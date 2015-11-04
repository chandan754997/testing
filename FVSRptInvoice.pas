//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint
// Unit   : FVSRptInvoice = Form VideoSoft RePorT Invoice
// Customer : Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// History:
// - Started from Castorama - Flexpoint 2.0 - FVsRptInvoice - CVS revision 1.1
// Version ModifiedBy Reason
// 1.6     ARB        Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5
// 1.7     ARB        Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.1
// 1.8     Med  (TCS) R2014.1.Req(45010).ALLOPCO.Improved-Invoice-Address-For-Duplication.
//=============================================================================

unit FVSRptInvoice;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfVSPrinter7, ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ToolWin, MMntInvoice, Db, ExtCtrls;

//=============================================================================
// Global definitions
//=============================================================================

var
  NumBodyRow            : Integer = 42;
  ViValSizeTitMatrix    : Integer = 10;
  ViValSizeMatrix       : Integer = 9;
  ViValSizeDocKind      : Integer = 15;
  ViValSizeDuplicate    : Integer = 10;
  ViValSizeBody         : Integer = 8;
  ViValSizeTitDeliv     : Integer = 10;
  ViValSizeDeliv        : Integer = 9;
  ViValSizeTitInvoice   : Integer = 10;
  ViValSizeInvoice      : Integer = 9;

var    // Column-width (in number of characters)
  ViValRptWidthDescr    : Integer = 30;// Width columns description
  ViValRptWidthQty      : Integer = 10;// Width columns quantity
  ViValRptWidthUnit     : Integer = 11;// Width columns unit price
  ViValRptWidthVal      : Integer = 11;// Width columns amount
  ViValRptWidthPrcDisc  : Integer = 11;// Width columns unit discount
  ViValRptWidthValDisc  : Integer = 11;// Width columns amount discount
  ViValRptWidthTotVal   : Integer = 11;// Width columns total amount
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5

  ViValCiRptWidthTotVal : Integer = 17;// Width columns total amount Client Intracom
  ViValRptWidthVATCod   : Integer = 6; // Width columns VAT Code

  ViValRptWidthVATDescr : Integer = 11;// Width columns VAT Description
  ViValRptWidthVATExcl  : Integer = 11;// Width columns VAT Total Excl VAT
  ViValRptWidthVATTot   : Integer = 11;// Width columns Total VAT
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5 15 TO 25
  ViValRptWidthPayDescr : Integer = 25;// Width columns Description payment
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  ViValCiRptWidthPayDescr:Integer = 19;//Width columns Description payment for Client Intracom
  ViValRptWidthPayAmount: Integer = 10;// Width columns Amount payment
  ViValRptWidthPayCur   : Integer = 5; // Width columns Description payment

var
  ViValRptMatrixPosX    : Integer = 500;    // X position of Tradematrix info
  ViValRptMatrixPosY    : Integer = 500;    // Y position of Tradematrix info

  ViValRptDocKindPoxX   : Integer = 6000;   // X position of Doc kind
  ViValRptDocKindPoxY   : Integer = 1000;   // Y position of Doc kind

  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.1
  ViValCiRptDocKindPoxX   : Integer = 5000;   // X position of Doc kind for Client Intracom
  ViValCiRptDocKindPoxY   : Integer = 1000;   // Y position of Doc kind for Client Intracom
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

  ViValRptDupliPoxX     : Integer = 6000;   // X position of Duplicate
  ViValRptDupliPoxY     : Integer = 1300;   // Y position of Duplicate

  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.1
  ViValCiRptDupliPoxX     : Integer = 5000;   // X position of Duplicate for Client Intracom
  ViValCiRptDupliPoxY     : Integer = 1300;   // Y position of Duplicate for Client Intracom
   // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

  ViValRptDelivPosX     : Integer = 500;    // X position of Delivery note
  ViValRptDelivPosY     : Integer = 3000;   // Y position of Delivery note

  ViValRptInvoicePosX   : Integer = 6000;   // X position of Invoice info
  ViValCiRptInvoicePosX : Integer = 500;    // X position of Invoice Note for Client Intracom
  ViValRptInvoicePosY   : Integer = 3000;   // Y position of Invoice info

  ViValRptBodyPoxX      : Integer = 500;    // X position of Body table
  ViValRptBodyPoxY      : Integer = 4500;   // Y position of Body table

  ViValRptVATPosX       : Integer = 500;    // X position of VAT table
  ViValRptVATPosY       : Integer = 11300;  // Y position of VAT table

  ViValRptPaymentPosX   : Integer = 5000;   // X position of Payment table
  ViValRptPaymentPosY   : Integer = 11300;  // Y position of Payment table
  ViValRptPayRectWidth  : Integer = 3100;   // Width of Payment table

  ViValRptRemarquePosX  : Integer = 500;    // X position of Remarque
  ViValRptRemarquePosY  : Integer = 13700;  // Y position of Remarque
  ViValRptRemarqueWidth : Integer = 10950;  // Width of remarque box
  ViValRptRemarqueHeight: Integer = 1850;   // Height of remarque box

  ViValRptSpaceBtwRect  : Integer = 100;    // Space between the rectangles

var
  ViValColorBodyTitle   : TColor  = clLtGray;    // Title of the body
  ViValColorVatTitle    : TColor  = clLtGray;    // Title of the VAT codes

//=============================================================================
// Resources - Labels on the rapport
//=============================================================================

resourcestring
  CtTxtHdrDescription   = 'Description';
  CtTxtHdrQty           = 'Qty';
  CtTxtHdrUnitPrice     = 'Price';
  CtTxtHdrVal           = 'Amount';
  CtTxtHdrValWoVat      = 'Amount Excl. Tax';  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  CtTxtHdrPrcDisc       = 'Prc Discount';
  CtTxtHdrDisc          = 'Discount';
  CtTxtHdrTotVal        = 'Total Line';
  CtTxtHdrTotValWoTax   = 'Total Line Excl Tax'; // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  CtTxtHdrVATCode       = 'VAT Code';

  CtTxtHdrVATDescr      = 'Description';
  CtTxtHdrPriceExclVAT  = 'Total Excl VAT';
  CtTxtHdrVATTotal      = 'Total VAT';

  CtTxtVATNumber        = 'VAT Number';
  CtTxtBankAccount      = 'Bank account';
  CtTxtCommReg          = 'Commercial Register';

  CtTxtDelivNoteNumber  = 'Delivery Note Number';
  CtTxtDelivNoteDate    = 'Delivery Note Date';
  CtTxtInvoiceNumber    = 'Invoice Number';
  CtTxtInvoiceDate      = 'Invoice Date';
  CtTxtPage             = 'Page';

  CtTxtRemarque         = 'Remarque';

  CtTxtDelivAddress     = 'Delivery address';
  CtTxtInvoiceAddress   = 'Invoice address';
  CtTxtCustNumber       = 'Customer Number';
  CtTxtVATCode          = 'VAT code';

resourcestring
  CtTxtNetAmount        = 'Net Amount';
  CtTxtTotalVAT         = 'Total VAT';
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  (*Resource string for printing label Total WO VAT*)
  CtTxtTotalWoVat       = 'Total WO VAT';
  CtTxtDepositPlus      = 'Deposit +';
  CtTxtDepositMin       = 'Deposit -';

  CtTxtShopCoupon       = 'ShopCoupoun';
  CtTxtMC               = 'MC';
  CtTxtCash             = 'Cash';
  CtTxtCheque           = 'Cheque';
  CtTxtEFT              = 'EFT';

  CtTxtTotal            = 'Total';
  CtTxtTotalPayed       = 'Total Paid';
  CtTxtTotalToPay       = 'Return';
  CtTxtSubTotal         = 'SubTotal';

//=============================================================================
// Resources - Titles on the rapport
//=============================================================================

resourcestring
  CtTxtCreditNote       = 'Credit Note';
  CtTxtInvoice          = 'Invoice';
  CtTxtInvoiceWoTax     = 'Invoice Excl Tax';     // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  CtTxtDelivNote        = 'Delivery Note';
  CtTxtDuplicate        = 'Duplicate';

//=============================================================================
// Resources - general error messages
//=============================================================================

resourcestring
  CtTxtNoTicketInfo     = 'No ticket information available';

//*****************************************************************************
// Custom Object-declaration
//*****************************************************************************

//=============================================================================
// Class TObjVATData : This class contains common data of 1 VAT-code.  Data
// of different articles with the same VAT-Code will be cummulated into this
// object.
//=============================================================================

type
  TObjVATData = class (TObject)
  public
    IdtVATCode     : Integer;          // Ident. of the VAT Code.
    TxtDescr       : string;           // Description of the VAT code.
    NumTotalInVAT  : Real;             // Total value
    NumTotalExVAT  : Real;             // Total value of the VAT code.
    NumTotalVAT    : Real;             // Total VAT.
    PctVAT         : Real;             // Procent of VAT Code.
  end; // of TObjFileData

//*****************************************************************************
// TFrmVSRptInvoice
//                                  -----
// REMARKS :
// - assumes :
//   * Add the Idts of the POSTransactions by using AddIdts
//   * CodKind must be specified, This gives you the posibility to make an
//     invoice are a delivery note.
//   * FlgDuplicate : gives you the possibility to make a duplicate of
//     the document.
//   * ObjCurrentTrans gives you the current postransaction in process.
//   * ObjCurrentTicket gives you the current ticket in process.
//*****************************************************************************

type
  TFrmVSRptInvoice = class(TFrmVSPreview)
    DsrPOSTransDetail: TDataSource;
    DsrPOSTransIdts: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure VspPreviewBeforeFooter(Sender: TObject);
    procedure VspPreviewBeforeHeader(Sender: TObject);
    procedure VspPreviewNewPage(Sender: TObject);
    procedure VspPreviewStartDoc(Sender: TObject);
  private
    { Private declarations }
    FIdtCustomer   : Integer;          // Current customer of the invoice.
    FFlgDuplicate  : Boolean;          // Printing a duplicate
    //FFlgforimproveddup : Boolean;                                             //R2014.1.Req(45010).ALLOPCO.Improved-Invoice-Address-For-Duplication.TCS-Med

    // All values that are put in the variables below, must be in the same
    // currency (the main currency)
    FValNettoAmount: Currency;         // Netto Amount of the invoice
    FValTotalVAT   : Currency;         // Total VAT of the invoice

    FValProfit     : Currency;         // Profit on the invoice.
    FValDepositPlus: Currency;         // Deposit Plus on the invoice
    FValDepositMin : Currency;         // Deposit Min on the invoice
    FValTotal      : Currency;         // Total on the invoice
    FValShopCoupon : Currency;         // Total shopCoupon on the invoice
    FValMC         : Currency;         // Total MC on the invoice
    FValCash       : Currency;         // Total cash on the invoice
    FValCheque     : Currency;         // Total cheque on the invoice
    FValEFT        : Currency;         // Total EFT on the invoice
    FValReturn     : Currency;         // Total that was returned on the invoice
    FValTotalPayed : Currency;         // Total Payed
    FValTotalToPay : Currency;         // Total To Pay

    PSavOnEndPage  : TNotifyEvent;     // Saving the OnEndPage handler
    PSavOnNewPage  : TNotifyEvent;     // Saving the OnNewPage handler
  protected
    // Property objects
    FCodKind            : Integer;     // What kind of rapport must be printed

    // Formats and headers
    TxtTableBodyFmt     : string;      // Format for body Table on report
    TxtTableBodyHdr     : string;      // Header for body Table on report
    TxtTableVatFmt      : string;      // Format for VAT Table on report
    TxtTableVatHdr      : string;      // Header for VAT Table on report
    TxtTablePaymentFmt  : string;      // Format for Payment Table on report
    TxtTablePaymentHdr  : string;      // Header for Payment Table on report

    StrLstVAT           : TStringList; // List of all VAT codes
    ObjCurrentTrans     : TObjTransaction; // Current Transaction to process
    ObjCurrentTicket    : TObjTransTicket; // Current Ticket to process

    NumCurRow           : Integer;     // Current Row to print.

    procedure CreateAdditionalModules; virtual;
    procedure EndPageBody (Sender : TObject); virtual;
    procedure EvaluatePagePosition; virtual;
    function GetTransactionObject : TObject; virtual;
    function GetTicketObject : TObject; virtual;

    // procedures to make a format and a header
    procedure AppendFmtAndHdrQuantity (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrUnit (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrVal (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrPrcDisc (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrValDisc (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrTotVal (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrVATCod (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrVAT (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrVATDescr (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrVATExcl (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrVATTotal (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrPayDescr (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrPayAmount (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrPayCurr (TxtHdr : string); virtual;

    // Build the headers and formats
    procedure BuildTableBodyFmtAndHdr; virtual;
    procedure BuildTableVATFmtAndHdr; virtual;
    procedure BuildTablePaymentFmtAndHdr; virtual;

    function GenerateCorrectionLine : string; virtual;
    function GenerateCommentLine : string; virtual;
    function GenerateFreeLine : string; virtual;
    function GeneratePromoNormalLine (NumPriceToPrint : Currency) : string;
                                                                        virtual;
    function GeneratePromoLine : string; virtual;
    function GenerateNormalLine (NumTotalToPrint : Currency) : string; virtual;
    function GenerateArticleFreeLine (NumPriceToPrint : Currency) : string;
                                                                        virtual;
    function GenerateArticleDispositLine : string; virtual;
    function GenerateAdminDepChargeLine : string; virtual;
    function GenerateAdminDepTakeBackLine : string; virtual;
    function GenerateAdminDiscCoup : string; virtual;

    procedure PrintGeneralInfo; virtual;
    procedure PrintGeneralInvoiceInfo; virtual;
    procedure PrintDeliveryNoteInfo; virtual;
    procedure PrintInvoiceNoteInfo; virtual;

    procedure PrintCorrectionLine; virtual;
    procedure PrintLineComment; virtual;
    procedure PrintFreeLine; virtual;

    procedure PrintArticleTakeBackLine; virtual;
    procedure PrintArticlePromoLine; virtual;
    procedure PrintArticleNormalLine; virtual;
    procedure PrintArticleFreeLine; virtual;
    procedure PrintArticleDispositLine; virtual;

    procedure PrintAdminDepChargeLine; virtual;
    procedure PrintAdminDepTakeBackLine; virtual;
    procedure PrintAdminDiscCoup; virtual;

    procedure PrintBodyDetailLine; virtual;
    procedure PrintBodyDetailAdmin; virtual;
    procedure PrintBodyDetailAdminExtend; virtual;
    procedure PrintVATTableLine (ObjVATData : TObjVATData); virtual;

    procedure AddVAT (NumLineTotal : Real  ;
                      TxtVATCode   : string;
                      TxtVATPrc    : Real) ; virtual;
    procedure CalcVATLines; virtual;

    procedure BuildBodyDetailLine; virtual;
    procedure CalcBodyDetailLine; virtual;

    procedure MakeCustomInfo; virtual;
    procedure MakeDocumentKind; virtual;
    procedure MakeDuplicate; virtual;
    procedure MakeTotals; virtual;
    procedure MakeOverLay; virtual;

    procedure BuildTickets; virtual;

    procedure PrintStoreInfo; virtual;
    procedure PrintGeneralTicketInfo; virtual;
    procedure PrintBodyInvoice; virtual;
    procedure PrintVATTable; virtual;
    procedure PrintPaymentTable; virtual;

    function GetTxtRemarqueTable : string; virtual;
    procedure PrintRemarqueTable; virtual;

    procedure SetValNettoAmount (Value : Currency); virtual;
    procedure SetValTotalVAT (Value : Currency); virtual;
    procedure SetValProfit (Value : Currency); virtual;
    procedure SetValDepositPlus (Value : Currency); virtual;
    procedure SetValDepositMin (Value : Currency); virtual;
    procedure SetValTotal (Value : Currency); virtual;
    procedure SetValShopCoupon (Value : Currency); virtual;
    procedure SetValMC (Value : Currency); virtual;
    procedure SetValCash (Value : Currency); virtual;
    procedure SetValCheque (Value : Currency); virtual;
    procedure SetValEFT (Value : Currency); virtual;
    procedure SetValReturn (Value : Currency); virtual;
    procedure SetValTotalPayed (Value : Currency); virtual;
    procedure SetValTotalToPay (Value : Currency); virtual;

    property IdtCustomer : Integer read  FIdtCustomer
                                   write FIdtCustomer;
    property ValNettoAmount : Currency read  FValNettoAmount
                                       write SetValNettoAmount;
    property ValTotalVAT : Currency read  FValTotalVAT
                                    write SetValTotalVAT;
    property ValProfit : Currency read  FValProfit
                                  write SetValProfit;
    property ValDepositPlus : Currency read  FValDepositPlus
                                       write SetValDepositPlus;
    property ValDepositMin : Currency read  FValDepositMin
                                      write SetValDepositMin;
    property ValTotal : Currency read  FValTotal
                                 write SetValTotal;
    property ValShopCoupon : Currency read  FValShopCoupon
                                      write SetValShopCoupon;
    property ValMC : Currency read  FValMC
                              write SetValMC;
    property ValCash : Currency read  FValCash
                                write SetValCash;
    property ValCheque : Currency read  FValCheque
                                  write SetValCheque;
    property ValEFT : Currency read  FValEFT
                               write SetValEFT;
    property ValReturn : Currency read  FValReturn
                                  write SetValReturn;
    property ValTotalPayed : Currency read  FValTotalPayed
                                      write SetValTotalPayed;
    property ValTotalToPay : Currency read  FValTotalToPay
                                      write SetValTotalToPay;
  public
    procedure AddIdts (IdtPOSTransaction : Integer;
                       IdtCheckOut       : Integer;
                       CodAction         : Integer;
                       DatTransBegin     : TDateTime); virtual;
    procedure ShowInvoices; virtual;

    property FlgDuplicate : Boolean read  FFlgDuplicate
                                    write FFlgDuplicate;
    property CodKind : Integer read  FCodKind
                               write FCodKind;
  end;   // of TFrmVSRptInvoice

var
  FrmVSRptInvoice: TFrmVSRptInvoice;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  StStrW,
  SmUtils,
  SmDBUtil,

  SfDialog,

  DFpnUtils,
  DFpnInvoice,
  DFpnPosTransaction,
  DFpnTradeMatrix,
  DFpnCustomer,
  DFpnAddress,
  DFpnWorkStat,
  DMDummy;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptInvoice';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptInvoice.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2011/02/13 10:10:13 $';

//=============================================================================

procedure TFrmVSRptInvoice.CreateAdditionalModules;
begin  // of TFrmVSRptInvoice.CreateAdditionalModules
  if not Assigned (DmdFpnPosTransaction) then
    DmdFpnPosTransaction := TDmdFpnPosTransaction.Create (Self);
  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Self);
  if not Assigned (DmdFpnWorkStat) then
    DmdFpnWorkStat := TDmdFpnWorkStat.Create (Self);
  if not Assigned (DmdMDummy) then
    DmdMDummy := TDmdMDummy.Create (Self);
  if not Assigned (DmdFpnCustomer) then
    DmdFpnCustomer := TDmdFpnCustomer.Create (Self);
  if not Assigned (DmdFpnAddress) then
    DmdFpnAddress := TDmdFpnAddress.Create (Self);
  if not Assigned (DmdFpnTradeMatrix) then
    DmdFpnTradeMatrix := TDmdFpnTradeMatrix.Create (Self);
  if not Assigned (DmdFpnInvoice) then
    DmdFpnInvoice := TDmdFpnInvoice.Create (Self);
end;  // of TFrmVSRptInvoice.CreateAdditionalModules

//=============================================================================
// TFrmVSRptInvoice.EndPageBody : Print a subtotal at the end of a page.
//                            --------------
// Remark : The event that triggers this procedure, will by replaced on the
//          last page.  In case of this a other procedure while by called.
//=============================================================================

procedure TFrmVSRptInvoice.EndPageBody (Sender : TObject);
begin  // of TFrmVSRptInvoice.EndPageBody
  VspPreview.MarginLeft := ViValRptPaymentPosX;
  VspPreview.CurrentX := ViValRptPaymentPosX;
  VspPreview.CurrentY := ViValRptPaymentPosY;

  VspPreview.TableBorder := bsNone;
  VspPreview.AddTable (TxtTablePaymentFmt, '', SepCol + SepCol + SepCol +
                       CtTxtSubTotal + SepCol +
                       CurrToStrF (ValTotal, ffFixed, DmdFpnUtils.QtyDecsPrice)+
                       SepCol + DmdFpnUtils.IdtCurrencyMain,
                       False, False, False);
end;   // of TFrmVSRptInvoice.EndPageBody

//=============================================================================
// TFrmVSRptInvoice.EvaluatePagePosition : Count the total body lines printed.
// If the given number is reached, a new page is taken.
//=============================================================================

procedure TFrmVSRptInvoice.EvaluatePagePosition;
begin  // of TFrmVSRptInvoice.EvaluatePagePosition
  Inc (NumCurRow);
  if ((NumCurRow mod NumBodyRow) = 0) then begin
     VspPreview.NewPage;
     NumCurRow := 0;
  end;
end;   // of TFrmVSRptInvoice.EvaluatePagePosition

//=============================================================================
// TFrmVSRptInvoice.GetTransactionObject : Create the needed object of the
// transaction.
//                            ------------------
// FuncRes : Returns the Transaction object
//=============================================================================

function TFrmVSRptInvoice.GetTransactionObject : TObject;
begin  // of TFrmVSRptInvoice.GetTransactionObject
  Result := TObjTransaction.Create;
end;   // of TFrmVSRptInvoice.GetTransactionObject

//=============================================================================
// TFrmVSRptInvoice.GetTicketObject : Create the needed object of the
// transticket.
//                            ------------------
// FuncRes : Returns the TransTicket object
//=============================================================================

function TFrmVSRptInvoice.GetTicketObject : TObject;
begin  // of TFrmVSRptInvoice.GetTicketObject
  Result := TObjTransTicket.Create;
end;   // of TFrmVSRptInvoice.GetTicketObject

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrQuantity : appends the format and header
// for a quantity-column to TxtTableBodyFmt and TxtTableBodyHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableBodyHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrQuantity (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrQuantity
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthQty))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrQuantity

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrUnit : appends the format and header
// for a Unit-column to TxtTableBodyFmt and TxtTableBodyHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableBodyHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrUnit (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrUnit
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',ViValRptWidthUnit))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrUnit

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrVal : appends the format and header
// for a Val-column to TxtTableBodyFmt and TxtTableBodyHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableBodyHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrVal (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrVal
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthVal))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrVal

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrPrcDisc : appends the format and header
// for a Price Discount-column to TxtTableBodyFmt and TxtTableBodyHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableBodyHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrPrcDisc (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrPrcDisc
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthPrcDisc))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrPrcDisc

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrValDisc : appends the format and header
// for a Value Discount-column to TxtTableBodyFmt and TxtTableBodyHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableBodyHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrValDisc (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrValDisc
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthValDisc))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrValDisc

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrTotVal : appends the format and header
// for a Total Value-column to TxtTableBodyFmt and TxtTableBodyHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableBodyHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrTotVal (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrTotVal
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthTotVal))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrTotVal

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrVATCod : appends the format and header
// for a VAT Code-column to TxtTableBodyFmt and TxtTableBodyHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableBodyHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrVATCod (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrVATCod
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthVATCod))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrVATCod

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrVAT : appends the format and header
// for a VAT Code-column to TxtTableVATFmt and TxtTableVATHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableVATHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrVAT (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrVAT
  if TxtTableVATFmt <> '' then begin
    TxtTableVATFmt := TxtTableVATFmt + SepCol;
    TxtTableVATHdr := TxtTableVATHdr + SepCol;
  end;
  TxtTableVATFmt := TxtTableVATFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthVATCod))]);
  TxtTableVATHdr := TxtTableVATHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrVAT

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrVATDescr : appends the format and header
// for a Description-column to TxtTableVATFmt and TxtTableVATHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableVATHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrVATDescr (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrVATDescr
  if TxtTableVATFmt <> '' then begin
    TxtTableVATFmt := TxtTableVATFmt + SepCol;
    TxtTableVATHdr := TxtTableVATHdr + SepCol;
  end;
  TxtTableVATFmt := TxtTableVATFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthVATDescr))]);
  TxtTableVATHdr := TxtTableVATHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrVATDescr

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrVATExcl : appends the format and header
// for a VAT Excl-column to TxtTableVATFmt and TxtTableVATHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableVATHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrVATExcl (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrVATExcl
  if TxtTableVATFmt <> '' then begin
    TxtTableVATFmt := TxtTableVATFmt + SepCol;
    TxtTableVATHdr := TxtTableVATHdr + SepCol;
  end;
  TxtTableVATFmt := TxtTableVATFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthVATExcl))]);
  TxtTableVATHdr := TxtTableVATHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrVATExcl

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrVATExcl : appends the format and header
// for a Total VAT column to TxtTableVATFmt and TxtTableVATHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableVATHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrVATTotal (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrVATTotal
  if TxtTableVATFmt <> '' then begin
    TxtTableVATFmt := TxtTableVATFmt + SepCol;
    TxtTableVATHdr := TxtTableVATHdr + SepCol;
  end;
  TxtTableVATFmt := TxtTableVATFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthVATTot))]);
  TxtTableVATHdr := TxtTableVATHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrVATTotal

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrPayDescr : appends the format and header
// for a Payment description-column to TxtTablePaymentFmt and TxtTablePaymentHdr
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTablePaymentHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrPayDescr (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrPayDescr
  if TxtTablePaymentFmt <> '' then begin
    TxtTablePaymentFmt := TxtTablePaymentFmt + SepCol;
    TxtTablePaymentHdr := TxtTablePaymentHdr + SepCol;
  end;
  TxtTablePaymentFmt := TxtTablePaymentFmt +
                 Format ('%s%d',
                         [FormatAlignLeft,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthPayDescr))]);
  TxtTablePaymentHdr := TxtTablePaymentHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrPayDescr

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrPayAmount : appends the format and header
// for a Payment Amount-column to TxtTablePaymentFmt and TxtTablePaymentHdr
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTablePaymentHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrPayAmount (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrPayAmount
  if TxtTablePaymentFmt <> '' then begin
    TxtTablePaymentFmt := TxtTablePaymentFmt + SepCol;
    TxtTablePaymentHdr := TxtTablePaymentHdr + SepCol;
  end;
  TxtTablePaymentFmt := TxtTablePaymentFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                     ViValRptWidthPayAmount))]);
  TxtTablePaymentHdr := TxtTablePaymentHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrPayAmount

//=============================================================================
// TFrmVSRptInvoice.AppendFmtAndHdrPayCurr : appends the format and header
// for a Payment Currency-column to TxtTablePaymentFmt and TxtTablePaymentHdr
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTablePaymentHdr.
//=============================================================================

procedure TFrmVSRptInvoice.AppendFmtAndHdrPayCurr (TxtHdr : string);
begin  // of TFrmVSRptInvoice.AppendFmtAndHdrPayCurr
  if TxtTablePaymentFmt <> '' then begin
    TxtTablePaymentFmt := TxtTablePaymentFmt + SepCol;
    TxtTablePaymentHdr := TxtTablePaymentHdr + SepCol;
  end;
  TxtTablePaymentFmt := TxtTablePaymentFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthPayCur))]);
  TxtTablePaymentHdr := TxtTablePaymentHdr + TxtHdr;
end;   // of TFrmVSRptInvoice.AppendFmtAndHdrPayCurr

//=============================================================================
// TFrmVSRptInvoice.BuildTableBodyFmtAndHdr : builds the Format and Header
// for the body table for the invoice.
//=============================================================================

procedure TFrmVSRptInvoice.BuildTableBodyFmtAndHdr;
begin  // of TFrmVSRptInvoice.BuildTableBodyFmtAndHdr
  TxtTableBodyFmt := Format ('%s%d', [FormatAlignLeft,
                                      ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableBodyHdr := CtTxtHdrDescription;

  AppendFmtAndHdrQuantity (CtTxtHdrQty);
  AppendFmtAndHdrUnit (CtTxtHdrUnitPrice);
  AppendFmtAndHdrVal (CtTxtHdrVal);
  AppendFmtAndHdrPrcDisc (CtTxtHdrPrcDisc);
  AppendFmtAndHdrValDisc (CtTxtHdrDisc);
  AppendFmtAndHdrTotVal (CtTxtHdrTotVal);
  AppendFmtAndHdrVATCod (CtTxtHdrVATCode);
end;   // of TFrmVSRptInvoice.BuildTableBodyFmtAndHdr

//=============================================================================
// TFrmVSRptInvoice.BuildTableVATFmtAndHdr : builds the Format and Header
// for the VAT table for the invoice.
//=============================================================================

procedure TFrmVSRptInvoice.BuildTableVATFmtAndHdr;
begin  // of TFrmVSRptInvoice.BuildTableVATFmtAndHdr
  TxtTableVATFmt := Format ('%s%d', [FormatAlignLeft,
                                     ColumnWidthInTwips (ViValRptWidthVATCod)]);
  TxtTableVATHdr := CtTxtHdrVATCode;

  AppendFmtAndHdrVATDescr (CtTxtHdrVATDescr);
  AppendFmtAndHdrVATExcl (CtTxtHdrPriceExclVAT);
  AppendFmtAndHdrVATTotal (CtTxtHdrVATTotal);
end;   // of TFrmVSRptInvoice.BuildTableVATFmtAndHdr

//=============================================================================
// TFrmVSRptInvoice.BuildTablePaymentFmtAndHdr : builds the Format and Header
// for the Payment table for the invoice.
//                               -------------
// Remark : Only the 'format string' is needed here, so no labels are given to
//          the procedures
//=============================================================================

procedure TFrmVSRptInvoice.BuildTablePaymentFmtAndHdr;
begin  // of TFrmVSRptInvoice.BuildTablePaymentFmtAndHdr
  AppendFmtAndHdrPayDescr ('');
  AppendFmtAndHdrPayAmount ('');
  AppendFmtAndHdrPayCurr ('');

  AppendFmtAndHdrPayDescr ('');
  AppendFmtAndHdrPayAmount ('');
  AppendFmtAndHdrPayCurr ('');
end;   // of TFrmVSRptInvoice.BuildTablePaymentFmtAndHdr

//=============================================================================
// TFrmVSRptInvoice.GenerateCorrectionLine : Generate the string-line in case
// of a correction
//=============================================================================

function TFrmVSRptInvoice.GenerateCorrectionLine : string;
begin  // of TFrmVSRptInvoice.GenerateCorrectionLine
  Result := ObjCurrentTrans.TxtDescrTakeBack;
end;   // of TFrmVSRptInvoice.GenerateCorrectionLine

//=============================================================================
// TFrmVSRptInvoice.GenerateCommentLine : Generate the string-line in case
// of comment line
//=============================================================================

function TFrmVSRptInvoice.GenerateCommentLine : string;
begin  // of TFrmVSRptInvoice.GenerateCommentLine
  Result := ObjCurrentTrans.TxtDescrComment;
end;   // of TFrmVSRptInvoice.GenerateCommentLine

//=============================================================================
// TFrmVSRptInvoice.GenerateFreeLine : Generate the string-line in case
// of free line
//=============================================================================

function TFrmVSRptInvoice.GenerateFreeLine : string;
begin  // of TFrmVSRptInvoice.GenerateFreeLine
  Result := ObjCurrentTrans.TxtDescrFree;
end;   // of TFrmVSRptInvoice.GenerateFreeLine

//=============================================================================
// TFrmVSRptInvoice.GeneratePromoNormalLine : This is the string - line that
// comes before the promotion - line.
//                                --------------
// Input : NumPriceToPrint : Price that must be printed on the 'normal' line
//=============================================================================

function TFrmVSRptInvoice.GeneratePromoNormalLine (NumPriceToPrint : Currency) :
                                                                         string;
var
  TxtQtyArt        : string;           // Converted qty article
begin  // of TFrmVSRptInvoice.GeneratePromoNormalLine
  TxtQtyArt := CurrToStrF (ObjCurrentTrans.QtyArt, ffFixed,
                           DmdFpnUtils.QtyDecsPrice);
  Result := ObjCurrentTrans.TxtDescrTurnOver + SepCol + TxtQtyArt + SepCol +
            CurrToStrF (NumPriceToPrint, ffFixed, DmdFpnUtils.QtyDecsPrice);
end;   // of TFrmVSRptInvoice.GeneratePromoNormalLine

//=============================================================================
// TFrmVSRptInvoice.GeneratePromoLine : This is the string - line that
// contains the promotion - information.
//=============================================================================

function TFrmVSRptInvoice.GeneratePromoLine : string;
begin  // of TFrmVSRptInvoice.GeneratePromoLine
  Result := ObjCurrentTrans.TxtDescrProm + SepCol +
            SepCol +
            CurrToStrF (ObjCurrentTrans.PrcPromInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValPromInclVAT +
                        ObjCurrentTrans.ValDiscInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.PctDisc, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValDiscInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValPromInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            IntToStr (ObjCurrentTrans.IdtVATCode);
end;   // of TFrmVSRptInvoice.GeneratePromoLine

//=============================================================================
// TFrmVSRptInvoice.GenerateNormalLine : This is the string - line that
// contains information of a normal article line
//                              -------------
// Input : NumTotalToPrint : Total to print on the rapport
//=============================================================================

function TFrmVSRptInvoice.GenerateNormalLine (NumTotalToPrint : Currency) :
                                                                         string;
var
  TxtQtyArt        : string;           // Converted qty article
begin  // of TFrmVSRptInvoice.GenerateNormalLine
  TxtQtyArt := CurrToStrF (ObjCurrentTrans.QtyArt, ffFixed,
                           DmdFpnUtils.QtyDecsPrice);

  Result := ObjCurrentTrans.TxtDescrTurnOver + SepCol +
            TxtQtyArt + SepCol +
            CurrToStrF (ObjCurrentTrans.PrcInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.PctDisc, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValDiscInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (NumTotalToPrint, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            IntToStr (ObjCurrentTrans.IdtVATCode);
end;   // of TFrmVSRptInvoice.GenerateNormalLine

//=============================================================================
// TFrmVSRptInvoice.GenerateArticleFreeLine : This is the string - line that
// contains information of a article that is given free
//                              -------------
// Input : NumPriceToPrint : Price to print on the rapport
//=============================================================================

function TFrmVSRptInvoice.GenerateArticleFreeLine (NumPriceToPrint : Currency) :
                                                                         string;
var
  TxtQtyArt        : string;           // Converted qty article
  TxtQtyArtPrc     : string;           // Converted qty article * Price
begin  // of TFrmVSRptInvoice.GenerateArticleFreeLine
  TxtQtyArt := CurrToStrF (ObjCurrentTrans.QtyArt, ffFixed,
                           DmdFpnUtils.QtyDecsPrice);
  TxtQtyArtPrc := CurrToStrF (ObjCurrentTrans.QtyArt * NumPriceToPrint, ffFixed,
                              DmdFpnUtils.QtyDecsPrice);

  Result := ObjCurrentTrans.TxtDescrTurnOver + SepCol +
            TxtQtyArt + SepCol +
            CurrToStrF (NumPriceToPrint, ffFixed, DmdFpnUtils.QtyDecsPrice) +
            SepCol + TxtQtyArtPrc;
end;   // of TFrmVSRptInvoice.GenerateArticleFreeLine

//=============================================================================
// TFrmVSRptInvoice.GenerateArticleDispositLine : This is the string - line that
// contains information of a disposit
//=============================================================================

function TFrmVSRptInvoice.GenerateArticleDispositLine : string;
begin  // of TFrmVSRptInvoice.GenerateArticleDispositLine
  Result := ObjCurrentTrans.TxtDescrAdm + SepCol + SepCol +
            CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol + SepCol + SepCol +
            CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice);
end;   // of TFrmVSRptInvoice.GenerateArticleDispositLine

//=============================================================================
// TFrmVSRptInvoice.GenerateAdminDepChargeLine :  This is the string - line that
// contains information of a DepCharge Line
//=============================================================================

function TFrmVSRptInvoice.GenerateAdminDepChargeLine : string;
begin  // of TFrmVSRptInvoice.GenerateAdminDepChargeLine
  Result := ObjCurrentTrans.TxtDescrAdm + SepCol + SepCol +
            CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol + SepCol + SepCol +
            CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice);
end;   // of TFrmVSRptInvoice.GenerateAdminDepChargeLine

//=============================================================================
// TFrmVSRptInvoice.GenerateAdminDepTakeBackLine : This is the string - line
// that contains information of a Dep. TakeBack Line
//=============================================================================

function TFrmVSRptInvoice.GenerateAdminDepTakeBackLine : string;
begin  // of TFrmVSRptInvoice.GenerateAdminDepTakeBackLine
  Result := ObjCurrentTrans.TxtDescrAdm + SepCol + SepCol +
            CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol + SepCol + SepCol +
            CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice);
end;   // of TFrmVSRptInvoice.GenerateAdminDepTakeBackLine

//=============================================================================
// TFrmVSRptInvoice.GenerateAdminDiscCoup : This is the string - line
// that contains information of a Discount Coupon
//=============================================================================

function TFrmVSRptInvoice.GenerateAdminDiscCoup : string;
begin  // of TFrmVSRptInvoice.GenerateAdminDiscCoup
  Result := ObjCurrentTrans.TxtDescrAdm + SepCol + SepCol + SepCol + SepCol +
            SepCol +
            CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice);
end;   // of TFrmVSRptInvoice.GenerateAdminDiscCoup

//=============================================================================
// TFrmVSRptInvoice.PrintGeneralInfo : Print general information on the rapport.
//=============================================================================

procedure TFrmVSRptInvoice.PrintGeneralInfo;
var
  StrLstMemo       : TStringList;      // Stringlist memo
  CntIndex         : Integer;          // Index counter
begin  // of TFrmVSRptInvoice.PrintGeneralInfo
  VspPreview.MarginLeft := ViValRptMatrixPosX;
  VspPreview.CurrentX := ViValRptMatrixPosX;
  VspPreview.CurrentY := ViValRptMatrixPosY;

  VspPreview.Font.Size := ViValSizeTitMatrix;
  VspPreview.Font.Style := VspPreview.Font.Style + [fsBold];
  VspPreview.Text :=
      DmdFpnTradeMatrix.InfoTradeMatrix [DmdFpnUtils.IdtTradeMatrixAssort,
                                         'TxtName'] + #10;
  VspPreview.Font.Style := VspPreview.Font.Style - [fsBold];

  VspPreview.Font.Size := ViValSizeMatrix;
  VspPreview.Text :=
      DmdFpnTradeMatrix.InfoTradeMatrix [DmdFpnUtils.IdtTradeMatrixAssort,
                                         'TxtStreet'] + #10 +
      DmdFpnTradeMatrix.InfoTradeMatrix [DmdFpnUtils.IdtTradeMatrixAssort,
                                         'TxtCodPost'] + #10 +
      DmdFpnTradeMatrix.InfoTradeMatrix [DmdFpnUtils.IdtTradeMatrixAssort,
                                         'TxtMunicip'] + #10;
  VspPreview.Text := #10;
  VspPreview.CurrentY := VspPreview.CurrentY - 150;;
  if DmdFpnUtils.QueryInfo
            ('Select TxtMemo from TradeMatrix ' +
             'where idttradematrix = ' +
              AnsiQuotedStr (DmdFpnUtils.IdtTradeMatrixAssort, '''')) then begin
    StrLstMemo := TStringList.Create;
    StrLstMemo.Text := DmdFpnUtils.QryInfo.FieldByName ('TxtMemo').AsString;
    try
      for CntIndex := 0 to Pred (StrLstMemo.Count) do begin
        VspPreview.Text:= StrLstMemo.Strings[CntIndex];
        VspPreview.Text := #10;
      end;
  VspPreview.Text := #10;
    finally
      StrLstMemo.free;;
    end;
  end;
  DmdFpnUtils.CloseInfo
end;  // of TFrmVSRptInvoice.PrintGeneralInfo

//=============================================================================
// TFrmVSRptInvoice.PrintGeneralInvoiceInfo : Print the Invoice information
// (number and date) or in case of a Delivery note the Delivery information.
//=============================================================================

procedure TFrmVSRptInvoice.PrintGeneralInvoiceInfo;
begin  // of TFrmVSRptInvoice.PrintGeneralInvoiceInfo
  VspPreview.CurrentY := VspPreview.CurrentY - 150;
  if CodKind = CodKindDelivNote then begin
    VspPreview.Text := CtTxtDelivNoteNumber + ' : ' +
        IntToStr (TObjTransTicket (
                               DmdFpnInvoice.LstTickets[0]).IdtDelivNote) + #10;
    VspPreview.Text := CtTxtDelivNoteDate + ' : ' +
        DateToStr (TObjTransTicket (
                               DmdFpnInvoice.LstTickets[0]).DtmDelivNote) + #10;
  end
  else begin
    VspPreview.Text := CtTxtInvoiceNumber + ' : ' +
        IntToStr (TObjTransTicket (
                                 DmdFpnInvoice.LstTickets[0]).IdtInvoice) + #10;
    VspPreview.Text := CtTxtInvoiceDate + ' : ' +
        DateToStr (TObjTransTicket (
                                 DmdFpnInvoice.LstTickets[0]).DtmInvoice) + #10;
  end;

  VspPreview.Text := CtTxtPage + ' : ' + IntToSTr (VspPreview.PageCount);
  VspPreview.Text := #10;
end;   // of TFrmVSRptInvoice.PrintGeneralInvoiceInfo

//=============================================================================
// TFrmVSRptInvoice.PrintDeliveryNoteInfo : Print the delivery note address
// on the invoice.
//=============================================================================

procedure TFrmVSRptInvoice.PrintDeliveryNoteInfo;
var
  TxtName          : string;           // Customer name
  TxtStreet        : string;           // Street
  TxtStreetNum     : string;           // House Number
  TxtZipCod        : string;           // Zipcode
  TxtMunicip       : string;           // Municipality
  TxtDatTransBegin : string;           // Date of transaction
begin  // of TFrmVSRptInvoice.PrintDeliveryNoteInfo
  VspPreview.MarginLeft := ViValRptDelivPosX;
  VspPreview.CurrentX := ViValRptDelivPosX;
  VspPreview.CurrentY := ViValRptDelivPosY;

  VspPreview.Font.Size := ViValSizeTitDeliv;
  VspPreview.Font.Style := VspPreview.Font.Style + [fsBold, fsUnderline];
  VspPreview.Text := CtTxtDelivAddress + #10;
  VspPreview.Font.Style := VspPreview.Font.Style - [fsBold, fsUnderline];

  VspPreview.Font.Size := ViValSizeDeliv;
  VspPreview.Text := #10;
  VspPreview.CurrentY := VspPreview.CurrentY - 150;

  try
    TxtName   := DmdFpnCustomer.InfoCustomer [IdtCustomer, 'TxtPublName'];
    TxtStreet := DmdFpnCustomer.InfoCustomerAddress [IdtCustomer,
                                                     CtCodAddressCustDeliv,
                                                     'TxtStreet'];
    TxtStreetNum := DmdFpnCustomer.InfoCustomerAddress [IdtCustomer,
                                                        CtCodAddressCustDeliv,
                                                        'TxtNumHouse'];
    TxtZipcod := DmdFpnCustomer.InfoCustomerAddress [IdtCustomer,
                                                     CtCodAddressCustDeliv,
                                                     'TxtCodPost'];
    TxtMunicip := DmdFpnCustomer.InfoCustomerAddress [IdtCustomer,
                                                      CtCodAddressCustDeliv,
                                                      'TxtMunicip'];
  except
    try
      TxtName   := '';
      TxtStreet := '';
      TxtStreetNum := '';
      TxtZipcod := '';
      TxtMunicip := '';

      TxtDatTransBegin :=
       AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                     DsrPOSTransIdts.DataSet.
                              FieldByName('DatTransBegin').AsDateTime), '''');

      if DmdFpnUtils.QueryInfo
         (#10'SELECT ' +
          #10'  TxtName,' +
          #10'  TxtStreet,' +
          #10'  TxtCodPost,' +
          #10'  TxtMunicip ' +
          #10'FROM ' +
          #10'  POSTransCust ' +
          #10'WHERE ' +
          #10'  (IdtPOSTransaction = ' + DsrPOSTransIdts.DataSet.
              FieldByName('IdtPOSTransaction').AsString + ')' +
          #10' AND (IdtCheckout = ' + DsrPOSTransIdts.DataSet.
              FieldByName ('IdtCheckout').AsString + ')' +
          #10' AND (CodTrans = ' + DsrPOSTransIdts.DataSet.
              FieldByName ('CodTrans').AsString + ')' +
          #10' AND (DatTransBegin = ' + TxtDatTransBegin + ')') then begin

        TxtName   := DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString;
        TxtStreet := DmdFpnUtils.QryInfo.FieldByName ('TxtStreet').AsString;
        TxtStreetNum := '';
        TxtZipcod := DmdFpnUtils.QryInfo.FieldByName('TxtCodPost').AsString;
        TxtMunicip := DmdFpnUtils.QryInfo.FieldByName('TxtMunicip').AsString;
      end;
    finally
      DmdFpnUtils.CloseInfo;
    end;
  end;
  VspPreview.Text := TxtName + #10;
  VspPreview.Text := TxtStreet + ' ' + TxtStreetNum + #10;
  VspPreview.Text := TxtZipcod + ' ' + TxtMunicip +#10;
end;   // of TFrmVSRptInvoice.PrintDeliveryNoteInfo

//=============================================================================
// TFrmVSRptInvoice.PrintInvoiceNoteInfo : Print the invoice address
// on the invoice.
//=============================================================================

procedure TFrmVSRptInvoice.PrintInvoiceNoteInfo;
var
  TxtName          : string;           // Customer name
  TxtStreet        : string;           // Street
  TxtStreetNum     : string;           // House Number
  TxtZipCod        : string;           // Zipcode
  TxtMunicip       : string;           // Municipality
  TxtVATCode       : string;           // VAT code
  TxtDatTransBegin : string;           // Date of transaction
begin  // of TFrmVSRptInvoice.PrintInvoiceNoteInfo
  // If we want to print an Delivery note, don't print the invoice information.
  if CodKind = CodKindDelivNote then
    Exit;

  VspPreview.MarginLeft := ViValRptInvoicePosX;
  VspPreview.CurrentX := ViValRptInvoicePosX;
  VspPreview.CurrentY := ViValRptInvoicePosY;

  VspPreview.Font.Size := ViValSizeTitInvoice;
  VspPreview.Font.Style := VspPreview.Font.Style + [fsBold, fsUnderline];
  VspPreview.Text := CtTxtInvoiceAddress + #10;
  VspPreview.Font.Style := VspPreview.Font.Style - [fsBold, fsUnderline];

  VspPreview.Font.Size := ViValSizeInvoice;
  VspPreview.Text := #10;
  VspPreview.CurrentY := VspPreview.CurrentY - 150;
  try
    TxtName   := DmdFpnCustomer.InfoCustomer [IdtCustomer, 'TxtPublName'];
    TxtStreet := DmdFpnCustomer.InfoCustomerAddress [IdtCustomer,
                                                     CtCodAddressCustInv,
                                                     'TxtStreet'];
    TxtStreetNum := DmdFpnCustomer.InfoCustomerAddress [IdtCustomer,
                                                        CtCodAddressCustInv,
                                                        'TxtNumHouse'];
    TxtZipcod := DmdFpnCustomer.InfoCustomerAddress [IdtCustomer,
                                                     CtCodAddressCustInv,
                                                     'TxtCodPost'];
    TxtMunicip := DmdFpnCustomer.InfoCustomerAddress [IdtCustomer,
                                                      CtCodAddressCustInv,
                                                      'TxtMunicip'];
    TxtVATCode := DmdFpnCustomer.InfoCustomer [IdtCustomer, 'TxtNumVAT'];
  except
    try
      TxtName   := '';
      TxtStreet := '';
      TxtStreetNum := '';
      TxtZipcod := '';
      TxtMunicip := '';
      TxtVATCode := '';

      TxtDatTransBegin :=
          AnsiQuotedStr (
               FormatDateTime (ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                               DsrPOSTransIdts.DataSet.
                               FieldByName('DatTransBegin').AsDateTime), '''');

      if DmdFpnUtils.QueryInfo
         (#10'SELECT ' +
          #10'  IdtCustomer, TxtName,  TxtStreet,  TxtCodPost,' +
          #10'  TxtMunicip, TxtNumVAT ' +
          #10'FROM ' +
          #10'  POSTransCust ' +
          #10'WHERE ' +
          #10'  (IdtPOSTransaction = ' + DsrPOSTransIdts.DataSet.
              FieldByName ('IdtPOSTransaction').AsString + ')' +
          #10' AND (IdtCheckout = ' + DsrPOSTransIdts.DataSet.
              FieldByName ('IdtCheckout').AsString + ')' +
          #10' AND (CodTrans = ' + DsrPOSTransIdts.DataSet.
              FieldByName ('CodTrans').AsString + ')' +
          #10' AND (DatTransBegin = ' + TxtDatTransBegin + ')') then begin

        TxtName   := DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString;
        TxtStreet := DmdFpnUtils.QryInfo.FieldByName ('TxtStreet').AsString;
        TxtStreetNum := '';
        TxtZipcod := DmdFpnUtils.QryInfo.FieldByName('TxtCodPost').AsString;
        TxtMunicip := DmdFpnUtils.QryInfo.FieldByName('TxtMunicip').AsString;
        IdtCustomer := DmdFpnUtils.QryInfo.FieldByName('IdtCustomer').AsInteger;
      end;
    finally
      DmdFpnUtils.CloseInfo;
    end;
  end;
  VspPreview.Text := TxtName + #10;
  VspPreview.Text := TxtStreet + ' ' + TxtStreetNum + #10;
  VspPreview.Text := TxtZipcod + ' ' + TxtMunicip + #10;
  VspPreview.Text := #10;
  VspPreview.CurrentY := VspPreview.CurrentY - 150;
  VspPreview.Text := CtTxtCustNumber + ' : ' + IntToStr (IdtCustomer) + #10;
  VspPreview.Text := CtTxtVATCode + ' : ' + TxtVATCode + #10;
end;   // of TFrmVSRptInvoice.PrintInvoiceNoteInfo

//=============================================================================
// TFrmVSRptInvoice.PrintCorrectionLine : Print a correction line
//=============================================================================

procedure TFrmVSRptInvoice.PrintCorrectionLine;
begin  // of TFrmVSRptInvoice.PrintCorrectionLine
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateCorrectionLine, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintCorrectionLine

//=============================================================================
// TFrmVSRptInvoice.PrintLineComment : Print a comment line
//=============================================================================

procedure TFrmVSRptInvoice.PrintLineComment;
begin  // of TFrmVSRptInvoice.PrintLineComment
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateCommentLine, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintLineComment

//=============================================================================
// TFrmVSRptInvoice.PrintFreeLine : Print a line in case of a free article.
//=============================================================================

procedure TFrmVSRptInvoice.PrintFreeLine;
begin  // of TFrmVSRptInvoice.PrintFreeLine
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateFreeLine, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintFreeLine

//=============================================================================
// TFrmVSRptInvoice.PrintArticleTakeBackLine : Print a line in case of a take
// back.
//=============================================================================

procedure TFrmVSRptInvoice.PrintArticleTakeBackLine;
begin  // of TFrmVSRptInvoice.PrintArticleTakeBackLine
  if ObjCurrentTrans.CodActTakeBack = 0 then
    exit;

  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateCorrectionLine, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintArticleTakeBackLine

//=============================================================================
// TFrmVSRptInvoice.PrintArticlePromoLine : In case of a promotion, print a
// promotion line.
//=============================================================================

procedure TFrmVSRptInvoice.PrintArticlePromoLine;
var
  CalcPrc          : Currency;         // Price to calculate with
begin  // of TFrmVSRptInvoice.PrintArticlePromoLine
  if (ObjCurrentTrans.PrcInclVAT - ObjCurrentTrans.PrcPromInclVAT)
      <= -CtValMinFloat then
    CalcPrc := 0
  else
    CalcPrc := ObjCurrentTrans.PrcInclVAT;

  VspPreview.AddTable (TxtTableBodyFmt, '', GeneratePromoNormalLine (CalcPrc),
                       False, False, True);
  EvaluatePagePosition;
  VspPreview.AddTable (TxtTableBodyFmt, '', GeneratePromoLine, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintArticlePromoLine

//=============================================================================
// TFrmVSRptInvoice.PrintArticleNormalLine : Print a normal article line
//=============================================================================

procedure TFrmVSRptInvoice.PrintArticleNormalLine;
var
  NumLineTotal     : Currency;         // Total of the line.
begin  // of TFrmVSRptInvoice.PrintArticleNormalLine
  NumLineTotal := ObjCurrentTrans.ValInclVAT + ObjCurrentTrans.ValDiscInclVAT;
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateNormalLine (NumLineTotal),
                       False, False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintArticleNormalLine

//=============================================================================
// TFrmVSRptInvoice.PrintArticleFreeLine : Print a line in case of a free
// article
//=============================================================================

procedure TFrmVSRptInvoice.PrintArticleFreeLine;
var
  CalcPrc          : Currency;         // Price to calculate with
begin  // of TFrmVSRptInvoice.PrintArticleFreeLine
  if Abs (ObjCurrentTrans.PrcPromInclVAT) >= CtValMinFloat then
    CalcPrc := ObjCurrentTrans.PrcPromInclVAT
  else
    CalcPrc := ObjCurrentTrans.PrcInclVAT;

  if ObjCurrentTrans.QtyArt > 0 then begin
     VspPreview.AddTable (TxtTableBodyFmt, '', GenerateArticleFreeLine(CalcPrc),
                          False, False, True);
    EvaluatePagePosition;
  end;
end;   // of TFrmVSRptInvoice.PrintArticleFreeLine

//=============================================================================
// TFrmVSRptInvoice.PrintArticleDispositLine : In case of disposite,
// print a line
//=============================================================================

procedure TFrmVSRptInvoice.PrintArticleDispositLine;
begin  // of TFrmVSRptInvoice.PrintArticleDispositLine
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateArticleDispositLine, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintArticleDispositLine

//=============================================================================
// TFrmVSRptInvoice.PrintAdminDepChargeLine : Print a depCharge line
//=============================================================================

procedure TFrmVSRptInvoice.PrintAdminDepChargeLine;
begin  // of TFrmVSRptInvoice.PrintAdminDepChargeLine
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateAdminDepChargeLine, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintAdminDepChargeLine

//=============================================================================
// TFrmVSRptInvoice.PrintAdminDepTakeBackLine : Print a Takeback line
//=============================================================================

procedure TFrmVSRptInvoice.PrintAdminDepTakeBackLine;
begin  // of TFrmVSRptInvoice.PrintAdminDepTakeBackLine
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateAdminDepTakeBackLine, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintAdminDepTakeBackLine

//=============================================================================
// TFrmVSRptInvoice.PrintAdminDiscCoup : Print a line of a Discount Coupon
//=============================================================================

procedure TFrmVSRptInvoice.PrintAdminDiscCoup;
begin  // of TFrmVSRptInvoice.PrintAdminDiscCoup
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateAdminDiscCoup, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.PrintAdminDiscCoup

//=============================================================================
// TFrmVSRptInvoice.PrintBodyDetailLine : Print a normal body line
//=============================================================================

procedure TFrmVSRptInvoice.PrintBodyDetailLine;
begin  // of TFrmVSRptInvoice.PrintBodyDetailLine
  if ObjCurrentTrans.QtyArt = 0 then
    Exit;

  PrintArticleTakeBackLine;

  // It's not a Free article
  if ObjCurrentTrans.CodActFree = 0 then begin
    // It's a promo price
    if Abs (ObjCurrentTrans.ValPromInclVAT) >= CtValMinFloat then
      PrintArticlePromoLine
    else
      PrintArticleNormalLine;
  end
  else
    PrintArticleFreeLine;

  // Disposit
  if Abs (ObjCurrentTrans.ValAdmInclVAT) >= CtValMinFloat then
    PrintArticleDispositLine;
end;   // of TFrmVSRptInvoice.PrintBodyDetailLine

//=============================================================================
// TFrmVSRptInvoice.PrintBodyDetailAdmin : Print a administratief body line.
//=============================================================================

procedure TFrmVSRptInvoice.PrintBodyDetailAdmin;
begin  // of TFrmVSRptInvoice.PrintBodyDetailAdmin
  case ObjCurrentTrans.CodActAdm of
    CtCodActDepCharge    : PrintAdminDepChargeLine;
    CtCodActDepTakeBack  : PrintAdminDepTakeBackLine;
    CtCodActDiscCoup     : PrintAdminDiscCoup;
  end;
end;   // of TFrmVSRptInvoice.PrintBodyDetailAdmin

//=============================================================================
// TFrmVSRptInvoice.PrintBodyDetailAdminExtend : Placeholder for inherite
//=============================================================================

procedure TFrmVSRptInvoice.PrintBodyDetailAdminExtend;
begin  // of TFrmVSRptInvoice.PrintBodyDetailAdminExtend
end;   // of TFrmVSRptInvoice.PrintBodyDetailAdminExtend

//=============================================================================
// TFrmVSRptInvoice.PrintVATTableLine : Create and print a VAT line depend
// on the given data.
//                             -----------
// Input : - ObjVATData : Object that contains the VAT data to create the
//                        VAT line.
//=============================================================================

procedure TFrmVSRptInvoice.PrintVATTableLine (ObjVATData : TObjVATData);
var
  TxtLine          : string;           // VAT Line to Print
begin  // of TFrmVSRptInvoice.PrintVATTableLine
  if Abs (ObjVATData.NumTotalInVAT) >= CtValMinFloat then begin
    TxtLine := IntToStr (ObjVATData.IdtVATCode) + SepCol +
               ObjVATData.TxtDescr + SepCol +
               CurrToStrF (ObjVATData.NumTotalExVAT, ffFixed,
                           DmdFpnUtils.QtyDecsPrice) + SepCol +
               CurrToStrF (ObjVATData.NumTotalVAT, ffFixed,
                           DmdFpnUtils.QtyDecsPrice);
    VspPreview.AddTable (TxtTableVATFmt, '', TxtLine, False, False, True);
  end;
end;   // of TFrmVSRptInvoice.PrintVATTableLine

//=============================================================================
// TFrmVSRptInvoice.AddVAT : Add an amount for a specified VAT Code
//                           ------------------
// Input : - NumLineTotal : Total to add to a specified VATCode
//         - TxtVATCode   : Code of the VAT Code
//         - TxtVATPrc    : Percentage of the VAT code
//=============================================================================

procedure TFrmVSRptInvoice.AddVAT (NumLineTotal : Real  ;
                                   TxtVATCode   : string;
                                   TxtVATPrc    : Real  );
var
  NumFound         : Integer;          // Index of the VatCode to proces.
  ObjVATData       : TObjVATData;      // VAT Object.
begin  // of TFrmVSRptInvoice.AddVAT
  if TxtVATCode = '' then
    Exit;

  NumFound := StrLstVAT.IndexOf (TxtVATCode);
  if NumFound = -1 then begin
    ObjVATData := TObjVATData.Create;
    ObjVATData.IdtVATCode := StrToInt (TxtVATCode);
    ObjVATData.PctVAT := TxtVATPrc;
    ObjVATData.TxtDescr := FormatFloat ('#.00', TxtVATPrc) + ' %';
    ObjVATData.NumTotalInVAT := NumLineTotal;
    ObjVATData.NumTotalVAT := 0;
    StrLstVAT.AddObject (TxtVATCode, ObjVATData);
  end
  else begin
    TObjVATData (StrLstVAT.Objects [NumFound]).NumTotalInVAT :=
      TObjVATData (StrLstVAT.Objects [ NumFound]).NumTotalInVAT + NumLineTotal;
  end;
end;   // of TFrmVSRptInvoice.AddVAT

//=============================================================================
// TFrmVSRptInvoice.CalcVATLines : Loop all the VAT codes and calculate the
// amount totals per VAT Code.
//=============================================================================

procedure TFrmVSRptInvoice.CalcVATLines;
var
  CntVATCode       : Integer;          // Looping the VAT codes
  ObjVATData       : TObjVATData;      // Object containing the VAT data.
begin  // of TFrmVSRptInvoice.CalcVATLines
  for CntVATCode := 0 to Pred (StrLstVAT.Count) do begin
    ObjVATData := TObjVATData (StrLstVAT.Objects [CntVATCode]);
    ObjVATData.NumTotalExVAT := ObjVATData.NumTotalInVAT /
                                (1 + ObjVATData.PctVAT / 100);
    ObjVATData.NumTotalVAT := ObjVATData.NumTotalInVAT -
                              ObjVATData.NumTotalExVAT;
  end;

  ValNettoAmount := 0;
  ValTotalVAT := 0;
  for CntVatCode := 0 to Pred (StrLstVAT.Count) do begin
    ValNettoAmount := ValNettoAmount +
                      TObjVATData(StrLstVAT.Objects [CntVATCode]).NumTotalExVAT;
    ValTotalVAT := ValTotalVAT +
                   TObjVATData (StrLstVAT.Objects [CntVATCode]).NumTotalVAT;
  end;

  ValNettoAmount := ValNettoAmount + ValProfit;
  ValTotal := ValNettoAmount + ValTotalVAT + ValDepositMin + ValDepositPlus;
end;   // of TFrmVSRptInvoice.CalcVATLines

//=============================================================================
// TFrmVSRptInvoice.BuildBodyDetailLine : Build a detail body line and print
// the needed line
//=============================================================================

procedure TFrmVSRptInvoice.BuildBodyDetailLine;
begin  // of TFrmVSRptInvoice.BuildBodyDetailLine
  if ObjCurrentTrans.CodActTakeBack <> 0 then
    PrintCorrectionLine;

  // In case of a free article
  if ObjCurrentTrans.CodActFree <> 0 then
    PrintFreeLine;

  case ObjCurrentTrans.CodMainAction of
    CtCodActPLUKey        : PrintBodyDetailLine;
    CtCodActPLUNum        : PrintBodyDetailLine;
    CtCodActClassNum      : PrintBodyDetailLine;
    CtCodActClassKey      : PrintBodyDetailLine;
    CtCodActDiscCoup      : PrintBodyDetailAdmin;
    CtCodActCoupExternal  : PrintBodyDetailAdmin;
    CtCodActDePCharge     : PrintBodyDetailAdmin;
    CtCodActDepTakeBack   : PrintBodyDetailAdmin;
    CtCodActDepCoupAccept : PrintBodyDetailAdmin;
    CtCodActCash          : PrintBodyDetailAdmin;
    CtCodActCheque        : PrintBodyDetailAdmin;
    CtCodActEFT           : PrintBodyDetailAdmin;
    CtCodActForCurr       : PrintBodyDetailAdmin;
    CtCodActCreditAllow   : PrintBodyDetailAdmin;
    CtCodActCreditCust    : PrintBodyDetailAdmin;
    CtCodActCreditRepay   : PrintBodyDetailAdmin;
    CtCodActVarious       : PrintBodyDetailAdmin;
    CtCodActCoupInternal  : PrintBodyDetailAdmin;
    CtCodActReturn        : PrintBodyDetailAdmin;
    else PrintBodyDetailAdminExtend;
  end;

  if (ObjCurrentTrans.CodActComment <> 0) then
    PrintLineComment;

  if ObjCurrentTrans.CodActAdm = CtCodActRndTotal then begin
    AddVAT (ObjCurrentTrans.ValAdmInclVAT,
            IntToStr (ObjCurrentTrans.IdtAdmVAT),
            ObjCurrentTrans.PctAdmVAT);
  end;
end;   // of TFrmVSRptInvoice.BuildBodyDetailLine

//=============================================================================
// TFrmVSRptInvoice.CalcBodyDetailLine : Add the totals of a current object
// (depending on the CodMain) in the StrLstVAT.
//=============================================================================

procedure TFrmVSRptInvoice.CalcBodyDetailLine;
begin  // of TFrmVSRptInvoice.CalcBodyDetailLine
  case ObjCurrentTrans.CodMainAction of
    CtCodActPLUKey,
    CtCodActPLUNum,
    CtCodActClassNum,
    CtCodActClassKey :  begin
      if ObjCurrentTrans.CodActFree = 0 then begin
        // It's a promo price
        if Abs (ObjCurrentTrans.ValPromInclVAT) >= CtValMinFloat then begin
          AddVAT (ObjCurrentTrans.ValPromInclVAT +
                  ObjCurrentTrans.ValDiscInclVAT,
                  IntToStr (ObjCurrentTrans.IdtVATCode),
                  ObjCurrentTrans.PctVATCode);
        end
        // It's not a promo price
        else begin
          AddVAT (ObjCurrentTrans.ValInclVAT + ObjCurrentTrans.ValDiscInclVAT,
                  IntToStr (ObjCurrentTrans.IdtVATCode),
                  ObjCurrentTrans.PctVATCode);
        end;
      end;

      // Disposited
      if Abs (ObjCurrentTrans.ValAdmInclVAT) >= CtValMinFloat then begin
        ValDepositPlus := ValDepositPlus + ObjCurrentTrans.ValAdmInclVAT;
      end;
    end;

    CtCodActDiscStore    :
         ValShopCoupon := ValShopCoupon + ObjCurrentTrans.ValAdmInclVAT;
    CtCodActCoupExternal : ValMC := ValMC + ObjCurrentTrans.ValAdmInclVAT;
    CtCodActCash         : ValCash := ValCash + ObjCurrentTrans.ValAdmInclVAT;
    CtCodActForCurr      : ValCash := ValCash + ObjCurrentTrans.ValAdmInclVAT;
    CtCodActEFT          : ValEFT := ValEFT + ObjCurrentTrans.ValAdmInclVAT;
    CtCodActCheque       : ValCheque := ValCheque +
                                        ObjCurrentTrans.ValAdmInclVAT;
    CtCodActDePCharge    :
        ValDepositPlus := ValDepositPlus + ObjCurrentTrans.ValAdmInclVAT;
    CtCodActDepTakeBack  :
        ValDepositMin := ValDepositMin + ObjCurrentTrans.ValAdmInclVAT;
    CtCodActDiscCoup     : ValCash := ValCash - ObjCurrentTrans.ValAdmInclVAT;
    CtCodActRndTotal     : begin
        AddVAT (ObjCurrentTrans.ValAdmInclVAT,
                IntToStr (ObjCurrentTrans.IdtAdmVAT),ObjCurrentTrans.PctAdmVAT);
    end
  end;
end;   // of TFrmVSRptInvoice.CalcBodyDetailLine

//=============================================================================
// TFrmVSRptInvoice.MakeCustomInfo : Placeholder for putting custom information
// on the rapport in 'overlay-mode'.
//=============================================================================

procedure TFrmVSRptInvoice.MakeCustomInfo;
begin  // of TFrmVSRptInvoice.MakeCustomInfo
  VspPreview.DrawRectangle (ViValRptBodyPoxX,
                            ViValRptBodyPoxY,
                            ViValRptBodyPoxX + ViValRptRemarqueWidth,
                            ViValRptVATPosY - ViValRptSpaceBtwRect, 10, 10);

  VspPreview.DrawRectangle (ViValRptPaymentPosX,
                            ViValRptPaymentPosY,
                            ViValRptPaymentPosX + ViValRptPayRectWidth,
                            ViValRptRemarquePosY - ViValRptSpaceBtwRect, 10,10);

  VspPreview.DrawRectangle (ViValRptPaymentPosX + ViValRptPayRectWidth +
                            ViValRptSpaceBtwRect,
                            ViValRptPaymentPosY,
                            ViValRptPaymentPosX + (ViValRptPayRectWidth * 2) +
                            ViValRptSpaceBtwRect,
                            ViValRptRemarquePosY - ViValRptSpaceBtwRect, 10,10);
end;   // of TFrmVSRptInvoice.MakeCustomInfo

//=============================================================================
// TFrmVSRptInvoice.MakeDocumentKind : Evaluate the kind of rapport it is.
// Depending on the evaluation, put a label on the rapport.
//=============================================================================

procedure TFrmVSRptInvoice.MakeDocumentKind;
var
  TxtDocKind       : string;           // Name of the document
begin  // of TFrmVSRptInvoice.MakeDocumentKind
  if CodKind = CodKindDelivNote then
    TxtDocKind := CtTxtDelivNote
  else begin
    if ValTotal < 0 then
      TxtDocKind := CtTxtCreditNote
    else
      TxtDocKind := CtTxtInvoice;
  end;

  VspPreview.Font.Size := ViValSizeDocKind;
  VspPreview.CurrentX := ViValRptDocKindPoxX;
  VspPreview.CurrentY := ViValRptDocKindPoxY;
  VspPreview.Text := TxtDocKind;
  VspPreview.Font.Size := ViValSizeBody;
end;   // of TFrmVSRptInvoice.MakeDocumentKind

//=============================================================================
// TFrmVSRptInvoice.MakeDuplicate : Set a 'Duplicate' label on the rapport if
// needed.
//=============================================================================

procedure TFrmVSRptInvoice.MakeDuplicate;
begin  // of TFrmVSRptInvoice.MakeDuplicate
  if FlgDuplicate then begin
    VspPreview.Font.Size := ViValSizeDuplicate;
    VspPreview.CurrentX := ViValRptDupliPoxX;
    VspPreview.CurrentY := ViValRptDupliPoxY;
    VspPreview.Text := CtTxtDuplicate;
    VspPreview.Font.Size := ViValSizeBody;
  end;
end;   // of TFrmVSRptInvoice.MakeDuplicate

//=============================================================================
// TFrmVSRptInvoice.MakeTotals : Print the totals on the rapport.
//=============================================================================

procedure TFrmVSRptInvoice.MakeTotals;
var
  TxtLine               : string;      // Line to print
begin  // of TFrmVSRptInvoice.MakeTotals
  VspPreview.MarginLeft := ViValRptPaymentPosX;
  VspPreview.CurrentX := ViValRptPaymentPosX;
  VspPreview.CurrentY := ViValRptPaymentPosY;

  ValTotalPayed := ValShopCoupon + ValMC + ValCash + ValCheque + ValEFT;
  ValTotalToPay := ValTotal - ValTotalPayed - ValReturn;

  VspPreview.TableBorder := tbNone;
  TxtLine := CtTxtNetAmount + SepCol +
             CurrToStrF (ValNettoAmount, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain + SepCol +
             CtTxtShopCoupon + SepCol +
             CurrToStrF (ValShopCoupon, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain;
  VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, False);

  TxtLine := CtTxtTotalVAT + SepCol +
             CurrToStrF (ValTotalVAT, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain + SepCol +
             CtTxtMC + SepCol +
             CurrToStrF (ValMC, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain;
  VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, True);

  TxtLine := CtTxtDepositPlus + SepCol +
             CurrToStrF (ValDepositPlus, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain + SepCol +
             CtTxtCash + SepCol +
             CurrToStrF (ValCash, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain;
  VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, True);

  TxtLine := CtTxtDepositMin + SepCol +
             CurrToStrF (ValDepositMin, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain + SepCol +
             CtTxtCheque + SepCol +
             CurrToStrF (ValCheque, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain;
  VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, True);

  TxtLine := SepCol + SepCol + SepCol +
             CtTxtEFT + SepCol +
             CurrToStrF (ValEFT, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain;
  VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, True);

  TxtLine := CtTxtTotal + SepCol +
             CurrToStrF (ValTotal, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain + SepCol +
             CtTxtTotalPayed + SepCol +
             CurrToStrF (ValTotalPayed, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain;
  VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, True);

  TxtLine := SepCol + SepCol + SepCol +
             CtTxtTotalToPay + SepCol +
             CurrToStrF (ValTotalToPay, ffFixed,
                         DmdFpnUtils.QtyDecsPrice) + SepCol +
             DmdFpnUtils.IdtCurrencyMain;
  VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, True);
end;   // of TFrmVSRptInvoice.MakeTotals

//=============================================================================
// TFrmVSRptInvoice.MakeOverLay : After the generate of the rapport, a second
// pass will occur to put necessary labels on the rapport such as the totals,
// 'duplicate', 'invoice/creditnote', the VAT table
//=============================================================================

procedure TFrmVSRptInvoice.MakeOverLay;
var
  CntPage          : Integer;          // Counter pages
begin  // of TFrmVSRptInvoice.MakeOverLay
  if VspPreview.PageCount > 0 then begin
    for CntPage := 1 to VspPreview.PageCount do begin
      VspPreview.StartOverlay (CntPage, False);
      try
        MakeDuplicate;
        MakeDocumentKind;
        // In case of the last page
        if CntPage = VspPreview.PageCount then begin
          CalcVATLines;
          MakeTotals;
          PrintVATTable;
        end;
        MakeCustomInfo;
      finally
        VspPreview.EndOverlay;
      end;
    end;  // of for CntPage := 1 to VspPreview.PageCount
    FlgDuplicate := True;
  end;  // of VspPreview.PageCount > 0
end;   // of TFrmVSRptInvoice.MakeOverLay

//=============================================================================

procedure TFrmVSRptInvoice.BuildTickets;
var
  ObjTransTicket   : TObjTransTicket;  // Current ticket
  ObjCurrTrans     : TObjTransaction;  // Current object of transdetail
  NumSubTot        : Integer;          // Indicates a subtotal in a ticket.
  NumLine          : Integer;          // Current Line in the ticket
  FlgFound         : Boolean;          // Is a equal Transdetail found?
  CntTransDetail   : Integer;          // Loop all Transdetails
begin  // of TFrmVSRptInvoice.BuildTickets
  if not (Assigned (DsrPOSTransDetail.DataSet) or
          Assigned (DsrPOSTransIdts.DataSet)) then
    raise Exception.Create (CtTxtNoTicketInfo);

  DsrPOSTransIdts.DataSet.First;
  // By loop all the POSTransaction idt's, infact you loop all tickets.
  DmdFpnInvoice.LstTickets.Clear;
  while not DsrPOSTransIdts.DataSet.Eof do begin
    // Get all the detail information of the POSTransaction and put in into
    // the ObjTransTicket object.
    DmdFpnInvoice.BuildPOSTransDetail
        (DmdFpnInvoice.QryPOSTransDetail,
         DsrPOSTransIdts.DataSet.FieldByName ('IdtPOSTransaction').AsInteger,
         DsrPOSTransIdts.DataSet.FieldByName ('IdtCheckOut').AsInteger,
         DsrPOSTransIdts.DataSet.FieldByName ('CodTrans').AsInteger,
         DsrPOSTransIdts.DataSet.FieldByName ('DatTransBegin').AsDateTime);
    DsrPOSTransDetail.DataSet := DmdFpnInvoice.QryPOSTransDetail;
    DsrPOSTransDetail.DataSet.Open;
    DsrPOSTransDetail.DataSet.First;

    // Set general information of ticket in list
    IdtCustomer := DsrPOSTransDetail.DataSet.
                                          FieldByName ('IdtCustomer').AsInteger;
    ObjTransTicket := TObjTransTicket (GetTicketObject);
    ObjTransTicket.FillObj (DsrPOSTransDetail.DataSet);
    DmdFpnInvoice.LstTickets.Add (ObjTransTicket);

    NumLine := DsrPOSTransDetail.DataSet.FieldByName ('NumLineReg').AsInteger;
    NumSubTot := 0;
    repeat
      // Put all POSTransDetail information of one NumLine into one object.
      ObjCurrTrans := TObjTransaction (GetTransactionObject);
      while (not DsrPOSTransDetail.DataSet.Eof)
        and (NumLine =
            DsrPOSTransDetail.DataSet.FieldByName ('NumLineReg').AsInteger)
            do begin
        ObjCurrTrans.FillObj (DsrPOSTransDetail.DataSet);
        DsrPOSTransDetail.DataSet.Next;
      end;
      NumLine := DsrPOSTransDetail.DataSet.FieldByName ('NumLineReg').AsInteger;

      // Find all equal POSTransDetails and cummulate them.
      // Start's from the last Subtotal-line
      FlgFound := False;
      for CntTransDetail := NumSubTot to
                       Pred (ObjTransTicket.StrLstObjTransaction.Count) do begin
        if TObjTransaction(ObjTransTicket.StrLstObjTransaction.
                             Objects[CntTransDetail]).Evaluate(ObjCurrTrans)
                                                                      then begin
          TObjTransaction(ObjTransTicket.StrLstObjTransaction.
                            Objects[CntTransDetail]).Count (ObjCurrTrans);
          ObjCurrTrans.Free;
          FlgFound := True;
          Break;
        end
      end;
      if not FlgFound then
        ObjTransTicket.StrLstObjTransaction.AddObject ('', ObjCurrTrans);

      // In case of a subtotal.
      if DsrPOSTransDetail.DataSet.FieldByName ('CodAction').AsInteger =
          CtCodActSubTotal then
        NumSubTot := ObjTransTicket.StrLstObjTransaction.Count;
    until DsrPOSTransDetail.DataSet.Eof;
    DsrPOSTransIdts.DataSet.Next;
  end;
end;   // of TFrmVSRptInvoice.BuildTickets

//=============================================================================

procedure TFrmVSRptInvoice.PrintStoreInfo;
begin  // of TFrmVSRptInvoice.PrintStoreInfo
  PrintGeneralInfo;
  PrintGeneralInvoiceInfo;
  PrintDeliveryNoteInfo;
  PrintInvoiceNoteInfo;
  VspPreview.Font.Size := ViValSizeBody;
end;   // of TFrmVSRptInvoice.PrintStoreInfo

//=============================================================================

procedure TFrmVSRptInvoice.PrintGeneralTicketInfo;
var
  TxtLine          : string;           // Line to print
begin  // of TFrmVSRptInvoice.PrintGeneralTicketInfo
  if CodKind <> CodKindInvoice  then
    Exit;

  if ObjCurrentTicket.IdtDelivNote <> 0 then begin
    TxtLine := CtTxtDelivNoteNumber + ' ' +
               IntToStr (ObjCurrentTicket.IdtDelivNote) + ' dd.' +
               FormatDateTime (CtTxtDatFormat, ObjCurrentTicket.DtmDelivNote);

    VspPreview.AddTable (TxtTableBodyFmt, '', TxtLine, False, clLtGray, False);
    EvaluatePagePosition;
  end;
end;   // of TFrmVSRptInvoice.PrintGeneralTicketInfo

//=============================================================================

procedure TFrmVSRptInvoice.PrintBodyInvoice;
var
  CntLstTickets    : Integer;          // Counter in List Tickets
  CntLstTransact   : Integer;          // Counter in PosTransaction
begin  // of TFrmVSRptInvoice.PrintBodyInvoice
  BuildTableBodyFmtAndHdr;
  BuildTableVATFmtAndHdr;
  BuildTablePaymentFmtAndHdr;

  VspPreview.StartDoc;
  VspPreview.Header := ' ';
  VspPreview.Footer := ' ';

  PSavOnEndPage := VspPreview.OnEndPage;
  PSavOnNewPage := VspPreview.OnNewPage;
  try
    // Calculate needed height to print transfer on each page
    VspPreview.OnEndPage := EndPageBody;
    // Do the print stuff
    for CntLstTickets := 0 to Pred (DmdFpnInvoice.LstTickets.Count) do begin
      ObjCurrentTicket :=
               TObjTransTicket (DmdFpnInvoice.LstTickets.Items [CntLstTickets]);
      PrintGeneralTicketInfo;
      for CntLstTransact := 0 to
                    Pred (ObjCurrentTicket.StrLstObjTransaction.Count) do begin
        ObjCurrentTrans :=
            TObjTransaction
               (ObjCurrentTicket.StrLstObjTransaction.Objects [CntLstTransact]);
        BuildBodyDetailLine;
        CalcBodyDetailLine;
      end;
    end;
  finally
    VspPreview.OnEndPage  := PSavOnEndPage;
    VspPreview.EndDoc;
  end;
  MakeOverLay;
end;   // of TFrmVSRptInvoice.PrintBodyInvoice

//=============================================================================
// TFrmVSRptInvoice.PrintVATTable :
//=============================================================================

procedure TFrmVSRptInvoice.PrintVATTable;
var
  CntVATCode       : Integer;          // Looping the VAT codes
  ObjVATData       : TObjVATData;      // Object containing the VAT data.
begin  // of TFrmVSRptInvoice.PrintVATTable
  VspPreview.MarginLeft := ViValRptVATPosX;
  VspPreview.CurrentX := ViValRptVATPosX;
  VspPreview.CurrentY := ViValRptVATPosY;

  VspPreview.TableBorder := tbBox;
  VspPreview.AddTable (TxtTableVATFmt, '', TxtTableVATHdr, False,
                       ViValColorVatTitle, False);

  StrLstVAT.Sort;
  for CntVATCode := 0 to Pred (StrLstVAT.Count) do begin
    ObjVATData := TObjVATData (StrLstVAT.Objects [CntVATCode]);
    PrintVATTableLine (ObjVATData);
  end;
end;   // of TFrmVSRptInvoice.PrintVATTable

//=============================================================================

procedure TFrmVSRptInvoice.PrintPaymentTable;
begin  // of TFrmVSRptInvoice.PrintPaymentTable
end;   // of TFrmVSRptInvoice.PrintPaymentTable

//=============================================================================
// TFrmVSRptInvoice.GetTxtRemarqueTable : Get the text that must be printed in
// the remarque part.
//                              -------------------
// FuncRes : Returns a string with the text to print in the remarque part.
//=============================================================================

function TFrmVSRptInvoice.GetTxtRemarqueTable : string;
begin  // of TFrmVSRptInvoice.GetTxtRemarqueTable
  Result := CtTxtRemarque + #10;
end;   // of TFrmVSRptInvoice.GetTxtRemarqueTable

//=============================================================================
// TFrmVSRptInvoice.PrintRemarqueTable : Print the remarque part to the invoice.
//=============================================================================

procedure TFrmVSRptInvoice.PrintRemarqueTable;
begin  // of TFrmVSRptInvoice.PrintRemarqueTable
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.BrushColor := clBlack;
  VspPreview.TextBox (GetTxtRemarqueTable,
                      ViValRptRemarquePosX, ViValRptRemarquePosY,
                      ViValRptRemarqueWidth, ViValRptRemarqueHeight, True,
                      False, True);
end;   // of TFrmVSRptInvoice.PrintRemarqueTable

//=============================================================================

procedure TFrmVSRptInvoice.SetValNettoAmount (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValNettoAmount
  FValNettoAmount := Value;
end;   // of TFrmVSRptInvoice.SetValNettoAmount

//=============================================================================

procedure TFrmVSRptInvoice.SetValTotalVAT (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValTotalVAT
  FValTotalVAT := Value;
end;   // of TFrmVSRptInvoice.SetValTotalVAT

//=============================================================================

procedure TFrmVSRptInvoice.SetValProfit (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValProfit
  FValProfit := Value;
end;   // of TFrmVSRptInvoice.SetValProfit

//=============================================================================

procedure TFrmVSRptInvoice.SetValDepositPlus (Value : Currency);
begin  // of TFrmInvoiceBuilder.SetValDispositPlus
  FValDepositPlus := Value;
end;   // of TFrmVSRptInvoice.SetValDispositPlus

//=============================================================================

procedure TFrmVSRptInvoice.SetValDepositMin (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValDispositMin
  FValDepositMin := Value;
end;   // of TFrmVSRptInvoice.SetValDispositMin

//=============================================================================

procedure TFrmVSRptInvoice.SetValTotal (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValTotal
  FValTotal := Value;
end;   // of TFrmVSRptInvoice.SetValTotal

//=============================================================================

procedure TFrmVSRptInvoice.SetValShopCoupon (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValShopCoupon
  FValShopCoupon := Value;
end;   // of TFrmVSRptInvoice.SetValShopCoupon

//=============================================================================

procedure TFrmVSRptInvoice.SetValMC (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValMC
  FValMC := Value;
end;   // of TFrmVSRptInvoice.SetValMC

//=============================================================================

procedure TFrmVSRptInvoice.SetValCash (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValCash
  FValCash := Value;
end;   // of TFrmVSRptInvoice.SetValCash

//=============================================================================

procedure TFrmVSRptInvoice.SetValCheque (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValCheque
  FValCheque := Value;
end;   // of TFrmVSRptInvoice.SetValCheque

//=============================================================================

procedure TFrmVSRptInvoice.SetValEFT (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValEFT
  FValEFT := Value;
end;   // of TFrmVSRptInvoice.SetValEFT

//=============================================================================

procedure TFrmVSRptInvoice.SetValReturn (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValReturn
  FValReturn := Value;
end;   // of TFrmVSRptInvoice.SetValReturn

//=============================================================================

procedure TFrmVSRptInvoice.SetValTotalPayed (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValTotalPayed
  FValTotalPayed := Value;
end;   // of TFrmVSRptInvoice.SetValTotalPayed

//=============================================================================

procedure TFrmVSRptInvoice.SetValTotalToPay (Value : Currency);
begin  // of TFrmVSRptInvoice.SetValTotalToPay
  FValTotalToPay := Value;
end;   // of TFrmVSRptInvoice.SetValTotalToPay

//=============================================================================
// TFrmVSRptInvoice.AddIdts : The given identifications added by this procedure
// are used to get and build the ticket's.
//                             -----------------
// Input : - IdtPOSTransaction : Identification of the POSTransaction
//         - IdtCheckOut       : Identification of the Checkout
//         - CodAction         : Code action
//         - DatTransBegin     : Date of the Transaction.
//=============================================================================

procedure TFrmVSRptInvoice.AddIdts (IdtPOSTransaction : Integer;
                                    IdtCheckOut       : Integer;
                                    CodAction         : Integer;
                                    DatTransBegin     : TDateTime);
var
  TxtDatTransBegin      : string;      // Date Transbegin is format to db format
begin  // of TFrmVSRptInvoice.AddIdts
  TxtDatTransBegin := FormatDateTime (ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                                      DatTransBegin);
  DmdFpnInvoice.StrLstIdtLst.Add (Format (TxtFmtIdt,
                            [IntToStr (IdtPOSTransaction),
                             IntToStr (IdtCheckOut),
                             IntToStr (CodAction),
                             TxtDatTransBegin]));
end;   // of TFrmVSRptInvoice.AddIdts

//=============================================================================
// TFrmVSRptInvoice.ShowInvoices : Starts processing the invoice and show it.
//=============================================================================

procedure TFrmVSRptInvoice.ShowInvoices;
begin  // of TFrmVSRptInvoice.ShowInvoices
  inherited;

  StrLstVAT := TStringList.Create;
  try
    // proces the given Idt's
    DmdFpnInvoice.BuildPOSTransaction;
    DmdFpnInvoice.QryPOSTransaction.Open;

    // In case the
    if DmdFpnInvoice.QryPOSTransaction.IsEmpty then
      raise Exception.Create (CtTxtNoTicketInfo);

    if not Assigned (DsrPOSTransIdts.DataSet) then
      DsrPOSTransIdts.DataSet := DmdFpnInvoice.QryPOSTransaction;
    if not Assigned (DsrPOSTransDetail.DataSet) then
      DsrPOSTransDetail.DataSet := DmdFpnInvoice.QryPOSTransDetail;

    // Fill the objects with given values.
    BuildTickets;
    PrintBodyInvoice;
    DmdFpnInvoice.StrLstIdtLst.Clear;
  finally
    StrLstVAT.Free;
    StrLstVAT := nil;

    DmdFpnInvoice.QryPOSTransaction.Close;
  end;
end;   // of TFrmVSRptInvoice.ShowInvoices

//=============================================================================

procedure TFrmVSRptInvoice.FormCreate(Sender: TObject);
begin  // of TFrmVSRptInvoice.FormCreate
  inherited;
  CreateAdditionalModules;
end;   // of TFrmVSRptInvoice.FormCreate

//=============================================================================
// TFrmVSRptInvoice.VspPreviewBeforeFooter : Event handler that is triggered at
// the end if the page.
//=============================================================================

procedure TFrmVSRptInvoice.VspPreviewBeforeFooter(Sender: TObject);
begin  // of TFrmVSRptInvoice.VspPreviewBeforeFooter
  inherited;
  CalcVATLines;
  PrintPaymentTable;
  PrintRemarqueTable;
end;   // of TFrmVSRptInvoice.VspPreviewBeforeFooter

//=============================================================================
// TFrmVSRptInvoice.VspPreviewBeforeHeader : Event handler that is triggered if
// a new page is made.
//=============================================================================

procedure TFrmVSRptInvoice.VspPreviewBeforeHeader(Sender: TObject);
begin  // of TFrmVSRptInvoice.VspPreviewBeforeHeader
  inherited;
  PrintStoreInfo;
end;   // of TFrmVSRptInvoice.VspPreviewBeforeHeader

//=============================================================================

procedure TFrmVSRptInvoice.VspPreviewNewPage(Sender: TObject);
begin  // of TFrmVSRptInvoice.VspPreviewNewPage
  inherited;
  VspPreview.Font.Size := ViValSizeBody;
  VspPreview.MarginLeft := ViValRptBodyPoxX;
  VspPreview.CurrentX := ViValRptBodyPoxX;
  VspPreview.CurrentY := ViValRptBodyPoxY;
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;
  VspPreview.AddTable (TxtTableBodyFmt, '', TxtTableBodyHdr,
                       False, ViValColorBodyTitle, False);
  VspPreview.TableCell [tcColAlign, 0,0,1, 90] := taCenterMiddle;
  VspPreview.EndTable;
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoice.VspPreviewNewPage

//=============================================================================

procedure TFrmVSRptInvoice.VspPreviewStartDoc(Sender: TObject);
begin  // of TFrmVSRptInvoice.VspPreviewStartDoc
  inherited;
  NumCurRow      := 0;

  ValNettoAmount := 0;
  ValTotalVAT    := 0;
  ValProfit      := 0;
  ValDepositPlus := 0;
  ValDepositMin  := 0;
  ValTotal       := 0;
  ValShopCoupon  := 0;
  ValMC          := 0;
  ValCash        := 0;
  ValCheque      := 0;
  ValEFT         := 0;
  ValReturn      := 0;
  ValTotalPayed  := 0;
  ValTotalToPay  := 0;
end;   // of TFrmVSRptInvoice.VspPreviewStartDoc

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FVSRptInvoice
