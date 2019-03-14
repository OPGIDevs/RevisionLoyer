program Revisions;

uses
  Vcl.Forms,
  uPrincipale in 'uPrincipale.pas' {frmPrincipale},
  uRevision in 'uRevision.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.Run;
end.
