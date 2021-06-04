unit WorldUnit;

interface

uses Classes,SysUtils,Math,Global,ab_Obj3D,WorldLine,EC_Mem,EC_Buf,aMyFunction,EC_Str,DebugMsg,ABPoint,GR_DirectX3D8;

type
PabWorldUnitBB = ^TabWorldUnitBB;
TabWorldUnitBB = record
	FOrbit:xyzV;
    FOrbitAngle:xyzV;
    FPos:TDxyz;
end;

TabWorldUnit = class(TObject)
	public
	    FPrev:TabWorldUnit;
    	FNext:TabWorldUnit;

        FFileName:WideString;

        FSel:boolean;
        FGraphSel:TabObj3D;
        FGraphSelBB:TabObj3D;

        FNo:integer;

        FType:integer;
        FTimeOffset:integer;
        FTimeLength:integer;
        FKeyGroup:integer;

        FCenter:D3DVECTOR;
        FDraw:boolean;

        FBBState:integer; // 0=-1 0=rebuild 1=yes
        FBB:array[0..3] of TabWorldUnitBB;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure UpdateGraph;

        function PointCnt:integer;
        function PointInTriangle(apo:TPointAB):boolean;
        function CalcCenter:TDxyz;
        function GetMaxPointFrom(v:TDxyz):TPointAB;
        function GetPoint(id:WideString):TPointAB;

        procedure SetKeyGroup(zn:integer);
        property KeyGroup:integer read FKeyGroup write SetKeyGroup;

        procedure BBBuild;
        procedure BBCalcPos;

        procedure Load(filename:WideString; orbit,orbitangle:single);
        procedure PlaceWorld(orbit,orbitangle:single);

        procedure SaveWorld(bd:TBufEC);
        procedure LoadWorld(bd:TBufEC);
end;

TabWorldPort = class(TObject)
	public
		FUnit:TabWorldUnit;
    	FId:WideString;
	    FType:WideString;

    	FCenter:TDxyz;
        FPointCnt:integer;
end;

procedure WorldUnit_Clear;
function WorldUnit_Add:TabWorldUnit;
procedure WorldUnit_Delete(el:TabWorldUnit);
function WorldUnit_Sel:TabWorldUnit;
procedure WorldUnit_SelUpdateGraph;
function WorldUnit_Cnt:integer;
function WorldUnit_ByNo(no:integer):TabWorldUnit;
procedure WorldUnit_Numerate;
procedure WorldUnit_CalcCenter;
procedure WorldUnit_CalcDraw;
procedure WorldUnit_SaveWorld(bd:TBufEC);
procedure WorldUnit_LoadWorld(bd:TBufEC);

procedure WorldPort_Clear(li:TList);
function WorldPort_Find(li:TList; own:TabWorldUnit; id:WideString):TabWorldPort; overload;
function WorldPort_Find(li:TList; pos:TDxyz; wtype:WideString; var md:single):TabWorldPort; overload;
procedure WorldPort_Build(li:TList);
procedure WorldPort_Split(li:TList; lides:TList; own:TabWorldUnit);
procedure WorldPort_Connect(wunit:TabWorldUnit);

function WorldPort2_Find(li:TList; pos:TDxyz; var md:single):TabWorldPort; overload;
function WorldPort2_FindPoint(own:TabWorldUnit; id:WideString; from:TPointAB=nil):TPointAB; overload;
function WorldPort2_FindPoint(own:TabWorldUnit; id:WideString; np:TDxyz; link:WideString):TPointAB; overload;
procedure WorldPort2_Build(li:TList);
procedure WorldPort2_Connect(wunit:TabWorldUnit);

var
	WorldUnit_First:TabWorldUnit=nil;
	WorldUnit_Last:TabWorldUnit=nil;

implementation

uses EC_BlockPar,ABTriangle,ABLine,ABKey,Form_Main,VOper;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TabWorldUnit.Create;
begin
	inherited Create;
end;

destructor TabWorldUnit.Destroy;
begin
	Clear;
	inherited Destroy;
end;

procedure TabWorldUnit.Clear;
var
	i:integer;
	apo,apo2:TPointAB;
    atr,atr2:TTriangleAB;
    atl,atl2:TLineAB;
begin
	atl:=Line_First;
    while atl<>nil do begin
    	atl2:=atl;
	    atl:=atl.FNext;
        if atl2.FOwner=self then Line_Delete(atl2);
    end;

	atr:=Triangle_First;
    while atr<>nil do begin
    	atr2:=atr;
	    atr:=atr.FNext;
        if atr2.FOwner=self then Triangle_Delete(atr2);
    end;

	apo:=Point_First;
    while apo<>nil do begin
	    apo2:=apo;
    	apo:=apo.FNext;
    	i:=apo2.FOwner.IndexOf(self);
        if i>=0 then begin
        	if i=0 then begin
            	apo2.FPortId:=apo2.FCopyPortId;
            	apo2.FPortType:=apo2.FCopyPortType;
            	apo2.FPortLink:=apo2.FCopyPortLink;
            end;
        	apo2.FOwner.Delete(i);
            if apo2.FOwner.Count<1 then Point_Delete(apo2);
        end;
    end;

    KeyGroupList_Del(self);

	if FGraphSel<>nil then begin
    	ab_Obj3D_Delete(FGraphSel);
    	FGraphSel:=nil;
	end;
    if FGraphSelBB<>nil then begin
    	ab_Obj3D_Delete(FGraphSelBB);
    	FGraphSelBB:=nil;
    end;
end;

procedure TabWorldUnit.UpdateGraph;
var
	i:integer;
    li:TList;
    apo:TPointAB;
    pmin,pmax:TDxy;
    v:TDxyz;
begin
	if not FSel then begin
    	if FGraphSel<>nil then begin
        	ab_Obj3D_Delete(FGraphSel);
            FGraphSel:=nil;
        end;
	    if FGraphSelBB<>nil then begin
    		ab_Obj3D_Delete(FGraphSelBB);
    		FGraphSelBB:=nil;
	    end;
    end else begin
    	if FGraphSel=nil then begin
        	FGraphSel:=ab_Obj3D_Add;
            FGraphSel.FDrawFromObjLoop:=true;
            FGraphSel.VerCount:=4;
			FGraphSel.UnitAddLine(0,1);
			FGraphSel.UnitAddLine(1,2);
			FGraphSel.UnitAddLine(2,3);
			FGraphSel.UnitAddLine(3,0);
        end;
    	if (FGraphSelBB=nil) and (FBBState=1) then begin
        	FGraphSelBB:=ab_Obj3D_Add;
            FGraphSelBB.FDrawFromObjLoop:=true;
            FGraphSelBB.VerCount:=4;
			FGraphSelBB.UnitAddLine(0,1);
			FGraphSelBB.UnitAddLine(1,2);
			FGraphSelBB.UnitAddLine(2,3);
			FGraphSelBB.UnitAddLine(3,0);
        end;

    	pmin:=Dxy(1e20,1e20);
    	pmax:=Dxy(-1e20,-1e20);

	    li:=Point_Find(self);
        for i:=0 to li.Count-1 do begin
        	apo:=li.Items[i];
            pmin.x:=min(apo.FPosShow.x-3,pmin.x);
            pmin.y:=min(apo.FPosShow.y-3,pmin.y);
            pmax.x:=max(apo.FPosShow.x+3,pmax.x);
            pmax.y:=max(apo.FPosShow.y+3,pmax.y);
        end;
        li.Free;

		FGraphSel.VerOpen;
	    FGraphSel.Ver(0)^:=abVer3D(pmin.x+GSmeX,pmin.y+GSmeY,0,0,0,$ffffffff);
	    FGraphSel.Ver(1)^:=abVer3D(pmax.x+GSmeX,pmin.y+GSmeY,0,0,0,$ffffffff);
	    FGraphSel.Ver(2)^:=abVer3D(pmax.x+GSmeX,pmax.y+GSmeY,0,0,0,$ffffffff);
	    FGraphSel.Ver(3)^:=abVer3D(pmin.x+GSmeX,pmax.y+GSmeY,0,0,0,$ffffffff);
        FGraphSel.VerClose;

        if FGraphSelBB<>nil then begin
        	FGraphSelBB.VerOpen;

            v:=D3D_TransformVector(ab_Camera_MatEnd,FBB[0].FPos);
		    FGraphSelBB.Ver(0)^:=abVer3D(v.x+GSmeX,v.y+GSmeY,0,0,0,$ffff0000);

            v:=D3D_TransformVector(ab_Camera_MatEnd,FBB[1].FPos);
		    FGraphSelBB.Ver(1)^:=abVer3D(v.x+GSmeX,v.y+GSmeY,0,0,0,$ffffff00);

            v:=D3D_TransformVector(ab_Camera_MatEnd,FBB[2].FPos);
		    FGraphSelBB.Ver(2)^:=abVer3D(v.x+GSmeX,v.y+GSmeY,0,0,0,$ffff0000);

            v:=D3D_TransformVector(ab_Camera_MatEnd,FBB[3].FPos);
		    FGraphSelBB.Ver(3)^:=abVer3D(v.x+GSmeX,v.y+GSmeY,0,0,0,$ffffff00);

            FGraphSelBB.VerClose;
        end;
    end;
end;

function TabWorldUnit.PointCnt:integer;
var
	apo:TPointAB;
begin
	Result:=0;

	apo:=Point_First;
    while apo<>nil do begin
    	if apo.FOwner.IndexOf(self)>=0 then begin
        	inc(Result);
        end;
    	apo:=apo.FNext;
    end;
end;

function TabWorldUnit.PointInTriangle(apo:TPointAB):boolean;
var
	atr:TTriangleAB;
begin
	atr:=Triangle_First;
    while atr<>nil do begin
    	if atr.FOwner=self then begin
        	if (atr.FV[0].FVer=apo) or (atr.FV[1].FVer=apo) or (atr.FV[2].FVer=apo) then begin Result:=true; Exit; end;
        end;
    	atr:=atr.FNext;
    end;
    Result:=false;
end;

function TabWorldUnit.CalcCenter:TDxyz;
var
	apo:TPointAB;
    center:TDxyz;
    cnt:integer;
begin
	center:=Dxyz(0,0,0);
    cnt:=0;

	apo:=Point_First;
    while apo<>nil do begin
    	if apo.FOwner.IndexOf(self)>=0 then begin
        	center.x:=center.x+apo.FPos.x;
        	center.y:=center.y+apo.FPos.y;
        	center.z:=center.z+apo.FPos.z;
            inc(cnt);
        end;
    	apo:=apo.FNext;
    end;

	center.x:=center.x/cnt;
    center.y:=center.y/cnt;
    center.z:=center.z/cnt;

    FCenter:=center;

    Result:=center;
end;

function TabWorldUnit.GetMaxPointFrom(v:TDxyz):TPointAB;
var
	apo:TPointAB;
	dmin,dcur:single;
begin
	dmin:=1e20;
    Result:=nil;

	apo:=Point_First;
    while apo<>nil do begin
    	if apo.FOwner.IndexOf(self)>=0 then begin
        	dcur:=sqr(apo.FPos.x-v.x)+sqr(apo.FPos.y-v.y)+sqr(apo.FPos.z-v.z);
            if dcur<dmin then begin
            	dmin:=dcur;
                Result:=apo;
            end;
        end;
    	apo:=apo.FNext;
    end;
end;

function TabWorldUnit.GetPoint(id:WideString):TPointAB;
var
	apo:TPointAB;
begin
	apo:=Point_First;
    while apo<>nil do begin
    	if apo.FOwner.IndexOf(self)>=0 then begin
        	if apo.FId=id then begin Result:=apo; exit; end;
        end;
    	apo:=apo.FNext;
    end;
    Result:=nil;
end;

procedure TabWorldUnit.SetKeyGroup(zn:integer);
begin
	FKeyGroup:=zn;
    if FKeyGroup<0 then FKeyGroup:=0
    else if FKeyGroup>=KeyGroupList_Get(self).FList.Count then FKeyGroup:=KeyGroupList_Get(self).FList.Count-1;
    KeyGroupList_Get(self).FCur:=FKeyGroup;
end;

procedure TabWorldUnit.BBBuild;
type
	Tpp=record
    	p:TPointAB;
        Angle:xyzV;
        Radius:xyzV;
    end;
var
	i,cnt:integer;
    p_list:array of Tpp;
	apo:TPointAB;
    center:TDxyz;
    center_orb,center_orbangle:xyzV;
    t_angle,t_radius,c_angle,min_angle:xyzV;
    x,y,per,per_min:xyzV;
    vmin,vmax:TDxyz;
    vmin_m,vmax_m:TDxyz;
    a1,r1,a2,r2,a3,r3,a4,r4:xyzV;
begin
	cnt:=PointCnt;
    if cnt<1 then begin FBBState:=-1; exit; end;

    SetLength(p_list,cnt);

    cnt:=0;
	apo:=Point_First;
    while apo<>nil do begin
    	if apo.FOwner.IndexOf(self)>=0 then begin
        	if PointInTriangle(apo) then begin
            	p_List[cnt].p:=apo;
				inc(cnt);
            end;
        end;
    	apo:=apo.FNext;
    end;

    if cnt<1 then begin FBBState:=-1; p_list:=nil; Exit; end;

    center:=Dxyz(0,0,0);
    for i:=0 to cnt-1 do begin
    	center.x:=center.x+p_list[i].p.FPos.x;
    	center.y:=center.y+p_list[i].p.FPos.y;
    	center.z:=center.z+p_list[i].p.FPos.z;
    end;
    center.x:=center.x/cnt;
    center.y:=center.y/cnt;
    center.z:=center.z/cnt;
    ab_CalcAngle(center,center_orb,center_orbangle);

    for i:=0 to cnt-1 do begin
	    ab_CalcAngleAndDist(center_orb,center_orbangle,0,p_list[i].p.FOrbit,p_list[i].p.FOrbitAngle,ab_WorldRadius,t_angle,t_radius);
        if t_angle<0 then t_angle:=360+t_angle;
        p_list[i].Angle:=t_angle;
        p_list[i].Radius:=t_radius; 
    end;

    per_min:=1e20;
    min_angle:=0;
    c_angle:=0;
    while c_angle<=90 do begin
    	vmin:=Dxyz(1e20,1e20,0);
    	vmax:=Dxyz(-1e20,-1e20,0);
	    for i:=0 to cnt-1 do begin
	        t_angle:=Angle360ToRad(AngleCorrect360(p_list[i].Angle+c_angle));

            x:=sin(t_angle)*p_list[i].Radius;
            y:=-cos(t_angle)*p_list[i].Radius;

            if x<vmin.x then vmin.x:=x;
            if x>vmax.x then vmax.x:=x;
            if y<vmin.y then vmin.y:=y;
            if y>vmax.y then vmax.y:=y;
        end;

        per:=(vmax.x-vmin.x)*2+(vmax.y-vmin.y)*2;
        if per<per_min then begin
	        per_min:=per;
            vmin_m:=vmin;
            vmax_m:=vmax;
            min_angle:=c_angle;
        end;

    	c_angle:=c_angle+5;
    end;

    a1:=AngleCorrect360(AngleRadTo360(ArcTan2(vmin_m.x,-vmin_m.y))-min_angle);
    r1:=sqrt(sqr(vmin_m.x)+sqr(vmin_m.y));
    a2:=AngleCorrect360(AngleRadTo360(ArcTan2(vmax_m.x,-vmin_m.y))-min_angle);
    r2:=sqrt(sqr(vmax_m.x)+sqr(vmin_m.y));
    a3:=AngleCorrect360(AngleRadTo360(ArcTan2(vmax_m.x,-vmax_m.y))-min_angle);
    r3:=sqrt(sqr(vmax_m.x)+sqr(vmax_m.y));
    a4:=AngleCorrect360(AngleRadTo360(ArcTan2(vmin_m.x,-vmax_m.y))-min_angle);
    r4:=sqrt(sqr(vmin_m.x)+sqr(vmax_m.y));

	FBB[0].FOrbit:=center_orb; FBB[0].FOrbitAngle:=center_orbangle;
	FBB[1].FOrbit:=center_orb; FBB[1].FOrbitAngle:=center_orbangle;
	FBB[2].FOrbit:=center_orb; FBB[2].FOrbitAngle:=center_orbangle;
	FBB[3].FOrbit:=center_orb; FBB[3].FOrbitAngle:=center_orbangle;

    ab_CalcNewPos(FBB[0].FOrbit,FBB[0].FOrbitAngle,a1,ab_WorldRadius,r1);
    ab_CalcNewPos(FBB[1].FOrbit,FBB[1].FOrbitAngle,a2,ab_WorldRadius,r2);
    ab_CalcNewPos(FBB[2].FOrbit,FBB[2].FOrbitAngle,a3,ab_WorldRadius,r3);
    ab_CalcNewPos(FBB[3].FOrbit,FBB[3].FOrbitAngle,a4,ab_WorldRadius,r4);

    FBBState:=1;

    p_list:=nil;

    BBCalcPos;
end;

procedure TabWorldUnit.BBCalcPos;
begin
	if FBBState<>1 then Exit;
    FBB[0].FPos:=ab_CalcPos(Angle360ToRad(FBB[0].FOrbit),Angle360ToRad(FBB[0].FOrbitAngle),ab_WorldRadius);
    FBB[1].FPos:=ab_CalcPos(Angle360ToRad(FBB[1].FOrbit),Angle360ToRad(FBB[1].FOrbitAngle),ab_WorldRadius);
    FBB[2].FPos:=ab_CalcPos(Angle360ToRad(FBB[2].FOrbit),Angle360ToRad(FBB[2].FOrbitAngle),ab_WorldRadius);
    FBB[3].FPos:=ab_CalcPos(Angle360ToRad(FBB[3].FOrbit),Angle360ToRad(FBB[3].FOrbitAngle),ab_WorldRadius);
end;

procedure TabWorldUnit.Load(filename:WideString; orbit,orbitangle:single);
var
	bp:TBlockParEC;
    gl:TKeyGroupList;
begin
	FFileName:=filename;

    bp:=TBlockParEC.Create;
    bp.LoadFromFile(PChar(AnsiString(GUnitPath+'\'+FFileName)));

    try
	    gl:=KeyGroupList_Add(self);
        gl.Load(bp);
		Point_Load(bp,self,gl);
    	Triangle_Load(bp,self,gl);
		Line_Load(bp,self,gl);
        Point_ClearNo;

	    PlaceWorld(orbit,orbitangle);
    finally
	    bp.Free;
    end;
end;

procedure TabWorldUnit.PlaceWorld(orbit,orbitangle:single);
var
    apo:TPointAB;
    lp:TList;
    center,v:TDxyz;
//    orbit,orbitangle:single;
    orbit2,orbitangle2,angle2:single;
    i:integer;
begin
	lp:=TList.Create;

    center:=Dxyz(0,0,0);

	apo:=Point_First;
    while apo<>nil do begin
    	if apo.FOwner.IndexOf(self)>=0 then begin
        	lp.Add(apo);
            center.x:=center.x+apo.FPos.x;
            center.y:=center.y+apo.FPos.y;
            center.z:=center.z+apo.FPos.z;
        end;
        apo:=apo.FNext;
    end;

    center.x:=center.x/lp.Count;
    center.y:=center.y/lp.Count;
    center.z:=0;//center.z/lp.Count;

//	if not FormMain.MouseToAngle(Point(GSmeX,GSmeY),orbit,orbitangle) then EError('TabWorldUnit.PlaceWorld');

    for i:=0 to lp.Count-1 do begin
    	apo:=lp.Items[i];
		v.x:=apo.FPos.x-center.x; v.y:=apo.FPos.y-center.y; v.z:=apo.FPos.z-center.z;

        orbit2:=orbit;
        orbitangle2:=orbitangle;
        angle2:=AngleRadTo360(ArcTan2(v.x,-v.y));
        apo.FRadius:=ab_WorldRadius-v.z;
        ab_CalcNewPos(orbit2,orbitangle2,angle2,apo.FRadius,sqrt(sqr(v.x)+sqr(v.y)));

        apo.FOrbit:=orbit2;
        apo.FOrbitAngle:=orbitangle2;

        apo.CalcPos;
    end;

    lp.Free;
end;

procedure TabWorldUnit.SaveWorld(bd:TBufEC);
begin
	bd.Add(FFileName);
    bd.AddInteger(FType);
    bd.AddInteger(FTimeOffset);
    bd.AddInteger(FKeyGroup);
    bd.AddInteger(FTimeLength);
end;

procedure TabWorldUnit.LoadWorld(bd:TBufEC);
begin
	FFileName:=bd.GetWideStr;
    FType:=bd.GetInteger;
    FTimeOffset:=bd.GetInteger;
    FKeyGroup:=bd.GetInteger;
    if GLoadVersion>=3 then FTimeLength:=bd.GetInteger;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure WorldUnit_Clear;
begin
	while WorldUnit_First<>nil do WorldUnit_Delete(WorldUnit_Last);
end;

function WorldUnit_Add:TabWorldUnit;
var
    el:TabWorldUnit;
begin
    el:=TabWorldUnit.Create;

    if WorldUnit_Last<>nil then WorldUnit_Last.FNext:=el;
	el.FPrev:=WorldUnit_Last;
	el.FNext:=nil;
	WorldUnit_Last:=el;
	if WorldUnit_First=nil then WorldUnit_First:=el;

    Result:=el;
end;

procedure WorldUnit_Delete(el:TabWorldUnit);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if WorldUnit_Last=el then WorldUnit_Last:=el.FPrev;
	if WorldUnit_First=el then WorldUnit_First:=el.FNext;

    el.Free;
end;

function WorldUnit_Sel:TabWorldUnit;
var
    el:TabWorldUnit;
begin
	el:=WorldUnit_First;
    while el<>nil do begin
    	if el.FSel then begin Result:=el; Exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

procedure WorldUnit_SelUpdateGraph;
var
	el:TabWorldUnit;
begin
	el:=WorldUnit_Sel;
    if el<>nil then el.UpdateGraph;
end;

function WorldUnit_Cnt:integer;
var
    el:TabWorldUnit;
begin
	Result:=0;
	el:=WorldUnit_First;
    while el<>nil do begin
    	inc(Result);
    	el:=el.FNext;
    end;
end;

function WorldUnit_ByNo(no:integer):TabWorldUnit;
var
    el:TabWorldUnit;
begin
	el:=WorldUnit_First;
    while el<>nil do begin
    	if el.FNo=no then begin Result:=el; Exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

procedure WorldUnit_Numerate;
var
    el:TabWorldUnit;
    i:integer;
begin
	i:=0;
	el:=WorldUnit_First;
    while el<>nil do begin
    	el.FNo:=i;
        inc(i);
    	el:=el.FNext;
    end;
end;

procedure WorldUnit_CalcCenter;
var
    el:TabWorldUnit;
begin
	el:=WorldUnit_First;
    while el<>nil do begin
    	el.CalcCenter;
    	el:=el.FNext;
    end;
end;

procedure WorldUnit_CalcDraw;
var
    el:TabWorldUnit;
begin
	el:=WorldUnit_First;
    while el<>nil do begin
	    el.FDraw:=ab_InTop(D3D_TransformVector(ab_Camera_MatEnd,el.FCenter).z);
    	el:=el.FNext;
    end;
end;

procedure WorldUnit_SaveWorld(bd:TBufEC);
var
	el:TabWorldUnit;
    i:integer;
begin
	bd.AddInteger(WorldUnit_Cnt);

    i:=0;
	el:=WorldUnit_First;
    while el<>nil do begin
	    el.FNo:=i;
        el.SaveWorld(bd);

        inc(i);
    	el:=el.FNext;
    end;
end;

procedure WorldUnit_LoadWorld(bd:TBufEC);
var
	i,cnt:integer;
    el:TabWorldUnit;
begin
	WorldUnit_Clear;

    cnt:=bd.GetInteger;
    for i:=0 to cnt-1 do begin
    	el:=WorldUnit_Add;
        el.FNo:=i;
        el.LoadWorld(bd);
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure WorldPort_Clear(li:TList);
var
	wp:TabWorldPort;
    i:integer;
begin
	for i:=0 to li.Count-1 do begin
    	wp:=li.Items[i];
        wp.Free;
    end;
    li.Clear;
end;

function WorldPort_Find(li:TList; own:TabWorldUnit; id:WideString):TabWorldPort;
var
	wp:TabWorldPort;
    i:integer;
begin
	for i:=0 to li.Count-1 do begin
		wp:=li.Items[i];

        if (wp.FUnit=own) and (wp.FId=id) then begin
        	Result:=wp;
            Exit;
        end;
    end;
    Result:=nil;
end;

function WorldPort_Find(li:TList; pos:TDxyz; wtype:WideString; var md:single):TabWorldPort;
var
	i,u:integer;
	wtypecnt:integer;
	wp:TabWorldPort;
    td:single;
begin
	md:=1e20;
    Result:=nil;
	wtypecnt:=GetCountParEC(wtype,',');

    for i:=0 to li.Count-1 do begin
    	wp:=li.Items[i];

        td:=sqr(wp.FCenter.x-pos.x)+sqr(wp.FCenter.y-pos.y)+sqr(wp.FCenter.z-pos.z);
        if td>=md then continue;

        u:=0;
        while u<wtypecnt do begin
        	if wp.FId=TrimEx(GetStrParEC(wtype,u,',')) then break;
        	inc(u);
        end;

        if u<wtypecnt then begin
        	md:=td;
            Result:=wp;
        end;
    end;
end;

procedure WorldPort_Build(li:TList);
var
	apo:TPointAB;
    own:TabWorldUnit;
	wp:TabWorldPort;
    i:integer;
begin
	WorldPort_Clear(li);

	apo:=Point_First;
    while apo<>nil do begin
    	if (apo.FOwner.Count<>1) or
           (apo.FPortId='') or
           (apo.FPortType='') or
           (apo.FPortLink='') then
        begin apo:=apo.FNext; continue; end;

        own:=apo.FOwner.Items[0];
        wp:=WorldPort_Find(li,own,apo.FPortId);
        if wp=nil then begin
        	wp:=TabWorldPort.Create;
            wp.FUnit:=own;
            wp.FId:=apo.FPortId;
            wp.FType:=apo.FPortType;
            wp.FPointCnt:=1;
            wp.FCenter:=apo.FPos;
            li.Add(wp);
        end else begin
        	if Length(wp.FType)<Length(apo.FPortType) then begin
            	wp.FType:=apo.FPortType;
            end;
            inc(wp.FPointCnt);
            wp.FCenter.x:=wp.FCenter.x+apo.FPos.x;
            wp.FCenter.y:=wp.FCenter.y+apo.FPos.y;
            wp.FCenter.z:=wp.FCenter.z+apo.FPos.z;
        end;

    	apo:=apo.FNext;
    end;

    for i:=0 to li.Count-1 do begin
    	wp:=li.Items[i];
        wp.FCenter.x:=wp.FCenter.x/wp.FPointCnt;
        wp.FCenter.y:=wp.FCenter.y/wp.FPointCnt;
        wp.FCenter.z:=wp.FCenter.z/wp.FPointCnt;
    end;
end;

procedure WorldPort_Split(li:TList; lides:TList; own:TabWorldUnit);
var
	i:integer;
	wp:TabWorldPort;
begin
	i:=0;
    while i<li.Count do begin
    	wp:=li.Items[i];
        if wp.FUnit=own then begin
        	lides.Add(wp);
            li.Delete(i);
        end else inc(i);
    end;
end;

procedure WorldPort_Connect(wunit:TabWorldUnit);
var
	li,licur:TList;
    wpcur,wpcur2,wpdes,wpdes2:TabWorldPort;
    md,td:single;
    i:integer;
    apo1,apo2,apo1t:TPointAB;
    center,l1,l2:TDxyz;
begin
	li:=TList.Create;
    licur:=TList.Create;

    while True do begin
	    WorldPort_Build(li);
        if li.Count<2 then break;
		WorldPort_Split(li,licur,wunit);
        if li.Count<1 then break;

        md:=1e20;
        wpcur:=nil;
        wpdes:=nil;

        center:=wunit.CalcCenter;

        for i:=0 to licur.Count-1 do begin
        	wpcur2:=licur.Items[i];
	        wpdes2:=WorldPort_Find(li,wpcur2.FCenter,wpcur2.FType,td);
            if (td<sqr(100)) and (wpdes2<>nil) and (td<md) then begin
            	l1:=Dxyz(wpcur2.FCenter.x-center.x,wpcur2.FCenter.y-center.y,wpcur2.FCenter.z-center.z);
                l2:=Dxyz(wpdes2.FCenter.x-center.x,wpdes2.FCenter.y-center.y,wpdes2.FCenter.z-center.z);
                if D3D_DotProduct(l1,l2)>=0 then begin
	            	md:=td;
    	        	wpcur:=wpcur2;
        	        wpdes:=wpdes2;
                end;
            end;
        end;
        if (wpcur=nil) or (wpdes=nil) then break;

        apo1t:=Point_First;
        while apo1t<>nil do begin
	        apo1:=apo1t;
        	apo1t:=apo1t.FNext;

            if apo1.FOwner.Count<>1 then continue;
            if apo1.FOwner.IndexOf(wunit)<0 then continue;
            if apo1.FPortId<>wpcur.FId then continue;

		    apo2:=Point_First;
        	while apo2<>nil do begin
            	if (apo2.FOwner.Count=1) and
                   (apo2.FOwner.IndexOf(wpdes.FUnit)>=0) and
                   (apo2.FPortId=wpdes.FId) and
                   (apo1.FPortLink=apo2.FPortLink) then
                begin
                	break;
                end;
            	apo2:=apo2.FNext;
            end;

            if apo2<>nil then begin
	            Point_Union(apo2,apo1);
            end;

        end;

        break;
    end;

    li.Free;
    licur.Free;

{    apo1:=Point_First;
	while apo1<>nil do begin
		DM('PointOwner',Format('Owners=%d Id=%s Type=%s Link=%s Copy(Id=%s Type=%s Link=%s)',[apo1.FOwner.Count,apo1.FPortId,apo1.FPortType,apo1.FPortLink,apo1.FCopyPortId,apo1.FCopyPortType,apo1.FCopyPortLink]));
    	apo1:=apo1.FNext;
    end;}
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function WorldPort2_Find(li:TList; pos:TDxyz; var md:single):TabWorldPort;
var
	i:integer;
	wp:TabWorldPort;
    td:single;
begin
	md:=1e20;
    Result:=nil;

    for i:=0 to li.Count-1 do begin
    	wp:=li.Items[i];

        td:=sqr(wp.FCenter.x-pos.x)+sqr(wp.FCenter.y-pos.y)+sqr(wp.FCenter.z-pos.z);
        if td>=md then continue;

        md:=td;
        Result:=wp;
    end;
end;

function WorldPort2_FindPoint(own:TabWorldUnit; id:WideString; from:TPointAB):TPointAB;
var
	apo:TPointAB;
begin
	if from=nil then apo:=Point_First
    else apo:=from.FNext;

    while apo<>nil do begin
    	if apo.FOwner.IndexOf(own)>=0 then begin
	        if FindSubstring(apo.FPortId,id)>=0 then begin
            	Result:=apo;
                Exit;
            end;
        end;
    	apo:=apo.FNext;
    end;
    Result:=nil;
end;

function WorldPort2_FindPoint(own:TabWorldUnit; id:WideString; np:TDxyz; link:WideString):TPointAB; overload;
var
	apo:TPointAB;
    md,td:single;
begin
	md:=1e20;

    Result:=nil;

	apo:=Point_First;
    while apo<>nil do begin
		td:=sqr(np.x-apo.FPos.x)+sqr(np.y-apo.FPos.y)+sqr(np.z-apo.FPos.z);
        if td<md then begin
	    	if apo.FOwner.IndexOf(own)>=0 then begin
		        if FindSubstring(apo.FPortId,id)>=0 then begin
		        	if apo.FPortLink=link then begin
        	        	md:=td;
            	        Result:=apo;
                    end;
        	    end;
	        end;
        end;
    	apo:=apo.FNext;
    end;
end;

procedure WorldPort2_Build(li:TList);
var
	apo:TPointAB;
    own:TabWorldUnit;
	wp:TabWorldPort;
    i,cnt:integer;
    tstr:WideString;
begin
	WorldPort_Clear(li);

	apo:=Point_First;
    while apo<>nil do begin
    	if {(apo.FOwner.Count<>1) or}
           (apo.FPortId='') or
           (apo.FPortLink='') then
        begin apo:=apo.FNext; continue; end;

        own:=apo.FOwner.Items[0];
        cnt:=GetCountParEC(apo.FPortId,',');
        for i:=0 to cnt-1 do begin
        	tstr:=TrimEx(GetStrParEC(apo.FPortId,i,','));

	        wp:=WorldPort_Find(li,own,tstr{apo.FPortId});
    	    if wp=nil then begin
        		wp:=TabWorldPort.Create;
    	        wp.FUnit:=own;
	            wp.FId:=tstr;
        	    wp.FPointCnt:=1;
    	        wp.FCenter:=apo.FPos;
	            li.Add(wp);
            end else begin
            	inc(wp.FPointCnt);
        	    wp.FCenter.x:=wp.FCenter.x+apo.FPos.x;
    	        wp.FCenter.y:=wp.FCenter.y+apo.FPos.y;
	            wp.FCenter.z:=wp.FCenter.z+apo.FPos.z;
            end;
        end;

    	apo:=apo.FNext;
    end;

    for i:=0 to li.Count-1 do begin
    	wp:=li.Items[i];
        wp.FCenter.x:=wp.FCenter.x/wp.FPointCnt;
        wp.FCenter.y:=wp.FCenter.y/wp.FPointCnt;
        wp.FCenter.z:=wp.FCenter.z/wp.FPointCnt;
    end;
end;

procedure WorldPort2_Connect(wunit:TabWorldUnit);
var
	li,licur:TList;
    wpcur,wpcur2,wpdes,wpdes2:TabWorldPort;
    md,td:single;
    i:integer;
    apo1,apo2,apo1t:TPointAB;
    center,l1,l2:TDxyz;
begin
	li:=TList.Create;
    licur:=TList.Create;

    while True do begin
	    WorldPort2_Build(li);
        if li.Count<2 then break;
		WorldPort_Split(li,licur,wunit);
        if li.Count<1 then break;
        if licur.Count<1 then break;

        md:=1e20;
        wpcur:=nil;
        wpdes:=nil;

        center:=wunit.CalcCenter;

        for i:=0 to licur.Count-1 do begin
        	wpcur2:=licur.Items[i];
	        wpdes2:=WorldPort2_Find(li,wpcur2.FCenter,td);
//DM('Find port',Format('Sou=%s Des=%s Dist=%.4f',[wpcur2.FId,wpdes2.FId,sqrt(td)]));
            if (td>0.001) and (td<sqr(100)) and (wpdes2<>nil) and (td<md) then begin
            	l1:=Dxyz(wpcur2.FCenter.x-center.x,wpcur2.FCenter.y-center.y,wpcur2.FCenter.z-center.z);
                l2:=Dxyz(wpdes2.FCenter.x-center.x,wpdes2.FCenter.y-center.y,wpdes2.FCenter.z-center.z);
                if D3D_DotProduct(l1,l2)>=0 then begin
	            	md:=td;
    	        	wpcur:=wpcur2;
        	        wpdes:=wpdes2;
                end;
            end;
        end;
        if (wpcur=nil) or (wpdes=nil) then break;


        apo1t:=WorldPort2_FindPoint(wunit,wpcur.FId);
        while apo1t<>nil do begin
	        apo1:=apo1t;
	        apo1t:=WorldPort2_FindPoint(wunit,wpcur.FId,apo1t);

            apo2:=WorldPort2_FindPoint(wpdes.FUnit,wpdes.FId,apo1.FPos,apo1.FPortLink);
            if apo2<>nil then begin
	            Point_Connect(apo2,apo1);
            end;
        end;

{        apo1t:=Point_First;
        while apo1t<>nil do begin
	        apo1:=apo1t;
        	apo1t:=apo1t.FNext;

            if apo1.FOwner.Count<>1 then continue;
            if apo1.FOwner.IndexOf(wunit)<0 then continue;
            if apo1.FPortId<>wpcur.FId then continue;

		    apo2:=Point_First;
        	while apo2<>nil do begin
            	if (apo2.FOwner.Count=1) and
                   (apo2.FOwner.IndexOf(wpdes.FUnit)>=0) and
                   (apo2.FPortId=wpdes.FId) and
                   (apo1.FPortLink=apo2.FPortLink) then
                begin
                	break;
                end;
            	apo2:=apo2.FNext;
            end;

            if apo2<>nil then begin
	            Point_Union(apo2,apo1);
            end;

        end;}

        break;
    end;

    li.Free;
    licur.Free;
end;

end.

