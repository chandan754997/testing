//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet  : Flexpoint
// Customer: Castorama
// Unit    : FVWPosJournalCA : Form VieW POS JOURNAL for CAstorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVWPosJournalCA.pas,v 1.51 2010/07/14 14:01:58 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FVWPosJournalCA - CVS revision 1.65
// Version ModifiedBy  Reason
// V 1.66  PRG  (TCS)  R2011.2 - BDES - Facture multi-tickets
// V 1.67  AM   (TCS)  R2011.2 - BDES - Traductions
// V 1.68  AM   (TCS)  R2012.1 - AnnulationTicket_sansAutoeng
// V 1.69  KC   (TCS)  R2012.1 - BRES - Facture multi-tickets
// V 1.70  PRG  (TCS)  R2012.1 - BDES - Invoice with bar code (already adjusted to include CAFR - Bar Code on ticket and B5 invoice, PRG, R2012.1 format)
// V 1.71  SC   (TCS)  R2012.1 - CAFR - Ajout_points_acquis_Carte_Castorama
// V 1.72  SMB  (TCS)  R2011.2 - DefectFix 448
// V 1.73  SRM  (TCS)  R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM
// V 1.74  SC   (TCS)  R2012.1 - Enhancement 263
// V 1.75  SM/CP(TCS)  R2013.1 - 11227-CAFR/BDES-Add store number in barcode
// V 1.76  SM   (TCS)  R2012.1 - DefectFix 299
// V 1.77  AS   (TCS)  R2013.2.Applix 2791888.PrptPosJournal-Display-Problem
// V 1.78  SC   (TCS)  R2013.2.Req(25020).BRFR-CAFR.Entering Customer Info
// V 1.79  TK   (TCS)  R2013.2.ALM-Defect192.PosJournal Display Problem.TCS-TK
// V 1.80  AJ   (TCS)  R2014.1.Req(46020).BDES.Replace abono by Factura Rectificativa.TCS-AJ
// V 1.81  Med  (TCS)  R2014.1.Req(45010).BRFR.Improved-Invoice-Address-For-Duplication.
// V 1.82  JD   (TCS)  R2013.2-Enhancement 315
// V 1.83  SC  (TCS)   R2014.2.Applix3129277.Mixture of invoice for blank customer 
// V 1.84  AJ   (TCS)  R2014.1.HOTFIX(19631).BDFR.Staff-Discount.TCS-AJ
//=============================================================================

unit FVWPosJournalCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FVWPosJournal, ImgList, ActnList, Menus, ComCtrls, StdCtrls, Buttons,
  ExtCtrls, DB, DBTables, ScTskMgr_BDE_DBC, DFpnPosTransaction,
  DFpnPosTransactionCA, StBarC, StDate;                                         // BDES - Invoice with bar code, PRG, R2012.1

//*****************************************************************************
// Global Identifiers
//*****************************************************************************

//=============================================================================
// Constants
//=============================================================================

const
  LstCodActPayments = [ctCodActCash, ctcodActEFT, CtCodActEFT2, ctCodActEFT3,
                       ctCodActEFT4, CtCodActForCurr, CtCodActForCurr2,
                       CtCodActForCurr3, CtCodActCheque, CtCodActCheque2,
                       CtCodActCoupPayment, CtCodActSavingCard,
                       CtCodActBankTransfer];

const
  CtTxtNumDaysInv        = 'NumDaysCreateInvoice';

//=============================================================================
// Variables
//=============================================================================

var  // Format's for ticket
  ViTxtFmtDocBO         : string  = 'Doc Nr: %s  Type: %s';// Format Description
                                                           // for BO
  ViTxtFmtDescr         : string  = '%-30.30s';// Format Description
  ViTxtFmtDescrNew      : string  = '%-45.45s';// Format Description     //R2012.1 47.01 Security  A.M.(Modifications)
  ViTxtFmtDescrPrcKorr  : string  = '%-45.45s';// Format Description    //R2014.2.Req(56010).BDES.Reason-correction-price.TCS-AJ
  ViTxtFmtHdrPrice      : string  = '%9s';     // Format Header Price
  ViTxtFmtPrice         : string  = '%9.2f';   // Format Price
  ViTxtFmtHdrAmount     : string  = '%12s';    // Format Header Amount
  ViTxtFmtAmount        : string  = '%12.2f';  // Format Amount
  CodActPrev            : Integer;  // To store codtaction of previous action//R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
  ViTxtCustomerName     : string;   //R2012.1 Defect Fix 299(SM)

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtFiscalReceipt     = 'Nr Fiscal Receipt: %s';
  CtTxtFiscalDate        = 'Date: %s';
  CtTxtLastEOD           = 'Last EOD: %s';
  CtTxtFiscalPrinter     = 'Nr fiscal printer: %s';
  CtTxtSureSelectCust    = 'Do you want to use customer %s (%s)?';
  CtTxtNumCard           = 'Card Nr: %s';
  CtTxtNumberEmployee    = 'Employee number:';
  CtTxtOriginalTicketID  = 'Original ticket ID:';
  CtTxtOriginalOrderID   = 'Original order ID:';
  CtTxtFmtApproval       = 'Approval: %s: %-20.20s';
  CtTxtCarteCadeau       = 'Carte Cadeau casto.';
  CtTxtMultiVAT          = 'Impossible to add this ticket: different VAT.';
  CtTxtAnnulReason       = 'Reason:';                                           //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
  CtTxtCancellation      = 'Annulation Ticket';                                 //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
  CtTxtPtsAcqdCarteCasto = 'Points acquired';                                   //R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)
  CtTxtPts               = 'points';                                            //R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)
  CtTxtPt                = 'point';                                             
// Facture multi-tickets, PRG, R2011.2 - start
//-----------------------------------------------------------------------------
  CtTxtDiffYear          = 'The added ticket must be from the same year as the tickets of the list';
  CtTxtDiffTcktType      = 'It is not possible to mix a sales ticket and a return ticket';
  CtTxtNATcktType        = 'It is not possible to add this kind of ticket';

// Facture multi-tickets, KC, R2012.1 - start
  CtTxtDiffMonth         = 'The added ticket must be from the same month as the tickets of the list';
// Facture multi-tickets, KC, R2012.1 - End

const
  CtCodTypeSale          = 1;
  CtCodTypeTakeBack      = 303;
  CtCodTypeCancelReceipt = 304;                                                 //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)
// Facture multi-tickets, PRG, R2011.2 - end
  CtCodActCancelLine     = 7;                                                  //R2013.2.Applix 2791888.PrptPosJournal-Display-Problem.AS(TCS)
  CtCodActCancelLastLine = 6;                                                  //R2013.2.Applix 2791888.PrptPosJournal-Display-Problem.AS(TCS)
//*****************************************************************************
// TFrmVWPosJournalCA
//*****************************************************************************

//=============================================================================

// Facture multi-tickets, PRG, R2011.2 - start
//-----------------------------------------------------------------------------
type
  TTcktType = (ctNotApplicable,ctNotAllowed,ctSale,ctReturn,ctCancel);  // Enumeration storing possible ticket types   //type cancel added //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)
//-----------------------------------------------------------------------------
// Facture multi-tickets, PRG, R2011.2 - end

type
  TObjTicket = class(TObject)
  private
    FIdtPOSTransaction: Integer;
    FIdtCheckOut: Integer;
    FCodTrans: Integer;
    FDatTransBegin: TDateTime;
    FTcktType: TTcktType;                                                       // Facture multi-tickets, PRG, R2011.2
  public
    property IdtPOSTransaction: Integer read FIdtPOSTransaction
      write FIdtPOSTransaction;
    property IdtCheckOut: Integer read FIdtCheckOut
      write FIdtCheckOut;
    property CodTrans: Integer read FCodTrans
      write FCodTrans;
    property DatTransBegin: TDateTime read FDatTransBegin
      write FDatTransBegin;
    property TcktType: TTcktType read FTcktType                                 // Facture multi-tickets, PRG, R2011.2
      write FTcktType;                                                          // Facture multi-tickets, PRG, R2011.2
    constructor Create(const IdtPosTransaction: integer;
      const IdtCheckout: integer;
      const CodTrans: integer;
      const DatTransBegin: TDateTime;                                           // Facture multi-tickets, PRG, R2011.2
      const TcktType: TTcktType = ctNotApplicable);                             // Facture multi-tickets, PRG, R2011.2
  end;

type
  TFrmVWPosJournalCA = class(TFrmVWPosJournal)
    ActInvReprint: TAction;
    ActInvCreate: TAction;
    MniInvoices: TMenuItem;
    ReprintInvoice1: TMenuItem;
    CreateInvoice1: TMenuItem;
    SvcTskLstCustomer: TSvcListTask;
    SvcTskDetCustomer: TSvcFormTask;
    SvcTskDetDepartment: TSvcFormTask;
    SvcTskDetManInvoice: TSvcFormTask;
    SvcTskLstClassification: TSvcListTask;
    SvcTskLstArticle: TSvcListTask;
    SvcTskDetManInvoiceArticle: TSvcFormTask;
    SvcTskDetManInvoiceComment: TSvcFormTask;
    SvcTskDetManInvoicePayments: TSvcFormTask;
    ActInvCreateManual: TAction;
    Createmanualinvoice1: TMenuItem;
    Addtoticketlist1: TMenuItem;
    Viewticketlist1: TMenuItem;
    Createinvoicefromticketlist1: TMenuItem;
    ActInvCreateMulti: TAction;
    ActInvAddToList: TAction;
    ActInvViewList: TAction;
    StBrCdTcktInfo: TStBarCode;                                                 // BDES - Invoice with bar code, PRG, R2012.1 - barcode component (width and format adjusted in form to include CAFR - Bar Code on ticket and B5 invoice, PRG, R2012.1 format)
    procedure ActCloseExecute(Sender: TObject);
    procedure ActInvCreateMultiExecute(Sender: TObject);
    procedure ActInvViewListExecute(Sender: TObject);
    procedure ActInvAddToListExecute(Sender: TObject);
    function IsValidAddToList(var TcktType: TTcktType): Boolean;                // Facture multi-tickets, PRG, R2011.2
    function ChkTcktType(): TTcktType;                                          // Facture multi-tickets, PRG, R2011.2
    procedure FormCreate(Sender: TObject);
    procedure ActInvExecute(Sender: TObject);
    procedure SvcTskLstCustomerCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstCustomerAfterExecute(Sender: TObject);
    procedure SvcTskDetCustomerCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetDepartmentAfterExecute(Sender: TObject);
    procedure SvcTskDetDepartmentCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetManInvoiceCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstClassificationCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstArticleCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetManInvoiceArticleCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetManInvoiceCommentCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetManInvoicePaymentsCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstClassificationBeforeExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
    procedure SvcTskLstCreate(Sender: TObject);
    procedure ActInvCreateManualExecute(Sender: TObject);
  private
    FFlgFiscal     : Boolean;
    FFlgItaly      : Boolean;
    FFlgDisableInvoice  : Boolean;
    FFlgRussia     : Boolean;
    FFlgCustFunc   : Boolean;
    FFlgDisableBonPassage    : Boolean;
    FFlgMultDepartment  : Boolean;
    FIdtDepartment : Integer;
    FIdtOrigInvoice: Integer;
    FFlgPrintCopy  : Boolean;
    FCodCreator    : Integer;
    ValPercPromDiff     : double;      // percentage difference between price and promo
    FViFlgMaskCCNumber : Boolean;
    FNumMaskCCStartPos : integer;
    FFlgAuthorised   : Boolean;                                                 //R2011.2 BDES-Traductions(A.M)
    FFlgAnnulation   : Boolean;                                                 //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
    FFlgMonth  : Boolean;                                                       //R2012.1 BRES-Facture_multi-tickets(K.C)
    //Properties for D3E
    FFlgShowEcoTaxTickLine   : boolean;
    FFlgShowEcoTaxInvoiceLine: boolean;
    FFlgShowEcoTaxInvoiceTotal    : boolean;
    FFlgShowEcoTaxFreeArt    : boolean;

    FFlgShowMOBTaxTickLine   : boolean;                                         //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.Start
    FFlgShowMOBTaxInvoiceLine: boolean;
    FFlgShowMOBTaxInvoiceTotal    : boolean;
    FFlgShowMOBTaxFreeArt    : boolean;                                         //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.End

    FFlgReturnTicket    : boolean;
    FFlgReturnBoDoc: boolean;
    FTxtDescrTotInvoiceFree  : string;
    FTxtDescrTotInvoice : string;
    FTxtDescrFreeArtLine: string;
    FTxtDescrArtLine    : string;

    FTxtDescrTotInvoiceFreeMOB  : string;                                       //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.Start
    FTxtDescrTotInvoiceMOB : string;
    FTxtDescrFreeArtLineMOB: string;
    FTxtDescrArtLineMOB    : string;                                            //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.End

    FFlgRevSign    : Boolean;
    FFlgMultiRecInv : Boolean;
    // BDES - Invoice with bar code, PRG, R2012.1 - start
    FDatTransBegin    : TStDate;          // Transaction date
    FNumTicket        : LongInt;          // Ticket Nnumber
    FNumCashdesk      : Word;             // Cashdesk number
    // BDES - Invoice with bar code, PRG, R2012.1 - end
  protected
    // Data Objects
    FIdtCustomer   : Integer;          // Customer id;
    FlgSeperateCNNumber : boolean;     // Use seperate number or not
    FlgChargeWithdrawSavingCard : Boolean;  // Indicates if current ticket is
                                            // Saving card Charge or Withdraw
    SprRTLstClass  : TStoredProc;           // Runtime Spr for Classification
    procedure AddCustomerHeader; override;
    procedure AddTicketHeader; override;
    procedure AddTicketFooter; override;                                        // BDES - Invoice with bar code, PRG, R2012.1  and TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)
    procedure AddTicketLines; override;
    procedure AddTicketLine; override;
    procedure AddSavingCard (FlgCancelled : Boolean); virtual;
    procedure ShowCurrentTicket; override;
    procedure DstLstTransAfterScroll (DataSet: TDataSet); override;
    procedure ReadParams; virtual;
    procedure SetResourceStringsDocs; virtual;
    procedure LoadIniConfig;virtual;     // Load ini config file
    function AskOrigInvoice: Integer;
    procedure AddCancelTicketInfo; virtual;
    procedure AddLineToTicket(TxtLine: string;
                              FntLine: TFont); override;
    // BDES - Invoice with bar code, PRG, R2012.1 - start
    procedure PrintTicket; override;
    procedure CreateBarCode (TransDate   : TStDate;
                             NumTicket   : LongInt;
                             NumCashdesk : Word); virtual;

    procedure PrintBarCode (var VarPicHeight:Real); virtual;
    procedure DestroyBarCode; virtual;
    // BDES - Invoice with bar code, PRG, R2012.1 - end
  published
    property IdtCustomer : Integer read  FIdtCustomer
                                   write FIdtCustomer;
    property CodCreator : Integer read FCodCreator
                                  write FCodCreator;
    property FlgFiscal: Boolean read FFlgFiscal
                              write FFlgFiscal;
    property FlgItaly: Boolean read FFlgItaly write FFlgItaly;
    property FlgRussia: Boolean read FFlgRussia write FFlgRussia;
    property FlgDisableInvoice: Boolean read FFlgDisableInvoice
                                       write FFlgDisableInvoice;
    property FlgCustFunc: Boolean read FFlgCustFunc
                                 write FFlgCustFunc;
    property FlgDisableBonPassage: Boolean read FFlgDisableBonPassage
                                          write FFlgDisableBonPassage;
    property FlgMultDepartment: Boolean read FFlgMultDepartment
                                       write FFlgMultDepartment;
    property IdtDepartment: integer read FIdtDepartment write FIdtDepartment;
    property IdtOrigInvoice: integer read FIdtOrigInvoice write FIdtOrigInvoice;
    property FlgPrintCopy: Boolean read FFlgPrintCopy write FFlgPrintCopy;
    property ViFlgMaskCCNumber: Boolean read FViFlgMaskCCNumber write FViFlgMaskCCNumber;
    property NumMaskCCStartPos: integer read FNumMaskCCStartPos write FNumMaskCCStartPos;
    //D3E-properties
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
    //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.Start ::::
    property TxtDescrArtLineMOB: string read FTxtDescrArtLineMOB
                                    write FTxtDescrArtLineMOB;
    property TxtDescrFreeArtLineMOB: string read FTxtDescrFreeArtLineMOB
                                        write FTxtDescrFreeArtLineMOB;
    property TxtDescrTotInvoiceMOB: string read FTxtDescrTotInvoiceMOB
                                       write FTxtDescrTotInvoiceMOB;
    property TxtDescrTotInvoiceFreeMOB: string read FTxtDescrTotInvoiceFreeMOB
                                           write FTxtDescrTotInvoiceFreeMOB;
    property FlgShowMOBTaxTickLine: boolean read FFlgShowMOBTaxTickLine
                                              write FFlgShowMOBTaxTickLine;
    property FlgShowMOBTaxInvoiceLine: boolean read FFlgShowMOBTaxInvoiceLine
                                              write FFlgShowMOBTaxInvoiceLine;
    property FlgShowMOBTaxInvoiceTotal: boolean read FFlgShowMOBTaxInvoiceTotal
                                               write FFlgShowMOBTaxInvoiceTotal;
    property FlgShowMOBTaxFreeArt: boolean read FFlgShowMOBTaxFreeArt
                                          write FFlgShowMOBTaxFreeArt;
    //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.End   ::::
    property FlgReturnTicket: boolean read FFlgReturnTicket
                                          write FFlgReturnTicket;
    property FlgReturnBoDoc: boolean read FFlgReturnBoDoc
                                    write FFlgReturnBoDoc;
    property FlgRevSign : Boolean read FFlgRevSign write FFlgRevSign;
    property FlgMultiRecInv : Boolean read FFlgMultiRecInv write FFlgMultiRecInv;
    property FlgAuthorised : Boolean read FFlgAuthorised write FFlgAuthorised;  //R2011.2 BDES-Traductions(A.M)
    property FlgAnnulation : Boolean read FFlgAnnulation write FFlgAnnulation;  //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
	property FlgMonth: Boolean read FFlgMonth write FFlgmonth;                    //R2012.1 BRES-Facture_multi-tickets(K.C)
    
	// BDES - Invoice with bar code, PRG, R2012.1 - start
    property DatTransBegin  : TStDate read FDatTransBegin write FDatTransBegin; // Transaction date
    property NumTicket      : LongInt read FNumTicket write FNumTicket;         // Ticket Nnumber
    property NumCashdesk    : Word read FNumCashdesk write FNumCashdesk;        // Cashdesk number
    // BDES - Invoice with bar code, PRG, R2012.1 - end
  public
    NumDaysCreateInv: Integer;
    StrLstObjTicket: TStringList;
  end;

var
  FrmVWPosJournalCA      : TFrmVWPosJournalCA;
  // R2014.1.Req(46020).BDES.Replace abono by Factura Rectificativa.TCS-AJ.Start
  DatOrigTick            : string;
  DatOrigTickDatTime     : TDateTime;
  IdtCheckOutOrig        : string;
  IdtPosTransactionOrig  : string;
  // R2014.1.Req(46020).BDES.Replace abono by Factura Rectificativa.TCS-AJ.End
  Flgblnkcust            : boolean =False;                                                   //R2013.2-Enhancement 315- JD
  FlgEmplCard            : Boolean;                                                       //R2014.1.HOTFIX(19631).BDFR.Staff-Discount.TCS-AJ
//*****************************************************************************

implementation

{$R *.DFM}                                               

uses
  Variants,
  StStrL,
  StStrW,
  //FRptCfgPosJournalCA,        // R2011.2 BDES-Traductions(A.M)
  SfDialog,
  SfVSPrinter7,
  SfList_BDE_DBC,
  SrStnCom,
  SmFile,
  SmUtils,
  SmDBUtil_BDE,
  SmVSPrinter7Lib_TLB,
  //StDate,                                                                     // Commented out - BDES - Invoice with bar code, PRG, R2012.1

  DFpnUtils,
  DFpnBODocument,
  RFpnCom,
  DFpnInvoice,
  DFpnCustomer,
  DFpnAddress,

  // To create/Reprint invoices
  FVSRptInvoice,
  FVSRptInvoiceCA,
  DFpnInvoiceCA,
  IniFiles,
  FInputInvOrigCA,
  FDetCustomerCA,
  DFpnDepartment,
  DFpnWorkStatCA,
  FDlgAskDepartment,
  FDetManInvoiceCA,
  FDetManInvoiceArticleCA,
  FDetManInvoiceCommentCA,
  FDetManInvoicePaymentCA,
  DFpnClassification,
  DFpnArticle,
  DFpnCustomerCA,
  UFpsSyst,
  RFpnComCA,
  ActiveX,                                                                      // BDES - Invoice with bar code, PRG, R2012.1
  AXCtrls,                                                                      // BDES - Invoice with bar code, PRG, R2012.1
  FVWPosJournalTicketLst;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVWPosJournalCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: $';
  CtTxtSrcVersion = '$Revision: 1.81 $';
  CtTxtSrcDate    = '$Date: 2014/03/26 13:37:58 $';

//*****************************************************************************
// Implementation of TObjTicket
//*****************************************************************************

constructor TObjTicket.Create(const IdtPosTransaction: integer;
  const IdtCheckout: integer;
  const CodTrans: integer;
  const DatTransBegin: TDateTime;                                               // Facture multi-tickets, PRG, R2011.2 
  const TcktType: TTcktType);                                                   // Facture multi-tickets, PRG, R2011.2
begin // of TObjTicket.Create
  FIdtPosTransaction := IdtPosTransaction;
  FIdtCheckout := IdtCheckout;
  FCodTrans := CodTrans;
  FDatTransBegin := DatTransBegin;
  FTcktType := TcktType;                                                        // Facture multi-tickets, PRG, R2011.2 - type of ticket - Sale/Return   
end; // of TObjTicket.Create

//*****************************************************************************
// Implementation of TFrmVWPosJournalCA
//*****************************************************************************

procedure TFrmVWPosJournalCA.AddCustomerHeader;
var
  TxtHdr           : string;           // Build the header line
  TxtLine          : string;           // Build the data line to add
  TxtName          : string;           // Customer name
  TxtStreet        : string;           // Street
  TxtZipCod        : string;           // Zipcode
  TxtMunicip       : string;           // Municipality
  txtSql           : string;           // sql statement
  txtFirstName     : string;
  txtLastName      : string;
  txtDescr         : string;
  NumCard          : string;                                                    //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ
  TxtIdtCustomer   : string;                                                    //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ
  //TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)--start
  TempIdtCheckout  : string;
  TempOperatorNum  : string;
  //TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)--end
  PctDiscount      : Currency;         // Get PctDiscount                       //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ

begin // of TFrmVWPosJournalCA.AddCustomerHeader

  //TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)--start
  TempIdtCheckout := IntToStr(DstLstTrans.FieldByName('IdtCheckout').AsInteger);
  TempOperatorNum := IntToStr(DstLstTrans.FieldByName('IdtOperator').AsInteger);
  //TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)--end

  //inherited;
  //Client marketing
  if (DstLstTrans.FieldByName ('NumCard').AsString <> '') then begin
    TxtHdr  := PadString (CharStrW (' ', 3) + Format(CtTxtNumCard,
                    [DstLstTrans.FieldByName ('NumCard').AsString]),
                    ViValTicketWidthPreview - Length (TxtHdr)) ;
    AddLineToTicket (TxtHdr, FntHeader);
  end;
  if (DstLstTrans.FieldByName ('IdtCustPosTrans').IsNull) and
     (DstLstTrans.FieldByName('IdtCustomer').AsInteger = 0) and
     DstLstTrans.FieldByName ('IdtCustInvoice').IsNull then begin
    txtSql :=
      #10'SELECT * FROM POSTransDetail WHERE ' +
      #10'IdtPosTransaction = ' +
          IntToStr(DstLstTrans.FieldByName('IdtPOSTransaction').AsInteger) +
      #10'and CodType in (' +
          IntToStr(CtCodPdtCommentCustMarketingTitle) + ',' +
          IntToStr(CtCodPdtCommentCustMarketingName) + ',' +
          IntToStr(CtCodPdtCommentCustMarketingFirstName) + ',' +
          IntToStr(CtCodPdtCommentCustDocBoTitle) + ',' +
          IntToStr(CtCodPdtCommentCustDocBoName) + ',' +
          IntToStr(CtCodPdtCommentCustDocBoFirstName) + ')' +
      #10'and DatTransBegin = ' +
          AnsiQuotedStr (FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
          DstLstTrans.FieldByName('DatTransBegin').AsDateTime), '''') +
      #10'and CodTrans = ' +
          IntToStr(DstLstTrans.FieldByName('CodTrans').AsInteger) +
      #10'and IdtCheckout = ' +
          IntToStr(DstLstTrans.FieldByName('IdtCheckout').AsInteger) +
      #10'ORDER BY codtype';

    try
      DmdFpnUtils.ClearQryInfo;
      if DmdFpnUtils.QueryInfo (txtSql) then begin
        // First try to fill with customer client marketing
        while not DmdFpnUtils.QryInfo.Eof do begin
          txtDescr := DmdFpnUtils.QryInfo.FieldByName('TxtDescr').AsString;
          if txtDescr <> '' then begin
            case DmdFpnUtils.QryInfo.FieldByName('CodType').AsInteger of
              CtCodPdtCommentCustMarketingTitle,
              CtCodPdtCommentCustMarketingFirstName: begin
                if txtFirstName <> '' then
                  txtFirstName := txtFirstName + ' ' + txtDescr
                else
                  txtFirstName := txtDescr;
              end;
              CtCodPdtCommentCustMarketingName: begin
                txtLastName := txtDescr;
              end;
            end;
          end;
          DmdFpnUtils.QryInfo.Next;
        end;
        // If no result try customer information from doc bo
        if (TxtFirstName = '') and (TxtLastName = '') then begin
          DmdFpnUtils.QryInfo.First;
          while not DmdFpnUtils.QryInfo.Eof do begin
            txtDescr := DmdFpnUtils.QryInfo.FieldByName('TxtDescr').AsString;
            if txtDescr <> '' then begin
              case DmdFpnUtils.QryInfo.FieldByName('CodType').AsInteger of
                CtCodPdtCommentCustDocBoTitle,
                CtCodPdtCommentCustDocBoFirstName: begin
                  if txtFirstName <> '' then
                    txtFirstName := txtFirstName + ' ' + txtDescr
                  else
                    txtFirstName := txtDescr;
                end;
                CtCodPdtCommentCustDocBoName: begin
                  txtLastName := txtDescr;
                end;
              end;
            end;
            DmdFpnUtils.QryInfo.Next;
          end;
        end;
      end;
    finally
      DmdFpnUtils.CloseInfo;
      DmdFpnUtils.ClearQryInfo;
    end;
    if (TxtFirstName <> '') or (TxtLastName <> '') then
      AddLineToTicket (' ', FntNormal);
    if TxtFirstName <> '' then begin
      TxtHdr  := PadString (CharStrW (' ', 3) +
                  txtFirstName,
                  ViValTicketWidthPreview - Length (TxtHdr)) ;
      AddLineToTicket (TxtHdr, FntHeader);
    end;
    if TxtLastName <> '' then begin
      TxtHdr  := PadString (CharStrW (' ', 3) +
                  txtLastName,
                  ViValTicketWidthPreview - Length (TxtHdr));
      AddLineToTicket (TxtHdr, FntHeader);
    end;
  end
  else begin

    if DstLstTrans.FieldByName ('IdtCustInvoice').IsNull then begin
      //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ.Start
      NumCard := DstLstTrans.FieldByName ('NumCard').AsString;
      if ViFlgBDFR and (NumCard <> '') then begin
        if DstLstTrans.FieldByName ('IdtCustomer').IsNull then
          Exit;

        AddLineToTicket (' ', FntNormal);
        TxtHdr  := '';
        TxtLine := '';

        PctDiscount := DstLstTrans.FieldByName ('PctDiscount').AsInteger;
        if PctDiscount <> 0 then begin
          TxtHdr  := CtTxtDiscount;
          TxtLine := Format ('%f',[PctDiscount]) + '%';
        end;
        NumCard := DstLstTrans.FieldByName ('NumCard').AsString;
        TxtHdr  := PadString (CharStrW (' ', 3) + CtTxtCustomer + ' ' +
                              DstLstTrans.FieldByName ('TxtIdtCustomer').AsString,
                              ViValTicketWidthPreview - Length (TxtHdr)) + TxtHdr;
        TxtLine := PadString (CharStrW (' ', 3) +
                              DstLstTrans.FieldByName ('TxtNameCustomer').AsString,
                              ViValTicketWidthPreview - Length (TxtLine)) + TxtLine;
        AddLineToTicket (TxtHdr, FntHeader);
        AddLineToTicket (TxtLine, FntNormal);

        AddLineToTicket (CharStrW (' ', 3) +
                         DstLstTrans.FieldByName ('TxtNameStreet').AsString + ' ',
                         FntNormal);
        AddLineToTicket (CharStrW (' ', 3) +
                         DstLstTrans.FieldByName ('TxtNameMunicip').AsString,
                         FntNormal);
        
        Exit;
      end
      else begin
       //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ.End
        inherited;
        Exit;  
      end                                                                       //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ
    end;

    AddLineToTicket (' ', FntNormal);
    TxtHdr  := '';
    TxtLine := '';

    try
      NumCard := '';                                                            //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ
      TxtName   := '';
      TxtStreet := '';
      TxtZipcod := '';
      TxtMunicip := '';
      NumCard := DstLstTrans.FieldByName ('NumCard').AsString;                  //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ
      TxtName   := DstLstTrans.FieldByName ('TxtNameCustomer').AsString;
      //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ.Start
      if (NumCard <> '') and ViFlgBDFR then
        TxtStreet := DstLstTrans.FieldByName ('TxtNameStreet').AsString
      else
      //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ.End
      TxtStreet := DstLstTrans.FieldByName ('TxtStreet').AsString;
      TxtZipcod := DstLstTrans.FieldByName ('TxtCodPost').AsString;
      //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ.Start
      if (NumCard <> '') and ViFlgBDFR then
        TxtMunicip := DstLstTrans.FieldByName ('TxtNameMunicip').AsString
      else
      //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ.End
        TxtMunicip := DstLstTrans.FieldByName ('TxtMunicip').AsString;
      //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ.Start
      if (NumCard <> '') and ViFlgBDFR then
        TxtIdtCustomer := DstLstTrans.FieldByName ('TxtIdtCustomer').AsString
      else
      //R2013.2.HOTFIX(45040).BDFR.Customer From SAP.TCS-AJ.End
        TxtIdtCustomer := DstLstTrans.FieldByName ('IdtCustomer').AsString;
    finally
      DmdFpnUtils.CloseInfo;
    end;

    TxtHdr  := PadString (CharStrW (' ', 3) + CtTxtCustomer + ' ' +
                  DstLstTrans.FieldByName ('IdtCustInvoice').AsString,
                  ViValTicketWidthPreview - Length (TxtHdr)) + TxtHdr;
    TxtLine := PadString (CharStrW (' ', 3) +
                  TxtName, ViValTicketWidthPreview - Length (TxtLine)) + TxtLine;
    AddLineToTicket (TxtHdr, FntHeader);
    AddLineToTicket (TxtLine, FntNormal);

    AddLineToTicket (CharStrW (' ', 3) + TxtStreet + ' ', FntNormal);
    if TxtZipcod <> '' then
      AddLineToTicket (CharStrW (' ', 3) + TxtZipcod + ' ' + TxtMunicip, FntNormal)
    else
      AddLineToTicket (CharStrW (' ', 3) + TxtMunicip, FntNormal);
  end;
end;  // of TFrmVWPosJournalCA.AddCustomerHeader

//=============================================================================

procedure TFrmVwPosJournalCA.AddTicketHeader;
var
  TxtLine          : string;           // Build the line to add
  IdtInvDeliv      : Integer;          // Get IdtInvoice or IdtDelivNote or NumFiscalTicket
  ValTempTotal     : Currency;         // Total value
  CodAct           : Integer;          // CodAction
  TxtDescr         : string;           // fiscal info
  NumFiscalReceipt : string;
  DatFiscalReceipt : string;
  NumLastEOD       : string;
  NumFiscalPrinter : string;
  posSeperator     : Integer;
begin // of TFrmVwPosJournalCA.AddTicketHeader
  TxtLine := '';
  FlgChargeWithdrawSavingCard := False;
  IdtInvDeliv := DstLstTrans.FieldByName ('IdtInvoice').AsInteger;
  if IdtInvDeliv <> 0 then begin
    ValTempTotal := 0;
    DstDetTrans.First;
    while not DstDetTrans.EOF do begin
      CodAct   := DstDetTrans.FieldByName ('CodAction').AsInteger;
      if CodAct = CtCodActTotal then
        ValTempTotal := DstDetTrans.FieldByName ('ValInclVat').AsCurrency;
      DstDetTrans.Next;
    end; // of while not DstDetTrans.EOF
    if ValTempTotal < 0 then
      TxtLine := Format ('%s %d - ', [CtTxtCreditNote, IdtInvDeliv])
    else
      TxtLine := Format ('%s %d - ', [CtTxtInvoice, IdtInvDeliv]);
  end; // of if IdtInvDeliv <> 0
  IdtInvDeliv := DstLstTrans.FieldByName ('IdtDelivNote').AsInteger;
  if IdtInvDeliv <> 0 then
    TxtLine := Format ('%s%s %d - ', [TxtLine, CtTxtDelivNote, IdtInvDeliv]);
  // Savingcard Charge or Redraw ?
  if TxtLine = '' then begin
    DstDetTrans.First;
    while not DstDetTrans.EOF do begin
      CodAct   := DstDetTrans.FieldByName ('CodAction').AsInteger;
      if CodAct = CtCodActChargeSavingCard then
        TxtLine := Format ('%s - ', [CtTxtChargeSavingCard])
      else if CodAct = CtCodActWithdrawSavingCard then
        TxtLine := Format ('%s - ', [CtTxtWithDrawSavingCard]);
      if TxtLine <> '' then
        break;
      DstDetTrans.Next;
    end; // of while not DstDetTrans.EOF
    FlgChargeWithdrawSavingCard := TxtLine <> '';
  end; // of if TxtLine = ''
  if TxtLine = '' then
    TxtLine := Format ('%s - ', [CtTxtTicket]);
  TxtLine := '   ' + TxtLine + CtTxtCheckout + ' ' + IntToStr (IdtCheckout) +
             ' ' + CtTxtOperator + ' ' +
             DstLstTrans.FieldByName ('IdtOperator').AsString + ' (' +
             DstLstTrans.FieldByName ('TxtName').AsString + ')';
  // BDES - Invoice with bar code, PRG, R2012.1 - start - store value for printing barcode
  NumCashdesk := IdtCheckout;
  NumTicket   := DstLstTrans.FieldByName('IdtPOSTransaction').AsInteger;
  DatTransBegin :=  DateTimeToStDate(DstLstTrans.FieldByName('DatTransBegin').AsDateTime);
  // BDES - Invoice with bar code, PRG, R2012.1 - end
  AddLineToTicket ('', FntHeader);
  AddLineToTicket (TxtLine, FntHeader);
  if not FlgChargeWithdrawSavingCard then begin
    if StrToInt(DstLstTrans.FieldByName('CodTrans').AsString) =
       CtCodPttErrReceiptAut then
      AddCancelTicketInfo;
    //Add fiscal info
    IdtInvDeliv := DstLstTrans.FieldByName ('NumFiscalTicket').AsInteger;
    if (IdtInvDeliv <> 0) and FlgFiscal then begin
      DmdFpnUtils.QueryInfo
        ('Select * from POSTransDetail where ' +
           'IdtPosTransaction = ' +
              IntToStr(DstLstTrans.FieldByName('IdtPOSTransaction').AsInteger) +
           ' and CodType = ' + IntToStr(CtCodPdtCommentFiscReceiptInfo) +
           ' and DatTransBegin = ' +
              AnsiQuotedStr (
                    FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                    DstLstTrans.FieldByName('DatTransBegin').AsDateTime), ''''));
      if not (DmdFpnUtils.qryInfo.Eof) then begin
        //info ivm fiscal receipt ophalen
        txtDescr := DmdFpnUtils.QryInfo.fieldByName('TxtDescr').AsString;
        NumFiscalReceipt := IntToStr(IdtInvDeliv);
        DatFiscalReceipt := Copy(txtDescr,1,2) + '-' + Copy(txtDescr,3,2) + '-' +
                            Copy(txtDescr,5,4);
        txtDescr := Copy(txtDescr,10, length(txtdescr)-9);
        posSeperator := Ansipos(';', txtDescr);
        NumLastEOD := Copy(txtDescr,1,posSeperator - 1);
        NumFiscalPrinter := Copy(txtDescr, posSeperator + 1,
                                 length(txtDescr) - posSeperator);

        AddLineToTicket ('   ' + Format(CtTxtFiscalReceipt,[NumFiscalReceipt]),
                                        FntHeader);
        AddLineToTicket ('   ' + Format(CtTxtFiscalDate,[DatFiscalReceipt]),
                                        FntHeader);
        AddLineToTicket ('   ' + Format(CtTxtLastEOD,[NumLastEOD]), FntHeader);
        AddLineToTicket ('   ' + Format(CtTxtFiscalPrinter, [NumFiscalPrinter]),
                                        FntHeader);
      end;
      DmdFpnUtils.QryInfo.Close;
    end;
  end;
  if DstLstTrans.FieldByName ('FlgTraining').AsInteger = 1 then
    AddLineToTicket ('   ' + CtTxtTraining, FntHeader);
  if DstLstTrans.FieldByname ('CodReturn').AsInteger = CtCodPtrDeliveryNote then
    AddLineToTicket ('   ' + CtTxtTransDelivNote, FntHeader)
  else if DstLstTrans.FieldByname ('CodReturn').AsInteger = CtCodPtrInvoice then
    AddLineToTicket ('   ' + CtTxtTransInvoice, FntHeader);
  if not FlgChargeWithdrawSavingCard then
    AddCustomerHeader;
  // Empty line
  AddLineToTicket ('', FntNormal);
  if FlgChargeWithdrawSavingCard then
    AddSavingCard (DstLstTrans.FieldByname ('CodReturn').AsInteger =
                    CtCodPtrCancelReceipt);
  if not FlgChargeWithdrawSavingCard then
    AddLineToTicket (' ' + Format (ViTxtFmtQty, [CtTxtQuantity]) +
                     ' ' + Format (ViTxtFmtDescr, [CtTxtHdrDescr]) +
                     Format (ViTxtFmtHdrPrice, [CtTxtHdrPrice]) +
                     Format (ViTxtFmtHdrAmount, [CtTxtAmount]),
                     FntHeader);
end;  // of TFrmVwPosJournalCA.AddTicketHeader

//=============================================================================

// BDES - Invoice with bar code, PRG, R2012.1 - start
//=============================================================================
// TFrmVwPosJournalCA.AddTicketFooter : Adds the footer of the ticket
//=============================================================================

{procedure TFrmVwPosJournalCA.AddTicketFooter;
begin // of TFrmVWPosJournal.AddTicketFooter
  // Get's the footer of the ticket
  AddLineToTicket ('', FntNormal);
  AddLineToTicket ('   ' + CtTxtTicketNumber + ' ' +
                   IntToStr (IdtPosTransaction) + CharStrW (' ', 10) +
                   DateTimeToStr (DatTransBegin), FntHeader);
  if FlgShowApproval and
     not DstLstTrans.FieldByName ('IdtOperApproval').IsNull then
    AddLineToTicket ('   ' +
      Format (ViTxtFmtApproval,
              [DstLstTrans.FieldByName ('IdtOperApproval').AsString,
               DstLstTrans.FieldByName ('TxtNameApproval').AsString]),
               FntHeader);
  if CodVisActCurrent = CtCodVisActDisplay then begin
    AddLineToTicket ('', FntHeader);
    AddLineToTicket ('', FntHeader);
  end;
end;  // of TFrmVwPosJournalCA.AddTicketFooter
}
// BDES - Invoice with bar code, PRG, R2012.1 - end
//=============================================================================

//TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)--start
procedure TFrmVWPosJournalCA.AddTicketFooter;
var
 TxtPtsAcquiredCarteCastoLine :string;
 TempIdtPosTrans  : string;
 TempDatTrans     : string;
 TempIdtCheckout  : integer;
 TempOperatorNum  : integer;

begin // of TFrmVWPosJournal.AddTicketFooter
  // Get's the footer of the ticket
  AddLineToTicket ('', FntNormal);
  TempIdtPosTrans := DstLstTrans.FieldByName('IdtPosTransaction').AsString;
  TempIdtCheckout := DstLstTrans.FieldByName('IdtCheckout').AsInteger;
  TempOperatorNum := DstLstTrans.FieldByName('IdtOperator').AsInteger;
  TempDatTrans    := DstLstTrans.FieldByName('DatTransBegin').AsString;
  if GetPrevTickCCPtsInfo(TempIdtPosTrans,TempOperatorNum,TempIdtCheckout,TempDatTrans) then begin
   if PrevTickAmtCarteCasto = 0 then
     TxtPtsAcquiredCarteCastoLine := CtTxtPtsAcqdCarteCasto + ' ' + floattostr(PrevTickAmtCarteCasto) + ' ' + CtTxtPt
   else
     TxtPtsAcquiredCarteCastoLine := CtTxtPtsAcqdCarteCasto + ' ' + floattostr(PrevTickAmtCarteCasto) + ' ' + CtTxtPts;
  AddLineToTicket('          ' + TxtPtsAcquiredCarteCastoLine, FntNormal);
  AddLineToTicket('          ' + '', FntNormal);                                
  PrevTickAmtCarteCasto := 0;
  end;
  AddLineToTicket ('   ' + CtTxtTicketNumber + ' ' +
                   IntToStr (IdtPosTransaction) + CharStrW (' ', 10) +
                   TempDatTrans, FntHeader);   // BDES - Invoice with bar code -  PRG, R2012.1
  if FlgShowApproval and
     not DstLstTrans.FieldByName ('IdtOperApproval').IsNull then
    AddLineToTicket ('   ' +
      Format (ViTxtFmtApproval,
              [DstLstTrans.FieldByName ('IdtOperApproval').AsString,
               DstLstTrans.FieldByName ('TxtNameApproval').AsString]),
               FntHeader);
  if CodVisActCurrent = CtCodVisActDisplay then begin
    AddLineToTicket ('', FntHeader);
    AddLineToTicket ('', FntHeader);
  end;
end;  // of TFrmVwPosJournalCA.AddTicketFooter

//TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)--start
//================================================================================
procedure TFrmVWPosJournalCA.AddTicketLines;
begin // of TFrmVWPosJournalCA.AddTicketLines
// R2014.1.Req(46020).BDES.Replace abono by Factura Rectificativa.TCS-AJ.Start
  DstDetTrans.First;
  while not DstDetTrans.EOF do begin
   if  ( DstDetTrans.FieldByName('codtype').AsString = inttostr(CtCodPdtCommentTakeBackDatTick)) then
   begin
     DatOrigTick  := DstDetTrans.FieldByName ('Txtdescr').AsString;
	 if DatOrigTick <> '' then
       DatOrigTickDatTime := StrToDateTime(DatOrigTick,CtTxtDatFormat, CtTxtHouFormat);
   end
   else if (DstDetTrans.FieldByName('codtype').AsString = inttostr(CtCodPdtCommentTakeBackNumCashdesk)) then
     IdtCheckOutOrig := DstDetTrans.FieldByName ('Txtdescr').AsString
   else if (DstDetTrans.FieldByName('codtype').AsString = inttostr(CtCodPdtCommentTakeBackNumTick)) then
     IdtPosTransactionOrig := DstDetTrans.FieldByName ('Txtdescr').AsString;
  DstDetTrans.Next;
  end;
// R2014.1.Req(46020).BDES.Replace abono by Factura Rectificativa.TCS-AJ.End
  FlgReturnTicket := False;
  DstDetTrans.First;
  while not DstDetTrans.EOF do begin
    AddTicketLine;
    DstDetTrans.Next;
  end;
end;  // of TFrmVWPosJournalCA.AddTicketLines

//=============================================================================

procedure TFrmVWPosJournalCA.AddTicketLine;
var
  TxtLine          : string;           // To build the line to add
  CodType          : Integer;          // CodType detailline
  CodAct           : Integer;          // CodAction of detailline
  TxtDescr         : string;           // to hold TxtDescr
  TxtFormat        : string;           // format for municipality string
  QtyReg           : Integer;          // Get QtyReg from dataset
  CurrTxt        : Currency;         // Currnecy field for foreign currency
  QtyLine          : Double;
  ValPrice         : Currency;
  TxtEcoTaxLine    : string;
  TxtMOBTaxLine    : string;                                                    //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM
  TxtCommentLine   : string;
  TxtLeft          : string;
  TxtRight         : string;
  TxtCardInfo      : string;

begin  // of TFrmVWPosJournalCA.AddTicketLine
  FntNormal.Color := clBlack;
  CodType  := DstDetTrans.FieldByName ('CodType').AsInteger;
  CodAct   := DstDetTrans.FieldByName ('CodAction').AsInteger;
  TxtDescr := DstDetTrans.FieldByName ('TxtDescr').AsString;
 //check for CAFR only for annulation ticket                                    //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)-Start
  if (FlgAnnulation) then begin
     if (CodAct = CtCodActCancelReceipt) then begin
       CodActPrev :=  CtCodActCancelReceipt;
       TxtDescr:= CtTxtCancellation;
     end
     else if (CodAct = CtCodActTakeBack) then begin
       CodActPrev :=  CtCodActTakeBack;
     end;
     //R2013.2.Applix 2791888.PrptPosJournal-Display-Problem.AS(TCS).Start
     if (CodAct = CtCodActCancelLine) then begin
       CodActPrev := CtCodActCancelLine;
     end;
     if (CodAct = CtCodActCancelLastLine) then begin
       CodActPrev := CtCodActCancelLastLine;
     end;
     //R2013.2.Applix 2791888.PrptPosJournal-Display-Problem.AS(TCS).end

  end;                                                                          //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)-End
  // infoline
  if (CodType = CtCodPdtInfoDocBO) or (CodType = CtCodPdtInfoDocBOLocal) or
     (CodType = CtCodPdtInfoDocBOLocalTransfer) then begin
    SetResourceStringsDocs;
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + ' ' +
               ViArrTxtShortDescrDoc[DstDetTrans.FieldByName ('CodTypeVente').
               AsInteger] + ': ' + DstDetTrans.FieldByName ('IdtCVente').AsString;
    AddLineToTicket (TxtLine, FntNormal);
  end // of if (CodType = CtCodPdtInfoDocBO) or (CodType = CtCodPdtInfoDocBOLocal)
  // Fiscal info line and client marketing lines
  else if ((CodType = CtCodPdtCommentFiscReceiptInfo) or
           (CodType = CtCodPdtCommentCustMarketingNumber) or
           (CodType = CtCodPdtCommentCustMarketingTitle) or
           (CodType = CtCodPdtCommentCustMarketingName) or
           (CodType = CtCodPdtCommentCustMarketingFirstName) or
           (CodType = CtCodPdtCommentCustDocBoTitle) or
           (CodType = CtCodPdtCommentCustDocBoName) or
           (CodType = CtCodPdtCommentCustDocBoFirstName)) then
    Exit
  // Prix promo
  else if (CodType = CtCodPdtCommentDocBoPV_Fichier) then
    Exit
  // municipality lines
  else if ((CodType = CtCodPdtCommentCodPost) or
           (CodType = CtCodPdtCommentCodCommune) or
           (CodType = CtCodPdtCommentCodCountry))
          and (CodAct = CtCodActComment)
          and not (CodType = CtCodPdtCommentAmountDiscPers) then begin
    // add blank line before municipality block
    case CodType of
      CtCodPdtCommentCodPost    : begin
        TxtFormat := ViTxtFmtZipCode;
        AddLineToTicket (' ', FntNormal);
      end; // of CtCodPdtCommentCodPost
      CtCodPdtCommentCodCommune : TxtFormat := ViTxtFmtCommune;
      CtCodPdtCommentCodCountry : TxtFormat := ViTxtFmtCountry;
    end; // of case CodType
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) +
               ' ' + Format (ViTxtFmtDescr, [Format (TxtFormat, [TxtDescr])]);
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if ((CodType = CtCodPdtCommentCodPost)
  // Add '-' before amount and don't print price if 'Return'
  else if (CodAct = CtCodActReturn) or
          ((CodAct = CtCodActComment) and
           (CodType = CtCodPdtCommentBankTransReturn)) then begin
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + Format (ViTxtFmtDescr,
               [DstDetTrans.FieldByName ('TxtDescr').AsString]) + '         ' +
               Format (ViTxtFmtAmount,
               [-DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodAct = CtCodActReturn)
  // Printing of Carte Cadeau Castorama
  else if (CodAct = CtCodActGiftCard) or (CodAct = CtCodPayGiftCard)
  or (CodAct = CtCodErrGiftCard) then begin       //R2011.2 Defect 448 TCS SMB
    QtyReg := DstDetTrans.FieldByName ('QtyReg').AsInteger;
    if (CodAct = CtCodPayGiftCard) then begin
      if QtyReg <> 0 then
        TxtLine := ' ' + Format (ViTxtFmtQty, [IntToStr (QtyReg)])
      else
        TxtLine := ' ' + Format (ViTxtFmtQty, [' ']);
      TxtLine := TxtLine + ' ' + Format (ViTxtFmtDescr, [CtTxtCarteCadeau]) +
                 Format (ViTxtFmtPrice,
                         [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]) +
                 Format (ViTxtFmtAmount,
                         [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
      AddLineToTicket (TxtLine, FntNormal);
    end // of if (CodAct = CtCodPayGiftCard)
    else begin
      if QtyReg <> 0 then
        TxtLine := ' ' + Format (ViTxtFmtQty, [IntToStr (QtyReg)])
      else
        TxtLine := ' ' + Format (ViTxtFmtQty, [' ']);
      TxtLine := TxtLine + ' ' + Format (ViTxtFmtDescr, [CtTxtCarteCadeau]);
      AddLineToTicket (TxtLine, FntNormal);
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                 Format (ViTxtFmtDescr,
                         [DstDetTrans.FieldByName ('NumPlu').AsString]) +
                 Format (ViTxtFmtPrice,
                         [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]) +
                 Format (ViTxtFmtAmount,
                         [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
      AddLineToTicket (TxtLine, FntNormal);
    end; // of else begin
  end // of else if (CodAct = CtCodActGiftCard) or (CodAct = CtCodPayGiftCard)
  // Don't print price if 'subtotal', 'total' or cash
  else if (CodAct = CtCodActSubTotal) or (CodAct = CtCodActTotal) or
          (CodAct = CtCodActBalance) then begin
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
              Format (ViTxtFmtDescr,
                     [DstDetTrans.FieldByName ('TxtDescr').AsString]) +
              '         ' +
              Format (ViTxtFmtAmount,
                     [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodAct = CtCodActSubTotal) or (CodAct = CtCodActTotal)
  else if (CodAct = CtCodActCash) or
          (CodAct = CtCodActCoupPayment) or
          (CodAct in LstCodActPayments) then begin
    if FlgRevSign and (DstDetTrans.FieldByName ('ValInclVat').AsCurrency <> 0)
    then
      ValPrice := DstDetTrans.FieldByName ('PrcInclVat').AsCurrency
    else
      ValPrice := DstDetTrans.FieldByName ('ValInclVat').AsCurrency;
    if CodAct in [CtCodActForCurr, CtCodActForCurr2, CtCodActForCurr3] then begin
      CurrTxt := DstDetTrans.FieldByName ('PrcInclVat').AsCurrency;
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
              Format (ViTxtFmtDescr,
                     [DstDetTrans.FieldByName ('TxtDescr').AsString]) +
              Format (ViTxtFmtPrice, [CurrTxt]) +
              Format (ViTxtFmtAmount, [ValPrice]);
    end
    else
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
              Format (ViTxtFmtDescr,
                     [DstDetTrans.FieldByName ('TxtDescr').AsString]) +
              '         ' +
              Format (ViTxtFmtAmount, [ValPrice]);
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodAct = CtCodActCash)
  else if ((CodAct = CtCodActComment) and
           (CodType = CtCodPdtCommentBankTransPayMent)) then begin
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
              Format (ViTxtFmtDescr,
                     [DstDetTrans.FieldByName ('TxtDescr').AsString]) +
              '         ' +
              Format (ViTxtFmtAmount,
                     [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if ((CodAct = CtCodActComment)
  // Suppress amount if overwritten price
  else if (CodAct = CtCodActPrcOverwrite) then begin
    // Print nothing
  end // of else if (CodAct = CtCodActPrcOverwrite)
  else if ((CodAct = CtCodActComment) and
          (CodType = CtCodPdtCommentCouponDeactivation)) then
    Exit
  else if ((CodAct = CtCodActComment) and
          (CodType = CtCodPdtCommentArtInfoCustOrder)) then begin
    QtyReg := DstDetTrans.FieldByName ('QtyReg').AsInteger;
    TxtLine := ' ' + Format (ViTxtFmtQty, [IntToStr(QtyReg)]) + ' ' +
              Format (ViTxtFmtDescr,
                     [DstDetTrans.FieldByName ('TxtDescr').AsString]) +
              Format (ViTxtFmtPrice,
                     [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]);
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if ((CodAct = CtCodActComment)
  // don't print start and end return lines
  else if (CodAct = CtCodActReturnOrigTick) and
           ((CodType = CtCodPdtInfoReturnOrigStart) or
           (CodType = CtCodPdtInfoReturnOrigEnd)) then begin
    FlgReturnTicket := True;
    FlgReturnBoDoc := True;
    Exit;
  end // of else if (CodAct = CtCodActReturnOrigTick)
  else if (CodAct = CtCodActComment) and
          (CodType = CtCodPdtCommentTakeBackDatTick) then begin
    if FlgReturnTicket then begin
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                Format (ViTxtFmtDescr,
                       [CtTxtOriginalTicketID]) + '' + '';
      AddLineToTicket (TxtLine, FntNormal);
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
               Format (ViTxtFmtDescr,
                       [DstDetTrans.FieldByName ('TxtDescr').AsString]) + '' + '';
      AddLineToTicket (TxtLine, FntNormal);
    end // of if FlgReturnTicket
    else begin
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                Format (ViTxtFmtDescr,
                       [DstDetTrans.FieldByName ('TxtDescr').AsString]) + '' + '';
      AddLineToTicket (TxtLine, FntNormal);
    end; // of else begin
    FlgReturnTicket := False;
    FlgReturnBoDoc := False;
  end // of else if (CodAct = CtCodActComment)
  else if (CodAct = CtCodActComment) and
          (CodType = CtCodPdtCommentTakeBackNumStore) then begin
    if FlgReturnBoDoc then begin
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                Format (ViTxtFmtDescr,
                       [CtTxtOriginalOrderID]) + '' + '';
      AddLineToTicket (TxtLine, FntNormal);
    end // of if FlgReturnBoDoc
    else begin
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                Format (ViTxtFmtDescr,
                       [DstDetTrans.FieldByName ('TxtDescr').AsString]) + '' + '';
      AddLineToTicket (TxtLine, FntNormal);
    end; // of else begin
    FlgReturnTicket := False;
    FlgReturnBoDoc := False;
  end // of else if (CodAct = CtCodActComment)
  // employee number
  else if (CodAct = CtCodActComment) and (CodType = CtCodPdtCommentNumEmployee)
  then begin
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +  Format (ViTxtFmtDescr,
               [CtTxtNumberEmployee + ' ' + DstDetTrans.FieldByName ('TxtDescr').
               AsString]) + '' + '';
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodAct = CtCodActComment)
  else if (CodAct = CtCodActComment) and
          (CodType = CtCodPdtCommentCouponsAttributed) then begin
    TxtCommentLine := Format(CtTxtPromopackCoupAttributed,
              [DstDetTrans.FieldByName('QtyReg').AsInteger,
               DstDetTrans.FieldByName ('ValInclVat').AsFloat,
               DstDetTrans.FieldByName('IdtCurrency').AsString,
               DstDetTrans.FieldByName ('PrcInclVat').AsInteger] );
    WordWrapString(TxtCommentLine, TxtLeft, TxtRight, 30, False);
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
               Format (ViTxtFmtDescr, [TxtLeft]);
    AddLineToTicket (TxtLine, FntNormal);
    if TxtRight <> '' then begin
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                 Format (ViTxtFmtDescr, [TxtRight]);
      AddLineToTicket (TxtLine, FntNormal);
    end; // of if TxtRight <> ''
  end
  else if ((CodAct = CtCodActComment)
       and (CodType = CtCodPdtCommentAnswerCatalogue)) then begin
       if DstDetTrans.FieldByName ('TxtDescr').AsString = 'YES' then begin
         TxtFormat := ViTxtCatalogue;
         TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) +
                 ' ' + Format (ViTxtFmtDescr, [Format (TxtFormat, [CtTxtYes])]);
         AddLineToTicket (TxtLine, FntNormal);
       end
       else begin
         TxtFormat := ViTxtCatalogue;
         TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) +
               ' ' + Format (ViTxtFmtDescr, [Format (TxtFormat, [CtTxtNo])]);
         AddLineToTicket (TxtLine, FntNormal);
       end
  end// of else if (CodAct = CtCodActComment)
  // Suppress amount and price for comment lines, correction and cash
  else if ((CodAct = CtCodActComment)
       and (CodType <> CtCodPdtCommentAmountDiscPers))
       and (CodType <> CtCodPdtCommentEcoTaxArticle)
       and (CodType <> CtCodPdtCommentEcoTaxFreeArticle)
       and (CodType <> CtCodPdtCommentMOBTaxArticle)                            //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM
       and (CodType <> CtCodPdtCommentMOBTaxFreeArticle)                        //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM
       and (CodType <> CtCodPdtCommentInstalmentCard)
       and (CodType <> CtCodPdtCommentInstalmentLoanType)
       and (CodType <> CtCodPdtCommentInstalmentLoanID)
       and (CodType <> CtCodPdtCommentInstalmentLoanPeriod) or
           (CodAct = CtCodActCancelLL) or
           (CodAct = CtCodActPromoCoupon) or
           (CodAct = CtCodActCorrection) then begin
    if (CodType = CtCodPdtInfoEFTNumCard) and (CodAct = CtCodActComment) then
    begin
      LoadIniConfig;
      if ViFlgMaskCCNumber then begin
        if (NumMaskCCStartPos > 0) and
           (NumMaskCCStartPos<Length(DstDetTrans.FieldByName ('TxtDescr').AsString))
        then
          // CARU - Chars Credit Card
          TxtCardInfo := Copy (DstDetTrans.FieldByName ('TxtDescr').AsString, 1,
                         NumMaskCCStartPos - 1) + CharStrL ('.', Length
                         (DstDetTrans.FieldByName ('TxtDescr').
                         AsString) - (NumMaskCCStartPos - 1));
      end // of if ViFlgMaskCCNumber
      else
        TxtCardInfo := DstDetTrans.FieldByName ('TxtDescr').AsString;
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                 Format (ViTxtFmtDescr,[TxtCardInfo])  + '' + '';
      AddLineToTicket (TxtLine, FntNormal);
    end // of if (CodType = CtCodPdtInfoEFTNumCard)
    else begin
      //R2014.2.Req(56010).BDES.Reason-correction-price.TCS-AJ.start
      if ViFlgPrccorrection and FlgAnnulation and not (CodActPrev = CtCodActCancelReceipt) then begin
        TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                       Format (ViTxtFmtDescrPrcKorr,
                       [DstDetTrans.FieldByName ('TxtDescr').AsString]) + '' + '';
        AddLineToTicket (TxtLine, FntNormal);
        CodActPrev := 0 ;
      end
      //R2014.2.Req(56010).BDES.Reason-correction-price.TCS-AJ.end
      else if (FlgAnnulation and not (CodActPrev = CtCodActCancelReceipt)) or (not FlgAnnulation)  then begin         //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)   //R2013.2.ALM-Defect192.PosJournal Display Problem.TCS-TK
        TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                       Format (ViTxtFmtDescr,
                       [DstDetTrans.FieldByName ('TxtDescr').AsString]) + '' + '';

        AddLineToTicket (TxtLine, FntNormal);
        CodActPrev := 0 ;                                          //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
      end;                                                        //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
    end; // of else begin
  end


  // of else if ((CodAct = CtCodActComment)
  // Articles
  else if DstDetTrans.FieldByName ('IdtArticle').AsString <> '' then begin
    QtyReg := DstDetTrans.FieldByName ('QtyReg').AsInteger;
    QtyLine := DstDetTrans.FieldByName ('QtyLine').AsFloat;
    if QtyReg <> 0 then
      TxtLine := ' ' + Format (ViTxtFmtQty, [IntToStr (QtyReg)])
    else
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']);
    TxtLine := TxtLine + ' ' + Format (ViTxtFmtDescr,
               [DstDetTrans.FieldByName ('TxtDescr').AsString]);
    AddLineToTicket (TxtLine, FntNormal);
    ValPrice := DstDetTrans.FieldByName ('PrcInclVat').AsCurrency;
    if not DstDetTrans.Eof then begin
      DstDetTrans.Next;
      if not DstDetTrans.Eof then begin
        if DstDetTrans.FieldByName ('CodAction').AsInteger = CtCodActPrcCampaign
        then begin
          if ValPrice - (ValPrice/100*ValPercPromDiff) >
             Abs (DstDetTrans.FieldByName ('PrcInclVat').AsCurrency) then
            DstDetTrans.Prior;
        end // of if DstDetTrans.FieldByName ('CodAction').AsInteger
        else
          DstDetTrans.Prior;
      end // of if not DstDetTrans.Eof
      else
        DstDetTrans.Last;
    end; // of if not DstDetTrans.Eof
    if DstDetTrans.FieldByName('CodSalesUnit').AsInteger <> 0 then begin
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + Format (ViTxtFmtDescr,
                 [DstDetTrans.FieldByName ('NumPLU').AsString]);
      AddLineToTicket(TxtLine, FntNormal);
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                 Format (ViTxtFmtDescr, [FloatToStr(QtyLine)]) +
                 Format (ViTxtFmtPrice,
                         [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]) +
                 Format (ViTxtFmtAmount,
                         [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
      AddLineToTicket (TxtLine, FntNormal);
    end // of if DstDetTrans.FieldByName('CodSalesUnit').AsInteger <>
    else begin
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
                 Format (ViTxtFmtDescr,
                         [DstDetTrans.FieldByName ('NumPLU').AsString]) +
                 Format (ViTxtFmtPrice,
                         [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]) +
                 Format (ViTxtFmtAmount,
                         [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
      AddLineToTicket (TxtLine, FntNormal);
    end; // of else begin
  end // of else if DstDetTrans.FieldByName ('IdtArticle').AsString <> ''
  // Personnel discount
  else if (CodAct = CtCodActComment) and (CodType = CtCodPdtCommentAmountDiscPers)
  then begin
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']);
    TxtLine := TxtLine + ' ' + Format (ViTxtFmtDescr,
               [DstDetTrans.FieldByName ('TxtDescr').AsString]) +
               Format (ViTxtFmtPrice,
                       [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]);
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodAct = CtCodActComment)
  //gift coupon
  else if (CodAct = CtCodActGiftCoupon) then begin
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + Format (ViTxtFmtDescr,
               [DstDetTrans.FieldByName ('TxtDescr').AsString]) + '         ' +
               Format (ViTxtFmtAmount,
               [-DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
    AddLineToTicket (TxtLine, FntNormal);
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
               DstDetTrans.FieldByName ('NumPLU').AsString;
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodAct = CtCodActGiftCoupon)
  else if CodAct = CtCodActChequeCrealfi then begin
    // First call inherited to show main line
    inherited;
    // Then show cheque number on an extra line
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' +
              Format (ViTxtFmtDescr,
                     [DstDetTrans.FieldByName ('NumPLU').AsString]);
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if CodAct = CtCodActChequeCrealfi
  else if (CodType = CtCodPdtCommentEcoTaxArticle)
       or (CodType = CtCodPdtCommentEcoTaxFreeArticle) then begin
    if FlgShowEcoTaxTickLine then begin
      TxtEcoTaxLine := Trim(TxtDescr) + ' ' + Trim(Format (ViTxtFmtPrice,
                       [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]));
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + TxtEcoTaxLine;
      AddLineToTicket (TxtLine, FntNormal);
    end; // of if FlgShowEcoTaxTickLine
  end // of else if (CodType = CtCodPdtCommentEcoTaxArticle)
  // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.Start ::::
  else if (CodType = CtCodPdtCommentMOBTaxArticle)
       or (CodType = CtCodPdtCommentMOBTaxFreeArticle) then begin
    if FlgShowMOBTaxTickLine then begin
      TxtMOBTaxLine := Trim(TxtDescr) + ' ' + Trim(Format (ViTxtFmtPrice,
                       [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]));
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + TxtMOBTaxLine;
      AddLineToTicket (TxtLine, FntNormal);
    end; // of if FlgShowMOBTaxTickLine
  end // of else if (CodType = CtCodPdtCommentMOBTaxArticle)
  // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.End ::::
  else if (CodType = CtCodPdtCommentInstalmentCard) then begin
    TxtCommentline := Format (ViTxtFmtDescr,[CtTxtLblPrnInstAccount + ' ' +
                      DstDetTrans.FieldByName ('TxtDescr').AsString]);
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + TxtCommentLine;
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodType = CtCodPdtCommentInstalmentCard)
  else if (CodType = CtCodPdtCommentInstalmentLoanType) then begin
    TxtCommentline := Format (ViTxtFmtDescr,[CtTxtLblPrnInstLoanType + ' ' +
                      DstDetTrans.FieldByName ('TxtDescr').AsString]);
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + TxtCommentLine;
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodType = CtCodPdtCommentInstalmentLoanType)
  else if (CodType = CtCodPdtCommentInstalmentLoanID) then begin
    TxtCommentline := Format (ViTxtFmtDescr,[CtTxtLblPrnInstLoanID + ' ' +
                      DstDetTrans.FieldByName ('TxtDescr').AsString]);
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + TxtCommentLine;
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodType = CtCodPdtCommentInstalmentLoanID)
  else if (CodType = CtCodPdtCommentInstalmentLoanPeriod) then begin
    TxtCommentline := Format (ViTxtFmtDescr,[CtTxtLblPrnInstLoanPeriod + ' ' +
                      DstDetTrans.FieldByName ('TxtDescr').AsString]);
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + ' ' + TxtCommentLine;
    AddLineToTicket (TxtLine, FntNormal);
  end // of else if (CodType = CtCodPdtCommentInstalmentLoanPeriod)
  // Other cases
  else begin
    QtyReg := DstDetTrans.FieldByName ('QtyReg').AsInteger;
    if QtyReg <> 0 then
      TxtLine := ' ' + Format (ViTxtFmtQty, [IntToStr (QtyReg)])
    else
      TxtLine := ' ' + Format (ViTxtFmtQty, [' ']);
   //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)(Modifications)-Start
    if (FlgAnnulation) and (CodAct = CtCodActCancelReceipt) then begin
    TxtLine := TxtLine + ' ' +
               Format (ViTxtFmtDescr,
                       [TxtDescr]) +
               Format (ViTxtFmtPrice,
                       [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]) +
               Format (ViTxtFmtAmount,
                       [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
    end
    else begin
   //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)(Modifications)-End
    TxtLine := TxtLine + ' ' +
               Format (ViTxtFmtDescr,
                       [DstDetTrans.FieldByName ('TxtDescr').AsString]) +
               Format (ViTxtFmtPrice,
                       [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]) +
               Format (ViTxtFmtAmount,
                       [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
    end; //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)(Modifications)
    AddLineToTicket (TxtLine, FntNormal);
  end; // of else begin
//R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)-Start
  if (FlgAnnulation) then begin
      if (CodActPrev = CtCodActCancelReceipt) and (CodAct = CtCodActComment) and (CodType=CtCodPdtInfo) then begin
         {TxtCommentline := Format (ViTxtFmtDescr,[CtTxtAnnulReason + ' ' +  //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)(Modifications)-COMMENETD
                      DstDetTrans.FieldByName ('TxtDescr').AsString]); }     //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)(Modifications)-COMMENETD
        //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)(Modifications)-Start
         TxtCommentline := Format (ViTxtFmtDescrNew,[CtTxtAnnulReason + ' ' +
                      Copy (DstDetTrans.FieldByName ('TxtDescr').AsString,
                              AnsiPos (' ', DstDetTrans.FieldByName ('TxtDescr').AsString) + 1,
                              Length (DstDetTrans.FieldByName ('TxtDescr').AsString))]);
        //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)-End
         TxtLine := ' ' + Format (ViTxtFmtQty, [' ']) + '   ' + TxtCommentLine;
         AddLineToTicket (TxtLine, FntNormal);
       CodActPrev := 0 ;
      end;

  end;                                                                           
//R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)-End
     if FlgShowApproval and not DstDetTrans.FieldByName ('IdtOperApproval').IsNull
   then
      AddLineToTicket (Format (' ' + ViTxtFmtQty + '   ' + CtTxtFmtApproval,
      ['', DstDetTrans.FieldByName ('IdtOperApproval').AsString,
      DstDetTrans.FieldByName ('TxtNameApproval').AsString]), FntNormal);
 end;   // of TFrmVWPosJournalCA.AddTicketLine

//=============================================================================

procedure TFrmVWPosJournalCA.AddSavingCard (FlgCancelled : Boolean);
var
  CodAction        : Integer;          // Current CodAction
  CodType          : Integer;          // Current CodType
  TxtCustomerCard  : string;           // Text Customer card
  TxtCustomerName  : string;           // Text Name Customer
  TxtAmount        : string;           // Text amount charged or withdrawn
  TxtBalance       : string;           // Text Balance customercard
  StrLstPayment    : TStringList;      // list of payments
  Cnt              : Integer;          // Counter
begin // of TFrmVWPosJournalCA.AddSavingCard
  TxtCustomerName := Format (CtTxtSavingCardCustomerName,
                      [DstLstTrans.FieldByName ('TxtNameCustomer').AsString]);
  // Retrieve the data
  TxtCustomerCard := '';
  TxtAmount := '';
  TxtBalance := '';
  StrLstPayment := TStringList.Create;
  DstDetTrans.First;
  while not DstDetTrans.EOF do begin
    CodAction := DstDetTrans.FieldByName ('CodAction').AsInteger;
    CodType   := DstDetTrans.FieldByName ('CodType').AsInteger;
    // Charge/Withdraw
    if CodAction in [CtCodActChargeSavingCard,
                     CtCodActWithdrawSavingCard] then begin
      if TxtAmount = '' then begin
        TxtAmount := Format (CtTxtSavingCardAmount,
                      [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
        TxtCustomerCard := Format (CtTxtSavingCardNumber,
                            [DstDetTrans.FieldByName ('TxtSrcNumPLU').AsString]);
      end
    end
    // Balance
    else if (CodAction = CtCodActComment) and
            (CodType = CtCodPdtCommentSavCardBalance) then
      TxtBalance := Format (CtTxtSavingCardBalance,
                     [DstDetTrans.FieldByName ('ValInclVat').AsCurrency,
                      DstDetTrans.FieldByName ('IdtCurrency').AsString])
    // Payments
    else if CodAction in
             [CtCodActCash,
              CtCodActCheque, CtCodActCheque2,
              CtCodActEFT, CtCodActEFT2, CtCodActEFT3, CtCodActEFT4,
              CtCodActForCurr, CtCodActForCurr2, CtCodActForCurr3,
              CtCodActReturn] then
      StrLstPayment.Add (Format ('    %-30.30s %12.2f',
                          [DstDetTrans.FieldByName ('TxtDescr').AsString,
                           DstDetTrans.FieldByName ('ValInclVat').AsCurrency]));
    DstDetTrans.Next;
  end;
  // Print the retrieved data
  if FlgCancelled then begin
    AddLineToTicket (CtTxtSavingCardCancelled, FntHeader);
    AddLineToTicket ('', FntNormal);
  end;
  AddLineToTicket (TxtAmount, FntNormal);
  AddLineToTicket ('', FntNormal);
  for Cnt := 0 to StrLstPayment.Count - 1 do
    AddLineToTicket (StrLstPayment[Cnt], FntNormal);
  AddLineToTicket ('', FntNormal);
  AddLineToTicket (TxtCustomerCard, FntNormal);
  AddLineToTicket (TxtCustomerName, FntNormal);
  AddLineToTicket (TxtBalance, FntNormal);
end;  // of TFrmVWPosJournalCA.AddSavingCard

//=============================================================================

procedure TFrmVWPosJournalCA.DstLstTransAfterScroll (DataSet: TDataSet);
var
  NumDays          : Integer;
  ticket           : TObjTicket;
  CntTrans         : Integer;
  FlgFound         : Boolean;
begin  // of TFrmVWPosJournalCA.DstLstTransAfterScroll
  inherited;
  NumDays := DateTimeToStDate (Date) - DateTimeToStDate(DataSet.
      FieldByName ('DatTransBegin').AsDateTime);
  ActInvCreate.Enabled :=
    DataSet.FieldByName ('IdtInvoice').IsNull and
    (DataSet.FieldByName ('IdtPOSTransaction').AsInteger <> 0) and
    (DataSet.FieldByName ('CodReturn').AsInteger = 0) and
    ((NumDays < NumDaysCreateInv) or
     (NumDaysCreateInv = 0)) and
    (DataSet.FieldByName ('FlgTraining').AsInteger = 0) and
    (not FlgDisableInvoice);
  if FlgMultiRecInv then begin
    FlgFound := False;
    ActInvAddToList.Visible := True;
    ActInvCreateMulti.Visible := True;
    ActInvViewList.Visible := True;
    for CntTrans := 0 to StrLstObjTicket.Count-1 do begin
      ticket := TObjticket(StrLstObjTicket.Objects[CntTrans]);
      if ticket.IdtPosTransaction = DataSet.FieldByName('IdtPOSTransaction').AsInteger then
        FlgFound := True;
    end ;
    If FlgFound then
      ActInvAddToList.Enabled := False
    else
      ActInvAddToList.Enabled := ActInvCreate.Enabled;
    if ((StrLstObjTicket.Count > 0) and (FlgMultiRecInv)) then begin
      ActInvCreateMulti.Enabled := True;
      ActInvCreate.Enabled := False;
      ActInvViewList.Enabled := True;
    end
    else begin
      ActInvCreateMulti.Enabled := False;
      ActInvViewList.Enabled := False;
    end;
  end
  else begin
    ActInvAddToList.Visible := False;
    ActInvCreateMulti.Visible := False;
    ActInvViewList.Visible := False;
  end;
  if FlgItaly then begin
    ActInvCreateManual.Enabled := ActInvCreate.Enabled;
  end;
  ActInvReprint.Enabled := not DataSet.FieldByName ('IdtInvoice').IsNull and
    (DataSet.FieldByName ('CodReturn').AsInteger = 0) and
    (not FlgDisableInvoice);
end;   // of TFrmVWPosJournalCA.DstLstTransAfterScroll

//=============================================================================

procedure TFrmVWPosJournalCA.ReadParams;
var
  IniFile             : TIniFile;         // IniObject to the INI-file
  TxtPath             : string;           // Path of the ini-file
  TxtSepNumb          : string;            // String with separate number
  TxtFlag             : string;
begin  // of TFrmVWPosJournalCA.ReadParams
  TxtPath := ReplaceEnvVar ('%SycRoot%\FlexPos\Ini\FpsSyst.INI');
  IniFile := nil;
  OpenIniFile(TxtPath, IniFile);
  if IniFile.ReadString('Promotion', 'PercPromDiff', '') <> '' then
    ValPercPromDiff := StrToFloat(IniFile.ReadString('Promotion', 'PercPromDiff', ''));
  // Use seperate number for creditnotes
  TxtSepNumb := IniFile.ReadString('Common', 'SeperateNumberCreditNote', '');
  if Trim (TxtSepNumb) <> '' then
    FlgSeperateCNNumber :=  StrToBool(TxtSepNumb, 'T')
  else
    FlgSeperateCNNumber :=  False;
  FlgMultDepartment := DmdFpnDepartment.NumDepartments > 1;
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
    //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.Start :::
    //MOBtax properties
  if IniFile.ReadString('EcoTax', 'DescrArtLineMOB', '') <> '' then
    TxtDescrArtLineMOB := IniFile.ReadString('EcoTax', 'DescrArtLineMOB', '');

  if IniFile.ReadString('EcoTax', 'DescrFreeArtLineMOB', '') <> '' then
    TxtDescrFreeArtLineMOB := IniFile.ReadString('EcoTax', 'DescrFreeArtLineMOB', '');

  if IniFile.ReadString('EcoTax', 'DescrTotInvoiceMOB', '') <> '' then
    TxtDescrTotInvoiceMOB := IniFile.ReadString('EcoTax', 'DescrTotInvoiceMOB', '');

  if IniFile.ReadString('EcoTax', 'DescrTotInvoiceFreeMOB', '') <> '' then
    TxtDescrTotInvoiceFreeMOB := IniFile.ReadString('EcoTax', 'DescrTotInvoiceFreeMOB', '');

  TxtFlag := IniFile.ReadString('EcoTax', 'ShowMOBTaxTickLine', '');
  if Trim (TxtFlag) <> '' then
    FlgShowMOBTaxTickLine :=  StrToBool(TxtFlag, 'T')
  else
    FlgShowMOBTaxTickLine :=  False;

  TxtFlag := IniFile.ReadString('EcoTax', 'ShowMOBTaxInvoiceLine', '');
  if Trim (TxtFlag) <> '' then
    FlgShowMOBTaxInvoiceLine :=  StrToBool(TxtFlag, 'T')
  else
    FlgShowMOBTaxInvoiceLine :=  False;

  TxtFlag := IniFile.ReadString('EcoTax', 'ShowMOBTaxInvoiceTotal', '');
  if Trim (TxtFlag) <> '' then
    FlgShowMOBTaxInvoiceTotal :=  StrToBool(TxtFlag, 'T')
  else
    FlgShowMOBTaxInvoiceTotal :=  False;

  TxtFlag := IniFile.ReadString('EcoTax', 'ShowMOBTaxFreeArt', '');
  if Trim (TxtFlag) <> '' then
    FlgShowMOBTaxFreeArt :=  StrToBool(TxtFlag, 'T')
  else
    FlgShowMOBTaxFreeArt :=  False;
    //R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-SRM.End :::

end;  // of TFrmVWPosJournalCA.ReadParams

//=============================================================================

procedure TFrmVWPosJournalCA.SetResourceStringsDocs;
begin // of TFrmVWPosJournalCA.SetResourceStringsDocs
  ViArrTxtShortDescrDoc[CtCodDocBV] := CtDocBV;
  ViArrTxtShortDescrDoc[CtCodDocBC] := CtDocBC;
  ViArrTxtShortDescrDoc[CtCodDocLOC] := CtDocLOC;
  ViArrTxtShortDescrDoc[CtCodDocSAV] := CtDocSAV;
end;  // of TFrmVWPosJournalCA.SetResourceStringsDocs

//=============================================================================

procedure TFrmVWPosJournalCA.ShowCurrentTicket;
begin  // of TFrmVWPosJournalCA.ShowCurrentTicket
  // Initializations before creating ticket
  if CodVisActCurrent = CtCodVisActDisplay then
    RchEdtTicket.Clear;
  QtyLines := 0;
  FlgReturnTicket := False;
  FlgReturnBoDoc := False;
  
  // Creating ticket
  try
    AddTicketHeader;
    if not FlgChargeWithdrawSavingCard then
      AddTicketLines;
  finally
    // Even when a problem occurs during show of ticket, always show footer,
    // since this is the only way to find out which ticket caused the problem.
    AddTicketFooter;
    if CodVisActCurrent = CtCodVisActDisplay then begin
      PnlShadow.Height := QtyLines * 16;
      RchEdtTicket.Height := QtyLines * 16;
      RchEdtTicket.Repaint;
      LblCurTicketNumber.Caption := IntToStr (IdtPosTransaction);
    end;
  end;
end;  // of TFrmVWPosJournalCA.ShowCurrentTicket

//=============================================================================
// TFrmVWPosJournalCA - Event handlers
//=============================================================================

procedure TFrmVWPosJournalCA.FormCreate(Sender: TObject);
begin  // of TFrmVWPosJournalCA.FormCreate
  inherited;
  StrLstObjTicket := TStringList.Create;
  FrmVWPosJournal := Self;
  LblTicketNumber.Font.Charset := DEFAULT_CHARSET;
  //Ophalen max. aantal dagen om een factuur te creeren
  try
    DmdFpnUtils.QryInfo.SQL.Clear;
    if DmdFpnUtils.QueryInfo
        ('Select ValParam from ApplicParam ' +
         'Where IdtApplicParam = ' +
          AnsiQuotedStr(CtTxtNumDaysInv, '''')) then begin
      NumDaysCreateInv := DmdFpnUtils.qryInfo.FieldByName('ValParam').AsInteger;
    end
    else begin
      NumDaysCreateInv := 0;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
  ReadParams;
end;   // of TFrmVWPosJournalCA.FormCreate

//=============================================================================

procedure TFrmVWPosJournalCA.ActInvExecute(Sender: TObject);
var
  IdtInvoice       : Integer;       // Filled with invoice or creditnote number
  IdtOrigInvoice   : Integer;       // Filled with original invoice number
  ValTempTotal     : Currency;      // Temporarily total
  CodAct           : Integer;       // CodAction of detailline
  flgColumnExist   : Boolean;
  txtProvince      : String;
  TxtStrProvince   : String;
  TxtProvinceUpd   : string;            //Internal Defect Fix-MeD
  TxtInvoiceField  : String;
  TxtIdtDepartment : String;
  CodInvoice       : integer;
  FlgSucceeded     : Boolean;
  CntTrans         : Integer;
  ticket           : TObjTicket;
  FlgNullInvoice   : Boolean;       // Flg to indicate changing customer data
                                    // for invoice with customer 0
  txttickets       : string;        // string to hold ticketnumbers of multiinvoice
  multicodefound   : Boolean;       // boolean to give error if multivatcodes found
  QryHlp           : TQuery;        // hulpquery for determining multi vat
  TxtName          : String;         // R2013.2.Enhancement 315.JD-Start
  TempTxtNameCustomer   :string;
  TempTxtNameMunicip    :String;
  NumCard          : String;
  TxtMunicip       : String;          // R2013.2.Enhancement 315.JD-End
  //R2014.1.HOTFIX(19631).BDFR.Staff-Discount.TCS-AJ.Start
  TempTickNum      : string;
  TempCashDesk      : string;
  TempCodTrans      : string;
  TempDatTick      : TDateTime;
  //R2014.1.HOTFIX(19631).BDFR.Staff-Discount.TCS-AJ.End
begin  // of TFrmVWPosJournalCA.ActInvExecute
  inherited;
  ReadParams;
  //R2014.1.HOTFIX(19631).BDFR.Staff-Discount.TCS-AJ.Start
  if ViFlgBDFR then begin
    TempTickNum := DstLstTrans.FieldByName('IdtPosTransaction').AsString;
    TempCashDesk := DstLstTrans.FieldByName('IdtCheckout').AsString;
    TempCodTrans := DstLstTrans.FieldByName('CodTrans').AsString;
    try
      DmdFpnUtils.QueryInfo(
            'SELECT TxtDescr ' +
            'from PosTransDetail ' +
            'where IdtPosTransaction = ' + TempTickNum +
            ' and IdtCheckout = ' + TempCashDesk +
            ' and CodTrans = ' + TempCodTrans +
            ' and CodType = ' + InttoStr(CtCodPdtCommentAmountDiscPers) +
            ' and DatTransBegin = ' + AnsiQuotedStr (FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
            DstLstTrans.FieldByName('DatTransBegin').AsDateTime), ''''));
        if DmdFpnUtils.QryInfo.RecordCount > 0 then
          FlgEmplCard := True;
    finally
      DmdFpnUtils.QryInfo.SQL.Clear;
      DmdFpnUtils.CloseInfo;
    end;
  end;
  //R2014.1.HOTFIX(19631).BDFR.Staff-Discount.TCS-AJ.End
   // R2013.2.Enhancement 315.JD-Start
   Flgblnkcust :=false;               // //R2013.2-Enhancement 315- JD
   TxtName := '';
   Numcard := '';
   TxtMunicip:= '';
   TempTxtNameCustomer:= '';
   TempTxtNameMunicip:='' ;
   TxtName   := DstLstTrans.FieldByName ('TxtNameCustomer').AsString;
   Numcard :=   DstLstTrans.FieldByName ('Numcard').AsString;
   TxtMunicip := DstLstTrans.FieldByName ('TxtMunicip').AsString;
   TempTxtNameCustomer :=DstLstTrans.FieldByName ('TxtNameCustomer').AsString;
   TempTxtNameMunicip := DstLstTrans.FieldByName ('TxtNameMunicip').AsString;
   // R2013.2.Enhancement 315.JD-End
  if Sender = ActInvReprint then begin
    try
      DmdFpnUtils.QueryInfo(
            'SELECT IdtPosTransaction,IdtCheckout,CodTrans,DatTransBegin ' +
            'from PosTransInvoice ' +
            'where IdtInvoice = ' + IntToStr(DstLstTrans.
            FieldByName('IdtInvoice').AsInteger));
      StrLstObjTicket.Clear;
      if DmdFpnUtils.QryInfo.RecordCount > 0 then begin
        DmdFpnUtils.QryInfo.First;
        repeat
          StrLstObjTicket.AddObject(' ',
              TObjTicket.Create(DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsInteger,
              DmdFpnUtils.QryInfo.FieldByName('IdtCheckout').AsInteger,
              DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger,
              DmdFpnUtils.QryInfo.FieldByName('DatTransBegin').AsDateTime));
          DmdFpnUtils.QryInfo.Next;
        until DmdFpnUtils.QryInfo.Eof;
      end;
    finally
      DmdFpnUtils.QryInfo.SQL.Clear;
      DmdFpnUtils.CloseInfo;
    end;
  end;
  IdtDepartment := 0;
  if FlgMultDepartment then begin
    if not(sender = ActInvReprint) then begin
      TxtIdtDepartment := DmdFpnWorkStatCA.InfoCheckout[
              DstLstTrans.FieldByName ('IdtCheckout').AsInteger, 'IdtDepartment'];
      TxtInvoiceField := CtTxtACInvoiceField + TxtIdtDepartment;
    end
    else begin
      try
        if DmdFpnUtils.QueryInfo(
            'SELECT CodInvoice from PosTransInvoice ' +
            'where IdtInvoice = ' + IntToStr(DstLstTrans.
                                        FieldByName ('IdtInvoice').AsInteger) +
            ' and DatTransBegin =' +
            AnsiQuotedStr (FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
            DstLstTrans.FieldByName('DatTransBegin').AsDateTime), '''')) then begin
          CodInvoice := DmdFpnUtils.QryInfo.FieldByName('CodInvoice').AsInteger;
        end
        else begin
          CodInvoice := 0;
        end;
      finally
        DmdFpnUtils.CloseInfo;
      end;
      if CodInvoice = CtCodInvOnSrvManual then begin
        FlgSucceeded := SvcTaskMgr.LaunchTask ('AskDepartment');
        if (IdtDepartment <> 0) and FlgSucceeded then
          TxtIdtDepartment := IntToStr(IdtDepartment)
        else
          Exit;

        TxtInvoiceField := CtTxtACInvoiceField + TxtIdtDepartment;
      end
      else begin
        TxtIdtDepartment := DmdFpnWorkStatCA.InfoCheckout[
            DstLstTrans.FieldByName ('IdtCheckout').AsInteger, 'IdtDepartment'];
        TxtInvoiceField := CtTxtACInvoiceField + TxtIdtDepartment;
      end;
    end;
  end
  else
    TxtInvoiceField := CtTxtACInvoiceField;
  IdtOrigInvoice := 0;
  if not Assigned (DmdFpnInvoice) then
    DmdFpnInvoice := TDmdFpnInvoice.Create (Self);
  if not Assigned (FrmVSRptInvoiceCA) then
    FrmVSRptInvoiceCA := TFrmVSRptInvoiceCA.Create (Self);
  FrmVSRptInvoiceCA.FlgFiscal := FlgFiscal;
  FrmVSRptInvoiceCA.FlgItaly := FlgItaly;
  FrmVSRptInvoiceCA.FlgRussia := FlgRussia;
  if FlgMultDepartment then
    FrmVSRptInvoiceCA.IdtDepartment := StrToInt(TxtIdtDepartment)
  else
    FrmVSRptInvoiceCA.IdtDepartment := 0;

  // check added on multiInvoice to avoid different %Vat with same idtVatCode
  if FlgMultiRecInv then begin
    txttickets := '';
    multicodefound := False;
    try
      DmdFpnUtils.QueryInfo(
              'select idtvatCode' +
              ' from vatcode  ');
      if DmdFpnUtils.QryInfo.RecordCount > 0 then begin
        DmdFpnUtils.QryInfo.First;
        repeat
          if StrLstObjTicket.Count > 0 then begin
            for CntTrans := 0 to StrLstObjTicket.Count-1 do begin
               ticket := TObjticket(FrmVWPosJournalCA.StrLstObjTicket.Objects[CntTrans]);
               if CntTrans = 0 then
                 txttickets := '(( idtpostransaction = ' + inttostr(ticket.idtpostransaction) +
                               ' and idtcheckout = ' + inttostr(ticket.IdtCheckout) +
                               ' and dattransbegin = ' + AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat + ' ' +
                                ViTxtDBHouFormat, ticket.DatTransBegin), '''') +
                                ' and codtrans = ' + inttostr(ticket.CodTrans) + ')'
               else
                 txttickets := txttickets + ' OR ( idtpostransaction = ' + inttostr(ticket.idtpostransaction) +
                               ' and idtcheckout = ' + inttostr(ticket.IdtCheckout) +
                               ' and dattransbegin = ' + AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat + ' ' +
                                ViTxtDBHouFormat, ticket.DatTransBegin), '''') +
                                ' and codtrans = ' + inttostr(ticket.CodTrans) + ')';
            end;
            txttickets := txttickets + ')';
            QryHlp := TQuery.Create(self);
            try
              QryHlp.DatabaseName := 'DBFlexPoint';
              QryHlp.Active := False;
              QryHlp.SQL.Clear;
              QryHlp.SQL.Add(
                 'SELECT distinct idtvatCode,PctVat ' +
                 'from Postransdetail ' +
                 'where ' +  txttickets + ' ' +
                 'AND (idtvatcode = ' +
                 DmdFpnUtils.QryInfo.FieldByName('idtvatCode').AsString  + ')');
              QryHlp.Active := True;
              if QryHlp.RecordCount > 1 then
                 multicodefound := True
            finally
             QryHlp.Active := False;
             QryHlp.Free;
            end;
          end;
          DmdFpnUtils.QryInfo.Next;
        until DmdFpnUtils.QryInfo.Eof;
        if multicodefound then begin
          showmessage (CtTxtMultiVAT);
          exit;
        end;
      end;
    finally
      DmdFpnUtils.CloseInfo;
    end;
  end;

  if StrLstObjTicket.Count > 0 then begin
    for CntTrans := 0 to StrLstObjTicket.Count-1 do begin
      ticket := TObjticket(FrmVWPosJournalCA.StrLstObjTicket.Objects[CntTrans]);
      FrmVSRptInvoiceCA.AddIdts(ticket.IdtPosTransaction,
                                ticket.IdtCheckout,
                                ticket.CodTrans,
                                ticket.DatTransBegin);
    end;
  end
  else begin
    FrmVSRptInvoiceCA.AddIdts(DstLstTrans.FieldByName('IdtPosTransaction').AsInteger,
      DstLstTrans.FieldByName('IdtCheckout').AsInteger,
      DstLstTrans.FieldByName('CodTrans').AsInteger,
      DstLstTrans.FieldByName('DatTransBegin').AsDateTime);
  end;


  FrmVSRptInvoiceCA.CodKind := CodKindInvoice;
  FrmVSRptInvoiceCA.FlgDuplicate := Sender = ActInvReprint;
  FlgNullInvoice := False;
  if not FrmVSRptInvoiceCA.FlgDuplicate then begin
    ValTempTotal := 0;
    DstDetTrans.First;
    while not DstDetTrans.EOF do begin
      CodAct := DstDetTrans.FieldByName('CodAction').AsInteger;
      if CodAct = CtCodActTotal then
        ValTempTotal := DstDetTrans.FieldByName('ValInclVat').AsCurrency;
      DstDetTrans.Next;
    end;
    if (DstLstTrans.FieldByName('IdtCustomer').IsNull) or
      (DstLstTrans.FieldByName('IdtCustomer').AsString = '') or
      (Sender <> ActInvReprint) then begin
      SvcTaskMgr.LaunchTask('ListCustomer');
      if (IdtCustomer = -1) or (IdtCustomer = 0) then begin
        DmdFpnInvoice.StrLstIdtLst.Clear;
        Exit;
      end
      else begin
        // ask original invoice number if credit note
        if (ValTempTotal < 0) and FlgItaly then begin
          IdtOrigInvoice := AskOrigInvoice;
          if IdtOrigInvoice = 0 then begin
            DmdFpnInvoice.StrLstIdtLst.Clear;
            exit;
          end;
        end;
        if (ValTempTotal < 0) and FlgSeperateCNNumber then begin
          IdtInvoice := DmdFpnUtils.GetNextCounter (CtTxtACCredNoteIdtAC,
                                                    CtTxtACCredNoteField);
          if IdtInvoice < 1000000 then begin
            IdtInvoice := 1000000;
            DmdFpnUtils.CloseInfo;
            DmdFpnUtils.ClearQryInfo;
            with DmdFpnUtils.QryInfo.SQL do begin
              Add ('UPDATE ApplicCounter');
              Add ('  SET');
              Add ('    NumCounter = ' + IntToStr(1000000));
              Add ('  WHERE IdtApplicCounter = ' +
                                 AnsiQuotedStr (CtTxtACCredNoteIdtAC, ''''));
            end;
            DmdFpnUtils.ExecQryInfo;
            DmdFpnUtils.CloseInfo;
            DmdFpnUtils.ClearQryInfo;
          end;
        end
        else
          IdtInvoice := DmdFpnUtils.GetNextCounter (CtTxtACInvoiceIdtAC,
                                                    TxtInvoiceField);
      end;
      if StrLstObjTicket.Count > 0 then begin
        for CntTrans := 0 to StrLstObjTicket.Count-1 do begin
          ticket := TObjticket(FrmVWPosJournalCA.StrLstObjTicket.Objects[CntTrans]);
          DmdFpnInvoiceCA.SetInvoice(ticket.IdtPosTransaction,
                                    ticket.IdtCheckout,
                                    ticket.CodTrans,
                                    ticket.DatTransBegin,
                                    IdtInvoice,
                                    Now,
                                    IdtCustomer,
                                    IdtOrigInvoice,
                                    CtCodInvOnSrvFromTick,
                                    CodCreator);
        end
      end
      else begin
        DmdFpnInvoiceCA.SetInvoice(DstLstTrans.FieldByName('IdtPosTransaction').AsInteger,
                      DstLstTrans.FieldByName('IdtCheckout').AsInteger,
                      DstLstTrans.FieldByName('CodTrans').AsInteger,
                      DstLstTrans.FieldByName('DatTransBegin').AsDateTime,
                      IdtInvoice,
                      Now,
                      IdtCustomer,
                      IdtOrigInvoice,
                      CtCodInvOnSrvFromTick,
                      CodCreator);
      end;
    end
    else begin
      if (ValTempTotal < 0) and FlgItaly then begin
        IdtOrigInvoice := AskOrigInvoice;
          if IdtOrigInvoice = 0 then begin
            DmdFpnInvoice.StrLstIdtLst.Clear;
            exit;
          end;
        end;
      IdtInvoice := DmdFpnUtils.GetNextCounter (CtTxtACInvoiceIdtAC,
                                                    TxtInvoiceField);
      DmdFpnInvoiceCA.SetInvoice (DstLstTrans.FieldByName ('IdtPosTransaction').AsInteger,
                                DstLstTrans.FieldByName ('IdtCheckout').AsInteger,
                                DstLstTrans.FieldByName ('CodTrans').AsInteger,
                                DstLstTrans.FieldByName ('DatTransBegin').AsDateTime,
                                IdtInvoice,
                                Now,
                                DstLstTrans.FieldByName ('IdtCustomer').AsInteger,
                                IdtOrigInvoice,
                                CtCodInvOnSrvFromTick,
                                DstLstTrans.FieldByName ('CodCreator').AsInteger
                                );
      IdtCustomer := DstLstTrans.FieldByName ('IdtCustomer').AsInteger;
      CodCreator := DstLstTrans.FieldByName ('CodCreator').AsInteger;
    end;
  end
  else
   // R2013.2.Enhancement 315.JD-start
    if Numcard <>'' then begin
     TxtName :=TempTxtNameCustomer ;
     TxtMunicip:=TempTxtNameMunicip ;
     end;
    if {DstLstTrans.FieldByName ('IdtCustInvoice').IsNull or }                    //R2013.2-Enhancement 315- JD.Start
    ((DstLstTrans.FieldByName ('IdtCustInvoice').AsString = '0') and
     ((TxtName  ='')
     or (TxtMunicip  =''))) then
     Flgblnkcust := true      ;                                                  ////R2013.2-Enhancement 315- JD.End
   // R2013.2.Enhancement 315.JD-end
    if {DstLstTrans.FieldByName ('IdtCustInvoice').IsNull or }
    ((DstLstTrans.FieldByName ('IdtCustInvoice').AsString = '0') and
     ((TxtName  ='')
     or (TxtMunicip  ='')))                                                       // R2013.2.Enhancement 315.JD
   { (not ViFlgAllowZeroCustNo))} then begin                                      //last clause added for R2013.2.Req(25020).BRFR-CAFR.Entering Customer Info.TCS-SC
      SvcTaskMgr.LaunchTask ('ListCustomer');
      if (IdtCustomer = -1) or (IdtCustomer = 0) then
      //R2013.2.Applix3129277.Mixture of invoice for blank customer.TCS-SC.Start
      begin
        DmdFpnInvoice.StrLstIdtLst.clear;
      //R2013.2.Applix3129277.Mixture of invoice for blank customer.TCS-SC.End
        Exit;
      end;                                                                      //R2013.2.Applix3129277.Mixture of invoice for blank customer.TCS-SC.Start  
      FlgNullInvoice := True;
      DmdFpnInvoiceCA.SetInvoice (DstLstTrans.FieldByName ('IdtPosTransaction').AsInteger,
                                DstLstTrans.FieldByName ('IdtCheckout').AsInteger,
                                DstLstTrans.FieldByName ('CodTrans').AsInteger,
                                DstLstTrans.FieldByName ('DatTransBegin').AsDateTime,
                                DstLstTrans.FieldByName ('IdtInvoice').AsInteger,
                                Now,
                                IdtCustomer,
                                IdtOrigInvoice,
                                CtCodInvOnSrvFromTick,
                                CodCreator);
  end;
  try

      flgColumnExist := DmdFpnUtils.FieldExists('Customer', 'TxtProvince');
      txtProvince := '';
      if flgColumnExist then
        txtProvince := ', TxtProvince = C.TxtProvince ';

      if (IdtCustomer = -1) or (IdtCustomer = 0) then begin
        Idtcustomer := DstLstTrans.FieldByName ('IdtCustomer').AsInteger;
        CodCreator := DstLstTrans.FieldByName ('CodCreator').AsInteger;
      end;
      if (not FrmVSRptInvoiceCA.FlgDuplicate) or (FlgNullInvoice) then begin
        if StrLstObjTicket.Count > 0 then begin
          for CntTrans := 0 to StrLstObjTicket.Count-1 do begin
            DmdFpnUtils.QryInfo.SQL.Clear;
            DmdFpnUtils.QueryInfo (#10'SELECT TxtName = C.TxtPublName, ' +
            #10'       TxtStreet = A.TxtStreet, CodApplic = A.CodApplic, TxtCodPost = M.TxtCodPost, ' +    //R2014.1.Req(45010).BRFR.Improved-Invoice-Address-For-Duplication.TCS-Med
            #10'       TxtMunicip= M.TxtName, CodCountry = Co.TxtCodCountry, ' +
            #10'       TxtCountry = Co.TxtName, TxtNumVat = C.TxtNumVAT, ' +
            #10'       PctDiscount = C.PctDiscount ' + txtProvince + ', C.CodCreator' +
            #10'FROM Customer C' +
            #10'  INNER JOIN Address A' +
            #10'  ON A.IdtCustomer = C.IdtCustomer' +
            #10'  AND A.CodCreator = C.CodCreator' +
            #10'  INNER JOIN Municipality M' +
            #10'  ON M.IdtMunicipality = A.IdtMunicipality' +
            #10'  INNER JOIN Country Co' +
            #10'  ON Co.IdtCountry = M.IdtCountry' +
            #10'WHERE C.IdtCustomer = ' + AnsiQuotedStr(IntToStr(IdtCustomer), '''') +
            #10' AND C.CodCreator = ' + AnsiQuotedStr(IntToStr(CodCreator), ''''));
            TxtStrProvince := '';
            if flgColumnExist then
              TxtStrProvince := DmdFpnUtils.QryInfo.FieldByName ('TxtProvince').AsString;
            ticket := TObjticket(FrmVWPosJournalCA.StrLstObjTicket.Objects[CntTrans]);
            DmdFpnInvoiceCA.SetCustTrans (ticket.IdtPosTransaction,
                          ticket.IdtCheckout,
                          ticket.CodTrans,
                          ticket.DatTransBegin,
                          IdtCustomer,
                          CodCreator,
                          DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString,
                          DmdFpnUtils.QryInfo.FieldByName ('TxtStreet').AsString,
                          DmdFpnUtils.QryInfo.FieldByName ('TxtCodPost').AsString,
                          DmdFpnUtils.QryInfo.FieldByName ('TxtMunicip').AsString,
                          DmdFpnUtils.QryInfo.FieldByName ('CodCountry').AsString,
                          DmdFpnUtils.QryInfo.FieldByName ('TxtCountry').AsString,
                          DmdFpnUtils.QryInfo.FieldByName ('TxtNumVat').AsString,
                          DmdFpnUtils.QryInfo.FieldByName ('PctDiscount').AsInteger,
                          TxtStrProvince);
          end;
        end
        else begin
          DmdFpnUtils.QryInfo.SQL.Clear;
          DmdFpnUtils.QueryInfo (#10'SELECT TxtName = C.TxtPublName, ' +
          #10'       TxtStreet = A.TxtStreet, CodApplic = A.CodApplic, TxtCodPost = M.TxtCodPost, ' +    //R2014.1.Req(45010).BRFR.Improved-Invoice-Address-For-Duplication.TCS-Med
          #10'       TxtMunicip= M.TxtName, CodCountry = Co.TxtCodCountry, ' +
          #10'       TxtCountry = Co.TxtName, TxtNumVat = C.TxtNumVAT, ' +
          #10'       PctDiscount = C.PctDiscount ' + txtProvince + ', C.CodCreator' +
          #10'FROM Customer C' +
          #10'  INNER JOIN Address A' +
          #10'  ON A.IdtCustomer = C.IdtCustomer' +
          #10'  AND A.CodCreator = C.CodCreator' +
          #10'  INNER JOIN Municipality M' +
          #10'  ON M.IdtMunicipality = A.IdtMunicipality' +
          #10'  INNER JOIN Country Co' +
          #10'  ON Co.IdtCountry = M.IdtCountry' +
          #10'WHERE C.IdtCustomer = ' + AnsiQuotedStr(IntToStr(IdtCustomer), '''') +
          #10' AND C.CodCreator = ' + AnsiQuotedStr(IntToStr(CodCreator), ''''));
          TxtStrProvince := '';
          if flgColumnExist then
            TxtStrProvince := DmdFpnUtils.QryInfo.FieldByName ('TxtProvince').AsString;

          DmdFpnInvoiceCA.SetCustTrans (DstLstTrans.FieldByName ('IdtPosTransaction').AsInteger,
                        DstLstTrans.FieldByName ('IdtCheckout').AsInteger,
                        DstLstTrans.FieldByName ('CodTrans').AsInteger,
                        DstLstTrans.FieldByName ('DatTransBegin').AsDateTime,
                        IdtCustomer,
                        CodCreator,
                        DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString,
                        DmdFpnUtils.QryInfo.FieldByName ('TxtStreet').AsString,
                        DmdFpnUtils.QryInfo.FieldByName ('TxtCodPost').AsString,
                        DmdFpnUtils.QryInfo.FieldByName ('TxtMunicip').AsString,
                        DmdFpnUtils.QryInfo.FieldByName ('CodCountry').AsString,
                        DmdFpnUtils.QryInfo.FieldByName ('TxtCountry').AsString,
                        DmdFpnUtils.QryInfo.FieldByName ('TxtNumVat').AsString,
                        DmdFpnUtils.QryInfo.FieldByName ('PctDiscount').AsInteger,
                        TxtStrProvince);
        end;
     end;
  finally
    DmdFpnUtils.QryInfo.SQL.Clear;
    DmdFpnUtils.QryInfo.Close;
  end;
  FrmVSRptInvoiceCA.ShowInvoices;
  FrmVSRptInvoiceCA.Show;
  if (Sender = ActInvCreate) or (FlgNullInvoice) then begin
    // Reload the headers of the tickets
    Init;
    if QtyTickets <> 0 then
      ShowCurrentTicket;
  end;
  StrLstObjTicket.Clear;
  IdtCustomer := 0;
  CodCreator := 0;
  DstLstTransAfterScroll(DstLstTrans);
end;   // of TFrmVWPosJournalCA.ActInvExecute

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskLstCustomerCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmVWPosJournalCA.SvcTskLstCustomerCreateExecutor
  inherited;
  NewObject := TFrmList.Create (Self);
  if FlgCustFunc then
    TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel, CtCodJobRecCons, CtCodJobRecNew]
  else
    TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel];
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmVWPosJournalCA.SvcTskLstCustomerCreateExecutor

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskLstCustomerAfterExecute(
  Sender: TObject);
var
  TxtCustomer      : string;           // Customer Text
  TxtCodCreator    : string;
  TxtCustName      : string;
begin  // of TFrmVWPosJournalCA.SvcTskLstCustomerAfterExecute
  inherited;
  //R2012.1 Defect Fix 299(SM) ::START
  try
   TxtCustomer :=  TFrmList (SvcTaskMgr.ActiveTask.Executor).StrLstIdtValues.
                                                         Values ['IdtCustomer'];
   TxtCodCreator  :=  TFrmList (SvcTaskMgr.ActiveTask.Executor).
                                        StrLstIdtValues.Values ['CodCreator'];
   DmdFpnUtils.QryInfo.SQL.Clear;
   DmdFpnUtils.QueryInfo (#10' SELECT Address.TxtName '+
                          #10' FROM Customer'+
                          #10' LEFT OUTER JOIN Address'+
                          #10' ON Customer.IdtCustomer = Address.IdtCustomer AND'+
                          #10' Customer.CodCreator = Address.CodCreator'+
                          #10' Where Customer.IdtCustomer = '  + TxtCustomer +
                          #10' AND Customer.CodCreator = '  + TxtCodCreator +
                          #10' AND Address.CodApplic=1');
   ViTxtCustomerName := DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString;
  finally
   DmdFpnUtils.QryInfo.SQL.Clear;
   DmdFpnUtils.QryInfo.Close;
  end;
  //R2012.1 Defect Fix 299(SM) ::END
  TxtCustomer := TFrmList (SvcTaskMgr.ActiveTask.Executor).StrLstIdtValues.
                                                         Values ['IdtCustomer'];
  TxtCodCreator := TFrmList (SvcTaskMgr.ActiveTask.Executor).
                                        StrLstIdtValues.Values ['CodCreator'];
  if TxtCustomer <> '' then begin
    IdtCustomer := StrToInt (TxtCustomer);
    CodCreator := StrToInt (TxtCodCreator);
  end
  else begin
    IdtCustomer := -1;
    CodCreator := 0;
  end;

  if IdtCustomer <> -1 then begin
    try
      TxtCustName := DmdFpnCustomerCA.InfoCustomer[IdtCustomer,CodCreator,
                                                   'TxtPublName'];
      if MessageDlg (Format (CtTxtSureSelectCust, [ViTxtCustomerName,                        //R2012.1 Defect Fix 299(SM)
                                                   IntToStr(IdtCustomer)]),
                     mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
        IdtCustomer := -1;
        CodCreator := 0;
      end;
    except
      Exit;
    end;
  end;
end;   // of TFrmVWPosJournalCA.SvcTskLstCustomerAfterExecute

//=============================================================================
//TFrmVWPosJournalCA.AskOrigInvoice: Ask for the original invoicenumber
//=============================================================================
function TFrmVWPosJournalCA.AskOrigInvoice: Integer;
begin  // of TFrmVWPosJournalCA.AskOrigInvoice
  FrmInputInvOrigCA := TFrmInputInvOrigCA.Create(Application);
  try
    if FrmInputInvOrigCA.ShowModal = mrOk then begin
      Result := FrmInputInvOrigCA.IdtInvoice;
    end
    else begin
      Result := 0;
    end;
  finally
    FrmInputInvOrigCA.Free;
    FrmInputInvOrigCA := nil;
  end;
end;   // of TFrmVWPosJournalCA.AskOrigInvoice

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskDetCustomerCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmVWPosJournalCA.SvcTskDetCustomerCreateExecutor
  NewObject := TFrmDetCustomerCA.Create (Self);
  TFrmDetCustomerCA(NewObject).FlgVatRequired := FlgFiscal;
  TFrmDetCustomerCA(NewObject).FlgDisableBonPassage := FlgDisableBonPassage;

  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmVWPosJournalCA.SvcTskDetCustomerCreateExecutor

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskDetDepartmentAfterExecute(Sender: TObject);
begin  // of TFrmVWPosJournalCA.SvcTskDetDepartmentAfterExecute
  inherited;
  IdtDepartment := TFrmDlgAskDepartment (SvcTaskMgr.ActiveTask.Executor).
                                                                  IdtDepartment;
end;   // of TFrmVWPosJournalCA.SvcTskDetDepartmentAfterExecute

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskDetDepartmentCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmVWPosJournalCA.SvcTskDetDepartmentCreateExecutor
  NewObject := TFrmDlgAskDepartment.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmVWPosJournalCA.SvcTskDetDepartmentCreateExecutor

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskDetManInvoiceCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmVWPosJournalCA.SvcTskDetManInvoiceCreateExecutor
  inherited;
  NewObject := TFrmDetManInvoiceCA.Create (Self);
  TFrmDetManInvoiceCA(NewObject).FlgFiscal := FlgFiscal;
  TFrmDetManInvoiceCA(NewObject).FlgItaly := FlgItaly;
  TFrmDetManInvoiceCA(NewObject).FlgRussia := FlgRussia;
  TFrmDetManInvoiceCA(NewObject).FlgPosJournal := True;
  TFrmDetManInvoiceCA(NewObject).IdtCustomer := IdtCustomer;
  TFrmDetManInvoiceCA(NewObject).CodCreator := CodCreator;
  TFrmDetManInvoiceCA(NewObject).IdtOrigInvoice := IdtOrigInvoice;
  TFrmDetManInvoiceCA(NewObject).IdtPOSTransaction :=
                       DstLstTrans.FieldByName('IdtPosTransaction').AsInteger;
  TFrmDetManInvoiceCA(NewObject).IdtCheckOut :=
                       DstLstTrans.FieldByName('IdtCheckout').AsInteger;
  TFrmDetManInvoiceCA(NewObject).CodTrans :=
                       DstLstTrans.FieldByName('CodTrans').AsInteger;
  TFrmDetManInvoiceCA(NewObject).DatTransBegin :=
                       DstLstTrans.FieldByName('DatTransBegin').AsDateTime;
  TFrmDetManInvoiceCA(NewObject).FlgFiscalInfo :=
                       DstLstTrans.FieldByName('NumFiscalTicket').AsInteger>0;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmVWPosJournalCA.SvcTskDetManInvoiceCreateExecutor

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskDetManInvoiceArticleCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmVWPosJournalCA.SvcTskDetManInvoiceArticleCreateExecutor
  inherited;
  NewObject := TFrmDetManInvoiceArticleCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmVWPosJournalCA.SvcTskDetManInvoiceArticleCreateExecutor

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskDetManInvoiceCommentCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmVWPosJournalCA.SvcTskDetManInvoiceCommentCreateExecutor
  inherited;
  NewObject := TFrmDetManInvoiceCommentCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmVWPosJournalCA.SvcTskDetManInvoiceCommentCreateExecutor

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskDetManInvoicePaymentsCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmVWPosJournalCA.SvcTskDetManInvoicePaymentsCreateExecutor
  inherited;
  NewObject := TFrmDetManInvoicePaymentCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmVWPosJournalCA.SvcTskDetManInvoicePaymentsCreateExecutor

//=============================================================================

procedure TFrmVWPosJournalCA.ActInvCreateManualExecute(Sender: TObject);
var
  ValTempTotal     : Currency;      // Temporarily total
  CodAct           : Integer;       // CodAction of detailline
begin  // of TFrmVWPosJournalCA.ActInvCreateManualExecute
  inherited;
  ReadParams;
  if (DstLstTrans.FieldByName ('IdtCustomer').IsNull) or
             (DstLstTrans.FieldByName ('IdtCustomer').AsString = '') then begin
    IdtCustomer := -1;
    SvcTaskMgr.LaunchTask ('ListCustomer');
    if (IdtCustomer = -1) or (IdtCustomer = 0) then
      Exit;
  end
  else begin
    IdtCustomer := DstLstTrans.FieldByName ('IdtCustomer').AsInteger;
    CodCreator := DstLstTrans.FieldByName ('CodCreator').AsInteger
  end;
  // ask original invoice number if credit note
  ValTempTotal := 0;
  DstDetTrans.First;
  while not DstDetTrans.EOF do begin
    CodAct   := DstDetTrans.FieldByName ('CodAction').AsInteger;
    if CodAct = CtCodActTotal then
      ValTempTotal := DstDetTrans.FieldByName ('ValInclVat').AsCurrency;
    DstDetTrans.Next;
  end;
  if (ValTempTotal < 0) and FlgItaly then begin
    IdtOrigInvoice := AskOrigInvoice;
    if IdtOrigInvoice = 0 then begin
      exit;
    end;
  end;
  SvcTaskMgr.LaunchTask ('DetManInvoice');
end;   // of TFrmVWPosJournalCA.ActInvCreateManualExecute

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskLstClassificationCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin
  inherited;
  NewObject  := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel];
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskLstArticleCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmVWPosJournalCA.SvcTskLstArticleCreateExecutor
  inherited;
  NewObject  := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel];
  TFrmList(NewObject).TxtSelectMaster := Application.Title;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmVWPosJournalCA.SvcTskLstArticleCreateExecutor

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskLstClassificationBeforeExecute(
  Sender: TObject; SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
var
  CntItem          : integer;
begin  // of TFrmVWPosJournalCA.SvcTskLstClassificationBeforeExecute
  inherited;
  if not Assigned (SprRTLstClass) then begin
    SprRTLstClass :=
        CopyStoredProc (Self, 'SprRTLstClass',
                        DmdFpnClassification.SprLstClassification, ['']);
    SprRTLstClass.ParamByName ('@PrmTxtCondition').AsString :=
        'CodType = ' + IntToStr (CtCodClassTypeTurnOver);
    for CntItem := 0 to Pred (SvcTskLstClassification.Sequences.Count) do
      SvcTskLstClassification.Sequences.Items[CntItem].DataSet :=
        SprRTLstClass;
  end;
end;   // of TFrmVWPosJournalCA.SvcTskLstClassificationBeforeExecute

//=============================================================================

procedure TFrmVWPosJournalCA.SvcTskLstCreate(Sender: TObject);
begin  // of TFrmVWPosJournalCA.SvcTskLstCreate
  inherited;
  TSvcCustomTask(Sender).RegKey := '\' + SrStnCom.CtTxtSycRegRoot +
                                   '\' + RFpnCom.CtTxtCompanyFpn +
                                   '\' + RFpnCom.CtTxtNameFpn +
                                   '\' + CtTxtVersionFpn +
                                   '\' + TSvcCustomTask(Sender).TaskName;
end;   // of TFrmVWPosJournalCA.SvcTskLstCreate

//=============================================================================

procedure TFrmVWPosJournalCA.AddCancelTicketInfo;
var
  TxtLine          : string;
begin
  AddLineToTicket ('', FntHeader);
  AddLineToTicket (CharStrW (' ', 3) + CtTxtCancellTicket, FntHeader);
  AddLineToTicket ('', FntHeader);
  try
    DmdFpnUtils.QueryInfo
      ('Select * from POSTransaction where ' +
         'IdtPosTransResume = ' +
            IntToStr(DstLstTrans.FieldByName('IdtPOSTransaction').AsInteger) +
         ' and IdtCheckoutResume = ' +
            IntToStr(DstLstTrans.FieldByName('IdtCheckout').AsInteger) +
         ' and DatTransBeginResume = ' +
            AnsiQuotedStr (
                  FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                  DstLstTrans.FieldByName('DatTransBegin').AsDateTime), ''''));
    if not (DmdFpnUtils.qryInfo.Eof) then begin
      TxtLine := CharStrW (' ', 3) + CtTxtOrigShopNumber + ' ' +
                                     DmdFpnUtils.IdtTradeMatrixAssort;
      AddLineToTicket(TxtLine, FntHeader);
      TxtLine := CharStrW (' ', 3) + CtTxtOrigTickNumber + ' ' +
        IntToStr(DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsInteger);
      AddLineToTicket(TxtLine, FntHeader);
      TxtLine := CharStrW (' ', 3) + CtTxtOrigDateTicket + ' ' +
        DateTimeToStr(DmdFpnUtils.QryInfo.FieldByName('DatTransBegin').AsDateTime);
      AddLineToTicket(TxtLine, FntHeader);
      TxtLine := CharStrW (' ', 3) + CtTxtOrigIdtCheckout + ' ' +
        IntToStr(DmdFpnUtils.QryInfo.FieldByName('IdtCheckout').AsInteger);
      AddLineToTicket(TxtLine, FntHeader);
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
  TxtLine := CharStrW (' ', 3) + Format(CtTxtCancelledBy,
                    [DstLstTrans.FieldByName ('IdtOperator').AsString,
                     DstLstTrans.FieldByName ('TxtName').AsString]);
  AddLineToTicket(TxtLine, FntHeader);
  //R2011.2 BDES-Traductions(A.M)-Start
 //if (FrmRptCfgPosJournalCA.FlgAuthorised) then begin
 if (FlgAuthorised) then begin
   try
     DmdFpnUtils.QueryInfo
      ('Select * from POSTransApproval where ' +
         'IdtPosTransaction = ' +
            IntToStr(DstLstTrans.FieldByName('IdtPOSTransaction').AsInteger - 1) +
         ' and IdtCheckout = ' +
            IntToStr(DstLstTrans.FieldByName('IdtCheckout').AsInteger) +
         ' and CodAction = ' + IntToStr(CtCodActCancelFinReceipt));
     if not (DmdFpnUtils.qryInfo.Eof) then begin
      if ((DmdFpnUtils.qryInfo.FieldByName ('CodApproval').AsInteger) = 0) then begin
        TxtLine := CharStrW (' ', 3) + Format(CtTxtAuthorized,
                     [DmdFpnUtils.qryInfo.FieldByName ('IdtOperApproval').AsString,
                      DmdFpnUtils.qryInfo.FieldByName ('TxtNameApproval').AsString]);
        AddLineToTicket(TxtLine, FntHeader);
      end;
     end;
   finally
    DmdFpnUtils.CloseInfo;
   end;
 end
 else begin
 //R2011.2 BDES-Traductions(A.M)- End
  try
    DmdFpnUtils.QueryInfo
      ('Select * from POSTransApproval where ' +
         'IdtPosTransaction = ' +
            IntToStr(DstLstTrans.FieldByName('IdtPOSTransaction').AsInteger) +
         ' and IdtCheckout = ' +
            IntToStr(DstLstTrans.FieldByName('IdtCheckout').AsInteger) +
         ' and DatTransBegin = ' +
            AnsiQuotedStr (
                  FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                  DstLstTrans.FieldByName('DatTransBegin').AsDateTime), '''') +
         ' and CodAction = ' + IntToStr(CtCodActCancelFinReceipt));
    if not (DmdFpnUtils.qryInfo.Eof) then begin
      TxtLine := CharStrW (' ', 3) + Format(CtTxtAuthorized,
                    [DstLstTrans.FieldByName ('IdtOperApproval').AsString,
                     DstLstTrans.FieldByName ('TxtNameApproval').AsString]);
      AddLineToTicket(TxtLine, FntHeader);
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end; //R2011.2 BDES-Traductions(A.M)
 end;  
end;

//=============================================================================
// TFrmVWPosJournalCA.AddLineToTicket : Adds the line to the ticket after checking
//    which kind of ticket
//                                  -----
// INPUT  : TxtLine = The text that has to be added to the ticket
//          FntLine = The font in which the texts needs to be displayed
//=============================================================================

procedure TFrmVWPosJournalCA.AddLineToTicket (TxtLine : string;
                                            FntLine : TFont );
begin // of TFrmVWPosJournalCA.AddLineToTicket
  Inc (QtyLines);
  case CodVisActCurrent of
    CtCodVisActDisplay : begin
      RchEdtTicket.SelAttributes.Assign (FntLine);
      try
        RchEdtTicket.Lines.Add (TxtLine);
      except
      end;
    end;  // of CodVisActCurrent = CtCodVisActDisplay

    CtCodVisActPrint : begin
      FrmVSPreview.VspPreview.TableCell[TcRows, null, null,
                                        null, null] := QtyLines;
      FrmVSPreview.VspPreview.TableCell[tcForeColor, QtyLines - 1, 1,
                                        null, null] := FntLine.Color;
      FrmVSPreview.VspPreview.TableCell[tcFontBold, QtyLines - 1, 1,
                                        null, null] :=
                                        Ord (fsBold in FntLine.Style);
      FrmVSPreview.VspPreview.TableCell[tcText, QtyLines - 1, 1,
                                        null, null] := TxtLine;
    end;  // of CodVisActCurrent = CtCodVisActPrint

    CtCodVisActSave : begin
      FTxWrite (TxtFileName, TxSave, TxtLine + #13#10);
    end;  // of CodVisActCurrent = CtCodVisActSave
  end;  // of case CodVisActCurrent of ...
end;  // of TFrmVWPosJournalCA.AddLineToTicket

//=============================================================================

procedure TFrmVWPosJournalCA.LoadIniConfig;
var
  IniFile : TIniFile;
  TxtNumMaskCCStartPos : string;
begin // of TFrmVWPosJournalCA.LoadIniConfig
  if copy(ViTxtFNIniSystemFps,1,pos('\',ViTxtFNIniSystemFps)) = '\' then
     ViTxtFNIniSystemFps := copy(ExtractFilePath (ExtractFileDir (Application.ExeName)),1,2) +
                            ViTxtFNIniSystemFps;
  IniFile := TIniFile.Create (ViTxtFNIniSystemFps);
  ViFlgMaskCCNumber := GetBoolDef (IniFile.ReadString ('MaskCardNumber','Active','False'),
               'T', False);
  TxtNumMaskCCStartPos := IniFile.ReadString ('MaskCardNumber','StartPosition ','?');
  if TxtNumMaskCCStartPos = '?' then
    NumMaskCCStartPos := 0
  else
     NumMaskCCStartPos := StrToInt(TxtNumMaskCCStartPos); 
end; // of TFrmVWPosJournalCA.LoadIniConfig

//=============================================================================

procedure TFrmVWPosJournalCA.ActInvAddToListExecute(Sender: TObject);
var                                                                             // Facture multi-tickets, PRG, R2011.2
  TcktType  : TTcktType; // Ticket type returned from IsValidAddToList function // Facture multi-tickets, PRG, R2011.2
begin  // of TFrmVWPosJournalCA.ActInvAddToListExecute
  if not IsValidAddToList(TcktType) then                                        // Facture multi-tickets, PRG, R2011.2
    Exit; // Dont add to list (message already displayed inside function)       // Facture multi-tickets, PRG, R2011.2
  StrLstObjTicket.AddObject(' ',
    TObjTicket.Create(DstLstTrans.FieldByName('IdtPosTransaction').AsInteger,
    DstLstTrans.FieldByName('IdtCheckout').AsInteger,
    DstLstTrans.FieldByName('CodTrans').AsInteger,
    DstLstTrans.FieldByName('DatTransBegin').AsDateTime,                        // Facture multi-tickets, PRG, R2011.2
    TcktType));                                                                 // Facture multi-tickets, PRG, R2011.2
  ActInvAddToList.Enabled   := False;
  ActInvViewList.Enabled    := True;
  ActInvViewList.Visible    := True;
  ActInvCreateMulti.Enabled := True;
  ActInvCreateMulti.Visible := True;
end;  // of TFrmVWPosJournalCA.ActInvAddToListExecute

//=============================================================================

//=============================================================================
// Facture multi-tickets, PRG, R2011.2 - start
//=============================================================================

// Check if the current ticket satisfies all criteria to be added to the multi-ticket list
function TFrmVWPosJournalCA.IsValidAddToList(var TcktType: TTcktType): Boolean;
var
  FirstTckt : TObjTicket;  // First ticket in the list
begin // of TFrmVWPosJournalCA.IsValidAddToList
  Result := True;
  TcktType := ChkTcktType;  //Get the ticket type from ChkTcktType function
  // Check if the current ticket is of "not allowed" type
  if TcktType = ctNotAllowed then begin
    MessageDlg (CtTxtNATcktType, mtError, [mbOK], 0);
    Result := False;
    Exit;
  end;
  // Check date and ticket type if tickets are already present in the list
  if StrLstObjTicket.Count>0 then begin
    FirstTckt := (StrLstObjTicket.Objects[0] As TObjTicket);
    // Check year of transactions
    if FormatDateTime('yyyy',FirstTckt.FDatTransBegin) <>
         FormatDateTime('yyyy',DstLstTrans.FieldByName('DatTransBegin').AsDateTime) then begin
		 MessageDlg (CtTxtDiffYear, mtError, [mbOK], 0);
		 Result := False;
		 Exit;
		 end;
		 // Facture_multi-tickets; KC; 2012.1 - Start
		 if FlgMonth then begin
		 // Check month of transactions
		 if FormatDateTime('mm',FirstTckt.FDatTransBegin) <>
		 FormatDateTime('mm',DstLstTrans.FieldByName('DatTransBegin').AsDateTime) then begin
		 MessageDlg (CtTxtDiffMonth, mtError, [mbOK], 0);
		 Result := False;
		 Exit;
		 end;
	  end;
    // Facture_multi-tickets; KC; 2012.1 - End
    // Check if tickets are of same type
    if FirstTckt.FTcktType <> TcktType then begin
      MessageDlg (CtTxtDiffTcktType, mtError, [mbOK], 0);
      Result := False;
      Exit;
    end;
  end;
end;  // of TFrmVWPosJournalCA.IsValidAddToList

//=============================================================================

{Check if the type of current ticket, i.e. Sales/Return/Mixed("not allowed") type)}
function TFrmVWPosJournalCA.ChkTcktType(): TTcktType;
var
  FlgSaleLine: Boolean;  // Stores the presence of a sale line
  FlgRtrnLine: Boolean;  // Stores the presence of a return line
  FlgCancelLine: Boolean; // Stores the presence of a Cancel line               //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)
begin // of TFrmVWPosJournalCA.ChkTcktType
  Result := ctNotAllowed;
  FlgSaleLine := false;
  FlgRtrnLine := false;
  FlgCancelLine := false;                                                       //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)
  // Iterate through dataset to determine ticket type
  DstDetTrans.First;
  while not DstDetTrans.EOF do begin
    //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)-Start
    // Check if this is a cancel line
    if (DstDetTrans.FieldByName('CodAction').AsInteger = CtCodActCancelReceipt) and
         (DstDetTrans.FieldByName('CodType').AsInteger = CtCodTypeCancelReceipt) then begin
       FlgCancelLine := true;
       Result := ctCancel;
       Exit;
    end;
    //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)-End
    // Check if this is a sales line
    if (DstDetTrans.FieldByName('CodAction').AsInteger = CtCodActPLUNum) and
         (DstDetTrans.FieldByName('CodType').AsInteger = CtCodTypeSale) and
         (DstDetTrans.FieldByName('QtyReg').AsInteger > 0) then
      FlgSaleLine := true;
    // Check if this is a return line
    if (DstDetTrans.FieldByName('CodAction').AsInteger = CtCodActTakeBack) and
         (DstDetTrans.FieldByName('CodType').AsInteger = CtCodTypeTakeBack) then begin
      FlgRtrnLine := true;
      // Check if sales line already present
      if FlgSaleLine then begin
        // Return action after sales action. Ticket cannot be included in list
        Result := ctNotAllowed;
        Exit;
      end;
    end;
    DstDetTrans.Next;
  end; // of while not DstDetTrans.EOF
  if FlgRtrnLine then
    Result := ctReturn
  else if FlgSaleLine then
    Result := ctSale;  
end;  // of TFrmVWPosJournalCA.ChkTcktType

// Facture multi-tickets, PRG, R2011.2 - end
//=============================================================================

procedure TFrmVWPosJournalCA.ActInvViewListExecute(Sender: TObject);
begin  // of TFrmVWPosJournalCA.ActInvViewListExecute
  inherited;
  frmFVWPosJournalTicket := TfrmFVWPosJournalTicket.Create(Self);
  frmFVWPosJournalTicket.ShowModal;
  frmFVWPosJournalTicket.Free;
  DstLstTransAfterScroll(DstLstTrans);
end;  // of TFrmVWPosJournalCA.ActInvViewListExecute

//=============================================================================

procedure TFrmVWPosJournalCA.ActInvCreateMultiExecute(Sender: TObject);
begin  // of TFrmVWPosJournalCA.ActInvCreateMultiExecute
  ActInvExecute(Self);
  Init;
  if QtyTickets <> 0 then
    ShowCurrentTicket;
end;   // of TFrmVWPosJournalCA.ActInvCreateMultiExecute

//=============================================================================

procedure TFrmVWPosJournalCA.ActCloseExecute(Sender: TObject);
begin  // of TFrmVWPosJournalCA.ActCloseExecute
  inherited;
 // StrLstObjTicket.Clear;
end;   // of TFrmVWPosJournalCA.ActCloseExecute

//=============================================================================
// BDES - Invoice with bar code, PRG, R2012.1 - start

//=============================================================================
// TFrmVWPosJournalCA.PrintTicket : Prints one ticket of the current record in
// the list dataset (overridden to print barcode)
//=============================================================================

procedure TFrmVWPosJournalCA.PrintTicket;
var
  VarPicHeight     : Real;             // Heigth of pic in twips
  TcktType: TTcktType;                                                          //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)
begin // of TFrmVWPosJournalCA.PrintTicket
  ValTicketStartY := FrmVSPreview.VspPreview.CurrentY;

  // Draw Top line
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft,
                                    FrmVSPreview.VspPreview.CurrentY,
                                    FrmVSPreview.VspPreview.MarginLeft +
                                    CtValTicketWidth * 16,
                                    FrmVSPreview.VspPreview.CurrentY);
  FrmVSPreview.VspPreview.StartTable;

  // Create a Column for a ticket
  FrmVSPreview.VspPreview.TableCell[TcCols, null, null, null, null] := 1;
  FrmVSPreview.VspPreview.TableCell[TcRows, null, null, null, null] := QtyLines;
  FrmVSPreview.VspPreview.TableCell[TcColwidth, 1, 1,
                                    null, null] := CtValTicketWidth * 16;
  Inc (QtyLines);

  ShowCurrentTicket;
  FrmVsPreview.VspPreview.EndTable;

  //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)-Start
  TcktType := ChkTcktType;  //Get the ticket type from ChkTcktType function
  if  (TcktType = ctCancel) then begin
    if(ViFlgBcdCancelA4) then begin
      CreateBarCode(DatTransBegin,NumTicket,NumCashdesk);
      PrintBarCode(VarPicHeight);
      DestroyBarCode;
      FrmVSPreview.VspPreview.CurrentY := FrmVSPreview.VspPreview.CurrentY + VarPicHeight;
    end;
  end
  else begin
    if ViFlgBcdA4 then begin
      CreateBarCode(DatTransBegin,NumTicket,NumCashdesk);
      PrintBarCode(VarPicHeight);
      DestroyBarCode;
      FrmVSPreview.VspPreview.CurrentY := FrmVSPreview.VspPreview.CurrentY + VarPicHeight;
    end;
  end;
  //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)-End
  // Draw Bottom line
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft,
                                    FrmVSPreview.VspPreview.CurrentY,
                                    FrmVSPreview.VspPreview.MarginLeft +
                                    CtValTicketWidth * 16,
                                    FrmVSPreview.VspPreview.CurrentY);

  // Draw Left Line
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft,
                                    ValTicketStartY,
                                    FrmVSPreview.VspPreview.MarginLeft,
                                    FrmVSPreview.VspPreview.CurrentY);
  // Draw Right Line
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft +
                                    CtValTicketWidth * 16,
                                    ValTicketStartY,
                                    FrmVSPreview.VspPreview.MarginLeft +
                                    CtValTicketWidth * 16,
                                    FrmVSPreview.VspPreview.CurrentY);
end;  // of TFrmVWPosJournalCA.PrintTicket

//=============================================================================
// CreateBarCode : Create a barcode bitmap
//=============================================================================

procedure TFrmVWPosJournalCA.CreateBarCode(TransDate   : TStDate;
                                           NumTicket   : LongInt;
                                           NumCashdesk : Word);
var
  strFilePath      : string;           // pathname for barcode
  TxtBarcd         : string;
  ViNumstorenew    : string;                                                    //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)
begin  // of TFrmVSRptInvoiceCA.CreateBarCode
  ViNumstorenew:='0'+ inttostr(ViNumstore);                                     //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)
  TxtBarcd := '';  //No barcode will be printed if this text is blank due to below conditions
  if barcodereturnNew.Format <> '' then
    TxtBarcd := MaakEAN128BarCD (barcodereturnNew.Format,TransDate,NumTicket,NumCashdesk,strtoint(ViNumstorenew));    //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)
  StBrCdTcktInfo.ShowCode := True;                                              //R2013.1-11227-CAFR/BDES-Add store number in barcode-TCS(SM/CP)
  StBrCdTcktInfo.Code := Copy(TxtBarcd, 0, Length(TxtBarcd));
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  StBrCdTcktInfo.SaveToFile(strFilePath);
end;   // of TFrmVSRptInvoiceCA.CreateBarCode

//=============================================================================
// PrintBarCode : Print the barcode bitmap
//=============================================================================

procedure TFrmVWPosJournalCA.PrintBarCode (var VarPicHeight:Real);              // Height required to draw lines
var
  StrFilePath      : string;           // pathname for logo
  PicLogo          : TPicture;         // Logo to be printed
  OlePicLogo       : IPictureDisp;     // Logo picture in OLE format
  VarPicWidth      : Real;             // Width of pic in twips
  VarPicLeft       : Real;             // Pic left position
//  VarPicHeight     : Real;             // Heigth of pic in twips
begin  // of TFrmVSRptInvoiceCA.PrintHeader
  VarPicHeight := 0;
  try
    // Barcode
    StrFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
    PicLogo := TPicture.Create;
    if FileExists (StrFilePath) then begin
      PicLogo.LoadFromFile(ReplaceEnvVar(StrFilePath));
      GetOlePicture (PicLogo, OlePicLogo);
      FrmVSPreview.VspPreview.CalcPicture := OlePicLogo;
      VarPicWidth  := PicLogo.Width/Screen.PixelsPerInch * 1440;
      VarPicHeight := PicLogo.Height/Screen.PixelsPerInch * 1440;
      VarPicLeft := FrmVSPreview.VspPreview.MarginLeft +
                    (CtValTicketWidth * 16 - VarPicWidth)/2;
      FrmVSPreview.VspPreview.DrawPicture (OlePicLogo, VarPicLeft,
                              FrmVSPreview.VspPreview.CurrentY, '100%', '100%', '', False);
    end; // of if FileExists (StrFilePath)
  finally
    // Restore fontsize for next report (barcode)
    FrmVSPreview.VspPreview.FontSize := 8;
  end;
end;   // of TFrmVSRptInvoiceCA.CreateBarCode

//=============================================================================
// DestroyBarCode : Destroy the barcode bitmap
//=============================================================================

procedure TFrmVWPosJournalCA.DestroyBarCode;
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
end.  //FVWPosJournalCA
