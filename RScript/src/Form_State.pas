unit Form_State;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf,EC_Str, RXCtrls, ComCtrls;

type
TStateInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TState = class(TGraphPoint)
    public
        FMove:integer; // 0-None 1-Move 2-Follow 3-Jump 4-Landing
        FMoveObj:TGraphPoint; //

        FAttack:TList;

        FTakeItem:TGraphPoint;
        FTakeAllItem:boolean;

        FMsgOut,FMsgIn:WideString;

        FEType:integer;
        FEUnique:WideString;
        FEMsg:WideString;
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

TFormState = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    ComboBoxMove: TComboBox;
    LabelMoveObj: TLabel;
    ComboBoxMoveObj: TComboBox;
    CheckListAttack: TRxCheckListBox;
    Label3: TLabel;
    Label4: TLabel;
    ComboBoxTakeItem: TComboBox;
    CheckBoxTakeAllItem: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MemoMsgOut: TMemo;
    MemoMsgIn: TMemo;
    TabSheet3: TTabSheet;
    Label5: TLabel;
    ComboBoxEType: TComboBox;
    Label6: TLabel;
    EditEUnique: TEdit;
    MemoEMsg: TMemo;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBoxMoveChange(Sender: TObject);
    procedure CheckListAttackClickCheck(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }

    FState:TState;

    procedure FillMoveObj(mt:integer; cur:TGraphPoint);
    procedure UpdateAttackList;
end;

var
  FormState: TFormState;

implementation

uses Main,Form_Group,Form_Star,Form_Planet,Form_Place,Form_Item,
Form_StarShip;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStateInterface.Create;
begin
    inherited Create;
    FName:='State';
    FGroup:=2;
end;

function TStateInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TState.Create;
    with Result do begin
        FPos:=tpos;
        FText:='StateNew';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TState.Create;
begin
    inherited Create;
    FImage:='State';

    FMove:=0;
    FMoveObj:=nil;

    FAttack:=TList.Create;

    FTakeItem:=nil;
    FTakeAllItem:=false;

    FEType:=1;
end;

destructor TState.Destroy;
begin
    FAttack.Free; FAttack:=nil;
    inherited Destroy;
end;

function TState.DblClick:boolean;
begin
    Result:=false;
    FormState.FState:=self;
    if FormState.ShowModal=mrOk then Result:=true;
end;

procedure TState.Save(bd:TBufEC);
var
    i:integer;
begin
    inherited Save(bd);

    bd.AddInteger(FMove);
    bd.AddDWORD(GGraphPoint.IndexOf(FMoveObj));

    bd.AddInteger(FAttack.Count);
    for i:=0 to FAttack.Count-1 do begin
        bd.AddDWORD(GGraphPoint.IndexOf(FAttack.Items[i]));
    end;

    bd.AddDWORD(GGraphPoint.IndexOf(FTakeItem));
    bd.AddBoolean(FTakeAllItem);

    bd.Add(FMsgOut);
    bd.Add(FMsgIn);

    bd.AddInteger(FEType);
    bd.Add(FEUnique);
    bd.Add(FEMsg);
end;

procedure TState.Load(bd:TBufEC);
var
    i,cnt:integer;
begin
    inherited Load(bd);

    FMove:=bd.GetInteger;
    FMoveObj:=TGraphPoint(bd.GetDWORD);

    FAttack.Clear;
    cnt:=bd.GetInteger;
    for i:=0 to cnt-1 do begin
        FAttack.Add(TGraphPoint(bd.GetDWORD));
    end;

    FTakeItem:=TGraphPoint(bd.GetDWORD);
    FTakeAllItem:=bd.GetBoolean;

    FMsgOut:=bd.GetWideStr;
    FMsgIn:=bd.GetWideStr;

    FEType:=bd.GetInteger;
    FEUnique:=bd.GetWideStr;
    FEMsg:=bd.GetWideStr;
end;

procedure TState.LoadLink;
var
    i:integer;
begin
    inherited LoadLink;
    if integer(DWORD(FMoveObj))=-1 then FMoveObj:=nil
    else FMoveObj:=GGraphPoint.Items[DWORD(FMoveObj)];

    for i:=0 to FAttack.Count-1 do begin
        if integer(DWORD(FAttack.Items[i]))=-1 then FAttack.Items[i]:=nil
        else FAttack.Items[i]:=GGraphPoint.Items[DWORD(FAttack.Items[i])];
    end;

    if integer(DWORD(FTakeItem))=-1 then FTakeItem:=nil
    else FTakeItem:=GGraphPoint.Items[DWORD(FTakeItem)];
end;

procedure TState.MsgDeletePoint(p:TGraphPoint);
begin
    inherited MsgDeletePoint(p);
    if FMoveObj=p then FMoveObj:=nil;

    if FTakeItem=p then FTakeItem:=nil;

    if FAttack.IndexOf(p)>=0 then FAttack.Delete(FAttack.IndexOf(p));
end;

function TState.Info:WideString;
var
    i:integer;
begin
    Result:='';
    if FMove=0 then begin
        Result:=Result+'Move : None'+#13#10;
    end else if FMove=1 then begin
        Result:=Result+'Move : Move';
        if FMoveObj=nil then Result:=Result+' (unknown)'+#13#10
        else Result:=Result+' ('+FMoveObj.FText+')'#13#10;
    end else if FMove=2 then begin
        Result:=Result+'Move : Follow';
        if FMoveObj=nil then Result:=Result+' (unknown)'+#13#10
        else Result:=Result+' ('+FMoveObj.FText+')'#13#10;
    end else if FMove=3 then begin
        Result:=Result+'Move : Jump';
        if FMoveObj=nil then Result:=Result+' (unknown)'+#13#10
        else Result:=Result+' ('+FMoveObj.FText+')'#13#10;
    end else if FMove=4 then begin
        Result:=Result+'Move : Landing';
        if FMoveObj=nil then Result:=Result+' (unknown)'+#13#10
        else Result:=Result+' ('+FMoveObj.FText+')'#13#10;
    end;

    if FAttack.Count>0 then begin
        Result:=Result+'Attack : ';
        for i:=0 to FAttack.Count-1 do begin
            if i<>0 then Result:=Result+',';
            Result:=Result+TGraphPoint(FAttack.Items[i]).FText;
        end;
        Result:=Result+#13#10;
    end;

    if FTakeItem<>nil then begin
        Result:=Result+'Take item : '+FTakeItem.FText+#13#10;
    end;

    if FTakeAllItem then begin
        Result:=Result+'Take all item'+#13#10;
    end;

    if (FMsgOut<>'') or (FMsgIn<>'') or (FEMsg<>'') then begin
        Result:=Result+'~';

        if Length(FMsgOut)<=40 then begin
            Result:=Result+FMsgOut+#13#10;
        end else begin
            Result:=Result+Copy(FMsgOut,1,40)+' ...'+#13#10;
        end;

        Result:=Result+'~';

        if Length(FMsgIn)<=40 then begin
            Result:=Result+FMsgIn+#13#10;
        end else begin
            Result:=Result+Copy(FMsgIn,1,40)+' ...'+#13#10;
        end;

        Result:=Result+'~';

        if Length(FEMsg)<=40 then begin
            Result:=Result+FEMsg+#13#10;
        end else begin
            Result:=Result+Copy(FEMsg,1,40)+' ...'+#13#10;
        end;

        Result:=BuildRazd(Result);
    end;

    Result:=TrimEx(Result);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormState.FillMoveObj(mt:integer; cur:TGraphPoint);
var
    i:integer;
    gp:TGraphPoint;
begin
    if mt=0 then begin
        LabelMoveObj.Visible:=false;
        ComboBoxMoveObj.Visible:=false;
        ComboBoxMoveObj.Items.Clear;
        ComboBoxMoveObj.Items.Add('unknown');
        ComboBoxMoveObj.Items.Objects[0]:=nil;
        ComboBoxMoveObj.ItemIndex:=0;
    end else if mt=1 then begin
        LabelMoveObj.Visible:=true;
        LabelMoveObj.Caption:='Position :';
        ComboBoxMoveObj.Visible:=true;
        ComboBoxMoveObj.Items.Clear;
        ComboBoxMoveObj.Items.Add('unknown');
        ComboBoxMoveObj.Items.Objects[0]:=nil;
        if cur=nil then ComboBoxMoveObj.ItemIndex:=0;

        for i:=0 to GGraphPoint.Count-1 do begin
            gp:=GGraphPoint.Items[i];
            if gp is TPlace then begin
                ComboBoxMoveObj.Items.Add(gp.FText);
                ComboBoxMoveObj.Items.Objects[ComboBoxMoveObj.Items.Count-1]:=gp;
                if gp=cur then ComboBoxMoveObj.ItemIndex:=ComboBoxMoveObj.Items.Count-1;
            end;
        end;

    end else if mt=2 then begin
        LabelMoveObj.Visible:=true;
        LabelMoveObj.Caption:='Group :';
        ComboBoxMoveObj.Visible:=true;
        ComboBoxMoveObj.Items.Clear;
        ComboBoxMoveObj.Items.Add('unknown');
        ComboBoxMoveObj.Items.Objects[0]:=nil;
        if cur=nil then ComboBoxMoveObj.ItemIndex:=0;

        for i:=0 to GGraphPoint.Count-1 do begin
            gp:=GGraphPoint.Items[i];
            if gp is TGroup then begin
                ComboBoxMoveObj.Items.Add(gp.FText);
                ComboBoxMoveObj.Items.Objects[ComboBoxMoveObj.Items.Count-1]:=gp;
                if gp=cur then ComboBoxMoveObj.ItemIndex:=ComboBoxMoveObj.Items.Count-1;
            end;
        end;

    end else if mt=3 then begin
        LabelMoveObj.Visible:=true;
        LabelMoveObj.Caption:='Object :';
        ComboBoxMoveObj.Visible:=true;
        ComboBoxMoveObj.Items.Clear;
        ComboBoxMoveObj.Items.Add('unknown');
        ComboBoxMoveObj.Items.Objects[0]:=nil;
        if cur=nil then ComboBoxMoveObj.ItemIndex:=0;

        for i:=0 to GGraphPoint.Count-1 do begin
            gp:=GGraphPoint.Items[i];
            if gp is TStar then begin
                ComboBoxMoveObj.Items.Add(gp.FText);
                ComboBoxMoveObj.Items.Objects[ComboBoxMoveObj.Items.Count-1]:=gp;
                if gp=cur then ComboBoxMoveObj.ItemIndex:=ComboBoxMoveObj.Items.Count-1;
            end;
        end;
    end else if mt=4 then begin
        LabelMoveObj.Visible:=true;
        LabelMoveObj.Caption:='Object :';
        ComboBoxMoveObj.Visible:=true;
        ComboBoxMoveObj.Items.Clear;
        ComboBoxMoveObj.Items.Add('unknown');
        ComboBoxMoveObj.Items.Objects[0]:=nil;
        if cur=nil then ComboBoxMoveObj.ItemIndex:=0;

        for i:=0 to GGraphPoint.Count-1 do begin
            gp:=GGraphPoint.Items[i];
            if (gp is TPlanet) then begin
                ComboBoxMoveObj.Items.Add(gp.FText);
                ComboBoxMoveObj.Items.Objects[ComboBoxMoveObj.Items.Count-1]:=gp;
                if gp=cur then ComboBoxMoveObj.ItemIndex:=ComboBoxMoveObj.Items.Count-1;
            end;
        end;
{        for i:=0 to GGraphPoint.Count-1 do begin
            gp:=GGraphPoint.Items[i];
            if (gp is TRuins) then begin
                ComboBoxMoveObj.Items.Add(gp.FText);
                ComboBoxMoveObj.Items.Objects[ComboBoxMoveObj.Items.Count-1]:=gp;
                if gp=cur then ComboBoxMoveObj.ItemIndex:=ComboBoxMoveObj.Items.Count-1;
            end;
        end;}
        for i:=0 to GGraphPoint.Count-1 do begin
            gp:=GGraphPoint.Items[i];
            if (gp is TGroup) then begin
                ComboBoxMoveObj.Items.Add(gp.FText);
                ComboBoxMoveObj.Items.Objects[ComboBoxMoveObj.Items.Count-1]:=gp;
                if gp=cur then ComboBoxMoveObj.ItemIndex:=ComboBoxMoveObj.Items.Count-1;
            end;
        end;
    end;
end;

procedure TFormState.UpdateAttackList;
var
    i:integer;
    gp:TGraphPoint;
begin
    CheckListAttack.Clear;
    for i:=0 to FState.FAttack.Count-1 do begin
        gp:=FState.FAttack.Items[i];
        CheckListAttack.Items.Add(gp.FText);
        CheckListAttack.Items.Objects[CheckListAttack.Items.Count-1]:=gp;
        CheckListAttack.Checked[CheckListAttack.Items.Count-1]:=true;
    end;

    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp is TGroup then begin
            if FState.FAttack.IndexOf(gp)<0 then begin
                CheckListAttack.Items.Add(gp.FText);
                CheckListAttack.Items.Objects[CheckListAttack.Items.Count-1]:=gp;
            end;
        end;
    end;
end;

procedure TFormState.ComboBoxMoveChange(Sender: TObject);
begin
    FillMoveObj(ComboBoxMove.ItemIndex,nil);
end;

procedure TFormState.FormShow(Sender: TObject);
var
    i:integer;
    gp:TGraphPoint;
begin
    EditName.Text:=FState.FText;

    ComboBoxMove.ItemIndex:=FState.FMove;
    FillMoveObj(FState.FMove,FState.FMoveObj);

    ComboBoxTakeItem.Clear;
    ComboBoxTakeItem.Items.Add('none');
    ComboBoxTakeItem.Items.Objects[0]:=nil;
    ComboBoxTakeItem.ItemIndex:=0;

    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp is TItem then begin
            ComboBoxTakeItem.Items.Add(gp.FText);
            ComboBoxTakeItem.Items.Objects[ComboBoxTakeItem.Items.Count-1]:=gp;
            if (FState.FTakeItem=gp) then ComboBoxTakeItem.ItemIndex:=ComboBoxTakeItem.Items.Count-1;
        end;
    end;

    CheckBoxTakeAllItem.Checked:=FState.FTakeAllItem;

    MemoMsgOut.Text:=FState.FMsgOut;
    MemoMsgIn.Text:=FState.FMsgIn;

    ComboBoxEType.ItemIndex:=FState.FEType;
    EditEUnique.Text:=FState.FEUnique;
    MemoEMsg.Text:=FState.FEMsg;

    UpdateAttackList;
end;

procedure TFormState.BitBtn1Click(Sender: TObject);
var
    i:integer;
begin
    FState.FText:=EditName.Text;

    FState.FMove:=ComboBoxMove.ItemIndex;
    FState.FMoveObj:=ComboBoxMoveObj.Items.Objects[ComboBoxMoveObj.ItemIndex] as TGraphPoint;

    FState.FAttack.Clear;
    for i:=0 to CheckListAttack.Items.Count-1 do begin
        if CheckListAttack.Checked[i] then begin
            FState.FAttack.Add(CheckListAttack.Items.Objects[i]);
        end;
    end;

    FState.FTakeItem:=ComboBoxTakeItem.Items.Objects[ComboBoxTakeItem.ItemIndex] as TGraphPoint;

    FState.FMsgOut:=MemoMsgOut.Text;
    FState.FMsgIn:=MemoMsgIn.Text;

    FState.FEType:=ComboBoxEType.ItemIndex;
    FState.FEUnique:=EditEUnique.Text;
    FState.FEMsg:=MemoEMsg.Text;

    FState.FTakeAllItem:=CheckBoxTakeAllItem.Checked;
end;

procedure TFormState.CheckListAttackClickCheck(Sender: TObject);
var
    i:integer;
    obj:TObject;
    str:WideString;
begin
    if CheckListAttack.Checked[CheckListAttack.ItemIndex] then begin
        i:=CheckListAttack.ItemIndex-1;
        while i>=0 do begin
            if CheckListAttack.Checked[i] then break;
            str:=CheckListAttack.Items[i];
            obj:=CheckListAttack.Items.Objects[i];
            CheckListAttack.Items[i]:=CheckListAttack.Items[i+1];
            CheckListAttack.Items.Objects[i]:=CheckListAttack.Items.Objects[i+1];
            CheckListAttack.Items[i+1]:=str;
            CheckListAttack.Items.Objects[i+1]:=obj;

            CheckListAttack.Checked[i]:=True;
            CheckListAttack.Checked[i+1]:=False;

            CheckListAttack.ItemIndex:=i;

            dec(i);
        end;
    end else begin
        i:=CheckListAttack.ItemIndex+1;
        while i<CheckListAttack.Items.Count do begin
            if not CheckListAttack.Checked[i] then break;
            str:=CheckListAttack.Items[i];
            obj:=CheckListAttack.Items.Objects[i];
            CheckListAttack.Items[i]:=CheckListAttack.Items[i-1];
            CheckListAttack.Items.Objects[i]:=CheckListAttack.Items.Objects[i-1];
            CheckListAttack.Items[i-1]:=str;
            CheckListAttack.Items.Objects[i-1]:=obj;

            CheckListAttack.Checked[i]:=False;
            CheckListAttack.Checked[i-1]:=True;

            CheckListAttack.ItemIndex:=i;

            inc(i);
        end;
    end;
end;

procedure TFormState.SpeedButton1Click(Sender: TObject);
begin
    EditEUnique.Text:=GUIDToStr(NewGuid);
end;

end.

