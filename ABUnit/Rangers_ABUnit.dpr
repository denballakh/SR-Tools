program Rangers_ABUnit;

uses
  Windows,
  MMSystem,
  Forms,
  Form_Main in 'Form_Main.pas' {FormMain},
  GR_DirectX3D8 in '..\Rangers_ABWorld\GR_DirectX3D8.pas',
  GR_DirectX in '..\Rangers_ABWorld\GR_DirectX.pas',
  ab_Tex in '..\Rangers_ABWorld\ab_Tex.pas',
  ab_Obj3D in 'ab_Obj3D.pas',
  EC_Thread in '..\Rangers_ABWorld\EC_Thread.pas',
  EC_BlockMem in '..\Rangers_ABWorld\EC_BlockMem.pas',
  EC_BlockPar in '..\Rangers_ABWorld\EC_BlockPar.pas',
  EC_Buf in '..\Rangers_ABWorld\EC_Buf.pas',
  EC_Expression in '..\Rangers_ABWorld\EC_Expression.pas',
  EC_File in '..\Rangers_ABWorld\EC_File.pas',
  EC_Mem in '..\Rangers_ABWorld\EC_Mem.pas',
  EC_Str in '..\Rangers_ABWorld\EC_Str.pas',
  ABPoint in 'ABPoint.pas',
  ABTriangle in 'ABTriangle.pas',
  VOper in '..\Rangers_ABWorld\VOper.pas',
  ABLine in 'ABLine.pas',
  ABKey in 'ABKey.pas',
  Form_Group in 'Form_Group.pas' {FormGroup},
  Global in 'Global.pas',
  Form_Key in 'Form_Key.pas' {FormKey};

{$R *.res}

procedure TimerProc(uTimerID: DWORD; uMessage: DWORD; dwUser: DWORD; dw1, dw2: DWORD) stdcall;
begin
  PostMessage(Application.Handle, $400 + 123, 0, 0);
end;

var
  ztimer: DWORD;
begin
  Application.Initialize;
  Application.Title := 'ABUnit';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormGroup, FormGroup);
  Application.CreateForm(TFormKey, FormKey);

  timeBeginPeriod(1);
  ztimer := timeSetEvent(20, 1, @TimerProc, 0, TIME_PERIODIC or TIME_CALLBACK_FUNCTION);

  Application.Run;

  timeKillEvent(ztimer);
  timeEndPeriod(1);
end.