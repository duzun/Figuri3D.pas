Program Figuri_3D;
Uses Graph, CRT, UCalc3D, UCalcVec, UGrafica, UFig;
{---------------------------------------------------------------}
var R1, R2: TReper;
    raza, alfa: integer;
    ax: byte;
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
    #72: R1[0][2] := R1[0][2]+3;  {Up}
    #80: R1[0][2] := R1[0][2]-3;  {Down}
    #77: R1[0][1] := R1[0][1]+3;  {Right}
    #75: R1[0][1] := R1[0][1]-3;  {Left}
    '-': R1[0][3] := R1[0][3]+30;  {-}
    '+': R1[0][3] := R1[0][3]-30;  {+}

    '*': R1[2][2] := R1[2][2]+3;
    '/': R1[2][2] := R1[2][2]-3;
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
raza := (MidX + MidY) div 120; {raza figurii}

{Pozitionarea Reperului R1}
R1[0] := VecZero;
VecParal(R1[1], VecI, 30);
VecParal(R1[2], VecJ, 30);
VecParal(R1[3], VecK, 30);
RotSis(R1, r(30), 1);
R2 := R1;

repeat
  ChgPage;
  RotSis(R1,  r(alfa), ax);
  RotSis(R2, -r(alfa), 3-ax);
  SubVec(R2[0], VecZero, R1[0]); {R2[0] := -R1[0]}

  Cub(R1, raza);
  Icosaedru(R2, raza);
until Taste = #27; {<ESC>}

Help(false);
Halt(0);
END.