unit Global;

interface

uses Windows,ActiveX,SysUtils,Math,Classes,EC_Str,EC_Buf,Graphics;

function NewGUID:TGUID;
function GUIDToStr(zn:TGUID):WideString;
function StrToGUID(zn:WideString):TGUID;
function CmpGUID(g1,g2:TGUID):boolean;

procedure GradientRect(ca:TCanvas; rc:TRect; cl1,cl2:TColor; vert:boolean);
//procedure DrawRectText(ca:TCanvas; rc:TRect; fs:TBrushStyle; fcolor:TColor; bstyle:TPenStyle; bcolor:TColor; bsize:integer; bcoef:single; tax:integer; tay:integer; tar:boolean; wordwrap:boolean; text:WideString; textsme:integer=0; tsx:integer=0; tsy:integer=0);
//procedure SaveCanvasPar(ca:TCanvas);
//procedure LoadCanvasPar(ca:TCanvas);

function RegUser_IsExist(path:WideString):boolean; overload;
function RegUser_IsExist(path:WideString; name:WideString):boolean; overload;

function RegUser_GetFullDWORD(pkey:HKEY; path:WideString; name:WideString; bydef:DWORD):DWORD; // HKEY_CURRENT_USER HKEY_LOCAL_MACHINE
procedure RegUser_SetFullDWORD(pkey:HKEY; path:WideString; name:WideString; zn:DWORD);

function RegUser_GetDWORD(path:WideString; name:WideString; bydef:DWORD):DWORD;
procedure RegUser_SetDWORD(path:WideString; name:WideString; zn:DWORD);

function RegUser_GetFullString(pkey:HKEY; path:WideString; name:WideString; bydef:WideString):WideString;
procedure RegUser_SetFullString(pkey:HKEY; path:WideString; name:WideString; zn:WideString);

function RegUser_GetString(path:WideString; name:WideString; bydef:WideString):WideString;
procedure RegUser_SetString(path:WideString; name:WideString; zn:WideString);

procedure RegUser_GetBuf(path:WideString; name:WideString; tbuf:TBufEC);
procedure RegUser_SetBuf(path:WideString; name:WideString; tbuf:TBufEC);

procedure RegUser_Delete(path:WideString); overload;
procedure RegUser_Delete(path:WideString; name:WideString); overload;

function RegUser_EnumKey(path:WideString; index:integer):WideString;
procedure RegUser_CopyValue(const soupath,despath:WideString);
procedure RegUser_CopyKey(const soupath,despath:WideString);
procedure RegUser_CopyKeyAndValue(const soupath,despath:WideString);

function FormatMessageEC(zn:DWORD):WideString;

function MsgToString(msg:DWORD):WideString;

procedure ClipboardGet(const formatname:WideString; bd:TBufEC);
procedure ClipboardSet(const formatname:WideString; bd:TBufEC);
function ClipboardTest(const formatname:WideString):boolean;

function CreateTempFileName:WideString;

var
    RegUserPath:WideString='Software\NewGame Sofware\RangersScriptViewer';

implementation

uses EC_Mem,Messages;

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
type
	PTRIVERTEX_m = ^TRIVERTEX_m;
	TRIVERTEX_m = packed record
		x: Longint;
		y: Longint;
		Red: WORD;
		Green: WORD;
		Blue: WORD;
		Alpha: WORD;
	end;
	function GradientFill_m(DC: HDC; Vertex: PTRIVERTEX_m; NumVertex: ULONG; Mesh: Pointer; NumMesh, Mode: ULONG): BOOL; stdcall; external 'msimg32.dll' name 'GradientFill';

procedure GradientRect(ca:TCanvas; rc:TRect; cl1,cl2:TColor; vert:boolean);
var
	tv:packed array[0..1] of TRIVERTEX_m;
    gr:GRADIENT_RECT;
begin
	with tv[0] do begin
    	x:=rc.Left; y:=rc.Top;
        Red:=GetRValue(cl1) shl 8;
        Green:=GetGValue(cl1) shl 8;
        Blue:=GetBValue(cl1) shl 8;
        Alpha:=$0000;
    end;
	with tv[1] do begin
    	x:=rc.Right;
        y:=rc.Bottom;
        Red:=GetRValue(cl2) shl 8;
        Green:=GetGValue(cl2) shl 8;
        Blue:=GetBValue(cl2) shl 8;
        Alpha:=$0000;
    end;
    gr.UpperLeft:=0; gr.LowerRight:=1;
    if vert then GradientFill_m(ca.Handle,@(tv[0]),2,@gr,1,GRADIENT_FILL_RECT_V)
	else GradientFill_m(ca.Handle,@(tv[0]),2,@gr,1,GRADIENT_FILL_RECT_H);
end;

(*procedure DrawRectText(ca:TCanvas; rc:TRect; fs:TBrushStyle; fcolor:TColor; bstyle:TPenStyle; bcolor:TColor;
					   bsize:integer; bcoef:single;
                       tax:integer; tay:integer; tar:boolean; wordwrap:boolean;
                       text:WideString; textsme:integer; tsx,tsy:integer);
var
    x,y,i:integer;
    crc:TRect;
    hr:HRGN;
    hrok:integer;
    fl:DWORD;
    opt:DWORD;
    si:TSize;
//    tm:TEXTMETRIC;
begin
//    GetTextMetrics(ca.Handle,tm);

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

    opt:=0;
    if wordwrap then begin
    	opt:=DT_WORDBREAK;
    	crc:=Rect(textsme,textsme,rc.Right-rc.Left-textsme*2,1000000);
    end else begin
	    crc:=Rect(textsme,textsme,1000000,1000000);
    end;
    GetTextExtentPoint32(ca.Handle,PChar(AnsiString(text)),Length(text),si);
//    crc:=Rect(0,0,si.cx,si.cy);
    DrawText(ca.Handle,PChar(AnsiString(text)),-1,crc,opt or DT_NOPREFIX or DT_TOP or DT_LEFT or DT_NOCLIP or DT_CALCRECT);

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
        crc:=Rect(x+textsme+tsx,y+textsme+tsy,1000000,1000000);
        DrawText(ca.Handle,PChar(AnsiString(text)),-1,crc,DT_NOPREFIX or DT_LEFT or DT_TOP or DT_NOCLIP or opt);
    end else begin
        crc:=Rect(rc.Left+textsme+tsx,y+textsme+tsy,rc.Right-textsme,1000000);
        DrawText(ca.Handle,PChar(AnsiString(text)),-1,crc,fl or DT_NOPREFIX or DT_TOP or DT_NOCLIP or opt);
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
    old_Font_Color:TColor;
    old_Font_Size:integer;
    old_Font_Name:AnsiString;

procedure SaveCanvasPar(ca:TCanvas);
begin
    old_Brush_Color:=ca.Brush.Color;
    old_Brush_Style:=ca.Brush.Style;
    old_Pen_Color:=ca.Pen.Color;
    old_Pen_Style:=ca.Pen.Style;
    old_Pen_Width:=ca.Pen.Width;
    old_Font_Color:=ca.Font.Color;
    old_Font_Size:=ca.Font.Size;
    old_Font_Name:=ca.Font.Name;
end;

procedure LoadCanvasPar(ca:TCanvas);
begin
    ca.Brush.Color:=old_Brush_Color;
    ca.Brush.Style:=old_Brush_Style;
    ca.Pen.Color:=old_Pen_Color;
    ca.Pen.Style:=old_Pen_Style;
    ca.Pen.Width:=old_Pen_Width;
    ca.Font.Color:=old_Font_Color;
    ca.Font.Size:=old_Font_Size;
    ca.Font.Name:=old_Font_Name;
end;*)

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function RegUser_IsExist(path:WideString):boolean;
var
    kkey:HKEY;
begin
	Result:=false;
    if RegOpenKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Exit;
    end;
    RegCloseKey(kkey);
	Result:=true;
end;

function RegUser_IsExist(path:WideString; name:WideString):boolean;
var
    kkey:HKEY;
    tip:DWORD;
begin
	Result:=false;
    if RegOpenKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegQueryValueExA(kkey,PChar(AnsiString(name)),nil,@tip,nil,nil)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;
    RegCloseKey(kkey);
	Result:=true;
end;

function RegUser_GetFullDWORD(pkey:HKEY; path:WideString; name:WideString; bydef:DWORD):DWORD;
var
    kkey:HKEY;
    tip:DWORD;
    zn:DWORD;
    tsize:DWORD;
begin
    if RegOpenKeyExA(pkey,PChar(AnsiString(path)),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
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

procedure RegUser_SetFullDWORD(pkey:HKEY; path:WideString; name:WideString; zn:DWORD);
var
    kkey:HKEY;
    dv:DWORD;
begin
    if RegCreateKeyExA(pkey,PChar(AnsiString(path)),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegSetValueExA(kkey,PChar(AnsiString(name)),0,REG_DWORD,@zn,4)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;
    RegCloseKey(kkey);
end;

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

function RegUser_GetFullString(pkey:HKEY; path:WideString; name:WideString; bydef:WideString):WideString;
var
    kkey:HKEY;
    tip:DWORD;
    zn:Pointer;
    tsize:DWORD;
begin
    if RegOpenKeyExA(pkey,PChar(AnsiString(path)),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
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

procedure RegUser_SetFullString(pkey:HKEY; path:WideString; name:WideString; zn:WideString);
var
    kkey:HKEY;
    dv:DWORD;
    tstr:AnsiString;
begin
    if RegCreateKeyExA(pkey,PChar(AnsiString(path)),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    tstr:=zn;
    if RegSetValueExA(kkey,PChar(AnsiString(name)),0,REG_SZ,PChar(tstr),Length(tstr)+1)<>ERROR_SUCCESS then begin
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

procedure RegUser_Delete(path:WideString);
var
//	i:integer;
    tstr:WideString;
begin
//	i:=0;
	while true do begin
    	tstr:=RegUser_EnumKey(path,0);
        if tstr='' then break;
//        inc(i);
		RegUser_Delete(path+'\'+tstr);
    end;
    RegDeleteKeyA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)));
end;

procedure RegUser_Delete(path:WideString; name:WideString);
var
    kkey:HKEY;
begin
    if RegOpenKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,KEY_ALL_ACCESS{KEY_WRITE or KEY_READ},kkey)<>ERROR_SUCCESS then begin
        Exit;
    end;
    RegDeleteValueA(kkey,PChar(AnsiString(name)));
    RegCloseKey(kkey);
end;

function RegUser_EnumKey(path:WideString; index:integer):WideString;
var
    kkey:HKEY;
    astr:AnsiString;
    dw:WORD;
begin
	Result:='';
    if RegOpenKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+path)),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Exit;
    end;

    SetLength(astr,MAX_PATH + 1);
	dw:=RegEnumKeyA(kkey,index,PChar(astr),MAX_PATH + 1);
    if dw=ERROR_SUCCESS then begin
	    SetLength(astr,StrLen(PChar(astr)));
        Result:=astr;
    end;

    RegCloseKey(kkey);
end;

procedure RegUser_CopyValue(const soupath,despath:WideString);
var
    sou_kkey,des_kkey:HKEY;
    dv:DWORD;
    namesize:DWORD;
    vtype:DWORD;
    vsize:DWORD;
    aname:AnsiString;
    buf:TBufEC;
	i:integer;
begin
	sou_kkey:=0;
	des_kkey:=0;
    buf:=TBufEC.Create;
    while true do begin
	    if RegOpenKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+soupath)),0,KEY_READ,sou_kkey)<>ERROR_SUCCESS then break;
	    if RegCreateKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+despath)),0,nil,0,KEY_WRITE,nil,des_kkey,@dv)<>ERROR_SUCCESS then break;

        i:=0;
        while True do begin
	        namesize:=512;
			SetLength(aname,namesize);
	        if RegEnumValueA(sou_kkey,i,PChar(aname),namesize,nil,@vtype,nil,@vsize)<>ERROR_SUCCESS then break;
            if namesize>500 then begin
	            namesize:=namesize*2;
				SetLength(aname,namesize);
            end else namesize:=512;
            buf.Len:=vsize;
	        if RegEnumValueA(sou_kkey,i,PChar(aname),namesize,nil,@vtype,buf.Buf,@vsize)<>ERROR_SUCCESS then break;
            inc(i);

		    if RegSetValueExA(des_kkey,PChar(aname),0,vtype,buf.Buf,vsize)<>ERROR_SUCCESS then begin
		    end;
        end;
        break;
    end;
    if sou_kkey<>0 then RegCloseKey(sou_kkey);
    if des_kkey<>0 then RegCloseKey(des_kkey);
    if buf<>nil then buf.Free;
end;

procedure RegUser_CopyKey(const soupath,despath:WideString);
var
    kkey:HKEY;
    astr:AnsiString;
    dw:WORD;
    i:integer;
begin
    if RegOpenKeyExA(HKEY_CURRENT_USER,PChar(AnsiString(RegUserPath+soupath)),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Exit;
    end;

    i:=0;
    while True do begin
	    SetLength(astr,MAX_PATH + 1);
		dw:=RegEnumKeyA(kkey,i,PChar(astr),MAX_PATH + 1);
        inc(i);
	    if dw<>ERROR_SUCCESS then break;
		SetLength(astr,StrLen(PChar(astr)));

        RegUser_CopyKeyAndValue(soupath+'\'+astr,despath+'\'+astr);
    end;

    RegCloseKey(kkey);
end;

procedure RegUser_CopyKeyAndValue(const soupath,despath:WideString);
begin
	RegUser_CopyValue(soupath,despath);
    RegUser_CopyKey(soupath,despath);
end;

function FormatMessageEC(zn:DWORD):WideString;
var
	buf:DWORD;
    ts:PChar;
begin
	Result:='';
	buf:=0;
	if FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ALLOCATE_BUFFER,nil,zn,0,@buf,1,nil)=0 then begin
        Exit;
    end;
    ts:=LocalLock(buf);
    if ts<>nil then begin
    	Result:=ts;
	    LocalUnlock(buf);
    end;
    LocalFree(DWORD(buf));
end;

function MsgToString(msg:DWORD):WideString;
begin
    case msg of
		WM_NULL: Result:='WM_NULL';
		WM_CREATE: Result:='WM_CREATE';
		WM_DESTROY: Result:='WM_DESTROY';
		WM_MOVE: Result:='WM_MOVE';
		WM_SIZE: Result:='WM_SIZE';

		WM_ACTIVATE: Result:='WM_ACTIVATE';

		WM_SETFOCUS: Result:='WM_SETFOCUS';
		WM_KILLFOCUS: Result:='WM_KILLFOCUS';
		WM_ENABLE: Result:='WM_ENABLE';
		WM_SETREDRAW: Result:='WM_SETREDRAW';
		WM_SETTEXT: Result:='WM_SETTEXT';
		WM_GETTEXT: Result:='WM_GETTEXT';
		WM_GETTEXTLENGTH: Result:='WM_GETTEXTLENGTH';
		WM_PAINT: Result:='WM_PAINT';
		WM_CLOSE: Result:='WM_CLOSE';
		WM_QUERYENDSESSION: Result:='WM_QUERYENDSESSION';
		WM_QUIT: Result:='WM_QUIT';
		WM_QUERYOPEN: Result:='WM_QUERYOPEN';
		WM_ERASEBKGND: Result:='WM_ERASEBKGND';
		WM_SYSCOLORCHANGE: Result:='WM_SYSCOLORCHANGE';
		WM_ENDSESSION: Result:='WM_ENDSESSION';
		WM_SHOWWINDOW: Result:='WM_SHOWWINDOW';
		WM_WININICHANGE: Result:='WM_WININICHANGE';

		WM_DEVMODECHANGE: Result:='WM_DEVMODECHANGE';
		WM_ACTIVATEAPP: Result:='WM_ACTIVATEAPP';
		WM_FONTCHANGE: Result:='WM_FONTCHANGE';
		WM_TIMECHANGE: Result:='WM_TIMECHANGE';
		WM_CANCELMODE: Result:='WM_CANCELMODE';
		WM_SETCURSOR: Result:='WM_SETCURSOR';
		WM_MOUSEACTIVATE: Result:='WM_MOUSEACTIVATE';
		WM_CHILDACTIVATE: Result:='WM_CHILDACTIVATE';
		WM_QUEUESYNC: Result:='WM_QUEUESYNC';

		WM_GETMINMAXINFO: Result:='WM_GETMINMAXINFO';

		WM_PAINTICON: Result:='WM_PAINTICON';
		WM_ICONERASEBKGND: Result:='WM_ICONERASEBKGND';
		WM_NEXTDLGCTL: Result:='WM_NEXTDLGCTL';
		WM_SPOOLERSTATUS: Result:='WM_SPOOLERSTATUS';
		WM_DRAWITEM: Result:='WM_DRAWITEM';
		WM_MEASUREITEM: Result:='WM_MEASUREITEM';
		WM_DELETEITEM: Result:='WM_DELETEITEM';
		WM_VKEYTOITEM: Result:='WM_VKEYTOITEM';
		WM_CHARTOITEM: Result:='WM_CHARTOITEM';
		WM_SETFONT: Result:='WM_SETFONT';
		WM_GETFONT: Result:='WM_GETFONT';
		WM_SETHOTKEY: Result:='WM_SETHOTKEY';
		WM_GETHOTKEY: Result:='WM_GETHOTKEY';
		WM_QUERYDRAGICON: Result:='WM_QUERYDRAGICON';
		WM_COMPAREITEM: Result:='WM_COMPAREITEM';

		WM_GETOBJECT: Result:='WM_GETOBJECT';

		WM_COMPACTING: Result:='WM_COMPACTING';
		WM_COMMNOTIFY: Result:='WM_COMMNOTIFY';
        WM_WINDOWPOSCHANGING: Result:='WM_WINDOWPOSCHANGING';
		WM_WINDOWPOSCHANGED: Result:='WM_WINDOWPOSCHANGED';

		WM_COPYDATA: Result:='WM_COPYDATA';
		WM_CANCELJOURNAL: Result:='WM_CANCELJOURNAL';

		WM_NOTIFY: Result:='WM_NOTIFY';
		WM_INPUTLANGCHANGEREQUEST: Result:='WM_INPUTLANGCHANGEREQUEST';
		WM_INPUTLANGCHANGE: Result:='WM_INPUTLANGCHANGE';
		WM_TCARD: Result:='WM_TCARD';
		WM_HELP: Result:='WM_HELP';
		WM_USERCHANGED: Result:='WM_USERCHANGED';
		WM_NOTIFYFORMAT: Result:='WM_NOTIFYFORMAT';

		WM_CONTEXTMENU: Result:='WM_CONTEXTMENU';
		WM_STYLECHANGING: Result:='WM_STYLECHANGING';
		WM_STYLECHANGED: Result:='WM_STYLECHANGED';
		WM_DISPLAYCHANGE: Result:='WM_DISPLAYCHANGE';
		WM_GETICON: Result:='WM_GETICON';
		WM_SETICON: Result:='WM_SETICON';

		WM_NCCREATE: Result:='WM_NCCREATE';
		WM_NCDESTROY: Result:='WM_NCDESTROY';
		WM_NCCALCSIZE: Result:='WM_NCCALCSIZE';
		WM_NCHITTEST: Result:='WM_NCHITTEST';
		WM_NCPAINT: Result:='WM_NCPAINT';
		WM_NCACTIVATE: Result:='WM_NCACTIVATE';
		WM_GETDLGCODE: Result:='WM_GETDLGCODE';
		WM_NCMOUSEMOVE: Result:='WM_NCMOUSEMOVE';
		WM_NCLBUTTONDOWN: Result:='WM_NCLBUTTONDOWN';
		WM_NCLBUTTONUP: Result:='WM_NCLBUTTONUP';
		WM_NCLBUTTONDBLCLK: Result:='WM_NCLBUTTONDBLCLK';
		WM_NCRBUTTONDOWN: Result:='WM_NCRBUTTONDOWN';
		WM_NCRBUTTONUP: Result:='WM_NCRBUTTONUP';
		WM_NCRBUTTONDBLCLK: Result:='WM_NCRBUTTONDBLCLK';
		WM_NCMBUTTONDOWN: Result:='WM_NCMBUTTONDOWN';
		WM_NCMBUTTONUP: Result:='WM_NCMBUTTONUP';
		WM_NCMBUTTONDBLCLK: Result:='WM_NCMBUTTONDBLCLK';

		WM_KEYDOWN: Result:='WM_KEYDOWN';
		WM_KEYUP: Result:='WM_KEYUP';
		WM_CHAR: Result:='WM_CHAR';
		WM_DEADCHAR: Result:='WM_DEADCHAR';
		WM_SYSKEYDOWN: Result:='WM_SYSKEYDOWN';
		WM_SYSKEYUP: Result:='WM_SYSKEYUP';
		WM_SYSCHAR: Result:='WM_SYSCHAR';
		WM_SYSDEADCHAR: Result:='WM_SYSDEADCHAR';
		WM_KEYLAST: Result:='WM_KEYLAST';

		WM_IME_STARTCOMPOSITION: Result:='WM_IME_STARTCOMPOSITION';
		WM_IME_ENDCOMPOSITION: Result:='WM_IME_ENDCOMPOSITION';
		WM_IME_COMPOSITION: Result:='WM_IME_COMPOSITION';

		WM_INITDIALOG: Result:='WM_INITDIALOG';
		WM_COMMAND: Result:='WM_COMMAND';
		WM_SYSCOMMAND: Result:='WM_SYSCOMMAND';
		WM_TIMER: Result:='WM_TIMER';
		WM_HSCROLL: Result:='WM_HSCROLL';
		WM_VSCROLL: Result:='WM_VSCROLL';
		WM_INITMENU: Result:='WM_INITMENU';
		WM_INITMENUPOPUP: Result:='WM_INITMENUPOPUP';
		WM_MENUSELECT: Result:='WM_MENUSELECT';
		WM_MENUCHAR: Result:='WM_MENUCHAR';
		WM_ENTERIDLE: Result:='WM_ENTERIDLE';

		WM_MENURBUTTONUP: Result:='WM_MENURBUTTONUP';
		WM_MENUDRAG: Result:='WM_MENUDRAG';
		WM_MENUGETOBJECT: Result:='WM_MENUGETOBJECT';
		WM_UNINITMENUPOPUP: Result:='WM_UNINITMENUPOPUP';
		WM_MENUCOMMAND: Result:='WM_MENUCOMMAND';

		WM_CTLCOLORMSGBOX: Result:='WM_CTLCOLORMSGBOX';
		WM_CTLCOLOREDIT: Result:='WM_CTLCOLOREDIT';
		WM_CTLCOLORLISTBOX: Result:='WM_CTLCOLORLISTBOX';
		WM_CTLCOLORBTN: Result:='WM_CTLCOLORBTN';
		WM_CTLCOLORDLG: Result:='WM_CTLCOLORDLG';
		WM_CTLCOLORSCROLLBAR: Result:='WM_CTLCOLORSCROLLBAR';
		WM_CTLCOLORSTATIC: Result:='WM_CTLCOLORSTATIC';

		WM_MOUSEMOVE: Result:='WM_MOUSEMOVE';
		WM_LBUTTONDOWN: Result:='WM_LBUTTONDOWN';
		WM_LBUTTONUP: Result:='WM_LBUTTONUP';
		WM_LBUTTONDBLCLK: Result:='WM_LBUTTONDBLCLK';
		WM_RBUTTONDOWN: Result:='WM_RBUTTONDOWN';
		WM_RBUTTONUP: Result:='WM_RBUTTONUP';
		WM_RBUTTONDBLCLK: Result:='WM_RBUTTONDBLCLK';
		WM_MBUTTONDOWN: Result:='WM_MBUTTONDOWN';
		WM_MBUTTONUP: Result:='WM_MBUTTONUP';
		WM_MBUTTONDBLCLK: Result:='WM_MBUTTONDBLCLK';

		WM_MOUSEWHEEL: Result:='WM_MOUSEWHEEL';

		WM_PARENTNOTIFY: Result:='WM_PARENTNOTIFY';
		WM_ENTERMENULOOP: Result:='WM_ENTERMENULOOP';
		WM_EXITMENULOOP: Result:='WM_EXITMENULOOP';

		WM_NEXTMENU: Result:='WM_NEXTMENU';
		WM_SIZING: Result:='WM_SIZING';
		WM_CAPTURECHANGED: Result:='WM_CAPTURECHANGED';
		WM_MOVING: Result:='WM_MOVING';
		WM_POWERBROADCAST: Result:='WM_POWERBROADCAST';

		WM_DEVICECHANGE: Result:='WM_DEVICECHANGE';

		WM_MDICREATE: Result:='WM_MDICREATE';
		WM_MDIDESTROY: Result:='WM_MDIDESTROY';
		WM_MDIACTIVATE: Result:='WM_MDIACTIVATE';
		WM_MDIRESTORE: Result:='WM_MDIRESTORE';
		WM_MDINEXT: Result:='WM_MDINEXT';
		WM_MDIMAXIMIZE: Result:='WM_MDIMAXIMIZE';
		WM_MDITILE: Result:='WM_MDITILE';
		WM_MDICASCADE: Result:='WM_MDICASCADE';
		WM_MDIICONARRANGE: Result:='WM_MDIICONARRANGE';
		WM_MDIGETACTIVE: Result:='WM_MDIGETACTIVE';

		WM_MDISETMENU: Result:='WM_MDISETMENU';
		WM_ENTERSIZEMOVE: Result:='WM_ENTERSIZEMOVE';
		WM_EXITSIZEMOVE: Result:='WM_EXITSIZEMOVE';
		WM_DROPFILES: Result:='WM_DROPFILES';
		WM_MDIREFRESHMENU: Result:='WM_MDIREFRESHMENU';

		WM_IME_SETCONTEXT: Result:='WM_IME_SETCONTEXT';
		WM_IME_NOTIFY: Result:='WM_IME_NOTIFY';
		WM_IME_CONTROL: Result:='WM_IME_CONTROL';
		WM_IME_COMPOSITIONFULL: Result:='WM_IME_COMPOSITIONFULL';
		WM_IME_SELECT: Result:='WM_IME_SELECT';
		WM_IME_CHAR: Result:='WM_IME_CHAR';
		WM_IME_REQUEST: Result:='WM_IME_REQUEST';
		WM_IME_KEYDOWN: Result:='WM_IME_KEYDOWN';
		WM_IME_KEYUP: Result:='WM_IME_KEYUP';

		WM_MOUSEHOVER: Result:='WM_MOUSEHOVER';
		WM_MOUSELEAVE: Result:='WM_MOUSELEAVE';

		WM_CUT: Result:='WM_CUT';
		WM_COPY: Result:='WM_COPY';
		WM_PASTE: Result:='WM_PASTE';
		WM_CLEAR: Result:='WM_CLEAR';
		WM_UNDO: Result:='WM_UNDO';
		WM_RENDERFORMAT: Result:='WM_RENDERFORMAT';
		WM_RENDERALLFORMATS: Result:='WM_RENDERALLFORMATS';
		WM_DESTROYCLIPBOARD: Result:='WM_DESTROYCLIPBOARD';
		WM_DRAWCLIPBOARD: Result:='WM_DRAWCLIPBOARD';
		WM_PAINTCLIPBOARD: Result:='WM_PAINTCLIPBOARD';
		WM_VSCROLLCLIPBOARD: Result:='WM_VSCROLLCLIPBOARD';
		WM_SIZECLIPBOARD: Result:='WM_SIZECLIPBOARD';
		WM_ASKCBFORMATNAME: Result:='WM_ASKCBFORMATNAME';
		WM_CHANGECBCHAIN: Result:='WM_CHANGECBCHAIN';
		WM_HSCROLLCLIPBOARD: Result:='WM_HSCROLLCLIPBOARD';
		WM_QUERYNEWPALETTE: Result:='WM_QUERYNEWPALETTE';
		WM_PALETTEISCHANGING: Result:='WM_PALETTEISCHANGING';
		WM_PALETTECHANGED: Result:='WM_PALETTECHANGED';
		WM_HOTKEY: Result:='WM_HOTKEY';

		WM_PRINT: Result:='WM_PRINT';
		WM_PRINTCLIENT: Result:='WM_PRINTCLIENT';

		WM_HANDHELDFIRST: Result:='WM_HANDHELDFIRST';
		WM_HANDHELDLAST: Result:='WM_HANDHELDLAST';

		WM_PENWINFIRST: Result:='WM_PENWINFIRST';
		WM_PENWINLAST: Result:='WM_PENWINLAST';
    end;
    Result:=Format('%s %x',[Result,msg]);
end;

procedure ClipboardGet(const formatname:WideString; bd:TBufEC);
var
	cf:DWORD;
	hglb:HGLOBAL;
    buf:Pointer;
    len:integer;
begin
	bd.Clear;

    if GetVersion()<$80000000 then cf:=RegisterClipboardFormatW(PWideChar(formatname))
    else cf:=RegisterClipboardFormatA(PChar(AnsiString(formatname)));
    if cf=0 then Exit;

    if not IsClipboardFormatAvailable(cf) then Exit;
    if not OpenClipboard(0) then Exit;

    while True do begin
	    hglb := GetClipboardData(cf);
        if hglb=0 then break;

        len:=GlobalSize(hglb);
        if len<1 then break;

        buf := GlobalLock(hglb);
        if buf=nil then break;

        bd.Len:=len;
        CopyMemory(bd.Buf,buf,len);
        bd.BPointer:=0;

        GlobalUnlock(hglb);
        break;
    end;

    CloseClipboard();
end;

procedure ClipboardSet(const formatname:WideString; bd:TBufEC);
var
	cf:DWORD;
	hglb:HGLOBAL;
    buf:Pointer;
begin
    if GetVersion()<$80000000 then cf:=RegisterClipboardFormatW(PWideChar(formatname))
    else cf:=RegisterClipboardFormatA(PChar(AnsiString(formatname)));
    if cf=0 then Exit;

    if not OpenClipboard(0) then Exit;

    while true do begin
        EmptyClipboard();
	    if bd.Len<=0 then break;

        hglb:=GlobalAlloc(GMEM_MOVEABLE,bd.Len);
        if hglb=0 then break;
        buf:=GlobalLock(hglb);
        if buf=nil then begin GlobalFree(hglb); break; end;

        CopyMemory(buf,bd.Buf,bd.Len);

        GlobalUnlock(hglb);

        SetClipboardData(cf,hglb);

    	break;
    end;

    CloseClipboard();
end;

function ClipboardTest(const formatname:WideString):boolean;
var
	cf:DWORD;
begin
	Result:=false;

    if GetVersion()<$80000000 then cf:=RegisterClipboardFormatW(PWideChar(formatname))
    else cf:=RegisterClipboardFormatA(PChar(AnsiString(formatname)));
    if cf=0 then Exit;

    Result:=IsClipboardFormatAvailable(cf);
end;

function CreateTempFileName:WideString;
var
	szTempPath,szTempFile:AnsiString;
    len:integer;
begin
	SetLength(szTempPath,MAX_PATH);
	len:=GetTempPath(MAX_PATH,PChar(szTempPath));
    if len=0 then begin Result:=''; Exit; end;
    SetLength(szTempPath,len);

    SetLength(szTempFile,MAX_PATH);
	len:=GetTempFileName(PChar(szTempPath),'ddb',0,PChar(szTempFile));
	if len=0 then begin Result:=''; Exit; end;
    Result:=AnsiString(PChar(szTempFile));
end;

end.

