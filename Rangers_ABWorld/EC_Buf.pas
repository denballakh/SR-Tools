unit EC_Buf;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils, Math, EC_File, EC_Mem;

type
  TBufEC = class(TObject)
  public
    m_Len: integer;
    m_Max: integer;
    m_Sme: integer;
    m_Buf: Pointer;
    m_Add: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure SetLenData(lendata: integer);
    property Buf: Pointer read m_Buf;
    property Len: integer read m_Len write SetLenData;

    function TestStart: boolean;
    function TestEnd: boolean;

    procedure BPointerAdd(zn: integer);
    procedure BPointerSet(zn: integer);
    property BPointer: integer read m_Sme write BPointerSet;

  private
    procedure TestAddLenBuf(addlen: integer); overload;
    procedure TestAddLenBuf(sme, addlen: integer); overload;
    procedure TestGet(len: integer); overload;
    procedure TestGet(sme, len: integer); overload;

  public
    procedure S(sme: integer; b: Pointer; len: integer); overload;
    procedure S(sme: integer; str: ansistring); overload;
    procedure S(sme: integer; str: WideString); overload;
    procedure SN0(sme: integer; str: ansistring); overload;
    procedure SN0(sme: integer; str: WideString); overload;
    procedure S(sme: integer; zn: byte); overload;
    procedure S(sme: integer; zn: AnsiChar); overload;
    procedure S(sme: integer; zn: widechar); overload;
    procedure S(sme: integer; zn: word); overload;
    procedure S(sme: integer; zn: smallint); overload;
    procedure S(sme: integer; zn: DWORD); overload;
    procedure S(sme: integer; zn: integer); overload;
    procedure S(sme: integer; zn: single); overload;
    procedure S(sme: integer; zn: double); overload;

    procedure Add(b: Pointer; len: integer); overload;
    procedure Add(str: ansistring); overload;
    procedure Add(str: WideString); overload;
    procedure AddN0(str: ansistring); overload;
    procedure AddN0(str: WideString); overload;
    procedure Add(zn: byte); overload;
    procedure Add(zn: AnsiChar); overload;
    procedure Add(zn: widechar); overload;
    procedure Add(zn: word); overload;
    procedure Add(zn: smallint); overload;
    procedure Add(zn: DWORD); overload;
    procedure Add(zn: integer); overload;
    procedure Add(zn: single); overload;
    procedure Add(zn: double); overload;

    procedure AddBYTE(zn: byte); overload;
    procedure AddWORD(zn: word); overload;
    procedure AddDWORD(zn: DWORD); overload;
    procedure AddInteger(zn: integer); overload;
    procedure AddSingle(zn: single); overload;
    procedure AddDouble(zn: double); overload;
    procedure AddBoolean(zn: boolean); overload;
    procedure AddBuf(zn: TBufEC); overload;

    function Get(sme: integer; b: Pointer; len: integer): Pointer; overload;
    function Get(sme: integer; s: PAnsiChar): PAnsiChar; overload;
    function Get(sme: integer; s: PWideChar): PWideChar; overload;
    function GetBYTE(sme: integer): byte; overload;
    function GetAnsiChar(sme: integer): AnsiChar; overload;
    function GetWideChar(sme: integer): widechar; overload;
    function GetWORD(sme: integer): word; overload;
    function GetSmallint(sme: integer): smallint; overload;
    function GetDWORD(sme: integer): DWORD; overload;
    function GetInteger(sme: integer): integer; overload;
    function GetSingle(sme: integer): single; overload;
    function GetDouble(sme: integer): double; overload;
    function GetBoolean(sme: integer): boolean; overload;

    function Get(b: Pointer; len: integer): Pointer; overload;
    function Get(s: PAnsiChar): PAnsiChar; overload;
    function Get(s: PWideChar): PWideChar; overload;
    function GetBYTE: byte; overload;
    function GetAnsiChar: AnsiChar; overload;
    function GetWideChar: widechar; overload;
    function GetWORD: word; overload;
    function GetSmallint: smallint; overload;
    function GetDWORD: DWORD; overload;
    function GetInteger: integer; overload;
    function GetSingle: single; overload;
    function GetDouble: double; overload;
    function GetBoolean: boolean; overload;
    procedure GetBuf(tbuf: TBufEC); overload;

    function GetLenAnsiStr: integer; overload;
    function GetLenAnsiStr(sme: integer): integer; overload;
    function GetLenWideStr: integer; overload;
    function GetLenWideStr(sme: integer): integer; overload;

    function GetLenAnsiTextStr: integer; overload;
    function GetLenAnsiTextStr(sme: integer): integer; overload;
    function GetLenWideTextStr: integer; overload;
    function GetLenWideTextStr(sme: integer): integer; overload;

    function GetAnsiTextStr(s: PAnsiChar): PAnsiChar; overload;
    function GetAnsiTextStr(sme: integer; s: PAnsiChar): PAnsiChar; overload;
    function GetAnsiTextStr: ansistring; overload;
    function GetAnsiStr: ansistring; overload;

    function GetWideTextStr(s: PWideChar): PWideChar; overload;
    function GetWideTextStr(sme: integer; s: PWideChar): PWideChar; overload;
    function GetWideTextStr: WideString; overload;
    function GetWideStr: WideString; overload;

    function Compress(fSpeed: boolean = false): boolean;
    function UnCompress: boolean;

    procedure LoadFromFile(fa: TFileEC; plen: integer); overload;
    procedure LoadFromFile(fa: TFileEC); overload;
    procedure LoadFromFile(filename: PChar); overload;

    procedure SaveInFile(fa: TFileEC; plen: integer); overload;
    procedure SaveInFile(fa: TFileEC); overload;
    procedure SaveInFile(filename: PChar); overload;
  end;

implementation

function OKGF_ZLib_Compress(desbuf: Pointer; soubuf: Pointer; len_sou_and_des_buf: DWORD; fSpeed: integer = 0): DWORD;
  cdecl; external 'okgf.dll' Name 'OKGF_ZLib_Compress';
function OKGF_ZLib_UnCompress(desbuf: Pointer; lendesbuf: DWORD; soubuf: Pointer; lensoubuf: DWORD): DWORD;
  cdecl; external 'okgf.dll' Name 'OKGF_ZLib_UnCompress';

constructor TBufEC.Create;
begin
  inherited Create;
  m_Add := 256;
end;

destructor TBufEC.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TBufEC.Clear;
begin
  if m_Buf <> nil then
  begin
    FreeEC(Buf);
    m_Buf := nil;
  end;
  m_Len := 0;
  m_Max := 0;
  m_Sme := 0;
end;

procedure TBufEC.SetLenData(lendata: integer);
begin
  if lendata < 1 then
    Clear()
  else
  begin
    m_Len := lendata;
    if m_Len > m_Max then
    begin
      m_Max := lendata + m_Add;
      m_Buf := ReAllocREC(m_Buf, m_Max);
    end;
    if m_Sme > m_Len then
      m_Sme := m_Len;
  end;
end;

function TBufEC.TestStart: boolean;
begin
  if m_Sme = 0 then
    result := true
  else
    result := false;
end;

function TBufEC.TestEnd: boolean;
begin
  if m_Sme >= m_Len then
    result := true
  else
    result := false;
end;

procedure TBufEC.BPointerAdd(zn: integer);
begin
  if (m_Sme + zn < 0) or (m_Sme + zn > m_Len) then
    raise Exception.Create('TBufEC.PointerAdd. zn=' + IntToStr(zn));
  m_Sme := m_Sme + zn;
end;

procedure TBufEC.BPointerSet(zn: integer);
begin
  if (zn < 0) or (zn > m_Len) then
    raise Exception.Create('TBufEC.PointerSet. zn=' + IntToStr(zn));
  m_Sme := zn;
end;

procedure TBufEC.TestAddLenBuf(addlen: integer);
begin
  if addlen < 1 then
    raise Exception.Create('TBufEC.TestAddLenBuf. addlen=' + IntToStr(addlen));
  if m_Sme + addlen > m_Len then
  begin
    m_Len := m_Sme + addlen;
    if m_Len > m_Max then
    begin
      m_Max := m_Len + m_Add;
      m_Buf := ReAllocREC(m_Buf, m_Max);
    end;
  end;
end;

procedure TBufEC.TestAddLenBuf(sme, addlen: integer);
begin
  if (addlen < 1) or (sme < 0) or (sme > m_Len) then
    raise Exception.Create('TBufEC.TestAddLenBuf. sme=' + IntToStr(sme) + ' addlen=' + IntToStr(addlen));
  if sme + addlen > m_Len then
  begin
    m_Len := sme + addlen;
    if m_Len > m_Max then
    begin
      m_Max := m_Len + m_Add;
      m_Buf := ReAllocREC(m_Buf, m_Max);
    end;
  end;
end;

procedure TBufEC.TestGet(len: integer);
begin
  if (len < 1) or ((m_Sme + len) > m_Len) then
    raise Exception.Create('TBufEC.TestGet. len=' + IntToStr(len));
end;

procedure TBufEC.TestGet(sme, len: integer);
begin
  if (len < 1) or ((sme + len) > m_Len) then
    raise Exception.Create('TBufEC.TestGet. sme=' + IntToStr(sme) + ' len=' + IntToStr(len));
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBufEC.S(sme: integer; b: Pointer; len: integer);
begin
  TestAddLenBuf(sme, len);
  CopyMemory(PAdd(Buf, sme), b, len);
end;

procedure TBufEC.S(sme: integer; str: ansistring);
var
  len: integer;
begin
  len := Length(str);
  TestAddLenBuf(sme, len + 1);
  CopyMemory(PAdd(Buf, sme), PAnsiChar(str), len + 1);
end;

procedure TBufEC.S(sme: integer; str: WideString);
var
  len: integer;
begin
  len := Length(str) * 2;
  TestAddLenBuf(sme, len + 2);
  CopyMemory(PAdd(Buf, sme), PWideChar(str), len + 2);
end;

procedure TBufEC.SN0(sme: integer; str: ansistring);
var
  len: integer;
begin
  len := Length(str);
  TestAddLenBuf(sme, len);
  CopyMemory(PAdd(Buf, sme), PAnsiChar(str), len);
end;

procedure TBufEC.SN0(sme: integer; str: WideString);
var
  len: integer;
begin
  len := Length(str) * 2;
  TestAddLenBuf(sme, len);
  CopyMemory(PAdd(Buf, sme), PWideChar(str), len);
end;

procedure TBufEC.S(sme: integer; zn: byte);
begin
  TestAddLenBuf(sme, sizeof(byte));
  PSet(PAdd(Buf, sme), zn);
end;

procedure TBufEC.S(sme: integer; zn: AnsiChar);
begin
  TestAddLenBuf(sme, sizeof(AnsiChar));
  PSet(PAdd(Buf, sme), zn);
end;

procedure TBufEC.S(sme: integer; zn: widechar);
begin
  TestAddLenBuf(sme, sizeof(widechar));
  PSet(PAdd(Buf, sme), zn);
end;

procedure TBufEC.S(sme: integer; zn: word);
begin
  TestAddLenBuf(sme, sizeof(word));
  PSet(PAdd(Buf, sme), zn);
end;

procedure TBufEC.S(sme: integer; zn: smallint);
begin
  TestAddLenBuf(sme, sizeof(smallint));
  PSet(PAdd(Buf, sme), zn);
end;

procedure TBufEC.S(sme: integer; zn: DWORD);
begin
  TestAddLenBuf(sme, sizeof(DWORD));
  PSet(PAdd(Buf, sme), zn);
end;

procedure TBufEC.S(sme: integer; zn: integer);
begin
  TestAddLenBuf(sme, sizeof(integer));
  PSet(PAdd(Buf, sme), zn);
end;

procedure TBufEC.S(sme: integer; zn: single);
begin
  TestAddLenBuf(sme, sizeof(single));
  PSet(PAdd(Buf, sme), zn);
end;

procedure TBufEC.S(sme: integer; zn: double);
begin
  TestAddLenBuf(sme, sizeof(double));
  PSet(PAdd(Buf, sme), zn);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBufEC.Add(b: Pointer; len: integer);
begin
  TestAddLenBuf(len);
  CopyMemory(PAdd(Buf, m_Sme), b, len);
  m_Sme := m_Sme + len;
end;

procedure TBufEC.Add(str: ansistring);
var
  len: integer;
begin
  len := Length(str);
  TestAddLenBuf(len + 1);
  CopyMemory(PAdd(Buf, m_Sme), PAnsiChar(str), len + 1);
  m_Sme := m_Sme + len + 1;
end;

procedure TBufEC.Add(str: WideString);
var
  len: integer;
begin
  len := Length(str) * 2;
  TestAddLenBuf(len + 2);
  CopyMemory(PAdd(Buf, m_Sme), PWideChar(str), len + 2);
  m_Sme := m_Sme + len + 2;
end;

procedure TBufEC.AddN0(str: ansistring);
var
  len: integer;
begin
  len := Length(str);
  if len > 0 then
  begin
    TestAddLenBuf(len);
    CopyMemory(PAdd(Buf, m_Sme), PAnsiChar(str), len);
    m_Sme := m_Sme + len;
  end;
end;

procedure TBufEC.AddN0(str: WideString);
var
  len: integer;
begin
  len := Length(str) * 2;
  if len > 0 then
  begin
    TestAddLenBuf(len);
    CopyMemory(PAdd(Buf, m_Sme), PWideChar(str), len);
    m_Sme := m_Sme + len;
  end;
end;

procedure TBufEC.Add(zn: byte);
begin
  TestAddLenBuf(sizeof(byte));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(byte);
end;

procedure TBufEC.Add(zn: AnsiChar);
begin
  TestAddLenBuf(sizeof(AnsiChar));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(AnsiChar);
end;

procedure TBufEC.Add(zn: widechar);
begin
  TestAddLenBuf(sizeof(widechar));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(widechar);
end;

procedure TBufEC.Add(zn: word);
begin
  TestAddLenBuf(sizeof(word));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(word);
end;

procedure TBufEC.Add(zn: smallint);
begin
  TestAddLenBuf(sizeof(smallint));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(smallint);
end;

procedure TBufEC.Add(zn: DWORD);
begin
  TestAddLenBuf(sizeof(DWORD));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(DWORD);
end;

procedure TBufEC.Add(zn: integer);
begin
  TestAddLenBuf(sizeof(integer));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(integer);
end;

procedure TBufEC.Add(zn: single);
begin
  TestAddLenBuf(sizeof(single));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(single);
end;

procedure TBufEC.Add(zn: double);
begin
  TestAddLenBuf(sizeof(double));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(double);
end;

procedure TBufEC.AddBYTE(zn: byte);
begin
  TestAddLenBuf(sizeof(byte));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(byte);
end;

procedure TBufEC.AddWORD(zn: word);
begin
  TestAddLenBuf(sizeof(word));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(word);
end;

procedure TBufEC.AddDWORD(zn: DWORD);
begin
  TestAddLenBuf(sizeof(DWORD));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(DWORD);
end;

procedure TBufEC.AddInteger(zn: integer);
begin
  TestAddLenBuf(sizeof(integer));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(integer);
end;

procedure TBufEC.AddSingle(zn: single);
begin
  TestAddLenBuf(sizeof(single));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(single);
end;

procedure TBufEC.AddDouble(zn: double);
begin
  TestAddLenBuf(sizeof(double));
  PSet(PAdd(Buf, m_Sme), zn);
  m_Sme := m_Sme + sizeof(double);
end;

procedure TBufEC.AddBoolean(zn: boolean);
begin
  TestAddLenBuf(sizeof(byte));
  PSet(PAdd(Buf, m_Sme), byte(zn));
  m_Sme := m_Sme + sizeof(byte);
end;

procedure TBufEC.AddBuf(zn: TBufEC);
begin
  AddDWORD(zn.Len);
  if zn.Len > 0 then
    Add(zn.Buf, zn.Len);
end;

////////////////////////////////////////////////////////////////////////////////
function TBufEC.Get(sme: integer; b: Pointer; len: integer): Pointer;
begin
  TestGet(sme, len);
  CopyMemory(b, PAdd(Buf, sme), len);
  result := b;
end;

function TBufEC.Get(sme: integer; s: PAnsiChar): PAnsiChar;
var
  len: integer;
begin
  len := GetLenAnsiStr(sme);
  if len > 0 then
    CopyMemory(s, PAdd(m_Buf, sme), len + 1)
  else
    s[0] := char(0);
  result := s;
end;

function TBufEC.Get(sme: integer; s: PWideChar): PWideChar;
var
  len: integer;
begin
  len := GetLenWideStr(sme);
  if len > 0 then
    CopyMemory(s, PAdd(m_Buf, sme), len * 2 + 2)
  else
    s[0] := widechar(0);
  result := s;
end;

function TBufEC.GetBYTE(sme: integer): byte;
begin
  TestGet(sme, sizeof(byte));
  result := PGetBYTE(PAdd(m_Buf, sme));
end;

function TBufEC.GetAnsiChar(sme: integer): AnsiChar;
begin
  TestGet(sme, sizeof(AnsiChar));
  result := PGetAnsiChar(PAdd(m_Buf, sme));
end;

function TBufEC.GetWideChar(sme: integer): widechar;
begin
  TestGet(sme, sizeof(widechar));
  result := PGetWideChar(PAdd(m_Buf, sme));
end;

function TBufEC.GetWORD(sme: integer): word;
begin
  TestGet(sme, sizeof(word));
  result := PGetWORD(PAdd(m_Buf, sme));
end;

function TBufEC.GetSmallint(sme: integer): smallint;
begin
  TestGet(sme, sizeof(smallint));
  result := PGetSmallint(PAdd(m_Buf, sme));
end;

function TBufEC.GetDWORD(sme: integer): DWORD;
begin
  TestGet(sme, sizeof(DWORD));
  result := PGetDWORD(PAdd(m_Buf, sme));
end;

function TBufEC.GetInteger(sme: integer): integer;
begin
  TestGet(sme, sizeof(integer));
  result := PGetInteger(PAdd(m_Buf, sme));
end;

function TBufEC.GetSingle(sme: integer): single;
begin
  TestGet(sme, sizeof(single));
  result := PGetSingle(PAdd(m_Buf, sme));
end;

function TBufEC.GetDouble(sme: integer): double;
begin
  TestGet(sme, sizeof(double));
  result := PGetDouble(PAdd(m_Buf, sme));
end;

function TBufEC.GetBoolean(sme: integer): boolean;
begin
  TestGet(sme, sizeof(byte));
  result := boolean(PGetBYTE(PAdd(m_Buf, sme)));
end;

////////////////////////////////////////////////////////////////////////////////
function TBufEC.Get(b: Pointer; len: integer): Pointer;
begin
  TestGet(len);
  CopyMemory(b, PAdd(Buf, m_Sme), len);
  m_Sme := m_Sme + len;
  result := b;
end;

function TBufEC.Get(s: PAnsiChar): PAnsiChar;
var
  len: integer;
begin
  len := GetLenAnsiStr(m_Sme);
  if len > 0 then
  begin
    TestGet(len + 1);
    CopyMemory(s, PAdd(m_Buf, m_Sme), len + 1);
    m_Sme := m_Sme + len + 1;
  end
  else
    s[0] := char(0);
  result := s;
end;

function TBufEC.Get(s: PWideChar): PWideChar;
var
  len: integer;
begin
  len := GetLenWideStr(m_Sme);
  if len > 0 then
  begin
    TestGet(len * 2 + 2);
    CopyMemory(s, PAdd(m_Buf, m_Sme), len * 2 + 2);
    m_Sme := m_Sme + len * 2 + 2;
  end
  else
  begin
    m_Sme := m_Sme + 2;
    s[0] := widechar(0);
  end;
  result := s;
end;

function TBufEC.GetBYTE: byte;
begin
  TestGet(sizeof(byte));
  //    Result:=PGetBYTE(PAdd(m_Buf,m_Sme));
  //    m_Sme:=m_Sme+sizeof(BYTE);

  asm
           PUSH    EAX
           PUSH    EBX
           PUSH    EDI

           MOV     EBX,self
           MOV     EAX,TBufEC(EBX).m_Sme
           MOV     EDI,TBufEC(EBX).m_Buf
           INC     TBufEC(EBX).m_Sme
           MOV     AL,[EDI+EAX]
           MOV     Result,AL

           POP     EDI
           POP     EBX
           POP     EAX
  end;

end;

function TBufEC.GetAnsiChar: AnsiChar;
begin
  TestGet(sizeof(AnsiChar));
  result := PGetAnsiChar(PAdd(m_Buf, m_Sme));
  m_Sme := m_Sme + sizeof(AnsiChar);
end;

function TBufEC.GetWideChar: widechar;
begin
  TestGet(sizeof(widechar));
  result := PGetWideChar(PAdd(m_Buf, m_Sme));
  m_Sme := m_Sme + sizeof(widechar);
end;

function TBufEC.GetWORD: word;
begin
  TestGet(sizeof(word));
  //    Result:=PGetWORD(PAdd(m_Buf,m_Sme));
  //    m_Sme:=m_Sme+sizeof(WORD);
  asm
           PUSH    EAX
           PUSH    EBX
           PUSH    EDI

           MOV     EBX,self
           MOV     EAX,TBufEC(EBX).m_Sme
           MOV     EDI,TBufEC(EBX).m_Buf
           ADD     TBufEC(EBX).m_Sme,2
           MOV     AX,[EDI+EAX]
           MOV     Result,AX

           POP     EDI
           POP     EBX
           POP     EAX
  end;
end;

function TBufEC.GetSmallint: smallint;
begin
  TestGet(sizeof(smallint));
  result := PGetSmallint(PAdd(m_Buf, m_Sme));
  m_Sme := m_Sme + sizeof(smallint);
end;

function TBufEC.GetDWORD: DWORD;
begin
  TestGet(sizeof(DWORD));
  //    Result:=PGetDWORD(PAdd(m_Buf,m_Sme));
  //    m_Sme:=m_Sme+sizeof(DWORD);
  asm
           PUSH    EAX
           PUSH    EBX
           PUSH    EDI

           MOV     EBX,self
           MOV     EAX,TBufEC(EBX).m_Sme
           MOV     EDI,TBufEC(EBX).m_Buf
           ADD     TBufEC(EBX).m_Sme,4
           MOV     EAX,[EDI+EAX]
           MOV     Result,EAX

           POP     EDI
           POP     EBX
           POP     EAX
  end;
end;

function TBufEC.GetInteger: integer;
begin
  TestGet(sizeof(integer));
  result := PGetInteger(PAdd(m_Buf, m_Sme));
  m_Sme := m_Sme + sizeof(integer);
end;

function TBufEC.GetSingle: single;
begin
  TestGet(sizeof(single));
  //    Result:=PGetSingle(PAdd(m_Buf,m_Sme));
  //    m_Sme:=m_Sme+sizeof(single);
  asm
           PUSH    EAX
           PUSH    EBX
           PUSH    EDI

           MOV     EBX,self
           MOV     EAX,TBufEC(EBX).m_Sme
           MOV     EDI,TBufEC(EBX).m_Buf
           ADD     TBufEC(EBX).m_Sme,4
           MOV     EAX,[EDI+EAX]
           MOV     Result,EAX

           POP     EDI
           POP     EBX
           POP     EAX
  end;
end;

function TBufEC.GetDouble: double;
begin
  TestGet(sizeof(double));
  result := PGetDouble(PAdd(m_Buf, m_Sme));
  m_Sme := m_Sme + sizeof(double);
end;

function TBufEC.GetBoolean: boolean;
begin
  TestGet(sizeof(byte));
  //    Result:=Boolean(PGetBYTE(PAdd(m_Buf,m_Sme)));
  //    m_Sme:=m_Sme+sizeof(BYTE);
  asm
           PUSH    EAX
           PUSH    EBX
           PUSH    EDI

           MOV     EBX,self
           MOV     EAX,TBufEC(EBX).m_Sme
           MOV     EDI,TBufEC(EBX).m_Buf
           INC     TBufEC(EBX).m_Sme
           MOV     AL,[EDI+EAX]
           MOV     Result,AL

           POP     EDI
           POP     EBX
           POP     EAX
  end;
end;

procedure TBufEC.GetBuf(tbuf: TBufEC);
var
  tlen: integer;
begin
  tlen := GetDWORD;
  tbuf.Len := Len;
  if len > 0 then
    Get(tbuf.Buf, tlen);
end;

////////////////////////////////////////////////////////////////////////////////
function TBufEC.GetLenAnsiStr: integer;
begin
  result := GetLenAnsiStr(m_Sme);
end;

function TBufEC.GetLenAnsiStr(sme: integer): integer;
var
  len, i: integer;
begin
  i := sme;
  len := 0;
  while i < m_Len do
  begin
    if PGetBYTE(PAdd(m_Buf, i)) = 0 then
    begin
      result := len;
      exit;
    end;
    Inc(len);
    Inc(i);
  end;
  result := len;
end;

function TBufEC.GetLenWideStr: integer;
begin
  result := GetLenWideStr(m_Sme);
end;

function TBufEC.GetLenWideStr(sme: integer): integer;
var
  len, i: integer;
begin
  i := sme;
  len := 0;
  while i + 1 < m_Len do
  begin
    if PGetWORD(PAdd(m_Buf, i)) = 0 then
    begin
      result := len;
      exit;
    end;
    Inc(len);
    Inc(i, 2);
  end;
  result := len;
end;

////////////////////////////////////////////////////////////////////////////////
function TBufEC.GetLenAnsiTextStr: integer;
begin
  result := GetLenAnsiTextStr(m_Sme);
end;

function TBufEC.GetLenAnsiTextStr(sme: integer): integer;
var
  len, i: integer;
  sim: byte;
begin
  i := sme;
  len := 0;
  while i < m_Len do
  begin
    sim := PGetBYTE(PAdd(m_Buf, i));
    if (sim = 0) or (sim = $0d) or (sim = $0a) then
    begin
      result := len;
      exit;
    end;
    Inc(len);
    Inc(i);
  end;
  result := len;
end;

function TBufEC.GetLenWideTextStr: integer;
begin
  result := GetLenWideTextStr(m_Sme);
end;

function TBufEC.GetLenWideTextStr(sme: integer): integer;
var
  len, i: integer;
  sim: word;
begin
  i := sme;
  len := 0;
  while i + 1 < m_Len do
  begin
    sim := PGetWORD(PAdd(m_Buf, i));
    if (sim = 0) or (sim = $0d) or (sim = $0a) then
    begin
      result := len;
      exit;
    end;
    Inc(len);
    Inc(i, 2);
  end;
  result := len;
end;

////////////////////////////////////////////////////////////////////////////////
function TBufEC.GetAnsiTextStr(s: PAnsiChar): PAnsiChar;
var
  len: integer;
  sim: byte;
begin
  len := GetLenAnsiTextStr;
  if len > 0 then
  begin
    CopyMemory(s, PAdd(m_Buf, m_Sme), len);
    s[len] := char(0);
    m_Sme := m_Sme + len;

  end
  else
    s[0] := char(0);
  if m_Sme < m_Len then
  begin
    sim := PGetByte(PAdd(m_Buf, m_Sme));
    if (sim = 0) or (sim = $0d) or (sim = $0a) then
      Inc(m_Sme);
    if m_Sme < m_Len then
    begin
      sim := PGetByte(PAdd(m_Buf, m_Sme));
      if (sim = 0) or (sim = $0d) or (sim = $0a) then
        Inc(m_Sme);
    end;
  end;
  result := s;
end;

function TBufEC.GetAnsiTextStr(sme: integer; s: PAnsiChar): PAnsiChar;
var
  len: integer;
begin
  len := GetLenAnsiTextStr(sme);
  if len > 0 then
  begin
    CopyMemory(s, PAdd(m_Buf, sme), len);
    s[len] := char(0);
  end
  else
    s[0] := char(0);
  result := s;
end;

function TBufEC.GetAnsiTextStr: ansistring;
var
  len: integer;
begin
  len := GetLenAnsiTextStr;
  if len > 0 then
  begin
    SetLength(result, len{+1});
    GetAnsiTextStr(PAnsiChar(result));
  end
  else
  begin
    SetLength(result, 2);
    GetAnsiTextStr(PAnsiChar(result));
    result := '';
  end;
end;

function TBufEC.GetAnsiStr: ansistring;
var
  len: integer;
begin
  len := GetLenAnsiStr;
  if len > 0 then
  begin
    SetLength(result, len{+1});
    Get(PAnsiChar(result));
  end
  else
  begin
    SetLength(result, 2);
    Get(PAnsiChar(result));
    result := '';
  end;
end;

function TBufEC.GetWideTextStr(s: PWideChar): PWideChar;
var
  len: integer;
  sim: word;
begin
  len := GetLenWideTextStr;
  if len > 0 then
  begin
    CopyMemory(s, PAdd(m_Buf, m_Sme), len * 2);
    s[len] := widechar(0);
    m_Sme := m_Sme + len * 2;

  end
  else
    s[0] := widechar(0);
  if m_Sme + 1 < m_Len then
  begin
    sim := PGetWORD(PAdd(m_Buf, m_Sme));
    if (sim = 0) or (sim = $0d) or (sim = $0a) then
      Inc(m_Sme, 2);
    if m_Sme + 1 < m_Len then
    begin
      sim := PGetWORD(PAdd(m_Buf, m_Sme));
      if (sim = 0) or (sim = $0d) or (sim = $0a) then
        Inc(m_Sme, 2);
    end;
  end;
  result := s;
end;

function TBufEC.GetWideTextStr(sme: integer; s: PWideChar): PWideChar;
var
  len: integer;
begin
  len := GetLenWideTextStr(sme);
  if len > 0 then
  begin
    CopyMemory(s, PAdd(m_Buf, sme), len * 2);
    s[len] := widechar(0);
  end
  else
    s[0] := widechar(0);
  result := s;
end;

function TBufEC.GetWideTextStr: WideString;
var
  len: integer;
begin
  len := GetLenWideTextStr;
  if len > 0 then
  begin
    SetLength(result, len{+1});
    GetWideTextStr(PWideChar(result));
  end
  else
  begin
    SetLength(result, 2);
    GetWideTextStr(PWideChar(result));
    result := '';
  end;
end;

function TBufEC.GetWideStr: WideString;
var
  len: integer;
begin
  len := GetLenWideStr;
  if len > 0 then
  begin
    SetLength(result, len{+1});
    Get(PWideChar(result));
    SetLength(result, len);
  end
  else
  begin
    SetLength(result, 1);
    Get(PWideChar(@len));
    SetLength(result, 0);
    result := '';
  end;
end;

function TBufEC.Compress(fSpeed: boolean = false): boolean;
var
  fs, tlen: integer;
  tbuf: ^byte;
begin
  fs := 0;
  if fSpeed = true then
    fs := 0;

  if m_Len < 8 then
  begin
    result := false;
    exit;
  end;
  tbuf := AllocEC(m_Len);
  tlen := OKGF_ZLib_Compress(tbuf, m_Buf, m_Len, fs);
  if tlen = 0 then
  begin
    FreeEC(tbuf);
    result := false;
    exit;
  end;
  FreeEC(m_Buf);
  m_Buf := tbuf;
  m_Len := tlen;
  m_Max := tlen;
  m_Sme := 0;
  result := true;
end;

function TBufEC.UnCompress: boolean;
var
  tlen: integer;
  tbuf: ^byte;
begin
  if m_Len < 8 then
  begin
    result := false;
    exit;
  end;
  tlen := OKGF_ZLib_UnCompress(nil, 0, m_Buf, m_Len);
  if tlen = 0 then
  begin
    result := false;
    exit;
  end;
  tbuf := AllocEC(tlen);
  tlen := OKGF_ZLib_UnCompress(tbuf, tlen, m_Buf, m_Len);
  if tlen = 0 then
  begin
    FreeEC(tbuf);
    result := false;
    exit;
  end;
  m_Buf := tbuf;
  m_Len := tlen;
  m_Max := tlen;
  m_Sme := 0;
  result := true;
end;
////////////////////////////////////////////////////////////////////////////////
{procedure TBufEC.LoadFromFile(fa:TFileEC; plen:integer);
begin
    Clear;
    fa.Open;
    try
        Len:=plen;
        fa.Read(m_Buf,len);
    finally
        fa.Close;
    end;
end;}

procedure TBufEC.LoadFromFile(fa: TFileEC; plen: integer);
var
  zlen: integer;
  zbuf: Pointer;
begin
  Clear;
  fa.Open;
  try
    Len := plen;
    zbuf := m_Buf;

    while plen > 0 do
    begin
      zlen := min(256 * 1024, plen);

      fa.read(zbuf, zlen);

      zbuf := PAdd(zbuf, zlen);
      plen := plen - zlen;
      if plen > 0 then
        Sleep(1);
    end;
  finally
    fa.Close;
  end;
end;

procedure TBufEC.LoadFromFile(fa: TFileEC);
var
  size: integer;
begin
  Clear;
  fa.Open;
  try
    size := fa.GetSize - fa.GetPointer;
    Len := size;
    fa.read(m_Buf, size);
  finally
    fa.Close;
  end;
end;

procedure TBufEC.LoadFromFile(filename: PChar);
var
  fa: TFileEC;
begin
  fa := TFileEC.Create;
  try
    fa.Init(filename);
    LoadFromFile(fa);
  finally
    fa.Free;
  end;
end;

procedure TBufEC.SaveInFile(fa: TFileEC; plen: integer);
begin
  fa.CreateNew;
  try
    fa.write(m_Buf, plen);
  finally
    fa.Close;
  end;
end;

procedure TBufEC.SaveInFile(fa: TFileEC);
begin
  fa.write(m_Buf, m_Len);
end;

procedure TBufEC.SaveInFile(filename: PChar);
var
  fa: TFileEC;
begin
  fa := TFileEC.Create;
  try
    fa.Init(filename);
    fa.CreateNew;
    SaveInFile(fa);
  finally
    fa.Free;
  end;
end;

end.