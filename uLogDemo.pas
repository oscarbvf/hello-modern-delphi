unit uLogDemo;

interface

uses
  System.SysUtils, GenericLogger, NullableUtils;

type
  LogIgnore = class(TCustomAttribute) end;

  LogName = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(const AName: string);
    property Name: string read FName;
  end;

  {$M+}
  TPerson = class
  private
    FId: Integer;
    FName: string;
    FPassword: string;
    FAge: Integer;
    FBirth: TNullable<TDateTime>;
  published
    [LogName('identifier')]
    property Id: Integer read FId write FId;

    [LogName('full_name')]
    property Name: string read FName write FName;

    [LogIgnore]
    property Password: string read FPassword write FPassword;

    property Age: Integer read FAge write FAge;

    [LogFormat('yyyy-mm-dd')]
    property Birth: TNullable<TDateTime> read FBirth write FBirth;
  end;
  {$M-}

function BuildLogString(AObj: TObject): string;

implementation

uses
  System.Rtti, System.Generics.Collections;

{ LogName }

constructor LogName.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;

function BuildLogString(AObj: TObject): string;
var
  Ctx: TRttiContext;
  RType: TRttiType;
  Prop: TRttiProperty;
  Attr: TCustomAttribute;
  Val: TValue;
  NameForLog: string;
  Parts: TList<string>;
  IgnoreProp: Boolean;
begin
  Result := '';
  if AObj = nil then Exit;

  Parts := TList<string>.Create;
  try
    Ctx := TRttiContext.Create;
    try
      RType := Ctx.GetType(AObj.ClassType);
      for Prop in RType.GetProperties do
      begin
        if not Prop.IsReadable then Continue;

        IgnoreProp := False;
        NameForLog := Prop.Name;

        for Attr in Prop.GetAttributes do
        begin
          if Attr is LogIgnore then
          begin
            IgnoreProp := True;
            Break;
          end
          else if Attr is LogName then
            NameForLog := LogName(Attr).Name;
        end;

        if IgnoreProp then Continue;

        Val := Prop.GetValue(AObj);
        if Val.IsEmpty then
          Parts.Add(Format('%s=<nil>', [NameForLog]))
        else
          Parts.Add(Format('%s=%s', [NameForLog, Val.ToString]));
      end;
    finally
      Ctx.Free;
    end;

    Result := String.Join('; ', Parts.ToArray);
  finally
    Parts.Free;
  end;
end;

end.

