unit ABPoint;

interface

uses SysUtils,Classes,ab_Obj3D,GR_DirectX3D8,EC_BlockPar,EC_Buf,DebugMsg,ABKey;

type
TPointAB = class(TObject)
	public
	    FPrev:TPointAB;
        FNext:TPointAB;

        FParent:TPointAB; // only 1 level

        FId:WideString;

        FPortId:WideString;
        FPortType:WideString;
        FPortLink:WideString;

        FCopyPortId:WideString;
        FCopyPortType:WideString;
        FCopyPortLink:WideString;

        FOrbit:single;
        FOrbitAngle:single;
		FRadius:single;

    	FPos:D3DVECTOR;
        FPosShow:D3DVECTOR;
        FPosShowInTop:boolean;

        FGraph:TabObj3D;

        FSel:boolean;

        FNo:integer;

        FOwner:TList;

        FTemp:integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure CreateGraph;

        procedure CalcPos;
        procedure CalcPosShow;
        procedure Update;

        function BP:TPointAB;

        procedure SetOrbit(orbit,orbitangle:single);
        procedure CalcCenterOwner;

//        procedure SetPosC(x,y,z:single); overload;
        procedure SetPos(pos:D3DVECTOR); overload;
        property Pos:D3DVECTOR read FPos write SetPos;

        procedure SetSel(zn:boolean);
        property Sel:boolean read FSel write SetSel;

        procedure Save(bp:TBlockParEC);
        procedure Load(bp:TBlockParEC);

        procedure SaveWorld(bd:TBufEC);
        procedure LoadWorld(bd:TBufEC);

        procedure SaveEnd(bd:TBufEC);
end;

procedure Point_Clear;
function Point_Add:TPointAB;
procedure Point_Delete(el:TPointAB);
function Point_NerestShow(pos:D3DVECTOR; crdist:single=1e20):TPointAB;
function Point_Sel(from:TPointAB=nil):TPointAB;
procedure Point_Update;
procedure Point_ListBuild;
procedure Point_ListClear;
function Point_Cnt:integer;
function Point_CntUnion:integer;
function Point_ByNo(no:integer):TPointAB;
procedure Point_ClearNo;
function Point_Find(own:TObject):TList;
procedure Point_Union(des,sou:TPointAB);
procedure Point_Connect(des,sou:TPointAB);
procedure Point_Save(bp:TBlockParEC);
procedure Point_Load(bp:TBlockParEC; owner:TObject; gl:TKeyGroupList);
procedure Point_SaveWorld(bd:TBufEC);
procedure Point_LoadWorld(bd:TBufEC);
procedure Point_SaveEnd(bd:TBufEC);

var
	Point_First:TPointAB=nil;
	Point_Last:TPointAB=nil;
    Point_List:array of TPointAB;

implementation

uses Form_Main,VOper,EC_Str,Global,aMyFunction,ABTriangle,ABLine,WorldUnit;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TPointAB.Create;
begin
	inherited Create;
	FOwner:=TList.Create;

    CreateGraph;
end;

destructor TPointAB.Destroy;
var
	apo,apo2:TPointAB;
begin
	if FGraph<>nil then begin ab_Obj3D_Delete(FGraph); FGraph:=nil; end;

    if FParent=nil then begin
	    apo:=Point_First;
    	while apo<>nil do begin
        	if apo.FParent=self then begin
            	apo.FParent:=nil;

                apo2:=apo.FNext;
                while apo2<>nil do begin
                	if apo2.FParent=self then apo2.FParent:=apo;
                	apo2:=apo2.FNext;
                end;

            	break;
            end;
	    	apo:=apo.FNext;
    	end;
    end;

    FOwner.Free;
	inherited Destroy;
end;

procedure TPointAB.CreateGraph;
begin
	if FGraph<>nil then begin ab_Obj3D_Delete(FGraph); FGraph:=nil; end;

    FGraph:=ab_Obj3D_Add;
    FGraph.FZTest:=false;
    FGraph.FLoopDraw:=1;
    if not FSel then begin
	    FGraph.CreateSphere(3,3,D3DCOLOR_ARGB(255,0,0,255));
    end else begin
	    FGraph.CreateSphere(3,3,D3DCOLOR_ARGB(255,255,0,0));
    end;
    FGraph.SetPos(D3DV(FPos.x+GSmeX,FPos.y+GSmeY,0.0{FPos.z}));
end;

procedure TPointAB.CalcPos;
begin
	FPos:=ab_CalcPos(Angle360ToRad(FOrbit),Angle360ToRad(FOrbitAngle),FRadius);
end;

procedure TPointAB.CalcPosShow;
begin
	FPosShow:=D3D_TransformVector(ab_Camera_MatEnd,FPos);
//DM('Point',FloatToStrEC(FPosShow.z));
end;

procedure TPointAB.Update;
begin
	CalcPosShow;
	if FGraph<>nil then begin
	    FGraph.FDrawFromObjLoop:=ab_InTop(FPosShow.z);
        if not FormMain.MM_View_Point.Checked then FGraph.FDrawFromObjLoop:=false;
        if FParent<>nil then FGraph.FDrawFromObjLoop:=false;
    	FGraph.SetPos(D3DV(FPosShow.x+GSmeX,FPosShow.y+GSmeY,0{FPos.z}));
    end;
end;

function TPointAB.BP:TPointAB;
begin
	if FParent<>nil then Result:=FParent
    else Result:=self;
end;

procedure TPointAB.SetOrbit(orbit,orbitangle:single);
var
	apo:TPointAB;
begin
	if FParent<>nil then begin
    	FParent.SetOrbit(orbit,orbitangle);
    	Exit;
    end;
	FOrbit:=orbit;
    FOrbitAngle:=orbitangle;
	CalcPos;

    apo:=Point_First;
    while apo<>nil do begin
	    if apo.FParent=self then begin
        	apo.FOrbit:=orbit;
            apo.FOrbitAngle:=orbitangle;
            apo.FPos:=FPos;
        end;
    	apo:=apo.FNext;
    end;
end;

procedure TPointAB.CalcCenterOwner;
var
	apo:TPointAB;
begin
	if FParent<>nil then begin
    	FParent.CalcCenterOwner;
    	Exit;
    end;

    apo:=Point_First;
    while apo<>nil do begin
	    if apo.FParent=self then begin
        	TabWorldUnit(apo.FOwner).CalcCenter;
        end;
    	apo:=apo.FNext;
    end;
end;

(*procedure TPointAB.SetPosC(x,y,z:single);
begin
	if (FPos.x=x) and (FPos.y=y) and (FPos.z=z) then Exit;
	FPos:=D3DV(x,y,z);
	CalcPosShow;
	if FGraph<>nil then FGraph.SetPos(D3DV(FPosShow.x+GSmeX,FPosShow.y+GSmeY,0{FPos.z}));
end;*)

procedure TPointAB.SetPos(pos:D3DVECTOR);
begin
	if (FPos.x=pos.x) and (FPos.y=pos.y) and (FPos.z=pos.z) then Exit;
	FPos:=pos;
	CalcPosShow;
	if FGraph<>nil then FGraph.SetPos(D3DV(FPosShow.x+GSmeX,FPosShow.y+GSmeY,0{FPos.z}));
end;

procedure TPointAB.SetSel(zn:boolean);
begin
	if (FSel=zn) then Exit;
    if FParent<>nil then FSel:=false
    else FSel:=zn;
	if FGraph<>nil then begin
    	if not FSel then begin
	    	FGraph.SetColor(D3DCOLOR_ARGB(255,0,0,255));
        end else begin
        	FGraph.SetColor(D3DCOLOR_ARGB(255,255,255,255));
        end;
    end;
end;

procedure TPointAB.Save(bp:TBlockParEC);
begin
//	bp.Par_Add('Pos',FloatToStrEC(FPos.x)+','+FloatToStrEC(FPos.y)+','+FloatToStrEC(FPos.z));
	bp.Par_Add('Pos',Format('%.4f,%.4f,%.4f',[FPos.x,FPos.y,FPos.z]));
end;

procedure TPointAB.Load(bp:TBlockParEC);
var
	tstr:WideString;
begin
	FId:=bp.Par['Id'];

	tstr:=bp.Par['Pos'];
    FPos.x:=StrToFloatEC(GetStrParEC(tstr,0,','));
    FPos.y:=StrToFloatEC(GetStrParEC(tstr,1,','));
    FPos.z:=StrToFloatEC(GetStrParEC(tstr,2,','));

    if bp.Par_Count('PortId')>0 then FPortId:=bp.Par['PortId'] else FPortId:='';
    if bp.Par_Count('PortType')>0 then FPortType:=bp.Par['PortType'] else FPortType:='';
    if bp.Par_Count('PortLink')>0 then FPortLink:=bp.Par['PortLink'] else FPortLink:='';
end;

procedure TPointAB.SaveWorld(bd:TBufEC);
var
	i:integer;
begin
	bd.Add(FId);

	bd.AddSingle(FOrbit);
	bd.AddSingle(FOrbitAngle);
	bd.AddSingle(FRadius);

    if FParent=nil then bd.AddInteger(0)
    else bd.AddInteger(FParent.FNo);

    bd.Add(FPortId);
    bd.Add(FPortType);
    bd.Add(FPortLink);

	bd.Add(FCopyPortId);
	bd.Add(FCopyPortType);
	bd.Add(FCopyPortLink);

    bd.AddInteger(FOwner.Count);
    for i:=0 to FOwner.Count-1 do begin
    	bd.AddInteger(TabWorldUnit(FOwner.Items[i]).FNo);
    end;
end;

procedure TPointAB.LoadWorld(bd:TBufEC);
var
	i,cnt:integer;
begin
	FId:=bd.GetWideStr;

	FOrbit:=bd.GetSingle;
	FOrbitAngle:=bd.GetSingle;
	FRadius:=bd.GetSingle;

    FParent:=TPointAB(bd.GetInteger);

    FPortId:=bd.GetWideStr;
    FPortType:=bd.GetWideStr;
    FPortLink:=bd.GetWideStr;

	FCopyPortId:=bd.GetWideStr;
	FCopyPortType:=bd.GetWideStr;
	FCopyPortLink:=bd.GetWideStr;

    cnt:=bd.GetInteger;
    for i:=0 to cnt-1 do begin
    	FOwner.Add(WorldUnit_ByNo(bd.GetInteger));
    end;

    CalcPos;
end;

procedure TPointAB.SaveEnd(bd:TBufEC);
begin
	bd.AddSingle(FOrbit);
	bd.AddSingle(FOrbitAngle);
	bd.AddSingle(FRadius);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure Point_Clear;
begin
	while Point_First<>nil do Point_Delete(Point_Last);
end;

function Point_Add:TPointAB;
var
    el:TPointAB;
begin
    el:=TPointAB.Create;

    if Point_Last<>nil then Point_Last.FNext:=el;
	el.FPrev:=Point_Last;
	el.FNext:=nil;
	Point_Last:=el;
	if Point_First=nil then Point_First:=el;

    Result:=el;
end;

procedure Point_Delete(el:TPointAB);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if Point_Last=el then Point_Last:=el.FPrev;
	if Point_First=el then Point_First:=el.FNext;

    el.Free;
end;

function Point_NerestShow(pos:D3DVECTOR; crdist:single):TPointAB;
var
	el:TPointAB;
    md,td:single;
begin
	md:=1e20;
    Result:=nil;
    crdist:=crdist*crdist;

	el:=Point_First;
    while el<>nil do begin
		td:=sqr(el.FPosShow.x-pos.x)+sqr(el.FPosShow.y-pos.y);//+sqr(el.FPos.z-pos.z);
        if (td<crdist) and (td<md) then begin
        	Result:=el;
            md:=td;
        end;
    	el:=el.FNext;
    end;
end;

function Point_Sel(from:TPointAB):TPointAB;
var
	el:TPointAB;
begin
	if from=nil then el:=Point_First
    else el:=from.FNext;
    while el<>nil do begin
    	if el.Sel then begin Result:=el; Exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

procedure Point_Update;
var
	el:TPointAB;
begin
	el:=Point_First;
    while el<>nil do begin
    	el.Update;
    	el:=el.FNext;
    end;
end;

procedure Point_ListBuild;
var
	i,cnt:integer;
	el:TPointAB;
begin
	Point_ListClear;

	cnt:=Point_Cnt+1;
    SetLength(Point_List,cnt);
    Point_List[0]:=nil;

    i:=1;
	el:=Point_First;
    while el<>nil do begin
    	Point_List[i]:=el;
    	el:=el.FNext;
        inc(i);
    end;
end;

procedure Point_ListClear;
begin
	Point_List:=nil;
end;

function Point_Cnt:integer;
var
	el:TPointAB;
begin
	Result:=0;
	el:=Point_First;
    while el<>nil do begin
    	inc(Result);
    	el:=el.FNext;
    end;
end;

function Point_CntUnion:integer;
var
	el:TPointAB;
begin
	Result:=0;
	el:=Point_First;
    while el<>nil do begin
    	if el.FParent=nil then begin
	    	inc(Result);
        end;
    	el:=el.FNext;
    end;
end;

function Point_ByNo(no:integer):TPointAB;
var
	el:TPointAB;
begin
	el:=Point_First;
    while el<>nil do begin
    	if el.FNo=no then begin Result:=el; Exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

procedure Point_ClearNo;
var
	el:TPointAB;
begin
	el:=Point_First;
    while el<>nil do begin
    	el.FNo:=-1;
    	el:=el.FNext;
    end;
end;

function Point_Find(own:TObject):TList;
var
	el:TPointAB;
    li:TList;
begin
	li:=TList.Create;

	el:=Point_First;
    while el<>nil do begin
    	if el.FOwner.IndexOf(own)>=0 then li.Add(el);
    	el:=el.FNext;
    end;

    if li.Count<1 then begin li.Free; li:=nil; end;
    Result:=li;
end;

procedure Point_Union(des,sou:TPointAB);
var
	atr:TTriangleAB;
    ali:TLineAB;
    i:integer;
begin
//	if des.FOwner.Count<>1 then EError('Point_Union');
//	if sou.FOwner.Count<>1 then EError('Point_Union');

	des.FCopyPortId:=sou.FPortId;
	des.FCopyPortType:=sou.FPortType;
	des.FCopyPortLink:=sou.FPortLink;
    des.FOwner.Add(sou.FOwner.Items[0]);

    atr:=Triangle_First;
    while atr<>nil do begin
    	for i:=0 to High(atr.FV) do begin
	    	if atr.FV[i].FVer=sou then atr.FV[i].FVer:=des;
        end;
    	atr:=atr.FNext;
    end;

    ali:=Line_First;
    while ali<>nil do begin
    	if ali.FVerStart=sou then ali.FVerStart:=des;
    	if ali.FVerEnd=sou then ali.FVerEnd:=des;
    	ali:=ali.FNext;
    end;

    Point_Delete(sou);
end;

procedure Point_Connect(des,sou:TPointAB);
var
	apo:TPointAB;
    oldpar:TPointAB;
begin
	if des=sou then exit;
    if sou.FParent=des then Exit;
    if (des.FParent<>nil) and (sou.FParent=des.FParent) then Exit;

	oldpar:=sou.FParent;

	if des.FParent=nil then begin
    	sou.FParent:=des;
    end else begin
    	sou.FParent:=des.FParent;
    end;
    sou.FOrbit:=sou.FParent.FOrbit;
    sou.FOrbitAngle:=sou.FParent.FOrbitAngle;
    sou.FRadius:=sou.FParent.FRadius;
    sou.FPos:=sou.FParent.FPos;

    if oldpar=nil then begin
	    apo:=Point_First;
    	while apo<>nil do begin
    		if apo.FParent=sou then begin
            	apo.FParent:=sou.FParent;
			    apo.FOrbit:=apo.FParent.FOrbit;
			    apo.FOrbitAngle:=apo.FParent.FOrbitAngle;
			    apo.FRadius:=apo.FParent.FRadius;
			    apo.FPos:=apo.FParent.FPos;
            end;
	    	apo:=apo.FNext;
    	end;
    end else begin
	    oldpar.FParent:=sou.FParent;
		oldpar.FOrbit:=oldpar.FParent.FOrbit;
		oldpar.FOrbitAngle:=oldpar.FParent.FOrbitAngle;
		oldpar.FRadius:=oldpar.FParent.FRadius;
		oldpar.FPos:=oldpar.FParent.FPos;

	    apo:=Point_First;
    	while apo<>nil do begin
    		if apo.FParent=oldpar then begin
            	apo.FParent:=sou.FParent;
			    apo.FOrbit:=apo.FParent.FOrbit;
			    apo.FOrbitAngle:=apo.FParent.FOrbitAngle;
			    apo.FRadius:=apo.FParent.FRadius;
			    apo.FPos:=apo.FParent.FPos;
            end;
	    	apo:=apo.FNext;
    	end;
    end;
end;

procedure Point_Save(bp:TBlockParEC);
var
	el:TPointAB;
    tbp,tbp2:TBlockParEC;
    i:integer;
begin
	tbp:=bp.Block_Add('Point');

    i:=0;
	el:=Point_First;
    while el<>nil do begin
	    tbp2:=tbp.Block_Add(IntToStr(i));
        el.FNo:=i;
    	el.Save(tbp2);
        inc(i);
    	el:=el.FNext;
    end;
end;

procedure Point_Load(bp:TBlockParEC; owner:TObject; gl:TKeyGroupList);
var
	el:TPointAB;
    tbp:TBlockParEC;
    i,cnt:integer;
    tstr:WideString;
begin
	tbp:=bp.Block_Get('Point');

    cnt:=tbp.Block_Count;
    for i:=0 to cnt-1 do begin
    	tstr:=tbp.Block_GetName(i);
        if (tstr='') or (not IsIntEC(tstr)) then continue;

        el:=Point_Add;
        el.FOwner.Add(owner);
        el.FNo:=StrToIntEC(tstr);
        el.Load(tbp.Block_Get(i));
    end;
end;

procedure Point_SaveWorld(bd:TBufEC);
var
	i:integer;
	el:TPointAB;
begin
	bd.AddInteger(Point_Cnt);

    i:=1;
	el:=Point_First;
    while el<>nil do begin
    	el.FNo:=i;
        inc(i);
    	el:=el.FNext;
    end;

	el:=Point_First;
    while el<>nil do begin
        el.SaveWorld(bd);
    	el:=el.FNext;
    end;
end;

procedure Point_LoadWorld(bd:TBufEC);
var
	i,cnt:integer;
	el:TPointAB;
begin
	Point_Clear;

	cnt:=bd.GetInteger;

    for i:=0 to cnt-1 do begin
    	el:=Point_Add;
        el.FNo:=i+1;
        el.LoadWorld(bd);
    end;

    Point_ListBuild;

	el:=Point_First;
    while el<>nil do begin
    	if el.FParent<>nil then el.FParent:=Point_List[integer(el.FParent)];//Point_ByNo(integer(el.FParent));
    	el:=el.FNext;
    end;
end;

procedure Point_SaveEnd(bd:TBufEC);
var
	i:integer;
	el:TPointAB;
begin
	bd.AddInteger(Point_CntUnion);

    i:=0;
	el:=Point_First;
    while el<>nil do begin
    	if el.FParent=nil then begin
	    	el.FNo:=i;
    	    el.SaveEnd(bd);

        	inc(i);
        end else begin
        	el.FNo:=el.FParent.FNo;
        end;
    	el:=el.FNext;
    end;
end;

end.

