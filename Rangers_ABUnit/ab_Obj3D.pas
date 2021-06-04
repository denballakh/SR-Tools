unit ab_Obj3D;

interface

uses Windows,Classes,SysUtils,Math,
	 GR_DirectX3D8,
     ab_Tex;

const
D3DFVF_CUSTOMVERTEX = (D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_TEX1);

type
PabVer3D = ^TabVer3D;
TabVer3D = packed record
    x,y,z,rhw:single;
    color:DWORD;
    tu,tv:single;
end;

PabObj3Dunit = ^TabObj3Dunit;
TabObj3Dunit = record
	FPrev:PabObj3Dunit;
    FNext:PabObj3Dunit;

	FVerCnt:integer;
    FVer:array of integer;
    FVerIndex:integer;

	FType:DWORD;
    FCnt:integer;

    FTex:TabTex;
end;

TabObj3D = class(TObject)
	public
		FPrev:TabObj3D;
		FNext:TabObj3D;

	    FVer:IDirect3DVertexBuffer8;
        FVerCnt:integer;
        FVerBuf:Pointer;
        FVerOpen:integer;

		FUnitFirst:PabObj3Dunit;
    	FUnitLast:PabObj3Dunit;

        FIndex:IDirect3DIndexBuffer8;
        FIndexRebuild:boolean;

		FPosOld:D3DVECTOR;

        FDrawFromObjLoop:boolean;

        FZTest:boolean;
    public
        constructor Create;
        destructor Destroy; override;

        procedure VerClear;
        procedure SetVerCount(len:integer);
        property VerCount:integer read FVerCnt write SetVerCount;
        procedure VerOpen;
        procedure VerClose;
        function Ver(no:integer):PabVer3D;

        procedure UnitClear;
        function UnitAdd:PabObj3Dunit;
        procedure UnitFree(el:PabObj3Dunit);
        function UnitAddTriangle(p1,p2,p3:integer; tex:WideString):PabObj3Dunit;
        function UnitAddLine(p1,p2:integer):PabObj3Dunit;

		procedure IndexClear;
        procedure IndexBuild;

        procedure SetTexture(tstr:WideString);

        procedure CreateSphere(fRadius:single; dwNumRings:DWORD; diffuse:D3DCOLOR);
        procedure CreateCone(vFrom,vTo:D3DVECTOR; rFrom,rTo:single; diffuseFrom,diffuseTo:D3DCOLOR; segcnt:integer);
        procedure UpdateCone(vFrom,vTo:D3DVECTOR; rFrom,rTo:single; diffuseFrom,diffuseTo:D3DCOLOR);
        procedure SetPos(pos:D3DVECTOR);
        procedure SetColor(diffuse:D3DCOLOR);

        procedure Draw;
end;

function abVer3D(x,y,z:single; u,v:single; color:DWORD):TabVer3D;

procedure ab_Obj3D_Clear();
function ab_Obj3D_Add:TabObj3D;
function ab_Obj3D_AddFirst:TabObj3D;
procedure ab_Obj3D_Delete(el:TabObj3D);
procedure ab_Obj3D_Draw;

var
ab_Obj3D_First:TabObj3D=nil;
ab_Obj3D_Last:TabObj3D=nil;

implementation

uses Form_Main,EC_Mem,VOper;

constructor TabObj3D.Create;
begin
	inherited Create;
    FDrawFromObjLoop:=true;
    FZTest:=true;
end;

destructor TabObj3D.Destroy;
begin
    UnitClear;
	IndexClear;
	VerClear;
	inherited Destroy;
end;

procedure TabObj3D.VerClear;
begin
	FVer:=nil;
    FVerCnt:=0;
    FVerOpen:=0;
    FVerBuf:=nil;
end;

procedure TabObj3D.SetVerCount(len:integer);
begin
	if FVer=nil then begin
	    if GR_lpDev.CreateVertexBuffer(len*sizeof(TabVer3D),0, D3DFVF_CUSTOMVERTEX,D3DPOOL_DEFAULT,FVer)<>D3D_OK then EError('TabObj3D.CreateVertexBuffer');
    end;
    FVerCnt:=len;
end;

procedure TabObj3D.VerOpen;
begin
	if FVerOpen=0 then begin
		if FVer.Lock(0,FVerCnt*sizeof(TabVer3D),FVerBuf,0)<>D3D_OK then EError('TabObj3D.Lock');
    end;
	inc(FVerOpen);
end;

procedure TabObj3D.VerClose;
begin
	if FVerOpen<0 then Exit;
	dec(FVerOpen);
    if FVerOpen=0 then FVer.Unlock();
end;

function TabObj3D.Ver(no:integer):PabVer3D;
begin
	Result:=Ptr(DWORD(FVerBuf)+DWORD(no*sizeof(TabVer3D)));
end;

procedure TabObj3D.UnitClear;
begin
	while FUnitFirst<>nil do UnitFree(FUnitLast);
end;

function TabObj3D.UnitAdd:PabObj3Dunit;
var
	el:PabObj3Dunit;
begin
	el:=AllocClearEC(sizeof(TabObj3Dunit));

    if FUnitLast<>nil then FUnitLast.FNext:=el;
	el.FPrev:=FUnitLast;
	el.FNext:=nil;
	FUnitLast:=el;
	if FUnitFirst=nil then FUnitFirst:=el;

    Result:=el;
end;

procedure TabObj3D.UnitFree(el:PabObj3Dunit);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if FUnitLast=el then FUnitLast:=el.FPrev;
	if FUnitFirst=el then FUnitFirst:=el.FNext;

    el.FVer:=nil;

    if el.FTex<>nil then begin ab_Tex_Free(el.FTex); el.FTex:=nil; end;

    FreeEC(el);

    FIndexRebuild:=true;
end;

function TabObj3D.UnitAddTriangle(p1,p2,p3:integer; tex:WideString):PabObj3Dunit;
begin
	Result:=UnitAdd;
    SetLength(Result.FVer,3);
    Result.FVer[0]:=p1;
    Result.FVer[1]:=p2;
    Result.FVer[2]:=p3;
    Result.FType:=D3DPT_TRIANGLELIST;
    Result.FVerCnt:=3;
    Result.FCnt:=1;
    if tex<>'' then Result.FTex:=ab_Tex_Get(tex);

    FIndexRebuild:=true;
end;

function TabObj3D.UnitAddLine(p1,p2:integer):PabObj3Dunit;
begin
	Result:=UnitAdd;
    SetLength(Result.FVer,2);
    Result.FVer[0]:=p1;
    Result.FVer[1]:=p2;
    Result.FType:=D3DPT_LINELIST;
    Result.FVerCnt:=2;
    Result.FCnt:=1;

    FIndexRebuild:=true;
end;

procedure TabObj3D.IndexClear;
begin
	FIndex:=nil;
end;

procedure TabObj3D.IndexBuild;
var
	un:PabObj3Dunit;
    cnt:integer;
    ib:Pointer;
    i,sme:integer;
begin
	IndexClear;

    cnt:=0;
    un:=FUnitFirst;
    while un<>nil do begin
    	cnt:=cnt+un.FVerCnt;
        un:=un.FNext;
    end;

    if cnt<=0 then Exit;

    if GR_lpDev.CreateIndexBuffer(cnt*sizeof(WORD),D3DUSAGE_WRITEONLY,D3DFMT_INDEX16,D3DPOOL_MANAGED,FIndex)<>D3D_OK then EError('TabObj3D CreateIndexBuffer');
	if FIndex.Lock(0,cnt*sizeof(WORD),ib,0 )<>D3D_OK then EError('TabObj3D Index.Look');

    sme:=0;
    un:=FUnitFirst;
    while un<>nil do begin
    	un.FVerIndex:=sme;
    	for i:=0 to un.FVerCnt-1 do begin
        	PWORD(ib)^:=un.FVer[i];

        	inc(sme);
        	ib:=Ptr(DWORD(ib)+2);
        end;
        un:=un.FNext;
    end;

	FIndex.Unlock;

    FIndexRebuild:=false;
end;

procedure TabObj3D.SetTexture(tstr:WideString);
var
	un:PabObj3Dunit;
begin
	un:=FUnitFirst;
    while un<>nil do begin
    	if tstr='' then begin
        	if un.FTex<>nil then begin ab_Tex_Free(un.FTex); un.FTex:=nil; end;
        end else begin
	    	if (un.FTex=nil) or (un.FTex.FPath<>tstr) then begin
	        	if un.FTex<>nil then begin ab_Tex_Free(un.FTex); un.FTex:=nil; end;
                un.FTex:=ab_Tex_Get(tstr);
            end;
		end;
    	un:=un.FNext;
    end;
end;

procedure TabObj3D.CreateSphere(fRadius:single; dwNumRings:DWORD; diffuse:D3DCOLOR);
var
	dwNumVertices:DWORD;
    dwNumIndices:DWORD;
    un:PabObj3Dunit;
    x,y,vtx,index:WORD;
    fDAng:single;
    fDAngY0:single;
    g_PI:single;
    y0,r0,tv,fDAngX0,tu:single;
    v,vy:D3DVECTOR;
    wNorthVtx,wSouthVtx:DWORD;
    p1,p2,p3:WORD;
begin
    UnitClear;
	IndexClear;
	VerClear;

    dwNumVertices := (dwNumRings*(2*dwNumRings+1)+2);
    dwNumIndices  := 6*(dwNumRings*2)*((dwNumRings-1)+1);
{    D3DLVERTEX* pVertices    = new D3DLVERTEX[dwNumVertices];
    WORD*      pIndices      = new WORD[dwNumIndices];}

    VerCount:=dwNumVertices;
    VerOpen;

	un:=UnitAdd;
    SetLength(un.FVer,dwNumIndices);
    un.FType:=D3DPT_TRIANGLELIST;
    un.FVerCnt:=dwNumIndices;
    un.FCnt:=1;

    g_PI:=pi;
    vtx := 0; index := 0;
    fDAng   := g_PI / dwNumRings;
    fDAngY0 := fDAng;

    for y:=0 to dwNumRings-1 do begin
        y0 := cos(fDAngY0);
        r0 := sin(fDAngY0);
        tv := (1.0 - y0)/2;

        for x:=0 to (dwNumRings*2)+1-1 do begin
            fDAngX0 := x*fDAng;

            v.x:=r0*sin(fDAngX0);
            v.y:=y0;
            v.z:=r0*cos(fDAngX0);

            tu := 1.0 - x/(dwNumRings*2.0);

            Ver(vtx)^:=abVer3D(v.x*fRadius,v.y*fRadius,v.z*fRadius,tu,tv,diffuse);

            vtx := vtx+1;
        end;
        fDAngY0 := fDAngY0+fDAng;
    end;

    for y:=0 to dwNumRings-1-1 do begin
        for x:=0 to (dwNumRings*2)-1 do begin
            un.FVer[index]:=( (y+0)*(dwNumRings*2+1) + (x+0) ); inc(index);
            un.FVer[index]:=( (y+1)*(dwNumRings*2+1) + (x+0) ); inc(index);
            un.FVer[index]:=( (y+0)*(dwNumRings*2+1) + (x+1) ); inc(index);
            un.FVer[index]:=( (y+0)*(dwNumRings*2+1) + (x+1) ); inc(index);
            un.FVer[index]:=( (y+1)*(dwNumRings*2+1) + (x+0) ); inc(index);
            un.FVer[index]:=( (y+1)*(dwNumRings*2+1) + (x+1) ); inc(index);
        end;
    end;

    y:=dwNumRings-1;

    vy.x:=0; vy.y:=1.0;  vy.z:=0;
    wNorthVtx := vtx;
	Ver(vtx)^:=abVer3D(vy.x*fRadius,vy.y*fRadius,vy.z*fRadius,0.5,0.0,diffuse);
    inc(vtx);
    wSouthVtx := vtx;
	Ver(vtx)^:=abVer3D(-vy.x*fRadius,-vy.y*fRadius,-vy.z*fRadius,0.5,1.0,diffuse);
//    inc(vtx);

    for x:=0 to (dwNumRings*2)-1 do begin
        p1 := wSouthVtx;
        p2 := ( (y)*(dwNumRings*2+1) + (x+1) );
        p3 := ( (y)*(dwNumRings*2+1) + (x+0) );

        un.FVer[index]:=p1; inc(index);
        un.FVer[index]:=p3; inc(index);
        un.FVer[index]:=p2; inc(index);
    end;

    for x:=0 to (dwNumRings*2)-1 do begin
        p1 := wNorthVtx;
        p2 := ( (0)*(dwNumRings*2+1) + (x+1) );
        p3 := ( (0)*(dwNumRings*2+1) + (x+0) );

        un.FVer[index]:=p1; inc(index);
        un.FVer[index]:=p3; inc(index);
        un.FVer[index]:=p2; inc(index);
    end;

    un.FCnt:=index div 3;

    VerClose;

    FIndexRebuild:=true;
end;

procedure TabObj3D.CreateCone(vFrom,vTo:D3DVECTOR; rFrom,rTo:single; diffuseFrom,diffuseTo:D3DCOLOR; segcnt:integer);
var
	vcnt:integer;
    icnt:integer;
    un:PabObj3Dunit;
    i,index:integer;
begin
	if segcnt<3 then Exit;

    vcnt:=segcnt*2;
    icnt:=segcnt*2*3;

    VerCount:=vcnt;

	un:=UnitAdd;
    SetLength(un.FVer,icnt);
    un.FType:={D3DPT_LINESTRIP}D3DPT_TRIANGLELIST;
    un.FVerCnt:=icnt;
    un.FCnt:=icnt div 3;

	UpdateCone(vFrom,vTo,rFrom,rTo,diffuseFrom,diffuseTo);

    index:=0;
    for i:=0 to segcnt-1 do begin
        un.FVer[index]:=i;
        inc(index);
        un.FVer[index]:=i+1; if un.FVer[index]>=segcnt then un.FVer[index]:=0;
        inc(index);
        un.FVer[index]:=i+segcnt;
        inc(index);

        un.FVer[index]:=i+1; if un.FVer[index]>=segcnt then un.FVer[index]:=0;
        inc(index);
        un.FVer[index]:=i+1+segcnt; if un.FVer[index]>=(segcnt+segcnt) then un.FVer[index]:=segcnt;
        inc(index);
        un.FVer[index]:=i+segcnt;
        inc(index);
    end;

    un.FCnt:=index div 3;

    FIndexRebuild:=true;
end;

procedure TabObj3D.UpdateCone(vFrom,vTo:D3DVECTOR; rFrom,rTo:single; diffuseFrom,diffuseTo:D3DCOLOR);
var
	i,segcnt:integer;
    a:single;
    v:D3DVECTOR;
	m:D3DMATRIX;
begin
	if (FVerCnt<6) or ((FVerCnt and 1)=1) then Exit;

    segcnt:=FVerCnt div 2;

    v.x:=vto.x-vfrom.x;
    v.y:=vto.y-vfrom.y;
    v.z:=vto.z-vfrom.z;
    v:=D3D_Normalize(v);
    m:=D3D_RotateTo(v);

    VerOpen;
    a:=0;
    for i:=0 to segcnt-1 do begin
    	v.x:=sin(a)*rFrom;
    	v.y:=-cos(a)*rFrom;
        v.z:=0;
        v:=D3D_TransformVector(m,v);

        Ver(i)^:=abVer3D(v.x+vfrom.x,v.y+vfrom.y,v.z+vfrom.z,a/(2*pi),0,diffuseFrom);

        a:=a+2*pi/segcnt;
    end;
    a:=0;
    for i:=0 to segcnt-1 do begin
    	v.x:=sin(a)*rTo;
    	v.y:=-cos(a)*rTo;
        v.z:=0;
        v:=D3D_TransformVector(m,v);

        Ver(segcnt+i)^:=abVer3D(v.x+vto.x,v.y+vto.y,v.z+vto.z,a/(2*pi),1,diffuseTo);

        a:=a+2*pi/segcnt;
    end;
    VerClose;
end;

procedure TabObj3D.SetPos(pos:D3DVECTOR);
var
	rp:PabVer3D;
    i:integer;
begin
	if FVerCnt<=0 then Exit;
    VerOpen;
    for i:=0 to FVerCnt-1 do begin
    	rp:=Ver(i);
        rp.x:=rp.x-FPosOld.x+pos.x;
        rp.y:=rp.y-FPosOld.y+pos.y;
        rp.z:=rp.z-FPosOld.z+pos.z;
    end;
    VerClose;
    FPosOld:=pos;
end;

procedure TabObj3D.SetColor(diffuse:D3DCOLOR);
var
    i:integer;
begin
	if FVerCnt<=0 then Exit;
    VerOpen;
    for i:=0 to FVerCnt-1 do Ver(i).color:=diffuse;
    VerClose;
end;

procedure TabObj3D.Draw;
var
	un:PabObj3Dunit;
begin
	if FIndexRebuild then IndexBuild;

    if (FVer=nil) or (FIndex=nil) then Exit;

	if GR_lpDev.SetStreamSource( 0, FVer, sizeof(TabVer3D))<>D3D_OK then EError('TabObj3D Draw');
    if GR_lpDev.SetIndices(FIndex,0)<>D3D_OK then EError('TabObj3D Draw');
	if GR_lpDev.SetVertexShader( D3DFVF_CUSTOMVERTEX )<>D3D_OK then EError('TabObj3D Draw');

    if FZTest then begin
	    GR_lpDev.SetRenderState(D3DRS_ZENABLE ,DWORD(TRUE));
    	GR_lpDev.SetRenderState(D3DRS_ZWRITEENABLE ,DWORD(TRUE));
    end else begin
	    GR_lpDev.SetRenderState(D3DRS_ZENABLE ,DWORD(FALSE));
    	GR_lpDev.SetRenderState(D3DRS_ZWRITEENABLE ,DWORD(FALSE));
    end;

    un:=FUnitFirst;
    while un<>nil do begin
    	if un.FTex<>nil then begin
	        GR_lpDev.SetTexture(0,IDirect3DBaseTexture8(un.FTex.FTex));

{            GR_lpDev.SetTextureStageState( 0, D3DTSS_COLOROP,   D3DTOP_MODULATE );
			GR_lpDev.SetTextureStageState( 0, D3DTSS_COLORARG1, D3DTA_TEXTURE );
			GR_lpDev.SetTextureStageState( 0, D3DTSS_COLORARG2, D3DTA_DIFFUSE );
			GR_lpDev.SetTextureStageState( 0, D3DTSS_ALPHAOP,   D3DTOP_DISABLE );}

            GR_lpDev.SetTextureStageState( 0, D3DTSS_COLOROP,   D3DTOP_SELECTARG1 );
			GR_lpDev.SetTextureStageState( 0, D3DTSS_COLORARG1, D3DTA_TEXTURE );
			GR_lpDev.SetTextureStageState( 0, D3DTSS_ALPHAOP,   D3DTOP_MODULATE );
			GR_lpDev.SetTextureStageState( 0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE );
			GR_lpDev.SetTextureStageState( 0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE );

//	GR_lpDev.SetRenderState(D3DRS_COLORVERTEX, DWORD(FALSE));
//	GR_lpDev.SetRenderState(D3DRS_ALPHABLENDENABLE, DWORD(FALSE));

        end else begin
	        GR_lpDev.SetTexture(0,nil);

        end;
		if GR_lpDev.DrawIndexedPrimitive({D3DPT_LINESTRIP}un.FType, 0, 1{un.FVerCnt }{-755}, un.FVerIndex, un.FCnt)<>D3D_OK then EError('TabObj3D Draw');
        un:=un.FNext;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function abVer3D(x,y,z:single; u,v:single; color:DWORD):TabVer3D;
begin
	Result.x:=x;
    Result.y:=y;
    Result.z:=z;
    Result.rhw:=1.0;
    Result.tu:=u;
    Result.tv:=v;
    Result.color:=color;
end;

procedure ab_Obj3D_Clear();
begin
	while ab_Obj3D_First<>nil do ab_Obj3D_Delete(ab_Obj3D_Last);
end;

function ab_Obj3D_Add:TabObj3D;
var
    el:TabObj3D;
begin
    el:=TabObj3D.Create;

    if ab_Obj3D_Last<>nil then ab_Obj3D_Last.FNext:=el;
	el.FPrev:=ab_Obj3D_Last;
	el.FNext:=nil;
	ab_Obj3D_Last:=el;
	if ab_Obj3D_First=nil then ab_Obj3D_First:=el;

    Result:=el;
end;

function ab_Obj3D_AddFirst:TabObj3D;
var
    el:TabObj3D;
begin
    el:=TabObj3D.Create;

    if ab_Obj3D_First<>nil then ab_Obj3D_First.FPrev:=el;
	el.FNext:=ab_Obj3D_First;
	el.FPrev:=nil;
	ab_Obj3D_First:=el;
	if ab_Obj3D_Last=nil then ab_Obj3D_Last:=el;

    Result:=el;
end;

procedure ab_Obj3D_Delete(el:TabObj3D);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if ab_Obj3D_Last=el then ab_Obj3D_Last:=el.FPrev;
	if ab_Obj3D_First=el then ab_Obj3D_First:=el.FNext;

    el.Free;
end;

procedure ab_Obj3D_Draw;
var
	el:TabObj3D;
begin
	el:=ab_Obj3D_First;
    while el<>nil do begin
    	if el.FDrawFromObjLoop then el.Draw;
    	el:=el.FNext;
    end;
end;

end.
