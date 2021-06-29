unit GraphBufHist;

interface

uses Windows,Classes,SysUtils,GraphBuf;

type
TGraphBufHist = class(TObject)
    public
        FList:TList;
        FCur:integer;

        FName:string;
        FMR,FMG,FMB,FMA:DWORD;

        FSaveFormat:integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        function GetBuf(no:integer):TGraphBuf;
        property Buf[no:integer]:TGraphBuf read GetBuf;

        function GetCount:integer;
        property Count:integer read GetCount;

        function GetCurBuf:TGraphBuf;
        property CurBuf:TGraphBuf read GetCurBuf;

        function AddBuf:TGraphBuf;
        procedure DelBuf(tstart,tend:integer); overload;
        procedure DelBuf(no:integer); overload;

        procedure NewModify;
end;

implementation

constructor TGraphBufHist.Create;
begin
    FList:=TList.Create;

    FName:='';
    FMR:=3;
    FMG:=3;
    FMB:=3;
    FMA:=3;
end;

destructor TGraphBufHist.Destroy;
begin
    FList.Free;
end;

procedure TGraphBufHist.Clear;
var
    i:integer;
begin
    for i:=0 to FList.Count-1 do begin
        Buf[i].Free;
    end;
    FList.Clear;
    FCur:=0;
end;

function TGraphBufHist.GetBuf(no:integer):TGraphBuf;
begin
    Result:=FList.Items[no];
end;

function TGraphBufHist.GetCount:integer;
begin
    Result:=FList.Count;
end;

function TGraphBufHist.GetCurBuf:TGraphBuf;
begin
    Result:=Buf[FCur];
end;

function TGraphBufHist.AddBuf:TGraphBuf;
var
    gb:TGraphBuf;
begin
    gb:=TGraphBuf.Create;
    FList.Add(gb);
    FCur:=Count-1;
    Result:=gb;
end;

procedure TGraphBufHist.DelBuf(tstart,tend:integer);
var
    i,cnt:integer;
begin
    for i:=tstart to tend do begin
        Buf[i].Free;
    end;
    cnt:=(tend-tstart)+1;
    for i:=0 to cnt-1 do begin
        FList.Delete(tstart);
    end;
    if FCur>=Count then FCur:=Count-1;
end;

procedure TGraphBufHist.DelBuf(no:integer);
begin
    DelBuf(no,no);
end;

procedure TGraphBufHist.NewModify;
var
    gb:TGraphBuf;
begin
    if FCur<(Count-1) then begin
        DelBuf(FCur+1,Count-1);
    end;
    gb:=AddBuf;
    gb.Load(Buf[Count-2]);
    gb.FPos:=Buf[Count-2].FPos;
    FCur:=Count-1;
end;

end.
