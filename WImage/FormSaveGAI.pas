unit FormSaveGAI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, Grids, EC_Buf;

type
PGAIZag = ^SGAIZag;
SGAIZag = record
    id0,id1,id2,id3:BYTE;
    ver:DWORD;
    rect:TRect;
    count:DWORD;
    series:DWORD;
    smeAnim:DWORD;
    sizeAnim:DWORD;
    r1,r2:DWORD;
end;

  TForm_SaveGAI = class(TForm)
    Label1: TLabel;
    EditFile: TEdit;
    SpeedButton1: TSpeedButton;
    SaveDialog1: TSaveDialog;
    ButtonSave: TButton;
    ButtonClose: TButton;
    Label2: TLabel;
    ComboBoxFormat: TComboBox;
    CheckBoxSeries: TCheckBox;
    MemoText: TMemo;
    Label3: TLabel;
    StringGridAnim: TStringGrid;
    CheckBoxCompress: TCheckBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure BuildAnim(sg:TStringGrid; bd:TBufEC);
    procedure LoadAnim(sg:TStringGrid; bd:TBufEC);
  end;

var
  Form_SaveGAI: TForm_SaveGAI;

implementation

uses EC_Mem,EC_Str,EC_File,FormMain,GraphBuf,GraphBufList,Globals;

{$R *.DFM}

procedure TForm_SaveGAI.FormCreate(Sender: TObject);
begin
    ComboBoxFormat.ItemIndex:=1;
    StringGridAnim.ColWidths[1]:=StringGridAnim.Width-StringGridAnim.ColWidths[0]-30;
end;

procedure TForm_SaveGAI.FormShow(Sender: TObject);
begin
    SaveDialog1.InitialDir:=RegUser_GetString('','SaveGAIPath',GetCurrentDir);
end;

procedure TForm_SaveGAI.SpeedButton1Click(Sender: TObject);
begin
    SaveDialog1.FileName:=EditFile.Text;
    if not SaveDialog1.Execute then Exit;
    EditFile.Text:=SaveDialog1.FileName;

    RegUser_SetString('','SaveGAIPath',File_Path(SaveDialog1.FileName));
end;

procedure TForm_SaveGAI.ButtonSaveClick(Sender: TObject);
var
    i,u,tpos,zn:integer;
    zag:SGAIZag;
    fi:TFileEC;
    bd:TBufEC;
    zaggi:PGIZag;
    giunit:PGIUnit;
//    sumSize0,sumSize1,sumSize2:integer;
    tstr:string;
    sformat:integer;
begin
    fi:=TFileEC.Create;
    bd:=TBufEC.Create;

    Screen.Cursor:=crHourglass;

    MemoText.Clear;

{    sumSize0:=0;
    sumSize1:=0;
    sumSize2:=0;}

    try
        fi.Init(EditFile.Text);
        fi.CreateNew;

        ZeroMemory(@zag,sizeof(SGAIZag));
        zag.id0:=Ord('g');
        zag.id1:=Ord('a');
        zag.id2:=Ord('i');
        zag.ver:=1;
        zag.count:=GBufList.Count;
        zag.series:=0; if CheckBoxSeries.Checked then zag.series:=1;

        zag.rect:=GBufList.Hist[0].CurBuf.GetRect;
        for i:=1 to GBufList.Count-1 do begin
            UnionRect(zag.rect,zag.rect,GBufList.Hist[i].CurBuf.GetRect);
        end;

        fi.Write(@zag,sizeof(SGAIZag));

        bd.Len:=zag.count*8;
        ZeroMemory(bd.Buf,bd.Len);
        fi.Write(bd.Buf,bd.Len);

        BuildAnim(StringGridAnim,bd);
        if bd.Len>0 then begin
            zag.smeAnim:=fi.GetPointer;
            zag.sizeAnim:=bd.Len;
            fi.Write(bd.Buf,bd.Len);
        end;

        for i:=0 to GBufList.Count-1 do begin
            sformat:=ComboBoxFormat.ItemIndex;
            if sformat>4 then sformat:=GBufList.Hist[i].FSaveFormat;
            if sformat=0 then begin
                GBufList.Hist[i].CurBuf.BuildGI_Bitmap(bd);
            end else if sformat=1 then begin
                GBufList.Hist[i].CurBuf.BuildGI_Trans(bd);
            end else if sformat=2 then begin
                GBufList.Hist[i].CurBuf.BuildGI_Alpha(bd);
            end else if sformat=3 then begin
                GBufList.Hist[i].CurBuf.BuildGI_AlphaIndexed8(bd);
            end else if sformat=4 then begin
                GBufList.Hist[i].CurBuf.BuildGI_BitmapPal(bd);
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
{            sumSize0:=sumSize0+zaggi.size0;
            sumSize1:=sumSize1+zaggi.size1;
            sumSize2:=sumSize2+zaggi.size2;}
            tstr:=Format('%d'#9,[i]);
            giunit:=PAdd(bd.Buf,sizeof(SGIZag));
            for u:=0 to zaggi.countUnit-1 do begin
                tstr:=tstr+Format('   Buf%d={%d,(%d,%d,%d,%d)}',[u,giunit.size,giunit.rect.Left,giunit.rect.Top,giunit.rect.Right,giunit.rect.Bottom]);
                giunit:=PAdd(giunit,sizeof(SGIUnit));
            end;

            MemoText.Lines.Add(tstr);
        end;

        fi.SetPointer(0);
        fi.Write(@zag,sizeof(SGAIZag));
//        MemoText.Lines.Add('');
//        MemoText.Lines.Add(Format('All'#9'   SizeBufs=(%d,%d,%d)',[sumSize0,sumSize1,sumSize2]));
    except
        on ex:Exception do begin
            ShowMessage(ex.message);
        end;
    end;

    fi.Free;
    bd.Free;
    Screen.Cursor:=crDefault;
end;

procedure TForm_SaveGAI.BuildAnim(sg:TStringGrid; bd:TBufEC);
var
    tstr:WideString;
    tstr2:WideString;
    t,i,count,u,countu:integer;
    ttime,tstart,tend:integer;
    countframe:integer;
    countgroup:integer;
    tname:WideString;
    smecountframe:integer;
begin
    bd.Clear;

    countgroup:=0;
    for t:=0 to sg.RowCount-1 do begin
        tstr:=trim(sg.Cells[1,t]);
        if tstr<>'' then inc(countgroup);
    end;
    if countgroup<1 then Exit;

    bd.AddDWORD(countgroup);

    for t:=0 to countgroup-1 do begin
        bd.AddDWORD(0);
        bd.AddDWORD(0);
    end;

    for t:=0 to sg.RowCount-1 do begin
        tstr:=trim(sg.Cells[1,t]);
        if tstr='' then continue;

        bd.S(4+8*t,bd.Pointer);

        tname:=trim(sg.Cells[0,t]);
        bd.Add(tname);
        countframe:=0;
        smecountframe:=bd.Pointer;
        bd.S(4+8*t+4,smecountframe);
        bd.AddDWORD(countframe);

        count:=(GetCountParEC(tstr,'[]')-1) div 2;
        for i:=0 to count-1 do begin
            tstr2:=GetStrParEC(tstr,i*2+1,'[]');
            ttime:=StrToIntEC(GetStrParEC(tstr2,0,',-'));
            tstart:=StrToIntEC(GetStrParEC(tstr2,1,',-'));
            tend:=StrToIntEC(GetStrParEC(tstr2,2,',-'));

            countu:=abs(tstart-tend)+1;
            countframe:=countframe+countu;

            for u:=0 to countu-1 do begin
                bd.AddDWORD(tstart);
                bd.AddDWORD(ttime);
                if tstart<tend then inc(tstart) else dec(tstart);
            end;
        end;
        bd.S(smecountframe,countframe);
    end;
end;

procedure TForm_SaveGAI.LoadAnim(sg:TStringGrid; bd:TBufEC);
var
    u,i,countgroup,nextgroup:integer;
    startsme,smename,smeframe:DWORD;
    countframe,tframe,ttime,cstart,cend,ctime:integer;
    tstr:WideString;
begin
    startsme:=bd.Pointer;

    countgroup:=bd.GetDWORD;
    nextgroup:=bd.Pointer;
    for i:=0 to countgroup-1 do begin
        bd.Pointer:=nextgroup;
        smename:=bd.GetDWORD()+startsme;
        smeframe:=bd.GetDWORD()+startsme;
        nextgroup:=bd.Pointer;

        bd.Pointer:=smename;
        sg.Cells[0,i]:=bd.GetWideStr;

        bd.Pointer:=smeframe;
        countframe:=bd.GetDWORD;

        ctime:=-1;
        cstart:=-1;
        cend:=-1;
        tstr:='';

        for u:=0 to countframe-1 do begin
            tframe:=bd.GetDWORD();
            ttime:=bd.GetDWORD();

            if (ctime=ttime) and (((cend>=cstart) and ((cend+1)=tframe)) or ((cend<=cstart) and ((cend-1)=tframe))) then begin
                if ((cend>=cstart) and ((cend+1)=tframe)) then inc(cend) else dec(cend);
            end else begin
                if ctime>=0 then begin
                    tstr:=tstr+'['+IntToStr(ctime)+','+IntToStr(cstart)+'-'+IntToStr(cend)+']'
                end;
                ctime:=ttime;
                cstart:=tframe;
                cend:=tframe;
            end;
        end;
        if ctime>=0 then begin
            tstr:=tstr+'['+IntToStr(ctime)+','+IntToStr(cstart)+'-'+IntToStr(cend)+']'
        end;

        sg.Cells[1,i]:=tstr;
    end;
end;

end.

