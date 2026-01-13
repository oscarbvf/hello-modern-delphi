program HelloModernDelphi;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  uGenericsUtils in 'uGenericsUtils.pas',
  uLogDemo in 'uLogDemo.pas',
  NullableUtils in 'NullableUtils.pas',
  GenericLogger in 'GenericLogger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
