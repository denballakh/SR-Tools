unit Form_Place;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf,EC_Str, ComCtrls, ExtCtrls;

type
TPlaceInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TPlace = class(TGraphPoint)
    public
        FType:integer;  // 0-Free 1-Near planet 2-In planet 3-To star 4-Near item
        FAngle:single;
        FDist:single;
        FRadius:integer;
        FObj:TGraphPoint;
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

TFormPlace = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    EditName: TEdit;
    Notebook1: TNotebook;
    Label14: TLabel;
    EditFAngle: TEdit;
    Label15: TLabel;
    EditFDist: TEdit;
    Label16: TLabel;
    EditFRadius: TEdit;
    Label17: TLabel;
    ComboBoxNPPlanet: TComboBox;
    Label18: TLabel;
    EditNPRadius: TEdit;
    Label19: TLabel;
    ComboBoxIPPlanet: TComboBox;
    Label20: TLabel;
    ComboBoxTSStar: TComboBox;
    Label21: TLabel;
    EditTSDist: TEdit;
    Label22: TLabel;
    EditTSRadius: TEdit;
    Label23: TLabel;
    EditTSAngle: TEdit;
    Label24: TLabel;
    ComboBoxNIItem: TComboBox;
    Label25: TLabel;
    EditNIRadius: TEdit;
    ComboBoxType: TComboBox;
    Label26: TLabel;
    Label2: TLabel;
    ComboBoxFGGroup: TComboBox;
    Label3: TLabel;
    EditFGDist: TEdit;
    Label4: TLabel;
    EditFGRadius: TEdit;
    Label5: TLabel;
    EditFGAngle: TEdit;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FPlace:TPlace;
end;

var
  FormPlace: TFormPlace;

implementation

uses Form_Planet,Form_Star,Form_Item,Form_Group;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TPlaceInterface.Create;
begin
    inherited Create;
    FName:='Place';
    FGroup:=0;
end;

function TPlaceInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TPlace.Create;
    with Result do begin
        FPos:=tpos;
        FText:='PlaceNew';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TPlace.Create;
begin
    inherited Create;
    FImage:='Place';

    FType:=0;
    FAngle:=0;
    FDist:=0.5;
    FRadius:=300;
    FObj:=nil;
end;

destructor TPlace.Destroy;
begin
    inherited Destroy;
end;

function TPlace.DblClick:boolean;
begin
    Result:=false;
    FormPlace.FPlace:=self;
    if FormPlace.ShowModal=mrOk then Result:=true;
end;

procedure TPlace.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.AddInteger(FType);
    bd.AddSingle(FAngle);
    bd.AddSingle(FDist);
    bd.AddInteger(FRadius);
    bd.AddDWORD(GGraphPoint.IndexOf(FObj));
end;

procedure TPlace.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FType:=bd.GetInteger;
    FAngle:=bd.GetSingle;
    FDist:=bd.GetSingle;
    FRadius:=bd.GetInteger;
    FObj:=TGraphPoint(bd.GetDWORD);
end;

procedure TPlace.LoadLink;
begin
    inherited LoadLink;

    if integer(DWORD(FObj))=-1 then FObj:=nil
    else FObj:=GGraphPoint.Items[DWORD(FObj)];
end;

procedure TPlace.MsgDeletePoint(p:TGraphPoint);
begin
    inherited MsgDeletePoint(p);

    if FObj=p then FObj:=nil;
end;

function TPlace.Info:WideString;
begin
    Result:='';
    if FType=0 then begin
        Result:=Result+'=Free='+#13#10;
        Result:=Result+'Angle    : '+FloatToStrEC(FAngle)+#13#10;
        Result:=Result+'Distance : '+FloatToStrEC(Round(FDist*1000)/1000)+#13#10;
        Result:=Result+'Radius   : '+IntToStr(FRadius);
    end else if FType=1 then begin
        Result:=Result+'=Near planet='+#13#10;
        if FObj<>nil then
        Result:=Result+'Planet : '+FObj.FText+#13#10;
        Result:=Result+'Radius : '+IntToStr(FRadius);
    end else if FType=2 then begin
        Result:=Result+'=In planet='+#13#10;
        if FObj<>nil then
        Result:=Result+'Planet : '+FObj.FText;
    end else if FType=3 then begin
        Result:=Result+'=To star='+#13#10;
        if FObj<>nil then
        Result:=Result+'Star      : '+FObj.FText+#13#10;
        Result:=Result+'Distance  : '+FloatToStrEC(Round(FDist*1000)/1000)+#13#10;
        Result:=Result+'Radius    : '+IntToStr(FRadius)+#13#10;
        Result:=Result+'Angle add : '+FloatToStrEC(FAngle);
    end else if FType=4 then begin
        Result:=Result+'=Near item='+#13#10;
        if FObj<>nil then
        Result:=Result+'Item   : '+FObj.FText+#13#10;
        Result:=Result+'Radius : '+IntToStr(FRadius);
    end else if FType=5 then begin
        Result:=Result+'=Form group='+#13#10;
        if FObj<>nil then
        Result:=Result+'Group   : '+FObj.FText+#13#10;
        Result:=Result+'Distance  : '+FloatToStrEC(Round(FDist*1000)/1000)+#13#10;
        Result:=Result+'Radius    : '+IntToStr(FRadius)+#13#10;
        Result:=Result+'Angle add : '+FloatToStrEC(FAngle);
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormPlace.FormShow(Sender: TObject);
var
    gp:TGraphPoint;
    i:integer;
begin
    EditName.Text:=FPlace.FText;

//    PageControlType.ActivePageIndex:=FPlace.FType;
    ComboBoxType.ItemIndex:=FPlace.FType;
    Notebook1.ActivePage:=ComboBoxType.Text;

    EditFAngle.Text:=FloatToStrEC(FPlace.FAngle);
    EditTSAngle.Text:=FloatToStrEC(FPlace.FAngle);
    EditFGAngle.Text:=FloatToStrEC(FPlace.FAngle);

    EditFDist.Text:=FloatToStrEC(Round(FPlace.FDist*1000)/1000);
    EditTSDist.Text:=FloatToStrEC(Round(FPlace.FDist*1000)/1000);
    EditFGDist.Text:=FloatToStrEC(Round(FPlace.FDist*1000)/1000);

    EditFRadius.Text:=IntToStr(FPlace.FRadius);
    EditNPRadius.Text:=IntToStr(FPlace.FRadius);
    EditTSRadius.Text:=IntToStr(FPlace.FRadius);
    EditNIRadius.Text:=IntToStr(FPlace.FRadius);
    EditFGRadius.Text:=IntToStr(FPlace.FRadius);

    ComboBoxNPPlanet.Clear;
    ComboBoxIPPlanet.Clear;

    ComboBoxNPPlanet.Items.Add('unknown');
    ComboBoxNPPlanet.Items.Objects[0]:=nil;
    ComboBoxNPPlanet.ItemIndex:=0;

    ComboBoxIPPlanet.Items.Add('unknown');
    ComboBoxIPPlanet.Items.Objects[0]:=nil;
    ComboBoxIPPlanet.ItemIndex:=0;

    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp is TPlanet then begin
            ComboBoxNPPlanet.Items.Add(gp.FText);
            ComboBoxNPPlanet.Items.Objects[ComboBoxNPPlanet.Items.Count-1]:=gp;
            if (FPlace.FType=1) and (FPlace.FObj=gp) then ComboBoxNPPlanet.ItemIndex:=ComboBoxNPPlanet.Items.Count-1;

            ComboBoxIPPlanet.Items.Add(gp.FText);
            ComboBoxIPPlanet.Items.Objects[ComboBoxIPPlanet.Items.Count-1]:=gp;
            if (FPlace.FType=2) and (FPlace.FObj=gp) then ComboBoxIPPlanet.ItemIndex:=ComboBoxNPPlanet.Items.Count-1;
        end;
    end;

    ComboBoxTSStar.Clear;
    ComboBoxTSStar.Items.Add('unknown');
    ComboBoxTSStar.Items.Objects[0]:=nil;
    ComboBoxTSStar.ItemIndex:=0;

    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp is TStar then begin
            ComboBoxTSStar.Items.Add(gp.FText);
            ComboBoxTSStar.Items.Objects[ComboBoxTSStar.Items.Count-1]:=gp;
            if (FPlace.FType=3) and (FPlace.FObj=gp) then ComboBoxTSStar.ItemIndex:=ComboBoxTSStar.Items.Count-1;
        end;
    end;

    ComboBoxNIItem.Clear;
    ComboBoxNIItem.Items.Add('unknown');
    ComboBoxNIItem.Items.Objects[0]:=nil;
    ComboBoxNIItem.ItemIndex:=0;

    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp is TItem then begin
            ComboBoxNIItem.Items.Add(gp.FText);
            ComboBoxNIItem.Items.Objects[ComboBoxNIItem.Items.Count-1]:=gp;
            if (FPlace.FType=4) and (FPlace.FObj=gp) then ComboBoxNIItem.ItemIndex:=ComboBoxNIItem.Items.Count-1;
        end;
    end;

    ComboBoxFGGroup.Clear;
    ComboBoxFGGroup.Items.Add('unknown');
    ComboBoxFGGroup.Items.Objects[0]:=nil;
    ComboBoxFGGroup.ItemIndex:=0;

    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp is TGroup then begin
            ComboBoxFGGroup.Items.Add(gp.FText);
            ComboBoxFGGroup.Items.Objects[ComboBoxFGGroup.Items.Count-1]:=gp;
            if (FPlace.FType=5) and (FPlace.FObj=gp) then ComboBoxFGGroup.ItemIndex:=ComboBoxFGGroup.Items.Count-1;
        end;
    end;
end;

procedure TFormPlace.BitBtn1Click(Sender: TObject);
begin
    FPlace.FText:=EditName.Text;
//    FPlace.FType:=PageControlType.ActivePageIndex;
    FPlace.FType:=ComboBoxType.ItemIndex;

    if FPlace.FType=0 then begin
        FPlace.FAngle:=StrToFloatEC(EditFAngle.Text);
        FPlace.FDist:=Round(StrToFloatEC(EditFDist.Text)*1000)/1000;
        FPlace.FRadius:=StrToIntEC(EditFRadius.Text);
    end else if FPlace.FType=1 then begin
        FPlace.FObj:=ComboBoxNPPlanet.Items.Objects[ComboBoxNPPlanet.ItemIndex] as TGraphPoint;
        FPlace.FRadius:=StrToIntEC(EditNPRadius.Text);
    end else if FPlace.FType=2 then begin
        FPlace.FObj:=ComboBoxIPPlanet.Items.Objects[ComboBoxIPPlanet.ItemIndex] as TGraphPoint;
    end else if FPlace.FType=3 then begin
        FPlace.FObj:=ComboBoxTSStar.Items.Objects[ComboBoxTSStar.ItemIndex] as TGraphPoint;
        FPlace.FDist:=Round(StrToFloatEC(EditTSDist.Text)*1000)/1000;
        FPlace.FRadius:=StrToIntEC(EditTSRadius.Text);
        FPlace.FAngle:=StrToFloatEC(EditTSAngle.Text);
    end else if FPlace.FType=4 then begin
        FPlace.FObj:=ComboBoxNIItem.Items.Objects[ComboBoxNIItem.ItemIndex] as TGraphPoint;
        FPlace.FRadius:=StrToIntEC(EditNIRadius.Text);
    end else if FPlace.FType=5 then begin
        FPlace.FObj:=ComboBoxFGGroup.Items.Objects[ComboBoxFGGroup.ItemIndex] as TGraphPoint;
        FPlace.FDist:=Round(StrToFloatEC(EditFGDist.Text)*1000)/1000;
        FPlace.FRadius:=StrToIntEC(EditFGRadius.Text);
        FPlace.FAngle:=StrToFloatEC(EditFGAngle.Text);
    end;
end;

procedure TFormPlace.ComboBoxTypeChange(Sender: TObject);
begin
    Notebook1.ActivePage:=ComboBoxType.Text;
end;

end.

