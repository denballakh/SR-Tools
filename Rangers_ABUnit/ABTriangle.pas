unit ABTriangle;

interface

uses Types,SysUtils,Classes,ab_Obj3D,GR_DirectX3D8,ABPoint,EC_BlockPar,ABKey;

type
PTriangleUnitAB = ^TTriangleUnitAB;
TTriangleUnitAB = record
	FVer:TPointAB;
    FU,FV:single;

//    FColor:D3DCOLOR;//array of D3DCOLOR;
	FColor:TKeyAB;

    FSel:TabObj3D;
end;

TTriangleAB = class(TObject)
	public
	    FPrev:TTriangleAB;
        FNext:TTriangleAB;

		FV:array[0..2] of TTriangleUnitAB;

        FGraph:TabObj3D;

        FTexture:WideString;

        FBackFace:boolean;

        FSel:boolean;
        FSelPoint:integer; // -1 - no sellect

        FPickT:single;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure UpdateGraph;

        function Find(p:TPointAB):integer;
        function Get(i:integer):PTriangleUnitAB;
        function CenterEnd:TPoint;

        procedure Save(bp:TBlockParEC);
        procedure Load(bp:TBlockParEC);
end;

procedure Triangle_Clear;
function Triangle_Add:TTriangleAB;
procedure Triangle_Delete(el:TTriangleAB);
function Triangle_Count:integer;
procedure Triangle_UpdateGraph;
function Triangle_Find(p1,p2,p3:TPointAB):TTriangleAB; overload;
function Triangle_Find(p1,p2:TPointAB):TList; overload;
function Triangle_Sel:TTriangleAB;
procedure Triangle_Save(bp:TBlockParEC);
procedure Triangle_Load(bp:TBlockParEC);

var
	Triangle_First:TTriangleAB=nil;
	Triangle_Last:TTriangleAB=nil;

implementation

uses Form_Main,EC_Str;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TTriangleAB.Create;
var
	i:integer;
begin
	inherited Create;
    for i:=0 to High(FV) do begin
    	FV[i].FColor:=TKeyAB.Create(sizeof(D3DCOLOR),@Key_FunInterpolateColor);
    end;
end;

destructor TTriangleAB.Destroy;
var
	i:integer;
begin
	Clear;
    for i:=0 to High(FV) do begin
    	FV[i].FColor.Free;
        FV[i].FColor:=nil;
    end;
	inherited Destroy;
end;

procedure TTriangleAB.Clear;
var
	i:integer;
begin
	if FGraph<>nil then begin ab_Obj3D_Delete(FGraph); FGraph:=nil; end;
    for i:=0 to High(FV) do begin
    	if FV[i].FSel<>nil then begin ab_Obj3D_Delete(FV[i].FSel); FV[i].FSel:=nil; end;
    end;
end;

procedure TTriangleAB.UpdateGraph;
var
	i:integer;
    p1,p2:TPointAB;
    z1,z2:integer;
    c1,c2:D3DCOLOR;
    r1,r2:single;
begin
    if (FV[0].FVer=nil) or (FV[1].FVer=nil) or (FV[2].FVer=nil) then Exit;

	if FGraph=nil then begin
	    FGraph:=ab_Obj3D_Add;
    	FGraph.VerCount:=3;
	    FGraph.UnitAddTriangle(0,1,2,FTexture);
        if FBackFace then begin
	        FGraph.UnitAddTriangle(1,0,2,FTexture);
        end;
        FGraph.FDrawFromObjLoop:=false;
    end else begin
	    FGraph.SetTexture(FTexture);

        if (not FBackFace) and (FGraph.FUnitFirst<>FGraph.FUnitLast) then begin
        	FGraph.UnitFree(FGraph.FUnitLast);
        end else if (FBackFace) and (FGraph.FUnitFirst=FGraph.FUnitLast) then begin
	        FGraph.UnitAddTriangle(1,0,2,FTexture);
        end;
    end;

    FGraph.VerOpen;
    for i:=0 to High(FV) do begin
	    FGraph.Ver(i)^:=abVer3D(FV[i].FVer.FPosShow.x+GSmeX,FV[i].FVer.FPosShow.y+GSmeY,FV[i].FVer.FPosShow.z,FV[i].FU,FV[i].FV,FV[i].FColor.IpDWORD);
    end;
    FGraph.VerClose;

    for i:=0 to High(FV) do begin
    	if not FSel then begin
	    	if FV[i].FSel<>nil then begin ab_Obj3D_Delete(FV[i].FSel); FV[i].FSel:=nil; end;
        end else begin
        	z1:=i;
            z2:=i+1; if z2>High(FV) then z2:=0;

        	p1:=FV[z1].FVer;
            p2:=FV[z2].FVer;

            c1:=$ffff0000;
            c2:=$ffff0000;
            r1:=1;
            r2:=1;
            if z1=FSelPoint then begin c1:=$ffffff00; r1:=2; end;
            if z2=FSelPoint then begin c2:=$ffffff00; r2:=2; end;

        	if FV[i].FSel=nil then begin
			    FV[i].FSel:=ab_Obj3D_Add;
		        FV[i].FSel.FZTest:=false;
                FV[i].FSel.CreateCone(D3DV(p1.FPosShow.x+GSmeX,p1.FPosShow.y+GSmeY,p1.FPosShow.z),
					                  D3DV(p2.FPosShow.x+GSmeX,p2.FPosShow.y+GSmeY,p2.FPosShow.z),
                                      r1,r2,c1,c2,
                                      5);
            end else begin
                FV[i].FSel.UpdateCone(D3DV(p1.FPosShow.x+GSmeX,p1.FPosShow.y+GSmeY,p1.FPosShow.z),
					                  D3DV(p2.FPosShow.x+GSmeX,p2.FPosShow.y+GSmeY,p2.FPosShow.z),
                                      r1,r2,c1,c2);
            end;
        end;
    end;
end;

function TTriangleAB.Find(p:TPointAB):integer;
var
	i:integer;
begin
	for i:=0 to High(FV) do begin
    	if FV[i].FVer=p then begin
        	Result:=i;
            Exit;
        end;
    end;
    Result:=-1;
end;

function TTriangleAB.Get(i:integer):PTriangleUnitAB;
begin
	Result:=@(FV[i]);
end;

function TTriangleAB.CenterEnd:TPoint;
var
	p1,p2,p3:LPD3DVECTOR;
begin
	p1:=@(FV[0].FVer.FPosShow);
	p2:=@(FV[1].FVer.FPosShow);
	p3:=@(FV[2].FVer.FPosShow);

    Result:=Point(Round((p1.x+p2.x+p3.x)/3+GSmeX),Round((p1.y+p2.y+p3.y)/3+GSmeY));
end;

procedure TTriangleAB.Save(bp:TBlockParEC);
var
	tbp:TBlockParEC;
    i:integer;
begin
	if FTexture<>'' then bp.Par_Add('Texture',FTexture);
    if FBackFace then bp.Par_Add('BackFace','1');

    for i:=0 to High(FV) do begin
		tbp:=bp.Block_Add(IntToStr(i));

        tbp.Par_Add('Point',IntToStr(FV[i].FVer.FNo));
        tbp.Par_Add('UV',Format('%.4f,%.4f',[FV[i].FU,FV[i].FV]));
//        tbp.Par_Add('Diffuse',Format('%d,%d,%d,%d',[D3DCOLOR_A(FV[i].FColor.VDWORD),D3DCOLOR_R(FV[i].FColor.VDWORD),D3DCOLOR_G(FV[i].FColor.VDWORD),D3DCOLOR_B(FV[i].FColor.VDWORD)]));
		tbp.Par_Add('Diffuse',FV[i].FColor.Save);
    end;
end;

procedure TTriangleAB.Load(bp:TBlockParEC);
var
	i:integer;
    tbp:TBlockParEC;
    tstr:WideString;
begin
	if bp.Par_Count('Texture')>0 then FTexture:=bp.Par['Texture'];
	if bp.Par_Count('BackFace')>0 then FBackFace:=boolean(StrToInt(bp.Par['BackFace']));

    for i:=0 to High(FV) do begin
		tbp:=bp.Block[IntToStr(i)];

        FV[i].FVer:=Point_ByNo(StrToIntEC(tbp.Par['Point']));
        tstr:=tbp.Par['UV'];
        FV[i].FU:=StrToFloatEC(GetStrParEC(tstr,0,','));
        FV[i].FV:=StrToFloatEC(GetStrParEC(tstr,1,','));
        tstr:=tbp.Par['Diffuse'];
        FV[i].FColor.Load(tstr);
{        FV[i].FColor.VDWORD:=D3DCOLOR_ARGB(
        					StrToIntEC(GetStrParEC(tstr,0,',')),
        					StrToIntEC(GetStrParEC(tstr,1,',')),
        					StrToIntEC(GetStrParEC(tstr,2,',')),
        					StrToIntEC(GetStrParEC(tstr,3,','))
                            );}
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure Triangle_Clear;
begin
	while Triangle_First<>nil do Triangle_Delete(Triangle_Last);
end;

function Triangle_Add:TTriangleAB;
var
    el:TTriangleAB;
begin
    el:=TTriangleAB.Create;

    if Triangle_Last<>nil then Triangle_Last.FNext:=el;
	el.FPrev:=Triangle_Last;
	el.FNext:=nil;
	Triangle_Last:=el;
	if Triangle_First=nil then Triangle_First:=el;

    Result:=el;
end;

procedure Triangle_Delete(el:TTriangleAB);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if Triangle_Last=el then Triangle_Last:=el.FPrev;
	if Triangle_First=el then Triangle_First:=el.FNext;

    el.Free;
end;

function Triangle_Count:integer;
var
    el:TTriangleAB;
begin
	Result:=0;
	el:=Triangle_First;
    while el<>nil do begin
    	inc(Result);
    	el:=el.FNext;
    end;
end;

procedure Triangle_UpdateGraph;
var
    el:TTriangleAB;
begin
	el:=Triangle_First;
    while el<>nil do begin
    	el.UpdateGraph;
    	el:=el.FNext;
    end;
end;

function Triangle_Find(p1,p2,p3:TPointAB):TTriangleAB;
var
    el:TTriangleAB;
    cnt:integer;
begin
	el:=Triangle_First;
    while el<>nil do begin
		cnt:=0;
        if (el.FV[0].FVer=p1) or (el.FV[0].FVer=p2) or (el.FV[0].FVer=p3) then inc(cnt);
        if (el.FV[1].FVer=p1) or (el.FV[1].FVer=p2) or (el.FV[1].FVer=p3) then inc(cnt);
        if (el.FV[2].FVer=p1) or (el.FV[2].FVer=p2) or (el.FV[2].FVer=p3) then inc(cnt);

        if cnt=3 then begin Result:=el; Exit; end;

    	el:=el.FNext;
    end;
    Result:=nil;
end;

function Triangle_Find(p1,p2:TPointAB):TList; overload;
var
    el:TTriangleAB;
    cnt,cntp:integer;
    li:TList;
begin
	li:=TList.Create;

    cntp:=1; if p2<>nil then inc(cntp);

	el:=Triangle_First;
    while el<>nil do begin
		cnt:=0;
        if (el.FV[0].FVer=p1) or (el.FV[0].FVer=p2) then inc(cnt);
        if (el.FV[1].FVer=p1) or (el.FV[1].FVer=p2) then inc(cnt);
        if (el.FV[2].FVer=p1) or (el.FV[2].FVer=p2) then inc(cnt);

        if cnt>=cntp then li.Add(el);

    	el:=el.FNext;
    end;

    if li.Count<1 then begin li.Free; li:=nil; end;
    Result:=li;
end;

function Triangle_Sel:TTriangleAB;
var
    el:TTriangleAB;
begin
	el:=Triangle_First;
    while el<>nil do begin
    	if el.FSel then begin Result:=el; Exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

procedure Triangle_Save(bp:TBlockParEC);
var
	el:TTriangleAB;
    tbp,tbp2:TBlockParEC;
    i:integer;
begin
	tbp:=bp.Block_Add('Polygon');

    i:=0;
	el:=Triangle_First;
    while el<>nil do begin
	    tbp2:=tbp.Block_Add(IntToStr(i));
    	el.Save(tbp2);
        inc(i);
    	el:=el.FNext;
    end;
end;

procedure Triangle_Load(bp:TBlockParEC);
var
	el:TTriangleAB;
    tbp:TBlockParEC;
    i,cnt:integer;
    tstr:WideString;
begin
	if bp.Block_Count('Polygon')<1 then Exit;
	tbp:=bp.Block_Get('Polygon');

    cnt:=tbp.Block_Count;
    for i:=0 to cnt-1 do begin
    	tstr:=tbp.Block_GetName(i);
        if (tstr='') or (not IsIntEC(tstr)) then continue;

        el:=Triangle_Add;
        el.Load(tbp.Block_Get(i));
    end;
end;

end.

