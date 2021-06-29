unit FormInfoProject;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm_InfoProject = class(TForm)
    MemoText: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    EditMaskName: TEdit;
    ButtonName: TButton;
    EditSme: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ButtonNameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_InfoProject: TForm_InfoProject;

implementation

uses EC_Mem,EC_Str,FormMain,GraphBuf,GraphBufList,Globals;

{$R *.DFM}

procedure TForm_InfoProject.Button3Click(Sender: TObject);
var
    i:integer;
    tstr:string;
    sx,sy:integer;
begin
    sx:=0;
    sy:=0;
    if GetCountParEC(EditSme.Text,',')>=2 then begin
        sx:=StrToInt(GetStrParEC(EditSme.Text,0,','));
        sy:=StrToInt(GetStrParEC(EditSme.Text,1,','));
    end;

    MemoText.Lines.Clear;
    for i:=0 to GBufList.Count-1 do begin
        tstr:=GBufList.Hist[i].FName+'=';
        tstr:=tstr+IntToStr(GBufList.Hist[i].CurBuf.FPos.x+sx)+','+IntToStr(GBufList.Hist[i].CurBuf.FPos.y+sy);
        tstr:=tstr+','+IntToStr(GBufList.Hist[i].CurBuf.FLenX)+','+IntToStr(GBufList.Hist[i].CurBuf.FLenY);
        MemoText.Lines.Add(tstr);
    end;
end;

procedure TForm_InfoProject.Button2Click(Sender: TObject);
var
    i:integer;
    sx,sy:integer;
begin
    sx:=0;
    sy:=0;
    if GetCountParEC(EditSme.Text,',')>=2 then begin
        sx:=StrToInt(GetStrParEC(EditSme.Text,0,','));
        sy:=StrToInt(GetStrParEC(EditSme.Text,1,','));
    end;

    MemoText.Lines.Clear;
    for i:=0 to GBufList.Count-1 do begin
        MemoText.Lines.Add(GBufList.Hist[i].FName+' {');
        MemoText.Lines.Add(#9+'Pos='+IntToStr(GBufList.Hist[i].CurBuf.FPos.x+sx)+','+IntToStr(GBufList.Hist[i].CurBuf.FPos.y+sy));
        MemoText.Lines.Add(#9+'Size='+IntToStr(GBufList.Hist[i].CurBuf.FLenX)+','+IntToStr(GBufList.Hist[i].CurBuf.FLenY));
        MemoText.Lines.Add('}');
    end;
end;

procedure TForm_InfoProject.ButtonNameClick(Sender: TObject);
var
    i:integer;
begin
    MemoText.Lines.Clear;
    for i:=0 to GBufList.Count-1 do begin
        MemoText.Lines.Add(StringReplaceEC(EditMaskName.Text,'<z>',GBufList.Hist[i].FName));
    end;
end;

end.
