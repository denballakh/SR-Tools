unit Form_Planet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, GraphUnit,EC_Str,EC_Buf, RXCtrls;

type
TPlanetInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TPlanet = class(TGraphPoint)
    public
        FRace:DWORD;
        FOwner:DWORD;
        FEconomy:DWORD;
        FGoverment:DWORD;

        FRangeMin,FRangeMax:integer;

        FDialog:TGraphPoint;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;
        procedure LoadLink; override;

        procedure MsgDeletePoint(p:TGraphPoint); override;

        function Info:WideString; override;
end;

TFormPlanet = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    EditName: TEdit;
    GroupBox1: TGroupBox;
    CheckBoxAgriculture: TCheckBox;
    CheckBoxIndustrial: TCheckBox;
    CheckBoxMixed: TCheckBox;
    CheckBoxEconomy: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBoxGoverment: TCheckBox;
    CheckBoxAnarchy: TCheckBox;
    CheckBoxDictatorship: TCheckBox;
    CheckBoxMonarchy: TCheckBox;
    CheckBoxRepublic: TCheckBox;
    CheckBoxDemocracy: TCheckBox;
    GroupBox3: TGroupBox;
    CheckBoxOwner: TCheckBox;
    CheckBoxOwnerMaloc: TCheckBox;
    CheckBoxOwnerPeleng: TCheckBox;
    CheckBoxOwnerPeople: TCheckBox;
    CheckBoxOwnerFei: TCheckBox;
    CheckBoxOwnerGaal: TCheckBox;
    CheckBoxOwnerKling: TCheckBox;
    CheckBoxOwnerNone: TCheckBox;
    GroupBox4: TGroupBox;
    CheckBoxRace: TCheckBox;
    CheckBoxRaceMaloc: TCheckBox;
    CheckBoxRacePeleng: TCheckBox;
    CheckBoxRacePeople: TCheckBox;
    CheckBoxRaceFei: TCheckBox;
    CheckBoxRaceGaal: TCheckBox;
    Label2: TLabel;
    EditRange: TEdit;
    Label3: TLabel;
    ComboBoxDialog: TComboBox;
    CheckBoxOwnerByPlayer: TCheckBox;
    procedure CheckBoxRaceClick(Sender: TObject);
    procedure CheckBoxOwnerClick(Sender: TObject);
    procedure CheckBoxEconomyClick(Sender: TObject);
    procedure CheckBoxGovermentClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FPlanet:TPlanet;
end;

var
  FormPlanet: TFormPlanet;

implementation

uses Main,Form_Dialog;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TPlanetInterface.Create;
begin
    inherited Create;
    FName:='Planet';
    FGroup:=0;
end;

function TPlanetInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TPlanet.Create;
    with Result do begin
        FPos:=tpos;
        FText:='PlanetNew';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TPlanet.Create;
begin
    inherited Create;


    FImage:='Planet';

    FRace:=CA1(CA1(CA1(CA1(CA1(0,5),4),3),2),1);
    FOwner:=CA1(CA1(CA1(CA1(CA1(0,5),4),3),2),1);
    FEconomy:=CA1(CA1(CA1(0,3),2),1);
    FGoverment:=CA1(CA1(CA1(CA1(CA1(0,5),4),3),2),1);

    FRangeMin:=0;
    FRangeMax:=100;
end;

function TPlanet.DblClick:boolean;
begin
    Result:=false;
    FormPlanet.FPlanet:=self;
    if FormPlanet.ShowModal=mrOk then Result:=true;
end;

procedure TPlanet.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.AddDWORD(FRace);
    bd.AddDWORD(FOwner);
    bd.AddDWORD(FEconomy);
    bd.AddDWORD(FGoverment);

    bd.AddInteger(FRangeMin);
    bd.AddInteger(FRangeMax);

    bd.AddDWORD(GGraphPoint.IndexOf(FDialog));
end;

procedure TPlanet.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FRace:=bd.GetDWORD;
    FOwner:=bd.GetDWORD;
    FEconomy:=bd.GetDWORD;
    FGoverment:=bd.GetDWORD;

    FRangeMin:=bd.GetInteger;
    FRangeMax:=bd.GetInteger;

    FDialog:=TGraphPoint(bd.GetDWORD);
end;

procedure TPlanet.LoadLink;
begin
    inherited LoadLink;

    if integer(DWORD(FDialog))=-1 then FDialog:=nil
    else FDialog:=GGraphPoint.Items[DWORD(FDialog)];
end;

procedure TPlanet.MsgDeletePoint(p:TGraphPoint);
begin
    inherited MsgDeletePoint(p);

    if FDialog=p then FDialog:=nil;
end;

function TPlanet.Info:WideString;
const
    ar:array[0..6] of WideString = ('Maloc','Peleng','People','Fei','Gaal','Kling','None');
    ae:array[0..2] of WideString = ('Agriculture','Industrial','Mixed');
    ag:array[0..4] of WideString = ('Anarchy','Dictatorship','Monarchy','Republic','Democracy');
var
    sl:TStringList;
    i:integer;
    tstr:WideString;
begin
    sl:=TStringList.Create;

    if CA(FRace,0) then begin
        tstr:='';
        for i:=0 to 4 do begin
            if CA(FRace,i+1) then begin
                if tstr<>'' then tstr:=tstr+',';
                tstr:=tstr+ar[i];
            end;
        end;
        sl.Add('Race  : '+tstr);
    end;
    if CA(FOwner,0) then begin
        tstr:='';
        for i:=0 to 6 do begin
            if CA(FOwner,i+1) then begin
                if tstr<>'' then tstr:=tstr+',';
                tstr:=tstr+ar[i];
            end;
        end;
        sl.Add('Owner : '+tstr);
    end;
    if CA(FEconomy,0) then begin
        tstr:='';
        for i:=0 to 2 do begin
            if CA(FEconomy,i+1) then begin
                if tstr<>'' then tstr:=tstr+',';
                tstr:=tstr+ae[i];
            end;
        end;
        sl.Add('Economy : '+tstr);
    end;
    if CA(FGoverment,0) then begin
        tstr:='';
        for i:=0 to 4 do begin
            if CA(FGoverment,i+1) then begin
                if tstr<>'' then tstr:=tstr+',';
                tstr:=tstr+ag[i];
            end;
        end;
        sl.Add('Goverment : '+tstr);
    end;
    if (FRangeMin>0) or (FRangeMax<100) then begin
        sl.Add('Range : '+IntToStr(FRangeMin)+','+IntToStr(FRangeMax));
    end;
    if FDialog<>nil then begin
        sl.Add('Dialog : '+FDialog.FText);
    end;

    Result:='';
    for i:=0 to sl.Count-1 do begin
        if i<>0 then Result:=Result+#13#10;
        Result:=Result+sl.Strings[i];
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TFormPlanet.CheckBoxRaceClick(Sender: TObject);
begin
    CheckBoxRaceMaloc.Enabled:=CheckBoxRace.Checked;
    CheckBoxRacePeleng.Enabled:=CheckBoxRace.Checked;
    CheckBoxRacePeople.Enabled:=CheckBoxRace.Checked;
    CheckBoxRaceFei.Enabled:=CheckBoxRace.Checked;
    CheckBoxRaceGaal.Enabled:=CheckBoxRace.Checked;
end;

procedure TFormPlanet.CheckBoxOwnerClick(Sender: TObject);
begin
    CheckBoxOwnerMaloc.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerPeleng.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerPeople.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerFei.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerGaal.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerKling.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerByPlayer.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerNone.Enabled:=CheckBoxOwner.Checked;
end;

procedure TFormPlanet.CheckBoxEconomyClick(Sender: TObject);
begin
    CheckBoxAgriculture.Enabled:=CheckBoxEconomy.Checked;
    CheckBoxIndustrial.Enabled:=CheckBoxEconomy.Checked;
    CheckBoxMixed.Enabled:=CheckBoxEconomy.Checked;
end;

procedure TFormPlanet.CheckBoxGovermentClick(Sender: TObject);
begin
    CheckBoxAnarchy.Enabled:=CheckBoxGoverment.Checked;
    CheckBoxDictatorship.Enabled:=CheckBoxGoverment.Checked;
    CheckBoxMonarchy.Enabled:=CheckBoxGoverment.Checked;
    CheckBoxRepublic.Enabled:=CheckBoxGoverment.Checked;
    CheckBoxDemocracy.Enabled:=CheckBoxGoverment.Checked;
end;

procedure TFormPlanet.FormShow(Sender: TObject);
var
    gp:TGraphPoint;
    i:integer;
begin
    EditName.Text:=FPlanet.FText;

    CheckBoxRace.Checked:=CA(FPlanet.FRace,0);
    CheckBoxRaceMaloc.Checked:=CA(FPlanet.FRace,1);
    CheckBoxRacePeleng.Checked:=CA(FPlanet.FRace,2);
    CheckBoxRacePeople.Checked:=CA(FPlanet.FRace,3);
    CheckBoxRaceFei.Checked:=CA(FPlanet.FRace,4);
    CheckBoxRaceGaal.Checked:=CA(FPlanet.FRace,5);
    CheckBoxRaceClick(nil);

    CheckBoxOwner.Checked:=CA(FPlanet.FOwner,0);
    CheckBoxOwnerMaloc.Checked:=CA(FPlanet.FOwner,1);
    CheckBoxOwnerPeleng.Checked:=CA(FPlanet.FOwner,2);
    CheckBoxOwnerPeople.Checked:=CA(FPlanet.FOwner,3);
    CheckBoxOwnerFei.Checked:=CA(FPlanet.FOwner,4);
    CheckBoxOwnerGaal.Checked:=CA(FPlanet.FOwner,5);
    CheckBoxOwnerKling.Checked:=CA(FPlanet.FOwner,6);
    CheckBoxOwnerNone.Checked:=CA(FPlanet.FOwner,7);
    CheckBoxOwnerByPlayer.Checked:=CA(FPlanet.FOwner,8);
    CheckBoxOwnerClick(nil);

    CheckBoxEconomy.Checked:=CA(FPlanet.FEconomy,0);
    CheckBoxAgriculture.Checked:=CA(FPlanet.FEconomy,1);
    CheckBoxIndustrial.Checked:=CA(FPlanet.FEconomy,2);
    CheckBoxMixed.Checked:=CA(FPlanet.FEconomy,3);
    CheckBoxEconomyClick(nil);

    CheckBoxGoverment.Checked:=CA(FPlanet.FGoverment,0);
    CheckBoxAnarchy.Checked:=CA(FPlanet.FGoverment,1);
    CheckBoxDictatorship.Checked:=CA(FPlanet.FGoverment,2);
    CheckBoxMonarchy.Checked:=CA(FPlanet.FGoverment,3);
    CheckBoxRepublic.Checked:=CA(FPlanet.FGoverment,4);
    CheckBoxDemocracy.Checked:=CA(FPlanet.FGoverment,5);
    CheckBoxGovermentClick(nil);

    EditRange.Text:=IntToStr(FPlanet.FRangeMin)+','+IntToStr(FPlanet.FRangeMax);

    ComboBoxDialog.Clear;
    ComboBoxDialog.Items.Add('');
    ComboBoxDialog.Items.Objects[0]:=nil;
    ComboBoxDialog.ItemIndex:=0;
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp is TDialog then begin
            ComboBoxDialog.Items.Add(gp.FText);
            ComboBoxDialog.Items.Objects[ComboBoxDialog.Items.Count-1]:=gp;
            if gp=FPlanet.FDialog then ComboBoxDialog.ItemIndex:=ComboBoxDialog.Items.Count-1;
        end;
    end;
end;

procedure TFormPlanet.BitBtn1Click(Sender: TObject);
begin
    if GetCountParEC(EditRange.Text,',')<>2 then Exit;

    FPlanet.FText:=EditName.Text;

    SCA(FPlanet.FRace,0,CheckBoxRace.Checked);
    SCA(FPlanet.FRace,1,CheckBoxRaceMaloc.Checked);
    SCA(FPlanet.FRace,2,CheckBoxRacePeleng.Checked);
    SCA(FPlanet.FRace,3,CheckBoxRacePeople.Checked);
    SCA(FPlanet.FRace,4,CheckBoxRaceFei.Checked);
    SCA(FPlanet.FRace,5,CheckBoxRaceGaal.Checked);

    SCA(FPlanet.FOwner,0,CheckBoxOwner.Checked);
    SCA(FPlanet.FOwner,1,CheckBoxOwnerMaloc.Checked);
    SCA(FPlanet.FOwner,2,CheckBoxOwnerPeleng.Checked);
    SCA(FPlanet.FOwner,3,CheckBoxOwnerPeople.Checked);
    SCA(FPlanet.FOwner,4,CheckBoxOwnerFei.Checked);
    SCA(FPlanet.FOwner,5,CheckBoxOwnerGaal.Checked);
    SCA(FPlanet.FOwner,6,CheckBoxOwnerKling.Checked);
    SCA(FPlanet.FOwner,7,CheckBoxOwnerNone.Checked);
    SCA(FPlanet.FOwner,8,CheckBoxOwnerByPlayer.Checked);

    SCA(FPlanet.FEconomy,0,CheckBoxEconomy.Checked);
    SCA(FPlanet.FEconomy,1,CheckBoxAgriculture.Checked);
    SCA(FPlanet.FEconomy,2,CheckBoxIndustrial.Checked);
    SCA(FPlanet.FEconomy,3,CheckBoxMixed.Checked);

    SCA(FPlanet.FGoverment,0,CheckBoxGoverment.Checked);
    SCA(FPlanet.FGoverment,1,CheckBoxAnarchy.Checked);
    SCA(FPlanet.FGoverment,2,CheckBoxDictatorship.Checked);
    SCA(FPlanet.FGoverment,3,CheckBoxMonarchy.Checked);
    SCA(FPlanet.FGoverment,4,CheckBoxRepublic.Checked);
    SCA(FPlanet.FGoverment,5,CheckBoxDemocracy.Checked);

    FPlanet.FRangeMin:=StrToIntEC(GetStrParEC(EditRange.Text,0,','));
    FPlanet.FRangeMax:=StrToIntEC(GetStrParEC(EditRange.Text,1,','));

    FPlanet.FDialog:=ComboBoxDialog.Items.Objects[ComboBoxDialog.ItemIndex] as TGraphPoint;

    ModalResult:=mrOk;
end;

end.
