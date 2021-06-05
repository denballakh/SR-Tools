unit EC_Str;

interface

uses Windows, Classes, Messages, Forms, MMSystem, SysUtils;

function GetCountParEC(str: WideString; raz: WideString): integer;
function GetSmeParEC(str: WideString; np: integer; raz: WideString): integer;
function GetLenParEC(str: WideString; smepar: integer; raz: WideString): integer;
function GetStrParEC(str: WideString; np: integer; raz: WideString): WideString; overload;
function GetStrParEC(str: WideString; nps, npe: integer; raz: WideString): WideString; overload;

function GetComEC(s: WideString): WideString;
function GetStrNoComEC(s: WideString): WideString;

function IsIntEC(str: WideString): boolean;
function StrToIntEC(str: WideString): integer;
function StrToIntFullEC(str: WideString): integer;
function StrToFloatEC(str: WideString): single;
function FloatToStrEC(zn: double): WideString;
function StringReplaceEC(str: WideString; sold: WideString; snew: WideString): WideString;

function IntToStrEC(zn: integer; len: integer): WideString;

function ByteToStrHexEC(zn: byte): WideString;
function StrHexToByteEC(str: WideString): byte;

function AddStrPar(str, par: WideString): WideString;

function BooleanToStr(zn: boolean): WideString;

function StrToPoint(tstr: WideString): TPoint;
function PointToStr(zn: TPoint): WideString;
function StrToRect(tstr: WideString): TRect;
function RectToStr(zn: TRect): WideString;

function BuildStr(tstr: string; maxlen: integer): string;
function CharToOemEx(tstr: string): string;

function TrimEx(tstr: WideString): WideString;
function UpperCaseEx(tstr: WideString): WideString;
function LowerCaseEx(tstr: WideString): WideString;

function TagSkipEC(tstr: PWideChar; tstrlen: integer): integer;

function ComparerStrEC(s1, s2: PWideChar): integer; cdecl;
function CmpStrFirstEC(ssou, ssub: WideString): boolean;
function FindSubstring(ssou, ssub: WideString; sme: integer = 0): integer; // -1 not found

function File_Name(path: WideString): WideString;
function File_Ext(path: WideString): WideString;
function File_Path(path: WideString): WideString;

type
  TStringsElEC = class(TObject)
    FPrev: TStringsElEC;
    FNext: TStringsElEC;

    FStr: WideString;
    FData: DWORD;
  end;

  TStringsEC = class(TObject)
  protected
    FFirst: TStringsElEC;
    FLast: TStringsElEC;

    FPointer: TStringsElEC;
  public
    constructor Create;
    destructor Destroy; override;

    procedure CopyData(des: TStringsEC);

    procedure Clear;

  protected
    function El_Add: TStringsElEC; overload;
    procedure El_Add(el: TStringsElEC); overload;
    function El_Insert(perel: TStringsElEC): TStringsElEC; overload;
    procedure El_Insert(perel, el: TStringsElEC); overload;
    procedure El_Del(el: TStringsElEC);
    function El_Get(i: integer): TStringsElEC;
    function El_GetEx(i: integer): TStringsElEC;
  public
    function GetCount: integer;
    procedure SetCount(c: integer);
    property Count: integer read GetCount write SetCount;

    function GetItem(i: integer): WideString;
    procedure SetItem(i: integer; zn: WideString);
    property Item[zn: integer]: WideString read GetItem write SetItem;
    property Strings[zn: integer]: WideString read GetItem write SetItem;

    function GetData(i: integer): DWORD; overload;
    procedure SetData(i: integer; zn: DWORD);
    property Data[zn: integer]: DWORD read GetData write SetData;

    function Find(str: WideString): integer;

    procedure Add(zn: WideString); overload;
    procedure Add(zn: PWideChar; len: integer); overload;
    procedure Insert(i: integer; zn: WideString);
    procedure Delete(i: integer);

    function Get: WideString;
    function GetData: DWORD; overload;
    function GetInc: WideString;
    function GetDec: WideString;
    function TestEnd: boolean;
    function TestFirst: boolean;
    function TestLast: boolean;
    procedure PointerFirst;
    procedure PointerLast;
    procedure PointerNext;
    procedure PointerPrev;
    function PointerGet: integer;
    procedure PointerSet(i: integer);
    property Pointer: integer read PointerGet write PointerSet;

    procedure SetTextStr(str: WideString);
    function GetTextStr: WideString;
    property Text: WideString read GetTextStr write SetTextStr;

    procedure SortBuble;
  end;

implementation

uses EC_Mem;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStringsEC.Create;
begin
  inherited Create;
end;

destructor TStringsEC.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TStringsEC.CopyData(des: TStringsEC);
var
  el: TStringsElEC;
begin
  des.Clear;
  el := FFirst;
  while el <> nil do
  begin
    des.Add(el.FStr);
    el := el.FNext;
  end;
end;

procedure TStringsEC.Clear;
begin
  while FFirst <> nil do
    El_Del(FLast);
  FPointer := nil;
end;

function TStringsEC.El_Add: TStringsElEC;
var
  el: TStringsElEC;
begin
  el := TStringsElEC.Create;
  El_Add(el);
  result := el;
end;

procedure TStringsEC.El_Add(el: TStringsElEC);
begin
  if FLast <> nil then
    FLast.FNext := el;
  el.FPrev := FLast;
  el.FNext := nil;
  FLast := el;
  if FFirst = nil then
    FFirst := el;
end;

function TStringsEC.El_Insert(perel: TStringsElEC): TStringsElEC;
var
  el: TStringsElEC;
begin
  el := TStringsElEC.Create;

  El_Insert(el);

  result := el;
end;

procedure TStringsEC.El_Insert(perel, el: TStringsElEC);
begin
  if perel = nil then
    El_Add(el)
  else
  begin
    el.FPrev := perel.FPrev;
    el.FNext := perel;
    if perel.FPrev <> nil then
      perel.FPrev.FNext := el;
    perel.FPrev := el;
    if perel = FFirst then
      FFirst := el;
  end;
end;

procedure TStringsEC.El_Del(el: TStringsElEC);
begin
  if el.FPrev <> nil then
    el.FPrev.FNext := el.FNext;
  if el.FNext <> nil then
    el.FNext.FPrev := el.FPrev;
  if FLast = el then
    FLast := el.FPrev;
  if FFirst = el then
    FFirst := el.FNext;

  el.Free;
end;

function TStringsEC.El_Get(i: integer): TStringsElEC;
var
  el: TStringsElEC;
begin
  el := FFirst;
  while el <> nil do
  begin
    if i = 0 then
    begin
      result := el;
      exit;
    end;
    Dec(i);
    el := el.FNext;
  end;
  raise Exception.Create('TStringsEC.El_Get. i=' + IntToStr(i));
end;

function TStringsEC.El_GetEx(i: integer): TStringsElEC;
var
  el: TStringsElEC;
begin
  if i < 0 then
    raise Exception.Create('TStringsEC.El_GetEx. i=' + IntToStr(i));
  el := FFirst;
  while el <> nil do
  begin
    if i = 0 then
    begin
      result := el;
      exit;
    end;
    Dec(i);
    el := el.FNext;
  end;
  while i >= 0 do
  begin
    El_Add;
    Dec(i);
  end;
  result := FLast;
end;

function TStringsEC.GetCount: integer;
var
  el: TStringsElEC;
begin
  el := FFirst;
  result := 0;
  while el <> nil do
  begin
    Inc(result);
    el := el.FNext;
  end;
end;

procedure TStringsEC.SetCount(c: integer);
var
  cc, i: integer;
begin
  if c <= 0 then
  begin
    Clear;
    exit;
  end;
  cc := c - Count;
  if cc > 0 then
    for i := 0 to cc - 1 do
      El_Add
  else
    for i := 0 to cc - 1 do
    begin
      if FLast = FPointer then
        FPointer := FPointer.FPrev;
      El_Del(FLast);
    end;
end;

function TStringsEC.GetItem(i: integer): WideString;
begin
  result := El_GetEx(i).FStr;
end;

procedure TStringsEC.SetItem(i: integer; zn: WideString);
begin
  El_GetEx(i).FStr := zn;
end;

function TStringsEC.GetData(i: integer): DWORD;
begin
  result := El_GetEx(i).FData;
end;

procedure TStringsEC.SetData(i: integer; zn: DWORD);
begin
  El_GetEx(i).FData := zn;
end;

function TStringsEC.Find(str: WideString): integer;
var
  el: TStringsElEC;
  i: integer;
begin
  el := FFirst;
  i := 0;
  while el <> nil do
  begin
    if el.FStr = str then
    begin
      result := i;
      exit;
    end;
    Inc(i);
    el := el.FNext;
  end;
  result := -1;
end;

procedure TStringsEC.Add(zn: WideString);
begin
  El_Add.FStr := zn;
end;

procedure TStringsEC.Add(zn: PWideChar; len: integer);
var
  el: TStringsElEC;
begin
  el := El_Add;
  if len > 0 then
  begin
    SetLength(el.FStr, len);
    CopyMemory(PWideChar(el.FStr), zn, len * 2);
    //        el.FStr[len+1]:=#0;
  end;
end;

procedure TStringsEC.Insert(i: integer; zn: WideString);
begin
  if (i < 0) or (i >= Count) then
    Add(zn)
  else
    El_Insert(El_Get(i)).FStr := zn;
end;

procedure TStringsEC.Delete(i: integer);
var
  el: TStringsElEC;
begin
  el := El_Get(i);
  if el = FPointer then
  begin
    FPointer := el.FNext;
    if FPointer = nil then
      FPointer := el.FPrev;
  end;
  El_Del(el);
end;

function TStringsEC.Get: WideString;
begin
  if FPointer = nil then
    raise Exception.Create('TStringsEC.Get.');

  result := FPointer.FStr;
end;

function TStringsEC.GetData: DWORD;
begin
  if FPointer = nil then
    raise Exception.Create('TStringsEC.GetData.');

  result := FPointer.FData;
end;

function TStringsEC.GetInc: WideString;
begin
  if FPointer = nil then
    raise Exception.Create('TStringsEC.Get.');

  result := FPointer.FStr;

  FPointer := FPointer.FNext;
end;

function TStringsEC.GetDec: WideString;
begin
  if FPointer = nil then
    raise Exception.Create('TStringsEC.Get.');

  result := FPointer.FStr;

  FPointer := FPointer.FPrev;
end;

function TStringsEC.TestEnd: boolean;
begin
  if FPointer <> nil then
    result := false
  else
    result := true;
end;

function TStringsEC.TestFirst: boolean;
begin
  if FPointer.FPrev <> nil then
    result := false
  else
    result := true;
end;

function TStringsEC.TestLast: boolean;
begin
  if FPointer.FNext <> nil then
    result := false
  else
    result := true;
end;

procedure TStringsEC.PointerFirst;
begin
  FPointer := FFirst;
end;

procedure TStringsEC.PointerLast;
begin
  FPointer := FLast;
end;

procedure TStringsEC.PointerNext;
begin
  FPointer := FPointer.FNext;
end;

procedure TStringsEC.PointerPrev;
begin
  FPointer := FPointer.FPrev;
end;

function TStringsEC.PointerGet: integer;
var
  el: TStringsElEC;
begin
  el := FPointer;
  result := -1;
  while el <> nil do
  begin
    Inc(result);
    FPointer := el.FPrev;
  end;
end;

procedure TStringsEC.PointerSet(i: integer);
begin
  if i < 0 then
    FPointer := nil
  else
    FPointer := El_Get(i);
end;

procedure TStringsEC.SetTextStr(str: WideString);
var
  P, Start: PWideChar;
begin
  Clear;
  P := PWideChar(str);
  if P <> nil then
    while P^ <> #0 do
    begin
      Start := P;
      while not ((P^ = #0) or (P^ = #10) or (P^ = #13)) do
        Inc(P);
      Add(Start, P - Start);
      if P^ = #13 then
        Inc(P);
      if P^ = #10 then
        Inc(P);
    end;
end;

function TStringsEC.GetTextStr: WideString;
var
  el: TStringsElEC;
begin
  el := FFirst;
  result := '';
  while el <> nil do
  begin
    result := result + el.FStr + #13 + #10;
    el := el.FNext;
  end;
end;

procedure TStringsEC.SortBuble;
var
  cnt, i, u: integer;
  tstr: WideString;
begin
  cnt := Count;
  for i := 0 to cnt - 2 do
    for u := i + 1 to cnt - 1 do
      if ComparerStrEC(PWideChar(Item[i]), PWideChar(Item[u])) > 0 then
      begin
        tstr := Item[i];
        Item[i] := Item[u];
        Item[u] := tstr;
      end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function GetCountParEC(str: WideString; raz: WideString): integer;
var
  len, lenraz: DWORD;
  i, u, Count: integer;
begin
  Count := 1;
  len := Length(str);
  lenraz := Length(raz);
  if len < 1 then
  begin
    result := 0;
    exit;
  end;
  for i := 1 to len do
    for u := 1 to lenraz do
      if str[i] = raz[u] then
      begin
        Inc(Count);
        break;
      end;
  result := Count;
end;

function GetSmeParEC(str: WideString; np: integer; raz: WideString): integer;
var
  len, lenraz: DWORD;
  i, u: integer;
begin
  if np > 0 then
  begin
    len := Length(str);
    lenraz := Length(raz);
    for i := 1 to len do
      for u := 1 to lenraz do
        if str[i] = raz[u] then
        begin
          Dec(np);
          if np = 0 then
          begin
            result := i + 1;
            exit;
          end;
          break;
        end;
    raise Exception.Create('GetSmeParEC. Str=' + str + ' np=' + IntToStr(np) + ' raz=' + raz);
  end;
  result := 1;
end;

function GetLenParEC(str: WideString; smepar: integer; raz: WideString): integer;
var
  len, lenraz: DWORD;
  i, u: integer;
begin
  len := Length(str);
  lenraz := Length(raz);
  for i := smepar to len do
    for u := 1 to lenraz do
      if str[i] = raz[u] then
      begin
        result := i - smepar;
        exit;
      end;
  result := integer(len) - smepar + 1;
end;

function GetStrParEC(str: WideString; np: integer; raz: WideString): WideString;
var
  sme: integer;
begin
  sme := GetSmeParEC(str, np, raz);
  result := Copy(str, sme, GetLenParEC(str, sme, raz));
end;

function GetStrParEC(str: WideString; nps, npe: integer; raz: WideString): WideString;
var
  sme1, sme2: integer;
begin
  sme1 := GetSmeParEC(str, nps, raz);
  sme2 := GetSmeParEC(str, npe, raz);
  sme2 := sme2 + GetLenParEC(str, sme2, raz);
  result := Copy(str, sme1, sme2 - sme1);
end;

function GetComEC(s: WideString): WideString;
var
  compos, i: integer;
begin
  compos := Pos('//', s);
  if compos < 1 then
  begin
    result := '';
    exit;
  end;
  i := compos - 1;
  while i >= 1 do
  begin
    if (s[i] <> widechar(32)) and (s[i] <> widechar(9)) and (s[i] <> widechar($0d)) and (s[i] <> widechar($0a)) then
      break;
    Dec(i);
  end;
  result := Copy(s, i + 1, Length(s) - (i));
end;

function GetStrNoComEC(s: WideString): WideString;
var
  compos: integer;
begin
  compos := Pos('//', s);
  if compos < 1 then
  begin
    result := s;
    exit;
  end
  else if compos = 1 then
  begin
    result := '';
    exit;
  end;
  result := TrimRight(Copy(s, 1, compos - 1));
end;

function IsIntEC(str: WideString): boolean;
var
  len, i: integer;
begin
  len := Length(str);
  if len < 1 then
  begin
    result := false;
    exit;
  end;
  for i := 1 to len do
    if ((str[i] < '0') or (str[i] > '9')) and (str[i] <> '-') then
    begin
      result := false;
      exit;
    end;
  result := true;
end;

function StrToIntEC(str: WideString): integer;
var
  len, i: integer;
begin
  result := 0;
  len := Length(str);
  for i := 1 to len do
    if (integer(str[i]) >= integer('0')) and (integer(str[i]) <= integer('9')) then
      result := result * 10 + StrToInt(str[i]);
end;

function StrToIntFullEC(str: WideString): integer;
var
  len, i: integer;
  fm: boolean;
begin
  result := 0;
  len := Length(str);
  fm := false;
  for i := 1 to len do
    if (integer(str[i]) >= integer('0')) and (integer(str[i]) <= integer('9')) then
      result := result * 10 + StrToInt(str[i])
    else if (integer(str[i]) = integer('-')) and (result = 0) then
      fm := true;
  if fm then
    result := -result;
end;

function StrToFloatEC(str: WideString): single;
var
  i, len: integer;
  zn, tra: single;
  ch: integer;
begin
  len := Length(str);
  if (len < 1) then
  begin
    result := 0;
    exit;
  end;

  zn := 0.0;

  for i := 0 to len - 1 do
  begin
    ch := integer(str[i + 1]);
    if (ch >= integer('0')) and (ch <= integer('9')) then
      zn := zn * 10.0 + (ch - integer('0'))
    else if (ch = integer('.')) then
      break;
  end;
  Inc(i);
  tra := 10.0;
  while i < len do
  begin
    ch := integer(str[i + 1]);
    if (ch >= integer('0')) and (ch <= integer('9')) then
    begin
      zn := zn + ((ch - integer('0'))) / tra;
      tra := tra * 10.0;
    end;
    Inc(i);
  end;
  for i := 0 to len - 1 do
    if integer(str[i + 1]) = integer('-') then
    begin
      zn := -zn;
      break;
    end;

  result := zn;
end;

function FloatToStrEC(zn: double): WideString;
var
  oldch: char;
begin
  oldch := DecimalSeparator;
  DecimalSeparator := '.';
  result := FloatToStr(zn);
  DecimalSeparator := oldch;
end;

function StringReplaceEC(str: WideString; sold: WideString; snew: WideString): WideString;
var
  strlen, soldlen, i, u: integer;
begin
  result := '';
  strlen := Length(str);
  soldlen := Length(sold);
  if (strlen < soldlen) or (strlen < 1) or (soldlen < 1) then
  begin
    result := str;
    exit;
  end;

  i := 0;
  while i <= strlen - soldlen do
  begin
    u := 0;
    while u < soldlen do
    begin
      if str[i + u + 1] <> sold[u + 1] then
        break;
      Inc(u);
    end;

    if u >= soldlen then
    begin
      result := result + snew;
      i := i + soldlen;
    end
    else
    begin
      result := result + str[i + 1];
      Inc(i);
    end;
  end;

  if i < strlen then
    result := result + Copy(str, i + 1, strlen - i);
end;

function IntToStrEC(zn: integer; len: integer): WideString;
var
  sim: integer;
  i, tlen: integer;
begin
  result := '';
  while zn > 0 do
  begin
    sim := zn;
    zn := zn div 10;
    sim := sim - zn * 10;
    result := Chr(sim + integer('0')) + result;
  end;
  tlen := Length(result);
  if tlen < len then
    for i := 0 to len - tlen do
      result := '0' + result
  else
    result := Copy(result, 0, len);
end;

function ByteToStrHexEC(zn: byte): WideString;
const
  hs: array[0..15] of widechar = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
begin
  SetLength(result, 2);
  result[1] := hs[zn shr 4];
  result[2] := hs[zn and $f];
end;

function StrHexToByteEC(str: WideString): byte;
var
  len, i: integer;
begin
  result := 0;
  len := Length(str);
  for i := 1 to len do
    if (integer(str[i]) >= integer('0')) and (integer(str[i]) <= integer('9')) then
      result := result * 16 + (integer(str[i]) - integer('0'))
    else if (integer(str[i]) >= integer('a')) and (integer(str[i]) <= integer('f')) then
      result := result * 16 + (integer(str[i]) - integer('a')) + 10
    else if (integer(str[i]) >= integer('A')) and (integer(str[i]) <= integer('F')) then
      result := result * 16 + (integer(str[i]) - integer('a')) + 10;
end;

function AddStrPar(str, par: WideString): WideString;
begin
  if GetCountParEC(str, '?') < 2 then
    result := str + '?' + par
  else
    result := str + '&' + par;
end;

function BooleanToStr(zn: boolean): WideString;
begin
  if zn = false then
    result := 'False'
  else
    result := 'True';
end;

function StrToPoint(tstr: WideString): TPoint;
begin
  if GetCountParEC(tstr, ',') < 2 then
    raise Exception.Create('StrToPoint. str=' + tstr);
  result := Point(StrToInt(GetStrParEC(tstr, 0, ',')), StrToInt(GetStrParEC(tstr, 1, ',')));
end;

function PointToStr(zn: TPoint): WideString;
begin
  result := IntToStr(zn.x) + ',' + IntToStr(zn.y);
end;

function StrToRect(tstr: WideString): TRect;
begin
  if GetCountParEC(tstr, ',') < 4 then
    raise Exception.Create('StrToRect. str=' + tstr);
  result.Left := StrToInt(GetStrParEC(tstr, 0, ','));
  result.Top := StrToInt(GetStrParEC(tstr, 1, ','));
  result.Right := StrToInt(GetStrParEC(tstr, 2, ','));
  result.Bottom := StrToInt(GetStrParEC(tstr, 3, ','));
end;

function RectToStr(zn: TRect): WideString;
begin
  result := IntToStr(zn.Left) + ',' + IntToStr(zn.Top) + ',' + IntToStr(zn.Right) + ',' + IntToStr(zn.Bottom);
end;

function BuildStr(tstr: string; maxlen: integer): string;
const
  addstr =
    '                                                                                                                                                                                                                                                               ';
var
  tlen: integer;
begin
  tlen := Length(tstr);
  if tlen > maxlen then
    result := Copy(tstr, 1, maxlen)
  else if tlen = maxlen then
    result := tstr
  else
    result := tstr + Copy(addstr, 1, maxlen - tlen);
end;

function CharToOemEx(tstr: string): string;
begin
  CharToOemBuff(PChar(tstr), PChar(tstr), Length(tstr));
  result := tstr;
end;

function TrimEx(tstr: WideString): WideString;
var
  zn, lensou, tstart, tend: integer;
begin
  lensou := Length(tstr);

  tstart := 0;
  while tstart < lensou do
  begin
    zn := Ord(tstr[tstart + 1]);
    if (zn <> $20) and (zn <> $09) and (zn <> $0d) and (zn <> $0a) and (zn <> $0) then
      break;
    Inc(tstart);
  end;
  if tstart >= lensou then
  begin
    result := '';
    exit;
  end;

  tend := lensou - 1;
  while tend >= 0 do
  begin
    zn := Ord(tstr[tend + 1]);
    if (zn <> $20) and (zn <> $09) and (zn <> $0d) and (zn <> $0a) and (zn <> $0) then
      break;
    Dec(tend);
  end;
  if tend < tstart then
  begin
    result := '';
    exit;
  end;

  SetLength(result, tend - tstart + 1);
  CopyMemory(PWideChar(result), PAdd(PWideChar(tstr), tstart * 2), (tend - tstart + 1) * 2);
end;

function UpperCaseEx(tstr: WideString): WideString;
var
  tlen: integer;
begin
  result := tstr;
  tlen := Length(result);
  if tlen > 0 then
    CharUpperBuffW(PWideChar(result), tlen);
end;

function LowerCaseEx(tstr: WideString): WideString;
var
  tlen: integer;
begin
  result := tstr;
  tlen := Length(result);
  if tlen > 0 then
    CharLowerBuffW(PWideChar(result), tlen);
end;

function TagSkipEC(tstr: PWideChar; tstrlen: integer): integer;
var
  i: integer;
begin
  result := 0;
  if (tstrlen < 2) or (tstr[0] <> '<') then
    exit;
  if tstr[1] = '<' then
  begin
    result := 1;
    exit;
  end;
  i := 1;
  while i < tstrlen do
    if tstr[i] = '>' then
      break
    else
      Inc(i);
  if i >= tstrlen then
    exit;
  result := i + 1;
end;

function ComparerStrEC(s1, s2: PWideChar): integer;
label
  l1, l2, l3, l4, lend;
asm
         PUSH    ESI
         PUSH    EDI
         PUSH    EBX
         PUSH    EDX

         MOV     ESI,s1
         MOV     EDI,s2
         TEST    ESI,ESI
         JNZ     l1
         MOV     EAX,-1
         TEST    EDI,EDI
         JNZ     lend
         XOR     EAX,EAX
         JMP     lend

         l1: TEST    EDI,EDI
         JNZ     l2
         MOV     EAX,1
         JMP     lend

         l2: MOV     BX,[ESI]
         MOV     DX,[EDI]
         ADD     ESI,2
         ADD     EDI,2
         CMP     BX,DX
         JNZ     l3
         XOR     EAX,EAX
         TEST    DX,DX
         JNZ     l2
         JMP     lend

         l3: MOV     EAX,1
         JA      l4
         MOV     EAX,-1
         l4:
         //    test    bx,bx
         //    jz      lend
         //    test    dx,dx
         //    jz      lend
         //    jmp     l2

         lend:
         POP     EDX
         POP     EBX
         POP     EDI
         POP     ESI
         MOV     Result,EAX
end;

function CmpStrFirstEC(ssou, ssub: WideString): boolean;
var
  lssou, lssub: integer;
begin
  lssou := Length(ssou);
  lssub := Length(ssub);
  if lssou < lssub then
  begin
    result := false;
    exit;
  end;
  if (lssou < 1) and (lssub < 1) then
  begin
    result := true;
    exit;
  end;

  result := CompareMem(PWideChar(ssou), PWideChar(ssub), lssub * 2);
end;

function FindSubstring(ssou, ssub: WideString; sme: integer = 0): integer; // -1 not found
var
  lssou, lssub: integer;
begin
  lssou := Length(ssou);
  lssub := Length(ssub);
  if (lssou - sme) < lssub then
  begin
    result := -1;
    exit;
  end;
  if (lssou < 1) and (lssub < 1) then
  begin
    result := -1;
    exit;
  end;

  while sme <= (lssou - lssub) do
  begin
    if CompareMem(PWideChar(DWORD(ssou) + DWORD(sme shl 1)), PWideChar(ssub), lssub * 2) then
    begin
      result := sme;
      exit;
    end;
    Inc(sme);
  end;
  result := -1;
end;

function File_Name(path: WideString): WideString;
var
  cnt: integer;
begin
  cnt := GetCountParEC(path, '\/');
  result := GetStrParEC(path, cnt - 1, '\/');
  cnt := GetCountParEC(result, '.');
  if cnt > 1 then
    result := GetStrParEC(result, 0, cnt - 2, '.');
end;

function File_Ext(path: WideString): WideString;
var
  cnt: integer;
begin
  cnt := GetCountParEC(path, '\/');
  result := GetStrParEC(path, cnt - 1, '\/');
  cnt := GetCountParEC(result, '.');
  if cnt > 1 then
    result := GetStrParEC(result, cnt - 1, '.')
  else
    result := '';
end;

function File_Path(path: WideString): WideString;
var
  cnt: integer;
begin
  cnt := GetCountParEC(path, '\/');
  if cnt < 1 then
  begin
    result := '';
    exit;
  end;
  result := GetStrParEC(path, 0, cnt - 2, '\/');
end;

end.