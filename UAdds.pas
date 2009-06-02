unit UAdds;

interface
uses UCalcVec, UCalc3D, UGrafica;
{---------------------------------------------------------------}
type
     TPunct    = packed array[1..3] of Integer;
{---------------------------------------------------------------}
procedure Cub2D(Sis: TReper; raz: integer);
{---------------------------------------------------------------}
implementation
{---------------------------------------------------------------}
{---------------------------------------------------------------}
procedure Cub2D(Sis: TReper; raz: integer);
var P :array[0..7] of TVector;
    P2:array[0..7] of TVec2Real;
    Im: TImReper;
    i : integer;
begin
  {Atribuirea coordonatelor punctelor figurii}
  for i:=0 to 7 do begin
     if i and 1 <> 0 then p[i][1] := raz else p[i][1] := -raz;
     if i and 2 <> 0 then p[i][2] := raz else p[i][2] := -raz;
     if i and 4 <> 0 then p[i][3] := raz else p[i][3] := -raz;
  end;

  {Calcularea coordonatelor plane}
  ProiecReper(Sis, Im);
  for i:=0 to 7 do CoordAbsol2D(P[i], Im, P2[i]);

  {Desenarea segmentelor figurii}
  for i:=0 to 3 do begin
    Line2D(P2[i],   P2[i+4]);
    Line2D(P2[2*i], P2[2*i+1]);
    Line2D(P2[i+i and 2+2], P2[i+i and 2]);
  end;
end;
{---------------------------------------------------------------}
end.