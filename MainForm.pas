unit MainForm;

interface

uses
  Cube, Graph,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg, ShellAPI;

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
  {Centrarea formei}
  Top  := (Screen.Height - Height) div 3;
  Left := (Screen.Width  - Width ) div 2;
  KeyPreview := true; {Captarea tastelor de catre forma}
  Image1.Picture.Create;
  InitGr(Image1.Picture, Width, Height);
  InitFiguri;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   Moves; {Transformarile de coordonate si desenarea figurii}
end;

procedure TForm1.FormResize(Sender: TObject);
begin
   SetGrSize(Width, Height);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Taste(Key) of {Prelucrarea comenzilor}
  'S': if SaveJPG(Application.ExeName) = '' then ShowMessage('Eroare la salvarea imaginii!!!');
  'A': Author;
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
{F1} 112: Help;
{F2} 113: DrowFig := Cub;
{F3} 114: DrowFig := Icosaedru;

{Up}    38: Taste('8');
{Down}  40: Taste('2');
{Right} 39: Taste('6');
{Left}  37: Taste('4');
   end;
end;

end.
