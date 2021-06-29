unit Form_If;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf, RXCtrls, Menus, ComCtrls, ExtCtrls,
  RxRichEd,Math;

type
TifInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

Tif = class(TGraphPoint)
    public
        FExpr:WideString;
//        FInitScript:boolean;
        FType:integer; // 0-normal 1-init 2-global
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

TFormIf = class(TForm)
    PopupMenuGroup: TPopupMenu;
    Text11: TMenuItem;
    Text21: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    RxSpeedButton2: TRxSpeedButton;
    ButFast: TRxSpeedButton;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    EditExpr: TRxRichEdit;
    ComboBoxType: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure EditExprSelectionChange(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    Fif:Tif;

    procedure PopupMenuGroupClick(Sender: TObject);
end;

var
  FormIf: TFormIf;

implementation

uses Main,Form_ExprInsert,Form_Group,Form_Place,Form_Item,Form_Planet,Form_Star;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TifInterface.Create;
begin
    inherited Create;
    FName:='if';
    FGroup:=2;
end;

function TifInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=Tif.Create;
    with Result do begin
        FPos:=tpos;
        FText:='';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor Tif.Create;
begin
    inherited Create;
    FImage:='if';

//    FInitScript:=false;
    FType:=0;
end;

destructor Tif.Destroy;
begin
    inherited Destroy;
end;

function Tif.DblClick:boolean;
begin
    Result:=false;
    FormIf.Fif:=self;
    if FormIf.ShowModal=mrOk then Result:=true;
end;

procedure Tif.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.Add(FExpr);
//    bd.AddBoolean(FInitScript);
    bd.AddBYTE(FType);
end;

procedure Tif.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FExpr:=bd.GetWideStr;
    if GFileVersion<$00000003 then begin
        if bd.GetBoolean then FType:=1 else FType:=0;
    end else begin
        FType:=bd.GetBYTE();
    end;
end;

procedure Tif.LoadLink;
begin
    inherited LoadLink;
end;

procedure Tif.MsgDeletePoint(p:TGraphPoint);
begin
    inherited MsgDeletePoint(p);
end;

function Tif.Info:WideString;
var
    i,len:integer;
begin
    Result:=FExpr;

{    if FInitScript then begin
//        Result:=Result+#13#10+CT('RunInitScript');
        len:=max(Length(FExpr),Length(CT('RunInitScript')));
        Result:=Result+#13#10;
        for i:=0 to len-1 do Result:=Result+'-';
        Result:=Result+#13#10+CT('RunInitScript');
    end;}
    if FType=1 then begin
        len:=max(Length(FExpr),Length(CT('RunInitScript')));
        Result:=Result+#13#10;
        for i:=0 to len-1 do Result:=Result+'-';
        Result:=Result+#13#10+CT('RunInitScript');
    end else if FType=2 then begin
        len:=max(Length(FExpr),Length(CT('RunGlobal')));
        Result:=Result+#13#10;
        for i:=0 to len-1 do Result:=Result+'-';
        Result:=Result+#13#10+CT('RunGlobal');
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormIf.FormShow(Sender: TObject);
begin
    EditExpr.Text:=Fif.FExpr;
//    CheckBoxInit.Checked:=Fif.FInitScript;
    ComboBoxType.ItemIndex:=Fif.FType;
    ButFast.Visible:=false;
end;

procedure TFormIf.BitBtn1Click(Sender: TObject);
begin
    Fif.FExpr:=EditExpr.Text;
//    Fif.FInitScript:=CheckBoxInit.Checked;
    Fif.FType:=ComboBoxType.ItemIndex;
end;

procedure TFormIf.RxSpeedButton2Click(Sender: TObject);
begin
    FormExprInsert.FTypeFun:=1;
    if FormExprInsert.ShowModal<>mrOk then Exit;
    if FormExprInsert.FResult<>'' then EditExpr.SelText:=FormExprInsert.FResult;
end;

procedure TFormIf.EditExprSelectionChange(Sender: TObject);
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

procedure TFormIf.PopupMenuGroupClick(Sender: TObject);
begin
    EditExpr.SelText:=(Sender as TMenuItem).Caption;
//    ButFast.Visible:=false;
end;

end.

