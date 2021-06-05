unit ABTriangle;

interface

uses Types, SysUtils, Classes, ab_Obj3D, GR_DirectX3D8, ABPoint, EC_BlockPar, EC_Buf, ABKey;

type
  PTriangleUnitAB = ^TTriangleUnitAB;

  TTriangleUnitAB = record
    FVer: TPointAB;
    FU, FV: single;

    FColor: TKeyAB;

    FSel: TabObj3D;
  end;

  TTriangleAB = class(TObject)
  public
    FPrev: TTriangleAB;
    FNext: TTriangleAB;

    FV: array[0..2] of TTriangleUnitAB;

    FGraph: TabObj3D;

    FTexture: WideString;

    FBackFace: boolean;

    FSel: boolean;
    FSelPoint: integer; // -1 - no sellect

    FPickT: single;

    FNo: integer;

    FOwner: TObject;
  public
    constructor Create(gl: TKeyGroupList);
    destructor Destroy; override;

    procedure Clear;

    procedure UpdateGraph;

    function Find(p: TPointAB): integer;
    function Get(i: integer): PTriangleUnitAB;
    function CenterEnd: TPoint;

    procedure Load(bp: TBlockParEC);

    procedure SaveWorld(bd: TBufEC);
    procedure LoadWorld(bd: TBufEC);

    procedure SaveEnd(bd, tempbuf: TBufEC);
  end;

procedure Triangle_Clear;
function Triangle_Add(gl: TKeyGroupList): TTriangleAB;
procedure Triangle_Delete(el: TTriangleAB);
function Triangle_Count: integer;
procedure Triangle_UpdateGraph;
function Triangle_Find(p1, p2, p3: TPointAB): TTriangleAB; overload;
function Triangle_Find(p1, p2: TPointAB): TList; overload;
function Triangle_Sel: TTriangleAB;
function Triangle_Cnt: integer;
procedure Triangle_Load(bp: TBlockParEC; owner: TObject; gl: TKeyGroupList);
procedure Triangle_SaveWorld(bd: TBufEC);
procedure Triangle_LoadWorld(bd: TBufEC);
procedure Triangle_SaveEnd(bd, tempbuf: TBufEC);

var
  Triangle_First: TTriangleAB = nil;
  Triangle_Last: TTriangleAB = nil;

implementation

uses Form_Main, EC_Str, Global, WorldUnit;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TTriangleAB.Create(gl: TKeyGroupList);
var
  i: integer;
begin
  inherited Create;
  for i := 0 to High(FV) do
    FV[i].FColor := TKeyAB.Create(gl, sizeof(D3DCOLOR), @Key_FunInterpolateColor);
end;

destructor TTriangleAB.Destroy;
var
  i: integer;
begin
  Clear;
  for i := 0 to High(FV) do
  begin
    FV[i].FColor.Free;
    FV[i].FColor := nil;
  end;
  inherited Destroy;
end;

procedure TTriangleAB.Clear;
var
  i: integer;
begin
  if FGraph <> nil then
  begin
    ab_Obj3D_Delete(FGraph);
    FGraph := nil;
  end;
  for i := 0 to High(FV) do
    if FV[i].FSel <> nil then
    begin
      ab_Obj3D_Delete(FV[i].FSel);
      FV[i].FSel := nil;
    end;
end;

procedure TTriangleAB.UpdateGraph;
var
  i: integer;
  p1, p2: TPointAB;
  z1, z2: integer;
  c1, c2: D3DCOLOR;
  r1, r2: single;
begin
  if not TabWorldUnit(FOwner).FDraw then
  begin
    if FGraph <> nil then
      FGraph.FDrawFromObjLoop := false;
    exit;
  end;

  if (FV[0].FVer = nil) or (FV[1].FVer = nil) or (FV[2].FVer = nil) then
    exit;

  if FGraph = nil then
  begin
    FGraph := ab_Obj3D_Add;
    FGraph.VerCount := 3;
    FGraph.UnitAddTriangle(0, 1, 2, FTexture);
    if FBackFace then
      FGraph.UnitAddTriangle(1, 0, 2, FTexture);
    //        FGraph.FDrawFromObjLoop:=false;
  end
  else if (not FBackFace) and (FGraph.FUnitFirst <> FGraph.FUnitLast) then
    FGraph.UnitFree(FGraph.FUnitLast)
  else if (FBackFace) and (FGraph.FUnitFirst = FGraph.FUnitLast) then
    FGraph.UnitAddTriangle(1, 0, 2, FTexture)//      FGraph.SetTexture(FTexture);
  ;

  FGraph.FDrawFromObjLoop := ab_InTop(FV[0].FVer.FPosShow.z) and ab_InTop(FV[1].FVer.FPosShow.z) and
    ab_InTop(FV[2].FVer.FPosShow.z);

  if not FGraph.FDrawFromObjLoop then
    exit;

  FGraph.VerOpen;
  for i := 0 to High(FV) do
    FGraph.Ver(i)^ := abVer3D(FV[i].FVer.FPosShow.x + GSmeX, FV[i].FVer.FPosShow.y + GSmeY, FV[i].FVer.FPosShow.z,
      FV[i].FU, FV[i].FV, FV[i].FColor.IpDWORD);
  FGraph.VerClose;

  for i := 0 to High(FV) do
    if not FSel then
    begin
      if FV[i].FSel <> nil then
      begin
        ab_Obj3D_Delete(FV[i].FSel);
        FV[i].FSel := nil;
      end;
    end
    else
    begin
      z1 := i;
      z2 := i + 1;
      if z2 > High(FV) then
        z2 := 0;

      p1 := FV[z1].FVer;
      p2 := FV[z2].FVer;

      c1 := $ffff0000;
      c2 := $ffff0000;
      r1 := 1;
      r2 := 1;
      if z1 = FSelPoint then
      begin
        c1 := $ffffff00;
        r1 := 2;
      end;
      if z2 = FSelPoint then
      begin
        c2 := $ffffff00;
        r2 := 2;
      end;

      if FV[i].FSel = nil then
      begin
        FV[i].FSel := ab_Obj3D_Add;
        FV[i].FSel.CreateCone(D3DV(p1.FPosShow.x + GSmeX, p1.FPosShow.y + GSmeY, p1.FPosShow.z),
          D3DV(p2.FPosShow.x + GSmeX, p2.FPosShow.y + GSmeY, p2.FPosShow.z),
          r1, r2, c1, c2,
          5);
      end
      else
        FV[i].FSel.UpdateCone(D3DV(p1.FPosShow.x + GSmeX, p1.FPosShow.y + GSmeY, p1.FPosShow.z),
          D3DV(p2.FPosShow.x + GSmeX, p2.FPosShow.y + GSmeY, p2.FPosShow.z),
          r1, r2, c1, c2);
    end;
end;

function TTriangleAB.Find(p: TPointAB): integer;
var
  i: integer;
begin
  for i := 0 to High(FV) do
    if FV[i].FVer = p then
    begin
      result := i;
      exit;
    end;
  result := -1;
end;

function TTriangleAB.Get(i: integer): PTriangleUnitAB;
begin
  result := @(FV[i]);
end;

function TTriangleAB.CenterEnd: TPoint;
var
  p1, p2, p3: LPD3DVECTOR;
begin
  p1 := @(FV[0].FVer.FPosShow);
  p2 := @(FV[1].FVer.FPosShow);
  p3 := @(FV[2].FVer.FPosShow);

  result := Point(Round((p1.x + p2.x + p3.x) / 3 + GSmeX), Round((p1.y + p2.y + p3.y) / 3 + GSmeY));
end;

procedure TTriangleAB.Load(bp: TBlockParEC);
var
  i: integer;
  tbp: TBlockParEC;
  tstr: WideString;
begin
  if bp.Par_Count('Texture') > 0 then
    FTexture := bp.Par['Texture'];
  if bp.Par_Count('BackFace') > 0 then
    FBackFace := boolean(StrToInt(bp.Par['BackFace']));

  for i := 0 to High(FV) do
  begin
    tbp := bp.Block[IntToStr(i)];

    FV[i].FVer := Point_ByNo(StrToIntEC(tbp.Par['Point']));
    tstr := tbp.Par['UV'];
    FV[i].FU := StrToFloatEC(GetStrParEC(tstr, 0, ','));
    FV[i].FV := StrToFloatEC(GetStrParEC(tstr, 1, ','));
    tstr := tbp.Par['Diffuse'];
    FV[i].FColor.Load(tstr);
  end;
end;

procedure TTriangleAB.SaveWorld(bd: TBufEC);
var
  i: integer;
begin
  bd.Add(FTexture);
  bd.AddBoolean(FBackFace);

  bd.AddInteger(TabWorldUnit(FOwner).FNo);

  for i := 0 to High(FV) do
  begin
    bd.AddInteger(FV[i].FVer.FNo);
    bd.AddSingle(FV[i].FU);
    bd.AddSingle(FV[i].FV);
    bd.Add(FV[i].FColor.Save);
  end;
end;

procedure TTriangleAB.LoadWorld(bd: TBufEC);
var
  i: integer;
begin
  FTexture := bd.GetWideStr;
  FBackFace := bd.GetBoolean;

  FOwner := WorldUnit_ByNo(bd.GetInteger);

  for i := 0 to High(FV) do
  begin
    FV[i].FVer := Point_List[bd.GetInteger];//Point_ByNo(bd.GetInteger);
    FV[i].FU := bd.GetSingle;
    FV[i].FV := bd.GetSingle;
    FV[i].FColor.Load(bd.GetWideStr);
  end;
end;

procedure TTriangleAB.SaveEnd(bd, tempbuf: TBufEC);
var
  i: integer;
begin
  //    bd.AddBoolean(FBackFace);
  //    bd.Add(File_Name(FTexture));
  bd.AddInteger(TabWorldUnit(FOwner).FNo);

  for i := 0 to High(FV) do
  begin
    //      bd.AddInteger(SE_PointGetOrAdd(FV[i].FVer.FOrbit,FV[i].FVer.FOrbitAngle,FV[i].FVer.FRadius,FV[i].FU,FV[i].FV,0{FV[i].FColor}));
{    if FV[i].FVer.FNo<0 then begin
      bd.AddInteger(FV[i].FVer.FParent.FNo);
        end else begin}
    bd.AddInteger(FV[i].FVer.FNo);
    //        end;
    bd.AddInteger(SE_ColorKeyGetOrAdd(FV[i].FColor, tempbuf));
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure Triangle_Clear;
begin
  while Triangle_First <> nil do
    Triangle_Delete(Triangle_Last);
end;

function Triangle_Add(gl: TKeyGroupList): TTriangleAB;
var
  el: TTriangleAB;
begin
  el := TTriangleAB.Create(gl);

  if Triangle_Last <> nil then
    Triangle_Last.FNext := el;
  el.FPrev := Triangle_Last;
  el.FNext := nil;
  Triangle_Last := el;
  if Triangle_First = nil then
    Triangle_First := el;

  result := el;
end;

procedure Triangle_Delete(el: TTriangleAB);
begin
  if el.FPrev <> nil then
    el.FPrev.FNext := el.FNext;
  if el.FNext <> nil then
    el.FNext.FPrev := el.FPrev;
  if Triangle_Last = el then
    Triangle_Last := el.FPrev;
  if Triangle_First = el then
    Triangle_First := el.FNext;

  el.Free;
end;

function Triangle_Count: integer;
var
  el: TTriangleAB;
begin
  result := 0;
  el := Triangle_First;
  while el <> nil do
  begin
    Inc(result);
    el := el.FNext;
  end;
end;

procedure Triangle_UpdateGraph;
var
  el: TTriangleAB;
begin
  el := Triangle_First;
  while el <> nil do
  begin
    el.UpdateGraph;
    el := el.FNext;
  end;
end;

function Triangle_Find(p1, p2, p3: TPointAB): TTriangleAB;
var
  el: TTriangleAB;
  cnt: integer;
begin
  el := Triangle_First;
  while el <> nil do
  begin
    cnt := 0;
    if (el.FV[0].FVer = p1) or (el.FV[0].FVer = p2) or (el.FV[0].FVer = p3) then
      Inc(cnt);
    if (el.FV[1].FVer = p1) or (el.FV[1].FVer = p2) or (el.FV[1].FVer = p3) then
      Inc(cnt);
    if (el.FV[2].FVer = p1) or (el.FV[2].FVer = p2) or (el.FV[2].FVer = p3) then
      Inc(cnt);

    if cnt = 3 then
    begin
      result := el;
      exit;
    end;

    el := el.FNext;
  end;
  result := nil;
end;

function Triangle_Find(p1, p2: TPointAB): TList; overload;
var
  el: TTriangleAB;
  cnt, cntp: integer;
  li: TList;
begin
  li := TList.Create;

  cntp := 1;
  if p2 <> nil then
    Inc(cntp);

  el := Triangle_First;
  while el <> nil do
  begin
    cnt := 0;
    if (el.FV[0].FVer = p1) or (el.FV[0].FVer = p2) then
      Inc(cnt);
    if (el.FV[1].FVer = p1) or (el.FV[1].FVer = p2) then
      Inc(cnt);
    if (el.FV[2].FVer = p1) or (el.FV[2].FVer = p2) then
      Inc(cnt);

    if cnt >= cntp then
      li.Add(el);

    el := el.FNext;
  end;

  if li.Count < 1 then
  begin
    li.Free;
    li := nil;
  end;
  result := li;
end;

function Triangle_Sel: TTriangleAB;
var
  el: TTriangleAB;
begin
  el := Triangle_First;
  while el <> nil do
  begin
    if el.FSel then
    begin
      result := el;
      exit;
    end;
    el := el.FNext;
  end;
  result := nil;
end;

function Triangle_Cnt: integer;
var
  el: TTriangleAB;
begin
  result := 0;
  el := Triangle_First;
  while el <> nil do
  begin
    Inc(result);
    el := el.FNext;
  end;
end;

procedure Triangle_Load(bp: TBlockParEC; owner: TObject; gl: TKeyGroupList);
var
  el: TTriangleAB;
  tbp: TBlockParEC;
  i, cnt: integer;
  tstr: WideString;
begin
  if bp.Block_Count('Polygon') < 1 then
    exit;
  tbp := bp.Block_Get('Polygon');

  cnt := tbp.Block_Count;
  for i := 0 to cnt - 1 do
  begin
    tstr := tbp.Block_GetName(i);
    if (tstr = '') or (not IsIntEC(tstr)) then
      continue;

    el := Triangle_Add(gl);
    el.FOwner := owner;
    el.Load(tbp.Block_Get(i));
  end;
end;

procedure Triangle_SaveWorld(bd: TBufEC);
var
  el: TTriangleAB;
begin
  bd.AddInteger(Triangle_Cnt);

  el := Triangle_First;
  while el <> nil do
  begin
    bd.AddInteger(el.FV[0].FColor.FGroupList.FNo);
    el.SaveWorld(bd);
    el := el.FNext;
  end;
end;

procedure Triangle_LoadWorld(bd: TBufEC);
var
  el: TTriangleAB;
  i, cnt: integer;
begin
  Triangle_Clear;

  cnt := bd.GetInteger;

  for i := 0 to cnt - 1 do
  begin
    el := Triangle_Add(KeyGroupList_ByNom(bd.GetInteger));
    el.LoadWorld(bd);
  end;
end;

procedure Triangle_SaveEnd(bd, tempbuf: TBufEC);
var
  el: TTriangleAB;
  i: integer;
begin
  bd.AddInteger(Triangle_Cnt);

  i := 0;
  el := Triangle_First;
  while el <> nil do
  begin
    el.FNo := i;
    el.SaveEnd(bd, tempbuf);
    el := el.FNext;
    Inc(i);
  end;
end;

end.