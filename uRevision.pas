unit uRevision;

interface

uses
  Classes,
  SysUtils,
  Contnrs,
  DateUtils;

type
  TRevision = class
  private
    FDateRevision: TDate;
    FTauxRevision: Real;
    function GetStrDate: string;
  public
    constructor Create(aDateRevision: TDate; aTauxRevision: Real);
    property DateRevision: TDate Read FDateRevision write FDateRevision;
    property TauxRevision: Real Read FTauxRevision write FTauxRevision;
    property StrDateRevision: string read GetStrDate;
  end;

  TMensualite = class
  private
    FDateDu        : TDate;
    FDateAu        : TDate;
    FLoyerPrincipal: Real;
    function GetDateDebut: string;
    function GetDateFin: string;
    function GetLoyerPrincipal: string;
  public
    constructor Create(aDateDu: TDate; aDateAu: TDate;
      aLoyerPrincipale: Real);
    property DateDu: TDate read FDateDu write FDateDu;
    property DateAu: TDate read FDateAu write FDateAu;
    property LoyerPrincipal: Real read FLoyerPrincipal write FLoyerPrincipal;

    property strLoyerPrincipal: string read GetLoyerPrincipal;
    property strDateDebut: string read GetDateDebut;
    property strDateFin: string read GetDateFin;

  end;

  TListeRevision = class(TObjectList)
  private
    function GetItem(Index: Integer): TRevision;
    procedure SetItem(Index: Integer; const Value: TRevision);
  public
    constructor Create(AOwner: TComponent);
    function Add(AObject: TRevision): Integer;
    procedure Insert(Index: Integer; AObject: TRevision);
    property Items[Index: Integer]: TRevision read GetItem
      write SetItem; default;
    procedure CreerPeriodeRevisions;
    function GetLoyer(aDatePeriode: TDate;
      aDateReference: TDate;
      aLoyerReference: Real): Real;
  end;

  TListeMensualite = class(TObjectList)
  private
    FListeRevision: TListeRevision;
    FLoyerActuel  : Real;
    FDateDebut    : TDate;
    FDateFin      : TDate;

    function GetItem(Index: Integer): TMensualite;
    procedure SetItem(Index: Integer; const Value: TMensualite);
  public

    constructor Create(); overload;
    constructor Create(aLoyerActuel: Real;
      aDateDebut: TDate;
      aDateFin: TDate); overload;
    destructor Destroy;
    function Add(AObject: TMensualite): Integer;
    procedure Insert(Index: Integer; AObject: TMensualite);
    property Items[Index: Integer]: TMensualite read GetItem
      write SetItem; default;
    property LoyerActuel: Real read FLoyerActuel write FLoyerActuel;
    property DateDebut: TDate read FDateDebut write FDateDebut;
    property DateFin: TDate read FDateFin write FDateFin;

    function Calculer: TListeMensualite;
  end;

implementation

{ TRevision }

constructor TRevision.Create(aDateRevision: TDate; aTauxRevision: Real);
begin
  FDateRevision := aDateRevision;
  FTauxRevision := aTauxRevision;
end;

function TRevision.GetStrDate: string;
begin
  Result := FormatDateTime('dd/MM/yyyy', DateRevision);
end;

{ TListeRevision }

constructor TListeRevision.Create(AOwner: TComponent);
begin
  CreerPeriodeRevisions;
end;

procedure TListeRevision.CreerPeriodeRevisions;
begin
  // Borne Inférieure
  Self.Add(TRevision.Create(EncodeDate(1962, 7, 5), 0));

   Self.Add(TRevision.Create(EncodeDate(1995, 4, 1), 10));
   Self.Add(TRevision.Create(EncodeDate(1995, 12, 1), 10));
   Self.Add(TRevision.Create(EncodeDate(1996, 6, 1), 10));
   Self.Add(TRevision.Create(EncodeDate(1997, 3, 1), 20));
   Self.Add(TRevision.Create(EncodeDate(1997, 11, 1), 15));
   Self.Add(TRevision.Create(EncodeDate(1998, 8, 1), 20));



  // Borne Supérieure jusqu'à ce jour
  Self.Add(TRevision.Create(Date, 0));
end;

function TListeRevision.GetLoyer(aDatePeriode, aDateReference: TDate;
  aLoyerReference: Real): Real;
var
  DerniereDate: TDate;
  I           : Integer;
begin
  for I := Self.Count - 1 downto 1 do
  begin
    aLoyerReference := aLoyerReference * (1 - (Self[I].TauxRevision / 100));
    Result := aLoyerReference;

    if DateInRange(aDatePeriode, Self[I - 1].FDateRevision,
      Self[I].FDateRevision) then
      Break;
  end;
end;

function TListeRevision.GetItem(Index: Integer): TRevision;
begin
  Result := TRevision(inherited GetItem(index));
end;

function TListeRevision.Add(AObject: TRevision): Integer;
begin
  Result := inherited Add(AObject);
end;

procedure TListeRevision.Insert(Index: Integer; AObject: TRevision);
begin
  inherited Insert(index, AObject);
end;

procedure TListeRevision.SetItem(Index: Integer; const Value: TRevision);
begin
  inherited SetItem(index, Value);
end;

{ TMensualite }

constructor TMensualite.Create(aDateDu, aDateAu: TDate;
  aLoyerPrincipale: Real);
begin
  FDateDu := StartOfTheMonth(aDateDu);
  FDateAu := EndOfTheMonth(aDateAu);
  FLoyerPrincipal := aLoyerPrincipale;
end;

function TMensualite.GetDateDebut: string;
begin
  Result := FormatDateTime('dd/MM/yyyy', FDateDu);
end;

function TMensualite.GetDateFin: string;
begin
  Result := FormatDateTime('dd/MM/yyyy', FDateAu);
end;

function TMensualite.GetLoyerPrincipal: string;
begin
  Result := FormatFloat('#,##0.00', FLoyerPrincipal);
end;

{ TListeMensualite }

function TListeMensualite.Add(AObject: TMensualite): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListeMensualite.Calculer: TListeMensualite;
var
  NbrMois        : Integer;
  I              : Integer;
  Mensualite     : TMensualite;
  DateMensualite : TDate;
  LoyerMensualite: Real;
begin
  DateMensualite := DateFin;
  NbrMois := MonthsBetween(DateFin, DateDebut) + 1;
  for I := 0 to NbrMois do
  begin

    LoyerMensualite := FListeRevision.GetLoyer(IncMonth(DateDebut, I),
      DateMensualite,
      LoyerActuel);

    Mensualite := TMensualite.Create(IncMonth(DateDebut, I),
      IncMonth(DateDebut, I), LoyerMensualite);
    Self.Add(Mensualite);

  end;
  Result := Self;
end;

constructor TListeMensualite.Create;
begin
  FListeRevision := TListeRevision.Create(nil);
end;

constructor TListeMensualite.Create(aLoyerActuel: Real;
  aDateDebut: TDate;
  aDateFin: TDate);
begin
  FListeRevision := TListeRevision.Create(nil);
  FLoyerActuel := aLoyerActuel;
  FDateDebut := aDateDebut;
  FDateFin := aDateFin;
  Calculer;
end;

destructor TListeMensualite.Destroy;
begin
  FListeRevision.Free;
end;

function TListeMensualite.GetItem(Index: Integer): TMensualite;
begin
  Result := TMensualite(inherited GetItem(Index));
end;

procedure TListeMensualite.Insert(Index: Integer; AObject: TMensualite);
begin
  inherited Insert(Index, AObject);
end;

procedure TListeMensualite.SetItem(Index: Integer; const Value: TMensualite);
begin
  inherited SetItem(Index, Value);
end;

end.
