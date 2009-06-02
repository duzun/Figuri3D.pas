{********************************
   Autor: Dumitru Uzun (DUzun)
   Data: 01.06.2009
 ********************************}
Unit Fig3D;
interface
USES  CRT,  Graph, UFig, UCalcVec, UCalc3D;

CONST   Unu = 5;

VAR     GD, GM     : integer;  {Pentru initierea modului grafic}
        MidX, MidY : word;     {Mijlocul ecranului}
        Reper      : TReper;   {Reperul figurii}
        V          : TVector;
        alfa       : Integer;
        ax         : Byte;     {Axa de rotatie}
        Rel        : Boolean;

{---------------------------------------------------------------}
PROCEDURE InitFiguri;                                  {Initializarea valorilor}
PROCEDURE Moves;                                       {Efectuarea transformarilor si desenarea}

PROCEDURE Help;
FUNCTION  Taste(Key: char): Char;
{---------------------------------------------------------------}
implementation
{---------------------------------------------------------------}
PROCEDURE Help;
BEGIN
  writeln(['Copyright (C) 2009. Dumitru Uzun (DUzun)'#10]);
  Writeln(['Deplasare:        <Sus>, <Jos>, <Dreapta>, <Stanga>, <+>, <->']);
  Writeln(['Deplasare:        <8>, <2>, <6>, <4>, <5>, <0>']);
  Writeln(['Directie rotire:  <X>, <Y>, <Z>']);
  Writeln(['Viteza rotire:    <,>, <.>, <Spatiu>']);
  Writeln(['Rotire relativa:  <R>']);
  Writeln(['Schimb figura:    <F>']);
  Writeln(['Iesire:           <Esc>']);
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
    ',': dec(alfa);
    '.': inc(alfa);
    ' ': alfa := 0;
    '8': Reper[0][2] := Reper[0][2]+Unu;  {Up}
    '2': Reper[0][2] := Reper[0][2]-Unu;  {Down}
    '6': Reper[0][1] := Reper[0][1]+Unu;  {Right}
    '4': Reper[0][1] := Reper[0][1]-Unu;  {Left}
    '5': Reper[2][2] := Reper[2][2]+Unu;
    '0': Reper[2][2] := Reper[2][2]-Unu;

    '-': Reper[0][3] := Reper[0][3]+Unu*5;  {-}
    '+': Reper[0][3] := Reper[0][3]-Unu*5;  {+}

    'R': Rel := not Rel;
    'F': inc(ActiveFig);

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

//    Help;

   {Setari ale modului grafic}
   SetBkColor(BLACK);
   SetColor(BROWN);
   SetFillColor(BROWN);
   ClearViewPort;

   alfa := 2;     {Viteza de rotire in grade}
   ax   := Ax_Y;  {axa de rotire: 1 - Ox, 2 - Oy, 3 - Oz}
   Rel  := false; {Rotirea este relativa sau absoluta}
//   Depth := (MidX + MidY) div 2; {Distanta pana la centrul de proiectie}

    {Pozitionarea reperului Reper}
   Reper[0] := VecZero;
   VecParal(Reper[1], VecI, 10);
   VecParal(Reper[2], VecJ, 10);
   VecParal(Reper[3], VecK, 10);
   RotSis(Reper, r(30), Ax_X);

   Moves;
END;
{---------------------------------------------------------------}
PROCEDURE Moves;             {Efectuarea transformarilor si desenarea}
BEGIN
  {Mijlocul ecranului}
   MidX := GetMaxX div 2;
   MidY := GetMaxY div 2;
   RazaFig := (MidX + MidY) div 40;

   if Rel then   RotSisRel(Reper,  r(alfa), ax)   {Rotirea fata de axele de coordonate}
          else   RotSis   (Reper,  r(alfa), ax);  {Rotirea fata relativa, fata de figura}

   ClearViewPort;
   DrowFig(Reper);       {Procedura de desenare a figurei}
   VecParal(V, Reper[1], RazaFig);  AddVec(V, Reper[0], V);  Line2D(Reper[0], V);
   VecParal(V, Reper[2], RazaFig);  AddVec(V, Reper[0], V);  Line2D(Reper[0], V);
   VecParal(V, Reper[3], RazaFig);  AddVec(V, Reper[0], V);  Line2D(Reper[0], V);

END;
{---------------------------------------------------------------}

BEGIN
END.

