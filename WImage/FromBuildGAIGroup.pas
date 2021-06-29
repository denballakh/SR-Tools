unit FromBuildGAIGroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit,EC_Str,Globals,Grids,GraphBuf;

type
  TForm_BuildGAIGroup = class(TForm)
    DirectoryEdit1: TDirectoryEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditTimeFrame: TEdit;
    ButtonBuild: TButton;
    ButtonClose: TButton;
    MemoText: TMemo;
    Label3: TLabel;
    EditRadius: TEdit;
    CheckBox1: TCheckBox;
    procedure ButtonBuildClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
        function GetDirectoryList(path:AnsiString):TStrings;
        function GetFileList(path:AnsiString):TStrings;
  end;

var
  Form_BuildGAIGroup: TForm_BuildGAIGroup;

implementation

uses FormBuildGAIAnim;

{$R *.DFM}

procedure TForm_BuildGAIGroup.FormShow(Sender: TObject);
begin
    DirectoryEdit1.Text:=RegUser_GetString('','BuildGAIGroupPath',GetCurrentDir);
end;

procedure TForm_BuildGAIGroup.FormHide(Sender: TObject);
begin
    RegUser_SetString('','BuildGAIGroupPath',DirectoryEdit1.Text);
end;

procedure TForm_BuildGAIGroup.ButtonBuildClick(Sender: TObject);
var
    i,u:integer;
    t:integer;
    slgroup:TStrings;
    slanim:TStrings;
    slfile:TStrings;
    sg:TStringGrid;
    tfile:AnsiString;
    gb:TGraphBuf;
begin
    Screen.Cursor:=crHourglass;
    MemoText.Lines.Clear;
    gb:=TGraphBuf.Create;

    slgroup:=GetDirectoryList(DirectoryEdit1.Text);
    for i:=0 to slgroup.Count-1 do begin
        slanim:=GetDirectoryList(DirectoryEdit1.Text+'\'+slgroup.Strings[i]);
        for u:=0 to slanim.Count-1 do begin
            slfile:=GetFileList(DirectoryEdit1.Text+'\'+slgroup.Strings[i]+'\'+slanim.Strings[u]);

            for t:=0 to slfile.Count-1 do begin
                slfile.Strings[t]:=DirectoryEdit1.Text+'\'+slgroup.Strings[i]+'\'+slanim.Strings[u]+'\'+slfile.Strings[t];
            end;

            sg:=TStringGrid.Create(self);
            sg.RowCount:=1;
            sg.ColCount:=2;
            sg.Cells[1,0]:='['+EditTimeFrame.Text+',0-'+IntToStr(slfile.Count-1)+']';
            if (slfile.Count>=3) and CheckBox1.Checked then begin
                sg.Cells[1,0]:=sg.Cells[1,0]+'['+EditTimeFrame.Text+','+IntToStr(slfile.Count-2)+'-1]';
            end;

            tfile:=DirectoryEdit1.Text+'\'+slgroup.Strings[i]+IntToStr(u)+'.gai';
            MemoText.Lines.Add(tfile);

            Form_BuildGAIAnim.Build(tfile,
                                    slfile,
                                    true,
                                    true,
                                    true,
                                    StrToIntEC(EditRadius.Text),
                                    sg,
                                    1,
                                    false);

            tfile:=DirectoryEdit1.Text+'\'+slgroup.Strings[i]+IntToStr(u)+'.gi';
            MemoText.Lines.Add(tfile);

            gb.LoadRGBA(slfile.Strings[0]);
            gb.FillRectChannel(3,Rect(0,0,gb.FLenX,gb.FLenY),255);
            gb.WriteGI_Bitmap(tfile);

            sg.Free;
            slfile.Free;
        end;
        slanim.Free;
    end;
    slgroup.Free;
    gb.Free;
    Screen.Cursor:=crDefault;
end;

function TForm_BuildGAIGroup.GetDirectoryList(path:AnsiString):TStrings;
var
    sl:TStringList;
    ss:WIN32_FIND_DATA;
    ha:THandle;
    tcurdir:AnsiString;
begin
    tcurdir:=GetCurrentDir;
    SetCurrentDir(path);

    sl:=TStringList.Create;

    ha:=FindFirstFile('*.*',ss);
    while True do begin
        if ((ss.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0) and (AnsiString(ss.cFileName)<>'.') and (AnsiString(ss.cFileName)<>'..') then begin
            sl.Add(AnsiString(ss.cFileName));
        end;

        if FindNextFile(ha,ss)=false then break;
    end;
    Windows.FindClose(ha);

    sl.Sort;

    SetCurrentDir(tcurdir);
    Result:=sl;
end;

function TForm_BuildGAIGroup.GetFileList(path:AnsiString):TStrings;
var
    sl:TStringList;
    ss:WIN32_FIND_DATA;
    ha:THandle;
    tcurdir:AnsiString;
begin
    tcurdir:=GetCurrentDir;
    SetCurrentDir(path);

    sl:=TStringList.Create;

    ha:=FindFirstFile('*.*',ss);
    while True do begin
        if ((ss.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)=0) then begin
            sl.Add(AnsiString(ss.cFileName));
        end;

        if FindNextFile(ha,ss)=false then break;
    end;
    Windows.FindClose(ha);

    sl.Sort;

    SetCurrentDir(tcurdir);
    Result:=sl;
end;

end.
