unit uGenericsUtils;

interface

uses
  System.Generics.Collections, System.SysUtils;

type
  TListUtils = class
  public
    class function FirstOrDefault<T>(const List: TList<T>;
      const Predicate: TFunc<T, Boolean>): T; static;
  end;

implementation

class function TListUtils.FirstOrDefault<T>(const List: TList<T>;
  const Predicate: TFunc<T, Boolean>): T;
var
  Item: T;
begin
  for Item in List do
    if Predicate(Item) then
      Exit(Item);
  Result := Default(T);
end;

end.

