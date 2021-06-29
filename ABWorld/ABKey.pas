unit ABKey;

interface

uses Windows, Classes, SysUtils, Math, EC_BlockPar, EC_Buf;

type
  TKeyAB = class;
  TKeyGroupList = class;

  Key_DefFunInterpolate = procedure(key: TKeyAB; i1, i2: integer; t: single);

  TKeyAB = class(TObject)
  public
    FKeyPrev: TKeyAB;
    FKeyNext: TKeyAB;

    FGroupList: TKeyGroupList;

    FCount: integer;
    FCur: integer;
    FUnitSize: integer;
    FUnit: array of array of Pointer;
    FUnitT: array of integer;

    FInterpolateVal: Pointer;

    FFunInterpolate: Key_DefFunInterpolate;

    FTimeFull: integer;
  public
    constructor Create(gl: TKeyGroupList; us: integer; fi: Key_DefFunInterpolate);
    destructor Destroy; override;

    procedure KeyInsert(no: integer);
    procedure KeyDelete(no: integer);
    procedure KeySwap(no1, no2: integer);

    procedure GroupInsert(no: integer);
    procedure GroupDelete(no: integer);
    procedure GroupSwap(no1, no2: integer);

    procedure CalcInterpolate(ztime: single; var i1: integer; var i2: integer; var t: single);
    procedure CalcInterpolateSimple(ztime: single; var i1: integer; var i2: integer; var t: single);
    function CalcTime(cnt: integer): integer;
    procedure Interpolate;

    function Get: Pointer;

    function GetVDWORD: DWORD;
    procedure SetVDWORD(zn: DWORD);
    procedure SetVDWORD_(zn: DWORD);
    property VDWORD: DWORD read GetVDWORD write SetVDWORD;
    property VDWORD_: DWORD write SetVDWORD_;

    function GetIpDWORD: DWORD;
    procedure SetIpDWORD(zn: DWORD);
    property IpDWORD: DWORD read GetIpDWORD write SetIpDWORD;

    function Save: WideString;
    procedure Load(tstr: WideString);
  end;

  TKeyGroup = class(TObject)
  public
    FName: WideString;
  public
  end;

  TKeyGroupList = class(TObject)
  public
    FNo: integer;

    FList: TList;
    FCur: integer;

    FOwner: TObject;
  public
    constructor Create(ow: TObject);
    destructor Destroy; override;

    function Count: integer;

    procedure Clear;

    function Insert(no: integer): TKeyGroup;
    procedure Delete(no: integer);

    procedure Load(bp: TBlockParEC);

    procedure SaveWorld(bd: TBufEC);
    procedure LoadWorld(bd: TBufEC);
  end;

var
  Key_First: TKeyAB;
  Key_Last: TKeyAB;

  KeyGroupList_List: TList;
  Key_Time: integer = 0;
  Key_TimeMax: integer = 0;

function KeyGroupList_Add(ow: TObject): TKeyGroupList;
procedure KeyGroupList_Del(el: TKeyGroupList); overload;
procedure KeyGroupList_Del(ow: TObject); overload;
function KeyGroupList_Get(ow: TObject): TKeyGroupList;
function KeyGroupList_ByNom(no: integer): TKeyGroupList;
procedure KeyGroupList_SaveWorld(bd: TBufEC);
procedure KeyGroupList_LoadWorld(bd: TBufEC);

procedure Key_Interpolate;
function Key_CalcFullTime: integer;

procedure Key_FunInterpolateColor(key: TKeyAB; i1, i2: integer; t: single);

implementation

uses EC_Mem, Form_Main, EC_Str, WorldUnit;

constructor TKeyAB.Create(gl: TKeyGroupList; us: integer; fi: Key_DefFunInterpolate);
var
  i, u: integer;
begin
  inherited Create;
  FGroupList := gl;
  FUnitSize := us;
  FFunInterpolate := fi;

  if Key_Last <> nil then
    Key_Last.FKeyNext := self;
  self.FKeyPrev := Key_Last;
  self.FKeyNext := nil;
  Key_Last := self;
  if Key_First = nil then
    Key_First := self;

  FCount := 1;
  FCur := 0;

  SetLength(FUnit, FGroupList.Count);
  for i := 0 to FGroupList.Count - 1 do
  begin
    SetLength(FUnit[i], FCount);
    for u := 0 to FCount - 1 do
      FUnit[i][u] := AllocClearEC(FUnitSize);
  end;
  SetLength(FUnitT, FCount);

  FInterpolateVal := AllocEC(FUnitSize);
end;

destructor TKeyAB.Destroy;
var
  i, u: integer;
begin
  if self.FKeyPrev <> nil then
    self.FKeyPrev.FKeyNext := self.FKeyNext;
  if self.FKeyNext <> nil then
    self.FKeyNext.FKeyPrev := self.FKeyPrev;
  if Key_Last = self then
    Key_Last := self.FKeyPrev;
  if Key_First = self then
    Key_First := self.FKeyNext;

  for i := 0 to High(FUnit) do
  begin
    for u := 0 to FCount - 1 do
      FreeEC(FUnit[i][u]);
    FUnit[i] := nil;
  end;
  FUnit := nil;
  FUnitT := nil;
  FCount := 0;
  FCur := 0;

  if FInterpolateVal <> nil then
  begin
    FreeEC(FInterpolateVal);
    FInterpolateVal := nil;
  end;

  inherited Destroy;
end;

procedure TKeyAB.KeyInsert(no: integer);
var
  i, u: integer;
begin
  Inc(FCount);
  for i := 0 to FGroupList.Count - 1 do
  begin
    SetLength(FUnit[i], FCount);
    for u := FCount - 1 downto no + 1 do
      FUnit[i][u] := FUnit[i][u - 1];

    FUnit[i][no] := AllocEC(FUnitSize);
    if no < (FCount - 1) then
      CopyMemory(FUnit[i][no], FUnit[i][no + 1], FUnitSize)
    else
      CopyMemory(FUnit[i][no], FUnit[i][no - 1], FUnitSize);
  end;

  SetLength(FUnitT, FCount);
  for u := FCount - 1 downto no + 1 do
    FUnitT[u] := FUnitT[u - 1];
  if no < (FCount - 1) then
    FUnitT[no] := FUnitT[no + 1]
  else
    FUnitT[no] := FUnitT[no - 1];
end;

procedure TKeyAB.KeyDelete(no: integer);
var
  i, u: integer;
begin
  if (no < 0) or (no >= FCount) or (FCount <= 1) then
    EError('TKeyAB.KeyDelete');

  for i := 0 to FGroupList.Count - 1 do
  begin
    FreeEC(FUnit[i][no]);
    for u := no + 1 to FCount - 1 do
      FUnit[i][u - 1] := FUnit[i][u];
    SetLength(FUnit[i], FCount - 1);
  end;

  for u := no + 1 to FCount - 1 do
    FUnitT[u - 1] := FUnitT[u];
  SetLength(FUnitT, FCount - 1);

  Dec(FCount);

  if FCur >= FCount then
    FCur := FCount - 1;
end;

procedure TKeyAB.KeySwap(no1, no2: integer);
var
  i: integer;
  tp: Pointer;
  zn: integer;
begin
  for i := 0 to FGroupList.Count - 1 do
  begin
    tp := FUnit[i][no1];
    FUnit[i][no1] := FUnit[i][no2];
    FUnit[i][no2] := tp;
  end;

  zn := FUnitT[no1];
  FUnitT[no1] := FUnitT[no2];
  FUnitT[no2] := zn;
end;

procedure TKeyAB.GroupInsert(no: integer);
var
  i: integer;
begin
  SetLength(FUnit, High(FUnit) + 1 + 1);
  for i := High(FUnit) downto no + 1 do
    FUnit[i]{))^} :={PDWORD(Pointer(}FUnit[i - 1]{PDWORD(Pointer(}{))^};
  //    PDWORD(Pointer(FUnit[no]))^:=0;
  SetLength(FUnit[no], FCount);
  for i := 0 to FCount - 1 do
  begin
    FUnit[no][i] := AllocEC(FUnitSize);
    if no < (High(FUnit) + 1 - 1) then
      CopyMemory(FUnit[no][i], FUnit[no + 1][i], FUnitSize)
    else
      CopyMemory(FUnit[no][i], FUnit[no - 1][i], FUnitSize);
  end;
end;

procedure TKeyAB.GroupDelete(no: integer);
var
  i: integer;
begin
  for i := 0 to FCount - 1 do
    FreeEC(FUnit[no][i]);
  FUnit[no] := nil;
  for i := no + 1 to High(FUnit) do
    FUnit[i - 1]{))^} :={PDWORD(Pointer(}FUnit[i]{PDWORD(Pointer(}{))^};
  //    PDWORD(Pointer(FUnit[High(FUnit)]))^:=0;
  SetLength(FUnit, High(FUnit) + 1 - 1);
end;

procedure TKeyAB.GroupSwap(no1, no2: integer);
{var
  zn:DWORD;
begin
  zn:=PDWORD(Pointer(FUnit[no1]))^;
    PDWORD(Pointer(FUnit[no1]))^:=PDWORD(Pointer(FUnit[no2]))^;
    PDWORD(Pointer(FUnit[no2]))^:=zn;
end;}
var
  i: integer;
  tp: Pointer;
begin
  for i := 0 to FCount - 1 do
  begin
    tp := FUnit[no1][i];
    FUnit[no1][i] := FUnit[no2][i];
    FUnit[no2][i] := tp;
  end;
end;

procedure TKeyAB.CalcInterpolate(ztime: single; var i1: integer; var i2: integer; var t: single);
var
  zerocnt: integer;
  keytimelength: integer;
  wu: TabWorldUnit;
begin
  if FCount <= 1 then
  begin
    i1 := 0;
    i2 := 0;
    t := 0;
    exit;
  end;

  wu := TabWorldUnit(FGroupList.FOwner);

  keytimelength := FTimeFull;//CalcTime(FCount);

  ztime := ztime + wu.FTimeOffset;
  if keytimelength >= wu.FTimeLength then
    ztime := Round(ztime) mod keytimelength
  else
  begin
    ztime := Round(ztime) mod wu.FTimeLength;

    if ztime < (wu.FTimeLength - keytimelength) then
    begin
      i1 := 0;
      i2 := 0;
      t := 0;
      exit;
    end
    else
      ztime := ztime - (wu.FTimeLength - keytimelength);
  end;

  zerocnt := 0;
  i1 := 0;
  while true do
  begin
    if (ztime - FUnitT[i1]) < 0 then
      break;
    if FUnitT[i1] <= 0 then
      Inc(zerocnt);
    ztime := ztime - FUnitT[i1];
    Inc(i1);
    if i1 >= FCount then
    begin
      if zerocnt = FCount then
      begin
        i1 := 0;
        i2 := 0;
        t := 0;
        exit;
      end;
      zerocnt := 0;
      i1 := 0;
    end;
  end;

  i2 := i1 + 1;
  if i2 >= FCount then
    i2 := 0;
  t := ztime / FUnitT[i1];
end;

procedure TKeyAB.CalcInterpolateSimple(ztime: single; var i1: integer; var i2: integer; var t: single);
var
  zerocnt: integer;
begin
  if FCount <= 1 then
  begin
    i1 := 0;
    i2 := 0;
    t := 0;
    exit;
  end;

  zerocnt := 0;
  i1 := 0;
  while true do
  begin
    if (ztime - FUnitT[i1]) < 0 then
      break;
    if FUnitT[i1] <= 0 then
      Inc(zerocnt);
    ztime := ztime - FUnitT[i1];
    Inc(i1);
    if i1 >= FCount then
    begin
      if zerocnt = FCount then
      begin
        i1 := 0;
        i2 := 0;
        t := 0;
        exit;
      end;
      zerocnt := 0;
      i1 := 0;
    end;
  end;

  i2 := i1 + 1;
  if i2 >= FCount then
    i2 := 0;
  t := ztime / FUnitT[i1];
end;

function TKeyAB.CalcTime(cnt: integer): integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to cnt - 1 do
    result := result + FUnitT[i];
end;

procedure TKeyAB.Interpolate;
var
  i1, i2: integer;
  t: single;
begin
  CalcInterpolate(Key_Time, i1, i2, t);
  FFunInterpolate(self, i1, i2, t);
end;

function TKeyAB.Get: Pointer;
begin
  result := FUnit[FGroupList.FCur][FCur];
end;

function TKeyAB.GetVDWORD: DWORD;
begin
  result := PDWORD(FUnit[FGroupList.FCur][FCur])^;
end;

procedure TKeyAB.SetVDWORD(zn: DWORD);
begin
  PDWORD(FUnit[FGroupList.FCur][FCur])^ := zn;
end;

procedure TKeyAB.SetVDWORD_(zn: DWORD);
var
  i, u: integer;
begin
  for i := 0 to FGroupList.Count - 1 do
    for u := 0 to FCount - 1 do
      PDWORD(FUnit[i][u])^ := zn;
end;

function TKeyAB.GetIpDWORD: DWORD;
begin
  result := PDWORD(FInterpolateVal)^;
end;

procedure TKeyAB.SetIpDWORD(zn: DWORD);
begin
  PDWORD(FInterpolateVal)^ := zn;
end;

function TKeyAB.Save: WideString;
var
  i, u, t: integer;
  buf: Pointer;
begin
  result := IntToStr(FCount);
  for i := 0 to FCount - 1 do
    result := result + ',' + IntToStr(FUnitT[i]);
  for i := 0 to FGroupList.Count - 1 do
    for u := 0 to FCount - 1 do
    begin
      result := result + ',';
      buf := FUnit[i][u];
      result := result + ByteToStrHexEC(PBYTE(buf)^);
      buf := Ptr(DWORD(buf) + 1);
      for t := 1 to FUnitSize - 1 do
      begin
        result := result + ' ' + ByteToStrHexEC(PBYTE(buf)^);
        buf := Ptr(DWORD(buf) + 1);
      end;
    end;
end;

procedure TKeyAB.Load(tstr: WideString);
var
  cnt, i, u, t, sme: integer;
  zs: WideString;
  buf: Pointer;
begin
  sme := 0;
  cnt := StrToIntEC(GetStrParEC(tstr, sme, ','));
  Inc(sme);

  while FCount < cnt do
    KeyInsert(FCount);
  while FCount > cnt do
    KeyDelete(FCount - 1);

  FTimeFull := 0;
  for i := 0 to FCount - 1 do
  begin
    FUnitT[i] := StrToIntEC(GetStrParEC(tstr, sme, ','));
    Inc(sme);
    FTimeFull := FTimeFull + FUnitT[i];
  end;
  for i := 0 to FGroupList.Count - 1 do
    for u := 0 to FCount - 1 do
    begin
      zs := TrimEx(GetStrParEC(tstr, sme, ','));
      Inc(sme);

      cnt := GetCountParEC(zs, ' ');
      if cnt <> FUnitSize then
        EError('TKeyAB.Load');
      buf := FUnit[i][u];
      for t := 0 to FUnitSize - 1 do
      begin
        PBYTE(buf)^ := StrHexToByteEC(GetStrParEC(zs, t, ' '));
        buf := Ptr(DWORD(buf) + 1);
      end;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TKeyGroupList.Create(ow: TObject);
begin
  inherited Create;
  FList := TList.Create;
  FOwner := ow;
end;

destructor TKeyGroupList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TKeyGroupList.Count: integer;
begin
  result := FList.Count;
end;

procedure TKeyGroupList.Clear;
var
  i: integer;
begin
  for i := 0 to FList.Count - 1 do
    TKeyGroup(FList.Items[i]).Free;
  FList.Clear;
  FCur := 0;
end;

function TKeyGroupList.Insert(no: integer): TKeyGroup;
var
  k: TKeyAB;
begin
  if (no < 0) or (no > Count) then
  begin
    result := nil;
    exit;
  end;
  result := TKeyGroup.Create;
  FList.Insert(no, result);

  k := Key_First;
  while k <> nil do
  begin
    if k.FGroupList = self then
      k.GroupInsert(no);
    k := k.FKeyNext;
  end;
end;

procedure TKeyGroupList.Delete(no: integer);
var
  k: TKeyAB;
begin
  if (no < 0) or (no >= Count) or (Count <= 1) then
    exit;
  FList.Delete(no);

  k := Key_First;
  while k <> nil do
  begin
    if k.FGroupList = self then
      k.GroupDelete(no);
    k := k.FKeyNext;
  end;

  if FCur >= Count then
    FCur := Count - 1;
end;

procedure TKeyGroupList.Load(bp: TBlockParEC);
var
  el: TKeyGroup;
  tbp, tbp2: TBlockParEC;
  i, cnt: integer;
  tstr: WideString;
begin
  Clear;

  tbp := bp.Block_Get('KeyGroup');

  cnt := tbp.Block_Count;
  for i := 0 to cnt - 1 do
  begin
    tstr := tbp.Block_GetName(i);
    if (tstr = '') or (not IsIntEC(tstr)) then
      continue;

    el := Insert(Count);

    tbp2 := tbp.Block_Get(i);
    if tbp2.Par_Count('Name') > 0 then
      el.FName := tbp2.Par['Name'];
  end;
end;

procedure TKeyGroupList.SaveWorld(bd: TBufEC);
var
  i: integer;
begin
  bd.AddInteger(FList.Count);
  for i := 0 to FList.Count - 1 do
    bd.Add(TKeyGroup(FList.Items[i]).FName);
end;

procedure TKeyGroupList.LoadWorld(bd: TBufEC);
var
  i, cnt: integer;
begin
  FCur := TabWorldUnit(FOwner).FKeyGroup;
  cnt := bd.GetInteger;
  for i := 0 to cnt - 1 do
    Insert(FList.Count).FName := bd.GetWideStr;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function KeyGroupList_Add(ow: TObject): TKeyGroupList;
var
  gl: TKeyGroupList;
begin
  gl := TKeyGroupList.Create(ow);
  KeyGroupList_List.Add(gl);
  result := gl;
end;

procedure KeyGroupList_Del(el: TKeyGroupList);
begin
  KeyGroupList_List.Delete(KeyGroupList_List.IndexOf(el));
  el.Free;
end;

procedure KeyGroupList_Del(ow: TObject);
var
  i: integer;
begin
  i := 0;
  while i < KeyGroupList_List.Count do
    if TKeyGroupList(KeyGroupList_List.Items[i]).FOwner = ow then
    begin
      TKeyGroupList(KeyGroupList_List.Items[i]).Free;
      KeyGroupList_List.Delete(i);
    end
    else
      Inc(i);
end;

function KeyGroupList_Get(ow: TObject): TKeyGroupList;
var
  i: integer;
begin
  for i := 0 to KeyGroupList_List.Count - 1 do
    if TKeyGroupList(KeyGroupList_List.Items[i]).FOwner = ow then
    begin
      result := TKeyGroupList(KeyGroupList_List.Items[i]);
      exit;
    end;
  result := nil;
end;

function KeyGroupList_ByNom(no: integer): TKeyGroupList;
var
  i: integer;
begin
  for i := 0 to KeyGroupList_List.Count - 1 do
    if TKeyGroupList(KeyGroupList_List.Items[i]).FNo = no then
    begin
      result := TKeyGroupList(KeyGroupList_List.Items[i]);
      exit;
    end;
  result := nil;
end;

procedure KeyGroupList_SaveWorld(bd: TBufEC);
var
  i: integer;
  el: TKeyGroupList;
begin
  bd.AddInteger(KeyGroupList_List.Count);

  for i := 0 to KeyGroupList_List.Count - 1 do
  begin
    el := TKeyGroupList(KeyGroupList_List.Items[i]);
    el.FNo := i + 1;
    bd.AddInteger(TabWorldUnit(el.FOwner).FNo);
    el.SaveWorld(bd);
  end;
end;

procedure KeyGroupList_LoadWorld(bd: TBufEC);
var
  i, cnt: integer;
  el: TKeyGroupList;
begin
  cnt := bd.GetInteger;
  for i := 0 to cnt - 1 do
  begin
    el := KeyGroupList_Add(WorldUnit_ByNo(bd.GetInteger()));
    el.FNo := i + 1;
    el.LoadWorld(bd);
  end;
end;

procedure Key_Interpolate;
var
  k: TKeyAB;
begin
  k := Key_First;
  while k <> nil do
  begin
    if TabWorldUnit(k.FGroupList.FOwner).FDraw then
      k.Interpolate;
    k := k.FKeyNext;
  end;
end;

function Key_CalcFullTime: integer;
var
  k: TKeyAB;
begin
  result := 0;

  k := Key_First;
  while k <> nil do
  begin
    result := max(result, k.FTimeFull{CalcTime(k.FCount)});
    k := k.FKeyNext;
  end;
end;

procedure Key_FunInterpolateColor(key: TKeyAB; i1, i2: integer; t: single);
var
  zn1, zn2: DWORD;

  function iv(v1, v2: integer): integer;
  begin
    result := v1 + Round((v2 - v1) * t);
    if result < 0 then
      result := 0
    else if result > 255 then
      result := 255;
  end;

begin
  zn1 := PDWORD(key.FUnit[key.FGroupList.FCur][i1])^;
  zn2 := PDWORD(key.FUnit[key.FGroupList.FCur][i2])^;

  key.IpDWORD :=
    iv(zn1 and $ff, zn2 and $ff) or (iv((zn1 shr 8) and $ff, (zn2 shr 8) and $ff) shl 8) or
    (iv((zn1 shr 16) and $ff, (zn2 shr 16) and $ff) shl 16) or
    (iv((zn1 shr 24) and $ff, (zn2 shr 24) and $ff) shl 24);
end;

end.