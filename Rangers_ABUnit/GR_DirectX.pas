unit GR_DirectX;

interface

uses Windows, MMSystem, SysUtils;

const
  CLSID_DirectDraw: TGUID = '{D7B70EE0-4340-11CF-B063-0020AFC2CD35}';
  IID_IDirectDraw: TGUID = '{6C14DB80-A733-11CE-A521-0020AF0BE560}';
  IID_IDirectDrawPalette: TGUID = '{6C14DB84-A733-11CE-A521-0020AF0BE560}';
  IID_IDirectDrawClipper: TGUID = '{6C14DB85-A733-11CE-A521-0020AF0BE560}';
  IID_IDirectDraw7: TGUID = '{15e65ec0-3b9c-11d2-b92f-00609797ea5b}';
  IID_IDirectDrawSurface7: TGUID = '{06675a80-3b9b-11d2-b92f-00609797ea5b}';

  IID_IDirectInput: TGUID = '{89521360-AA8A-11CF-BFC7-444553540000}';
  IID_IDirectInput7: TGUID = '{9A4CB684-236D-11D3-8E9D-00C04f6844ae}';
  IID_IDirectInputDevice: TGUID = '{5944E680-C92E-11CF-BFC7-444553540000}';
  IID_IDirectInputDevice7: TGUID = '{57D7C6BC-2356-11D3-8E9D-00C04f6844ae}';
  IID_IDirectInputEffect: TGUID = '{E7E1F7C0-88D2-11D0-9AD0-00A0C9A06E35}';

  GUID_Button: TGUID = '{A36D02F0-C9F3-11CF-BFC7-444553540000}';
  GUID_SysMouse: TGUID = '{6F1D2B60-D5A0-11CF-BFC7-444553540000}';
  GUID_SysKeyboard: TGUID = '{6F1D2B61-D5A0-11CF-BFC7-444553540000}';
  GUID_Key: TGUID = '{55728220-D33C-11CF-BFC7-444553540000}';

  CLSID_DirectSound: TGUID = '{47D4D946-62E8-11cf-93BC-444553540000}';
  CLSID_DirectSoundCapture: TGUID = '{B0210780-89CD-11d0-AF08-00A0C925CD16}';

  IID_IDirectSound: TGUID = '{279AFA83-4981-11CE-A521-0020AF0BE560}';
  IID_IDirectSoundBuffer: TGUID = '{279AFA85-4981-11CE-A521-0020AF0BE560}';
  IID_IDirectSound3DListener: TGUID = '{279AFA84-4981-11CE-A521-0020AF0BE560}';
  IID_IDirectSound3DBuffer: TGUID = '{279AFA86-4981-11CE-A521-0020AF0BE560}';
  IID_IDirectSoundCapture: TGUID = '{B0210781-89CD-11D0-AF08-00A0C925CD16}';
  IID_IDirectSoundCaptureBuffer: TGUID = '{B0210782-89CD-11D0-AF08-00A0C925CD16}';

  IID_IDirectSoundNotify: TGUID = '{B0210783-89CD-11D0-AF08-00A0C925CD16}';

  DD_ROP_SPACE = 256 div 32;       // space required to store ROP array
  MAX_DDDEVICEID_STRING = 512;

  DDEDM_REFRESHRATES        = $00000001;

{ DirectDraw SetCooperativeLevel Flags }

  DDSCL_FULLSCREEN          = $00000001;
  DDSCL_ALLOWREBOOT         = $00000002;
  DDSCL_NOWINDOWCHANGES     = $00000004;
  DDSCL_NORMAL              = $00000008;
  DDSCL_EXCLUSIVE           = $00000010;
  DDSCL_ALLOWMODEX          = $00000040;
  DDSCL_SETFOCUSWINDOW      = $00000080;
  DDSCL_SETDEVICEWINDOW     = $00000100;
  DDSCL_CREATEDEVICEWINDOW  = $00000200;
  DDSCL_MULTITHREADED       = $00000400;
  DDSCL_FPUSETUP            = $00000800;

{ ddsCaps field is valid. }
  DDSD_CAPS               = $00000001;     // default
  DDSD_HEIGHT             = $00000002;
  DDSD_WIDTH              = $00000004;
  DDSD_PITCH              = $00000008;
  DDSD_BACKBUFFERCOUNT    = $00000020;
  DDSD_ZBUFFERBITDEPTH    = $00000040;
  DDSD_ALPHABITDEPTH      = $00000080;
  DDSD_LPSURFACE          = $00000800;
  DDSD_PIXELFORMAT        = $00001000;
  DDSD_CKDESTOVERLAY      = $00002000;
  DDSD_CKDESTBLT          = $00004000;
  DDSD_CKSRCOVERLAY       = $00008000;
  DDSD_CKSRCBLT           = $00010000;
  DDSD_MIPMAPCOUNT        = $00020000;
  DDSD_REFRESHRATE        = $00040000;
  DDSD_LINEARSIZE         = $00080000;
  DDSD_TEXTURESTAGE       = $00100000;
  DDSD_ALL                = $0007f9ee;

{ DirectDrawSurface Capability Flags }

  DDSCAPS_RESERVED1           = $00000001; { DDSCAPS_3D }
  DDSCAPS_ALPHA               = $00000002;
  DDSCAPS_BACKBUFFER          = $00000004;
  DDSCAPS_COMPLEX             = $00000008;
  DDSCAPS_FLIP                = $00000010;
  DDSCAPS_FRONTBUFFER         = $00000020;
  DDSCAPS_OFFSCREENPLAIN      = $00000040;
  DDSCAPS_OVERLAY             = $00000080;
  DDSCAPS_PALETTE             = $00000100;
  DDSCAPS_PRIMARYSURFACE      = $00000200;
  DDSCAPS_PRIMARYSURFACELEFT  = $00000400;
  DDSCAPS_SYSTEMMEMORY        = $00000800;
  DDSCAPS_TEXTURE             = $00001000;
  DDSCAPS_3DDEVICE            = $00002000;
  DDSCAPS_VIDEOMEMORY         = $00004000;
  DDSCAPS_VISIBLE             = $00008000;
  DDSCAPS_WRITEONLY           = $00010000;
  DDSCAPS_ZBUFFER             = $00020000;
  DDSCAPS_OWNDC               = $00040000;
  DDSCAPS_LIVEVIDEO           = $00080000;
  DDSCAPS_HWCODEC             = $00100000;
  DDSCAPS_MODEX               = $00200000;
  DDSCAPS_MIPMAP              = $00400000;
  DDSCAPS_RESERVED2           = $00800000;
  DDSCAPS_ALLOCONLOAD         = $04000000;
  DDSCAPS_VIDEOPORT           = $08000000;
  DDSCAPS_LOCALVIDMEM         = $10000000;
  DDSCAPS_NONLOCALVIDMEM      = $20000000;
  DDSCAPS_STANDARDVGAMODE     = $40000000;
  DDSCAPS_OPTIMIZED           = $80000000;

{ DirectDrawSurface Capability Flags 2 }

  DDSCAPS2_HARDWAREDEINTERLACE = $00000002;
  DDSCAPS2_HINTDYNAMIC         = $00000004;
  DDSCAPS2_HINTSTATIC          = $00000008;
  DDSCAPS2_TEXTUREMANAGE       = $00000010;
  DDSCAPS2_RESERVED1           = $00000020;
  DDSCAPS2_RESERVED2           = $00000040;
  DDSCAPS2_OPAQUE              = $00000080;
  DDSCAPS2_HINTANTIALIASING    = $00000100;

{ DirectDraw Return Codes }

  DD_OK                                   = 0;
  DD_FALSE                                = S_FALSE;

{ DirectDraw EnumCallback Return Values }

  DDENUMRET_CANCEL = 0;
  DDENUMRET_OK     = 1;

{ DirectDrawSurface Lock Flags }

  DDLOCK_SURFACEMEMORYPTR  = $00000000;    // default
  DDLOCK_WAIT              = $00000001;
  DDLOCK_EVENT             = $00000002;
  DDLOCK_READONLY          = $00000010;
  DDLOCK_WRITEONLY         = $00000020;
  DDLOCK_NOSYSLOCK         = $00000800;

{ BltFast Flags }

  DDBLTFAST_NOCOLORKEY   = $00000000;
  DDBLTFAST_SRCCOLORKEY  = $00000001;
  DDBLTFAST_DESTCOLORKEY = $00000002;
  DDBLTFAST_WAIT         = $00000010;

{ DirectDraw Blt Flags }

  DDBLT_ALPHADEST                = $00000001;
  DDBLT_ALPHADESTCONSTOVERRIDE   = $00000002;
  DDBLT_ALPHADESTNEG             = $00000004;
  DDBLT_ALPHADESTSURFACEOVERRIDE = $00000008;
  DDBLT_ALPHAEDGEBLEND           = $00000010;
  DDBLT_ALPHASRC                 = $00000020;
  DDBLT_ALPHASRCCONSTOVERRIDE    = $00000040;
  DDBLT_ALPHASRCNEG              = $00000080;
  DDBLT_ALPHASRCSURFACEOVERRIDE  = $00000100;
  DDBLT_ASYNC                    = $00000200;
  DDBLT_COLORFILL                = $00000400;
  DDBLT_DDFX                     = $00000800;
  DDBLT_DDROPS                   = $00001000;
  DDBLT_KEYDEST                  = $00002000;
  DDBLT_KEYDESTOVERRIDE          = $00004000;
  DDBLT_KEYSRC                   = $00008000;
  DDBLT_KEYSRCOVERRIDE           = $00010000;
  DDBLT_ROP                      = $00020000;
  DDBLT_ROTATIONANGLE            = $00040000;
  DDBLT_ZBUFFER                  = $00080000;
  DDBLT_ZBUFFERDESTCONSTOVERRIDE = $00100000;
  DDBLT_ZBUFFERDESTOVERRIDE      = $00200000;
  DDBLT_ZBUFFERSRCCONSTOVERRIDE  = $00400000;
  DDBLT_ZBUFFERSRCOVERRIDE       = $00800000;
  DDBLT_WAIT                     = $01000000;
  DDBLT_DEPTHFILL                = $02000000;

{DI}
  DIDC_ATTACHED           = $00000001;
  DIDC_POLLEDDEVICE       = $00000002;
  DIDC_EMULATED           = $00000004;
  DIDC_POLLEDDATAFORMAT   = $00000008;

  DIDC_FORCEFEEDBACK      = $00000100;
  DIDC_FFATTACK           = $00000200;
  DIDC_FFFADE             = $00000400;
  DIDC_SATURATION         = $00000800;
  DIDC_POSNEGCOEFFICIENTS = $00001000;
  DIDC_POSNEGSATURATION   = $00002000;
  DIDC_DEADBAND           = $00004000;

  DIDFT_ALL        = $00000000;

  DIDFT_RELAXIS    = $00000001;
  DIDFT_ABSAXIS    = $00000002;
  DIDFT_AXIS       = $00000003;

  DIDFT_PSHBUTTON  = $00000004;
  DIDFT_TGLBUTTON  = $00000008;
  DIDFT_BUTTON     = $0000000C;

  DIDFT_POV        = $00000010;

  DIDFT_COLLECTION = $00000040;
  DIDFT_NODATA     = $00000080;

  DIDFT_ANYINSTANCE = $00FFFF00;
  DIDFT_INSTANCEMASK = DIDFT_ANYINSTANCE;

  DIGDD_PEEK = $00000001;

  DISCL_EXCLUSIVE    = $00000001;
  DISCL_NONEXCLUSIVE = $00000002;
  DISCL_FOREGROUND   = $00000004;
  DISCL_BACKGROUND   = $00000008;

  DIDF_ABSAXIS = $00000001;
  DIDF_RELAXIS = $00000002;

  DIPH_DEVICE   = 0;
  DIPH_BYOFFSET = 1;
  DIPH_BYID     = 2;

  DIPROP_BUFFERSIZE   = PGUID(1);
  DIPROP_AXISMODE     = PGUID(2);

{ DirectDraw Error Codes }

  DDERR_ALREADYINITIALIZED                = $88760000 + 5;
  DDERR_CANNOTATTACHSURFACE               = $88760000 + 10;
  DDERR_CANNOTDETACHSURFACE               = $88760000 + 20;
  DDERR_CURRENTLYNOTAVAIL                 = $88760000 + 40;
  DDERR_EXCEPTION                         = $88760000 + 55;
  DDERR_GENERIC                           = DWORD(E_FAIL);
  DDERR_HEIGHTALIGN                       = $88760000 + 90;
  DDERR_INCOMPATIBLEPRIMARY               = $88760000 + 95;
  DDERR_INVALIDCAPS                       = $88760000 + 100;
  DDERR_INVALIDCLIPLIST                   = $88760000 + 110;
  DDERR_INVALIDMODE                       = $88760000 + 120;
  DDERR_INVALIDOBJECT                     = $88760000 + 130;
  DDERR_INVALIDPARAMS                     = DWORD(E_INVALIDARG);
  DDERR_INVALIDPIXELFORMAT                = $88760000 + 145;
  DDERR_INVALIDRECT                       = $88760000 + 150;
  DDERR_LOCKEDSURFACES                    = $88760000 + 160;
  DDERR_NO3D                              = $88760000 + 170;
  DDERR_NOALPHAHW                         = $88760000 + 180;
  DDERR_NOCLIPLIST                        = $88760000 + 205;
  DDERR_NOCOLORCONVHW                     = $88760000 + 210;
  DDERR_NOCOOPERATIVELEVELSET             = $88760000 + 212;
  DDERR_NOCOLORKEY                        = $88760000 + 215;
  DDERR_NOCOLORKEYHW                      = $88760000 + 220;
  DDERR_NODIRECTDRAWSUPPORT               = $88760000 + 222;
  DDERR_NOEXCLUSIVEMODE                   = $88760000 + 225;
  DDERR_NOFLIPHW                          = $88760000 + 230;
  DDERR_NOGDI                             = $88760000 + 240;
  DDERR_NOMIRRORHW                        = $88760000 + 250;
  DDERR_NOTFOUND                          = $88760000 + 255;
  DDERR_NOOVERLAYHW                       = $88760000 + 260;
  DDERR_OVERLAPPINGRECTS                  = $88760000 + 270;
  DDERR_NORASTEROPHW                      = $88760000 + 280;
  DDERR_NOROTATIONHW                      = $88760000 + 290;
  DDERR_NOSTRETCHHW                       = $88760000 + 310;
  DDERR_NOT4BITCOLOR                      = $88760000 + 316;
  DDERR_NOT4BITCOLORINDEX                 = $88760000 + 317;
  DDERR_NOT8BITCOLOR                      = $88760000 + 320;
  DDERR_NOTEXTUREHW                       = $88760000 + 330;
  DDERR_NOVSYNCHW                         = $88760000 + 335;
  DDERR_NOZBUFFERHW                       = $88760000 + 340;
  DDERR_NOZOVERLAYHW                      = $88760000 + 350;
  DDERR_OUTOFCAPS                         = $88760000 + 360;
  DDERR_OUTOFMEMORY                       = DWORD(E_OUTOFMEMORY);
  DDERR_OUTOFVIDEOMEMORY                  = $88760000 + 380;
  DDERR_OVERLAYCANTCLIP                   = $88760000 + 382;
  DDERR_OVERLAYCOLORKEYONLYONEACTIVE      = $88760000 + 384;
  DDERR_PALETTEBUSY                       = $88760000 + 387;
  DDERR_COLORKEYNOTSET                    = $88760000 + 400;
  DDERR_SURFACEALREADYATTACHED            = $88760000 + 410;
  DDERR_SURFACEALREADYDEPENDENT           = $88760000 + 420;
  DDERR_SURFACEBUSY                       = $88760000 + 430;
  DDERR_CANTLOCKSURFACE                   = $88760000 + 435;
  DDERR_SURFACEISOBSCURED                 = $88760000 + 440;
  DDERR_SURFACELOST                       = $88760000 + 450;
  DDERR_SURFACENOTATTACHED                = $88760000 + 460;
  DDERR_TOOBIGHEIGHT                      = $88760000 + 470;
  DDERR_TOOBIGSIZE                        = $88760000 + 480;
  DDERR_TOOBIGWIDTH                       = $88760000 + 490;
  DDERR_UNSUPPORTED                       = DWORD(E_NOTIMPL);
  DDERR_UNSUPPORTEDFORMAT                 = $88760000 + 510;
  DDERR_UNSUPPORTEDMASK                   = $88760000 + 520;
  DDERR_INVALIDSTREAM                     = $88760000 + 521;
  DDERR_VERTICALBLANKINPROGRESS           = $88760000 + 537;
  DDERR_WASSTILLDRAWING                   = $88760000 + 540;
  DDERR_XALIGN                            = $88760000 + 560;
  DDERR_INVALIDDIRECTDRAWGUID             = $88760000 + 561;
  DDERR_DIRECTDRAWALREADYCREATED          = $88760000 + 562;
  DDERR_NODIRECTDRAWHW                    = $88760000 + 563;
  DDERR_PRIMARYSURFACEALREADYEXISTS       = $88760000 + 564;
  DDERR_NOEMULATION                       = $88760000 + 565;
  DDERR_REGIONTOOSMALL                    = $88760000 + 566;
  DDERR_CLIPPERISUSINGHWND                = $88760000 + 567;
  DDERR_NOCLIPPERATTACHED                 = $88760000 + 568;
  DDERR_NOHWND                            = $88760000 + 569;
  DDERR_HWNDSUBCLASSED                    = $88760000 + 570;
  DDERR_HWNDALREADYSET                    = $88760000 + 571;
  DDERR_NOPALETTEATTACHED                 = $88760000 + 572;
  DDERR_NOPALETTEHW                       = $88760000 + 573;
  DDERR_BLTFASTCANTCLIP                   = $88760000 + 574;
  DDERR_NOBLTHW                           = $88760000 + 575;
  DDERR_NODDROPSHW                        = $88760000 + 576;
  DDERR_OVERLAYNOTVISIBLE                 = $88760000 + 577;
  DDERR_NOOVERLAYDEST                     = $88760000 + 578;
  DDERR_INVALIDPOSITION                   = $88760000 + 579;
  DDERR_NOTAOVERLAYSURFACE                = $88760000 + 580;
  DDERR_EXCLUSIVEMODEALREADYSET           = $88760000 + 581;
  DDERR_NOTFLIPPABLE                      = $88760000 + 582;
  DDERR_CANTDUPLICATE                     = $88760000 + 583;
  DDERR_NOTLOCKED                         = $88760000 + 584;
  DDERR_CANTCREATEDC                      = $88760000 + 585;
  DDERR_NODC                              = $88760000 + 586;
  DDERR_WRONGMODE                         = $88760000 + 587;
  DDERR_IMPLICITLYCREATED                 = $88760000 + 588;
  DDERR_NOTPALETTIZED                     = $88760000 + 589;
  DDERR_UNSUPPORTEDMODE                   = $88760000 + 590;
  DDERR_NOMIPMAPHW                        = $88760000 + 591;
  DDERR_INVALIDSURFACETYPE                = $88760000 + 592;
  DDERR_NOOPTIMIZEHW                      = $88760000 + 600;
  DDERR_NOTLOADED                         = $88760000 + 601;
  DDERR_NOFOCUSWINDOW                     = $88760000 + 602;
  DDERR_DCALREADYCREATED                  = $88760000 + 620;
  DDERR_NONONLOCALVIDMEM                  = $88760000 + 630;
  DDERR_CANTPAGELOCK                      = $88760000 + 640;
  DDERR_CANTPAGEUNLOCK                    = $88760000 + 660;
  DDERR_NOTPAGELOCKED                     = $88760000 + 680;
  DDERR_MOREDATA                          = $88760000 + 690;
  DDERR_EXPIRED                           = $88760000 + 691;
  DDERR_VIDEONOTACTIVE                    = $88760000 + 695;
  DDERR_DEVICEDOESNTOWNSURFACE            = $88760000 + 699;
  DDERR_NOTINITIALIZED                    = DWORD(CO_E_NOTINITIALIZED);

  DI_OK = DWORD(S_OK);
  DI_NOTATTACHED = DWORD(S_FALSE);
  DI_BUFFEROVERFLOW = DWORD(S_FALSE);
  DI_PROPNOEFFECT = DWORD(S_FALSE);
  DI_NOEFFECT = DWORD(S_FALSE);
  DI_POLLEDDEVICE = $00000002;
  DI_DOWNLOADSKIPPED = $00000003;
  DI_EFFECTRESTARTED = $00000004;
  DI_TRUNCATED = $00000008;
  DI_TRUNCATEDANDRESTARTED = $0000000C;

  DIERR_OLDDIRECTINPUTVERSION = $8007047E;
  DIERR_BETADIRECTINPUTVERSION = $80070481;
  DIERR_BADDRIVERVER = $80070077;
  DIERR_DEVICENOTREG = DWORD(REGDB_E_CLASSNOTREG);
  DIERR_NOTFOUND = $80070002;
  DIERR_OBJECTNOTFOUND = $80070002;
  DIERR_INVALIDPARAM = DWORD(E_INVALIDARG);
  DIERR_NOINTERFACE = DWORD(E_NOINTERFACE);
  DIERR_GENERIC = DWORD(E_FAIL);
  DIERR_OUTOFMEMORY = DWORD(E_OUTOFMEMORY);
  DIERR_UNSUPPORTED = DWORD(E_NOTIMPL);
  DIERR_NOTINITIALIZED = $80070015;
  DIERR_ALREADYINITIALIZED = $800704DF;
  DIERR_NOAGGREGATION = DWORD(CLASS_E_NOAGGREGATION);
  DIERR_OTHERAPPHASPRIO = DWORD(E_ACCESSDENIED);
  DIERR_INPUTLOST = $8007001E;
  DIERR_ACQUIRED = $800700AA;
  DIERR_NOTACQUIRED = $8007000C;
  DIERR_READONLY = DWORD(E_ACCESSDENIED);
  DIERR_HANDLEEXISTS = DWORD(E_ACCESSDENIED);
  DIERR_PENDING = $80070007;
  DIERR_INSUFFICIENTPRIVS = $80040200;
  DIERR_DEVICEFULL = $80040201;
  DIERR_MOREDATA = $80040202;
  DIERR_NOTDOWNLOADED = $80040203;
  DIERR_HASEFFECTS = $80040204;
  DIERR_NOTEXCLUSIVEACQUIRED = $80040205;
  DIERR_INCOMPLETEEFFECT = $80040206;
  DIERR_NOTBUFFERED = $80040207;
  DIERR_EFFECTPLAYING = $80040208;

{ DirectDraw WaitForVerticalBlank Flags }

  DDWAITVB_BLOCKBEGIN      = $00000001;
  DDWAITVB_BLOCKBEGINEVENT = $00000002;
  DDWAITVB_BLOCKEND        = $00000004;

{ DirectSound }
  DS_OK = 0;
  DSERR_ALLOCATED = $88780000 + 10;
  DSERR_CONTROLUNAVAIL = $88780000 + 30;
  DSERR_INVALIDPARAM = E_INVALIDARG;
  DSERR_INVALIDCALL = $88780000 + 50;
  DSERR_GENERIC = E_FAIL;
  DSERR_PRIOLEVELNEEDED = $88780000 + 70;
  DSERR_OUTOFMEMORY = E_OUTOFMEMORY;
  DSERR_BADFORMAT = $88780000 + 100;
  DSERR_UNSUPPORTED = E_NOTIMPL;
  DSERR_NODRIVER = $88780000 + 120;
  DSERR_ALREADYINITIALIZED = $88780000 + 130;
  DSERR_NOAGGREGATION = CLASS_E_NOAGGREGATION;
  DSERR_BUFFERLOST = $88780000 + 150;
  DSERR_OTHERAPPHASPRIO = $88780000 + 160;
  DSERR_UNINITIALIZED = $88780000 + 170;
  DSERR_NOINTERFACE = E_NOINTERFACE;

  DSCAPS_PRIMARYMONO      = $00000001;
  DSCAPS_PRIMARYSTEREO    = $00000002;
  DSCAPS_PRIMARY8BIT      = $00000004;
  DSCAPS_PRIMARY16BIT     = $00000008;
  DSCAPS_CONTINUOUSRATE   = $00000010;
  DSCAPS_EMULDRIVER       = $00000020;
  DSCAPS_CERTIFIED        = $00000040;
  DSCAPS_SECONDARYMONO    = $00000100;
  DSCAPS_SECONDARYSTEREO  = $00000200;
  DSCAPS_SECONDARY8BIT    = $00000400;
  DSCAPS_SECONDARY16BIT   = $00000800;

  DSBPLAY_LOOPING         = $00000001;

  DSBSTATUS_PLAYING       = $00000001;
  DSBSTATUS_BUFFERLOST    = $00000002;
  DSBSTATUS_LOOPING       = $00000004;

  DSBLOCK_FROMWRITECURSOR = $00000001;
  DSBLOCK_ENTIREBUFFER    = $00000002;

  DSSCL_NORMAL            = $00000001;
  DSSCL_PRIORITY          = $00000002;
  DSSCL_EXCLUSIVE         = $00000003;
  DSSCL_WRITEPRIMARY      = $00000004;

  DS3DMODE_NORMAL         = $00000000;
  DS3DMODE_HEADRELATIVE   = $00000001;
  DS3DMODE_DISABLE        = $00000002;

  DS3D_IMMEDIATE          = $00000000;
  DS3D_DEFERRED           = $00000001;

  DS3D_MINDISTANCEFACTOR     = 0.0;
  DS3D_MAXDISTANCEFACTOR     = 10.0;
  DS3D_DEFAULTDISTANCEFACTOR = 1.0;

  DS3D_MINROLLOFFFACTOR      = 0.0;
  DS3D_MAXROLLOFFFACTOR      = 10.0;
  DS3D_DEFAULTROLLOFFFACTOR  = 1.0;

  DS3D_MINDOPPLERFACTOR      = 0.0;
  DS3D_MAXDOPPLERFACTOR      = 10.0;
  DS3D_DEFAULTDOPPLERFACTOR  = 1.0;

  DS3D_DEFAULTMINDISTANCE    = 1.0;
  DS3D_DEFAULTMAXDISTANCE    = 1000000000.0;

  DS3D_MINCONEANGLE          = 0;
  DS3D_MAXCONEANGLE          = 360;
  DS3D_DEFAULTCONEANGLE      = 360;

  DS3D_DEFAULTCONEOUTSIDEVOLUME = 0;

  DSBCAPS_PRIMARYBUFFER       = $00000001;
  DSBCAPS_STATIC              = $00000002;
  DSBCAPS_LOCHARDWARE         = $00000004;
  DSBCAPS_LOCSOFTWARE         = $00000008;
  DSBCAPS_CTRL3D              = $00000010;
  DSBCAPS_CTRLFREQUENCY       = $00000020;
  DSBCAPS_CTRLPAN             = $00000040;
  DSBCAPS_CTRLVOLUME          = $00000080;
  DSBCAPS_CTRLPOSITIONNOTIFY  = $00000100;
  DSBCAPS_CTRLDEFAULT         = $000000E0;
  DSBCAPS_CTRLALL             = $000001F0;
  DSBCAPS_STICKYFOCUS         = $00004000;
  DSBCAPS_GLOBALFOCUS         = $00008000;
  DSBCAPS_GETCURRENTPOSITION2 = $00010000;
  DSBCAPS_MUTE3DATMAXDISTANCE = $00020000;

  DSCBCAPS_WAVEMAPPED = $80000000;

  DSSPEAKER_HEADPHONE = $00000001;
  DSSPEAKER_MONO      = $00000002;
  DSSPEAKER_QUAD      = $00000003;
  DSSPEAKER_STEREO    = $00000004;
  DSSPEAKER_SURROUND  = $00000005;

  DSCCAPS_EMULDRIVER    = $00000020;

  DSCBLOCK_ENTIREBUFFER = $00000001;

  DSCBSTATUS_CAPTURING  = $00000001;
  DSCBSTATUS_LOOPING    = $00000002;

  DSCBSTART_LOOPING     = $00000001;

  DSBFREQUENCY_MIN      = 100;
  DSBFREQUENCY_MAX      = 100000;
  DSBFREQUENCY_ORIGINAL = 0;

  DSBPAN_LEFT   = -10000;
  DSBPAN_CENTER = 0;
  DSBPAN_RIGHT  = 10000;

  DSBVOLUME_MIN = -10000;
  DSBVOLUME_MAX = 0;

  DSBSIZE_MIN = 4;
  DSBSIZE_MAX = $0FFFFFFF;

  DSBPN_OFFSETSTOP = $FFFFFFFF;

type
  IDirectDraw = interface;
  IDirectDrawPalette = interface;
  IDirectDrawClipper = interface;
  IDirectDraw7 = interface;
  IDirectDrawSurface = interface;
  IDirectDrawSurface7 = interface;

  IDirectInput = interface;
  IDirectInput7 = interface;
  IDirectInputDevice = interface;
  IDirectInputDevice7 = interface;
  IDirectInputEffect = interface;

  IDirectSound = interface;
  IDirectSoundBuffer = interface;
  IDirectSoundNotify = interface;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDCOLORKEY ////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDCOLORKEY=^DDCOLORKEY;
DDCOLORKEY = record
  dwColorSpaceLowValue: DWORD;
  dwColorSpaceHighValue: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDPIXELFORMAT /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDPIXELFORMAT=^DDPIXELFORMAT;
DDPIXELFORMAT = record
  dwSize: DWORD;
  dwFlags: DWORD;
  dwFourCC: DWORD;
  case Integer of
    0: (
      dwRGBBitCount: DWORD;
      dwRBitMask: DWORD;
      dwGBitMask: DWORD;
      dwBBitMask: DWORD;
      dwRGBAlphaBitMask: DWORD;
      );
    1: (
      _union1a: DWORD;
      _union1b: DWORD;
      _union1c: DWORD;
      _union1d: DWORD;
      dwRGBZBitMask: DWORD;
      );
    2: (
      dwYUVBitCount: DWORD;
      dwYBitMask: DWORD;
      dwUBitMask: DWORD;
      dwVBitMask: DWORD;
      dwYUVAlphaBitMask: DWORD;
      );
    3: (
      _union3a: DWORD;
      _union3b: DWORD;
      _union3c: DWORD;
      _union3d: DWORD;
      dwYUVZBitMask: DWORD;
      );
    4: (
      dwZBufferBitDepth: DWORD;
      dwStencilBitDepth: DWORD;
      dwZBitMask: DWORD;
      dwStencilBitMask: DWORD;
      );
    5: (
      dwAlphaBitDepth: DWORD;
      );
    6: (
      dwLuminanceBitCount: DWORD;
      dwLuminanceBitMask: DWORD;
      _union6a: DWORD;
      _union6b: DWORD;
      dwLuminanceAlphaBitMask: DWORD;
     );
    7: (
      dwBumpBitCount: DWORD;
      dwBumpDuBitMask: DWORD;
      dwBumpDvBitMask: DWORD;
      dwBumpLuminanceBitMask: DWORD;
     );
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDSCAPS2 /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDSCAPS=^DDSCAPS;
DDSCAPS = record
    dwCaps: DWORD;         // capabilities of surface wanted
end;
DDSCAPSr = DDSCAPS;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDSCAPS2 /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDSCAPS2=^DDSCAPS2;
DDSCAPS2 = record
  dwCaps: DWORD;
  dwCaps2: DWORD;
  dwCaps3: DWORD;
  dwCaps4: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDSURFACEDESC /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDSURFACEDESC=^DDSURFACEDESC;
DDSURFACEDESC = record
    dwSize: DWORD;                   // size of the TDDSurfaceDesc structure
    dwFlags: DWORD;                  // determines what fields are valid
    dwHeight: DWORD;                 // height of surface to be created
    dwWidth: DWORD;                  // width of input surface
    case Integer of
      0: (
        lPitch: Longint;
        dwBackBufferCount: DWORD;        // number of back buffers requested
        case Integer of
        0: (
          dwMipMapCount: DWORD;          // number of mip-map levels requested
          dwAlphaBitDepth: DWORD;        // depth of alpha buffer requested
          dwReserved: DWORD;             // reserved
          lpSurface: Pointer;            // pointer to the associated surface memory
          ddckCKDestOverlay: DDCOLORKEY;// color key for destination overlay use
          ddckCKDestBlt: DDCOLORKEY;    // color key for destination blt use
          ddckCKSrcOverlay: DDCOLORKEY; // color key for source overlay use
          ddckCKSrcBlt: DDCOLORKEY;     // color key for source blt use
          ddpfPixelFormat: DDPIXELFORMAT;// pixel format description of the surface
          ddsCaps: DDSCAPS;             // direct draw surface capabilities
          );
        1: (
          dwZBufferBitDepth: DWORD;      // depth of Z buffer requested
          );
        2: (
          dwRefreshRate: DWORD;          // refresh rate (used when display mode is described)
          );
      );
      1: (
        dwLinearSize: DWORD
      );
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDSURFACEDESC2 ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDSURFACEDESC2=^DDSURFACEDESC2;
DDSURFACEDESC2 = record
  dwSize: DWORD;                   // size of the TDDSurfaceDesc structure
  dwFlags: DWORD;                  // determines what fields are valid
  dwHeight: DWORD;                 // height of surface to be created
  dwWidth: DWORD;                  // width of input surface
  case Integer of
    0: (
      lPitch: Longint;
      dwBackBufferCount: DWORD;        // number of back buffers requested
      case Integer of
      0: (
        dwMipMapCount: DWORD;          // number of mip-map levels requested
        dwAlphaBitDepth: DWORD;        // depth of alpha buffer requested
        dwReserved: DWORD;             // reserved
        lpSurface: Pointer;            // pointer to the associated surface memory
        ddckCKDestOverlay: DDCOLORKEY;// color key for destination overlay use
        ddckCKDestBlt: DDCOLORKEY;    // color key for destination blt use
        ddckCKSrcOverlay: DDCOLORKEY; // color key for source overlay use
        ddckCKSrcBlt: DDCOLORKEY;     // color key for source blt use
        ddpfPixelFormat: DDPIXELFORMAT;// pixel format description of the surface
        ddsCaps: DDSCAPS2;            // direct draw surface capabilities
        dwTextureStage: DWORD;         // stage in multitexture cascade
      );
      1: (
        //dwZBufferBitDepth: DWORD;    // dwZBufferBitDepth removed, use ddpfPixelFormat one instead
        );
      2: (
        dwRefreshRate: DWORD;          // refresh rate (used when display mode is described)
        );
    );
    1: (
      dwLinearSize: DWORD
    );
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDCAPS ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDCAPS=^DDCAPS;
DDCAPS = record
    dwSize: DWORD;
    dwCaps: DWORD;
    dwCaps2: DWORD;
    dwCKeyCaps: DWORD;
    dwFXCaps: DWORD;
    dwFXAlphaCaps: DWORD;
    dwPalCaps: DWORD;
    dwSVCaps: DWORD;
    dwAlphaBltConstBitDepths: DWORD;
    dwAlphaBltPixelBitDepths: DWORD;
    dwAlphaBltSurfaceBitDepths: DWORD;
    dwAlphaOverlayConstBitDepths: DWORD;
    dwAlphaOverlayPixelBitDepths: DWORD;
    dwAlphaOverlaySurfaceBitDepths: DWORD;
    dwZBufferBitDepths: DWORD;
    dwVidMemTotal: DWORD;
    dwVidMemFree: DWORD;
    dwMaxVisibleOverlays: DWORD;
    dwCurrVisibleOverlays: DWORD;
    dwNumFourCCCodes: DWORD;
    dwAlignBoundarySrc: DWORD;
    dwAlignSizeSrc: DWORD;
    dwAlignBoundaryDest: DWORD;
    dwAlignSizeDest: DWORD;
    dwAlignStrideAlign: DWORD;
    dwRops: array[0..DD_ROP_SPACE-1] of DWORD;
    ddsOldCaps: DDSCAPS2;
    dwMinOverlayStretch: DWORD;
    dwMaxOverlayStretch: DWORD;
    dwMinLiveVideoStretch: DWORD;
    dwMaxLiveVideoStretch: DWORD;
    dwMinHwCodecStretch: DWORD;
    dwMaxHwCodecStretch: DWORD;
    dwReserved1: DWORD;
    dwReserved2: DWORD;
    dwReserved3: DWORD;
    dwSVBCaps: DWORD;
    dwSVBCKeyCaps: DWORD;
    dwSVBFXCaps: DWORD;
    dwSVBRops: array[0..DD_ROP_SPACE-1] of DWORD;
    dwVSBCaps: DWORD;
    dwVSBCKeyCaps: DWORD;
    dwVSBFXCaps: DWORD;
    dwVSBRops: array[0..DD_ROP_SPACE-1] of DWORD;
    dwSSBCaps: DWORD;
    dwSSBCKeyCaps: DWORD;
    dwSSBFXCaps: DWORD;
    dwSSBRops: array[0..DD_ROP_SPACE-1] of DWORD;
    dwMaxVideoPorts: DWORD;
    dwCurrVideoPorts: DWORD;
    dwSVBCaps2: DWORD;
    dwNLVBCaps: DWORD;
    dwNLVBCaps2: DWORD;
    dwNLVBCKeyCaps: DWORD;
    dwNLVBFXCaps: DWORD;
    dwNLVBRops: array[0..DD_ROP_SPACE-1] of DWORD;
    ddsCaps: DDSCAPS2;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDSURFACEDESC /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDDEVICEIDENTIFIER2=^DDDEVICEIDENTIFIER2;
DDDEVICEIDENTIFIER2 = record
    szDriver: array[0..MAX_DDDEVICEID_STRING-1] of Char;
    szDescription: array[0..MAX_DDDEVICEID_STRING-1] of Char;

    liDriverVersion: TLargeInteger;     // Defined for applications and other 32 bit components

    dwVendorId: DWORD;
    dwDeviceId: DWORD;
    dwSubSysId: DWORD;
    dwRevision: DWORD;

    guidDeviceIdentifier: TGUID;

    dwWHQLLevel: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDBLTFX ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDBLTFX=^DDBLTFX;
DDBLTFX = record
    dwSize: DWORD;
    dwDDFX: DWORD;
    dwROP: DWORD;
    dwDDROP: DWORD;
    dwRotationAngle: DWORD;
    dwZBufferOpCode: DWORD;
    dwZBufferLow: DWORD;
    dwZBufferHigh: DWORD;
    dwZBufferBaseDest: DWORD;
    dwZDestConstBitDepth: DWORD;
    case Integer of
    0: (
        dwZDestConst: DWORD;
        dwZSrcConstBitDepth: DWORD;
        dwZSrcConst: DWORD;
        dwAlphaEdgeBlendBitDepth: DWORD;
        dwAlphaEdgeBlend: DWORD;
        dwReserved: DWORD;
        dwAlphaDestConstBitDepth: DWORD;
        dwAlphaDestConst: DWORD;
        dwAlphaSrcConstBitDepth: DWORD;
        dwAlphaSrcConst: DWORD;
        dwFillColor: DWORD;
        ddckDestColorkey: DDCOLORKEY;
        ddckSrcColorkey: DDCOLORKEY;
    );
    1: (
        lpDDSZBufferDest: ^IDirectDrawSurface;
        _union1b: DWORD;
        lpDDSZBufferSrc: ^IDirectDrawSurface;
        _union1d: DWORD;
        _union1e: DWORD;
        _union1f: DWORD;
        _union1g: DWORD;
        lpDDSAlphaDest: ^IDirectDrawSurface;
        _union1i: DWORD;
        lpDDSAlphaSrc: ^IDirectDrawSurface;
        dwFillDepth: DWORD;
    );
    2: (
        _union2a: DWORD;
        _union2b: DWORD;
        _union2c: DWORD;
        _union2d: DWORD;
        _union2e: DWORD;
        _union2f: DWORD;
        _union2g: DWORD;
        _union2h: DWORD;
        _union2i: DWORD;
        _union2j: DWORD;
        lpDDSPattern: ^IDirectDrawSurface;
    );
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDBLTFX ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDBLTBATCH=^DDBLTBATCH;
DDBLTBATCH = record
    lprDest: PRect;
    lpDDSSrc: IDirectDrawSurface;
    lprSrc: PRect;
    dwFlags: DWORD;
    lpDDBltFx: LPDDBLTFX;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DDOVERLAYFX ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDOVERLAYFX=^DDOVERLAYFX;
DDOVERLAYFX = record
    dwSize: DWORD;
    dwAlphaEdgeBlendBitDepth: DWORD;
    dwAlphaEdgeBlend: DWORD;
    dwReserved: DWORD;
    dwAlphaDestConstBitDepth: DWORD;
    case Integer of
    0: (
        dwAlphaDestConst: DWORD;
        dwAlphaSrcConstBitDepth: DWORD;
        dwAlphaSrcConst: DWORD;
        dckDestColorkey: DDCOLORKEY;
        dckSrcColorkey: DDCOLORKEY;
        dwDDFX: DWORD;
        dwFlags: DWORD;
    );
    1: (
        lpDDSAlphaDest: ^IDirectDrawSurface;
        _union1b: DWORD;
        lpDDSAlphaSrc: ^IDirectDrawSurface;
    );
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIDEVICEINSTANCE //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
PDIDEVICEINSTANCE = ^DIDEVICEINSTANCE;
DIDEVICEINSTANCE = record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: array[0..MAX_PATH-1] of CHAR;
    tszProductName: array[0..MAX_PATH-1] of CHAR;
    guidFFDriver: TGUID;
    wUsagePage: WORD;
    wUsage: WORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIDEVCAPS /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIDEVCAPS = ^DIDEVCAPS;
DIDEVCAPS = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwDevType: DWORD;
    dwAxes: DWORD;
    dwButtons: DWORD;
    dwPOVs: DWORD;
    dwFFSamplePeriod: DWORD;
    dwFFMinTimeResolution: DWORD;
    dwFirmwareRevision: DWORD;
    dwHardwareRevision: DWORD;
    dwFFDriverVersion: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIDEVICEOBJECTINSTANCE ////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIDEVICEOBJECTINSTANCE = ^DIDEVICEOBJECTINSTANCE;
DIDEVICEOBJECTINSTANCE = record
    dwSize: DWORD;
    guidType: TGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
    tszName: array[0..MAX_PATH-1] of CHAR;
    dwFFMaxForce: DWORD;
    dwFFForceResolution: DWORD;
    wCollectionNumber: WORD;
    wDesignatorIndex: WORD;
    wUsagePage: WORD;
    wUsage: WORD;
    dwDimension: DWORD;
    wExponent: WORD;
    wReportId: WORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIPROPHEADER //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIPROPHEADER = ^DIPROPHEADER;
DIPROPHEADER = record
    dwSize: DWORD;
    dwHeaderSize: DWORD;
    dwObj: DWORD;
    dwHow: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIPROPDWORD ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIPROPDWORD = ^DIPROPDWORD;
DIPROPDWORD = record
    diph: DIPROPHEADER;
    dwData: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIDEVICEOBJECTDATA ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIDEVICEOBJECTDATA = ^DIDEVICEOBJECTDATA;
DIDEVICEOBJECTDATA = record
    dwOfs: DWORD;
    dwData: DWORD;
    dwTimeStamp: DWORD;
    dwSequence: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIOBJECTDATAFORMAT ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIOBJECTDATAFORMAT = ^DIOBJECTDATAFORMAT;
DIOBJECTDATAFORMAT = record
    pguid: PGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIDATAFORMAT //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIDATAFORMAT = ^DIDATAFORMAT;
DIDATAFORMAT = record
    dwSize: DWORD;
    dwObjSize: DWORD;
    dwFlags: DWORD;
    dwDataSize: DWORD;
    dwNumObjs: DWORD;
    rgodf: LPDIOBJECTDATAFORMAT;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIDATAFORMAT //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIENVELOPE = ^DIENVELOPE;
DIENVELOPE = record
    dwSize: DWORD;                   // sizeof(DIENVELOPE)
    dwAttackLevel: DWORD;
    dwAttackTime: DWORD;             // Microseconds
    dwFadeLevel: DWORD;
    dwFadeTime: DWORD;               // Microseconds
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIDATAFORMAT //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIEFFECT = ^DIEFFECT;
DIEFFECT = record
    dwSize: DWORD;                   // sizeof(DIEFFECT)
    dwFlags: DWORD;                  // DIEFF_*
    dwDuration: DWORD;               // Microseconds
    dwSamplePeriod: DWORD;           // Microseconds
    dwGain: DWORD;
    dwTriggerButton: DWORD;          // or DIEB_NOTRIGGER
    dwTriggerRepeatInterval: DWORD;  // Microseconds
    cAxes: DWORD;                    // Number of axes
    rgdwAxes: PDWORD;                // arrayof axes
    rglDirection: PLongint;          // arrayof directions
    lpEnvelope: LPDIENVELOPE;        // Optional
    cbTypeSpecificParams: DWORD;     // Size of params
    lpvTypeSpecificParams: Pointer;  // Pointer to params
    dwStartDelay:DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIEFFECTINFO //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIEFFECTINFO = ^DIEFFECTINFO;
DIEFFECTINFO = record
    dwSize: DWORD;
    guid: TGUID;
    dwEffType: DWORD;
    dwStaticParams: DWORD;
    dwDynamicParams: DWORD;
    tszName: array[0..MAX_PATH-1] of CHAR;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIEFFECTINFO //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDIEFFESCAPE = ^DIEFFESCAPE;
DIEFFESCAPE = record
    dwSize: DWORD;
    dwCommand: DWORD;
    lpvInBuffer: Pointer;
    cbInBuffer: DWORD;
    lpvOutBuffer: Pointer;
    cbOutBuffer: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DIEFFECTINFO //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPCDIFILEEFFECT = ^CDIFILEEFFECT;
CDIFILEEFFECT = record
    dwSize:DWORD;
    GuidEffect:TGUID;
    lpDiEffect:LPDIEFFECT;
    szFriendlyName: array[0..MAX_PATH-1] of CHAR;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DSCAPS ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDSCAPS = ^DSCAPS;
DSCAPS = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwMinSecondarySampleRate: DWORD;
    dwMaxSecondarySampleRate: DWORD;
    dwPrimaryBuffers: DWORD;
    dwMaxHwMixingAllBuffers: DWORD;
    dwMaxHwMixingStaticBuffers: DWORD;
    dwMaxHwMixingStreamingBuffers: DWORD;
    dwFreeHwMixingAllBuffers: DWORD;
    dwFreeHwMixingStaticBuffers: DWORD;
    dwFreeHwMixingStreamingBuffers: DWORD;
    dwMaxHw3DAllBuffers: DWORD;
    dwMaxHw3DStaticBuffers: DWORD;
    dwMaxHw3DStreamingBuffers: DWORD;
    dwFreeHw3DAllBuffers: DWORD;
    dwFreeHw3DStaticBuffers: DWORD;
    dwFreeHw3DStreamingBuffers: DWORD;
    dwTotalHwMemBytes: DWORD;
    dwFreeHwMemBytes: DWORD;
    dwMaxContigFreeHwMemBytes: DWORD;
    dwUnlockTransferRateHwBuffers: DWORD;
    dwPlayCpuOverheadSwBuffers: DWORD;
    dwReserved1: DWORD;
    dwReserved2: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DSBCAPS ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDSBCAPS = ^DSBCAPS;
DSBCAPS = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwUnlockTransferRate: DWORD;
    dwPlayCpuOverhead: DWORD;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DSBUFFERDESC //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
PDSBUFFERDESC = ^DSBUFFERDESC;
DSBUFFERDESC = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwReserved: DWORD;
    lpwfxFormat: PWAVEFORMATEX;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// DSBUFFERDESC //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDSBPOSITIONNOTIFY = ^DSBPOSITIONNOTIFY;
DSBPOSITIONNOTIFY = record
    dwOffset: DWORD;
    hEventNotify: THandle;
end;

//############################################################################################################################################################
//############################################################################################################################################################
//############################################################################################################################################################


////////////////////////////////////////////////////////////////////////////////
//////////////////////////// CallBack //////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
LPDDENUMMODESCALLBACK = function(const lpDDSurfaceDesc: DDSURFACEDESC; lpContext: Pointer): HResult; stdcall;
LPDDENUMMODESCALLBACK2 = function(const lpDDSurfaceDesc: DDSURFACEDESC2; lpContext: Pointer): HResult; stdcall;
LPDDENUMSURFACESCALLBACK = function(lpDDSurface: IDirectDrawSurface; const lpDDSurfaceDesc: DDSURFACEDESC; lpContext: Pointer): HResult; stdcall;
LPDDENUMSURFACESCALLBACK2 = function(lpDDSurface: IDirectDrawSurface7; const lpDDSurfaceDesc: DDSURFACEDESC2; lpContext: Pointer): HResult; stdcall;
LPDDENUMSURFACESCALLBACK7 = function(lpDDSurface: IDirectDrawSurface7; const lpDDSurfaceDesc: DDSURFACEDESC2; lpContext: Pointer): HResult; stdcall;
LPDIENUMDEVICESCALLBACK = function(const lpddi: DIDEVICEINSTANCE; pvRef: Pointer): HResult; stdcall;
LPDIENUMDEVICEOBJECTSCALLBACK = function(const peff: DIDEVICEOBJECTINSTANCE; pvRef: Pointer): HResult; stdcall;
LPDIENUMEFFECTSCALLBACK = function(const pdei: DIEFFECTINFO; pvRef: Pointer): HResult; stdcall;
LPDIENUMCREATEDEFFECTOBJECTSCALLBACK = function(const peff: IDirectInputEffect; pvRef: Pointer): HResult; stdcall;
LPENUMEFFECTSINFILECALLBACK = function(lpDiFileEf:CDIFILEEFFECT; pvRef: Pointer): DWORD; stdcall;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectDraw ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectDraw = interface(IUnknown)
    ['{6C14DB80-A733-11CE-A521-0020AF0BE560}']
    function Compact: HResult; stdcall;
    function CreateClipper(dwFlags: DWORD; out lplpDDClipper: IDirectDrawClipper; pUnkOuter: IUnknown): HResult; stdcall;
    function CreatePalette(dwFlags: DWORD; lpColorTable: PPaletteEntry; out lplpDDPalette: IDirectDrawPalette; pUnkOuter: IUnknown): HResult; stdcall;
    function CreateSurface(const lpDDSurfaceDesc: DDSURFACEDESC; out lplpDDSurface: IDirectDrawSurface; pUnkOuter: IUnknown): HResult; stdcall;
    function DuplicateSurface(lpDDSurface: IDirectDrawSurface; out lplpDupDDSurface: IDirectDrawSurface): HResult; stdcall;
    function EnumDisplayModes(dwFlags: DWORD; const lpDDSurfaceDesc: DDSURFACEDESC; lpContext: Pointer; lpEnumModesCallback: LPDDENUMMODESCALLBACK): HResult; stdcall;
    function EnumSurfaces(dwFlags: DWORD; const lpDDSD: DDSURFACEDESC; lpContext: Pointer; lpEnumCallback: LPDDENUMSURFACESCALLBACK): HResult; stdcall;
    function FlipToGDISurface: HResult; stdcall;
    function GetCaps(var lpDDDriverCaps: DDCAPS; var lpDDHELCaps: DDCAPS): HResult; stdcall;
    function GetDisplayMode(var lpDDSurfaceDesc: DDSURFACEDESC): HResult; stdcall;
    function GetFourCCCodes(var lpNumCodes, lpCodes: DWORD): HResult; stdcall;
    function GetGDISurface(out lplpGDIDDSSurface: IDirectDrawSurface): HResult; stdcall;
    function GetMonitorFrequency(var lpdwFrequency: DWORD): HResult; stdcall;
    function GetScanLine(var lpdwScanLine: DWORD): HResult; stdcall;
    function GetVerticalBlankStatus(var lpbIsInVB: BOOL): HResult; stdcall;
    function Initialize(lpGUID: PGUID): HResult; stdcall;
    function RestoreDisplayMode: HResult; stdcall;
    function SetCooperativeLevel(hWnd: HWND; dwFlags: DWORD): HResult; stdcall;
    function SetDisplayMode(dwWidth, dwHeight, dwBpp: DWORD): HResult; stdcall;
    function WaitForVerticalBlank(dwFlags: DWORD; hEvent: THandle): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectDrawPalette ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectDrawPalette = interface(IUnknown)
    ['{6C14DB84-A733-11CE-A521-0020AF0BE560}']
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectDrawClipper ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectDrawClipper = interface(IUnknown)
    ['{6C14DB85-A733-11CE-A521-0020AF0BE560}']
    function GetClipList(const lpRect: TRect; lpClipList: PRgnData; var lpdwSize: DWORD): HResult; stdcall;
    function GetHWnd(var lphWnd: HWND): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw; dwFlags: DWORD): HResult; stdcall;
    function IsClipListChanged(var lpbChanged: BOOL): HResult; stdcall;
    function SetClipList(lpClipList: PRgnData; dwFlags: DWORD): HResult; stdcall;
    function SetHWnd(dwFlags: DWORD; hWnd: HWND): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectDraw7 //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectDraw7 = interface(IUnknown)
    ['{15e65ec0-3b9c-11d2-b92f-00609797ea5b}']
    function Compact: HResult; stdcall;
    function CreateClipper(dwFlags: DWORD; out lplpDDClipper: IDirectDrawClipper; pUnkOuter: IUnknown): HResult; stdcall;
    function CreatePalette(dwFlags: DWORD; lpColorTable: PPaletteEntry; out lplpDDPalette: IDirectDrawPalette; pUnkOuter: IUnknown): HResult; stdcall;
    function CreateSurface(const lpDDSurfaceDesc2: DDSURFACEDESC2; out lplpDDSurface: IDirectDrawSurface7; pUnkOuter: IUnknown): HResult; stdcall;
    function DuplicateSurface(lpDDSurface: IDirectDrawSurface7; out lplpDupDDSurface: IDirectDrawSurface7): HResult; stdcall;
    function EnumDisplayModes(dwFlags: DWORD; const lpDDSurfaceDesc2: LPDDSURFACEDESC2; lpContext: Pointer; lpEnumModesCallback: LPDDENUMMODESCALLBACK2): HResult; stdcall;
    function EnumSurfaces(dwFlags: DWORD; const lpDDSD: LPDDSURFACEDESC2; lpContext: Pointer; lpEnumCallback: LPDDENUMSURFACESCALLBACK7): HResult; stdcall;
    function FlipToGDISurface: HResult; stdcall;
    function GetCaps(var lpDDDriverCaps: DDCAPS; var lpDDHELCaps: DDCAPS): HResult; stdcall;
    function GetDisplayMode(var lpDDSurfaceDesc: DDSURFACEDESC2): HResult; stdcall;
    function GetFourCCCodes(var lpNumCodes, lpCodes: DWORD): HResult; stdcall;
    function GetGDISurface(out lplpGDIDDSSurface: IDirectDrawSurface7): HResult; stdcall;
    function GetMonitorFrequency(var lpdwFrequency: DWORD): HResult; stdcall;
    function GetScanLine(var lpdwScanLine: DWORD): HResult; stdcall;
    function GetVerticalBlankStatus(var lpbIsInVB: BOOL): HResult; stdcall;
    function Initialize(lpGUID: PGUID): HResult; stdcall;
    function RestoreDisplayMode: HResult; stdcall;
    function SetCooperativeLevel(hWnd: HWND; dwFlags: DWORD): HResult; stdcall;
    function SetDisplayMode(dwWidth, dwHeight, dwBpp, dwRefreshRate, dwFlags: DWORD): HResult; stdcall;
    function WaitForVerticalBlank(dwFlags: DWORD; hEvent: THandle): HResult; stdcall;

    function GetAvailableVidMem(lpDDSCaps2: DDSCAPS2; var lpdwTotal: DWORD; var lpdwFree: DWORD): HResult; stdcall;

    function GetSurfaceFromDC(hdc: HDC; out lpDDS: IDirectDrawSurface7): HResult; stdcall;
    function RestoreAllSurfaces: HResult; stdcall;
    function TestCooperativeLevel: HResult; stdcall;
    function GetDeviceIdentifier(var lpdddi: DDDEVICEIDENTIFIER2; dwFlags: DWORD): HResult; stdcall;
    function StartModeTest(lpModesToTest: PSize; dwNumEntries: DWORD; dwFlags: DWORD): HResult; stdcall;
    function EvaluateMode(dwFlags: DWORD; out pSecondsUntilTimeout: DWORD): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectDrawSurface ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectDrawSurface = interface(IUnknown)
    ['{6C14DB81-A733-11CE-A521-0020AF0BE560}']
    function AddAttachedSurface(lpDDSAttachedSurface: IDirectDrawSurface): HResult; stdcall;
    function AddOverlayDirtyRect(const lpRect: TRect): HResult; stdcall;
    function Blt(const lpDestRect: TRect; lpDDSrcSurface: IDirectDrawSurface; const lpSrcRect: TRect; dwFlags: DWORD; const lpDDBltFx: DDBLTFX): HResult; stdcall;
    function BltBatch(const lpDDBltBatch: DDBLTBATCH; dwCount: DWORD; dwFlags: DWORD): HResult; stdcall;
    function BltFast(dwX, dwY: DWORD; lpDDSrcSurface: IDirectDrawSurface; const lpSrcRect: TRect; dwTrans: DWORD): HResult; stdcall;
    function DeleteAttachedSurface(dwFlags: DWORD; lpDDSAttachedSurface: IDirectDrawSurface): HResult; stdcall;
    function EnumAttachedSurfaces(lpContext: Pointer; lpEnumSurfacesCallback: LPDDENUMSURFACESCALLBACK): HResult; stdcall;
    function EnumOverlayZOrders(dwFlags: DWORD; lpContext: Pointer; lpfnCallback: LPDDENUMSURFACESCALLBACK): HResult; stdcall;
    function Flip(lpDDSurfaceTargetOverride: IDirectDrawSurface; dwFlags: DWORD): HResult; stdcall;
    function GetAttachedSurface(var lpDDSCaps: DDSCAPS; out lplpDDAttachedSurface: IDirectDrawSurface): HResult; stdcall;
    function GetBltStatus(dwFlags: DWORD): HResult; stdcall;
    function GetCaps(var lpDDSCaps: DDSCAPS): HResult; stdcall;
    function GetClipper(out lplpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function GetColorKey(dwFlags: DWORD; var lpDDColorKey: DDCOLORKEY): HResult; stdcall;
    function GetDC(var lphDC: HDC): HResult; stdcall;
    function GetFlipStatus(dwFlags: DWORD): HResult; stdcall;
    function GetOverlayPosition(var lplX, lplY: Longint): HResult; stdcall;
    function GetPalette(out lplpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function GetPixelFormat(var lpDDPixelFormat: DDPIXELFORMAT): HResult; stdcall;
    function GetSurfaceDesc(var lpDDSurfaceDesc: DDSURFACEDESC): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw; const lpDDSurfaceDesc: DDSURFACEDESC): HResult; stdcall;
    function IsLost: HResult; stdcall; function Lock(lpDestRect: PRect; var lpDDSurfaceDesc: DDSURFACEDESC; dwFlags: DWORD; hEvent: THandle): HResult; stdcall;
    function ReleaseDC(hDC: HDC): HResult; stdcall;
    function Restore: HResult; stdcall;
    function SetClipper(lpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function SetColorKey(dwFlags: DWORD; const lpDDColorKey: DDCOLORKEY): HResult; stdcall;
    function SetOverlayPosition(lX, lY: Longint): HResult; stdcall;
    function SetPalette(lpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function Unlock(lpSurfaceData: Pointer): HResult; stdcall;
    function UpdateOverlay(const lpSrcRect: TRect; lpDDDestSurface: IDirectDrawSurface; const lpDestRect: TRect; dwFlags: DWORD; const lpDDOverlayFx: DDOVERLAYFX ): HResult; stdcall;
    function UpdateOverlayDisplay(dwFlags: DWORD): HResult; stdcall;
    function UpdateOverlayZOrder(dwFlags: DWORD; lpDDSReference: IDirectDrawSurface): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectDrawSurface7 ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectDrawSurface7 = interface(IUnknown)
    ['{06675a80-3b9b-11d2-b92f-00609797ea5b}']
    function AddAttachedSurface(lpDDSAttachedSurface: IDirectDrawSurface7): HResult; stdcall;
    function AddOverlayDirtyRect(const lpRect: TRect): HResult; stdcall;
    function Blt(const lpDestRect: TRect; lpDDSrcSurface: IDirectDrawSurface7; const lpSrcRect: TRect; dwFlags: DWORD; const lpDDBltFx: DDBLTFX): HResult; stdcall;
    function BltBatch(const lpDDBltBatch: DDBLTBATCH; dwCount: DWORD; dwFlags: DWORD): HResult; stdcall;
    function BltFast(dwX, dwY: DWORD; lpDDSrcSurface: IDirectDrawSurface7; const lpSrcRect: TRect; dwTrans: DWORD): HResult; stdcall;
    function DeleteAttachedSurface(dwFlags: DWORD; lpDDSAttachedSurface: IDirectDrawSurface7): HResult; stdcall;
    function EnumAttachedSurfaces(lpContext: Pointer; lpEnumSurfacesCallback: LPDDENUMSURFACESCALLBACK2): HResult; stdcall;
    function EnumOverlayZOrders(dwFlags: DWORD; lpContext: Pointer; lpfnCallback: LPDDENUMSURFACESCALLBACK2): HResult; stdcall;
    function Flip(lpDDSurfaceTargetOverride: IDirectDrawSurface7; dwFlags: DWORD): HResult; stdcall;
    function GetAttachedSurface(var lpDDSCaps: DDSCAPS2; out lplpDDAttachedSurface: IDirectDrawSurface7): HResult; stdcall;
    function GetBltStatus(dwFlags: DWORD): HResult; stdcall;
    function GetCaps(var lpDDSCaps: DDSCAPS2): HResult; stdcall;
    function GetClipper(out lplpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function GetColorKey(dwFlags: DWORD; var lpDDColorKey: DDCOLORKEY): HResult; stdcall;
    function GetDC(var lphDC: HDC): HResult; stdcall;
    function GetFlipStatus(dwFlags: DWORD): HResult; stdcall;
    function GetOverlayPosition(var lplX, lplY: Longint): HResult; stdcall;
    function GetPalette(out lplpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function GetPixelFormat(var lpDDPixelFormat: DDPIXELFORMAT): HResult; stdcall;
    function GetSurfaceDesc(var lpDDSurfaceDesc: DDSURFACEDESC2): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw; const lpDDSurfaceDesc: DDSURFACEDESC2): HResult; stdcall;
    function IsLost: HResult; stdcall;
    function Lock(lpDestRect: PRect; const lpDDSurfaceDesc: DDSURFACEDESC2; dwFlags: DWORD; hEvent: THandle): HResult; stdcall;
    function ReleaseDC(hDC: HDC): HResult; stdcall;
    function Restore: HResult; stdcall;
    function SetClipper(lpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function SetColorKey(dwFlags: DWORD; const lpDDColorKey: DDCOLORKEY): HResult; stdcall;
    function SetOverlayPosition(lX, lY: Longint): HResult; stdcall;
    function SetPalette(lpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function Unlock(lpRect: PRect): HResult; stdcall;
    function UpdateOverlay(const lpSrcRect: TRect; lpDDDestSurface: IDirectDrawSurface7; const lpDestRect: TRect; dwFlags: DWORD; const lpDDOverlayFx: DDOVERLAYFX): HResult; stdcall;
    function UpdateOverlayDisplay(dwFlags: DWORD): HResult; stdcall;
    function UpdateOverlayZOrder(dwFlags: DWORD; lpDDSReference: IDirectDrawSurface7): HResult; stdcall;

    function GetDDInterface(out lplpDD: IUnknown): HResult; stdcall;
    function PageLock(dwFlags: DWORD): HResult; stdcall;
    function PageUnlock(dwFlags: DWORD): HResult; stdcall;

    function SetSurfaceDesc(const lpddsd: DDSURFACEDESC2; dwFlags: DWORD): HResult; stdcall;

    function SetPrivateData(const guidTag: TGUID; lpData: Pointer; cbSize: DWORD; dwFlags: DWORD): HResult; stdcall;
    function GetPrivateData(const guidTag: TGUID; lpData: Pointer; var cbSize: DWORD): HResult; stdcall;
    function FreePrivateData(const guidTag: TGUID): HResult; stdcall;
    function GetUniquenessValue(var lpValue: DWORD): HResult; stdcall;
    function ChangeUniquenessValue: HResult; stdcall;

    function SetPriority(dwPriority: DWORD): HResult; stdcall;
    function GetPriority(var dwPriority: DWORD): HResult; stdcall;
    function SetLOD(dwMaxLOD: DWORD): HResult; stdcall;
    function GetLOD(var dwMaxLOD: DWORD): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectInput //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectInput = interface(IUnknown)
    ['{89521360-AA8A-11CF-BFC7-444553540000}']
    function CreateDevice(const rguid: TGUID; out lplpDirectInputDevice: IDirectInputDevice; pUnkOuter: IUnknown): HResult; stdcall;
    function EnumDevices(dwDevType: DWORD; lpCallback: LPDIENUMDEVICESCALLBACK; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetDeviceStatus(const rguidInstance: TGUID): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectInput7 /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectInput7 = interface(IUnknown)
    ['{9A4CB684-236D-11D3-8E9D-00C04f6844ae}']
    function CreateDevice(const rguid: TGUID; out lplpDirectInputDevice: IDirectInputDevice; pUnkOuter: IUnknown): HResult; stdcall;
    function EnumDevices(dwDevType: DWORD; lpCallback: LPDIENUMDEVICESCALLBACK; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetDeviceStatus(const rguidInstance: TGUID): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD): HResult; stdcall;
    function FindDevice(Arg1: PGUID; Arg2: PAnsiChar; Arg3: PGUID): HResult; stdcall;

    function CreateDeviceEx(Arg1: PGUID; Arg2: PGUID; out lplpDD: IDirectInputDevice7; pUnkOuter:IUnknown): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectInputDevice ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectInputDevice = interface(IUnknown)
    ['{5944E680-C92E-11CF-BFC7-444553540000}']
    function GetCapabilities(var lpDIDevCaps: DIDEVCAPS): HResult; stdcall;
    function EnumObjects(lpCallback: LPDIENUMDEVICEOBJECTSCALLBACK; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetProperty(rguidProp: PGUID; var pdiph: DIPROPHEADER): HResult; stdcall;
    function SetProperty(rguidProp: PGUID; const pdiph: DIPROPHEADER): HResult; stdcall;
    function Acquire: HResult; stdcall;
    function Unacquire: HResult; stdcall;
    function GetDeviceState(cbData: DWORD; var lpvData): HResult; stdcall;
    function GetDeviceData(cbObjectData: DWORD; var rgdod: DIDEVICEOBJECTDATA; var pdwInOut: DWORD; dwFlags: DWORD): HResult; stdcall;
    function SetDataFormat(const lpdf: DIDATAFORMAT): HResult; stdcall;
    function SetEventNotification(hEvent: THandle): HResult; stdcall;
    function SetCooperativeLevel(hwnd: HWND; dwFlags: DWORD): HResult; stdcall;
    function GetObjectInfo(var pdidoi: DIDEVICEOBJECTINSTANCE; dwObj: DWORD; dwHow: DWORD): HResult; stdcall;
    function GetDeviceInfo(var pdidi: DIDEVICEINSTANCE): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD; const rguid: TGUID): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectInputDevice7 ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectInputDevice7 = interface(IUnknown)
    ['{57D7C6BC-2356-11D3-8E9D-00C04f6844ae}']
    function GetCapabilities(var lpDIDevCaps: DIDEVCAPS): HResult; stdcall;
    function EnumObjects(lpCallback: LPDIENUMDEVICEOBJECTSCALLBACK; pvRef: Pointer; dwFlags: DWORD): HResult; stdcall;
    function GetProperty(rguidProp: PGUID; var pdiph: DIPROPHEADER): HResult; stdcall;
    function SetProperty(rguidProp: PGUID; const pdiph: DIPROPHEADER): HResult; stdcall;
    function Acquire: HResult; stdcall;
    function Unacquire: HResult; stdcall;
    function GetDeviceState(cbData: DWORD; var lpvData): HResult; stdcall;
    function GetDeviceData(cbObjectData: DWORD; var rgdod: DIDEVICEOBJECTDATA; var pdwInOut: DWORD; dwFlags: DWORD): HResult; stdcall;
    function SetDataFormat(const lpdf: DIDATAFORMAT): HResult; stdcall;
    function SetEventNotification(hEvent: THandle): HResult; stdcall;
    function SetCooperativeLevel(hwnd: HWND; dwFlags: DWORD): HResult; stdcall;
    function GetObjectInfo(var pdidoi: DIDEVICEOBJECTINSTANCE; dwObj: DWORD; dwHow: DWORD): HResult; stdcall;
    function GetDeviceInfo(var pdidi: DIDEVICEINSTANCE): HResult; stdcall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD): HResult; stdcall;
    function Initialize(hinst: THandle; dwVersion: DWORD; const rguid: TGUID): HResult; stdcall;

    function CreateEffect(const rguid: TGUID; const lpeff: DIEFFECT; out ppdeff: IDirectInputEffect; punkOuter: IUnknown): HResult; stdcall;
    function EnumEffects(lpCallback: LPDIENUMEFFECTSCALLBACK; pvRef: Pointer; dwEffType: DWORD): HResult; stdcall;
    function GetEffectInfo(var pdei: DIEFFECTINFO; const rguid: TGUID): HResult; stdcall;
    function GetForceFeedbackState(var pdwOut: DWORD): HResult; stdcall;
    function SendForceFeedbackCommand(dwFlags: DWORD): HResult; stdcall;
    function EnumCreatedEffectObjects(lpCallback:LPDIENUMCREATEDEFFECTOBJECTSCALLBACK; pvRef: Pointer; fl: DWORD): HResult; stdcall;
    function Escape(const pesc: DIEFFESCAPE): HResult; stdcall;
    function Poll: HResult; stdcall;
    function SendDeviceData(cbObjectData: DWORD; const rgdod: DIDEVICEOBJECTDATA; var pdwInOut: DWORD; fl: DWORD): HResult; stdcall;

    function EnumEffectsInFile(lpszFileName:PChar; pec:LPENUMEFFECTSINFILECALLBACK; pvRef:PDWORD; dwFlags:DWORD): HResult; stdcall;
    function WriteEffectToFile(lpszFileName:PChar; dwEntries:DWORD; rgDiFileEft:LPCDIFILEEFFECT; dwFlags:DWORD): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectInputEffect ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectInputEffect = interface(IUnknown)
    ['{E7E1F7C0-88D2-11D0-9AD0-00A0C9A06E35}']
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectSound //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectSound = interface(IUnknown)
    ['{279AFA83-4981-11CE-A521-0020AF0BE560}']

    function CreateSoundBuffer(const lpDSBufferDesc: PDSBUFFERDESC; out lplpDirectSoundBuffer: IDirectSoundBuffer; pUnkOuter: IUnknown): HResult; stdcall;
    function GetCaps(var lpDSCaps: DSCAPS): HResult; stdcall;
    function DuplicateSoundBuffer(lpDsbOriginal: IDirectSoundBuffer; out lpDsbDuplicate: IDirectSoundBuffer): HResult; stdcall;
    function SetCooperativeLevel(hwnd: HWND; dwLevel: DWORD): HResult; stdcall;
    function Compact: HResult; stdcall;
    function GetSpeakerConfig(var lpdwSpeakerConfig: DWORD): HResult; stdcall;
    function SetSpeakerConfig(dwSpeakerConfig: DWORD): HResult; stdcall;
    function Initialize(lpGuid: PGUID): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectSoundBuffer ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectSoundBuffer = interface(IUnknown)
    ['{279AFA85-4981-11CE-A521-0020AF0BE560}']

    function GetCaps(var lpDSBufferCaps: DSBCAPS): HResult; stdcall;
    function GetCurrentPosition(lpdwCurrentPlayCursor,lpdwCurrentWriteCursor: PDWORD): HResult; stdcall;
    function GetFormat(lpwfxFormat: PWAVEFORMATEX; dwSizeAllocated: DWORD; lpdwSizeWritten: PDWORD): HResult; stdcall;
    function GetVolume(var lplVolume: Longint): HResult; stdcall;
    function GetPan(var lplPan: Longint): HResult; stdcall;
    function GetFrequency(var lpdwFrequency: DWORD): HResult; stdcall;
    function GetStatus(var lpdwStatus: DWORD): HResult; stdcall;
    function Initialize(lpDirectSound: IDirectSound; const lpDSBufferDesc: DSBUFFERDESC): HResult; stdcall;
    function Lock(dwWriteCursor: DWORD; dwWriteBytes: DWORD; var lplpvAudioPtr1: Pointer; var lpdwAudioBytes1: DWORD; var lplpvAudioPtr2: Pointer; var lpdwAudioBytes2: DWORD; dwFlags: DWORD): HResult; stdcall;
    function Play(dwReserved1, dwReserved2: DWORD; dwFlags: DWORD): HResult; stdcall;
    function SetCurrentPosition(dwNewPosition: DWORD): HResult; stdcall;
    function SetFormat(lpfxFormat: PWAVEFORMATEX): HResult; stdcall;
    function SetVolume(lVolume: Longint): HResult; stdcall;
    function SetPan(lPan: Longint): HResult; stdcall;
    function SetFrequency(dwFrequency: DWORD): HResult; stdcall;
    function Stop: HResult; stdcall;
    function Unlock(lpvAudioPtr1: Pointer; dwAudioBytes1: DWORD; lpvAudioPtr2: Pointer; dwAudioBytes2: DWORD): HResult; stdcall;
    function Restore: HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// IDirectSoundNotify ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
IDirectSoundNotify = interface(IUnknown)
    ['{B0210783-89CD-11D0-AF08-00A0C925CD16}']

    function SetNotificationPositions(cPositionNotifies: DWORD; lpcPositionNotifies:LPDSBPOSITIONNOTIFY): HResult; stdcall;
end;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// ExceptionDX ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
ExceptionDX = class(Exception);

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// function //////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function DirectDrawCreate(lpGUID: PGUID; out lplpDD: IDirectDraw; pUnkOuter: IUnknown): HResult; stdcall;
function DirectDrawCreateEx(lpGUID: PGUID; out lplpDD: IDirectDraw7; iid: PGUID; pUnkOuter: IUnknown): HResult; stdcall;

function DirectInputCreate(hinst: THandle; dwVersion: DWORD; out ppDI: IDirectInput; punkOuter: IUnknown): HResult; stdcall;
function DirectInputCreateEx(hinst:Integer; dwVersion:DWORD; riidltf:PGUID; out ppvOut:IDirectInput7; punkOuter:IUnknown): HResult; stdcall;

function DirectDrawStrError(hr:HResult) : string;
function DirectInputStrError(hr:HResult) : string;

function DirectSoundCreate(lpGUID: PGUID; out lpDS: IDirectSound; pUnkOuter: IUnknown): HResult; stdcall;

{ Mouse }

type
  TDIMouseState = record
    lX: Longint;
    lY: Longint;
    lZ: Longint;
    rgbButtons: array[0..3] of BYTE;
  end;

  DIMOUSESTATE = TDIMouseState;

const
  _c_dfDIMouse_Objects: array[0..1] of DIOBJECTDATAFORMAT = (
    (pguid: nil;          dwOfs: 0;  dwType: DIDFT_RELAXIS or DIDFT_ANYINSTANCE; dwFlags: 0),
    (pguid: @GUID_Button; dwOfs: 12; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;  dwFlags: 0)
  );

  c_dfDIMouse: DIDATAFORMAT = (
    dwSize: Sizeof(c_dfDIMouse);
    dwObjSize: Sizeof(DIOBJECTDATAFORMAT);
    dwFlags: DIDF_RELAXIS;
    dwDataSize: Sizeof(TDIMouseState);
    dwNumObjs: High(_c_dfDIMouse_Objects)+1;
    rgodf: @_c_dfDIMouse_Objects
  );

{ Keyboard }
type
  TDIKeyboardState = array[0..255] of Byte;
  DIKEYBOARDSTATE = TDIKeyboardState;

const
  _c_dfDIKeyboard_Objects: array[0..0] of DIOBJECTDATAFORMAT = (
    (pguid: @GUID_Key; dwOfs: 1; dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE; dwFlags: 0)
  );

  c_dfDIKeyboard: DIDATAFORMAT = (
    dwSize: Sizeof(c_dfDIKeyboard);
    dwObjSize: Sizeof(DIOBJECTDATAFORMAT);
    dwFlags: 0;
    dwDataSize: SizeOf(TDIKeyboardState);
    dwNumObjs: High(_c_dfDIKeyboard_Objects)+1;
    rgodf: @_c_dfDIKeyboard_Objects
  );
{ DirectInput keyboard scan codes }

const
  DIK_ESCAPE          = $01;
  DIK_1               = $02;
  DIK_2               = $03;
  DIK_3               = $04;
  DIK_4               = $05;
  DIK_5               = $06;
  DIK_6               = $07;
  DIK_7               = $08;
  DIK_8               = $09;
  DIK_9               = $0A;
  DIK_0               = $0B;
  DIK_MINUS           = $0C;    // - on main keyboard
  DIK_EQUALS          = $0D;
  DIK_BACK            = $0E;    // backspace
  DIK_TAB             = $0F;
  DIK_Q               = $10;
  DIK_W               = $11;
  DIK_E               = $12;
  DIK_R               = $13;
  DIK_T               = $14;
  DIK_Y               = $15;
  DIK_U               = $16;
  DIK_I               = $17;
  DIK_O               = $18;
  DIK_P               = $19;
  DIK_LBRACKET        = $1A;
  DIK_RBRACKET        = $1B;
  DIK_RETURN          = $1C;    // Enter on main keyboard
  DIK_LCONTROL        = $1D;
  DIK_A               = $1E;
  DIK_S               = $1F;
  DIK_D               = $20;
  DIK_F               = $21;
  DIK_G               = $22;
  DIK_H               = $23;
  DIK_J               = $24;
  DIK_K               = $25;
  DIK_L               = $26;
  DIK_SEMICOLON       = $27;
  DIK_APOSTROPHE      = $28;
  DIK_GRAVE           = $29;    // accent grave
  DIK_LSHIFT          = $2A;
  DIK_BACKSLASH       = $2B;
  DIK_Z               = $2C;
  DIK_X               = $2D;
  DIK_C               = $2E;
  DIK_V               = $2F;
  DIK_B               = $30;
  DIK_N               = $31;
  DIK_M               = $32;
  DIK_COMMA           = $33;
  DIK_PERIOD          = $34;    // . on main keyboard
  DIK_SLASH           = $35;    // / on main keyboard
  DIK_RSHIFT          = $36;
  DIK_MULTIPLY        = $37;    // * on numeric keypad
  DIK_LMENU           = $38;    // left Alt
  DIK_SPACE           = $39;
  DIK_CAPITAL         = $3A;
  DIK_F1              = $3B;
  DIK_F2              = $3C;
  DIK_F3              = $3D;
  DIK_F4              = $3E;
  DIK_F5              = $3F;
  DIK_F6              = $40;
  DIK_F7              = $41;
  DIK_F8              = $42;
  DIK_F9              = $43;
  DIK_F10             = $44;
  DIK_NUMLOCK         = $45;
  DIK_SCROLL          = $46;    // Scroll Lock
  DIK_NUMPAD7         = $47;
  DIK_NUMPAD8         = $48;
  DIK_NUMPAD9         = $49;
  DIK_SUBTRACT        = $4A;    // - on numeric keypad
  DIK_NUMPAD4         = $4B;
  DIK_NUMPAD5         = $4C;
  DIK_NUMPAD6         = $4D;
  DIK_ADD             = $4E;    // + on numeric keypad
  DIK_NUMPAD1         = $4F;
  DIK_NUMPAD2         = $50;
  DIK_NUMPAD3         = $51;
  DIK_NUMPAD0         = $52;
  DIK_DECIMAL         = $53;    // . on numeric keypad
  DIK_F11             = $57;
  DIK_F12             = $58;

  DIK_F13             = $64;    //                     (NEC PC98)
  DIK_F14             = $65;    //                     (NEC PC98)
  DIK_F15             = $66;    //                     (NEC PC98)

  DIK_KANA            = $70;    // (Japanese keyboard)
  DIK_CONVERT         = $79;    // (Japanese keyboard)
  DIK_NOCONVERT       = $7B;    // (Japanese keyboard)
  DIK_YEN             = $7D;    // (Japanese keyboard)
  DIK_NUMPADEQUALS    = $8D;    // = on numeric keypad (NEC PC98)
  DIK_CIRCUMFLEX      = $90;    // (Japanese keyboard)
  DIK_AT              = $91;    //                     (NEC PC98)
  DIK_COLON           = $92;    //                     (NEC PC98)
  DIK_UNDERLINE       = $93;    //                     (NEC PC98)
  DIK_KANJI           = $94;    // (Japanese keyboard)
  DIK_STOP            = $95;    //                     (NEC PC98)
  DIK_AX              = $96;    //                     (Japan AX)
  DIK_UNLABELED       = $97;    //                        (J3100)
  DIK_NUMPADENTER     = $9C;    // Enter on numeric keypad
  DIK_RCONTROL        = $9D;
  DIK_NUMPADCOMMA     = $B3;    // , on numeric keypad (NEC PC98)
  DIK_DIVIDE          = $B5;    // / on numeric keypad
  DIK_SYSRQ           = $B7;
  DIK_RMENU           = $B8;    // right Alt
  DIK_HOME            = $C7;    // Home on arrow keypad
  DIK_UP              = $C8;    // UpArrow on arrow keypad
  DIK_PRIOR           = $C9;    // PgUp on arrow keypad
  DIK_LEFT            = $CB;    // LeftArrow on arrow keypad
  DIK_RIGHT           = $CD;    // RightArrow on arrow keypad
  DIK_END             = $CF;    // End on arrow keypad
  DIK_DOWN            = $D0;    // DownArrow on arrow keypad
  DIK_NEXT            = $D1;    // PgDn on arrow keypad
  DIK_INSERT          = $D2;    // Insert on arrow keypad
  DIK_DELETE          = $D3;    // Delete on arrow keypad
  DIK_LWIN            = $DB;    // Left Windows key
  DIK_RWIN            = $DC;    // Right Windows key
  DIK_APPS            = $DD;    // AppMenu key

//
//  Alternate names for keys, to facilitate transition from DOS.
//
  DIK_BACKSPACE       = DIK_BACK;            // backspace
  DIK_NUMPADSTAR      = DIK_MULTIPLY;        // * on numeric keypad
  DIK_LALT            = DIK_LMENU;           // left Alt
  DIK_CAPSLOCK        = DIK_CAPITAL;         // CapsLock
  DIK_NUMPADMINUS     = DIK_SUBTRACT;        // - on numeric keypad
  DIK_NUMPADPLUS      = DIK_ADD;             // + on numeric keypad
  DIK_NUMPADPERIOD    = DIK_DECIMAL;         // . on numeric keypad
  DIK_NUMPADSLASH     = DIK_DIVIDE;          // / on numeric keypad
  DIK_RALT            = DIK_RMENU;           // right Alt
  DIK_UPARROW         = DIK_UP;              // UpArrow on arrow keypad
  DIK_PGUP            = DIK_PRIOR;           // PgUp on arrow keypad
  DIK_LEFTARROW       = DIK_LEFT;            // LeftArrow on arrow keypad
  DIK_RIGHTARROW      = DIK_RIGHT;           // RightArrow on arrow keypad
  DIK_DOWNARROW       = DIK_DOWN;            // DownArrow on arrow keypad
  DIK_PGDN            = DIK_NEXT;            // PgDn on arrow keypad

implementation
const
  DDrawLib = 'DDraw.dll';

function DirectDrawCreate; external DDrawLib;
function DirectDrawCreateEx; external DDrawLib;
function DirectInputCreate; external 'DInput.dll' name 'DirectInputCreateA';
function DirectInputCreateEx; external 'DInput.dll';
function DirectSoundCreate; external 'DSound.dll';

function DirectDrawStrError(hr:HResult) : string;
var
    str:string;
begin
    case (DWORD(hr)) of
        DD_OK: str:='DD_OK';
        DD_FALSE: str:='DD_FALSE';
        DDERR_ALREADYINITIALIZED: str:='DDERR_ALREADYINITIALIZED';
        DDERR_CANNOTATTACHSURFACE: str:='DDERR_CANNOTATTACHSURFACE';
        DDERR_CANNOTDETACHSURFACE: str:='DDERR_CANNOTDETACHSURFACE';
        DDERR_CURRENTLYNOTAVAIL: str:='DDERR_CURRENTLYNOTAVAIL';
        DDERR_EXCEPTION: str:='DDERR_EXCEPTION';
        DDERR_GENERIC: str:='DDERR_GENERIC';
        DDERR_HEIGHTALIGN: str:='DDERR_HEIGHTALIGN';
        DDERR_INCOMPATIBLEPRIMARY: str:='DDERR_INCOMPATIBLEPRIMARY';
        DDERR_INVALIDCAPS: str:='DDERR_INVALIDCAPS';
        DDERR_INVALIDCLIPLIST: str:='DDERR_INVALIDCLIPLIST';
        DDERR_INVALIDMODE: str:='DDERR_INVALIDMODE';
        DDERR_INVALIDOBJECT: str:='DDERR_INVALIDOBJECT';
        DDERR_INVALIDPARAMS: str:='DDERR_INVALIDPARAMS';
        DDERR_INVALIDPIXELFORMAT: str:='DDERR_INVALIDPIXELFORMAT';
        DDERR_INVALIDRECT: str:='DDERR_INVALIDRECT';
        DDERR_LOCKEDSURFACES: str:='DDERR_LOCKEDSURFACES';
        DDERR_NO3D: str:='DDERR_NO3D';
        DDERR_NOALPHAHW: str:='DDERR_NOALPHAHW';
        DDERR_NOCLIPLIST: str:='DDERR_NOCLIPLIST';
        DDERR_NOCOLORCONVHW: str:='DDERR_NOCOLORCONVHW';
        DDERR_NOCOOPERATIVELEVELSET: str:='DDERR_NOCOOPERATIVELEVELSET';
        DDERR_NOCOLORKEY: str:='DDERR_NOCOLORKEY';
        DDERR_NOCOLORKEYHW: str:='DDERR_NOCOLORKEYHW';
        DDERR_NODIRECTDRAWSUPPORT: str:='DDERR_NODIRECTDRAWSUPPORT';
        DDERR_NOEXCLUSIVEMODE: str:='DDERR_NOEXCLUSIVEMODE';
        DDERR_NOFLIPHW: str:='DDERR_NOFLIPHW';
        DDERR_NOGDI: str:='DDERR_NOGDI';
        DDERR_NOMIRRORHW: str:='DDERR_NOMIRRORHW';
        DDERR_NOTFOUND: str:='DDERR_NOTFOUND';
        DDERR_NOOVERLAYHW: str:='DDERR_NOOVERLAYHW';
        DDERR_OVERLAPPINGRECTS: str:='DDERR_OVERLAPPINGRECTS';
        DDERR_NORASTEROPHW: str:='DDERR_NORASTEROPHW';
        DDERR_NOROTATIONHW: str:='DDERR_NOROTATIONHW';
        DDERR_NOSTRETCHHW: str:='DDERR_NOSTRETCHHW';
        DDERR_NOT4BITCOLOR: str:='DDERR_NOT4BITCOLOR';
        DDERR_NOT4BITCOLORINDEX: str:='DDERR_NOT4BITCOLORINDEX';
        DDERR_NOT8BITCOLOR: str:='DDERR_NOT8BITCOLOR';
        DDERR_NOTEXTUREHW: str:='DDERR_NOTEXTUREHW';
        DDERR_NOVSYNCHW: str:='DDERR_NOVSYNCHW';
        DDERR_NOZBUFFERHW: str:='DDERR_NOZBUFFERHW';
        DDERR_NOZOVERLAYHW: str:='DDERR_NOZOVERLAYHW';
        DDERR_OUTOFCAPS: str:='DDERR_OUTOFCAPS';
        DDERR_OUTOFMEMORY: str:='DDERR_OUTOFMEMORY';
        DDERR_OUTOFVIDEOMEMORY: str:='DDERR_OUTOFVIDEOMEMORY';
        DDERR_OVERLAYCANTCLIP: str:='DDERR_OVERLAYCANTCLIP';
        DDERR_OVERLAYCOLORKEYONLYONEACTIVE: str:='DDERR_OVERLAYCOLORKEYONLYONEACTIVE';
        DDERR_PALETTEBUSY: str:='DDERR_PALETTEBUSY';
        DDERR_COLORKEYNOTSET: str:='DDERR_COLORKEYNOTSET';
        DDERR_SURFACEALREADYATTACHED: str:='DDERR_SURFACEALREADYATTACHED';
        DDERR_SURFACEALREADYDEPENDENT: str:='DDERR_SURFACEALREADYDEPENDENT';
        DDERR_SURFACEBUSY: str:='DDERR_SURFACEBUSY';
        DDERR_CANTLOCKSURFACE: str:='DDERR_CANTLOCKSURFACE';
        DDERR_SURFACEISOBSCURED: str:='DDERR_SURFACEISOBSCURED';
        DDERR_SURFACELOST: str:='DDERR_SURFACELOST';
        DDERR_SURFACENOTATTACHED: str:='DDERR_SURFACENOTATTACHED';
        DDERR_TOOBIGHEIGHT: str:='DDERR_TOOBIGHEIGHT';
        DDERR_TOOBIGSIZE: str:='DDERR_TOOBIGSIZE';
        DDERR_TOOBIGWIDTH: str:='DDERR_TOOBIGWIDTH';
        DDERR_UNSUPPORTED: str:='DDERR_UNSUPPORTED';
        DDERR_UNSUPPORTEDFORMAT: str:='DDERR_UNSUPPORTEDFORMAT';
        DDERR_UNSUPPORTEDMASK: str:='DDERR_UNSUPPORTEDMASK';
        DDERR_INVALIDSTREAM: str:='DDERR_INVALIDSTREAM';
        DDERR_VERTICALBLANKINPROGRESS: str:='DDERR_VERTICALBLANKINPROGRESS';
        DDERR_WASSTILLDRAWING: str:='DDERR_WASSTILLDRAWING';
        DDERR_XALIGN: str:='DDERR_XALIGN';
        DDERR_INVALIDDIRECTDRAWGUID: str:='DDERR_INVALIDDIRECTDRAWGUID';
        DDERR_DIRECTDRAWALREADYCREATED: str:='DDERR_DIRECTDRAWALREADYCREATED';
        DDERR_NODIRECTDRAWHW: str:='DDERR_NODIRECTDRAWHW';
        DDERR_PRIMARYSURFACEALREADYEXISTS: str:='DDERR_PRIMARYSURFACEALREADYEXISTS';
        DDERR_NOEMULATION: str:='DDERR_NOEMULATION';
        DDERR_REGIONTOOSMALL: str:='DDERR_REGIONTOOSMALL';
        DDERR_CLIPPERISUSINGHWND: str:='DDERR_CLIPPERISUSINGHWND';
        DDERR_NOCLIPPERATTACHED: str:='DDERR_NOCLIPPERATTACHED';
        DDERR_NOHWND: str:='DDERR_NOHWND';
        DDERR_HWNDSUBCLASSED: str:='DDERR_HWNDSUBCLASSED';
        DDERR_HWNDALREADYSET: str:='DDERR_HWNDALREADYSET';
        DDERR_NOPALETTEATTACHED: str:='DDERR_NOPALETTEATTACHED';
        DDERR_NOPALETTEHW: str:='DDERR_NOPALETTEHW';
        DDERR_BLTFASTCANTCLIP: str:='DDERR_BLTFASTCANTCLIP';
        DDERR_NOBLTHW: str:='DDERR_NOBLTHW';
        DDERR_NODDROPSHW: str:='DDERR_NODDROPSHW';
        DDERR_OVERLAYNOTVISIBLE: str:='DDERR_OVERLAYNOTVISIBLE';
        DDERR_NOOVERLAYDEST: str:='DDERR_NOOVERLAYDEST';
        DDERR_INVALIDPOSITION: str:='DDERR_INVALIDPOSITION';
        DDERR_NOTAOVERLAYSURFACE: str:='DDERR_NOTAOVERLAYSURFACE';
        DDERR_EXCLUSIVEMODEALREADYSET: str:='DDERR_EXCLUSIVEMODEALREADYSET';
        DDERR_NOTFLIPPABLE: str:='DDERR_NOTFLIPPABLE';
        DDERR_CANTDUPLICATE: str:='DDERR_CANTDUPLICATE';
        DDERR_NOTLOCKED: str:='DDERR_NOTLOCKED';
        DDERR_CANTCREATEDC: str:='DDERR_CANTCREATEDC';
        DDERR_NODC: str:='DDERR_NODC';
        DDERR_WRONGMODE: str:='DDERR_WRONGMODE';
        DDERR_IMPLICITLYCREATED: str:='DDERR_IMPLICITLYCREATED';
        DDERR_NOTPALETTIZED: str:='DDERR_NOTPALETTIZED';
        DDERR_UNSUPPORTEDMODE: str:='DDERR_UNSUPPORTEDMODE';
        DDERR_NOMIPMAPHW: str:='DDERR_NOMIPMAPHW';
        DDERR_INVALIDSURFACETYPE: str:='DDERR_INVALIDSURFACETYPE';
        DDERR_NOOPTIMIZEHW: str:='DDERR_NOOPTIMIZEHW';
        DDERR_NOTLOADED: str:='DDERR_NOTLOADED';
        DDERR_NOFOCUSWINDOW: str:='DDERR_NOFOCUSWINDOW';
        DDERR_DCALREADYCREATED: str:='DDERR_DCALREADYCREATED';
        DDERR_NONONLOCALVIDMEM: str:='DDERR_NONONLOCALVIDMEM';
        DDERR_CANTPAGELOCK: str:='DDERR_CANTPAGELOCK';
        DDERR_CANTPAGEUNLOCK: str:='DDERR_CANTPAGEUNLOCK';
        DDERR_NOTPAGELOCKED: str:='DDERR_NOTPAGELOCKED';
        DDERR_MOREDATA: str:='DDERR_MOREDATA';
        DDERR_EXPIRED: str:='DDERR_EXPIRED';
        DDERR_VIDEONOTACTIVE: str:='DDERR_VIDEONOTACTIVE';
        DDERR_DEVICEDOESNTOWNSURFACE: str:='DDERR_DEVICEDOESNTOWNSURFACE';
        DDERR_NOTINITIALIZED: str:='DDERR_NOTINITIALIZED';
    else
        str:='Unknown';
    end;
    Result:='HResult='+IntToStr(DWORD(hr))+' Str='+ str;
end;

function DirectInputStrError(hr:HResult) : string;
var
    str:string;
begin
    case (DWORD(hr)) of
        DI_OK: str:='DI_OK';
        DI_NOTATTACHED: str:='DI_NOTATTACHED';
//        DI_BUFFEROVERFLOW: str:='DI_BUFFEROVERFLOW';
//        DI_PROPNOEFFECT: str:='DI_PROPNOEFFECT';
//        DI_NOEFFECT: str:='DI_NOEFFECT';
        DI_POLLEDDEVICE: str:='DI_POLLEDDEVICE';
        DI_DOWNLOADSKIPPED: str:='DI_DOWNLOADSKIPPED';
        DI_EFFECTRESTARTED: str:='DI_EFFECTRESTARTED';
        DI_TRUNCATED: str:='DI_TRUNCATED';
        DI_TRUNCATEDANDRESTARTED: str:='DI_TRUNCATEDANDRESTARTED';

        DIERR_OLDDIRECTINPUTVERSION: str:='DIERR_OLDDIRECTINPUTVERSION';
        DIERR_BETADIRECTINPUTVERSION: str:='DIERR_BETADIRECTINPUTVERSION';
        DIERR_BADDRIVERVER: str:='DIERR_BADDRIVERVER';
        DIERR_DEVICENOTREG: str:='DIERR_DEVICENOTREG';
        DIERR_NOTFOUND: str:='DIERR_NOTFOUND';
//        DIERR_OBJECTNOTFOUND: str:='DIERR_OBJECTNOTFOUND';
        DIERR_INVALIDPARAM: str:='DIERR_INVALIDPARAM';
        DIERR_NOINTERFACE: str:='DIERR_NOINTERFACE';
        DIERR_GENERIC: str:='DIERR_GENERIC';
        DIERR_OUTOFMEMORY: str:='DIERR_OUTOFMEMORY';
        DIERR_UNSUPPORTED: str:='DIERR_UNSUPPORTED';
        DIERR_NOTINITIALIZED: str:='DIERR_NOTINITIALIZED';
        DIERR_ALREADYINITIALIZED: str:='DIERR_ALREADYINITIALIZED';
        DIERR_NOAGGREGATION: str:='DIERR_NOAGGREGATION';
        DIERR_OTHERAPPHASPRIO: str:='DIERR_OTHERAPPHASPRIO';
        DIERR_INPUTLOST: str:='DIERR_INPUTLOST';
        DIERR_ACQUIRED: str:='DIERR_ACQUIRED';
        DIERR_NOTACQUIRED: str:='DIERR_NOTACQUIRED';
//        DIERR_READONLY: str:='DIERR_READONLY';
//        DIERR_HANDLEEXISTS: str:='DIERR_HANDLEEXISTS';
        DIERR_PENDING: str:='DIERR_PENDING';
        DIERR_INSUFFICIENTPRIVS: str:='DIERR_INSUFFICIENTPRIVS';
        DIERR_DEVICEFULL: str:='DIERR_DEVICEFULL';
        DIERR_MOREDATA: str:='DIERR_MOREDATA';
        DIERR_NOTDOWNLOADED: str:='DIERR_NOTDOWNLOADED';
        DIERR_HASEFFECTS: str:='DIERR_HASEFFECTS';
        DIERR_NOTEXCLUSIVEACQUIRED: str:='DIERR_NOTEXCLUSIVEACQUIRED';
        DIERR_INCOMPLETEEFFECT: str:='DIERR_INCOMPLETEEFFECT';
        DIERR_NOTBUFFERED: str:='DIERR_NOTBUFFERED';
        DIERR_EFFECTPLAYING: str:='DIERR_EFFECTPLAYING';
    else
        str:='Unknown';
    end;
    Result:='HResult='+IntToStr(DWORD(hr))+' Str='+ str;
end;

end.
