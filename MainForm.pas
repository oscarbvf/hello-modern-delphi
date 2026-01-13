unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Collections, System.Generics.Defaults,
  uGenericsUtils, uLogDemo, NullableUtils, GenericLogger, System.Rtti, System.TypInfo;

type
  TForm1 = class(TForm)
    lblGreeting: TLabel;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Lista: TList<Integer>;
  N: Integer;
begin
  Lista := TList<Integer>.Create;
  try
    Lista.Add(10);
    Lista.Add(3);
    Lista.Add(7);

    Lista.Sort;  // ordena em ordem crescente (usa TComparer<Integer>.Default)

    for N in Lista do
      ShowMessage(IntToStr(N));
  finally
    Lista.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Dicionario: TDictionary<string, Integer>;
  Chave: string;
  Valor: Integer;
begin
  Dicionario := TDictionary<string, Integer>.Create;
  try
    Dicionario.Add('um', 1);
    Dicionario.Add('dois', 2);
    Dicionario.Add('tres', 3);
    Chave := 'quatro';
    if Dicionario.TryGetValue(Chave, Valor) then
      ShowMessage('Valor encontrado: '+ IntToStr(Valor))
    else
      ShowMessage('Chave não encontrada: '+ Chave);
  finally
    Dicionario.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  L: TList<Integer>;
  R: Integer;
begin
  L := TList<Integer>.Create;
  try
    L.AddRange([1,2,3]);
    R := TListUtils.FirstOrDefault<Integer>(L,
      function(x: Integer): Boolean
      begin
        Result := x > 3;
      end
    );
    ShowMessage(R.ToString);
  finally
    L.Free;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
{
var
  P: TPerson;
  s: string;
begin
  P := TPerson.Create;
  try
    P.Id := 1;
    P.Name := 'Oscar';
    P.Password := 'secret';
    P.Age := 44;
    P.Birth := TNullable<TDateTime>.Create(EncodeDate(1981, 1, 2));

    //s := TGenericLogger.Serialize(P);
    ShowMessage(s);
    // ShowMessage(BuildLogString(P));

    // Saída esperada: "identifier=1; full_name=Oscar; Age=44"
    // Note que Password foi ignorada e os nomes foram sobrescritos pelos LogName
  finally
    P.Free;
  end;
}
var
  Logger: TGenericLogger;
  Person: TPerson;
begin
  Logger := TGenericLogger.Create;
  try
    Logger.AddHandler('console',
      TProc<string>(procedure(const S: string)
      begin
        ShowMessage('[Console] ' + S);
      end));

    Logger.AddHandler('file',
      TProc<string>(procedure(const S: string)
      var F: TextFile;
      begin
        AssignFile(F, 'log.txt');
        if FileExists('log.txt') then
          Append(F)
        else
          Rewrite(F);
        Writeln(F, S);
        CloseFile(F);
      end));

    Person := TPerson.Create;
    Person.Name := 'Oscar';
    Person.Id := 1;
    Logger.Log(Person);

  finally
    Logger.Free;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  v: TValue;
  n: TNullable<TDateTime>;
begin
  n := EncodeDate(1981, 1, 2);
  v := TValue.From<TNullable<TDateTime>>(n);
  ShowMessage('Type: ' + string(v.TypeInfo^.Name));

  try
    ShowMessage('ToString: ' + v.AsType<string>);
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;

end.
