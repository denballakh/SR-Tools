unit VOper;

interface

uses Math, ab_Obj3D, GR_DirectX3D8;

const
  ToRad = pi / 180;
  ToGrad = 180 / pi;

function D3D_Normalize(var v: D3DVECTOR): D3DVECTOR;
function D3D_CrossProduct(var o1: D3DVECTOR; var o2: D3DVECTOR): D3DVECTOR;
function D3D_DotProduct(var o1: D3DVECTOR; var o2: D3DVECTOR): single;
function D3D_ZeroMatrix: D3DMATRIX;
function D3D_IdentityMatrix: D3DMATRIX;
function D3D_RotateZMatrix(angle: single): D3DMATRIX;
function D3D_RotateMatrix(v: D3DVECTOR; angle: single): D3DMATRIX;
function D3D_RotateTo(v: D3DVECTOR): D3DMATRIX;
function D3D_ProjectionMatrix(near_plane, far_plane, fov, scale: single): D3DMATRIX;
function D3D_ViewMatrix(var from: D3DVECTOR; var at: D3DVECTOR; var world_up: D3DVECTOR): D3DMATRIX;
procedure D3D_InverseMatrix(var m: D3DMATRIX; var des: D3DMATRIX);
procedure D3D_InvertMatrix(var m: D3DMATRIX; var des: D3DMATRIX);
function D3D_MatrixMult(var a: D3DMATRIX; var b: D3DMATRIX): D3DMATRIX;
function D3D_TransformVector(var m: D3DMATRIX; var v: D3DVECTOR): D3DVECTOR;

function D3D_IntersectTriangle(var orig: D3DVECTOR; var dir: D3DVECTOR; var v0: D3DVECTOR;
  var v1: D3DVECTOR; var v2: D3DVECTOR; var t: single; var u: single; var v: single): boolean;

implementation

function D3D_Normalize(var v: D3DVECTOR): D3DVECTOR;
var
  r: single;
begin
  r := 1 / sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
  result.x := v.x * r;
  result.y := v.y * r;
  result.z := v.z * r;
end;

function D3D_CrossProduct(var o1: D3DVECTOR; var o2: D3DVECTOR): D3DVECTOR;
begin
  result.x := o1.y * o2.z - o1.z * o2.y;
  result.y := o1.z * o2.x - o1.x * o2.z;
  result.z := o1.x * o2.y - o1.y * o2.x;
end;

function D3D_DotProduct(var o1: D3DVECTOR; var o2: D3DVECTOR): single;
begin
  result := o1.x * o2.x + o1.y * o2.y + o1.z * o2.z;
end;

function D3D_ZeroMatrix: D3DMATRIX;
var
  i, j: integer;
begin
  for i := 0 to 3 do
    for j := 0 to 3 do
      result.m[i, j] := 0.0;
end;

function D3D_IdentityMatrix: D3DMATRIX;
var
  i, j: integer;
begin
  for i := 0 to 3 do
  begin
    for j := 0 to 3 do
      result.m[i, j] := 0.0;
    result.m[i, i] := 1.0;
  end;
end;

function D3D_RotateZMatrix(angle: single): D3DMATRIX;
var
  ca, sa: single;
begin
  ca := cos(angle);
  sa := sin(angle);
  result := D3D_IdentityMatrix;
  result.m[0, 0] := ca;
  result.m[1, 1] := ca;
  result.m[0, 1] := -sa;
  result.m[1, 0] := sa;
end;

function D3D_RotateMatrix(v: D3DVECTOR; angle: single): D3DMATRIX;
var
  ca, sa: single;
begin
  ca := cos(angle);
  sa := sin(angle);
  result.m[0, 0] := v.x * v.x + (1 - v.x * v.x) * ca;
  result.m[0, 1] := v.x * v.y * (1 - ca) + v.z * sa;
  result.m[0, 2] := v.x * v.z * (1 - ca) - v.y * sa;
  result.m[0, 3] := 0;
  result.m[1, 0] := v.x * v.y * (1 - ca) - v.z * sa;
  result.m[1, 1] := v.y * v.y + (1 - v.y * v.y) * ca;
  result.m[1, 2] := v.y * v.z * (1 - ca) + v.x * sa;
  result.m[1, 3] := 0;
  result.m[2, 0] := v.x * v.z * (1 - ca) + v.y * sa;
  result.m[2, 1] := v.y * v.z * (1 - ca) - v.x * sa;
  result.m[2, 2] := v.z * v.z + (1 - v.z * v.z) * ca;
  result.m[2, 3] := 0;
  result.m[3, 0] := 0;
  result.m[3, 1] := 0;
  result.m[3, 2] := 0;
  result.m[3, 3] := 1;
end;

function D3D_RotateTo(v: D3DVECTOR): D3DMATRIX;
var
  m1, m2: D3DMATRIX;
  //    d:single;
  az: single;
  ay: single;
begin
  m1 := D3D_IdentityMatrix;
  m2 := D3D_IdentityMatrix;

  //    d:=sqrt(sqr(v.y)+sqr(v.z));
{    m1.m[1,1]:=v.z/d;
    m1.m[1,2]:=v.y/d;
    m1.m[2,1]:=-v.y/d;
    m1.m[2,2]:=v.z/d;

    m2.m[0,0]:=v.x;
    m2.m[0,2]:=d;
    m2.m[2,0]:=-d;
    m2.m[2,2]:=v.x;}

{    m1.m[1,1]:=v.z/d;
    m1.m[2,1]:=v.y/d;
    m1.m[1,2]:=-v.y/d;
    m1.m[2,2]:=v.z/d;

    m2.m[0,0]:=v.x;
    m2.m[2,0]:=d;
    m2.m[0,2]:=-d;
    m2.m[2,2]:=v.x;}

  if v.x > 0 then
    az := ArcTan(v.y / v.x)
  else if v.x < 0 then
    az := pi + ArcTan(v.y / v.x)
  else if (v.x = 0) and (v.y >= 0) then
    az := pi / 2
  else
    az := 3 * pi / 2;

  ay := arccos(v.z / sqrt(sqr(v.x) + sqr(v.y) + sqr(v.z)));

  m1.m[0, 0] := cos(az);
  m1.m[1, 0] := -sin(az);
  m1.m[0, 1] := sin(az);
  m1.m[1, 1] := cos(az);

  m2.m[0, 0] := cos(ay);
  m2.m[2, 0] := sin(ay);
  m2.m[0, 2] := -sin(ay);
  m2.m[2, 2] := cos(ay);

  result := D3D_MatrixMult(m1, m2);
end;

function D3D_ProjectionMatrix(near_plane, far_plane, fov, scale: single): D3DMATRIX;
var
  c, s, Q: single;
begin
  c := cos(fov * 0.5);
  s := sin(fov * 0.5);
  Q := s / (1.0 - near_plane / far_plane);

  result := D3D_ZeroMatrix;

  result.m[0, 0] := c * scale;
  result.m[1, 1] := c * scale;
  result.m[2, 2] := Q;
  result.m[3, 2] := -Q * near_plane;
  result.m[2, 3] := s;
end;

function D3D_ViewMatrix(var from: D3DVECTOR; var at: D3DVECTOR; var world_up: D3DVECTOR): D3DMATRIX;
var
  view_dir: D3DVECTOR;
  right: D3DVECTOR;
  up: D3DVECTOR;
begin
  result := D3D_IdentityMatrix;

  view_dir := D3DV(at.x - from.x, at.y - from.y, at.z - from.z);
  view_dir := D3D_Normalize(view_dir);

  right := D3D_CrossProduct(world_up, view_dir);
  up := D3D_CrossProduct(view_dir, right);

  right := D3D_Normalize(right);
  up := D3D_Normalize(up);

  result.m[0, 0] := right.x;
  result.m[1, 0] := right.y;
  result.m[2, 0] := right.z;
  result.m[0, 1] := up.x;
  result.m[1, 1] := up.y;
  result.m[2, 1] := up.z;
  result.m[0, 2] := view_dir.x;
  result.m[1, 2] := view_dir.y;
  result.m[2, 2] := view_dir.z;

  result.m[3, 0] := -D3D_DotProduct(right, from);
  result.m[3, 1] := -D3D_DotProduct(up, from);
  result.m[3, 2] := -D3D_DotProduct(view_dir, from);
end;

procedure D3D_InverseMatrix(var m: D3DMATRIX; var des: D3DMATRIX);
var
  n: D3DMATRIX;
  i, j: integer;
  indx: array[0..3] of integer;
  d: single;
  col: array[0..3] of single;

  procedure lubksb(var a: D3DMATRIX);
  var
    i, j, ii, ip: integer;
    sum: single;
  begin
    ii := -1;
    for i := 0 to 3 do
    begin
      ip := indx[i];
      sum := col[ip];
      col[ip] := col[i];
      if (ii >= 0) then
        for j := ii to i - 1 do
          sum := sum - (a.m[i, j] * col[j])
      else if (sum <> 0.0) then
        ii := i;
      col[i] := sum;
    end;
    for i := 3 downto 0 do
    begin
      sum := col[i];
      for j := i + 1 to 3 do
        sum := sum - (a.m[i, j] * col[j]);
      col[i] := sum / a.m[i, i];
    end;
  end;

  procedure ludcmp(var a: D3DMATRIX; var d: single);
  var
    vv: array[0..3] of single;
    big, dum, sum, tmp: single;
    i, imax, j, k: integer;
  begin
    d := 1.0;
    for i := 0 to 3 do
    begin
      big := 0.0;
      for j := 0 to 3 do
      begin
        tmp := abs(a.m[i, j]);
        if tmp > big then
          big := tmp;
      end;
      vv[i] := 1.0 / big;
    end;
    for j := 0 to 3 do
    begin
      i := 0;
      while i < j do
      begin
        sum := a.m[i, j];
        k := 0;
        while k < i do
        begin
          sum := sum - (a.m[i, k] * a.m[k, j]);
          Inc(k);
        end;
        a.m[i, j] := sum;
        Inc(i);
      end;
      imax := 0;
      big := 0.0;
      for i := j to 3 do
      begin
        sum := a.m[i, j];
        k := 0;
        while k < j do
        begin
          sum := sum - (a.m[i, k] * a.m[k, j]);
          Inc(k);
        end;
        a.m[i, j] := sum;
        dum := vv[i] * abs(sum);
        if dum >= big then
        begin
          big := dum;
          imax := i;
        end;
      end;
      if (j <> imax) then
      begin
        for k := 0 to 3 do
        begin
          dum := a.m[imax, k];
          a.m[imax, k] := a.m[j, k];
          a.m[j, k] := dum;
        end;
        d := -d;
        vv[imax] := vv[j];
      end;
      indx[j] := imax;
      if (a.m[j, j] = 0.0) then
        a.m[j, j] := 1.0e-20;
      if j <> 3 then
      begin
        dum := 1.0 / a.m[j, j];
        for i := j + 1 to 3 do
          a.m[i, j] := a.m[i, j] * dum;
      end;
    end;
  end;

begin
  n := m;
  ludcmp(n, d);

  for j := 0 to 3 do
  begin
    for i := 0 to 3 do
      col[i] := 0.0;
    col[j] := 1.0;
    lubksb(n);
    for i := 0 to 3 do
      des.m[i, j] := col[i];
  end;
end;

procedure D3D_InvertMatrix(var m: D3DMATRIX; var des: D3DMATRIX);
var
  d, mulby: single;
  x: D3DMATRIX;
  i, j, k: integer;
begin
  x := m;
  des := D3D_IdentityMatrix;
  for i := 0 to 3 do
  begin
    d := x.m[i][i];
    if d <> 1.0 then
      for j := 0 to 3 do
      begin
        des.m[i][j] := des.m[i][j] / d;
        x.m[i][j] := x.m[i][j] / d;
      end;
    for j := 0 to 3 do
      if j <> i then
        if x.m[j][i] <> 0 then
        begin
          mulby := x.m[j][i];
          for k := 0 to 3 do
          begin
            x.m[j][k] := x.m[j][k] - mulby * x.m[i][k];
            des.m[j][k] := des.m[j][k] - mulby * des.m[i][k];
          end;
        end;
  end;
end;

function D3D_MatrixMult(var a: D3DMATRIX; var b: D3DMATRIX): D3DMATRIX;
var
  i, j, k: integer;
begin
  result := D3D_ZeroMatrix;
  for i := 0 to 3 do
    for j := 0 to 3 do
      for k := 0 to 3 do
        result.m[i, j] := result.m[i, j] + a.m[k, j] * b.m[i, k];
end;

function D3D_TransformVector(var m: D3DMATRIX; var v: D3DVECTOR): D3DVECTOR;
(*asm
  push  ebx
    push  edx
    push  ecx

  mov    ebx,v
    mov    edx,m
    mov    ecx,Result
    fld    QWORD PTR D3DVECTOR[ebx].z        // (v.z)
    fld       QWORD PTR D3DVECTOR[ebx].y        // (v.y) ### (v.z)
    fld    QWORD PTR D3DVECTOR[ebx].x        // (v.x) ### (v.y) ### (v.z)

    fld    QWORD PTR [edx+18h]          // m[0,3] ### v.x ### v.y ### v.z
    fmul  ST,ST(1)              // m[0,3]*v.x ### v.x ### v.y ### v.z
    fld    QWORD PTR [edx+38h]          // m[1,3] ### m[0,3]*v.x ### v.x ### v.y ### v.z
    fmul  ST,ST(3)              // m[1,3]*v.y ### m[0,3]*v.x ### v.x ### v.y ### v.z
    faddp  ST(1),ST              // m[0,3]*v.x+m[1,3]*v.y ### v.x ### v.y ### v.z
    fld    QWORD PTR [edx+58h]          // m[2,3] ### m[0,3]*v.x+m[1,3]*v.y ### v.x ### v.y ### v.z
    fmul  ST,ST(4)              // m[2,3]*v.z ### m[0,3]*v.x+m[1,3]*v.y ### v.x ### v.y ### v.z
    faddp  ST(1),ST              // m[0,3]*v.x+m[1,3]*v.y+m[2,3]*v.z ### v.x ### v.y ### v.z
    fadd  QWORD PTR [edx+78h]          // m[0,3]*v.x+m[1,3]*v.y+m[2,3]*v.z+m[3,3] ### v.x ### v.y ### v.z
    fld1
    fdivrp  ST(1),ST              // kof ### v.x ### v.y ### v.z

    fld    QWORD PTR [edx+0h]          // m[0,0] ## kof ### v.x ### v.y ### v.z
    fmul  ST,ST(2)              // m[0,0]*v.x ### kof ### v.x ### v.y ### v.z
    fld    QWORD PTR [edx+20h]          // m[1,0] ## m[0,0]*v.x ### kof ### v.x ### v.y ### v.z
    fmul  ST,ST(4)              // m[1,0]*v.y ## m[0,0]*v.x ### kof ### v.x ### v.y ### v.z
    faddp  ST(1),ST              // m[0,0]*v.x+m[1,0]*v.y ### kof ### v.x ### v.y ### v.z
    fld    QWORD PTR [edx+40h]          // m[2,0] ### m[0,0]*v.x+m[1,0]*v.y ### kof ### v.x ### v.y ### v.z
    fmul  ST,ST(5)              // m[2,0]*v.z ### m[0,0]*v.x+m[1,0]*v.y ### kof ### v.x ### v.y ### v.z
    faddp  ST(1),ST              // m[0,0]*v.x+m[1,0]*v.y+m[2,0]*v.z ### kof ### v.x ### v.y ### v.z
    fadd  QWORD PTR [edx+60h]          // m[0,0]*v.x+m[1,0]*v.y+m[2,0]*v.z+m[3,0] ### kof ### v.x ### v.y ### v.z
    fmul     ST,ST(1)
    fstp  QWORD PTR D3DVECTOR[ecx].x

    fld    QWORD PTR [edx+8h]
    fmul  ST,ST(2)
    fld    QWORD PTR [edx+28h]
    fmul  ST,ST(4)
    faddp  ST(1),ST
    fld    QWORD PTR [edx+48h]
    fmul  ST,ST(5)
    faddp  ST(1),ST
    fadd  QWORD PTR [edx+68h]
    fmul     ST,ST(1)
    fstp  QWORD PTR D3DVECTOR[ecx].y

    fld     QWORD PTR [edx+10h]
    fmulp  ST(2),ST
    fld     QWORD PTR [edx+30h]
    fmulp  ST(3),ST
    fld     QWORD PTR [edx+50h]
    fmulp  ST(4),ST
    fxch    ST(3)
    fadd  QWORD PTR [edx+70h]
    faddp  ST(1),ST
    faddp  ST(1),ST
    fmulp  ST(1),ST
    fstp  QWORD PTR D3DVECTOR[ecx].z

{    fld    QWORD PTR [edx+10h]
    fmul  ST,ST(2)
    fld    QWORD PTR [edx+30h]
    fmul  ST,ST(4)
    faddp  ST(1),ST
    fld    QWORD PTR [edx+50h]
    fmul  ST,ST(5)
    faddp  ST(1),ST
    fadd  QWORD PTR [edx+70h]
    fmul     ST,ST(1)
    fstp  QWORD PTR D3DVECTOR[ecx].z}

    pop    ecx
    pop    edx
  pop    ebx
end;*)
var
  //    hvec:array[0..3] of single;
  //    i:integer;
  kof: single;
begin
  kof := 1 / (v.x * m.m[0, 3] + v.y * m.m[1, 3] + v.z * m.m[2, 3] + m.m[3, 3]);
  result.x := (v.x * m.m[0, 0] + v.y * m.m[1, 0] + v.z * m.m[2, 0] + m.m[3, 0]) * kof;
  result.y := (v.x * m.m[0, 1] + v.y * m.m[1, 1] + v.z * m.m[2, 1] + m.m[3, 1]) * kof;
  result.z := (v.x * m.m[0, 2] + v.y * m.m[1, 2] + v.z * m.m[2, 2] + m.m[3, 2]) * kof;

{    for i:=0 to 3 do begin
        hvec[i]:=v.x*m[0,i]+v.y*m[1,i]+v.z*m[2,i]+m[3,i];
  end;
    Result.x:=hvec[0]/hvec[3];
    Result.y:=hvec[1]/hvec[3];
    Result.z:=hvec[2]/hvec[3];}
end;

{begin
    Result.x:=v.x*m[0,0]+v.y*m[1,0]+v.z*m[2,0]+m[3,0];
    Result.y:=v.x*m[0,1]+v.y*m[1,1]+v.z*m[2,1]+m[3,1];
    Result.z:=v.x*m[0,2]+v.y*m[1,2]+v.z*m[2,2]+m[3,2];
end;}

function D3D_SPrjMatrix(v: D3DVECTOR): D3DMATRIX;
var
  d: single;
  m1, m2: D3DMATRIX;
begin
  d := 1 / sqrt(sqr(v.x) + sqr(v.y) + sqr(v.z));
  v.x := v.x * d;
  v.y := v.y * d;
  v.z := v.z * d;

  d := sqrt(sqr(v.y) + sqr(v.z));

  m1 := D3D_IdentityMatrix;
  m1.m[1, 1] := v.z / d;
  m1.m[1, 2] := v.y / d;
  m1.m[2, 1] := -v.y / d;
  m1.m[2, 2] := v.z / d;

  m2 := D3D_IdentityMatrix;
  m2.m[0, 0] := v.x;
  m2.m[0, 2] := d;
  m2.m[2, 0] := -d;
  m2.m[2, 2] := v.x;

  result := D3D_MatrixMult(m1, m2);
end;

function D3D_IntersectTriangle(var orig: D3DVECTOR; var dir: D3DVECTOR; var v0: D3DVECTOR;
  var v1: D3DVECTOR; var v2: D3DVECTOR; var t: single; var u: single; var v: single): boolean;
var
  edge1, edge2: D3DVECTOR;
  pvec: D3DVECTOR;
  tvec: D3DVECTOR;
  qvec: D3DVECTOR;
  det: single;
  fInvDet: single;
begin
  result := false;

  edge1.x := v1.x - v0.x;
  edge1.y := v1.y - v0.y;
  edge1.z := v1.z - v0.z;
  edge2.x := v2.x - v0.x;
  edge2.y := v2.y - v0.y;
  edge2.z := v2.z - v0.z;

  pvec := D3D_CrossProduct(dir, edge2);

  det := D3D_DotProduct(edge1, pvec);
  if det < 0.0001 then
    exit;

  tvec.x := orig.x - v0.x;
  tvec.y := orig.y - v0.y;
  tvec.z := orig.z - v0.z;

  u := D3D_DotProduct(tvec, pvec);
  if (u < 0.0) or (u > det) then
    exit;

  qvec := D3D_CrossProduct(tvec, edge1);

  v := D3D_DotProduct(dir, qvec);
  if (v < 0.0) or ((u + v) > det) then
    exit;

  t := D3D_DotProduct(edge2, qvec);
  fInvDet := 1.0 / det;

  t := t * fInvDet;
  u := u * fInvDet;
  v := v * fInvDet;

  result := true;
end;

end.