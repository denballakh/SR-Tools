unit FormRescale;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,GraphBuf, Buttons;

type
  TForm_Rescale = class(TForm)
    ButtonBuild: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EditSizeX: TEdit;
    EditSizeY: TEdit;
    CheckBoxAll: TCheckBox;
    Label3: TLabel;
    ComboBoxFilter: TComboBox;
    CheckBoxXPercent: TCheckBox;
    CheckBoxYPercent: TCheckBox;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FSouHist:integer;
    FSouBuf:integer;
    FDesHist:integer;
    FDesBuf:integer;

    procedure Build(sou,des:TGraphBuf; px:boolean; py:boolean; newsizex,newsizey:single; nomfilter:integer);
  end;

var
  Form_Rescale: TForm_Rescale;

implementation

uses EC_Mem,EC_Str,FormMain,GraphBufList,Globals;

{$R *.DFM}

procedure TForm_Rescale.FormCreate(Sender: TObject);
begin
    ComboBoxFilter.ItemIndex:=5;
end;

procedure TForm_Rescale.FormShow(Sender: TObject);
var
    sou:TGraphBuf;
begin
    FSouHist:=GBufList.FCur;
    FSouBuf:=GBufList.Hist[FSouHist].FCur-1;

    FDesHist:=GBufList.FCur;
    FDesBuf:=GBufList.Hist[FDesHist].FCur;

    sou:=GBufList.Hist[FSouHist].Buf[FSouBuf];

    if not CheckBoxXPercent.Checked then EditSizeX.Text:=IntToStr(sou.FLenX);
    if not CheckBoxYPercent.Checked then EditSizeY.Text:=IntToStr(sou.FLenY);
end;

procedure TForm_Rescale.ButtonOkClick(Sender: TObject);
begin
    Form_Main.FFormModify:=false;
    Hide;
end;

procedure TForm_Rescale.ButtonCancelClick(Sender: TObject);
begin
    Form_Main.FRectUpdate.TestAdd(GBufList.Hist[FDesHist].Buf[FDesBuf].GetRect);
    GBufList.Hist[FDesHist].DelBuf(FDesBuf);
    Form_Main.RenderImage;
    Form_Main.UpdateImage;
    Form_Main.FFormModify:=false;
    Hide;
end;

procedure TForm_Rescale.BitBtn1Click(Sender: TObject);
begin
    EditSizeX.Text:=FloatToStrEC((800/1024)*100);
    EditSizeY.Text:=FloatToStrEC((800/1024)*100);
    CheckBoxXPercent.Checked:=true;
    CheckBoxYPercent.Checked:=true;
end;

procedure TForm_Rescale.ButtonBuildClick(Sender: TObject);
var
    sou,des:TGraphBuf;
    i:integer;
begin
    Screen.Cursor:=crHourglass;

    sou:=GBufList.Hist[FSouHist].Buf[FSouBuf];
    des:=GBufList.Hist[FDesHist].Buf[FDesBuf];

    if not CheckBoxAll.Checked then begin
        Build(sou,des,
              CheckBoxXPercent.Checked,CheckBoxYPercent.Checked,
              StrToFloatEC(EditSizeX.Text),StrToFloatEC(EditSizeY.Text),
              ComboBoxFilter.ItemIndex);
    end else begin
        for i:=0 to GBufList.Count-1 do begin
            if des=GBufList.Hist[i].CurBuf then begin
                Build(sou,des,
                      CheckBoxXPercent.Checked,CheckBoxYPercent.Checked,
                      StrToFloatEC(EditSizeX.Text),StrToFloatEC(EditSizeY.Text),
                      ComboBoxFilter.ItemIndex);
            end else begin
                GBufList.Hist[i].NewModify;
                Build(GBufList.Hist[i].Buf[GBufList.Hist[i].FCur-1],GBufList.Hist[i].CurBuf,
                      CheckBoxXPercent.Checked,CheckBoxYPercent.Checked,
                      StrToFloatEC(EditSizeX.Text),StrToFloatEC(EditSizeY.Text),
                      ComboBoxFilter.ItemIndex);
            end;
        end;
        Form_Main.RenderImage(true);
        Form_Main.UpdateImage;
        Form_Main.FFormModify:=false;
        Hide;
    end;

    Form_Main.FRectUpdate.TestAdd(GBufList.Hist[FDesHist].Buf[FDesBuf].GetRect);
    Form_Main.RenderImage;
    Form_Main.UpdateImage;

    Screen.Cursor:=crDefault;
end;

procedure TForm_Rescale.Build(sou,des:TGraphBuf; px:boolean; py:boolean; newsizex,newsizey:single; nomfilter:integer);
begin
    if px then newsizex:=sou.FLenX*(newsizex/100);
    if py then newsizey:=sou.FLenY*(newsizey/100);
    des.ImageCreate(Round(newsizex),Round(newsizey),sou.FChannels);

    OKGF_Rescale(des.FBuf,des.FLenX,des.FLenY,des.FLenLine,
                 sou.FBuf,sou.FLenX,sou.FLenY,sou.FLenLine,
                 sou.FChannels,nomfilter);
end;

end.
