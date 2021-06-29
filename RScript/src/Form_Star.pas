unit Form_Star;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf,EC_Str;

type
TStarInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TStar = class(TGraphPoint)
    public
        FConstellation:integer;
        FPriority:integer;
        FSubspace:boolean;
        FNoKling:boolean;
        FNoComeKling:boolean;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;
        function Info:WideString; override;
end;

TFormStar = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    EditConst: TEdit;
    Label3: TLabel;
    EditPriority: TEdit;
    CheckBoxSubspace: TCheckBox;
    CheckBoxNoKling: TCheckBox;
    CheckBoxNoComeKling: TCheckBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }

    FStar:TStar;
end;

var
  FormStar: TFormStar;

implementation

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStarInterface.Create;
begin
    inherited Create;
    FName:='Star';
    FGroup:=0;
end;

function TStarInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TStar.Create;
    with Result do begin
        FPos:=tpos;
        FText:='StarNew';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStar.Create;
begin
    inherited Create;
    FImage:='Star';
end;

function TStar.DblClick:boolean;
begin
    Result:=false;
    FormStar.FStar:=self;
    if FormStar.ShowModal=mrOk then Result:=true;
end;

procedure TStar.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.AddInteger(FConstellation);
    bd.AddInteger(FPriority);
    bd.AddBoolean(FSubspace);
    bd.AddBoolean(FNoKling);
    bd.AddBoolean(FNoComeKling);
end;

procedure TStar.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FConstellation:=bd.GetInteger;
    FPriority:=bd.GetInteger;
    FSubspace:=bd.GetBoolean;
    if GFileVersion>=$00000004 then begin
        FNoKling:=bd.GetBoolean;
        FNoComeKling:=bd.GetBoolean;
    end;
end;

function TStar.Info:WideString;
begin
    Result:='';

    if FSubspace then begin
        Result:=Result+'Subspace'+#13#10;
    end else if FConstellation<>0 then begin
        Result:=Result+'Constellation : '+IntToStr(FConstellation)+#13#10;
    end;

    Result:=Result+'Priority : '+IntToStr(FPriority);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormStar.FormShow(Sender: TObject);
begin
    EditName.Text:=FStar.FText;
    EditConst.Text:=IntToStr(FStar.FConstellation);
    EditPriority.Text:=IntToStr(FStar.FPriority);
    CheckBoxSubspace.Checked:=FStar.FSubspace;
    CheckBoxNoKling.Checked:=FStar.FNoKling;
    CheckBoxNoComeKling.Checked:=FStar.FNoComeKling;
end;

procedure TFormStar.BitBtn1Click(Sender: TObject);
begin
    FStar.FText:=EditName.Text;
    FStar.FConstellation:=StrToIntEC(EditConst.Text);
    FStar.FPriority:=StrToIntEC(EditPriority.Text);
    FStar.FSubspace:=CheckBoxSubspace.Checked;
    FStar.FNoKling:=CheckBoxNoKling.Checked;
    FStar.FNoComeKling:=CheckBoxNoComeKling.Checked;
end;

end.

