unit Form_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, GR_DirectX3D8, StdCtrls,Math,
  ABKey, ABPoint,ABTriangle,ABLine,ab_Obj3D,EC_Str, Menus, EC_BlockPar,
  Buttons, ComCtrls;

type
  TFormMain = class(TForm)
    Panel3D: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    NInfo: TNotebook;
    Label1: TLabel;
    EditPointPos: TEdit;
    Timer1: TTimer;
    ButtonTriDelete: TButton;
    ButtonTriInvert: TButton;
    Label8: TLabel;
    GroupBox4: TGroupBox;
    EditTPColor: TEdit;
    ScrollBarTPA: TScrollBar;
    ScrollBarTPR: TScrollBar;
    ScrollBarTPG: TScrollBar;
    ScrollBarTPB: TScrollBar;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditTPTex: TComboBox;
    GroupBox1: TGroupBox;
    EditTriTexture: TComboBox;
    ButtonTriLoad: TButton;
    OpenDialogTexture: TOpenDialog;
    ButtonTriClear: TButton;
    Edit1: TEdit;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    About1: TMenuItem;
    About2: TMenuItem;
    Save1: TMenuItem;
    Load1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Panel3: TPanel;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    EditTriBackFace: TCheckBox;
    ButtonPointDelete: TButton;
    ButtonLineDelete: TButton;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    EditPointPortType: TEdit;
    Label3: TLabel;
    EditPointPortId: TEdit;
    Label4: TLabel;
    EditPointPortLink: TEdit;
    Edit2: TMenuItem;
    MM_Edir_Group: TMenuItem;
    ButtonTPColorKey: TSpeedButton;
    TBTime: TTrackBar;
    CheckBoxPlay: TCheckBox;
    GroupBox3: TGroupBox;
    EditLPColor: TEdit;
    ButtonLPColorKey: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label13: TLabel;
    ScrollBarLPB: TScrollBar;
    ScrollBarLPG: TScrollBar;
    ScrollBarLPR: TScrollBar;
    ScrollBarLPA: TScrollBar;
    N2: TMenuItem;
    MM_File_Clear: TMenuItem;
    Label14: TLabel;
    EditPointId: TEdit;
    Label15: TLabel;
    EditLineType: TEdit;
    ITime: TImage;
    ButtonTPCopy: TBitBtn;
    ButtonTPPaste: TBitBtn;
    ButtonLPCopy: TButton;
    ButtonLPPaste: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Panel3DMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Panel3DMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3DMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure EditPointPosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonTriInvertClick(Sender: TObject);
    procedure ButtonTriDeleteClick(Sender: TObject);
    procedure EditTPColorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ScrollBarTPAChange(Sender: TObject);
    procedure ButtonTriLoadClick(Sender: TObject);
    procedure EditTPTexSelect(Sender: TObject);
    procedure EditTPTexKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditTriTextureSelect(Sender: TObject);
    procedure ButtonTriClearClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure EditTriBackFaceClick(Sender: TObject);
    procedure ButtonPointDeleteClick(Sender: TObject);
    procedure ButtonLineDeleteClick(Sender: TObject);
    procedure EditPointPortIdChange(Sender: TObject);
    procedure MM_Edir_GroupClick(Sender: TObject);
    procedure ButtonTPColorKeyClick(Sender: TObject);
    procedure TBTimeChange(Sender: TObject);
    procedure EditLPColorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ScrollBarLPAChange(Sender: TObject);
    procedure ButtonLPColorKeyClick(Sender: TObject);
    procedure MM_File_ClearClick(Sender: TObject);
    procedure EditPointIdChange(Sender: TObject);
    procedure EditLineTypeChange(Sender: TObject);
    procedure ButtonTPCopyClick(Sender: TObject);
    procedure ButtonTPPasteClick(Sender: TObject);
    procedure ButtonLPCopyClick(Sender: TObject);
    procedure ButtonLPPasteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    	FMove:boolean;
        FRotateCamera:boolean;
        FMoveLP:TPoint;

        FProgUpdate:boolean;

    	procedure ClearAll;
		procedure Draw3D;
        procedure UpdateInfo;
        procedure UpdateInfoP;
        procedure UpdateMatrix;
        procedure UpdateCaption;
        procedure UpdateITime;

		procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
		procedure ApplicationDeactivate(Sender: TObject);

        function PosToView(pos:TPoint):D3DVECTOR;
        procedure CalcPick(mp:TPoint; var vpos:D3DVECTOR; var vdir:D3DVECTOR);
        function CalcWorld(mp:TPoint; z:single; var des:D3DVECTOR):boolean; overload;
        function CalcWorld(mp:TPoint; var des:D3DVECTOR):boolean;  overload;
        function CalcWorld(vpos,vdir:D3DVECTOR; atr:TTriangleAB; var t:single):boolean;  overload;
        function PickTriangle(mp:TPoint):TList;
        function PickTrianglePlane(mp:TPoint):TList;
        function PickLine(mp:TPoint):TList;
        function CurKey:TKeyAB;
        function CalcTexCoord(mp:TPoint; var u:single; var v:single):boolean;

        procedure SetTime(t:integer);

        procedure SortTriangle;

        procedure ClacTexCoord;
  end;

var
	FormMain: TFormMain;

	GR_LibD3D8:DWORD=0;
	GR_lpD3D:IDirect3D8=nil;
	GR_DMode:D3DDISPLAYMODE;
	GR_lpDev:IDirect3DDevice8=nil;

    GSmeX:single=0;
    GSmeY:single=0;

    Camera_Pos:D3DVECTOR;
    Camera_Des:D3DVECTOR;
    Camera_Up:D3DVECTOR;
    Camera_Fov:single=40;//45;

    Camera_MatView:D3DMATRIX;
	Camera_MatProj:D3DMATRIX;
	Camera_MatEnd:D3DMATRIX;

    GFileName:WideString;

    GSortTriangle:TList;

procedure EError(str:string);

implementation

uses VOper, Form_Group, Form_Key;

{$R *.dfm}

procedure EError(str:string);
begin
	raise Exception.Create(str);
end;

procedure TFormMain.FormCreate(Sender: TObject);
type
	DefDirect3DCreate8 = function(ver:integer):IDirect3D8; stdcall;
var
    Direct3DCreate8:DefDirect3DCreate8;
    d8dpp:D3DPRESENT_PARAMETERS;
    hr:DWORD;
begin
	DecimalSeparator:='.';

    Application.OnMessage := AppMessage;
    Application.OnDeactivate:=ApplicationDeactivate;

    KeyGroup_ClearInit;

    GSortTriangle:=TList.Create;

    Camera_Pos:=D3DV(0,0,-3500);
    Camera_Des:=D3DV(0,0,0);
    Camera_Up:=D3DV(0,1,0);
    UpdateMatrix;

	    GR_LibD3D8:=LoadLibrary('d3d8.dll');
        if GR_LibD3D8=0 then raise Exception.Create('LoadLibrary');
    	Direct3DCreate8:=GetProcAddress(GR_LibD3D8,'Direct3DCreate8');
        if not Assigned(Direct3DCreate8) then raise Exception.Create('GetProcAddress');

//		GR_lpD3D:=Direct3DCreate8(120);
		asm
        	mov		eax,120
            push	eax
            mov		eax,Direct3DCreate8
            call	eax
            mov		GR_lpD3D,eax
        end;
        if GR_lpD3D=nil then raise Exception.Create('Direct3DCreate8');

		hr:=GR_lpD3D.GetAdapterDisplayMode(D3DADAPTER_DEFAULT, @GR_DMode);
        if hr<>D3D_OK then raise Exception.Create('GetAdapterDisplayMode');

        ZeroMemory(@d8dpp,sizeof(D3DPRESENT_PARAMETERS));
        d8dpp.Windowed := TRUE;
        d8dpp.SwapEffect:=D3DSWAPEFFECT_DISCARD;
        d8dpp.BackBufferFormat:=GR_DMode.Format;
		d8dpp.EnableAutoDepthStencil := TRUE;
	    d8dpp.AutoDepthStencilFormat := D3DFMT_D16;
		hr:=GR_lpD3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, Panel3D.Handle,
        						 D3DCREATE_SOFTWARE_VERTEXPROCESSING,
                                 @d8dpp, GR_lpDev );
        if hr<>D3D_OK then raise Exception.Create('CreateDevice');

	GSmeX:=Panel3D.Width/2;
	GSmeY:=Panel3D.Height/2;

{	Point_Add.SetPosC(-100,-100,0);
	Point_Add.SetPosC(100,-100,0);
	Point_Add.SetPosC(100,100,0);}
{    with ab_Obj3D_Add do begin
	    VerCount:=3;
        VerOpen;
        Ver(0)^:=abVer3D(10,10,0,0,0,$000000ff);
        Ver(1)^:=abVer3D(200,100,0,1,0,$ff0000ff);
        Ver(2)^:=abVer3D(100,200,0,1,1,$ff0000ff);
        VerClose;

        UnitAddTriangle(0,1,2,'');
//        UnitAddTriangle(1,0,2);
    end;}

    SetTime(0);

    ITime.Picture.Bitmap.Width:=ITime.Width;
    ITime.Picture.Bitmap.Height:=ITime.Height;

	UpdateCaption;
    UpdateITime;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
	GR_lpDev:=nil;
	GR_lpD3D:=nil;
	if GR_LibD3D8<>0 then begin
	    FreeLibrary(GR_LibD3D8);
        GR_LibD3D8:=0;
    end;
    GSortTriangle.Free; GSortTriangle:=nil;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
	Draw3D;
    UpdateInfo;
end;

procedure TFormMain.FormResize(Sender: TObject);
{var
	d8dpp:D3DPRESENT_PARAMETERS;}
begin
{	vp.X:=0;
    vp.Y:=0;
    vp.Width:=Panel3D.Width;
    vp.Height:=Panel3D.Height;
    vp.MinZ:=0.0;
    vp.MaxZ:=1.0;
	if GR_lpDev.SetViewport(@vp)<>D3D_OK then raise Exception.Create('SetViewport');}
{    pp.BackBufferWidth;
    pp.BackBufferHeight;
    pp.BackBufferFormat;
    pp.BackBufferCount;

    pp.MultiSampleType;

    pp.SwapEffect;
    pp.hDeviceWindow;
    pp.Windowed;
    pp.EnableAutoDepthStencil;
    pp.AutoDepthStencilFormat;
    pp.Flags;

    pp.FullScreen_RefreshRateInHz;
    pp.FullScreen_PresentationInterval;}

{	ZeroMemory(@d8dpp,sizeof(D3DPRESENT_PARAMETERS));
    d8dpp.Windowed := TRUE;
    d8dpp.SwapEffect:=D3DSWAPEFFECT_DISCARD;
    d8dpp.BackBufferFormat:=GR_DMode.Format;

    if GR_lpDev.Reset(@d8dpp)<>D3D_OK then raise Exception.Create('Reset');

	Draw3D;}
end;

procedure TFormMain.ClearAll;
begin
	Line_Clear;
	Triangle_Clear;
	Point_Clear;

    KeyGroup_ClearInit;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
	Draw3D;
end;

procedure TFormMain.Draw3D;
var
	i:integer;
begin
	if not Application.Active then Exit;
//	Edit1.Text:=IntToStr(integer(Application.Active));

	if GR_lpDev.Clear( 0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, D3DCOLOR_XRGB(0,0,0), 1.0, 0 )<>D3D_OK then EError('TabObj3D Dev.Clear');
	if GR_lpDev.BeginScene<>D3D_OK then EError('TabObj3D BeginScene');

	GR_lpDev.SetRenderState(D3DRS_COLORVERTEX, DWORD(TRUE));
	GR_lpDev.SetRenderState(D3DRS_ALPHABLENDENABLE, DWORD(TRUE));
	GR_lpDev.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_SRCALPHA  );
	GR_lpDev.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA  );

	GR_lpDev.SetRenderState(D3DRS_CULLMODE, D3DCULL_CCW {D3DCULL_NONE});

    GR_lpDev.SetRenderState(D3DRS_CLIPPING,DWORD(FALSE));

//    GR_lpDev.SetRenderState(D3DRS_FILLMODE,DWORD(D3DFILL_WIREFRAME));

    GR_lpDev.SetRenderState(D3DRS_DITHERENABLE ,DWORD(TRUE));

    GR_lpDev.SetRenderState(D3DRS_ZENABLE ,DWORD(TRUE));
    GR_lpDev.SetRenderState(D3DRS_ZWRITEENABLE ,DWORD(TRUE));
    GR_lpDev.SetRenderState(D3DRS_ZFUNC, DWORD({D3DCMP_GREATEREQUAL}  D3DCMP_LESSEQUAL));

    GR_lpDev.SetTextureStageState(0,D3DTSS_MAGFILTER,D3DTEXF_LINEAR);
    GR_lpDev.SetTextureStageState(0,D3DTSS_MINFILTER,D3DTEXF_LINEAR);
    GR_lpDev.SetTextureStageState(0,D3DTSS_MIPFILTER,D3DTEXF_LINEAR);

    for i:=GSortTriangle.Count-1 downto 0 do begin
		TTriangleAB(GSortTriangle.Items[i]).FGraph.Draw;
    end;
{    for i:=0 to GSortTriangle.Count-1 do begin
		TTriangleAB(GSortTriangle.Items[i]).FGraph.Draw;
    end;}
    ab_Obj3D_Draw;

	if GR_lpDev.EndScene<>D3D_OK then EError('TabObj3D EndScene');
    if GR_lpDev.Present(nil, nil, 0, nil)<>D3D_OK then EError('TabObj3D Present');
end;

procedure TFormMain.UpdateInfo;
begin
	FProgUpdate:=true;
    UpdateInfoP;
	FProgUpdate:=false;
end;

procedure TFormMain.UpdateInfoP;
var
	apo:TPointAB;
    atr,atr2:TTriangleAB;
    ali:TLineAB;
    cntsel:integer;
    i,u:integer;
    newp:string;
    tstr:WideString;
    li:TList;
    atrp:PTriangleUnitAB;
    dw:DWORD;
begin
	atr:=nil;
    ali:=nil;

	cntsel:=0;
    apo:=Point_First;
    while apo<>nil do begin
    	if apo.Sel then inc(cntsel);
    	apo:=apo.FNext;
    end;
    if (cntsel<>1) and (NInfo.ActivePage='Point') then begin
	    newp:='Main';
    end else if cntsel=1 then begin
		newp:='Point';
    end else begin
		newp:='Main';
    end;

    if newp='Main' then begin
        ali:=Line_Sel;
        if ali<>nil then begin
        	if ali.FSelPoint<0 then newp:='Line'
            else newp:='LinePoint';
        end;
    end;

    if newp='Main' then begin
    	atr:=Triangle_Sel;
        if atr<>nil then begin
        	if atr.FSelPoint<0 then newp:='Triangle'
            else newp:='TriPoint';
        end;
    end;

    if NInfo.ActivePage<>newp then NInfo.ActivePage:=newp;

    if NInfo.ActivePage='Point' then begin
    	apo:=Point_Sel;

        EditPointId.Text:=apo.FId;

        EditPointPos.Text:=Format('%.2f,%.2f,%.2f',[apo.Pos.x,apo.Pos.y,apo.Pos.z]);

        EditPointPortId.Text:=apo.FPortId;
        EditPointPortType.Text:=apo.FPortType;
    	EditPointPortLink.Text:=apo.FPortLink;

    end else if NInfo.ActivePage='Triangle' then begin

        EditTriTexture.Items.Clear;
        EditTriTexture.ItemIndex:=-1;
        atr2:=Triangle_First;
        while atr2<>nil do begin
        	if atr2.FTexture<>'' then begin
            	tstr:=File_Name(atr2.FTexture);
            	if EditTriTexture.Items.IndexOf(tstr)<0 then begin
                	EditTriTexture.Items.Add(tstr);
                    EditTriTexture.Items.Objects[EditTriTexture.Items.Count-1]:=atr2;
                end;

                if atr=atr2 then begin
	                EditTriTexture.ItemIndex:=EditTriTexture.Items.Count-1;
                end;
            end;

            atr2:=atr2.FNext;
        end;

        EditTriBackFace.Checked:=atr.FBackFace;

    end else if NInfo.ActivePage='TriPoint' then begin
    	i:=atr.FSelPoint;

        EditTPTex.Items.Clear;
        EditTPTex.Items.Add('0,0');
        EditTPTex.Items.Add('1,0');
        EditTPTex.Items.Add('0,1');
        EditTPTex.Items.Add('1,1');
        li:=Triangle_Find(atr.FV[i].FVer,nil);
        if li<>nil then begin
        	if li.Count>1 then begin
		        EditTPTex.Items.Add('---');
    	        for u:=0 to li.Count-1 do begin
                	atr2:=TTriangleAB(li.Items[u]);
                    if atr2=atr then continue;

                    atrp:=atr2.Get(atr2.Find(atr.FV[i].FVer));

	        	    EditTPTex.Items.Add(Format('%.4f,%.4f',[atrp.FU,atrp.FV]));
                end;
            end;
        	li.Free;
        end;
		EditTPTex.Text:=Format('%.4f,%.4f',[atr.FV[i].FU,atr.FV[i].FV]);

        EditTPColor.Text:=Format('%d,%d,%d,%d',[D3DCOLOR_A(atr.FV[i].FColor.VDWORD),D3DCOLOR_R(atr.FV[i].FColor.VDWORD),D3DCOLOR_G(atr.FV[i].FColor.VDWORD),D3DCOLOR_B(atr.FV[i].FColor.VDWORD)]);
        ScrollBarTPA.Position:=D3DCOLOR_A(atr.FV[i].FColor.VDWORD);
        ScrollBarTPR.Position:=D3DCOLOR_R(atr.FV[i].FColor.VDWORD);
        ScrollBarTPG.Position:=D3DCOLOR_G(atr.FV[i].FColor.VDWORD);
        ScrollBarTPB.Position:=D3DCOLOR_B(atr.FV[i].FColor.VDWORD);

    end else if NInfo.ActivePage='Line' then begin
        EditLineType.Text:=ali.FType;

    end else if NInfo.ActivePage='LinePoint' then begin
        if ali.FSelPoint=0 then dw:=ali.FColorStart.VDWORD
        else dw:=ali.FColorEnd.VDWORD;

        EditLPColor.Text:=Format('%d,%d,%d,%d',[D3DCOLOR_A(dw),D3DCOLOR_R(dw),D3DCOLOR_G(dw),D3DCOLOR_B(dw)]);
        ScrollBarLPA.Position:=D3DCOLOR_A(dw);
        ScrollBarLPR.Position:=D3DCOLOR_R(dw);
        ScrollBarLPG.Position:=D3DCOLOR_G(dw);
        ScrollBarLPB.Position:=D3DCOLOR_B(dw);
    end;
end;

procedure TFormMain.UpdateMatrix;
var
//	minz,maxz:single;
//    apo:TPointAB;
    d:single;
begin
{	minz:=1e20;
    maxz:=-1e20;

    apo:=Point_First;
    while apo<>nil do begin
    	minz:=min(minz,apo.FPos.z);
    	maxz:=min(maxz,apo.FPos.z);
    	apo:=apo.FNext;
    end;}
    d:=sqrt(sqr(Camera_Pos.x-Camera_Des.x)+sqr(Camera_Pos.y-Camera_Des.y)+sqr(Camera_Pos.z-Camera_Des.z));

    Camera_MatView:=D3D_ViewMatrix(Camera_Pos,Camera_Des,Camera_Up);
	Camera_MatProj:=D3D_ProjectionMatrix(d-500,d+500,Camera_Fov*ToRad,Panel3D.Width);
    Camera_MatEnd:=D3D_MatrixMult(Camera_MatProj,Camera_MatView);
end;

procedure TFormMain.UpdateCaption;
var
	tstr:WideString;
begin
	tstr:='3DE';
    if GFileName<>'' then tstr:=tstr+' ['+File_Name(GFileName)+']';

    Caption:=tstr;
end;

procedure TFormMain.UpdateITime;
var
	ca:TCanvas;
    atr:TTriangleAB;
    ali:TLineAB;
    key:TKeyAB;
    t,i,sme,lp,smey:integer;
begin
	key:=nil;

	ca:=ITime.Picture.Bitmap.Canvas;

    ca.Brush.Color:=clBtnFace;
    ca.Brush.Style:=bsSolid;
    ca.Pen.Color:=clBtnFace;
    ca.Pen.Style:=psSolid;
    ca.FillRect(Rect(0,0,ITime.Width,ITime.Height));

	ali:=Line_Sel;
    if ali<>nil then begin
    	if ali.FSelPoint=0 then key:=ali.FColorStart
        else if ali.FSelPoint=1 then key:=ali.FColorEnd;
    end;

	atr:=Triangle_Sel;
	if atr<>nil then begin
    	if atr.FSelPoint>=0 then key:=atr.FV[atr.FSelPoint].FColor;
    end;

    if key=nil then Exit;

    smey:=0;
    lp:=-100;
    t:=0;
    for i:=0 to key.FCount-1 do begin
    	sme:=Round(8+(ITime.Width-(8+8))*(t/TBTime.Max));

        if (sme-lp)<5 then begin
        	smey:=smey+4;
        end else begin
        	smey:=0;
        end;
		lp:=sme;

        if i=key.FCur then begin
		    ca.Brush.Color:=clRed;
		    ca.Pen.Color:=clRed;
        end else begin
		    ca.Brush.Color:=clBlue;
		    ca.Pen.Color:=clBlue;
        end;

        ca.Ellipse(sme-3,smey,sme+3,smey+6);

    	t:=t+key.FUnitT[i];
    end;
end;

procedure TFormMain.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
	tp:TPoint;
    apo,apo1,apo2,apo3:TPointAB;
    atr:TTriangleAB;
    ali:TLineAB;
    _ctrl,_shift:boolean;
    m:D3DMATRIX;
    v:D3DVECTOR;
    r,zn:single;
    ed:boolean;
begin
    _ctrl:=(GetAsyncKeyState(VK_CONTROL) and $8000)=$8000;
    _shift:=(GetAsyncKeyState(VK_SHIFT) and $8000)=$8000;

    ed:=(ActiveControl<>nil) and ((ActiveControl.ClassName='TEdit') or (ActiveControl.ClassName='TComboBox'));

	Handled:=false;
    if Msg.message=($400+123) then begin
    	if CheckBoxPlay.Checked then SetTime(Key_Time+20);
    end else if (Msg.message=WM_PAINT) and (Msg.hwnd=Panel3D.Handle) then begin
        Draw3D;
        Handled:=true;
    end else if (Msg.message=WM_KEYDOWN) and (not ed) then begin
    	if _ctrl and (Msg.wParam=integer('A')) then begin
        	ClacTexCoord;
            Triangle_UpdateGraph;
            Draw3D;
    	end else if _ctrl and (Msg.wParam=integer('P')) then begin
		    apo:=Point_First;
    		while apo<>nil do begin
		    	apo.Sel:=false;
    			apo:=apo.FNext;
	    	end;

            ali:=Line_Sel;
            if ali<>nil then begin
            	ali.FSel:=false;
                ali.UpdateGraph;
            end;

			GetCursorPos(tp);
			if CalcWorld(Panel3D.ScreenToClient(tp),v) then begin
		        apo:=Point_Add;
        	    apo.Pos:=v;
            	apo.Sel:=true;
            end;

            UpdateInfo;
            Handled:=true;

    	end else if _ctrl and (Msg.wParam=integer('T')) then begin
            while True do begin
			    apo1:=Point_Sel; if apo1=nil then break;
                apo2:=Point_Sel(apo1); if apo2=nil then break;
                apo3:=Point_Sel(apo2); if apo3=nil then break;
                if Point_Sel(apo3)<>nil then break;
				if Triangle_Find(apo1,apo2,apo3)<>nil then break;

                atr:=Triangle_Sel;
                if atr<>nil then begin
                	atr.FSel:=false;
                    atr.UpdateGraph;
                end;
                ali:=Line_Sel;
                if ali<>nil then begin
                	ali.FSel:=false;
                    ali.UpdateGraph;
                end;

				//(2.x-1.x)*(1.y-3.y)-(2.y-1.y)*(1.x-3.x)
				zn:=(apo2.FPosShow.x-apo1.FPosShow.x)*(apo1.FPosShow.y-apo3.FPosShow.y)-
                    (apo2.FPosShow.y-apo1.FPosShow.y)*(apo1.FPosShow.x-apo3.FPosShow.x);
                if zn>0 then begin
                    apo:=apo1; apo1:=apo2; apo2:=apo;
                end;

				atr:=Triangle_Add;
                with atr.FV[0] do begin
                	FVer:=apo1;
                	FU:=0.0;
                    FV:=0.0;
                    FColor.VDWORD_:=$ffffffff;
                    FColor.Interpolate;
                end;
                with atr.FV[1] do begin
                	FVer:=apo2;
                	FU:=1.0;
                    FV:=0.0;
                    FColor.VDWORD_:=$ffffffff;
                    FColor.Interpolate;
                end;
                with atr.FV[2] do begin
                	FVer:=apo3;
                	FU:=0.0;
                    FV:=1.0;
                    FColor.VDWORD_:=$ffffffff;
                    FColor.Interpolate;
                end;
                atr.FSel:=true;
                atr.FSelPoint:=-1;
                atr.UpdateGraph;

			    apo:=Point_First;
    			while apo<>nil do begin
			    	apo.Sel:=false;
    				apo:=apo.FNext;
	    		end;

                UpdateInfo;
                SortTriangle;
                Draw3D;
            	break;
            end;

    	end else if _ctrl and (Msg.wParam=integer('L')) then begin
            while True do begin
			    apo1:=Point_Sel; if apo1=nil then break;
                apo2:=Point_Sel(apo1); if apo2=nil then break;
                if Point_Sel(apo2)<>nil then break;
				if Line_Find(apo1,apo2)<>nil then break;

                atr:=Triangle_Sel;
                if atr<>nil then begin
                	atr.FSel:=false;
                    atr.UpdateGraph;
                end;
                ali:=Line_Sel;
                if ali<>nil then begin
                	ali.FSel:=false;
                    ali.UpdateGraph;
                end;

				ali:=Line_Add;
                ali.FVerStart:=apo1;
                ali.FVerEnd:=apo2;
                ali.FSel:=true;
                ali.FSelPoint:=-1;
                ali.FColorStart.VDWORD_:=$ffffffff;
                ali.FColorStart.Interpolate;
                ali.FColorEnd.VDWORD_:=$ffffffff;
                ali.FColorEnd.Interpolate;
                ali.UpdateGraph;

			    apo:=Point_First;
    			while apo<>nil do begin
			    	apo.Sel:=false;
    				apo:=apo.FNext;
	    		end;

                UpdateInfo;
                Draw3D;
                break;
            end;

    	end else if (Msg.wParam=VK_LEFT) or (Msg.wParam=VK_RIGHT) then begin
        	if Msg.wParam=VK_LEFT then zn:=2
            else zn:=-2;

            if _shift then zn:=zn*10;
            if _ctrl then zn:=zn/10;

        	Camera_Up:=D3D_Normalize(Camera_Up);
	        m:=D3D_RotateMatrix(Camera_Up,zn*ToRad);
            Camera_Pos:=D3D_TransformVector(m,Camera_Pos);

            UpdateMatrix;
            Point_Update;
            Triangle_UpdateGraph;
            Line_UpdateGraph;
            SortTriangle;
            Draw3D;
	        Handled:=true;

    	end else if (Msg.wParam=VK_UP) or (Msg.wParam=VK_DOWN) then begin
        	if Msg.wParam=VK_UP then zn:=2
            else zn:=-2;

            if _shift then zn:=zn*10;
            if _ctrl then zn:=zn/10;

            v:=D3D_CrossProduct(Camera_Up,Camera_Pos);
        	v:=D3D_Normalize(v);
	        m:=D3D_RotateMatrix(v,zn*ToRad);
            Camera_Pos:=D3D_TransformVector(m,Camera_Pos);
            Camera_Up:=D3D_TransformVector(m,Camera_Up);

            UpdateMatrix;
            Point_Update;
            Triangle_UpdateGraph;
            Line_UpdateGraph;
            SortTriangle;
            Draw3D;
	        Handled:=true;

    	end else if _ctrl and (Msg.wParam=integer('C')) then begin
        	zn:=sqrt(sqr(Camera_Pos.x)+sqr(Camera_Pos.y)+sqr(Camera_Pos.z));
            Camera_Pos:=D3DV(0,0,-zn);
            Camera_Up:=D3DV(0,1,0);

            UpdateMatrix;
            Point_Update;
            Triangle_UpdateGraph;
            Line_UpdateGraph;
            SortTriangle;
            Draw3D;
	        Handled:=true;
            
    	end else if (Msg.wParam=VK_PRIOR) or (Msg.wParam=VK_NEXT) then begin
        	if Msg.wParam=VK_PRIOR then zn:=-100
            else zn:=100;
        	v.x:=Camera_Pos.x-Camera_Des.x;
        	v.y:=Camera_Pos.y-Camera_Des.y;
        	v.z:=Camera_Pos.z-Camera_Des.z;
            r:=sqrt(sqr(v.x)+sqr(v.y)+sqr(v.z));
            Camera_Pos.x:=Camera_Des.x+v.x/r*(r+zn);
            Camera_Pos.y:=Camera_Des.y+v.y/r*(r+zn);
            Camera_Pos.z:=Camera_Des.z+v.z/r*(r+zn);

            UpdateMatrix;
            Point_Update;
            Triangle_UpdateGraph;
            Line_UpdateGraph;
            SortTriangle;
            Draw3D;
	        Handled:=true;
    	end else if (Msg.wParam=VK_HOME) then begin
		    Camera_Pos:=D3DV(0,0,-3500);
		    Camera_Des:=D3DV(0,0,0);
		    Camera_Up:=D3DV(0,1,0);
            
		    UpdateMatrix;
            Point_Update;
            Triangle_UpdateGraph;
            Line_UpdateGraph;
            SortTriangle;
            Draw3D;
	        Handled:=true;
        end;
    end;
end;

procedure TFormMain.ApplicationDeactivate(Sender: TObject);
begin
	if (FMove) or (FRotateCamera) then begin
    	FMove:=false;
        FRotateCamera:=false;

		Screen.Cursor:=crDefault;
		Mouse.Capture:=0;
    end;
end;

function TFormMain.PosToView(pos:TPoint):D3DVECTOR;
begin
	Result.x:=pos.x-GSmeX;
    Result.y:=pos.y-GSmeY;
    Result.z:=0;
end;

procedure TFormMain.CalcPick(mp:TPoint; var vpos:D3DVECTOR; var vdir:D3DVECTOR);
var
	v:D3DVECTOR;
    m:D3DMATRIX;
begin
	D3D_InverseMatrix(Camera_MatProj,m);
    v:=D3DV(mp.x-GSmeX,mp.y-GSmeY,1);
    v:=D3D_TransformVector(m,v);

	D3D_InverseMatrix(Camera_MatView,m);

    vdir.x  := v.x*m.m[0,0] + v.y*m.m[1,0] + v.z*m.m[2,0];
    vdir.y  := v.x*m.m[0,1] + v.y*m.m[1,1] + v.z*m.m[2,1];
    vdir.z  := v.x*m.m[0,2] + v.y*m.m[1,2] + v.z*m.m[2,2];

    vdir:=D3D_Normalize(vdir);

	vpos.x := m.m[3,0];
    vpos.y := m.m[3,1];
    vpos.z := m.m[3,2];
end;

function TFormMain.CalcWorld(mp:TPoint; z:single; var des:D3DVECTOR):boolean;
var
    vpos,vdir:D3DVECTOR;
    pn:D3DVECTOR;
    pd:single;
    vd,t:single;
begin
	CalcPick(mp,vpos,vdir);

    pn:=D3DV(0,0,1);
    pd:=z;

    vd:=D3D_DotProduct(pn,vdir);
    if abs(vd)<0.0001 then begin Result:=false; Exit; end;
	t:=-(D3D_DotProduct(pn,vpos)+pd)/vd;

    des.x:=vpos.x+vdir.x*t;
    des.y:=vpos.y+vdir.y*t;
    des.z:=vpos.z+vdir.z*t;

    Result:=true;
end;

function TFormMain.CalcWorld(mp:TPoint; var des:D3DVECTOR):boolean;
var
    pn:D3DVECTOR;
    vpos,vdir:D3DVECTOR;
	atr:TTriangleAB;
    pd:single;
    vd,t:single;
    a,b,c:LPD3DVECTOR;
begin
	CalcPick(mp,vpos,vdir);

	atr:=Triangle_Sel;
    if atr=nil then begin
    	pn:=D3DV(0,0,1);
	    pd:=0;
    end else begin
    	a:=@(atr.FV[0].FVer.FPos);
    	b:=@(atr.FV[1].FVer.FPos);
    	c:=@(atr.FV[2].FVer.FPos);

	    pn.x:=a.y*(b.z-c.z)-b.y*(a.z-c.z)+c.y*(a.z-b.z);
        pn.y:=-(a.x*(b.z-c.z)-b.x*(a.z-c.z)+c.x*(a.z-b.z));
        pn.z:=a.x*(b.y-c.y)-b.x*(a.y-c.y)+c.x*(a.y-b.y);
        pd:=a.x*(b.y*c.z-c.y*b.z)-b.x*(a.y*c.z-c.y*a.z)+c.x*(a.y*b.z-b.y*a.z);
        t:=sqrt(sqr(pn.x)+sqr(pn.y)+sqr(pn.z));
        if abs(t)<0.0001 then begin Result:=false; Exit; end;
        t:=1/t;
        pn.x:=pn.x*t;
        pn.y:=pn.y*t;
        pn.z:=pn.z*t;
        pd:=pd*t;
    end;

    vd:=D3D_DotProduct(pn,vdir);
    if abs(vd)<0.0001 then begin Result:=false; Exit; end;
	t:=-(D3D_DotProduct(pn,vpos)+pd)/vd;

    des.x:=vpos.x+vdir.x*t;
    des.y:=vpos.y+vdir.y*t;
    des.z:=vpos.z+vdir.z*t;

    Result:=true;
end;

function TFormMain.CalcWorld(vpos,vdir:D3DVECTOR; atr:TTriangleAB; var t:single):boolean;
var
    pn:D3DVECTOR;
    pd:single;
    vd:single;
    a,b,c:LPD3DVECTOR;
begin
    	a:=@(atr.FV[0].FVer.FPos);
    	b:=@(atr.FV[1].FVer.FPos);
    	c:=@(atr.FV[2].FVer.FPos);

	    pn.x:=a.y*(b.z-c.z)-b.y*(a.z-c.z)+c.y*(a.z-b.z);
        pn.y:=-(a.x*(b.z-c.z)-b.x*(a.z-c.z)+c.x*(a.z-b.z));
        pn.z:=a.x*(b.y-c.y)-b.x*(a.y-c.y)+c.x*(a.y-b.y);
        pd:=a.x*(b.y*c.z-c.y*b.z)-b.x*(a.y*c.z-c.y*a.z)+c.x*(a.y*b.z-b.y*a.z);
        t:=sqrt(sqr(pn.x)+sqr(pn.y)+sqr(pn.z));
        if abs(t)<0.0001 then begin Result:=false; Exit; end;
        t:=1/t;
        pn.x:=pn.x*t;
        pn.y:=pn.y*t;
        pn.z:=pn.z*t;
        pd:=pd*t;

    vd:=D3D_DotProduct(pn,vdir);
    if abs(vd)<0.0001 then begin Result:=false; Exit; end;
	t:=-(D3D_DotProduct(pn,vpos)+pd)/vd;

    Result:=true;
end;

function TFormMain.PickTriangle(mp:TPoint):TList;
var
	li:TList;
	atr:TTriangleAB;
    vpos,vdir:D3DVECTOR;
    t,u,v:single;
    i:integer;
begin
	li:=TList.Create;

    CalcPick(mp,vpos,vdir);

    atr:=Triangle_First;
    while atr<>nil do begin
	    if D3D_IntersectTriangle(vpos,vdir,atr.FV[1].FVer.FPos,atr.FV[0].FVer.FPos,atr.FV[2].FVer.FPos,t,u,v) or
           D3D_IntersectTriangle(vpos,vdir,atr.FV[0].FVer.FPos,atr.FV[1].FVer.FPos,atr.FV[2].FVer.FPos,t,u,v) then
        begin

        	if t>0 then begin
		        atr.FPickT:=t;

    	        i:=0;
        	    while i<li.Count do begin
            		if TTriangleAB(li.Items[i]).FPickT>t then break;
                	inc(i);
	            end;
    	        li.Insert(i,atr);
            end;
        end;

    	atr:=atr.FNext;
    end;

    if li.Count<=0 then begin li.Free; li:=nil; end;
    Result:=li;
end;

function TFormMain.PickTrianglePlane(mp:TPoint):TList;
var
	li:TList;
	atr:TTriangleAB;
    vpos,vdir:D3DVECTOR;
    t:single;
    i:integer;
begin
	li:=TList.Create;

    CalcPick(mp,vpos,vdir);

    atr:=Triangle_First;
    while atr<>nil do begin
	    if CalcWorld(vpos,vdir,atr,t) then
{	    if D3D_IntersectTriangle(vpos,vdir,atr.FV[1].FVer.FPos,atr.FV[0].FVer.FPos,atr.FV[2].FVer.FPos,t,u,v) or
           D3D_IntersectTriangle(vpos,vdir,atr.FV[0].FVer.FPos,atr.FV[1].FVer.FPos,atr.FV[2].FVer.FPos,t,u,v) then}
        begin

        	if t>0 then begin
		        atr.FPickT:=t;

    	        i:=0;
        	    while i<li.Count do begin
            		if TTriangleAB(li.Items[i]).FPickT>t then break;
                	inc(i);
	            end;
    	        li.Insert(i,atr);
            end;
        end;

    	atr:=atr.FNext;
    end;

    if li.Count<=0 then begin li.Free; li:=nil; end;
    Result:=li;
end;

function TFormMain.PickLine(mp:TPoint):TList;
var
	li:TList;
    ali:TLineAB;
begin
	li:=TList.Create;

    ali:=Line_First;
    while ali<>nil do begin
    	if ali.Hit(mp) then li.Add(ali);
    	ali:=ali.FNext;
    end;

    if li.Count<=0 then begin li.Free; li:=nil; end;
    Result:=li;
end;

function TFormMain.CurKey:TKeyAB;
var
    atr:TTriangleAB;
    ali:TLineAB;
begin
	Result:=nil;

	ali:=Line_Sel;
    if ali<>nil then begin
    	if ali.FSelPoint=0 then Result:=ali.FColorStart
        else if ali.FSelPoint=1 then Result:=ali.FColorEnd;
    end;
	atr:=Triangle_Sel;
	if atr<>nil then begin
    	if atr.FSelPoint>=0 then Result:=atr.FV[atr.FSelPoint].FColor;
    end;
end;

function TFormMain.CalcTexCoord(mp:TPoint; var u:single; var v:single):boolean;
var
	pp:D3DVECTOR;
    atr:TTriangleAB;
    p1,p2,p3:LPD3DVECTOR;
    l1,l2,l3:D3DVECTOR;
    l1_l,l2_l,l3_l,pps_l:single;
    pr_in_l1:single;
    u1,v1,u2,v2,u3,v3:single;
    u_l1,v_l1,u_l2,v_l2:single;
    t,ca1,ca2:single;
//    t1,t2:single;
    pps:D3DVECTOR;
    k1:D3DVECTOR;
    e1,e2:D3DVECTOR;
begin
	Result:=false;

    atr:=Triangle_Sel;
    if (atr=nil) then Exit;

	if not CalcWorld(mp,pp) then Exit;

	p1:=@(atr.FV[0].FVer.FPos);
    p2:=@(atr.FV[1].FVer.FPos);
    p3:=@(atr.FV[2].FVer.FPos);
    u1:=atr.FV[0].FU; v1:=atr.FV[0].FV;
    u2:=atr.FV[1].FU; v2:=atr.FV[1].FV;
    u3:=atr.FV[2].FU; v3:=atr.FV[2].FV;

    l1.x:=p2.x-p1.x; l1.y:=p2.y-p1.y; l1.z:=p2.z-p1.z;
    l2.x:=p3.x-p1.x; l2.y:=p3.y-p1.y; l2.z:=p3.z-p1.z;
    pps.x:=pp.x-p1.x; pps.y:=pp.y-p1.y; pps.z:=pp.z-p1.z;

    l1_l:=sqrt(sqr(l1.x)+sqr(l1.y)+sqr(l1.z));
    if l1_l<0.00001 then Exit;
    l2_l:=sqrt(sqr(l2.x)+sqr(l2.y)+sqr(l2.z));
    if l2_l<0.00001 then Exit;
    pps_l:=sqrt(sqr(pps.x)+sqr(pps.y)+sqr(pps.z));
    if pps_l<0.00001 then Exit;

    pr_in_l1:=D3D_DotProduct(l1,pps)/l1_l;
    t:=pr_in_l1/l1_l;
    u_l1:=u1+t*(u2-u1);
    v_l1:=v1+t*(v2-v1);
    k1.x:=t*l1.x; k1.y:=t*l1.y; k1.z:=t*l1.z;
//    t1:=t;

    ca1:=D3D_DotProduct(l1,pps)/(l1_l*pps_l);
    ca2:=D3D_DotProduct(l1,l2)/(l1_l*l2_l);
    t:=(ca1*pps_l)/(ca2);
    l3.x:=(l2.x/l2_l)*t;
    l3.y:=(l2.y/l2_l)*t;
    l3.z:=(l2.z/l2_l)*t;
    l3_l:=sqrt(sqr(l3.x)+sqr(l3.y)+sqr(l3.z));
    if l3_l<0.00001 then Exit;

//    t:=l3_l/l2_l;
	if (l2.x<>0) then t:=l3.x/l2.x
    else if (l2.y<>0) then t:=l3.y/l2.y
    else t:=l3.z/l2.z;

    u_l2:=u1+t*(u3-u1);
    v_l2:=v1+t*(v3-v1);
//    t2:=t;

    e1.x:=l3.x-k1.x; e1.y:=l3.y-k1.y; e1.z:=l3.z-k1.z;
    e2.x:=pps.x-k1.x; e2.y:=pps.y-k1.y; e2.z:=pps.z-k1.z;

{    t:=sqrt(sqr(e2.x)+sqr(e2.y)+sqr(e2.z))/
       sqrt(sqr(e1.x)+sqr(e1.y)+sqr(e1.z));
    if D3D_DotProduct(e1,e2)/sqrt(sqr(e1.x)+sqr(e1.y)+sqr(e1.z))<0 then t:=-t;}
//    t:=(D3D_DotProduct(e1,e2)/sqrt(sqr(e1.x)+sqr(e1.y)+sqr(e1.z)))/sqrt(sqr(e1.x)+sqr(e1.y)+sqr(e1.z));
    t:=D3D_DotProduct(e1,e2)/(sqr(e1.x)+sqr(e1.y)+sqr(e1.z));

    u:=u_l1+t*(u_l2-u_l1);
    v:=v_l1+t*(v_l2-v_l1);

//Edit1.Text:=Format('%.3f,%.3f    %.3f,%.3f      %.3f,%.3f   ca1=%.2f ca2=%.2f l3=(%.2f,%.2f,%.2f) t1=%.2f t2=%.2f t3=%.2f t4=%.2f',[u_l1,v_l1,u_l2,v_l2,u,v,ArcCos(ca1)*ToGrad,ArcCos(ca2)*ToGrad,l3.x,l3.y,l3.z,t1,t2,t,D3D_DotProduct(e1,e2)/sqrt(sqr(l3.x-k1.x)+sqr(l3.y-k1.y)+sqr(l3.z-k1.z))]);

	result:=true;
end;

procedure TFormMain.Panel3DMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
	v:D3DVECTOR;
    apo:TPointAB;
    atr:TTriangleAB;
    ali:TLineAB;
    li:TList;
    i:integer;
    zn,zn2:single;
begin
	ActiveControl:=nil;

	v:=PosToView(Point(x,y));

    if (Button=mbLeft) and (not FMove) and (not FRotateCamera) then begin
	    atr:=Triangle_Sel;
        ali:=Line_Sel;

        if (atr<>nil) and (ssShift in Shift) then begin
        	zn:=sqr(atr.FV[0].FVer.FPosShow.x-v.x)+sqr(atr.FV[0].FVer.FPosShow.y-v.y); i:=0;
            zn2:=sqr(atr.FV[1].FVer.FPosShow.x-v.x)+sqr(atr.FV[1].FVer.FPosShow.y-v.y); if zn2<zn then begin zn:=zn2; i:=1; end;
            zn2:=sqr(atr.FV[2].FVer.FPosShow.x-v.x)+sqr(atr.FV[2].FVer.FPosShow.y-v.y); if zn2<zn then i:=2;

            atr.FSelPoint:=i;
            atr.UpdateGraph;

            apo:=Point_First;
            while apo<>nil do begin
				apo.Sel:=false;
    			apo:=apo.FNext;
            end;

        end else if (ali<>nil) and (ssShift in Shift) then begin
        	zn:=sqr(ali.FVerStart.FPosShow.x-v.x)+sqr(ali.FVerStart.FPosShow.y-v.y); i:=0;
            zn2:=sqr(ali.FVerEnd.FPosShow.x-v.x)+sqr(ali.FVerEnd.FPosShow.y-v.y); if zn2<zn then begin {zn:=zn2;} i:=1; end;

            ali.FSelPoint:=i;
            ali.UpdateGraph;

        end else begin

		    if not (ssCtrl in Shift) then begin
			    apo:=Point_First;
    			while apo<>nil do begin
			    	apo.Sel:=false;
    				apo:=apo.FNext;
	    		end;
		    end;

    		apo:=Point_NerestShow(v,20);
	    	if apo<>nil then begin
    			if not (ssCtrl in Shift) then apo.Sel:=True
	        	else apo.Sel:=not apo.Sel;
		    end;

			ali:=Line_Sel;
            if apo=nil then begin
				li:=PickLine(Point(x,y));
                if li<>nil then begin
            	    i:=li.IndexOf(atr)+1;
	                if i>=li.Count then i:=0;

	        	    if ali<>nil then begin
        	        	ali.FSel:=false;
    	                ali.UpdateGraph;
	                end;

    	            ali:=li.Items[i];
        	        ali.FSel:=true;
		            ali.FSelPoint:=-1;
	                ali.UpdateGraph;

    	        	li.Free;
                end else begin
	        	    if ali<>nil then begin
        	        	ali.FSel:=false;
    	                ali.UpdateGraph;
	                end;
                end;
            end else begin
	            if ali<>nil then begin
                	ali.FSel:=false;
                    ali.UpdateGraph;
                end;
            end;

        	if (apo<>nil) or (ali<>nil) or (ssCtrl in Shift) then begin
            	if (apo<>nil) and (atr<>nil) and (atr.FSelPoint>=0) then begin
	                atr.FSelPoint:=-1;
                    atr.UpdateGraph;
                end;
                if ali<>nil then begin
		        	atr:=Triangle_Sel;
    		        if atr<>nil then begin
        		    	atr.FSel:=false;
	        	        atr.UpdateGraph;
    	        	end;
                end;
	        end else begin
				li:=PickTriangle(Point(x,y));
        	    if li<>nil then begin
            	    i:=li.IndexOf(atr)+1;
	                if i>=li.Count then i:=0;

	    	        if atr<>nil then begin
    	    	    	atr.FSel:=false;
        	    	    atr.UpdateGraph;
	            	end;

    	            atr:=li.Items[i];
        	        atr.FSel:=true;
            	    atr.FSelPoint:=-1;
	                atr.UpdateGraph;

    	        	li.Free;
        	    end else begin
	        	    if atr<>nil then begin
    	        		atr.FSel:=false;
	        	        atr.UpdateGraph;
    	        	end;
        	    end;
	        end;
		end;

	    if CurKey<>nil then CurKey.FCur:=CurKey.NearestKey(Key_Time);

        UpdateInfo;
        UpdateITime;
        SortTriangle;
        Draw3D;

    end else if Button=mbRight then begin
    	if Point_Sel<>nil then begin
			FMove:=true;
			FMoveLP:=Point(x,y);

	        Screen.Cursor:=crSizeAll;
	        Mouse.Capture:=Panel3D.Handle;

    	end else if (Triangle_Sel<>nil) and (Triangle_Sel.FSelPoint>=0) then begin
			FMove:=true;
			FMoveLP:=Point(x,y);

	        Screen.Cursor:=crSizeAll;
	        Mouse.Capture:=Panel3D.Handle;

        end else begin
	        FRotateCamera:=true;
			FMoveLP:=Point(x,y);

	        Screen.Cursor:=crSizeAll;
	        Mouse.Capture:=Panel3D.Handle;

        end;
    end;
end;

procedure TFormMain.Panel3DMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
	if ((FMove) or (FRotateCamera)) and (Button=mbRight) then begin
    	FMove:=false;
        FRotateCamera:=false;

		Screen.Cursor:=crDefault;
		Mouse.Capture:=0;
    end;
end;

procedure TFormMain.Panel3DMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
    apo:TPointAB;
    atr:TTriangleAB;
    v1,v2:D3DVECTOR;
    tu1,tv1,tu2,tv2:single;
    m:D3DMATRIX;
    v:D3DVECTOR;
begin
	if FMove then begin
    	atr:=Triangle_Sel;
    	if Point_Sel<>nil then begin
	    	while True do begin
				if not CalcWorld(FMoveLP,{0,}v1) then break;
				if not CalcWorld(Point(x,y),{0,}v2) then break;

	    		apo:=Point_Sel;
    	    	while apo<>nil do begin
//      	  		apo.Pos:=D3DV(apo.Pos.x+x-FMoveLP.x,apo.Pos.y+y-FMoveLP.y,apo.Pos.z);
        			apo.Pos:=D3DV(apo.Pos.x+v2.x-v1.x,apo.Pos.y+v2.y-v1.y,apo.Pos.z+v2.z-v1.z);
//					apo.Pos:=v2;

			        apo:=Point_Sel(apo);
    		    end;

				FMoveLP:=Point(x,y);

    	    	Triangle_UpdateGraph;
                Line_UpdateGraph;
	        	UpdateInfo;
                SortTriangle;
    	        Draw3D;
        	    break;
	        end;

		end else begin
        	while True do begin
		        if not CalcTexCoord(FMoveLP,tu1,tv1) then break;
		        if not CalcTexCoord(Point(x,y),tu2,tv2) then break;
//Edit1.Text:=Format('%.3f,%.3f,%.3f',[v1.x,v1.y,v1.z]);

				atr.FV[atr.FSelPoint].FU:=atr.FV[atr.FSelPoint].FU+tu1-tu2;
				atr.FV[atr.FSelPoint].FV:=atr.FV[atr.FSelPoint].FV+tv1-tv2;
//				atr.FV[atr.FSelPoint].FU:=tu2;
//				atr.FV[atr.FSelPoint].FV:=tv2;

				FMoveLP:=Point(x,y);

                atr.UpdateGraph;
                UpdateInfo;
                SortTriangle;
                Draw3D;
                break;
            end;
        end;

	end else if FRotateCamera then begin

    	if ssLeft in Shift then begin
        	v.x:=Camera_Des.x-Camera_Pos.x;
        	v.y:=Camera_Des.y-Camera_Pos.y;
        	v.z:=Camera_Des.z-Camera_Pos.z;
            v:=D3D_Normalize(v);
		    m:=D3D_RotateMatrix(v,(FMoveLP.x-x)*0.5*ToRad);
        	Camera_Up:=D3D_TransformVector(m,Camera_Up);
        end else begin
			Camera_Up:=D3D_Normalize(Camera_Up);
		    m:=D3D_RotateMatrix(Camera_Up,(x-FMoveLP.x)*0.5*ToRad);
        	Camera_Pos:=D3D_TransformVector(m,Camera_Pos);

	        v:=D3D_CrossProduct(Camera_Up,Camera_Pos);
    	    v:=D3D_Normalize(v);
	    	m:=D3D_RotateMatrix(v,(y-FMoveLP.y)*0.5*ToRad);
	        Camera_Pos:=D3D_TransformVector(m,Camera_Pos);
    	    Camera_Up:=D3D_TransformVector(m,Camera_Up);
        end;

		FMoveLP:=Point(x,y);

        UpdateMatrix;
        Point_Update;
		Triangle_UpdateGraph;
        Line_UpdateGraph;
        SortTriangle;
        Draw3D;
    end;
end;

procedure TFormMain.EditPointPosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
	apo:TPointAB;
begin
	if Key=VK_RETURN then begin
		apo:=Point_Sel;

        if GetCountParEC(EditPointPos.Text,',')>=3 then begin
	        apo.Pos:=D3DV(StrToFloatEC(GetStrParEC(EditPointPos.Text,0,',')),
			              StrToFloatEC(GetStrParEC(EditPointPos.Text,1,',')),
			              StrToFloatEC(GetStrParEC(EditPointPos.Text,2,',')));

			Triangle_UpdateGraph;
            Line_UpdateGraph;
		end;
    end;
end;

procedure TFormMain.EditPointPortIdChange(Sender: TObject);
var
	apo:TPointAB;
begin
	if FProgUpdate then Exit;

	apo:=Point_Sel;
    apo.FPortId:=TrimEx(EditPointPortId.Text);
    apo.FPortType:=TrimEx(EditPointPortType.Text);
    apo.FPortLink:=TrimEx(EditPointPortLink.Text);
end;

procedure TFormMain.EditPointIdChange(Sender: TObject);
var
	apo:TPointAB;
begin
	if FProgUpdate then Exit;

	apo:=Point_Sel;
    apo.FId:=TrimEx(EditPointId.Text);
end;

procedure TFormMain.ButtonPointDeleteClick(Sender: TObject);
var
	apo:TPointAB;
    li:TList;
    i:integer;
begin
	apo:=Point_Sel;

    li:=Triangle_Find(apo,nil);
    if li<>nil then begin
    	for i:=0 to li.Count-1 do begin
		    Triangle_Delete(li.Items[i]);
        end;
        li.Free;
    end;

    li:=Line_Find(apo);
    if li<>nil then begin
    	for i:=0 to li.Count-1 do begin
		    Line_Delete(li.Items[i]);
        end;
    	li.Free;
    end;

    Point_Delete(apo);

    UpdateInfo;
    SortTriangle;
end;

procedure TFormMain.ButtonTriInvertClick(Sender: TObject);
var
	atr:TTriangleAB;
	apo:TPointAB;
begin
	atr:=Triangle_Sel;
    apo:=atr.FV[0].FVer;
    atr.FV[0].FVer:=atr.FV[1].FVer;
    atr.FV[1].FVer:=apo;

    atr.UpdateGraph;
    UpdateInfo;
end;

procedure TFormMain.ButtonTriDeleteClick(Sender: TObject);
var
	atr:TTriangleAB;
begin
	atr:=Triangle_Sel;

    Triangle_Delete(atr);

    SortTriangle;
    UpdateInfo;
end;

procedure TFormMain.EditTPTexSelect(Sender: TObject);
var
	atr:TTriangleAB;
begin
	if FProgUpdate then Exit;

	atr:=Triangle_Sel;
	if GetCountParEC(EditTPTex.Text,',')>=2 then begin
        atr.FV[atr.FSelPoint].FU:=StrToFloatEC(GetStrParEC(EditTPTex.Text,0,','));
		atr.FV[atr.FSelPoint].FV:=StrToFloatEC(GetStrParEC(EditTPTex.Text,1,','));
	end;
    atr.UpdateGraph;

    UpdateInfo;
	Draw3D;
end;

procedure TFormMain.EditTPTexKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if Key=VK_RETURN then EditTPTexSelect(nil);
end;

procedure TFormMain.EditTPColorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
	atr:TTriangleAB;
begin
	if FProgUpdate then Exit;

	atr:=Triangle_Sel;
	if Key=VK_RETURN then begin
	    if GetCountParEC(EditTPColor.Text,',')>=4 then begin
	        atr.FV[atr.FSelPoint].FColor.VDWORD:=D3DCOLOR_ARGB(
            		StrToIntEC(GetStrParEC(EditTPColor.Text,0,',')),
            		StrToIntEC(GetStrParEC(EditTPColor.Text,1,',')),
            		StrToIntEC(GetStrParEC(EditTPColor.Text,2,',')),
            		StrToIntEC(GetStrParEC(EditTPColor.Text,3,','))
            );
            atr.FV[atr.FSelPoint].FColor.Interpolate;
        end;
	    atr.UpdateGraph;
	    UpdateInfo;
        SortTriangle;
	    Draw3D;
    end;
end;

procedure TFormMain.ScrollBarTPAChange(Sender: TObject);
var
	atr:TTriangleAB;
begin
	if FProgUpdate then Exit;
	atr:=Triangle_Sel;

	atr.FV[atr.FSelPoint].FColor.VDWORD:=D3DCOLOR_ARGB(ScrollBarTPA.Position,ScrollBarTPR.Position,ScrollBarTPG.Position,ScrollBarTPB.Position);
    atr.FV[atr.FSelPoint].FColor.Interpolate;
	atr.UpdateGraph;
    UpdateInfo;
    SortTriangle;
    Draw3D;
end;

procedure TFormMain.EditTriTextureSelect(Sender: TObject);
var
	atr:TTriangleAB;
begin
	if FProgUpdate then Exit;

	atr:=Triangle_Sel;
	atr.FTexture:=TTriangleAB(EditTriTexture.Items.Objects[EditTriTexture.ItemIndex]).FTexture;
    atr.UpdateGraph;
    Draw3D;
end;

procedure TFormMain.EditTriBackFaceClick(Sender: TObject);
var
	atr:TTriangleAB;
begin
	if FProgUpdate then Exit;

	atr:=Triangle_Sel;
    atr.FBackFace:=EditTriBackFace.Checked;
    atr.UpdateGraph;
    Draw3D;
end;

procedure TFormMain.ButtonTriLoadClick(Sender: TObject);
var
	atr:TTriangleAB;
begin
	if not OpenDialogTexture.Execute then Exit;
	atr:=Triangle_Sel;
	atr.FTexture:=TrimEx(OpenDialogTexture.FileName);
    atr.UpdateGraph;
    UpdateInfo;
    Draw3D;
end;

procedure TFormMain.ButtonTriClearClick(Sender: TObject);
var
	atr:TTriangleAB;
begin
	atr:=Triangle_Sel;
	atr.FTexture:='';
    atr.UpdateGraph;
    UpdateInfo;
    SortTriangle;
end;

procedure TFormMain.ButtonLineDeleteClick(Sender: TObject);
var
	ali:TLineAB;
begin
	ali:=Line_Sel;

    Line_Delete(ali);

    UpdateInfo;
end;

procedure TFormMain.Exit1Click(Sender: TObject);
begin
	Close;
end;

procedure TFormMain.SaveAs1Click(Sender: TObject);
var
	bp:TBlockParEC;
begin
	if (Sender<>nil) or (GFileName='') then begin
		SaveDialog1.FileName:=GFileName;
		if not SaveDialog1.Execute then Exit;
	    GFileName:=SaveDialog1.FileName;
    end;

	bp:=TBlockParEC.Create;
    bp.Par_Add('Version','1');
    KeyGroup_Save(bp);
    Point_Save(bp);
    Triangle_Save(bp);
    Line_Save(bp);
    bp.SaveInFile(PChar(AnsiString(GFileName)),true);
    bp.Free;

    UpdateCaption;
end;

procedure TFormMain.Save1Click(Sender: TObject);
begin
	SaveAs1Click(nil);
end;

procedure TFormMain.Load1Click(Sender: TObject);
var
	bp:TBlockParEC;
begin
//MessageBox(Handle,'11','2222',MB_OK or MB_ICONQUESTION);
	if not OpenDialog1.Execute then Exit;

	ClearAll;
    SortTriangle;

	bp:=TBlockParEC.Create;

    try
    	bp.LoadFromFile(PChar(OpenDialog1.FileName));
	    KeyGroup_Load(bp);
        Point_Load(bp);
        Triangle_Load(bp);
        Line_Load(bp);

        GFileName:=OpenDialog1.FileName;
    except
	    GFileName:='';
    	ClearAll;
        ShowMessage('Error load file');
    end;

    bp.Free;

    UpdateCaption;
    SetTime(0);
    Point_Update;
    Triangle_UpdateGraph;
    Line_UpdateGraph;
    SortTriangle;
    Draw3D;
    UpdateITime;
    UpdateInfo;
end;

procedure TFormMain.SetTime(t:integer);
begin
	TBTime.Max:=max(0,Key_CalcFullTime()-1);
	if t<0 then t:=0
    else if t>TBTime.Max then t:=0;//TBTime.Max;
    TBTime.Position:=t;

    TBTime.Enabled:=TBTime.Max>0;

	Key_Time:=t;
    Key_Interpolate;
end;

procedure TFormMain.SortTriangle;
var
	atr:TTriangleAB;
    cntpick:integer;
    lpick:array of TList;
    i,u:integer;
//    x,y,cntx,cnty,step:integer;
	p1,p2,p3:LPD3DVECTOR;
    pc,pt:D3DVECTOR;
    t:single;
begin
	GSortTriangle.Clear;

	cntpick:=Triangle_Count;
    if cntpick<1 then Exit;

    cntpick:=cntpick*7;
    SetLength(lpick,cntpick);

    atr:=Triangle_First;
    i:=0;
    while atr<>nil do begin
		p1:=@(atr.FV[0].FVer.FPosShow);
		p2:=@(atr.FV[1].FVer.FPosShow);
		p3:=@(atr.FV[2].FVer.FPosShow);

        pc.x:=(p1.x+p2.x+p3.x)/3; pc.y:=(p1.y+p2.y+p3.y)/3; pc.z:=(p1.z+p2.z+p3.z)/3;
        lpick[i]:=PickTriangle(Point(Round(pc.x+GSmeX),Round(pc.y+GSmeY)));
    	inc(i);

        t:=0.48;
        while t<1 do begin
	        pt.x:=pc.x+(p1.x-pc.x)*t; pt.y:=pc.y+(p1.y-pc.y)*t; pt.z:=pc.z+(p1.z-pc.z)*t;
    	    lpick[i]:=PickTriangle(Point(Round(pt.x+GSmeX),Round(pt.y+GSmeY)));
    		inc(i);

	        pt.x:=pc.x+(p2.x-pc.x)*t; pt.y:=pc.y+(p2.y-pc.y)*t; pt.z:=pc.z+(p2.z-pc.z)*t;
    	    lpick[i]:=PickTriangle(Point(Round(pt.x+GSmeX),Round(pt.y+GSmeY)));
    		inc(i);

	        pt.x:=pc.x+(p3.x-pc.x)*t; pt.y:=pc.y+(p3.y-pc.y)*t; pt.z:=pc.z+(p3.z-pc.z)*t;
    	    lpick[i]:=PickTriangle(Point(Round(pt.x+GSmeX),Round(pt.y+GSmeY)));
    		inc(i);

            t:=t+0.48;
        end;

    	atr:=atr.FNext;
    end;

(*    step:=20;

    cntx:=Panel3D.Width div step+1;
    cnty:=Panel3D.Height div step+1;
    cntpick:=cntx*cnty;
    SetLength(lpick,cntpick);

    i:=0;
    for y:=0 to cnty-1 do begin
	    for x:=0 to cntx-1 do begin
    	    lpick[i]:=PickTriangle{Plane}(Point(x*step,y*step));
	    	inc(i);
        end;
    end;*)


(*    SetLength(lpick,cntpick);

    atr:=Triangle_First;
    i:=0;
    while atr<>nil do begin
        lpick[i]:=PickTriangle{Plane}(atr.CenterEnd);
    	inc(i);
    	atr:=atr.FNext;
    end;
*)

    while true do begin
        atr:=nil;
    	i:=0;
    	while i<cntpick do begin
        	if lpick[i]=nil then begin inc(i); continue; end;

            atr:=lpick[i].Items[0];

            u:=0;
            while u<cntpick do begin
            	if (lpick[u]<>nil) and (lpick[u].IndexOf(atr)>0) then break;
            	inc(u);
            end;
            if u>=cntpick then break;
            inc(i);
        end;
        if atr=nil then break;

        GSortTriangle.Add(atr);

        for i:=0 to cntpick-1 do begin
        	if lpick[i]=nil then continue;

            u:=lpick[i].IndexOf(atr);
            if u>=0 then begin
            	lpick[i].Delete(u);
                if lpick[i].Count<1 then begin
                	lpick[i].Free;
                    lpick[i]:=nil;
                end;
            end;
        end;
    end;

    lpick:=nil;
end;

procedure TFormMain.ClacTexCoord;
var
	apo:TPointAB;
    atr:TTriangleAB;
    minx,maxx,miny,maxy:single;
    i:integer;
    x,y:single;
begin
	minx:=1e20;
    maxx:=-1e20;
    miny:=1e20;
    maxy:=-1e20;

	apo:=Point_First;
    while apo<>nil do begin
    	if apo.FSel then begin
        	minx:=min(minx,apo.FPosShow.x);
        	miny:=min(miny,apo.FPosShow.y);
        	maxx:=max(maxx,apo.FPosShow.x);
        	maxy:=max(maxy,apo.FPosShow.y);
        end;
    	apo:=apo.FNext;
    end;

    atr:=Triangle_First;
    while atr<>nil do begin
    	if (atr.FV[0].FVer.FSel) and (atr.FV[1].FVer.FSel) and (atr.FV[2].FVer.FSel) then begin
            for i:=0 to High(atr.FV) do begin
            	x:=atr.FV[i].FVer.FPosShow.x;
            	y:=atr.FV[i].FVer.FPosShow.y;
	            atr.FV[i].FU:=(x-minx)/(maxx-minx);
	            atr.FV[i].FV:=(y-miny)/(maxy-miny);
            end;
        end;
    	atr:=atr.FNext;
    end;
end;

procedure TFormMain.MM_Edir_GroupClick(Sender: TObject);
begin
	FormGroup.ShowModal;

    SetTime(Key_Time);
    Point_Update;
    Triangle_UpdateGraph;
    Line_UpdateGraph;
    Draw3D;
    UpdateInfo;
    UpdateITime;
end;

procedure TFormMain.ButtonTPColorKeyClick(Sender: TObject);
var
	atr:TTriangleAB;
begin
	atr:=Triangle_Sel;

	FormKey.FKey:=atr.FV[atr.FSelPoint].FColor;
    FormKey.ShowModal;

    SetTime(FormKey.FKey.CalcTime(FormKey.FKey.FCur));
    Point_Update;
    Triangle_UpdateGraph;
    Line_UpdateGraph;
    Draw3D;
    UpdateInfo;
    UpdateITime;
end;

procedure TFormMain.TBTimeChange(Sender: TObject);
var
    key:TKeyAB;
begin
	SetTime(TBTime.Position);

    key:=CurKey;
    if key<>nil then begin
    	key.FCur:=key.NearestKey(Key_Time);
    end;

    Point_Update;
    Triangle_UpdateGraph;
    Line_UpdateGraph;
    Draw3D;
	UpdateITime;
    UpdateInfo;
end;

procedure TFormMain.EditLPColorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
	ali:TLineAB;
    dw:DWORD;
begin
	if FProgUpdate then Exit;

	ali:=Line_Sel;
	if Key=VK_RETURN then begin
	    if GetCountParEC(EditLPColor.Text,',')>=4 then begin
        	dw:=D3DCOLOR_ARGB(
            		StrToIntEC(GetStrParEC(EditLPColor.Text,0,',')),
            		StrToIntEC(GetStrParEC(EditLPColor.Text,1,',')),
            		StrToIntEC(GetStrParEC(EditLPColor.Text,2,',')),
            		StrToIntEC(GetStrParEC(EditLPColor.Text,3,','))
            );
            if ali.FSelPoint=0 then begin
            	ali.FColorStart.VDWORD:=dw;
                ali.FColorStart.Interpolate;
            end else begin
            	ali.FColorEnd.VDWORD:=dw;
                ali.FColorEnd.Interpolate;
            end;
        end;
	    ali.UpdateGraph;
	    UpdateInfo;
	    Draw3D;
    end;
end;

procedure TFormMain.ScrollBarLPAChange(Sender: TObject);
var
	ali:TLineAB;
    dw:DWORD;
begin
	if FProgUpdate then Exit;
	ali:=Line_Sel;

    dw:=D3DCOLOR_ARGB(ScrollBarLPA.Position,ScrollBarLPR.Position,ScrollBarLPG.Position,ScrollBarLPB.Position);
    if ali.FSelPoint=0 then begin
    	ali.FColorStart.VDWORD:=dw;
        ali.FColorStart.Interpolate;
    end else begin
    	ali.FColorEnd.VDWORD:=dw;
        ali.FColorEnd.Interpolate;
    end;
	ali.UpdateGraph;
    UpdateInfo;
    Draw3D;
end;

procedure TFormMain.ButtonLPColorKeyClick(Sender: TObject);
var
	ali:TLineAB;
begin
	ali:=Line_Sel;

	if ali.FSelPoint=0 then FormKey.FKey:=ali.FColorStart
    else FormKey.FKey:=ali.FColorEnd;
    FormKey.ShowModal;

    SetTime(FormKey.FKey.CalcTime(FormKey.FKey.FCur));
    Point_Update;
    Triangle_UpdateGraph;
    Line_UpdateGraph;
    Draw3D;
    UpdateInfo;
	UpdateITime;
end;

procedure TFormMain.MM_File_ClearClick(Sender: TObject);
begin
	ClearAll;
	GFileName:='';

    SortTriangle;
    SetTime(0);
    Point_Update;
    Triangle_UpdateGraph;
    Line_UpdateGraph;
    Draw3D;
    UpdateInfo;
    UpdateCaption;
end;

procedure TFormMain.EditLineTypeChange(Sender: TObject);
var
	ali:TLineAB;
begin
	ali:=Line_Sel;

    ali.FType:=TrimEx(EditLineType.Text);
end;

procedure TFormMain.ButtonTPCopyClick(Sender: TObject);
begin
	Key_Copy:=Triangle_Sel.FV[Triangle_Sel.FSelPoint].FColor;
end;

procedure TFormMain.ButtonTPPasteClick(Sender: TObject);
begin
	if Key_Copy=Triangle_Sel.FV[Triangle_Sel.FSelPoint].FColor then Exit;
    Triangle_Sel.FV[Triangle_Sel.FSelPoint].FColor.Load(Key_Copy.Save);
	if CurKey<>nil then CurKey.FCur:=CurKey.NearestKey(Key_Time);
    SetTime(Key_Time);
    Point_Update;
    Triangle_UpdateGraph;
    Line_UpdateGraph;
    UpdateInfo;
    UpdateITime;
    Draw3D;
end;

procedure TFormMain.ButtonLPCopyClick(Sender: TObject);
var
	ali:TLineAB;
    key:TKeyAB;
begin
	ali:=Line_Sel;

    if ali.FSelPoint=0 then key:=ali.FColorStart
    else key:=ali.FColorEnd;

	Key_Copy:=key;
end;

procedure TFormMain.ButtonLPPasteClick(Sender: TObject);
var
	ali:TLineAB;
    key:TKeyAB;
begin
	ali:=Line_Sel;

    if ali.FSelPoint=0 then key:=ali.FColorStart
    else key:=ali.FColorEnd;

    key.Load(Key_Copy.Save);
	if CurKey<>nil then CurKey.FCur:=CurKey.NearestKey(Key_Time);
    SetTime(Key_Time);
    Point_Update;
    Triangle_UpdateGraph;
    Line_UpdateGraph;
    UpdateInfo;
    UpdateITime;
    Draw3D;
end;

end.

