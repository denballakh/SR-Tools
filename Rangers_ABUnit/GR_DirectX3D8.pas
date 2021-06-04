unit GR_DirectX3D8;

interface

uses Windows,GR_DirectX;

type
	D3DCOLOR = DWORD;
    D3DVALUE = single;

const
	D3DADAPTER_DEFAULT          = 0;

    D3D_OK              		= DD_OK;

	D3DCREATE_FPU_PRESERVE      = $00000002;
	D3DCREATE_MULTITHREADED     = $00000004;

	D3DCREATE_PUREDEVICE                    = $00000010;
	D3DCREATE_SOFTWARE_VERTEXPROCESSING     = $00000020;
	D3DCREATE_HARDWARE_VERTEXPROCESSING     = $00000040;
	D3DCREATE_MIXED_VERTEXPROCESSING        = $00000080;

    D3DFMT_UNKNOWN              =  0;
    D3DFMT_R8G8B8               = 20;
    D3DFMT_A8R8G8B8             = 21;
    D3DFMT_X8R8G8B8             = 22;
    D3DFMT_R5G6B5               = 23;
    D3DFMT_X1R5G5B5             = 24;
    D3DFMT_A1R5G5B5             = 25;
    D3DFMT_A4R4G4B4             = 26;
    D3DFMT_R3G3B2               = 27;
    D3DFMT_A8                   = 28;
    D3DFMT_A8R3G3B2             = 29;
    D3DFMT_X4R4G4B4             = 30;
    D3DFMT_A8P8                 = 40;
    D3DFMT_P8                   = 41;
    D3DFMT_L8                   = 50;
    D3DFMT_A8L8                 = 51;
    D3DFMT_A4L4                 = 52;
    D3DFMT_V8U8                 = 60;
    D3DFMT_L6V5U5               = 61;
    D3DFMT_X8L8V8U8             = 62;
    D3DFMT_Q8W8V8U8             = 63;
    D3DFMT_V16U16               = 64;
    D3DFMT_W11V11U10            = 65;
    D3DFMT_UYVY                 = DWORD('U') or (DWORD('Y') shl 8) or (DWORD('V') shl 16) or (DWORD('Y') shl 24);
    D3DFMT_YUY2                 = DWORD('Y') or (DWORD('U') shl 8) or (DWORD('Y') shl 16) or (DWORD('2') shl 24);
    D3DFMT_DXT1                 = DWORD('D') or (DWORD('X') shl 8) or (DWORD('T') shl 16) or (DWORD('1') shl 24);
    D3DFMT_DXT2                 = DWORD('D') or (DWORD('X') shl 8) or (DWORD('T') shl 16) or (DWORD('2') shl 24);
    D3DFMT_DXT3                 = DWORD('D') or (DWORD('X') shl 8) or (DWORD('T') shl 16) or (DWORD('3') shl 24);
    D3DFMT_DXT4                 = DWORD('D') or (DWORD('X') shl 8) or (DWORD('T') shl 16) or (DWORD('4') shl 24);
    D3DFMT_DXT5                 = DWORD('D') or (DWORD('X') shl 8) or (DWORD('T') shl 16) or (DWORD('5') shl 24);
    D3DFMT_D16_LOCKABLE         = 70;
    D3DFMT_D32                  = 71;
    D3DFMT_D15S1                = 73;
    D3DFMT_D24S8                = 75;
    D3DFMT_D16                  = 80;
    D3DFMT_D24X8                = 77;
    D3DFMT_D24X4S4              = 79;
    D3DFMT_VERTEXDATA           = 100;
    D3DFMT_INDEX16              = 101;
    D3DFMT_INDEX32              = 102;
    D3DFMT_FORCE_DWORD          = $7fffffff;

    D3DDEVTYPE_HAL         		= 1;
    D3DDEVTYPE_REF         		= 2;
    D3DDEVTYPE_SW          		= 3;
    D3DDEVTYPE_FORCE_DWORD  	= $7fffffff;

    D3DRTYPE_SURFACE            = 1;
    D3DRTYPE_VOLUME             = 2;
    D3DRTYPE_TEXTURE            = 3;
    D3DRTYPE_VOLUMETEXTURE      = 4;
    D3DRTYPE_CUBETEXTURE        = 5;
    D3DRTYPE_VERTEXBUFFER       = 6;
    D3DRTYPE_INDEXBUFFER        = 7;
    D3DRTYPE_FORCE_DWORD        = $7fffffff;

    D3DMULTISAMPLE_NONE         =  0;
    D3DMULTISAMPLE_2_SAMPLES    =  2;
    D3DMULTISAMPLE_3_SAMPLES    =  3;
    D3DMULTISAMPLE_4_SAMPLES    =  4;
    D3DMULTISAMPLE_5_SAMPLES    =  5;
    D3DMULTISAMPLE_6_SAMPLES    =  6;
    D3DMULTISAMPLE_7_SAMPLES    =  7;
    D3DMULTISAMPLE_8_SAMPLES    =  8;
    D3DMULTISAMPLE_9_SAMPLES    =  9;
    D3DMULTISAMPLE_10_SAMPLES   = 10;
    D3DMULTISAMPLE_11_SAMPLES   = 11;
    D3DMULTISAMPLE_12_SAMPLES   = 12;
    D3DMULTISAMPLE_13_SAMPLES   = 13;
    D3DMULTISAMPLE_14_SAMPLES   = 14;
    D3DMULTISAMPLE_15_SAMPLES   = 15;
    D3DMULTISAMPLE_16_SAMPLES   = 16;
    D3DMULTISAMPLE_FORCE_DWORD  = $7fffffff;

    D3DSWAPEFFECT_DISCARD       = 1;
    D3DSWAPEFFECT_FLIP          = 2;
    D3DSWAPEFFECT_COPY          = 3;
    D3DSWAPEFFECT_COPY_VSYNC    = 4;
    D3DSWAPEFFECT_FORCE_DWORD   = $7fffffff;

    D3DBACKBUFFER_TYPE_MONO     = 0;
    D3DBACKBUFFER_TYPE_LEFT     = 1;
    D3DBACKBUFFER_TYPE_RIGHT    = 2;
    D3DBACKBUFFER_TYPE_FORCE_DWORD  = $7fffffff;

    D3DPOOL_DEFAULT             = 0;
    D3DPOOL_MANAGED             = 1;
    D3DPOOL_SYSTEMMEM           = 2;
    D3DPOOL_FORCE_DWORD         = $7fffffff;

    D3DTS_VIEW                  = 2;
    D3DTS_PROJECTION            = 3;
    D3DTS_TEXTURE0              = 16;
    D3DTS_TEXTURE1              = 17;
    D3DTS_TEXTURE2              = 18;
    D3DTS_TEXTURE3              = 19;
    D3DTS_TEXTURE4              = 20;
    D3DTS_TEXTURE5              = 21;
    D3DTS_TEXTURE6              = 22;
    D3DTS_TEXTURE7              = 23;
    D3DTS_FORCE_DWORD           = $7fffffff;

    D3DLIGHT_POINT          	= 1;
    D3DLIGHT_SPOT           	= 2;
    D3DLIGHT_DIRECTIONAL    	= 3;
    D3DLIGHT_FORCE_DWORD    	= $7fffffff;

    D3DRS_ZENABLE                   = 7;
    D3DRS_FILLMODE                  = 8;
    D3DRS_SHADEMODE                 = 9;
    D3DRS_LINEPATTERN               = 10;
    D3DRS_ZWRITEENABLE              = 14;
    D3DRS_ALPHATESTENABLE           = 15;
    D3DRS_LASTPIXEL                 = 16;
    D3DRS_SRCBLEND                  = 19;
    D3DRS_DESTBLEND                 = 20;
    D3DRS_CULLMODE                  = 22;
    D3DRS_ZFUNC                     = 23;
    D3DRS_ALPHAREF                  = 24;
    D3DRS_ALPHAFUNC                 = 25;
    D3DRS_DITHERENABLE              = 26;
    D3DRS_ALPHABLENDENABLE          = 27;
    D3DRS_FOGENABLE                 = 28;
    D3DRS_SPECULARENABLE            = 29;
    D3DRS_ZVISIBLE                  = 30;
    D3DRS_FOGCOLOR                  = 34;
    D3DRS_FOGTABLEMODE              = 35;
    D3DRS_FOGSTART                  = 36;
    D3DRS_FOGEND                    = 37;
    D3DRS_FOGDENSITY                = 38;
    D3DRS_EDGEANTIALIAS             = 40;
    D3DRS_ZBIAS                     = 47;
    D3DRS_RANGEFOGENABLE            = 48;
    D3DRS_STENCILENABLE             = 52;
    D3DRS_STENCILFAIL               = 53;
    D3DRS_STENCILZFAIL              = 54;
    D3DRS_STENCILPASS               = 55;
    D3DRS_STENCILFUNC               = 56;
    D3DRS_STENCILREF                = 57;
    D3DRS_STENCILMASK               = 58;
    D3DRS_STENCILWRITEMASK          = 59;
    D3DRS_TEXTUREFACTOR             = 60;
    D3DRS_WRAP0                     = 128;
    D3DRS_WRAP1                     = 129;
    D3DRS_WRAP2                     = 130;
    D3DRS_WRAP3                     = 131;
    D3DRS_WRAP4                     = 132;
    D3DRS_WRAP5                     = 133;
    D3DRS_WRAP6                     = 134;
    D3DRS_WRAP7                     = 135;
    D3DRS_CLIPPING                  = 136;
    D3DRS_LIGHTING                  = 137;
    D3DRS_AMBIENT                   = 139;
    D3DRS_FOGVERTEXMODE             = 140;
    D3DRS_COLORVERTEX               = 141;
    D3DRS_LOCALVIEWER               = 142;
    D3DRS_NORMALIZENORMALS          = 143;
    D3DRS_DIFFUSEMATERIALSOURCE     = 145;
    D3DRS_SPECULARMATERIALSOURCE    = 146;
    D3DRS_AMBIENTMATERIALSOURCE     = 147;
    D3DRS_EMISSIVEMATERIALSOURCE    = 148;
    D3DRS_VERTEXBLEND               = 151;
    D3DRS_CLIPPLANEENABLE           = 152;
    D3DRS_SOFTWAREVERTEXPROCESSING  = 153;
    D3DRS_POINTSIZE                 = 154;
    D3DRS_POINTSIZE_MIN             = 155;
    D3DRS_POINTSPRITEENABLE         = 156;
    D3DRS_POINTSCALEENABLE          = 157;
    D3DRS_POINTSCALE_A              = 158;
    D3DRS_POINTSCALE_B              = 159;
    D3DRS_POINTSCALE_C              = 160;
    D3DRS_MULTISAMPLEANTIALIAS      = 161;
    D3DRS_MULTISAMPLEMASK           = 162;
    D3DRS_PATCHEDGESTYLE            = 163;
    D3DRS_PATCHSEGMENTS             = 164;
    D3DRS_DEBUGMONITORTOKEN         = 165;
    D3DRS_POINTSIZE_MAX             = 166;
    D3DRS_INDEXEDVERTEXBLENDENABLE  = 167;
    D3DRS_COLORWRITEENABLE          = 168;
    D3DRS_TWEENFACTOR               = 170;
    D3DRS_BLENDOP                   = 171;
    D3DRS_FORCE_DWORD               = $7fffffff;

    D3DSBT_ALL           = 1;
    D3DSBT_PIXELSTATE    = 2;
    D3DSBT_VERTEXSTATE   = 3;
    D3DSBT_FORCE_DWORD   = $7fffffff;

    D3DTSS_COLOROP        =  1;
    D3DTSS_COLORARG1      =  2;
    D3DTSS_COLORARG2      =  3;
    D3DTSS_ALPHAOP        =  4;
    D3DTSS_ALPHAARG1      =  5;
    D3DTSS_ALPHAARG2      =  6;
    D3DTSS_BUMPENVMAT00   =  7;
    D3DTSS_BUMPENVMAT01   =  8;
    D3DTSS_BUMPENVMAT10   =  9;
    D3DTSS_BUMPENVMAT11   = 10;
    D3DTSS_TEXCOORDINDEX  = 11;
    D3DTSS_ADDRESSU       = 13;
    D3DTSS_ADDRESSV       = 14;
    D3DTSS_BORDERCOLOR    = 15;
    D3DTSS_MAGFILTER      = 16;
    D3DTSS_MINFILTER      = 17;
    D3DTSS_MIPFILTER      = 18;
    D3DTSS_MIPMAPLODBIAS  = 19;
    D3DTSS_MAXMIPLEVEL    = 20;
    D3DTSS_MAXANISOTROPY  = 21;
    D3DTSS_BUMPENVLSCALE  = 22;
    D3DTSS_BUMPENVLOFFSET = 23;
    D3DTSS_TEXTURETRANSFORMFLAGS = 24;
    D3DTSS_ADDRESSW       = 25;
    D3DTSS_COLORARG0      = 26;
    D3DTSS_ALPHAARG0      = 27;
    D3DTSS_RESULTARG      = 28;
    D3DTSS_FORCE_DWORD    = $7fffffff;

    D3DPT_POINTLIST             = 1;
    D3DPT_LINELIST              = 2;
    D3DPT_LINESTRIP             = 3;
    D3DPT_TRIANGLELIST          = 4;
    D3DPT_TRIANGLESTRIP         = 5;
    D3DPT_TRIANGLEFAN           = 6;
    D3DPT_FORCE_DWORD           = $7fffffff;

   D3DBASIS_BEZIER      = 0;
   D3DBASIS_BSPLINE     = 1;
   D3DBASIS_INTERPOLATE = 2;
   D3DBASIS_FORCE_DWORD = $7fffffff;

   D3DORDER_LINEAR      = 1;
   D3DORDER_CUBIC       = 3;
   D3DORDER_QUINTIC     = 5;
   D3DORDER_FORCE_DWORD = $7fffffff;

	D3DFVF_RESERVED0        = $001;
	D3DFVF_POSITION_MASK    = $00E;
	D3DFVF_XYZ              = $002;
	D3DFVF_XYZRHW           = $004;
	D3DFVF_XYZB1            = $006;
	D3DFVF_XYZB2            = $008;
	D3DFVF_XYZB3            = $00a;
	D3DFVF_XYZB4            = $00c;
	D3DFVF_XYZB5            = $00e;
	D3DFVF_NORMAL           = $010;
	D3DFVF_PSIZE            = $020;
	D3DFVF_DIFFUSE          = $040;
	D3DFVF_SPECULAR         = $080;
	D3DFVF_TEXCOUNT_MASK    = $f00;
	D3DFVF_TEXCOUNT_SHIFT   = 8;
	D3DFVF_TEX0             = $000;
	D3DFVF_TEX1             = $100;
	D3DFVF_TEX2             = $200;
	D3DFVF_TEX3             = $300;
	D3DFVF_TEX4             = $400;
	D3DFVF_TEX5             = $500;
	D3DFVF_TEX6             = $600;
	D3DFVF_TEX7             = $700;
	D3DFVF_TEX8             = $800;
	D3DFVF_LASTBETA_UBYTE4  = $1000;
	D3DFVF_RESERVED2        = $E000;

	D3DUSAGE_WRITEONLY          = $00000008;
	D3DUSAGE_SOFTWAREPROCESSING = $00000010;
	D3DUSAGE_DONOTCLIP          = $00000020;
	D3DUSAGE_POINTS             = $00000040;
	D3DUSAGE_RTPATCHES          = $00000080;
	D3DUSAGE_NPATCHES           = $00000100;
	D3DUSAGE_DYNAMIC            = $00000200;

    D3DCLEAR_TARGET             = $00000001;
	D3DCLEAR_ZBUFFER            = $00000002;
	D3DCLEAR_STENCIL            = $00000004;

    D3DBLEND_ZERO               = 1;
    D3DBLEND_ONE                = 2;
    D3DBLEND_SRCCOLOR           = 3;
    D3DBLEND_INVSRCCOLOR        = 4;
    D3DBLEND_SRCALPHA           = 5;
    D3DBLEND_INVSRCALPHA        = 6;
    D3DBLEND_DESTALPHA          = 7;
    D3DBLEND_INVDESTALPHA       = 8;
    D3DBLEND_DESTCOLOR          = 9;
    D3DBLEND_INVDESTCOLOR       = 10;
    D3DBLEND_SRCALPHASAT        = 11;
    D3DBLEND_BOTHSRCALPHA       = 12;
    D3DBLEND_BOTHINVSRCALPHA    = 13;
    D3DBLEND_FORCE_DWORD        = $7fffffff;

    D3DTOP_DISABLE              = 1;
    D3DTOP_SELECTARG1           = 2;
    D3DTOP_SELECTARG2           = 3;
    D3DTOP_MODULATE             = 4;
    D3DTOP_MODULATE2X           = 5;
    D3DTOP_MODULATE4X           = 6;
    D3DTOP_ADD                  =  7;
    D3DTOP_ADDSIGNED            =  8;
    D3DTOP_ADDSIGNED2X          =  9;
    D3DTOP_SUBTRACT             = 10;
    D3DTOP_ADDSMOOTH            = 11;
    D3DTOP_BLENDDIFFUSEALPHA    = 12;
    D3DTOP_BLENDTEXTUREALPHA    = 13;
    D3DTOP_BLENDFACTORALPHA     = 14;
    D3DTOP_BLENDTEXTUREALPHAPM  = 15;
    D3DTOP_BLENDCURRENTALPHA    = 16;
    D3DTOP_PREMODULATE            = 17;
    D3DTOP_MODULATEALPHA_ADDCOLOR = 18;
    D3DTOP_MODULATECOLOR_ADDALPHA = 19;
    D3DTOP_MODULATEINVALPHA_ADDCOLOR = 20;
    D3DTOP_MODULATEINVCOLOR_ADDALPHA = 21;
    D3DTOP_BUMPENVMAP           = 22;
    D3DTOP_BUMPENVMAPLUMINANCE  = 23;
    D3DTOP_DOTPRODUCT3          = 24;
    D3DTOP_MULTIPLYADD          = 25;
    D3DTOP_LERP                 = 26;
    D3DTOP_FORCE_DWORD = $7fffffff;

	D3DTA_SELECTMASK        = $0000000f;
	D3DTA_DIFFUSE           = $00000000;
	D3DTA_CURRENT           = $00000001;
	D3DTA_TEXTURE           = $00000002;
	D3DTA_TFACTOR           = $00000003;
	D3DTA_SPECULAR          = $00000004;
	D3DTA_TEMP              = $00000005;
	D3DTA_COMPLEMENT        = $00000010;
	D3DTA_ALPHAREPLICATE    = $00000020;

    D3DCULL_NONE                = 1;
    D3DCULL_CW                  = 2;
    D3DCULL_CCW                 = 3;
    D3DCULL_FORCE_DWORD         = $7fffffff;

    D3DFILL_POINT               = 1;
    D3DFILL_WIREFRAME           = 2;
    D3DFILL_SOLID               = 3;
    D3DFILL_FORCE_DWORD         = $7fffffff;

    D3DTEXF_NONE            = 0;
    D3DTEXF_POINT           = 1;
    D3DTEXF_LINEAR          = 2;
    D3DTEXF_ANISOTROPIC     = 3;
    D3DTEXF_FLATCUBIC       = 4;
    D3DTEXF_GAUSSIANCUBIC   = 5;
    D3DTEXF_FORCE_DWORD     = $7fffffff;

    D3DCMP_NEVER                = 1;
    D3DCMP_LESS                 = 2;
    D3DCMP_EQUAL                = 3;
    D3DCMP_LESSEQUAL            = 4;
    D3DCMP_GREATER              = 5;
    D3DCMP_NOTEQUAL             = 6;
    D3DCMP_GREATEREQUAL         = 7;
    D3DCMP_ALWAYS               = 8;
    D3DCMP_FORCE_DWORD          = $7fffffff;

////////////////////////////////////////////////////////////////////////////////
type
IDirect3DDevice8 = interface;
IDirect3DSurface8 = interface;
IDirect3DSwapChain8 = interface;
IDirect3DTexture8 = interface;
IDirect3DBaseTexture8 = interface;
IDirect3DVertexBuffer8 = interface;
IDirect3DIndexBuffer8 = interface;

LPD3DADAPTER_IDENTIFIER8 = ^D3DADAPTER_IDENTIFIER8;
D3DADAPTER_IDENTIFIER8 = record
    Driver:array[0..511] of char;
    Description:array[0..511] of char;

    DriverVersion:int64;

    VendorId:DWORD;
    DeviceId:DWORD;
    SubSysId:DWORD;
    Revision:DWORD;

    DeviceIdentifier:TGUID;

    WHQLLevel:DWORD;
end;

LPD3DDISPLAYMODE = ^D3DDISPLAYMODE;
D3DDISPLAYMODE = record
	Width:DWORD;
    Height:DWORD;
    RefreshRate:DWORD;
    Format:DWORD;
end;

LPD3DCAPS8 = ^D3DCAPS8;
D3DCAPS8 = record
    DeviceType:DWORD;
    AdapterOrdinal:DWORD;

    Caps:DWORD;
    Caps2:DWORD;
    Caps3:DWORD;
    PresentationIntervals:DWORD;

    CursorCaps:DWORD;

    DevCaps:DWORD;

    PrimitiveMiscCaps:DWORD;
    RasterCaps:DWORD;
    ZCmpCaps:DWORD;
    SrcBlendCaps:DWORD;
    DestBlendCaps:DWORD;
    AlphaCmpCaps:DWORD;
    ShadeCaps:DWORD;
    TextureCaps:DWORD;
    TextureFilterCaps:DWORD;
    CubeTextureFilterCaps:DWORD;
    VolumeTextureFilterCaps:DWORD;
    TextureAddressCaps:DWORD;
    VolumeTextureAddressCaps:DWORD;

    LineCaps:DWORD;

    MaxTextureWidth, MaxTextureHeight:DWORD;
    MaxVolumeExtent:DWORD;

    MaxTextureRepeat:DWORD;
    MaxTextureAspectRatio:DWORD;
    MaxAnisotropy:DWORD;
    MaxVertexW:DWORD;

    GuardBandLeft:single;
    GuardBandTop:single;
    GuardBandRight:single;
    GuardBandBottom:single;

    ExtentsAdjust:single;
    StencilCaps:DWORD;

    FVFCaps:DWORD;
    TextureOpCaps:DWORD;
    MaxTextureBlendStages:DWORD;
    MaxSimultaneousTextures:DWORD;

    VertexProcessingCaps:DWORD;
    MaxActiveLights:DWORD;
    MaxUserClipPlanes:DWORD;
    MaxVertexBlendMatrices:DWORD;
    MaxVertexBlendMatrixIndex:DWORD;

    MaxPointSize:single;

    MaxPrimitiveCount:DWORD;
    MaxVertexIndex:DWORD;
    MaxStreams:DWORD;
    MaxStreamStride:DWORD;

    VertexShaderVersion:DWORD;
    MaxVertexShaderConst:DWORD;

    PixelShaderVersion:DWORD;
    MaxPixelShaderValue:single;
end;

LPD3DPRESENT_PARAMETERS = ^D3DPRESENT_PARAMETERS;
D3DPRESENT_PARAMETERS = record
    BackBufferWidth:integer;
    BackBufferHeight:integer;
    BackBufferFormat:DWORD;
    BackBufferCount:integer;

    MultiSampleType:DWORD;

    SwapEffect:DWORD;
    hDeviceWindow:HWND;
    Windowed:BOOL;
    EnableAutoDepthStencil:BOOL;
    AutoDepthStencilFormat:DWORD;
    Flags:DWORD;

    FullScreen_RefreshRateInHz:integer;
    FullScreen_PresentationInterval:integer;
end;

LPD3DDEVICE_CREATION_PARAMETERS = ^D3DDEVICE_CREATION_PARAMETERS;
D3DDEVICE_CREATION_PARAMETERS = record
    AdapterOrdinal:integer;
    DeviceType:DWORD;
    hFocusWindow:HWND;
    BehaviorFlags:DWORD;
end;

LPD3DRASTER_STATUS = ^D3DRASTER_STATUS;
D3DRASTER_STATUS = record
    InVBlank:BOOL;
    ScanLine:integer;
end;

LPD3DGAMMARAMP = ^D3DGAMMARAMP;
D3DGAMMARAMP = record
    red:array[0..255] of WORD;
    green:array[0..255] of WORD;
    blue:array[0..255] of WORD;
end;

LPD3DRECT = ^D3DRECT;
D3DRECT = record
    x1:integer;
    y1:integer;
    x2:integer;
    y2:integer;
end;

LPD3DVECTOR = ^D3DVECTOR;
D3DVECTOR = record
    x:single;
    y:single;
    z:single;
end;

LPD3DMATRIX = ^D3DMATRIX;
D3DMATRIX = record
    case Integer of
    0: (
		_11, _12, _13, _14:single;
		_21, _22, _23, _24:single;
		_31, _32, _33, _34:single;
		_41, _42, _43, _44:single;
    );
    1: (
	    m:array[0..3,0..3] of single;
    );
end;

LPD3DVIEWPORT8 = ^D3DVIEWPORT8;
D3DVIEWPORT8 = record
    X:DWORD;
    Y:DWORD;
    Width:DWORD;
    Height:DWORD;
    MinZ:single;
    MaxZ:single;
end;

LPD3DCOLORVALUE = ^D3DCOLORVALUE;
D3DCOLORVALUE = record
    r:D3DVALUE;
    g:D3DVALUE;
    b:D3DVALUE;
    a:D3DVALUE;
end;

LPD3DMATERIAL8 = ^D3DMATERIAL8;
D3DMATERIAL8 = record
    Diffuse:D3DCOLORVALUE;
    Ambient:D3DCOLORVALUE;
    Specular:D3DCOLORVALUE;
    Emissive:D3DCOLORVALUE;
    Power:single;
end;

LPD3DLIGHT8 = ^D3DLIGHT8;
D3DLIGHT8 = record
    lType:DWORD;
    Diffuse:D3DCOLORVALUE;
    Specular:D3DCOLORVALUE;
    Ambient:D3DCOLORVALUE;
    Position:D3DVECTOR;
    Direction:D3DVECTOR;
    Range:single;
    Falloff:single;
    Attenuation0:single;
    Attenuation1:single;
    Attenuation2:single;
    Theta:single;
    Phi:single;
end;

LPD3DCLIPSTATUS8 = ^D3DCLIPSTATUS8;
D3DCLIPSTATUS8 = record
    ClipUnion:DWORD;
    ClipIntersection:DWORD;
end;

LPD3DRECTPATCH_INFO = ^D3DRECTPATCH_INFO;
D3DRECTPATCH_INFO = record
    StartVertexOffsetWidth:integer;
    StartVertexOffsetHeight:integer;
    Width:integer;
    Height:integer;
    Stride:integer;
    Basis:DWORD;
    Order:DWORD;
end;

LPD3DTRIPATCH_INFO = ^D3DTRIPATCH_INFO;
D3DTRIPATCH_INFO = record
    StartVertexOffset:integer;
    NumVertices:integer;
    Basis:DWORD;
    Order:DWORD;
end;

LPD3DSURFACE_DESC = ^D3DSURFACE_DESC;
D3DSURFACE_DESC = record
    Format:DWORD;
    rType:DWORD;
    Usage:DWORD;
    Pool:DWORD;
    Size:integer;

    MultiSampleType:DWORD;
    Width:integer;
    Height:integer;
end;

LPD3DLOCKED_RECT = ^D3DLOCKED_RECT;
D3DLOCKED_RECT = record
    Pitch:integer;
    pBits:Pointer;
end;

LPD3DVERTEXBUFFER_DESC = ^D3DVERTEXBUFFER_DESC;
D3DVERTEXBUFFER_DESC = record
    Format:DWORD;
    rType:DWORD;
    Usage:DWORD;
    Pool:DWORD;
    Size:integer;
	FVF:DWORD;
end;

LPD3DINDEXBUFFER_DESC = ^D3DINDEXBUFFER_DESC;
D3DINDEXBUFFER_DESC = record
    Format:DWORD;
    rType:DWORD;
    Usage:DWORD;
    Pool:DWORD;
    Size:integer;
end;

////////////////////////////////////////////////////////////////////////////////
IDirect3D8 = interface(IUnknown)
    ['{1DD9E8DA-1C77-4d40-B0CF-98FEFDFF9512}']
    function RegisterSoftwareDevice(fun:Pointer):HResult; stdcall;
    function GetAdapterCount:integer; stdcall;
    function GetAdapterIdentifier(Adapter:integer; Flags:DWORD; pIdentifier:LPD3DADAPTER_IDENTIFIER8):HResult; stdcall;
    function GetAdapterModeCount(Adapter:integer):integer; stdcall;
    function EnumAdapterModes(Adapter:integer; Mode:integer; pMode:LPD3DDISPLAYMODE):HResult; stdcall;
    function GetAdapterDisplayMode(Adapter:integer; pMode:LPD3DDISPLAYMODE):HResult; stdcall;
    function CheckDeviceType(Adapter:integer; CheckType:DWORD; DisplayFormat:DWORD; BackBufferFormat:DWORD; Windowed:BOOL):HResult; stdcall;
    function CheckDeviceFormat(Adapter:integer; DeviceType:DWORD; AdapterFormat:DWORD; Usage:DWORD; RType:DWORD; CheckFormat:DWORD):HResult; stdcall;
    function CheckDeviceMultiSampleType(Adapter:integer; DeviceType:DWORD; SurfaceFormat:DWORD; Windowed:BOOL; MultiSampleType:DWORD):HResult; stdcall;
    function CheckDepthStencilMatch(Adapter:integer; DeviceType:DWORD; AdapterFormat:DWORD; RenderTargetFormat:DWORD; DepthStencilFormat:DWORD):HResult; stdcall;
    function GetDeviceCaps(Adapter:integer; DeviceType:DWORD; pCaps:LPD3DCAPS8):HResult; stdcall;
    function GetAdapterMonitor(Adapter:integer):DWORD; stdcall;
    function CreateDevice(Adapter:integer; DeviceType:DWORD; hFocusWindow:HWND; BehaviorFlags:DWORD; pPresentationParameters:LPD3DPRESENT_PARAMETERS; out ppReturnedDeviceInterface: IDirect3DDevice8):HResult; stdcall;
end;

IDirect3DDevice8 = interface(IUnknown)
    ['{7385E5DF-8FE8-41D5-86B6-D7B48547B6CF}']
    function TestCooperativeLevel:HResult; stdcall;
    function GetAvailableTextureMem:integer; stdcall;
    function ResourceManagerDiscardBytes(Bytes:DWORD):HResult; stdcall;
    function GetDirect3D(out ppD3D8: IDirect3D8):HResult; stdcall;
    function GetDeviceCaps(pCaps:LPD3DCAPS8):HResult; stdcall;
    function GetDisplayMode(pMode:LPD3DDISPLAYMODE):HResult; stdcall;
    function GetCreationParameters(pParameters:LPD3DDEVICE_CREATION_PARAMETERS):HResult; stdcall;
    function SetCursorProperties(XHotSpot:integer; YHotSpot:integer; pCursorBitmap:IDirect3DSurface8):HResult; stdcall;
    function SetCursorPosition(XScreenSpace:integer; YScreenSpace:integer; Flags:DWORD):HResult; stdcall;
    function ShowCursor(bShow:BOOL):HResult; stdcall;
    function CreateAdditionalSwapChain(pPresentationParameters:LPD3DPRESENT_PARAMETERS; out pSwapChain:IDirect3DSwapChain8):HResult; stdcall;
    function Reset(pPresentationParameters:LPD3DPRESENT_PARAMETERS):HResult; stdcall;
    function Present(pSourceRect:PRect; pDestRect:PRect; hDestWindowOverride:HWND; pDirtyRegion:PRGNDATA):HResult; stdcall;
    function GetBackBuffer(BackBuffer:integer; bbType:DWORD; out ppBackBuffer:IDirect3DSurface8):HResult; stdcall;
    function GetRasterStatus(pRasterStatus:LPD3DRASTER_STATUS):HResult; stdcall;
    procedure SetGammaRamp(Flags:DWORD; pRamp:LPD3DGAMMARAMP); stdcall;
    procedure GetGammaRamp(Flags:DWORD; pRamp:LPD3DGAMMARAMP); stdcall;
    function CreateTexture(Width,Height,Levels:integer; Usage:DWORD; Format:DWORD; Pool:DWORD; out ppTexture:IDirect3DTexture8):HResult; stdcall;
    function CreateVolumeTexture(Width,Height,Depth,Levels:integer; Usage:DWORD; Format:DWORD; Pool:DWORD; out ppTexture:IDirect3DTexture8):HResult; stdcall;
    function CreateCubeTexture(EdgeLength,Levels:integer; Usage:DWORD; Format:DWORD; Pool:DWORD; out ppCubeTexture:IDirect3DTexture8):HResult; stdcall;
    function CreateVertexBuffer(Length:integer; Usage:DWORD; FVF:DWORD; Pool:DWORD; out ppVertexBuffer:IDirect3DVertexBuffer8):HResult; stdcall;
    function CreateIndexBuffer(Length:integer; Usage:DWORD; Format:DWORD; Pool:DWORD; out ppIndexBuffer:IDirect3DIndexBuffer8):HResult; stdcall;
    function CreateRenderTarget(Width,Height:integer; Format:DWORD; MultiSample:DWORD; Lockable:BOOL; out ppSurface:IDirect3DSurface8):HResult; stdcall;
    function CreateDepthStencilSurface(Width,Height:integer; Format:DWORD; MultiSample:DWORD; out ppSurface:IDirect3DSurface8):HResult; stdcall;
    function CreateImageSurface(Width,Height:integer; Format:DWORD; out ppSurface:IDirect3DSurface8):HResult; stdcall;
    function CopyRects(pSourceSurface:IDirect3DSurface8; pSourceRectsArray:PRect; cRects:integer; pDestinationSurface:IDirect3DSurface8; pDestPointsArray:PPoint):HResult; stdcall;
    function UpdateTexture(pSourceTexture:IDirect3DBaseTexture8; pDestinationTexture:IDirect3DBaseTexture8):HResult; stdcall;
    function GetFrontBuffer(pDestSurface:IDirect3DSurface8):HResult; stdcall;
    function SetRenderTarget(pRenderTarget:IDirect3DSurface8; pNewZStencil:IDirect3DSurface8):HResult; stdcall;
    function GetRenderTarget(out ppRenderTarget:IDirect3DSurface8):HResult; stdcall;
    function GetDepthStencilSurface(out ppZStencilSurface:IDirect3DSurface8):HResult; stdcall;
    function BeginScene:HResult; stdcall;
    function EndScene:HResult; stdcall;
    function Clear(Count:DWORD; pRects:LPD3DRECT; Flags:DWORD; Color:D3DCOLOR; Z:single; Stencil:DWORD):HResult; stdcall;
    function SetTransform(State:DWORD; pMatrix:LPD3DMATRIX):HResult; stdcall;
    function GetTransform(State:DWORD; pMatrix:LPD3DMATRIX):HResult; stdcall;
    function MultiplyTransform(State:DWORD; pMatrix:LPD3DMATRIX):HResult; stdcall;
    function SetViewport(pViewport:LPD3DVIEWPORT8):HResult; stdcall;
    function GetViewport(pViewport:LPD3DVIEWPORT8):HResult; stdcall;
    function SetMaterial(pMaterial:LPD3DMATERIAL8):HResult; stdcall;
    function GetMaterial(pMaterial:LPD3DMATERIAL8):HResult; stdcall;
    function SetLight(Index:DWORD; li:LPD3DLIGHT8):HResult; stdcall;
    function GetLight(Index:DWORD; li:LPD3DLIGHT8):HResult; stdcall;
    function LightEnable(Index:DWORD; Enable:BOOL):HResult; stdcall;
    function GetLightEnable(Index:DWORD; pEnable:PBOOL):HResult; stdcall;
    function SetClipPlane(Index:DWORD; pPlane:single):HResult; stdcall;
    function GetClipPlane(Index:DWORD; pPlane:psingle):HResult; stdcall;
    function SetRenderState(State:DWORD; Value:DWORD):HResult; stdcall;
    function GetRenderState(State:DWORD; pValue:PDWORD):HResult; stdcall;
    function BeginStateBlock:HResult; stdcall;
    function EndStateBlock(pToken:PDWORD):HResult; stdcall;
    function ApplyStateBlock(Token:DWORD):HResult; stdcall;
    function CaptureStateBlock(Token:DWORD):HResult; stdcall;
    function DeleteStateBlock(Token:DWORD):HResult; stdcall;
    function CreateStateBlock(sType:DWORD; pToken:PDWORD):HResult; stdcall;
    function SetClipStatus(pClipStatus:LPD3DCLIPSTATUS8):HResult; stdcall;
    function GetClipStatus(pClipStatus:LPD3DCLIPSTATUS8):HResult; stdcall;
    function GetTexture(Stage:DWORD; out ppTexture:IDirect3DBaseTexture8):HResult; stdcall;
    function SetTexture(Stage:DWORD; pTexture:IDirect3DBaseTexture8):HResult; stdcall;
    function GetTextureStageState(State:DWORD; sType:DWORD; pValue:PDWORD):HResult; stdcall;
    function SetTextureStageState(State:DWORD; sType:DWORD; Value:DWORD):HResult; stdcall;
    function ValidateDevice(pNumPasses:PDWORD):HResult; stdcall;
    function GetInfo(DevInfoID:DWORD; pDevInfoStruct:Pointer; DevInfoStructSize:DWORD):HResult; stdcall;
    function SetPaletteEntries(PaletteNumber:integer; pEntries:PPaletteEntry):HResult; stdcall;
    function GetPaletteEntries(PaletteNumber:integer; pEntries:PPaletteEntry):HResult; stdcall;
    function SetCurrentTexturePalette(PaletteNumber:integer):HResult; stdcall;
    function GetCurrentTexturePalette(PaletteNumber:pinteger):HResult; stdcall;
    function DrawPrimitive(PrimitiveType:DWORD; StartVertex:integer; PrimitiveCount:integer):HResult; stdcall;
    function DrawIndexedPrimitive(PrimitiveType:DWORD; minIndex:integer; NumVertices:integer; startIndex:integer; primCount:integer):HResult; stdcall;
    function DrawPrimitiveUP(PrimitiveType:DWORD; PrimitiveCount:integer; pVertexStreamZeroData:Pointer; VertexStreamZeroStride:integer):HResult; stdcall;
    function DrawIndexedPrimitiveUP(PrimitiveType:DWORD; MinVertexIndex:integer; NumVertexIndices:integer; PrimitiveCount:integer; pIndexData:pointer; IndexDataFormat:DWORD; pVertexStreamZeroData:Pointer; VertexStreamZeroStride:integer):HResult; stdcall;
    function ProcessVertices(SrcStartIndex:integer; DestIndex:integer; VertexCount:integer; pDestBuffer:IDirect3DVertexBuffer8; Flags:DWORD):HResult; stdcall;
	function CreateVertexShader(pDeclaration:PDWORD; pFunction:PDWORD; pHandle:PDWORD; Usage:DWORD):HResult; stdcall;
    function SetVertexShader(Handle:DWORD):HResult; stdcall;
    function GetVertexShader(Handle:PDWORD):HResult; stdcall;
    function DeleteVertexShader(Handle:DWORD):HResult; stdcall;
    function SetVertexShaderConstant(rRegister:DWORD; pConstantData:Pointer; ConstantCount:DWORD):HResult; stdcall;
    function GetVertexShaderConstant(rRegister:DWORD; pConstantData:Pointer; ConstantCount:DWORD):HResult; stdcall;
    function GetVertexShaderDeclaration(Handle:DWORD; pData:Pointer; pSizeOfData:DWORD):HResult; stdcall;
    function GetVertexShaderFunction(Handle:DWORD; pData:Pointer; pSizeOfData:PDWORD):HResult; stdcall;
    function SetStreamSource(StreamNumber:integer; pStreamData:IDirect3DVertexBuffer8; Stride:integer):HResult; stdcall;
    function GetStreamSource(StreamNumber:integer; out ppStreamData:IDirect3DVertexBuffer8; pStride:pinteger):HResult; stdcall;
	function SetIndices(pIndexData:IDirect3DIndexBuffer8; BaseVertexIndex:integer):HResult; stdcall;
    function GetIndices(out ppIndexData:IDirect3DIndexBuffer8; pBaseVertexIndex:pinteger):HResult; stdcall;
    function CreatePixelShader(pFunction:PDWORD; pHandle:PDWORD):HResult; stdcall;
    function SetPixelShader(Handle:DWORD):HResult; stdcall;
    function GetPixelShader(Handle:PDWORD):HResult; stdcall;
    function DeletePixelShader(Handle:DWORD):HResult; stdcall;
    function SetPixelShaderConstant(rRegister:DWORD; pConstantData:Pointer; ConstantCount:DWORD):HResult; stdcall;
    function GetPixelShaderConstant(rRegister:DWORD; pConstantData:Pointer; ConstantCount:DWORD):HResult; stdcall;
    function GetPixelShaderFunction(Handle:DWORD; pData:Pointer; pSizeOfData:DWORD):HResult; stdcall;
    function DrawRectPatch(Handle:integer; pNumSegs:psingle; pRectPatchInfo:LPD3DRECTPATCH_INFO):HResult; stdcall;
    function DrawTriPatch(Handle:integer; pNumSegs:psingle; pTriPatchInfo:LPD3DTRIPATCH_INFO):HResult; stdcall;
    function DeletePatch(Handle:integer):HResult; stdcall;
end;

IDirect3DSurface8 = interface(IUnknown)
    ['{B96EEBCA-B326-4ea5-882F-2FF5BAE021DD}']

    function GetDevice(out ppDevice:IDirect3DDevice8):HResult; stdcall;
    function SetPrivateData(refguid:TGUID; pData:pointer; SizeOfData:DWORD; Flags:DWORD):HResult; stdcall;
    function GetPrivateData(refguid:TGUID; pData:pointer; pSizeOfData:PDWORD):HResult; stdcall;
    function FreePrivateData(refguid:TGUID):HResult; stdcall;
    function GetContainer(riid:TGUID; out ppContainer:Pointer):HResult; stdcall;
    function GetDesc(pDesc:LPD3DSURFACE_DESC):HResult; stdcall;
    function LockRect(pLockedRect:LPD3DLOCKED_RECT; pRect:PRect; Flags:DWORD):HResult; stdcall;
    function UnlockRect:HResult; stdcall;
end;

IDirect3DSwapChain8 = interface(IUnknown)
    ['{928C088B-76B9-4C6B-A536-A590853876CD}']
    function Present(pSourceRect:PRect; pDestRect:PRect; hDestWindowOverride:HWND; pDirtyRegion:PRGNDATA):HResult; stdcall;
    function GetBackBuffer(BackBuffer:integer; bbType:DWORD; out ppBackBuffer:IDirect3DSurface8):HResult; stdcall;
end;

IDirect3DTexture8 = interface(IUnknown)
    ['{E4CDD575-2866-4f01-B12E-7EECE1EC9358}']
    function GetDevice(out ppDevice:IDirect3DDevice8):HResult; stdcall;
    function SetPrivateData(refguid:TGUID; pData:pointer; SizeOfData:DWORD; Flags:DWORD):HResult; stdcall;
    function GetPrivateData(refguid:TGUID; pData:pointer; pSizeOfData:PDWORD):HResult; stdcall;
    function FreePrivateData(refguid:TGUID):HResult; stdcall;
    function SetPriority(PriorityNew:DWORD):DWORD; stdcall;
    function GetPriority:DWORD; stdcall;
    procedure PreLoad; stdcall;
    function GetType:DWORD; stdcall;
    function SetLOD(LODNew:DWORD):HResult; stdcall;
    function GetLOD:DWORD; stdcall;
    function GetLevelCount:DWORD; stdcall;
    function GetLevelDesc(Level:integer; pDesc:LPD3DSURFACE_DESC):HResult; stdcall;
    function GetSurfaceLevel(Level:integer; out ppSurfaceLevel:IDirect3DSurface8):HResult; stdcall;
    function LockRect(Level:integer; pLockedRect:LPD3DLOCKED_RECT; pRect:PRECT; Flags:DWORD):HResult; stdcall;
    function UnlockRect(Level:integer):HResult; stdcall;
    function AddDirtyRect(pDirtyRect:PRECT):HResult; stdcall;
end;

IDirect3DBaseTexture8 = interface(IUnknown)
    ['{B4211CFA-51B9-4a9f-AB78-DB99B2BB678E}']
    function GetDevice(out ppDevice:IDirect3DDevice8):HResult; stdcall;
    function SetPrivateData(refguid:TGUID; pData:pointer; SizeOfData:DWORD; Flags:DWORD):HResult; stdcall;
    function GetPrivateData(refguid:TGUID; pData:pointer; pSizeOfData:PDWORD):HResult; stdcall;
    function FreePrivateData(refguid:TGUID):HResult; stdcall;
    function SetPriority(PriorityNew:DWORD):DWORD; stdcall;
    function GetPriority:DWORD; stdcall;
    procedure PreLoad; stdcall;
    function GetType:DWORD; stdcall;
    function SetLOD(LODNew:DWORD):HResult; stdcall;
    function GetLOD:DWORD; stdcall;
    function GetLevelCount:DWORD; stdcall;
end;

IDirect3DVertexBuffer8 = interface(IUnknown)
    ['{8AEEEAC7-05F9-44d4-B591-000B0DF1CB95}']
    function GetDevice(out ppDevice:IDirect3DDevice8):HResult; stdcall;
    function SetPrivateData(refguid:TGUID; pData:pointer; SizeOfData:DWORD; Flags:DWORD):HResult; stdcall;
    function GetPrivateData(refguid:TGUID; pData:pointer; pSizeOfData:PDWORD):HResult; stdcall;
    function FreePrivateData(refguid:TGUID):HResult; stdcall;
    function SetPriority(PriorityNew:DWORD):DWORD; stdcall;
    function GetPriority:DWORD; stdcall;
    procedure PreLoad; stdcall;
    function GetType:DWORD; stdcall;
    function Lock(OffsetToLock:integer; SizeToLock:integer; out ppbData:Pointer; Flags:DWORD):HResult; stdcall;
    function Unlock:HResult; stdcall;
    function GetDesc(pDesc:LPD3DVERTEXBUFFER_DESC):HResult; stdcall;
end;

IDirect3DIndexBuffer8 = interface(IUnknown)
    ['{0E689C9A-053D-44a0-9D92-DB0E3D750F86}']
    function GetDevice(out ppDevice:IDirect3DDevice8):HResult; stdcall;
    function SetPrivateData(refguid:TGUID; pData:pointer; SizeOfData:DWORD; Flags:DWORD):HResult; stdcall;
    function GetPrivateData(refguid:TGUID; pData:pointer; pSizeOfData:PDWORD):HResult; stdcall;
    function FreePrivateData(refguid:TGUID):HResult; stdcall;
    function SetPriority(PriorityNew:DWORD):DWORD; stdcall;
    function GetPriority:DWORD; stdcall;
    procedure PreLoad; stdcall;
    function GetType:DWORD; stdcall;
    function Lock(OffsetToLock:integer; SizeToLock:integer; out ppbData:Pointer; Flags:DWORD):HResult; stdcall;
    function Unlock:HResult; stdcall;
    function GetDesc(pDesc:LPD3DINDEXBUFFER_DESC):HResult; stdcall;
end;

function D3DCOLOR_A(zn:DWORD):BYTE;
function D3DCOLOR_R(zn:DWORD):BYTE;
function D3DCOLOR_G(zn:DWORD):BYTE;
function D3DCOLOR_B(zn:DWORD):BYTE;
function D3DCOLOR_ARGB(a,r,g,b:BYTE):DWORD;
function D3DCOLOR_RGBA(r,g,b,a:BYTE):DWORD;
function D3DCOLOR_XRGB(r,g,b:BYTE):DWORD;
function D3DV(x,y,z:single):D3DVECTOR;

implementation

function D3DCOLOR_A(zn:DWORD):BYTE;
begin
	Result:=BYTE(zn shr 24);
end;

function D3DCOLOR_R(zn:DWORD):BYTE;
begin
	Result:=BYTE(zn shr 16);
end;

function D3DCOLOR_G(zn:DWORD):BYTE;
begin
	Result:=BYTE(zn shr 8);
end;

function D3DCOLOR_B(zn:DWORD):BYTE;
begin
	Result:=BYTE(zn);
end;

function D3DCOLOR_ARGB(a,r,g,b:BYTE):DWORD;
begin
	Result:=((a and $ff) shl 24) or ((r and $ff) shl 16) or ((g and $ff) shl 8) or (b and $ff);
end;

function D3DCOLOR_RGBA(r,g,b,a:BYTE):DWORD;
begin
	Result:=((a and $ff) shl 24) or ((r and $ff) shl 16) or ((g and $ff) shl 8) or (b and $ff);
end;

function D3DCOLOR_XRGB(r,g,b:BYTE):DWORD;
begin
	Result:=(($ff) shl 24) or ((r and $ff) shl 16) or ((g and $ff) shl 8) or (b and $ff);
end;

function D3DV(x,y,z:single):D3DVECTOR;
begin
	Result.x:=x;
	Result.y:=y;
	Result.z:=z;
end;

end.
