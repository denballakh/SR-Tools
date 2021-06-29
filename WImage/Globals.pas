unit Globals;

interface

uses Math,Windows,GraphBuf;

procedure GlobalsInit;
function HTimer:int64;
function IsSelected(x,y:integer):boolean;

function RegUser_GetDWORD(path:WideString; name:WideString; bydef:DWORD):DWORD;
procedure RegUser_SetDWORD(path:WideString; name:WideString; zn:DWORD);

function RegUser_GetString(path:WideString; name:WideString; bydef:WideString):WideString;
procedure RegUser_SetString(path:WideString; name:WideString; zn:WideString);

procedure SFT(tstr:AnsiString);
procedure SFTne(tstr:AnsiString);

var
    RegUserPath:WideString='Software\dab\WImage';

GAlphaMulColor:Pointer;
GAlphaAddAlpha:Pointer;
GHTimerFreq:int64;

GImageSelectAll:boolean=true;
GImageSelectPos:TPoint;
GImageSelect:TGraphBuf;

implementation

uses EC_Mem;

var
GR_FL: TextFile;

procedure GlobalsInit;
var
    i,u:integer;
begin
    GAlphaMulColor:=AllocEC(256*256);
    GAlphaAddAlpha:=AllocEC(256*256);

    for i:=0 to 255 do begin
        for u:=0 to 255 do begin
            PSet(PAdd(GAlphaMulColor,i*256+u),BYTE(DWORD(Round(i*(u/255)))));
        end;
    end;
    for i:=0 to 255 do begin
        for u:=0 to 255 do begin
            PSet(PAdd(GAlphaAddAlpha,i*256+u),BYTE(DWORD(min(i+u,255))));
        end;
    end;

    GHTimerFreq:=0;
    QueryPerformanceFrequency(GHTimerFreq);

    AssignFile(GR_FL, 'c:\########.log');
    Rewrite(GR_FL);
    Writeln(GR_FL,'Start');
    CloseFile(GR_FL);
end;

function HTimer:int64;
begin
    QueryPerformanceCounter(Result);
end;

function IsSelected(x,y:integer):boolean;
begin
    if GImageSelectAll then begin Result:=true; Exit; end;
    if (x<GImageSelectPos.x) or (y<GImageSelectPos.y) or (x>=GImageSelectPos.x+GImageSelect.FLenX) or (y>=GImageSelectPos.y+GImageSelect.FLenY) then begin Result:=false; Exit; end;
    Result:=GImageSelect.PixelChannel(x-GImageSelectPos.x,y-GImageSelectPos.y,0)<>0;
end;

function RegUser_GetDWORD(path:WideString; name:WideString; bydef:DWORD):DWORD;
var
    kkey:HKEY;
    tip:DWORD;
    zn:DWORD;
    tsize:DWORD;
begin
    if RegOpenKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Result:=bydef;
        Exit;
    end;
    tsize:=4;
    if RegQueryValueExW(kkey,PWChar(name),nil,@tip,PByte(@zn),@tsize)<>ERROR_SUCCESS then begin
        Result:=bydef;
        RegCloseKey(kkey);
        Exit;
    end;
    if tip<>REG_DWORD then Result:=bydef
    else Result:=zn;
    RegCloseKey(kkey);
end;

procedure RegUser_SetDWORD(path:WideString; name:WideString; zn:DWORD);
var
    kkey:HKEY;
    dv:DWORD;
begin
    if RegCreateKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegSetValueExW(kkey,PWChar(name),0,REG_DWORD,@zn,4)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;
    RegCloseKey(kkey);
end;

function RegUser_GetString(path:WideString; name:WideString; bydef:WideString):WideString;
var
    kkey:HKEY;
    tip:DWORD;
    zn:Pointer;
    tsize:DWORD;
begin
    if RegOpenKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Result:=bydef;
        Exit;
    end;
    tsize:=2048;
    zn:=AllocEC(tsize);
    if RegQueryValueExW(kkey,PWChar(name),nil,@tip,PByte(zn),@tsize)<>ERROR_SUCCESS then begin
        Result:=bydef;
        RegCloseKey(kkey);
        FreeEC(zn);
        Exit;
    end;
    if tip<>REG_SZ then Result:=bydef
    else Result:=PWChar(zn);
    FreeEC(zn);
    RegCloseKey(kkey);
end;

procedure RegUser_SetString(path:WideString; name:WideString; zn:WideString);
var
    kkey:HKEY;
    dv:DWORD;
begin
    if RegCreateKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegSetValueExW(kkey,PWChar(name),0,REG_SZ,PWChar(zn),Length(zn)*2+2)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;
    RegCloseKey(kkey);
end;

procedure SFT(tstr:AnsiString);
begin
//    if SFTCS=nil then SFTCS:=TCriticalSection.Create;
//    SFTCS.Enter;

    Append(GR_FL);
    Writeln(GR_FL,tstr);
    CloseFile(GR_FL);

//    SFTCS.Leave;
end;

procedure SFTne(tstr:AnsiString);
begin
//    if SFTCS=nil then SFTCS:=TCriticalSection.Create;
//    SFTCS.Enter;

    Append(GR_FL);
    Write(GR_FL,tstr);
    CloseFile(GR_FL);

//    SFTCS.Leave;
end;

end.
