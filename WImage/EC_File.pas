unit EC_File;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils;

type
TFileEC = class(TObject)
    public
		m_Fa:DWORD;
		m_OpenSos:integer;
		m_Name:string;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure Init(filename:string);
		procedure Open;
        procedure OpenRead;
        function OpenReadNE:boolean;
		procedure CreateNew;
		procedure Close;

        function GetSize:DWORD;
        function GetFileName: WideString;

		function SetPointer(zn:integer; tip:integer=FILE_BEGIN):DWORD; // tip=FILE_BEGIN или FILE_CURRENT или FILE_END
		function GetPointer:DWORD;

		procedure Read(buf:Pointer; kolbyte:DWORD);
		procedure Write(buf:Pointer; kolbyte:DWORD);
        function ReadString:WideString;
end;

implementation

constructor TFileEC.Create;
begin
    inherited Create;
end;

destructor TFileEC.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TFileEC.Clear;
begin
	if m_Fa<>0 then CloseHandle(m_Fa);
	m_OpenSos:=0;
	m_Fa:=0;
	m_Name:='';
end;

procedure TFileEC.Init(filename:string);
begin
    Clear;
    m_Name:=filename;
end;

procedure TFileEC.Open;
begin
    if m_OpenSos=0 then begin

        m_Fa:=CreateFile(PChar(m_Name),
                         GENERIC_READ or GENERIC_WRITE,
                         0,nil,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);

        if m_Fa=INVALID_HANDLE_VALUE then begin
			m_Fa:=0;
			raise Exception.Create('TFileEC.Open. FileName=' + m_Name);
        end;
	end;
	Inc(m_OpenSos);
end;

procedure TFileEC.OpenRead;
begin
    if m_OpenSos=0 then begin

        m_Fa:=CreateFile(PChar(m_Name),
                         GENERIC_READ,
                         FILE_SHARE_READ,nil,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);

        if m_Fa=INVALID_HANDLE_VALUE then begin
			m_Fa:=0;
			raise Exception.Create('TFileEC.Open. FileName=' + m_Name);
        end;
	end;
	Inc(m_OpenSos);
end;

function TFileEC.OpenReadNE:boolean;
begin
    if m_OpenSos=0 then begin

        m_Fa:=CreateFile(PChar(m_Name),
                         GENERIC_READ,
                         FILE_SHARE_READ,nil,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);

        if m_Fa=INVALID_HANDLE_VALUE then begin
            Result:=false;
            Exit;
        end;
	end;
	Inc(m_OpenSos);
    Result:=true;
end;

procedure TFileEC.CreateNew;
begin
	m_OpenSos:=0;
	if m_Fa<>0 then begin
        CloseHandle(m_Fa);
        m_Fa:=0;
    end;

    m_Fa:=CreateFile(PChar(m_Name),GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
	if m_Fa=INVALID_HANDLE_VALUE then begin
		m_Fa:=NULL;
        raise Exception.Create('TFileEC.CreateNew. FileName=' + m_Name);
	end;

	m_OpenSos:=1;
end;

procedure TFileEC.Close;
begin
	Dec(m_OpenSos);
	if m_OpenSos<=0 then begin
		if m_Fa<>0 then CloseHandle(m_Fa);
		m_Fa:=0;
		m_OpenSos:=0;
	end;
end;

function TFileEC.GetSize:DWORD;
var
    len:DWORD;
begin
	Open();
    len:=GetFileSize(m_Fa,nil);
	if len=$0FFFFFFFF then raise Exception.Create('TFileEC.GetSize. FileName=' + m_Name);
	Close();
	Result:=len;
end;

function TFileEC.GetFileName: WideString;
begin
    Result:=m_Name;
end;

function TFileEC.SetPointer(zn:integer; tip:integer=FILE_BEGIN):DWORD;
var
    sme:DWORD;
begin
    sme:=SetFilePointer(m_Fa,zn,nil,tip);
	if sme=$0FFFFFFFF then raise Exception.Create('TFileEC.SetPointer. FileName=' + m_Name);
	Result:=sme;
end;

function TFileEC.GetPointer:DWORD;
begin
	Result:=SetPointer(0,FILE_CURRENT);
end;

procedure TFileEC.Read(buf:Pointer; kolbyte:DWORD);
var
    temp:DWORD;
    hr:boolean;
begin
    temp:=0;
    hr:=ReadFile(m_Fa,buf^,kolbyte,temp,nil);
	if (hr=FALSE) or (temp<>kolbyte) then raise Exception.Create('TFileEC.Read. FileName=' + m_Name+ ' kolbyte=' + IntToStr(kolbyte) + ' GetLastError=' + IntToStr(GetLastError()));
end;

procedure TFileEC.Write(buf:Pointer; kolbyte:DWORD);
var
    temp:DWORD;
    hr:boolean;
begin
	if kolbyte<=0 then Exit;
    hr:=WriteFile(m_Fa,buf^,kolbyte,temp,nil);
	if (hr=FALSE) or (temp<>kolbyte) then raise Exception.Create('TFileEC.Write. FileName=' + m_Name+ ' kolbyte=' + IntToStr(kolbyte));
end;

function TFileEC.ReadString:WideString;
var
    tv:WideChar;
begin
    Result:='';
    while True do begin
        Read(@tv,2);
        if tv=Chr(0) then break;
        Result:=Result+WideString(tv);
    end;
end;

end.
