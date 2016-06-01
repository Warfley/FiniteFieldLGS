unit LGSTypes;

{$mode delphi}

interface

type
  TRow = record
    Leading0: cardinal;
    Colums: array of integer;
  end;

  TLGS = record
    M, N: cardinal;
    Rows: array of TRow;
  end;

  TStep = record
    l: TLGS;
    Note: String;
    class operator Equal(l1, l2: TStep): boolean;
	end;

function isNumeric(str: string): boolean;
implementation

class operator TStep.Equal(l1, l2: TStep): boolean;
var
  y, x: integer;
begin
  Result := (l1.l.M = l2.l.M) and (l1.l.N = l2.l.N);
  if Result then
    for y := 0 to l1.l.M - 1 do
      for x := 0 to l1.l.N - 1 do
        if l1.l.Rows[y].Colums[x] <> l2.l.Rows[y].Colums[x] then
        begin
          Result := False;
          Break;
        end;
end;
function isNumeric(str: string): boolean;
var
  c: char;
begin
  Result := True;
  for c in str do
    if not (c in ['0'..'9', '-']) then
    begin
      Result := False;
      Break;
    end;
end;

end.
