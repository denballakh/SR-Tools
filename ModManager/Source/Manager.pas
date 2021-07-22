unit Manager;

interface

uses
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, IniFiles, StdCtrls, ComCtrls, ExtCtrls, Menus, Buttons, sSkinManager,
     sCheckBox, sButton, Vcl.ImgList, sScrollBox, sMemo, sPageControl, acAlphaHints, ShlObj,
     Registry, ShellApi, System.ImageList;

type
     TManagerForm = class(TForm)
     sSkinManager1: TsSkinManager;
     About: TsButton;
    CloseButton: TsButton;
     StartGame: TsButton;
     Options: TsButton;
     ExpansionTab: TsButton;
     EvolutionTab: TsButton;
     RevolutionTab: TsButton;
     OtherModsTab: TsButton;
     TweaksTab: TsButton;
     ListModules: TsMemo;
     BigButtonsImg: TImageList;
     SmallButtonsImg: TImageList;
     TabsControl: TsPageControl;
     sTabSheet1: TsTabSheet;
     sTabSheet2: TsTabSheet;
     sTabSheet3: TsTabSheet;
     sTabSheet4: TsTabSheet;
     sTabSheet5: TsTabSheet;
     sScrollBox1: TsScrollBox;
     sScrollBox2: TsScrollBox;
     sScrollBox3: TsScrollBox;
     sScrollBox4: TsScrollBox;
     sScrollBox5: TsScrollBox;
     sAlphaHints1: TsAlphaHints;
procedure FormCreate(Sender: TObject);
procedure FormDestroy(Sender: TObject);
procedure AboutClick(Sender: TObject);
procedure CloseButtonClick(Sender: TObject);
procedure StartGameClick(Sender: TObject);
procedure OptionsClick(Sender: TObject);
procedure FormActivate(Sender: TObject);
procedure TabsControlChange(Sender: TObject);
procedure sScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox2MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox2MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox3MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox3MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox4MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox4MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox5MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
procedure sScrollBox5MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);

private
    { Private declarations }
public
    { Public declarations }
procedure CheckInfo(Sender: TObject);
procedure CheckModules(Sender: TObject);
procedure UniverseLog;
procedure WriteModCFG;
procedure FocusScrollBox;
procedure WineDetect;
end;

var
    ManagerForm: TManagerForm;
    StylingFlag,StandaloneFlag,CloseFlag,GR_WeRunOnWine: bool;
    nModules: integer;
    Module,MyDocPath: string;
    CheckButtonAr: array of TsCheckBox;
    InfoButtonAr: array of TsCheckBox;
    EmptyDir: array of string;

implementation

{$R *.dfm}

uses AboutManager, ModuleInfo, Notify, Options;

//Parsing conflict and dependence strings
function Parser(s: string; count: integer):string;
var
    i: integer;
begin
  if count<=0 then
  begin
    Result := ''; Exit;
  end;
  if count=1 then Delete(s, pos(',', s),Length(s)) else
  for i:=1 to count-1 do
  begin
    if Pos(',', s)=0 then
    begin
      result := ''; Exit;
    end;
    Delete(s, 1, Pos(',', s));
    if i=count-1 then if Pos(',', s)<>0 then Delete(s, Pos(',', s),Length(s));
  end;
  Result := s;
end;

//Styling application
procedure Styling;
begin
  if StylingFlag=False
  then
  begin
    ManagerForm.sSkinManager1.ExtendedBorders := True;
    ManagerForm.sSkinManager1.AnimEffects.BlendOnMoving.Active := True;
    ManagerForm.Caption := '';
  end
  else
  begin
    ManagerForm.sSkinManager1.ExtendedBorders := False;
    ManagerForm.sSkinManager1.AnimEffects.BlendOnMoving.Active := False;
    ManagerForm.Caption := 'Space Rangers Universe (Community)';
  end;
end;

//Procedure for ModuleInfoForm
procedure TManagerForm.CheckInfo(Sender: TObject);
var
    FullDescriptionHeight: TRect;
    Canvas,i,d: integer;
    StringList: TStringList;
    Name,Author,Conflict,Dependence,Section,FullDescription,Standalone,Compatibility: string;
begin
  for i:=0 to nModules-1 do
  begin
    if Sender <> InfoButtonAr[i] then continue;
    InfoButtonAr[i].OnClick := nil;
    InfoButtonAr[i].State := cbGrayed;
    InfoButtonAr[i].OnClick := ManagerForm.CheckInfo;
    Module := ListModules.Lines[i];
    StringList := TStringList.Create;
    StringList.LoadFromFile('Mods/' + Module + '/ModuleInfo.txt',TEncoding.GetEncoding(1251));
    Name := StringList[1];
    Author := StringList[2];
    Conflict := StringList[3];
    Dependence := StringList[4];
    Section := StringList[5];
    Standalone := StringList[6];
    Compatibility := StringList[7];
    FullDescription := StringList[9];
    Delete(Name, 1, 5);
    Delete(Author, 1, 7);
    Delete(Conflict, 1, 9);
    Delete(Dependence, 1, 11);
    Delete(Section, 1, 8);
    Delete(Standalone, 1, 11);
    Delete(Compatibility, 1, 14);
    Delete(FullDescription, 1, 16);
    ModuleInfoForm.ModuleNameValue.Caption := Name;
    ModuleInfoForm.ModuleAuthorValue.Caption := Author;
    ModuleInfoForm.ModuleConflictValue.Caption := Conflict;
    ModuleInfoForm.ModuleDependenceValue.Caption := Dependence;
    ModuleInfoForm.ModuleFullDescriptionValue.Caption := FullDescription + #13#10;
    for d:=10 to StringList.Count - 1 do
      begin
        ModuleInfoForm.ModuleFullDescriptionValue.Caption := ModuleInfoForm.ModuleFullDescriptionValue.Caption + StringList.Strings[d] + #13#10;
      end;
  FullDescriptionHeight := Rect(0,0,ModuleInfoForm.ModuleFullDescriptionValue.Width,ModuleInfoForm.ModuleConflictValue.Height);
  Canvas := DrawText(ModuleInfoForm.ModuleFullDescriptionValue.Canvas.Handle, PChar(ModuleInfoForm.ModuleFullDescriptionValue.Caption), -1, FullDescriptionHeight, DT_CALCRECT or DT_WORDBREAK);
  ModuleInfoForm.ModuleFullDescriptionValue.Height := Canvas;
  StringList.Free;
  end;
  ModuleInfoForm.Position := poMainFormCenter;
  ModuleInfoForm.ShowModal;
end;


//Procedure check conflict and dependence modules
var CallCount: integer = 0;
procedure TManagerForm.CheckModules(Sender: TObject);
var
    i,d,s,g: integer;
    StringList: TStringList;
    Conflict,Dependence,Piece,Standalone,Compatibility: string;
    Autonomous: boolean;
begin
  inc(CallCount);
  for i:=0 to nModules-1 do
  begin
    if Sender <> CheckButtonAr[i] then continue;
    Module := ListModules.Lines[i];
    StringList := TStringList.Create;
    StringList.LoadFromFile('Mods/' + Module + '/ModuleInfo.txt',TEncoding.GetEncoding(1251));
    Standalone := StringList[6];
    Compatibility := StringList[7];
    Delete(Standalone, 1, 11);
    Delete(Compatibility, 1, 14);
    if (Standalone = 'Yes') and (not StandaloneFlag) then
    begin
      StandaloneFlag := True;
      for s:=0 to nModules-1 do
      begin
        if i = s then continue;
        Autonomous := False;
        d := 1;
        while true do
        begin
          Piece := Parser(Compatibility,d);
          if Piece = '' then break;
          inc(d);
          if CheckButtonAr[s].Hint = Piece then
          begin
            Autonomous := True;
            break;
          end;
        end;
        if not Autonomous then
        begin
          CheckButtonAr[s].State := cbUnchecked; CheckButtonAr[s].Enabled := False;
        end;
      end;
      if Compatibility <> '' then
      begin
        NotifyForm.TitleNotify.Caption := 'Данный модуль является самостоятельным и несовместим с другими, исключением являются:';
        NotifyForm.TitleNotify.Font.Color := clMaroon;
        NotifyForm.TextNotify.Top := 38;
        g := 1;
        while True do
        begin
          Piece := Parser(Compatibility,g);
          if Piece = '' then break;
          if NotifyForm.TextNotify.Caption='' then NotifyForm.TextNotify.Caption := Piece else NotifyForm.TextNotify.Caption := NotifyForm.TextNotify.Caption + ', ' + Piece;
          inc(g);
        end;
      end
      else begin
        NotifyForm.TitleNotify.Caption := 'Данный модуль является самостоятельным и несовместим с другими';
        NotifyForm.TitleNotify.Font.Color := clMaroon;
        NotifyForm.TextNotify.Top := 25;
      end;
      NotifyForm.ShowModal;
      sSkinManager1.RepaintForms;
    end
    else if (Standalone = 'Yes') and StandaloneFlag then
    begin
      StandaloneFlag := False;
      for s:=0 to nModules-1 do
      begin
        CheckButtonAr[s].Enabled := True;
      end;
    end;
    if CheckButtonAr[i].State = cbChecked then
    begin
      Conflict := StringList[3];
      Delete(Conflict, 1, 9);
      d := 1;
      while true do
      begin
        Piece := Parser(Conflict,d);
        if Piece = '' then break;
        inc(d);
        for s:=0 to nModules-1 do
        begin
          if (CheckButtonAr[s].Hint = Piece) and (CheckButtonAr[s].State = cbChecked) then
          begin
            CheckButtonAr[s].State := cbUnchecked;
            NotifyForm.TitleNotify.Caption := 'Обнаружены конфликтующие модули, которые будут отключены:';
            NotifyForm.TitleNotify.Font.Color := clMaroon;
            NotifyForm.TextNotify.Top := 25;
            if NotifyForm.TextNotify.Caption = '' then NotifyForm.TextNotify.Caption := Piece else NotifyForm.TextNotify.Caption := NotifyForm.TextNotify.Caption + ', ' + Piece;
          end;
        end;
      end;
    end;
    if CheckButtonAr[i].State = cbChecked then
    begin
      Dependence := StringList[4];
      Delete(Dependence, 1, 11);
      d:=1;
      while True do
      begin
        Piece := Parser(Dependence,d);
        if Piece = '' then break;
        inc(d);
        for s:=0 to nModules-1 do
        begin
          if (CheckButtonAr[s].Hint = Piece) and (CheckButtonAr[s].State = cbUnchecked) then
          begin
            CheckButtonAr[s].State := cbChecked;
            NotifyForm.TitleNotify.Caption := 'Обнаружены зависимые модули, которые будут подключены:';
            NotifyForm.TitleNotify.Font.Color := clGreen;
            NotifyForm.TextNotify.Top := 25;
            if NotifyForm.TextNotify.Caption='' then NotifyForm.TextNotify.Caption := Piece else NotifyForm.TextNotify.Caption := NotifyForm.TextNotify.Caption + ', ' + Piece;
          end;
        end;
      end;
    end;
    StringList.Free;
  end;
  dec(CallCount);
  if (CallCount<=0) and ((NotifyForm.TitleNotify.Caption<>'') or (NotifyForm.TextNotify.Caption<>'')) then
  begin
    NotifyForm.Position := poMainFormCenter;
    NotifyForm.ShowModal;
  end;
  WriteModCFG;
end;

//Read manager ini file
procedure ReadINI;
var
    ini: Tinifile;
    i: integer;
begin
  ini := TiniFile.Create(ExtractFileDir(Application.ExeName)+'\Universe.ini');
  StylingFlag := Ini.ReadBool('StylingFlag','Checked', False);
  StandaloneFlag := Ini.ReadBool('StandaloneFlag','Checked', False);
  CloseFlag := Ini.ReadBool('CloseFlag','Checked', False);
  for i:=0 to nModules-1 do
  begin
    CheckButtonAr[i].Checked := Ini.ReadBool(CheckButtonAr[i].Hint,'Checked', False);
    CheckButtonAr[i].Enabled := Ini.ReadBool(CheckButtonAr[i].Hint,'Enabled', True);
  end;
  Ini.Free;
end;

//Write manager ini file
procedure WriteINI;
var
    ini: Tinifile;
    i: integer;
begin
  ini := TiniFile.Create(ExtractFileDir(Application.ExeName)+'\Universe.ini');
  Ini.WriteBool('StylingFlag','Checked',StylingFlag);
  Ini.WriteBool('StandaloneFlag','Checked',StandaloneFlag);
  Ini.WriteBool('CloseFlag','Checked',CloseFlag);
  for i:=0 to nModules-1 do
  begin
    Ini.WriteBool(CheckButtonAr[i].Hint,'Checked',CheckButtonAr[i].Checked);
    Ini.WriteBool(CheckButtonAr[i].Hint,'Enabled',CheckButtonAr[i].Enabled);
  end;
  Ini.Free;
end;

//Write ModCFG.txt file
procedure TManagerForm.WriteModCFG;
var
    i: integer;
    ModCFG: textfile;
    StringList: TStringList;
    CurrentMod,RosterModules,Name,Section,Expansion,Evolution,Revolution,OtherMods,Another: string;
begin
  for i:=0 to nModules-1 do
  begin
    Module := ListModules.Lines[i];
    StringList := TStringList.Create;
    StringList.LoadFromFile('Mods/' + Module + '/ModuleInfo.txt',TEncoding.GetEncoding(1251));
    Name := StringList[1];
    Section := StringList[5];
    Delete(Section, 1, 8);
    Delete(Name, 1, 5);
    if CheckButtonAr[i].Checked then
    begin
      if Section = 'Expansion' then
      begin
        Expansion := (Expansion + Section + '\' + CheckButtonAr[i].Hint + ',');
      end
      else if Section = 'Evolution' then
      begin
        Evolution := (Evolution + Section + '\' + CheckButtonAr[i].Hint + ',');
      end
      else if Section = 'Revolution' then
      begin
        Revolution := (Revolution + Section + '\' + CheckButtonAr[i].Hint + ',');
      end
      else if Section = 'OtherMods' then
      begin
        OtherMods := (OtherMods + Section + '\' + CheckButtonAr[i].Hint + ',');
      end
      else Another := (Another + Section + '\' + CheckButtonAr[i].Hint + ',');
    end;
    StringList.Free;
  end;
  if FileExists('Mods/ModCFG.txt') then SetFileAttributes('Mods/ModCFG.txt', FILE_ATTRIBUTE_NORMAL);
  AssignFile(ModCFG, 'Mods/ModCFG.txt');
  Rewrite(ModCFG);
  CurrentMod := 'CurrentMod=Universe,';
  RosterModules := Expansion + Evolution + Revolution + OtherMods + Another;
  if Length(RosterModules)=0 then Delete(CurrentMod, 12, 9);
  if Length(RosterModules)>0 then Delete(RosterModules, Length(RosterModules), 1);
  Write(ModCFG, CurrentMod);
  Write(ModCFG, RosterModules);
  CloseFile(ModCFG);
end;

//Delete manager ini file
procedure DeleteINI;
begin
  if FileExists('Universe.ini') then begin
    SetFileAttributes('Universe.ini', FILE_ATTRIBUTE_NORMAL);
    DeleteFile('Universe.ini');
  end;
end;

//Parsing Mods directory
procedure DirectoryList(Path: string; DirList: TStrings; exPath:string);
var Varser: TSearchRec;
begin
  if FindFirst(Path + '*.*', faDirectory, Varser) = 0 then
  begin
    repeat
      if (Varser.Attr and faDirectory) <> 0 then
      begin
        if (Varser.Name='.') or (Varser.Name='..') then continue;
        if (Varser.Name='Expansion') or (Varser.Name='Evolution') or (Varser.Name='Revolution') or (Varser.Name='OtherMods') or (Varser.Name='Tweaks')
        then DirectoryList(Path+Varser.Name+'/',DirList,Varser.Name+'/')
        else if exPath<>'' then DirList.Add(exPath+Varser.Name);
      end;
    until FindNext(Varser) <> 0;
    FindClose(Varser);
  end;
end;

//Find MyDoc directory
function GetPathMyDoc: string;
var
    bResult: boolean;
    Path: array [0..MAX_PATH] of Char;
begin
  bResult := SHGetSpecialFolderPath(0, Path, CSIDL_MYDOCUMENTS, False);
  if not bResult then
  raise Exception.Create('Невозможно найти папку "Мои Документы"');
  Result := Path;
  MyDocPath := Path;
end;

//Get Mods folder size
procedure GetDirSize(const aPath: string; var SizeDir: Int64);
var
    SR: TSearchRec;
    tPath: string;
begin
  tPath := IncludeTrailingPathDelimiter(aPath);
  if FindFirst(tPath + '*.*', faAnyFile, SR) = 0 then
  begin
    try
    repeat
      if (SR.Name = '.') or (SR.Name = '..') or (SR.Name='ModCFG.txt') then
      Continue;
      if (SR.Attr and faDirectory) <> 0 then
      begin
        GetDirSize(tPath + SR.Name, SizeDir);
        Continue;
      end;
      SizeDir := SizeDir + SR.Size;
    until FindNext(SR) <> 0;
    finally
    Sysutils.FindClose(SR);
  end;
end;
end;

//Create Universe.log in MyDoc folder
procedure TManagerForm.UniverseLog;
var
    exeSize: LongInt;
    fs: TFileStream;
    logFile: TextFile;
    GOG,SteamBuy: Bool;
    Log,SteamPath,InstallSR,EXEDate,WineStart,GOGFlag: string;
    Reg : TRegistry;
    MainEXE: Integer;
    RegKey: DWORD;
    SizeDir: Int64;
begin
  RegKey := 0;
  if not DirectoryExists(GetPathMyDoc + '\SpaceRangersHD') then CreateDir(GetPathMyDoc + '\SpaceRangersHD');
  if FileExists('Rangers.exe') then
  begin
    MainEXE := FileOpen('Rangers.exe', fmOpenRead);
    exeSize := GetFileSize(MainEXE, nil);
    EXEDate := DateTimeToStr(FileDateToDateTime(FileGetDate(MainEXE)));
    FileClose(MainEXE);
  end
  else exeSize := 0;
  GOG := FileExists('goggame-1207667113.ico');
  if GOG=True then GOGFlag := 'Yes' else GOGFlag := 'No';
  if FileExists(GetPathMyDoc + '\SpaceRangersHD\Universe.log') then SetFileAttributes(PChar(GetPathMyDoc + '\SpaceRangersHD\Universe.log'), FILE_ATTRIBUTE_NORMAL);
  fs := TFileStream.Create(GetPathMyDoc + '\SpaceRangersHD\Universe.log', fmCreate);
  fs.Free;
  AssignFile(logFile, GetPathMyDoc + '\SpaceRangersHD\Universe.log');
  Rewrite(logFile);
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  If Reg.OpenKeyReadOnly('Software\Valve\Steam') or Reg.OpenKeyReadOnly('Software\Wow6432Node\Valve\Steam')
  Then
  Begin
    If Reg.ValueExists('InstallPath')
    Then SteamPath := Reg.ReadString('InstallPath')
    Else SteamPath := 'Not Found';
    Reg.CloseKey;
  End
  Else SteamPath := 'Not Found';
  Reg.RootKey := HKEY_CURRENT_USER;
  If Reg.OpenKeyReadOnly('Software\Valve\Steam\Apps\214730') or Reg.OpenKeyReadOnly('Software\Wow6432Node\Valve\Steam\Apps\214730')
  Then
  Begin
    If Reg.ValueExists('Installed')
    Then RegKey := Reg.ReadInteger('Installed'); If RegKey=1 then InstallSR := 'Yes'
    Else InstallSR := 'No';
    Reg.CloseKey;
  End
  Else InstallSR := 'No';
  Reg.Free;
  if FileExists(SteamPath + '\appcache\stats\UserGameStatsSchema_214730.bin') then SteamBuy := true else SteamBuy := false;
  if GR_WeRunOnWine then WineStart := 'Yes' else WineStart := 'No';
  SizeDir := 0;
  GetDirSize('Mods', SizeDir);
  Log := '============================================' + #13#10;
  Log := Log + '     Space Rangers Universe (Community)     ' + #13#10;
  Log := Log + '============================================' + #13#10;
  Log := Log + 'App Folder = ' + ExtractFilePath(Application.ExeName) + #13#10;
  Log := Log + 'EXE Size = ' + IntToStr(exeSize) + #13#10;
  Log := Log + 'EXE Date = ' + EXEDate + #13#10;
  Log := Log + 'Mods Size = ' + IntToStr(SizeDir) + #13#10;
  Log := Log + 'Steam Folder = ' + SteamPath + #13#10;
  Log := Log + 'Steam App Installed = ' + InstallSR + #13#10;
  if SteamBuy=true then Log := Log + 'Steam Buy = ' + 'Yes' + #13#10 else
  Log := Log + 'Steam Buy = ' + 'No' + #13#10;
  Log := Log + 'GOG = ' + GOGFlag + #13#10;
  Log := Log + 'Wine = ' + WineStart;
  Write(logFile, Log);
  CloseFile(logFile);
end;

//Focus ScrollBox in Tabs
procedure TManagerForm.FocusScrollBox;
begin
  if TabsControl.ActivePageIndex = 0 then ExpansionTab.SetFocus;
  if TabsControl.ActivePageIndex = 1 then EvolutionTab.SetFocus;
  if TabsControl.ActivePageIndex = 2 then RevolutionTab.SetFocus;
  if TabsControl.ActivePageIndex = 3 then OtherModsTab.SetFocus;
  if TabsControl.ActivePageIndex = 4 then TweaksTab.SetFocus;
end;

//System notify on start
var firstCall: boolean = true;
procedure TManagerForm.FormActivate(Sender: TObject);
var
    i: integer;
begin
  if not firstCall then exit;
  firstCall:=false;
  FocusScrollBox;
  if Length(EmptyDir)>0 then
  begin
    for i:=Length(EmptyDir)-1 downto 0 do
    begin
      NotifyForm.TitleNotify.Caption := 'Обнаружены модули без инфо-файла, которые будут проигнорированы менеджером:';
      NotifyForm.TitleNotify.Font.Color := clMaroon;
      NotifyForm.TextNotify.Top := 38;
      if NotifyForm.TextNotify.Caption = '' then NotifyForm.TextNotify.Caption := EmptyDir[i] else NotifyForm.TextNotify.Caption := NotifyForm.TextNotify.Caption + ', ' + EmptyDir[i];
    end;
    NotifyForm.Position := poMainFormCenter;
    NotifyForm.ShowModal;
  end;
  UniverseLog;
end;

//Start manager
procedure TManagerForm.FormCreate(Sender: TObject);
var
    i,s,no: integer;
    Name,Section,SmallDescription: string;
    StringList: TStringList;
    index: array[1..5] of integer;
begin
  DirectoryList('Mods/', ListModules.Lines, '');
  for i:=1 to 5 do index[i]:=0;
  nModules := ListModules.Lines.Count;
  s := 0;
  for i:=ListModules.Lines.Count downto 0 do
  begin
    Module := ListModules.Lines[i];
    if FileExists ('Mods/' + Module + '/ModuleInfo.txt') then
    else if Pos(Module,ListModules.Lines[i])>0 then
    begin
      ListModules.Lines.Delete(i);
      SetLength(EmptyDir, s+1); EmptyDir[s] := Module; s := s + 1;
    end;
  end;
  nModules := ListModules.Lines.Count;
  SetLength(CheckButtonAr, nModules);
  SetLength(InfoButtonAr, nModules);
  for i:=0 to nModules-1 do
  begin
    Module := ListModules.Lines[i];
    StringList := TStringList.Create;
    StringList.LoadFromFile('Mods/' + Module + '/ModuleInfo.txt',TEncoding.GetEncoding(1251));
    Name := StringList[1];
    Section := StringList[5];
    SmallDescription := StringList[8];
    Delete(Name, 1, 5);
    Delete(Section, 1, 8);
    Delete(SmallDescription, 1, 17);
    InfoButtonAr[i] := TsCheckBox.Create(ManagerForm);
    CheckButtonAr[i] := TsCheckBox.Create(ManagerForm);
    if Section = 'Expansion' then
    begin
      CheckButtonAr[i].Parent := sScrollBox1; InfoButtonAr[i].Parent := sScrollBox1; no:=1;
    end
    else if Section = 'Evolution' then
    begin
      CheckButtonAr[i].Parent := sScrollBox2; InfoButtonAr[i].Parent := sScrollBox2; no:=2;
    end
    else if Section = 'Revolution' then
    begin
      CheckButtonAr[i].Parent := sScrollBox3; InfoButtonAr[i].Parent := sScrollBox3; no:=3;
    end
    else if Section = 'Tweaks' then
    begin
      CheckButtonAr[i].Parent := sScrollBox5; InfoButtonAr[i].Parent := sScrollBox5; no:=5;
    end
    else
    begin
      CheckButtonAr[i].Parent := sScrollBox4; InfoButtonAr[i].Parent := sScrollBox4; no:=4;
    end;
    InfoButtonAr[i].Left := 10;
    InfoButtonAr[i].Top := index[no]*30;
    InfoButtonAr[i].AutoSize := False;
    InfoButtonAr[i].Height := 42;
    InfoButtonAr[i].SkinData.SkinSection := 'CHECKBOX';
    InfoButtonAr[i].Caption := '';
    InfoButtonAr[i].ShowFocus := False;
    InfoButtonAr[i].State := cbGrayed;
    CheckButtonAr[i].Left := 40;
    CheckButtonAr[i].Top := index[no]*30;
    CheckButtonAr[i].AutoSize := False;
    CheckButtonAr[i].Height := 42;
    CheckButtonAr[i].Width := 700;
    CheckButtonAr[i].ParentFont := False;
    CheckButtonAr[i].Font.Charset := DEFAULT_CHARSET;
    CheckButtonAr[i].Font.Name := 'Verdana';
    CheckButtonAr[i].Font.Style := [fsBold];
    CheckButtonAr[i].Font.Color := 4934475;
    CheckButtonAr[i].Font.Height := -11;
    CheckButtonAr[i].Font.Size := 8;
    CheckButtonAr[i].SkinData.CustomFont := True;
    CheckButtonAr[i].SkinData.SkinSection := 'CHECKBOX';
    CheckButtonAr[i].Caption := SmallDescription;
    CheckButtonAr[i].Hint := Name;
    CheckButtonAr[i].ShowHint := True;
    CheckButtonAr[i].ShowFocus := False;
    CheckButtonAr[i].WordWrap := False;
    inc(index[no]);
    StringList.Free;
  end;
  ReadINI;
  for i:=0 to nModules-1 do begin
    InfoButtonAr[i].OnClick := CheckInfo;
    CheckButtonAr[i].OnClick := CheckModules;
  end;
  WineDetect;
  if GR_WeRunOnWine then
  begin
    TabsControl.MultiLine := False;
    sSkinManager1.ExtendedBorders := False;
    sSkinManager1.AnimEffects.BlendOnMoving.Active := False;
    ManagerForm.Caption := 'Space Rangers Universe (Community)';
  end
  else Styling;
end;

//Close manager
procedure TManagerForm.FormDestroy(Sender: TObject);
begin
  DeleteINI;
  WriteINI;
  WriteModCFG;
end;

//*nix Wine detect
procedure TManagerForm.WineDetect;
var
    hnd: THandle;
wine_get_version: function : pchar; {$IFDEF Win32} stdcall; {$ENDIF}
wine_unix2fn: procedure (p1:pointer; p2:pointer); {$IFDEF Win32} stdcall; {$ENDIF}
begin
  hnd := LoadLibrary('ntdll.dll');
  if hnd>32 then
  begin
    wine_get_version := GetProcAddress(hnd, 'wine_get_version');
    wine_unix2fn := GetProcAddress(hnd, 'wine_nt_to_unix_file_name');
    if assigned(wine_get_version) or assigned(wine_unix2fn) then GR_WeRunOnWine := True;
    FreeLibrary(hnd);
  end;
end;

//About manager
procedure TManagerForm.AboutClick(Sender: TObject);
begin
  AboutManagerForm.Position := poMainFormCenter;
  AboutManagerForm.ShowModal;
end;

//Close manager
procedure TManagerForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

//Start game
procedure TManagerForm.StartGameClick(Sender: TObject);
begin
  DeleteINI;
  WriteINI;
  WriteModCFG;
  FocusScrollBox;
  if CloseFlag = True then Close else Application.Minimize;
  ShellExecute(Handle, nil, 'Rangers.exe', nil, nil, SW_SHOW);
end;

//Options
procedure TManagerForm.OptionsClick(Sender: TObject);
begin
  OptionsForm.ShowModal;
end;

//Tabs change event
procedure TManagerForm.TabsControlChange(Sender: TObject);
begin
  FocusScrollBox;
end;

//Scroll
procedure TManagerForm.sScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox1.VertScrollBar.Position := sScrollBox1.VertScrollBar.Position + 10;
end;

procedure TManagerForm.sScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox1.VertScrollBar.Position := sScrollBox1.VertScrollBar.Position - 10;
end;

procedure TManagerForm.sScrollBox2MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox2.VertScrollBar.Position := sScrollBox2.VertScrollBar.Position + 10;
end;

procedure TManagerForm.sScrollBox2MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox2.VertScrollBar.Position := sScrollBox2.VertScrollBar.Position - 10;
end;

procedure TManagerForm.sScrollBox3MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox3.VertScrollBar.Position := sScrollBox3.VertScrollBar.Position + 10;
end;

procedure TManagerForm.sScrollBox3MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox3.VertScrollBar.Position := sScrollBox3.VertScrollBar.Position - 10;
end;

procedure TManagerForm.sScrollBox4MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox4.VertScrollBar.Position := sScrollBox4.VertScrollBar.Position + 10;
end;

procedure TManagerForm.sScrollBox4MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox4.VertScrollBar.Position := sScrollBox4.VertScrollBar.Position - 10;
end;

procedure TManagerForm.sScrollBox5MouseWheelDown(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox5.VertScrollBar.Position := sScrollBox5.VertScrollBar.Position + 10;
end;

procedure TManagerForm.sScrollBox5MouseWheelUp(Sender: TObject; Shift: TShiftState;
MousePos: TPoint; var Handled: Boolean);
begin
  sScrollBox5.VertScrollBar.Position := sScrollBox5.VertScrollBar.Position - 10;
end;

end.

