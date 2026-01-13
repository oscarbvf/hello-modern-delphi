unit NullableUtils;

interface

uses
  System.SysUtils, System.Rtti, System.TypInfo;

{$RTTI EXPLICIT METHODS([vcPublic, vcPublished])}
type
  TNullable<T> = record
  private
    FHasValue: Boolean;
    FValue: T;
  public
    class function Create(const AValue: T): TNullable<T>; static;
    procedure Clear;
    function Has: Boolean;
    function ValueOrDefault(const ADefault: T): T;
    property HasValue: Boolean read FHasValue;
    property Value: T read FValue;
    function ToString: string; inline;
//    function ToString(const AFormat: string = ''): string;

    class operator Implicit(const AValue: T): TNullable<T>;
    class operator Explicit(const AValue: TNullable<T>): T;
  end;

implementation

{ TNullable<T> }

class function TNullable<T>.Create(const AValue: T): TNullable<T>;
begin
  Result.FHasValue := True;
  Result.FValue := AValue;
end;

procedure TNullable<T>.Clear;
begin
  FHasValue := False;
  // FValue fica com valor default (não necessário limpar explicitamente)
  FValue := Default(T);
end;

function TNullable<T>.Has: Boolean;
begin
  Result := FHasValue;
end;

function TNullable<T>.ValueOrDefault(const ADefault: T): T;
begin
  if FHasValue then
    Result := FValue
  else
    Result := ADefault;
end;

{
function TNullable<T>.ToString(const AFormat: string): string;
var
  ctx: TRttiContext;
  rtype: TRttiType;
begin
  if not FHasValue then
    Exit('<null>');

  // tratamento simples para DateTime
  ctx := TRttiContext.Create;
  try
    rtype := ctx.GetType(TypeInfo(T));
    if Assigned(rtype) and (rtype.TypeKind = tkFloat) and (rtype.Name = 'TDateTime') then
    begin
      if AFormat = '' then
        Result := DateTimeToStr(TValue.From<T>(FValue).AsExtended)
      else
        Result := FormatDateTime(AFormat, TValue.From<T>(FValue).AsExtended);
      Exit;
    end;
  finally
    // ctx é record, não precisa Free; mantendo try/finally pra clareza
  end;

  // default
  Result := TValue.From<T>(FValue).ToString;
end;
}

class operator TNullable<T>.Implicit(const AValue: T): TNullable<T>;
begin
  Result.FHasValue := True;
  Result.FValue := AValue;
end;

function TNullable<T>.ToString: string;
begin
  if FHasValue then
    Result := TValue.From<T>(FValue).ToString
  else
    Result := '<null>';
end;

class operator TNullable<T>.Explicit(const AValue: TNullable<T>): T;
begin
  if not AValue.FHasValue then
    raise Exception.Create('Nullable has no value');
  Result := AValue.FValue;
end;

end.

