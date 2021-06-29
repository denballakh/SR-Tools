unit Form_StateLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, GraphUnit,EC_Str,EC_Buf, RxRichEd, RXCtrls, ExtCtrls,
  Menus,Math;

type
TStateLink = class(TGraphLink)
    public
        FExpr:WideString;
        FPriority:integer;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;

        function Info:WideString; override;
end;

TFormStateLink = class(TForm)
    Panel2: TPanel;
    RxSpeedButton2: TRxSpeedButton;
    ButFast: TRxSpeedButton;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    EditExpr: TRxRichEdit;
    PopupMenuGroup: TPopupMenu;
    Text11: TMenuItem;
    Text21: TMenuItem;
    Label2: TLabel;
    EditPriority: TEdit;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure EditExprSelectionChange(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FLink:TStateLink;

    procedure PopupMenuGroupClick(Sender: TObject);
end;

var
    FormStateLink: TFormStateLink;

implementation

uses Main,Form_ExprInsert;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStateLink.Create;
begin
    inherited Create;
end;

function TStateLink.DblClick:boolean;
begin
    Result:=false;
    FormStateLink.FLink:=self;
    if FormStateLink.ShowModal=mrOk then Result:=true;
end;

procedure TStateLink.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.Add(FExpr);
    bd.AddInteger(FPriority);
end;

procedure TStateLink.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FExpr:=bd.GetWideStr();
    FPriority:=bd.GetInteger;
end;

function TStateLink.Info:WideString;
var
    i,len:integer;
begin
    Result:=FExpr;

    if FPriority<>0 then begin
        len:=max(Length(FExpr),Length('Priority : '+IntToStr(FPriority)));
        Result:=Result+#13#10;
        for i:=0 to len-1 do Result:=Result+'-';
        Result:=Result+#13#10+'Priority : '+IntToStr(FPriority);
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormStateLink.FormShow(Sender: TObject);
begin
    EditExpr.Text:=FLink.FExpr;
    EditPriority.Text:=IntToStr(FLink.FPriority);
    ButFast.Visible:=false;
end;

procedure TFormStateLink.BitBtn1Click(Sender: TObject);
begin
    FLink.FExpr:=EditExpr.Text;
    FLink.FPriority:=StrToIntEC(EditPriority.Text);
end;

procedure TFormStateLink.RxSpeedButton2Click(Sender: TObject);
begin
    FormExprInsert.FTypeFun:=1;
    if FormExprInsert.ShowModal<>mrOk then Exit;
    if FormExprInsert.FResult<>'' then EditExpr.SelText:=FormExprInsert.FResult;
end;

procedure TFormStateLink.EditExprSelectionChange(Sender: TObject);
var
    tstr:WideString;
    i,ss,se:integer;
begin
    tstr:=EditExpr.Text;
    i:=EditExpr.SelStart-1;
    while i>=0 do begin
        if tstr[i+1]='<' then break;
        if tstr[i+1] in [WideChar('>'),WideChar('('),WideChar(')')] then begin ButFast.Visible:=false; Exit; end;
        dec(i);
    end;
    if i<0 then begin ButFast.Visible:=false; Exit; end;
    ss:=i;

    i:=EditExpr.SelStart;
    while i<Length(tstr) do begin
        if tstr[i+1]='>' then break;
        if tstr[i+1] in [WideChar('<'),WideChar('('),WideChar(')')] then begin ButFast.Visible:=false; Exit; end;
        inc(i);
    end;
    if i>=Length(tstr) then begin ButFast.Visible:=false; Exit; end;
    se:=i+1;

    tstr:=Copy(tstr,ss+1,se-ss);

    EditExpr.OnSelectionChange:=nil;
    if MenuBuild(self,tstr,PopupMenuGroup,PopupMenuGroupClick) then begin
        EditExpr.SelStart:=ss;
        EditExpr.SelLength:=se-ss;

        ButFast.Caption:='Fast';
        ButFast.Visible:=true;
    end else begin
        ButFast.Visible:=false;
    end;
    EditExpr.OnSelectionChange:=EditExprSelectionChange;
end;

procedure TFormStateLink.PopupMenuGroupClick(Sender: TObject);
begin
    EditExpr.SelText:=(Sender as TMenuItem).Caption;
//    ButFast.Visible:=false;
end;

end.
