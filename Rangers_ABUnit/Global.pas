unit Global;

interface

uses Windows,ActiveX,SysUtils,Math,Classes,EC_Str,EC_Buf,Graphics;

function NewGUID:TGUID;
function GUIDToStr(zn:TGUID):WideString;
function StrToGUID(zn:WideString):TGUID;
function CmpGUID(g1,g2:TGUID):boolean;

procedure DrawRectText(ca:TCanvas; rc:TRect; fs:TBrushStyle; fcolor:TColor; bstyle:TPenStyle; bcolor:TColor; bsize:integer; bcoef:single; tax:integer; tay:integer; tar:boolean; text:WideString);
procedure SaveCanvasPar(ca:TCanvas);
procedure LoadCanvasPar(ca:TCanvas);

function RegUser_GetDWORD(path:WideString; name:WideString; bydef:DWORD):DWORD;
procedure RegUser_SetDWORD(path:WideString; name:WideString; zn:DWORD);

function RegUser_GetString(path:WideString; name:WideString; bydef:WideString):WideString;
procedure RegUser_SetString(path:WideString; name:WideString; zn:WideString);

procedure RegUser_GetBuf(path:WideString; name:WideString; tbuf:TBufEC);
procedure RegUser_SetBuf(path:WideString; name:WideString; tbuf:TBufEC);

var
    RegUserPath:WideString='Software\dab\Rangers_ABUnit';

implementation

uses EC_Mem;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function NewGUID:TGUID;
begin
    if CoCreateGuid(Result)<>S_OK then raise Exception.Create('NewGUID');
end;

function GUIDToStr(zn:TGUID):WideString;
var
    tstr:WideString;
begin
{    SetLength(Result,38);
    if StringFromGUID2(zn,PWideChar(Result),38)<>NOERROR then raise Exception.Create('GUIDToStr');
    Result:=Copy(Result,2,36);}

    SetLength(tstr,40);
    if StringFromGUID2(zn,PWideChar(tstr),40)=0 then raise Exception.Create('GUIDToStr');
    Result:=UpperCase(Copy(tstr,2,36));
end;

function StrToGUID(zn:WideString):TGUID;
begin
    if CLSIDFromString(PWideChar('{'+TrimEx(zn)+'}'),Result)<>NOERROR then raise Exception.Create('StrToGUID('+zn+')');
end;

function CmpGUID(g1,g2:TGUID):boolean;
begin
    Result:=CompareMem(@g1,@g2,sizeof(TGUID));
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure DrawRectText(ca:TCanvas; rc:TRect; fs:TBrushStyle; fcolor:TColor; bstyle:TPenStyle; bcolor:TColor; bsize:integer; bcoef:single; tax:integer; tay:integer; tar:boolean; text:WideString);
var
    x,y,i:integer;
    crc:TRect;
    hr:HRGN;
    hrok:integer;
    fl:DWORD;
begin
    ca.Brush.Color:=fcolor;
    ca.Brush.Style:=fs;
    ca.Pen.Style:=psClear;
    ca.Rectangle(rc.left{+bsize},rc.top{+bsize},rc.Right{+1-bsize},rc.Bottom{+1-bsize});

    ca.Pen.Color:=bcolor;
    ca.Pen.Style:=bstyle;
    ca.Pen.Width:=1;
    for i:=0 to bsize-1 do begin
        ca.MoveTo(rc.Right-2-i,rc.Top+i);
        ca.LineTo(rc.Left+i,rc.Top+i);
        ca.LineTo(rc.Left+i,rc.Bottom-2-i);
    end;

    ca.Pen.Color:=RGB(min(255,max(0,Round(GetRValue(bcolor)*bcoef))),min(255,max(0,Round(GetGValue(bcolor)*bcoef))),min(255,max(0,Round(GetBValue(bcolor)*bcoef))));
    for i:=0 to bsize-1 do begin
        ca.MoveTo(rc.Left+i,rc.Bottom-2-i);
        ca.LineTo(rc.Right-2-i,rc.Bottom-2-i);
        ca.LineTo(rc.Right-2-i,rc.Top+i);
    end;

    if Length(TrimEx(text))<1 then Exit;

    rc.Left:=rc.Left+bsize+1;
    rc.Top:=rc.Top+bsize+1;
    rc.Right:=rc.Right-bsize-1;
    rc.Bottom:=rc.Bottom-bsize-1;

    crc:=Rect(0,0,1000000,1000000);
    DrawText(ca.Handle,PChar(AnsiString(text)),-1,crc,DT_TOP or DT_LEFT or DT_NOCLIP or DT_CALCRECT);

    if tax<0 then begin x:=rc.Left; fl:=DT_LEFT; end
    else if tax=0 then begin x:=(rc.Left+rc.Right) div 2-(crc.Right-crc.Left) div 2; fl:=DT_CENTER; end
    else begin x:=rc.Right-(crc.Right-crc.Left); fl:=DT_RIGHT; end;

    if tay<0 then y:=rc.Top
    else if tay=0 then y:=(rc.Top+rc.Bottom) div 2-(crc.Bottom-crc.Top) div 2
    else y:=rc.Bottom-(crc.Bottom-crc.Top);

    hr:=CreateRectRgn(0,0,1,1);
    hrok:=GetClipRgn(ca.Handle,hr);

//    BeginPath(ca.Handle);
//    SelectClipPath(ca.Handle,RGN_OR);
    IntersectClipRect(ca.Handle,rc.Left,rc.Top,rc.Right,rc.Bottom);

    if tar then begin
        crc:=Rect(x,y,1000000,1000000);
        DrawText(ca.Handle,PChar(AnsiString(text)),-1,crc,DT_LEFT or DT_TOP or DT_NOCLIP);
    end else begin
        crc:=Rect(rc.Left,y,rc.Right,1000000);
        DrawText(ca.Handle,PChar(AnsiString(text)),-1,crc,fl or DT_TOP or DT_NOCLIP);
    end;

//    EndPath(ca.Handle);

    SelectClipRgn(ca.Handle,0);
    if hrok=1 then SelectClipRgn(ca.Handle,hr);
    DeleteObject(hr);
end;

var
    old_Brush_Color:TColor;
    old_Brush_Style:TBrushStyle;
    old_Pen_Color:TColor;
    old_Pen_Style:TPenStyle;
    old_Pen_Width:integer;

procedure SaveCanvasPar(ca:TCanvas);
begin
    old_Brush_Color:=ca.Brush.Color;
    old_Brush_Style:=ca.Brush.Style;
    old_Pen_Color:=ca.Pen.Color;
    old_Pen_Style:=ca.Pen.Style;
    old_Pen_Width:=ca.Pen.Width;
end;

procedure LoadCanvasPar(ca:TCanvas);
begin
    ca.Brush.Color:=old_Brush_Color;
    ca.Brush.Style:=old_Brush_Style;
    ca.Pen.Color:=old_Pen_Color;
    ca.Pen.Style:=old_Pen_Style;
    ca.Pen.Width:=old_Pen_Width;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function RegUser_GetDWORD(path:WideString; name:WideString; bydef:DWORD):DWORD;
var
    kkey:HKEY;
    tip:DWORD;
    zn:DWORD;
    tsize:DWORD;
begin
{    if RegOpenKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Result:=bydef;
        Exit;
    end;
    tsize:=4;
    if RegQueryValueExW(kkey,PWChar(name),nil,@tip,PByte(@zn),@tsize)<>ERROR_SUCCESS then begin
        Result:=bydef;
        RegCloseKey(kkey);
        Exit;
    end;}
    if RegOpenKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Result:=bydef;
        Exit;
    end;
    tsize:=4;
    if RegQueryValueExA(kkey,PChar(AnsiString(name)),nil,@tip,PByte(@zn),@tsize)<>ERROR_SUCCESS then begin
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
{    if RegCreateKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegSetValueExW(kkey,PWChar(name),0,REG_DWORD,@zn,4)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;}
    if RegCreateKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegSetValueExA(kkey,PChar(AnsiString(name)),0,REG_DWORD,@zn,4)<>ERROR_SUCCESS then begin
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
{    if RegOpenKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
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
    RegCloseKey(kkey);}
    if RegOpenKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Result:=bydef;
        Exit;
    end;
    tsize:=2048;
    zn:=AllocEC(tsize);
    if RegQueryValueExA(kkey,PChar(AnsiString(name)),nil,@tip,PByte(zn),@tsize)<>ERROR_SUCCESS then begin
        Result:=bydef;
        RegCloseKey(kkey);
        FreeEC(zn);
        Exit;
    end;
    if tip<>REG_SZ then Result:=bydef
    else Result:=PChar(zn);
    FreeEC(zn);
    RegCloseKey(kkey);
end;

procedure RegUser_SetString(path:WideString; name:WideString; zn:WideString);
var
    kkey:HKEY;
    dv:DWORD;
    tstr:AnsiString;
begin
{    if RegCreateKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegSetValueExW(kkey,PWChar(name),0,REG_SZ,PWChar(zn),Length(zn)*2+2)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;
    RegCloseKey(kkey);}
    if RegCreateKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    tstr:=zn;
    if RegSetValueExA(kkey,PChar(AnsiString(name)),0,REG_SZ,PChar(tstr),Length(tstr)+1)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;
    RegCloseKey(kkey);
end;

procedure RegUser_GetBuf(path:WideString; name:WideString; tbuf:TBufEC);
var
    kkey:HKEY;
    tip:DWORD;
    tsize:DWORD;
begin
	tbuf.Clear;
    if RegOpenKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Exit;
    end;

    tsize:=0;
    if RegQueryValueExA(kkey,PChar(AnsiString(name)),nil,@tip,nil,@tsize)<>ERROR_SUCCESS then begin
	    RegCloseKey(kkey);
    	Exit;
    end;

    if tsize<=0 then begin
	    RegCloseKey(kkey);
    	Exit;
    end;

    tbuf.Len:=tsize;
    if RegQueryValueExA(kkey,PChar(AnsiString(name)),nil,@tip,tbuf.Buf,@tsize)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        tbuf.Clear;
        Exit;
    end;

    RegCloseKey(kkey);
end;

procedure RegUser_SetBuf(path:WideString; name:WideString; tbuf:TBufEC);
var
    kkey:HKEY;
    dv:DWORD;
begin
    if RegCreateKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegSetValueExA(kkey,PChar(AnsiString(name)),0,REG_BINARY,tbuf.Buf,tbuf.Len)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;
    RegCloseKey(kkey);
end;

end.

