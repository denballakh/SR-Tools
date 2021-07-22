unit Notify;

interface

uses
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sLabel, sGroupBox,
     sButton, Vcl.ImgList, System.ImageList;

type
     TNotifyForm = class(TForm)
     sGroupBox1: TsGroupBox;
     TitleNotify: TsLabel;
     TextNotify: TsLabel;
     BigButtonsImg: TImageList;
     CloseButton: TsButton;
procedure CloseButtonClick(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
end;

var
    NotifyForm: TNotifyForm;

implementation

uses Manager;

{$R *.dfm}

procedure TNotifyForm.CloseButtonClick(Sender: TObject);
begin
  Close;
  TitleNotify.Caption := '';
  TextNotify.Caption := '';
end;

end.
