unit ModuleInfo;

interface

uses
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ImgList,
     sButton, sGroupBox, sLabel, sScrollBox, Vcl.ExtCtrls, acImage, acPNG, Vcl.ComCtrls,
     System.ImageList;

type
     TModuleInfoForm = class(TForm)
     CloseButton: TsButton;
     sButton2: TsButton;
     BigButtonsImg: TImageList;
     sGroupBox1: TsGroupBox;
     sScrollBox1: TsScrollBox;
     ModuleNameTitle: TsLabel;
     ModuleNameValue: TsLabel;
     ModuleAuthorTitle: TsLabel;
     ModuleAuthorValue: TsLabel;
     ModuleConflictTitle: TsLabel;
     ModuleConflictValue: TsLabel;
     ModuleDependenceTitle: TsLabel;
     ModuleDependenceValue: TsLabel;
     ModuleFullDescriptionTitle: TsLabel;
     ModuleFullDescriptionValue: TsLabel;
procedure CloseButtonClick(Sender: TObject);
procedure sScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure FormActivate(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
end;

var
    ModuleInfoForm: TModuleInfoForm;

implementation

uses Manager;

{$R *.dfm}

procedure TModuleInfoForm.FormActivate(Sender: TObject);
begin
  sButton2.SetFocus;
end;

procedure TModuleInfoForm.CloseButtonClick(Sender: TObject);
begin
  Close;
  ModuleInfoForm.ModuleNameValue.Caption := '';
  ModuleInfoForm.ModuleAuthorValue.Caption := '';
  ModuleInfoForm.ModuleConflictValue.Caption := '';
  ModuleInfoForm.ModuleDependenceValue.Caption := '';
  ModuleInfoForm.ModuleFullDescriptionValue.Caption := '';
end;

procedure TModuleInfoForm.sScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox1.VertScrollBar.Position := sScrollBox1.VertScrollBar.Position + 10;
end;

procedure TModuleInfoForm.sScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox1.VertScrollBar.Position := sScrollBox1.VertScrollBar.Position - 10;
end;

end.
