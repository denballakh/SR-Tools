unit EC_Mem;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils;

function AllocEC(size:integer):Pointer;
function AllocClearEC(size:integer):Pointer;
function ReAllocEC(buf:Pointer; size:integer):Pointer;
function ReAllocREC(buf:Pointer; size:integer):Pointer;
procedure FreeEC(buf:Pointer);

function PAdd(buf:Pointer; zn:integer):Pointer; cdecl;
procedure PSet(buf:Pointer; zn:BYTE); overload; cdecl;
procedure PSet(buf:Pointer; zn:AnsiChar); overload; cdecl;
procedure PSet(buf:Pointer; zn:WideChar); overload; cdecl;
procedure PSet(buf:Pointer; zn:WORD); overload; cdecl;
procedure PSet(buf:Pointer; zn:smallint); overload; cdecl;
procedure PSet(buf:Pointer; zn:DWORD); overload; cdecl;
procedure PSet(buf:Pointer; zn:integer); overload; cdecl;
procedure PSet(buf:Pointer; zn:single); overload; cdecl;
procedure PSet(buf:Pointer; zn:double); overload; cdecl;

function PGetBYTE(buf:Pointer):BYTE; cdecl;
function PGetAnsiChar(buf:Pointer):AnsiChar; cdecl;
function PGetWideChar(buf:Pointer):WideChar; cdecl;
function PGetWORD(buf:Pointer):WORD; cdecl;
function PGetSmallint(buf:Pointer):smallint; cdecl;
function PGetDWORD(buf:Pointer):DWORD; cdecl;
function PGetInteger(buf:Pointer):integer; cdecl;
function PGetSingle(buf:Pointer):single; cdecl;
function PGetDouble(buf:Pointer):double; cdecl;

implementation

function AllocEC(size:integer):Pointer;
var
    buf:Pointer;
begin
    buf:=HeapAlloc(GetProcessHeap(),0,size);
	if buf=nil then raise Exception.Create('AllocEC. size=' + IntToStr(size));
	Result:=buf;
end;

function AllocClearEC(size:integer):Pointer;
var
    buf:Pointer;
begin
    buf:=HeapAlloc(GetProcessHeap(),$08,size);
	if buf=nil then raise Exception.Create('AllocClearEC. size=' + IntToStr(size));
	Result:=buf;
end;

function ReAllocEC(buf:Pointer; size:integer):Pointer;
begin
    buf:=HeapReAlloc(GetProcessHeap(),0,buf,size);
	if buf=nil then raise Exception.Create('ReAllocEC. size=' + IntToStr(size));
	Result:=buf;
end;

function ReAllocREC(buf:Pointer; size:integer):Pointer;
begin
	if (size<=0) and (buf<>nil) then begin
		HeapFree(GetProcessHeap(),0,buf);
		buf:=nil;
	end else if size<=0 then begin
		buf:=nil;
	end else if (size>0) and (buf<>nil) then begin
        buf:=HeapReAlloc(GetProcessHeap(),0,buf,size);
		if buf=nil then raise Exception.Create('ReAllocREC. size=' + IntToStr(size));
	end else begin
        buf:=HeapAlloc(GetProcessHeap(),0,size);
		if buf=nil then raise Exception.Create('ReAllocREC. size=' + IntToStr(size));
	end;
	Result:=buf;
end;

procedure FreeEC(buf:Pointer);
begin
	HeapFree(GetProcessHeap(),0,buf);
end;

function PAdd(buf:Pointer; zn:integer):Pointer;
asm
    mov eax,buf
    add eax,zn
end;

procedure PSet(buf:Pointer; zn:BYTE);
asm
    mov edx,buf
    mov al,zn
    mov [edx],al
end;

procedure PSet(buf:Pointer; zn:AnsiChar);
asm
    mov edx,buf
    mov al,zn
    mov [edx],al
end;

procedure PSet(buf:Pointer; zn:WideChar);
asm
    mov edx,buf
    mov ax,zn
    mov [edx],ax
end;

procedure PSet(buf:Pointer; zn:WORD);
asm
    mov edx,buf
    mov ax,zn
    mov [edx],ax
end;

procedure PSet(buf:Pointer; zn:smallint);
asm
    mov edx,buf
    mov ax,zn
    mov [edx],ax
end;

procedure PSet(buf:Pointer; zn:DWORD);
asm
    mov edx,buf
    mov eax,zn
    mov [edx],eax
end;

procedure PSet(buf:Pointer; zn:integer);
asm
    mov edx,buf
    mov eax,zn
    mov [edx],eax
end;

procedure PSet(buf:Pointer; zn:single);
asm
    mov edx,buf
    mov eax,zn
    mov [edx],eax
end;

procedure PSet(buf:Pointer; zn:double);
asm
    push ebx
    mov ebx,buf
    lea edx,zn
    mov eax,[edx]
    mov [ebx],eax
    mov eax,[edx+4]
    mov [ebx+4],eax
    pop ebx
end;

function PGetBYTE(buf:Pointer):BYTE;
asm
    mov eax,buf
    mov al,[eax]
end;

function PGetAnsiChar(buf:Pointer):AnsiChar;
asm
    mov eax,buf
    mov al,[eax]
end;

function PGetWideChar(buf:Pointer):WideChar;
asm
    mov eax,buf
    mov ax,[eax]
end;

function PGetWORD(buf:Pointer):WORD;
asm
    mov eax,buf
    mov ax,[eax]
end;

function PGetSmallint(buf:Pointer):smallint;
asm
    mov eax,buf
    mov ax,[eax]
end;

function PGetDWORD(buf:Pointer):DWORD;
asm
    mov eax,buf
    mov eax,[eax]
end;

function PGetInteger(buf:Pointer):integer;
asm
    mov eax,buf
    mov eax,[eax]
end;

function PGetSingle(buf:Pointer):single;
asm
    mov eax,buf
    fld dword ptr [eax]
end;

function PGetDouble(buf:Pointer):double;
asm
    mov eax,buf
    fld qword ptr [eax]
end;

end.
