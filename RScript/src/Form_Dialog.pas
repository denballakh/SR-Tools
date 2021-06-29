unit Form_Dialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf;

type
TDialogInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TDialog = class(TGraphPoint)
    public
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;
end;

TFormDialog = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FDialog:TDialog;
end;

var
  FormDialog: TFormDialog;

implementation

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialogInterface.Create;
begin
    inherited Create;
    FName:='Dialog';
    FGroup:=3;
end;

function TDialogInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TDialog.Create;
    with Result do begin
        FPos:=tpos;
        FText:='DialogNew';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialog.Create;
begin
    inherited Create;
    FImage:='Dialog';
end;

function TDialog.DblClick:boolean;
begin
    Result:=false;
    FormDialog.FDialog:=self;
    if FormDialog.ShowModal=mrOk then Result:=true;
end;

procedure TDialog.Save(bd:TBufEC);
begin
    inherited Save(bd);
end;

procedure TDialog.Load(bd:TBufEC);
begin
    inherited Load(bd);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormDialog.FormShow(Sender: TObject);
begin
    EditName.Text:=FDialog.FText;
end;

procedure TFormDialog.BitBtn1Click(Sender: TObject);
begin
    FDialog.FText:=EditName.Text;
end;

end.
