unit ABKey;

interface

uses Windows, Classes, SysUtils, Math, EC_BlockPar;

type
  TKeyAB = class;

  Key_DefFunInterpolate = procedure(key: TKeyAB; i1, i2: integer; t: single);

  TKeyAB = class(TObject)
  public
    FKeyPrev: TKeyAB;
    FKeyNext: TKeyAB;

    FCount: integer;
    FCur: integer;
    FUnitSize: integer;
    FUnit: array of array of Pointer;
    FUnitT: array of integer;

    FInterpolateVal: Pointer;

    FFunInterpolate: Key_DefFunInterpolate;
  public
    constructor Create(us: integer; fi: Key_DefFunInterpolate);
    destructor Destroy; override;

    procedure KeyInsert(no: integer);
    procedure KeyDelete(no: integer);
    procedure KeySwap(no1, no2: integer);

    procedure GroupInsert(no: integer);
    procedure GroupDelete(no: integer);
    procedure GroupSwap(no1, no2: integer);

    procedure CalcInterpolate(ztime: single; var i1: integer; var i2: integer; var t: single);
    function CalcTime(cnt: integer): integer;
    function NearestKey(ztime: integer): integer;
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

var
  Key_First: TKeyAB;
  Key_Last: TKeyAB;

  Key_Copy: TKeyAB;

  KeyGroup_Count: integer = 0;
  KeyGroup_Cur: integer = 0;
  KeyGroup_List: TList;

  Key_Time: integer = 0;

procedure KeyGroup_ClearInit;
function KeyGroup_Insert(no: integer): TKeyGroup;
procedure KeyGroup_Delete(no: integer);
procedure KeyGroup_Swap(no1, no2: integer);
procedure KeyGroup_Save(bp: TBlockParEC);
procedure KeyGroup_Load(bp: TBlockParEC);
procedure Key_Interpolate;
function Key_CalcFullTime: integer;

procedure Key_FunInterpolateColor(key: TKeyAB; i1, i2: integer; t: single);

implementation

uses EC_Mem, Form_Main, EC_Str;

constructor TKeyAB.Create(us: integer; fi: Key_DefFunInterpolate);
var
  i, u: integer;
begin
  inherited Create;
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

  SetLength(FUnit, KeyGroup_Count);
  for i := 0 to KeyGroup_Count - 1 do
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

  if Key_Copy = self then
    Key_Copy := nil;

  inherited Destroy;
end;

procedure TKeyAB.KeyInsert(no: integer);
var
  i, u: integer;
begin
  Inc(FCount);
  for i := 0 to KeyGroup_Count - 1 do
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

  for i := 0 to KeyGroup_Count - 1 do
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
  for i := 0 to KeyGroup_Count - 1 do
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

function TKeyAB.NearestKey(ztime: integer): integer;
var
  i1, i2: integer;
  t: single;
begin
  CalcInterpolate(ztime, i1, i2, t);
  if t < 0.5 then
    result := i1
  else
    result := i2;
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
  result := FUnit[KeyGroup_Cur][FCur];
end;

function TKeyAB.GetVDWORD: DWORD;
begin
  result := PDWORD(FUnit[KeyGroup_Cur][FCur])^;
end;

procedure TKeyAB.SetVDWORD(zn: DWORD);
begin
  PDWORD(FUnit[KeyGroup_Cur][FCur])^ := zn;
end;

procedure TKeyAB.SetVDWORD_(zn: DWORD);
var
  i, u: integer;
begin
  for i := 0 to KeyGroup_Count - 1 do
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
  for i := 0 to KeyGroup_Count - 1 do
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

  for i := 0 to FCount - 1 do
  begin
    FUnitT[i] := StrToIntEC(GetStrParEC(tstr, sme, ','));
    Inc(sme);
  end;
  for i := 0 to KeyGroup_Count - 1 do
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
procedure KeyGroup_ClearInit;
var
  kg: TKeyGroup;
  i: integer;
begin
  if KeyGroup_List = nil then
    KeyGroup_List := TList.Create
  else
  begin
    for i := 0 to KeyGroup_List.Count - 1 do
      TKeyGroup(KeyGroup_List.Items[i]).Free;
    KeyGroup_List.Clear;
  end;
  kg := TKeyGroup.Create;
  KeyGroup_List.Add(kg);
  KeyGroup_Count := 1;
end;

function KeyGroup_Insert(no: integer): TKeyGroup;
var
  k: TKeyAB;
begin
  if (no < 0) or (no > KeyGroup_Count) then
  begin
    result := nil;
    exit;
  end;
  result := TKeyGroup.Create;
  KeyGroup_List.Insert(no, result);
  Inc(KeyGroup_Count);

  k := Key_First;
  while k <> nil do
  begin
    k.GroupInsert(no);
    k := k.FKeyNext;
  end;
end;

procedure KeyGroup_Delete(no: integer);
var
  k: TKeyAB;
begin
  if (no < 0) or (no >= KeyGroup_Count) or (KeyGroup_Count <= 1) then
    exit;
  KeyGroup_List.Delete(no);
  Dec(KeyGroup_Count);

  k := Key_First;
  while k <> nil do
  begin
    k.GroupDelete(no);
    k := k.FKeyNext;
  end;

  if KeyGroup_Cur >= KeyGroup_Count then
    KeyGroup_Cur := KeyGroup_Count - 1;
end;

procedure KeyGroup_Swap(no1, no2: integer);
var
  k: TKeyAB;
begin
  KeyGroup_List.Exchange(no1, no2);
  k := Key_First;
  while k <> nil do
  begin
    k.GroupSwap(no1, no2);
    k := k.FKeyNext;
  end;
end;

procedure KeyGroup_Save(bp: TBlockParEC);
var
  el: TKeyGroup;
  tbp, tbp2: TBlockParEC;
  i: integer;
begin
  tbp := bp.Block_Add('KeyGroup');

  for i := 0 to KeyGroup_List.Count - 1 do
  begin
    el := KeyGroup_List.Items[i];

    tbp2 := tbp.Block_Add(IntToStr(i));
    if el.FName <> '' then
      tbp2.Par_Add('Name', el.FName);
  end;
end;

procedure KeyGroup_Load(bp: TBlockParEC);
var
  el: TKeyGroup;
  tbp, tbp2: TBlockParEC;
  i, cnt: integer;
  tstr: WideString;
begin
  KeyGroup_ClearInit;

  tbp := bp.Block_Get('KeyGroup');

  cnt := tbp.Block_Count;
  for i := 0 to cnt - 1 do
  begin
    tstr := tbp.Block_GetName(i);
    if (tstr = '') or (not IsIntEC(tstr)) then
      continue;

    if i = 0 then
      el := KeyGroup_List.Items[0]
    else
      el := KeyGroup_Insert(KeyGroup_Count);

    tbp2 := tbp.Block_Get(i);
    if tbp2.Par_Count('Name') > 0 then
      el.FName := tbp2.Par['Name'];
  end;
end;

procedure Key_Interpolate;
var
  k: TKeyAB;
begin
  k := Key_First;
  while k <> nil do
  begin
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
    result := max(result, k.CalcTime(k.FCount));
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
  zn1 := PDWORD(key.FUnit[KeyGroup_Cur][i1])^;
  zn2 := PDWORD(key.FUnit[KeyGroup_Cur][i2])^;

  key.IpDWORD :=
    iv(zn1 and $ff, zn2 and $ff) or (iv((zn1 shr 8) and $ff, (zn2 shr 8) and $ff) shl 8) or
    (iv((zn1 shr 16) and $ff, (zn2 shr 16) and $ff) shl 16) or
    (iv((zn1 shr 24) and $ff, (zn2 shr 24) and $ff) shl 24);
end;

end.