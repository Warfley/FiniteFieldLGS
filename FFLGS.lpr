program FFLGS;

{$mode objfpc}{$H+}

uses
    {$IFDEF UNIX}{$IFDEF UseCThreads}
    cthreads,
    {$ENDIF}{$ENDIF}
    Interfaces, // this includes the LCL widgetset
    Forms, InputForm, StepSolution, LGSTypes
    { you can add units after this };

{$R *.res}

begin
    RequireDerivedFormResource:=True;
    Application.Initialize;
		Application.CreateForm(TLGSSolver, LGSSolver);
		Application.CreateForm(TStepView, StepView);
    Application.Run;
end.

