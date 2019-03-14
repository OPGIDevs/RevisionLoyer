unit uPrincipale;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,

  Vcl.Grids,

  uRevision,
  Vcl.ComCtrls,
  Data.DB,
  Datasnap.DBClient,
  Vcl.DBGrids, Vcl.Mask, Vcl.DBCtrls;

type
  TfrmPrincipale = class(TForm)
    mmoLog:
      TMemo;
    btnMensualite: TBitBtn;
    Loyer: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    txtDateDu: TDateTimePicker;
    txtDateau: TDateTimePicker;
    txtLoyer: TEdit;
    dsMensualite: TClientDataSet;
    dsMensualiteDateDu: TDateField;
    dsMensualiteDateAu: TDateField;
    dsMensualiteLoyerPrincipal: TFloatField;
    dbgMensualite: TDBGrid;
    dsM: TDataSource;
    dsMensualiteTotal: TAggregateField;
    dbedt: TDBEdit;
    procedure btnCreerClick(Sender: TObject);
    procedure btnMensualiteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }

  end;

var
  frmPrincipale: TfrmPrincipale;

implementation

{$R *.dfm}


procedure TfrmPrincipale.btnCreerClick(Sender: TObject);
var
  Revisions: TListeRevision;
  I        : Integer;
begin
  Revisions := TListeRevision.Create(nil);
  try
    for I := 0 to Revisions.Count - 1 do
      mmoLog.Lines.Add(Revisions[I].StrDateRevision);
  finally
    Revisions.Free;
  end;
end;

procedure TfrmPrincipale.btnMensualiteClick(Sender: TObject);
var
  ListeMensualite: TListeMensualite;
  I              : Integer;
begin
  mmoLog.Lines.Clear;
  ListeMensualite := TListeMensualite.Create(StrToFloat(txtLoyer.Text),
    txtDateDu.Date,
    txtDateau.Date);
  try
    dsMensualite.Active := False;
    dsMensualite.CreateDataSet;
    dsMensualite.Active := True;
    dsMensualite.DisableControls;
    // mmoLog.Lines.BeginUpdate;
    for I := 0 to ListeMensualite.Count - 1 do
    begin
      dsMensualite.Append;
      dsMensualite.Edit;
      dsMensualiteDateDu.AsDateTime := ListeMensualite[I].DateDu;
      dsMensualiteDateAu.AsDateTime := ListeMensualite[I].DateAu;
      dsMensualiteLoyerPrincipal.AsFloat := ListeMensualite[I]
        .LoyerPrincipal;
      dsMensualite.Post;
    end;

    // mmoLog.Lines.Add(ListeMensualite[I].strDateDebut + #9 +
    // ListeMensualite[I].strDateFin + #9 +
    // ListeMensualite[I].strLoyerPrincipal);

    // mmoLog.Lines.EndUpdate;
  finally
    dsMensualite.EnableControls;
    ListeMensualite.Free;
  end;
end;

procedure TfrmPrincipale.FormCreate(Sender: TObject);
begin
  txtDateDu.DateTime := EncodeDate(1995, 11, 1);
  txtDateau.DateTime := EncodeDate(2019, 03, 1);

end;

end.
