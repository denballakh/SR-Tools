program Rangers_ABUnit;

uses
	Windows,
    MMSystem,
  Forms,
  Form_Main in 'Form_Main.pas' {FormMain},
  GR_DirectX3D8 in 'GR_DirectX3D8.pas',
  GR_DirectX in 'GR_DirectX.pas',
  ab_Tex in 'ab_Tex.pas',
  ab_Obj3D in 'ab_Obj3D.pas',
  EC_Thread in 'EC_Thread.pas',
  EC_BlockMem in 'EC_BlockMem.pas',
  EC_BlockPar in 'EC_BlockPar.pas',
  EC_Buf in 'EC_Buf.pas',
  EC_Expression in 'EC_Expression.pas',
  EC_File in 'EC_File.pas',
  EC_Mem in 'EC_Mem.pas',
  EC_Str in 'EC_Str.pas',
  ABPoint in 'ABPoint.pas',
  ABTriangle in 'ABTriangle.pas',
  VOper in 'VOper.pas',
  ABLine in 'ABLine.pas',
  ABKey in 'ABKey.pas',
  Form_Group in 'Form_Group.pas' {FormGroup},
  Global in 'Global.pas',
  Form_Key in 'Form_Key.pas' {FormKey};

{$R *.res}

procedure TimerProc(uTimerID:DWORD; uMessage: DWORD; dwUser:DWORD; dw1, dw2: DWORD) stdcall;
begin
    PostMessage(Application.Handle,$400+123,0,0);
end;

var
    ztimer:DWORD;
begin
	Application.Initialize;
	Application.CreateForm(TFormMain, FormMain);
	Application.CreateForm(TFormGroup, FormGroup);
	Application.CreateForm(TFormKey, FormKey);

	timeBeginPeriod(1);
    ztimer:=timeSetEvent(20,1,@TimerProc,0,TIME_PERIODIC or TIME_CALLBACK_FUNCTION);

	Application.Run;

    timeKillEvent(ztimer);
    timeEndPeriod(1);
end.
