unit Options;

interface

uses
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sGroupBox, sButton,
     System.ImageList, Vcl.ImgList, sCheckBox, IniFiles, ShellApi, Vcl.Buttons,
     sSpeedButton, ShlObj;

type
     TOptionsForm = class(TForm)
     BigButtonsImg: TImageList;
     sGroupBox1: TsGroupBox;
     StylingCheck: TsCheckBox;
     CloseCheck: TsCheckBox;
     ViewListButton: TsSpeedButton;
     ViewLogButton: TsSpeedButton;
     CloseButton: TsButton;
procedure FormCreate(Sender: TObject);
procedure CloseButtonClick(Sender: TObject);
procedure StylingCheckClick(Sender: TObject);
procedure CloseCheckClick(Sender: TObject);
procedure ViewListButtonClick(Sender: TObject);
procedure ViewLogButtonClick(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
end;

var
    OptionsForm: TOptionsForm;

implementation

{$R *.dfm}

uses Manager;

procedure TOptionsForm.FormCreate(Sender: TObject);
var
    ini: Tinifile;
begin
  ini := TiniFile.Create(ExtractFileDir(Application.ExeName)+'\Universe.ini');
  StylingCheck.Checked := Ini.ReadBool('StylingFlag','Checked', False);
  CloseCheck.Checked := Ini.ReadBool('CloseFlag','Checked', False);
  Ini.Free;
end;

procedure TOptionsForm.CloseButtonClick(Sender: TObject);
begin
  Close;
  ManagerForm.FocusScrollBox;
end;

procedure TOptionsForm.StylingCheckClick(Sender: TObject);
begin
  if StylingCheck.State = cbChecked
  then
  begin
    ManagerForm.sSkinManager1.ExtendedBorders := False;
    ManagerForm.sSkinManager1.AnimEffects.BlendOnMoving.Active := False;
    ManagerForm.Caption := 'Space Rangers Universe (Community)';
    StylingFlag := True;
  end
  else
  begin
    ManagerForm.Caption := '';
    ManagerForm.sSkinManager1.ExtendedBorders := True;
    ManagerForm.sSkinManager1.AnimEffects.BlendOnMoving.Active := True;
    StylingFlag := False;
  end;
end;

procedure TOptionsForm.CloseCheckClick(Sender: TObject);
begin
  if CloseCheck.State = cbChecked then CloseFlag := True
  else CloseFlag := False;
end;

procedure TOptionsForm.ViewListButtonClick(Sender: TObject);
begin
  ShellExecute(Handle,'open','notepad.exe','Mods/ModCFG.txt',nil,SW_SHOWNORMAL);
end;

procedure TOptionsForm.ViewLogButtonClick(Sender: TObject);
var
    PathToDoc: PWideChar;
begin
  PathToDoc := PWideChar(WideString(MyDocPath + '\SpaceRangersHD\########.log'));
  if FileExists(MyDocPath + '\SpaceRangersHD\########.log') then
  ShellExecute(Handle,'open','notepad.exe',PathToDoc,nil,SW_SHOWNORMAL);
end;

end.
