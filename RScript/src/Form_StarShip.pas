unit Form_StarShip;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, GraphUnit,EC_Str,EC_Buf;

type
TStarShipInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TStarShip = class(TGraphPoint)
    public
        FCount:integer;
        FOwner:DWORD;
        FType:DWORD;
        FPlayer:boolean;

        FRuins:WideString;

        FSpeedMin,FSpeedMax:integer;
        FWeapon:integer;
        FCargoHook:integer;

        FEmptySpace:integer;

        FRatingMin,FRatingMax:integer;
        FStatusTraderMin,FStatusTraderMax:integer;
        FStatusWarriorMin,FStatusWarriorMax:integer;
        FStatusPirateMin,FStatusPirateMax:integer;

        FScoreMin,FScoreMax:integer;

        FStrengthMin,FStrengthMax:single;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;

        function Info:WideString; override;
end;

TFormStarShip = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    EditSpeed: TEdit;
    Label3: TLabel;
    ComboBoxWeapon: TComboBox;
    Label4: TLabel;
    ComboBoxCargoHook: TComboBox;
    GroupBox4: TGroupBox;
    CheckBoxType: TCheckBox;
    CheckBoxRanger: TCheckBox;
    CheckBoxWarrior: TCheckBox;
    CheckBoxPirate: TCheckBox;
    CheckBoxTransport: TCheckBox;
    CheckBoxLiner: TCheckBox;
    CheckBoxDiplomat: TCheckBox;
    GroupBox3: TGroupBox;
    CheckBoxOwner: TCheckBox;
    CheckBoxOwnerMaloc: TCheckBox;
    CheckBoxOwnerPeleng: TCheckBox;
    CheckBoxOwnerPeople: TCheckBox;
    CheckBoxOwnerFei: TCheckBox;
    CheckBoxOwnerGaal: TCheckBox;
    CheckBoxOwnerKling: TCheckBox;
    CheckBoxPlayer: TCheckBox;
    Label5: TLabel;
    EditEmptySpace: TEdit;
    Label1: TLabel;
    EditRating: TEdit;
    GroupBox1: TGroupBox;
    EditSTrader: TEdit;
    Label9: TLabel;
    Label6: TLabel;
    EditSWarrior: TEdit;
    Label7: TLabel;
    EditSPirate: TEdit;
    Label8: TLabel;
    EditScore: TEdit;
    Label10: TLabel;
    EditCount: TEdit;
    CheckBoxK0Blazer: TCheckBox;
    CheckBoxK1Blazer: TCheckBox;
    CheckBoxK2Blazer: TCheckBox;
    CheckBoxK3Blazer: TCheckBox;
    CheckBoxK4Blazer: TCheckBox;
    CheckBoxTranclucator: TCheckBox;
    Label11: TLabel;
    EditStrength: TEdit;
    EditRuins: TEdit;
    Label12: TLabel;
    CheckBoxOwnerByPlayer: TCheckBox;
    Label13: TLabel;
    Label14: TLabel;
    CheckBoxK0Keller: TCheckBox;
    CheckBoxK1Keller: TCheckBox;
    CheckBoxK2Keller: TCheckBox;
    CheckBoxK3Keller: TCheckBox;
    CheckBoxK4Keller: TCheckBox;
    Label15: TLabel;
    CheckBoxK0Terron: TCheckBox;
    CheckBoxK1Terron: TCheckBox;
    CheckBoxK2Terron: TCheckBox;
    CheckBoxK3Terron: TCheckBox;
    CheckBoxK4Terron: TCheckBox;
    CheckBoxK5Blazer: TCheckBox;
    CheckBoxK5Keller: TCheckBox;
    CheckBoxK5Terron: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CheckBoxOwnerClick(Sender: TObject);
    procedure CheckBoxTypeClick(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FStarShip:TStarShip;
end;

var
  FormStarShip: TFormStarShip;

implementation

uses Main;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStarShipInterface.Create;
begin
    inherited Create;
    FName:='Ship';
    FGroup:=0;
end;

function TStarShipInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TStarShip.Create;
    with Result do begin
        FPos:=tpos;
        FText:='';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStarShip.Create;
begin
    inherited Create;

    FImage:='Ship';

    FCount:=1;

    FOwner:=CA1(CA1(CA1(CA1(CA1(0,5),4),3),2),1);
    FType:=CA1(CA1(CA1(CA1(CA1(CA1(0,6),5),4),3),2),1);

    FPlayer:=false;

    FSpeedMin:=0;
    FSpeedMax:=10000;
    FWeapon:=0;
    FCargoHook:=0;
    FEmptySpace:=0;

    FRatingMin:=0;
    FRatingMax:=1000;
    FStatusTraderMin:=0;
    FStatusTraderMax:=100;
    FStatusWarriorMin:=0;
    FStatusWarriorMax:=100;
    FStatusPirateMin:=0;
    FStatusPirateMax:=100;

    FScoreMin:=0;
    FScoreMax:=1000000;

    FStrengthMin:=0;
    FStrengthMax:=0;

    FRuins:='';
end;

function TStarShip.DblClick:boolean;
begin
    Result:=false;
    FormStarShip.FStarShip:=self;
    if FormStarShip.ShowModal=mrOk then Result:=true;
end;

procedure TStarShip.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.AddInteger(FCount);

    bd.AddDWORD(FOwner);
    bd.AddDWORD(FType);
    bd.AddBoolean(FPlayer);

    bd.AddInteger(FSpeedMin);
    bd.AddInteger(FSpeedMax);
    bd.AddInteger(FWeapon);
    bd.AddInteger(FCargoHook);

    bd.AddInteger(FEmptySpace);

    bd.AddInteger(FRatingMin);
    bd.AddInteger(FRatingMax);
    bd.AddInteger(FStatusTraderMin);
    bd.AddInteger(FStatusTraderMax);
    bd.AddInteger(FStatusWarriorMin);
    bd.AddInteger(FStatusWarriorMax);
    bd.AddInteger(FStatusPirateMin);
    bd.AddInteger(FStatusPirateMax);

    bd.AddInteger(FScoreMin);
    bd.AddInteger(FScoreMax);

    bd.AddSingle(FStrengthMin);
    bd.AddSingle(FStrengthMax);

    bd.Add(FRuins);
end;

procedure TStarShip.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FCount:=bd.GetInteger;

    FOwner:=bd.GetDWORD;
    FType:=bd.GetDWORD;
    FPlayer:=bd.GetBoolean;

    FSpeedMin:=bd.GetInteger;
    FSpeedMax:=bd.GetInteger;
    FWeapon:=bd.GetInteger;
    FCargoHook:=bd.GetInteger;

    FEmptySpace:=bd.GetInteger;

    FRatingMin:=bd.GetInteger;
    FRatingMax:=bd.GetInteger;
    FStatusTraderMin:=bd.GetInteger;
    FStatusTraderMax:=bd.GetInteger;
    FStatusWarriorMin:=bd.GetInteger;
    FStatusWarriorMax:=bd.GetInteger;
    FStatusPirateMin:=bd.GetInteger;
    FStatusPirateMax:=bd.GetInteger;

    FScoreMin:=bd.GetInteger;
    FScoreMax:=bd.GetInteger;

    if GFileVersion>=$00000002 then begin
        FStrengthMin:=bd.GetSingle;
        FStrengthMax:=bd.GetSingle;
        FRuins:=bd.GetWideStr;
    end;

    if FPlayer then FImage:='Player'
    else FImage:='Ship';
end;

function TStarShip.Info:WideString;
const
    ao:array[0..5] of WideString = ('Maloc','Peleng','People','Fei','Gaal','Kling');
    at:array[0..24] of WideString = ('Ranger','Warrior','Pirate','Transport','Liner','Diplomat','K0 Blazer','K1 Blazer','K2 Blazer','K3 Blazer','K4 Blazer','K5 Blazer','K0 Keller','K1 Keller','K2 Keller','K3 Keller','K4 Keller','K5 Keller','K0 Terron','K1 Terron','K2 Terron','K3 Terron','K4 Terron','K5 Terron','Tranclucator');
var
    sl:TStringList;
    i:integer;
    tstr:WideString;
begin
    sl:=TStringList.Create;

    if CA(FOwner,0) then begin
        tstr:='';
        for i:=0 to 5 do begin
            if CA(FOwner,i+1) then begin
                if tstr<>'' then tstr:=tstr+',';
                tstr:=tstr+ao[i];
            end;
        end;
        sl.Add('Owner : '+tstr);
    end;
    if CA(FType,0) then begin
        tstr:='';
        for i:=0 to High(at) do begin
            if CA(FType,i+1) then begin
                if tstr<>'' then tstr:=tstr+',';
                tstr:=tstr+at[i];
            end;
        end;
        sl.Add('Type : '+tstr);
    end;

    if FRuins<>'' then sl.Add('Ruins : '+FRuins);

    sl.Add('Count : '+IntToStr(FCount));
    if (FSpeedMin>0) or (FSpeedMax<10000) then sl.Add('Speed : '+IntToStr(FSpeedMin)+','+IntToStr(FSpeedMax));
    if FWeapon=1 then sl.Add('Weapon : Yes') else if FWeapon=2 then sl.Add('Weapon : No');
    if FCargoHook<>0 then sl.Add('CargoHook : '+IntToStr(FCargoHook));
    if FEmptySpace<>0 then sl.Add('Empty space : '+IntToStr(FEmptySpace));

    if (FStatusTraderMin>0) or (FStatusTraderMax<100) or (FStatusWarriorMin>0) or (FStatusWarriorMax<100) or (FStatusPirateMin>0) or (FStatusPirateMax<100) then begin
        sl.Add(Format('Status : {%d,%d}{%d,%d}{%d,%d}',[FStatusTraderMin,FStatusTraderMax,FStatusWarriorMin,FStatusWarriorMax,FStatusPirateMin,FStatusPirateMax]));
    end;

    if (FRatingMin>0) and (FRatingMax<>1000) then sl.Add('Rating : '+IntToStr(FRatingMin)+','+IntToStr(FRatingMax));
    if (FScoreMin>0) and (FScoreMax<>1000000) then sl.Add('Score : '+IntToStr(FScoreMin)+','+IntToStr(FScoreMax));

    if (FStrengthMin<>0) or (FStrengthMax<>0) then sl.Add('Strength : '+FloatToStrEC(Round(FStrengthMin*100)/100)+','+FloatToStrEC(Round(FStrengthMax*100)/100));

    Result:='';
    for i:=0 to sl.Count-1 do begin
        if i<>0 then Result:=Result+#13#10;
        Result:=Result+sl.Strings[i];
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormStarShip.CheckBoxOwnerClick(Sender: TObject);
begin
    CheckBoxOwnerMaloc.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerPeleng.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerPeople.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerFei.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerGaal.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerKling.Enabled:=CheckBoxOwner.Checked;
    CheckBoxOwnerByPlayer.Enabled:=CheckBoxOwner.Checked;
end;

procedure TFormStarShip.CheckBoxTypeClick(Sender: TObject);
begin
    CheckBoxRanger.Enabled:=CheckBoxType.Checked;
    CheckBoxWarrior.Enabled:=CheckBoxType.Checked;
    CheckBoxPirate.Enabled:=CheckBoxType.Checked;
    CheckBoxTransport.Enabled:=CheckBoxType.Checked;
    CheckBoxLiner.Enabled:=CheckBoxType.Checked;
    CheckBoxDiplomat.Enabled:=CheckBoxType.Checked;
    CheckBoxK0Blazer.Enabled:=CheckBoxType.Checked;
    CheckBoxK1Blazer.Enabled:=CheckBoxType.Checked;
    CheckBoxK2Blazer.Enabled:=CheckBoxType.Checked;
    CheckBoxK3Blazer.Enabled:=CheckBoxType.Checked;
    CheckBoxK4Blazer.Enabled:=CheckBoxType.Checked;
    CheckBoxK0Keller.Enabled:=CheckBoxType.Checked;
    CheckBoxK1Keller.Enabled:=CheckBoxType.Checked;
    CheckBoxK2Keller.Enabled:=CheckBoxType.Checked;
    CheckBoxK3Keller.Enabled:=CheckBoxType.Checked;
    CheckBoxK4Keller.Enabled:=CheckBoxType.Checked;
    CheckBoxK0Terron.Enabled:=CheckBoxType.Checked;
    CheckBoxK1Terron.Enabled:=CheckBoxType.Checked;
    CheckBoxK2Terron.Enabled:=CheckBoxType.Checked;
    CheckBoxK3Terron.Enabled:=CheckBoxType.Checked;
    CheckBoxK4Terron.Enabled:=CheckBoxType.Checked;
    CheckBoxTranclucator.Enabled:=CheckBoxType.Checked;
    EditRuins.Enabled:=CheckBoxType.Checked;
end;

procedure TFormStarShip.FormShow(Sender: TObject);
begin
    EditCount.Text:=IntToStr(FStarShip.FCount);

    CheckBoxOwner.Checked:=CA(FStarShip.FOwner,0);
    CheckBoxOwnerMaloc.Checked:=CA(FStarShip.FOwner,1);
    CheckBoxOwnerPeleng.Checked:=CA(FStarShip.FOwner,2);
    CheckBoxOwnerPeople.Checked:=CA(FStarShip.FOwner,3);
    CheckBoxOwnerFei.Checked:=CA(FStarShip.FOwner,4);
    CheckBoxOwnerGaal.Checked:=CA(FStarShip.FOwner,5);
    CheckBoxOwnerKling.Checked:=CA(FStarShip.FOwner,6);
    CheckBoxOwnerByPlayer.Checked:=CA(FStarShip.FOwner,8);
    CheckBoxOwnerClick(nil);

    CheckBoxType.Checked:=CA(FStarShip.FType,0);
    CheckBoxRanger.Checked:=CA(FStarShip.FType,1);
    CheckBoxWarrior.Checked:=CA(FStarShip.FType,2);
    CheckBoxPirate.Checked:=CA(FStarShip.FType,3);
    CheckBoxTransport.Checked:=CA(FStarShip.FType,4);
    CheckBoxLiner.Checked:=CA(FStarShip.FType,5);
    CheckBoxDiplomat.Checked:=CA(FStarShip.FType,6);
    CheckBoxK0Blazer.Checked:=CA(FStarShip.FType,7);
    CheckBoxK1Blazer.Checked:=CA(FStarShip.FType,8);
    CheckBoxK2Blazer.Checked:=CA(FStarShip.FType,9);
    CheckBoxK3Blazer.Checked:=CA(FStarShip.FType,10);
    CheckBoxK4Blazer.Checked:=CA(FStarShip.FType,11);
    CheckBoxK5Blazer.Checked:=CA(FStarShip.FType,12);
    CheckBoxK0Keller.Checked:=CA(FStarShip.FType,13);
    CheckBoxK1Keller.Checked:=CA(FStarShip.FType,14);
    CheckBoxK2Keller.Checked:=CA(FStarShip.FType,15);
    CheckBoxK3Keller.Checked:=CA(FStarShip.FType,16);
    CheckBoxK4Keller.Checked:=CA(FStarShip.FType,17);
    CheckBoxK5Keller.Checked:=CA(FStarShip.FType,18);
    CheckBoxK0Terron.Checked:=CA(FStarShip.FType,19);
    CheckBoxK1Terron.Checked:=CA(FStarShip.FType,20);
    CheckBoxK2Terron.Checked:=CA(FStarShip.FType,21);
    CheckBoxK3Terron.Checked:=CA(FStarShip.FType,22);
    CheckBoxK4Terron.Checked:=CA(FStarShip.FType,23);
    CheckBoxK5Terron.Checked:=CA(FStarShip.FType,24);
    CheckBoxTranclucator.Checked:=CA(FStarShip.FType,25);
    CheckBoxTypeClick(nil);

    EditRuins.Text:=FStarShip.FRuins;

    CheckBoxPlayer.Checked:=FStarShip.FPlayer;

    EditSpeed.Text:=IntToStr(FStarShip.FSpeedMin)+','+IntToStr(FStarShip.FSpeedMax);
    ComboBoxWeapon.ItemIndex:=FStarShip.FWeapon;
    ComboBoxCargoHook.ItemIndex:=FStarShip.FCargoHook;

    EditEmptySpace.Text:=IntToStr(FStarShip.FEmptySpace);

    EditRating.Text:=IntToStr(FStarShip.FRatingMin)+','+IntToStr(FStarShip.FRatingMax);
    EditSTrader.Text:=IntToStr(FStarShip.FStatusTRaderMin)+','+IntToStr(FStarShip.FStatusTRaderMax);
    EditSWarrior.Text:=IntToStr(FStarShip.FStatusWarriorMin)+','+IntToStr(FStarShip.FStatusWarriorMax);
    EditSPirate.Text:=IntToStr(FStarShip.FStatusPirateMin)+','+IntToStr(FStarShip.FStatusPirateMax);

    EditScore.Text:=IntToStr(FStarShip.FScoreMin)+','+IntToStr(FStarShip.FScoreMax);

    EditStrength.Text:=FloatToStrEC(Round(FStarShip.FStrengthMin*100)/100)+','+FloatToStrEC(Round(FStarShip.FStrengthMax*100)/100);
end;

procedure TFormStarShip.BitBtn1Click(Sender: TObject);
begin
    if (GetCountParEC(EditSpeed.Text,',')<2) then Exit;
    if (GetCountParEC(EditRating.Text,',')<2) then Exit;
    if (GetCountParEC(EditSTrader.Text,',')<2) then Exit;
    if (GetCountParEC(EditSWarrior.Text,',')<2) then Exit;
    if (GetCountParEC(EditSPirate.Text,',')<2) then Exit;
    if (GetCountParEC(EditScore.Text,',')<2) then Exit;
    if (GetCountParEC(EditStrength.Text,',')<2) then Exit;

    FStarShip.FCount:=StrToIntEC(EditCount.Text);

    SCA(FStarShip.FOwner,0,CheckBoxOwner.Checked);
    SCA(FStarShip.FOwner,1,CheckBoxOwnerMaloc.Checked);
    SCA(FStarShip.FOwner,2,CheckBoxOwnerPeleng.Checked);
    SCA(FStarShip.FOwner,3,CheckBoxOwnerPeople.Checked);
    SCA(FStarShip.FOwner,4,CheckBoxOwnerFei.Checked);
    SCA(FStarShip.FOwner,5,CheckBoxOwnerGaal.Checked);
    SCA(FStarShip.FOwner,6,CheckBoxOwnerKling.Checked);
    SCA(FStarShip.FOwner,8,CheckBoxOwnerByPlayer.Checked);

    SCA(FStarShip.FType,0,CheckBoxType.Checked);
    SCA(FStarShip.FType,1,CheckBoxRanger.Checked);
    SCA(FStarShip.FType,2,CheckBoxWarrior.Checked);
    SCA(FStarShip.FType,3,CheckBoxPirate.Checked);
    SCA(FStarShip.FType,4,CheckBoxTransport.Checked);
    SCA(FStarShip.FType,5,CheckBoxLiner.Checked);
    SCA(FStarShip.FType,6,CheckBoxDiplomat.Checked);
    SCA(FStarShip.FType,7,CheckBoxK0Blazer.Checked);
    SCA(FStarShip.FType,8,CheckBoxK1Blazer.Checked);
    SCA(FStarShip.FType,9,CheckBoxK2Blazer.Checked);
    SCA(FStarShip.FType,10,CheckBoxK3Blazer.Checked);
    SCA(FStarShip.FType,11,CheckBoxK4Blazer.Checked);
    SCA(FStarShip.FType,12,CheckBoxK5Blazer.Checked);
    SCA(FStarShip.FType,13,CheckBoxK0Keller.Checked);
    SCA(FStarShip.FType,14,CheckBoxK1Keller.Checked);
    SCA(FStarShip.FType,15,CheckBoxK2Keller.Checked);
    SCA(FStarShip.FType,16,CheckBoxK3Keller.Checked);
    SCA(FStarShip.FType,17,CheckBoxK4Keller.Checked);
    SCA(FStarShip.FType,18,CheckBoxK5Keller.Checked);
    SCA(FStarShip.FType,19,CheckBoxK0Terron.Checked);
    SCA(FStarShip.FType,20,CheckBoxK1Terron.Checked);
    SCA(FStarShip.FType,21,CheckBoxK2Terron.Checked);
    SCA(FStarShip.FType,22,CheckBoxK3Terron.Checked);
    SCA(FStarShip.FType,23,CheckBoxK4Terron.Checked);
    SCA(FStarShip.FType,24,CheckBoxK5Terron.Checked);
    SCA(FStarShip.FType,25,CheckBoxTranclucator.Checked);

    FStarShip.FRuins:=EditRuins.Text;

    FStarShip.FPlayer:=CheckBoxPlayer.Checked;
    if FStarShip.FPlayer then FStarShip.FImage:='Player'
    else FStarShip.FImage:='Ship';

    FStarShip.FSpeedMin:=StrToInt(GetStrParEC(EditSpeed.Text,0,','));
    FStarShip.FSpeedMax:=StrToInt(GetStrParEC(EditSpeed.Text,1,','));

    FStarShip.FWeapon:=ComboBoxWeapon.ItemIndex;
    FStarShip.FCargoHook:=ComboBoxCargoHook.ItemIndex;

    FStarShip.FEmptySpace:=strToIntEC(EditEmptySpace.Text);

    FStarShip.FRatingMin:=StrToIntEC(GetStrParEC(EditRating.Text,0,','));
    FStarShip.FRatingMax:=StrToIntEC(GetStrParEC(EditRating.Text,1,','));

    FStarShip.FStatusTRaderMin:=StrToIntEC(GetStrParEC(EditSTrader.Text,0,','));
    FStarShip.FStatusTRaderMax:=StrToIntEC(GetStrParEC(EditSTrader.Text,1,','));

    FStarShip.FStatusWarriorMin:=StrToIntEC(GetStrParEC(EditSWarrior.Text,0,','));
    FStarShip.FStatusWarriorMax:=StrToIntEC(GetStrParEC(EditSWarrior.Text,1,','));

    FStarShip.FStatusPirateMin:=StrToIntEC(GetStrParEC(EditSPirate.Text,0,','));
    FStarShip.FStatusPirateMax:=StrToIntEC(GetStrParEC(EditSPirate.Text,1,','));

    FStarShip.FScoreMin:=StrToIntEC(GetStrParEC(EditScore.Text,0,','));
    FStarShip.FScoreMax:=StrToIntEC(GetStrParEC(EditScore.Text,1,','));

    FStarShip.FStrengthMin:=StrToFloatEC(GetStrParEC(EditStrength.Text,0,','));
    FStarShip.FStrengthMax:=StrToFloatEC(GetStrParEC(EditStrength.Text,1,','));

    ModalResult:=mrOk;
end;

end.
