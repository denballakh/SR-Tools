unit FormCutOffAlpha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm_CutOffAlpha = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    ButtonBuild: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    CheckBoxAll: TCheckBox;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_CutOffAlpha: TForm_CutOffAlpha;

implementation

uses EC_Mem,EC_Str,FormMain,GraphBuf,GraphBufList,OImage;

{$R *.DFM}

procedure TForm_CutOffAlpha.ButtonCancelClick(Sender: TObject);
begin
    Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    GBufList.CurHist.DelBuf(GBufList.CurHist.FCur);
    Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    Form_Main.RenderImage;
    Form_Main.UpdateImage;
    ModalResult := mrCancel;
end;

procedure TForm_CutOffAlpha.ButtonOkClick(Sender: TObject);
begin
    ModalResult := mrOk;
end;

procedure TForm_CutOffAlpha.ButtonBuildClick(Sender: TObject);
var
    i:integer;
begin
    Screen.Cursor:=crHourglass;
    try
        if not CheckBoxAll.Checked then begin
            Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
            OCutOffAlpha(GBufList.CurHist.Buf[GBufList.CurHist.FCur-1],GBufList.CurHist.Buf[GBufList.CurHist.FCur],StrToIntEC(Edit1.Text));
            Form_Main.RenderImage;
            Form_Main.UpdateImage;
        end else begin
            for i:=0 to GBufList.Count-1 do begin
                if GBufList.Hist[i]=GBufList.CurHist then begin
                    OCutOffAlpha(GBufList.CurHist.Buf[GBufList.CurHist.FCur-1],GBufList.CurHist.Buf[GBufList.CurHist.FCur],StrToIntEC(Edit1.Text));
                end else begin
                    GBufList.Hist[i].NewModify;
                    OCutOffAlpha(GBufList.Hist[i].Buf[GBufList.Hist[i].FCur-1],GBufList.Hist[i].Buf[GBufList.Hist[i].FCur],StrToIntEC(Edit1.Text));
                end;
            end;
            Form_Main.RenderImage(true);
            Form_Main.UpdateImage;
            ModalResult:=mrOk;
        end;
    except
        on ex:Exception do begin
            Screen.Cursor:=crDefault;
            ShowMessage(ex.message);
        end;
    end;
    Screen.Cursor:=crDefault;
end;

end.
