unit WorldZone;

interface

uses Windows,Classes,SysUtils,Math,aMyFunction,Global,ab_Obj3D,WorldLine,EC_Mem,EC_Buf,
	 EC_Str,DebugMsg,ABPoint;

type
TabZone = class(TObject)
	public
	    FPrev:TabZone;
    	FNext:TabZone;

	    FOrb,FOrbAngle:single;
	    FRadiusAngle:single;
    	FRadius:single;
	    FPos:TDxyz;
        FPosShow:TDxyz;

        FType:integer;	// 0-normal 1-in 2,3,4-exit

	    FGraphLine:TabObj3D;
    	FGraphCenter:TabObj3D;

        FGraph:WideString;
        FHitpoints:integer;
        FMass:integer;
        FDamage:integer;

        FItem:DWORD;
        FItemFreq:integer;

        FSel:boolean;
        FNo:integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure CalcPos;

        procedure UpdateGraph;

        procedure SaveWorld(bd:TBufEC);
        procedure LoadWorld(bd:TBufEC);
end;

TabZoneLink = class(TObject)
	public
	    FPrev:TabZoneLink;
    	FNext:TabZoneLink;

    	FStart:TabZone;
    	FEnd:TabZone;

	    FGraph:TabObj3D;

        FType:integer; // 0-normal 1-stop line

        FSel:boolean;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure UpdateGraph;
end;

procedure Zone_Clear;
function Zone_Add:TabZone;
procedure Zone_Delete(el:TabZone);
function Zone_Cnt:integer;
function Zone_Sel:TabZone;
function Zone_ByNo(no:integer):TabZone;
procedure Zone_UpdateGraph;
procedure Zone_SaveWorld(bd:TBufEC);
procedure Zone_LoadWorld(bd:TBufEC);
procedure Zone_SaveEnd(bd:TBufEC);

procedure ZoneLink_Clear;
function ZoneLink_Add:TabZoneLink;
procedure ZoneLink_Delete(el:TabZoneLink);
function ZoneLink_Cnt:integer;
function ZoneLink_Sel:TabZoneLink;
procedure ZoneLink_UpdateGraph;
function ZoneLink_Find(z1,z2:TabZone):TabZoneLink;

var
	Zone_First:TabZone=nil;
	Zone_Last:TabZone=nil;

	ZoneLink_First:TabZoneLink=nil;
	ZoneLink_Last:TabZoneLink=nil;

implementation

uses EC_BlockPar,GR_DirectX3D8,ABTriangle,ABLine,ABKey,Form_Main,VOper;

constructor TabZone.Create;
begin
	inherited Create;
end;

destructor TabZone.Destroy;
begin
	Clear;
	inherited Destroy;
end;

procedure TabZone.Clear;
var
	zl,zl2:TabZoneLink;
begin
	if FGraphLine<>nil then begin
    	ab_Obj3D_Delete(FGraphLine);
    	FGraphLine:=nil;
	end;
	if FGraphCenter<>nil then begin
    	ab_Obj3D_Delete(FGraphCenter);
    	FGraphCenter:=nil;
	end;

    zl:=ZoneLink_First;
    while zl<>nil do begin
    	zl2:=zl;
    	zl:=zl.FNext;
    	if (zl2.FStart=self) or (zl2.FEnd=self) then ZoneLink_Delete(zl2);
    end;
end;

procedure TabZone.CalcPos;
begin
// l=((pi*r)/180)*n
// n=l/((pi*r)/180)
	FRadius:=(pi*ab_WorldRadius*FRadiusAngle)/180;
	FPos:=ab_CalcPos(Angle360ToRad(FOrb),Angle360ToRad(FOrbAngle),ab_WorldRadius);
end;

procedure TabZone.UpdateGraph;
var
	i,cnt:integer;
    angle,step:xyzV;
    v:TDxyz;
    col:DWORD;
begin
//	col:=D3DCOLOR_ARGB(255,0,0,255);
	if FType=0 then col:=D3DCOLOR_ARGB(255,0,0,255)
    else if FType=1 then col:=D3DCOLOR_ARGB(255,0,255,255)//D3DCOLOR_ARGB(255,0,97,201)
    else if FType in [2,3,4] then col:=D3DCOLOR_ARGB(255,191,94,140{180,0,0})
    else if FType=5 then col:=D3DCOLOR_ARGB(255,0,255,0)
    else if FType in [6,7,8] then col:=D3DCOLOR_ARGB(255,255,0,0)
    else if FType=9 then col:=D3DCOLOR_ARGB(255,255,255,0)
    else col:=D3DCOLOR_ARGB(255,255,150,150);

    if FSel then col:=D3DCOLOR_ARGB(255,255,255,255);

	if FGraphCenter=nil then begin
    	FGraphCenter:=ab_Obj3D_Add;
	    FGraphCenter.FZTest:=false;
    	FGraphCenter.FLoopDraw:=1;
	    if not FSel then begin
		    FGraphCenter.CreateSphere(3,3,D3DCOLOR_ARGB(255,0,0,255));
	    end else begin
	    	FGraphCenter.CreateSphere(3,3,D3DCOLOR_ARGB(255,255,0,0));
    	end;
    end;
    FGraphCenter.SetColor(col);
	FPosShow:=D3D_TransformVector(ab_Camera_MatEnd,FPos);
	FGraphCenter.FDrawFromObjLoop:=ab_InTop(FPosShow.z) and FormMain.MM_View_Zone.Checked;
	FGraphCenter.SetPos(D3DV(FPosShow.x+GSmeX,FPosShow.y+GSmeY,0{FPos.z}));

//    FGraphCenter.FDrawFromObjLoop:=FormMain.MM_View_Zone.Checked;

	cnt:=32;
    if FGraphLine=nil then begin
    	FGraphLine:=ab_Obj3D_Add;
	    FGraphLine.FZTest:=false;
    	FGraphLine.FLoopDraw:=1;
        FGraphLine.VerCount:=cnt;

        FGraphLine.UnitAddLine(cnt-1,0);
        for i:=0 to cnt-2 do FGraphLine.UnitAddLine(i,i+1);
    end;

    FGraphLine.VerOpen;
    step:=360/(cnt-1);
    angle:=-step;
    for i:=0 to cnt-1 do begin
	    angle:=angle+step;

	    with ab_CalcNewPos(abPos(FOrb,FOrbAngle,angle),FRadius) do begin
		    v:=ab_CalcPos(Angle360ToRad(FOrbit),Angle360ToRad(FOrbitAngle),ab_WorldRadius);
	    end;
		v:=D3D_TransformVector(ab_Camera_MatEnd,v);
        FGraphLine.Ver(i)^:=abVer3D(v.x+GSmeX,v.y+GSmeY,v.z,0,0,col);
    end;
    FGraphLine.VerClose;

    FGraphLine.FDrawFromObjLoop:=ab_InTop(FPosShow.z) and FormMain.MM_View_Zone.Checked;
end;

procedure TabZone.SaveWorld(bd:TBufEC);
begin
	bd.AddSingle(FOrb);
    bd.AddSingle(FOrbAngle);
    bd.AddSingle(FRadiusAngle);
    bd.AddInteger(FType);
    bd.Add(FGraph);
	bd.AddInteger(FHitpoints);
    bd.AddInteger(FMass);
    bd.AddInteger(FDamage);

	bd.AddDWORD(FItem);
    bd.AddInteger(FItemFreq);
end;

procedure TabZone.LoadWorld(bd:TBufEC);
begin
	FOrb:=bd.GetSingle;
    FOrbAngle:=bd.GetSingle;
    FRadiusAngle:=bd.GetSingle;
    FType:=bd.GetInteger;
    FGraph:=bd.GetWideStr;
	FHitpoints:=bd.GetInteger;
    FMass:=bd.GetInteger;
    FDamage:=bd.GetInteger;

    if GLoadVersion>=2 then begin
		FItem:=bd.GetDWORD;
        FItemFreq:=bd.GetInteger;
    end;

    CalcPos;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TabZoneLink.Create;
begin
	inherited Create;
end;

destructor TabZoneLink.Destroy;
begin
	Clear;
	inherited Destroy;
end;

procedure TabZoneLink.Clear;
begin
	if FGraph<>nil then begin
    	ab_Obj3D_Delete(FGraph);
    	FGraph:=nil;
	end;
end;

procedure TabZoneLink.UpdateGraph;
var
	col:DWORD;
begin
	col:=D3DCOLOR_ARGB(255,0,0,255);
    if FSel then col:=D3DCOLOR_ARGB(255,255,255,255);

	if FGraph=nil then begin
	    FGraph:=ab_Obj3D_Add;
    	FGraph.VerCount:=2;
	    FGraph.UnitAddLine(0,1);
    end else begin
    end;

    FGraph.VerOpen;
    FGraph.Ver(0)^:=abVer3D(FStart.FPosShow.x+GSmeX,FStart.FPosShow.y+GSmeY,FStart.FPosShow.z,0,0,col);
    FGraph.Ver(1)^:=abVer3D(FEnd.FPosShow.x+GSmeX,FEnd.FPosShow.y+GSmeY,FEnd.FPosShow.z,1,1,col);
    FGraph.VerClose;

    FGraph.FDrawFromObjLoop:=ab_InTop(FStart.FPosShow.z) and
							 ab_InTop(FEnd.FPosShow.z) and
                             FormMain.MM_View_Zone.Checked;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure Zone_Clear;
begin
	while Zone_First<>nil do Zone_Delete(Zone_Last);
end;

function Zone_Add:TabZone;
var
    el:TabZone;
begin
    el:=TabZone.Create;

    if Zone_Last<>nil then Zone_Last.FNext:=el;
	el.FPrev:=Zone_Last;
	el.FNext:=nil;
	Zone_Last:=el;
	if Zone_First=nil then Zone_First:=el;

    Result:=el;
end;

procedure Zone_Delete(el:TabZone);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if Zone_Last=el then Zone_Last:=el.FPrev;
	if Zone_First=el then Zone_First:=el.FNext;

    el.Free;
end;

function Zone_Cnt:integer;
var
    el:TabZone;
begin
	Result:=0;
	el:=Zone_First;
    while el<>nil do begin
    	inc(Result);
    	el:=el.FNext;
    end;
end;

function Zone_Sel:TabZone;
var
    el:TabZone;
begin
	el:=Zone_First;
    while el<>nil do begin
    	if el.FSel then begin Result:=el; Exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

function Zone_ByNo(no:integer):TabZone;
var
    el:TabZone;
begin
	el:=Zone_First;
    while el<>nil do begin
    	if el.FNo=no then begin Result:=el; Exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

procedure Zone_UpdateGraph;
var
	el:TabZone;
begin
	el:=Zone_First;
    while el<>nil do begin
    	el.UpdateGraph;
    	el:=el.FNext;
    end;
end;

procedure Zone_SaveWorld(bd:TBufEC);
var
	zone:TabZone;
    zl:TabZoneLink;
    i:integer;
begin
	bd.AddInteger(Zone_Cnt);
	i:=1;
	zone:=Zone_First;
    while zone<>nil do begin
    	zone.FNo:=i;
        zone.SaveWorld(bd);
    	zone:=zone.FNext;
        inc(i);
    end;

	bd.AddInteger(ZoneLink_Cnt);
    zl:=ZoneLink_First;
    while zl<>nil do begin
    	bd.AddInteger(zl.FStart.FNo);
    	bd.AddInteger(zl.FEnd.FNo);
        bd.AddInteger(zl.FType);
    	zl:=zl.FNext;
    end;
end;

procedure Zone_LoadWorld(bd:TBufEC);
var
	zone:TabZone;
    zl:TabZoneLink;
    i,cnt:integer;
begin
    cnt:=bd.GetInteger;
    for i:=0 to cnt-1 do begin
    	zone:=Zone_Add;
    	zone.FNo:=i+1;
        zone.LoadWorld(bd);
    end;

    cnt:=bd.GetInteger;
    for i:=0 to cnt-1 do begin
    	zl:=ZoneLink_Add;
        zl.FStart:=Zone_ByNo(bd.GetInteger());
        zl.FEnd:=Zone_ByNo(bd.GetInteger());
        zl.FType:=bd.GetInteger();
    end;
end;

procedure Zone_SaveEnd(bd:TBufEC);
var
	zone:TabZone;
    zl:TabZoneLink;
    i:integer;
begin
	i:=0;
	bd.AddInteger(Zone_Cnt);
	zone:=Zone_First;
    while zone<>nil do begin
    	zone.FNo:=i;
    	bd.AddSingle(zone.FOrb);
    	bd.AddSingle(zone.FOrbAngle);
    	bd.AddSingle(zone.FRadiusAngle);
        bd.AddInteger(zone.FType);
        bd.Add(zone.FGraph);
        bd.AddInteger(zone.FHitpoints);
		bd.AddInteger(zone.FMass);
	    bd.AddInteger(zone.FDamage);
		bd.AddDWORD(zone.FItem);
    	bd.AddInteger(zone.FItemFreq);

    	zone:=zone.FNext;
        inc(i);
    end;

    bd.AddInteger(ZoneLink_Cnt);
    zl:=ZoneLink_First;
    while zl<>nil do begin
    	bd.AddInteger(zl.FStart.FNo);
        bd.AddInteger(zl.FEnd.FNo);
        bd.AddInteger(zl.FType);
    	zl:=zl.FNext;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure ZoneLink_Clear;
begin
	while ZoneLink_First<>nil do ZoneLink_Delete(ZoneLink_Last);
end;

function ZoneLink_Add:TabZoneLink;
var
    el:TabZoneLink;
begin
    el:=TabZoneLink.Create;

    if ZoneLink_Last<>nil then ZoneLink_Last.FNext:=el;
	el.FPrev:=ZoneLink_Last;
	el.FNext:=nil;
	ZoneLink_Last:=el;
	if ZoneLink_First=nil then ZoneLink_First:=el;

    Result:=el;
end;

procedure ZoneLink_Delete(el:TabZoneLink);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if ZoneLink_Last=el then ZoneLink_Last:=el.FPrev;
	if ZoneLink_First=el then ZoneLink_First:=el.FNext;

    el.Free;
end;

function ZoneLink_Cnt:integer;
var
    el:TabZoneLink;
begin
	Result:=0;
    
	el:=ZoneLink_First;
    while el<>nil do begin
    	inc(Result);
    	el:=el.FNext;
    end;
end;


function ZoneLink_Sel:TabZoneLink;
var
    el:TabZoneLink;
begin
	el:=ZoneLink_First;
    while el<>nil do begin
    	if el.FSel then begin Result:=el; Exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

procedure ZoneLink_UpdateGraph;
var
	el:TabZoneLink;
begin
	el:=ZoneLink_First;
    while el<>nil do begin
    	el.UpdateGraph;
    	el:=el.FNext;
    end;
end;

function ZoneLink_Find(z1,z2:TabZone):TabZoneLink;
var
	el:TabZoneLink;
begin
	el:=ZoneLink_First;
    while el<>nil do begin
    	if (el.FStart=z1) and (el.FEnd=z2) then begin Result:=el; exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

end.
