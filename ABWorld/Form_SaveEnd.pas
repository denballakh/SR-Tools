unit Form_SaveEnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, EC_BlockPar;

type
  TFormSaveEnd = class(TForm)
    BitBtn1: TBitBtn;
    DGL: TDrawGrid;
    BitBtnSaveTest: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure DGLDrawCell(Sender: TObject; ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
    procedure BitBtnSaveTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    FRowCnt: integer;
    procedure Save(filename, filename2: WideString);
  end;

var
  FormSaveEnd: TFormSaveEnd;

implementation

uses Form_Main, Global, EC_Str, EC_Buf, EC_File, ABKey, ABPoint, ABTriangle, ABLine,
  WorldUnit, WorldZone, ABOpt;

{$R *.dfm}

procedure TFormSaveEnd.FormShow(Sender: TObject);
begin
  Label1.Caption := '0';
  FRowCnt := 1;
  DGL.RowCount := FRowCnt + 1;
end;

procedure TFormSaveEnd.FormHide(Sender: TObject);
begin
  ab_OptClear;
end;

procedure TFormSaveEnd.DGLDrawCell(Sender: TObject; ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
var
  tstr: WideString;
  mapname: WideString;
begin
  tstr := '';

  if GFileName = '' then mapname := 'NEW' else mapname := File_Name(GFileName);
  if ARow = 0 then
  begin
    if ACol = 0 then
      tstr := 'Name'
    else if ACol = 1 then
      tstr := 'Portal'
    else if ACol = 2 then
      tstr := 'Priority';

    SaveCanvasPar(DGL.Canvas);
    DGL.Canvas.Font.Style := [fsBold];
    DrawRectText(DGL.Canvas, Rect,
      bsClear, 0,
      psClear, 0, 0, 1,
      0, 0, false,
      tstr);
    LoadCanvasPar(DGL.Canvas);

  end
  else if (ARow - 1) < FRowCnt then
  begin

    if ACol = 0 then tstr := mapname
    else if ACol = 1 then tstr := '1'
    else tstr := '100';

    SaveCanvasPar(DGL.Canvas);
    DGL.Canvas.Font.Style := [];
    DrawRectText(DGL.Canvas, Rect,
      bsClear, 0,
      psClear, 0, 0, 1, -1, 0, false,
      tstr);
    LoadCanvasPar(DGL.Canvas);
  end;
end;

procedure TFormSaveEnd.Save(filename, filename2: WideString);
var
  buf, buf2: TBufEC;
  tempbuf: TBufEC;
  fi, fi2: TFileEC;
  zn: DWORD;
begin
  if ab_Opt = nil then
    Label1.Caption := IntToStr(ab_OptBuild);

  SE_ColorKeyBuf := TBufEC.Create;
  buf := TBufEC.Create;
  buf2 := TBufEC.Create;
  tempbuf := TBufEC.Create;

  fi := TFileEC.Create;
  fi.Init(PChar(ansistring(filename)));
  fi.CreateNew;

  fi2 := TFileEC.Create;
  fi2.Init(PChar(ansistring(filename2)));
  fi2.CreateNew;

  WorldUnit_Numerate();

  Point_SaveEnd(buf);
  Line_SaveEnd(buf, tempbuf);
  Zone_SaveEnd(buf);
  Triangle_SaveEnd(buf, tempbuf);
  ab_OptSaveEnd(buf2);
  buf2.Compress;

  zn := $6d776261;
  fi.write(@zn, 4);
  zn := 1;
  fi.write(@zn, 4);
  fi.write(@ab_WorldRadius, sizeof(single));

  fi.write(@(SE_ColorKeyBuf.m_Len), 4);
  fi.write(SE_ColorKeyBuf.Buf, SE_ColorKeyBuf.Len);
  fi.write(buf.Buf, buf.Len);

  fi2.write(buf2.Buf, buf2.Len);

  fi.Free;
  fi2.Free;
  buf.Free;
  buf2.Free;
  tempbuf.Free;
  SE_ColorKeyBuf.Free;
  SE_ColorKeyBuf := nil;

  Point_ClearNo;
end;

procedure TFormSaveEnd.BitBtnSaveTestClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;

  if GFileName = '' then Save(GRangersPath + '\DATA\NEW.map', GRangersPath + '\DATA\NEW.opt')
  else Save(GRangersPath + '\DATA\' + File_Name(GFileName) + '.map', GRangersPath + '\DATA\' + File_Name(GFileName) + '.opt');

  Screen.Cursor := crDefault;
end;

end.