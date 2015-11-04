//====== Copyright 2009 (c) Centric Retail Solutions. All rights reserved =====
// Packet : Form for printing Castorama Report: Global Acomptes
// Customer: Castorama
// Unit   : FDetGlobalAcomptes.PAS : based on FDetGeneralCA (General
//                                   Detailform to print CAstorama rapports)
//------------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetGlobalAcomptes.pas,v 1.7 2009/09/16 15:56:42 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - PRptGlobalAcomptes - CVS revision 1.12
//==============================================================================
// Version    Modified by    Reason
// 1.13		  TCS SM		 R2013.2.Req(31010).CAFR.DocBO_Advance_Payment

//*****************************************************************************
unit FDetGlobalAcomptes;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils,
  SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring        // of header
  CtTxtTitle          = 'Report global down payments';

resourcestring        // of errormessages
  CtTxtStartEndDate   = 'Startdate is after enddate!';
  CtTxtStartFuture    = 'Startdate is in the future!';
  CtTxtEndFuture      = 'Enddate is in the future!';
  CtTxtNoNumber       = 'Please enter a down payment nr';

resourcestring        // for general report labels
  CtTxtNoData         = 'No data found';
  CtTxtNotExist       = 'Unexisting nr down payment';
  CtTxtPrintDate      = 'Printed on %s at %s';
  CtTxtReportDate     = 'Report from %s to %s';
  CtTxtDetail         = 'List of mouvements';
  CtTxtGlobal         = 'List of down payments';
  CtTxtSelected       = 'Selected reporttype: ';
  CtTxtUnpaid         = 'Report of all unpaid down payments';
  CtTxtAll            = 'Report of all down payments';
  CtTxtDownPaymentNr  = 'Report of down payment nr';
  CtTxtNbDownPayments = 'Nb down payments:';
  CtTxtNotFound       = 'Nr down payment does not exist';

resourcestring        // of table header.
  // Global report
  CtTxtDownPayment    = 'Nr down payment';
  CtTxtDocType        = 'Doc. Type';
  CtTxtFirstDeposit   = 'First deposit';
  CtTxtLastDeposit    = 'Last deposit';
  CtTxtExpected       = 'Expected';
  CtTxtReal           = 'Real';
  CtTxtTakeBack       = 'Takeback';
  CtTxtSaldo          = 'Saldo';
  // Detail report
  CtTxtDate           = 'Date';
  CtTxtMouvement      = 'Mouvement';
  CtTxtAmount         = 'Amount';
  CtTxtCashdeskNr     = 'Nr Cashdesk';
  CtTxtOperatorNr     = 'Nr Operator';
  CtTxtTicketNr       = 'Nr Ticket';
  CtTxtExpPayment     = 'Expected payment';
  CtTxtRealPayment    = 'Real payment';
  CtTxtChangePayment  = 'Change payment';
  CtTxtBV             = 'BV';
  CtTxtBC             = 'BC';
  CtTxtLOC            = 'LOC';
  CtTxtSAV            = 'SAV';
  CtTxtZOR            = 'ZOR';
  CtTxtZWR            = 'ZWR';
  CtTxtRE             = 'RE';
  CtTxtZWRE           = 'ZWRE';
  CtTxtCR             = 'CR';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetGlobalAcomptes = class(TFrmDetGeneralCA)
    GbxDownPayments: TGroupBox;
    RdbtnNotPayed: TRadioButton;
    RdbtnAll: TRadioButton;
    RdbtnDownPaymentNr: TRadioButton;
    TxtDownPayment: TEdit;
    ChkbxDetail: TCheckBox;
    procedure TxtDownPaymentKeyPress(Sender: TObject; var Key: Char);
    procedure RbtDateDayClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Procedure ChangeStatusDownPaymentNr(Sender: TObject); virtual;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FlgDetailReport          : boolean;       // Print detail or global report
    NumDownPayments          : integer;       // Number of down payments
    ValExpected              : double;        // Value of expected down payments
    ValReal                  : double;        // Value of real down payments
    ValDebetSaldo            : double;        // Value of debetsaldo
    ValSaldo                 : double;        // Value of saldo
  protected
    // Formats of the rapport

    function GetFmtTableHeader       : string; override;
    function GetFmtTableBody         : string; override;
    function GetTxtTableTitle        : string; override;
    function GetTxtTitRapport        : string; override;
    function GetTxtRefRapport        : string; override;
    function BuildSQLStatementGlobal : string; virtual;
    function DetermineDateType       : string; virtual;
    function BuildSQLStatementDetail : string; virtual;
    function DetermineMouvementType  : string; virtual;
    function DetermineDocType        : string; virtual;
    procedure ResetValues; virtual;
    procedure CalculateValues; virtual;
  public
    { Public declarations }
    procedure Execute; override;
    procedure PrintHeader; override;
    procedure PrintTableBodyGlobal; virtual;
    procedure PrintTableBodyDetail; virtual;
    procedure PrintTotalGlobal; virtual;
  end;

var
  FrmDetGlobalAcomptes: TFrmDetGlobalAcomptes;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils, DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetGlobalAcomptes.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.13 $';
  CtTxtSrcDate    = '$Date: 2013/10/25 15:56:42 $';

//******************************************************************************
// Implementation of TFrmDetGlobalAcomptes
//******************************************************************************

function TFrmDetGlobalAcomptes.GetFmtTableHeader: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetGlobalAcomptes.GetFmtTableHeader
  if FlgDetailReport then begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (15)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (10)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (17)]);
    for CntFmt := 0 to 5 do
      Result := Result + TxtSep +
                Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                  FrmVsPreview.ColumnWidthInTwips (10)]);
    for CntFmt := 0 to 1 do
      Result := Result + TxtSep +
                Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                 FrmVsPreview.ColumnWidthInTwips (10)]);
  end
  else begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (15)]);
    Result := Result + Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (10)]);
    for CntFmt := 0 to 6 do begin
    Result := Result + TxtSep + Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (15)]);
    end;
  end;
end;   // of TFrmDetGlobalAcomptes.GetFmtTableHeader

//==============================================================================

function TFrmDetGlobalAcomptes.GetFmtTableBody: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetGlobalAcomptes.GetFmtTableBody
  if FlgDetailReport then begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignLeft,
              FrmVsPreview.ColumnWidthInTwips (15)]);
    Result := Result + TxtSep + Format ('%s%d', [FrmVsPreview.FormatAlignLeft,
              FrmVsPreview.ColumnWidthInTwips (10)]);
    Result := Result + TxtSep + Format ('%s%d', [FrmVsPreview.FormatAlignLeft,
              FrmVsPreview.ColumnWidthInTwips (17)]);
    for CntFmt := 0 to 5 do
      Result := Result +
                TxtSep + Format ('%s%d', [FrmVsPreview.FormatAlignRight,
                FrmVsPreview.ColumnWidthInTwips (10)]);
    for CntFmt := 0 to 1 do
      Result := Result +
                TxtSep + Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                FrmVsPreview.ColumnWidthInTwips (10)]);
  end
  else begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignRight,
              FrmVsPreview.ColumnWidthInTwips (15)]);
    Result := Result + Format ('%s%d', [FrmVsPreview.FormatAlignRight,
              FrmVsPreview.ColumnWidthInTwips (10)]);
    for CntFmt := 0 to 1 do begin
    Result := Result +  TxtSep + Format ('%s%d', [FrmVsPreview.FormatAlignLeft,
              FrmVsPreview.ColumnWidthInTwips (15)]);
    end;
    for CntFmt := 0 to 4 do begin
    Result := Result +  TxtSep + Format ('%s%d', [FrmVsPreview.FormatAlignRight,
              FrmVsPreview.ColumnWidthInTwips (15)]);
    end;
  end;
end;   // of TFrmDetGlobalAcomptes.GetFmtTableBody

//==============================================================================

function TFrmDetGlobalAcomptes.GetTxtTableTitle : string;
begin  // of TFrmDetGlobalAcomptes.GetTxtTableTitle
  if FlgDetailReport then
    Result := CtTxtDate + TxtSep + CtTxtDocType + TxtSep + CtTxtMouvement +
              TxtSep + CtTxtAmount + Txtsep + CtTxtExpected + TxtSep +
              CtTxtReal + TxtSep + CtTxtTakeBack + TxtSep + CtTxtSaldo +
              TxtSep + CtTxtCashdeskNr + TxtSep + CtTxtOperatorNr + TxtSep +
              CtTxtTicketNr
  else
    Result := CtTxtDownPayment + TxtSep + CtTxtDocType + TxtSep +
              CtTxtFirstDeposit + TxtSep + CtTxtLastDeposit + TxtSep +
              CtTxtExpected + TxtSep + CtTxtReal + TxtSep + CtTxtTakeBack +
              TxtSep + CtTxtSaldo;
end;   // of TFrmDetGlobalAcomptes.GetTxtTableTitle)

//==============================================================================

function TFrmDetGlobalAcomptes.GetTxtTitRapport : string;
begin  // of TFrmDetGlobalAcomptes.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetGlobalAcomptes.GetTxtTitRapport

//==============================================================================

function TFrmDetGlobalAcomptes.GetTxtRefRapport : string;
begin  // of TFrmDetGlobalAcomptes.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0008';
end;   // of TFrmDetGlobalAcomptes.GetTxtRefRapport

//=============================================================================

function TFrmDetGlobalAcomptes.BuildSQLStatementGlobal : string;
begin  // of TFrmDetCarteBancaire.BuildSQLStatementGlobal
  Result :=
    #10'SELECT NumAcompte = CAST(G1.IdtCVente AS Char),' +
    #10'CodTypeVente = G1.CodTypeVente, MinDate = Min(G1.MinDate),' +
    #10'MaxDate = Max(G1.MaxDate), Prevu = SUM(G1.Prevu), Reel = SUM(G1.Reel),' +
    #10'Repris = SUM(G1.Repris), Solde = G1.Reel - G1.Repris' +
    #10'FROM (SELECT G2.IdtCVente, G2.CodTypeVente, MinDate = Min(G2.MinDate),' +
    #10'      MaxDate = Max(G2.MaxDate), Prevu = SUM(G2.Prevu),' +
    #10'      Reel = SUM(G2.Reel), Repris = SUM(G2.Repris)' +
    #10'      FROM (SELECT IdtCVente = G3.IdtCVente,' +
    #10'            CodTypeVente = G3.CodTypeVente, MinDate = Min(G3.DatTransBegin),' +
    #10'  	      MaxDate = Max(G3.DatTransBegin), Prevu =SUM(G3.ValAmount),' +
    #10'	      Reel = 0, Repris = 0' +
    #10'            FROM GlobalAcomptes AS G3' +
    #10'            WHERE G3.CodType = 1 ';
                    if not RdbtnDownPaymentNr.Checked then
                      Result := Result + ' AND G3.IdtCVente in (SELECT IdtCVente FROM GlobalAcomptes WHERE ' + DetermineDateType + ')';
                    Result := Result +
    #10'            GROUP BY G3.IdtCVente, G3.CodTypeVente' +
    #10'            UNION' +
    #10'            SELECT IdtCVente = G4.IdtCVente, CodTypeVente = G4.CodTypeVente,' +
    #10'            MinDate = Min(G4.DatTransBegin), MaxDate = Max(G4.DatTransBegin),' +
    #10'	    Prevu = 0, Reel = SUM(G4.ValAmount), Repris = 0' +
    #10'            FROM GlobalAcomptes AS G4' +
    #10'            WHERE G4.CodType IN (2, 3) ';
                    if not RdbtnDownPaymentNr.Checked then
                      Result := Result + ' AND G4.IdtCVente in (SELECT IdtCVente FROM GlobalAcomptes WHERE ' + DetermineDateType + ')';
                    Result := Result +
    #10'            GROUP BY G4.IdtCVente, G4.CodTypeVente' +
    #10'            UNION' +
    #10'            SELECT IdtCVente = G5.IdtCVente, CodTypeVente = G5.CodTypeVente,' +
    #10'	    MinDate = Min(G5.DatTransBegin), MaxDate = Max(G5.DatTransBegin),' +
    #10'            Prevu = 0, Reel = 0, Repris = SUM(G5.ValAmount)' +
    #10'            FROM GlobalAcomptes AS G5' +
    #10'            WHERE G5.CodType = 4 AND G5.ValAmount <> 0 ';                //R2013.2.Req(31010).CAFR.DocBO_Advance_Payment.TCS-SM
                    if not RdbtnDownPaymentNr.Checked then
                      Result := Result + ' AND G5.IdtCVente in (SELECT IdtCVente FROM GlobalAcomptes WHERE ' + DetermineDateType + ')';
                    Result := Result +
    #10'            GROUP BY G5.IdtCVente, G5.CodTypeVente' +
    #10'            ) AS G2' +
    #10'      GROUP BY G2.IdtCVente, G2.CodTypeVente' +
    #10'      ) AS G1';
    if RdbtnDownPaymentNr.Checked then
      Result := Result + #10'WHERE G1.IdtCVente = ' +
        AnsiQuotedStr(TxtDownPayment.Text, '''');
    if RdbtnNotPayed.Checked then begin                                         
      Result := Result + #10'WHERE Reel - Repris <> 0';                                 
    end;                                                                        //R2013.2.Req(31010).CAFR.DocBO_Advance_Payment.TCS-SM
    Result := Result +
    #10'GROUP BY G1.IdtCVente, G1.CodTypeVente, G1.Prevu, G1.Reel, G1.Repris' +
    #10'ORDER BY G1.IdtCVente, G1.CodTypeVente ASC';
end;   // of TFrmDetCarteBancaire.BuildSQLStatementGlobal

//=============================================================================

function TFrmDetGlobalAcomptes.DetermineDateType : string;
begin  // of TFrmDetCarteBancaire.DetermineDateType
  if RbtDateDay.Checked then
    Result :=
      #10'DatTransBegin BETWEEN ' +
           AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''')
    else
      Result :=
      #10'DatTransBegin BETWEEN ' +
           AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
end;   // of TFrmDetCarteBancaire.DetermineDateType

//=============================================================================

function TFrmDetGlobalAcomptes.BuildSQLStatementDetail : string;
begin  // of TFrmDetCarteBancaire.BuildSQLStatementGlobal
  Result :=
      #10'(SELECT DatTransBegin, CodType, CodTypeVente, ' +
      #10'       Montant = SUM(ValAmount), Prevu = SUM(ValAmount), ' +
      #10'       Reel = SUM(0), Repris = SUM(0), Solde = SUM(0), ' +
      #10'       IdtCheckout, IdtOperator, IdtPosTransaction' +
      #10'FROM GlobalAcomptes' +
      #10'WHERE CodType = 1' +
      #10'AND IdtCVente = ' + AnsiQuotedStr(TxtDownPayment.Text, '''') +
      #10'GROUP BY DatTransBegin, CodType, CodTypeVente, IdtCheckout, ' +
      #10'IdtOperator, IdtPosTransaction)' +
      #10'UNION ALL' +
      #10'(SELECT DatTransBegin, CodType, CodTypeVente, ' +
      #10'       Montant = SUM(ValAmount), Prevu = SUM(0), ' +
      #10'       Reel = SUM(ValAmount), Repris = SUM(0), ' +
      #10'       Solde = SUM(ValAmount), ' +
      #10'       IdtCheckout, IdtOperator, IdtPosTransaction' +
      #10'FROM GlobalAcomptes' +
      #10'WHERE CodType IN (2, 3)' +
      #10'AND IdtCVente = ' + AnsiQuotedStr(TxtDownPayment.Text, '''') +
      #10'GROUP BY DatTransBegin, CodType, CodTypeVente, IdtCheckout, ' +
      #10'IdtOperator, IdtPosTransaction)' +
      #10'UNION ALL' +
      #10'(SELECT DatTransBegin, CodType, CodTypeVente, ' +
      #10'       Montant = SUM(ValAmount), Prevu = SUM(0), Reel = SUM(0), ' +
      #10'       Repris = SUM(ValAmount), Solde = SUM(ValAmount), ' +
      #10'       IdtCheckout, IdtOperator, IdtPosTransaction' +
      #10'FROM GlobalAcomptes' +
      #10'WHERE CodType = 4' +
      #10'AND IdtCVente = ' + AnsiQuotedStr(TxtDownPayment.Text, '''') +
      #10'AND ValAmount <> 0' +													//R2013.2.Req(31010).CAFR.DocBO_Advance_Payment.TCS-SM
      #10'GROUP BY DatTransBegin, CodType, CodTypeVente, IdtCheckout, ' +
      #10'IdtOperator, IdtPosTransaction)' +
      #10'ORDER BY DatTransBegin, CodType, CodTypeVente';
end;   // of TFrmDetCarteBancaire.BuildSQLStatementDetail

//==============================================================================

procedure TFrmDetGlobalAcomptes.Execute;
begin  // of TFrmDetGlobalAcomptes.Execute
  ResetValues;

  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;

  if FlgDetailReport then begin
    PrintTableBodyDetail;
  end
  else begin
    PrintTableBodyGlobal;
  end;

  VspPreview.EndDoc;

  PrintPageNumbers;
  PrintReferences;

  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);

  FrmVSPreview.OnActivate(Self);
end;   // of TFrmDetGlobalAcomptes.Execute
//==============================================================================
// TFrmDetGlobalAcomptes.PrintHeader : Print header of report
//==============================================================================

procedure TFrmDetGlobalAcomptes.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetGlobalAcomptes.PrintHeader


  if FlgDetailReport then
    TxtHdr := TxtTitRapport + ': ' + CtTxtDetail + CRLF + CRLF
  else
    TxtHdr := TxtTitRapport + ': ' + CtTxtGlobal + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
            DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF;
  if RdbtnNotPayed.Checked then
    TxtHdr := TxtHdr + CtTxtSelected + ' ' + CtTxtUnpaid
  else if RdbtnAll.Checked then
    TxtHdr := TxtHdr + CtTxtSelected + ' ' + CtTxtAll
  else if RdbtnDownPaymentNr.Checked then
    TxtHdr := TxtHdr + CtTxtSelected + ' ' + CtTxtDownPaymentNr + ' ' +
              TxtDownPayment.Text;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetGlobalAcomptes.PrintHeader

//==============================================================================
// TFrmDetGlobalAcomptes.PrintTableBodyGlobal : Print tablebody of global report
//==============================================================================

procedure TFrmDetGlobalAcomptes.PrintTableBodyGlobal;
var
  TxtPrintLine        : string;           // String to print
begin  // of TFrmDetGlobalAcomptes.PrintTableBodyGlobal
  inherited;
  try
    ResetValues;
    if DmdFpnUtils.QueryInfo (BuildSQLStatementGlobal) then begin
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      while not DmdFpnUtils.QryInfo.Eof do begin
        TxtPrintLine :=
            DmdFpnUtils.QryInfo.FieldByName ('NumAcompte').AsString + TxtSep +
            DetermineDocType + TxtSep +
            FormatDateTime (CtTxtDatFormat,
            DmdFpnUtils.QryInfo.FieldByName ('MinDate').AsDateTime) + ' ' +
            FormatDateTime (CtTxtHouFormat,
            DmdFpnUtils.QryInfo.FieldByName ('MinDate').AsDateTime) + TxtSep +
            FormatDateTime (CtTxtDatFormat,
            DmdFpnUtils.QryInfo.FieldByName ('MaxDate').AsDateTime) + ' ' +
            FormatDateTime (CtTxtHouFormat,
            DmdFpnUtils.QryInfo.FieldByName ('MaxDate').AsDateTime) + TxtSep +
            FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Prevu').AsFloat) + TxtSep +
            FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Reel').AsFloat) + TxtSep +
            FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Repris').AsFloat) + TxtSep +
            FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Solde').AsFloat);
            VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                                 clWhite, False);
          CalculateValues;
          DmdFpnUtils.QryInfo.Next;
      end;
      VspPreview.EndTable;
      PrintTotalGlobal;

    end
    else begin
      VspPreview.CurrentY := VspPreview.CurrentY + 250;
      VspPreview.TableBorder := tbNone;
      VspPreview.StartTable;
      VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                           clWhite, False);
      VspPreview.EndTable;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetGlobalAcomptes.PrintTableBodyGlobal

//==============================================================================
// TFrmDetGlobalAcomptes.PrintTableBodyDetail : Print tablebody of global report
//==============================================================================

procedure TFrmDetGlobalAcomptes.PrintTableBodyDetail;
var
  TxtPrintLine        : string;           // String to print
begin  // of TFrmDetGlobalAcomptes.PrintTableBodyDetail
  inherited;
  try
    if DmdFpnUtils.QueryInfo (BuildSQLStatementDetail) then begin
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      while not DmdFpnUtils.QryInfo.Eof do begin
        TxtPrintLine :=
          FormatDateTime (CtTxtDatFormat,
          DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime) + ' ' +
          FormatDateTime (CtTxtHouFormat,
          DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime) +
          TxtSep + DetermineDocType + TxtSep + DetermineMouvementType + TxtSep +
          FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Montant').AsFloat) + TxtSep +
          FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Prevu').AsFloat) + TxtSep +
          FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Reel').AsFloat) + TxtSep +
          FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Repris').AsFloat) + TxtSep +
          FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Solde').AsFloat) + TxtSep +
          DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsString + TxtSep +
          DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + TxtSep +
          DmdFpnUtils.QryInfo.FieldByName ('IdtPosTransaction').AsString;
          VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                               clWhite, False);
        DmdFpnUtils.QryInfo.Next;
      end;
      VspPreview.EndTable;
    end
    else begin
      VspPreview.CurrentY := VspPreview.CurrentY + 250;
      VspPreview.TableBorder := tbNone;
      VspPreview.StartTable;
      VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                           clWhite, False);
      VspPreview.EndTable;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetGlobalAcomptes.PrintTableBodyDetail

//==============================================================================
// TFrmDetGlobalAcomptes.PrintTotal: Print totals on Global report
//==============================================================================

procedure TFrmDetGlobalAcomptes.PrintTotalGlobal;
var
  TxtTotal      : string;
begin  // of TFrmDetGlobalAcomptes.PrintTotalGlobal
  TxtTotal := CtTxtNbDownPayments + TxtSep + IntToStr(NumDownPayments) +
              TxtSep +  '' + TxtSep +  '' + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValExpected) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValReal) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValDebetSaldo) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValSaldo);
  VspPreview.CurrentY := VspPreview.CurrentY + 250;
  VspPreview.StartTable;
  VspPreview.AddTable (FmtTableBody, '', TxtTotal, clWhite,
                       clWhite, False);
  VspPreview.TableCell[tcFontBold, 1, 1, 1, 8] := True;
  VspPreview.EndTable;
end;   // of TFrmDetGlobalAcomptes.PrintTotalGlobal

//==============================================================================
// TFrmDetGlobalAcomptes.DetermineMouvementType : Determine mouvement type
//==============================================================================

function TFrmDetGlobalAcomptes.DetermineMouvementType: string;
begin  // of TFrmDetGlobalAcomptes.DetermineMouvementType
  Case DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger of
    1: Result := CtTxtExpPayment;
    2: Result := CtTxtRealPayment;
    3: Result := CtTxtChangePayment;
    4: Result := CtTxtTakeBack;
  end;
end;   // of TFrmDetGlobalAcomptes.DetermineMouvementType

//==============================================================================
// TFrmDetGlobalAcomptes.DetermineDocType : Determine document type
//==============================================================================

function TFrmDetGlobalAcomptes.DetermineDocType: string;
begin  // of TFrmDetGlobalAcomptes.DetermineDocType
  Case DmdFpnUtils.QryInfo.FieldByName ('CodTypeVente').AsInteger of
    1: Result := CtTxtBV;
    2: Result := CtTxtBC;
    3: Result := CtTxtLOC;
    4: Result := CtTxtSAV;
    10: Result := CtTxtZOR;
    11: Result := CtTxtZWR;
    12: Result := CtTxtRE;
    13: Result := CtTxtZWRE;
    14: Result := CtTxtCR;
  end;
end;   // of TFrmDetGlobalAcomptes.DetermineDocType

//==============================================================================
// TFrmDetGlobalAcomptes.ResetValues : Clear all total values
//==============================================================================

procedure TFrmDetGlobalAcomptes.ResetValues;
begin  // of TFrmDetGlobalAcomptes.ResetValues
  NumDownPayments := 0;
  ValExpected     := 0;
  ValReal         := 0;
  ValDebetSaldo   := 0;
  ValSaldo        := 0;
end;   // of TFrmDetGlobalAcomptes.ResetValues

//==============================================================================
// TFrmDetGlobalAcomptes.CalculateValues : Calculate all total values
//==============================================================================

procedure TFrmDetGlobalAcomptes.CalculateValues;
begin  // of TFrmDetGlobalAcomptes.CalculateValues
  NumDownPayments := NumDownPayments + 1;
  ValExpected     := ValExpected + StrToFloat(
                     DmdFpnUtils.QryInfo.FieldByName ('Prevu').AsString);
  ValReal         := ValReal + StrToFloat(
                     DmdFpnUtils.QryInfo.FieldByName ('Reel').AsString);
  ValDebetSaldo   := ValDebetSaldo + StrToFloat(
                     DmdFpnUtils.QryInfo.FieldByName ('Repris').AsString);
  ValSaldo        := ValSaldo + StrToFloat(
                     DmdFpnUtils.QryInfo.FieldByName ('Solde').AsString);
end;   // of TFrmDetGlobalAcomptes.CalculateValues

//=============================================================================

procedure TFrmDetGlobalAcomptes.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetGlobalAcomptes.BtnPrintClick
  if RdbtnNotPayed.Checked then    // The date fields must loose their focus
   RdbtnNotPayed.SetFocus;
  if RdbtnAll.Checked then
   RdbtnAll.SetFocus;
  if RdbtnDownPaymentNr.Checked then
    RdbtnDownPaymentNr.SetFocus;
  if RdbtnDownPaymentNr.Checked and ChkbxDetail.Checked then
    FlgDetailReport := True
  else
    FlgDetailReport := False;

  if (not ItemsSelected) and (not RdbtnDownPaymentNr.Checked) then begin
      MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
      Exit;
  end;

  if RdbtnDownPaymentNr.Checked and (TxtDownPayment.Text = '') then begin
      MessageDlg (CtTxtNoNumber, mtWarning, [mbOK], 0);
      TxtDownPayment.SetFocus;
      Exit;
  end;

  // Check is DayFrom < DayTo
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
  (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date) then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      DtmPckLoadedFrom.Date := Now;
      DtmPckLoadedTo.Date := Now;
      MessageDlg (CtTxtStartEndDate, mtWarning, [mbOK], 0);
  end
  // Check if DayFrom is in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now) then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      DtmPckLoadedFrom.Date := Now;
      DtmPckLoadedTo.Date := Now;
      MessageDlg (CtTxtStartFuture, mtWarning, [mbOK], 0);
  end
  // Check if DayTo is in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
      DtmPckDayTo.Date := Now;
      DtmPckLoadedTo.Date := Now;
      MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  else begin
     FlgPreview := (Sender = BtnPreview);
     if FlgDetailReport then begin
       if not DmdFpnUtils.QueryInfo (BuildSQLStatementDetail) then begin
         MessageDlg (CtTxtNotExist, mtWarning, [mbOK], 0);
         TxtDownPayment.Text := '';
         DmdFpnUtils.CloseInfo;
         exit;
       end;
     end
     else begin
       if RdbtnDownPaymentNr.Checked  and
         not DmdFpnUtils.QueryInfo (BuildSQLStatementGlobal)
       then begin
         MessageDlg (CtTxtNotExist, mtWarning, [mbOK], 0);
         TxtDownPayment.Text := '';
         DmdFpnUtils.CloseInfo;
         exit;
       end;
     end;
     DmdFpnUtils.CloseInfo;
     Execute;
  end;
end;   // of TFrmDetGlobalAcomptes.BtnPrintClick

//=============================================================================

procedure TFrmDetGlobalAcomptes.FormCreate(Sender: TObject);
begin // of TFrmDetGlobalAcomptes.FormCreate
  inherited;
  DtmPckDayFrom.DateTime := Now;
end;  // of TFrmDetGlobalAcomptes.FormCreate

//=============================================================================

procedure TFrmDetGlobalAcomptes.ChangeStatusDownPaymentNr(Sender: TObject);
begin // of TFrmDetGlobalAcomptes.ChangeStatusDownPaymentNr
  // Enable textbox for number down payment and checkbox for detail report
  if Sender = RdbtnDownPaymentNr then begin
    // Disable date and operator selection
    DtmPckDayFrom.Enabled := False;
    DtmPckDayTo.Enabled := False;
    DtmPckLoadedFrom.Enabled := False;
    DtmPckLoadedTo.Enabled := False;
    TxtDownPayment.Enabled := True;
    TxtDownPayment.SetFocus;
    ChkbxDetail.Enabled := True;
    RbtDateLoaded.Enabled := False;
    RbtDateDay.Enabled := False;
  end
  else if not RbtDateDay.Enabled then begin
    DtmPckDayFrom.Enabled := True;
    DtmPckDayTo.Enabled := True;
    DtmPckLoadedFrom.Enabled := False;
    DtmPckLoadedTo.Enabled := False;
    TxtDownPayment.Enabled := False;
    ChkbxDetail.Enabled := False;
    RbtDateLoaded.Enabled := True;
    RbtDateDay.Enabled := True;
    RbtDateDay.Checked := True;
  end
end; // of TFrmDetGlobalAcomptes.ChangeStatusDownPaymentNr

//=============================================================================

procedure TFrmDetGlobalAcomptes.FormActivate(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
  DtmSetDayFrom    : TDateTime;
begin // of TFrmDetGlobalAcomptes.FormActivate
  inherited;
  DtmSetDayFrom := DtmPckDayFrom.DateTime;
  // Disable ChkLbxOperator and select all available operators
  AutoStart(Self);
  DtmPckDayFrom.DateTime := DtmSetDayFrom;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do
    ChkLbxOperator.Checked [CntIx] := True;
  ChkLbxOperator.Enabled := False;
  BtnSelectAll.Enabled := False;
  BtnDeSelectAll.Enabled := False;
  TxtDownPayment.Text := '';
  DtmPckDayFrom.Enabled := True;
  DtmPckDayTo.Enabled := True;
  DtmPckLoadedFrom.Enabled := False;
  DtmPckLoadedTo.Enabled := False;
  TxtDownPayment.Enabled := False;
  ChkbxDetail.Enabled := False;
  RbtDateLoaded.Enabled := True;
  RbtDateDay.Enabled := True;
  RbtDateDay.Checked := True;
  RdbtnNotPayed.Checked := True;
  RbtDateDay.Checked := True;
  RbtDateDayClick(Self);
end; // of TFrmDetGlobalAcomptes.FormActivate

//=============================================================================

procedure TFrmDetGlobalAcomptes.RbtDateDayClick(Sender: TObject);
begin // of TFrmDetGlobalAcomptes.RbtDateDayClick
  inherited;
  if Sender = RbtDateDay then begin
    DtmPckDayFrom.Enabled := True;
    DtmPckDayTo.Enabled := True;
    DtmPckLoadedFrom.Enabled := False;
    DtmPckLoadedTo.Enabled := False;
    TxtDownPayment.Enabled := False;
    ChkbxDetail.Enabled := False;
    ChkbxDetail.Checked := False;
    TxtDownPayment.Text := '';
  end;
  if Sender = RbtDateLoaded then begin
    // Enable date and operator selection
    DtmPckDayFrom.Enabled := False;
    DtmPckDayTo.Enabled := False;
    DtmPckLoadedFrom.Enabled := True;
    DtmPckLoadedTo.Enabled := True;
    TxtDownPayment.Enabled := False;
    ChkbxDetail.Enabled := False;
    ChkbxDetail.Checked := False;
    TxtDownPayment.Text := '';
  end;
end;  // of TFrmDetGlobalAcomptes.RbtDateDayClick

//=============================================================================

procedure TFrmDetGlobalAcomptes.TxtDownPaymentKeyPress(Sender: TObject;
  var Key: Char);
begin // of TFrmDetGlobalAcomptes.TxtDownPaymentKeyPress
  inherited;
  if Key in [chr(32)..chr(47)] + [chr(58)..chr(255)] then Key := #0
end; // of TFrmDetGlobalAcomptes.TxtDownPaymentKeyPress

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetGlobalAcomptes
