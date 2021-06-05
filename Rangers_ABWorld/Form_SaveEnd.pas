unit Form_SaveEnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, EC_BlockPar;

type
  TFormSaveEnd = class(TForm)
    BitBtn1: TBitBtn;
    DGL: TDrawGrid;
    BitBtnAdd: TBitBtn;
    BitBtnDelete: TBitBtn;
    BitBtnSave: TBitBtn;
    BitBtnSaveTest: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure DGLDrawCell(Sender: TObject; ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
    procedure DGLGetEditText(Sender: TObject; ACol, ARow: integer; var Value: string);
    procedure DGLSelectCell(Sender: TObject; ACol, ARow: integer; var CanSelect: boolean);
    procedure DGLSetEditText(Sender: TObject; ACol, ARow: integer; const Value: string);
    procedure BitBtnAddClick(Sender: TObject);
    procedure BitBtnDeleteClick(Sender: TObject);
    procedure BitBtnSaveClick(Sender: TObject);
    procedure BitBtnSaveTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    FBPCD: TBlockParEC;
    FBPMap: TBlockParEC;

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

  FBPCD := TBlockParEC.Create;
  FBPMap := TBlockParEC.Create;

  FBPCD.LoadFromFile(PChar(ansistring(GRangersPath + '\CFG\CD\ABMap.txt')), true);
  FBPMap.LoadFromFile(PChar(ansistring(GRangersPath + '\CFG\ABMap.txt')), true);

  FRowCnt := FBPMap.Block_Count;
  if FRowCnt < 1 then
    DGL.RowCount := 2
  else
    DGL.RowCount := FRowCnt + 1;
end;

procedure TFormSaveEnd.FormHide(Sender: TObject);
begin
  FBPCD.Free;
  FBPCD := nil;
  FBPMap.Free;
  FBPMap := nil;

  ab_OptClear;
end;

procedure TFormSaveEnd.DGLDrawCell(Sender: TObject; ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
var
  tstr: WideString;
begin
  tstr := '';

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
    if ACol = 0 then
      tstr := FBPMap.Block_GetName(ARow - 1)
    else if ACol = 1 then
      tstr := FBPMap.Block_Get(ARow - 1).Par['Portal']
    else
      tstr := FBPMap.Block_Get(ARow - 1).Par['Priority'];

    SaveCanvasPar(DGL.Canvas);
    DGL.Canvas.Font.Style := [];
    DrawRectText(DGL.Canvas, Rect,
      bsClear, 0,
      psClear, 0, 0, 1, -1, 0, false,
      tstr);
    LoadCanvasPar(DGL.Canvas);
  end;
end;

procedure TFormSaveEnd.DGLSelectCell(Sender: TObject; ACol, ARow: integer; var CanSelect: boolean);
begin
  CanSelect := (ARow - 1) < FRowCnt;
end;

procedure TFormSaveEnd.DGLGetEditText(Sender: TObject; ACol, ARow: integer; var Value: string);
begin
  if ((ARow - 1) < 0) or ((ARow - 1) >= FRowCnt) then
    exit;

  if ACol = 0 then
    Value := FBPMap.Block_GetName(ARow - 1)
  else if ACol = 1 then
    Value := FBPMap.Block_Get(ARow - 1).Par['Portal']
  else if ACol = 2 then
    Value := FBPMap.Block_Get(ARow - 1).Par['Priority'];
end;

procedure TFormSaveEnd.DGLSetEditText(Sender: TObject; ACol, ARow: integer; const Value: string);
var
  newname, oldname: WideString;
begin
  if ((ARow - 1) < 0) or ((ARow - 1) >= FRowCnt) then
    exit;

  if ACol = 0 then
  begin
    newname := TrimEx(Value);
    if newname <> '' then
      if FBPMap.Block_GetNE(newname) = nil then
      begin
        oldname := FBPMap.Block_GetName(ARow - 1);

        FBPMap.Block_SetName(ARow - 1, Value);
        FBPMap.Block_Get(ARow - 1).Par_Set('Path', 'ABMap.' + newname);

        FBPCD.Par_SetName(oldname, newname);
        FBPCD.Par_Set(newname, 'data\ABMap\' + newname + '.map');

        FBPCD.Par_SetName(oldname + '_', newname + '_');
        FBPCD.Par_Set(newname + '_', 'data\ABMap\' + newname + '.opt');

        RenameFile(GRangersPath + '\DATA\ABMap\' + oldname + '.map', GRangersPath + '\DATA\ABMap\' + newname + '.map');
        RenameFile(GRangersPath + '\DATA\ABMap\' + oldname + '.opt', GRangersPath + '\DATA\ABMap\' + newname + '.opt');
      end;
  end
  else if ACol = 1 then
    FBPMap.Block_Get(ARow - 1).Par_Set('Portal', Value)
  else if ACol = 2 then
    FBPMap.Block_Get(ARow - 1).Par_Set('Priority', Value);

  FBPCD.SaveInFile(PChar(ansistring(GRangersPath + '\CFG\CD\ABMap.txt')), true);
  FBPMap.SaveInFile(PChar(ansistring(GRangersPath + '\CFG\ABMap.txt')), true);
end;

procedure TFormSaveEnd.BitBtnAddClick(Sender: TObject);
var
  newname: WideString;
begin
  newname := GUIDToStr(NewGUID);
  with FBPMap.Block_Add(newname) do
  begin
    Par_Add('Portal', '1,2,3');
    Par_Add('Priority', '100');
    Par_Add('Path', 'ABMap.' + newname);
  end;
  FBPCD.Par_Add(newname, 'data\ABMap\' + newname + '.map');
  FBPCD.Par_Add(newname + '_', 'data\ABMap\' + newname + '.opt');

  FBPCD.SaveInFile(PChar(ansistring(GRangersPath + '\CFG\CD\ABMap.txt')), true);
  FBPMap.SaveInFile(PChar(ansistring(GRangersPath + '\CFG\ABMap.txt')), true);

  FRowCnt := FRowCnt + 1;
  DGL.RowCount := FRowCnt + 1;
  DGL.Row := FRowCnt + 1 - 1;
  DGL.Repaint;

  BitBtnSaveClick(Sender);
end;

procedure TFormSaveEnd.BitBtnDeleteClick(Sender: TObject);
var
  i: integer;
begin
  i := DGL.Row - 1;
  if (i < 0) or (i >= FRowCnt) then
    exit;

  if MessageBox(Handle, 'Delete ?', 'Query', MB_YESNO or MB_ICONQUESTION) <> idYes then
    exit;

  Name := FBPMap.Block_GetName(i);

  FBPMap.Block_Delete(i);
  FBPCD.Par_Delete(Name);
  FBPCD.Par_Delete(Name + '_');
  DeleteFile(GRangersPath + '\DATA\ABMap\' + Name + '.map');

  FBPCD.SaveInFile(PChar(ansistring(GRangersPath + '\CFG\CD\ABMap.txt')), true);
  FBPMap.SaveInFile(PChar(ansistring(GRangersPath + '\CFG\ABMap.txt')), true);

  FRowCnt := FRowCnt - 1;
  if FRowCnt < 1 then
    DGL.RowCount := 2
  else
    DGL.RowCount := FRowCnt + 1;
  DGL.Repaint;
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

procedure TFormSaveEnd.BitBtnSaveClick(Sender: TObject);
var
  i: integer;
begin
  i := DGL.Row - 1;
  if (i < 0) or (i >= FRowCnt) then
    exit;

  Screen.Cursor := crHourglass;

  Save(GRangersPath + '\DATA\ABMap\' + FBPMap.Block_GetName(i) + '.map',
    GRangersPath + '\DATA\ABMap\' + FBPMap.Block_GetName(i) + '.opt');

  Screen.Cursor := crDefault;
end;

procedure TFormSaveEnd.BitBtnSaveTestClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;

  Save(GRangersPath + '\DATA\edit.map',
    GRangersPath + '\DATA\edit.opt');

  Screen.Cursor := crDefault;
end;

end.