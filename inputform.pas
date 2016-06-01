unit inputform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ExtCtrls, StdCtrls, Math, LGSTypes, StepSolution;

type

  { TLGSSolver }

  TLGSSolver = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
		StepBox: TCheckBox;
    PrimEdit: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
  private
procedure SortDaShit(l: TLGS);
function CalcDaShit(r1, r2: TRow; c, k, j: cardinal; out s: String): TRow;
procedure DoGauss(var l: TLGS; c: cardinal);
procedure insert(l: TLGS);
    { private declarations }
  public
    { public declarations }
  end;

var
  LGSSolver: TLGSSolver;

implementation

{$R *.lfm}

{ TLGSSolver }
procedure TLGSSolver.insert(l: TLGS);
var
		y, x: Integer;
begin

  StringGrid1.RowCount := l.M;
  StringGrid1.ColCount := l.N;
  for y := 0 to l.M - 1 do
    for x := 0 to l.N - 1 do
      LGSSolver.StringGrid1.Cells[x, y] := IntToStr(l.Rows[y].Colums[x]);
end;

function ModDaShit(i, c: integer): integer;
begin
  if i >= 0 then
    Result := i mod c
  else
  begin
    Result := i;
    while Result < 0 do
      Inc(Result, c);
  end;
end;

procedure TLGSSolver.SortDaShit(l: TLGS);

  procedure swapRows(var a, b: TRow);
  var
    tmp: TRow;
  begin
    tmp := a;
    a := b;
    b := tmp;
  end;

  procedure QuickSort(var dummy: array of TRow; erstes, letztes: integer);
  var
    vonLinks, vonRechts, mitte: integer;
    vergleichsElement: TRow;
  begin
    if erstes < letztes then {mind. 2 Elemente}
    begin {Zerlegung vorbereiten}
      mitte := (erstes + letztes) div 2;
      vergleichsElement := dummy[mitte];
      vonLinks := erstes;
      vonRechts := letztes;
      while vonLinks <= vonRechts do {noch nicht fertig zerlegt?}
      begin
        while dummy[vonLinks].Leading0 < vergleichsElement.Leading0 do
          {linkes Element suchen}
          vonLinks := vonLinks + 1;
        while dummy[vonRechts].Leading0 > vergleichsElement.Leading0 do
          {rechtes Element suchen}
          vonRechts := vonRechts - 1;
        if vonLinks <= vonRechts then
        begin
          swapRows(Dummy[vonLinks], dummy[vonRechts]); {Elemente tauschen}
          vonLinks := vonLinks + 1;
          vonRechts := vonRechts - 1;
        end;
      end;
      Quicksort(dummy, erstes, vonRechts); {li. und re. Teilfeld zerlegen}
      Quicksort(dummy, vonLinks, letztes);
    end;
  end;

begin
  QuickSort(l.Rows, low(l.Rows), High(l.Rows));
end;

function TLGSSolver.CalcDaShit(r1, r2: TRow; c, k, j: cardinal; out s: String): TRow;
var
  f1, f2, i: integer;
begin
  if r1.Leading0 = Length(r1.Colums) then
    exit;
  f1 := r1.Colums[r1.Leading0];
  f2 := r2.Colums[r2.Leading0];
  if (f1 = c) or (f2 = c) then
    exit;
  SetLength(Result.Colums, Length(r1.Colums));
  Result.Leading0 := r1.Leading0 + 1;
  for i := 0 to Length(r1.Colums) - 1 do
    Result.Colums[i] := ModDaShit((r1.Colums[i] * f2 - r2.Colums[i] * f1), c);
        if StepBox.Checked then
          s:=Format('Reihe %d wird zu Reihe %d * %d - Reihe %d * %d', [j, k, f2, j, f1]);
end;

procedure TLGSSolver.DoGauss(var l: TLGS; c: cardinal);
var
  i, j: integer;
  s: String;
begin
  SortDaShit(l);
  for i := 0 to l.M - 1 do
  begin
    for j := i + 1 to l.M - 1 do
      if l.Rows[i].Leading0 = l.Rows[j].Leading0 then
      begin
        l.Rows[j] := CalcDaShit(l.Rows[i], l.Rows[j], c, i, j, s);
        if StepBox.Checked then
          StepView.AddStep(l, s);
      end
      else
        break;
    SortDaShit(l);
        if StepBox.Checked then
          StepView.AddStep(l, 'Umsortiert');
  end;
end;

procedure TLGSSolver.Button1Click(Sender: TObject);
begin
  StringGrid1.RowCount := StringGrid1.RowCount + 1;
end;

procedure TLGSSolver.Button2Click(Sender: TObject);
begin
  StringGrid1.ColCount := StringGrid1.ColCount + 1;
end;

procedure TLGSSolver.Button3Click(Sender: TObject);
begin
  StringGrid1.ColCount := max(StringGrid1.ColCount - 1, 0);
end;

procedure TLGSSolver.Button4Click(Sender: TObject);
var
  l: TLGS;
  x, y: integer;
  nonz: boolean;
begin
  StepView.ClearSteps;
  StepView.OnInsert:=@insert;
  for x := 0 to StringGrid1.ColCount - 1 do
    for y := 0 to StringGrid1.RowCount - 1 do
      if not isNumeric(StringGrid1.Cells[x, y]) then
        Exit
      else if StringGrid1.Cells[x, y] = '' then
        StringGrid1.Cells[x, y] := '0'
      else
        StringGrid1.Cells[x, y] :=
          IntToStr(ModDaShit(StrToInt(StringGrid1.Cells[x, y]),
          StrToInt(PrimEdit.Text)));
  l.M := StringGrid1.RowCount;
  l.N := StringGrid1.ColCount;
  SetLength(l.Rows, l.M);
  for y := 0 to StringGrid1.RowCount - 1 do
  begin
    SetLength(l.Rows[y].Colums, l.N);
    nonz := False;
    l.Rows[y].Leading0 := 0;
    for x := 0 to StringGrid1.ColCount - 1 do
    begin
      l.Rows[y].Colums[x] := StrToInt(StringGrid1.Cells[x, y]);
      if not nonz and (l.Rows[y].Colums[x] = 0) then
        Inc(l.Rows[y].Leading0)
      else
        nonz := True;
    end;
  end;
  StepView.AddStep(l, 'Initialmatrix');
  DoGauss(l, StrToInt(PrimEdit.Text));
  for y := 0 to l.M - 1 do
    for x := 0 to l.N - 1 do
      StringGrid1.Cells[x, y] := IntToStr(l.Rows[y].Colums[x]);

        if StepBox.Checked then
        begin
          StepView.ShowStep(0);
        StepView.ShowModal;
				end;

end;

procedure TLGSSolver.Button5Click(Sender: TObject);
begin
  StringGrid1.RowCount := max(StringGrid1.RowCount - 1, 0);
end;

procedure TLGSSolver.StringGrid1DrawCell(Sender: TObject; aCol, aRow: integer;
  aRect: TRect; aState: TGridDrawState);
begin
  with StringGrid1.Canvas do
  begin
    Brush.Style := bsSolid;
    if not isNumeric(StringGrid1.Cells[aCol, aRow]) then
      Brush.Color := clRed
    else
    begin
      if aRow mod 2 = 0 then
        Brush.Color := clWhite
      else
        Brush.Color := $00DEDEDE;
    end;
    Rectangle(aRect);
    Brush.Style := bsClear;
    Font.Color := clBlack;
    TextOut(aRect.Left + ((aRect.Right - aRect.Left) div 2) -
      (TextWidth(StringGrid1.Cells[aCol, aRow]) div 2), aRect.Top +
      ((aRect.Bottom - aRect.Top) div 2) -
      (TextHeight(StringGrid1.Cells[aCol, aRow]) div 2),
      StringGrid1.Cells[aCol, aRow]);
  end;
end;

end.
