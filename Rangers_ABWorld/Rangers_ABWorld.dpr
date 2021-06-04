program Rangers_ABWorld;

uses
  Windows,
  MMSystem,
  Forms,
  Form_Main in 'Form_Main.pas' {FormMain},
  EC_BlockMem in 'EC_BlockMem.pas',
  EC_BlockPar in 'EC_BlockPar.pas',
  EC_Buf in 'EC_Buf.pas',
  EC_Expression in 'EC_Expression.pas',
  EC_File in 'EC_File.pas',
  EC_Mem in 'EC_Mem.pas',
  EC_Str in 'EC_Str.pas',
  EC_Thread in 'EC_Thread.pas',
  GR_DirectX in '..\Rangers_ABUnit\GR_DirectX.pas',
  GR_DirectX3D8 in '..\Rangers_ABUnit\GR_DirectX3D8.pas',
  ABTriangle in 'ABTriangle.pas',
  ab_Obj3D in 'ab_Obj3D.pas',
  ab_Tex in 'ab_Tex.pas',
  ABLine in 'ABLine.pas',
  ABPoint in 'ABPoint.pas',
  VOper in '..\Rangers_ABUnit\VOper.pas',
  Global in 'Global.pas',
  aMyFunction in 'aMyFunction.pas',
  WorldLine in 'WorldLine.pas',
  WorldUnit in 'WorldUnit.pas',
  DebugMsg in 'DebugMsg.pas',
  ABKey in 'ABKey.pas',
  WorldZone in 'WorldZone.pas',
  Form_Options in 'Form_Options.pas' {FormOptions},
  aPathBuild in 'aPathBuild.pas',
  Form_SaveEnd in 'Form_SaveEnd.pas' {FormSaveEnd},
  Form_About in 'Form_About.pas' {FormAbout},
  ABOpt in 'ABOpt.pas',
  Form_UnitPath in 'Form_UnitPath.pas' {FormUnitPath};



{$R *.res}

procedure TimerProc(uTimerID:DWORD; uMessage: DWORD; dwUser:DWORD; dw1, dw2: DWORD) stdcall;
//var
//	msg:TMsg;
begin
//	if not PeekMessage(msg,Application.Handle,0,0,PM_NOREMOVE) then begin
	    PostMessage(Application.Handle,$400+123,0,0);
//    end;
end;

var
    ztimer:DWORD;
begin
	Application.Initialize;
	Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormOptions, FormOptions);
  Application.CreateForm(TFormSaveEnd, FormSaveEnd);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormUnitPath, FormUnitPath);
  timeBeginPeriod(1);
    ztimer:=timeSetEvent(20,1,@TimerProc,0,TIME_PERIODIC or TIME_CALLBACK_FUNCTION);
	Application.Run;
    timeKillEvent(ztimer);
    timeEndPeriod(1);
end.
