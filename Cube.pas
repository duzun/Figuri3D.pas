{********************************
   Autor: Dumitru Uzun (DUzun)
   Data: 25.05.2009
 ********************************}
Unit Cube;
interface
USES  CRT,  Graph;

CONST   Unu = 5;        { Pentru adjustarea dimensiunilor }
        Grade = pi/180; { x * Grade = y Radiani}
        Ax_X = 1;
        Ax_Y = 2;
        Ax_Z = 3;

{$F+}
TYPE    TVector  = packed array[1..3] of Real;
        TReper   = packed array[0..3] of TVector;   {O, e1, e2, e3}
        TProiec  = (prParalel, prCentral);
        TDrowFig = PROCEDURE (Sis: TReper; pr: TProiec);


VAR     GD, GM     : integer;  {Pentru initierea modului grafic}
        Depth      : Word;     {Distanta pana la centrul de proiectie}
        MidX, MidY : word;     {Mijlocul ecranului}
        R          : TReper;   {Reperul figurii}
        pr         : TProiec;  {Tipul de proiectie}
        alfa       : Integer;
        ax         : Byte;     {Axa de rotatie}
        DrowFig    : TDrowFig; {Procedura de desenare a figurei}
{---------------------------------------------------------------}
PROCEDURE Cub(Sis: TReper; pr: TProiec);               {Desenarea cubului}
PROCEDURE Icosaedru(Sis: TReper; pr: TProiec);         {Desenarea icosaedrului}
{---------------------------------------------------------------}
PROCEDURE InitFiguri;                                  {Initializarea valorilor}
PROCEDURE Moves;                                       {Efectuarea transformarilor si desenarea}

PROCEDURE Help;
FUNCTION  Taste(Key: char): Char;
{---------------------------------------------------------------}
implementation
{---------------------------------------------------------------}
PROCEDURE Proiec_Central(P: TVector; E: TReper; VAR M: TVector); FORWARD;
PROCEDURE Proiec_Paralel(P: TVector; E: TReper; VAR M: TVector);
    {-----------------------------------------------------------}
    PROCEDURE AddVec2D (VAR r: TVector; v1, v2: TVector);
    BEGIN  { r := v1 + v2 }
       r[1] := v1[1] + v2[1];
       r[2] := v1[2] + v2[2];
    END;
    {-----------------------------------------------------------}
    PROCEDURE MulScal2D(VAR r: TVector; v: TVector; scal: Real);
    BEGIN  { r := v * scal }
       r[1] := v[1] * scal;
       r[2] := v[2] * scal;
    END;
    {-----------------------------------------------------------}
BEGIN
   { M = (O + P1*e1 + P2*e2 + P3*e3) }
   MulScal2D(E[1], E[1], P[1]); {e1 := P1 * e1}
   MulScal2D(E[2], E[2], P[2]); {e2 := P2 * e2}
   MulScal2D(E[3], E[3], P[3]); {e3 := P3 * e3}
   AddVec2D(M, e[0], e[1]);     {M := O + e1}
   AddVec2D(M, M,    e[2]);     {M := M + e2}
   AddVec2D(M, M,    e[3]);     {M := M + e3}
END;
{---------------------------------------------------------------}
PROCEDURE CoordAbsol(P: TVector; E: TReper; VAR M: TVector);
    {-----------------------------------------------------------}
    PROCEDURE AddVec(VAR r: TVector; v1, v2: TVector);
    BEGIN  { r := v1 + v2 }
       r[1] := v1[1] + v2[1];
       r[2] := v1[2] + v2[2];
       r[3] := v1[3] + v2[3];
    END;
    {-----------------------------------------------------------}
    PROCEDURE MulScal(VAR r: TVector; v: TVector; scal: Real);
    BEGIN  { r := v * scal }
       r[1] := v[1] * scal;
       r[2] := v[2] * scal;
       r[3] := v[3] * scal;
    END;
    {-----------------------------------------------------------}
BEGIN { M = (O + P1*e1 + P2*e2 +P3*e3) }
   MulScal(e[1], e[1], P[1]); {e1 := P1 * e1}
   MulScal(e[2], e[2], P[2]); {e2 := P2 * e2}
   MulScal(e[3], e[3], P[3]); {e3 := P3 * e3}
   AddVec(M, e[0], e[1]);     {M := O + e1}
   AddVec(M, M,    e[2]);     {M := M + e2}
   AddVec(M, M,    e[3]);     {M := M + e3}
END;
{---------------------------------------------------------------}
PROCEDURE Proiec(xyz: TVector; VAR xy: TVector);
BEGIN  {3D -> 2D}
  { Atentie! xyz[3] <> -Depth, altfel se obtine eroare }
  IF (xyz[3] <> -Depth) THEN  xy[3] := Depth  / (xyz[3]+Depth)
                        else  xy[3] := 1.7e+38; {infinit}

  xy [1] := xyz[1] * xy[3]; { x := x * (Depth / (z+Depth)) }
  xy [2] := xyz[2] * xy[3]; { y := y * (Depth / (z+Depth)) }
END;
{---------------------------------------------------------------}
PROCEDURE Proiec_Central(P: TVector; E: TReper; VAR M: TVector);
BEGIN
  CoordAbsol(P, E, P);
  Proiec(P, M);
END;
{---------------------------------------------------------------}
PROCEDURE RotAx(var v: TVector; rad: Real; Ax: byte); {Rotirea vectorului}
var sn, cs, x, y: real;
    i, j: byte;
BEGIN
   { case ax of 1: Ox; 2: Oy; 3: Oz; }
   sn := sin(rad);  i := ax mod 3 + 1; inc(ax);  x := v[i];
   cs := cos(rad);  j := ax mod 3 + 1;           y := v[j];
   {Rotirea vectorului v}
   v[i] := x*cs - y*sn;
   v[j] := x*sn + y*cs;
END;
{---------------------------------------------------------------}
PROCEDURE RotSis(var E: TReper; rad: Real; Ax: byte);  {Rotirea sistemului de coordonate}
BEGIN {A roti sistemul inseamna a roti vectorii sistemului}
   ax := ax mod 3;
   RotAx(e[1], rad, ax);
   RotAx(e[2], rad, ax);
   RotAx(e[3], rad, ax);
END;
{---------------------------------------------------------------}
FUNCTION Line2d(p1, p2: TVector): boolean;
BEGIN
   {??? punctele pot iesi in afara limitelor ecranului}
   Line( round(p1[1]) + MidX, -round(p1[2]) + MidY,
         round(p2[1]) + MidX, -round(p2[2]) + MidY );
END;
{---------------------------------------------------------------}
PROCEDURE Cub(Sis: TReper; pr: TProiec);
VAR P : array[0..7] of TVector;
    i : integer;
BEGIN
  {Amplasarea punctelor in spatiu (in reper)}
  FOR i:=0 TO 7 DO BEGIN
     IF (i and 1) <> 0 THEN p[i][1] := Unu else p[i][1] := -Unu;
     IF (i and 2) <> 0 THEN p[i][2] := Unu else p[i][2] := -Unu;
     IF (i and 4) <> 0 THEN p[i][3] := Unu else p[i][3] := -Unu;
  END;

  {Calcularea coordonatelor plane}
  FOR i:=0 TO 7 DO CASE pr OF
    prCentral: Proiec_Central(P[i], Sis, P[i]); {  I metoda }
    prParalel: Proiec_Paralel(P[i], Sis, P[i]); { II metoda }
  END;

  {Desenarea segmentelor figurii}
  FOR i:=0 TO 3 DO BEGIN
    Line2D(P[i],           P[i + 4]);
    Line2D(P[2*i],         P[2*i + 1]);
    Line2D(P[i+i and 2+2], P[i+i and 2]);
  END;
END;
{---------------------------------------------------------------}
PROCEDURE Icosaedru(Sis: TReper; pr: TProiec);
var P :array[1..12] of TVector;
    u : real;
    i : integer;
BEGIN
  {Unghiul la centru dintre doua varfuri}
  u := 2*arctan(2/(sqrt(5)+1));

  {Amplasarea punctelor in spatiu (reper)}
  FOR i:=1 TO 12 DO BEGIN P[i][1]:=0;  P[i][3]:=0; END;
  FOR i:=1 TO 6  DO p[i][2] := Unu;
  FOR i:=7 TO 12 DO p[i][2] :=-Unu;
  FOR i:=2 TO 11 DO RotAx(P[i], u,                3);
  FOR i:=2 TO 6  DO RotAx(P[i], (72*i)*Grade,     2);
  FOR i:=7 TO 11 DO RotAx(P[i], (72*(i-3))*Grade, 2);

  {Calcularea coordonatelor plane}
  FOR i:=1 TO 12 DO CASE pr OF
    prCentral: Proiec_Central(P[i], Sis, P[i]); {  I metoda }
    prParalel: Proiec_Paralel(P[i], Sis, P[i]); { II metoda }
  END;

  {Desenarea segmentelor figurii}
  FOR i:=2 TO 6  DO Line2D(P[1], P[i]);
  FOR i:=7 TO 11 DO Line2D(P[12],P[i]);
  FOR i:=2 TO 6  DO BEGIN
   Line2D(P[i],  P[(i-1)mod 5+2]);
   Line2D(P[i+5],P[(i-1)mod 5+7]);
   Line2D(P[i],  P[i+5]);
   Line2D(P[i],  P[(i-1)mod 5+7]);
  END;
END;
{---------------------------------------------------------------}
PROCEDURE Help;
BEGIN
  writeln(['Copyright (C) 2009. Dumitru Uzun (DUzun)'#10]);
  Writeln(['Deplasare:       <Sus>, <Jos>, <Dreapta>, <Stanga>, <+>, <->']);
  Writeln(['Deplasare:       <8>, <2>, <6>, <4>, <5>, <0>']);
  Writeln(['Directie rotire: <X>, <Y>, <Z>']);
  Writeln(['Viteza rotire:   <,>, <.>, <Spatiu>']);
  Writeln(['Tip proiectie:   <C>entrala, <P>aralela']);
  Writeln(['Iesire:          <Esc>']);
  readkey;
END;
{---------------------------------------------------------------}
FUNCTION Taste(Key: Char): Char;
BEGIN
    Key := UpCase(Key);
    case Key of
    'X'..'Z': {'X': ax := 1; 'Y': ax := 2; 'Z': ax := 3;}
       BEGIN
          ax := ord(UpCase(Key))-ord('X')+1;
          if (alfa = 0) then inc(alfa);
       END;
    'P': pr := prParalel;
    'C': pr := prCentral;
    ',': dec(alfa);
    '.': inc(alfa);
    ' ': alfa := 0;
    '8': R[0][2] := R[0][2]+Unu;  {Up}
    '2': R[0][2] := R[0][2]-Unu;  {Down}
    '6': R[0][1] := R[0][1]+Unu;  {Right}
    '4': R[0][1] := R[0][1]-Unu;  {Left}
    '5': R[2][2] := R[2][2]+Unu;
    '0': R[2][2] := R[2][2]-Unu;

    '-': R[0][3] := R[0][3]+Unu*5;  {-}
    '+': R[0][3] := R[0][3]-Unu*5;  {+}

    #27: Halt(0);
    END;
    Taste := Key;
END;
{---------------------------------------------------------------}
PROCEDURE InitFiguri;
BEGIN
   GD := Detect;
   InitGraph(GD, GM, '');
   IF (GraphResult <> 0) THEN
   BEGIN
      Writeln(['Erroare initializare modul grafic!']);
      ReadKey;
      Halt(1);
   END;

   {Setari ale modului grafic}
   SetBkColor(BLACK);
   SetColor(YELLOW);
   ClearViewPort;

   pr   := prCentral;
   alfa := 3;
   ax   := Ax_Y;   {Axa Oy}
   DrowFig := Icosaedru;

   {Pozitionarea si orientarea reperului in spatiu}
   R[0][1] :=  0;   R[0][2] :=  0;   R[0][3] :=  0; { O(0, 0, 0) }
   R[1][1] := 10;   R[1][2] :=  0;   R[1][3] :=  0; { e1( 10,  0,   0) }
   R[2][1] :=  0;   R[2][2] := 10;   R[2][3] :=  0; { e2(  0, 10,   0) }
   R[3][1] :=  0;   R[3][2] :=  0;   R[3][3] := 10; { e3(  0,  0,  10) }

   Moves;
END;
{---------------------------------------------------------------}
PROCEDURE Moves;             {Efectuarea transformarilor si desenarea}
BEGIN
  {Mijlocul ecranului}
   MidX := GetMaxX div 2;
   MidY := GetMaxY div 2;
   Depth := (MidX + MidY) div 2;
   RotSis(R, alfa*Grade, ax);
   ClearViewPort;
   DrowFig(R, pr);
END;
{---------------------------------------------------------------}

BEGIN
END.

