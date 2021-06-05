unit EC_Mem;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils;

function AllocEC(size: integer): Pointer;
function AllocClearEC(size: integer): Pointer;
function ReAllocEC(buf: Pointer; size: integer): Pointer;
function ReAllocREC(buf: Pointer; size: integer): Pointer;
procedure FreeEC(buf: Pointer);

function PAdd(buf: Pointer; zn: integer): Pointer; cdecl;
procedure PSet(buf: Pointer; zn: byte); overload; cdecl;
procedure PSet(buf: Pointer; zn: AnsiChar); overload; cdecl;
procedure PSet(buf: Pointer; zn: widechar); overload; cdecl;
procedure PSet(buf: Pointer; zn: word); overload; cdecl;
procedure PSet(buf: Pointer; zn: smallint); overload; cdecl;
procedure PSet(buf: Pointer; zn: DWORD); overload; cdecl;
procedure PSet(buf: Pointer; zn: integer); overload; cdecl;
procedure PSet(buf: Pointer; zn: single); overload; cdecl;
procedure PSet(buf: Pointer; zn: double); overload; cdecl;

function PGetBYTE(buf: Pointer): byte; cdecl;
function PGetAnsiChar(buf: Pointer): AnsiChar; cdecl;
function PGetWideChar(buf: Pointer): widechar; cdecl;
function PGetWORD(buf: Pointer): word; cdecl;
function PGetSmallint(buf: Pointer): smallint; cdecl;
function PGetDWORD(buf: Pointer): DWORD; cdecl;
function PGetInteger(buf: Pointer): integer; cdecl;
function PGetSingle(buf: Pointer): single; cdecl;
function PGetDouble(buf: Pointer): double; cdecl;

implementation

function AllocEC(size: integer): Pointer;
var
  buf: Pointer;
begin
  buf := HeapAlloc(GetProcessHeap(), 0, size);
  if buf = nil then
    raise Exception.Create('AllocEC. size=' + IntToStr(size));
  result := buf;
end;

function AllocClearEC(size: integer): Pointer;
var
  buf: Pointer;
begin
  buf := HeapAlloc(GetProcessHeap(), $08, size);
  if buf = nil then
    raise Exception.Create('AllocClearEC. size=' + IntToStr(size));
  result := buf;
end;

function ReAllocEC(buf: Pointer; size: integer): Pointer;
begin
  buf := HeapReAlloc(GetProcessHeap(), 0, buf, size);
  if buf = nil then
    raise Exception.Create('ReAllocEC. size=' + IntToStr(size));
  result := buf;
end;

function ReAllocREC(buf: Pointer; size: integer): Pointer;
begin
  if (size <= 0) and (buf <> nil) then
  begin
    HeapFree(GetProcessHeap(), 0, buf);
    buf := nil;
  end
  else if size <= 0 then
    buf := nil
  else if (size > 0) and (buf <> nil) then
  begin
    buf := HeapReAlloc(GetProcessHeap(), 0, buf, size);
    if buf = nil then
      raise Exception.Create('ReAllocREC. size=' + IntToStr(size));
  end
  else
  begin
    buf := HeapAlloc(GetProcessHeap(), 0, size);
    if buf = nil then
      raise Exception.Create('ReAllocREC. size=' + IntToStr(size));
  end;
  result := buf;
end;

procedure FreeEC(buf: Pointer);
begin
  HeapFree(GetProcessHeap(), 0, buf);
end;

function PAdd(buf: Pointer; zn: integer): Pointer;
asm
         MOV     EAX,buf
         ADD     EAX,zn
end;

procedure PSet(buf: Pointer; zn: byte);
asm
         MOV     EDX,buf
         MOV     AL,zn
         MOV     [EDX],AL
end;

procedure PSet(buf: Pointer; zn: AnsiChar);
asm
         MOV     EDX,buf
         MOV     AL,zn
         MOV     [EDX],AL
end;

procedure PSet(buf: Pointer; zn: widechar);
asm
         MOV     EDX,buf
         MOV     AX,zn
         MOV     [EDX],AX
end;

procedure PSet(buf: Pointer; zn: word);
asm
         MOV     EDX,buf
         MOV     AX,zn
         MOV     [EDX],AX
end;

procedure PSet(buf: Pointer; zn: smallint);
asm
         MOV     EDX,buf
         MOV     AX,zn
         MOV     [EDX],AX
end;

procedure PSet(buf: Pointer; zn: DWORD);
asm
         MOV     EDX,buf
         MOV     EAX,zn
         MOV     [EDX],EAX
end;

procedure PSet(buf: Pointer; zn: integer);
asm
         MOV     EDX,buf
         MOV     EAX,zn
         MOV     [EDX],EAX
end;

procedure PSet(buf: Pointer; zn: single);
asm
         MOV     EDX,buf
         MOV     EAX,zn
         MOV     [EDX],EAX
end;

procedure PSet(buf: Pointer; zn: double);
asm
         PUSH    EBX
         MOV     EBX,buf
         LEA     EDX,zn
         MOV     EAX,[EDX]
         MOV     [EBX],EAX
         MOV     EAX,[EDX+4]
         MOV     [EBX+4],EAX
         POP     EBX
end;

function PGetBYTE(buf: Pointer): byte;
asm
         MOV     EAX,buf
         MOV     AL,[EAX]
end;

function PGetAnsiChar(buf: Pointer): AnsiChar;
asm
         MOV     EAX,buf
         MOV     AL,[EAX]
end;

function PGetWideChar(buf: Pointer): widechar;
asm
         MOV     EAX,buf
         MOV     AX,[EAX]
end;

function PGetWORD(buf: Pointer): word;
asm
         MOV     EAX,buf
         MOV     AX,[EAX]
end;

function PGetSmallint(buf: Pointer): smallint;
asm
         MOV     EAX,buf
         MOV     AX,[EAX]
end;

function PGetDWORD(buf: Pointer): DWORD;
asm
         MOV     EAX,buf
         MOV     EAX,[EAX]
end;

function PGetInteger(buf: Pointer): integer;
asm
         MOV     EAX,buf
         MOV     EAX,[EAX]
end;

function PGetSingle(buf: Pointer): single;
asm
         MOV     EAX,buf
         FLD     dword ptr [EAX]
end;

function PGetDouble(buf: Pointer): double;
asm
         MOV     EAX,buf
         FLD     qword ptr [EAX]
end;

end.