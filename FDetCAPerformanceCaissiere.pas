//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Flexpoint Development
// Customer: Castorama
// Unit   : FDetCAPerformanceCassiere.PAS : based on FDetGeneralCA (General
//                                      Detailform to print CAstorama rapports)
//------------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCAPerformanceCaissiere.pas,v 1.5 2009/09/29 11:35:31 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetCAPerformanceCassiere.PAS - CVS revision 1.3
//==============================================================================

unit FDetCAPerformanceCaissiere;

//******************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE,
  ScUtils, SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA;

//******************************************************************************
// Global definitions
//******************************************************************************

const
  CtMaxNumDays        = 30;

resourcestring     // of header
  CtTxtTitle          = 'Performance operators';

resourcestring     // of table header.
  CtTxtDescription    = 'Operator Nr';
  CtTxtCaisse         = 'Cash register Nr';
  CtTxtTotal          = 'Total';
  CtTxtTEffectif      = 'Real time';
  CtTxtTDiverses      = 'Time various operations';
  CtTxtTdAttente      = 'Waiting time between two customers';
  CtTxtTMisePause     = 'Time on break';
  CtTxtTClient        = 'Average time per customer';
  CtTxtTArticle       = 'Average time per article';
  CtTxtTTrans         = 'Number of transactions';
  CtTxtOperateur      = 'Operator';
  CtTxtNoData         = 'No data for this daterange';
  CtTxtPrintDate      = 'Printed on %s at %s';
  CtTxtReportDate     = 'Report from %s to %s';
  CtTxtStartEndDate   = 'Startdate is after enddate!';
  CtTxtStartFuture    = 'Startdate is in the future!';
  CtTxtEndFuture      = 'Enddate is in the future!';
  CtTxtMaxDays        = 'Selected daterange may not contain more then %s days';

resourcestring     // how to format a timepart.
  CtTxtFrmTime        = '00';       // How to format a number.

resourcestring     // of run parameters
  CtTxtNumTrans       = '/VNT=Number of transactions is added and operators ' +
                        'are added to searchcriteria';

//******************************************************************************
// Form-declaration.
//******************************************************************************

type
  TFrmDetCAPerformanceCaissiere = class(TFrmDetGeneralCA)
    SprCAPerformanceCaissiere: TStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
  private
  // Variables
  valTotal            : Real;             // Total
  valTempsEffectif    : Real;             // Temps effectif
  valTempsDiverse     : Real;             // Temps operations diverses
  valTempsAttend      : Real;             // Temps d'attente entre 2 clients
  valTempsPauze       : Real;             // Temps de mise en pause
  qtyClient           : Real;             // Number of clients
  qtyArticle          : Real;             // Number of articles
  qtyTransactions     : integer;          // Number of transactions
  qtyTotalTrans       : integer;          // Total number of transactions
  valTempsClient      : Real;             // Average time per customer
  valTempsArticle     : Real;             // Average time per customer
  FFlgNumTrans        : boolean;          // Show number of transactions
  protected
    // Run params
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
     // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetTxtTableFooter : string; override;
    function GetTxtTableTitle : string; override;
    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
  public
    property FlgNumTrans: Boolean read FFlgNumTrans write FFlgNumTrans;
    procedure ResetValues; virtual;
    procedure CalculateValues; virtual;
    procedure CalculateAverages; virtual;
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure PrintBodyLine(StrOperator, StrCheckOut : string); virtual;
    procedure PrintTableFooter; override;
    procedure Execute; override;
    //convert seconds to hh:mm:ss
    function ConvertTime(valTime : Real) : string; virtual;
  end;

var
  FrmDetCAPerformanceCaissiere: TFrmDetCAPerformanceCaissiere;

//******************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils, DFpnTradeMatrix;

{$R *.DFM}

//==============================================================================
// Source-identifiers
//==============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCAPerformanceCaissiere';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCAPerformanceCaissiere.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.5 $';
  CtTxtSrcDate    = '$Date: 2009/09/29 11:35:31 $';

//******************************************************************************
// Implementation of TFrmDetCAPerformanceCaissiere
//******************************************************************************

function TFrmDetCAPerformanceCaissiere.GetFmtTableHeader: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCAPerformanceCaissiere.GetFmtTableHeader
  Result := '<+' + IntToStr (CalcWidthText (16, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (16, False));
  if FlgNumTrans then
    for CntFmt := 0 to 7 do
      Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (12, False))
  else
    for CntFmt := 0 to 6 do
      Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (14, False));
end;   // of TFrmDetCAPerformanceCaissiere.GetFmtTableHeader

//==============================================================================

function TFrmDetCAPerformanceCaissiere.GetFmtTableBody: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCAPerformanceCaissiere.GetFmtTableBody
  Result := '<+' + IntToStr (CalcWidthText (16, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (16, False));
  if FlgNumTrans then
    for CntFmt := 0 to 7 do
      Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (12, False))
  else
    for CntFmt := 0 to 6 do
      Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (14, False));
end;   // of TFrmDetCAPerformanceCaissiere.GetFmtTableBody

//=============================================================================

function TFrmDetCAPerformanceCaissiere.GetTxtTableFooter : string;
begin  // of TFrmDetCAPerformanceCaissiere.GetTxtTableFooter
  Result := CtTxtTotal + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
            TxtSep + TxtSep + TxtSep + TxtSep + IntToStr(qtyTotalTrans);
end;   // of TFrmDetCAPerformanceCaissiere.GetTxtTableFooter

//==============================================================================

function TFrmDetCAPerformanceCaissiere.GetTxtTableTitle : string;
begin  // of TFrmDetCAPerformanceCaissiere.GetTxtTableTitle
  if FlgNumTrans then
    Result := CtTxtDescription + TxtSep + CtTxtCaisse +
                TxtSep + CtTxtTotal + TxtSep + CtTxtTEffectif + TxtSep +
                CtTxtTDiverses + TxtSep + CtTxtTdAttente + TxtSep +
                CtTxtTMisePause + TxtSep + CtTxtTClient + TxtSep + CtTxtTArticle +
                TxtSep + CtTxtTTrans
  else
    Result := CtTxtDescription + TxtSep + CtTxtCaisse +
                TxtSep + CtTxtTotal + TxtSep + CtTxtTEffectif + TxtSep +
                CtTxtTDiverses + TxtSep + CtTxtTdAttente + TxtSep +
                CtTxtTMisePause + TxtSep + CtTxtTClient + TxtSep + CtTxtTArticle;
end;   // of TFrmDetCAPerformanceCaissiere.GetTxtTableTitle)

//==============================================================================

function TFrmDetCAPerformanceCaissiere.GetTxtTitRapport : string;
begin  // of TFrmDetCAPerformanceCaissiere.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetCAPerformanceCaissiere.GetTxtTitRapport

//==============================================================================

function TFrmDetCAPerformanceCaissiere.GetTxtRefRapport : string;
begin  // of TFrmDetCAPerformanceCaissiere.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0004';
end;   // of TFrmDetCAPerformanceCaissiere.GetTxtRefRapport

//==============================================================================

procedure TFrmDetCAPerformanceCaissiere.Execute;
begin  // of TFrmDetCAPerformanceCaissiere.Execute
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;
  SprCAPerformanceCaissiere.Active := False;
  SprCAPerformanceCaissiere.ParamByName ('@PrmTxtSequence').AsString :=
      'IdtOperator';
  SprCAPerformanceCaissiere.ParamByName ('@PrmTxtFrom').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  SprCAPerformanceCaissiere.ParamByName ('@PrmTxtTo').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  SprCAPerformanceCaissiere.Active := True;
  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  if SprCAPerformanceCaissiere.RecordCount = 0 then
    VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite, clWhite, False)
  else
      PrintTableBody;
  if FlgNumTrans then
    PrintTableFooter;
  VspPreview.EndDoc;
  PrintPageNumbers;
  PrintReferences;
  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
  FrmVSPreview.OnActivate(Self);
end;   // of TFrmDetCAPerformanceCaissiere.Execute

//==============================================================================
// TFrmDetCAPerformanceCaissiere.ResetValues : Clear all total values
//==============================================================================

procedure TFrmDetCAPerformanceCaissiere.ResetValues;
begin  // of TFrmDetCAPerformanceCaissiere.ResetValues
  valTotal         := 0;
  valTempsEffectif := 0;
  valTempsDiverse  := 0;
  valTempsAttend   := 0;
  valTempsPauze    := 0;
  qtyClient        := 0;
  qtyArticle       := 0;
  qtyTransactions  := 0;
end;    // of TFrmDetCAPerformanceCaissiere.ResetValues

//==============================================================================
// TFrmDetCAPerformanceCaissiere.CalculateValues : Calculate all total values
//==============================================================================

procedure TFrmDetCAPerformanceCaissiere.CalculateValues;
begin  // of TFrmDetCAPerformanceCaissiere.CalculateValues
  valTotal         := valTotal +
    SprCAPerformanceCaissiere.FieldByName ('Total').AsFloat;
  valTempsEffectif := valTempsEffectif +
    SprCAPerformanceCaissiere.FieldByName ('TempsEffectif').AsFloat;
  valTempsDiverse  := valTempsDiverse +
    (SprCAPerformanceCaissiere.FieldByName ('Total').AsFloat -
     SprCAPerformanceCaissiere.FieldByName ('TempsEffectif').AsFloat -
     SprCAPerformanceCaissiere.FieldByName ('TempsAttend').AsFloat -
     SprCAPerformanceCaissiere.FieldByName ('TempsPause').AsFloat);
  valTempsAttend   := valTempsAttend +
    SprCAPerformanceCaissiere.FieldByName ('TempsAttend').AsFloat;
  valTempsPauze    := valTempsPauze +
    SprCAPerformanceCaissiere.FieldByName ('TempsPause').AsFloat;
  QtyClient        := qtyClient +
    SprCAPerformanceCaissiere.FieldByName ('qtyClient').AsFloat;
  qtyArticle       := qtyArticle +
    SprCAPerformanceCaissiere.FieldByName ('qtyArticle').AsFloat;
  qtyTransactions  := qtyTransactions +
    SprCAPerformanceCaissiere.FieldByName ('qtyPOSTrans').AsInteger;
end;    // of TFrmDetCAPerformanceCaissiere.CalculateValues

//==============================================================================
// TFrmDetCAPerformanceCaissiere.CalculateAverages : Calculate all averages
//==============================================================================

procedure TFrmDetCAPerformanceCaissiere.CalculateAverages;
begin  // of TFrmDetCAPerformanceCaissiere.CalculateAverages
  // Calculate average time per customer
  if qtyClient = 0 then
    valTempsClient  := 0
  else
    valTempsClient  := valTempsEffectif/qtyClient;
  // Calculate average time per article
  if qtyArticle = 0 then
    valTempsArticle  := 0
  else
    valTempsArticle  := valTempsEffectif/qtyArticle;
end;    // of TFrmDetCAPerformanceCaissiere.CalculateAverages

//==============================================================================
// TFrmDetCAPerformanceCaissiere.ConvertTime : Convert time in seconds to time
// in hh:mm:ss format
//                                  -----
// INPUT   : valTime : time in seconds
//==============================================================================

function TFrmDetCAPerformanceCaissiere.ConvertTime(valTime : Real) : string;
var
  valHoures    : Real;         // Variable to store houres
  valMinutes   : Real;         // Variable to store minutes
  valSeconds   : Real;         // Variable to store seconds
  valDivider   : Real;         // Divider to calculate timepart
begin   // of TFrmDetCAPerformanceCaissiere.ConverTime
  // Calculate houres
  valDivider   := valTime / 3600;
  valHoures    := trunc(valDivider);
  valTime := valTime - valHoures * 3600;
  // Calculate minutes
  valDivider   := valTime/60;
  valMinutes   := trunc(valDivider);
  // Calculate seconds
  valSeconds   := valTime - valMinutes * 60;
  // Fill string
  Result := FormatFloat(CtTxtFrmTime, valHoures) + ':' +
            FormatFloat(CtTxtFrmTime, valMinutes) + ':' +
            FormatFloat(CtTxtFrmTime, valSeconds);
end;    // of TFrmDetCAPerformanceCaissiere.ConverTime

//==============================================================================

procedure TFrmDetCAPerformanceCaissiere.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCAPerformanceCaissiere.PrintHeader
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
end;   // of TFrmDetCAPerformanceCaissiere.PrintHeader

//=============================================================================

procedure TFrmDetCAPerformanceCaissiere.PrintTableBody;
var
  StrCurrentOperator  : string;           // Current operator
  StrPreviousOperator : string;           // Previous operator
  StrCurrentCheckOut  : string;           // Current Check-out
  StrPreviousCheckOut : string;           // Previous Check-out
  StrFirstRecord      : string;           // First record check
begin  // of TFrmDetCAPerformanceCaissiere.PrintTableBody
  inherited;
  strFirstRecord := '';
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;
  // Initialize values
  ResetValues;
  qtyTotalTrans := 0;
  while not SprCAPerformanceCaissiere.Eof do begin
    StrCurrentOperator :=
       SprCAPerformanceCaissiere.FieldByName ('IdtOperator').AsString;
    StrCurrentCheckOut :=
       SprCAPerformanceCaissiere.FieldByName ('IdtCheckOut').AsString;
    if ((StrPreviousOperator = StrCurrentOperator)
    or (StrPreviousOperator = StrFirstRecord))
    and ((StrPreviousCheckOut = StrCurrentCheckOut)
    or (StrPreviousCheckOut = StrFirstRecord)) then
      // Calculate values
      CalculateValues
    else begin
      // Calculate averages
      CalculateAverages;
      // Print line
      PrintBodyLine(StrPreviousOperator, StrPreviousCheckOut);
      // Reset values
      ResetValues;
      // Calculate values
      CalculateValues
    end;
    StrPreviousOperator := StrCurrentOperator;
    StrPreviousCheckOut := StrCurrentCheckOut;
    SprCAPerformanceCaissiere.Next;
  end;
  // Handle last record
  if SprCAPerformanceCaissiere.Active
  and (SprCAPerformanceCaissiere.RecordCount > 0) then begin
    StrCurrentOperator :=
      SprCAPerformanceCaissiere.FieldByName ('IdtOperator').AsString;
    StrCurrentCheckOut :=
      SprCAPerformanceCaissiere.FieldByName ('IdtCheckOut').AsString;
    CalculateAverages;
    PrintBodyLine(strCurrentOperator, strCurrentCheckOut);
  end;
  VspPreview.EndTable;
end;   // of TFrmDetCAPerformanceCaissiere.PrintTableBody

//==============================================================================
// TFrmDetCAPerformanceCaissiere.PrintBodyLine : Print one line of the table
//                                  -----
// INPUT   : strOperator : operator of which the line needs to be printed
//           strCheckout : type of checkout on which the operator worked
//==============================================================================

procedure TFrmDetCAPerformanceCaissiere.PrintBodyLine(StrOperator,
                                                      StrCheckout : string);
var
  TxtPrintLine        : string;           // String to print
  CntIx               : Integer;          // Loop the operators in the Checklistbox
  FlgPrintLine        : boolean;          // Print detailline
begin  // of PrintBodyLine
  FlgPrintLine := False;
  if FlgNumTrans then begin
    for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
      if ChkLbxOperator.Checked [CntIx] and (StrOperator =
         IntToStr(Integer(ChkLbxOperator.Items.Objects[CntIx]))) then
        FlgPrintLine := True;
    end;
  end
  else
  FlgPrintLine := True;
  if FlgPrintLine then begin
    TxtPrintLine := CtTxtOperateur + ' ' + StrOperator  + TxtSep + StrCheckOut +
              TxtSep + ConvertTime(valTotal) + TxtSep +
              ConvertTime(valTempsEffectif) + TxtSep +
              ConvertTime(valTempsDiverse) + TxtSep +
              ConvertTime(valTempsAttend) + TxtSep + ConvertTime(valTempsPauze) +
              TxtSep + ConvertTime(valTempsClient) + TxtSep +
              ConvertTime(valTempsArticle) + TxtSep + IntToStr(qtyTransactions);
    VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                         clWhite, False);
    qtyTotalTrans := qtyTotalTrans +qtyTransactions;
  end;
end;    // of PrintBodyLine

//=============================================================================

procedure TFrmDetCAPerformanceCaissiere.PrintTableFooter;
begin  // of TFrmDetCAPerformanceCaissiere.PrintTableFooter
  VspPreview.Text := CRLF;
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;
  VspPreview.AddTable (FmtTableBody, '', TxtTableFooter, clWhite,
                       clWhite, False);
  VspPreview.EndTable;
end;   // of TFrmDetCAPerformanceCaissiere.PrintTableFooter

//==============================================================================

procedure TFrmDetCAPerformanceCaissiere.FormPaint(Sender: TObject);
begin  // of TFrmDetCAPerformanceCaissiere.FormPaint
  inherited;
  if not FlgNumTrans then
    BtnSelectAllClick(Self)
end;   // of TFrmDetCAPerformanceCaissiere.FormPaint

//==============================================================================

procedure TFrmDetCAPerformanceCaissiere.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetCAPerformanceCaissiere.BtnPrintClick
  Panel1.SetFocus;
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
  else if DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayto.Date := Now;
    MessageDlg(Format(CtTxtMaxDays,[IntToStr(CtMaxNumDays)]), mtWarning, [mbOK], 0);
  end
  else begin
   FlgPreview := (Sender = BtnPreview);
   Execute;
  end;
end;  // of TFrmDetCAPerformanceCaissiere.BtnPrintClick

//=============================================================================

procedure TFrmDetCAPerformanceCaissiere.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmDetCAPerformanceCaissiere.BeforeCheckRunParams
  inherited;
  // add param /VNT to help
  SplitString(CtTxtNumTrans, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmDetCAPerformanceCaissiere.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetCAPerformanceCaissiere.CheckAppDependParams(TxtParam: string);
begin  // of TFrmDetCAPerformanceCaissiere.CheckAppDependParams
  if Copy(TxtParam,3,2)= 'NT' then
    FlgNumTrans := True
  else
    inherited;
end;   // of TFrmDetCAPerformanceCaissiere.CheckAppDependParams

//==============================================================================

procedure TFrmDetCAPerformanceCaissiere.FormCreate(Sender: TObject);
begin // of TFrmDetCAPerformanceCaissiere.FormCreate
  inherited;
  if not FlgNumTrans then
    Self.Height := 188
  else
    Panel1.Height := Self.Height - 180;
end; // of TFrmDetCAPerformanceCaissiere.FormCreate

//==============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetCAPerformanceCaissiere
