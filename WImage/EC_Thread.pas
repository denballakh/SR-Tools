unit EC_Thread;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils, Classes;

type
TThreadEC = class(TObject)
    private
        FHandle:THandle;
        FThreadID:LongWord;
        FPriority:TThreadPriority;
        FTerminate:boolean;

        FEndDestroy:boolean;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Execute; virtual;

        property Handle:THandle read FHandle;
        property EndDestroy:boolean read FEndDestroy write FEndDestroy;

        procedure SetPriority(value: TThreadPriority);
        property Priority:TThreadPriority read FPriority write SetPriority;

        procedure Terminate;
        property Terminated:boolean read FTerminate write FTerminate;

        procedure Run;
        function IsRun:boolean;
        function WaitEnd(time:DWORD=INFINITE):boolean;

        procedure TerminateThread;
end;

implementation

const
  Priorities: array [TThreadPriority] of Integer =
   (THREAD_PRIORITY_IDLE, THREAD_PRIORITY_LOWEST, THREAD_PRIORITY_BELOW_NORMAL,
    THREAD_PRIORITY_NORMAL, THREAD_PRIORITY_ABOVE_NORMAL,
    THREAD_PRIORITY_HIGHEST, THREAD_PRIORITY_TIME_CRITICAL);

function ThreadProcEC(thread: TThreadEC): Integer;
begin
    try
//        thread.FTerminate:=false;
        thread.Execute;
    finally
        thread.FTerminate:=false;
        if thread.FHandle<>0 then begin CloseHandle(thread.FHandle); thread.FHandle:=0; end;
        thread.FThreadID:=0;
    end;
    if thread.FEndDestroy then thread.Free;
    Result:=0;
end;

constructor TThreadEC.Create;
begin
    inherited Create;
    FEndDestroy:=false;
end;

destructor TThreadEC.Destroy;
begin
    if IsRun then begin
        Terminate;
        WaitEnd;
    end;
    inherited Destroy;
end;

procedure TThreadEC.Execute;
begin
    while not Terminated do begin
        Sleep(1000);
    end;
end;

procedure TThreadEC.SetPriority(value: TThreadPriority);
begin
    FPriority:=value;
    if FHandle<>0 then SetThreadPriority(FHandle, Priorities[Value]);
end;

procedure TThreadEC.Terminate;
begin
    FTerminate:=true;
end;

procedure TThreadEC.Run;
begin
    if IsRun then Exit;
    FHandle:=BeginThread(nil,0,@ThreadProcEC,self,CREATE_SUSPENDED,FThreadID);
    Priority:=FPriority;
    ResumeThread(FHandle);
end;

function TThreadEC.IsRun:boolean;
begin
    Result:=FHandle<>0;
end;

function TThreadEC.WaitEnd(time:DWORD):boolean;
begin
    if not IsRun then begin Result:=True; Exit; end;
    if WaitForSingleObject(FHandle,time)=WAIT_TIMEOUT then Result:=false else Result:=true;
end;

procedure TThreadEC.TerminateThread;
begin
    EndThread(0);
end;

end.
