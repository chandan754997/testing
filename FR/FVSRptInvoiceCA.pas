//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint
// Unit     : FVSRptInvoiceCA = Form VideoSoft RePorT Invoice CAstorama
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS      : $Header:$
// History  :
// - Started from Castorama - Flexpoint 2.0 - FVSRptInvoiceCA - CVS revision 1.103
// Version ModifiedBy Reason
// 1.49    ARB        Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5
// 1.50    KB         Bug #181                  , KB,  R2011.1.EUR5
// 1.51    ARB        Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1
// 1.52    ARB        Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.1
// 1.53    ARB        Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del2
// 1.54    ARB        Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del4
// 1.55    ARB        Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del5
// 1.56    KB         Bug #181 Fix              , KB, R2011.1.EUR5
// 1.57    ARB        Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del6
// 1.58    ARB        CAFR.2011.2.23.9.1
// 1.59    ARB        CAFR.2011.2.23.9.2
// 1.60    SMB        Applix 2141096
// 1.61    TT         R2012.1 - BRES - Format de facture
// 1.62    SM         Address de Facturation      SM ,R2012.1 
// 1.63    PRG (TCS)  R2012.1 - BDES - Invoice with bar code (already adjusted to include CAFR - Bar Code on ticket and B5 invoice, PRG, R2012.1 format)
//=============================================================================

unit FVSRptInvoiceCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB, Buttons, ComCtrls,
  ExtCtrls,ToolWin, MMntInvoice, FVSRptInvoice, StBarC, StDate;                 // BDES - Invoice with bar code, PRG, R2012.1 - barcode component

//=============================================================================
// Global definitions
//=============================================================================

// BDES - Invoice with bar code, PRG, R2012.1 - start
const              // general to the report
  CtTxtBarCode     = 'barcode.bmp';    // bitmap image of the barcode
// BDES - Invoice with bar code, PRG, R2012.1 - end

var    // Column-width (in number of characters)
  ViValRptWidthDescr    : Integer = 23; // Width columns description  // Modified Bug #181, TCS(KB), R2011.1.EUR5
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.1
  ViValCiRptWidthDescr  : Integer = 30;// Width columns description Client Intracom
  ViValRptWidthCodeCasto: Integer = 10;// Width columns of casto
  ViValRptWidthPHUT     : Integer = 8; // Width columns of casto
  ViValRptWidthNumGTD   : Integer = 18;// Width columns of casto russia
  ViValRptWidthISOCode  : Integer = 15;// Width columns of casto russia
  ViValRptWidthSalesUnit: Integer = 7;// Width columns of casto russia
  ViValRptWidthEcoDescr : Integer = 38;// Width columns ecoline description
  CIFNConfig            : string = '\FlexPos\Ini\FPSSyst.Ini';   //R2012.1 Address De Facturation(SM)
//  ViValRptWidthQty      : Integer = 6; // Width columns quantity
  ViValRptWidthQty      : Integer = 7;  // Width columns quantity // Modified Bug #181, TCS(KB), R2011.1.EUR5
  ViValCiRptWidthQty    : Integer = 8;  // Width columns quantity client intracom
  ViValRptWidthUnit     : Integer = 9; // Width columns unit price
  ViValRptWidthVal      : Integer = 10;// Width columns amount
  ViValRptWidthPrcDisc  : Integer = 9; // Width columns unit discount
  ViValRptWidthValDisc  : Integer = 9; // Width columns amount discount
  ViValRptWidthTotVal   : Integer = 9; // Width columns total amount
  ViValRptWidthTotDescr : Integer = 10; // Width columns Description totals
  //  Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  //  R2011 10 to 16
  ViValCiRptWidthTotDescr : Integer = 16;// Client Intracom Width columns Description totals
  //ViValRptWidthPayDescr : Integer = 22;// Width columns Description payment   24 to 22
  ViValRptWidthPayCur   : Integer = 5; // Width columns Description payment
  ViValRptWidthPayFtr   : Integer = 25; //Width column payment footer


  ViValRptTotRectWidth  : Integer = 2640;// Width of Payment table            //R2011 3200
  //  Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  //  R2011 2640 to 3200
  ViValCiRptTotRectWidth  : Integer = 3200;// Client Intracom Width of Payment table
  ViValRptPayRectWidth  : Integer = 3300;// Width of Payment table            //R2011 3350
  //  Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  //  R2011 3300 to 3350
  ViValCiRptPayRectWidth  : Integer = 3350;// Client Intracom Width of Payment table

  ViValRptInvoiceRuPosY : Integer = 2300;   // Y position of Invoice info RU
  ViValRptVATPosY       : Integer = 11800;  // Y position of VAT table
  ViValRptPaymentPosX   : Integer = 4750;   // X position of Payment table    //R2011  4650
  //  Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  //  R2011  4750 to 4650
  ViValCiRptPaymentPosX   : Integer = 4650;   // Client Intracom X position of Payment table 4650
  ViValRptPaymentPosY   : Integer = 11800;  // Y position of Payment table

  ViValRptRemarquePosY  : Integer = 14200;  // Y position of Remarque
  ViValRptRemarque2PosY : Integer = 15000;  // Y position of Remarque 2
  ViValRptRemarque2RuPosY: Integer = 15600;  // Y position of Remarque 2

  ViValRptRemarqueHeight: Integer = 1400;   // Height of remarque box
  ViValRptRemarque1Height: Integer = 600;   // Height of remarque box 1
  ViValRptRemarqueRuHeight: Integer = 1200; //Height of remarque box 1 for ru
  ViValRptRemarque2Height: Integer = 600;   // Height of remarque box 2
  // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del2
  (*Changed the ViValRptBodyPoxY from 5650 to 6000*)
  ViValRptBodyPoxY      : Integer = 6000;   // Y position of Body table
  ViValRptBodyRuPoxY    : Integer = 6000;   // Y position of Body table
  ViValRptBodyPoxYCI    : Integer = 6000;   // Y pos of Body for Client Intracom// BDFR - Evol2
  ViValRptRuInfoPosY    : Integer = 4000;   // Y position of ru table (KPP, ...)

  ViValRptCreditStripPoxX    : Integer = 7500;   // X position of Credit strip
  ViValRptCreditStripWidth   : Integer = 4000;   // width of credit strip
  ViValRptCreditStripHeight  : Integer = 1900;   // width of credit strip

  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.1
  // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del6, Start
  (*See TFrmVSRptInvoiceCA.PrintCreditStrip for change details*)
  //ViValCiRptCreditStripPoxX  : Integer = 8200;   // X position of Credit strip for Client Intracom
  //ViValCiRptCreditStripWidth : Integer = 3200;   // width of credit strip for Client Intracom
  //ViValCiRptCreditStripHeight: Integer = 500;   // height of credit strip for Client Intracom
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del6, End
  ViValRptWidthRuDescr: Integer = 30; // Width columns of casto ru info
  ViValRptWidthRuValue: Integer = 80; // Width columns of casto ru info

  ViValRptDocKindRuPosX   : Integer = 4200;   // X position of Doc kind russia
  ViValRptDocKindRuPoxY   : Integer = 1200;
  ViValRptInvoiceRuPosX   : Integer = 8000;   // X position of ru invoice info
  ViValRptDupliRuPoxY     : Integer = 1500;
  ViValRptWidthVATVal     : Integer = 7; // Width columns VAT Value
  ViValRptWidthTotExclVAT : Integer = 10; // Width columns total excl VAT
  ViValRptPaymentRuPosX   : Integer = 7500;
  ViValRptTotalsRuPosX    : Integer = 4750;
  ViValRptPageNrRuPoxY    : Integer = 5750;   // Y position of page number
  ViValRptSignaturePosY   : Integer = 10000;
  ViValRptFiscalInfoPosY  : Integer = 5250;

  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  (*Position for Printing the Article Declation*)
  ViValRptClientIntracomWidth : Integer = 4000;  // Width of remarque box
  ViValRptClientIntracomHeight: Integer = 300;   // Height of remarque box
  //CAFR.2011.2.23.9.2 ARB Start
  ViValRptPromoPack     : Integer = 11675;  // Y Position for printing
                                            // Propack details in case
                                            // VAT table is not printed
                                            // as for Client Intracom
  //CAFR.2011.2.23.9.2 ARB End
  TxtDiffNoReturn     : string;
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  (*For comparing Client Intracom Payment*)
  TxtIdtClassClntIntra: string = '80.980.8300';


//=============================================================================
// Resourcestring with captions
//=============================================================================

resourcestring
  CtTxtCastorama         = 'Castorama';
  CtTxtFirstCopy         = 'First copy';
  CtTxtHdrCodeCasto      = 'Code Casto';
  CtTxtHdrSalesUnit      = 'Sales unit';
  CtTxtHdrPTUH           = 'PUHT';
  CtTxtPaiementcomptant  = 'Cash payment ; discount not used';
  CtTxtTicketNr          = 'Ticket Nr.';
  CtTxtTicketDate        = 'Ticket date';
  CtTxtMinitel           = 'Minitel';
  CtTxtClientCompte      = 'Client en compte';
  CtTxtAvoirReprise      = 'Avoir Reprise';
  CtTxtBonDachats        = 'Discount coupon Brico-Depot';
  CtTxtCheque2           = 'Gift Cheque';
  // SPAIN V1
  CtTxtInvoiceOrigin     = 'Invoice corresponding with ticket %s made on ' +
                           'caskdesk %s on %s';
  CtTxtCreditNoteNr      = 'Creditnote number';
  CtTxtCopyInvoice       = 'Copy of invoice';
  CtTxtInvoiceCreditnote = 'Invoice/Creditnote Nr';
  CtTxtOriginalInvoice   = 'Original invoice Number';
  CtTxtCreditNoteDate    = 'Creditnote date';
  CtTxtCreditNoteAddress = 'Creditnote address';
  CtTxtFiscalReceipt     = 'F.R. nr %s of %s';
  CtTxtFiscalDate        = 'Date: %s';
  CtTxtLastEOD           = 'Last EOD: %s';
  CtTxtFiscalPrinter     = 'Nr fiscal printer: %s';

  CtTxtLogoName          = 'flexpoint.report.bmp';   // Logo to print
                                                     // on the rapport

  CtTxtDirector          = 'General director';
  CtTxtDirector2         = '/A.B./';
  CtTxtChiefAccountancy  = 'Chief of accountancy';
  CtTxtChiefAccountancy2 = '/M.B./';
  CtTxtBeneficiary       = 'Beneficiary';
  CtTxtTotalItems        = 'Total items';
  CtTxtINN               = 'INN';
  CtTxtKPP               = 'KPP';
  CtTxtOKPO              = 'OKPO';
  CtTxtCompanyType       = 'Type of company';
  CtTxtOn                = 'On';
  CtTxtHdrISOCode        = 'ISO-code';
  CtTxtHdrGTDNumber      = 'GTD number';
  CtTxtHdrVATRate        = 'VAT rate';
  CtTxtHdrColumn7        = 'Column 7';
  CtTxtHdrVATVal         = 'VAT';
  CtTxtHdrRuPriceExclVAT = 'Total Excl VAT';
  CtTxtPapillon          = 'For each payment with banc or postal cheques, send ' +
                           'your ticket with the credit strip to: ';
  CtTxtCompanyName       = 'Company name:';
  CtTxtAddress           = 'Address:';
  CtTxtCompanyBankInfo   = 'INN/KPP number:';
  CtTxtSupplierAddress   = 'Supplier address:';
  CtTxtStoreNumber       = 'Store number:';

  CtTxtCustomerInfo      = 'Customer name and address:';
  CtTxtNrDateTicket      = 'Number and date of ticket:';
  CtTxtCustomerName      = 'Customer name:';
  CtTxtCustomerBankInfo  = 'INN/KPP number:';
  CtTxtTotalLine         = 'Total';
  CtTxtCancellTicket     = 'CANCELLATION OF COMPLETED TICKET';
  CtTxtOrigTickNumber    = 'Original ticket number:';
  CtTxtOrigShopNumber    = 'Original shop number:';
  CtTxtOrigDateTicket    = 'Original date/time ticket:';
  CtTxtOrigIdtCheckout   = 'Original checkout number:';
  CtTxtCancelledBy       = 'Cancelled by: %s, %s';
  CtTxtAuthorized        = 'Authorized by: %s, %s';
  CtDocNr                = 'Nr. Doc BO';
  CtTxtEmployeeCard      = 'Employee:';
  CtTxtCarteCadeau       = 'Carte Cadeau casto.';

type
  TObjTransactionCA = class (TObjTransaction)
  protected
    FlgRussia           : boolean;
    FlgFrance           : boolean;                                              //R2012.1 Address De Facturation(SM)
  public
    CodActionDocBO      : Integer;
    NumDocBO            : currency;
    NumLineReg          : Integer;
    CodType             : Integer;
    NumCard             : String;
    NumGTD              : String;
    TxtISOCountry       : String;
    TxtSalesUnit        : String;
    CodCreator          : Integer;
    PrcD3E              : currency;
    CodTypeD3E          : Integer;
    procedure FillObj (DsrData : TDataSet); override;
    function Evaluate (ObjTransaction : TObjTransaction) : Boolean; override;
    procedure InvertTransaction; virtual;
    procedure Count (ObjTransaction : TObjTransaction); override;
  end; // of TObjTransactionCA

type
  TObjTransTicketCA = class (TObjTransTicket)
  protected
    function GetNewTransObj: TObjTransaction; override;
  public
    IdtCheckOut         : Integer;
    NumFiscalTicket     : Integer;
    IdtInvoiceOrig      : Integer;
    IdtOperator         : Integer;
    CodCreator          : Integer;
    procedure FillObj (DsrData : TDataSet); override;
    function GetUniqueTransField (TxtFieldname: string): TStringList; virtual;
    constructor Create; override;
  end; // of TObjTransTicketCA

type
  TObjPayment = class (TObject)
  public
    IdtClassification   : string;
    CodAction           : integer;
    TxtDescr            : string;
    ValTotal            : Currency;
  end;  // of TObjPayment

//*****************************************************************************
// TFrmVSRptInvoiceCA
//*****************************************************************************

type
  TFrmVSRptInvoiceCA = class(TFrmVSRptInvoice)
    SpeedButton1: TSpeedButton;
    StBrCdTcktInfo: TStBarCode;                                                 // BDES - Invoice with bar code, PRG, R2012.1 - barcode component (width and format adjusted in form to include CAFR - Bar Code on ticket and B5 invoice, PRG, R2012.1 format)
    procedure FormCreate(Sender: TObject);
    procedure VspPreviewStartDoc(Sender: TObject);
    procedure VspPreviewNewPage(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActPrintAllExecute(Sender: TObject);
    procedure ActPrintPageExecute(Sender: TObject);
    procedure VspPreviewBeforeFooter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReadIniFile;         //R2012.1 Address De Facturation(SM)
  private
    { Private declarations }
    FLstPayments       : TList;       // List of all the payments
    // SPAIN V1
    TxtVATIncluded      : string;      // Text to print
    FlgTicketInfo       : boolean;     // Show origin Invoice or not
    FlgExtraInfo        : boolean;     // Print extra info on invoice or not
    FlgAllowCreditnote  : boolean;     // Allow Creditnote
    FlgSeperateCNNumber : boolean;     // Seperate number for creditnotes
    FlgCreditnote       : boolean;     // Creditnote
    NumStoreNrLength    : integer;     // Length of the storenumber
    NumInvoiceNrLength  : integer;     // Length of the invoicenumber
    ValRptInvoicePosY   : integer;     // y coordinate of invoice address
    ValPercPromDiff     : double;       // percentage difference between price and promo
    //Properties for D3E
    FFlgShowEcoTaxTickLine     : boolean;
    FFlgShowEcoTaxInvoiceLine  : boolean;
    FFlgShowEcoTaxInvoiceTotal : boolean;
    FFlgShowEcoTaxFreeArt      : boolean;
    FTxtDescrTotInvoiceFree    : string;
    FTxtDescrTotInvoice        : string;
    FTxtDescrFreeArtLine       : string;
    FTxtDescrArtLine           : string;
    FStrInvRemark              : TStringList;
    FStrInvAddress             : TStringList;
    FValTotalEcoTaxArticle     : currency;
    FValTotalEcoTaxFreeArticle : currency;
    PSavOnEndPage      : TNotifyEvent; // Saving the OnEndPage handler
    PSavOnNewPage      : TNotifyEvent; // Saving the OnNewPage handler
    FFlgFiscal         : Boolean;
    FFlgItaly          : Boolean;
    TxtFiscalText      : string;
    FFlgRussia         : Boolean;
    FFlgFrance         : Boolean;                                                //R2012.1 Address De Facturation(SM)
    FFlgPrintCopy      : Boolean;
    FNumTotalItems     : Currency;
    FFlgInvForm        : Boolean;  //  R2012.1 - BRES - Format de facture, TT
    FIdtDepartment     : Integer;
    FFlgCreditStrip    : boolean;
    FFlgClientEnCompte : boolean;
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
    (*This flag is used to uniquely identify a Client Intracom transaction
    this flag does not affect any functionality of the function IsClientIntraCom : Boolean*)
    FlgClientIntracom  : boolean;
    FValCredit         : Currency;
    ValRptTotalPosY    : integer;
    FCodCreator        : Integer;
    FNumCopies         : Integer;
    FTxtClientIntraLine1   : string;      // First line to print 4 client intracom
    FTxtClientIntraLine2   : string;      // Second line to print 4 client intracom
    FTxtClientIntraLine3   : string;      // Third line to print 4 client intracom
    FTxtClientIntraLine4   : string;      // Fourth line to print 4 client intracom
    FTxtCustName           : string;      // Customer name
    function IsClientIntraCom : Boolean;  // Checks if client is client intracom
  protected
    ObjCurrentTicket    : TObjTransTicketCA; // Current Ticket to process
    ImgLogo             : TImage;      // Picture with logo
    TxtTableRuFmt       : string;      // Format for Russian Table on report
    TxtTableBodyFmtD3E  : string;      // Format for body line ecotax on report
    TxtTableBodyHdr2    : string;      // Header for body Table on report
    TxtTableTotalsFmt  : string;      // Format for Payment Table on report
    TxtTableTotalsHdr  : string;      // Header for Payment Table on report
    StrLstContents      : TStringList;  // StringList with Contents descriptions
    TxtTablePaymentFtr  : string;      // Footer for Payment Table on report
    procedure CreateAdditionalModules; override;
    function GetTransactionObject : TObject; override;
    procedure EndPageBody (Sender : TObject); override;
    procedure AppendFmtAndHdrCodeCasto (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrPHUT (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrQuantity (TxtHdr : string); override;
    procedure AppendFmtAndHdrUnit (TxtHdr : string); override;
    procedure AppendFmtAndHdrVal (TxtHdr : string); override;
    procedure AppendFmtAndHdrPrcDisc (TxtHdr : string); override;
    procedure AppendFmtAndHdrValDisc (TxtHdr : string); override;
    procedure AppendFmtAndHdrTotVal (TxtHdr : string); override;
    procedure AppendFmtAndHdrVATCod (TxtHdr : string); override;
    procedure AppendFmtAndHdrTotDescr (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrPayDescr (TxtHdr : string); override;
    procedure AppendFmtAndHdrPayCurr (TxtHdr : string); override;
    procedure AppendFmtAndHdrNumGTD (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrISOCode (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrSalesUnit (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrVATVal (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrTotExclVat (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrTotalDescr (TxtHdr : string); virtual;        //Ru
    procedure AppendFmtAndHdrTotalAmount (TxtHdr : string); virtual;     //Ru
    procedure AppendFmtAndHdrTotalCurr (TxtHdr : string); virtual;       //Ru
    procedure BuildTableBodyFmtAndHdr; override;
    procedure BuildTablePaymentFmtAndHdr; override;
    procedure BuildTableRuFmt;
    procedure PrintGeneralInfo; override;
    procedure PrintGeneralInvoiceInfo; override;
    procedure PrintDeliveryNoteInfo; override;
    procedure PrintInvoiceNoteInfo; override;
    procedure MakeOverlay; reintroduce;
    function GenerateCorrectionLine : string; override;
    function GenerateCommentLine : string; override;
    function GenerateFreeLine : string; override;
    function GeneratePromoNormalLine (NumPriceToPrint : Currency) : string;
                                                                       override;
    function GeneratePromoLine : string; override;
    function GenerateNormalLine (NumTotalToPrint : Currency) : string; override;
    function GenerateNormalLinePromo (NumTotalToPrint : Currency) : string;
                                                                        virtual;
    function GenerateArticleFreeLine (NumPriceToPrint : Currency) : string;
                                                                       override;
    function GenerateLineEcoTax : string; virtual;
    function GenerateLineBon : string; virtual;
    function GenerateArticleDispositLine : string; override;
    function GenerateAdminDepChargeLine : string; override;
    function GenerateAdminDepTakeBackLine : string; override;
    function GenerateAdminDiscCoup : string; override;
    procedure PrintBodyDetailPayAdvance; virtual;
    procedure PrintBodyDetailTakeBackAdvance; virtual;
    procedure PrintBodyDetailBOLine; virtual;
    procedure PrintBodyDetailAvoirEmisLine; virtual;
    procedure PrintBodyDetailGiftCoupon; virtual;
    procedure PrintBodyDetailAdmin; override;
    procedure PrintBodyDetailAdminExtend; override;
    procedure PrintBodyDetailLine; override;
    procedure PrintArticleNoPromoLine; virtual;
    procedure PrintLineEcoTax; virtual;
    procedure PrintLineBon; virtual;
    procedure PrintArticleNormalLine; override;        // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
    procedure PrintArticlePromoLine; override;         // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
    procedure PrintArticleFreeLine; override;          // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
    procedure CalcBodyDetailLine; override;
    procedure BuildBodyDetailLine; override;
    procedure MakeDuplicate; override;
    procedure MakeTotals; override;
    procedure MakeDocumentKind; override;
    procedure MakeCustomInfo; override;
    function GetTicketObject : TObject; override;
    procedure BuildTickets; override;
    function GetTxtRemarqueTable : string; override;
    procedure PrintRemarqueTable; override;
    function GetLegalInfo : string; virtual;
    function GetDefaultInvExpDays : integer; virtual;
    function GetFlgCreditStrip : boolean; virtual;
    procedure PrintStoreInfo; override;
    procedure PrintGeneralTicketInfo; override;
    procedure PrintBodyInvoice; override;
    procedure PrintVATTable; override;
    procedure PrintVATTableLine (ObjVATData : TObjVATData); override;
    procedure CalcVATLines; override;
    procedure AddVAT (NumLineTotal : Real  ;
                      TxtVATCode   : string;
                      TxtVATPrc    : Real) ; override;
    procedure PrintFiscalReceiptInfo;
    procedure PrintEmployeeInfo;
    function GetAddressInfo: string;
    function GetRemarqueText: string;
    procedure PrintRuTable(TxtINN  : string;
                           TxtKPP  : string;
                           TxtOKPO : string); virtual;
    procedure FillStrLstContents (StrLstContents : TStringList); virtual;
    procedure PrintSignature; virtual;
    procedure PrintTotalLine; virtual;
    // SPAIN V1
    function FillString(FillChar: char; Len: integer): string; virtual;
    procedure InvertCurrentTrans; virtual;
    procedure ReadParams; virtual;

    function GetTxtCreditStrip : string; virtual;
    procedure PrintCreditStrip; virtual;

    property NumTotalItems : Currency read  FNumTotalItems
                                      write FNumTotalItems;
    property FlgCreditStrip : boolean read FFlgCreditStrip
                                     write FFlgCreditStrip;
    property FlgClientEnCompte : boolean read FFlgClientEnCompte
                                        write FFlgClientEnCompte;
    property ValCredit : Currency read FValCredit
                                 write FValCredit;
    property NumCopies : Integer read FNumCopies
                                 write FNumCopies;
    property StrInvRemark : TStringList read FStrInvRemark
                                       write FStrInvRemark;
    property StrInvAddress : TStringList read FStrInvAddress
                                        write FStrInvAddress;
    // CAFR.2011.2.23.9.1 ARB Start
    procedure PrintPromoPackDetails;
    // CAFR.2011.2.23.9.1 ARB End
  public
    { Public declarations }
    procedure ShowInvoices; override;
    procedure DrawLogo (ImgLogo : TImage); override;
    procedure PrintPageNumbers; virtual;
    // Properties
    property LstPayments : TList read FLstPayments
                                write FLstPayments;
    property FlgFiscal: Boolean read FFlgFiscal
                               write FFlgFiscal;
    property FlgItaly: Boolean read FFlgItaly write FFlgItaly;
    property FlgRussia: Boolean read FFlgRussia write FFlgRussia;
    property FlgFrance: Boolean read FFlgFrance write FFlgFrance;                //R2012.1 Address De Facturation(SM)
    property IdtDepartment: Integer read FIdtDepartment write FIdtDepartment;
    property FlgPrintCopy: Boolean read FFlgPrintCopy write FFlgPrintCopy;
    property FlgInvForm: Boolean read FFlgInvForm write FFlgInvForm; //  R2012.1 - BRES - Format de facture, TT
    property CodCreator: Integer read FCodCreator write FCodCreator;
    //EcoTax-properties
    property TxtDescrArtLine: string read FTxtDescrArtLine
                                    write FTxtDescrArtLine;
    property TxtDescrFreeArtLine: string read FTxtDescrFreeArtLine
                                        write FTxtDescrFreeArtLine;
    property TxtDescrTotInvoice: string read FTxtDescrTotInvoice
                                       write FTxtDescrTotInvoice;
    property TxtDescrTotInvoiceFree: string read FTxtDescrTotInvoiceFree
                                           write FTxtDescrTotInvoiceFree;
    property FlgShowEcoTaxTickLine: boolean read FFlgShowEcoTaxTickLine
                                              write FFlgShowEcoTaxTickLine;
    property FlgShowEcoTaxInvoiceLine: boolean read FFlgShowEcoTaxInvoiceLine
                                              write FFlgShowEcoTaxInvoiceLine;
    property FlgShowEcoTaxInvoiceTotal: boolean read FFlgShowEcoTaxInvoiceTotal
                                               write FFlgShowEcoTaxInvoiceTotal;
    property FlgShowEcoTaxFreeArt: boolean read FFlgShowEcoTaxFreeArt
                                          write FFlgShowEcoTaxFreeArt;
    property ValTotalEcoTaxArticle: Currency read FValTotalEcoTaxArticle
                                            write FValTotalEcoTaxArticle;
    property ValTotalEcoTaxFreeArticle: Currency read FValTotalEcoTaxFreeArticle
                                               write FValTotalEcoTaxFreeArticle;
    property TxtClientIntraLine1: string read FTxtClientIntraLine1
                                               write FTxtClientIntraLine1;
    property TxtClientIntraLine2: string read FTxtClientIntraLine2
                                               write FTxtClientIntraLine2;
    property TxtClientIntraLine3: string read FTxtClientIntraLine3
                                               write FTxtClientIntraLine3;
    property TxtClientIntraLine4: string read FTxtClientIntraLine4
                                               write FTxtClientIntraLine4;
    property TxtCustName: string read FTxtCustName write FTxtCustName;

    // BDES - Invoice with bar code, PRG, R2012.1 - start
    procedure CreateBarCode (TransDate   : TStDate;
                             NumTicket   : LongInt;
                             NumCashdesk : Word); virtual;

    procedure PrintBarCode; virtual;

    procedure DestroyBarCode; virtual;

    // BDES - Invoice with bar code, PRG, R2012.1 - end

  end; // of TFrmVSRptInvoiceCA

var
  FrmVSRptInvoiceCA: TFrmVSRptInvoiceCA;

//*****************************************************************************

implementation

uses
  IniFiles,

  StStrW,
  SmUtils,
  SmDBUtil_BDE,
  SfDialog,

  DFpnUtils,
  DFpnInvoice,
  DFpnCustomer,
  DFpnCustomerCA,
  DFpnDepartment,
  DFpnAddress,
  DFpnAddressCA,                                    // R2012.1 Address De Facturation (SM)
  DFpnTradeMatrix,
  DFpnPosTransaction,
  DFpnPosTransActionCA,
  DMDummy,
  DMDummyCA,

  ActiveX,
  AXCtrls,

  RFpnCom,
  RFpnInvoiceCA,
  Ufpssyst,
  RFpnComCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptInvoiceCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptInvoiceCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.63 $';
  CtTxtSrcDate    = '$Date: 2012/04/24 10:10:13 $';

//*****************************************************************************
//* TObjTransactionCA
//*****************************************************************************

//=============================================================================
// TObjTransactionCA.FillObj : Same extra information need to be loaded into
// the object.
//=============================================================================

procedure TObjTransactionCA.FillObj (DsrData : TDataSet);
var
  ValPos: integer;
begin  // of TObjTransactionCA.FillObj
  // Fill in the currency
  IdtCurrencyOrig := DsrData.FieldByName ('IdtCurrency').AsString;
  ValExchangeOrig := DsrData.FieldByName ('ValExchange').AsCurrency;
  FlgExchMultiplyOrig :=
      StrToBool (DsrData.FieldByName ('FlgExchMultiply').AsString, '9');
  NumDocBO := DsrData.FieldByName ('IdtCVente').AsCurrency;
  CodActionDocBO := DsrData.FieldByName ('CodTypeVente').AsInteger;
  NumLineReg := DsrData.FieldByName ('NumLineReg').AsInteger;
  CodType := DsrData.FieldByName ('CodType').AsInteger;
  CodCreator := DsrData.FieldByName ('CodCreator').AsInteger;
  if DsrData.FieldByName ('CodAction').AsInteger <> CtCodActComment then
    IdtAdmClassi := DsrData.FieldByName ('IdtClassification').AsString;
  // Depend on the codaction, fill in the fields in the object.
  case DsrData.FieldByName ('CodAction').AsInteger of
    CtCodActDiffNoReturn :
      TxtDiffNoReturn := DsrData.FieldByName ('TxtDescr').AsString;
    //CtCodActPLUNum, CtCodActPLUKey, CtCodActClassNum, CtCodActClassKey : begin
    CtCodActPLUNum, CtCodActPLUKey, CtCodActClassNum, CtCodActClassKey, CtCodActGiftCard : begin     //R2011.2 TCS SMB Applix 2141096
      // Fill in the action
      if CodMainAction = 0 then
        CodMainAction := DsrData.FieldByName ('CodAction').AsInteger;
      CodActTurnOver := DsrData.FieldByName ('CodAction').AsInteger;
      // Evaluatie if we're talking about a 'normal article', 'balance article',
      // ....  The codes 0 and 3 are given by SVE,
      if DsrData.FieldByName ('CodContents').AsInteger in [0, 3] then
        QtyArt := DsrData.FieldByName ('QtyLine').AsCurrency
      else
        QtyArt := DsrData.FieldByName ('QtyLine').AsCurrency *
                  DsrData.FieldByName ('QtyReg').AsCurrency;
      if CodActTurnOver in [CtCodActClassNum, CtCodActClassKey] then
        IdtClassification := DsrData.FieldByName ('IdtClassification').AsString
      else begin
        if CodActTurnOver = CtCodActGiftCard then begin
          TxtDescrTurnOver := CtTxtCarteCadeau;
          NumPLU := DsrData.FieldByName ('NumPLU').AsVariant;
          IdtArticle := DsrData.FieldByName ('NumPLU').AsString
        end
        else begin
          TxtDescrTurnOver := DsrData.FieldByName ('TxtDescr').AsString;
          NumPLU := DsrData.FieldByName ('NumPLU').AsVariant;
          IdtArticle := DsrData.FieldByName ('IdtArticle').AsString;
        end;
      end;


      // Convert the prices to the main currency
      PrcExclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName('PrcExclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      ValExclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName ('ValExclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      PrcInclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName('PrcInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      ValInclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName ('ValInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      IdtVATCode := DsrData.FieldByName ('IdtVATCode').AsInteger;
      PctVATCode := DsrData.FieldByName ('PctVAT').AsCurrency;
      if IdtClassification = '' then
        IdtClassification := DsrData.FieldByName ('IdtClassification').AsString;
      // Russia
      if (IdtArticle <> '') and FlgRussia then begin
        TxtISOCountry := DmdMDummyCA.GetInfoArticle(IdtArticle,
                                                      'TxtISOCountry');
        NumGTD       := DmdMDummyCA.GetInfoArticle(IdtArticle, 'NumGTD');
        TxtSalesUnit := PChar (TFrmVSRptInvoiceCA(FrmVSRptInvoice).
                          StrLstContents.Values [DmdMDummyCA.
                          GetInfoArticle(IdtArticle, 'CodSalesUnit')]);
      end; // of if (IdtArticle <> '') and FlgRussia
      //correction qty if manual invoice and codcontents > 3
      if DsrData.FieldByName ('CodSalesUnit').AsInteger = 0 then
        QtyArt := DsrData.FieldByName ('QtyLine').AsCurrency
      else begin
        if DsrData.FieldByName('IdtPosTransaction').AsInteger <> 0 then
          QtyArt := DsrData.FieldByName ('QtyLine').AsCurrency *
                    DsrData.FieldByName ('QtyReg').AsCurrency
        else
          QtyArt := DsrData.FieldByName ('QtyLine').AsCurrency;
      end;
    end;
    CtCodActPrcCampaign : begin
      TxtDescrProm := DsrData.FieldByName ('TxtDescr').AsString;
      // Convert the prices to the main currency
      PrcPromInclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName('PrcInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      ValPromInclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName ('ValInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      PrcPromExclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName('PrcExclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      ValPromExclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName ('ValExclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
    end;
    CtCodActDiscArtPct, CtCodActDiscCust, CtCodActDiscArtVal,
    CtCodActDirectPromDisc : begin
      CodActDisc := DsrData.FieldByName ('CodAction').AsInteger;
      if CodActDisc <> CtCodActDiscArtVal then
        PctDisc := DsrData.FieldByName ('PctDiscount').AsCurrency;
      TxtDescrDiscount := DsrData.FieldByName ('TxtDescr').AsString;
      // Convert the prices to the main currency
      PrcDiscInclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName('PrcInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      ValDiscInclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName ('ValInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      ValDiscExclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName ('ValExclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
    end;
    CtCodActDiscPers: begin
      if CodType = CtCodPdtTurnOverDisc then begin
        CodActDisc := DsrData.FieldByName ('CodAction').AsInteger;
        TxtDescrDiscount := DsrData.FieldByName ('TxtDescr').AsString;
        // Convert the prices to the main currency
        PrcDiscInclVAT := PrcDiscInclVAT + DmdFpnUtils.ExchangeCurr
            (DsrData.FieldByName('PrcInclVAT').AsCurrency, ValExchangeOrig,
             FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
             DmdFpnUtils.FlgExchMultiplyCurrencyMain);
        ValDiscInclVAT := ValDiscInclVAT + DmdFpnUtils.ExchangeCurr
            (DsrData.FieldByName ('ValInclVAT').AsCurrency, ValExchangeOrig,
             FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
             DmdFpnUtils.FlgExchMultiplyCurrencyMain);
        if ValPromInclVAT = 0 then
          PctDisc := (ValDiscInclVAT/ValInclVAT) * 100
        else
          PctDisc := (ValDiscInclVAT/ValPromInclVAT) * 100;
      end
      else begin
        //see it as payment
        if CodMainAction = 0 then
          CodMainAction := DsrData.FieldByName ('CodAction').AsInteger;
        CodActAdm := DsrData.FieldByName ('CodAction').AsInteger;
        TxtDescrAdm := DsrData.FieldByName ('TxtDescr').AsString;
        // Convert the prices to the main currency
        PrcAdmInclVAT := DmdFpnUtils.ExchangeCurr
            (DsrData.FieldByName('PrcInclVAT').AsCurrency, ValExchangeOrig,
             FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
             DmdFpnUtils.FlgExchMultiplyCurrencyMain);
        ValAdmInclVAT := DmdFpnUtils.ExchangeCurr
            (- DsrData.FieldByName ('ValInclVAT').AsCurrency, ValExchangeOrig,
             FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
             DmdFpnUtils.FlgExchMultiplyCurrencyMain);
        if DsrData.FieldByName ('CodAction').AsInteger in
                    [CtCodActCredCoupAccept, CtCodActGiftCoupon] then
          NumPLU := DsrData.FieldByName ('NumPLU').AsString;
        IdtClassification := DsrData.FieldByName ('IdtClassification').AsString;
      end;
    end;
    // Payment with cash
    CtCodActCash, CtCodActCheque, CtCodActCheque2, CtCodActBankCard,
    CtCodActEFT, CtCodActEFT2, CtCodActEFT3, CtCodActEFT4,
    CtCodActForCurr2, CtCodActForCurr3, CtCodActMinitel, CtCodActCredCoupAccept,
    CtCodActCreditAllow, CtCodActCreditCust, CtCodActTakeBackAdvance,
    CtCodActDiscCoup, CtCodActBankTransfer, CtCodActReturn,
    CtCodActCredCoupCreate, CtCodActGiftCoupon, CtCodActChequeCrealfi,
    CtCodActForCurr, CtCodActCoupExternal, CtCodActRndTotal,
    CtCodActDepCharge, CtCodActDepTakeBack, CtCodActCarteProvisoire,
    CtCodActInstalment, CtCodActCoupInternal, CtCodPayGiftCard, CtCodPaySatCard,
    CtCodActCoupPayment, CtCodActSavingCard: begin
      if CodMainAction = 0 then
        CodMainAction := DsrData.FieldByName ('CodAction').AsInteger;
      CodActAdm := DsrData.FieldByName ('CodAction').AsInteger;
      if DsrData.FieldByName ('CodAction').AsInteger = CtCodActCoupInternal then
      begin
        ValPos := 1;
        while Pos(' ', TxtDescrAdm) = 0 do begin
          TxtDescrAdm := Copy(DsrData.FieldByName ('TxtDescr').AsString,
                         Length(DsrData.FieldByName ('TxtDescr').AsString) -
                         ValPos, ValPos);
          ValPos := ValPos + 1;
        end;
        if StrToIntDef(TrimLeadChar(Copy(DsrData.FieldByName ('TxtDescr').AsString,
          Length(DsrData.FieldByName ('TxtDescr').AsString) -
          (ValPos-1), ValPos),' '),0) = 0 then
          TxtDescrAdm := DsrData.FieldByName ('TxtDescr').AsString
        else
          TxtDescrAdm := Copy(DsrData.FieldByName ('TxtDescr').AsString, 1,
                         length(DsrData.FieldByName ('TxtDescr').AsString) -
                         ValPos);
      end
      else
        TxtDescrAdm := DsrData.FieldByName ('TxtDescr').AsString;
      // Convert the prices to the main currency
      PrcAdmInclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName('PrcInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      ValAdmInclVAT := DmdFpnUtils.ExchangeCurr
          ( - DsrData.FieldByName ('ValInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      if CodActAdm = CtCodActRndTotal then begin
        IdtAdmVAT := DsrData.FieldByName ('IdtVATCode').AsInteger;
        PctAdmVAT := DsrData.FieldByName ('PctVAT').AsCurrency;
      end;
      IdtClassification := DsrData.FieldByName ('IdtClassification').AsString;
    end;
    CtCodActFree, CtCodActBingo : begin
      CodActFree := DsrData.FieldByName ('CodAction').AsInteger;
      TxtDescrFree := DsrData.FieldByName ('TxtDescr').AsString;
    end;
    CtCodActTakeBack : begin
      CodActTakeBack := DsrData.FieldByName ('CodAction').AsInteger;
      TxtDescrTakeBack := DsrData.FieldByName ('TxtDescr').AsString;
    end;
    CtCodActComment : begin
      CodActComment := DsrData.FieldByName ('CodAction').AsInteger;
      TxtDescrComment := DsrData.FieldByName ('TxtDescr').AsString;
      if DsrData.FieldByName('CodType').AsInteger = CtCodPdtInfoEFTNumCard then
        NumCard := DsrData.FieldByName ('TxtDescr').AsString;
      if (DsrData.FieldByName('CodType').AsInteger = CtCodPdtCommentEcoTaxArticle)
      or (DsrData.FieldByName('CodType').AsInteger = CtCodPdtCommentEcoTaxFreeArticle)
      then begin
        CodTypeD3E := DsrData.FieldByName('CodType').AsInteger;
        PrcD3E := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName('PrcInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      end; // of if (DsrData.FieldByName('CodType').AsInteger....
      if DsrData.FieldByName('CodType').AsInteger = CtCodPdtCommentArtInfoCustOrder
      then begin
        NumPLU := DsrData.FieldByName ('NumPLU').AsString;
        QtyArt := DsrData.FieldByName ('QtyLine').AsCurrency;
        TxtDescrTurnOver := DsrData.FieldByName('TxtDescr').AsString;
        PrcInclVAT := DmdFpnUtils.ExchangeCurr (DsrData.FieldByName('PrcInclVAT').
          AsCurrency, ValExchangeOrig, FlgExchMultiplyOrig, DmdFpnUtils.
          ValExchangeBase, DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      end; // of if DsrData.FieldByName('CodType').AsInteger....
    end; // of CtCodActComment
    CtCodActPayAdvance, CtCodActChangeAdvance, CtCodActPayForfait,
    CtCodActTakeBackForfait: begin
      if CodMainAction = 0 then
        CodMainAction := DsrData.FieldByName ('CodAction').AsInteger;
      CodActTurnOver   := DsrData.FieldByName ('CodAction').AsInteger;
      TxtDescrTurnOver := DsrData.FieldByName ('TxtDescr').AsString;
      // Convert the prices to the main currency
      PrcExclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName('PrcExclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      ValExclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName ('ValExclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      PrcInclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName('PrcInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      ValInclVAT := DmdFpnUtils.ExchangeCurr
          (- DsrData.FieldByName ('ValInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
      IdtClassification := DsrData.FieldByName ('IdtClassification').AsString;
    end;
    CtCodActDocBO : begin
      if CodMainAction = 0 then
        CodMainAction := DsrData.FieldByName ('CodAction').AsInteger;
      CodActAdm := DsrData.FieldByName ('CodAction').AsInteger;
      TxtDescrAdm := CtDocNr + ' ' + DsrData.FieldByName ('IdtCVente').AsString;
    end;
  end; // of case DsrData.FieldByName ('CodAction').AsInteger
end;   // of TObjTransactionCA.FillObj

//==============================================================================

function TObjTransactionCA.Evaluate (ObjTransaction : TObjTransaction) : Boolean;
begin  // of TObjTransactionCA.Evaluate
  Result := inherited Evaluate (ObjTransaction)
            and (NumDocBO = TObjTransactionCA(ObjTransaction).NumDocBO)
            and (CodActionDocBO =
                              TObjTransactionCA(ObjTransaction).CodActionDocBO)
            and (PctDisc = TObjTransactionCA(ObjTransaction).PctDisc)
            and (NumCard = TObjTransactionCA(ObjTransaction).NumCard);
  if Result then begin
    if ((ObjTransaction.CodMainAction = 0) and
                  (ObjTransaction.CodActComment <> 0)) then
      Result := False;
  end;
end;   // of TObjTransactionCA.Evaluate

//==============================================================================
// TObjTransactionCA.InvertTransaction : Invert the given values in the object
//==============================================================================

procedure TObjTransactionCA.InvertTransaction;
begin  // of TObjTransactionCA.InvertTransaction
  PrcInclVAT     := - PrcInclVAT;
  PrcExclVAT     := - PrcExclVAT;
  ValInclVAT     := - ValInclVAT;
  ValExclVAT     := - ValExclVAT;

  PrcPromInclVAT := - PrcPromInclVAT;
  PrcPromExclVAT := - PrcPromExclVAT;
  ValPromInclVAT := - ValPromInclVAT;
  ValPromExclVAT := - ValPromExclVAT;

  PrcDiscInclVAT := - PrcDiscInclVAT;
  ValDiscInclVAT := - ValDiscInclVAT;
  ValDiscExclVAT := - ValDiscExclVAT;

  PrcAdmInclVAT  := - PrcAdmInclVAT;
  ValAdmInclVAT  := - ValAdmInclVAT;
end;   // of TObjTransactionCA.InvertTransaction

//*****************************************************************************
//* TObjTransTicketCA
//*****************************************************************************

//=============================================================================
// TObjTransTicketCA.Create
//=============================================================================

constructor TObjTransTicketCA.Create;
begin  // of TObjTransTicketCA.Create
  inherited;

  FSetActPaymentTypes := FSetActPaymentTypes +
    [CtCodActCheque2, CtCodActEFT2, CtCodActEFT3, CtCodActEFT4,
     CtCodActForCurr2, CtCodActForCurr3, CtCodActInstalment,
     CtCodActBankTransfer, CtCodActCoupPayment, CtCodActSavingCard];

end;   // of TObjTransTicketCA.Create

//=============================================================================
// TObjTransTicketCA.FillObj : Same extra information need to be loaded into
// the object.
//=============================================================================

procedure TObjTransTicketCA.FillObj (DsrData : TDataSet);
begin  // of TObjTransTicketCA.FillObj
  // SPAIN V1
  inherited;
  if DsrData.FindField('IdtCheckOut') <> nil then
    IdtCheckOut := DsrData.FieldByName ('IdtCheckOut').AsInteger;
  if DsrData.FindField('DatTransBegin') <> nil then
    DatTransBegin := DsrData.FieldByName ('DatTransBegin').AsDateTime;
  if DsrData.FindField('NumFiscalTicket') <> nil then
    NumFiscalTicket := DsrData.FieldByName ('NumFiscalTicket').AsInteger;
  if DsrData.FindField('IdtInvoiceOrig') <> nil then
    IdtInvoiceOrig := DsrData.FieldByName ('IdtInvoiceOrig').AsInteger;
  if DsrData.FindField('IdtOperator') <> nil then
    IdtOperator := StrToIntDef(DsrData.FieldByName('IdtOperator').AsString, 0);
  if (DtmInvoice = 0) and (DsrData.FindField('DatCreate') <> nil) then
    DtmInvoice := DsrData.FieldByName ('DatCreate').AsDateTime;
  if DsrData.FindField('CodCreator') <> nil then
    CodCreator := DsrData.FieldByName ('CodCreator').AsInteger;
end;   // of TObjTransTicketCA.FillObj

//=============================================================================
// TObjTransTicketCA.GetUniqueTransField
//=============================================================================

function TObjTransTicketCA.GetUniqueTransField (TxtFieldname: string): TStringList;
var
  CntTrans         : Integer;
  ObjTrans         : TObjTransactionCA;
begin  // of TObjTransTicketCA.GetUniqueTransField
  Result := TStringList.Create();
  for CntTrans := 0 to StrLstObjTransaction.Count-1 do begin
    ObjTrans := TObjTransactionCA (StrLstObjTransaction.Objects[CntTrans]);
    if AnsiSameText (TxtFieldname, 'NumCard') then begin
      if ObjTrans.CodActComment = CtCodActComment then begin
        if ObjTrans.NumCard <> '' then
          Result.Add(ObjTrans.NumCard);
//        Result := ObjTrans.NumCard;
        //Break;
      end;
    end;
  end;
end;   // of TObjTransTicketCA.GetUniqueTransField

//=============================================================================
// TObjTransTicketCA.GetNewTransObj
//=============================================================================

function TObjTransTicketCA.GetNewTransObj: TObjTransaction;
begin  // of TObjTransTicketCA.GetNewTransObj
  Result := TObjTransactionCA.Create();
end;   // of TObjTransTicketCA.GetNewTransObj

//*****************************************************************************
//* TFrmVSRptInvoiceCA
//*****************************************************************************

procedure TFrmVSRptInvoiceCA.CreateAdditionalModules;
begin  // of TFrmVSRptInvoiceCA.CreateAdditionalModules;
  if not Assigned (DmdFpnInvoice) then
    DmdFpnInvoice := TDmdFpnInvoice.Create (Self);
  if not Assigned (DmdFpnPOSTransaction) then
    DmdFpnPOSTransaction := TDmdFpnPOSTransaction.Create (Self);
  inherited;
end;   // of TFrmVSRptInvoiceCA.CreateAdditionalModules;

//==============================================================================

function TFrmVSRptInvoiceCA.GetTransactionObject : TObject;
begin  // of TFrmVSRptInvoiceCA.GetTransactionObject
  Result := TObjTransactionCA.Create;
end;   // of TFrmVSRptInvoiceCA.GetTransactionObject

//==============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrCodeCasto(TxtHdr: string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrCodeCasto
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                     ViValRptWidthCodeCasto))]);
  TxtTableBodyFmtD3E := TxtTableBodyFmtD3E +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                     ViValRptWidthCodeCasto))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrCodeCasto

//==============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrPHUT(TxtHdr: string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrPHUT
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                     ViValRptWidthPHUT))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrPHUT

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrQuantity (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrQuantity
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
    // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del2.Start
    if FlgClientIntracom then
      TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValCiRptWidthQty))])
    else
      TxtTableBodyFmt := TxtTableBodyFmt +
                   Format ('%s%d',
                           [FormatAlignRight,
                            ColumnWidthInTwips(CharStrW('0', ViValRptWidthQty))]);
    // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del2.End
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrQuantity

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrUnit (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrUnit
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',ViValRptWidthUnit))]);
  TxtTableBodyFmtD3E := TxtTableBodyFmtD3E +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',ViValRptWidthUnit))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrUnit

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrVal (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrVal
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthVal))]);
  TxtTableBodyFmtD3E := TxtTableBodyFmtD3E +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthVal))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrVal

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrPrcDisc (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrPrcDisc
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthPrcDisc))]);
  TxtTableBodyFmtD3E := TxtTableBodyFmtD3E +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthPrcDisc))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrPrcDisc

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrValDisc (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrValDisc
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthValDisc))]);
  TxtTableBodyFmtD3E := TxtTableBodyFmtD3E +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthValDisc))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrValDisc

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrTotVal (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrTotVal
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  if FlgClientIntracom then
    TxtTableBodyFmt := TxtTableBodyFmt +
                   Format ('%s%d',
                           [FormatAlignRight,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValCiRptWidthTotVal))])
  else
     TxtTableBodyFmt := TxtTableBodyFmt +
                   Format ('%s%d',
                           [FormatAlignRight,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValRptWidthTotVal))]);
   
  if FlgClientIntracom then
    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E +
                   Format ('%s%d',
                           [FormatAlignRight,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValCiRptWidthTotVal))])
  else
    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E +
                   Format ('%s%d',
                           [FormatAlignRight,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValRptWidthTotVal))]);
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrTotVal

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrVATCod (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrVATCod
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthVATCod))]);
  TxtTableBodyFmtD3E := TxtTableBodyFmtD3E +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthVATCod))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrVATCod

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrTotDescr (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrTotDescr
  if TxtTablePaymentFmt <> '' then begin
    TxtTablePaymentFmt := TxtTablePaymentFmt + SepCol;
    TxtTablePaymentHdr := TxtTablePaymentHdr + SepCol;
  end;
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  if FlgClientIntracom then
    TxtTablePaymentFmt := TxtTablePaymentFmt +
                   Format ('%s%d',
                           [FormatAlignLeft,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValCiRptWidthTotDescr))])
  else
    TxtTablePaymentFmt := TxtTablePaymentFmt +
                   Format ('%s%d',
                           [FormatAlignLeft,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValRptWidthTotDescr))]);



  TxtTablePaymentHdr := TxtTablePaymentHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrTotDescr

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrPayDescr (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrPayDescr
  if TxtTablePaymentFmt <> '' then begin
    TxtTablePaymentFmt := TxtTablePaymentFmt + SepCol;
    TxtTablePaymentHdr := TxtTablePaymentHdr + SepCol;
  end;
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  if FlgClientIntracom then
    TxtTablePaymentFmt := TxtTablePaymentFmt +
                   Format ('%s%d',
                           [FormatAlignLeft,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValCiRptWidthPayDescr))])
  else
    TxtTablePaymentFmt := TxtTablePaymentFmt +
                   Format ('%s%d',
                           [FormatAlignLeft,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValRptWidthPayDescr))]);

  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

  TxtTablePaymentHdr := TxtTablePaymentHdr + TxtHdr;

  TxtTablePaymentFtr := Format ('%s%d',
                         [FormatAlignLeft,
                          ColumnWidthInTwips(CharStrW('0',
                                          ViValRptWidthPayFtr))]) + SepCol;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrPayDescr

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrPayCurr (TxtHdr : string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrPayCurr
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
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrPayCurr

//==============================================================================

procedure TFrmVSRptInvoiceCA.BuildTableBodyFmtAndHdr;
begin  // of TFrmVSRptInvoiceCA.BuildTableBodyFmtAndHdr
  TxtTableBodyFmt := '';
  TxtTableBodyFmtD3E := '';
  TxtTableBodyHdr := '';
  TxtTableBodyHdr2 := '';

  if not FlgRussia then begin
    AppendFmtAndHdrCodeCasto (CtTxtHdrCodeCasto);

    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    if FlgClientIntracom then
      TxtTableBodyFmt := TxtTableBodyFmt + SepCol +
                       Format ('%s%d', [FormatNoWrap + FormatAlignLeft,
                                     ColumnWidthInTwips (ViValCiRptWidthDescr)])
    else
      TxtTableBodyFmt := TxtTableBodyFmt + SepCol +
                         Format ('%s%d', [FormatNoWrap + FormatAlignLeft,
                                       ColumnWidthInTwips (ViValRptWidthDescr)]) ;
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

    TxtTableBodyHdr := TxtTableBodyHdr + SepCol + CtTxtHdrDescription;

    TxtTableBodyFmtD3E := TxtTableBodyFmtD3E + SepCol +
                       Format ('%s%d', [FormatNoWrap + FormatAlignLeft,
                                   ColumnWidthInTwips (ViValRptWidthEcoDescr)]);
    AppendFmtAndHdrQuantity (CtTxtHdrQty);
    AppendFmtAndHdrPHUT (CtTxtHdrPTUH);
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    (*Removing Unit Price Column*)
    if not FlgClientIntracom then
      AppendFmtAndHdrUnit (CtTxtHdrUnitPrice);
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    (*Replacing the amount column*)
    if FlgClientIntracom then
      AppendFmtAndHdrVal (CtTxtHdrValWoVat)
    else
      AppendFmtAndHdrVal (CtTxtHdrVal);
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

    AppendFmtAndHdrValDisc (CtTxtHdrPrcDisc);
    if FlgTicketInfo then begin
      AppendFmtAndHdrPrcDisc ('');
    end
    else begin
      AppendFmtAndHdrPrcDisc (CtTxtHdrDisc);
    end;

    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    (*Replacing the Total Line header*)
    if FlgClientIntracom then
      AppendFmtAndHdrTotVal (CtTxtHdrTotValWoTax)
    else
      AppendFmtAndHdrTotVal (CtTxtHdrTotVal);
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    (*Disabling Vat Code Line Col*)
    if not FlgClientIntracom then
      AppendFmtAndHdrVATCod (CtTxtHdrVATCode);
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  end
  else begin
    AppendFmtAndHdrCodeCasto (CtTxtHdrCodeCasto);

    TxtTableBodyFmt := TxtTableBodyFmt + SepCol +
                       Format ('%s%d', [FormatAlignLeft,
                                     ColumnWidthInTwips (ViValRptWidthDescr)]) ;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol + CtTxtHdrDescription;
    AppendFmtAndHdrSalesUnit (CtTxtHdrSalesUnit);
    AppendFmtAndHdrVATCod (CtTxtHdrQty);
    AppendFmtAndHdrUnit (CtTxtHdrUnitPrice);
    AppendFmtAndHdrTotExclVat (CtTxtHdrRuPriceExclVAT);
    AppendFmtAndHdrVATCod (CtTxtHdrColumn7);   //unknown column
    AppendFmtAndHdrVATCod (CtTxtHdrVATRate);
    AppendFmtAndHdrVATVal (CtTxtHdrVATVal);
    AppendFmtAndHdrTotVal (CtTxtHdrTotVal);
    AppendFmtAndHdrISOCode (CtTxtHdrISOCode);
    AppendFmtAndHdrNumGTD (CtTxtHdrGTDNumber);
    TxtTableBodyHdr2 := '1' + SepCol + '2' + SepCol + '3' + SepCol + '4' +
                        SepCol + '5' + SepCol + '6' + SepCol + '7' + SepCol +
                        '8' + SepCol + '9' + SepCol + '10' + SepCol + '11' +
                        SepCol + '12';
  end;

end;   // of TFrmVSRptInvoiceCA.BuildTableBodyFmtAndHdr

//=============================================================================

procedure TFrmVSRptInvoiceCA.BuildTablePaymentFmtAndHdr;
begin  // of TFrmVSRptInvoiceCA.BuildTablePaymentFmtAndHdr
  TxtTablePaymentFmt := '';
  TxtTablePaymentHdr := '';
  TxtTableTotalsFmt := '';
  TxtTableTotalsHdr := '';
  if not FlgRussia then begin
    AppendFmtAndHdrTotDescr ('');
    AppendFmtAndHdrPayAmount ('');
    AppendFmtAndHdrPayCurr ('');
  end
  else begin
    AppendFmtAndHdrTotalDescr ('');
    AppendFmtAndHdrTotalAmount ('');
    AppendFmtAndHdrTotalCurr ('');
  end;

  AppendFmtAndHdrPayDescr ('');
  AppendFmtAndHdrPayAmount ('');
  AppendFmtAndHdrPayCurr ('');

end;   // of TFrmVSRptInvoiceCA.BuildTablePaymentFmtAndHdr

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintGeneralInfo;
var
  StrLstMemo       : TStringList;      // Stringlist memo
  StrLstAddress    : TStringList;      // Stringlist address
  CntIndex         : Integer;          // Index counter
  TxtName          : String;
  TxtStreet        : String;
  TxtCodPost       : String;
  TxtMunicip       : String;
  TxtINN           : String;
  TxtKPP           : String;
  TxtOKPO          : String;
  TxtAddress       : String;
  TxtSep           : String;
  CntTickets       : Integer;          // Loop all tickets                      // BDES - Invoice with bar code, PRG, R2012.1
  // BDES - Invoice with bar code, PRG, R2012.1 - start
  // Ticket information
  DatTransBegin    : TStDate;          // Transaction date
  NumTicket        : LongInt;          // Ticket Nnumber
  NumCashdesk      : Word;             // Cashdesk number
  // BDES - Invoice with bar code, PRG, R2012.1 - end  
begin  // of TFrmVSRptInvoiceCA.PrintGeneralInfo
  VspPreview.MarginLeft := ViValRptMatrixPosX;

  //Print 'castorama'
  {
  if FlgRussia then begin
    VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1000;
    VspPreview.CurrentY := VspPreview.MarginHeader;
    if VspPreview.CurrentY = 0 then
      VspPreview.CurrentY := VspPreview.MarginTop - VspPreview.Y2;
    if VspPreview.CurrentY <= 200 then
      VspPreview.CurrentY := 200;
    VspPreview.Font.Style := VspPreview.Font.Style + [fsBold];
    VspPreview.Text := CtTxtCastorama;
    VspPreview.Font.Style := VspPreview.Font.Style - [fsBold];
  end;   }


  VspPreview.CurrentX := ViValRptMatrixPosX;
  if not FlgRussia then begin
    VspPreview.CurrentY := ViValRptMatrixPosY;
  end
  else begin
    VspPreview.CurrentY := ViValRptInvoiceRuPosY;
  end;

  TxtName := DmdFpnTradeMatrix.InfoTradeMatrix
                                 [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtName'];
  TxtStreet := DmdFpnTradeMatrix.InfoTradeMatrix
                               [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtStreet'];
  TxtCodPost := DmdFpnTradeMatrix.InfoTradeMatrix
                               [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'];
  TxtMunicip := DmdFpnTradeMatrix.InfoTradeMatrix
                               [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'];
  if not FlgRussia then begin
    VspPreview.Font.Size := ViValSizeTitMatrix;
    VspPreview.Font.Style := VspPreview.Font.Style + [fsBold];
    if IdtDepartment > 0 then
      VspPreview.Text :=
        DmdFpnDepartment.InfoDepartment [IdtDepartment, 'TxtName'] + #10
    else
      VspPreview.Text :=
        DmdFpnTradeMatrix.InfoTradeMatrix [DmdFpnUtils.IdtTradeMatrixAssort,
                                           'TxtName'] + #10;
    VspPreview.Font.Style := VspPreview.Font.Style - [fsBold];

    VspPreview.Font.Size := ViValSizeMatrix;

    if FlgFiscal then begin
      if not(IdtDepartment > 0) then
        VspPreview.Text := TxtStreet + #10 + TxtCodPost + ' ' + TxtMunicip + #10
    end
    else begin
      if not (IdtDepartment > 0) then
        VspPreview.Text := TxtStreet + #10 + TxtCodPost + #10 +
                           TxtMunicip + #10;
    end;
    VspPreview.Text := #10;
    VspPreview.CurrentY := VspPreview.CurrentY - 150;

    if IdtDepartment > 0 then begin
      StrLstAddress := TStringList.Create;
      strLstAddress.Text := DmdFpnDepartment.InfoDepartment [IdtDepartment,
                                                             'TxtAddress'];
      try
        for CntIndex := 0 to Pred (strLstAddress.Count) do begin
          VspPreview.Text:= strLstAddress.Strings[CntIndex];
          VspPreview.Text := #10;
        end;
      finally
        strLstAddress.free;
      end;
    end
    else begin
      if DmdFpnUtils.QueryInfo ('SELECT TxtMemo FROM TradeMatrix ' +
                                'WHERE IdtTradeMatrix = ' +
                                AnsiQuotedStr (DmdFpnUtils.IdtTradeMatrixAssort,
                                                               '''')) then begin
        StrLstMemo := TStringList.Create;
        StrLstMemo.Text := DmdFpnUtils.QryInfo.FieldByName ('TxtMemo').AsString;
        try
          for CntIndex := 0 to Pred (StrLstMemo.Count) do begin
            VspPreview.Text:= StrLstMemo.Strings[CntIndex];
            VspPreview.Text := #10;
          end;
        finally
          StrLstMemo.free;
        end;
      end;
      DmdFpnUtils.CloseInfo;
    end;
    if not (IdtDepartment > 0) then begin
      if DmdFpnUtils.QueryInfo ('SELECT TxtNumPhone FROM TradeMatrix ' +
                            'WHERE IdtTradeMatrix = ' +
                        AnsiQuotedStr (DmdFpnUtils.IdtTradeMatrixAssort, '''')) then begin
        VspPreview.Text:= DmdFpnUtils.QryInfo.FieldByName ('TxtNumPhone').AsString;
        VspPreview.Text := #10;
      end;
      DmdFpnUtils.CloseInfo;
    end;
  end;
  if FlgRussia and not (IdtDepartment > 0) then begin
    VspPreview.Font.Size := ViValSizeInvoice;
    BuildTableRuFmt;
    if DmdFpnUtils.QueryInfo ('SELECT TxtINN, TxtKPP, TxtOKPO, TxtCompanyType' +
                              ' FROM TradeMatrix ' +
                              'WHERE IdtTradeMatrix = ' +
                               AnsiQuotedStr (DmdFpnUtils.IdtTradeMatrixAssort,
                                                              '''')) then begin
      TxtINN := DmdFpnUtils.QryInfo.FieldByName ('TxtINN').AsString;
      TxtKPP := DmdFpnUtils.QryInfo.FieldByName ('TxtKPP').AsString;
      TxtOKPO := DmdFpnUtils.QryInfo.FieldByName ('TxtOKPO').AsString;
    end;
    DmdFpnUtils.CloseInfo;


    VspPreview.TableBorder :=  tbNone;
    VspPreview.CurrentY :=  ViValRptInvoiceRuPosY;

    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtCompanyName + SepCol + TxtName,
                    False, False, True);
    //For address take txtmemo, excluding the first line
    TxtAddress := '';
    TxtSep := '';
    if DmdFpnUtils.QueryInfo ('SELECT TxtMemo FROM TradeMatrix ' +
                              'WHERE IdtTradeMatrix = ' +
                                AnsiQuotedStr (DmdFpnUtils.IdtTradeMatrixAssort,
                                                               '''')) then begin
      StrLstMemo := TStringList.Create;
      StrLstMemo.Text := DmdFpnUtils.QryInfo.FieldByName ('TxtMemo').AsString;
      try
        for CntIndex := 1 to Pred (StrLstMemo.Count) do begin
          TxtAddress := TxtAddress + TxtSep + StrLstMemo.Strings[CntIndex];
          TxtSep := ', ';
        end;
      finally
        StrLstMemo.free;;
      end;
    end;
    DmdFpnUtils.CloseInfo;

    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtAddress + SepCol + TxtAddress,
                    False, False, True);
    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtCompanyBankInfo + SepCol +
                    TxtINN + '/' + TxtKPP, False, False, True);
    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtSupplierAddress + SepCol +
                    TxtName + ', ' + TxtStreet + ', ' + TxtCodPost + ' ' +
                    TxtMunicip, False, False, True);
    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtStoreNumber + SepCol +
                    DmdFpnUtils.IdtTradeMatrixAssort, False, False, True);
    VspPreview.Text := #10;
  end;
  if FlgItaly then begin
    VspPreview.Text := #13#13;
    for CntIndex := 0 to StrInvAddress.Count - 1 do
      VspPreview.Text := StrInvAddress.Strings[CntIndex] + #13;
  end;
  DrawLogo(ImgLogo);
  // BDES - Invoice with bar code, PRG, R2012.1 - start
  // Print barcode if not multiple ticket and if A4 barcode printing is enabled
  if (DmdFpnInvoice.LstTickets.Count=1) and (BarcodeReturn.PrintOnA4Invoice) then begin
    DatTransBegin := DateTimeToStDate(TObjTransTicket
                       (DmdFpnInvoice.LstTickets[CntTickets]).DatTransBegin);
    NumTicket     := TObjTransTicket
                       (DmdFpnInvoice.LstTickets[CntTickets]).IdtPOSTransaction;
    NumCashdesk   := TObjTransTicket
                       (DmdFpnInvoice.LstTickets[CntTickets]).IdtCheckOut;
    CreateBarCode(DatTransBegin,NumTicket,NumCashdesk);
    PrintBarCode;
    DestroyBarCode;
  end;  
  // BDES - Invoice with bar code, PRG, R2012.1 - end
end;  // of TFrmVSRptInvoiceCA.PrintGeneralInfo

//==============================================================================

procedure TFrmVSRptInvoiceCA.PrintGeneralInvoiceInfo;
var
  CntTickets       : Integer;          // Loop all tickets
  TxtSep           : string;           // Seperator
  TxtAllTickets    : string;           // All tickets to print
  TxtAllTickDates  : string;           // Dates of all tickets to print
  TxtInvoice       : string;           // Invoice number
  TxtTradeMatrix   : string;           // IdtTradeMatrix
  TxtNumber        : string;           // Number of invoice/creditnote
  TxtDocKind       : string;           // First copy or duplicate
begin  // of TFrmVSRptInvoiceCA.PrintGeneralInvoiceInfo
  if not FlgRussia then
    VspPreview.CurrentY := VspPreview.CurrentY + 250
  else
    VspPreview.CurrentY := ViValRptDupliRuPoxY + 300;

  if FlgDuplicate then
    TxtDocKind := cttxtDuplicate;
  for CntTickets := 0 to Pred (DmdFpnInvoice.LstTickets.Count) do begin
    TxtAllTickets := TxtAllTickets + TxtSep +
       IntToStr (TObjTransTicket (
                       DmdFpnInvoice.LstTickets[CntTickets]).IdtPOSTransaction);
    TxtAllTickDates := TxtAllTickDates + TxtSep + DateToStr(TObjTransTicket (
                       DmdFpnInvoice.LstTickets[CntTickets]).DatTransBegin);
    TxtSep := ', ';
  end;  
  if CodKind = CodKindDelivNote then begin
    VspPreview.Text := CtTxtDelivNoteNumber + ' : ' +
        IntToStr (TObjTransTicket (
                               DmdFpnInvoice.LstTickets[0]).IdtDelivNote) + #10;
    VspPreview.Text := CtTxtTicketDate + ' : ' + TxtAllTickDates + #10;
    VspPreview.Text := CtTxtDelivNoteDate + ' : ' +
        DateToStr (TObjTransTicket (
                               DmdFpnInvoice.LstTickets[0]).DtmDelivNote) + #10;
  end
  else begin
    // SPAIN V1
    TxtInvoice := Trim(IntToStr (TObjTransTicket (
                                DmdFpnInvoice.LstTickets[0]).IdtInvoice));
    TxtTradeMatrix := DmdFpnUtils.IdtTradeMatrixAssort;
    If NumStoreNrLength = 0 then
      TxtNumber := FillString('0', NumInvoiceNrLength -
                   length(trim(TxtInvoice))) + TxtInvoice
    else
      TxtNumber := FillString('0', NumStoreNrLength  -
                   length(trim(TxtTradeMatrix))) + TxtTradeMatrix + '-' +
                   FillString('0', NumInvoiceNrLength -
                   length(trim(TxtInvoice))) + TxtInvoice ;
    If not flgrussia then
      TxtNumber := TxtNumber + #10;
    If FlgCreditNote then begin
      if not FlgRussia then
        if FlgItaly then
          VspPreview.Text := CtTxtCreditNoteNr + ' : ' + TxtTradeMatrix + ' ' +
                             TxtNumber + #10
        else
          VspPreview.Text := CtTxtCreditNoteNr + ' : ' + TxtNumber + #10
      else begin
        //if copy: other title
        if not FlgPrintCopy then begin
          VspPreview.Text := TxtDocKind + ' ' + CtTxtCreditNoteNr + '         '
             + CtTxtOn + ' ' +
             FormatDateTime ('dd-mmmm-yyyy',TObjTransTicket (
                                 DmdFpnInvoice.LstTickets[0]).DtmInvoice) + #10;
        end
        else begin
          VspPreview.Text := TxtDocKind + ' ' + CtTxtCopyInvoice + '         ' +
             CtTxtOn + ' ' +
             FormatDateTime ('dd-mmmm-yyyy',TObjTransTicket (
                                 DmdFpnInvoice.LstTickets[0]).DtmInvoice) + #10;
        end;
      end;
      if flgItaly then
        VspPreview.Text := CtTxtOriginalInvoice + ' : ' +
                             IntToStr (TObjTransTicketCA (
                             DmdFpnInvoice.LstTickets[0]).IdtInvoiceOrig) + #10;
    end
    else begin
      if not FlgRussia then
        if FlgItaly then
          VspPreview.Text := CtTxtInvoiceNumber + ' : ' + TxtTradeMatrix + ' ' + TxtNumber
        else
          VspPreview.Text := CtTxtInvoiceNumber + ' : ' + TxtNumber
      else begin
       //extend with duplicate/first copy and don't print number
        if not FlgPrintCopy then begin
          VspPreview.Text := TxtDocKind + ' ' + CtTxtInvoiceNumber + '         '
            + CtTxtOn + ' ' +
            FormatDateTime ('dd-mmmm-yyyy',TObjTransTicket (
                                 DmdFpnInvoice.LstTickets[0]).DtmInvoice) + #10;
        end
        else begin
          VspPreview.Text := TxtDocKind + ' ' + CtTxtCopyInvoice + '         ' +
             CtTxtOn + ' ' +
            FormatDateTime ('dd-mmmm-yyyy',TObjTransTicket (
                                 DmdFpnInvoice.LstTickets[0]).DtmInvoice) + #10;
        end;
      end;
    end;

    if FlgItaly then begin
      VspPreview.CurrentX := ViValRptDupliPoxX;
      if FlgCreditnote then
        VspPreview.CurrentY := VspPreview.CurrentY - 400;
    end;

    if (not FlgFiscal) and (not FlgRussia) and (not FlgInvForm) then begin      // R2012.1 - BRES - Format de facture, TT
      if not FlgInvForm then
        VspPreview.Text := CtTxtTicketDate + ' : ' + TxtAllTickDates + #10;
    end;                                                                       // R2012.1 - BRES - Format de facture, TT
    if not FlgRussia then begin
      if FlgCreditnote then
        VspPreview.Text := CtTxtCreditnoteDate + ' : ' +
          DateToStr (TObjTransTicket (
                                  DmdFpnInvoice.LstTickets[0]).DtmInvoice) + #10
      else
        VspPreview.Text := CtTxtInvoiceDate + ' : ' +
          DateToStr (TObjTransTicket (
                                 DmdFpnInvoice.LstTickets[0]).DtmInvoice) + #10;
    end;
  end;

  TxtSep := '';

  If not FlgRussia then begin
    if FlgItaly then
      VspPreview.CurrentX := ViValRptDupliPoxX;
    VspPreview.Text := CtTxtTicketNr + ' : ' + TxtAllTickets + #10;
    // R2012.1 - BRES - Format de facture, TT - Start
    if (not FlgFiscal) and (FlgInvForm) then
      VspPreview.Text := CtTxtTicketDate + ' : ' + TxtAllTickDates + #10;
    // R2012.1 - BRES - Format de facture, TT - End
    if FlgItaly then
      VspPreview.CurrentX := ViValRptDupliPoxX;
    VspPreview.Text := CtTxtPage + ' : ' + IntToSTr (VspPreview.PageCount) + #10;
  end;

end;   // of TFrmVSRptInvoiceCA.PrintGeneralInvoiceInfo

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintDeliveryNoteInfo;
var
  TxtName          : string;           // Customer name
  TxtStreet        : string;           // Street
  TxtZipCod        : string;           // Zipcode
  TxtMunicip       : string;           // Municipality
  TxtProvince      : string;           // Province  
  TxtDatTransBegin : string;           // Date of transaction
  TxtFldProvince   : string;
  FlgProvince      : Boolean;
begin  // of TFrmVSRptInvoiceCA.PrintDeliveryNoteInfo
  FlgProvince           := False;
  VspPreview.MarginLeft := ViValRptDelivPosX;
  VspPreview.CurrentX := ViValRptDelivPosX;
  if FlgItaly then
    VspPreview.CurrentY := VspPreview.CurrentY + (StrInvAddress.Count * 200) + 200
  else
    VspPreview.CurrentY := VspPreview.CurrentY + 150;
  ValRptInvoicePosY     := VspPreview.CurrentY;
  VspPreview.Font.Size  := ViValSizeTitDeliv;
  VspPreview.Font.Style := VspPreview.Font.Style + [fsBold, fsUnderline];
  VspPreview.Text       := #13 + CtTxtDelivAddress + #10;
  VspPreview.Font.Style := VspPreview.Font.Style - [fsBold, fsUnderline];
  VspPreview.Font.Size  := ViValSizeDeliv;
  VspPreview.Text       := #10;
  VspPreview.CurrentY   := VspPreview.CurrentY - 150;
  try
    TxtName          := '';
    TxtStreet        := '';
    TxtZipcod        := '';
    TxtMunicip       := '';
    TxtProvince      := '';
    TxtFldProvince   := '';
    TxtCustName      := '';
    TxtDatTransBegin := AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat + ' ' +
                          ViTxtDBHouFormat, DsrPOSTransIdts.DataSet.
                          FieldByName('DatTransBegin').AsDateTime), '''');
    if DmdFpnUtils.FieldExists('Customer', 'TxtProvince') then begin
      TxtFldProvince := ',  TxtProvince ';
      FlgProvince    := True;
    end;
   if FlgFrance then begin                                                                           // R2012.1 Address De facturation (SM) ::START
    if DmdFpnUtils.QueryInfo
       (#10'SELECT ' +
        #10'  POSTransCust.TxtName,' +
        #10'  Address.TxtStreet,' +
        #10'  Municipality.TxtCodPost,' +                                                 //R2012.1 System testing 1 Fix (SM)
        #10'  Municipality.TxtName as TxtMunicip ' +                                      //R2012.1 System testing 1 Fix (SM)
        #10 + Trim(TxtFldProvince) + ' ' +
        #10'FROM ' +
        #10'  POSTransCust ' +
        #10' Inner Join Address ON ' +
        #10' Postranscust.IdtCustomer = Address.IdtCustomer ' +
        #10' Inner Join Municipality ON ' +                                                //R2012.1 System testing 1 Fix (SM)
        #10' Address.IdtMunicipality = Municipality.IdtMunicipality ' +                    //R2012.1 System testing 1 Fix (SM)
        #10'WHERE ' +
        #10'  (IdtPOSTransaction = ' + DsrPOSTransIdts.DataSet.
            FieldByName('IdtPOSTransaction').AsString + ')' +
        #10' AND Address.Codapplic in (1,202)' +
        #10' AND (IdtCheckout = ' + DsrPOSTransIdts.DataSet.
            FieldByName ('IdtCheckout').AsString + ')' +
        #10' AND (CodTrans = ' + DsrPOSTransIdts.DataSet.
            FieldByName ('CodTrans').AsString + ')' +
        #10' AND (DatTransBegin = ' + TxtDatTransBegin + ')') then begin
      TxtName    := DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString;
      TxtCustName := TxtName;
      TxtStreet  := DmdFpnUtils.QryInfo.FieldByName('TxtStreet').AsString;
      TxtZipcod  := DmdFpnUtils.QryInfo.FieldByName('TxtCodPost').AsString;                  //R2012.1 System testing 1 Fix (SM)
      TxtMunicip := DmdFpnUtils.QryInfo.FieldByName('TxtMunicip').AsString;
      if FlgProvince then
        TxtProvince := ' (' +
                DmdFpnUtils.QryInfo.FieldByName('TxtProvince').AsString + ')';
    end;
    end else begin                   // of if ViFlgisBDFR                                                                     // R2012.1 Address De facturation (SM) ::END
    if DmdFpnUtils.QueryInfo
       (#10'SELECT ' +
        #10'  TxtName,' +
        #10'  TxtStreet,' +
        #10'  TxtCodPost,' +
        #10'  TxtMunicip ' +
        #10 + Trim(TxtFldProvince) + ' ' +
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
      TxtName    := DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString;
      TxtCustName := TxtName;
      TxtStreet  := DmdFpnUtils.QryInfo.FieldByName ('TxtStreet').AsString;
      TxtZipcod  := DmdFpnUtils.QryInfo.FieldByName('TxtCodPost').AsString;
      TxtMunicip := DmdFpnUtils.QryInfo.FieldByName('TxtMunicip').AsString;
      if FlgProvince then
        TxtProvince := ' (' +
                DmdFpnUtils.QryInfo.FieldByName('TxtProvince').AsString + ')';
    end;            //Address de Facturation      SM ,R2012.1 
   end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
  VspPreview.Text := TxtName + #10;
  VspPreview.Text := TxtStreet + #10;
  VspPreview.Text := TxtZipcod + ' ' + TxtMunicip + TxtProvince + #10;
end;   // of TFrmVSRptInvoiceCA.PrintDeliveryNoteInfo

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintInvoiceNoteInfo;
var
  TxtName          : string;           // Customer name
  TxtStreet        : string;           // Street
  TxtStreetNum     : string;           // House Number
  TxtZipCod        : string;           // Zipcode
  TxtMunicip       : string;           // Municipality
  TxtProvince      : string;           // Province
  TxtVATCode       : string;           // VAT code
  TxtDatTransBegin : string;           // Date of transaction
  TxtFldProvince   : string;
  TxtINN           : string;
  TxtKPP           : string;
  TxtOKPO          : string;
  TxtCompanyType   : string;
  CntTickets       : Integer;
  TxtAllTickets    : string;
  TxtAllTickDates  : string;
  TxtSep           : string;
  FlgProvince      : Boolean;
  CustAddress      : integer;
begin  // of TFrmVSRptInvoiceCA.PrintInvoiceNoteInfo
  FlgProvince := False;
  // If we want to print an Delivery note, don't print the invoice information.
  if CodKind = CodKindDelivNote then
    Exit;
  if not FlgRussia then begin
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    if FlgClientIntracom then begin
      VspPreview.CurrentX   := ViValCiRptInvoicePosX;
      VspPreview.MarginLeft := ViValCiRptInvoicePosX;
    end
    else begin
      VspPreview.CurrentX   := ViValRptInvoicePosX;
      VspPreview.MarginLeft := ViValRptInvoicePosX;
    end
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  end // of if not FlgRussia
  else begin
    VspPreview.MarginLeft := ViValRptMatrixPosX;
    VspPreview.CurrentX   := ViValRptMatrixPosX;
  end; // of else begin
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  if FlgClientIntracom then
    VspPreview.CurrentY  := ValRptInvoicePosY + 600      // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del2
  else
    VspPreview.CurrentY  := ValRptInvoicePosY;
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  VspPreview.Font.Size := ViValSizeTitInvoice;
  if not FlgRussia then begin
    VspPreview.Font.Style := VspPreview.Font.Style + [fsBold, fsUnderline];
    if FlgCreditnote then
      VspPreview.Text := CtTxtCreditNoteAddress + #10
    else
      VspPreview.Text := CtTxtInvoiceAddress + #10;
    VspPreview.Font.Style := VspPreview.Font.Style - [fsBold, fsUnderline];
  end; // of if not FlgRussia
  VspPreview.Font.Size := ViValSizeInvoice;
  VspPreview.Text := #10;
  if FlgRussia then begin
    VspPreview.MarginLeft := ViValRptMatrixPosX;
    VspPreview.CurrentY := ViValRptRuInfoPosY;
    VspPreview.CurrentX := ViValRptMatrixPosX;
  end // of if FlgRussia
  else
    if not  FlgClientIntracom then       // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del2
      VspPreview.CurrentY := VspPreview.CurrentY - 150;
  //Get info
  try
    TxtName          := '';
    TxtStreet        := '';
    TxtStreetNum     := '';
    TxtZipcod        := '';
    TxtMunicip       := '';
    TxtProvince      := '';
    TxtVATCode       := '';
    TxtINN           := '';
    TxtKPP           := '';
    TxtOKPO          := '';
    TxtCompanyType   := '';
    TxtFldProvince   := '';
    TxtDatTransBegin := AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat + ' ' +
                          ViTxtDBHouFormat, DsrPOSTransIdts.DataSet.
                          FieldByName('DatTransBegin').AsDateTime), '''');
    if DmdFpnutils.FieldExists('Customer', 'TxtProvince') then begin
      TxtFldProvince := ', TxtProvince';
      FlgProvince    := True;
    end;
   if FlgFrance then begin                                                        // R2012.1 Address De facturation (SM) ::START
    if DmdFpnUtils.QueryInfo
       (#10'SELECT ' +
        #10'  POSTransCust.IdtCustomer, POSTransCust.CodCreator, POSTransCust.TxtName,  Address.TxtStreet,Municipality.TxtCodPost,' +       //R2012.1 System testing 1 Fix (SM)
        #10'  Municipality.TxtName as TxtMunicip, POSTransCust.TxtNumVAT, TxtINN, TxtKPP, TxtOKPO, TxtCompanyType ' +                       //R2012.1 System testing 1 Fix (SM)
        Trim(TxtFldProvince) + ' ' +
        #10'FROM ' +
        #10' POSTransCust ' +
        #10' Inner Join Address ON ' +
        #10' Postranscust.IdtCustomer = Address.IdtCustomer ' +
        #10' Inner Join Municipality ON ' +                                                //R2012.1 System testing 1 Fix (SM)
        #10' Address.IdtMunicipality = Municipality.IdtMunicipality ' +                    //R2012.1 System testing 1 Fix (SM)
        #10' WHERE ' +
        #10'  (IdtPOSTransaction = ' + DsrPOSTransIdts.DataSet.
            FieldByName ('IdtPOSTransaction').AsString + ')' +
        #10' AND (IdtCheckout = ' + DsrPOSTransIdts.DataSet.
            FieldByName ('IdtCheckout').AsString + ')' +
        #10' AND Address.Codapplic=203' +
        #10' AND (CodTrans = ' + DsrPOSTransIdts.DataSet.
            FieldByName ('CodTrans').AsString + ')' +
        #10' AND (DatTransBegin = ' + TxtDatTransBegin + ')') then begin
      TxtName    := DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString;
      TxtStreet  := DmdFpnUtils.QryInfo.FieldByName ('TxtStreet').AsString;
      TxtZipcod  := DmdFpnUtils.QryInfo.FieldByName('TxtCodPost').AsString;               //R2012.1 System testing 1 Fix (SM)
      TxtMunicip := DmdFpnUtils.QryInfo.FieldByName('TxtMunicip').AsString;
      TxtVATCode := DmdFpnUtils.QryInfo.FieldByName('TxtNumVAT').AsString;
      IdtCustomer := DmdFpnUtils.QryInfo.FieldByName('IdtCustomer').AsInteger;
      if FlgProvince then
        TxtProvince := ' (' +
                DmdFpnUtils.QryInfo.FieldByName('TxtProvince').AsString + ')';
      if FlgRussia then begin
        TxtINN         := DmdFpnUtils.QryInfo.FieldByName ('TxtINN').AsString;
        TxtKPP         := DmdFpnUtils.QryInfo.FieldByName ('TxtKPP').AsString;
        TxtOKPO        := DmdFpnUtils.QryInfo.FieldByName('TxtOKPO').AsString;
        TxtCompanyType := DmdFpnUtils.QryInfo.FieldByName('TxtCompanyType').AsString;

      end; // of if FlgRussia
      end                                                                           //  (System test 1 defect fix) ::START (SM)
      else begin
      DmdFpnUtils.QryInfo.Close;
      if DmdFpnUtils.QueryInfo
       (#10'SELECT ' +
        #10'  POSTransCust.IdtCustomer, POSTransCust.CodCreator, POSTransCust.TxtName,  Address.TxtStreet,Municipality.TxtCodPost,' +
        #10'  Municipality.TxtName as TxtMunicip, POSTransCust.TxtNumVAT, TxtINN, TxtKPP, TxtOKPO, TxtCompanyType ' +
        Trim(TxtFldProvince) + ' ' +
        #10'FROM ' +
        #10' POSTransCust ' +
        #10' Inner Join Address ON ' +
        #10' Postranscust.IdtCustomer = Address.IdtCustomer ' +
        #10' Inner Join Municipality ON ' +
        #10' Address.IdtMunicipality = Municipality.IdtMunicipality ' +
        #10' WHERE ' +
        #10'  (IdtPOSTransaction = ' + DsrPOSTransIdts.DataSet.
            FieldByName ('IdtPOSTransaction').AsString + ')' +
        #10' AND (IdtCheckout = ' + DsrPOSTransIdts.DataSet.
            FieldByName ('IdtCheckout').AsString + ')' +
        #10' AND Address.Codapplic in (1,202)' +
        #10' AND (CodTrans = ' + DsrPOSTransIdts.DataSet.
            FieldByName ('CodTrans').AsString + ')' +
        #10' AND (DatTransBegin = ' + TxtDatTransBegin + ')') then begin
      TxtName    := DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString;
      TxtStreet  := DmdFpnUtils.QryInfo.FieldByName ('TxtStreet').AsString;
      TxtZipcod  := DmdFpnUtils.QryInfo.FieldByName('TxtCodPost').AsString;
      TxtMunicip := DmdFpnUtils.QryInfo.FieldByName('TxtMunicip').AsString;
      TxtVATCode := DmdFpnUtils.QryInfo.FieldByName('TxtNumVAT').AsString;
      IdtCustomer := DmdFpnUtils.QryInfo.FieldByName('IdtCustomer').AsInteger;
      if FlgProvince then
        TxtProvince := ' (' +
                DmdFpnUtils.QryInfo.FieldByName('TxtProvince').AsString + ')';
      if FlgRussia then begin
        TxtINN         := DmdFpnUtils.QryInfo.FieldByName ('TxtINN').AsString;
        TxtKPP         := DmdFpnUtils.QryInfo.FieldByName ('TxtKPP').AsString;
        TxtOKPO        := DmdFpnUtils.QryInfo.FieldByName('TxtOKPO').AsString;
        TxtCompanyType := DmdFpnUtils.QryInfo.FieldByName('TxtCompanyType').AsString;
      end; // of if FlgRussia
    end; // of if DmdFpnUtils.QueryInfo
   end                                                                                                           //  (System test 1 defect fix) ::End (SM)
  end else begin     // of if ViFlgisBDFR                                                                        // R2012.1 Address De facturation (SM) ::END
    if DmdFpnUtils.QueryInfo
       (#10'SELECT ' +
        #10'  IdtCustomer, CodCreator, TxtName,  TxtStreet,  TxtCodPost,' +
        #10'  TxtMunicip, TxtNumVAT, TxtINN, TxtKPP, TxtOKPO, TxtCompanyType ' +
        Trim(TxtFldProvince) + ' ' +
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
      TxtName    := DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString;
      TxtStreet  := DmdFpnUtils.QryInfo.FieldByName ('TxtStreet').AsString;
      TxtZipcod  := DmdFpnUtils.QryInfo.FieldByName('TxtCodPost').AsString;
      TxtMunicip := DmdFpnUtils.QryInfo.FieldByName('TxtMunicip').AsString;
      TxtVATCode := DmdFpnUtils.QryInfo.FieldByName('TxtNumVAT').AsString;
      IdtCustomer := DmdFpnUtils.QryInfo.FieldByName('IdtCustomer').AsInteger;
      if FlgProvince then
        TxtProvince := ' (' +
                DmdFpnUtils.QryInfo.FieldByName('TxtProvince').AsString + ')';
      if FlgRussia then begin
        TxtINN         := DmdFpnUtils.QryInfo.FieldByName ('TxtINN').AsString;
        TxtKPP         := DmdFpnUtils.QryInfo.FieldByName ('TxtKPP').AsString;
        TxtOKPO        := DmdFpnUtils.QryInfo.FieldByName('TxtOKPO').AsString;
        TxtCompanyType := DmdFpnUtils.QryInfo.FieldByName('TxtCompanyType').AsString;
        end;  // of if FlgRussia
      end;   //of if DmdFpnUtils.QueryInfo
    end; // of ViflgisBDFR
  finally
    DmdFpnUtils.CloseInfo;
  end; // of try... finally
  //Print info
  if not FlgRussia then begin
    VspPreview.Text := TxtName + #10;
    VspPreview.Text := TxtStreet + #10;
    VspPreview.Text := TxtZipcod + ' ' + TxtMunicip + TxtProvince + #10;
    VspPreview.Text := #10;
    VspPreview.CurrentY := VspPreview.CurrentY - 150;
    VspPreview.Text := CtTxtCustNumber + ' : ' + IntToStr (IdtCustomer) + #10;
    VspPreview.Text := CtTxtVATCode + ' : ' + TxtVATCode + #10;
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    if FlgClientIntracom then begin                                              // BDFR - Evol2
      VspPreview.BrushStyle := bsTransparent;                                   // ..
      VspPreview.BrushColor := clBlack;
      VspPreview.TextBox (' ' + TxtClientIntraLine2 + ' '
                          + TxtClientIntraLine3, VspPreview.CurrentX,
                          VspPreview.CurrentY + 200, ViValRptClientIntracomWidth,     // ..
                          ViValRptClientIntracomHeight, True, False, True);     // BDFR - Evol2
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
    // Commented as part of Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
    //if IsClientIntraCom then begin                                              // BDFR - Evol2
    //  VspPreview.BrushStyle := bsTransparent;                                   // ..
    //  VspPreview.BrushColor := clBlack;
    //  VspPreview.TextBox (' ' + TxtClientIntraLine2 + #10 + ' '
    //                      + TxtClientIntraLine3 + #10, VspPreview.CurrentX,
    //                      VspPreview.CurrentY, ViValRptClientIntracomWidth,     // ..
    //                      ViValRptClientIntracomHeight, True, False, True);     // BDFR - Evol2
    end;
  end // of if not FlgRussia
  else begin
    //RUSSIA
    BuildTableRuFmt;
    VspPreview.TableBorder :=  tbNone;
    VspPreview.CurrentY    :=  ViValRptRuInfoPosY;
    for CntTickets := 0 to Pred (DmdFpnInvoice.LstTickets.Count) do begin
      TxtAllTickets := TxtAllTickets + TxtSep + IntToStr (TObjTransTicket (
                       DmdFpnInvoice.LstTickets[CntTickets]).IdtPOSTransaction);
      TxtAllTickDates := TxtAllTickDates + TxtSep +
                         FormatDateTime('dd-mmmm-yyyy',TObjTransTicket (
                         DmdFpnInvoice.LstTickets[CntTickets]).DatTransBegin);
      TxtSep := ', ';
    end;
    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtCustomerInfo + SepCol + TxtName
                    + ', ' + TxtStreet, False, False, True);
    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtNrDateTicket + SepCol +
                    TxtAllTickets + ' ' + CtTxtOn + ' ' + TxtAllTickDates,
                    False, False, True);
    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtCustomerName + SepCol +
                    TxtName, False, False, True);
    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtAddress + SepCol + TxtStreet,
                    False, False, True);
    VspPreview.AddTable(TxtTableRuFmt, '', CtTxtCustomerBankInfo + SepCol +
                    TxtINN + '/' + TxtKPP, False, False, True);
  end;
end;   // of TFrmVSRptInvoiceCA.PrintInvoiceNoteInfo

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateCorrectionLine : string;
begin  // of TFrmVSRptInvoiceCA.GenerateCorrectionLine
  Result := SepCol + ObjCurrentTrans.TxtDescrTakeback
end;   // of TFrmVSRptInvoiceCA.GenerateCorrectionLine

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateCommentLine : string;
begin  // of TFrmVSRptInvoiceCA.GenerateCommentLine
  Result := SepCol + ObjCurrentTrans.TxtDescrComment;
end;   // of TFrmVSRptInvoiceCA.GenerateCommentLine

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateFreeLine : string;
begin  // of TFrmVSRptInvoiceCA.GenerateFreeLine
  Result := SepCol + ObjCurrentTrans.TxtDescrFree
end;   // of TFrmVSRptInvoiceCA.GenerateFreeLine

//==============================================================================

function TFrmVSRptInvoiceCA.GeneratePromoNormalLine
                                          (NumPriceToPrint : Currency) : string;
var
  TxtQtyArt        : string;           // Converted qty article
begin  // of TFrmVSRptInvoiceCA.GeneratePromoNormalLine
  TxtQtyArt := CurrToStrF (ObjCurrentTrans.QtyArt, ffFixed,
                           DmdFpnUtils.QtyDecsPrice + 1);
  If not FlgRussia then begin
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    if FlgClientIntracom then
      Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrTurnOver + SepCol +
              TxtQtyArt + SepCol + CurrToStrF((NumPriceToPrint),
                    ffFixed, DmdFpnUtils.QtyDecsPrice)
    else
      Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrTurnOver + SepCol +
              TxtQtyArt + SepCol +
              CurrToStrF
               ((( NumPriceToPrint / (ObjCurrentTrans.PctVATCode + 100)) * 100),
                    ffFixed, DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF (NumPriceToPrint, ffFixed, DmdFpnUtils.QtyDecsPrice);
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  end
  else begin
    Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrTurnOver + SepCol +
              TObjTransactionCA(ObjCurrentTrans).TxtSalesUnit + SepCol +
              TxtQtyArt + SepCol +
              CurrToStrF
               ((( NumPriceToPrint / (ObjCurrentTrans.PctVATCode + 100)) * 100),
                    ffFixed, DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF
               ((( NumPriceToPrint / (ObjCurrentTrans.PctVATCode + 100)) * 100),
                    ffFixed, DmdFpnUtils.QtyDecsPrice) ;
  end;
end;   // of TFrmVSRptInvoiceCA.GeneratePromoNormalLine

//==============================================================================

function TFrmVSRptInvoiceCA.GeneratePromoLine : string;
begin  // of TFrmVSRptInvoiceCA.GeneratePromoLine
  Result := '';
  if not FlgRussia then begin
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    (*Printing Promotion line for an article*)
    if FlgClientIntracom then
    Result := ObjCurrentTrans.IdtArticle + SepCol +
            ObjCurrentTrans.TxtDescrProm + SepCol +
            ' ' + SepCol +
            CurrToStrF (ObjCurrentTrans.PrcPromExclVAT, ffFixed,
                      DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValPromExclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.PctDisc, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValDiscExclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValPromExclVAT +
                        ObjCurrentTrans.ValDiscExclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice)
    else
      Result := ObjCurrentTrans.IdtArticle + SepCol +
            ObjCurrentTrans.TxtDescrProm + SepCol +
            ' ' + SepCol +
            SepCol +
            CurrToStrF (ObjCurrentTrans.PrcPromInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValPromInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.PctDisc, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValDiscInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValPromInclVAT +
                        ObjCurrentTrans.ValDiscInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            IntToStr (ObjCurrentTrans.IdtVATCode);
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  end
  else begin
    Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrProm + SepCol +
              TObjTransactionCA(ObjCurrentTrans).TxtSalesUnit + SepCol +  // Sales unit
              ' ' + SepCol +  // Quantity
              ' ' + SepCol +  // Price without vat
              ' ' + SepCol +  //Total Excl VAT
              ' ' + SepCol +  //unknown column
              CurrToStrF (ObjCurrentTrans.PctVatCode, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              '' + SepCol  +
              CurrToStrF (ObjCurrentTrans.ValPromInclVAT +
                          ObjCurrentTrans.ValDiscInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              TObjTransactionCA(ObjCurrentTrans).TxtISOCountry + SepCol +
              Trim(TObjTransactionCA(ObjCurrentTrans).NumGTD);
  end;
end;   // of TFrmVSRptInvoiceCA.GeneratePromoLine

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateNormalLine (NumTotalToPrint : Currency) :
                                                                         string;
var
  TxtQtyArt        : string;           // Converted qty article
begin  // of TFrmVSRptInvoiceCA.GenerateNormalLine
  TxtQtyArt := CurrToStrF (ObjCurrentTrans.QtyArt, ffFixed,
                           DmdFpnUtils.QtyDecsPrice); // - 1); Commented to get 2 dec place   // Modified Bug #181, TCS(KB), R2011.1.EUR5
  if not FlgRussia then begin
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    if FlgClientIntracom then
      Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrTurnOver + SepCol +
              TxtQtyArt + SepCol +
              CurrToStrF
                  ((( ObjCurrentTrans.PrcInclVAT /
                      (ObjCurrentTrans.PctVATCode + 100)) * 100), ffFixed,
                      DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF (ObjCurrentTrans.ValExclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF (ObjCurrentTrans.PctDisc, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF (ObjCurrentTrans.ValDiscExclVAT, ffFixed,         //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF (NumTotalToPrint, ffFixed,
                          DmdFpnUtils.QtyDecsPrice)
    else
      Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrTurnOver + SepCol +
              TxtQtyArt + SepCol +
              CurrToStrF
                  ((( ObjCurrentTrans.PrcInclVAT /
                      (ObjCurrentTrans.PctVATCode + 100)) * 100), ffFixed,
                      DmdFpnUtils.QtyDecsPrice) + SepCol +
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
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  end
  else begin
    Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrTurnOver + SepCol +
              TObjTransactionCA(ObjCurrentTrans).TxtSalesUnit + SepCol +
              TxtQtyArt + SepCol +
              CurrToStrF
                  ((( ObjCurrentTrans.PrcInclVAT /
                      (ObjCurrentTrans.PctVATCode + 100)) * 100), ffFixed,
                      DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF
                  ((( ObjCurrentTrans.ValInclVAT /
                      (ObjCurrentTrans.PctVATCode + 100)) * 100), ffFixed,
                      DmdFpnUtils.QtyDecsPrice) + SepCol +
              ' ' + SepCol +
              CurrToStrF (ObjCurrentTrans.PctVatCode, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF
                  (ObjCurrentTrans.ValInclVAT -
                      (( ObjCurrentTrans.ValInclVAT /
                      (ObjCurrentTrans.PctVATCode + 100)) * 100), ffFixed,
                      DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF (NumTotalToPrint, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              TObjTransactionCA(ObjCurrentTrans).TxtISOCountry + SepCol +
              TObjTransactionCA(ObjCurrentTrans).NumGTD;
  end;
end;   // of TFrmVSRptInvoiceCA.GenerateNormalLine

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateNormalLinePromo
                                          (NumTotalToPrint : Currency) : string;
var
  TxtQtyArt        : string;           // Converted qty article
begin  // of TFrmVSRptInvoiceCA.GenerateNormalLinePromo
  TxtQtyArt := CurrToStrF (ObjCurrentTrans.QtyArt, ffFixed,
                           DmdFpnUtils.QtyDecsPrice + 1);
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  if FlgClientIntracom then
    Result := ObjCurrentTrans.IdtArticle + SepCol +
            ObjCurrentTrans.TxtDescrTurnOver + SepCol +
            TxtQtyArt + SepCol +
            CurrToStrF
                ((( ObjCurrentTrans.PrcPromInclVAT /
                    (ObjCurrentTrans.PctVATCode + 100)) * 100), ffFixed,
                    DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValPromExclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.PctDisc, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValDiscExclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (NumTotalToPrint, ffFixed,
                        DmdFpnUtils.QtyDecsPrice)
  else
    Result := ObjCurrentTrans.IdtArticle + SepCol +
            ObjCurrentTrans.TxtDescrTurnOver + SepCol +
            TxtQtyArt + SepCol +
            CurrToStrF
                ((( ObjCurrentTrans.PrcPromInclVAT /
                    (ObjCurrentTrans.PctVATCode + 100)) * 100), ffFixed,
                    DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.PrcPromInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValPromInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.PctDisc, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (ObjCurrentTrans.ValDiscInclVAT, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            CurrToStrF (NumTotalToPrint, ffFixed,
                        DmdFpnUtils.QtyDecsPrice) + SepCol +
            IntToStr (ObjCurrentTrans.IdtVATCode);

  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
end;   // of TFrmVSRptInvoiceCA.GenerateNormalLinePromo

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateArticleFreeLine
                                          (NumPriceToPrint : Currency) : string;
var
  TxtQtyArt        : string;           // Converted qty article
  TxtQtyArtPrc     : string;           // Converted qty article * Price
begin  // of TFrmVSRptInvoiceCA.GenerateArticleFreeLine
  TxtQtyArt := CurrToStrF (ObjCurrentTrans.QtyArt, ffFixed,
                           DmdFpnUtils.QtyDecsPrice + 1);
  TxtQtyArtPrc := CurrToStrF (ObjCurrentTrans.QtyArt * NumPriceToPrint, ffFixed,
                              DmdFpnUtils.QtyDecsPrice);
  if not FlgRussia then begin
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    if FlgClientIntracom then
      Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrTurnOver + SepCol +
              TxtQtyArt + SepCol +
              CurrToStrF((NumPriceToPrint),
                    ffFixed, DmdFpnUtils.QtyDecsPrice) + SepCol +
              // Commented as part of Intracom Invoice excl. Tax, ARB, R2011.1.EUR5//Commented
              //CurrToStrF (NumPriceToPrint, ffFixed,
              //              DmdFpnUtils.QtyDecsPrice) + SepCol +
              TxtQtyArtPrc
    else
      Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrTurnOver + SepCol +
              TxtQtyArt + SepCol +
              CurrToStrF
                  (((NumPriceToPrint / (ObjCurrentTrans.PctVATCode + 100)) * 100),
                    ffFixed, DmdFpnUtils.QtyDecsPrice) + SepCol +
              CurrToStrF (NumPriceToPrint, ffFixed,
                            DmdFpnUtils.QtyDecsPrice) + SepCol +
              TxtQtyArtPrc;
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  end
  else begin
    Result := ObjCurrentTrans.IdtArticle + SepCol +
              ObjCurrentTrans.TxtDescrTurnOver + SepCol +
              TObjTransactionCA(ObjCurrentTrans).TxtSalesUnit + SepCol + //Sales Unit
              TxtQtyArt + SepCol +
              CurrToStrF
                  (((NumPriceToPrint / (ObjCurrentTrans.PctVATCode + 100)) * 100),
                    ffFixed, DmdFpnUtils.QtyDecsPrice) + SepCol +
              TxtQtyArtPrc;
  end;
end;   // of TFrmVSRptInvoiceCA.GenerateArticleFreeLine

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateArticleDispositLine : string;
begin  // of TFrmVSRptInvoiceCA.GenerateArticleDispositLine
  if not FlgRussia then begin
    Result := ' ' + SepCol +
              ObjCurrentTrans.TxtDescrAdm + SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              SepCol +
              SepCol +

              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice);
  end
  else begin
    Result := ' ' + SepCol +
              ObjCurrentTrans.TxtDescrAdm + SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              SepCol +
              SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice);
  end;
end;   // of TFrmVSRptInvoiceCA.GenerateArticleDispositLine

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateAdminDepChargeLine : string;
begin  // of TFrmVSRptInvoiceCA.GenerateAdminDepChargeLine
  if not FlgRussia then begin
    Result := SepCol +
              ObjCurrentTrans.TxtDescrAdm + SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice);
  end
  else begin
    Result := SepCol +
              ObjCurrentTrans.TxtDescrAdm + SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              SepCol +
              SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice);
  end;

end;   // of TFrmVSRptInvoiceCA.GenerateAdminDepChargeLine

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateAdminDepTakeBackLine : string;
begin  // of TFrmVSRptInvoiceCA.GenerateAdminDepTakeBackLine
  if not FlgRussia then begin
    Result := SepCol +
              ObjCurrentTrans.TxtDescrAdm + SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice);
  end
  else begin
    Result := SepCol +
              ObjCurrentTrans.TxtDescrAdm + SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice) + SepCol +
              SepCol +
              SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice);
  end;
end;   // of TFrmVSRptInvoiceCA.GenerateAdminDepTakeBackLine

//==============================================================================

function TFrmVSRptInvoiceCA.GenerateAdminDiscCoup : string;
begin  // of TFrmVSRptInvoiceCA.GenerateAdminDiscCoup
  if not FlgRussia then begin
    Result := SepCol +
              ObjCurrentTrans.TxtDescrAdm + SepCol +
              SepCol +
              SepCol +
              SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice);
  end
  else begin
    Result := SepCol +
              ObjCurrentTrans.TxtDescrAdm + SepCol +
              SepCol +
              SepCol +
              SepCol +
              SepCol +
              SepCol +
              SepCol +
              SepCol +
              CurrToStrF (ObjCurrentTrans.ValAdmInclVAT, ffFixed,
                          DmdFpnUtils.QtyDecsPrice);
  end;
end;   // of TFrmVSRptInvoiceCA.GenerateAdminDiscCoup

//==============================================================================

procedure TFrmVSRptInvoiceCA.PrintBodyDetailPayAdvance;
var
  TxtPrint         : string;
begin  // of TFrmVSRptInvoiceCA.PrintBodyDetailPayAdvance

  //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.Start
  if FlgClientIntracom then
    TxtPrint := SepCol + ObjCurrentTrans.TxtDescrTurnOver + SepCol + SepCol +
                SepCol + SepCol + SepCol + SepCol +
                CurrToStrF (-ObjCurrentTrans.ValExclVAT, ffFixed,
                            DmdFpnUtils.QtyDecsPrice)
  else
  //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.End
    TxtPrint := SepCol + ObjCurrentTrans.TxtDescrTurnOver + SepCol + SepCol +
                SepCol + SepCol + SepCol + SepCol + SepCol +
                CurrToStrF (-ObjCurrentTrans.ValInclVAT, ffFixed,
                            DmdFpnUtils.QtyDecsPrice);

  VspPreview.AddTable (TxtTableBodyFmt, '', TxtPrint, False, False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintBodyDetailPayAdvance

//==============================================================================

procedure TFrmVSRptInvoiceCA.PrintBodyDetailTakeBackAdvance;
var
  TxtPrint         : string;
begin  // of TFrmVSRptInvoiceCA.PrintBodyDetailTakeBackAdvance
  //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.Start
  if FlgClientIntracom then
    TxtPrint := SepCol + ObjCurrentTrans.TxtDescrTurnOver + SepCol + SepCol +
                SepCol + SepCol + SepCol + SepCol +
                CurrToStrF (-ObjCurrentTrans.ValExclVAT, ffFixed,
                            DmdFpnUtils.QtyDecsPrice)
  else
  //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1.End
    TxtPrint := SepCol + ObjCurrentTrans.TxtDescrTurnOver + SepCol + SepCol +
                SepCol + SepCol + SepCol + SepCol + SepCol +
                CurrToStrF (-ObjCurrentTrans.ValInclVAT, ffFixed,
                            DmdFpnUtils.QtyDecsPrice);

  VspPreview.AddTable (TxtTableBodyFmt, '', TxtPrint, False, False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintBodyDetailTakeBackAdvance

//==============================================================================

procedure TFrmVSRptInvoiceCA.PrintBodyDetailBOLine;
var
  TxtPrint         : string;
begin  // of TFrmVSRptInvoiceCA.PrintBodyDetailBOLine
  TxtPrint := SepCol + ObjCurrentTrans.TxtDescrAdm;
  VspPreview.AddTable (TxtTableBodyFmt, '', TxtPrint, False, clLtGray, True);
  if ObjCurrentTrans.CodActTakeBack <> 0 then begin
    case ObjCurrentTrans.CodActTurnOver of
      CtCodActPayAdvance    : PrintBodyDetailPayAdvance;
      CtCodActPayForfait    : PrintBodyDetailPayAdvance;
      CtCodActTakeBackForfait:PrintBodyDetailPayAdvance;
      CtCodActChangeAdvance : PrintBodyDetailPayAdvance;
    end;
  end;
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintBodyDetailBOLine

//==============================================================================

procedure TFrmVSRptInvoiceCA.PrintBodyDetailAvoirEmisLine;
var
  TxtPrint         : string;
begin  // of TFrmVSRptInvoiceCA.PrintBodyDetailAvoirEmisLine
  TxtPrint := SepCol + ObjCurrentTrans.TxtDescrAdm;
  VspPreview.AddTable (TxtTableBodyFmt, '', TxtPrint, False, False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintBodyDetailAvoirEmisLine

//==============================================================================

procedure TFrmVSRptInvoiceCA.PrintBodyDetailAdminExtend;
begin  // of TFrmVSRptInvoiceCA.PrintBodyDetailAdminExtend
  case ObjCurrentTrans.CodMainAction of
    CtCodActCheque        : PrintBodyDetailAdmin;
    CtCodActCheque2       : PrintBodyDetailAdmin;
    CtCodActEFT2          : PrintBodyDetailAdmin;
    CtCodActEFT3          : PrintBodyDetailAdmin;
    CtCodActEFT4          : PrintBodyDetailAdmin;
    CtCodActForCurr2      : PrintBodyDetailAdmin;
    CtCodActForCurr3      : PrintBodyDetailAdmin;
    CtCodActMinitel       : PrintBodyDetailAdmin;
    CtCodActCreditAllow   : PrintBodyDetailAdmin;
    CtCodActCreditCust    : PrintBodyDetailAdmin;
    CtCodActDiscCoup      : PrintBodyDetailAdmin;
    CtCodActDiscPers      : if not FlgItaly then PrintBodyDetailAdmin;
//    CtCodActCredCoupCreate: PrintBodyDetailAvoirEmisLine;
    CtCodActCredCoupAccept: PrintBodyDetailAdmin;
    CtCodActGiftCoupon    : PrintBodyDetailGiftCoupon;
    CtCodActPayAdvance    : PrintBodyDetailPayAdvance;
    CtCodActPayForfait    : PrintBodyDetailPayAdvance;
    CtCodActTakeBackForfait:PrintBodyDetailPayAdvance;
    CtCodActChangeAdvance : PrintBodyDetailPayAdvance;
    //CtCodActTakeBackAdvance : PrintBodyDetailTakeBackAdvance;
    CtCodActDocBO         : PrintBodyDetailBOLine;
  end;
end;   // of TFrmVSRptInvoiceCA.PrintBodyDetailAdminExtend

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintBodyDetailLine;
begin  // of TFrmVSRptInvoiceCA.PrintBodyDetailLine
  if ObjCurrentTrans.QtyArt = 0 then
    Exit;

  PrintArticleTakeBackLine;

  // It's not a Free article
  if ObjCurrentTrans.CodActFree = 0 then begin
    // It's a promo price
    if (Abs (ObjCurrentTrans.ValPromInclVAT) >= CtValMinFloat) then begin
      if (ObjCurrentTrans.PrcInclVAT -
          (ObjCurrentTrans.PrcInclVAT/100*ValPercPromDiff))
                                     > Abs (ObjCurrentTrans.PrcPromInclVAT) then
        PrintArticlePromoLine
      else
        PrintArticleNoPromoLine;
    end
    else
      PrintArticleNormalLine;
  end
  else begin
    PrintFreeLine;
    PrintArticleFreeLine;
  end;

  // Disposit
  if Abs (ObjCurrentTrans.ValAdmInclVAT) >= CtValMinFloat then
    PrintArticleDispositLine;
end;   // of TFrmVSRptInvoiceCA.PrintBodyDetailLine

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintArticleNoPromoLine;
var
  NumLineTotal     : Currency;         // Total of the line.
begin  // of TFrmVSRptInvoiceCA.PrintArticleNoPromoLine
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  if FlgClientIntracom then
    NumLineTotal := (ObjCurrentTrans.PrcPromExclVAT * ObjCurrentTrans.QtyArt) +
                                               ObjCurrentTrans.ValDiscExclVAT
  else
  NumLineTotal := (ObjCurrentTrans.PrcPromInclVAT * ObjCurrentTrans.QtyArt) +
                                               ObjCurrentTrans.ValDiscInclVAT;
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateNormalLinePromo (NumLineTotal),
                       False, False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintArticleNoPromoLine

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintBodyDetailAdmin;
begin  // of TFrmVSRptInvoiceCA.PrintBodyDetailAdmin
  case ObjCurrentTrans.CodActAdm of
    CtCodActDepCharge      : PrintAdminDepChargeLine;
    CtCodActDepTakeBack    : PrintAdminDepTakeBackLine;
  end;
end;   // of TFrmVSRptInvoiceCA.PrintBodyDetailAdmin

//==============================================================================

procedure TFrmVSRptInvoiceCA.CalcBodyDetailLine;
begin  // of TFrmVSRptInvoiceCA.CalcBodyDetailLine
  case ObjCurrentTrans.CodMainAction of
    CtCodActPLUKey,
    CtCodActPLUNum,
    CtCodActClassNum,
    CtCodActGiftCard,
    CtCodActClassKey :  begin
      NumTotalItems := NumTotalItems + ObjCurrentTrans.QtyArt;
      if ObjCurrentTrans.CodActFree = 0 then begin
        // It's a promo price
        if Abs (ObjCurrentTrans.ValPromInclVAT) >= CtValMinFloat then
          AddVAT (ObjCurrentTrans.ValPromInclVAT + ObjCurrentTrans.ValDiscInclVAT,
                  IntToStr (ObjCurrentTrans.IdtVATCode),
                  ObjCurrentTrans.PctVATCode)
        // It's not a promo price
        else
          AddVAT (ObjCurrentTrans.ValInclVAT + ObjCurrentTrans.ValDiscInclVAT,
                  IntToStr (ObjCurrentTrans.IdtVATCode),
                  ObjCurrentTrans.PctVATCode);
      end
    end;
    CtCodActRndTotal     : begin
        AddVAT (ObjCurrentTrans.ValAdmInclVAT,
                IntToStr (ObjCurrentTrans.IdtAdmVAT),ObjCurrentTrans.PctAdmVAT);
    end;
    CtCodActPayAdvance : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
    CtCodActPayForfait : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
    CtCodActTakeBackForfait : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
    CtCodActChangeAdvance : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
    CtCodActTakeBackAdvance : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
    CtCodActGiftCoupon: AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
    CtCodActDocBO : begin
      if ObjCurrentTrans.CodActTakeBack <> 0 then begin
        case ObjCurrentTrans.CodActTurnOver of
          CtCodActPayAdvance : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
          CtCodActPayForfait : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
          CtCodActTakeBackForfait : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
          CtCodActChangeAdvance : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
          CtCodActTakeBackAdvance : AddVAT (-ObjCurrentTrans.ValInclVAT, '0', 0);
        end;
      end;
    end;
  end;
end;   // of TFrmVSRptInvoiceCA.CalcBodyDetailLine

//==============================================================================

procedure TFrmVSRptInvoiceCA.BuildBodyDetailLine;
begin  // of TFrmVSRptInvoiceCA.BuildBodyDetailLine
  // In case of a free article

  case ObjCurrentTrans.CodMainAction of
    CtCodActPLUKey         : PrintBodyDetailLine;
    CtCodActPLUNum         : PrintBodyDetailLine;
    CtCodActClassNum       : PrintBodyDetailLine;
    CtCodActClassKey       : PrintBodyDetailLine;
    CtCodActDiscCoup       : PrintBodyDetailAdmin;
    CtCodActCoupExternal   : PrintBodyDetailAdmin;
    CtCodActDePCharge      : PrintBodyDetailAdmin;
    CtCodActDepTakeBack    : PrintBodyDetailAdmin;
    CtCodActDepCoupAccept  : PrintBodyDetailAdmin;
    CtCodActCash           : PrintBodyDetailAdmin;
    CtCodActCoupInternal   : PrintBodyDetailAdmin;
    CtCodActCheque         : PrintBodyDetailAdmin;
    CtCodActEFT            : PrintBodyDetailAdmin;
    CtCodActForCurr        : PrintBodyDetailAdmin;
    CtCodActCreditAllow    : PrintBodyDetailAdmin;
    CtCodActCreditCust     : PrintBodyDetailAdmin;
    CtCodActCreditRepay    : PrintBodyDetailAdmin;
    CtCodActVarious        : PrintBodyDetailAdmin;
    CtCodActReturn         : PrintBodyDetailAdmin;
    CtCodActGiftCard       : PrintBodyDetailLine;
    CtCodActDiscPers       : if not FlgItaly then PrintBodyDetailAdmin;
    else PrintBodyDetailAdminExtend;
  end;

  if (ObjCurrentTrans.CodActComment <> 0) then begin
    if TObjTransactionCA(ObjCurrentTrans).CodType = CtCodPdtCommentDocBoPV_Fichier then
      Exit
    else if (TObjTransactionCA(ObjCurrentTrans).CodTypeD3E = CtCodPdtCommentEcoTaxArticle)
       and (ObjCurrentTrans.QtyArt <> 0) then begin
      if FlgShowEcoTaxInvoiceLine then begin
        PrintLineEcoTax;
      end;
    end
    else begin
      if (TObjTransactionCA(ObjCurrentTrans).CodTypeD3E =
                         CtCodPdtCommentEcoTaxFreeArticle)
         and (ObjCurrentTrans.QtyArt <> 0) then begin
        if (FlgShowEcoTaxInvoiceLine) and (FlgShowEcoTaxFreeArt) then begin
         PrintLineEcoTax;
        end;
      end
      else begin
        if (ObjCurrentTicket.IdtPOSTransaction = 0) and
        ((AnsiCompareText(ObjCurrentTrans.TxtDescrComment, 'BANC') <> 0) and
        (AnsiPOS(ObjCurrentTrans.TxtDescrComment, 'INCONNU') = 0)) then begin
          if (ObjCurrentTrans.CodActTakeBack = 0) and
             (TObjTransactionCA(ObjCurrentTrans).CodType <>
                                            CtCodPdtCommentFiscReceiptInfo) then
            PrintLineComment;
        end;
      end;
    end;
  end;
  if ObjCurrentTrans.CodActAdm = CtCodActRndTotal then
    AddVAT (ObjCurrentTrans.ValAdmInclVAT, IntToStr (ObjCurrentTrans.IdtAdmVAT),
            ObjCurrentTrans.PctAdmVAT);
  if ObjCurrentTrans.QtyArt <>  0 then begin
    //Calculate total ecotax for articles
    if TObjTransactionCA(ObjCurrentTrans).CodTypeD3E =
                                        CtCodPdtCommentEcoTaxArticle then begin
      ValTotalEcoTaxArticle := ValTotalEcoTaxArticle +
                               TObjTransactionCA(ObjCurrentTrans).PrcD3E;
    end
    //Calculate total ecotax for free articles
    else if TObjTransactionCA(ObjCurrentTrans).CodTypeD3E =
                                     CtCodPdtCommentEcoTaxFreeArticle then begin
      ValTotalEcoTaxFreeArticle := ValTotalEcoTaxFreeArticle +
                                   TObjTransactionCA(ObjCurrentTrans).PrcD3E;
    end;
  end;
 // if TObjTransactionCA(ObjCurrentTrans).CodType = CtCodPdtInfoPromo then
 //   PrintLineBon;
end;   // of TFrmVSRptInvoiceCA.BuildBodyDetailLine

//==============================================================================

procedure TFrmVSRptInvoiceCA.MakeTotals;
var
  TxtLine               : string;      // Line to print
  TxtLineTotal          : string;
  TxtFmtLayOut          : string;      // LayOut of the payments
  CntItem               : integer;     // Counter
  CurrentTotalsPosY     : integer;
  CurrentPaymentPosY    : integer;
  FlgTotalPrinted       : Boolean;
begin  // of TFrmVSRptInvoiceCA.MakeTotals
  ValTotalPayed      := 0;
  CurrentPaymentPosY := 0;
  CurrentTotalsPosY  := 0;
  if FlgRussia then begin
    VspPreview.MarginLeft := ViValRptPaymentRuPosX;
    VspPreview.CurrentX := ViValRptPaymentRuPosX;
    CurrentTotalsPosY := ViValRptPaymentPosY;
    CurrentPaymentPosY := ViValRptPaymentPosY;
  end
  else begin
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    if FlgClientIntracom then begin
      VspPreview.MarginLeft := ViValCiRptPaymentPosX;
      VspPreview.CurrentX := ViValCiRptPaymentPosX;
    end
    else begin
      VspPreview.MarginLeft := ViValRptPaymentPosX;
      VspPreview.CurrentX := ViValRptPaymentPosX;
    end
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  end;
  VspPreview.CurrentY := ViValRptPaymentPosY;
  for CntItem := 0 to LstPayments.Count -1 do
    ValTotalPayed := ValTotalPayed + TObjPayment(LstPayments[CntItem]).ValTotal;
  ValTotalToPay := ValTotal - ValTotalPayed - ValReturn;
  if FlgRussia then
    TxtFmtLayOut := '%s' + SepCol + '%s' + SepCol + '%s'
  else
    TxtFmtLayOut :=          '%s' + SepCol + '%s' + SepCol + '%s' +
                    SepCol + '%s' + SepCol + '%s' + SepCol + '%s';
  if not FlgRussia then
    VspPreview.TableBorder := tbNone
  else
    VspPreview.TableBorder := tbBoxColumns;
  //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del4
  (*Flag to avoid printing total twice incase the customer no
  is for Client Intracom but Client Intracom button is not pressed*)
  FlgTotalPrinted := False;
  for CntItem := 0 to LstPayments.Count - 1 do begin
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
	if not FlgRussia and not FlgClientIntracom then begin

      if CntItem = 0 then
        TxtLine := Format (TxtFmtLayOut, [CtTxtNetAmount, CurrToStrF
                     (ValNettoAmount, ffFixed, DmdFpnUtils.QtyDecsPrice),
                     DmdFpnUtils.IdtCurrencyMain, TObjPayment(LstPayments[CntItem]).
                     TxtDescr, CurrToStrF (TObjPayment(LstPayments[CntItem]).ValTotal,
                     ffFixed, DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain])
      else if CntItem = 1 then
        TxtLine := Format (TxtFmtLayOut, [CtTxtTotalVAT, CurrToStrF (ValTotalVAT,
                     ffFixed, DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain,
                     TObjPayment(LstPayments[CntItem]).TxtDescr, CurrToStrF
                     (TObjPayment(LstPayments[CntItem]).ValTotal, ffFixed,
                     DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain])
      else if (CntItem = LstPayments.Count - 1) and (CntItem > 1) then
        TxtLine := Format (TxtFmtLayOut, [CtTxtTotal, CurrToStrF (ValTotal, ffFixed,
                   DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain,
                   TObjPayment(LstPayments[CntItem]).TxtDescr, CurrToStrF
                   (TObjPayment(LstPayments[CntItem]).ValTotal, ffFixed,
                   DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain])
      else
        TxtLine := Format (TxtFmtLayOut, ['', '', '', TObjPayment(LstPayments
                     [CntItem]).TxtDescr, CurrToStrF (TObjPayment(LstPayments
                     [CntItem]).ValTotal, ffFixed, DmdFpnUtils.QtyDecsPrice),
                     DmdFpnUtils.IdtCurrencyMain]);
      VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, False);
    end // of if not FlgRussia
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    else if not FlgRussia and FlgClientIntracom then
    begin
     if CntItem = 0 then begin
          if ansicomparestr(TObjPayment(LstPayments[CntItem]).IdtClassification,TxtIdtClassClntIntra) <> 0 then
            begin
            TxtLine := Format (TxtFmtLayOut, [CtTxtTotalWoVat, CurrToStrF ((ValTotal -ValTotalVAT),
                            ffFixed,DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain,
                            TObjPayment(LstPayments[CntItem]).TxtDescr, CurrToStrF
                            (TObjPayment(LstPayments[CntItem]).ValTotal, ffFixed,
                            DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain]);
            VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, False);
            //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del4
            FlgTotalPrinted := True;
            end
          //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1, Start
          (*We print the total and the payment modes in a single row incase we have
          just on mode of payment used in the transaction*)
          else if  LstPayments.Count = 1 then
            begin
            TxtLine := Format (TxtFmtLayOut, [CtTxtTotalWoVat, CurrToStrF ((ValTotal -ValTotalVAT),
                            ffFixed,DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain,
                            '', '', '']);
            VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, False);
            end
          //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1, End
     end
     else if CntItem = 1 then begin
          if ansicomparestr(TObjPayment(LstPayments[CntItem]).IdtClassification,TxtIdtClassClntIntra) <> 0  then
           begin
           //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del4, Start
            if FlgTotalPrinted = False then
              TxtLine := Format (TxtFmtLayOut, [CtTxtTotalWoVat, CurrToStrF ((ValTotal -ValTotalVAT),
                             ffFixed,DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain,
                              TObjPayment(LstPayments[CntItem]).TxtDescr, CurrToStrF
                              (TObjPayment(LstPayments[CntItem]).ValTotal, ffFixed,
                              DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain])
            else
              TxtLine := Format (TxtFmtLayOut, ['', '', '',
                              TObjPayment(LstPayments[CntItem]).TxtDescr, CurrToStrF
                              (TObjPayment(LstPayments[CntItem]).ValTotal, ffFixed,
                              DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain]);
            VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, False);
            FlgTotalPrinted := True;
            //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del4, End
            end
           end
      //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del1
      //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del4.Start
      //else if (CntItem = LstPayments.Count - 1) and (CntItem > 1) then begin
      //    if ansicomparestr(TObjPayment(LstPayments[CntItem]).IdtClassification,TxtIdtClassClntIntra) = 0  then
      //     begin
      //      TxtLine := Format (TxtFmtLayOut, [CtTxtTotalWoVat, CurrToStrF ((ValTotal -ValTotalVAT),
      //                      ffFixed,DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain,
      //                      '', '', '']);
      //      VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, False);
      //      end
      //     end
     //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del4.End
     // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

     else
     begin
        if comparestr(TObjPayment(LstPayments[CntItem]).IdtClassification,TxtIdtClassClntIntra) <> 0 then
        begin
        TxtLine := Format (TxtFmtLayOut, ['', '', '', TObjPayment(LstPayments
                     [CntItem]).TxtDescr, CurrToStrF (TObjPayment(LstPayments
                     [CntItem]).ValTotal, ffFixed, DmdFpnUtils.QtyDecsPrice),
                     DmdFpnUtils.IdtCurrencyMain]);
        VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, False);
        end
     end
    end
    else
      TxtLineTotal := SepCol + SepCol + SepCol + SepCol + SepCol + Sepcol +
                      SepCol + SepCol + SepCol + CurrToStrF (ValTotalVAT, ffFixed,
                      DmdFpnUtils.QtyDecsPrice) + SepCol + CurrToStrF (ValTotal,
                      ffFixed, DmdFpnUtils.QtyDecsPrice);
  end; // of for CntItem := 0 to LstPayments.Count - 1
  if (LstPayments.Count - 1) < 1 then begin
    if not FlgRussia then begin
      // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
      if not FlgClientIntracom then
        begin
        TxtLine := Format (TxtFmtLayOut, [CtTxtTotalVAT, CurrToStrF (ValTotalVAT,
                   ffFixed, DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain,
                   '','','']);
        VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, False);
        end;
      // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
    end // of if not FlgRussia
    else begin
      TxtLine := Format (TxtFmtLayOut, [CtTxtTotalVAT, CurrToStrF (ValTotalVAT,
                   ffFixed, DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain]);
      VspPreview.MarginLeft := ViValRptTotalsRuPosX;
      VspPreview.CurrentX := ViValRptTotalsRuPosX;
      VspPreview.CurrentY := CurrentTotalsPosY;
      VspPreview.AddTable (TxtTableTotalsFmt, '', TxtLine, False, False, False);
      CurrentTotalsPosY := VspPreview.CurrentY;
    end; // of else begin
  end; // of if (LstPayments.Count - 1) < 1
  if (LstPayments.Count - 1) < 2 then begin
    if not FlgRussia then begin
        // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
        if not FlgClientIntracom then
          begin
          TxtLine := Format (TxtFmtLayOut, [CtTxtTotal, CurrToStrF (ValTotal, ffFixed,
                   DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain, '', '', '']);
          VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, False);
          end
        // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
    end // of if not FlgRussia
    else begin
      VspPreview.MarginLeft := ViValRptTotalsRuPosX;
      VspPreview.CurrentX   := ViValRptTotalsRuPosX;
      VspPreview.CurrentY   := CurrentTotalsPosY;
      TxtLine := Format (TxtFmtLayOut, [CtTxtTotal, CurrToStrF (ValTotal, ffFixed,
                   DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain]);
      VspPreview.AddTable (TxtTableTotalsFmt, '', TxtLine, False, False, False);
    end // of else begin
  end; // of if (LstPayments.Count - 1) < 2
  if not FlgRussia then begin
    if TxtDiffNoReturn <> '' then
      TxtLine := Format (TxtFmtLayOut, ['', '', '', TxtDiffNoReturn, CurrToStrF
                   (-ValTotalToPay, ffFixed, DmdFpnUtils.QtyDecsPrice),
                   DmdFpnUtils.IdtCurrencyMain])
    else
      TxtLine := Format (TxtFmtLayOut, ['', '', '', CtTxtTotalToPay, CurrToStrF
                    (-ValTotalToPay, ffFixed, DmdFpnUtils.QtyDecsPrice),
                    DmdFpnUtils.IdtCurrencyMain]);
  end // of if not FlgRussia
  else begin
    VspPreview.MarginLeft := ViValRptPaymentRuPosX;
    VspPreview.CurrentX   := ViValRptPaymentRuPosX;
    VspPreview.CurrentY   := CurrentPaymentPosY;
    TxtLine := Format (TxtFmtLayOut, [CtTxtTotalToPay, CurrToStrF (-ValTotalToPay,
                 ffFixed, DmdFpnUtils.QtyDecsPrice), DmdFpnUtils.IdtCurrencyMain]);
  end; // of else begin
  VspPreview.AddTable (TxtTablePaymentFmt, '', TxtLine, False, False, True);
  //EcoTax lines
  if not FlgRussia then begin
    if (ValTotalEcoTaxArticle > 0) and FlgShowEcoTaxInvoiceTotal then begin
      TxtLine := Trim(TxtDescrTotInvoice) + ' ' + CurrToStrF (ValTotalEcoTaxArticle,
                   ffFixed, DmdFpnUtils.QtyDecsPrice) + SepCol + ' ' + SepCol;
      VspPreview.AddTable (TxtTablePaymentFtr, '', TxtLine, False, False, True);
    end; // of if (ValTotalEcoTaxArticle > 0) and FlgShowEcoTaxInvoiceTotal
    if FlgShowEcoTaxInvoiceTotal and FlgShowEcoTaxFreeArt and
       (ValTotalEcoTaxFreeArticle > 0) then begin
      TxtLine := Trim(TxtDescrTotInvoiceFree) + ' ' + CurrToStrF
                   (ValTotalEcoTaxFreeArticle, ffFixed, DmdFpnUtils.QtyDecsPrice);
      VspPreview.AddTable (TxtTablePaymentFtr, '', TxtLine, False, False, True);
    end; // of if FlgShowEcoTaxInvoiceTotal and FlgShowEcoTaxFreeArt
  end; // of if not FlgRussia
  VspPreview.CurrentY := CurrentPaymentPosY;
  // Print totaal aantal items
  if FlgRussia then begin
    VspPreview.MarginLeft := ViValRptBodyPoxX;
    VspPreview.CurrentX   := ViValRptBodyPoxX;
    VspPreview.CurrentY   := ViValRptRemarquePosY - (ViValRptSpaceBtwRect * 3);
    VspPreview.Text       := CtTxtTotalItems + ': ' + CurrToStrF(NumTotalItems,
                               ffFixed, DmdFpnUtils.QtyDecsQuant);
  end; // of if FlgRussia
  TxtDiffNoReturn := '';
end;   // of TFrmVSRptInvoiceCA.MakeTotals

//==============================================================================

procedure TFrmVSRptInvoiceCA.MakeDocumentKind;
var
  TxtDocKind       : string;           // Name of the document
begin  // of TFrmVSRptInvoice.MakeDocumentKind
  if CodKind = CodKindDelivNote then
    TxtDocKind := CtTxtDelivNote
  else begin
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
    if FlgClientIntracom then
      TxtDocKind := CtTxtInvoiceWoTax
    else
      TxtDocKind := CtTxtInvoice;
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
    if FlgCreditnote then
      TxtDocKind := CtTxtCreditNote;
  end;

  VspPreview.Font.Size := ViValSizeDocKind;
  if FlgRussia then begin
    VspPreview.CurrentX := ViValRptDocKindRuPosX;
    VspPreview.CurrentY := ViValRptDocKindRuPoxY;
  end
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  else if FlgClientIntracom then begin
    VspPreview.CurrentX := ViValCiRptDocKindPoxX;
    VspPreview.CurrentY := ViValCiRptDocKindPoxY;
  end
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  else begin
    VspPreview.CurrentX := ViValRptDocKindPoxX;
    VspPreview.CurrentY := ViValRptDocKindPoxY;
  end;
  VspPreview.Text := TxtDocKind;
  VspPreview.Font.Size := ViValSizeBody;
end;   // of TFrmVSRptInvoiceCA.MakeDocumentKind

//=============================================================================

procedure TFrmVSRptInvoiceCA.MakeCustomInfo;
begin  // of TFrmVSRptInvoiceCA.MakeCustomInfo
  if not FlgRussia then begin
    if IsClientIntraCom then
      VspPreview.DrawRectangle (ViValRptBodyPoxX,
                                ViValRptBodyPoxYCI,
                                ViValRptBodyPoxX + ViValRptRemarqueWidth,
                                ViValRptVATPosY - ViValRptSpaceBtwRect, 10, 10)
    else
      VspPreview.DrawRectangle (ViValRptBodyPoxX,
                                ViValRptBodyPoxY,
                                ViValRptBodyPoxX + ViValRptRemarqueWidth,
                                ViValRptVATPosY - ViValRptSpaceBtwRect, 10, 10);
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    if FlgClientIntracom then begin
    VspPreview.DrawRectangle (ViValCiRptPaymentPosX,
                              ViValRptPaymentPosY,
                              ViValCiRptPaymentPosX + ViValCiRptTotRectWidth,
                              ViValRptRemarquePosY - ViValRptSpaceBtwRect, 10,10);

    VspPreview.DrawRectangle (ViValCiRptPaymentPosX + ViValCiRptTotRectWidth +
                              ViValRptSpaceBtwRect,
                              ViValRptPaymentPosY,
                              ViValCiRptPaymentPosX + (ViValCiRptPayRectWidth * 2) +
                              ViValRptSpaceBtwRect,
                              ViValRptRemarquePosY - ViValRptSpaceBtwRect, 10,10);
    end
    else begin
      VspPreview.DrawRectangle (ViValRptPaymentPosX,
                              ViValRptPaymentPosY,
                              ViValRptPaymentPosX + ViValRptTotRectWidth,
                              ViValRptRemarquePosY - ViValRptSpaceBtwRect, 10,10);

      VspPreview.DrawRectangle (ViValRptPaymentPosX + ViValRptTotRectWidth +
                              ViValRptSpaceBtwRect,
                              ViValRptPaymentPosY,
                              ViValRptPaymentPosX + (ViValRptPayRectWidth * 2) +
                              ViValRptSpaceBtwRect,
                              ViValRptRemarquePosY - ViValRptSpaceBtwRect, 10,10);
    end
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  end;
end;   // of TFrmVSRptInvoiceCA.MakeCustomInfo

//=============================================================================

function TFrmVSRptInvoiceCA.GetTicketObject : TObject;
begin  // of TFrmVSRptInvoiceCA.GetTicketObject
  Result := TObjTransTicketCA.Create;
end;   // of TFrmVSRptInvoiceCA.GetTicketObject

//=============================================================================

procedure TFrmVSRptInvoiceCA.BuildTickets;
var
  ObjTransTicket   : TObjTransTicketCA; // Current ticket
  ObjCurrTrans     : TObjTransactionCA; // Current object of transdetail
  NumSubTot        : Integer;           // Indicates a subtotal in a ticket.
  NumLine          : Integer;           // Current Line in the ticket
  FlgFound         : Boolean;           // Is a equal Transdetail found?
  CntTransDetail   : Integer;           // Loop all Transdetails
begin  // of TFrmVSRptInvoiceCA.BuildTickets
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
    CodCreator := DsrPOSTransDetail.DataSet.
                                          FieldByName ('CodCreator').AsInteger;
    ObjTransTicket := TObjTransTicketCA (GetTicketObject);
    ObjTransTicket.FillObj (DsrPOSTransDetail.DataSet);

    DmdFpnInvoice.LstTickets.Add (ObjTransTicket);

    NumLine := DsrPOSTransDetail.DataSet.FieldByName ('NumLineReg').AsInteger;
    NumSubTot := 0;
    repeat
      // Put all POSTransDetail information of one NumLine into one object.
      ObjCurrTrans := TObjTransactionCA (GetTransactionObject);

      while (not DsrPOSTransDetail.DataSet.Eof)
        and (NumLine =
            DsrPOSTransDetail.DataSet.FieldByName ('NumLineReg').AsInteger)
            do begin
    //CAFR.2011.2.23.9.1 ARB  Start
    if (DsrPOSTransDetail.dataset.FieldByName ('CodType').AsInteger = CtCodPdtCommentCouponsAttributed) then
      Objtransticket.PromoPackComment := Format(CtTxtPromopackCoupAttributed,
              [DsrPOSTransDetail.dataset.FieldByName('QtyReg').AsInteger,
               DsrPOSTransDetail.dataset.FieldByName ('ValInclVat').AsFloat,
               DsrPOSTransDetail.dataset.FieldByName('IdtCurrency').AsString,
               DsrPOSTransDetail.dataset.FieldByName ('PrcInclVat').AsInteger] );
    //CAFR.2011.2.23.9.1 ARB End
        ObjCurrTrans.FlgRussia := FlgRussia;
        ObjCurrTrans.FillObj (DsrPOSTransDetail.DataSet);
        DsrPOSTransDetail.DataSet.Next;
      end;
      NumLine := DsrPOSTransDetail.DataSet.FieldByName ('NumLineReg').AsInteger;
      // Find all equal POSTransDetails and cummulate them.
      // Start's from the last Subtotal-line
      FlgFound := False;
      for CntTransDetail := NumSubTot to
                       Pred (ObjTransTicket.StrLstObjTransaction.Count) do begin

        if (TObjTransaction(ObjTransTicket.StrLstObjTransaction.
       Objects[CntTransDetail]).Evaluate(ObjCurrTrans))
       and not (TObjTransactionCA(ObjCurrTrans).CodType = CtCodPdtInfoPromo)
       and not (TObjTransactionCA(ObjCurrTrans).CodMainAction = CtCodActCredCoupCreate)
       and not (TObjTransactionCA(ObjCurrTrans).CodMainAction = CtCodActCredCoupAccept)
       then begin
          TObjTransaction(ObjTransTicket.StrLstObjTransaction.
                            Objects[CntTransDetail]).Count (ObjCurrTrans);
          ObjCurrTrans.Free;
          FlgFound := True;
          Break;
        end
      end;
      if not FlgFound then begin
        ObjTransTicket.StrLstObjTransaction.AddObject ('', ObjCurrTrans);
      end;

       // In case of a subtotal.
    {  if DsrPOSTransDetail.DataSet.FieldByName ('CodAction').AsInteger =
          CtCodActSubTotal then  }
     if DsrPOSTransDetail.DataSet.FieldByName ('CodAction').AsInteger =
          CtCodActTotal then
        NumSubTot := ObjTransTicket.StrLstObjTransaction.Count;
            // In case of a subtotal.
      if DsrPOSTransDetail.DataSet.FieldByName ('CodAction').AsInteger =
          CtCodActTotal then begin
        if (DsrPOSTransDetail.DataSet.FieldByName ('Valinclvat').AsCurrency < 0) then
          FlgCreditnote := True
        else
          FlgCreditnote := False;
      end;
    until DsrPOSTransDetail.DataSet.Eof;
    DsrPOSTransIdts.DataSet.Next;
  end;
end;   // of TFrmVSRptInvoiceCA.BuildTickets


//==============================================================================

function TFrmVSRptInvoiceCA.GetTxtRemarqueTable : string;
var
  TxtRemarque      : string;
begin  // of TFrmVSRptInvoiceCA.GetTxtRemarqueTable
  Result := '  ' + inherited GetTxtRemarqueTable + #13;
  if (TxtVATIncluded = '')  and (FlgExtraInfo) then begin
    TxtRemarque := GetRemarqueText;
    if TxtRemarque = '' then
      Result := '  ' + CtTxtPaiementcomptant + #13
    else
      Result := TxtRemarque;
  end;
  //Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del5
    if FlgCreditStrip and FlgClientEnCompte and not FlgCreditnote and not FlgClientIntracom then
      Result := Result + '  ' + CtTxtPapillon + #13 +
                '  ' + DmdFpnTradeMatrix.InfoTradeMatrix
                                             [DmdFpnUtils.IdtTradeMatrixAssort,
                                             'TxtStreet'] + #13 +
                '  ' + DmdFpnTradeMatrix.InfoTradeMatrix
                                             [DmdFpnUtils.IdtTradeMatrixAssort,
                                             'TxtCodPost'] + ' ' +
                DmdFpnTradeMatrix.InfoTradeMatrix
                                             [DmdFpnUtils.IdtTradeMatrixAssort,
                                             'TxtMunicip'] + #13;
  // SPAIN V1
  if length(TxtVATIncluded) > 0 then
    Result := Result + '  ' + TxtVATIncluded + #13;
  if FlgTicketInfo then begin
    if (DmdFpnInvoice.LstTickets.Count > 1) then begin
     Result := Result + '  ' + GetLegalInfo + #13;
    end
    else begin
      Result := Result + '  ' + Format (CtTxtInvoiceOrigin,
        [IntToStr(ObjCurrentTicket.IdtPOSTransaction),
        IntToStr(ObjCurrentTicket.IdtCheckOut),
        FormatDateTime (CtTxtDatFormat, ObjCurrentTicket.DatTransBegin)+ ' '
        + FormatDateTime (CtTxtHouFormat, ObjCurrentTicket.DatTransBegin)]) + #13 +
        #13 + '  ' + GetLegalInfo + #13;
    end;
  end;  
  if FlgFiscal and (TxtFiscalText <> '') then
    Result := Result + '  ' + TxtFiscalText + #13;
  if FlgRussia then
    Result := Result + #13 + '  ' + CtTxtDirector + ' : ' + #13 + #13 +'  ' +
              CtTxtChiefAccountancy + ' : ' + #13 + #13 + '  ' +
              CtTxtBeneficiary + ' : ';
end;   // of TFrmVSRptInvoiceCA.GetTxtRemarqueTable

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintRemarqueTable;
var
  TxtInvRemark    : string;
  CntItem         : integer;
begin  // of TFrmVSRptInvoiceCA.PrintRemarqueTable
  if FlgFiscal and FlgItaly then begin
    VspPreview.BrushStyle := bsTransparent;
    VspPreview.BrushColor := clBlack;

    for CntItem := 0 to StrInvRemark.Count - 1 do begin
      if TxtInvRemark <> '' then
        TxtInvRemark := TxtInvRemark + #13;
      TxtInvRemark := TxtInvRemark + '   ' + StrInvRemark.Strings[CntItem];
    end;

    VspPreview.TextBox (TxtInvRemark,
                        ViValRptRemarquePosX, ViValRptRemarque2PosY,
                        ViValRptRemarqueWidth, ViValRptRemarque2Height, True,
                        False, True);
  end
  else begin
    if not FlgRussia then begin
      VspPreview.BrushStyle := bsTransparent;
      VspPreview.BrushColor := clBlack;
      VspPreview.TextBox (GetTxtRemarqueTable,
                          ViValRptRemarquePosX, ViValRptRemarquePosY,
                          ViValRptRemarqueWidth, ViValRptRemarqueHeight, True,
                          False, True);
    end;
  end;
end;   // of TFrmVSRptInvoiceCA.PrintRemarqueTable

//==============================================================================

function TFrmVSRptInvoiceCA.GetTxtCreditStrip : string;
var
  NumInvExpDays    : integer;           //Number of days before expiry
  IdtTradematrix   : string;
  NumInvoice       : integer;
  DatInvoice       : TDateTime;
begin  // of TFrmVSRptInvoiceCA.GetTxtCreditStrip
  IdtTradematrix := DmdFpnUtils.IdtTradeMatrixAssort;
  NumInvoice := TObjTransTicket(DmdFpnInvoice.LstTickets[0]).IdtInvoice;
  DatInvoice := TObjTransTicket(DmdFpnInvoice.LstTickets[0]).DtmInvoice;
  NumInvExpDays := StrToInt(DmdFpnCustomerCA.InfoCustomer [IdtCustomer,
                                                           CodCreator,
                                                           'NumInvExpDays']);
  if NumInvExpDays = 0 then
    NumInvExpDays := GetDefaultInvExpDays;

  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  if (NumInvExpDays <> 0) and FlgClientIntracom then begin
    Result := Result + #13 + '    ' + CtTxtInvDateExpiry + ' ' + DateToStr (
              DatInvoice + NumInvExpDays) + #13;
    exit;
  end;
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

    Result := #13 +'    ' + CtTxtInvStoreNumber + ' ' + IdtTradematrix + #13;
    Result := Result + '    ' + CtTxtInvCustNumber + ' ' + IntToStr(IdtCustomer) + #13;
    Result := Result + '    ' + CtTxtInvCustName + ' ' + TxtCustName + #13;
    Result := Result + '    ' + CtTxtInvNum + ' ' + IntToStr (NumInvoice) + #13;
    Result := Result + '    ' + CtTxtInvDate + ' ' + DateToStr (DatInvoice) + #13;

  if NumInvExpDays <> 0 then
    Result := Result + '    ' + CtTxtInvDateExpiry + ' ' + DateToStr (
              DatInvoice + NumInvExpDays) + #13
  else
    Result := Result + #13;
  Result := Result + '    ' + CtTxtInvAmountCredit + ' ' + FloatToStr(ValCredit) +
            #13 + #13;
  Result := Result + '    ' + DmdFpnCustomerCA.BuildOCRLine (DatInvoice,
                                         IdtCustomer,
                                         NumInvoice,
                                         ValCredit,
                                         IdtTradeMatrix);
end;   // of TFrmVSRptInvoiceCA.GetTxtCreditStrip

//==============================================================================

procedure TFrmVSRptInvoiceCA.PrintCreditStrip;
begin  // of TFrmVSRptInvoiceCA.PrintCreditStrip
    VspPreview.BrushStyle := bsTransparent;
    VspPreview.BrushColor := clBlack;
//    VspPreview.Font.Size := ViValSizeBody;
// Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  (*Disabling the credit strip fucntionality PARTIALLY for client intracom customer
  the FlgCreditStrip is used from FlgCreditStrip IdtApplicParam *)
// Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del6, Start
(*
Change details - After discussion with KITS, the MOA does not want the credit
strip box, hence disabling the logic in the fucntion and the corresponding
function call
*)

//    if FlgClientIntracom then
//      VspPreview.TextBox (GetTxtCreditStrip,
//                          ViValCiRptCreditStripPoxX, ViValRptMatrixPosY + 1000,
//                          ViValCiRptCreditStripWidth, ViValCiRptCreditStripHeight, True,
//                          False, True)
//    else
// Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del6, End
      VspPreview.TextBox (GetTxtCreditStrip,
                          ViValRptCreditStripPoxX, ViValRptMatrixPosY + 650,
                          ViValRptCreditStripWidth, ViValRptCreditStripHeight, True,
                          False, True);
// Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
end;   // of TFrmVSRptInvoiceCA.PrintCreditStrip

//==============================================================================

function TFrmVSRptInvoiceCA.GetLegalInfo : string;
var
  CntItem    : Integer;            // counter
begin  // of TFrmVSRptInvoiceCA.GetLegalInfo
  try
    Result := '';
    for CntItem := 1 to 6 do begin
      if DmdFpnUtils.QueryInfo(
      #10'SELECT TxtParam' +
      #10'FROM ApplicParam' +
      #10'WHERE IdtApplicParam = ' + AnsiQuotedStr('InvoiceLegalInfo' +
                                     IntToStr(CntItem), ''''))
      then
        if (CntItem = 4) then
          Result := Result + #13 + '  ' +
                    DmdFpnUtils.QryInfo.FieldByName ('TxtParam').AsString
        else
          Result := Result +
                    DmdFpnUtils.QryInfo.FieldByName ('TxtParam').AsString;
      DmdFpnUtils.ClearQryInfo;
      DmdFpnUtils.CloseInfo;
    end;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptInvoiceCA.GetLegalInfo

//==============================================================================

function TFrmVSRptInvoiceCA.GetDefaultInvExpDays : integer;
begin  // of TFrmVSRptInvoiceCA.GetDefaultInvExpDays
  try
    Result := 0;
    if DmdFpnUtils.QueryInfo('SELECT ValParam' +
                          #10'FROM ApplicParam' +
                          #10'WHERE IdtApplicParam = ' +
                              AnsiQuotedStr('NumInvExpDays', '''')) then
      Result := DmdFpnUtils.QryInfo.FieldByName ('ValParam').AsInteger;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptInvoiceCA.GetDefaultInvExpDays

//==============================================================================

function TFrmVSRptInvoiceCA.GetFlgCreditStrip : boolean;
begin  // of TFrmVSRptInvoiceCA.GetDefaultInvExpDays
  try
    Result := False;
    if DmdFpnUtils.QueryInfo('SELECT ValParam' +
                          #10'FROM ApplicParam' +
                          #10'WHERE IdtApplicParam = ' +
                              AnsiQuotedStr('FlgCreditStrip', '''')) then begin
      if DmdFpnUtils.QryInfo.FieldByName ('ValParam').AsInteger = 1 then
        Result := True;
    end;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptInvoiceCA.GetDefaultInvExpDays

//==============================================================================

procedure TFrmVSRptInvoiceCA.PrintGeneralTicketInfo;
var
  TxtLine          : string;           // Line to print
  NumFiscalReceipt : integer;
begin  // of TFrmVSRptInvoiceCA.PrintGeneralTicketInfo
  if CodKind <> CodKindInvoice  then
    Exit;
  NumFiscalReceipt := ObjCurrentTicket.NumFiscalTicket;

  if (NumFiscalReceipt <> 0) and FlgFiscal then
  begin
    PrintFiscalReceiptInfo;
  end;
  if ObjCurrentTicket.IdtDelivNote <> 0 then begin
    TxtLine := SepCol +  CtTxtDelivNoteNumber + ' ' +
               IntToStr (ObjCurrentTicket.IdtDelivNote) + ' dd.' +
               FormatDateTime (CtTxtDatFormat, ObjCurrentTicket.DtmDelivNote);

    VspPreview.AddTable (TxtTableBodyFmt, '', TxtLine, False, clLtGray, False);
    EvaluatePagePosition;
  end;
  if FlgItaly then
    PrintEmployeeInfo;
end;   // of TFrmVSRptInvoiceCA.PrintGeneralTicketInfo

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintBodyInvoice;
var
  ObjPayment       : TObjPayment;
  CntItem          : integer;
  FlgExist         : boolean;
  CntLstTickets    : Integer;          // Counter in List Tickets
  CntLstTransact   : Integer;          // Counter in PosTransaction
  ValTempTotal     : double;           // Temporarily total
  ValTempNetto     : double;           // Temporarily total
  FlgSavDuplicate  : Boolean;
  CntCopy          : Integer;
begin  // of TFrmVSRptInvoiceCA.PrintBodyInvoice
  FlgClientEnCompte         := False;
  FlgClientIntracom         := False; // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  ValCredit                 := 0;
  ValTotalEcoTaxArticle     := 0;
  ValTotalEcoTaxFreeArticle := 0;
  ValTempNetto              := 0;
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  if IdtCustomer = 90000 + StrToInt (DmdFpnUtils.IdtTradeMatrixAssort) then
    FlgClientIntracom := True;
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  if FlgRussia then begin
    ViValSizeBody          := 8;
    ViValRptWidthCodeCasto := 11;
    ViValRptWidthDescr     := 28;
    ViValRptWidthTotDescr  := 18;
    ViValRptWidthPayDescr  := 37;
    ViValRptWidthQty       := 10;
    ViValRptWidthVATCod    := 7;
    ViValRptWidthVATExcl   := 15;
    ViValRptWidthUnit      := 10;
    ViValRptWidthPrcDisc   := 10;
    ViValRptWidthValDisc   := 10;
    ViValRptWidthPHUT      := 10;
    ViValRptWidthTotVal    := 10;
    ViValRptWidthVATVal    := 10;
    VspPreview.Orientation := orLandscape;
  end; // of if FlgRussia
  VspPreview.Font.Size := ViValSizeBody;
  BuildTableBodyFmtAndHdr;
  if not FlgRussia then begin
    BuildTableVATFmtAndHdr;
    BuildTablePaymentFmtAndHdr;
  end; // of if not FlgRussia
  VspPreview.StartDoc;
  VspPreview.Header := ' ';
  VspPreview.Footer := ' ';
  PSavOnEndPage := VspPreview.OnEndPage;
  PSavOnNewPage := VspPreview.OnNewPage;
  try
    // Calculate needed height to print transfer on each page
    VspPreview.OnEndPage := EndPageBody;
    // Determine if it is a invoice or creditnote
    ValTempTotal := 0;
    for CntLstTickets := 0 to Pred (DmdFpnInvoice.LstTickets.Count) do begin
      ObjCurrentTicket :=
             TObjTransTicketCA (DmdFpnInvoice.LstTickets.Items [CntLstTickets]);
      for CntLstTransact := 0 to Pred (ObjCurrentTicket.StrLstObjTransaction.Count)
      do begin
        ObjCurrentTrans := TObjTransactionCA
               (ObjCurrentTicket.StrLstObjTransaction.Objects [CntLstTransact]);
        ValTempNetto := ValTempNetto + ObjCurrentTrans.QtyArt *
                                       ObjCurrentTrans.PrcInclVAT;
        ValTempTotal := ValTempTotal + ObjCurrentTrans.ValInclVAT +
                        ObjCurrentTrans.ValAdmInclVAT +
                        ObjCurrentTrans.ValPromInclVAT +
                        ObjCurrentTrans.ValDiscInclVAT;
      end; // of for CntLstTransact := 0 to....
    end; // of for CntLstTickets := 0 to....
{    if ValTempTotal < 0 then
      FlgCreditnote := True
    else
      FlgCreditNote := False; }
    NumTotalItems := 0;
    // Do the print stuff
    LstPayments.Clear;
    if not FlgRussia then begin
      try
        if DmdFpnUtils.QueryInfo
           (#10'SELECT QtyCopyInv FROM Customer ' +
            #10'WHERE (IdtCustomer = ' + IntToStr(IdtCustomer) + ')') then
          NumCopies := DmdFpnUtils.QryInfo.FieldByName('QtyCopyInv').AsInteger;
      finally
        DmdFpnUtils.CloseInfo;
      end; // of try... finally
      if NumCopies < 1 then
        NumCopies := 1;
    end // of if not FlgRussia
    else
      NumCopies := 2;
    for CntCopy := 1 to numCopies do begin
      if CntCopy > 1 then begin
        ValTotalEcoTaxArticle := 0;
        ValTotalEcoTaxFreeArticle := 0;
        LstPayments.Clear;
        VspPreview.OnEndPage := PSavOnEndPage;
        //else you would get subtotal in payment table at the end of every copy
        VspPreview.NewPage;
        VspPreview.OnEndPage := EndPageBody;
        //else you would get subtotal in payment table at the end of every copy
        NumCurRow := 1;
        FlgPrintCopy := True;
      end // of if CntCopy > 1
      else
        FlgPrintCopy := False;
      for CntLstTickets := 0 to Pred (DmdFpnInvoice.LstTickets.Count) do begin
        ObjCurrentTicket :=
             TObjTransTicketCA (DmdFpnInvoice.LstTickets.Items [CntLstTickets]);
        PrintGeneralTicketInfo;
        TxtFiscalText := '';
        for CntLstTransact := 0 to Pred (ObjCurrentTicket.StrLstObjTransaction.Count)
        do begin
          ObjCurrentTrans := TObjTransactionCA
               (ObjCurrentTicket.StrLstObjTransaction.Objects [CntLstTransact]);
          if FlgAllowCreditnote and FlgCreditnote then
            InvertCurrentTrans;
          if (Abs (ObjCurrentTrans.ValAdmInclVAT) > 0) and
            (ObjCurrentTrans.CodActAdm <> CtCodActReturn)  then begin
            FlgExist := False;
            for CntItem := 0 to LstPayments.Count -1 do begin
              if (TObjPayment(LstPayments[CntItem]).IdtClassification =
              ObjCurrentTrans.IdtAdmClassi )and
              ((ObjCurrentTrans.CodMainAction <> CtCodActCredCoupAccept) and
               (ObjCurrentTrans.CodMainAction <> CtCodActCredCoupCreate)) then begin
                TObjPayment(LstPayments[CntItem]).ValTotal :=
                            TObjPayment(LstPayments[CntItem]).ValTotal +
                            ObjCurrentTrans.ValAdmInclVAT;
                FlgExist := True;
              end;
            end;
            if ObjCurrentTrans.CodMainAction = CtCodActCreditAllow then begin
              FlgClientEnCompte := True;
              ValCredit := ValCredit + ObjCurrentTrans.ValAdmInclVAT;
            end;
            if not FlgExist then begin
              ObjPayment := TObjPayment.Create;
              ObjPayment.IdtClassification := ObjCurrentTrans.IdtAdmClassi;
              ObjPayment.CodAction := ObjCurrentTrans.CodMainAction;
              ObjPayment.TxtDescr := ObjCurrentTrans.TxtDescrAdm;
              ObjPayment.ValTotal := ObjCurrentTrans.ValAdmInclVAT;
              LstPayments.Add(ObjPayment); 
            end;
          end;
          BuildBodyDetailLine;
          ValRptTotalPosY := VspPreview.CurrentY;
          if CntCopy = 1 then
            CalcBodyDetailLine;
        end;
      end;
    end;
  finally
    VspPreview.OnEndPage  := PSavOnEndPage;
    VspPreview.EndDoc;
  end;
  if (LstPayments.Count > 10) and (not FlgRussia) then begin
    NumBodyRow := NumBodyRow - (LstPayments.Count - 10);
    ViValRptVATPosY := ViValRptVATPosY - ((LstPayments.Count - 10) * 220);
    ViValRptPaymentPosY := ViValRptPaymentPosY -
                           ((LstPayments.Count - 10) * 220);
  end;
  FlgSavDuplicate := FlgDuplicate;
  MakeOverLay;
  if FlgRussia then 
    PrintPageNumbers;
  FlgDuplicate := FlgSavDuplicate;
  LstPayments.Clear;
end;   // of TFrmVSRptInvoiceCA.PrintBodyInvoice

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintVATTable;
var
  CntVATCode       : Integer;          // Looping the VAT codes
  ObjVATData       : TObjVATData;      // Object containing the VAT data.
begin  // of TFrmVSRptInvoiceCA.PrintVATTable
  VspPreview.MarginLeft := ViValRptVATPosX;
  VspPreview.CurrentX := ViValRptVATPosX;
  VspPreview.CurrentY := ViValRptVATPosY;

  if not FlgRussia then
    VspPreview.TableBorder := tbBox
  else
    VspPreview.TableBorder := tbBoxColumns;

  VspPreview.AddTable (TxtTableVATFmt, '', TxtTableVATHdr, False,
                       ViValColorVatTitle, False);

  StrLstVAT.Sort;
  for CntVATCode := 0 to Pred (StrLstVAT.Count) do begin
    ObjVATData := TObjVATData (StrLstVAT.Objects [CntVATCode]);
    if ObjVatData.IdtVATCode <> 0 then 
      PrintVATTableLine (ObjVATData);
  end;
end;   // of TFrmVSRptInvoiceCA.PrintVATTable

//==============================================================================

procedure TFrmVSRptInvoiceCA.PrintVATTableLine (ObjVATData : TObjVATData);
begin  // of TFrmVSRptInvoiceCA.PrintVATTableLine
  //EDS: put if in comment, also print VAT if % = 0
  //if (Abs (ObjVATData.PctVAT) >= CtValMinFloat) then
    inherited;
end;   // of TFrmVSRptInvoiceCA.PrintVATTableLine

//=============================================================================
// FillString : Fills up a string of given Length
//  with given char
//                                  -----
// INPUT   :  FillChar = the char to fill the string with
//            Len      = The length of the returned filled string
//                                  -----
// FUNCRES :  The Filled-up-String
//=============================================================================

function TFrmVSRptInvoiceCA.FillString(FillChar: char; Len: integer): string;
var
  Txt               : String;
  Cnt               : integer;
begin  // of TFrmVSRptInvoiceCA.FillString
  SetLength(Txt,Len);
  for Cnt := 1 to Len do Txt[Cnt] := FillChar;
  Result := Txt;
end;   // of TFrmVSRptInvoiceCA.FillString

//==============================================================================
// TFrmVSRptInvoiceCA.InvertCurrentTrans : Invert the given values in the object
//==============================================================================

procedure TFrmVSRptInvoiceCA.InvertCurrentTrans;
begin  // of TFrmVSRptInvoiceCA.InvertCurrentTrans
  With ObjCurrentTrans do
  begin

  QtyArt := - QtyArt;
  //PrcInclVAT     := - PrcInclVAT;
  //PrcExclVAT     := - PrcExclVAT;
  ValInclVAT     := - ValInclVAT;
  ValExclVAT     := - ValExclVAT;

  //PrcPromInclVAT := - PrcPromInclVAT;
  //PrcPromExclVAT := - PrcPromExclVAT;
  ValPromInclVAT := - ValPromInclVAT;
  ValPromExclVAT := - ValPromExclVAT;

  //PrcDiscInclVAT := - PrcDiscInclVAT;
  ValDiscInclVAT := - ValDiscInclVAT;
  ValDiscExclVAT := - ValDiscExclVAT;

  //PrcAdmInclVAT  := - PrcAdmInclVAT;
  ValAdmInclVAT  := - ValAdmInclVAT;
  end;
end;   // of TFrmVSRptInvoiceCA.InvertCurrentTrans

//=============================================================================
// TFrmVSRptInvoiceCA.ReadParams : Get params out of FpsSyst.ini
//=============================================================================

procedure TFrmVSRptInvoiceCA.ReadParams;
var
  IniFile            : TIniFile;          // IniObject to the INI-file
  TxtPath            : string;            // Path of the ini-file
  TxtFmtInvoiceNum   : string;            // Format of the ini-file
  NumStart           : integer;           // Start position
  NumEnd             : integer;           // End position
  TxtSepNumb         : string;            // String with separate number
  TxtFlag            : string;
  TxtInvRemark       : string;
  TxtInvAddress      : string;
  CntItem            : integer;
begin  // of TFrmVSRptInvoiceCA.ReadParams
  TxtPath := ReplaceEnvVar ('%SycRoot%\FlexPos\Ini\FpsSyst.INI');
  IniFile := nil;
  OpenIniFile(TxtPath, IniFile);
  // Text to print in the remarks area
  TxtVATIncluded  := IniFile.ReadString('Common', 'TextVATIncl', '');
  // Print ticket info or not
  FlgTicketInfo :=
  StrToBool(IniFile.ReadString('Common', 'PrintTickInfoOnInvoice', ''), 'T');
  // Default alway print remarks on invoice
  TxtFlag := IniFile.ReadString('Common', 'PrintExtraInfoOnInvoice', '');
  if Trim (TxtFlag) <> '' then
    FlgExtraInfo :=  StrToBool(TxtFlag, 'T')
  else
    FlgExtraInfo :=  True;
  // Allow creditnotes or not
  FlgAllowCreditnote :=
  StrToBool(IniFile.ReadString('Common', 'InvertValuesForCreditNote', ''), 'T');
  // Use seperate number for creditnotes
  TxtSepNumb := IniFile.ReadString('Common', 'SeperateNumberCreditNote', '');
  if Trim (TxtSepNumb) <> '' then
    FlgSeperateCNNumber :=  StrToBool(TxtSepNumb, 'T')
  else
    FlgSeperateCNNumber :=  False;
  // Determine the format of the invoice number
  TxtFmtInvoiceNum := IniFile.ReadString('Common', 'FmtInvoiceNum', '');
  NumStart := AnsiPos('S', TxtFmtInvoiceNum) + 1;
  NumEnd := AnsiPos('>', TxtFmtInvoiceNum);
  NumStoreNrLength := StrToInt(Copy(TxtFmtInvoiceNum, NumStart, 1));
  TxtFmtInvoiceNum := Copy(TxtFmtInvoiceNum, NumEnd, Length(TxtFmtInvoiceNum));
  NumStart := AnsiPos('I', TxtFmtInvoiceNum) + 1;
  NumInvoiceNrLength := StrToInt(Copy(TxtFmtInvoiceNum, NumStart, 1));
  // Percentage promo difference
  if IniFile.ReadString('Promotion', 'PercPromDiff', '') <> '' then
    ValPercPromDiff := StrToFloat(IniFile.ReadString('Promotion', 'PercPromDiff', ''));

  //Ecotax properties
  if IniFile.ReadString('EcoTax', 'DescrArtLine', '') <> '' then
    TxtDescrArtLine := IniFile.ReadString('EcoTax', 'DescrArtLine', '');

  if IniFile.ReadString('EcoTax', 'DescrFreeArtLine', '') <> '' then
    TxtDescrFreeArtLine := IniFile.ReadString('EcoTax', 'DescrFreeArtLine', '');

  if IniFile.ReadString('EcoTax', 'DescrTotInvoice', '') <> '' then
    TxtDescrTotInvoice := IniFile.ReadString('EcoTax', 'DescrTotInvoice', '');

  if IniFile.ReadString('EcoTax', 'DescrTotInvoiceFree', '') <> '' then
    TxtDescrTotInvoiceFree := IniFile.ReadString('EcoTax', 'DescrTotInvoiceFree', '');

  TxtFlag := IniFile.ReadString('EcoTax', 'ShowEcoTaxTickLine', '');
  if Trim (TxtFlag) <> '' then
    FlgShowEcoTaxTickLine :=  StrToBool(TxtFlag, 'T')
  else
    FlgShowEcoTaxTickLine :=  False;

  TxtFlag := IniFile.ReadString('EcoTax', 'ShowEcoTaxInvoiceLine', '');
  if Trim (TxtFlag) <> '' then
    FlgShowEcoTaxInvoiceLine :=  StrToBool(TxtFlag, 'T')
  else
    FlgShowEcoTaxInvoiceLine :=  False;

  TxtFlag := IniFile.ReadString('EcoTax', 'ShowEcoTaxInvoiceTotal', '');
  if Trim (TxtFlag) <> '' then
    FlgShowEcoTaxInvoiceTotal :=  StrToBool(TxtFlag, 'T')
  else
    FlgShowEcoTaxInvoiceTotal :=  False;

  TxtFlag := IniFile.ReadString('EcoTax', 'ShowEcoTaxFreeArt', '');
  if Trim (TxtFlag) <> '' then
    FlgShowEcoTaxFreeArt :=  StrToBool(TxtFlag, 'T')
  else
    FlgShowEcoTaxFreeArt :=  False;

  // Remark text
  if not assigned (StrInvRemark) then
    StrInvRemark := TStringList.Create
  else
    StrInvRemark.Clear;
  for CntItem := 1 to 2 do begin
    TxtInvRemark := IniFile.ReadString('InvRemark', 'InvRemark' +
                                                         IntToStr(CntItem), '');
    if TxtInvRemark <> '' then
      StrInvRemark.Add(TxtInvRemark);
  end;

  // Address data
  if not assigned (StrInvAddress) then
    StrInvAddress := TStringList.Create
  else
    StrInvAddress.Clear;
  for CntItem := 1 to 7 do begin
    TxtInvAddress := IniFile.ReadString('InvAddress', 'InvAddress' +
                                                         IntToStr(CntItem), '');
    if TxtInvAddress <> '' then
      StrInvAddress.Add(TxtInvAddress);
  end;

  // Client Intracom
  TxtClientIntraLine1  := IniFile.ReadString('ClientIntracom','Line1','');
  TxtClientIntraLine2  := IniFile.ReadString('ClientIntracom','Line2','');
  TxtClientIntraLine3  := IniFile.ReadString('ClientIntracom','Line3','');       // ..
  TxtClientIntraLine4  := IniFile.ReadString('ClientIntracom','Line4','');
end;   // of TFrmVSRptInvoiceCA.ReadParams

//==============================================================================

procedure TFrmVSRptInvoiceCA.FormCreate(Sender: TObject);
var
  TxtImagePath     : string;           // Path of image directory
begin  // of TFrmVSRptInvoiceCA.FormCreate
  inherited;
  FrmVSRptInvoice := Self;
  LstPayments := TList.Create;
  ImgLogo := TImage.Create (Self);
  TxtImagePath := AddStartDirToFN ('\image');
  if FileExists (TxtImagePath + '\' + CtTxtLogoName) then begin
    ImgLogo.Picture.LoadFromFile (TxtImagePath + '\' + CtTxtLogoName);
  end;
  FlgCreditStrip := GetFlgCreditStrip;
  FlgClientEnCompte := False;
  if FlgCreditStrip then begin
    ViValRptRemarquePosY  := 13700;
    ViValRptRemarque2PosY := 14500;
  end;
  StrLstContents := TStringList.Create;
  FillStrLstContents (StrLstContents);
  CIFNConfig := ReplaceEnvVar ('%PrgROOT%') + CIFNConfig;       //R2012.1 Address De Facturation(SM)
  ReadIniFile;                                                  //R2012.1 Address De Facturation(SM)
end;   // of TFrmVSRptInvoiceCA.FormCreate

//=============================================================================

procedure TFrmVSRptInvoiceCA.VspPreviewStartDoc(Sender: TObject);
begin  // of TFrmVSRptInvoiceCA.VspPreviewStartDoc
  ReadParams;
  inherited;
end;   // of TFrmVSRptInvoiceCA.VspPreviewStartDoc

//=============================================================================

procedure TFrmVSRptInvoiceCA.VspPreviewNewPage(Sender: TObject);
begin  // of TFrmVSRptInvoiceCA.VspPreviewNewPage

  VspPreview.Font.Size := ViValSizeBody;
  VspPreview.MarginLeft := ViValRptBodyPoxX;
  VspPreview.CurrentX := ViValRptBodyPoxX;
  if FlgRussia then begin
    NumBodyRow := 15;
    VspPreview.CurrentY := ViValRptBodyRuPoxY;
  end
  else begin
    if FlgItaly then
      NumBodyRow := 30
    else
//      NumBodyRow := 32;          //Commented for Bug #181 By TCS(KB)
        NumBodyRow := 26;          //Modified for the Bug #181 By TCS(KB)
    VspPreview.CurrentY := ViValRptBodyPoxY;
  end;

  // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del2 .. commented the lines below
  // since its printing a blank space in between
  // Change Y position of body, when client intracom msg will be printed        // BDFR - Evol2
  if IsClientIntraCom then                                                      // BDFR - Evol2
    VspPreview.CurrentY := ViValRptBodyPoxYCI;                                  // BDFR - Evol2

  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;
  VspPreview.AddTable (TxtTableBodyFmt, '', TxtTableBodyHdr,
                       False, ViValColorBodyTitle, False);
  //Add row with column numbers
  if FlgRussia then begin
    VspPreview.AddTable (TxtTableBodyFmt, '', TxtTableBodyHdr2,
                       False, ViValColorBodyTitle, False);
  end;
  VspPreview.TableCell [tcColAlign, 0,0,1, 90] := taCenterMiddle;
  VspPreview.EndTable;
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.VspPreviewNewPage

//=============================================================================

procedure TFrmVSRptInvoiceCA.FormDestroy(Sender: TObject);
begin
  inherited;
  LstPayments.Free;
  LstPayments := nil;
  StrLstContents.Free;
  StrLstContents := nil;
end;

//=============================================================================

procedure TFrmVSRptInvoiceCA.ActPrintAllExecute(Sender: TObject);
begin  // of TFrmVSRptInvoiceCA.ActPrintAllExecute
  inherited;
  if not FlgDuplicate then begin
    AllowPrintActions := false;
    AllowPrintSetupActions := false;
    ActPrintCustom.enabled := False;
  end;
end;   // of TFrmVSRptInvoiceCA.ActPrintAllExecute

//=============================================================================

procedure TFrmVSRptInvoiceCA.ActPrintPageExecute(Sender: TObject);
begin  // of TFrmVSRptInvoiceCA.ActPrintPageExecute
  inherited;
  if not FlgDuplicate then begin
    AllowPrintActions := false;
    AllowPrintSetupActions := false;
    ActPrintCustom.enabled := False;
  end;
end;   // of TFrmVSRptInvoiceCA.ActPrintPageExecute

//=============================================================================

procedure TFrmVSRptInvoiceCA.ShowInvoices;
begin  // of TFrmVSRptInvoiceCA.ShowInvoices
  AllowPrintActions := True;
  AllowPrintSetupActions := True;
  ActPrintCustom.enabled := True;
  inherited;
end;   // of TFrmVSRptInvoiceCA.ShowInvoices

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintFiscalReceiptInfo;
var
  TxtLine          : string;
  NumFiscalReceipt : string;
  NumFiscalPrinter : string;
  DatFiscalReceipt : string;
  NumLastEOD       : string;
  txtDescr         : string;
  posSeperator     : integer;
  tempPosX         : integer;
  tempPosY         : integer;
begin
  DmdFpnUtils.QueryInfo('Select * from POSTransDetail where ' +
                        'IdtPosTransaction = ' +
                        IntToStr(ObjCurrentTicket.IdtPOSTransaction) +
                        ' and CodType = ' +
                        IntToStr(CtCodPdtCommentFiscReceiptInfo) +
                        ' and DatTransBegin = ' +
            AnsiQuotedStr (FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                        ObjCurrentTicket.DatTransBegin), ''''));
  if not (DmdFpnUtils.qryInfo.Eof) then begin
    //info ivm fiscal receipt ophalen
    txtDescr := DmdFpnUtils.QryInfo.fieldByName('TxtDescr').AsString;
    NumFiscalReceipt := IntToStr(objCurrentTicket.NumFiscalTicket);
    DatFiscalReceipt := Copy(txtDescr,1,2) + '-' + Copy(txtDescr,3,2) + '-' +
                        Copy(txtDescr,5,4);
    txtDescr := Copy(txtDescr,10, length(txtdescr)-9);
    posSeperator := Ansipos(';', txtDescr);
    NumLastEOD := Copy(txtDescr,1,posSeperator - 1);
    NumFiscalPrinter := Copy(txtDescr, posSeperator + 1,
                             length(txtDescr) - posSeperator);
    if not FlgRussia then begin
      // info afdrukken
      TxtLine := SepCol + Format(CtTxtFiscalReceipt,[NumFiscalReceipt,
                                                     DatFiscalReceipt]);
  //                      + ' ' + Format(CtTxtFiscalDate,[DatFiscalReceipt]);
      VspPreview.AddTable (TxtTableBodyFmt, '', TxtLine, False, False, True);
      EvaluatePagePosition;

    //TxtLine := SepCol + Format(CtTxtFiscalDate,[DatFiscalReceipt]);
    //VspPreview.AddTable (TxtTableBodyFmt, '', TxtLine, False, False, True);
    //EvaluatePagePosition;

    //TxtLine := SepCol + Format(CtTxtLastEOD,[NumLastEOD]);
    //VspPreview.AddTable (TxtTableBodyFmt, '', TxtLine, False, False, True);
    //EvaluatePagePosition;

      TxtLine := SepCol + Format(CtTxtFiscalPrinter, [NumFiscalPrinter]);
      VspPreview.AddTable (TxtTableBodyFmt, '', TxtLine, False, False, True);
      EvaluatePagePosition;
    end
    else begin
      tempPosX := VspPreview.CurrentX;
      tempPosY := VspPreview.CurrentY;

      VspPreview.CurrentY := ViValRptFiscalInfoPosY;
      VspPreview.CurrentX := ViValRptMatrixPosX;
      VspPreview.MarginLeft := ViValRptMatrixPosX;
      VspPreview.Text := Format(CtTxtFiscalReceipt,
                                [NumFiscalReceipt,DatFiscalReceipt]) + #10;
      VspPreview.Text := Format(CtTxtFiscalPrinter, [NumFiscalPrinter]);

      VspPreview.CurrentY := tempPosY;
      VspPreview.CurrentX := tempPosX;
    end;
  end;
  DmdFpnUtils.QryInfo.Close;
end;

//=============================================================================

function TFrmVSRptInvoiceCA.GetAddressInfo: string;
var
  CntItem    : Integer;            // counter
begin  // of TFrmVSRptInvoiceCA.GetAddressInfo
  try
    Result := '';
    for CntItem := 1 to 3 do begin
      if DmdFpnUtils.QueryInfo(
      #10'SELECT TxtParam' +
      #10'FROM ApplicParam' +
      #10'WHERE IdtApplicParam = ' + AnsiQuotedStr('TxtInvRemarque' +
                                                    IntToStr(CntItem), ''''))
      then
        if (CntItem = 1) then
          Result := Result + '  ' +
                    DmdFpnUtils.QryInfo.FieldByName ('TxtParam').AsString
        else
          Result := Result + ' - ' +
                    DmdFpnUtils.QryInfo.FieldByName ('TxtParam').AsString;
      DmdFpnUtils.ClearQryInfo;
      DmdFpnUtils.CloseInfo;
    end;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptInvoiceCA.GetAddressInfo

//=============================================================================

procedure TFrmVSRptInvoiceCA.AddVAT (NumLineTotal : Real  ;
                                     TxtVATCode   : string;
                                     TxtVATPrc    : Real  );
var
  NumFound         : Integer;          // Index of the VatCode to proces.
  ObjVATData       : TObjVATData;      // VAT Object.
begin  // of TFrmVSRptInvoiceCA.AddVAT
  if TxtVATCode = '' then
    Exit;
  NumFound := StrLstVAT.IndexOf (TxtVATCode);
  if NumFound = -1 then begin
    ObjVATData := TObjVATData.Create;
    ObjVATData.IdtVATCode := StrToInt (TxtVATCode);
    ObjVATData.PctVAT := TxtVATPrc;
    ObjVATData.TxtDescr := FormatFloat ('#0.00', TxtVATPrc) + ' %';
    ObjVATData.NumTotalInVAT := NumLineTotal;
    ObjVATData.NumTotalVAT := 0;
    StrLstVAT.AddObject (TxtVATCode, ObjVATData);
  end
  else
    TObjVATData (StrLstVAT.Objects [NumFound]).NumTotalInVAT :=
      TObjVATData (StrLstVAT.Objects [ NumFound]).NumTotalInVAT + NumLineTotal;

end;   // of TFrmVSRptInvoiceCA.AddVAT

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintStoreInfo;
begin  // of TFrmVSRptInvoiceCA.PrintStoreInfo
  PrintGeneralInfo;
  PrintGeneralInvoiceInfo;
  if not FlgRussia then begin
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    if not FlgClientIntracom then
      PrintDeliveryNoteInfo
    else begin
       VspPreview.CurrentY := VspPreview.CurrentY + 150;
       ValRptInvoicePosY := ViValRptInvoicePosY + 200;
       (*Confirming that the invoice note info is positioned on the left for
       client intracom *)
    end
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
  end
  else begin
    VspPreview.CurrentY := VspPreview.CurrentY + 150;
    //ValRptInvoicePosY := VspPreview.CurrentY;
    ValRptInvoicePosY := ViValRptInvoiceRuPosY;
  end;
  PrintInvoiceNoteInfo;
  VspPreview.Font.Size := ViValSizeBody;
end;   // of TFrmVSRptInvoiceCA.PrintStoreInfo

//=============================================================================

procedure TFrmVSRptInvoiceCA.MakeDuplicate;
begin  // of TFrmVSRptInvoiceCA.MakeDuplicate
  if not FlgDuplicate and FlgRussia then begin
    VspPreview.Font.Size := ViValSizeDuplicate;
    VspPreview.CurrentX := ViValRptDocKindRuPosX;
    VspPreview.CurrentY := ViValRptDupliRuPoxY;
    VspPreview.Text := CtTxtFirstCopy;
    VspPreview.Font.Size := ViValSizeBody;
  end;
  if FlgDuplicate then begin
    VspPreview.Font.Size := ViValSizeDuplicate;
    if FlgRussia then begin
      VspPreview.CurrentX := ViValRptDocKindRuPosX;
      VspPreview.CurrentY := ViValRptDupliRuPoxY;
    end
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
    else if FlgClientIntracom then begin
       VspPreview.CurrentX := ViValCiRptDupliPoxX;
       VspPreview.CurrentY := ViValCiRptDupliPoxY;
    end
    // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
    else begin
      VspPreview.CurrentX := ViValRptDupliPoxX;
      VspPreview.CurrentY := ViValRptDupliPoxY;
    end;
    VspPreview.Text := CtTxtDuplicate;
    VspPreview.Font.Size := ViValSizeBody;
  end;
end;   // of TFrmVSRptInvoiceCA.MakeDuplicate

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrNumGTD(TxtHdr: string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrNumGTD
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthNumGTD))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrNumGTD

//=============================================================================

procedure TFrmVSRptInvoiceCA.BuildTableRuFmt;
begin  // of TFrmVSRptInvoiceCA.BuildTableRuFmt

  TxtTableRuFmt := '';
  TxtTableRuFmt := TxtTableRuFmt +
         Format ('%s%d',
                 [FormatAlignLeft,
                  ColumnWidthInTwips(CharStrW('0', ViValRptWidthRuDescr))]) +
         SepCol +
         Format ('%s%d',
                 [FormatAlignLeft,
                  ColumnWidthInTwips(CharStrW('0', ViValRptWidthRuValue))]);

end;   // of TFrmVSRptInvoiceCA.BuildTableRuFmt

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintRuTable(TxtINN : string;
                                          TxtKPP : string;
                                          TxtOKPO: string);
begin  // of TFrmVSRptInvoiceCA.PrintRuTable
  VspPreview.TableBorder :=  tbNone;
  VspPreview.CurrentY :=  ViValRptRuInfoPosY;

  VspPreview.AddTable(TxtTableRuFmt, '', CtTxtINN + SepCol + TxtINN,
                      False, False, True);
  VspPreview.AddTable(TxtTableRuFmt, '', CtTxtKPP + SepCol + TxtKPP,
                      False, False, True);
  VspPreview.AddTable(TxtTableRuFmt, '', CtTxtOKPO + SepCol + TxtOKPO,
                      False, False, True);

end;   // of TFrmVSRptInvoiceCA.PrintRuTable

//=============================================================================

procedure TFrmVSRptInvoiceCA.DrawLogo(ImgLogo: TImage);
var
  OlePicLogo       : IPictureDisp;     // Logo picture in OLE format
  ValPosLeft       : Double;           // Position left for picture
  ValPosTop        : Double;           // Position top for picture
begin  // of TFrmVSRptInvoiceCA.DrawLogo
  GetOlePicture (ImgLogo.Picture, OlePicLogo);
  VspPreview.X1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y1 := 0;
  VspPreview.Y2 := 0;
  VspPreview.CalcPicture := OlePicLogo;

  // Calculate position left: allign picture to the right margin
  if FlgRussia then begin
    ValPosLeft := ViValRptDocKindRuPosX;
  end
  else begin
    ValPosLeft := VspPreview.PageWidth - VspPreview.MarginRight - VspPreview.X2;
  end;
  if ValPosLeft < 0 then
    ValPosLeft := VspPreview.MarginLeft;
  // Calculate position top: allign top of picture to top of header, or, if
  // top of header is unknown, allign bottom of picture to bottom of header;
  // but assure the picture leaves a small border (200 twips) on top
  ValPosTop := VspPreview.MarginHeader;
  if ValPosTop = 0 then
    ValPosTop := VspPreview.MarginTop - VspPreview.Y2;
  if ValPosTop <= 200 then
    ValPosTop := 200;

  VspPreview.DrawPicture (OlePicLogo, ValPosLeft, ValPosTop, '100%', '100%',
                          '', False);
end;   // of TFrmVSRptInvoiceCA.DrawLogo

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrISOCode(TxtHdr: string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrISOCode
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthISOCode))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrISOCode

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrSalesUnit(TxtHdr: string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrSalesUnit
 if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                     ViValRptWidthSalesUnit))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrSalesUnit

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrVATVal(TxtHdr: string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrVATVal
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                     ViValRptWidthVATVal))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrVATVal

//=============================================================================

procedure TFrmVSRptInvoiceCA.EndPageBody(Sender: TObject);
begin  // of TFrmVSRptInvoiceCA.EndPageBody
  If FlgRussia then begin
    VspPreview.MarginLeft := ViValRptPaymentRuPosX;
    VspPreview.CurrentX := ViValRptPaymentRuPosX;
  end
  else begin
    VspPreview.MarginLeft := ViValRptPaymentPosX;
    VspPreview.CurrentX := ViValRptPaymentPosX;
  end;
  VspPreview.CurrentY := ViValRptPaymentPosY;

  if not FlgRussia then
    VspPreview.TableBorder := tbNone
  else
    VspPreview.TableBorder := tbBoxColumns;
  VspPreview.AddTable (TxtTablePaymentFmt, '', SepCol + SepCol + SepCol +
                       CtTxtSubTotal + SepCol +
                       CurrToStrF (ValTotal, ffFixed, DmdFpnUtils.QtyDecsPrice)+
                       SepCol + DmdFpnUtils.IdtCurrencyMain,
                       False, False, False);
end;   // of TFrmVSRptInvoiceCA.EndPageBody

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrTotExclVat(TxtHdr: string);
begin  // of TFrmVSRptInvoiceCA.AppendFmtAndHdrTotExclVat
  if TxtTableBodyFmt <> '' then begin
    TxtTableBodyFmt := TxtTableBodyFmt + SepCol;
    TxtTableBodyHdr := TxtTableBodyHdr + SepCol;
  end;
  TxtTableBodyFmt := TxtTableBodyFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                    ViValRptWidthTotExclVAT))]);
  TxtTableBodyHdr := TxtTableBodyHdr + TxtHdr;
end;   // of TFrmVSRptInvoiceCA.AppendFmtAndHdrTotExclVat

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintPageNumbers;
var
  CntPageNb        : Integer;          // Temp Pagenumber
  NumPage          : Integer;
  NumTotalPages    : Integer;          // all the pages (including copies)
  NumPages         : Integer;          // nr pages for 1 doc (excluding copies)
begin  // of TFrmVSRptInvoiceCA.PrintPageNumbers
  //2 copies of invoices, start renumbering for second copy
  NumTotalPages := VspPreview.PageCount;
  NumPages := round(NumTotalPages div NumCopies);
  NumPage := 1;
  for CntPageNb := 1 to NumTotalPages do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, TRUE);
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1200;
      CurrentY := ViValRptPageNrRuPoxY;
      Text := CtTxtCurrency + ': ' + DmdFpnUtils.IdtCurrencyMain;
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1200;
      CurrentY := ViValRptPageNrRuPoxY - 500;
      Text := CtTxtPage + ' ' + IntToStr (NumPage) + '/' +
                                IntToStr (NumPages);
      if NumPage >= NumPages then
        NumPage := 1
      else
        NumPage := NumPage + 1;
      EndOverlay;
    end;
  end;
end;   // of TFrmVSRptInvoiceCA.PrintPageNumbers

//=============================================================================

procedure TFrmVSRptInvoiceCA.FillStrLstContents(StrLstContents: TStringList);
begin  // of TFrmVSRptInvoiceCA.FillStrLstContents
  if not Assigned (StrLstContents) then
    Exit;

  try
    if DmdFpnUtils.QueryInfo
        ('SELECT TxtFldCode, TxtChcShort ' +
         'FROM ApplicDescr ' +
         'WHERE IdtApplicConv = ' + AnsiQuotedStr ('CodSalesUnit', '''') +
          ' AND TxtTable = ' + AnsiQuotedStr ('', '''') +
          ' AND IdtLanguage = ' +
            AnsiQuotedStr (DmdFpnUtils.IdtLanguageTradeMatrix, '''')) then begin
      StrLstContents.Clear;
      DmdFpnUtils.QryInfo.First;
      while not DmdFpnUtils.QryInfo.EOF do begin
        StrLstContents.Add
          (DmdFpnUtils.QryInfo.FieldByName ('TxtFldCode').AsString +
           '=' +
           DmdFpnUtils.QryInfo.FieldByName ('TxtChcShort').AsString);
        DmdFpnUtils.QryInfo.Next;
      end;   // of while not DmdFpnUtils.QryInfo.EOF ...
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptInvoiceCA.FillStrLstContents

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrTotalAmount(TxtHdr: string);
begin
  if TxtTableTotalsFmt <> '' then begin
    TxtTableTotalsFmt := TxtTableTotalsFmt + SepCol;
    TxtTableTotalsHdr := TxtTableTotalsHdr + SepCol;
  end;
  TxtTableTotalsFmt := TxtTableTotalsFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                     ViValRptWidthPayAmount))]);
  TxtTableTotalsFmt := TxtTableTotalsFmt + TxtHdr;
end;

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrTotalCurr(TxtHdr: string);
begin
  if TxtTableTotalsFmt <> '' then begin
    TxtTableTotalsFmt := TxtTableTotalsFmt + SepCol;
    TxtTableTotalsHdr := TxtTableTotalsHdr + SepCol;
  end;
  TxtTableTotalsFmt := TxtTableTotalsFmt +
                 Format ('%s%d',
                         [FormatAlignLeft,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthPayCur))]);
  TxtTableTotalsHdr := TxtTableTotalsHdr + TxtHdr;
end;

//=============================================================================

procedure TFrmVSRptInvoiceCA.AppendFmtAndHdrTotalDescr(TxtHdr: string);
begin
  if TxtTableTotalsFmt <> '' then begin
    TxtTableTotalsFmt := TxtTableTotalsFmt + SepCol;
    TxtTableTotalsHdr := TxtTableTotalsHdr + SepCol;
  end;
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
  if FlgClientIntracom then
    TxtTableTotalsFmt := TxtTableTotalsFmt +
                   Format ('%s%d',
                           [FormatAlignLeft,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValCiRptWidthTotDescr))])
  else
    TxtTableTotalsFmt := TxtTableTotalsFmt +
                   Format ('%s%d',
                           [FormatAlignLeft,
                            ColumnWidthInTwips(CharStrW('0',
                                                        ViValRptWidthTotDescr))]);
  // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End

  TxtTableTotalsHdr := TxtTableTotalsHdr + TxtHdr;
end;

//=============================================================================

procedure TFrmVSRptInvoiceCA.VspPreviewBeforeFooter(Sender: TObject);
begin
  inherited;
  // Intracom Invoice Excl. Tax, ARB, R2011.1.EUR5.Del6
  if FlgCreditStrip and FlgClientEnCompte and not FlgCreditnote
  and not FlgClientIntracom then
    PrintCreditStrip;
end;

//=============================================================================

procedure TFrmVSRptInvoiceCA.MakeOverLay;
var
  CntPage          : Integer;          // Counter pages
  NumTotalPages    : Integer;          // all the pages (including copies)
  NumPages         : Integer;          // nr pages for 1 doc (excluding copies)
begin  // of TFrmVSRptInvoiceCA.MakeOverLay
  NumTotalPages := VspPreview.PageCount;
  if NumTotalPages > 0 then begin
    NumPages := round(NumTotalPages div NumCopies);
    for CntPage := 1 to NumTotalPages do begin
      VspPreview.StartOverlay (CntPage, False);
      try
        if not FlgRussia then begin
          MakeDuplicate;
          MakeDocumentKind;
        end;
        if (CntPage mod NumPages = 0) then begin
          CalcVATLines;
          if not FlgRussia then begin
            MakeTotals;
            // Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
            (*Disabling the printing of the VAT Details in the bottom of the invoice*)
            if FlgClientIntracom = False then
              PrintVATTable;
            // CAFR.2011.2.23.9.1 ARB Start
            PrintPromoPackDetails;
            // CAFR.2011.2.23.9.1 ARB End
          end
          else begin
            PrintTotalLine;
            PrintSignature;
          end;
        end;
        MakeCustomInfo;
      finally
        VspPreview.EndOverlay;
      end;
    end;  // of for CntPage := 1 to VspPreview.PageCount
    FlgDuplicate := True;
  end;  // of VspPreview.PageCount > 0
end;   // of TFrmVSRptInvoiceCA.MakeOverLay

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintSignature;
begin  // of TFrmVSRptInvoiceCA.PrintSignature
  //signature director
  VspPreview.CurrentX := ViValRptMatrixPosX;
  VspPreview.CurrentY := ViValRptSignaturePosY;
  VspPreview.Text := CtTxtDirector;


  //Signature chief accountancy
  VspPreview.CurrentX := ViValRptMatrixPosX + 9000;
  VspPreview.CurrentY := ViValRptSignaturePosY;
  VspPreview.Text := CtTxtChiefAccountancy;

  //Signature ???
  VspPreview.CurrentX := ViValRptMatrixPosX + 9000;
  VspPreview.CurrentY := ViValRptSignaturePosY + 400;
  VspPreview.Text := CtTxtBeneficiary;

end;   // of TFrmVSRptInvoiceCA.PrintSignature

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintTotalLine;
var
  TxtLineTotal     : String;
begin   // of TFrmVSRptInvoiceCA.PrintTotalLine
  VspPreview.CurrentY := ValRptTotalPosY;
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.Font.Style := VspPreview.Font.Style + [fsBold];
  TxtLineTotal :=
         CtTxtTotalLine + SepCol + SepCol + SepCol + SepCol + Sepcol +
         SepCol + SepCol + SepCol +
         CurrToStrF (ValTotalVAT, ffFixed, DmdFpnUtils.QtyDecsPrice) +
         SepCol + CurrToStrF (ValTotal, ffFixed, DmdFpnUtils.QtyDecsPrice);
  VspPreview.AddTable (TxtTableBodyFmt, '', TxtLineTotal, False,
                       False, True);
    VspPreview.Font.Style := VspPreview.Font.Style - [fsBold];
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintTotalLine

//=============================================================================

procedure TFrmVSRptInvoiceCA.FormActivate(Sender: TObject);
begin
  inherited;
  if FlgRussia then
    ActPrintPage.Enabled := False;
end;

//=============================================================================

procedure TObjTransactionCA.Count(ObjTransaction: TObjTransaction);
begin  // of TObjTransactionCA.Count
  inherited;
  ValExclVAT     := ValExclVAT     + ObjTransaction.ValExclVAT;
  PrcD3E := PrcD3E + TObjTransactionCA(ObjTransaction).PrcD3E;
end;   // of TObjTransactionCA.Count

//=============================================================================
procedure TFrmVSRptInvoiceCA.CalcVATLines;
var
  CntVATCode       : Integer;          // Looping the VAT codes
  ObjVATData       : TObjVATData;      // Object containing the VAT data.
begin  // of TFrmVSRptInvoiceCA.CalcVATLines
  for CntVATCode := 0 to Pred (StrLstVAT.Count) do begin
    ObjVATData := TObjVATData (StrLstVAT.Objects [CntVATCode]);
    ObjVATData.NumTotalExVAT := StrToCurr(CurrToStrF((ObjVATData.NumTotalInVAT /
                                (1 + ObjVATData.PctVAT / 100)), ffFixed,
                                DmdFpnUtils.QtyDecsPrice));
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
end;   // of TFrmVSRptInvoiceCA.CalcVATLines

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintBodyDetailGiftCoupon;
var
  TxtPrint         : string;
begin  // of TFrmVSRptInvoiceCA.PrintBodyDetailGiftCoupon
  TxtPrint := SepCol + ObjCurrentTrans.TxtDescrAdm;
  VspPreview.AddTable (TxtTableBodyFmt, '', TxtPrint, False, False, True);

  TxtPrint := SepCol + ObjCurrentTrans.NumPLU;
  VspPreview.AddTable (TxtTableBodyFmt, '', TxtPrint, False, False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintBodyDetailGiftCoupon

//=============================================================================

function TFrmVSRptInvoiceCA.GenerateLineEcoTax: string;
begin  // of TFrmVSRptInvoiceCA.GenerateLineEcoTax
  Result := SepCol + ObjCurrentTrans.TxtDescrComment + ' ' +
            CurrToStrF (TObjTransactionCA(ObjCurrentTrans).Prcd3E, ffFixed,
                        DmdFpnUtils.QtyDecsPrice);
end;   // of TFrmVSRptInvoiceCA.GenerateLineEcoTax

//=============================================================================

function TFrmVSRptInvoiceCA.GenerateLineBon : string;
begin  // of TFrmVSRptInvoiceCA.GenerateLineBon
  Result := SepCol + ObjCurrentTrans.TxtDescrComment;
end;   // of TFrmVSRptInvoiceCA.GenerateLineBon

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintLineEcoTax;
begin  // of TFrmVSRptInvoiceCA.PrintLineEcoTax
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateLineEcoTax, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintLineEcoTax

//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintLineBon;
begin  // of TFrmVSRptInvoiceCA.PrintLineBon
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateLineBon, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintLineBon

// Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, Start
//=============================================================================
// TFrmVSRptInvoiceCA.PrintArticleNormalLine : Print a normal article line
//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintArticleNormalLine;
var
  NumLineTotal     : Currency;         // Total of the line.
begin  // of TFrmVSRptInvoiceCA.PrintArticleNormalLine
  // Commented as part of Intracom Invoice excl. Tax, ARB, R2011.1.EUR5
  //NumLineTotal := ObjCurrentTrans.ValInclVAT + ObjCurrentTrans.ValDiscInclVAT;
  if FlgClientIntracom then
    NumLineTotal := ObjCurrentTrans.ValExclVAT + ObjCurrentTrans.ValDiscExclVAT
  else
    NumLineTotal := ObjCurrentTrans.ValInclVAT + ObjCurrentTrans.ValDiscInclVAT;
  VspPreview.AddTable (TxtTableBodyFmt, '', GenerateNormalLine (NumLineTotal),
                       False, False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintArticleNormalLine

//=============================================================================
// TFrmVSRptInvoiceCA.PrintArticlePromoLine : In case of a promotion, print a
// promotion line.
//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintArticlePromoLine;
var
  CalcPrc          : Currency;         // Price to calculate with
begin  // of TFrmVSRptInvoiceCA.PrintArticlePromoLine
  if (ObjCurrentTrans.PrcInclVAT - ObjCurrentTrans.PrcPromInclVAT)
      <= -CtValMinFloat then
    CalcPrc := 0
  else begin
    //CalcPrc := ObjCurrentTrans.PrcInclVAT;
    if FlgClientIntracom then
      CalcPrc := ObjCurrentTrans.PrcExclVAT
    else
      CalcPrc := ObjCurrentTrans.PrcInclVAT
  end;
  VspPreview.AddTable (TxtTableBodyFmt, '', GeneratePromoNormalLine (CalcPrc),
                       False, False, True);
  EvaluatePagePosition;
  VspPreview.AddTable (TxtTableBodyFmt, '', GeneratePromoLine, False,
                       False, True);
  EvaluatePagePosition;
end;   // of TFrmVSRptInvoiceCA.PrintArticlePromoLine

//=============================================================================
// TFrmVSRptInvoiceCA.PrintArticleFreeLine : Print a line in case of a free
// article
//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintArticleFreeLine;
var
  CalcPrc          : Currency;         // Price to calculate with
begin  // of TFrmVSRptInvoiceCA.PrintArticleFreeLine
  if Abs (ObjCurrentTrans.PrcPromInclVAT) >= CtValMinFloat then
    begin
    if FlgClientIntracom then
      CalcPrc := ObjCurrentTrans.PrcPromExclVAT
    else
      CalcPrc := ObjCurrentTrans.PrcPromInclVAT
    end
    //CalcPrc := ObjCurrentTrans.PrcPromInclVAT;
  else
    //CalcPrc := ObjCurrentTrans.PrcInclVAT;
    begin
    if FlgClientIntracom then
      CalcPrc := ObjCurrentTrans.PrcExclVAT
    else
      CalcPrc := ObjCurrentTrans.PrcInclVAT
    end;
  if ObjCurrentTrans.QtyArt > 0 then begin
     VspPreview.AddTable (TxtTableBodyFmt, '', GenerateArticleFreeLine(CalcPrc),
                          False, False, True);
    EvaluatePagePosition;
  end;
end;   // of TFrmVSRptInvoiceCA.PrintArticleFreeLine


// Intracom Invoice excl. Tax, ARB, R2011.1.EUR5, End
//=============================================================================



procedure TFrmVSRptInvoiceCA.PrintEmployeeInfo;
var
  TxtLine          : string;
begin  // of TFrmVSRptInvoiceCA.PrintEmployeeInfo
  try
    if DmdFpnUtils.QueryInfo
                  ('Select * from POSTransDetail where ' +
                   'IdtPosTransaction = ' +
                          IntToStr(ObjCurrentTicket.IdtPOSTransaction) +
                   ' and CodType = ' +
                          IntToStr(CtCodPdtCommentNumEmployee) +
                   ' and DatTransBegin = ' +
              QuotedStr (FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                          ObjCurrentTicket.DatTransBegin))) then begin
      //Print cardnumber
      TxtLine := SepCol + CtTxtEmployeeCard + Trim(DmdFpnUtils.QryInfo.FieldByName('TxtDescr').AsString);
      VspPreview.AddTable (TxtTableBodyFmt, '', TxtLine, False, False, True);
      EvaluatePagePosition;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptInvoiceCA.PrintEmployeeInfo

//=============================================================================

function TFrmVSRptInvoiceCA.GetRemarqueText: string;
begin  // of TFrmVSRptInvoiceCA.GetRemarqueText
  try
    Result := '';
    if DmdFpnUtils.QueryInfo(
      #10'SELECT TxtApplicText' +
      #10'FROM ApplicTextLang' +
      #10'WHERE IdtApplicText = ' + QuotedStr('TxtRemarque') +
      #10'ORDER BY CodApplicText') then begin
      while not DmdFpnUtils.QryInfo.Eof do begin
        Result := Result + '  ' +
                  DmdFpnUtils.QryInfo.FieldByName ('TxtApplicText').AsString + #13;
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptInvoiceCA.GetRemarqueText

//==============================================================================
// TObjTransactionCA.IsClientIntraCom : Check if the current client is a
// client intracom.
// Remark: Make sure parameters are red before the use this function
// (ReadParams)
//==============================================================================

function TFrmVSRptInvoiceCA.IsClientIntraCom: Boolean;                          // BDFR - Evol2
var                                                                             // ..
  IdtCustIntraCom  : Integer;          // Id of client intracom
  TxtIntraCom      : string;           // Text to print for client intracom
begin  // of TFrmVSRptInvoiceCA.IsClientIntraCom
  IdtCustIntraCom := 90000 + StrToInt (DmdFpnUtils.IdtTradeMatrixAssort);
  TxtIntracom := TxtClientIntraLine1 + TxtClientIntraLine2 +
                 TxtClientIntraLine3 + TxtClientIntraLine4;
  Result := (IdtCustomer = IdtCustIntraCom) and (TxtIntraCom <> '');
end;  // of TFrmVSRptInvoiceCA.IsClientIntraCom                                 // BDFR - Evol2

//=============================================================================

//  CAFR.2011.2.23.9.1 ARB  Start
//==============================================================================
// TFrmVSRptInvoiceCA.PrintPromoPackDetails : Prints the details of the Bon D'
// achats that are attributed to the customer.
//==============================================================================
procedure TFrmVSRptInvoiceCA.PrintPromoPackDetails;
var
  CntTickets       : Integer;          // For looping through the tickets
  PPDetailedText : String;             // Promo Pack detailed text
begin  // of TFrmVSRptInvoiceCA.PrintVATTable
  VspPreview.MarginLeft := ViValRptVATPosX;
  VspPreview.CurrentX := ViValRptVATPosX;  // Xposition being used is the same
                                           // Used for the Vat Table
  //CAFR.2011.2.23.9.2 ARB Start
  //VspPreview.CurrentY := same as the current Y but only if its
  //not a Client Intracom Customer, incase of client Intracom the value is
  //hardcoded
  if FlgClientIntracom = True then
    VspPreview.CurrentY := ViValRptPromoPack;
  //CAFR.2011.2.23.9.2 ARB End
  for CntTickets := 0 to Pred (DmdFpnInvoice.LstTickets.Count) do begin
    PPDetailedText := TObjTransTicket (DmdFpnInvoice.LstTickets[CntTickets]).PromoPackComment;
    PPDetailedText :=  PPDetailedText + #13;
    if CntTickets >= 5 then begin // incase 5 details of coupons are accumlated
        PPDetailedText :=  PPDetailedText + '...';
        break;               // indicate text has been truncated.
    end;
  end;
  //CAFR.2011.2.23.9.2 ARB Start
  VspPreview.TextBox (PPDetailedText,
                          VspPreview.CurrentX, (VspPreview.CurrentY + 100.6),
                          4250, 1200,True,False, False);
  //CAFR.2011.2.23.9.2 ARB End
end;
//=============================================================================
// CAFR.2011.2.23.9.1 ARB   End
//R2012.1 Address De Facturation(SM) ::START
 procedure TFrmVSRptInvoiceCA.ReadIniFile;
var
  IniFile          : TIniFile;
  S                : Integer;
begin  // of ReadIniFile

  // Open INI-file
  IniFile := nil;
  try
    OpenIniFile (CIFNConfig, IniFile);
  except
    on E:Exception do begin
      //ShowError (E.message, 0);
      Exit;
    end;
  end;

  // Shortcut menu-keys
  S := IniFile.ReadInteger ('Common', 'BDFR', S);
   If S= 1 then
   FlgFrance := True;

  // Close INI-file
  IniFile.Free;
  IniFile := nil;
end;   // of ReadIniFile
// BDES - Invoice with bar code, PRG, R2012.1 - start
//=============================================================================
// CreateBarCode : Create a barcode bitmap
//=============================================================================

procedure TFrmVSRptInvoiceCA.CreateBarCode(TransDate   : TStDate;
                                           NumTicket   : LongInt;
                                           NumCashdesk : Word);
var
  strFilePath      : string;           // pathname for barcode
  TxtBarcd         : string;
begin  // of TFrmVSRptInvoiceCA.CreateBarCode
  TxtBarcd := '';  //No barcode will be printed if this text is blank due to below conditions
  if barcodereturn.Format <> '' then
    TxtBarcd := MaakEAN128BarCD (barcodereturn.Format,TransDate,NumTicket,NumCashdesk);
  StBrCdTcktInfo.ShowCode := false;
  StBrCdTcktInfo.Code := Copy(TxtBarcd, 0, Length(TxtBarcd));
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  StBrCdTcktInfo.SaveToFile(strFilePath);
end;   // of TFrmVSRptInvoiceCA.CreateBarCode

//=============================================================================
// PrintBarCode : Print the barcode bitmap
//=============================================================================

procedure TFrmVSRptInvoiceCA.PrintBarCode;
var
  StrFilePath      : string;           // pathname for logo
  PicLogo          : TPicture;         // Logo to be printed
  OlePicLogo       : IPictureDisp;     // Logo picture in OLE format
  VarPicWidth      : Real;             // Width of pic in twips
  VarPicHeight     : Real;             // Heigth of pic in twips
begin  // of TFrmVSRptInvoiceCA.PrintHeader
  VarPicHeight := 0;
  try
    // Barcode
    StrFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
    PicLogo := TPicture.Create;
    if FileExists (StrFilePath) then begin
      PicLogo.LoadFromFile(ReplaceEnvVar(StrFilePath));
      GetOlePicture (PicLogo, OlePicLogo);
      VspPreview.CalcPicture := OlePicLogo;
      VarPicWidth  := PicLogo.Width/Screen.PixelsPerInch * 1440;
      VarPicHeight := PicLogo.Height/Screen.PixelsPerInch * 1440;
      VspPreview.DrawPicture (OlePicLogo, VspPreview.PageWidth -
                              VspPreview.MarginLeft - VarPicWidth,
                              VspPreview.CurrentY, '100%', '100%', '', False);
    end; // of if FileExists (StrFilePath)
  finally
    // Restore fontsize for next report (barcode)
    VspPreview.FontSize := 8;
  end;
end;   // of TFrmVSRptInvoiceCA.CreateBarCode

//=============================================================================
// DestroyBarCode : Destroy the barcode bitmap
//=============================================================================

procedure TFrmVSRptInvoiceCA.DestroyBarCode;
var
  strFilePath      : string;           // pathname for barcode
begin  // of TFrmVSRptInvoiceCA.DestroyBarCode
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  if FileExists (strFilePath) then
     DeleteFile(strFilePath);
end;   // of TFrmVSRptInvoiceCA.DestroyBarCode

//=============================================================================
// BDES - Invoice with bar code, PRG, R2012.1 - end

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FVSRptInvoiceCA
