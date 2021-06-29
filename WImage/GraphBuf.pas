unit GraphBuf;

interface

uses Math,Windows,SysUtils,Classes,Dialogs,EC_File,EC_Buf;

function OKGF_ReadStart_File(filename:PChar; lenx:PDWORD; leny:PDWORD): DWORD; cdecl; external 'okgf.dll' name 'OKGF_ReadStart_File';
function OKGF_ReadStart_Buf(soubuf:Pointer; soubuflen:DWORD; lenx:PDWORD; leny:PDWORD): DWORD; cdecl; external 'okgf.dll' name 'OKGF_ReadStart_Buf';
function OKGF_Read(id:DWORD; buf:Pointer; lenline:DWORD; mR,mG,mB,mD:DWORD; BytePP:DWORD): DWORD; cdecl; external 'okgf.dll' name 'OKGF_Read';

function OKGF_Write_PNG_File(filename:PChar; buf:Pointer; ll,lenx,leny:DWORD; alpha,rgb_to_bgr:integer): DWORD; cdecl; external 'okgf.dll' name 'OKGF_Write_PNG_File';

procedure OKGR_TransBuf_Draw_WORD(desbuf:Pointer; ll:DWORD; graphbuf:Pointer); cdecl; external 'okgf.dll' name 'OKGR_TransBuf_Draw_WORD';
procedure OKGR_TransBuf_Draw_5658(desbuf:Pointer; ll:DWORD; graphbuf:Pointer); cdecl; external 'okgf.dll' name 'OKGR_TransBuf_Draw_5658';
procedure OKGR_TransBuf_DrawClip_WORD(desbuf:Pointer; ll:DWORD; x,y:integer; graphbuf:Pointer; rc:PRECT); cdecl; external 'okgf.dll' name 'OKGR_TransBuf_DrawClip_WORD';
procedure OKGR_TransBuf_Convert565to555_WORD(graphbuf:Pointer); cdecl; external 'okgf.dll' name 'OKGR_TransBuf_Convert565to555_WORD';
procedure OKGR_TransBuf_HADrawClip_16(desbuf:Pointer; ll:DWORD; x,y:integer; graphbuf:Pointer; rc:PRECT); cdecl; external 'okgf.dll' name 'OKGR_TransBuf_HADrawClip_16';
procedure OKGR_TransBuf_HADrawClip_15(desbuf:Pointer; ll:DWORD; x,y:integer; graphbuf:Pointer; rc:PRECT); cdecl; external 'okgf.dll' name 'OKGR_TransBuf_HADrawClip_15';
function OKGR_TransBuf_Build_WORD(bufsou:Pointer; bufsoull:DWORD; lenx,leny:integer; graphbuf:Pointer; ctran:WORD):DWORD; cdecl; external 'okgf.dll' name 'OKGR_TransBuf_Build_WORD';
function OKGR_TransBuf_BuildFromRGBA_16(bufsou:Pointer; bufsoull:DWORD; lenx,leny:integer; graphbuf:Pointer):DWORD; cdecl; external 'okgf.dll' name 'OKGR_TransBuf_BuildFromRGBA_16';
function OKGR_TransBuf_BuildFromRGBA_15(bufsou:Pointer; bufsoull:DWORD; lenx,leny:integer; graphbuf:Pointer):DWORD; cdecl; external 'okgf.dll' name 'OKGR_TransBuf_BuildFromRGBA_15';

procedure OKGR_TransAlphaBuf_DrawClip_WORD(desbuf:Pointer; ll:DWORD; x,y:integer; graphbuf:Pointer; rc:PRECT); cdecl; external 'okgf.dll' name 'OKGR_TransAlphaBuf_DrawClip_WORD';
procedure OKGR_AlphaBuf_DrawClip_16(desbuf:Pointer; ll:DWORD; x,y:integer; graphbuf:Pointer; rc:PRECT); cdecl; external 'okgf.dll' name 'OKGR_AlphaBuf_DrawClip_16';
procedure OKGR_AlphaBuf_DrawClip_15(desbuf:Pointer; ll:DWORD; x,y:integer; graphbuf:Pointer; rc:PRECT); cdecl; external 'okgf.dll' name 'OKGR_AlphaBuf_DrawClip_15';
function OKGR_TransAlphaBuf_BuildFromRGBA_16(bufsou:Pointer; bufsoull:DWORD; lenx,leny:integer; graphbuf:Pointer):DWORD; cdecl; external 'okgf.dll' name 'OKGR_TransAlphaBuf_BuildFromRGBA_16';
function OKGR_TransAlphaBuf_BuildFromRGBA_15(bufsou:Pointer; bufsoull:DWORD; lenx,leny:integer; graphbuf:Pointer):DWORD; cdecl; external 'okgf.dll' name 'OKGR_TransAlphaBuf_BuildFromRGBA_15';
function OKGR_AlphaBuf_BuildFromRGBA(bufsou:Pointer; bufsoull:DWORD; lenx,leny:integer; graphbuf:Pointer):DWORD; cdecl; external 'okgf.dll' name 'OKGR_AlphaBuf_BuildFromRGBA';

procedure OKGR_AlphaSimpleBuf_Draw_16(desbuf:Pointer; desll,desx,desy:DWORD; soubuf:Pointer; soull,soux,souy:DWORD; lenx,leny:DWORD); cdecl; external 'okgf.dll' name 'OKGR_AlphaSimpleBuf_Draw_16';
procedure OKGR_AlphaSimpleBuf_Draw_15(desbuf:Pointer; desll,desx,desy:DWORD; soubuf:Pointer; soull,soux,souy:DWORD; lenx,leny:DWORD); cdecl; external 'okgf.dll' name 'OKGR_AlphaSimpleBuf_Draw_15';
procedure OKGR_AlphaSimpleBufPal_Draw_16(desbuf:Pointer; desll,desx,desy:DWORD; soubuf:Pointer; soull,soux,souy:DWORD; lenx,leny:DWORD;Pal:Pointer); cdecl; external 'okgf.dll' name 'OKGR_AlphaSimpleBufPal_Draw_16';
procedure OKGR_AlphaSimpleBufPal_Draw_15(desbuf:Pointer; desll,desx,desy:DWORD; soubuf:Pointer; soull,soux,souy:DWORD; lenx,leny:DWORD;Pal:Pointer); cdecl; external 'okgf.dll' name 'OKGR_AlphaSimpleBufPal_Draw_15';
procedure OKGR_AlphaSimpleBufPalAlpha_Draw_16(desbuf:Pointer; desll,desx,desy:DWORD; soubuf:Pointer; soull,soux,souy:DWORD; lenx,leny:DWORD;Pal:Pointer); cdecl; external 'okgf.dll' name 'OKGR_AlphaSimpleBufPalAlpha_Draw_16';
procedure OKGR_AlphaSimpleBufPalAlpha_Draw_15(desbuf:Pointer; desll,desx,desy:DWORD; soubuf:Pointer; soull,soux,souy:DWORD; lenx,leny:DWORD;Pal:Pointer); cdecl; external 'okgf.dll' name 'OKGR_AlphaSimpleBufPalAlpha_Draw_15';

procedure OKGR_AlphaBuf_Draw_5658(bufdes:Pointer; bufdesll:DWORD; graphbuf:Pointer); cdecl; external 'okgf.dll' name 'OKGR_AlphaBuf_Draw_5658';
procedure OKGR_TransAlphaBuf_Draw_5658(bufdes:Pointer; bufdesll:DWORD; graphbuf:Pointer); cdecl; external 'okgf.dll' name 'OKGR_TransAlphaBuf_Draw_5658';
procedure OKGR_AlphaIndexed_CopyDraw_5658(bufdes:Pointer; bufdesll:DWORD; graphbuf:Pointer); cdecl; external 'okgf.dll' name 'OKGR_AlphaIndexed_CopyDraw_5658';
procedure OKGR_AlphaIndexed_AlphaDraw_5658(bufdes:Pointer; bufdesll:DWORD; graphbuf:Pointer); cdecl; external 'okgf.dll' name 'OKGR_AlphaIndexed_AlphaDraw_5658';


procedure OKGF_Convert_8888to565(desbuf:Pointer; desll:DWORD; desx,desy:DWORD; sou:Pointer; soull,soux,souy,lenx,leny:DWORD); cdecl; external 'okgf.dll' name 'OKGF_Convert_8888to565';
procedure OKGF_Convert_8888to555(desbuf:Pointer; desll:DWORD; desx,desy:DWORD; sou:Pointer; soull,soux,souy,lenx,leny:DWORD); cdecl; external 'okgf.dll' name 'OKGF_Convert_8888to555';
procedure OKGF_Convert5658toRGBA(soubuf:Pointer; soull:DWORD; desbuf:Pointer; desll,lenx,leny:DWORD); cdecl; external 'okgf.dll' name 'OKGF_Convert5658toRGBA';
procedure OKGF_Convert565toRGBA(soubuf:Pointer; soull:DWORD; desbuf:Pointer; desll,lenx,leny:DWORD); cdecl; external 'okgf.dll' name 'OKGF_Convert565toRGBA';

//function IC_RGBAtoIndexed8(sou:Pointer; soull,souBPP:integer; mR,mG,mB,mA:DWORD; des:Pointer; desll:integer; despal:Pointer; lenx,leny:integer):integer; cdecl; external 'ImgCon.dll' name 'IC_RGBAtoIndexed8';
function OKGF_RGBAtoIndexed8(sou:Pointer; soull,souBPP:integer; mR,mG,mB,mA:DWORD; des:Pointer; desll:integer; despal:Pointer; lenx,leny:integer):integer; cdecl; external 'okgf.dll' name 'OKGF_RGBAtoIndexed8';

function OKGR_AlphaIndexed_CopyBuild_16(bufsou:Pointer; bufsounp,bufsoull:DWORD; palsou:Pointer; mask:Pointer; masknp,maskll:DWORD; lenx,leny:integer; graphbuf:Pointer):DWORD; cdecl; external 'okgf.dll' name 'OKGR_AlphaIndexed_CopyBuild_16';
function OKGR_AlphaIndexed_AlphaBuild_16(bufsou:Pointer; bufsounp,bufsoull:DWORD; palsou:Pointer; mask:Pointer; masknp,maskll:DWORD; lenx,leny:integer; graphbuf:Pointer):DWORD; cdecl; external 'okgf.dll' name 'OKGR_AlphaIndexed_AlphaBuild_16';

procedure OKGF_Rescale(dst:Pointer; dst_xsize,dst_ysize,dst_span:integer; src:Pointer; src_xsize,src_ysize,src_span:integer; channels:integer; nomfilter:integer); cdecl; external 'okgf.dll' name 'OKGF_Rescale';

function OKGF_ZLib_Compress(desbuf:Pointer; soubuf:Pointer; len_sou_and_des_buf:DWORD; fSpeed:integer=0): DWORD; cdecl; external 'okgf.dll' name 'OKGF_ZLib_Compress';
function OKGF_ZLib_UnCompress(desbuf:Pointer; lendesbuf:DWORD; soubuf:Pointer; lensoubuf:DWORD): DWORD; cdecl; external 'okgf.dll' name 'OKGF_ZLib_UnCompress';

type
PGIZag = ^SGIZag;
SGIZag = record
    id0,id1,id2,id3:BYTE;
    ver:DWORD;
    rect:TRect;
    mR:DWORD;
    mG:DWORD;
    mB:DWORD;
    mA:DWORD;
    format:DWORD;  // 0-bitmap 1-trans 2-alpha 3-IndexedAlpha8 4-bitmap pal 5-compressed anim
    countUnit:integer;
    countUpdateRect:integer;
    smeUpdateRect:DWORD;
    rz0:DWORD;
    rz1:DWORD;
end;

PGIUnit = ^SGIUnit;
SGIUnit = record
    sme:DWORD;
    size:integer;
    rect:TRect;
    r0:DWORD;
    r1:DWORD;
end;

TGraphBuf = class(TObject)
    public
        FPos:TPoint;

        FChannels:integer;
        FLenX:integer;
        FLenY:integer;
        FLenLine:integer;
        FBuf:Pointer;

        FPalCount:integer;
        FPal:Pointer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure ImageFree;
        procedure ImageCreate(lx,ly,channels:integer); overload;
        procedure ImageCreate(lx,ly,channels,ll:integer); overload;
        procedure PalFree;
        procedure PalCreate(cnt:integer);

        function PixelBuf(x,y:integer):Pointer;
        function PixelChannel(x,y,ch:integer):BYTE;
        procedure SetPixelChannel(x,y,ch:integer; zn:BYTE);

        function GetRect:TRect;
        function GetRectIntersect(rs:TGraphBuf):TRect;
        function RectWorldToBuf(rc:TRect):TRect;
        function PosWorldToBuf(tp:TPoint):TPoint;

        procedure Load(sou:TGraphBuf);
        procedure LoadRGBA(filename:string);
        procedure WritePNG(filename:string);
        procedure WriteGI_Alpha(filename:string);
        procedure WriteGI_Trans(filename:string);
        procedure WriteGI_AlphaIndexed8(filename:string);
        procedure WriteGI_Bitmap(filename:string);

        procedure BuildGI_Alpha(bd:TBufEC; autosize:boolean=true);
        procedure LoadGI_Alpha(bd:TBufEC);
        procedure BuildGI_Trans(bd:TBufEC; autosize:boolean=true);
        procedure LoadGI_Trans(bd:TBufEC);
        procedure BuildGI_AlphaIndexed8(bd:TBufEC; autosize:boolean=true);
        procedure LoadGI_AlphaIndexed8(bd:TBufEC);
        procedure BuildGI_BitmapPal(bd:TBufEC);
        procedure LoadGI_BitmapPal(bd:TBufEC);
        procedure BuildGI_Bitmap(bd:TBufEC; pf:integer=1); // 0-555 1-565 2-8888
        procedure LoadGI_Bitmap(bd:TBufEC);

        procedure FillZero;
        procedure FillZeroRect(rc:TRect);
        procedure FillRect(rc:TRect; col:DWORD);
        procedure FillRectChannel(ch:integer; rc:TRect; col:BYTE);
        procedure ShrRectChannel(ch:integer; rc:TRect; zn:BYTE);
        procedure ShlRectChannel(ch:integer; rc:TRect; zn:BYTE);
        procedure SwapChannels(c1,c2:integer);

        procedure Copy(pdes:TPoint; sou:TGraphBuf; sourect:TRect);

        procedure Draw(des:TGraphBuf; smedes:TPoint; rcsou:TRect; m_r,m_g,m_b,m_a:DWORD);
        procedure EndScale(_rsou:TRect; _rdes:TRect; des:TGraphBuf; mode:integer);
end;

implementation

uses EC_Mem,Globals,OImage;

constructor TGraphBuf.Create;
begin
    inherited Create;
end;

destructor TGraphBuf.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TGraphBuf.Clear;
begin
    PalFree;
    ImageFree;
end;

procedure TGraphBuf.ImageFree;
begin
    FChannels:=0;
    FLenX:=0;
    FLenY:=0;
    FLenLine:=0;
    if FBuf<>nil then begin FreeEC(FBuf); FBuf:=nil; end;
end;

procedure TGraphBuf.ImageCreate(lx,ly,channels:integer);
begin
    ImageFree;

    FChannels:=channels;
    FLenX:=lx;
    FLenY:=ly;
    FLenLine:=FLenX*FChannels;
    FBuf:=AllocEC(FLenLine*FLenY);
end;

procedure TGraphBuf.ImageCreate(lx,ly,channels,ll:integer);
begin
    ImageFree;

    FChannels:=channels;
    FLenX:=lx;
    FLenY:=ly;
    FLenLine:=ll;
    FBuf:=AllocEC(FLenLine*FLenY);
end;

procedure TGraphBuf.PalFree;
begin
    FPalCount:=0;
    if FPal<>nil then begin FreeEC(FPal); FPal:=nil; end;
end;

procedure TGraphBuf.PalCreate(cnt:integer);
begin
    PalFree;

    FPalCount:=cnt;
    FPal:=AllocEC(4*cnt);
end;

function TGraphBuf.PixelBuf(x,y:integer):Pointer;
begin
    Result:=PAdd(FBuf,(x*FChannels)+(y*FLenLine));
end;

function TGraphBuf.PixelChannel(x,y,ch:integer):BYTE;
begin
    Result:=PGetBYTE(PAdd(FBuf,(x*FChannels)+(y*FLenLine)+ch));
end;

procedure TGraphBuf.SetPixelChannel(x,y,ch:integer; zn:BYTE);
begin
    PSet(PAdd(FBuf,(x*FChannels)+(y*FLenLine)+ch),zn);
end;

function TGraphBuf.GetRect:TRect;
begin
    Result.Left:=FPos.x;
    Result.Top:=FPos.y;
    Result.Right:=FPos.x+FLenX;
    Result.Bottom:=FPos.y+FLenY;
end;

function TGraphBuf.GetRectIntersect(rs:TGraphBuf):TRect;
begin
    if not IntersectRect(Result,GetRect,rs.GetRect) then begin
        Result.Left:=0;
        Result.Top:=0;
        Result.Right:=0;
        Result.Bottom:=0;
    end;
end;

function TGraphBuf.RectWorldToBuf(rc:TRect):TRect;
begin
    Result.Left:=rc.Left-FPos.x;
    Result.Top:=rc.Top-FPos.y;
    Result.Right:=rc.Right-FPos.x;
    Result.Bottom:=rc.Bottom-FPos.y;
end;

function TGraphBuf.PosWorldToBuf(tp:TPoint):TPoint;
begin
    Result.x:=tp.x-FPos.x;
    Result.y:=tp.y-FPos.y;
end;

procedure TGraphBuf.Load(sou:TGraphBuf);
begin
    Clear;

    FChannels:=sou.FChannels;
    FLenX:=sou.FLenX;
    FLenY:=sou.FLenY;
    FLenLine:=sou.FLenLine;
    FBuf:=AllocEC(FLenLine*FLenY);
    CopyMemory(FBuf,sou.FBuf,FLenLine*FLenY);
end;

procedure TGraphBuf.LoadRGBA(filename:string);
var
    id:DWORD;
begin
    Clear;

    id:=OKGF_ReadStart_File(PChar(filename),@FLenX,@FLenY);
    if id=0 then raise Exception.Create('TGraphBuf.LoadRGBA. Error load file:'+filename);
    ImageCreate(FLenX,FLenY,4);
    id:=OKGF_Read(id,FBuf,FLenLine,$ff,$ff00,$ff0000,$ff000000,4);
    if id=0 then raise Exception.Create('TGraphBuf.LoadRGBA. Error load file:'+filename);
end;

procedure TGraphBuf.WritePNG(filename:string);
begin
    OKGF_Write_PNG_File(PChar(filename),FBuf,FLenLine,FLenX,FLenY,1,0);
end;

procedure TGraphBuf.WriteGI_Alpha(filename:string);
var
    bd:TBufEC;
begin
    bd:=TBufEC.Create;
    try
        BuildGI_Alpha(bd);
        bd.SaveInFile(PChar(filename));
    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;
    bd.Free;
end;
{var
    len:integer;
    zag:SGIZag;
    fi:TFileEC;
    tb:TBufEC;
begin
    SwapChannels(0,2);

    tb:=TBufEC.Create;

    fi:=TFileEC.Create;
    fi.Init(filename);
    fi.CreateNew;

    try
        zag.id0:=67;
        zag.id1:=69;
        zag.id2:=0;
        zag.id3:=0;
        zag.ver:=1;
        zag.rect.Left:=0;
        zag.rect.Top:=0;
        zag.rect.Right:=FLenX;
        zag.rect.Bottom:=FLenY;
        zag.mR:=$00000F800;
        zag.mG:=$0000007E0;
        zag.mB:=$00000001F;
        zag.mA:=$000000000;
        zag.format:=2;
        zag.sme0:=0;
        zag.sme1:=0;
        zag.sme2:=0;
        zag.countUpdateRect:=0;
        zag.smeUpdateRect:=0;
        fi.Write(@zag,sizeof(SGIZag));

        len:=OKGR_TransBuf_BuildFromRGBA_16(FBuf,FLenLine,FLenX,FLenY,nil);
        if len<1 then raise Exception.Create('Error save file.');
        tb.Len:=len;
        OKGR_TransBuf_BuildFromRGBA_16(FBuf,FLenLine,FLenX,FLenY,tb.Buf);
        zag.sme0:=fi.GetPointer;
        fi.Write(tb.Buf,len);

        len:=OKGR_TransAlphaBuf_BuildFromRGBA_16(FBuf,FLenLine,FLenX,FLenY,nil);
        if len<1 then raise Exception.Create('Error save file.');
        tb.Len:=len;
        OKGR_TransAlphaBuf_BuildFromRGBA_16(FBuf,FLenLine,FLenX,FLenY,tb.Buf);
        zag.sme1:=fi.GetPointer;
        fi.Write(tb.Buf,len);

        len:=OKGR_AlphaBuf_BuildFromRGBA(FBuf,FLenLine,FLenX,FLenY,nil);
        if len<1 then raise Exception.Create('Error save file.');
        tb.Len:=len;
        OKGR_AlphaBuf_BuildFromRGBA(FBuf,FLenLine,FLenX,FLenY,tb.Buf);
        zag.sme2:=fi.GetPointer;
        fi.Write(tb.Buf,len);

        fi.SetPointer(0);
        fi.Write(@zag,sizeof(SGIZag));
    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;

    fi.Free;
    tb.Free;

    SwapChannels(0,2);
end;}

procedure TGraphBuf.WriteGI_Trans(filename:string);
var
    bd:TBufEC;
begin
    bd:=TBufEC.Create;
    try
        BuildGI_Trans(bd);
        bd.SaveInFile(PChar(filename));
    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;
    bd.Free;
end;
{var
    len:integer;
    zag:SGIZag;
    fi:TFileEC;
    tb:TBufEC;
    gb:TGraphBuf;
begin
//    SwapChannels(0,2);

    tb:=TBufEC.Create;

    gb:=TGraphBuf.Create;
    gb.ImageCreate(FLenX,FlenY,2);
    OKGF_Convert_8888to565(gb.FBuf,gb.FLenLine,0,0,
                           FBuf,FLenLine,0,0,
                           FLenX,FLenY);

    fi:=TFileEC.Create;
    fi.Init(filename);
    fi.CreateNew;

    try
        zag.id0:=67;
        zag.id1:=69;
        zag.id2:=0;
        zag.id3:=0;
        zag.ver:=1;
        zag.rect.Left:=0;
        zag.rect.Top:=0;
        zag.rect.Right:=FLenX;
        zag.rect.Bottom:=FLenY;
        zag.mR:=$00000F800;
        zag.mG:=$0000007E0;
        zag.mB:=$00000001F;
        zag.mA:=$000000000;
        zag.format:=1;
        zag.sme0:=0;
        zag.sme1:=0;
        zag.sme2:=0;
        zag.countUpdateRect:=0;
        zag.smeUpdateRect:=0;
        fi.Write(@zag,sizeof(SGIZag));

        len:=OKGR_TransBuf_Build_WORD(gb.FBuf,gb.FLenLine,gb.FLenX,gb.FLenY,nil,0);
        if len<1 then raise Exception.Create('Error save file.');
        tb.Len:=len;
        OKGR_TransBuf_Build_WORD(gb.FBuf,gb.FLenLine,gb.FLenX,gb.FLenY,tb.Buf,0);
        zag.sme0:=fi.GetPointer;
        fi.Write(tb.Buf,len);

        fi.SetPointer(0);
        fi.Write(@zag,sizeof(SGIZag));
    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;

    fi.Free;
    gb.Free;
    tb.Free;

//    SwapChannels(0,2);
end;}

procedure TGraphBuf.WriteGI_AlphaIndexed8(filename:string);
var
    bd:TBufEC;
begin
    bd:=TBufEC.Create;
    try
        BuildGI_AlphaIndexed8(bd);
        bd.SaveInFile(PChar(filename));
    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;
    bd.Free;
end;

procedure TGraphBuf.WriteGI_Bitmap(filename:string);
var
    bd:TBufEC;
begin
    bd:=TBufEC.Create;
    try
        BuildGI_Bitmap(bd);
        bd.SaveInFile(PChar(filename));
    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;
    bd.Free;
end;

procedure TGraphBuf.BuildGI_Alpha(bd:TBufEC; autosize:boolean);
var
    len:integer;
    zag:SGIZag;
    zagunit:SGIUnit;
    tb:TBufEC;
begin
    bd.Clear;

    SwapChannels(0,2);

    tb:=TBufEC.Create;

        ZeroMemory(@zag,sizeof(SGIZag));
        zag.id0:=Ord('g');
        zag.id1:=Ord('i');
        zag.id2:=0;
        zag.id3:=0;
        zag.ver:=1;
        zag.rect.Left:=0;
        zag.rect.Top:=0;
        zag.rect.Right:=0;
        zag.rect.Bottom:=0;
        zag.mR:=$00000F800;
        zag.mG:=$0000007E0;
        zag.mB:=$00000001F;
        zag.mA:=$000000000;
        zag.format:=2;
        zag.countUnit:=3;
        zag.countUpdateRect:=0;
        zag.smeUpdateRect:=0;
        bd.Add(@zag,sizeof(SGIZag));

        ZeroMemory(@zagunit,sizeof(SGIUnit));
        bd.Add(@zagunit,sizeof(SGIUnit));
        bd.Add(@zagunit,sizeof(SGIUnit));
        bd.Add(@zagunit,sizeof(SGIUnit));

        if autosize then zagunit.rect:=OCutOffAlphaCalc_TransBuf_BuildFromRGBA_16(self)
        else begin zagunit.rect.TopLeft:=Point(0,0); zagunit.rect.BottomRight:=Point(FLenX,FLenY); end;
        if ((zagunit.rect.Right-zagunit.rect.Left)>0) and ((zagunit.rect.Right-zagunit.rect.Left)>0) then begin
            len:=OKGR_TransBuf_BuildFromRGBA_16(PixelBuf(zagunit.rect.left,zagunit.rect.top),FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,nil);
            if len<1 then raise Exception.Create('Error save file.');
            tb.Len:=len;
            OKGR_TransBuf_BuildFromRGBA_16(PixelBuf(zagunit.rect.left,zagunit.rect.top),FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,tb.Buf);
            zagunit.sme:=bd.Pointer;
            zagunit.size:=len;
            zagunit.rect.Left:=zagunit.rect.Left+FPos.x;
            zagunit.rect.Top:=zagunit.rect.Top+FPos.y;
            zagunit.rect.Right:=zagunit.rect.Right+FPos.x;
            zagunit.rect.Bottom:=zagunit.rect.Bottom+FPos.y;
            bd.Add(tb.Buf,len);
            bd.S(sizeof(SGIZag)+sizeof(SGIUnit)*0,@zagunit,sizeof(SGIUnit));

            zag.rect:=zagunit.rect;
        end;

        if autosize then zagunit.rect:=OCutOffAlphaCalc_TransAlphaBuf_BuildFromRGBA_16(self)
        else begin zagunit.rect.TopLeft:=Point(0,0); zagunit.rect.BottomRight:=Point(FLenX,FLenY); end;
        if ((zagunit.rect.Right-zagunit.rect.Left)>0) and ((zagunit.rect.Right-zagunit.rect.Left)>0) then begin
            len:=OKGR_TransAlphaBuf_BuildFromRGBA_16(PixelBuf(zagunit.rect.left,zagunit.rect.top),FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,nil);
            if len<1 then raise Exception.Create('Error save file.');
            tb.Len:=len;
            OKGR_TransAlphaBuf_BuildFromRGBA_16(PixelBuf(zagunit.rect.left,zagunit.rect.top),FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,tb.Buf);
            zagunit.sme:=bd.Pointer;
            zagunit.size:=len;
            zagunit.rect.Left:=zagunit.rect.Left+FPos.x;
            zagunit.rect.Top:=zagunit.rect.Top+FPos.y;
            zagunit.rect.Right:=zagunit.rect.Right+FPos.x;
            zagunit.rect.Bottom:=zagunit.rect.Bottom+FPos.y;
            bd.Add(tb.Buf,len);
            bd.S(sizeof(SGIZag)+sizeof(SGIUnit)*1,@zagunit,sizeof(SGIUnit));

            if ((zag.rect.right-zag.rect.left)<1) or ((zag.rect.bottom-zag.rect.top)<1) then begin
                zag.rect:=zagunit.rect;
            end else begin
                UnionRect(zag.rect,zag.rect,zagunit.rect);
            end;
        end;

        if autosize then zagunit.rect:=OCutOffAlphaCalc_TransAlphaBuf_BuildFromRGBA_16(self)
        else begin zagunit.rect.TopLeft:=Point(0,0); zagunit.rect.BottomRight:=Point(FLenX,FLenY); end;
        if ((zagunit.rect.Right-zagunit.rect.Left)>0) and ((zagunit.rect.Right-zagunit.rect.Left)>0) then begin
            len:=OKGR_AlphaBuf_BuildFromRGBA(PixelBuf(zagunit.rect.left,zagunit.rect.top),FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,nil);
            if len<1 then raise Exception.Create('Error save file.');
            tb.Len:=len;
            OKGR_AlphaBuf_BuildFromRGBA(PixelBuf(zagunit.rect.left,zagunit.rect.top),FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,tb.Buf);
            zagunit.sme:=bd.Pointer;
            zagunit.size:=len;
            zagunit.rect.Left:=zagunit.rect.Left+FPos.x;
            zagunit.rect.Top:=zagunit.rect.Top+FPos.y;
            zagunit.rect.Right:=zagunit.rect.Right+FPos.x;
            zagunit.rect.Bottom:=zagunit.rect.Bottom+FPos.y;
            bd.Add(tb.Buf,len);
            bd.S(sizeof(SGIZag)+sizeof(SGIUnit)*2,@zagunit,sizeof(SGIUnit));

            if ((zag.rect.right-zag.rect.left)<1) or ((zag.rect.bottom-zag.rect.top)<1) then begin
                zag.rect:=zagunit.rect;
            end else begin
                UnionRect(zag.rect,zag.rect,zagunit.rect);
            end;
        end;

        bd.S(0,@zag,sizeof(SGIZag));

    tb.Free;

    SwapChannels(0,2);
end;

procedure TGraphBuf.LoadGI_Alpha(bd:TBufEC);
var
    zag:SGIZag;
    zagunit0:SGIUnit;
    zagunit1:SGIUnit;
    zagunit2:SGIUnit;

    buf:Pointer;
    startsme:DWORD;
begin
    startsme:=bd.Pointer;
    bd.Get(@zag,sizeof(SGIZag));
    if zag.format<>2 then raise Exception.Create('Not alpha format.');

    ImageCreate(zag.rect.Right-zag.rect.Left,zag.rect.Bottom-zag.rect.Top,4);
    FPos:=zag.rect.TopLeft;
    buf:=AllocClearEC(FLenX*FLenY*3);

    bd.Get(@zagunit0,sizeof(SGIUnit));
    bd.Get(@zagunit1,sizeof(SGIUnit));
    bd.Get(@zagunit2,sizeof(SGIUnit));

    if zagunit2.sme<>0 then begin
        OKGR_AlphaBuf_Draw_5658(PAdd(buf,(zagunit2.rect.Left-FPos.x)*3+(zagunit2.rect.Top-FPos.y)*FLenX*3),FLenX*3,PAdd(bd.Buf,startsme+zagunit2.sme));
    end;

    if zagunit1.sme<>0 then begin
        OKGR_TransAlphaBuf_Draw_5658(PAdd(buf,(zagunit1.rect.Left-FPos.x)*3+(zagunit1.rect.Top-FPos.y)*FLenX*3),FLenX*3,PAdd(bd.Buf,startsme+zagunit1.sme));
    end;

    if zagunit0.sme<>0 then begin
        OKGR_TransBuf_Draw_5658(PAdd(buf,(zagunit0.rect.Left-FPos.x)*3+(zagunit0.rect.Top-FPos.y)*FLenX*3),FLenX*3,PAdd(bd.Buf,startsme+zagunit0.sme));
    end;

    OKGF_Convert5658toRGBA(buf,FLenX*3,FBuf,FLenLine,FLenX,FLenY);

    FreeEC(buf);
end;

procedure TGraphBuf.BuildGI_Trans(bd:TBufEC; autosize:boolean);
var
    len:integer;
    zag:SGIZag;
    zagunit:SGIUnit;
    tb:TBufEC;
    gb:TGraphBuf;
begin
    bd.Clear;
//    SwapChannels(0,2);

    tb:=TBufEC.Create;

    gb:=TGraphBuf.Create;
    gb.ImageCreate(FLenX,FlenY,2);
    OKGF_Convert_8888to565(gb.FBuf,gb.FLenLine,0,0,
                           FBuf,FLenLine,0,0,
                           FLenX,FLenY);

        ZeroMemory(@zag,sizeof(SGIZag));
        zag.id0:=Ord('g');
        zag.id1:=Ord('i');
        zag.id2:=0;
        zag.id3:=0;
        zag.ver:=1;
        zag.rect.Left:=0;
        zag.rect.Top:=0;
        zag.rect.Right:=0;
        zag.rect.Bottom:=0;
        zag.mR:=$00000F800;
        zag.mG:=$0000007E0;
        zag.mB:=$00000001F;
        zag.mA:=$000000000;
        zag.format:=1;
        zag.countUnit:=1;
        zag.countUpdateRect:=0;
        zag.smeUpdateRect:=0;
        bd.Add(@zag,sizeof(SGIZag));

        ZeroMemory(@zagunit,sizeof(SGIUnit));
        bd.Add(@zagunit,sizeof(SGIUnit));

        if autosize then zagunit.rect:=OCutOffAlphaCalc_TransBuf_Build_WORD(gb,0)
        else begin zagunit.rect.TopLeft:=Point(0,0); zagunit.rect.BottomRight:=Point(FLenX,FLenY); end;
        if ((zagunit.rect.Right-zagunit.rect.Left)>0) and ((zagunit.rect.Right-zagunit.rect.Left)>0) then begin
            len:=OKGR_TransBuf_Build_WORD(gb.PixelBuf(zagunit.rect.left,zagunit.rect.top),gb.FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,nil,0);
            if len<1 then raise Exception.Create('Error save file.');
            tb.Len:=len;
            OKGR_TransBuf_Build_WORD(gb.PixelBuf(zagunit.rect.left,zagunit.rect.top),gb.FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,tb.Buf,0);
            zagunit.sme:=bd.Pointer;
            zagunit.size:=len;
            zagunit.rect.Left:=zagunit.rect.Left+FPos.x;
            zagunit.rect.Top:=zagunit.rect.Top+FPos.y;
            zagunit.rect.Right:=zagunit.rect.Right+FPos.x;
            zagunit.rect.Bottom:=zagunit.rect.Bottom+FPos.y;
            bd.Add(tb.Buf,len);
            bd.S(sizeof(SGIZag)+sizeof(SGIUnit)*0,@zagunit,sizeof(SGIUnit));

            zag.rect:=zagunit.rect;
        end;

        bd.S(0,@zag,sizeof(SGIZag));

    gb.Free;
    tb.Free;

//    SwapChannels(0,2);
end;

procedure TGraphBuf.LoadGI_Trans(bd:TBufEC);
var
    zag:SGIZag;
    zagunit:SGIUnit;

    buf:Pointer;
begin
    bd.Get(@zag,sizeof(SGIZag));
    if zag.format<>1 then raise Exception.Create('Not trans format.');

    bd.Get(@zagunit,sizeof(SGIUnit));

    ImageCreate(zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,4);
    FPos:=zagunit.rect.TopLeft;

    buf:=AllocClearEC(FLenX*FLenY*3);

    OKGR_TransBuf_Draw_5658(buf,FLenX*3,PAdd(bd.Buf,bd.Pointer));

    OKGF_Convert5658toRGBA(buf,FLenX*3,FBuf,FLenLine,FLenX,FLenY);

    FreeEC(buf);
end;

//function OKGR_AlphaIndexed_CopyBuild_16(bufsou:Pointer; bufsounp,bufsoull:DWORD; palsou:Pointer; lenx,leny:integer; graphbuf:Pointer):DWORD; cdecl; external 'okgf.dll' name 'OKGR_AlphaIndexed_CopyBuild_16';
//function OKGR_AlphaIndexed_AlphaBuild_16(bufsou:Pointer; bufsounp,bufsoull:DWORD; palsou:Pointer; lenx,leny:integer; graphbuf:Pointer):DWORD; cdecl; external 'okgf.dll' name 'OKGR_AlphaIndexed_AlphaBuild_16';
procedure TGraphBuf.BuildGI_AlphaIndexed8(bd:TBufEC; autosize:boolean);
var
    im:TGraphBuf;
    imCopy,imAlpha:TGraphBuf;
    len:integer;
    zag:SGIZag;
    zagunit:SGIUnit;
    tb:TBufEC;
begin
    bd.Clear;

    if FChannels<>4 then Exit;

    im:=TGraphBuf.Create;
    imCopy:=TGraphBuf.Create;
    imAlpha:=TGraphBuf.Create;
    tb:=TBufEC.Create;

    try
        OSplit_ForAlphaIndexed(self,imCopy,imAlpha);

        ZeroMemory(@zag,sizeof(SGIZag));
        zag.id0:=Ord('g');
        zag.id1:=Ord('i');
        zag.id2:=0;
        zag.id3:=0;
        zag.ver:=1;
        zag.rect.Left:=0;
        zag.rect.Top:=0;
        zag.rect.Right:=0;
        zag.rect.Bottom:=0;
        zag.mR:=$00000F800;
        zag.mG:=$0000007E0;
        zag.mB:=$00000001F;
        zag.mA:=$000000000;
        zag.format:=3;
        zag.countUnit:=2;
        zag.countUpdateRect:=0;
        zag.smeUpdateRect:=0;
        bd.Add(@zag,sizeof(SGIZag));

        ZeroMemory(@zagunit,sizeof(SGIUnit));
        bd.Add(@zagunit,sizeof(SGIUnit));
        bd.Add(@zagunit,sizeof(SGIUnit));

        if autosize then zagunit.rect:=OCutOffAlphaCalc_TransBuf_BuildFromRGBA_16(imCopy)
        else begin zagunit.rect.TopLeft:=Point(0,0); zagunit.rect.BottomRight:=Point(FLenX,FLenY); end;
        if ((zagunit.rect.Right-zagunit.rect.Left)>0) and ((zagunit.rect.Right-zagunit.rect.Left)>0) then begin
            im.ImageCreate(FLenX,FLenY,1);
            im.PalCreate(256);
            if OKGF_RGBAtoIndexed8(imCopy.FBuf,imCopy.FLenLine,32,$ff,$ff00,$ff0000,$ff000000,im.FBuf,im.FLenLine,im.FPal,FLenX,FLenY)=0 then begin
                im.Free;
                raise Exception.Create('TGraphBuf.BuildGI_AlphaIndexed8');
            end;

            len:=OKGR_AlphaIndexed_CopyBuild_16(im.PixelBuf(zagunit.rect.left,zagunit.rect.top),1,im.FLenLine,im.FPal,PAdd(PixelBuf(zagunit.rect.left,zagunit.rect.top),3),4,FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,nil);
            if len<1 then raise Exception.Create('Error save file.');
            tb.Len:=len;
            OKGR_AlphaIndexed_CopyBuild_16(im.PixelBuf(zagunit.rect.left,zagunit.rect.top),1,im.FLenLine,im.FPal,PAdd(PixelBuf(zagunit.rect.left,zagunit.rect.top),3),4,FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,tb.Buf);
            zagunit.sme:=bd.Pointer;
            zagunit.size:=len;
            zagunit.rect.Left:=zagunit.rect.Left+FPos.x;
            zagunit.rect.Top:=zagunit.rect.Top+FPos.y;
            zagunit.rect.Right:=zagunit.rect.Right+FPos.x;
            zagunit.rect.Bottom:=zagunit.rect.Bottom+FPos.y;
            bd.Add(tb.Buf,len);
            bd.S(sizeof(SGIZag)+sizeof(SGIUnit)*0,@zagunit,sizeof(SGIUnit));

            zag.rect:=zagunit.rect;
        end;

        if autosize then zagunit.rect:=OCutOffAlphaCalc_TransAlphaBuf_BuildFromRGBA_16(imAlpha)
        else begin zagunit.rect.TopLeft:=Point(0,0); zagunit.rect.BottomRight:=Point(FLenX,FLenY); end;
        if ((zagunit.rect.Right-zagunit.rect.Left)>0) and ((zagunit.rect.Right-zagunit.rect.Left)>0) then begin
            im.ImageCreate(FLenX,FLenY,1);
            im.PalCreate(256);
            if OKGF_RGBAtoIndexed8(imAlpha.FBuf,imAlpha.FLenLine,32,$ff,$ff00,$ff0000,$ff000000,im.FBuf,im.FLenLine,im.FPal,FLenX,FLenY)=0 then begin
                im.Free; // Œ¯Ë·Í‡ ???!!!
                raise Exception.Create('TGraphBuf.BuildGI_AlphaIndexed8');
            end;

            len:=OKGR_AlphaIndexed_AlphaBuild_16(im.PixelBuf(zagunit.rect.left,zagunit.rect.top),1,im.FLenLine,im.FPal,PAdd(PixelBuf(zagunit.rect.left,zagunit.rect.top),3),4,FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,nil);
            if len<1 then raise Exception.Create('Error save file.');
            tb.Len:=len;
            OKGR_AlphaIndexed_AlphaBuild_16(im.PixelBuf(zagunit.rect.left,zagunit.rect.top),1,im.FLenLine,im.FPal,PAdd(PixelBuf(zagunit.rect.left,zagunit.rect.top),3),4,FLenLine,zagunit.rect.Right-zagunit.rect.Left,zagunit.rect.Bottom-zagunit.rect.Top,tb.Buf);
            zagunit.sme:=bd.Pointer;
            zagunit.size:=len;
            zagunit.rect.Left:=zagunit.rect.Left+FPos.x;
            zagunit.rect.Top:=zagunit.rect.Top+FPos.y;
            zagunit.rect.Right:=zagunit.rect.Right+FPos.x;
            zagunit.rect.Bottom:=zagunit.rect.Bottom+FPos.y;
            bd.Add(tb.Buf,len);
            bd.S(sizeof(SGIZag)+sizeof(SGIUnit)*1,@zagunit,sizeof(SGIUnit));

            if ((zag.rect.right-zag.rect.left)<1) or ((zag.rect.bottom-zag.rect.top)<1) then begin
                zag.rect:=zagunit.rect;
            end else begin
                UnionRect(zag.rect,zag.rect,zagunit.rect);
            end;
        end;

        bd.S(0,@zag,sizeof(SGIZag));

    finally
        imCopy.Free;
        imAlpha.Free;
        im.Free;
        tb.Free;
    end;

end;

procedure TGraphBuf.LoadGI_AlphaIndexed8(bd:TBufEC);
var
    zag:SGIZag;
    zagunit0:SGIUnit;
    zagunit1:SGIUnit;

    buf:Pointer;
    startsme:DWORD;
begin
    startsme:=bd.Pointer;
    bd.Get(@zag,sizeof(SGIZag));
    if zag.format<>3 then raise Exception.Create('Not alpha format.');

    ImageCreate(zag.rect.Right-zag.rect.Left,zag.rect.Bottom-zag.rect.Top,4);
    FPos:=zag.rect.TopLeft;
    buf:=AllocClearEC(FLenX*FLenY*3);

    bd.Get(@zagunit0,sizeof(SGIUnit));
    bd.Get(@zagunit1,sizeof(SGIUnit));

    if zagunit0.sme<>0 then begin
        OKGR_AlphaIndexed_CopyDraw_5658(PAdd(buf,(zagunit0.rect.Left-FPos.x)*3+(zagunit0.rect.Top-FPos.y)*FLenX*3),FLenX*3,PAdd(bd.Buf,startsme+zagunit0.sme));
    end;

    if zagunit1.sme<>0 then begin
        OKGR_AlphaIndexed_AlphaDraw_5658(PAdd(buf,(zagunit1.rect.Left-FPos.x)*3+(zagunit1.rect.Top-FPos.y)*FLenX*3),FLenX*3,PAdd(bd.Buf,startsme+zagunit1.sme));
    end;

    OKGF_Convert5658toRGBA(buf,FLenX*3,FBuf,FLenLine,FLenX,FLenY);

    FreeEC(buf);
end;

procedure TGraphBuf.BuildGI_BitmapPal(bd:TBufEC);
var
    im:TGraphBuf;
    tb:TBufEC;
    zag:SGIZag;
    zagunit:SGIUnit;
//    despal:Pointer;
//    i:integer;
//    r,g,b:DWORD;
begin
    bd.Clear;

    if FChannels<>4 then Exit;

    tb:=TBufEC.Create;
    im:=TGraphBuf.Create;

    try
        ZeroMemory(@zag,sizeof(SGIZag));
        zag.id0:=Ord('g');
        zag.id1:=Ord('i');
        zag.id2:=0;
        zag.id3:=0;
        zag.ver:=1;
        zag.rect.Left:=0;
        zag.rect.Top:=0;
        zag.rect.Right:=0;
        zag.rect.Bottom:=0;
        zag.rect:=GetRect;
        zag.mR:=$00000F800;
        zag.mG:=$0000007E0;
        zag.mB:=$00000001F;
        zag.mA:=$000000000;
        zag.format:=4;
        zag.countUnit:=2;
        zag.countUpdateRect:=0;
        zag.smeUpdateRect:=0;
        bd.Add(@zag,sizeof(SGIZag));

        ZeroMemory(@zagunit,sizeof(SGIUnit));
        bd.Add(@zagunit,sizeof(SGIUnit));
        bd.Add(@zagunit,sizeof(SGIUnit));

        im.ImageCreate(FLenX,FLenY,1,FLenX);
        im.PalCreate(256);
        if OKGF_RGBAtoIndexed8(FBuf,FLenLine,32,$ff,$ff00,$ff0000,$ff000000,im.FBuf,im.FLenLine,im.FPal,FLenX,FLenY)=0 then begin
            raise Exception.Create('TGraphBuf.BuildGI_BitmapPal');
        end;

{        despal:=AllocEC(256*2);
        for i:=0 to 256-1 do begin
            r:=PGetBYTE(PAdd(im.FPal,i*4+0));
            g:=PGetBYTE(PAdd(im.FPal,i*4+1));
            b:=PGetBYTE(PAdd(im.FPal,i*4+2));

            PSet(PAdd(despal,i*2),WORD(((r shr 3) shl 11) or ((g shr 2) shl 5) or ((b shr 3))));
        end;}

        zagunit.sme:=bd.Pointer;
        zagunit.size:=FLenX*FLenY;
        zagunit.rect:=GetRect;
        bd.Add(im.FBuf,zagunit.size);
        bd.S(sizeof(SGIZag)+sizeof(SGIUnit)*0,@zagunit,sizeof(SGIUnit));

        zagunit.sme:=bd.Pointer;
        zagunit.size:=256*4;
        zagunit.rect:=Rect(0,0,0,0);
        bd.Add(im.FPal,zagunit.size);
        bd.S(sizeof(SGIZag)+sizeof(SGIUnit)*1,@zagunit,sizeof(SGIUnit));

//        FreeEC(despal);
    finally
        im.Free;
        tb.Free;
    end;
end;

procedure TGraphBuf.LoadGI_BitmapPal(bd:TBufEC);
var
    zag:SGIZag;
    zagunit:SGIUnit;

    startsme:DWORD;
    soubuf,desbuf,pal:Pointer;
    col,x,y:DWORD;
begin
    startsme:=bd.Pointer;
    bd.Get(@zag,sizeof(SGIZag));
    if zag.format<>4 then raise Exception.Create('Not bitmappal format.');

    ImageCreate(zag.rect.Right-zag.rect.Left,zag.rect.Bottom-zag.rect.Top,4);
    FPos:=zag.rect.TopLeft;

    bd.Get(@zagunit,sizeof(SGIUnit));
    soubuf:=PAdd(bd.Buf,startsme+zagunit.sme);
    bd.Get(@zagunit,sizeof(SGIUnit));
    pal:=PAdd(bd.Buf,startsme+zagunit.sme);

    desbuf:=FBuf;

    for y:=0 to FLenY-1 do begin
        for x:=0 to FLenX-1 do begin
            col:=PGetDWORD(PAdd(Pal,PGetBYTE(soubuf)*4));

            PSet(desbuf,col);

            soubuf:=PAdd(soubuf,1);
            desbuf:=PAdd(desbuf,4);
        end;
        desbuf:=PAdd(desbuf,FLenLine-FLenX*4);
    end;
end;

procedure TGraphBuf.BuildGI_Bitmap(bd:TBufEC; pf:integer);
var
    im:TGraphBuf;
    tb:TBufEC;
    zag:SGIZag;
    zagunit:SGIUnit;
begin
    bd.Clear;

    if FChannels<>4 then Exit;

    tb:=TBufEC.Create;
    im:=TGraphBuf.Create;

    try
        ZeroMemory(@zag,sizeof(SGIZag));
        zag.id0:=Ord('g');
        zag.id1:=Ord('i');
        zag.id2:=0;
        zag.id3:=0;
        zag.ver:=1;
        zag.rect.Left:=0;
        zag.rect.Top:=0;
        zag.rect.Right:=0;
        zag.rect.Bottom:=0;
        zag.rect:=GetRect;
        if pf=0 then begin
            zag.mR:=$000007c00;
            zag.mG:=$0000003e0;
            zag.mB:=$00000001F;
            zag.mA:=$000000000;
        end else if pf=1 then begin
            zag.mR:=$00000F800;
            zag.mG:=$0000007E0;
            zag.mB:=$00000001F;
            zag.mA:=$000000000;
        end else begin
            zag.mR:=$000ff0000;
            zag.mG:=$00000ff00;
            zag.mB:=$0000000fF;
            zag.mA:=$0ff000000;
        end;
        zag.format:=0;
        zag.countUnit:=1;
        zag.countUpdateRect:=0;
        zag.smeUpdateRect:=0;
        bd.Add(@zag,sizeof(SGIZag));

        ZeroMemory(@zagunit,sizeof(SGIUnit));
        bd.Add(@zagunit,sizeof(SGIUnit));

        if pf=0 then begin
            im.ImageCreate(FLenX,FLenY,2,FLenX*2);
            OKGF_Convert_8888to555(im.FBuf,im.FLenLine,0,0,
                                   FBuf,FLenLine,0,0,
                                   FLenX,FLenY);
            zagunit.sme:=bd.Pointer;
            zagunit.size:=im.FLenLine*FLenY;
            zagunit.rect:=GetRect;
            bd.Add(im.FBuf,zagunit.size);
        end else if pf=1 then begin
            im.ImageCreate(FLenX,FLenY,2,FLenX*2);
            OKGF_Convert_8888to565(im.FBuf,im.FLenLine,0,0,
                                   FBuf,FLenLine,0,0,
                                   FLenX,FLenY);
            zagunit.sme:=bd.Pointer;
            zagunit.size:=im.FLenLine*FLenY;
            zagunit.rect:=GetRect;
            bd.Add(im.FBuf,zagunit.size);
        end else if pf=2 then begin
            SwapChannels(0,2);
            zagunit.sme:=bd.Pointer;
            zagunit.size:=FLenLine*FLenY;
            zagunit.rect:=GetRect;
            bd.Add(FBuf,zagunit.size);
            SwapChannels(0,2);
        end;

        bd.S(sizeof(SGIZag)+sizeof(SGIUnit)*0,@zagunit,sizeof(SGIUnit));

    finally
        im.Free;
        tb.Free;
    end;
end;

procedure TGraphBuf.LoadGI_Bitmap(bd:TBufEC);
var
    zag:SGIZag;
    zagunit:SGIUnit;

    startsme:DWORD;
begin
    startsme:=bd.Pointer;
    bd.Get(@zag,sizeof(SGIZag));
    if zag.format<>0 then raise Exception.Create('Not bitmap format.');

    ImageCreate(zag.rect.Right-zag.rect.Left,zag.rect.Bottom-zag.rect.Top,4);
    FPos:=zag.rect.TopLeft;

    bd.Get(@zagunit,sizeof(SGIUnit));

    OKGF_Convert565toRGBA(PAdd(bd.Buf,startsme+zagunit.sme),FLenX*2,FBuf,FLenLine,FLenX,FLenY);
end;

procedure TGraphBuf.FillZero;
begin
    ZeroMemory(FBuf,FLenLine*FLenY);
end;

procedure TGraphBuf.FillZeroRect(rc:TRect);
var
    lx,ly,ll:integer;
    tbuf:Pointer;
label a1_m1;
begin
    lx:=rc.Right-rc.Left;
    ly:=rc.Bottom-rc.Top;
    ll:=FLenLine-lx*FChannels;
    tbuf:=PixelBuf(rc.Left,rc.Top);

    if FChannels=4 then begin
        asm
            push    esi
            push    edi
            push    eax
            push    ecx
            push    ebx
            push    edx

            xor     eax,eax
            mov     edi,tbuf
            mov     edx,ly
            mov     ecx,lx
            mov     ebx,ecx
            mov     esi,ll

a1_m1:      mov     [edi],eax
            add     edi,4
            dec     ecx
            jnz     a1_m1
            mov     ecx,ebx
            add     edi,esi
            dec     edx
            jnz     a1_m1

            pop    edx
            pop    ebx
            pop    ecx
            pop    eax
            pop    edi
            pop    esi
        end;
    end;
end;

procedure TGraphBuf.FillRect(rc:TRect; col:DWORD);
var
    lx,ly,ll:integer;
    tbuf:Pointer;
label a1_m1,a2_m1;
begin
    lx:=rc.Right-rc.Left;
    ly:=rc.Bottom-rc.Top;
    ll:=FLenLine-lx*FChannels;
    tbuf:=PixelBuf(rc.Left,rc.Top);

    if FChannels=1 then begin
        asm
            push    esi
            push    edi
            push    eax
            push    ecx
            push    ebx
            push    edx

            mov     eax,col
            mov     edi,tbuf
            mov     edx,ly
            mov     ecx,lx
            mov     ebx,ecx
            mov     esi,ll

a2_m1:      mov     [edi],al
            add     edi,1
            dec     ecx
            jnz     a2_m1
            mov     ecx,ebx
            add     edi,esi
            dec     edx
            jnz     a2_m1

            pop    edx
            pop    ebx
            pop    ecx
            pop    eax
            pop    edi
            pop    esi
        end;
    end else if FChannels=4 then begin
        asm
            push    esi
            push    edi
            push    eax
            push    ecx
            push    ebx
            push    edx

            mov     eax,col
            mov     edi,tbuf
            mov     edx,ly
            mov     ecx,lx
            mov     ebx,ecx
            mov     esi,ll

a1_m1:      mov     [edi],eax
            add     edi,4
            dec     ecx
            jnz     a1_m1
            mov     ecx,ebx
            add     edi,esi
            dec     edx
            jnz     a1_m1

            pop    edx
            pop    ebx
            pop    ecx
            pop    eax
            pop    edi
            pop    esi
        end;
    end;
end;

procedure TGraphBuf.FillRectChannel(ch:integer; rc:TRect; col:BYTE);
var
    lx,ly,ll,np:integer;
    tbuf:Pointer;
label a1_m1,a2_m1;
begin
    lx:=rc.Right-rc.Left;
    ly:=rc.Bottom-rc.Top;
    ll:=FLenLine-lx*FChannels;
    np:=FChannels;
    tbuf:=PAdd(PixelBuf(rc.Left,rc.Top),ch);

        asm
            push    esi
            push    edi
            push    eax
            push    ecx
            push    ebx
            push    edx

            mov     al,col
            mov     edi,tbuf
            mov     edx,ly
            mov     ecx,lx
            mov     ebx,np
            mov     esi,ll

a2_m1:      mov     [edi],al
            add     edi,ebx
            dec     ecx
            jnz     a2_m1
            mov     ecx,lx
            add     edi,esi
            dec     edx
            jnz     a2_m1

            pop    edx
            pop    ebx
            pop    ecx
            pop    eax
            pop    edi
            pop    esi
        end;
end;


procedure TGraphBuf.ShrRectChannel(ch:integer; rc:TRect; zn:BYTE);
var
    lx,ly,ll,np:integer;
    tbuf:Pointer;
label a1_m1,a2_m1;
begin
    lx:=rc.Right-rc.Left;
    ly:=rc.Bottom-rc.Top;
    ll:=FLenLine-lx*FChannels;
    np:=FChannels;
    tbuf:=PAdd(PixelBuf(rc.Left,rc.Top),ch);

        asm
            push    esi
            push    edi
            push    eax
            push    ecx
            push    ebx
            push    edx

            mov     cl,zn
            mov     edi,tbuf
            mov     edx,ly
            mov     eax,lx
            mov     ebx,np
            mov     esi,ll

a2_m1:
            shr     [edi],cl

            add     edi,ebx
            dec     eax
            jnz     a2_m1
            mov     eax,lx
            add     edi,esi
            dec     edx
            jnz     a2_m1

            pop    edx
            pop    ebx
            pop    ecx
            pop    eax
            pop    edi
            pop    esi
        end;
end;

procedure TGraphBuf.ShlRectChannel(ch:integer; rc:TRect; zn:BYTE);
var
    lx,ly,ll,np:integer;
    tbuf:Pointer;
label a1_m1,a2_m1;
begin
    lx:=rc.Right-rc.Left;
    ly:=rc.Bottom-rc.Top;
    ll:=FLenLine-lx*FChannels;
    np:=FChannels;
    tbuf:=PAdd(PixelBuf(rc.Left,rc.Top),ch);

        asm
            push    esi
            push    edi
            push    eax
            push    ecx
            push    ebx
            push    edx

            mov     cl,zn
            mov     edi,tbuf
            mov     edx,ly
            mov     eax,lx
            mov     ebx,np
            mov     esi,ll

a2_m1:
            shl     [edi],cl

            add     edi,ebx
            dec     eax
            jnz     a2_m1
            mov     eax,lx
            add     edi,esi
            dec     edx
            jnz     a2_m1

            pop    edx
            pop    ebx
            pop    ecx
            pop    eax
            pop    edi
            pop    esi
        end;
end;

procedure TGraphBuf.SwapChannels(c1,c2:integer);
var
    lx,ly,ll:integer;
    tbuf:Pointer;
label a1_m1;
begin
    if (FLenX<1) or (FLenY<1) then Exit;
    lx:=FLenX;
    ly:=FLenY;
    ll:=FLenLine-FLenX*FChannels;
    tbuf:=FBuf;

    if (FChannels=4) and (c1=0) and (c2=2) then begin
        asm
            push    esi
            push    edi
            push    eax
            push    ecx
            push    ebx
            push    edx

            mov     edi,tbuf
            mov     edx,ly
            mov     ecx,lx
            mov     ebx,ecx
            mov     esi,ll

a1_m1:      mov     al,[edi]
            xchg    al,[edi+2]
            mov     [edi],al

            add     edi,4
            dec     ecx
            jnz     a1_m1
            mov     ecx,ebx
            add     edi,esi
            dec     edx
            jnz     a1_m1

            pop    edx
            pop    ebx
            pop    ecx
            pop    eax
            pop    edi
            pop    esi
        end;
    end;
end;

procedure TGraphBuf.Copy(pdes:TPoint; sou:TGraphBuf; sourect:TRect);
var
    soubuf,desbuf,bufpal:Pointer;
    lenx,leny,sounl,desnl:integer;
label a1_m1,a2_m1,a3_m1;
begin
    soubuf:=sou.PixelBuf(sourect.Left,sourect.Top);
    lenx:=sourect.Right-sourect.Left;
    leny:=sourect.Bottom-sourect.Top;
    sounl:=sou.FLenLine-lenx*sou.FChannels;

    desbuf:=PixelBuf(pdes.x,pdes.y);
    desnl:=FlenLine-lenx*FChannels;

    if (sou.FChannels=1) and (FChannels=1) then begin
        asm
            push eax
            push ecx
            push ebx
            push edx
            push esi
            push edi

            mov     esi,soubuf
            mov     edi,desbuf
            mov     ecx,lenx
            mov     edx,leny
            mov     ebx,ecx

a1_m1:      mov     al,[esi]
            mov     [edi],al
            inc     esi
            inc     edi

            dec     ecx
            jnz     a1_m1
            mov     ecx,ebx
            add     esi,sounl
            add     edi,desnl
            dec     edx
            jnz     a1_m1

            pop edi
            pop esi
            pop edx
            pop ebx
            pop ecx
            pop eax
        end;
    end else if (sou.FChannels=4) and (FChannels=4) then begin
        asm
            push eax
            push ecx
            push ebx
            push edx
            push esi
            push edi

            mov     esi,soubuf
            mov     edi,desbuf
            mov     ecx,lenx
            mov     edx,leny
            mov     ebx,ecx

a2_m1:      mov     eax,[esi]
            mov     [edi],eax
            add     esi,4
            add     edi,4

            dec     ecx
            jnz     a2_m1
            mov     ecx,ebx
            add     esi,sounl
            add     edi,desnl
            dec     edx
            jnz     a2_m1

            pop edi
            pop esi
            pop edx
            pop ebx
            pop ecx
            pop eax
        end;
    end else if (sou.FChannels=1) and (sou.FPalCount=256) and (FChannels=4) then begin
        bufpal:=sou.FPal;
        asm
            push eax
            push ecx
            push ebx
            push edx
            push esi
            push edi

            mov     esi,soubuf
            mov     edi,desbuf
            mov     ecx,lenx
            mov     edx,leny
            mov     ebx,bufpal

a3_m1:      xor     eax,eax
            mov     al,[esi]
            mov     eax,[ebx+eax*4]
            mov     [edi],eax
            add     esi,1
            add     edi,4

            dec     ecx
            jnz     a3_m1
            mov     ecx,lenx
            add     esi,sounl
            add     edi,desnl
            dec     edx
            jnz     a3_m1

            pop edi
            pop esi
            pop edx
            pop ebx
            pop ecx
            pop eax
        end;
    end;
end;

procedure TGraphBuf.Draw(des:TGraphBuf; smedes:TPoint; rcsou:TRect; m_r,m_g,m_b,m_a:DWORD);
var
    soulenx,souleny:integer;
    y:integer;
    bsou,bdes:Pointer;
    bsounp,bdesnp:integer;
    bsounl,bdesnl:integer;
label a1_m1,a1_m2,a2_m1,a2_m2,a3_m1,a3_m2,a4_m1,a4_m2;
begin
{    rc.Left:=rc.Left-FPos.x;
    rc.Top:=rc.Top-FPos.y;
    rc.Right:=rc.Right-FPos.x;
    rc.Bottom:=rc.Bottom-FPos.y;}

{    desx:=FPos.x+sme.x;
    desy:=FPos.y+sme.y;

    if (desx>=rc.Right) or (desy>=rc.Bottom) or (desx+integer(FLenX)-1<rc.Left) or (desy+integer(FLenY)-1<rc.Top) then Exit;

    soux:=0; souy:=0;

    soulenx:=FLenX;
    souleny:=FLenY;
    if desx+integer(soulenx)-1>=rc.Right then soulenx:=soulenx-((desx+soulenx-1)-(rc.Right-1));
    if desy+integer(souleny)-1>=rc.Bottom then souleny:=souleny-((desy+souleny-1)-(rc.Bottom-1));

    if desx<rc.Left then begin
        soux:=rc.Left-desx;
        soulenx:=soulenx-soux;
        desx:=rc.Left;
    end;
    if desy<rc.Top then begin
        souy:=rc.Top-desy;
        souleny:=souleny-souy;
        desy:=rc.Top;
    end;}

    soulenx:=rcsou.Right-rcsou.Left;
    souleny:=rcsou.Bottom-rcsou.Top;

    bsou:=PixelBuf(rcsou.Left,rcsou.Top);
    bdes:=des.PixelBuf(smedes.x,smedes.y);

    bsounp:=FChannels;
    bdesnp:=des.FChannels;
    bsounl:=FChannels*(FLenX-soulenx);
    bdesnl:=des.FChannels*(des.FLenX-soulenx);

    if FChannels=4 then begin
{        for y:=0 to souleny-1 do begin
            for x:=0 to soulenx-1 do begin
                psou:=PGetDWORD(bsou);
                pdes:=PGetDWORD(bdes);}

{                bsou:=PAdd(bsou,bsounp);
                bdes:=PAdd(bdes,bdesnp);
            end;
            bsou:=PAdd(bsou,bsounl);
            bdes:=PAdd(bdes,bdesnl);
        end;}
/// Red ////////////////////////////////////////////////////////////////////////
        if (m_r and 3)=1 then begin
            y:=souleny;
            asm
                push eax
                push ecx
                push ebx
                push edx
                push esi
                push edi

                mov esi,bsou
                mov edi,bdes
                mov edx,soulenx
                mov ecx,souleny

a1_m2:
                mov al,[esi]
                mov [edi],al

                add esi,bsounp
                add edi,bdesnp

                dec edx
                jnz a1_m2

                add esi,bsounl
                add edi,bdesnl
                mov edx,soulenx

                dec ecx
                jnz a1_m2

                pop edi
                pop esi
                pop edx
                pop ebx
                pop ecx
                pop eax
            end;
        end else if (m_r and 3)=3 then begin
            y:=souleny;
            asm
                push eax
                push ecx
                push ebx
                push edx
                push esi
                push edi

                mov esi,bsou
                mov edi,bdes
                mov edx,soulenx

a1_m1:
                mov eax,[esi]
                mov ebx,eax
                shr ebx,24
                and eax,$ff
                shl eax,8
                add eax,ebx
                add eax,GAlphaMulColor
                mov al,[eax]
                mov ecx,[edi]
                and ecx,$ff
                shl ecx,8
                add ecx,255
                sub ecx,ebx
                add ecx,GAlphaMulColor
                mov cl,[ecx]
                add eax,ecx
                mov [edi],al

                add esi,bsounp
                add edi,bdesnp

                dec edx
                jnz a1_m1

                add esi,bsounl
                add edi,bdesnl
                mov edx,soulenx

                dec y
                jnz a1_m1

                pop edi
                pop esi
                pop edx
                pop ebx
                pop ecx
                pop eax
            end;
        end;

/// Green //////////////////////////////////////////////////////////////////////
        if (m_g and 3)=1 then begin
            y:=souleny;
            asm
                push eax
                push ecx
                push ebx
                push edx
                push esi
                push edi

                mov esi,bsou
                inc esi
                mov edi,bdes
                inc edi
                mov edx,soulenx
                mov ecx,souleny

a2_m2:
                mov al,[esi]
                mov [edi],al

                add esi,bsounp
                add edi,bdesnp

                dec edx
                jnz a2_m2

                add esi,bsounl
                add edi,bdesnl
                mov edx,soulenx

                dec ecx
                jnz a2_m2

                pop edi
                pop esi
                pop edx
                pop ebx
                pop ecx
                pop eax
            end;
        end else if (m_g and 3)=3 then begin
            y:=souleny;
            asm
                push eax
                push ecx
                push ebx
                push edx
                push esi
                push edi

                mov esi,bsou
                mov edi,bdes
                mov edx,soulenx

a2_m1:
                mov eax,[esi]
                mov ebx,eax
                shr ebx,24
                shr eax,8
                and eax,$ff
                shl eax,8
                add eax,ebx
                add eax,GAlphaMulColor
                mov al,[eax]
                mov ecx,[edi]
                shr ecx,8
                and ecx,$ff
                shl ecx,8
                add ecx,255
                sub ecx,ebx
                add ecx,GAlphaMulColor
                mov cl,[ecx]
                add eax,ecx
                mov [edi+1],al

                add esi,bsounp
                add edi,bdesnp

                dec edx
                jnz a2_m1

                add esi,bsounl
                add edi,bdesnl
                mov edx,soulenx

                dec y
                jnz a2_m1

                pop edi
                pop esi
                pop edx
                pop ebx
                pop ecx
                pop eax
            end;
        end;

/// Blue ///////////////////////////////////////////////////////////////////////
        if (m_b and 3)=1 then begin
            y:=souleny;
            asm
                push eax
                push ecx
                push ebx
                push edx
                push esi
                push edi

                mov esi,bsou
                mov edi,bdes
                inc esi
                inc edi
                inc esi
                inc edi
                mov edx,soulenx
                mov ecx,souleny

a3_m2:
                mov al,[esi]
                mov [edi],al

                add esi,bsounp
                add edi,bdesnp

                dec edx
                jnz a3_m2

                add esi,bsounl
                add edi,bdesnl
                mov edx,soulenx

                dec ecx
                jnz a3_m2

                pop edi
                pop esi
                pop edx
                pop ebx
                pop ecx
                pop eax
            end;
        end else if (m_b and 3)=3 then begin
            y:=souleny;
            asm
                push eax
                push ecx
                push ebx
                push edx
                push esi
                push edi

                mov esi,bsou
                mov edi,bdes
                mov edx,soulenx

a3_m1:
                mov eax,[esi]
                mov ebx,eax
                shr ebx,24
                shr eax,16
                and eax,$ff
                shl eax,8
                add eax,ebx
                add eax,GAlphaMulColor
                mov al,[eax]
                mov ecx,[edi]
                shr ecx,16
                and ecx,$ff
                shl ecx,8
                add ecx,255
                sub ecx,ebx
                add ecx,GAlphaMulColor
                mov cl,[ecx]
                add eax,ecx
                mov [edi+2],al

                add esi,bsounp
                add edi,bdesnp

                dec edx
                jnz a3_m1

                add esi,bsounl
                add edi,bdesnl
                mov edx,soulenx

                dec y
                jnz a3_m1

                pop edi
                pop esi
                pop edx
                pop ebx
                pop ecx
                pop eax
            end;
        end;

/// Alpha //////////////////////////////////////////////////////////////////////
        if (m_a and 1)=1 then begin
            y:=souleny;
            asm
                push eax
                push ecx
                push ebx
                push edx
                push esi
                push edi

                mov esi,bsou
                mov edi,bdes
                inc esi
                inc edi
                inc esi
                inc edi
                inc esi
                inc edi
                mov edx,soulenx
                mov ecx,souleny

a4_m2:
                mov al,[esi]
                add al,[edi]
                jnc  a4_m1
                mov al,255
a4_m1:          mov [edi],al

                add esi,bsounp
                add edi,bdesnp

                dec edx
                jnz a4_m2

                add esi,bsounl
                add edi,bdesnl
                mov edx,soulenx

                dec ecx
                jnz a4_m2

                pop edi
                pop esi
                pop edx
                pop ebx
                pop ecx
                pop eax
            end;
        end;
    end;
end;

procedure TGraphBuf.EndScale(_rsou:TRect; _rdes:TRect; des:TGraphBuf; mode:integer);
var
    soulenx,souleny,deslenx,desleny:integer;
    bsou,bdes:Pointer;
    bsounp,bsounl,bdesnp,bdesnl:integer;
    scalex,scaley:integer;
    x,y:integer;
    t_desnp,t_desnl:integer;
label a1_m1,a1_m2,a2_m1,a2_m2,a3_m1,a3_m2,a4_m1,a4_m2,a5_m1,a5_m2;
begin
    soulenx:=_rsou.Right-_rsou.Left;
    souleny:=_rsou.Bottom-_rsou.Top;
    deslenx:=_rdes.Right-_rdes.Left;
    desleny:=_rdes.Bottom-_rdes.Top;

    scalex:=floor(deslenx/soulenx);
    scaley:=floor(desleny/souleny);

    bsounp:=FChannels;
    bsounl:=FLenLine-soulenx*FChannels;

    bdesnp:=des.FChannels*scalex;
    bdesnl:=des.FLenLine*scaley-deslenx*des.FChannels;

    t_desnp:=des.FChannels;
    t_desnl:=des.FLenLine-des.FChannels*scalex;

    bsou:=PixelBuf(_rsou.Left,_rsou.Top);
    bdes:=des.PixelBuf(_rdes.Left,_rdes.Top);

    if mode=0 then begin
            x:=soulenx;
            y:=souleny;
            asm
                push    ebx
                push    eax
                push    ebx
                push    ecx
                push    esi
                push    edi

                mov     esi,bsou
                mov     edi,bdes

a1_m2:
                mov     edx,[esi]

                mov     ecx,edx // red
                shl     ecx,+8
                and     ecx,$f800
                mov     eax,ecx

                mov     ecx,edx // green
                shr     ecx,+8+2-5
                and     ecx,$7e0
                or      eax,ecx

                mov     ecx,edx // blue
                shr     ecx,+16+3
                and     ecx,$1f
                or      eax,ecx

                mov     ebx,edi
                mov     edx,scaley
                mov     ecx,scalex
a1_m1:
                mov     [ebx],ax

                add     ebx,t_desnp
                dec     ecx
                jnz     a1_m1
                add     ebx,t_desnl
                mov     ecx,scalex
                dec     edx
                jnz     a1_m1

                add     esi,bsounp
                add     edi,bdesnp
                dec     x
                jnz     a1_m2
                mov     eax,soulenx
                mov     x,eax
                add     esi,bsounl
                add     edi,bdesnl
                dec     y
                jnz     a1_m2


                pop     edi
                pop     esi
                pop     ecx
                pop     ebx
                pop     eax
                pop     ebx
            end;
    end else if mode=1 then begin
            x:=soulenx;
            y:=souleny;
            asm
                push    ebx
                push    eax
                push    ebx
                push    ecx
                push    esi
                push    edi

                mov     esi,bsou
                mov     edi,bdes

a2_m2:
                mov     edx,[esi]

                mov     ecx,edx // red
                shl     ecx,+8
                and     ecx,$f800
                mov     eax,ecx

                mov     ecx,edx // green
                shl     ecx,-2+5
                and     ecx,$7e0
                or      eax,ecx

                mov     ecx,edx // blue
                shr     ecx,+3
                and     ecx,$1f
                or      eax,ecx

                mov     ebx,edi
                mov     edx,scaley
                mov     ecx,scalex
a2_m1:
                mov     [ebx],ax

                add     ebx,t_desnp
                dec     ecx
                jnz     a2_m1
                add     ebx,t_desnl
                mov     ecx,scalex
                dec     edx
                jnz     a2_m1

                add     esi,bsounp
                add     edi,bdesnp
                dec     x
                jnz     a2_m2
                mov     eax,soulenx
                mov     x,eax
                add     esi,bsounl
                add     edi,bdesnl
                dec     y
                jnz     a2_m2


                pop     edi
                pop     esi
                pop     ecx
                pop     ebx
                pop     eax
                pop     ebx
            end;
    end else if mode=2 then begin
            x:=soulenx;
            y:=souleny;
            asm
                push    ebx
                push    eax
                push    ebx
                push    ecx
                push    esi
                push    edi

                mov     esi,bsou
                mov     edi,bdes

a3_m2:
                mov     edx,[esi]

                mov     ecx,edx // red
//                shl     ecx,-8+8
                and     ecx,$f800
                mov     eax,ecx

                mov     ecx,edx // green
                shr     ecx,+8+2-5
                and     ecx,$7e0
                or      eax,ecx

                mov     ecx,edx // blue
                shr     ecx,+8+3
                and     ecx,$1f
                or      eax,ecx

                mov     ebx,edi
                mov     edx,scaley
                mov     ecx,scalex
a3_m1:
                mov     [ebx],ax

                add     ebx,t_desnp
                dec     ecx
                jnz     a3_m1
                add     ebx,t_desnl
                mov     ecx,scalex
                dec     edx
                jnz     a3_m1

                add     esi,bsounp
                add     edi,bdesnp
                dec     x
                jnz     a3_m2
                mov     eax,soulenx
                mov     x,eax
                add     esi,bsounl
                add     edi,bdesnl
                dec     y
                jnz     a3_m2


                pop     edi
                pop     esi
                pop     ecx
                pop     ebx
                pop     eax
                pop     ebx
            end;
    end else if mode=3 then begin
            x:=soulenx;
            y:=souleny;
            asm
                push    ebx
                push    eax
                push    ebx
                push    ecx
                push    esi
                push    edi

                mov     esi,bsou
                mov     edi,bdes

a4_m2:
                mov     edx,[esi]

                mov     ecx,edx // red
                shr     ecx,+16+3-5-6
                and     ecx,$f800
                mov     eax,ecx

                mov     ecx,edx // green
                shr     ecx,+16+2-5
                and     ecx,$7e0
                or      eax,ecx

                mov     ecx,edx // blue
                shr     ecx,+16+3
                and     ecx,$1f
                or      eax,ecx

                mov     ebx,edi
                mov     edx,scaley
                mov     ecx,scalex
a4_m1:
                mov     [ebx],ax

                add     ebx,t_desnp
                dec     ecx
                jnz     a4_m1
                add     ebx,t_desnl
                mov     ecx,scalex
                dec     edx
                jnz     a4_m1

                add     esi,bsounp
                add     edi,bdesnp
                dec     x
                jnz     a4_m2
                mov     eax,soulenx
                mov     x,eax
                add     esi,bsounl
                add     edi,bdesnl
                dec     y
                jnz     a4_m2


                pop     edi
                pop     esi
                pop     ecx
                pop     ebx
                pop     eax
                pop     ebx
            end;
    end else if mode=4 then begin
            x:=soulenx;
            y:=souleny;
            asm
                push    ebx
                push    eax
                push    ebx
                push    ecx
                push    esi
                push    edi

                mov     esi,bsou
                mov     edi,bdes

a5_m2:
                mov     edx,[esi]

                mov     ecx,edx // red
                shr     ecx,+24+3-5-6
                and     ecx,$f800
                mov     eax,ecx

                mov     ecx,edx // green
                shr     ecx,+24+2-5
                and     ecx,$7e0
                or      eax,ecx

                mov     ecx,edx // blue
                shr     ecx,+24+3
                and     ecx,$1f
                or      eax,ecx

                mov     ebx,edi
                mov     edx,scaley
                mov     ecx,scalex
a5_m1:
                mov     [ebx],ax

                add     ebx,t_desnp
                dec     ecx
                jnz     a5_m1
                add     ebx,t_desnl
                mov     ecx,scalex
                dec     edx
                jnz     a5_m1

                add     esi,bsounp
                add     edi,bdesnp
                dec     x
                jnz     a5_m2
                mov     eax,soulenx
                mov     x,eax
                add     esi,bsounl
                add     edi,bdesnl
                dec     y
                jnz     a5_m2


                pop     edi
                pop     esi
                pop     ecx
                pop     ebx
                pop     eax
                pop     ebx
            end;
    end;

end;

end.
