Program Figuri_3D;
Uses Graph, CRT, UCalc3D, UCalcVec, UGrafica, UFig;
{---------------------------------------------------------------}
var Reper: TReper;
    Pl: TPlan;
    alfa: integer;
    ax: byte;
    Rel: boolean;
{---------------------------------------------------------------}
function Taste: char;
var k: char;
begin
  if keypressed then begin
    k := readkey;
    case UpCase(k) of
    'X'..'Z': {'X': ax := 1; 'Y': ax := 2; 'Z': ax := 3;}
       begin
          ax := ord(UpCase(k))-ord('X')+1;
          if (alfa = 0) then inc(alfa);
       end;
    ',': dec(alfa);
    '.': inc(alfa);
    ' ': alfa := 0;
    #72: Reper[0][2] := Reper[0][2]+3;  {Up}
    #80: Reper[0][2] := Reper[0][2]-3;  {Down}
    #77: Reper[0][1] := Reper[0][1]+3;  {Right}
    #75: Reper[0][1] := Reper[0][1]-3;  {Left}
    '-': Reper[0][3] := Reper[0][3]+30;  {-}
    '+': Reper[0][3] := Reper[0][3]-30;  {+}

    '*': Reper[2][2] := Reper[2][2]+3;
    '/': Reper[2][2] := Reper[2][2]-3;
    'R': Rel := not Rel;
    'F': inc(Figures.Active);
    end;
    Taste := k;
  end else Taste := #0;
end;
{---------------------------------------------------------------}
procedure Help(wait: boolean);
begin
  CloseGraph;
  ClrScr;
  writeln(#10'Copyright (C) 2008. Dumitru Uzun'#10);
  Writeln('Deplasare:       <Sus>, <Jos>, <Dreapta>, <Stanga>, <+>, <->');
  Writeln('Directie rotire: <X>, <Y>, <Z>');
  Writeln('Viteza rotire:   <,> sau <.>');
  Writeln('Iesire:          <Esc>');
  if wait then begin
    Writeln(#10'Apasa orice tasta pentru a continua!');
    readkey;
  end;
end;
{---------------------------------------------------------------}

BEGIN
Help(true);

if (not InitGr) then begin
   Writeln('Erroare initializare modul grafic!'); readkey; Halt(1);
end;

alfa := 1;     {Viteza de rotire in grade}
ax   := 2;     {axa de rotire: 1 - Ox, 2 - Oy, 3 - Oz}
Rel  := false; {Rotirea este relativa sau absoluta}
RazaFig := (MidX + MidY) div 120; {raza figurii}

{Pozitionarea reperului Reper}
Reper[0] := VecZero;
VecParal(Reper[1], VecI, 30);
VecParal(Reper[2], VecJ, 30);
VecParal(Reper[3], VecK, 30);
//RotSis(Reper, Reper(30), 1);

repeat
  ChgPage;
  if Rel then   RotSisRel(Reper,  r(alfa), ax)   {Rotirea fata de axele de coordonate}
         else   RotSis   (Reper,  r(alfa), ax);  {Rotirea fata relativa, fata de figura}


  with Pl do C := EcPlan(n, Reper[0], Reper[2], Reper[3]);
  with Pl do begin
     OutTextXY(1, 1,                 'A: ' + NumToStr(n[1], 2));
     OutTextXY(1, TextHeight('H'),   'B: ' + NumToStr(n[2], 2));
     OutTextXY(1, 2*TextHeight('H'), 'C: ' + NumToStr(n[3], 2));
     OutTextXY(1, 3*TextHeight('H'), 'D: ' + NumToStr(C, 2));
     OutTextXY(1, 4*TextHeight('H'), 'Cos: ' + NumToStr(CosVec(VecI, n), 2));
  end;

  {Desenarea figurii active}
  DrowFig(Reper);
until Taste = #27; {<ESC>}

Help(false);
Halt(0);
END.