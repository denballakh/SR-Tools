unit SelectLine;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils, Classes,GraphBuf,EC_Mem;

type
PSelectLineUnit = ^TSelectLineUnit;
TSelectLineUnit = record
    FStart:TPoint;
    FEnd:TPoint;
end;

TSelectLine = class(TObject)
    public
        FCount,FMax:integer;
        FBuf:Pointer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure Add(ts,te:TPoint);

        procedure Build(gb:TGraphBuf);
end;

implementation

constructor TSelectLine.Create;
begin
    inherited Create;
end;

destructor TSelectLine.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TSelectLine.Clear;
begin
    if FBuf<>nil then begin
        FreeEC(FBuf);
        FBuf:=nil;
    end;
    FMax:=0;
    FCount:=0;
end;

procedure TSelectLine.Add(ts,te:TPoint);
var
    cu:PSelectLineUnit;
begin
    if FCount>=FMax then begin
        FMax:=FMax+25;
        FBuf:=ReAllocREC(FBuf,FMax*sizeof(TSelectLineUnit));
    end;
    cu:=PAdd(FBuf,FCount*sizeof(TSelectLineUnit));
    inc(FCount);
    cu.FStart:=ts;
    cu.FEnd:=te;
end;

procedure TSelectLine.Build(gb:TGraphBuf);
var
    x,y,tstart:integer;
    col1,col2:BYTE;
begin
    Clear;

    //////////////// y /////////////////
    for y:=0 to (gb.FLenY-1+1) do begin
        tstart:=-1;
        x:=0;
        while x<gb.FLenX do begin
            if y=0 then col1:=0 else col1:=gb.PixelChannel(x,y-1,0);
            if y=gb.FLenY then col2:=0 else col2:=gb.PixelChannel(x,y,0);

            if col1<>col2 then begin
                if tstart<0 then begin
                    tstart:=x;
                end;
            end else begin
                if tstart>=0 then begin
                    Add(Point(tstart,y),Point(x,y));
                    tstart:=-1;
                end;
            end;
            inc(x);
        end;
        if tstart>=0 then begin
            Add(Point(tstart,y),Point(x,y));
        end;
    end;

    //////////////// x /////////////////
    for x:=0 to (gb.FLenX-1+1) do begin
        tstart:=-1;
        y:=0;
        while y<gb.FLenY do begin
            if x=0 then col1:=0 else col1:=gb.PixelChannel(x-1,y,0);
            if x=gb.FLenX then col2:=0 else col2:=gb.PixelChannel(x,y,0);

            if col1<>col2 then begin
                if tstart<0 then begin
                    tstart:=y;
                end;
            end else begin
                if tstart>=0 then begin
                    Add(Point(x,tstart),Point(x,y));
                    tstart:=-1;
                end;
            end;
            inc(y);
        end;
        if tstart>=0 then begin
            Add(Point(x,tstart),Point(x,y));
        end;
    end;

    FBuf:=ReAllocREC(FBuf,FCount*sizeof(TSelectLineUnit));
end;

end.
