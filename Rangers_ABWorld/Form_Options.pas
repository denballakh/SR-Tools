unit Form_Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Math;

type
  TFormOptions = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    EditUnitPath: TEdit;
    Label2: TLabel;
    EditRangersPath: TEdit;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    EditWLCount: TEdit;
    Label4: TLabel;
    EditWLFront: TEdit;
    Label5: TLabel;
    EditWLBack: TEdit;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOptions: TFormOptions;

implementation

uses Form_Main, aPathBuild, EC_Str, Global, GR_DirectX3D8;

{$R *.dfm}

procedure TFormOptions.FormShow(Sender: TObject);
begin
  EditUnitPath.Text := GUnitPath;
  EditRangersPath.Text := GRangersPath;

  EditWLCount.Text := IntToStr(GWLCount);
  EditWLFront.Text := Format('%d,%d,%d,%d', [D3DCOLOR_A(GWLFront), D3DCOLOR_R(GWLFront), D3DCOLOR_G(
    GWLFront), D3DCOLOR_B(GWLFront)]);
  EditWLBack.Text := Format('%d,%d,%d,%d', [D3DCOLOR_A(GWLBack), D3DCOLOR_R(GWLBack), D3DCOLOR_G(
    GWLBack), D3DCOLOR_B(GWLBack)]);
end;

procedure TFormOptions.BitBtn1Click(Sender: TObject);
begin
  GUnitPath := LowerCaseEx(BuildPathTrim(EditUnitPath.Text));
  RegUser_SetString('', 'UnitPath', GUnitPath);

  GRangersPath := LowerCaseEx(BuildPathTrim(EditRangersPath.Text));
  RegUser_SetString('', 'RangersPath', GRangersPath);

  GWLCount := max(8, StrToIntEC(EditWLCount.Text));
  RegUser_SetDWORD('', 'WLCount', GWLCount);

  if GetCountParEC(EditWLFront.Text, ',') >= 4 then
  begin
    GWLFront := D3DCOLOR_ARGB(StrToIntEc(GetStrParEC(EditWLFront.Text, 0, ',')),
      StrToIntEc(GetStrParEC(EditWLFront.Text, 1, ',')), StrToIntEc(GetStrParEC(EditWLFront.Text, 2, ',')),
      StrToIntEc(GetStrParEC(EditWLFront.Text, 3, ',')));
    RegUser_SetDWORD('', 'WLFront', GWLFront);
  end;

  if GetCountParEC(EditWLBack.Text, ',') >= 4 then
  begin
    GWLBack := D3DCOLOR_ARGB(StrToIntEc(GetStrParEC(EditWLBack.Text, 0, ',')),
      StrToIntEc(GetStrParEC(EditWLBack.Text, 1, ',')), StrToIntEc(GetStrParEC(EditWLBack.Text, 2, ',')),
      StrToIntEc(GetStrParEC(EditWLBack.Text, 3, ',')));
    RegUser_SetDWORD('', 'WLBack', GWLBack);
  end;
end;

end.