unit FormBuildGAIAnim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolEdit, StdCtrls, Mask,GraphBuf,Grids;

type
  TForm_BuildGAIAnim = class(TForm)
    Label2: TLabel;
    FilenameEditDes: TFilenameEdit;
    ButtonBuild: TButton;
    ButtonClose: TButton;
    ListBoxFiles: TListBox;
    ButtonLoad: TButton;
    MemoText: TMemo;
    OpenDialogFile: TOpenDialog;
    CheckBoxSeries: TCheckBox;
    CheckBoxFillAlpha255: TCheckBox;
    ComboBoxFormat: TComboBox;
    Label1: TLabel;
    EditRadius: TEdit;
    CheckBoxCopyEnd: TCheckBox;
    CheckBoxCompress: TCheckBox;
    Label4: TLabel;
    EditScale: TEdit;
    Label5: TLabel;
    ComboBoxFilter: TComboBox;
    Label6: TLabel;
    EditFrame: TEdit;
    Label9: TLabel;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CopyNo0(des,sou:TGraphBuf);

    procedure Build(filedes:AnsiString; soufile:TStrings; alphafill255:boolean; series:boolean; copyend:boolean; radius:single; sg:TStringGrid; rformat:integer; autosize:boolean);
  end;

var
  Form_BuildGAIAnim: TForm_BuildGAIAnim;

implementation

uses EC_Mem,EC_Str,EC_File,EC_Buf,FormMain,GraphBufList,Globals,
  FormDifferent,FormSaveGAI,OImage;

{$R *.DFM}

procedure TForm_BuildGAIAnim.FormCreate(Sender: TObject);
begin
    ComboBoxFormat.ItemIndex:=1;
    ComboBoxFilter.ItemIndex:=5;
end;

procedure TForm_BuildGAIAnim.FormShow(Sender: TObject);
begin
    OpenDialogFile.InitialDir:=RegUser_GetString('','BuildGAIAnimPath',GetCurrentDir);
end;

procedure TForm_BuildGAIAnim.ButtonLoadClick(Sender: TObject);
var
    i,u:integer;
begin
    if not OpenDialogFile.Execute then Exit;

    RegUser_SetString('','BuildGAIAnimPath',File_Path(OpenDialogFile.FileName));

    for i:=0 to OpenDialogFile.Files.Count-1 do begin
        for u:=0 to i do begin
            if CompareStr(OpenDialogFile.Files.Strings[i],OpenDialogFile.Files.Strings[u])<0 then begin
                OpenDialogFile.Files.Exchange(i,u);
            end;
        end;
    end;

    ListBoxFiles.Items.Clear;
    for i:=0 to OpenDialogFile.Files.Count-1 do begin
        ListBoxFiles.Items.Add(OpenDialogFile.Files.Strings[i]);
    end;

    EditFrame.Text:='[50,0-'+IntToStr(OpenDialogFile.Files.Count-1)+']';
end;

procedure TForm_BuildGAIAnim.ButtonBuildClick(Sender: TObject);
var
    sg:TStringGrid;
begin
    Screen.Cursor:=crHourglass;

    sg:=TStringGrid.Create(self);
    sg.RowCount:=1;
    sg.ColCount:=2;
    sg.Cells[0,0]:='';
    sg.Cells[1,0]:=EditFrame.Text;

    Build(FilenameEditDes.Text,ListBoxFiles.Items,CheckBoxFillAlpha255.Checked,CheckBoxSeries.Checked,CheckBoxCopyEnd.Checked,StrToIntEC(EditRadius.Text),sg,ComboBoxFormat.ItemIndex,true);

    sg.Free;

    Screen.Cursor:=crDefault;
end;

procedure TForm_BuildGAIAnim.Build(filedes:AnsiString; soufile:TStrings; alphafill255:boolean; series:boolean; copyend:boolean; radius:single; sg:TStringGrid; rformat:integer; autosize:boolean);
var
    i,u,tpos,zn:integer;
//    x,y:integer;
    gb1,gb2,gb3,gbt,tbuf:TGraphBuf;
    req:single;
    fi:TFileEC;
    bd:TBufEC;
    zag:SGAIZag;
    zaggi:PGIZag;
    giunit:PGIUnit;
    tr:TRect;
    tstr:string;
    scalex,scaley:integer;

    procedure SwapBuf(var b1:TGraphBuf; var b2:TGraphBuf);
    var
        bt:TGraphBuf;
    begin
        bt:=b1; b1:=b2; b2:=bt;
    end;
begin
    MemoText.Clear;
    if soufile.Count<2 then Exit;

    if GetCountParEC(EditScale.Text,',')<>2 then Exit;
    scalex:=StrToIntEC(GetStrParEC(EditScale.Text,0,','));
    scaley:=StrToIntEC(GetStrParEC(EditScale.Text,1,','));
    if (scalex<1) or (scaley<1) then Exit;

    fi:=TFileEC.Create;
    bd:=TBufEC.Create;
    gb1:=TGraphBuf.Create;
    gb2:=TGraphBuf.Create;
    gb3:=TGraphBuf.Create;
    tbuf:=TGraphBuf.Create;

    req:=sqr(radius/256);

    fi.Init(filedes);
    fi.CreateNew;

    ZeroMemory(@zag,sizeof(SGAIZag));
    zag.id0:=Ord('g');
    zag.id1:=Ord('a');
    zag.id2:=Ord('i');
    zag.ver:=1;
    zag.count:=soufile.Count;
    zag.series:=0; if series then zag.series:=1;

{    zag.rect:=GBufList.Hist[0].CurBuf.GetRect;
    for i:=1 to GBufList.Count-1 do begin
        UnionRect(zag.rect,zag.rect,GBufList.Hist[i].CurBuf.GetRect);
    end;}
    fi.Write(@zag,sizeof(SGAIZag));

    bd.Len:=zag.count*8;
    ZeroMemory(bd.Buf,bd.Len);
    fi.Write(bd.Buf,bd.Len);

    if sg<>nil then begin
        Form_SaveGAI.BuildAnim(sg,bd);
        if bd.Len>0 then begin
            zag.smeAnim:=fi.GetPointer;
            zag.sizeAnim:=bd.Len;
            fi.Write(bd.Buf,bd.Len);
        end;
    end;

    try
//        if not CheckBoxSeries.Checked then begin
            gb1.LoadRGBA(soufile.Strings[0]);
            if alphafill255 then gb1.FillRectChannel(3,Rect(0,0,gb1.FLenX,gb1.FLenY),255);
            if (gb1.FLenX<>scalex) or (gb1.FLenY<>scaley) then begin
                tbuf.ImageCreate(scalex,scaley,gb1.FChannels);
                OKGF_Rescale(tbuf.FBuf,tbuf.FLenX,tbuf.FLenY,tbuf.FLenLine,
                             gb1.FBuf,gb1.FLenX,gb1.FLenY,gb1.FLenLine,
                             gb1.FChannels,ComboBoxFilter.ItemIndex);
                SwapBuf(gb1,tbuf);
            end;

            for i:=0 to soufile.Count-1 do begin
                MemoText.Lines.Add(Format('%d-   %s',[i,soufile.Strings[i]]));

                gb2.LoadRGBA(soufile.Strings[i]);
                if alphafill255 then gb2.FillRectChannel(3,Rect(0,0,gb2.FLenX,gb2.FLenY),255);
                if (gb2.FLenX<>scalex) or (gb2.FLenY<>scaley) then begin
                    tbuf.ImageCreate(scalex,scaley,gb2.FChannels);
                    OKGF_Rescale(tbuf.FBuf,tbuf.FLenX,tbuf.FLenY,tbuf.FLenLine,
                                 gb2.FBuf,gb2.FLenX,gb2.FLenY,gb2.FLenLine,
                                 gb2.FChannels,ComboBoxFilter.ItemIndex);
                    SwapBuf(gb2,tbuf);
                end;

                gb3.ImageCreate(gb2.FLenX,gb2.FLenY,gb2.FChannels,gb2.FLenLine);

                Form_Different.Different(gb3,gb1,gb2,0,req);
                tr:=OCutOffAlphaCalc(gb3,0);
                if (tr.right-tr.left)>0 then begin
                    if not autosize then tr:=gb3.GetRect;
                    if (zag.rect.right-zag.rect.left)<=0 then zag.rect:=tr else UnionRect(zag.rect,zag.rect,tr);
                end;

{tbuf.ImageCreate(gb3.FLenX,gb3.FLenY,gb3.FChannels);
tbuf.FillZero;
for y:=0 to gb3.FLenY-1 do begin
    for x:=0 to gb3.FLenX-1 do begin
        if PGetDWORD(gb3.PixelBuf(x,y))<>0 then begin
            PSet(tbuf.PixelBuf(x,y),DWORD($ffffffff));
        end;
    end;
end;
if i<10 then tbuf.WritePNG('c:\#####0'+IntToStr(i)+'.png')
else tbuf.WritePNG('c:\#####'+IntToStr(i)+'.png');}

                if rformat=1 then begin
                    gb3.BuildGI_Trans(bd,autosize);
                end else if rformat=2 then begin
                    gb3.BuildGI_Alpha(bd,autosize);
                end else if rformat=3 then begin
                    gb3.BuildGI_AlphaIndexed8(bd,autosize);
                end;

                if CheckBoxCompress.Checked then bd.Compress;
                tpos:=fi.GetPointer;
                fi.SetPointer(sizeof(SGAIZag)+i*8);
                fi.Write(@tpos,4);
                zn:=bd.Len;
                fi.Write(@zn,4);
                fi.SetPointer(tpos);
                fi.Write(bd.Buf,bd.Len);
                if CheckBoxCompress.Checked then bd.Uncompress;

                zaggi:=bd.Buf;
                tstr:=#9;
                giunit:=PAdd(bd.Buf,sizeof(SGIZag));
                for u:=0 to zaggi.countUnit-1 do begin
                    tstr:=tstr+Format('   Buf%d={%d,(%d,%d,%d,%d)}',[u,giunit.size,giunit.rect.Left,giunit.rect.Top,giunit.rect.Right,giunit.rect.Bottom]);
                    giunit:=PAdd(giunit,sizeof(SGIUnit));
                end;

                MemoText.Lines.Add(tstr);

                if series then begin
                    if not copyend then begin
                        gbt:=gb1; gb1:=gb2; gb2:=gbt;
                    end else begin
                        CopyNo0(gb1,gb3);
                    end;
                end;

{if i<10 then gb1.WritePNG('c:\###_00'+IntToStr(i)+'.png')
else if i<100 then gb1.WritePNG('c:\###_0'+IntToStr(i)+'.png')
else gb1.WritePNG('c:\###_'+IntToStr(i)+'.png');}

            end;

    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;

    fi.SetPointer(0);
    fi.Write(@zag,sizeof(SGAIZag));

    tbuf.Free;
    gb1.Free;
    gb2.Free;
    gb3.Free;
    fi.Free;
    bd.Free;
end;

procedure TForm_BuildGAIAnim.CopyNo0(des,sou:TGraphBuf);
var
    tr:TRect;
    sousmex,sousmey,dessmex,dessmey,lenx,leny:integer;
    x,y:integer;
    col:DWORD;
begin
    tr:=des.GetRectIntersect(sou);

    sousmex:=tr.Left-sou.FPos.x;
    sousmey:=tr.Top-sou.FPos.y;
    dessmex:=tr.Left-des.FPos.x;
    dessmey:=tr.Top-des.FPos.y;
    lenx:=tr.Right-tr.Left;
    leny:=tr.Bottom-tr.Top;

    for y:=0 to leny-1 do begin
        for x:=0 to lenx-1 do begin
            col:=PGetDWORD(sou.PixelBuf(sousmex+x,sousmey+y));

            if col<>0 then PSet(des.PixelBuf(dessmex+x,dessmey+y),DWORD(col));
        end;
    end;
end;

end.
