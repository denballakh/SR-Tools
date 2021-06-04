unit Form_UnitPath;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, EC_Str;

type
  TFormUnitPath = class(TForm)
    BitBtn1: TBitBtn;
    DGL: TDrawGrid;
    BitBtn2: TBitBtn;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure DGLDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure DGLGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure DGLSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    FPathIn:TStringsEC;
    FPathOut:TStringsEC;
    FCnt:integer;
  end;

var
  FormUnitPath: TFormUnitPath;

implementation

uses WorldUnit,Global,aPathBuild,Form_Main;

{$R *.dfm}

procedure TFormUnitPath.FormShow(Sender: TObject);
var
	wu:TabWorldUnit;
begin
	if FPathIn<>nil then begin FPathIn.Free; FPathIn:=nil; end;
	if FPathOut<>nil then begin FPathOut.Free; FPathOut:=nil; end;
    FPathIn:=TStringsEC.Create;
    FPathOut:=TStringsEC.Create;

	wu:=WorldUnit_First;
    while wu<>nil do begin
    	if FPathIn.Find(wu.FFileName)<0 then begin
			FPathIn.Add(wu.FFileName);
			FPathOut.Add(wu.FFileName);
        end;
    	wu:=wu.FNext;
    end;
    FPathIn.SortBuble;
    FPathOut.SortBuble;

    FCnt:=FPathIn.GetCount;

    if FCnt<1 then begin
	    DGL.RowCount:=1;
    end else begin
	    DGL.RowCount:=FCnt;
    end;
end;

procedure TFormUnitPath.FormHide(Sender: TObject);
begin
	if FPathIn<>nil then begin FPathIn.Free; FPathIn:=nil; end;
	if FPathOut<>nil then begin FPathOut.Free; FPathOut:=nil; end;
end;

procedure TFormUnitPath.DGLDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
	tstr:WideString;
begin
	if (FCnt>0) and (ARow>=0) and (ARow<FCnt) then begin
		tstr:=FPathOut.Item[ARow];

		SaveCanvasPar(DGL.Canvas);
	    DGL.Canvas.Font.Style:=[];
		DrawRectText(DGL.Canvas,Rect,
    				 bsClear,0,
        	   	     psClear,0,0,1,
            	   	 -1,0,false,
	            	 tstr);
	    LoadCanvasPar(DGL.Canvas);
    end;
end;

procedure TFormUnitPath.DGLGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
	Value:=FPathOut.Item[ARow];
end;

procedure TFormUnitPath.DGLSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
	FPathOut.Item[ARow]:=Value;
end;

procedure TFormUnitPath.BitBtn1Click(Sender: TObject);
var
	i:integer;
    sin,sout:WideString;
	wu:TabWorldUnit;
begin
	for i:=0 to FCnt-1 do begin
		sin:=FPathIn.Item[i];
        sout:=FPathOut.Item[i];
        if sin<>sout then begin

			wu:=WorldUnit_First;
		    while wu<>nil do begin
    			if wu.FFileName=sin then begin
	                wu.FFileName:=sout;
		        end;
    			wu:=wu.FNext;
		    end;

        end;
    end;
	ModalResult:=mrOk;
end;

procedure TFormUnitPath.Button1Click(Sender: TObject);
begin
	if FCnt<1 then Exit;
//    OpenDialog1.FileName:=FPathOut.Item[DGL.Row];
    if not OpenDialog1.Execute then Exit;

    FPathOut.Item[DGL.Row]:=BuildPathRel(LowerCaseEx(BuildPathTrim(OpenDialog1.FileName)),GUnitPath);
    DGL.Invalidate;
end;

end.
