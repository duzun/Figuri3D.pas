object Form1: TForm1
  Left = 191
  Top = 109
  Width = 314
  Height = 311
  Hint = 'F1 - Ajutor'
  Caption = 'Cube 3D'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  ScreenSnap = True
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 306
    Height = 277
    Align = alClient
  end
  object Timer1: TTimer
    Interval = 30
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
end
