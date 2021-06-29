unit FormSaveGI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, ToolEdit,GraphBuf;

type
  TForm_SaveGI = class(TForm)
    Label1: TLabel;
    EditFile: TEdit;
    SpeedButton1: TSpeedButton;
    SaveDialog1: TSaveDialog;
    Label2: TLabel;
    ComboBoxFormat: TComboBox;
    ButtonSave: TButton;
    ButtonClose: TButton;
    MemoText: TMemo;
    Label3: TLabel;
    DirectoryEditDir: TDirectoryEdit;
    CheckBoxAll: TCheckBox;
    CheckBoxAutoSize: TCheckBox;
    Label4: TLabel;
    ComboBoxPF: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxAllClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SaveImage(gb:TGraphBuf; filename:string; fformat:integer; pf:integer; autosize:boolean);
  end;

var
  Form_SaveGI: TForm_SaveGI;

implementation

uses EC_Mem,EC_Str,EC_File,EC_Buf,FormMain,GraphBufList,Globals;

{$R *.DFM}

procedure TForm_SaveGI.FormCreate(Sender: TObject);
begin
    ComboBoxFormat.ItemIndex:=1;
    ComboBoxPF.ItemIndex:=1;
end;

procedure TForm_SaveGI.FormShow(Sender: TObject);
begin
    EditFile.Text:=SaveDialog1.InitialDir+GBufList.CurHist.FName+'.gi';

    DirectoryEditDir.Text:=RegUser_GetString('','SaveGIAllPath',GetCurrentDir);
    SaveDialog1.InitialDir:=RegUser_GetString('','SaveGISinglePath',GetCurrentDir);
end;

procedure TForm_SaveGI.FormHide(Sender: TObject);
begin
    RegUser_SetString('','SaveGIAllPath',File_Path(DirectoryEditDir.Text));
end;

procedure TForm_SaveGI.SpeedButton1Click(Sender: TObject);
begin
    SaveDialog1.FileName:=EditFile.Text;
    if not SaveDialog1.Execute then Exit;
    EditFile.Text:=SaveDialog1.FileName;

    RegUser_SetString('','SaveGISinglePath',File_Path(SaveDialog1.FileName));
end;

procedure TForm_SaveGI.CheckBoxAllClick(Sender: TObject);
begin
    DirectoryEditDir.Visible:=CheckBoxAll.Checked;
    Label3.Visible:=CheckBoxAll.Checked;
    EditFile.Visible:=not CheckBoxAll.Checked;
    Label1.Visible:=not CheckBoxAll.Checked;
    SpeedButton1.Visible:=not CheckBoxAll.Checked;
end;

procedure TForm_SaveGI.ButtonSaveClick(Sender: TObject);
var
    i:integer;
begin
    Screen.Cursor:=crHourglass;
    MemoText.Clear;

    try
        if not CheckBoxAll.Checked then begin
            SaveImage(GBufList.CurHist.CurBuf,EditFile.Text,ComboBoxFormat.ItemIndex,ComboBoxPF.ItemIndex,CheckBoxAutoSize.Checked);
        end else begin
            for i:=0 to GBufList.Count-1 do begin
                SaveImage(GBufList.Hist[i].CurBuf,DirectoryEditDir.Text+'\'+GBufList.Hist[i].FName+'.gi',ComboBoxFormat.ItemIndex,ComboBoxPF.ItemIndex,CheckBoxAutoSize.Checked);
            end;
        end;
    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;

    Screen.Cursor:=crDefault;
end;

procedure TForm_SaveGI.SaveImage(gb:TGraphBuf; filename:string; fformat:integer; pf:integer; autosize:boolean);
var
    u:integer;
    bd:TBufEC;
    zaggi:PGIZag;
    giunit:PGIUnit;
    tstr:string;
begin
    bd:=TBufEC.Create;
    try
        if fformat=0 then begin
//            gb.SwapChannels(0,2);
            gb.BuildGI_Bitmap(bd,pf);
//            gb.SwapChannels(0,2);
        end else if fformat=1 then begin
            gb.BuildGI_Trans(bd,autosize);
        end else if fformat=2 then begin
            gb.BuildGI_Alpha(bd,autosize);
        end else if fformat=3 then begin
            gb.BuildGI_AlphaIndexed8(bd,autosize);
        end else if fformat=4 then begin
            gb.BuildGI_BitmapPal(bd);
        end;

        zaggi:=bd.Buf;

        tstr:=Format('%s'#9,[filename]);
        giunit:=PAdd(bd.Buf,sizeof(SGIZag));
        for u:=0 to zaggi.countUnit-1 do begin
            tstr:=tstr+Format('   Buf%d={%d,(%d,%d,%d,%d)}',[u,giunit.size,giunit.rect.Left,giunit.rect.Top,giunit.rect.Right,giunit.rect.Bottom]);
            giunit:=PAdd(giunit,sizeof(SGIUnit));
        end;

        MemoText.Lines.Add(tstr);

        bd.SaveInFile(PChar(filename));
    finally
        bd.Free;
    end;
end;

end.
