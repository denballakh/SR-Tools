unit Form_StarLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, GraphUnit,EC_Str,EC_Buf;

type
TStarLink = class(TGraphLink)
    public
        FDistMin,FDistMax:integer;
        FAngleRange:integer;
        FRelMin,FRelMax:integer;
        FHole:boolean;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;

        function Info:WideString; override;
end;

TFormStarLink = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    EditAngleRange: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    EditDist: TEdit;
    EditRelation: TEdit;
    CheckBoxHole: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FLink:TStarLink;
end;

var
  FormStarLink: TFormStarLink;

implementation

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStarLink.Create;
begin
    inherited Create;
    FArrow:=false;

    FDistMin:=0; FDistMax:=150;
    FAngleRange:=25;
    FRelMin:=0;
    FRelMax:=100;
end;

function TStarLink.DblClick:boolean;
begin
    Result:=false;
    FormStarLink.FLink:=self;
    if FormStarLink.ShowModal=mrOk then Result:=true;
end;

procedure TStarLink.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.AddInteger(FDistMin);
    bd.AddInteger(FDistMax);
    bd.AddInteger(FAngleRange);
    bd.AddInteger(FRelMin);
    bd.AddInteger(FRelMax);
    bd.AddBoolean(FHole);
end;

procedure TStarLink.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FDistMin:=bd.GetInteger;
    FDistMax:=bd.GetInteger;
    FAngleRange:=bd.GetInteger;
    FRelMin:=bd.GetInteger;
    FRelMax:=bd.GetInteger;
    FHole:=bd.GetBoolean;
end;

function TStarLink.Info:WideString;
begin
    Result:='';
    if (FDistMin>0) or (FDistMax<150) then Result:=Result+'Distance  : '+IntToStr(FDistMin)+','+IntToStr(FDistMax)+#13#10;
    Result:=Result+'Deviation : '+IntToStr(FAngleRange)+#13#10;
    if (FRelMin>0) or (FRelMax<100) then Result:=Result+'Relation  : '+IntToStr(FRelMin)+','+IntToStr(FRelMax)+#13#10;
    if FHole then Result:=Result+'Hole'+#13#10;

    Result:=TrimEx(Result);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormStarLink.FormShow(Sender: TObject);
begin
    EditDist.Text:=IntToStr(FLink.FDistMin)+','+IntToStr(FLink.FDistMax);
    EditAngleRange.Text:=IntToStr(FLink.FAngleRange);
    EditRelation.Text:=IntToStr(FLink.FRelMin)+','+IntToStr(FLink.FRelMax);
    CheckBoxHole.Checked:=FLink.FHole;
end;

procedure TFormStarLink.BitBtn1Click(Sender: TObject);
begin
    if (GetCountParEC(EditDist.Text,',')<2) or (GetCountParEC(EditRelation.Text,',')<2) then Exit;

    FLink.FDistMin:=StrToIntEC(GetStrParEC(EditDist.Text,0,','));
    FLink.FDistMax:=StrToIntEC(GetStrParEC(EditDist.Text,1,','));
    FLink.FAngleRange:=StrToIntEC(EditAngleRange.Text);
    FLink.FRelMin:=StrToIntEC(GetStrParEC(EditRelation.Text,0,','));
    FLink.FRelMax:=StrToIntEC(GetStrParEC(EditRelation.Text,1,','));
    FLink.FHole:=CheckBoxHole.Checked;

    ModalResult:=mrOk;
end;

end.
