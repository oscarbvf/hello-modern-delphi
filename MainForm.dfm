object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lblGreeting: TLabel
    Left = 72
    Top = 72
    Width = 237
    Height = 32
    Caption = 'Hello, Modern Delphi!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 72
    Top = 120
    Width = 105
    Height = 25
    Caption = 'Cria Lista'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 72
    Top = 151
    Width = 105
    Height = 25
    Caption = 'Cria Hash Table'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 72
    Top = 182
    Width = 145
    Height = 25
    Caption = 'Testa Fun'#231#227'o Lambda'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 72
    Top = 213
    Width = 145
    Height = 25
    Caption = 'Testa Log Atributos'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 223
    Top = 213
    Width = 146
    Height = 25
    Caption = 'Mini Teste de TNullable'
    TabOrder = 4
    OnClick = Button5Click
  end
end
