unit aMyFunction;

interface

type
  TPos = record
    x, y: single
  end;

function AngleDist(a, b: single): single;
function AngleCorrect360(a: single): single;
function Angle360ToRad(a: single): single;
function AngleRadTo360(a: single): single;

implementation

function AngleDist(a, b: single): single;
begin
  result := abs(a - b);
end;

function AngleCorrect360(a: single): single;
begin
  if (a < 0) then
    result := AngleCorrect360(a + 360)
  else if (a > 360) then
    result := AngleCorrect360(a - 360)
  else
    result := a;
end;

function Angle360ToRad(a: single): single;
begin
  result := a / 180.0 * 3.1415;
end;

function AngleRadTo360(a: single): single;
begin
  result := a * 180.0 / 3.1415;
end;

end.