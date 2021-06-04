unit ab_Tex;

interface

uses Windows,Classes,SysUtils,Math,
	 GR_DirectX3D8;

type
TabTex = class(TObject)
	public
		FPrev:TabTex;
		FNext:TabTex;

        FRefs:integer;
        FPath:WideString;
        FTex:IDirect3DTexture8;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

//        procedure Load(path:WideString);
        procedure Load{File}(path:WideString);
end;

procedure ab_Tex_Clear();
function ab_Tex_Add:TabTex;
procedure ab_Tex_Delete(el:TabTex);
function ab_Tex_Get(path:WideString):TabTex;
procedure ab_Tex_Free(el:TabTex);

var
ab_Tex_First:TabTex=nil;
ab_Tex_Last:TabTex=nil;

implementation

uses {EC_Cache, EC_CacheGi, }Form_Main;

function OKGF_ReadStart_File(filename:PChar; lenx:PDWORD; leny:PDWORD): DWORD; cdecl; external 'okgf.dll' name 'OKGF_ReadStart_File';
function OKGF_ReadStart_Buf(soubuf:Pointer; soubuflen:DWORD; lenx:PDWORD; leny:PDWORD): DWORD; cdecl; external 'okgf.dll' name 'OKGF_ReadStart_Buf';
function OKGF_Read(id:DWORD; buf:Pointer; lenline:DWORD; mR,mG,mB,mD:DWORD; BytePP:DWORD): DWORD; cdecl; external 'okgf.dll' name 'OKGF_Read';

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TabTex.Create;
begin
	inherited Create;
end;

destructor TabTex.Destroy;
begin
	Clear;
	inherited Destroy;
end;

procedure TabTex.Clear;
begin
	FTex:=nil;
	FRefs:=0;
end;

{procedure TabTex.Load(path:WideString);
begin
end;}
(*var
	gcc:TCGiControlEC;
    gic:TCGiEC;
    d3dlr:D3DLOCKED_RECT;
    des,sou:Pointer;
    lenx,leny,desll,x,y:integer;
begin
	Clear;

    FPath:=path;

    gcc:=TCGiControlEC.Create;
    GR_Cache.InitControl(gcc);
    gcc.Init(path);
    gic:=nil;

    try
	    gic:=gcc.Open;

        lenx:=gic.GI.GetSize.x;
        leny:=gic.GI.GetSize.y;

        if gic.GI.GetFormat<>0 then EError('Incorrect format texture 1');
        if (gic.GI.Zag.mR=$ff0000) and (gic.GI.Zag.mG=$ff00) and (gic.GI.Zag.mB=$ff) and (gic.GI.Zag.mA=0) then begin
	        if GR_lpDev.CreateTexture(lenx,leny,0,0,D3DFMT_R8G8B8,0,FTex)<>D3D_OK then EError('CreateTexture');

    		if FTex.LockRect(0,@d3dlr,nil,0)<>D3D_OK then EError('Tex.Lock');
		    des := d3dlr.pBits;
            desll := d3dlr.Pitch;
            sou := Ptr(DWORD(gic.GI.Buf)+DWORD(gic.GI.GetUnit(0).sme));

            for y:=0 to leny-1 do begin
            	for x:=0 to lenx-1 do begin
                	PBYTE(DWORD(des)+0)^:=PBYTE(DWORD(sou)+0)^;
                	PBYTE(DWORD(des)+1)^:=PBYTE(DWORD(sou)+1)^;
                	PBYTE(DWORD(des)+2)^:=PBYTE(DWORD(sou)+2)^;
                	des:=Ptr(DWORD(des)+DWORD(3));
                	sou:=Ptr(DWORD(sou)+DWORD(3));
                end;
                des:=Ptr(DWORD(des)+DWORD(desll-leny*3));
            end;

		    FTex.UnlockRect(0);

        end else if (gic.GI.Zag.mR=$ff0000) and (gic.GI.Zag.mG=$ff00) and (gic.GI.Zag.mB=$ff) and (gic.GI.Zag.mA=$ff000000) then begin
	        if GR_lpDev.CreateTexture(lenx,leny,1,0,D3DFMT_A8R8G8B8,D3DPOOL_MANAGED,FTex)<>D3D_OK then EError('CreateTexture');

    		if FTex.LockRect(0,@d3dlr,nil,0)<>D3D_OK then EError('Tex.Lock');
		    des := d3dlr.pBits;
            desll := d3dlr.Pitch;
            sou := Ptr(DWORD(gic.GI.Buf)+DWORD(gic.GI.GetUnit(0).sme));

            for y:=0 to leny-1 do begin
            	for x:=0 to lenx-1 do begin
                	PDWORD(des)^:=PDWORD(sou)^;
{                	PBYTE(DWORD(des)+3)^:=255;//PBYTE(DWORD(sou)+0)^;
                	PBYTE(DWORD(des)+2)^:=255;//PBYTE(DWORD(sou)+1)^;
                	PBYTE(DWORD(des)+1)^:=255;//PBYTE(DWORD(sou)+2)^;
                	PBYTE(DWORD(des)+0)^:=255;//PBYTE(DWORD(sou)+3)^;}
                	des:=Ptr(DWORD(des)+DWORD(4));
                	sou:=Ptr(DWORD(sou)+DWORD(4));
                end;
                des:=Ptr(DWORD(des)+DWORD(desll-leny*4));
            end;

		    FTex.UnlockRect(0);

        end else if (gic.GI.Zag.mR=$F800) and (gic.GI.Zag.mG=$07E0) and (gic.GI.Zag.mB=$001F) and (gic.GI.Zag.mA=0) then begin
	        if GR_lpDev.CreateTexture(lenx,leny,0,0,D3DFMT_R5G6B5,0,FTex)<>D3D_OK then EError('CreateTexture');

    		if FTex.LockRect(0,@d3dlr,nil,0)<>D3D_OK then EError('Tex.Lock');
		    des := d3dlr.pBits;
            desll := d3dlr.Pitch;
            sou := Ptr(DWORD(gic.GI.Buf)+DWORD(gic.GI.GetUnit(0).sme));

            for y:=0 to leny-1 do begin
            	for x:=0 to lenx-1 do begin
                	PWORD(des)^:=PWORD(sou)^;
                	des:=Ptr(DWORD(des)+DWORD(2));
                	sou:=Ptr(DWORD(sou)+DWORD(2));
                end;
                des:=Ptr(DWORD(des)+DWORD(desll-leny*2));
            end;

		    FTex.UnlockRect(0);

        end else EError('Incorrect format texture 2');
    finally
    	if gic<>nil then begin gcc.Close; end;
	    gcc.Free;
    end;
end;*)

procedure TabTex.Load{File}(path:WideString);
var
    lenx,leny:integer;
    id:DWORD;
    d3dlr:D3DLOCKED_RECT;
    x,y,lln:integer;
    buf:Pointer;
label m1;
begin
	Clear;

    FPath:=path;

    id:=OKGF_ReadStart_File(PChar(AnsiString(path)),@lenx,@leny);
    if id=0 then raise Exception.Create('TabTex.LoadFile. Error load file:'+path);

	if GR_lpDev.CreateTexture(lenx,leny,1,0,D3DFMT_A8R8G8B8,D3DPOOL_MANAGED,FTex)<>D3D_OK then EError('CreateTexture');

    if FTex.LockRect(0,@d3dlr,nil,0)<>D3D_OK then EError('Tex.Lock');

//    id:=OKGF_Read(id,d3dlr.pBits,d3dlr.Pitch,$ff,$ff00,$ff0000,$ff000000,4);
    id:=OKGF_Read(id,d3dlr.pBits,d3dlr.Pitch,$ff0000,$ff00,$ff,$ff000000,4);
    if id=0 then raise Exception.Create('TGraphBuf.LoadRGBA. Error load file:'+path);

    buf:=Ptr(DWORD(d3dlr.pBits)+3);
    lln:=d3dlr.Pitch-lenx*4;
    for y:=0 to leny-1 do begin
	    for x:=0 to lenx-1 do begin
        	if (PBYTE(buf)^)<>0 then goto m1;
	        buf:=Ptr(DWORD(buf)+DWORD(4));
        end;
        buf:=Ptr(DWORD(buf)+DWORD(lln));
    end;

    buf:=Ptr(DWORD(d3dlr.pBits)+3);
    lln:=d3dlr.Pitch-lenx*4;
    for y:=0 to leny-1 do begin
	    for x:=0 to lenx-1 do begin
        	PBYTE(buf)^:=255;
	        buf:=Ptr(DWORD(buf)+DWORD(4));
        end;
        buf:=Ptr(DWORD(buf)+DWORD(lln));
    end;

m1:

	FTex.UnlockRect(0);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure ab_Tex_Clear();
begin
	while ab_Tex_First<>nil do ab_Tex_Delete(ab_Tex_Last);
end;

function ab_Tex_Add:TabTex;
var
    el:TabTex;
begin
    el:=TabTex.Create;

    if ab_Tex_Last<>nil then ab_Tex_Last.FNext:=el;
	el.FPrev:=ab_Tex_Last;
	el.FNext:=nil;
	ab_Tex_Last:=el;
	if ab_Tex_First=nil then ab_Tex_First:=el;

    Result:=el;
end;

procedure ab_Tex_Delete(el:TabTex);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if ab_Tex_Last=el then ab_Tex_Last:=el.FPrev;
	if ab_Tex_First=el then ab_Tex_First:=el.FNext;

    el.Free;
end;

function ab_Tex_Get(path:WideString):TabTex;
var
	el:TabTex;
begin
	el:=ab_Tex_First;
    while el<>nil do begin
    	if el.FPath=path then begin
			Result:=el;
            inc(Result.FRefs);
            Exit;
        end;
    	el:=el.FNext;
    end;

    Result:=ab_Tex_Add;
    Result.Load(path);
    inc(Result.FRefs);
end;

procedure ab_Tex_Free(el:TabTex);
begin
	dec(el.FRefs);
    if el.FRefs<=0 then ab_Tex_Delete(el);
end;

end.
