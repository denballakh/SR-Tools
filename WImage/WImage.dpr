program WImage;

uses
  Forms,
  FormMain in 'FormMain.pas' {Form_Main},
  GraphBuf in 'GraphBuf.pas',
  EC_Mem in 'EC_Mem.pas',
  GraphBufList in 'GraphBufList.pas',
  GraphBufHist in 'GraphBufHist.pas',
  Globals in 'Globals.pas',
  GR_Rect in 'GR_Rect.pas',
  OImage in 'OImage.pas',
  FormCorrectImageByAlpha in 'FormCorrectImageByAlpha.pas' {Form_CorrectImageByAlpha},
  EC_File in 'EC_File.pas',
  EC_Buf in 'EC_Buf.pas',
  FormDifferent in 'FormDifferent.pas' {Form_Different},
  FormCutOffAlpha in 'FormCutOffAlpha.pas' {Form_CutOffAlpha},
  FormFillAlpha in 'FormFillAlpha.pas' {Form_FillAlpha},
  FormOperation in 'FormOperation.pas' {Form_Operation},
  SelectLine in 'SelectLine.pas',
  FormSelectAlpha in 'FormSelectAlpha.pas' {Form_SelectAlpha},
  FormInfoProject in 'FormInfoProject.pas' {Form_InfoProject},
  FormSaveGAI in 'FormSaveGAI.pas' {Form_SaveGAI},
  FormSaveGI in 'FormSaveGI.pas' {Form_SaveGI},
  FormBuildGAIAnim in 'FormBuildGAIAnim.pas' {Form_BuildGAIAnim},
  FormSplitLineDiv in 'FormSplitLineDiv.pas' {FormSplitLineDivForm},
  FromBuildGAIGroup in 'FromBuildGAIGroup.pas' {Form_BuildGAIGroup},
  FormRescale in 'FormRescale.pas' {Form_Rescale},
  FormScript in 'FormScript.pas' {Form_Script},
  EC_Expression in 'EC_Expression.pas',
  EC_Thread in 'EC_Thread.pas',
  GAIBuild in 'GAIBuild.pas',
  FormCorrectAlpha in 'FormCorrectAlpha.pas' {Form_CorrectAlpha},
  FormBuildGAIExAnim in 'FormBuildGAIExAnim.pas' {Form_BuildGAIExAnim};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'WImage';
  Application.CreateForm(TForm_Main, Form_Main);
  Application.CreateForm(TForm_CorrectImageByAlpha, Form_CorrectImageByAlpha);
  Application.CreateForm(TForm_Different, Form_Different);
  Application.CreateForm(TForm_CutOffAlpha, Form_CutOffAlpha);
  Application.CreateForm(TForm_FillAlpha, Form_FillAlpha);
  Application.CreateForm(TForm_Operation, Form_Operation);
  Application.CreateForm(TForm_SelectAlpha, Form_SelectAlpha);
  Application.CreateForm(TForm_InfoProject, Form_InfoProject);
  Application.CreateForm(TForm_SaveGAI, Form_SaveGAI);
  Application.CreateForm(TForm_SaveGI, Form_SaveGI);
  Application.CreateForm(TForm_BuildGAIAnim, Form_BuildGAIAnim);
  Application.CreateForm(TFormSplitLineDivForm, FormSplitLineDivForm);
  Application.CreateForm(TForm_BuildGAIGroup, Form_BuildGAIGroup);
  Application.CreateForm(TForm_Rescale, Form_Rescale);
  Application.CreateForm(TForm_Script, Form_Script);
  Application.CreateForm(TForm_CorrectAlpha, Form_CorrectAlpha);
  Application.CreateForm(TForm_BuildGAIExAnim, Form_BuildGAIExAnim);
  Application.Run;
end.
