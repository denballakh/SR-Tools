unit Form_Var;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons, Math,EC_Buf, EC_Str, ComCtrls;

type
TVarInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TVar = class(TGraphPoint)
    public
        FType:integer; // 0-unknown 1-int 2-dw 3-str
        FInit:WideString;
        FGlobal:boolean;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;

        function Info:WideString; override;
end;

TFormVar = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    ComboBoxType: TComboBox;
    Label3: TLabel;
    EditInitState: TEdit;
    CheckBoxGlobal: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FVar:TVar;
end;

var
  FormVar: TFormVar;

implementation

uses Form_Star;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TVarInterface.Create;
begin
    inherited Create;
    FName:='Variable';
    FGroup:=2;
end;

function TVarInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TVar.Create;
    with Result do begin
        FPos:=tpos;
        FText:='VarNew';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TVar.Create;
begin
    inherited Create;
    FImage:='Var';

    FGlobal:=false;
end;

function TVar.DblClick:boolean;
begin
    Result:=false;
    FormVar.FVar:=self;
    if FormVar.ShowModal=mrOk then Result:=true;
end;

procedure TVar.Save(bd:TBufEC);
begin
    inherited Save(bd);
    bd.AddInteger(FType);
    bd.Add(FInit);
    bd.AddBoolean(FGlobal);
end;

procedure TVar.Load(bd:TBufEC);
begin
    inherited Load(bd);
    FType:=bd.GetInteger();
    FInit:=bd.GetWideStr;
    if GFileVersion>=$00000003 then begin
        FGlobal:=bd.GetBoolean;
    end;
end;

function TVar.Info:WideString;
var
    i,len:integer;
begin
    Result:='';
    if FType=0 then Result:='unknown'
    else if FType=1 then Result:='int'
    else if FType=2 then Result:='dword'
    else if FType=3 then Result:='str';

    Result:=Result+' '+FText+'='+FInit;

    if FGlobal then begin
        len:=max(Length(Result),Length(CT('VarGlobal')));
        Result:=Result+#13#10;
        for i:=0 to len-1 do Result:=Result+'-';
        Result:=Result+#13#10+CT('VarGlobal');
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormVar.FormShow(Sender: TObject);
begin
    EditName.Text:=FVar.FText;

    ComboBoxType.ItemIndex:=FVar.FType;
    EditInitState.Text:=FVar.FInit;

    CheckBoxGlobal.Checked:=FVar.FGlobal;
end;

procedure TFormVar.BitBtn1Click(Sender: TObject);
begin
    FVar.FText:=EditName.Text;

    FVar.FType:=ComboBoxType.ItemIndex;
    FVar.FInit:=EditInitState.Text;

    FVar.FGlobal:=CheckBoxGlobal.Checked;
end;

end.
