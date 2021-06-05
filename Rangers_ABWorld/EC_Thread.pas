unit EC_Thread;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils, Classes;

type
  TThreadEC = class(TObject)
  protected
    FHandle: THandle;
    FThreadID: longword;
    FPriority: TThreadPriority;
    FTerminate: boolean;

    FTerminateEvent: THandle;

    FSuspendMy: boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Execute; virtual;

    property Handle: THandle read FHandle;

    procedure SetPriority(Value: TThreadPriority);
    property Priority: TThreadPriority read FPriority write SetPriority;

    procedure SuspendMy;
    procedure ResumeMy;
    property IsSuspendMy: boolean read FSuspendMy;

    procedure Terminate;
    property Terminated: boolean read FTerminate write FTerminate;

    procedure Run;
    function IsRun: boolean;
    function WaitEnd(time: DWORD = INFINITE): boolean;
  end;

implementation

const
  Priorities: array [TThreadPriority] of integer =
    (THREAD_PRIORITY_IDLE, THREAD_PRIORITY_LOWEST, THREAD_PRIORITY_BELOW_NORMAL,
    THREAD_PRIORITY_NORMAL, THREAD_PRIORITY_ABOVE_NORMAL,
    THREAD_PRIORITY_HIGHEST, THREAD_PRIORITY_TIME_CRITICAL);

function ThreadProcEC(thread: TThreadEC): integer;
begin
  try
    //        thread.FTerminate:=false;
    thread.Execute;
  finally
    thread.FTerminate := false;
    if thread.FHandle <> 0 then
    begin
      CloseHandle(thread.FHandle);
      thread.FHandle := 0;
    end;
    thread.FThreadID := 0;
  end;
  result := 0;
end;

constructor TThreadEC.Create;
begin
  inherited Create;

  FTerminateEvent := CreateEvent(nil, true, false, nil);
  if FTerminateEvent = 0 then
    raise Exception.Create('TThreadEC.Create CreateEvent');
end;

destructor TThreadEC.Destroy;
begin
  if IsRun then
  begin
    Terminate;
    WaitEnd;
  end;
  if FTerminateEvent <> 0 then
  begin
    CloseHandle(FTerminateEvent);
    FTerminateEvent := 0;
  end;
  inherited Destroy;
end;

procedure TThreadEC.Execute;
begin
  //    SFT('Start Thread');
  while not Terminated do
    Sleep(1000);
  //    SFT('End Thread');
end;

procedure TThreadEC.SetPriority(Value: TThreadPriority);
begin
  FPriority := Value;
  if FHandle <> 0 then
    SetThreadPriority(FHandle, Priorities[Value]);
end;

procedure TThreadEC.SuspendMy;
begin
  FSuspendMy := true;
end;

procedure TThreadEC.ResumeMy;
begin
  FSuspendMy := false;
end;

procedure TThreadEC.Terminate;
begin
  FTerminate := true;
  SetEvent(FTerminateEvent);
end;

procedure TThreadEC.Run;
begin
  if IsRun then
    exit;
  ResetEvent(FTerminateEvent);
  FHandle := BeginThread(nil, 0, @ThreadProcEC, self, CREATE_SUSPENDED, FThreadID);
  Priority := FPriority;
  ResumeThread(FHandle);
end;

function TThreadEC.IsRun: boolean;
begin
  result := FHandle <> 0;
end;

function TThreadEC.WaitEnd(time: DWORD): boolean;
begin
  if not IsRun then
  begin
    result := true;
    exit;
  end;
  if WaitForSingleObject(FHandle, time) = WAIT_TIMEOUT then
    result := false
  else
    result := true;
end;

end.