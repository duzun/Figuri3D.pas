program Figuri3D;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  Fig3D in 'Fig3D.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
