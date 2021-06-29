unit GraphBufList;

interface

uses Windows,Classes,SysUtils,GraphBuf,GraphBufHist;

type
TGraphBufList = class(TObject)
    public
        FList:TList;
        FCur:integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        function GetHist(no:integer):TGraphBufHist;
        procedure SetHist(no:integer; el:TGraphBufHist);
        property Hist[no:integer]:TGraphBufHist read GetHist write SetHist;

        function GetCount:integer;
        property Count:integer read GetCount;

        function GetCurHist:TGraphBufHist;
        property CurHist:TGraphBufHist read GetCurHist;

        function AddHist:TGraphBufHist;
        function InsertHist(no:integer):TGraphBufHist;
        procedure DelHist(no:integer);
        procedure CurHistUp;
        procedure CurHistDown;

        function RectIntersectImage(hist1,buf1,hist2,buf2:integer):TRect;
end;

var
GBufList:TGraphBufList;

implementation

constructor TGraphBufList.Create;
begin
    FList:=TList.Create;
end;

destructor TGraphBufList.Destroy;
begin
    Clear;
    FList.Free;
end;

procedure TGraphBufList.Clear;
var
    i:integer;
begin
    for i:=0 to FList.Count-1 do begin
        Hist[i].Free;
    end;
    FList.Clear;
    FCur:=0;
end;

function TGraphBufList.GetHist(no:integer):TGraphBufHist;
begin
    Result:=FList.Items[no];
end;

procedure TGraphBufList.SetHist(no:integer; el:TGraphBufHist);
begin
    FList.Items[no]:=el;
end;

function TGraphBufList.GetCount:integer;
begin
    Result:=FList.Count;
end;

function TGraphBufList.GetCurHist:TGraphBufHist;
begin
    Result:=Hist[FCur];
end;

function TGraphBufList.AddHist:TGraphBufHist;
var
    hist:TGraphBufHist;
begin
    hist:=TGraphBufHist.Create;
    FList.Add(hist);
    FCur:=Count-1;
    Result:=hist;
end;

function TGraphBufList.InsertHist(no:integer):TGraphBufHist;
var
    hist:TGraphBufHist;
begin
    hist:=TGraphBufHist.Create;
    FList.Insert(no,hist);
    FCur:=no;
    Result:=hist;
end;

procedure TGraphBufList.DelHist(no:integer);
begin
    Hist[no].Free;
    FList.Delete(no);
    if FCur>=Count then FCur:=Count-1;
end;

procedure TGraphBufList.CurHistUp;
var
    el:TGraphBufHist;
begin
    if (Count<2) or (FCur<1) then Exit;
    el:=Hist[FCur-1];
    Hist[FCur-1]:=Hist[FCur];
    Hist[FCur]:=el;
    dec(FCur);
end;

procedure TGraphBufList.CurHistDown;
var
    el:TGraphBufHist;
begin
    if (Count<2) or (FCur>=(Count-1)) then Exit;
    el:=Hist[FCur+1];
    Hist[FCur+1]:=Hist[FCur];
    Hist[FCur]:=el;
    inc(FCur);
end;

function TGraphBufList.RectIntersectImage(hist1,buf1,hist2,buf2:integer):TRect;
var
    tr1,tr2:TRect;
begin
    tr1.Left:=Hist[hist1].Buf[buf1].FPos.x;
    tr1.Top:=Hist[hist1].Buf[buf1].FPos.y;
    tr1.Right:=tr1.Left+Hist[hist1].Buf[buf1].FLenX;
    tr1.Bottom:=tr1.Top+Hist[hist1].Buf[buf1].FLenY;

    tr2.Left:=Hist[hist2].Buf[buf2].FPos.x;
    tr2.Top:=Hist[hist2].Buf[buf2].FPos.y;
    tr2.Right:=tr2.Left+Hist[hist2].Buf[buf2].FLenX;
    tr2.Bottom:=tr2.Top+Hist[hist2].Buf[buf2].FLenY;

    if not IntersectRect(Result,tr1,tr2) then begin
        Result.Left:=0;
        Result.Top:=0;
        Result.Right:=0;
        Result.Bottom:=0;
    end;
end;

end.
