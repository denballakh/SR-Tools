unit Form_Item;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf, EC_Str, ComCtrls, RXSpin, ExtCtrls;

type
TItemInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TItem = class(TGraphPoint)
    public
        FMainType:integer;  // 0-Equipment 1-Weapon 2-Goods 3-Artifact 4-Unknown
        FType:integer;      // Equipment:   0-FuelTanks 1-Engine 2-Radar 3-Scaner 4-RepairRobot 5-CargoHook 6-DefGenerator
                            // Weapon:      0-14
                            // Goods:       0-Food 1-Medicine 2-Technics 3-Luxury 4-Minerals 5-Minerals (natural) 6-Alcohol 7-Arms 8-Narcotics
                            // Artifact:    0-Speed 1-Def 2-Transmitter 3-Bomb 4-Tranclucator
        FSize:integer;
        FLavel:integer;     // 1-7
        FRadius:integer;    // For weapon
        FOwner:integer;     // 0-Maloc 1-Peleng 2-People 3-Fei 4-Gaal 5-Kling 6-None
        FUseless:WideString;//

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

TFormItem = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Notebook1: TNotebook;
    Label5: TLabel;
    ComboBoxEqType: TComboBox;
    Label2: TLabel;
    EditEqSize: TEdit;
    Label3: TLabel;
    RxSpinEditEqLevel: TRxSpinEdit;
    Label4: TLabel;
    ComboBoxEqOwner: TComboBox;
    Label6: TLabel;
    ComboBoxWeType: TComboBox;
    Label7: TLabel;
    EditWeSize: TEdit;
    Label8: TLabel;
    RxSpinEditWeLevel: TRxSpinEdit;
    Label10: TLabel;
    EditWeRadius: TEdit;
    Label9: TLabel;
    ComboBoxWeOwner: TComboBox;
    Label11: TLabel;
    ComboBoxGoType: TComboBox;
    Label12: TLabel;
    EditGoCount: TEdit;
    Label13: TLabel;
    ComboBoxArType: TComboBox;
    Label14: TLabel;
    ComboBoxArOwner: TComboBox;
    Label15: TLabel;
    ComboBoxType: TComboBox;
    Label16: TLabel;
    EditUselessName: TEdit;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FItem:TItem;
end;

var
  FormItem: TFormItem;

implementation

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TItemInterface.Create;
begin
    inherited Create;
    FName:='Item';
    FGroup:=0;
end;

function TItemInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TItem.Create;
    with Result do begin
        FPos:=tpos;
        FText:='ItemNew';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TItem.Create;
begin
    inherited Create;
    FImage:='Item';

    FMainType:=0;
    FType:=0;
    FSize:=10;
    FLavel:=1;
    FRadius:=150;
    FOwner:=6;
end;

destructor TItem.Destroy;
begin
    inherited Destroy;
end;

function TItem.DblClick:boolean;
begin
    Result:=false;
    FormItem.FItem:=self;
    if FormItem.ShowModal=mrOk then Result:=true;
end;

procedure TItem.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.AddInteger(FMainType);
    bd.AddInteger(FType);
    bd.AddInteger(FSize);
    bd.AddInteger(FLavel);
    bd.AddInteger(FRadius);
    bd.AddInteger(FOwner);
    bd.Add(FUseless);
end;

procedure TItem.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FMainType:=bd.GetInteger;
    FType:=bd.GetInteger;
    FSize:=bd.GetInteger;
    FLavel:=bd.GetInteger;
    FRadius:=bd.GetInteger;
    FOwner:=bd.GetInteger;
    if GFileVersion<$00000002 then begin
        if FMainType=4 then FMainType:=5;
    end;
    if GFileVersion>=$00000002 then FUseless:=bd.GetWideStr else FUseless:='';
end;

procedure TItem.LoadLink;
begin
    inherited LoadLink;
end;

procedure TItem.MsgDeletePoint(p:TGraphPoint);
begin
    inherited MsgDeletePoint(p);
end;

function TItem.Info:WideString;
const
    mo:array[0..6] of WideString =('Maloc','Peleng','People','Fei','Gaal','Kling','None');
    me:array[0..6] of WideString =('FuelTanks','Engine','Radar','Scaner','RepairRobot','CargoHook','DefGenerator');
    mw:array[0..14] of WideString =('1=Photon gun','2=Industrial laser','3=Zipgun','4=Graviton beamer','5=Retractor','6=Kelller''s phaser','7=Aeonic blaster','8=X-defibrillator','9=Submesonic cannon','10=Field annihilator','11=Tachyon blade','12=Vortex projector','13=Ultimate matrix','14=Hellwave','15=Eyes of Machpella');
    mg:array[0..9] of WideString =('Food','Medicine','Technics','Luxury','Minerals','Minerals (natural)','Alcohol','Arms','Narcotics','Protoplasm');
    ma:array[0..15] of WideString =('ArtefactHull','ArtefactFuel','ArtefactSpeed','ArtefactPower','ArtefactRadar','ArtefactScaner','ArtefactDroid','ArtefactNano','ArtefactHook','ArtefactDef','ArtefactAnalyzer','ArtefactMiniExpl','ArtefactAntigrav','ArtefactTransmitter','ArtefactBomb','ArtefactTranclucator');
begin
    if FMainType=0 then begin
        Result:=Result+'='+me[FType]+'='+#13#10;
        Result:=Result+'Size  : '+IntToStr(FSize)+#13#10;
        Result:=Result+'Level : '+IntToStr(FLavel)+#13#10;
        Result:=Result+'Owner : '+mo[FOwner];
    end else if FMainType=1 then begin
        Result:=Result+'='+mw[FType]+'='+#13#10;
        Result:=Result+'Size   : '+IntToStr(FSize)+#13#10;
        Result:=Result+'Level  : '+IntToStr(FLavel)+#13#10;
        Result:=Result+'Radius : '+IntToStr(FRadius)+#13#10;
        Result:=Result+'Owner  : '+mo[FOwner];
    end else if FMainType=2 then begin
        Result:=Result+'='+mg[FType]+'='+#13#10;
        Result:=Result+'Count  : '+IntToStr(FSize);
    end else if FMainType=3 then begin
        Result:=Result+'='+ma[FType]+'='+#13#10;
        Result:=Result+'Owner  : '+mo[FOwner];
    end else if FMainType=4 then begin
        Result:=Result+'=Useless='+#13#10;
        Result:=Result+'Name   : '+FUseless;
    end else if FMainType=5 then begin
        Result:=Result+'=Unknown='+#13#10;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormItem.FormShow(Sender: TObject);
begin
    EditName.Text:=FItem.FText;

    ComboBoxType.ItemIndex:=FItem.FMainType;
    Notebook1.ActivePage:=ComboBoxType.Text;

    if FItem.FType>=ComboBoxEqType.Items.Count then ComboBoxEqType.ItemIndex:=0
    else ComboBoxEqType.ItemIndex:=FItem.FType;
    EditEqSize.Text:=IntToStr(FItem.FSize);
    RxSpinEditEqLevel.Value:=FItem.FLavel;
    ComboBoxEqOwner.ItemIndex:=FItem.FOwner;

    if FItem.FType>=ComboBoxWeType.Items.Count then ComboBoxWeType.ItemIndex:=0
    else ComboBoxWeType.ItemIndex:=FItem.FType;
    EditWeSize.Text:=IntToStr(FItem.FSize);
    RxSpinEditWeLevel.Value:=FItem.FLavel;
    EditWeRadius.Text:=IntToStr(FItem.FRadius);
    ComboBoxWeOwner.ItemIndex:=FItem.FOwner;

    if FItem.FType>=ComboBoxGoType.Items.Count then ComboBoxGoType.ItemIndex:=0
    else ComboBoxGoType.ItemIndex:=FItem.FType;
    EditGoCount.Text:=IntToStr(FItem.FSize);

    if FItem.FType>=ComboBoxArType.Items.Count then ComboBoxArType.ItemIndex:=0
    else ComboBoxArType.ItemIndex:=FItem.FType;
    ComboBoxArOwner.ItemIndex:=FItem.FOwner;

    EditUselessName.Text:=FItem.FUseless;
end;

procedure TFormItem.BitBtn1Click(Sender: TObject);
begin
    FItem.FText:=EditName.Text;

    FItem.FUseless:='';

    FItem.FMainType:=ComboBoxType.ItemIndex;
    if FItem.FMainType=0 then begin
        FItem.FType:=ComboBoxEqType.ItemIndex;
        FItem.FSize:=StrToIntEC(EditEqSize.Text);
        FItem.FLavel:=Round(RxSpinEditEqLevel.Value);
        FItem.FOwner:=ComboBoxEqOwner.ItemIndex;
    end else if FItem.FMainType=1 then begin
        FItem.FType:=ComboBoxWeType.ItemIndex;
        FItem.FSize:=StrToIntEC(EditWeSize.Text);
        FItem.FLavel:=Round(RxSpinEditWeLevel.Value);
        FItem.FRadius:=StrToIntEC(EditWeRadius.Text);
        FItem.FOwner:=ComboBoxWeOwner.ItemIndex;
    end else if FItem.FMainType=2 then begin
        FItem.FType:=ComboBoxGoType.ItemIndex;
        FItem.FSize:=StrToIntEC(EditGoCount.Text);
    end else if FItem.FMainType=3 then begin
        FItem.FType:=ComboBoxArType.ItemIndex;
        FItem.FOwner:=ComboBoxArOwner.ItemIndex;
    end else if FItem.FMainType=4 then begin
        FItem.FUseless:=EditUselessName.Text;
    end;
end;

procedure TFormItem.ComboBoxTypeChange(Sender: TObject);
begin
    Notebook1.ActivePage:=ComboBoxType.Text;
end;

end.
