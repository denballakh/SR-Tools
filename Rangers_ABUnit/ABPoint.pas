unit ABPoint;

interface

uses SysUtils,ab_Obj3D,GR_DirectX3D8,EC_BlockPar;

type
TPointAB = class(TObject)
	public
	    FPrev:TPointAB;
        FNext:TPointAB;

        FId:WideString;

        FPortId:WideString;
        FPortType:WideString;
        FPortLink:WideString;

    	FPos:D3DVECTOR;
        FPosShow:D3DVECTOR;

        FGraph:TabObj3D;

        FSel:boolean;

        FNo:integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure CreateGraph;

        procedure CalcPosShow;
        procedure Update;

        procedure SetPosC(x,y,z:single); overload;
        procedure SetPos(pos:D3DVECTOR); overload;
        property Pos:D3DVECTOR read FPos write SetPos;

        procedure SetSel(zn:boolean);
        property Sel:boolean read FSel write SetSel;

        procedure Save(bp:TBlockParEC);
        procedure Load(bp:TBlockParEC);
end;

procedure Point_Clear;
function Point_Add:TPointAB;
procedure Point_Delete(el:TPointAB);
function Point_NerestShow(pos:D3DVECTOR; crdist:single=1e20):TPointAB;
function Point_Sel(from:TPointAB=nil):TPointAB;
procedure Point_Update;
function Point_ByNo(no:integer):TPointAB;
procedure Point_Save(bp:TBlockParEC);
procedure Point_Load(bp:TBlockParEC);

var
	Point_First:TPointAB=nil;
	Point_Last:TPointAB=nil;

implementation

uses Form_Main,VOper,EC_Str,Global;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TPointAB.Create;
begin
	inherited Create;

    FId:=GUIDToStr(NewGUID());

    CreateGraph;
end;

destructor TPointAB.Destroy;
begin
	if FGraph<>nil then begin ab_Obj3D_Delete(FGraph); FGraph:=nil; end;
	inherited Destroy;
end;

procedure TPointAB.CreateGraph;
begin
	if FGraph<>nil then begin ab_Obj3D_Delete(FGraph); FGraph:=nil; end;

    FGraph:=ab_Obj3D_Add;
    FGraph.FZTest:=false;
    if not FSel then begin
	    FGraph.CreateSphere(4,4,D3DCOLOR_ARGB(255,0,0,255));
    end else begin
	    FGraph.CreateSphere(4,4,D3DCOLOR_ARGB(255,255,0,0));
    end;
    FGraph.SetPos(D3DV(FPos.x+GSmeX,FPos.y+GSmeY,FPos.z));
end;

procedure TPointAB.CalcPosShow;
begin
	FPosShow:=D3D_TransformVector(Camera_MatEnd,FPos);
end;

procedure TPointAB.Update;
begin
	CalcPosShow;
	if FGraph<>nil then FGraph.SetPos(D3DV(FPosShow.x+GSmeX,FPosShow.y+GSmeY,FPos.z));
end;

procedure TPointAB.SetPosC(x,y,z:single);
begin
	if (FPos.x=x) and (FPos.y=y) and (FPos.z=z) then Exit;
	FPos:=D3DV(x,y,z);
	CalcPosShow;
	if FGraph<>nil then FGraph.SetPos(D3DV(FPosShow.x+GSmeX,FPosShow.y+GSmeY,FPos.z));
end;

procedure TPointAB.SetPos(pos:D3DVECTOR);
begin
	if (FPos.x=pos.x) and (FPos.y=pos.y) and (FPos.z=pos.z) then Exit;
	FPos:=pos;
	CalcPosShow;
	if FGraph<>nil then FGraph.SetPos(D3DV(FPosShow.x+GSmeX,FPosShow.y+GSmeY,FPos.z));
end;

procedure TPointAB.SetSel(zn:boolean);
begin
	if (FSel=zn) then Exit;
    FSel:=zn;
	if FGraph<>nil then begin
    	if not FSel then begin
	    	FGraph.SetColor(D3DCOLOR_ARGB(255,0,0,255));
        end else begin
        	FGraph.SetColor(D3DCOLOR_ARGB(255,255,0,0));
        end;
    end;
end;

procedure TPointAB.Save(bp:TBlockParEC);
begin
	bp.Par_Add('Id',FId);
	bp.Par_Add('Pos',Format('%.4f,%.4f,%.4f',[FPos.x,FPos.y,FPos.z]));

    if FPortId<>'' then bp.Par_Add('PortId',FPortId);
    if FPortType<>'' then bp.Par_Add('PortType',FPortType);
    if FPortLink<>'' then bp.Par_Add('PortLink',FPortLink);
end;

procedure TPointAB.Load(bp:TBlockParEC);
var
	tstr:WideString;
begin
	if bp.Par_Count('Id')>0 then FId:=bp.Par['Id'];

	tstr:=bp.Par['Pos'];
    FPos.x:=StrToFloatEC(GetStrParEC(tstr,0,','));
    FPos.y:=StrToFloatEC(GetStrParEC(tstr,1,','));
    FPos.z:=StrToFloatEC(GetStrParEC(tstr,2,','));

    if bp.Par_Count('PortId')>0 then FPortId:=bp.Par['PortId'] else FPortId:='';
    if bp.Par_Count('PortType')>0 then FPortType:=bp.Par['PortType'] else FPortType:='';
    if bp.Par_Count('PortLink')>0 then FPortLink:=bp.Par['PortLink'] else FPortLink:='';
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

procedure Point_Load(bp:TBlockParEC);
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
        el.FNo:=StrToIntEC(tstr);
        el.Load(tbp.Block_Get(i));
    end;
end;

end.

