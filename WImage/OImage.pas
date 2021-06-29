unit OImage;

interface

uses Windows,SysUtils,Classes,GraphBuf,Math;

procedure OCutOffAlpha(gbsou,gbdes:TGraphBuf; alphabound:DWORD);
procedure OCutOffRect(gbsou,gbdes:TGraphBuf; rc:TRect);
function OCutOffAlphaCalc(gb:TGraphBuf; alphabound:DWORD):TRect;
function OCutOffAlphaCalc_TransBuf_BuildFromRGBA_16(gb:TGraphBuf):TRect;
function OCutOffAlphaCalc_TransAlphaBuf_BuildFromRGBA_16(gb:TGraphBuf):TRect;
function OCutOffAlphaCalc_TransBuf_Build_WORD(gb:TGraphBuf; colorTrans:WORD):TRect;
procedure ODithering16bit(sou,des:TGraphBuf);

procedure OSplit_ForAlphaIndexed(sou,desCopy,desAlpha:TGraphBuf);

implementation

uses EC_Mem;

procedure OCutOffAlpha(gbsou,gbdes:TGraphBuf; alphabound:DWORD);
var
    rc:TRect;
    x,y,lx,ly,sx,sy:integer;
begin
    rc:=OCutOffAlphaCalc(gbsou,alphabound);
    lx:=rc.Right-rc.Left;
    ly:=rc.Bottom-rc.Top;
    if (lx<1) or (ly<1) then raise Exception.Create('Error: empty alpha');

    sx:=rc.Left;
    sy:=rc.Top;

    gbdes.ImageCreate(lx,ly,4);
    gbdes.FPos.x:=gbsou.FPos.x+sx;
    gbdes.FPos.y:=gbsou.FPos.y+sy;

    for y:=0 to ly-1 do begin
        for x:=0 to lx-1 do begin
            PSet(gbdes.PixelBuf(x,y),PGetDWORD(gbsou.PixelBuf(sx+x,sy+y)));
        end;
    end;
end;

procedure OCutOffRect(gbsou,gbdes:TGraphBuf; rc:TRect);
var
    x,y,lx,ly,sx,sy:integer;
begin
    lx:=rc.Right-rc.Left;
    ly:=rc.Bottom-rc.Top;
    if (lx<1) or (ly<1) then raise Exception.Create('Error: OCutOffRect');

    sx:=rc.Left;
    sy:=rc.Top;

    gbdes.ImageCreate(lx,ly,4);
    gbdes.FPos.x:=gbsou.FPos.x+sx;
    gbdes.FPos.y:=gbsou.FPos.y+sy;

    for y:=0 to ly-1 do begin
        for x:=0 to lx-1 do begin
            PSet(gbdes.PixelBuf(x,y),PGetDWORD(gbsou.PixelBuf(sx+x,sy+y)));
        end;
    end;
end;

function OCutOffAlphaCalc(gb:TGraphBuf; alphabound:DWORD):TRect;
var
    x,y:integer;
begin
    if (gb.FLenX<2) or (gb.FLenY<2) then raise Exception.Create('Error: size');
    if (gb.FChannels<4) then raise Exception.Create('Error: channels');

	// Top
    y:=0;
    while y<gb.FLenY do begin
        x:=0;
        while x<gb.FLenX do begin if gb.PixelChannel(x,y,3)>alphabound then break; inc(x); end;
        if x<gb.FLenX then break;
        inc(y);
	end;
	if y>=gb.FLenY then begin
		Result.Left:=0; Result.Top:=0;
		Result.Right:=0; Result.Bottom:=0;
		Exit;
	end;
	Result.Top:=y;

    y:=gb.FLenY-1;
    while y>=0 do begin
        x:=0;
        while x<gb.FLenX do begin if gb.PixelChannel(x,y,3)>alphabound then break; inc(x); end;
        if x<gb.FLenX then break;
        dec(y);
	end;
	Result.Bottom:=y+1;

    x:=0;
    while x<gb.FLenX do begin
        y:=0;
        while y<gb.FLenY do begin if gb.PixelChannel(x,y,3)>alphabound then break; inc(y); end;
        if y<gb.FLenY then break;
        inc(x);
	end;
	Result.Left:=x;

    x:=gb.FLenX-1;
    while x>=0 do begin
        y:=0;
        while y<gb.FLenY do begin if gb.PixelChannel(x,y,3)>alphabound then break; inc(y); end;
        if y<gb.FLenY then break;
        dec(x);
	end;
	Result.Right:=x+1;
end;


function OCutOffAlphaCalc_TransBuf_BuildFromRGBA_16(gb:TGraphBuf):TRect;
var
    x,y:integer;
begin
    if (gb.FLenX<1) or (gb.FLenY<1) then raise Exception.Create('Error: size');
    if (gb.FChannels<4) then raise Exception.Create('Error: channels');

	// Top
    y:=0;
    while y<gb.FLenY do begin
        x:=0;
        while x<gb.FLenX do begin if (gb.PixelChannel(x,y,3) and $0fc)=$0fc then break; inc(x); end;
        if x<gb.FLenX then break;
        inc(y);
	end;
	if y>=gb.FLenY then begin
		Result.Left:=0; Result.Top:=0;
		Result.Right:=0; Result.Bottom:=0;
		Exit;
	end;
	Result.Top:=y;

    y:=gb.FLenY-1;
    while y>=0 do begin
        x:=0;
        while x<gb.FLenX do begin if (gb.PixelChannel(x,y,3) and $0fc)=$0fc then break; inc(x); end;
        if x<gb.FLenX then break;
        dec(y);
	end;
	Result.Bottom:=y+1;

    x:=0;
    while x<gb.FLenX do begin
        y:=0;
        while y<gb.FLenY do begin if (gb.PixelChannel(x,y,3) and $0fc)=$0fc then break; inc(y); end;
        if y<gb.FLenY then break;
        inc(x);
	end;
	Result.Left:=x;

    x:=gb.FLenX-1;
    while x>=0 do begin
        y:=0;
        while y<gb.FLenY do begin if (gb.PixelChannel(x,y,3) and $0fc)=$0fc then break; inc(y); end;
        if y<gb.FLenY then break;
        dec(x);
	end;
	Result.Right:=x+1;
end;

function OCutOffAlphaCalc_TransAlphaBuf_BuildFromRGBA_16(gb:TGraphBuf):TRect;
var
    x,y:integer;
    alpha:BYTE;
begin
    if (gb.FLenX<1) or (gb.FLenY<1) then raise Exception.Create('Error: size');
    if (gb.FChannels<4) then raise Exception.Create('Error: channels');

	// Top
    y:=0;
    while y<gb.FLenY do begin
        x:=0;
        while x<gb.FLenX do begin
            alpha:=(gb.PixelChannel(x,y,3)) and $0fc;
            if (alpha<>$0fc) and (alpha<>0) then break;
            inc(x);
        end;
        if x<gb.FLenX then break;
        inc(y);
	end;
	if y>=gb.FLenY then begin
		Result.Left:=0; Result.Top:=0;
		Result.Right:=0; Result.Bottom:=0;
		Exit;
	end;
	Result.Top:=y;

    y:=gb.FLenY-1;
    while y>=0 do begin
        x:=0;
        while x<gb.FLenX do begin
            alpha:=(gb.PixelChannel(x,y,3)) and $0fc;
            if (alpha<>$0fc) and (alpha<>0) then break;
            inc(x);
        end;
        if x<gb.FLenX then break;
        dec(y);
	end;
	Result.Bottom:=y+1;

    x:=0;
    while x<gb.FLenX do begin
        y:=0;
        while y<gb.FLenY do begin
            alpha:=(gb.PixelChannel(x,y,3)) and $0fc;
            if (alpha<>$0fc) and (alpha<>0) then break;
            inc(y);
        end;
        if y<gb.FLenY then break;
        inc(x);
	end;
	Result.Left:=x;

    x:=gb.FLenX-1;
    while x>=0 do begin
        y:=0;
        while y<gb.FLenY do begin
            alpha:=(gb.PixelChannel(x,y,3)) and $0fc;
            if (alpha<>$0fc) and (alpha<>0) then break;
            inc(y);
        end;
        if y<gb.FLenY then break;
        dec(x);
	end;
	Result.Right:=x+1;
end;

function OCutOffAlphaCalc_TransBuf_Build_WORD(gb:TGraphBuf; colorTrans:WORD):TRect;
var
    x,y:integer;
    color:WORD;
begin
    if (gb.FLenX<1) or (gb.FLenY<1) then raise Exception.Create('Error: size');
    if (gb.FChannels<>2) then raise Exception.Create('Error: channels');

	// Top
    y:=0;
    while y<gb.FLenY do begin
        x:=0;
        while x<gb.FLenX do begin
            color:=PGetWORD(gb.PixelBuf(x,y));
            if (color<>colorTrans) then break;
            inc(x);
        end;
        if x<gb.FLenX then break;
        inc(y);
	end;
	if y>=gb.FLenY then begin
		Result.Left:=0; Result.Top:=0;
		Result.Right:=0; Result.Bottom:=0;
		Exit;
	end;
	Result.Top:=y;

    y:=gb.FLenY-1;
    while y>=0 do begin
        x:=0;
        while x<gb.FLenX do begin
            color:=PGetWORD(gb.PixelBuf(x,y));
            if (color<>colorTrans) then break;
            inc(x);
        end;
        if x<gb.FLenX then break;
        dec(y);
	end;
	Result.Bottom:=y+1;

    x:=0;
    while x<gb.FLenX do begin
        y:=0;
        while y<gb.FLenY do begin
            color:=PGetWORD(gb.PixelBuf(x,y));
            if (color<>colorTrans) then break;
            inc(y);
        end;
        if y<gb.FLenY then break;
        inc(x);
	end;
	Result.Left:=x;

    x:=gb.FLenX-1;
    while x>=0 do begin
        y:=0;
        while y<gb.FLenY do begin
            color:=PGetWORD(gb.PixelBuf(x,y));
            if (color<>colorTrans) then break;
            inc(y);
        end;
        if y<gb.FLenY then break;
        dec(x);
	end;
	Result.Right:=x+1;
end;


procedure ODithering16bit(sou,des:TGraphBuf);
var
    x,y:integer;
    cr,cg,cb,ca,dr,dg,db,_r,_g,_b:DWORD;
    col,col2:DWORD;
begin
    if (sou.FLenX<1) or (sou.FLenY<1) then raise Exception.Create('Error: size');
    if (sou.FChannels<4) then raise Exception.Create('Error: channels');

    des.FillZero;

    for y:=0 to sou.FLenY-1 do begin
        for x:=0 to sou.FLenX-1 do begin
            col:=PGetDWORD(sou.PixelBuf(x,y));
            cr:=((col) and $ff);
            cg:=((col shr 8) and $ff);
            cb:=((col shr 16) and $ff);
            ca:=((col shr 24) and $ff);

            col2:=PGetDWORD(des.PixelBuf(x,y));
            dr:=((col2) and $ff);
            dg:=((col2 shr 8) and $ff);
            db:=((col2 shr 16) and $ff);

            cr:=cr+dr; if cr>255 then cr:=255;
            cg:=cg+dg; if cg>255 then cg:=255;
            cb:=cb+db; if cb>255 then cb:=255;

            dr:=(((cr shr 3) shl 3) and 255);
            dg:=(((cg shr 2) shl 2) and 255);
            db:=(((cb shr 3) shl 3) and 255);

            _r:=cr-dr;
            _g:=cg-dg;
            _b:=cb-db;

            cr:=Round(_r*(7/16));
            cg:=Round(_g*(7/16));
            cb:=Round(_b*(7/16));
            col:=(DWORD(cr)) or (DWORD(cg) shl 8) or (DWORD(cb) shl 16);
            if (col<>0) and (x<(sou.FLenX-1)) then PSet(des.PixelBuf(x+1,y),col);

            cr:=Round(_r*(5/16));
            cg:=Round(_g*(5/16));
            cb:=Round(_b*(5/16));
            col:=(DWORD(cr)) or (DWORD(cg) shl 8) or (DWORD(cb) shl 16);
            if (col<>0) and (y<(sou.FLenY-1)) then PSet(des.PixelBuf(x,y+1),col);

            cr:=Round(_r*(1/16));
            cg:=Round(_g*(1/16));
            cb:=Round(_b*(1/16));
            col:=(DWORD(cr)) or (DWORD(cg) shl 8) or (DWORD(cb) shl 16);
            if (col<>0) and (x<(sou.FLenX-1)) and (y<(sou.FLenY-1)) then PSet(des.PixelBuf(x+1,y+1),col);

            cr:=Round(_r*(3/16));
            cg:=Round(_g*(3/16));
            cb:=Round(_b*(3/16));
            col:=(DWORD(cr)) or (DWORD(cg) shl 8) or (DWORD(cb) shl 16);
            if (col<>0) and (x>0) and (y<(sou.FLenY-1)) then PSet(des.PixelBuf(x-1,y+1),col);

{            cr:=Round(_r / 4);
            cg:=Round(_g / 4);
            cb:=Round(_b / 4);
            col:=(DWORD(cr)) or (DWORD(cg) shl 8) or (DWORD(cb) shl 16);
            if (col<>0) and (x<(sou.FLenX-1)) then PSet(des.PixelBuf(x+1,y),col);
            if (col<>0) and (y<(sou.FLenY-1)) then PSet(des.PixelBuf(x,y+1),col);

            cr:=Round(_r*(3/8));
            cg:=Round(_g*(3/8));
            cb:=Round(_b*(3/8));
            col:=(DWORD(cr)) or (DWORD(cg) shl 8) or (DWORD(cb) shl 16);
            if (col<>0) and (x<(sou.FLenX-1)) and (y<(sou.FLenY-1)) then PSet(des.PixelBuf(x+1,y+1),col);
}
            PSet(des.PixelBuf(x,y),(DWORD(dr)) or (DWORD(dg) shl 8) or (DWORD(db) shl 16) or (DWORD(ca) shl 24));
        end;
    end;
end;

procedure OSplit_ForAlphaIndexed(sou,desCopy,desAlpha:TGraphBuf);
var
    x,y:integer;
    soucolor,copycolor,alphacolor,alpha:DWORD;
begin
    desCopy.ImageCreate(sou.FLenX,sou.FLenY,sou.FChannels,sou.FLenLine);
    desAlpha.ImageCreate(sou.FLenX,sou.FLenY,sou.FChannels,sou.FLenLine);

    for y:=0 to sou.FLenY-1 do begin
        for x:=0 to sou.FLenX-1 do begin
            soucolor:=PGetDWORD(sou.PixelBuf(x,y));
            copycolor:=0;
            alphacolor:=0;
            alpha:=(soucolor shr 24) and $0fc;
            if (alpha>0) then begin
                if alpha<$0fc then alphacolor:=soucolor
                else copycolor:=soucolor;
            end;
            PSet(desCopy.PixelBuf(x,y),DWORD(copycolor));
            PSet(desAlpha.PixelBuf(x,y),DWORD(alphacolor));
        end;
    end;
end;

end.
