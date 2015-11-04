//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : Standard Development
// Unit   : MMntInvoice.pas : Module of MaiNTenance Invoices
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MMntInvoice.pas,v 1.9 2009/05/20 07:42:51 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - MMntInvoice - CVS revision 1.2
// 1.10    ARB        CAFR.2011.2.23.9.1
// 1.11    RC    (TCS) R2014.2.Applix 3148175.Invoice_Regrouping
//=============================================================================

unit MMntInvoice;

//*****************************************************************************

interface

uses
  Windows, Messages, Dialogs, OvcBase, OvcPF, SysUtils, Classes, Controls,
  StdCtrls, ExtCtrls,  ScUtils, Db, Grids;

//=============================================================================
// Resourcestring contains all the titles of the items that must be put in a
// stringrid.
//=============================================================================

resourcestring
  CtTxtQuantity    = 'Quantity';
  CtTxtDescription = 'Description';
  CtTxtPrice       = 'Price';
  CtTxtPromotion   = 'Promotion';
  CtTxtDiscount    = 'Discount';
  CtTxtAmount      = 'Amount';

//=============================================================================
// Global type definitions :
// TObjTransaction : The fields in this object are almost the same as those
// in FlexPOS.  In this way, the processing of a ticket is similar.
//
// Remark : It's important to know that all prices are converted to
// the main currency when the object is filled.  This makes the processing of
// the invoice a little easier and faster.  The original IdtCurrency is
// also stored into the object (IdtCurrencyOrig).  In this way is possible
// to 're - generate' the original value.
//=============================================================================

type
  TObjTransaction = class (TObject)
  public
    // Kind of POSTransaction
    CodMainAction       : Byte;

    // Currency of the transaction
    IdtCurrencyOrig     : string;   // Original Indent of the currency
    ValExchangeOrig     : Currency; // Original Value of te exchange
    FlgExchMultiplyOrig : Boolean;  // Original Flag exchange multiply

    // Data Turnover
    CodActTurnOver      : Byte;     // CodAction Turnover
    IdtClassification   : string;   // Classification of the article
    TxtDescrTurnOver    : string;   // Discription of the turnover line
    QtyArt              : Currency; // Quantity Article
    NumPLU              : string;   // PLU number, only filled in for article.
    IdtArticle          : string;   // Idt of Article, only filled in for art.

    PrcInclVAT          : Currency; // Standard Saleprice Inclusief VAT
    ValInclVAT          : Currency; // Amount Saleprice Inclusief VAT
    PrcExclVAT          : Currency; // Standard Saleprice Exclusief VAT
    ValExclVAT          : Currency; // Amount Saleprice Exclusief VAT

    IdtVATCode          : Integer;  // Identification of the VAT Code
    PctVATCode          : Currency; // Percent of the VAT Code

    // Data Discount
    CodActDisc          : Byte;     // CodAction Discount
    TxtDescrDiscount    : string;   // Description Discount
    (** KRG -> moet nog onderzocht worden, maar mag waarschijnlijk verwijderd worden.**)
    PrcDiscInclVAT      : Currency; // Price Discount Inclusief VAT
    (** KRG **)
    ValDiscInclVAT      : Currency; // Amount Discount Inclusief VAT
    ValDiscExclVAT      : Currency; // Amount Discount Inclusief VAT
    PctDisc             : Currency; // Percent Discount on a article

    // Takeback an article
    CodActTakeBack      : Byte;     // CodAction  Takeback
    TxtDescrTakeBack    : string;   // Description Takeback

    // Data for a Free Article
    CodActFree          : Byte;     // CodAction Free
    TxtDescrFree        : string;   // Description Free
    SubdivFree          : Word;     // SubdivNr Free

    TxtDescrProm        : string;   // Description promotionprice
    PrcPromInclVAT      : Currency; // Unitprice of promotion (Incl VAT)
    ValPromInclVAT      : Currency; // Amount of promotion price (Incl VAT)
    PrcPromExclVAT      : Currency; // Unitprice of promotion (Excl VAT)
    ValPromExclVAT      : Currency; // Amount of promotion price (Excl VAT)

    // Data administratif of geld : bons, winkelbons, ...
    // but also counted deposit by an article
    CodActAdm           : Byte;     // CodAction administratief bedrag
    TxtDescrAdm         : string;   // Description administratief
    IdtAdmClassi        : string;   // SubdivNr administratief
    PrcAdmInclVAT       : Currency; // Administratieve prices
    ValAdmInclVAT       : Currency; // Amount administratif prices
    IdtAdmVAT           : Byte;     // Identification of the VAT Code
    PctAdmVAT           : Currency; // Percent of the VAT Code

    // Data Comment
    CodActComment       : Byte;     // CodAction Comment
    TxtDescrComment     : string;   // String of comment


    procedure FillObj (DsrData : TDataSet); virtual;
    function Evaluate (ObjTransaction : TObjTransaction) : Boolean; virtual;
    procedure Count (ObjTransaction : TObjTransaction); virtual;
    procedure Clear; virtual;
    function PurgeMe : Boolean; virtual;

    function GetSalesPrice (FlgExclVAT: Boolean = False): Currency;
      // Get sales price for transaction, while taking into account possible
      // discounts and promotion.
    function GetSalesValue (FlgExclVAT: Boolean = False): Currency;
      // Get sales value for transaction, while taking into account possible
      // discounts and promotion.

  end;   // of TObjTransaction

//=============================================================================

type
  TObjTransTicket = class (TObject)
  private
    FDtmInvoice         : TDateTime;
    FDtmDelivNote       : TDateTime;
    FIdtInvoice         : Integer;
    FIdtDelivNote       : Integer;

    FIdtPOSTransaction  : Integer;
    FIdtCheckOut        : Integer;
    FCodTrans           : Integer;
    FDatTransBegin      : TDateTime;

    FIdtCustomer        : Integer;
    // CAFR.2011.2.23.9.1 ARB
    FPromoPackComment   : String;
  protected

    FSetActPaymentTypes : set of Byte; // Action codes for payment types.
    FSetActSales        : set of Byte; // Action codes for sales total calc.

    function GetNewTransObj : TObjTransaction; virtual;


  public
    StrLstObjTransaction    : TStringList;

    property DtmInvoice : TDateTime read FDtmInvoice
                                    write FDtmInvoice;
    property DtmDelivNote : TDateTime read FDtmDelivNote
                                      write FDtmDelivNote;
    property IdtInvoice : Integer read FIdtInvoice
                                  write FIdtInvoice;
    property IdtDelivNote : Integer read FIdtDelivNote
                                    write FIdtDelivNote;

    property IdtPOSTransaction : Integer read FIdtPOSTransaction
                                         write FIdtPOSTransaction;
    property IdtCheckOut : Integer read FIdtCheckOut
                                   write FIdtCheckOut;
    property CodTrans : Integer read FCodTrans
                                write FCodTrans;
    property DatTransBegin : TDateTime read  FDatTransBegin
                                       write FDatTransBegin;

    property IdtCustomer : Integer read FIdtCustomer
                                   write FIdtCustomer;
    // CAFR.2011.2.23.9.1 ARB Start
    property PromoPackComment : String read FPromoPackComment
                                      write FPromoPackComment;
    // CAFR.2011.2.23.9.1 ARB End
    constructor Create; virtual;
    destructor Destroy; override;
    procedure FillObj (DsrData : TDataSet); virtual;
    procedure FillTransactions (DsrData : TDataSet); virtual;
    procedure PurgeTransactions; virtual;
      // Purge transactions where amount and quantity are zero.

    function GetPaymentTrans: TList; virtual;
    function GetTotalByAct (ArrCodAction : array of Integer): Double; virtual;

    function GetTicketTotal: Double; virtual;
    function GetDepositTotal: Double; virtual;

  end;   // of TObjTransTicket

type
  TObjTransPayment = class (TObjTransaction)
    FCmpName   : TComponent;
  public
    property CmpName : TComponent read FCmpName
                                  write FCmpName;
  end;  // of TObjPayments

//=============================================================================

implementation

uses
  SmUtils,
  SfDialog,

  DFpnUtils,
  DFpnPosTransAction,
  DfpnPosTransActionCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'MMntInvoices';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MMntInvoice.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.10 $';
  CtTxtSrcDate    = '$Date: 2011/06/06 10:10:13 $';

//*****************************************************************************
// Implementation of TObjTransaction
//*****************************************************************************

//=============================================================================
// TObjTransaction.FillObj : Interpret the given dataset and put it in the
// object.  Depend on the Codaction, different field are filled.  This is
// almost equal to Flexpos.
//                                  --------------
// Input : - DsrData    : Dataset that contains the data to evaluate.
//=============================================================================

procedure TObjTransaction.FillObj (DsrData : TDataSet);
begin  // of TObjTransaction.FillObj
  // Fill in the currency
  IdtCurrencyOrig := DsrData.FieldByName ('IdtCurrency').AsString;
  ValExchangeOrig := DsrData.FieldByName ('ValExchange').AsCurrency;
  FlgExchMultiplyOrig :=
      StrToBool (DsrData.FieldByName ('FlgExchMultiply').AsString, '9');

  // Depend on the codaction, fill in the fields in the object.
  case DsrData.FieldByName ('CodAction').AsInteger of
    CtCodActPLUNum, CtCodActPLUKey, CtCodActClassNum, CtCodActClassKey : begin
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
        NumPLU := DsrData.FieldByName ('NumPLU').AsVariant;
        IdtArticle := DsrData.FieldByName ('IdtArticle').AsString;
      end;
      TxtDescrTurnOver := DsrData.FieldByName ('TxtDescr').AsString;

      // Convert the prices to the main currency
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
      ValPromExclVAT := DmdFpnUtils.ExchangeCurr
          (DsrData.FieldByName ('ValExclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
    end;
    CtCodActDiscArtPct, CtCodActDiscCust, CtCodActDiscPers,
    CtCodActDiscArtVal : begin
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
      if (ValDiscInclVAT <> 0) and (PrcDiscInclVAT = 0) then
        // Initialise PrcDiscInclVAT since this never seems to be filled out
        // and we loose the original value when the transactions are cumulated
        // using the Count() method.
        PrcDiscInclVAT := ValDiscInclVAT/QtyArt;
    end;
    // Payment with cash
    CtCodActCash, CtCodActCheque, CtCodActBankCard, CtCodActEFT,
    CtCodActCreditAllow, CtCodActForCurr, CtCodActCoupExternal,
    CtCodActRndTotal, CtCodActBankTransfer : begin
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
          ( - DsrData.FieldByName ('ValInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);

      if CodActAdm = CtCodActRndTotal then begin
        IdtAdmVAT := DsrData.FieldByName ('IdtVATCode').AsInteger;
        PctAdmVAT := DsrData.FieldByName ('PctVAT').AsCurrency;
      end;
    end;
    CtCodActFree, CtCodActBingo : begin
      CodActFree := DsrData.FieldByName ('CodAction').AsInteger;
      TxtDescrFree := DsrData.FieldByName ('TxtDescr').AsString;
    end;
    CtCodActDiscCoup, CtCodActDepCharge, CtCodActDepTakeBack : begin
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
          (DsrData.FieldByName ('ValInclVAT').AsCurrency, ValExchangeOrig,
           FlgExchMultiplyOrig, DmdFpnUtils.ValExchangeBase,
           DmdFpnUtils.FlgExchMultiplyCurrencyMain);
    end;
    CtCodActTakeBack : begin
      CodActTakeBack := DsrData.FieldByName ('CodAction').AsInteger;
      TxtDescrTakeBack := DsrData.FieldByName ('TxtDescr').AsString;
    end;
    CtCodActComment : begin
      CodActComment := DsrData.FieldByName ('CodAction').AsInteger;
      TxtDescrComment := DsrData.FieldByName ('TxtDescr').AsString;
    end;
  end;
end;   // of TObjTransaction.FillObj

//=============================================================================
// TObjTransaction.Evaluate : Evaluate 2 objects if there are equal.
//                             ------------
// INPUT   : ObjTransaction : Object that will be examed to see if
//                            there're equal
//                             ------------
// FUNCRES : True  : the objects are equal
//           False : The objects aren't equal
//=============================================================================

function TObjTransaction.Evaluate (ObjTransaction : TObjTransaction) : Boolean;
begin  // of TObjTransaction.Evaluate
  Result := (ObjTransaction.CodActTakeBack <> CtCodActTakeBack)
        and (CodActTakeBack <> CtCodActTakeBack)
        and (CodActFree = ObjTransaction.CodActFree)
        and (CodMainAction = ObjTransaction.CodMainAction)
        and (NumPLU = ObjTransaction.NumPLU)
        and (PrcInclVAT = ObjTransaction.PrcInclVAT)
        and (PrcPromInclVAT = ObjTransaction.PrcPromInclVAT)
        and (TxtDescrDiscount = ObjTransaction.TxtDescrDiscount)
        and (CodActDisc = ObjTransaction.CodActDisc)
        and (CodActAdm = ObjTransaction.CodActAdm )
        and (PrcAdmInclVAT = ObjTransaction.PrcAdmInclVAT)
        and (AnsiCompareStr (IdtAdmClassi, ObjTransaction.IdtAdmClassi) = 0)
        and (IdtClassification = ObjTransaction.IdtClassification)
        and (TxtDescrTurnOver = ObjTransaction.TxtDescrTurnOver)       // R2014.2.Applix 3148175.Invoice_Regrouping.TCS-RC.
end;   // of TObjTransaction.Evaluate

//=============================================================================
// TObjTransaction.Count : Count values of 1 object to a other.
//                              ----------------
// INPUT :  ObjTransaction : Object that contains the information to count
//=============================================================================

procedure TObjTransaction.Count (ObjTransaction : TObjTransaction);
begin  // of TObjTransaction.Count
  QtyArt         := QtyArt         + ObjTransaction.QtyArt;
  ValInclVAT     := ValInclVAT     + ObjTransaction.ValInclVAT;
  ValPromInclVAT := ValPromInclVAT + ObjTransaction.ValPromInclVAT;
  ValPromExclVAT := ValPromExclVAT + ObjTransaction.ValPromExclVAT;
  ValAdmInclVAT  := ValAdmInclVAT  + ObjTransaction.ValAdmInclVAT;
  ValDiscInclVAT := ValDiscInclVAT + ObjTransaction.ValDiscInclVAT;
end;   // of TObjTransaction.Count

//=============================================================================
// TObjTransaction.Clear : Clears the information of a transaction.
//=============================================================================

procedure TObjTransaction.Clear;
begin  // of TObjTransaction.Clear
  CodActTakeBack   := 0;
  TxtDescrTakeBack := '';

  CodActFree       := 0;
  TxtDescrFree     := '';
  SubdivFree       := 0;

  CodMainAction    := 0;

  CodActTurnOver   := 0;
  TxtDescrTurnOver := '';
  TxtDescrProm     := '';
  IdtClassification   := '';
  IdtArticle       := '';

  QtyArt           := 0;
  NumPLU           := '0';
  PrcInclVAT       := 0;
  PrcPromInclVAT   := 0;
  ValPromInclVAT   := 0;

  IdtVATCode       := 0;
  PctVATCode       := 0;

  CodActAdm        := 0;
  TxtDescrAdm      := '';
  IdtAdmClassi     := '';
  ValAdmInclVAT    := 0;
  PrcAdmInclVAT    := 0;
  IdtAdmVAT        := 0;
  PctAdmVAT        := 0;

  CodActDisc       := 0;
  TxtDescrDiscount := '';
  PrcDiscInclVAT   := 0;
  ValDiscInclVAT   := 0;

  CodActComment    := 0;
  TxtDescrComment  := '';
end;   // of TObjTransaction.Clear

//=============================================================================

function TObjTransaction.GetSalesValue (FlgExclVAT: Boolean = False): Currency;
begin  // of TObjTransaction.GetSalesValue
  if FlgExclVAT then begin
    if ValPromExclVAT > 0 then
      Result := ValPromExclVAT + ValDiscInclVAT
    else
      Result := ValExclVAT + ValDiscInclVAT;
  end
  else begin
    if ValPromInclVAT > 0 then
      Result := ValPromInclVAT + ValDiscInclVAT
    else if ValAdmInclVAT > 0 then
      Result := ValAdmInclVAT
    else
      Result := ValInclVAT + ValDiscInclVAT;
  end;
end;   // of TObjTransaction.GetSalesValue

//=============================================================================

function TObjTransaction.GetSalesPrice (FlgExclVAT: Boolean = False): Currency;
begin  // of TObjTransaction.GetSalesPrice
  if FlgExclVAT then begin
    if PrcPromExclVAT > 0 then
      Result := PrcPromExclVAT + PrcDiscInclVAT
    else
      Result := PrcExclVAT + PrcDiscInclVAT;
  end
  else begin
    if PrcPromInclVAT > 0 then
      Result := PrcPromInclVAT + PrcDiscInclVAT
    else if PrcAdmInclVAT > 0 then
      Result := PrcAdmInclVAT
    else
      Result := PrcInclVAT + PrcDiscInclVAT;
  end;
end;   // of TObjTransaction.GetSalesPrice

//=============================================================================

function TObjTransaction.PurgeMe: Boolean;
begin  // of TObjTransaction.PurgeMe
  Result := (QtyArt = 0) and (GetSalesValue() = 0) and
            (CodMainAction in [CtCodActPLUNum, CtCodActPLUKey,
                               CtCodActClassNum, CtCodActClassKey,
                               CtCodActDiscCoup, CtCodActDepCharge,
                                CtCodActDepTakeBack]);
end;  // of TObjTransaction.PurgeMe

//*****************************************************************************
// Implementation of TObjTransTicket
//*****************************************************************************

constructor TObjTransTicket.Create;
begin  // of TObjTransTicket.Create
  StrLstObjTransaction := TStringList.Create;

  FSetActSales := [CtCodActPLUNum, CtCodActPLUKey,
                   CtCodActClassNum, CtCodActClassKey,
                   CtCodActDepCharge, CtCodActDepTakeBack];
  FSetActPaymentTypes :=
    [CtCodActCash, CtCodActCheque, CtCodActBankCard, CtCodActEFT,
     CtCodActForCurr, CtCodActCreditAllow, CtCodActCoupExternal,
     CtCodActRndTotal, CtCodActDiscCoup, CtCodActReturn];
end;   // of TObjTransTicket.Create

//=============================================================================

destructor TObjTransTicket.Destroy;
begin  // of TObjTransTicket.Destroy
  StrLstObjTransaction.Free;
end;   // of TObjTransTicket.Destroy

//=============================================================================
// TObjTransTicket.FillObj : Interpret the given dataset and put it in the
// object.
//                                  --------------
// Input : - DsrData    : Dataset that contains the data to evaluate.
//=============================================================================

procedure TObjTransTicket.FillObj (DsrData : TDataSet);
begin  // of TObjTransTicket.FillObj
  if DsrData.FindField('IdtInvoice') <> nil then
    FIdtInvoice := DsrData.FieldByName ('IdtInvoice').AsInteger;
  if DsrData.FindField('DatInvoice') <> nil then
    FDtmInvoice := DsrData.FieldByName ('DatInvoice').AsDateTime;
  if DsrData.FindField('IdtDelivNote') <> nil then
    FIdtDelivNote := DsrData.FieldByName ('IdtDelivNote').AsInteger;
  if DsrData.FindField('DatDelivNote') <> nil then
    FDtmDelivNote := DsrData.FieldByName ('DatDelivNote').AsDateTime;
  if DsrData.FindField('IdtPOSTransaction') <> nil then
    FIdtPOSTransaction := DsrData.FieldByName ('IdtPOSTransaction').AsInteger;
  if DsrData.FindField('IdtCheckout') <> nil then
    FIdtCheckOut := DsrData.FieldByName ('IdtCheckout').AsInteger;
  if DsrData.FindField('CodTrans') <> nil then
    FCodTrans := DsrData.FieldByName ('CodTrans').AsInteger;
  if DsrData.FindField('DatTransBegin') <> nil then
    FDatTransBegin := DsrData.FieldByName ('DatTransBegin').AsDateTime;
end;   // of TObjTransTicket.FillObj

//=============================================================================
// TObjTransTicket.GetNewTransObj: returns a new transaction object
//=============================================================================

function TObjTransTicket.GetNewTransObj: TObjTransaction;
begin  // of TObjTransTicket.GetNewTransObj
  Result := TObjTransaction.Create;
end;   // of TObjTransTicket.GetNewTransObj

//=============================================================================
// TObjTransTicket.FillTransactions: fill the list with transaction objects
//  using data from a given dataset with POSTransDetail info.
//                                     ---
// INPUT  : DsrData = Dataset containing PosTransDetail data for current ticket.
//=============================================================================

procedure TObjTransTicket.FillTransactions(DsrData: TDataSet);
var
  NumLine          : Integer;          // Current POSTransDetail line
  ObjCurrTrans     : TObjTransaction;  // Current transaction
  FlgFound         : Boolean;          // Is a equal Transdetail found?
  CntTransDetail   : Integer;          // Loop all Transdetails
  NumSubTot        : Integer;          // Indicates a subtotal in a ticket.
begin  // of TObjTransTicket.FillTransactions

  NumLine   := DsrData.FieldByName('NumLineReg').AsInteger;
  NumSubTot := 0;
  repeat
    ObjCurrTrans := GetNewTransObj;
    while not (DsrData.Eof) and
              (NumLine = DsrData.FieldByName('NumLineReg').AsInteger) do begin
      ObjCurrTrans.FillObj(DsrData);
      DsrData.Next;
    end;

    NumLine := DsrData.FieldByName('NumLineReg').AsInteger;
    // Find all equal POSTransDetails and cummulate them.
    // Start's from the last Subtotal-line
    FlgFound := False;
    for CntTransDetail := NumSubTot to Pred(StrLstObjTransaction.Count) do begin
      if TObjTransAction(StrLstObjTransaction.Objects[CntTransDetail]).
                           Evaluate(ObjCurrTrans) then begin
        TObjTransAction(StrLstObjTransaction.Objects[CntTransDetail]).
                          Count(ObjCurrTrans);
        ObjCurrTrans.Free;
        FlgFound := True;
        Break;
      end;
    end;

    if not FlgFound then
      StrLstObjTransaction.AddObject('', ObjCurrTrans);

    // In case of a subtotal
    if DsrData.FieldByName('CodAction').AsInteger = CtCodActSubTotal then
      NumSubTot := StrLstObjTransaction.Count;

  until DsrData.Eof;
end;   // of TObjTransTicket.FillTransactions

//=============================================================================

procedure TObjTransTicket.PurgeTransactions;
var
  CntTrans         : Integer;
begin  // of TObjTransTicket.PurgeTransactions
  for CntTrans := StrLstObjTransaction.Count-1 downto 0 do begin
    if TObjTransAction(StrLstObjTransaction.Objects[CntTrans]).PurgeMe then
      StrLstObjTransaction.Objects[CntTrans].Free;
  end;
end;   // of TObjTransTicket.PurgeTransactions

//=============================================================================
// TObjTransTicket.GetTicketTotal: returns ticket total registered by last
//  action total line registered for the ticket.
//=============================================================================

function TObjTransTicket.GetTicketTotal: Double;
var
  CntTrans         : Integer;
  ObjTrans         : TObjTransaction;
begin  // of TObjTransTicket.GetTicketTotal
  Result := 0;
  for CntTrans := 0 to StrLstObjTransaction.Count-1 do begin
    ObjTrans := TObjTransaction (StrLstObjTransaction.Objects[CntTrans]);
    if ObjTrans.CodMainAction in FSetActSales then
      Result := Result + ObjTrans.GetSalesValue;
  end;
end;   // of TObjTransTicket.GetTicketTotal

//=============================================================================
// TObjTransTicket.GetTicketTotal: returns ticket total registered by last
//  action total line registered for the ticket.
//=============================================================================

function TObjTransTicket.GetDepositTotal: Double;
var
  CntTrans         : Integer;
  ObjTrans         : TObjTransaction;
begin  // of TObjTransTicket.GetTicketTotal
  Result := 0;
  for CntTrans := 0 to StrLstObjTransaction.Count-1 do begin
    ObjTrans := TObjTransaction (StrLstObjTransaction.Objects[CntTrans]);
    if ObjTrans.CodMainAction in [CtCodActPayAdvance,
                                  CtCodActChangeAdvance,
                                  CtCodActPayForfait] then
      Result := Result + (-ObjTrans.GetSalesValue);
  end;
end;   // of TObjTransTicket.GetTicketTotal

//=============================================================================
// TObjTransTicket.GetPaymentTrans: return a list with all payment type
//   transactions for the current ticket.
//                                     ---
// RESULT : TList object containing all payment transactions.
//=============================================================================

function TObjTransTicket.GetPaymentTrans: TList;
var
  CntTrans         : Integer;
  ObjTrans         : TObjTransaction;
begin  // of TObjTransTicket.GetPaymentTrans
  Result := TList.Create();
  for CntTrans := 0 to StrLstObjTransaction.Count-1 do begin
    ObjTrans := TObjTransaction (StrLstObjTransaction.Objects[CntTrans]);
    if ObjTrans.CodMainAction in FSetActPaymentTypes then begin
      Result.Add (ObjTrans);
    end;
  end;
end;   // of // of TObjTransTicket.GetPaymentTrans

//=============================================================================

function TObjTransTicket.GetTotalByAct(ArrCodAction: array of Integer): Double;
var
  CntTrans         : Integer;
  CntIx            : Integer;
  ObjTrans         : TObjTransaction;
begin  // of TObjTransTicket.GetTotalByAct
  Result := 0;
  for CntTrans := 0 to StrLstObjTransaction.Count-1 do begin
    ObjTrans := TObjTransaction (StrLstObjTransaction.Objects[CntTrans]);
    for CntIx := 0 to High (ArrCodAction) do begin
      if ObjTrans.CodMainAction = ArrCodAction[CntIx] then begin
        Result := Result + ObjTrans.GetSalesValue();
        break;
      end;
    end;
  end;
end;   // of TObjTransTicket.GetTotalByAct

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of MMntInvoice
