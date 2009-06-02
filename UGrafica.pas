{$N+}
unit UGrafica;

interface
Uses Graph, CRT, UCalc3D, UCalcVec, UPoligon;
{---------------------------------------------------------------}
{---------------------------------------------------------------}
var MidX, MidY: word; {Mijlocul ecranului}
{---------------------------------------------------------------}
function InitGr: boolean;
function ChgPage: byte; {Schimba pagina activa cu cea vizuala}
function Line2D(p1, p2: TVec2Real): boolean;
procedure FillPoly2D(Poli: TPoli);
{---------------------------------------------------------------}
function NumToStr(v: Extended; prec: byte): string;
{---------------------------------------------------------------}
implementation
var Page: byte;
{---------------------------------------------------------------}
function InitGr: boolean;
var GD, GM: integer;
begin
   GD := Detect;
   InitGraph(GD, GM, '');
   MidX := GetMaxX div 2;
   MidY := GetMaxY div 2;
   InitGr := GraphResult = 0;
end;
{---------------------------------------------------------------}
function ChgPage: byte;
begin
  SetActivePage(Page mod 2);        {Pagina pe care se deseneaza}
  if(Page=255)then Page := 0 else
  inc(Page);                        {Page = 0 sau 1}
  SetVisualPage(Page mod 2, true);        {Pagina care se afiseaza}
  ClearViewPort;                    {Pagina activa se sterge}
  ChgPage := Page;
end;
{---------------------------------------------------------------}
function Line2d(p1, p2: TVec2Real): boolean;
var i1,i2: TVec2Int;
begin
   {??? punctele pot iesi in afara limitelor ecranului}
   i1[1] := round(p1[1]);
   i2[1] := round(p2[1]);
   i1[2] := round(p1[2]);
   i2[2] := round(p2[2]);
   Line(MidX + i1[1], MidY - i1[2], MidX + i2[1], MidY - i2[2])
end;
{---------------------------------------------------------------}
procedure FillPoly2D(Poli: TPoli);
var Tab: PPointList;
    i: word;
begin
  GetMem( Tab, Poli.n*SizeOf(PointType) );
  if Tab = nil then exit;
  with Poli do for i := 0 to n-1 do begin
    Tab^[i].x := MidX + round(P^[i]^[1]);
    Tab^[i].y := MidY - round(P^[i]^[2]);
  end;
  FillPoly(Poli.n, Tab^);
  FreeMem( Tab, Poli.n*SizeOf(PointType) )
end;
{---------------------------------------------------------------}
function NumToStr(v: Extended; prec: byte): string;
var s, r: string;
    t: Extended;
begin
   t := Int(abs(v));
   if t <> 0 then begin
     s := '';
     repeat
       s := Chr(Trunc(t) mod 10 + Ord('0')) + s ;
       t := Int(t/10);
     until t = 0;
     if v < 0 then s := '-' +  s;
   end else s := '0';


   t := Frac(abs(v));
   if (prec <> 0)and(t <> 0) then begin
     s := s + '.';
     repeat
       t := t * 10;
       s := s + Chr(Trunc(t)+Ord('0'));
       t := Frac(t);
       dec(prec);
     until (prec = 0)or(t = 0);
   end;
   NumToStr := s;
end;
{---------------------------------------------------------------}
end.
