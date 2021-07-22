unit AboutManager;

interface

uses
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
     Vcl.ExtCtrls, sButton, Vcl.ImgList, sLabel, sGroupBox, System.ImageList;

type
     TAboutManagerForm = class(TForm)
     CloseButton: TsButton;
     Title: TsLabel;
     InfoText: TsLabel;
     CompatibilityTitle: TsLabel;
     UseTitle: TsLabel;
     Compatibility: TsLabel;
     sGroupBox1: TsGroupBox;
     BigButtonsImg: TImageList;
procedure CloseButtonClick(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
end;

var
    AboutManagerForm: TAboutManagerForm;

implementation

uses Manager;

{$R *.dfm}

procedure TAboutManagerForm.CloseButtonClick(Sender: TObject);
begin
  Close;
  ManagerForm.FocusScrollBox;
end;

end.
