unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg, ShellAPI,
  Graph, UFig, Fig3d;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Counter: DWord;

implementation

{$R *.dfm}

function SaveJPG(FileName: String): String;
var i: integer;
    j: TJPEGImage;
begin
   FileName := ChangeFileExt(FileName, ''); {Eliminarea extensiei din FileName}
   i := 0;
   repeat {Cautarea unui nume de fisier inexistent}
     Result := FileName + '_' + IntToStr(i) + '.jpg';
     inc(i);
   until not FileExists(Result);

   try  {Salvarea imaginei}
     j := TJPEGImage.Create;
     j.Assign(Form1.Image1.Picture.Bitmap);
     j.SaveToFile(Result);
     FileName := '';
   finally
     j.Free;
     if FileName <> '' then Result := ''; {Erroare la salvare}
   end;
end;

procedure Author;
begin
  ShellExecute(0, 0, 'http://duzun.teologie.net/_DUzun', 0, 0, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Height := Height + 34;
  Width := Width + 8;
  {Centrarea formei}
  Top  := (Screen.Height - Height) div 3;
  Left := (Screen.Width  - Width ) div 2;
  Counter := 0;
  KeyPreview := true; {Captarea tastelor de catre forma}
  Hint := 'F1 - Ajutor'#10'S  - Save'#10'A  - Autor';

  Image1.Picture.Create;
  with Image1 do InitGr(Picture, Width, Height);
  InitFiguri;
  Graph.SetBkColor(Color);
end;

procedure TForm1.Timer1Timer(Sender: TObject); {Transformarile de coordonate si desenarea figurii}
begin
  Moves;
//  if Counter and 3 = 0 then SaveJPG(Application.ExeName);
  inc(Counter);
end;

procedure TForm1.FormResize(Sender: TObject);
begin with Image1 do SetGrSize(Width, Height); end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var p: PointList;
begin
  case Taste(Key) of {Prelucrarea comenzilor}
  'S': if SaveJPG(Application.ExeName) = '' then ShowMessage('Eroare la salvarea imaginii!!!');
  'A': Author;
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
{F1}     112: Help;
{F2..F6} 113..117: ActiveFig := Key - 113;

{Up}    38: Taste('8');
{Down}  40: Taste('2');
{Right} 39: Taste('6');
{Left}  37: Taste('4');
{Enter} 13: if Shift = [ssAlt] then
            begin
              if WindowState = wsMaximized then WindowState := wsNormal
                                           else WindowState := wsMaximized;
            end;
   end;
end;

end.
