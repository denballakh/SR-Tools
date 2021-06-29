unit Form_Op;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf, RXCtrls, Menus, ComCtrls, ExtCtrls,
  RxRichEd,Math;

type
TopInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

Top = class(TGraphPoint)
    public
        FExpr:WideString;
        FInitScript:boolean;
    public
        constructor Create;
        destructor Destroy; override;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;
        procedure LoadLink; override;

        procedure MsgDeletePoint(p:TGraphPoint); override;

        function Info:WideString; override;
end;

TFormOp = class(TForm)
    Panel2: TPanel;
    RxSpeedButton2: TRxSpeedButton;
    ButFast: TRxSpeedButton;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    Panel4: TPanel;
    Panel6: TPanel;
    EditExpr: TRxRichEdit;
    PopupMenuGroup: TPopupMenu;
    Text11: TMenuItem;
    Text21: TMenuItem;
    CheckBoxInit: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure EditExprSelectionChange(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    Fop:Top;

    procedure PopupMenuGroupClick(Sender: TObject);
end;

var
  FormOp: TFormOp;

implementation

uses Main,Form_ExprInsert,Form_Group,Form_Place,Form_Item,Form_Planet,Form_Star;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TopInterface.Create;
begin
    inherited Create;
    FName:='Operation';
    FGroup:=2;
end;

function TopInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=Top.Create;
    with Result do begin
        FPos:=tpos;
        FText:='';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor Top.Create;
begin
    inherited Create;
    FImage:='op';

    FInitScript:=false;
end;

destructor Top.Destroy;
begin
    inherited Destroy;
end;

function Top.DblClick:boolean;
begin
    Result:=false;
    FormOp.Fop:=self;
    if FormOp.ShowModal=mrOk then Result:=true;
end;

procedure Top.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.Add(FExpr);
    bd.AddBoolean(FInitScript);
end;

procedure Top.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FExpr:=bd.GetWideStr;
    FInitScript:=bd.GetBoolean;
end;

procedure Top.LoadLink;
begin
    inherited LoadLink;
end;

procedure Top.MsgDeletePoint(p:TGraphPoint);
begin
    inherited MsgDeletePoint(p);
end;

function Top.Info:WideString;
var
    i,len:integer;
begin
    Result:=FExpr;

    if FInitScript then begin
//        Result:=Result+#13#10+CT('RunInitScript');
        len:=max(Length(FExpr),Length(CT('RunInitScript')));
        Result:=Result+#13#10;
        for i:=0 to len-1 do Result:=Result+'-';
        Result:=Result+#13#10+CT('RunInitScript');
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormOp.FormShow(Sender: TObject);
begin
    EditExpr.Text:=Fop.FExpr;
    CheckBoxInit.Checked:=Fop.FInitScript;
    ButFast.Visible:=false;
end;

procedure TFormOp.BitBtn1Click(Sender: TObject);
begin
    Fop.FExpr:=EditExpr.Text;
    Fop.FInitScript:=CheckBoxInit.Checked;
end;

procedure TFormOp.RxSpeedButton2Click(Sender: TObject);
begin
    FormExprInsert.FTypeFun:=2;
    if FormExprInsert.ShowModal<>mrOk then Exit;
    if FormExprInsert.FResult<>'' then EditExpr.SelText:=FormExprInsert.FResult;
end;

procedure TFormOp.EditExprSelectionChange(Sender: TObject);
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

procedure TFormOp.PopupMenuGroupClick(Sender: TObject);
begin
    EditExpr.SelText:=(Sender as TMenuItem).Caption;
    ButFast.Visible:=false;
end;

end.
