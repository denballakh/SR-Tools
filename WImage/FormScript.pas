unit FormScript;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit, ExtCtrls,EC_Thread,EC_Expression,syncobjs,
  ComCtrls,GAIBuild,GraphBuf,Globals,EC_Buf,OImage;

type
TThreadRun=class(TThreadEC)
    public
    public
        procedure Execute; override;
end;

  TForm_Script = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    FilenameScript: TFilenameEdit;
    ButtonRun: TButton;
    ButtonCancelRun: TButton;
    TimerConsole: TTimer;
    MemoConsole: TRichEdit;
    procedure ButtonRunClick(Sender: TObject);
    procedure TimerConsoleTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonCancelRunClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
        FFun:TVarArrayEC;
        FCreateOk:boolean;
        FCode:TCodeEC;
        FThreadRun:TThreadRun;

        FConsole:WideString;
        FCS:TCriticalSection;
        FStateBreak:boolean;

        procedure SF_Add;
 end;

var
  Form_Script: TForm_Script;

implementation

uses EC_File, EC_Str, FromBuildGAIGroup, FormCorrectImageByAlpha, FormRescale;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TThreadRun.Execute;
begin
    Form_Script.FStateBreak:=false;
    try
        Form_Script.FCode.RunDebug(Form_Script.FStateBreak);
    except
        on ex:ExceptionExpressionEC do Form_Script.MemoConsole.Lines.Text:=Form_Script.MemoConsole.Lines.Text+'Runtime error: '+ex.Message;
    end;
    Form_Script.FCode.Free;
    Form_Script.FCode:=nil;

    Form_Script.ButtonRun.Enabled:=true;
    Form_Script.ButtonCancelRun.Enabled:=false;
    Form_Script.TimerConsole.Enabled:=false;
    Form_Script.TimerConsoleTimer(nil);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function LoadCodeFromFile(filename:WideString; var loadcode:WideString):boolean;
var
    tstr:AnsiString;
    fi:TFileEC;
    len:integer;
begin
    loadcode:='';

    fi:=TFileEC.Create;
    fi.Init(filename);
    if not fi.OpenReadNE then begin
        fi.Free;
        Result:=false;
        Exit;
    end;
    len:=fi.GetSize;
    if len>0 then begin
        SetLength(tstr,len);
        fi.Read(PAnsiChar(tstr),len);
        loadcode:=tstr;
    end;
    fi.Free;
    Result:=true;
end;

procedure TForm_Script.ButtonRunClick(Sender: TObject);
var
    ae:TCodeAnalyzerEC;
    tstr:WideString;
begin
    if not LoadCodeFromFile(FilenameScript.Text,tstr) then Exit;

    MemoConsole.Lines.Text:='';
    FConsole:='';

    ae:=TCodeAnalyzerEC.Create;
    ae.Build(tstr);
    ae.DelCom; ae.DelSpace; ae.DelEnter;
    tstr:=ae.TestOpenClose;
    if tstr<>'' then begin MemoConsole.Lines.Text:='Analyzer error: '+tstr; ae.Free; Exit; End;

    FCode:=TCodeEC.Create;
    tstr:=FCode.Compiler(ae);
    ae.Free;
    if tstr<>'' then begin MemoConsole.Lines.Text:='Code error: '+tstr; FCode.Free; Exit; End;

    FCode.Link(FFun);

    Form_Script.ButtonRun.Enabled:=false;
    Form_Script.ButtonCancelRun.Enabled:=true;
    Form_Script.TimerConsole.Enabled:=true;

//    FThreadRun.Priority:=tpLower;
    FThreadRun.Priority:=tpNormal;
    FThreadRun.Run;
end;

procedure TForm_Script.TimerConsoleTimer(Sender: TObject);
var
    tstr:WideString;
begin
    FCS.Enter;
    tstr:=FConsole;
    FCS.Leave;
    MemoConsole.Text:=tstr;
end;

procedure TForm_Script.FormCreate(Sender: TObject);
begin
    FCS:=TCriticalSection.Create;

    FFun:=TVarArrayEC.Create;
    FFun.AddStdFunction;
    SF_Add;

    FThreadRun:=TThreadRun.Create;

end;

procedure TForm_Script.FormDestroy(Sender: TObject);
begin
    FThreadRun.Free; FThreadRun:=nil;
    FFun.Free; FFun:=nil;
    FCS.Free; FCS:=nil;
end;

procedure TForm_Script.ButtonCancelRunClick(Sender: TObject);
begin
    FStateBreak:=true;
end;

procedure TForm_Script.FormShow(Sender: TObject);
begin
    Form_Script.ButtonRun.Enabled:=true;
    Form_Script.ButtonCancelRun.Enabled:=false;
    Form_Script.TimerConsole.Enabled:=false;

    FilenameScript.Text:=RegUser_GetString('','LastScriptFile','');
end;

procedure TForm_Script.FormHide(Sender: TObject);
begin
    RegUser_SetString('','LastScriptFile',FilenameScript.Text);
end;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure SF_Out(av:array of TVarEC);
begin
    if (High(av)+1)<2 then Exit;
    Form_Script.FCS.Enter;
    Form_Script.FConsole:=Form_Script.FConsole+av[1].VStr;
    Form_Script.FCS.Leave;
end;

procedure WI_DirList(av:array of TVarEC);
var
    sl:TStrings;
    i:integer;
begin
    if High(av)<1 then Exit;

    sl:=Form_BuildGAIGroup.GetDirectoryList(av[1].VStr);
    av[0].VType:=vtArray;
    av[0].ArrayInit([sl.Count]);
    for i:=0 to sl.Count-1 do begin
        av[0].VArray.Items[i].VStr:=sl.Strings[i];
    end;
    sl.Free;
end;

procedure WI_FileList(av:array of TVarEC);
var
    sl:TStrings;
    i:integer;
begin
    if High(av)<1 then Exit;

    sl:=Form_BuildGAIGroup.GetFileList(av[1].VStr);
    av[0].VType:=vtArray;
    av[0].ArrayInit([sl.Count]);
    for i:=0 to sl.Count-1 do begin
        av[0].VArray.Items[i].VStr:=sl.Strings[i];
    end;
    sl.Free;
end;

procedure WI_GAI_Create(av:array of TVarEC);
begin
    if High(av)<>4 then Exit;
    av[0].VDW:=DWORD(TGAIBuild.Create(av[1].VStr,av[2].VInt,boolean(av[3].VInt),av[4].VStr));
end;

procedure WI_GAI_Free(av:array of TVarEC);
begin
    if High(av)<>1 then Exit;
    TGAIBuild(av[1].VDW).Free;
end;

procedure WI_GAI_AddImage(av:array of TVarEC);
begin
    if High(av)<>4 then Exit;
    TGAIBuild(av[1].VDW).AddImage(TGraphBuf(av[2].VDW),av[3].VInt,boolean(av[4].VInt));
end;

procedure WI_Image_Create(av:array of TVarEC);
begin
    av[0].VDW:=DWORD(TGraphBuf.Create);
end;

procedure WI_Image_Free(av:array of TVarEC);
begin
    if High(av)<>1 then Exit;
    TGraphBuf(av[1].VDW).Free;
end;

procedure WI_Image_Load(av:array of TVarEC);
begin
    if High(av)<>2 then Exit;
    TGraphBuf(av[1].VDW).LoadRGBA(av[2].VStr);
end;

procedure WI_Filter_SubColor(av:array of TVarEC);
var
    bgcolor,errorcolor:WideString;
    sou,des:TGraphBuf;
begin
    if High(av)<2 then Exit;
    if High(av)>=5 then bgcolor:=av[3].VStr+','+av[4].VStr+','+av[5].VStr
    else bgcolor:='0,0,0';
    if High(av)>=8 then errorcolor:=av[6].VStr+','+av[7].VStr+','+av[8].VStr
    else errorcolor:='0,0,0';
    sou:=TGraphBuf(av[2].VDW);
    des:=TGraphBuf(av[1].VDW);
    des.ImageCreate(sou.FLenX,sou.FLenY,sou.FChannels);
    Form_CorrectImageByAlpha.Build(sou,des,1,bgcolor,errorcolor);
end;

procedure WI_Image_Rescale(av:array of TVarEC);
begin
    if High(av)<>7 then Exit;
    Form_Rescale.Build(TGraphBuf(av[2].VDW),TGraphBuf(av[1].VDW),boolean(av[3].VInt),boolean(av[5].VInt),av[4].VFloat,av[6].VFloat,av[7].VInt);
end;

procedure WI_Image_SaveGI(av:array of TVarEC);
var
    bd:TBufEC;
    fformat:integer;
    autosize:boolean;
    gb:TGraphBuf;
begin
    if High(av)<>4 then Exit;

    gb:=TGraphBuf(av[1].VDW);
    fformat:=av[3].VInt;
    autosize:=boolean(av[4].VInt);

    bd:=TBufEC.Create;
    try
        if fformat=0 then begin
            gb.BuildGI_Bitmap(bd);
        end else if fformat=1 then begin
            gb.BuildGI_Trans(bd,autosize);
        end else if fformat=2 then begin
            gb.BuildGI_Alpha(bd,autosize);
        end else if fformat=3 then begin
            gb.BuildGI_AlphaIndexed8(bd,autosize);
        end;

        bd.SaveInFile(PChar(AnsiString(av[2].VStr)));
    finally
        bd.Free;
    end;
end;

procedure WI_Image_CutOff(av:array of TVarEC);
begin
    if High(av)<>3 then Exit;
    OCutOffAlpha(TGraphBuf(av[2].VDW),TGraphBuf(av[1].VDW),av[3].VInt);
end;

procedure WI_Image_Size(av:array of TVarEC);
var
    gb:TGraphBuf;
begin
    if High(av)<>3 then Exit;
    gb:=TGraphBuf(av[1].VDW);
    av[2].VInt:=gb.FLenX;
    av[3].VInt:=gb.FLenY;
end;

procedure WI_FileName(av:array of TVarEC);
begin
    if High(av)<>1 then Exit;
    av[0].VStr:=File_Name(av[1].VStr);
end;

procedure TForm_Script.SF_Add;
begin
    FFun.Add('out',vtExternFun).VExternFun:=SF_Out;
    FFun.Add('WI_DirList',vtExternFun).VExternFun:=WI_DirList;
    FFun.Add('WI_FileList',vtExternFun).VExternFun:=WI_FileList;

    FFun.Add('WI_GAI_Create',vtExternFun).VExternFun:=WI_GAI_Create;
    FFun.Add('WI_GAI_Free',vtExternFun).VExternFun:=WI_GAI_Free;
    FFun.Add('WI_GAI_AddImage',vtExternFun).VExternFun:=WI_GAI_AddImage;

    FFun.Add('WI_Image_Create',vtExternFun).VExternFun:=WI_Image_Create;
    FFun.Add('WI_Image_Free',vtExternFun).VExternFun:=WI_Image_Free;
    FFun.Add('WI_Image_Load',vtExternFun).VExternFun:=WI_Image_Load;
    FFun.Add('WI_Image_Rescale',vtExternFun).VExternFun:=WI_Image_Rescale;
    FFun.Add('WI_Image_SaveGI',vtExternFun).VExternFun:=WI_Image_SaveGI;
    FFun.Add('WI_Image_CutOff',vtExternFun).VExternFun:=WI_Image_CutOff;
    FFun.Add('WI_Image_Size',vtExternFun).VExternFun:=WI_Image_Size;

    FFun.Add('WI_Filter_SubColor',vtExternFun).VExternFun:=WI_Filter_SubColor;

    FFun.Add('WI_FileName',vtExternFun).VExternFun:=WI_FileName;
end;

end.
