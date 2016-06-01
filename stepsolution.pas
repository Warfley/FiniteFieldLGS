unit StepSolution;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, LGSTypes, fgl;

type

  { TStepView }

  TStepList = specialize TFPGList<TStep>;
  TInsertEvent = procedure (l: TLGS) of object;
  TStepView = class(TForm)
			Button1: TButton;
			Button4: TButton;
			Button5: TButton;
    Panel1: TPanel;
		Panel2: TPanel;
    StringGrid1: TStringGrid;
		procedure Button1Click(Sender: TObject);
		procedure Button4Click(Sender: TObject);
		procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
		procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
				aRect: TRect; aState: TGridDrawState);
  private
    FInsert: TInsertEvent;
    FSteps: TStepList;
    FCurrent: integer;
    { private declarations }
  public
    procedure AddStep(l: TLGS; note: String);
    procedure ClearSteps;
    procedure ShowStep(i: integer);
    property OnInsert: TInsertEvent read FInsert write FInsert;
    { public declarations }
  end;

var
  StepView: TStepView;

implementation

{$R *.lfm}

procedure TStepView.FormCreate(Sender: TObject);
begin
  FSteps := TStepList.Create;
  FCurrent := 0;
end;

procedure TStepView.Button1Click(Sender: TObject);
begin
    ShowStep(FCurrent-1);
end;

procedure TStepView.Button4Click(Sender: TObject);
var l: TLGS;
begin
  l := FSteps[FCurrent].l;
  FInsert(l);
end;

procedure TStepView.Button5Click(Sender: TObject);
begin
    ShowStep(FCurrent+1);
end;

procedure TStepView.FormDestroy(Sender: TObject);
begin
  FSteps.Free;
end;

procedure TStepView.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
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

procedure TStepView.AddStep(l: TLGS; note: String);
var
  x: integer;
  s: TStep;
begin
  SetLength(l.Rows, l.M);
  for x := 0 to l.M - 1 do
    SetLength(l.Rows[x].Colums, l.N);
  s.l :=l;
  s.Note:=note;
  FSteps.Add(s);
end;

procedure TStepView.ClearSteps;
begin
  FSteps.Clear;
end;

procedure TStepView.ShowStep(i: integer);
var
  l: TLGS;
  x, y: integer;
begin
  FCurrent := i;
  Button1.Enabled:=FCurrent>0;
  Button5.Enabled:=FCurrent<FSteps.Count-1;
  l := FSteps[i].l;
  StringGrid1.RowCount := l.M;
  StringGrid1.ColCount := l.N;
  for y := 0 to l.M - 1 do
    for x := 0 to l.N - 1 do
      StringGrid1.Cells[x, y] := IntToStr(l.Rows[y].Colums[x]);
  Panel2.Caption:=FSteps[i].Note;
end;

end.
