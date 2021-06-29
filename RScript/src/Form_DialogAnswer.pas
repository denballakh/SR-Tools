unit Form_DialogAnswer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf, Menus, RxRichEd, RXCtrls, ExtCtrls,
  ComCtrls;

type
TDialogAnswerInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TDialogAnswer = class(TGraphPoint)
    public
        FMsg:WideString;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;

        function Info:WideString; override;
end;

TFormDialogAnswer = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Panel2: TPanel;
    RxSpeedButton2: TRxSpeedButton;
    ButFast: TRxSpeedButton;
    Panel5: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    Label1: TLabel;
    EditName: TEdit;
    Panel4: TPanel;
    MemoText: TRichEdit;
    PopupMenuGroup: TPopupMenu;
    Text11: TMenuItem;
    Text21: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure MemoTextSelectionChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MemoTextChange(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FDialogAnswer:TDialogAnswer;

    procedure PopupMenuGroupClick(Sender: TObject);
end;

var
  FormDialogAnswer: TFormDialogAnswer;

implementation

uses Main,Form_Main,Form_ExprInsert;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialogAnswerInterface.Create;
begin
    inherited Create;
    FName:='DialogAnswer';
    FGroup:=3;
end;

function TDialogAnswerInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TDialogAnswer.Create;
    with Result do begin
        FPos:=tpos;
        FText:='DialogAnswerNew';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialogAnswer.Create;
begin
    inherited Create;
    FImage:='DialogAnswer';
end;

function TDialogAnswer.DblClick:boolean;
begin
    Result:=false;
    FormDialogAnswer.FDialogAnswer:=self;
    if FormDialogAnswer.ShowModal=mrOk then Result:=true;
end;

procedure TDialogAnswer.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.Add(FMsg);
end;

procedure TDialogAnswer.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FMsg:=bd.GetWideStr();
end;

function TDialogAnswer.Info:WideString;
begin
    Result:='';
    if FMsg<>'' then begin
        if Length(FMsg)<=60 then begin
            Result:=Result+FMsg;
        end else begin
            Result:=Result+Copy(FMsg,1,60)+' ...';
        end;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormDialogAnswer.FormShow(Sender: TObject);
begin
    EditName.Text:=FDialogAnswer.FText;
    MemoText.Text:=FDialogAnswer.FMsg;

    ButFast.Visible:=false;
end;

procedure TFormDialogAnswer.BitBtn1Click(Sender: TObject);
begin
    FDialogAnswer.FText:=EditName.Text;
    FDialogAnswer.FMsg:=MemoText.Text;
end;

procedure TFormDialogAnswer.RxSpeedButton2Click(Sender: TObject);
begin
    FormExprInsert.FTypeFun:=1;
    if FormExprInsert.ShowModal<>mrOk then Exit;
    if FormExprInsert.FResult<>'' then MemoText.SelText:=FormExprInsert.FResult;
end;

procedure TFormDialogAnswer.MemoTextSelectionChange(Sender: TObject);
var
    tstr:WideString;
    i,ss,se:integer;
begin
    tstr:=MemoText.Text;
    i:=MemoText.SelStart-1;
    while i>=0 do begin
        if tstr[i+1]='<' then break;
        if tstr[i+1] in [WideChar('>'),WideChar('('),WideChar(')')] then begin ButFast.Visible:=false; Exit; end;
        dec(i);
    end;
    if i<0 then begin ButFast.Visible:=false; Exit; end;
    ss:=i;

    i:=MemoText.SelStart;
    while i<Length(tstr) do begin
        if tstr[i+1]='>' then break;
        if tstr[i+1] in [WideChar('<'),WideChar('('),WideChar(')')] then begin ButFast.Visible:=false; Exit; end;
        inc(i);
    end;
    if i>=Length(tstr) then begin ButFast.Visible:=false; Exit; end;
    se:=i+1;

    tstr:=Copy(tstr,ss+1,se-ss);

    MemoText.OnSelectionChange:=nil;
    if MenuBuild(self,tstr,PopupMenuGroup,PopupMenuGroupClick) then begin
        MemoText.SelStart:=ss;
        MemoText.SelLength:=se-ss;

        ButFast.Caption:='Fast';
        ButFast.Visible:=true;
    end else begin
        ButFast.Visible:=false;
    end;
    MemoText.OnSelectionChange:=MemoTextSelectionChange;
end;

procedure TFormDialogAnswer.PopupMenuGroupClick(Sender: TObject);
begin
    MemoText.SelText:=(Sender as TMenuItem).Caption;
//    ButFast.Visible:=false;
end;

procedure TFormDialogAnswer.FormResize(Sender: TObject);
begin
    EditName.Width:=MemoText.Width;
end;

procedure TFormDialogAnswer.MemoTextChange(Sender: TObject);
begin
    RichEditRStyle(MemoText,self);
end;

end.
