//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Standard Development
// Customer: Castorama
// Unit   : FDetCAAuditCassiere.PAS : based on FDetGeneralCA (General
//                                      Detailform to print CAstorama rapports)
//------------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCAAuditCaissiere.pas,v 1.6 2011/06/26 13:38:17 BEL\nclevers Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetCAAuditCassiere.PAS - CVS revision 1.3
// Version  ModifiedBy    Reason
// 1.6      SRM. (TCS)    R2011.2 - BDES - Operators Audit report
// 1.7      SRM. (TCS)    R2011.2 - BDES - Operators Audit report - Difectfix(80)
// 1.8      SRM. (TCS)    R2011.2 - BDES - Operators Audit report - Difectfix(240)
// 1.9      TK   (TCS)    R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores
//==============================================================================

unit FDetCAAuditCaissiere;

//******************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils,
  SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA, ExtDlgs;

//******************************************************************************
// Global definitions
//******************************************************************************

resourcestring     // of header
  CtTxtTitle       = 'Audit operators';

resourcestring     // of table header.
  CtTxtCaissiere      = 'Operator Nr';
  CtTxtCheckout       = 'CDN';                                                  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
  CtTxtGratuit        = 'Free';
  CtTxtPrixForce      = 'Price correction';
  CtTxtRetour         = 'Return';
  CtTxtRembous        = 'Repayment of the difference';
  CtTxtAnnulationL    = 'Annulation line';
  CtTxtAnnulUL        = 'Annulation prev line';                                 // Operators Audit report SRM R2011.2
  CtTxtAnnulationT    = 'Annulation ticket';
  CtTxtTicketSusp     = 'Wait ticket';
  CtTxtTicketAnnul    = 'Wait and canceled ticket';
  CtTxtOuverture      = 'Opening drawer';
  CtTxtNb             = 'Nr';
  CtTxtMontant        = 'Amount';
  CtTxtOperateur      = 'Operator';
  CtTxtNoData         = 'No Data for this daterange';
  CtTxtPrintDate      = 'Printed on %s at %s';
  CtTxtReportDate     = 'Report from %s to %s';
  CtTxtStartEndDate   = 'Startdate is after enddate!';
  CtTxtStartFuture    = 'Startdate is in the future!';
  CtTxtEndFuture      = 'Enddate is in the future!';
  CtTxtHdrLines       = 'lines';
  CtTxtHdrArt         = 'art'; 

resourcestring     // of footer
  CtTxtTotal       = 'Total: ';
  CtLastLine       = '/VUL=Display Last Line';                                  // Operators Audit report SRM R2011.2
  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.Start
  CtTxtPlace       = 'D:\sycron\transfertbo\excel';
  CtTxtExists      = 'File exists, Overwrite?'    ;
  CtTxtErrorHeader = 'Incorrect Date';
  CtTxtSubTot      = 'SubTotal';
  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.End
//******************************************************************************
// Form-declaration.
//******************************************************************************

type
  TFrmDetCAAuditCaissiere = class(TFrmDetGeneralCA)
    SprCAAuditCaissiere: TStoredProc;
	//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.Start
    BitBtn1: TBitBtn;
    BtnExport: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    procedure BtnExportClick(Sender: TObject);
	//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.End
    procedure FormCreate(Sender: TObject);
 //   procedure FormActivate(Sender: TObject);                                    // Operators Audit report SRM R2011.2
    procedure FormPaint(Sender: TObject);
  //  procedure BtnPrintClick(Sender: TObject);

  private
    // Totals per operator per cashdesk
    QtyGratuit          : integer;          // Nb gratuit
    ValGratuit          : double;           // Montant gratuit
    QtyPrixForce        : integer;          // Nb Prix Force
    ValPrixForce        : double;           // Montant Prix Force
    QtyRetour           : integer;          // Nb Retour
    ValRetour           : double;           // Montant Retour
    QtyRembous          : integer;          // Nb Rembour
    ValRembous          : double;           // Montant Rembousersment de la difference
    QtyAnnulationL      : integer;          // Nb Annulation Ligne
    ValAnnulationL      : double;           // Montant Annulation Ligne
    QtyAnnulationUL     : integer;          // Nb Annulation Ultima Ligne        // Operators Audit report SRM R2011.2
    ValAnnulationUL     : double;           // Montant Annulation Ultima Ligne   // Operators Audit report SRM R2011.2
    QtyAnnulationT      : integer;          // Nb Annulation Transaction
    ValAnnulationT      : double;           // Montant Annulation Transaction
    QtyTicketSusp       : integer;          // Ticket Suspendu
    QtyTicketAnnul      : integer;          // Ticket Annule
    QtyOuverture        : integer;          // Ouverture Tiroir
    NumAnnulationL      : integer;           // Nb Annulation article
    NumAnnulationUL     : integer;          // Nb Annulation Ultima article      // Operators Audit report SRM R2011.2
    //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.Start// Sub Totals per operator
    QtyGratuitSubTot      : integer;
    ValGratuitSubTot      : double;
    QtyPrixForceSubTot    : integer;
    ValPrixForceSubTot    : double;
    QtyRetourSubTot       : integer;
    ValRetourSubTot       : double;
    QtyRembousSubTot      : integer;
    ValRembousSubTot      : double;
    QtyAnnulationLSubTot  : integer;
    ValAnnulationLSubTot  : double;
    QtyAnnulationULSubTot : integer;
    ValAnnulationULSubTot : double;
    QtyAnnulationTSubTot  : integer;
    ValAnnulationTSubTot  : double;
    QtyTicketSuspSubTot   : integer;
    QtyTicketAnnulSubTot  : integer;
    QtyOuvertureSubTot    : integer;
    NumAnnulationLSubTot  : integer;
    NumAnnulationULSubTot : integer;
    //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.End
    // Grand totals
    QtyGratuitTotal     : integer;          // Total Nb gratuit
    ValGratuitTotal     : double;           // Total Montant gratuit
    QtyPrixForceTotal   : integer;          // Total Nb Prix Force
    ValPrixForceTotal   : double;           // Total Montant Prix Force
    QtyRetourTotal      : integer;          // Total Nb Retour
    ValRetourTotal      : double;           // Total Montant Retour
    QtyRembousTotal     : integer;          // Total Nb Rembour
    ValRembousTotal     : double;           // Total Montant Remb. de la diff.
    NumAnnulationLTotal : integer;          // no of articles cancelled in annulation line //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK
    QtyAnnulationLTotal : integer;          // Total Nb Annulation Ligne
    ValAnnulationLTotal : double;           // Total Montant Annulation Ligne
    QtyAnnulationULTotal: integer;          // Total Nb Annulation Ligne        // Operators Audit report SRM R2011.2
    ValAnnulationULTotal: double;           // Total Montant Annulation Ligne   // Operators Audit report SRM R2011.2
    QtyAnnulationTTotal : integer;          // Total Nb Annulation Transaction
    ValAnnulationTTotal : double;           // Total Montant Annul. Trans.
    QtyTicketSuspTotal  : integer;          // Total Ticket Suspendu
    QtyTicketAnnulTotal : integer;          // Total Ticket Annule
    QtyOuvertureTotal   : integer;          // Total Ouverture Tiroir
    FFlagLastLine       : Boolean;          // Modified by TCS(KB), R2011.2

  protected
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;
    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
    procedure CheckAppDependParams (TxtParam : string); override;               // Operators Audit report SRM R2011.2
    procedure BeforeCheckRunParams; override;

  public
    procedure ResetValues; virtual;
    procedure ResetTotalValues; virtual;
    procedure CalculateValues(StrType : string); virtual;
    procedure PrintHeader; override;
    procedure PrintSecondTableHeader; virtual;
    procedure PrintTableBody; override;
    procedure PrintBodyLine(StrOperator, StrCheckout :string); virtual;				//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK
    procedure Execute; override;
    //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.Start
    procedure PrintSubTotal;
    function GetBodyLine(StrOperator, StrCheckout :string) : string;
    //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.ENd

  // Operators Audit report SRM R2011.2 Start
  published
    property FlgLastLine          : Boolean read FFlagLastLine
                                      write FFlagLastLine;
  // Operators Audit report SRM R2011.2 End
  end;
var
  FrmDetCAAuditCaissiere: TFrmDetCAAuditCaissiere;

//******************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils,
  DFpnTradeMatrix;

{$R *.DFM}

//==============================================================================
// Source-identifiers
//==============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCAAuditCaissiere';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCAAuditCaissiere.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.8 $';
  CtTxtSrcDate    = '$Date: 2011/12/06 12:53:45 $';

//******************************************************************************
// Implementation of TFrmDetCAAuditCaissiere
//******************************************************************************

function TFrmDetCAAuditCaissiere.GetFmtTableHeader: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCAAuditCaissiere.GetFmtTableHeader
 if FlgLastLine = false then begin                                              // Operators Audit report SRM R2011.2
   Result := '^+' + IntToStr (CalcWidthText (13, False));
   Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (4, False));      //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
   for CntFmt := 0 to 5 do begin
     if CntFmt = 4 then
       Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (20, False))
     else
       Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False) );
   end;
   for CntFmt := 0 to 2 do
     Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (8, False));
 end
   // Operators Audit report SRM R2011.2 Start                                                                            // Operators Audit report SRM R2011.2
 else if FlgLastLine = true then begin
   Result := '^+' + IntToStr (CalcWidthText (11, False));
   Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (4, False));      //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
   for CntFmt := 0 to 6 do begin
    if CntFmt in [4,5] then
       Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (18, False))
     else
       Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (13, False) );
   end;
   for CntFmt := 0 to 2 do
     Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (8, False));
 end
   // Operators Audit report SRM R2011.2 End
end;   // of TFrmDetCAAuditCaissiere.GetFmtTableHeader

//==============================================================================

function TFrmDetCAAuditCaissiere.GetFmtTableBody: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCAAuditCaissiere.GetFmtTableBody
 if FlgLastLine = false then begin                                              // Operators Audit report SRM R2011.2
   Result := '<+' + IntToStr (CalcWidthText (13, False));
   Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (4, False));       //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
   for CntFmt := 0 to 5 do begin
     if CntFmt = 4 then begin
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (5, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (4, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (11, False))
     end
     else begin
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (4, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (11, False));
     end;
   end;
   for CntFmt := 0 to 2 do
     Result := Result + TxtSep + '+' + IntToStr (CalcWidthText (8, False));
 end                                                                            // Operators Audit report SRM R2011.2
   // Operators Audit report SRM R2011.2 Start
 else if FlgLastLine = true then begin
   Result := '<+' + IntToStr (CalcWidthText (11, False));
   Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (4, False));       //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
   for CntFmt := 0 to 6 do begin
   if CntFmt in [4,5] then begin
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (5, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (4, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (9, False))
     end
     else begin
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (4, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (9, False));
     end;
   end;
   for CntFmt := 0 to 2 do
     Result := Result + TxtSep + '+' + IntToStr (CalcWidthText (8, False));
 end
 // Operators Audit report SRM R2011.2 End
end;   // of TFrmDetCAAuditCaissiere.GetFmtTableBody

//==============================================================================

function TFrmDetCAAuditCaissiere.GetTxtTableTitle : string;
begin  // of TFrmDetCAAuditCaissiere.GetTxtTableTitle
  if FlgLastLine = false then begin                                             // Operators Audit report SRM R2011.2
  Result := CtTxtCaissiere + TxtSep + CtTxtCheckout + TxtSep + CtTxtGratuit +   //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
   TxtSep + CtTxtPrixForce + TxtSep + CtTxtRetour + TxtSep + CtTxtRembous +
   TxtSep + CtTxtAnnulationL + TxtSep + CtTxtAnnulationT + TxtSep +
              CtTxtTicketSusp + TxtSep +
              CtTxtTicketAnnul + TxtSep + CtTxtOuverture;
  end
  // Operators Audit report SRM R2011.2 Start                                                                           // Operators Audit report SRM R2011.2
  else if FlgLastLine = true then begin
    Result := CtTxtCaissiere + TxtSep + CtTxtCheckout + TxtSep + CtTxtGratuit + //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
    TxtSep + CtTxtPrixForce + TxtSep + CtTxtRetour + TxtSep + CtTxtRembous +
    TxtSep + CtTxtAnnulationL + TxtSep + CtTxtAnnulUL + TxtSep +
    CtTxtAnnulationT + TxtSep + CtTxtTicketSusp + TxtSep +
    CtTxtTicketAnnul + TxtSep + CtTxtOuverture;
  end
  // Operators Audit report SRM R2011.2 End
end;   // of TFrmDetCAAuditCaissiere.GetTxtTableTitle)

//==============================================================================

function TFrmDetCAAuditCaissiere.GetTxtTitRapport : string;
begin  // of TFrmDetCAAuditCaissiere.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetCAAuditCaissiere.GetTxtTitRapport

//==============================================================================

function TFrmDetCAAuditCaissiere.GetTxtRefRapport : string;
begin  // of TFrmDetCAAuditCaissiere.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0003';
end;   // of TFrmDetCAAuditCaissiere.GetTxtRefRapport

//==============================================================================

procedure TFrmDetCAAuditCaissiere.Execute;
begin  // of TFrmDetCAAuditCaissiere.Execute
  // Initialization of totals per operator
  ResetValues;
  // Initialization of grand totals
  ResetTotalValues;
  // Activatie Stored procedure
  SprCAAuditCaissiere.Active := False;
  SprCAAuditCaissiere.ParamByName ('@PrmTxtSequence').AsString :=
      'IdtOperator';
  SprCAAuditCaissiere.ParamByName ('@PrmTxtFrom').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  SprCAAuditCaissiere.ParamByName ('@PrmTxtTo').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  SprCAAuditCaissiere.ParamByName ('@LstOperator').AsString :=
                                                TxtLstOperIDforSP;              //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
  SprCAAuditCaissiere.ParamByName ('@FlgLastLine').AsString :=
                                                BoolToStr(FlgLastLine,'T');		 //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
  SprCAAuditCaissiere.Active := True;
  // Start preview report
  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  PrintSecondTableHeader;
  if SprCAAuditCaissiere.RecordCount = 0 then
    VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite, clWhite, False)
  else begin
    PrintTableBody;
    PrintTableFooter;
  end;
  VspPreview.EndDoc;
  PrintPageNumbers;
  PrintReferences;
  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
  FrmVSPreview.OnActivate(Self);
end;   // of TFrmDetCAAuditCaissiere.Execute

//==============================================================================
// TFrmDetCAAuditCaissiere.ResetValues : Clear all running values
//==============================================================================

procedure TFrmDetCAAuditCaissiere.ResetValues;
begin  // of TFrmDetCAAuditCaissiere.ResetValues
  QtyGratuit      := 0;
  ValGratuit      := 0;
  QtyPrixForce   := 0;
  ValPrixForce    := 0;
  QtyRetour       := 0;
  ValRetour       := 0;
  QtyRembous      := 0;
  ValRembous      := 0;
  QtyAnnulationL  := 0;
  ValAnnulationL  := 0;
  NumAnnulationL  := 0;
  QtyAnnulationUL := 0;                                                         // Operators Audit report SRM R2011.2
  ValAnnulationUL := 0;                                                         // Operators Audit report SRM R2011.2
  NumAnnulationUL := 0;                                                         // Operators Audit report SRM R2011.2
  QtyAnnulationT  := 0;
  ValAnnulationT  := 0;
  QtyTicketSusp   := 0;
  QtyTicketAnnul  := 0;
  QtyOuverture    := 0;
  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.Start
  QtyGratuitSubTot      := 0;
  ValGratuitSubTot      := 0;
  QtyPrixForceSubTot    := 0;
  ValPrixForceSubTot    := 0;
  QtyRetourSubTot       := 0;
  ValRetourSubTot       := 0;
  QtyRembousSubTot      := 0;
  ValRembousSubTot      := 0;
  QtyAnnulationLSubTot  := 0;
  ValAnnulationLSubTot  := 0;
  NumAnnulationLSubTot  := 0;
  QtyAnnulationULSubTot := 0;
  ValAnnulationULSubTot := 0;
  NumAnnulationULSubTot := 0;
  QtyAnnulationTSubTot  := 0;
  ValAnnulationTSubTot  := 0;
  QtyTicketSuspSubTot   := 0;
  QtyTicketAnnulSubTot  := 0;
  QtyOuvertureSubTot    := 0;
  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.End
end;   // of TFrmDetCAAuditCaissiere.ResetValues

//==============================================================================
// TFrmDetCAAuditCaissiere.ResetTotalValues : Clear all total values
//==============================================================================

procedure TFrmDetCAAuditCaissiere.ResetTotalValues;
begin  // of TFrmDetCAAuditCaissiere.ResetTotalValues
  QtyGratuitTotal     := 0;
  ValGratuitTotal     := 0;
  QtyPrixForceTotal   := 0;
  ValPrixForceTotal   := 0;
  QtyRetourTotal      := 0;
  ValRetourTotal      := 0;
  QtyRembousTotal     := 0;
  ValRembousTotal     := 0;
  QtyAnnulationLTotal := 0;
  ValAnnulationLTotal := 0;
  QtyAnnulationULTotal :=0;                                                     // Operators Audit report SRM R2011.2
  ValAnnulationULTotal :=0;                                                     // Operators Audit report SRM R2011.2
  QtyAnnulationTTotal := 0;
  ValAnnulationTTotal := 0;
  QtyTicketSuspTotal  := 0;
  QtyTicketAnnulTotal := 0;
  QtyOuvertureTotal   := 0;
  NumAnnulationLTotal := 0;                                                     //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK
end;   // of TFrmDetCAAuditCaissiere.ResetTotalValues

//==============================================================================
// TFrmDetCAAuditCaissiere.CalculateValues : calculate running and total values
//                                  -----
// INPUT   : StrType : calculate running or total values
//==============================================================================

procedure TFrmDetCAAuditCaissiere.CalculateValues(StrType : string);
begin  // of TFrmDetCAAuditCaissiere.CalculateValues
  if StrType = 'Total' then begin
//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.Start
    QtyGratuitTotal     := QtyGratuitTotal + QtyGratuitSubTot;
    ValGratuitTotal     := ValGratuitTotal + ValGratuitSubTot;
    QtyPrixForceTotal   := QtyPrixForceTotal + QtyPrixForceSubTot;
    ValPrixForceTotal   := ValPrixForceTotal + ValPrixForceSubTot;
    QtyRetourTotal      := QtyRetourTotal + QtyRetourSubTot;
    ValRetourTotal      := ValRetourTotal + ValRetourSubTot;
    QtyRembousTotal     := QtyRembousTotal + QtyRembousSubTot;
    ValRembousTotal     := ValRembousTotal + ValRembousSubTot;
    NumAnnulationLTotal := NumAnnulationLTotal + NumAnnulationLSubTot;
    QtyAnnulationLTotal := QtyAnnulationLTotal + QtyAnnulationLSubTot;
    ValAnnulationLTotal := ValAnnulationLTotal + ValAnnulationLSubTot;
    QtyAnnulationTTotal := QtyAnnulationTTotal + QtyAnnulationTSubTot;
    ValAnnulationTTotal := ValAnnulationTTotal + ValAnnulationTSubTot;
    QtyTicketSuspTotal  := QtyTicketSuspTotal + QtyTicketSuspSubTot;
    QtyTicketAnnulTotal := QtyTicketAnnulTotal + QtyTicketAnnulSubTot;
    QtyOuvertureTotal   := QtyOuvertureTotal + QtyOuvertureSubTot;
    // Operators Audit report SRM R2011.2 Start
    if FlgLastLine then begin
      QtyAnnulationULTotal := QtyAnnulationULTotal + QtyAnnulationULSubTot;
      ValAnnulationULTotal := ValAnnulationULTotal + ValAnnulationULSubTot;
    end;
//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.end	
    // Operators Audit report SRM R2011.2 End
  end
  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.Start
  else if StrType = 'CurrentData' then begin
    QtyGratuit     := StrToInt(SprCAAuditCaissiere.FieldByName ('QtyGratis').AsString);
    ValGratuit     := SprCAAuditCaissiere.FieldByName ('ValGratis').AsFloat;
    QtyPrixForce   := SprCAAuditCaissiere.FieldByName ('QtyPrcUnitForce').AsInteger;
    ValPrixForce   := SprCAAuditCaissiere.FieldByName ('PrcUnitForce').AsFloat;
    QtyRetour      := SprCAAuditCaissiere.FieldByName ('QtyRetour').AsInteger;
    ValRetour      := SprCAAuditCaissiere.FieldByName ('ValRetour').AsFloat;
    QtyRembous     := SprCAAuditCaissiere.FieldByName ('QtyRemboursement').AsInteger;
    ValRembous     := SprCAAuditCaissiere.FieldByName ('ValRemboursement').AsFloat;
    QtyAnnulationL := SprCAAuditCaissiere.FieldByName ('NumCancelLigne').AsInteger;
    ValAnnulationL := SprCAAuditCaissiere.FieldByName ('ValCancelLigne').AsFloat;
    NumAnnulationL := SprCAAuditCaissiere.FieldByName ('QtyCancelLigne').AsInteger;
    QtyAnnulationT := SprCAAuditCaissiere.FieldByName ('QtyCancelTicket').AsInteger;
    ValAnnulationT := SprCAAuditCaissiere.FieldByName ('ValCancelTicket').AsFloat;
    QtyTicketSusp  := SprCAAuditCaissiere.FieldByName ('QtySuspendTicket').AsInteger;
    QtyTicketAnnul := SprCAAuditCaissiere.FieldByName ('QtySuspendCancelTicket').AsInteger;
    QtyOuverture   := SprCAAuditCaissiere.FieldByName ('QtyOpenDrawer').AsInteger;
    if FlgLastLine then begin
      QtyAnnulationUL := SprCAAuditCaissiere.FieldByName ('NumCancelUltimaLigne').AsInteger;
      ValAnnulationUL := SprCAAuditCaissiere.FieldByName ('ValCancelUltimaLigne').AsFloat;
      NumAnnulationUL := SprCAAuditCaissiere.FieldByName ('QtyCancelUltimaLigne').AsInteger;
    end;
  end
  else if StrType = 'DataPerCashdesk' then begin					//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK
    QtyGratuit     := QtyGratuit +
                          StrToInt(SprCAAuditCaissiere.FieldByName ('QtyGratis').AsString);
    ValGratuit     := ValGratuit +
                          SprCAAuditCaissiere.FieldByName ('ValGratis').AsFloat;
    QtyPrixForce   := QtyPrixForce +
                          SprCAAuditCaissiere.FieldByName ('QtyPrcUnitForce').AsInteger;
    ValPrixForce   := ValPrixForce +
                          SprCAAuditCaissiere.FieldByName ('PrcUnitForce').AsFloat;
    QtyRetour      := QtyRetour +
                          SprCAAuditCaissiere.FieldByName ('QtyRetour').AsInteger;
    ValRetour      := ValRetour +
                          SprCAAuditCaissiere.FieldByName ('ValRetour').AsFloat;
    QtyRembous     := QtyRembous +
                          SprCAAuditCaissiere.FieldByName ('QtyRemboursement').AsInteger;
    ValRembous     := ValRembous +
                          SprCAAuditCaissiere.FieldByName ('ValRemboursement').AsFloat;
    QtyAnnulationL := QtyAnnulationL +
                          SprCAAuditCaissiere.FieldByName ('NumCancelLigne').AsInteger;
    ValAnnulationL := ValAnnulationL +
                          SprCAAuditCaissiere.FieldByName ('ValCancelLigne').AsFloat;
    NumAnnulationL := NumAnnulationL +
                          SprCAAuditCaissiere.FieldByName ('QtyCancelLigne').AsInteger;
    QtyAnnulationT := QtyAnnulationT +
                          SprCAAuditCaissiere.FieldByName ('QtyCancelTicket').AsInteger;
    ValAnnulationT := ValAnnulationT +
                          SprCAAuditCaissiere.FieldByName ('ValCancelTicket').AsFloat;
    QtyTicketSusp  := QtyTicketSusp +
                          SprCAAuditCaissiere.FieldByName ('QtySuspendTicket').AsInteger;
    QtyTicketAnnul := QtyTicketAnnul +
                          SprCAAuditCaissiere.FieldByName ('QtySuspendCancelTicket').AsInteger;
    QtyOuverture   := QtyOuverture +
                          SprCAAuditCaissiere.FieldByName ('QtyOpenDrawer').AsInteger;
    if FlgLastLine then begin						//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK
      QtyAnnulationUL := QtyAnnulationUL +
                             SprCAAuditCaissiere.FieldByName ('NumCancelUltimaLigne').AsInteger;
      ValAnnulationUL := ValAnnulationUL +
                             SprCAAuditCaissiere.FieldByName ('ValCancelUltimaLigne').AsFloat;
      NumAnnulationUL := NumAnnulationUL +
                             SprCAAuditCaissiere.FieldByName ('QtyCancelUltimaLigne').AsInteger;
    end;
  end
  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.End
  else begin
    QtyAnnulationTSubTot :=0;                                                     // jay
    ValAnnulationTSubTot :=0;                                                     // jay

    QtyGratuitSubTot := QtyGratuitSubTot + QtyGratuit;
    ValGratuitSubTot     := ValGratuitSubTot + ValGratuit;
    QtyPrixForceSubTot   := QtyPrixForceSubTot + QtyPrixForce;
    ValPrixForceSubTot   := ValPrixForceSubTot + ValPrixForce;
    QtyRetourSubTot      := QtyRetourSubTot + QtyRetour;
    ValRetourSubTot      := ValRetourSubTot + ValRetour;
    QtyRembousSubTot     := QtyRembousSubTot + QtyRembous;
    ValRembousSubTot     := ValRembousSubTot + ValRembous;
    QtyAnnulationLSubTot := QtyAnnulationLSubTot + QtyAnnulationL;
    ValAnnulationLSubTot := ValAnnulationLSubTot + ValAnnulationL;
    NumAnnulationLSubTot := NumAnnulationLSubTot + NumAnnulationL;
    QtyAnnulationTSubTot := QtyAnnulationTSubTot + QtyAnnulationT;
    ValAnnulationTSubTot := ValAnnulationTSubTot + ValAnnulationT;
    QtyTicketSuspSubTot  := QtyTicketSuspSubTot + QtyTicketSusp;
    QtyTicketAnnulSubTot := QtyTicketAnnulSubTot + QtyTicketAnnul;
    QtyOuvertureSubTot   := QtyOuvertureSubTot + QtyOuverture;
    // Operators Audit report SRM R2011.2 Start
    if FlgLastLine then begin
      QtyAnnulationULSubTot := QtyAnnulationULSubTot + QtyAnnulationUL;
      ValAnnulationULSubTot := ValAnnulationULSubTot + ValAnnulationUL;
      NumAnnulationULSubTot := NumAnnulationULSubTot + NumAnnulationUL;
    end;
    // Operators Audit report SRM R2011.2 End
  end;
end;   // of TFrmDetCAAuditCaissiere.CalculateValues

//==============================================================================
// TFrmDetCAAuditCaissiere.PrintSecondTableHeader : print subtitles
//==============================================================================
procedure TFrmDetCAAuditCaissiere.PrintSecondTableHeader;
var
  CntFmt           : integer;          // Loop for making the format.
  SecTabHeader     : string;           // String for second table header
  SecTabTitle      : string;           // String for second table title
begin  // of TFrmDetCAAuditCaissiere.PrintSecondTableHeader
  if FlgLastLine = false then begin                                             // Operators Audit report SRM R2011.2
  // Filling SecondTableHeader
  SecTabHeader := '<+' + IntToStr (CalcWidthText (13, False));
  SecTabHeader := SecTabHeader + TxtSep + '>+' +
                    IntToStr (CalcWidthText (4, False));                        //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
  for CntFmt := 0 to 5 do begin
    if CntFmt = 4 then begin
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                        IntToStr (CalcWidthText (5, False));
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                        IntToStr (CalcWidthText (4, False));
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                        IntToStr (CalcWidthText (11, False));
    end
    else begin
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                      IntToStr (CalcWidthText (4, False));
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                      IntToStr (CalcWidthText (11, False));
    end;
  end;
  for CntFmt := 0 to 2 do
    SecTabHeader := SecTabHeader + TxtSep + '^+' +
                    IntToStr (CalcWidthText (8, False));
  // Filling SecondTableTitle
  SecTabTitle := '' + TxtSep + '' + TxtSep + CtTxtNb + TxtSep + CtTxtMontant +  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
              TxtSep + CtTxtNb + TxtSep + CtTxtMontant + TxtSep + CtTxtNb +
              TxtSep + CtTxtMontant + TxtSep + CtTxtNb + TxtSep + CtTxtMontant +
              TxtSep + CtTxtNb + ' ' + CtTxtHdrLines + TxtSep + CtTxtNb +
              ' ' + CtTxtHdrArt + TxtSep + CtTxtMontant + TxtSep + CtTxtNb +
              TxtSep + CtTxtMontant + TxtSep + '' + TxtSep + '' +
              TxtSep + '' + TxtSep + '' + TxtSep + '';
  //  Adding SecondTableHeader
  VspPreview.AddTable (SecTabHeader, '', SecTabTitle, clWhite, clLTGray, False);
  end                                                                           // Operators Audit report SRM R2011.2
  // Operators Audit report SRM R2011.2 Start
  else if FlgLastLine = true then begin
    // Filling SecondTableHeader
  SecTabHeader := '<+' + IntToStr (CalcWidthText (11, False));
  SecTabHeader := SecTabHeader + TxtSep + '>+' +
                    IntToStr (CalcWidthText (4, False));                        //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
  for CntFmt := 0 to 6 do begin
    if CntFmt in [4,5] then begin
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                        IntToStr (CalcWidthText (5, False));
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                        IntToStr (CalcWidthText (4, False));
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                        IntToStr (CalcWidthText (9, False));
    end
    else begin
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                      IntToStr (CalcWidthText (4, False));
      SecTabHeader := SecTabHeader + TxtSep + '>+' +
                      IntToStr (CalcWidthText (9, False));
    end;
  end;
  for CntFmt := 0 to 2 do
    SecTabHeader := SecTabHeader + TxtSep + '^+' +
                    IntToStr (CalcWidthText (8, False));
  // Filling SecondTableTitle
  SecTabTitle := '' + TxtSep + '' + TxtSep +  CtTxtNb + TxtSep + CtTxtMontant + //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
              TxtSep + CtTxtNb + TxtSep + CtTxtMontant + TxtSep + CtTxtNb +
              TxtSep + CtTxtMontant + TxtSep + CtTxtNb + TxtSep + CtTxtMontant +
              TxtSep + CtTxtNb + ' ' + CtTxtHdrLines + TxtSep + CtTxtNb +
              ' ' + CtTxtHdrArt + TxtSep + CtTxtMontant + TxtSep +
  // Operators Audit report SRM R2011.2 - Start
                   CtTxtNb + ' ' + CtTxtHdrLines + TxtSep + CtTxtNb +
                   ' ' + CtTxtHdrArt + TxtSep + CtTxtMontant + TxtSep +
  // Operators Audit report SRM R2011.2 - End
                   CtTxtNb + TxtSep + CtTxtMontant + TxtSep + '' +
                   TxtSep + '' + TxtSep + '' + TxtSep + '' + TxtSep + '';
  //  Adding SecondTableHeader
  VspPreview.AddTable (SecTabHeader, '', SecTabTitle, clWhite, clLTGray, False);
  end
  // Operators Audit report SRM R2011.2 End
end;   // of TFrmDetCAAuditCaissiere.PrintSecondTableHeader

//==============================================================================
// TFrmDetCAAuditCaissiere.PrintHeader : print header of the report
//==============================================================================

procedure TFrmDetCAAuditCaissiere.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCAAuditCaissiere.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;
  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;
  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetCAAuditCaissiere.PrintHeader

//==============================================================================
// TFrmDetCAAuditCaissiere.PrintTableBody : print table
//==============================================================================

procedure TFrmDetCAAuditCaissiere.PrintTableBody;
var
  StrCurrentOperator  : string;           // Current operator
  StrPreviousOperator : string;           // Previous operator
  StrFirstRecord      : string;           // First record check
  StrPreviousCheckout : string;           // Previous Checkout                  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
  StrCurrentCheckout  : string;           // Current Checkout                   //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
begin  // of TFrmDetCAAuditCaissiere.PrintTableBody
  inherited;
  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.Start.modified
  strFirstRecord := '';
  VspPreview.TableBorder := tbBoxColumns;
  while not SprCAAuditCaissiere.Eof do begin
    StrCurrentOperator := SprCAAuditCaissiere.FieldByName ('IdtOperator').AsString;
    StrCurrentCheckout := SprCAAuditCaissiere.FieldByName ('IdtCheckout').AsString;
    if (StrPreviousOperator = StrCurrentOperator)
       and (StrPreviousCheckout = StrCurrentCheckout) then
      // Calculate values
      CalculateValues('DataPerCashdesk')
    else begin
      if (StrPreviousOperator <> StrFirstRecord) then
        // print lines
        PrintBodyLine(StrPreviousOperator,StrPreviousCheckout);
      if (StrPreviousOperator <> StrCurrentOperator) and
                     (StrPreviousOperator <> StrFirstRecord) then begin
        PrintSubTotal;
        // Calculate total values
        CalculateValues('Total');
        // Resetting of totals per operator
        ResetValues;
      end;
      CalculateValues('CurrentData');
    end;
    CalculateValues('SubTotal');
    StrPreviousOperator := StrCurrentOperator;
    StrPreviousCheckout := StrCurrentCheckout;
    SprCAAuditCaissiere.Next;
  end;
  // Handle last record
  if SprCAAuditCaissiere.Active then begin
    StrCurrentOperator := SprCAAuditCaissiere.FieldByName ('IdtOperator').AsString;
    StrCurrentCheckout := SprCAAuditCaissiere.FieldByName ('IdtCheckout').AsString;
    PrintBodyLine(strCurrentOperator,StrCurrentCheckout);
    PrintSubTotal;
    CalculateValues('Total');
  end;
  //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.End.modified
end;   // of TFrmDetCAAuditCaissiere.PrintTableBody

//==============================================================================
// TFrmDetCAAuditCaissiere.PrintBodyLine : print one line of the table
//                                  -----
// INPUT   : StrOperator : operator of which a line needs to be printed
//==============================================================================

procedure TFrmDetCAAuditCaissiere.PrintBodyLine(StrOperator, StrCheckout :string);
var
  TxtPrintLine        : string;           // String to print
begin  // of TFrmDetCAAuditCaissiere.PrintBodyLine
   VspPreview.StartTable; 
    if not FlgLastLine then
    TxtPrintLine:= GetBodyLine(StrOperator, StrCheckout)
  {if FlgLastLine = false then begin                                             // Operators Audit report SRM R2011.2
  TxtPrintLine := CtTxtOperateur + ' ' + StrOperator + TxtSep+
                  IntToStr(QtyGratuit) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValGratuit) + TxtSep +
                  IntToStr(QtyPrixForce) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValPrixForce) + TxtSep +
                  IntToStr(QtyRetour) +
                  TxtSep +  FormatFloat(CtTxtFrmNumber,ValRetour) + TxtSep +
                  IntToStr(QtyRembous) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValRembous) +
                  TxtSep + IntToStr(QtyAnnulationL) + TxtSep +
                  IntToStr(NumAnnulationL) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValAnnulationL) + TxtSep +
                  IntToStr(QtyAnnulationT) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValAnnulationT) + TxtSep +
                  IntToStr(QtyTicketSusp) +
                  TxtSep + IntToStr(QtyTicketAnnul) + TxtSep +
                  IntToStr(QtyOuverture);
  VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                       clWhite, False);
  end                                                                           // Operators Audit report SRM R2011.2
  else if FlgLastLine = true then begin                                         // Operators Audit report SRM R2011.2 - Start
    TxtPrintLine := CtTxtOperateur + ' ' + StrOperator + TxtSep+
                  IntToStr(QtyGratuit) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValGratuit) + TxtSep +
                  IntToStr(QtyPrixForce) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValPrixForce) + TxtSep +
                  IntToStr(QtyRetour) +
                  TxtSep +  FormatFloat(CtTxtFrmNumber,ValRetour) + TxtSep +
                  IntToStr(QtyRembous) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValRembous) +
                  TxtSep + IntToStr(QtyAnnulationL) + TxtSep +
                  IntToStr(NumAnnulationL) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValAnnulationL) +
                  TxtSep + IntToStr(QtyAnnulationUL) + TxtSep +
                  IntToStr(NumAnnulationUL) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValAnnulationUL) + TxtSep +
                  IntToStr(QtyAnnulationT) + TxtSep +
                  FormatFloat(CtTxtFrmNumber,ValAnnulationT) + TxtSep +
                  IntToStr(QtyTicketSusp) +
                  TxtSep + IntToStr(QtyTicketAnnul) + TxtSep +
                  IntToStr(QtyOuverture);
    VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                       clWhite, False);
  end;}
    else
	  TxtPrintLine := GetBodyLine(StrOperator, StrCheckout);
	    VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                       clWhite, False);  													// Operators Audit report SRM R2011.2 - End
  VspPreview.EndTable;                                                                        
end;   // of TFrmDetCAAuditCaissiere.PrintBodyLine

//==============================================================================

function TFrmDetCAAuditCaissiere.GetTxtTableFooter : string;
begin  // of TFrmDetCAAuditCaissiere.GetTxtTableFooter
 if FlgLastLine = false then begin                                             // Operators Audit report SRM R2011.2
  Result := CtTxtTotal + TxtSep + '' + TxtSep + IntToStr(QtyGratuitTotal) +     //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
            TxtSep + FormatFloat (CtTxtFrmNumber, ValGratuitTotal) +TxtSep +
            IntToStr(QtyPrixForceTotal) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValPrixForceTotal) + TxtSep +
            IntToStr(QtyRetourTotal) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValRetourTotal) + TxtSep +
            IntToStr(QtyRembousTotal) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValRembousTotal) + TxtSep +
            IntToStr(QtyAnnulationLTotal) + TxtSep + ' ' + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValAnnulationLTotal) + TxtSep +
            IntToStr(QtyAnnulationTTotal) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValAnnulationTTotal) + TxtSep +
            IntToStr(QtyTicketSuspTotal) + TxtSep +
            IntToStr(QtyTicketAnnulTotal) + TxtSep +
            IntToStr(QtyOuvertureTotal);
  end
  else if FlgLastLine = true then begin                                          // Operators Audit report SRM R2011.2 - Start
    Result := CtTxtTotal + TxtSep + '' + TxtSep + IntToStr(QtyGratuitTotal) +   //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
            TxtSep + FormatFloat (CtTxtFrmNumber, ValGratuitTotal) +TxtSep +
            IntToStr(QtyPrixForceTotal) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValPrixForceTotal) + TxtSep +
            IntToStr(QtyRetourTotal) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValRetourTotal) + TxtSep +
            IntToStr(QtyRembousTotal) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValRembousTotal) + TxtSep +
            IntToStr(QtyAnnulationLTotal) + TxtSep + ' ' + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValAnnulationLTotal) + TxtSep +
            IntToStr(QtyAnnulationULTotal) + TxtSep + ' ' + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValAnnulationULTotal) + TxtSep +
            IntToStr(QtyAnnulationTTotal) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValAnnulationTTotal) + TxtSep +
            IntToStr(QtyTicketSuspTotal) + TxtSep +
            IntToStr(QtyTicketAnnulTotal) + TxtSep +
            IntToStr(QtyOuvertureTotal);
  end                                                                           // Operators Audit report SRM R2011.2 - End
end;   // of TFrmDetCAAuditCaissiere.GetTxtTableFooter

//==============================================================================

procedure TFrmDetCAAuditCaissiere.FormPaint(Sender: TObject);
begin  // of TFrmDetCAAuditCaissiere.FormPaint
  inherited;
  //BtnSelectAllClick(Self)
end;   // of TFrmDetCAAuditCaissiere.FormPaint

//==============================================================================

{procedure TFrmDetCAAuditCaissiere.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetCAAuditCaissiere.BtnPrintClick
  DtmPckDayTo.SetFocus;
  DtmPckDayFrom.SetFocus;
  // Check is DayFrom < DayTo
  if DtmPckDayFrom.Date > DtmPckDayTo.Date then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    MessageDlg (CtTxtStartEndDate, mtWarning, [mbOK], 0);
  end
  // Check if DayFrom is in the future
  else if DtmPckDayFrom.Date > Now then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    MessageDlg (CtTxtStartFuture, mtWarning, [mbOK], 0);
  end
  // Check if DayTo is in the future
  else if DtmPckDayTo.Date > Now then begin
    DtmPckDayTo.Date := Now;
    MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  else begin
   FlgPreview := (Sender = BtnPreview);
   Execute;
  end;
end;  // of TFrmDetCAAuditCaissiere.BtnPrintClick}

//==============================================================================
{// // Operators Audit report SRM R2011.2 Start
//                                 ---
//==============================================================================
{procedure TFrmDetCAAuditCaissiere.FormActivate(Sender: TObject);
var
NumParam : Integer;
Txtparam : String;
TxtPrmCheck : String;
begin
{  for NumParam := 1 to ParamCount do begin
    TxtParam := ParamStr (NumParam);
    if (TxtParam[1] = '/') and (Length (TxtParam) >= 2) and
       (UpCase (TxtParam[2]) = 'V') then begin
      TxtPrmCheck := AnsiUpperCase (Copy (TxtParam, 3, Length (TxtParam)));
    end;
    if TxtPrmCheck = 'UL' then
    FlgLastLine := True;
  end; }
//inherited;
//end;}
//==============================================================================
// Operators Audit report SRM R2011.2 End
//==============================================================================
// //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.AJ.End}

//==============================================================================
// Operators Audit report SRM R2011.2 Start

//==============================================================================
 procedure TFrmDetCAAuditCaissiere.CheckAppDependParams(TxtParam: string);
begin
 if AnsiUpperCase(Copy(TxtParam,3,4))= 'UL' then
    FlgLastLine := True
 else
  inherited;
 end;
//==============================================================================
// Operators Audit report SRM R2011.2 End
//==============================================================================

//==============================================================================
// Operators Audit report SRM R2011.2 Start
//==============================================================================
procedure TFrmDetCAAuditCaissiere.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin
  inherited;
  SplitString(CtLastLine, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;
//==============================================================================
// Operators Audit report SRM R2011.2 End
//==============================================================================
procedure TFrmDetCAAuditCaissiere.FormCreate(Sender: TObject);                  // Operators Audit report SRM Difectfix(240) start
begin
  inherited;
 application.Title := CtTxtTitle;
end;                                                                            // Operators Audit report SRM Difectfix(240) start
//==============================================================================

//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.Start

procedure TFrmDetCAAuditCaissiere.PrintSubTotal ;
  var
  TxtLine          : string;           // Line to print
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
begin  // of TFrmDetCAAuditCaissiere.PrintSubTotal
  VspPreview.StartTable;
  if FlgLastLine = false then begin
    TxtLine := CtTxtSubTot + TxtSep + '' + TxtSep + IntToStr(QtyGratuitSubTot) +
              TxtSep + FormatFloat (CtTxtFrmNumber, ValGratuitSubTot) +TxtSep +
              IntToStr(QtyPrixForceSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValPrixForceSubTot) + TxtSep +
              IntToStr(QtyRetourSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValRetourSubTot) + TxtSep +
              IntToStr(QtyRembousSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValRembousSubTot) + TxtSep +
              IntToStr(QtyAnnulationLSubTot) + TxtSep +
              IntToStr(NumAnnulationLSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValAnnulationLSubTot) + TxtSep +
              IntToStr(QtyAnnulationTSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValAnnulationTSubTot) + TxtSep +
              IntToStr(QtyTicketSuspSubTot) + TxtSep +
              IntToStr(QtyTicketAnnulSubTot) + TxtSep +
              IntToStr(QtyOuvertureSubTot);
  end
  else if FlgLastLine = true then begin
    TxtLine := CtTxtSubTot + TxtSep + '' + TxtSep + IntToStr(QtyGratuitSubTot) +
              TxtSep + FormatFloat (CtTxtFrmNumber, ValGratuitSubTot) +TxtSep +
              IntToStr(QtyPrixForceSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValPrixForceSubTot) + TxtSep +
              IntToStr(QtyRetourSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValRetourSubTot) + TxtSep +
              IntToStr(QtyRembousSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValRembousSubTot) + TxtSep +
              IntToStr(QtyAnnulationLSubTot) + TxtSep +
              IntToStr(NumAnnulationLSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValAnnulationLSubTot) + TxtSep +
              IntToStr(QtyAnnulationULSubTot) + TxtSep + ' ' + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValAnnulationULSubTot) + TxtSep +
              IntToStr(QtyAnnulationTSubTot) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValAnnulationTSubTot) + TxtSep +
              IntToStr(QtyTicketSuspSubTot) + TxtSep +
              IntToStr(QtyTicketAnnulSubTot) + TxtSep +
              IntToStr(QtyOuvertureSubTot);
  end;
  VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clLtGray;
  VspPreview.EndTable;
end;
//==============================================================================

procedure TFrmDetCAAuditCaissiere.BtnExportClick(Sender: TObject);
var
  TxtTitles           : string;
  TxtWriteLine        : string;
  Counter             : Integer;
  F                   : System.Text;
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;
  StrCurrentOperator  : string;
  TxtBodyLine         : string;
  StrCurrentCheckout  : string;
  TxtItem             : string;
  Cnt                 : integer;
begin // of TFrmDetCAAuditCaissiere.BtnExportClick
  TxtItem:= '';
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;
  //set focus to other fields than on datefields
  QryHlp := TQuery.Create(self);
  try
    QryHlp.DatabaseName := 'DBFlexPoint';
    QryHlp.Active := False;
    QryHlp.SQL.Clear;
    QryHlp.SQL.Add('select * from ApplicParam' +
                   ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
    QryHlp.Active := True;
    if QryHlp.RecordCount > 0 then
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  FlgPreview := (Sender = BtnPreview);

  // Check is DayFrom < DayTo
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) then begin
    DtmPckDayFrom.Date    := Now;
    DtmPckDayTo.Date      := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) then begin
    DtmPckDayFrom.Date    := Now;
    Application.MessageBox(PChar(CtTxtStartFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) then begin
    DtmPckDayto.Date    := Now;
    Application.MessageBox(PChar(CtTxtEndFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
    ChrDecimalSep    := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    TxtTitles := GetTxtTableTitle();
    TxtWriteLine := '';
    for counter := 1 to Length(TxtTitles) do
      if TxtTitles[counter] = '|' then
        TxtWriteLine := TxtWriteLine + ';'
      else
        TxtWriteLine := TxtWriteLine + TxtTitles[counter];
    repeat
      Btnselect := mrOk;
      FlgOK := SavDlgExport.Execute;
      if FileExists(SavDlgExport.FileName) and FlgOK then
        Btnselect := MessageDlg(CtTxtExists, mtError, mbOKCancel, 0);
      if not FlgOK then
        Btnselect := mrOK;
    until Btnselect = mrOk;
    if FlgOK then begin
      System.Assign(F, SavDlgExport.FileName);
      Rewrite(F);
      WriteLn(F, TxtWriteLine);
      SprCAAuditCaissiere.ParamByName ('@PrmTxtSequence').AsString :=
                                                      'IdtOperator';
      SprCAAuditCaissiere.ParamByName ('@PrmTxtFrom').AsString :=
          FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
              FormatDateTime (ViTxtDBHouFormat, 0);
      SprCAAuditCaissiere.ParamByName ('@PrmTxtTo').AsString :=
          FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
              FormatDateTime (ViTxtDBHouFormat, 0);
      SprCAAuditCaissiere.ParamByName ('@LstOperator').AsString :=
                                                TxtLstOperIDforSP;
      SprCAAuditCaissiere.ParamByName ('@FlgLastLine').AsString :=
                                                BoolToStr(FlgLastLine,'T');
      try
        SprCAAuditCaissiere.Active := True;
        SprCAAuditCaissiere.First;
        if SprCAAuditCaissiere.RecordCount = 0 then begin
          TxtWriteLine := CtTxtNoData;
          WriteLn(F, TxtWriteLine);
        end
        else
        begin
          while not SprCAAuditCaissiere.Eof do begin
            Counter:= 1;
            Cnt:= 0;
            TxtWriteLine := '';
            StrCurrentOperator :=
              SprCAAuditCaissiere.FieldByName('IdtOperator').AsString;
            StrCurrentCheckout :=
              SprCAAuditCaissiere.FieldByName('IdtCheckout').AsString;
            CalculateValues('CurrentData');
            TxtBodyLine:= GetBodyLine(StrCurrentOperator,StrCurrentCheckout);
            repeat
              while TxtBodyLine[counter] <> '|' do begin
                TxtItem:= TxtItem + TxtBodyLine[counter];
                Inc(Counter);
                if TxtBodyLine[counter] = '|' then
                  Inc(Cnt);
              end;
              if Cnt > 1 then begin
                if StrToFloat(TxtItem) = 0 then
                    TxtItem:= '';
                TxtWriteLine:= TxtWriteLine + ';' + TxtItem;
              end
              else
                TxtWriteLine:= TxtItem;
              TxtItem:= '';
              if Counter <> Length(TxtBodyLine) then
                Inc(Counter);
            until Counter = Length(TxtBodyLine);
            WriteLn(F, TxtWriteLine);
            SprCAAuditCaissiere.Next;
          end;
        end;
      finally
        DmdFpnUtils.CloseInfo;
        SprCAAuditCaissiere.Active := False;
        System.Close(F);
        DecimalSeparator := ChrDecimalSep;
      end;
    end;
  end;
end;
//==============================================================================

function TFrmDetCAAuditCaissiere.GetBodyLine(StrOperator, StrCheckout :string): string;
begin
  if not FlgLastLine then
    Result := CtTxtOperateur + ' ' + StrOperator + TxtSep + Strcheckout +
              TxtSep + IntToStr(QtyGratuit) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValGratuit) + TxtSep +
              IntToStr(QtyPrixForce) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValPrixForce) + TxtSep +
              IntToStr(QtyRetour) +
              TxtSep +  FormatFloat(CtTxtFrmNumber,ValRetour) + TxtSep +
              IntToStr(QtyRembous) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValRembous) +
              TxtSep + IntToStr(QtyAnnulationL) + TxtSep +
              IntToStr(NumAnnulationL) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValAnnulationL) + TxtSep +
              IntToStr(QtyAnnulationT) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValAnnulationT) + TxtSep +
              IntToStr(QtyTicketSusp) +
              TxtSep + IntToStr(QtyTicketAnnul) + TxtSep +
              IntToStr(QtyOuverture)
  else
    Result := CtTxtOperateur + ' ' + StrOperator + TxtSep + Strcheckout +
              TxtSep + IntToStr(QtyGratuit) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValGratuit) + TxtSep +
              IntToStr(QtyPrixForce) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValPrixForce) + TxtSep +
              IntToStr(QtyRetour) +
              TxtSep +  FormatFloat(CtTxtFrmNumber,ValRetour) + TxtSep +
              IntToStr(QtyRembous) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValRembous) +
              TxtSep + IntToStr(QtyAnnulationL) + TxtSep +
              IntToStr(NumAnnulationL) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValAnnulationL) +
              TxtSep + IntToStr(QtyAnnulationUL) + TxtSep +
              IntToStr(NumAnnulationUL) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValAnnulationUL) + TxtSep +
              IntToStr(QtyAnnulationT) + TxtSep +
              FormatFloat(CtTxtFrmNumber,ValAnnulationT) + TxtSep +
              IntToStr(QtyTicketSusp) +
              TxtSep + IntToStr(QtyTicketAnnul) + TxtSep +
              IntToStr(QtyOuverture);
  if not FlgPreview then
    Result:= Result + TxtSep;
end;
//==============================================================================
//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-TK.End

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun
