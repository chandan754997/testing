//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint
// Customer : Castorama
// Unit     : FVSRptGenInvoices.PAS : base form for reports generated from
//            PRptGenInvoices application.
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptGenInvoices.pas,v 1.12 2009/09/28 13:16:16 BEL\KDeconyn Exp $
//=============================================================================

unit FVSRptGenInvoices;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfVSPrinter7, ActnList, ImgList, Menus, ExtCtrls, Buttons, OleCtrls,
  SmVSPrinter7Lib_TLB, ComCtrls, DB, MMntInvoice, FVSRptInvoiceCA, IniFiles;

//*****************************************************************************
// Global definitions
//*****************************************************************************

const
  ViTxtFmtPrice    : string  = '%8.2f';     // Format Price

(*

  Page printing flow:

  - PrepareReport() is the main method for generating the report to be called
    externally.
  - GenerateReport() is the main loop to generate the report from ticket info.
  - CheckStartNewPage() indicates if the body table is "full" and a new page
    needs to be started.
  - InitialisePage() initialised a new page for printing, and is called from
    the VspPreview.OnNewPage() event.
  - FinalisePage() finalised the page, and is called from the
    VspPreview.OnBeforeFooter() event when a new page is begun.
  - InitialiseBody() initialised the body table for the detail lines, and is
    called from InitialisePage().
  - FinaliseBody() finalised the body table (e.g. for subtotal generation) and
    is called from FinalisePage().

*)

type

  TObjRetourPayment       = class
  private
    FNumPriority        : integer;
    FValInclVAT         : Double;
  public
    //Properties
    property NumPriority: integer read FNumPriority write FNumPriority;
    property ValInclVAT: Double read FValInclVAT write FValInclVAT;
  end;

  TFrmVSRptGenInvoices = class(TFrmVSPreview)
    DscTicket: TDataSource;
    DscPOSTransDetail: TDataSource;
    procedure VspPreviewNewPage(Sender: TObject);
    procedure VspPreviewBeforeFooter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    // Interal housekeeping properties
    ValTransTotInclVAT : Double;       // Subtotal ValInclVAT for report.
    StrLstBodyTable    : TStringList;  // Stringlist with detail table.
    LstTransTicket     : TList;        // List of ObjTransTicket objects
    ArrCodActPrintable : array of Integer; // Set with actions to print in body

    // Max. height of the body table. This is the actual height of the
    // rectangle used for the body part, independant of the current position
    // on the page.
    // This value is used to determine if a new page has to be started.
    ValMaxHeightBody  : Integer;

    // Properties to be printed on the report.
    FTxtCompanyName   : string;
    FTxtCustName      : string;
    FTxtCustAddress   : string;
    FNumCustomer      : Integer;
    FValSubTotal      : Double;
    FTxtUsername      : string;        // Username of user printing the report.
    FValTotalRetour   : double;

    FValGlobalTotal   : Double;
    FlgGlobalTotalCalc: Boolean;       // Indicates if global total has been calculated.
    // Indicates if a new page has been forced, meaning there are more pages to come.
    FlgForcedNewPage  : Boolean;

    FLstRetourPayments : TList;

    procedure GetPOSTransactionData; virtual;
    function GetTransTicket (IdtPOSTransaction,
                             IdtCheckout,
                             CodTrans          : Integer;
                             DatTransBegin     : TDatetime):
                                                    TObjTransTicketCA; virtual;
    procedure GetRetourPayments (IdtPOSTransaction,
                                IdtCheckout       : integer;
                                DatTransBegin     : TDatetime;
                                LstRetourPayments : TList); virtual;
    procedure AddRefundTickets (IdtPOSTransaction,
                                IdtCheckout,
                                CodTrans          : Integer;
                                DatTransBegin     : TDatetime);


    procedure GenerateHeader; virtual;
    procedure GenerateReport; virtual;

    procedure InitIniParam (IniFile: TIniFile; TxtIniSection: string); virtual;

    procedure InitialiseReport; virtual;
    procedure InitialisePage; virtual;
    procedure FinalisePage; virtual;
    procedure FinaliseReport; virtual;

    procedure InitialiseBody; virtual;
    procedure FinaliseBody; virtual;

    procedure AddTableLine(TxtFormat, TxtBody: WideString);

    procedure PrintTicketLine (ObjTransTicket: TObjTransTicketCA;
                               FlgStart: Boolean); virtual;
    procedure PrintTransactionLine (ObjTrans: TObjTransactionCA); virtual;

    procedure UpdateTransStats (ObjTrans : TObjTransactionCA); virtual;
    function IsTransPrintable (ObjTrans: TObjTransactionCA): Boolean; virtual;

    function GetGlobalTotal: Double;

    //*** Abstract methods ***//
    // Formatting methods for article detail lines of printed tickets in main
    // detail table on report.
    function GetTransFmtLine: string; virtual; abstract;
      // Returns VSP formatting string for table row layout
    function GetTransBodyLine (ObjTrans: TObjTransactionCA): string; virtual;
                                                                     abstract;
      // Returns VSP string for actual transaction data

    // Formatting methods for "ticket lines", or ticket breaks when printing
    // the detail body table of the report.
    function
    GetTicketBodyLine (ObjTransTicket: TObjTransTicketCA;
                                FlgStart      : Boolean) : string; virtual;
                                                                   abstract;
      // Returns VSP string for actual transaction data

    function CheckStartNewPage: Boolean; virtual;
      // Determines if a new page has to be started.

    procedure AddPrintableActions (const ArrCodAction : array of Integer);
                                                                      virtual;

    property ValGlobalTotal : Double read GetGlobalTotal;

      // Global total for all tickets

  public
    { Public declarations }

    property TxtUsername : string read  FTxtUsername
                                  write FTxtUsername;
    property TxtCompanyName   : string read  FTxtCompanyName
                                       write FTxtCompanyName;
    property TxtCustName : string read  FTxtCustName
                                  write FTxtCustName;
    property TxtCustAddress : string read  FTxtCustAddress
                                     write FTxtCustAddress;
    property NumCustomer : Integer read  FNumCustomer
                                   write FNumCustomer;
    property ValSubTotal : Double read FValSubTotal
                                 write FValSubTotal;
    property LstRetourPayments : TList read FLstRetourPayments
                                      write FLstRetourPayments;
    property ValTotalRetour : double read FValTotalRetour
                                    write FValTotalRetour;
    procedure PrepareReport; virtual;

    procedure InitFromIni (TxtIniFile: string; TxtIniSection: string); virtual;

    property TransFmtLine : string read GetTransFmtLine;
  end;

var
  FrmVSRptGenInvoices: TFrmVSRptGenInvoices;

//*****************************************************************************

implementation

uses
  SfDialog,

  SmUtils,

  DFpnPosTransAction,
  DFpnPosTransActionCA,
  DFpnInvoice,
  DFpnInvoiceCA, 
  DFpnUtils;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: ';
  CtTxtSrcVersion = '$Revision: 1.12 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 13:16:16 $';

//*****************************************************************************
// Implementation of FVSRptGenInvoices
//*****************************************************************************

{ TFrmVSRptGenInvoices }

//=============================================================================
// TFrmVSRptGenInvoices.PrepareReport: prepares and generates report.
//=============================================================================

procedure TFrmVSRptGenInvoices.PrepareReport;
begin  // of TFrmVSRptGenInvoices.PrepareReport
  if DscTicket.DataSet = nil then
    Raise Exception.Create('Dataset with ticket info not initialised.');

  DscTicket.DataSet.DisableControls;
  InitialiseReport;
  try
    VspPreview.StartDoc;
    GenerateReport;
    FinaliseReport;
  finally
    //VspPreview.EndDoc;
    DscTicket.DataSet.EnableControls;
  end;
end;  // of TFrmVSRptGenInvoices.PrepareReport

//=============================================================================
// TFrmVSRptGenInvoices.AddRefundTickets
//=============================================================================

procedure TFrmVSRptGenInvoices.AddRefundTickets(IdtPOSTransaction,
                                                IdtCheckout,
                                                CodTrans          : Integer;
                                                DatTransBegin     : TDatetime);
var
  ObjTransTick     : TObjTransTicketCA;
  IxTrans          : Integer;
  IxNumLine        : Integer;
  ObjCurrTrans     : TObjTransactionCA; // Current transaction object.
  IdtPosTransCurr  : Integer;
  LstNumLineReg    : TList;
  FlgDeleteTrans   : Boolean;
begin  // of TFrmVSRptGenInvoices.AddRefundTickets
  if assigned(LstRetourPayments) then begin
    LstRetourPayments.Free;
    LstRetourPayments := nil;
  end;
  LstRetourPayments := TList.Create;
  DmdFpnPosTransactionCA.QryLstPosTransaction.Active := False;
  DmdFpnPosTransactionCA.QryLstPosTransaction.SQL.Text :=
    DmdFpnPosTransactionCA.BuildSQLForRefundTickets (
      DmdFpnUtils.IdtTradeMatrixAssort, IdtPOSTransaction, IdtCheckout,
      CodTrans, DatTransBegin);
  try
    DmdFpnPosTransactionCA.QryLstPosTransaction.Active := True;
    repeat
      with DmdFpnPosTransactionCA.QryLstPosTransaction do begin
        ObjTransTick := GetTransTicket(
                                FieldByName ('IdtPosTransaction').AsInteger,
                                FieldByName ('IdtCheckout').AsInteger,
                                FieldByName ('CodTrans').AsInteger,
                                FieldByName ('DatTransBegin').AsDateTime);

        GetRetourPayments(
                    FieldByName ('IdtPosTransaction').AsInteger,
                    FieldByName ('IdtCheckout').AsInteger,
                    FieldByName ('DatTransBegin').AsDateTime,
                    LstRetourPayments);
        IdtPosTransCurr := FieldByName ('IdtPosTransaction').AsInteger;
        LstNumLineReg := TList.Create();
        // Get all refund lines for the current ticket.
        while not Eof and (FieldByName ('IdtPosTransaction').AsInteger =
                           IdtPosTransCurr) do begin
          LstNumLineReg.Add (TObject(FieldByName ('NumLineReg').AsInteger));
          Next;
        end;
        // Filter refund transactions for current ticket.
        for IxTrans := ObjTransTick.StrLstObjTransaction.Count-1 downto 0 do begin
          ObjCurrTrans :=
            TObjTransactionCA (ObjTransTick.StrLstObjTransaction.Objects[IxTrans]);
          FlgDeleteTrans := True;
          if (ObjCurrTrans.CodActTakeBack = CtCodActTakeBack) then begin
            for IxNumLine := 0 to LstNumLineReg.Count-1 do
              if Integer(LstNumLineReg[IxNumLine]) =
                   ObjCurrTrans.NumLineReg then begin
                FlgDeleteTrans := False;
                break;
              end;
          end;
          if FlgDeleteTrans then
            ObjTransTick.StrLstObjTransaction.Delete(IxTrans);
        end;
        for IxTrans := ObjTransTick.StrLstObjTransaction.Count-1 downto 0 do begin
          ObjCurrTrans :=
            TObjTransactionCA (ObjTransTick.StrLstObjTransaction.Objects[IxTrans]);
          if (ObjCurrTrans.CodActTakeBack = CtCodActTakeBack) then begin
            ValTotalRetour := ValTotalRetour + ABS(ObjCurrTrans.ValInclVAT);
          end;
        end;
      end;
      if ObjTransTick.StrLstObjTransaction.Count = 0 then
        ObjTransTick.Free
      else
        LstTransTicket.Add (ObjTransTick);
    until DmdFpnPosTransactionCA.QryLstPosTransaction.Eof
  finally
    DmdFpnPosTransactionCA.QryLstPosTransaction.Active := False;
  end
end;  // of TFrmVSRptGenInvoices.AddRefundTickets

//=============================================================================
// TFrmVSRptGenInvoices.GetTransTicket: get the initialised ticket object
//   for the given ticket.
//=============================================================================

function TFrmVSRptGenInvoices.GetTransTicket (
                              IdtPOSTransaction : Integer;
                              IdtCheckout       : Integer;
                              CodTrans          : Integer;
                              DatTransBegin     : TDatetime): TObjTransTicketCA;
begin  // of TFrmVSRptGenInvoices.GetTransTicket
  Result := TObjTransTicketCA.Create();
  Result.IdtPOSTransaction := IdtPosTransaction;
  Result.IdtCheckOut := IdtCheckout;
  Result.CodTrans := CodTrans;
  Result.DatTransBegin := DatTransBegin;
  // Get POS transaction detail info for ticket
  DscPOSTransDetail.DataSet.Active := False;
  DmdFpnInvoiceCA.BuildPOSTransDetail
      (DmdFpnInvoiceCA.QryPOSTransDetail,
       IdtPosTransaction, IdtCheckout, CodTrans, DatTransBegin);
  // Fill transaction detail data in TransTick object
  DscPOSTransDetail.DataSet.Active := True;
  Result.FillTransactions (DscPOSTransDetail.DataSet);
end;   // of TFrmVSRptGenInvoices.GetTransTicket

//=============================================================================
// TFrmVSRptGenInvoices.GetRetourPayments: get the payment methods for
//                                         the given return ticket.
//=============================================================================

procedure TFrmVSRptGenInvoices.GetRetourPayments (IdtPOSTransaction,
                                                  IdtCheckout : integer;
                                                  DatTransBegin     : TDatetime;
                                                  LstRetourPayments : TList);
var
  ObjRetourPayment : TObjRetourPayment;
begin  // of TFrmVSRptGenInvoices.GetRetourPayments
  try
    if DmdFpnUtils.QueryInfo(
            'SELECT NumPriority, ValInclVAT = SUM(ValInclVAT)' +
         #10'FROM (SELECT NumPriority = CASE' +
         #10'         WHEN CodAction IN (23, 66) THEN ''1''' +
         #10'         WHEN CodAction IN (31, 32, 33, 40, 41, 49, 50, 116, 149) THEN ''2''' +
         #10'         WHEN CodAction IN (15, 18, 155) THEN ''3''' +
         #10'         WHEN CodAction IN (29, 30) THEN ''4''' +
         #10'         WHEN CodAction IN (24) THEN ''5''' +
         #10'         WHEN CodAction IN (151) THEN ''6''' +
         #10'         WHEN CodAction IN (25, 145) THEN ''7''' +
         #10'         ELSE ''8''' +
         #10'       END,' +
         #10'       ValInclVAT = CASE' +
         #10'         WHEN QtyLine < 0 THEN QtyLine * ValInclVAT' +
         #10'         ELSE ValInclVAT' +
         #10'       END' +
         #10'FROM POSTransDetail' +
         #10'WHERE CodType = 201' +
         #10'AND IdtPOSTransaction = ' + IntToStr(IdtPOSTransaction) +
         #10'AND IdtCheckOut = ' + IntToStr(IdtCheckOut) +
         #10'AND DatTransBegin > ' +
            QuotedStr(FormatDateTime('YYYYMMDD', DatTransBegin)) + ') AS T' +
         #10'GROUP BY NumPriority') then begin
      DmdFpnUtils.QryInfo.First;
      while not DmdFpnUtils.QryInfo.Eof do begin
        ObjRetourPayment := TObjRetourPayment.Create;
        ObjRetourPayment.NumPriority :=
                      DmdFpnUtils.QryInfo.FieldByName('NumPriority').AsInteger;
        ObjRetourPayment.ValInclVAT :=
                      DmdFpnUtils.QryInfo.FieldByName('ValInclVAT').AsFloat;
        LstRetourPayments.Add(ObjRetourPayment);
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptGenInvoices.GetRetourPayments

//=============================================================================
// TFrmVSRptGenInvoices.GetPOSTransactionData: get POSTranscation data from
//  DB for the requested tickets.
//=============================================================================

procedure TFrmVSRptGenInvoices.GetPOSTransactionData;
var
  ObjTransTick     : TObjTransTicketCA;
begin  // of TFrmVSRptGenInvoices.GetPOSTransactionData;
  DscTicket.DataSet.First;
  DscPOSTransDetail.DataSet := DmdFpnInvoiceCA.QryPOSTransDetail;
  while not DscTicket.DataSet.Eof do begin
    // Initialise TransTick object
    ObjTransTick := GetTransTicket (
         DscTicket.DataSet.FieldByName ('IdtPOSTransaction').AsInteger,
         DscTicket.DataSet.FieldByName ('IdtCheckout').AsInteger,
         DscTicket.DataSet.FieldByName ('CodTrans').AsInteger,
         DscTicket.DataSet.FieldByName ('DatTransBegin').AsDateTime);
    DscPOSTransDetail.DataSet.Active := False;
    //ObjTransTick.PurgeTransactions;
    LstTransTicket.Add (ObjTransTick);

    if DscTicket.DataSet.FieldByName ('FlgRefundTickets').AsBoolean then begin
      // Get refund ticket data, and add it to the list.
      AddRefundTickets (
         DscTicket.DataSet.FieldByName ('IdtPOSTransaction').AsInteger,
         DscTicket.DataSet.FieldByName ('IdtCheckout').AsInteger,
         DscTicket.DataSet.FieldByName ('CodTrans').AsInteger,
         DscTicket.DataSet.FieldByName ('DatTransBegin').AsDateTime);
    end;

    DscTicket.DataSet.Next;
  end;
  FlgGlobalTotalCalc := False;
end;   // of TFrmVSRptGenInvoices.GetPOSTransactionData;

//=============================================================================
// TFrmVSRptGenInvoices.GenerateReport: generates report.
//=============================================================================

procedure TFrmVSRptGenInvoices.GenerateReport;
var
  CntTicket        : Integer;
  CntTrans         : Integer;
  ObjTransTick     : TObjTransTicketCA;
begin  // of TFrmVSRptGenInvoices.GenerateReport
  for CntTicket := 0 to LstTransTicket.Count - 1 do begin
    ObjTransTick := LstTransTicket.Items [CntTicket];
    PrintTicketLine (ObjTransTick, True);
    for CntTrans := 0 to ObjTransTick.StrLstObjTransaction.Count - 1 do begin
      PrintTransactionLine
      (TObjTransactionCA (ObjTransTick.StrLstObjTransaction.Objects[CntTrans]));
    end;
    PrintTicketLine (ObjTransTick, False);
  end;
end;   // of TFrmVSRptGenInvoices.GenerateReport

//=============================================================================
// TFrmVSRptGenInvoices.InitialiseBody: initialises page body/detail section.
//=============================================================================

procedure TFrmVSRptGenInvoices.InitialiseBody;
begin  // of TFrmVSRptGenInvoices.InitialiseBody
  StrLstBodyTable.Clear;
 // VspPreview.StartTable;
end;   // of TFrmVSRptGenInvoices.InitialiseBody

//=============================================================================
// TFrmVSRptGenInvoices.FinaliseBody: finalises the body section.
//=============================================================================

procedure TFrmVSRptGenInvoices.FinaliseBody;
begin  // of TFrmVSRptGenInvoices.FinaliseBody
 // VspPreview.EndTable;
end;   // of TFrmVSRptGenInvoices.FinaliseBody

//=============================================================================
// TFrmVSRptGenInvoices.InitialiseReport: report initialisation.
//=============================================================================

procedure TFrmVSRptGenInvoices.InitialiseReport;
begin  // of TFrmVSRptGenInvoices.InitialiseReport
  FlgGlobalTotalCalc := False;
  ValMaxHeightBody   := 9999;
  // Force footer creation by setting property to a non blank value.
  // This is necessary to force footer event to trigger, and thus call the
  // finalisation code for the page.
  VspPreview.Footer := ' ';

  GetPOSTransactionData;
  AddPrintableActions ([CtCodActPLUNum, CtCodActPLUKey, CtCodActClassNum,
                        CtCodActClassKey, CtCodActPayAdvance,
                        CtCodActTakeBackAdvance, CtCodActChangeAdvance]);
  ValTransTotInclVAT := 0;
end;   // of TFrmVSRptGenInvoices.InitialiseReport

//=============================================================================
// TFrmVSRptGenInvoices.FinaliseReport: report finalisation
//=============================================================================

procedure TFrmVSRptGenInvoices.FinaliseReport;
begin  // of TFrmVSRptGenInvoices.FinaliseReport
  // This can be used to print n/m pages using overlays etc.
  VspPreview.EndDoc;
end;  // of TFrmVSRptGenInvoices.FinaliseReport

//=============================================================================
// TFrmVSRptGenInvoices.InitialisePage: initialises the curent report page.
//=============================================================================

procedure TFrmVSRptGenInvoices.InitialisePage;
begin  // of TFrmVSRptGenInvoices.InitialisePage
  GenerateHeader;
  InitialiseBody;
  FlgForcedNewPage := False;
end;   // of TFrmVSRptGenInvoices.InitialisePage

//=============================================================================
// TFrmVSRptGenInvoices.FinalisePage: finalises the current report page.
//=============================================================================

procedure TFrmVSRptGenInvoices.FinalisePage;
begin  // of TFrmVSRptGenInvoices.FinalisePage
  FinaliseBody;
end;   // of TFrmVSRptGenInvoices.FinalisePage

//=============================================================================
// TFrmVSRptGenInvoices.GenerateHeader: generates the report page header.
//=============================================================================

procedure TFrmVSRptGenInvoices.GenerateHeader;
begin  // of TFrmVSRptGenInvoices.GenerateHeader
  // Can be implemented in inheriting classes
end;   // of TFrmVSRptGenInvoices.GenerateHeader

//=============================================================================
// TFrmVSRptGenInvoices.AddTableLine: add a line to the body/detail table.
//                                     ---
// INPUT  : TxtFormat = VSPrinter AddTable() format string.
//          TxtBody   = actual body content to be printed.
//=============================================================================

procedure TFrmVSRptGenInvoices.AddTableLine (TxtFormat: WideString;
                                             TxtBody: WideString);
begin  // of TFrmVSRptGenInvoices.AddTableLine
  StrLstBodyTable.Add (TxtBody);
  VspPreview.AddTable (TxtFormat, '', TxtBody, clWhite, clWhite, False);
  if CheckStartNewPage then begin
    // NewPage will trigger Initialise & FinaliseBody methods in
    // VspPreview OnBeforeFooter and OnNewPage events.
    FlgForcedNewPage := True;
    VspPreview.NewPage;
  end;
end;   // of TFrmVSRptGenInvoices.AddTableLine

//=============================================================================
// TFrmVSRptGenInvoices.PrintTicketLine: print a ticket begin or end line.
//   These lines are printed before or after the ticket body data lines.
//                                     ---
// INPUT  : ObjTransTicket = ticket object to print a line for.
//          FlgStart       = true if we are at the start of a ticket data.
//=============================================================================

procedure TFrmVSRptGenInvoices.PrintTicketLine(ObjTransTicket: TObjTransTicketCA;
                                               FlgStart: Boolean);
var
  TxtBody          : string;
begin  // of TFrmVSRptGenInvoices.PrintTicketLine
  TxtBody := GetTicketBodyLine(ObjTransTicket, FlgStart);
  if TxtBody <> '' then
    AddTableLine (TransFmtLine, TxtBody);
end;   // of TFrmVSRptGenInvoices.PrintTicketLine

//=============================================================================
// GetGlobalTotal: calculate global total for all tickets
//=============================================================================

function TFrmVSRptGenInvoices.GetGlobalTotal: Double;
var
  CntTicket        : Integer;
begin  // of TFrmVSRptGenInvInvoice.GetGlobalTotal
  if not FlgGlobalTotalCalc then begin
    FValGlobalTotal := 0;
    for CntTicket := 0 to LstTransTicket.Count - 1 do begin
      FValGlobalTotal := FValGlobalTotal +
        TObjTransTicketCA (LstTransTicket.Items [CntTicket]).GetTicketTotal +
        TObjTransticketCA (LstTransTicket.Items [CntTicket]).GetDepositTotal;
    end;
    FlgGlobalTotalCalc := True;
  end;
  Result := FValGlobalTotal;
end;   // of TFrmVSRptGenInvoices.GetGlobalTotal

//=============================================================================
// TFrmVSRptGenInvoices.CheckStartNewPage: checks if a new page has to be
//   started.
//=============================================================================

function TFrmVSRptGenInvoices.CheckStartNewPage: Boolean;
var
  TxtTable : string;
  CntStr   : integer;
begin  // of TFrmVSRptGenInvoices.CheckStartNewPage
  TxtTable := TransFmtLine + SepRow;
  for CntStr := 0 to StrLstBodyTable.Count -1 do
    TxtTable := TxtTable + StrLstBodyTable.Strings[CntStr] + SepRow;
  VspPreview.CalcTable := TxtTable;
  Result := (VspPreview.Y2-VspPreview.Y1) >= ValMaxHeightBody;
end;   // of TFrmVSRptGenInvoices.CheckStartNewPage

//=============================================================================
// TFrmVSRptGenInvoices.UpdateTransStats: updates subtotal count for the
//   transactions printed in the detail lines on the report.
//                                     ---
// INPUT  : ObjTrans = transaction object.
//=============================================================================

procedure TFrmVSRptGenInvoices.UpdateTransStats(ObjTrans: TObjTransactionCA);
begin  // of TFrmVSRptGenInvoices.UpdateTransStats
  if ObjTrans.CodMainAction in [CtCodActPayAdvance,
                                   CtCodActChangeAdvance,
                                   CtCodActPayForfait] then
    ValTransTotInclVAT := ValTransTotInclVAT - ObjTrans.GetSalesValue
  else
    ValTransTotInclVAT := ValTransTotInclVAT + ObjTrans.GetSalesValue;
end;   // of TFrmVSRptGenInvoices.UpdateTransStats

//=============================================================================
// TFrmVSRptGenInvoices.PrintTransactionLine: print a transaction line using
//   a given transaction object.
//                                     ---
// INPUT  : ObjTrans = transaction object.
//=============================================================================

procedure TFrmVSRptGenInvoices.PrintTransactionLine(ObjTrans: TObjTransactionCA);
begin  // of TFrmVSRptGenInvoices.PrintTransactionLine
  if IsTransPrintable (ObjTrans) then begin
    UpdateTransStats (ObjTrans);
    AddTableLine (TransFmtLine, GetTransBodyLine (ObjTrans));
  end;
end;   // of TFrmVSRptGenInvoices.PrintTransactionLine

//=============================================================================
// TFrmVSRptGenInvoices.IsTransPrintable: checks if a ticket transaction has
//   to be printed for the current report.
//                                     ---
// INPUT  : ObjTrans = transaction object.
//=============================================================================

function TFrmVSRptGenInvoices.IsTransPrintable(ObjTrans: TObjTransactionCA):
                                                                        Boolean;
var
  CntAction        : Integer;
begin  // of TFrmVSRptGenInvoices.IsTransPrintable
  Result := False;
  for CntAction := 0 to High (ArrCodActPrintable) do
    if ObjTrans.CodMainAction = ArrCodActPrintable[CntAction] then begin
      Result := True;
      Break;
    end;
  if not Result then begin
    if (ObjTrans.CodActComment <> 0) and
       (ObjTrans.CodType = CtCodPdtCommentArtInfoCustOrder) then
      Result := True;
  end;
  if Result then
    Result := not ObjTrans.PurgeMe;
end;   // of TFrmVSRptGenInvoices.IsTransPrintable

//=============================================================================
// TFrmVSRptGenInvoices.AddPrintableActions: add actions to the list of print-
//   able actions for the report body.
//                                     ---
// INPUT  : ArrCodAction = array containing action codes to print the body.
//=============================================================================

procedure TFrmVSRptGenInvoices.AddPrintableActions(
                                         const ArrCodAction: array of Integer);
var
  NumOrigLen       : Integer;
  CntAction        : Integer;
begin  // of TFrmVSRptGenInvoices.AddPrintableActions
  NumOrigLen := Length (ArrCodActPrintable);
  SetLength (ArrCodActPrintable, NumOrigLen + Length (ArrCodAction));
  for CntAction := 0 to High (ArrCodAction) do
    ArrCodActPrintable [NumOrigLen + CntAction] := ArrCodAction [CntAction];
end;   // of TFrmVSRptGenInvoices.AddPrintableActions

//*****************************************************************************
// FORM EVENTS
//*****************************************************************************

procedure TFrmVSRptGenInvoices.FormCreate(Sender: TObject);
begin  // of TFrmVSRptGenInvoices.FormCreate
  inherited;

  StrLstBodyTable    := TStringList.Create();
  LstTransTicket     := TList.Create();
end;   // of TFrmVSRptGenInvoices.FormCreate

//=============================================================================

procedure TFrmVSRptGenInvoices.FormDestroy(Sender: TObject);
begin  // of TFrmVSRptGenInvoices.FormDestroy
  inherited;

  StrLstBodyTable.Free();
  LstTransTicket.Free();
end;   // of TFrmVSRptGenInvoices.FormDestroy

//=============================================================================

procedure TFrmVSRptGenInvoices.VspPreviewBeforeFooter(Sender: TObject);
begin  // of TFrmVSRptGenInvoices.VspPreviewBeforeFooter
  FinalisePage;
end;    // of TFrmVSRptGenInvoices.VspPreviewBeforeFooter

//=============================================================================

procedure TFrmVSRptGenInvoices.VspPreviewNewPage(Sender: TObject);
begin  // of TFrmVSRptGenInvoices.VspPreviewNewPage
  InitialisePage;
end;   // of TFrmVSRptGenInvoices.VspPreviewNewPage

//=============================================================================

procedure TFrmVSRptGenInvoices.InitFromIni (TxtIniFile   : string;
                                            TxtIniSection: string);
var
  IniFile          : TIniFile;         // IniObject to the INI-file
begin  // of TFrmVSRptGenInvoices.InitFromIni
  IniFile := nil;
  if FileExists(TxtIniFile) then begin
    try
      if OpenIniFile (TxtIniFile, IniFile) then
        InitIniParam (IniFile, TxtIniSection);
    finally
      IniFile.Free;
      IniFile := nil;
    end;
  end;
end;   // of TFrmVSRptGenInvoices.InitFromIni

//=============================================================================

procedure TFrmVSRptGenInvoices.InitIniParam (IniFile      : TIniFile;
                                             TxtIniSection: string);
var
  StrIni           : TStringList;
begin  // of TFrmVSRptGenInvoices.InitIniParam
  StrIni := TStringList.Create();
  IniFile.ReadSectionValues(TxtIniSection, StrIni);
  if IniFile.ValueExists (TxtIniSection, 'ReportMargin') then begin
    // Set the margin from the ini file.
    VspPreview.MarginLeft := StrIni.Values['ReportMargin'];
  end;
  StrIni.Free;
end;   // of TFrmVSRptGenInvoices.InitIniParam

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                               CtTxtSrcDate);
end.   // of FVSRptGenInvoices

