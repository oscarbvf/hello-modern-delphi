unit GenericLogger;

interface

uses
  System.SysUtils, System.Generics.Collections, Vcl.Dialogs, System.Rtti, NullableUtils,
  System.Math, System.StrUtils, System.TypInfo;

type
  // Atributos
  LogIgnore = class(TCustomAttribute) end;

  LogName = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(const AName: string);
    property Name: string read FName;
  end;

  LogFormat = class(TCustomAttribute)
  private
    FFormat: string;
  public
    constructor Create(const AFormat: string);
    property FormatStr: string read FFormat;
  end;

  // Logger central
  TGenericLogger = class
  private
    FHandlers: TDictionary<string, TProc<string>>;
    class var FPropsCache: TDictionary<TClass, TArray<TRttiProperty>>;
    class function GetPropertiesForClass(AClass: TClass; ctx: TRttiContext): TArray<TRttiProperty>; static;
  public
    constructor Create;
    destructor Destroy; override;
    function Serialize(AObj: TObject): string; overload;

    procedure AddHandler(const Name: string; const Proc: TProc<string>);
    procedure Log<T: class>(const Obj: T);
  end;

implementation

{ LogName }

constructor LogName.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;

{ LogFormat }

constructor LogFormat.Create(const AFormat: string);
begin
  inherited Create;
  FFormat := AFormat;
end;

{ TGenericLogger }

procedure TGenericLogger.AddHandler(const Name: string;
  const Proc: TProc<string>);
begin
  FHandlers.AddOrSetValue(Name, Proc);
end;

constructor TGenericLogger.Create;
begin
  FHandlers := TDictionary<string, TProc<string>>.Create;
  FPropsCache := TDictionary<TClass, TArray<TRttiProperty>>.Create;
end;

destructor TGenericLogger.Destroy;
begin
  FHandlers.Free;
  FPropsCache.Free;
  inherited;
end;

class function TGenericLogger.GetPropertiesForClass(AClass: TClass; ctx: TRttiContext): TArray<TRttiProperty>;
var
  rtype: TRttiType;
  props: TArray<TRttiProperty>;
begin
  if FPropsCache.TryGetValue(AClass, Result) then
    Exit(Result);

  rtype := ctx.GetType(AClass);
  if not Assigned(rtype) then
    Result := nil
  else
  begin
    props := rtype.GetProperties;
    FPropsCache.Add(AClass, props);
    Result := props;
  end;
end;

function TGenericLogger.Serialize(AObj: TObject): string;
var
  ctx: TRttiContext;
  props: TArray<TRttiProperty>;
  p: TRttiProperty;
  parts: TList<string>;
  attr: TCustomAttribute;
  ignore: Boolean;
  nameForLog: string;
  v: TValue;
  fmt: string;
  propType: TRttiType;
  propType2: TRttiType;
  propMethod: TRttiMethod;
  sVal: string;
  handler: TProc<string>;
  LObject: TObject;
begin
  Result := '';
  if AObj = nil then Exit;

  ctx := TRttiContext.Create;
  parts := TList<string>.Create;
  try
    props := GetPropertiesForClass(AObj.ClassType, ctx);
    for p in props do
    begin
      if not p.IsReadable then Continue;

      // default name
      nameForLog := p.Name;
      ignore := False;
      fmt := '';

      for attr in p.GetAttributes do
      begin
        if attr is LogIgnore then
        begin
          ignore := True;
          Break;
        end
        else if attr is LogName then
          nameForLog := LogName(attr).Name
        else if attr is LogFormat then
          fmt := LogFormat(attr).FormatStr;
      end;

      if ignore then Continue;

      // Check if there's a handler registered for the property type
      propType := p.PropertyType;
      if (propType <> nil) and FHandlers.TryGetValue(propType.Name, handler) then
      begin
        // If user registered a handler for this type (e.g. 'TUser'), call it with the owner object
//        handler(AObj);
        handler(Format('%s=%s', [nameForLog, sVal]));
        Continue; // or append a note — depends on design
      end;

      v := p.GetValue(AObj);

        // handle common kinds
        case v.Kind of
          tkUString, tkLString, tkWString, tkString: sVal := v.ToString;
          tkInteger, tkInt64: sVal := v.ToString;
          tkFloat:
            begin
              // DateTime detection: if RTTI type is TDateTime
              if Assigned(propType) and (propType.Name = 'TDateTime') then
              begin
                if fmt <> '' then
                  sVal := FormatDateTime(fmt, v.AsExtended)
                else
                  sVal := DateTimeToStr(v.AsExtended);
              end
              else
                sVal := v.ToString;
            end;
          tkEnumeration:
            begin
              // booleans and enums
              if v.IsType<Boolean> then
                sVal := IfThen(v.AsBoolean, 'True', 'False')
              else
                sVal := v.ToString;
            end;
          tkClass:
            begin
              if v.IsObject then
              begin
                // If it's an object, try to use its ToString, or recursively serialize
                LObject := v.AsObject;
                if Assigned(LObject) then
                  sVal := LObject.ToString
                else
                  sVal := '<nil>';
              end
              else
                sVal := v.ToString;
            end;
          tkRecord:
            begin
              if v.TypeInfo = TypeInfo(TNullable<TDateTime>) then begin
                var n := v.AsType<TNullable<TDateTime>>;
                if n.HasValue then
                  sVal := DateToStr(n.Value)
                else
                  sVal := '<null>';
              end else begin
                propType2 := ctx.GetType(p.PropertyType.Handle);
                propMethod := propType2.GetMethod('ToString');
                if Assigned(propMethod) then
                  try
                    sVal := propMethod.Invoke(v.GetReferenceToRawData, []).ToString;
                  except
                    sVal := '(record)';
                  end
                else
                  sVal := '(record)';
              end;
            end;
        else
          sVal := v.ToString;
        end;
      //end;

      parts.Add(Format('%s=%s', [nameForLog, sVal]));
    end;

    Result := String.Join('; ', parts.ToArray);
  finally
    parts.Free;
    // ctx is record, nothing to free
  end;
end;

procedure TGenericLogger.Log<T>(const Obj: T);
{
var
  ctx: TRttiContext;
  objType: TRttiType;
  prop: TRttiProperty;
  LogStr, sVal: string;
  Handler: TProc<string>;
  val: TValue;
begin
  ctx := TRttiContext.Create;
  try
    objType := ctx.GetType(TypeInfo(T));
    LogStr := objType.Name + ' {';

    // Cria um TValue a partir do objeto genérico
    val := TValue.From<T>(Obj);

    for prop in objType.GetProperties do
      if prop.IsReadable then
      begin
        try
          sVal := prop.GetValue(val.AsObject).ToString;
        except
          sVal := '<unavailable>';
        end;
        LogStr := LogStr + Format('%s=%s; ', [prop.Name, sVal]);
      end;
}
    // LogStr := LogStr + '}';
{
    // envia o log para todos os handlers registrados
    for Handler in FHandlers.Values do
      Handler(LogStr);

  finally
    ctx.Free;
  end;
}
var
  LogStr: string;
  Handler: TProc<string>;
begin
  LogStr := Serialize(Obj); // seu método já existente

  for Handler in FHandlers.Values do
    Handler(LogStr);
end;

end.

