program RScript;

uses
  Forms,
  Form_Main in 'Form_Main.pas' {FormMain},
  GraphUnit in 'GraphUnit.pas',
  Form_RectText in 'Form_RectText.pas' {FormRectText},
  EC_Buf in 'EC_Buf.pas',
  EC_File in 'EC_File.pas',
  EC_Mem in 'EC_Mem.pas',
  EC_Str in 'EC_Str.pas',
  EC_Thread in 'EC_Thread.pas',
  EC_Expression in 'EC_Expression.pas';
  main in 'src\main.pas',
  Form_Star in 'src\Form_Star.pas' {FormStar},
  Form_StarLink in 'src\Form_StarLink.pas' {FormStarLink},
  Form_StarShip in 'src\Form_StarShip.pas' {FormStarShip},
  Form_Planet in 'src\Form_Planet.pas' {FormPlanet},
  Form_Group in 'src\Form_Group.pas' {FormGroup},
  Form_GroupLink in 'src\Form_GroupLink.pas' {FormGroupLink},
  Form_State in 'src\Form_State.pas' {FormState},
  Form_Place in 'src\Form_Place.pas' {FormPlace},
  Form_Item in 'src\Form_Item.pas' {FormItem},
  Form_If in 'src\Form_If.pas' {FormIf},
  Form_ExprInsert in 'src\Form_ExprInsert.pas' {FormExprInsert},
  Form_Op in 'src\Form_Op.pas' {FormOp},
  Form_Var in 'src\Form_Var.pas' {FormVar},
  Form_DialogMsg in 'src\Form_DialogMsg.pas' {FormDialogMsg},
  Form_DialogAnswer in 'src\Form_DialogAnswer.pas' {FormDialogAnswer},
  Form_Dialog in 'src\Form_Dialog.pas' {FormDialog},
  Form_StateLink in 'src\Form_StateLink.pas' {FormStateLink},
  EC_BlockPar in 'EC_BlockPar.pas',
  Form_Build in 'src\Form_Build.pas' {FormBuild},
  Form_Ether in 'src\Form_Ether.pas' {FormEther},
  Global in 'Global.pas',

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormRectText, FormRectText);
  Application.CreateForm(TFormStar, FormStar);
  Application.CreateForm(TFormStarLink, FormStarLink);
  Application.CreateForm(TFormStarShip, FormStarShip);
  Application.CreateForm(TFormPlanet, FormPlanet);
  Application.CreateForm(TFormGroup, FormGroup);
  Application.CreateForm(TFormGroupLink, FormGroupLink);
  Application.CreateForm(TFormState, FormState);
  Application.CreateForm(TFormPlace, FormPlace);
  Application.CreateForm(TFormItem, FormItem);
  Application.CreateForm(TFormIf, FormIf);
  Application.CreateForm(TFormExprInsert, FormExprInsert);
  Application.CreateForm(TFormOp, FormOp);
  Application.CreateForm(TFormVar, FormVar);
  Application.CreateForm(TFormDialogMsg, FormDialogMsg);
  Application.CreateForm(TFormDialogAnswer, FormDialogAnswer);
  Application.CreateForm(TFormDialog, FormDialog);
  Application.CreateForm(TFormStateLink, FormStateLink);
  Application.CreateForm(TFormBuild, FormBuild);
  Application.CreateForm(TFormEther, FormEther);
  Application.Run;
end.
