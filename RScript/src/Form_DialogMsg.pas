unit Form_DialogMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf, ExtCtrls, RxRichEd, Menus, RXCtrls,math,
  ComCtrls;

type
TDialogMsgInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TDialogMsg = class(TGraphPoint)
    public
        FMsg:WideString;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;

        function Info:WideString; override;
end;

TFormDialogMsg = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    EditName: TEdit;
    Label1: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    MemoText: TRichEdit;
    RxSpeedButton2: TRxSpeedButton;
    ButFast: TRxSpeedButton;
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
    FDialogMsg:TDialogMsg;

    procedure PopupMenuGroupClick(Sender: TObject);
end;

var
    FormDialogMsg: TFormDialogMsg;

implementation

uses Main,Form_Main,Form_ExprInsert;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialogMsgInterface.Create;
begin
    inherited Create;
    FName:='DialogMsg';
    FGroup:=3;
end;

function TDialogMsgInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TDialogMsg.Create;
    with Result do begin
        FPos:=tpos;
        FText:='DialogMsgNew';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialogMsg.Create;
begin
    inherited Create;
    FImage:='DialogMsg';
end;

function TDialogMsg.DblClick:boolean;
begin
    Result:=false;
    FormDialogMsg.FDialogMsg:=self;
    if FormDialogMsg.ShowModal=mrOk then Result:=true;
end;

procedure TDialogMsg.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.Add(FMsg);
end;

procedure TDialogMsg.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FMsg:=bd.GetWideStr();
end;

function TDialogMsg.Info:WideString;
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
procedure TFormDialogMsg.FormShow(Sender: TObject);
begin
    EditName.Text:=FDialogMsg.FText;
    MemoText.Text:=FDialogMsg.FMsg;

    ButFast.Visible:=false;
end;

procedure TFormDialogMsg.BitBtn1Click(Sender: TObject);
begin
    FDialogMsg.FText:=EditName.Text;
    FDialogMsg.FMsg:=MemoText.Text;
end;

procedure TFormDialogMsg.RxSpeedButton2Click(Sender: TObject);
begin
    FormExprInsert.FTypeFun:=1;
    if FormExprInsert.ShowModal<>mrOk then Exit;
    if FormExprInsert.FResult<>'' then MemoText.SelText:=FormExprInsert.FResult;
end;

procedure TFormDialogMsg.MemoTextSelectionChange(Sender: TObject);
var
    tstr:WideString;
    i,ss,se,deccnt:integer;
begin
    tstr:=MemoText.Text;

    deccnt:=0;
{    i:=min(MemoText.SelStart-1,Length(tstr)-1-1);
    while i>=0 do begin
        if (tstr[i+1]=#13) and (tstr[i+2]=#10) then inc(deccnt);
        dec(i);
    end;}

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
        MemoText.SelStart:=ss-deccnt;
        MemoText.SelLength:=se-ss;

        ButFast.Caption:='Fast';
        ButFast.Visible:=true;
    end else begin
        ButFast.Visible:=false;
    end;
    MemoText.OnSelectionChange:=MemoTextSelectionChange;
end;

procedure TFormDialogMsg.PopupMenuGroupClick(Sender: TObject);
begin
    MemoText.SelText:=(Sender as TMenuItem).Caption;
//    ButFast.Visible:=false;
end;

procedure TFormDialogMsg.FormResize(Sender: TObject);
begin
    EditName.Width:=MemoText.Width;
end;

procedure TFormDialogMsg.MemoTextChange(Sender: TObject);
begin
    RichEditRStyle(MemoText,self);
end;

end.
