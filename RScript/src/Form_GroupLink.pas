unit Form_GroupLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, GraphUnit,EC_Str,EC_Buf, RXCtrls;

type
TGroupLink = class(TGraphLink)
    public
        FRel1,FRel2:integer;
        FWarWeightMin,FWarWeightMax:single;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;

        function Info:WideString; override;
end;

TFormGroupLink = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label4: TLabel;
    Label1: TLabel;
    EditWarWeight: TEdit;
    ComboBoxRelation1: TComboBox;
    Label2: TLabel;
    ComboBoxRelation2: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FLink:TGroupLink;
end;

var
  FormGroupLink: TFormGroupLink;

implementation

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TGroupLink.Create;
begin
    inherited Create;
    FArrow:=false;

    FRel1:=5;//2;
    FRel2:=5;//2;

    FWarWeightMin:=0;
    FWarWeightMax:=1000;
end;

function TGroupLink.DblClick:boolean;
begin
    Result:=false;
    FormGroupLink.FLink:=self;
    if FormGroupLink.ShowModal=mrOk then Result:=true;
end;

procedure TGroupLink.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.AddInteger(FRel1);
    bd.AddInteger(FRel2);
    bd.AddSingle(FWarWeightMin);
    bd.AddSingle(FWarWeightMax);
end;

procedure TGroupLink.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FRel1:=bd.GetInteger;
    FRel2:=bd.GetInteger;
    FWarWeightMin:=bd.GetSingle;
    FWarWeightMax:=bd.GetSingle;
end;

function TGroupLink.Info:WideString;
begin
    Result:='';

    if FRel1=0 then Result:=Result+'Relation 1 : War'+#13#10
    else if FRel1=1 then Result:=Result+'Relation 1 : Bad'+#13#10
    else if FRel1=2 then Result:=Result+'Relation 1 : Normal'+#13#10
    else if FRel1=3 then Result:=Result+'Relation 1 : Good'+#13#10
    else if FRel1=4 then Result:=Result+'Relation 1 : Best'+#13#10;

    if FRel2=0 then Result:=Result+'Relation 2 : War'+#13#10
    else if FRel2=1 then Result:=Result+'Relation 2 : Bad'+#13#10
    else if FRel2=2 then Result:=Result+'Relation 2 : Normal'+#13#10
    else if FRel2=3 then Result:=Result+'Relation 2 : Good'+#13#10
    else if FRel2=4 then Result:=Result+'Relation 2 : Best'+#13#10;

    Result:=Result+'War weight : '+FloatToStrEC(Round(FWarWeightMin*100)/100)+','+FloatToStrEC(Round(FWarWeightMax*100)/100);

    Result:=TrimEx(Result);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormGroupLink.FormShow(Sender: TObject);
begin
//    EditRelation.Text:=IntToStr(FLink.FRelMin)+','+IntToStr(FLink.FRelMax);
    ComboBoxRelation1.ItemIndex:=FLink.FRel1;
    ComboBoxRelation2.ItemIndex:=FLink.FRel2;
    EditWarWeight.Text:=FloatToStrEC(Round(FLink.FWarWeightMin*100)/100)+','+FloatToStrEC(Round(FLink.FWarWeightMax*100)/100);
end;

procedure TFormGroupLink.BitBtn1Click(Sender: TObject);
begin
//    if (GetCountParEC(EditRelation.Text,',')<2) then Exit;
    if (GetCountParEC(EditWarWeight.Text,',')<2) then Exit;

//    FLink.FRelMin:=StrToIntEC(GetStrParEC(EditRelation.Text,0,','));
//    FLink.FRelMax:=StrToIntEC(GetStrParEC(EditRelation.Text,1,','));
    FLink.FRel1:=ComboBoxRelation1.ItemIndex;
    FLink.FRel2:=ComboBoxRelation2.ItemIndex;

    FLink.FWarWeightMin:=StrToFloatEC(GetStrParEC(EditWarWeight.Text,0,','));
    FLink.FWarWeightMax:=StrToFloatEC(GetStrParEC(EditWarWeight.Text,1,','));

    ModalResult:=mrOk;
end;

end.
