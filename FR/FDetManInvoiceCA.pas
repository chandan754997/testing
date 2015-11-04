//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Manuel Invoice
// Unit   : FDetManInvoiceCA.PAS : Form DETail MANuele INVOICES                   
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetManInvoiceCA.pas,v 1.6 2009/09/21 13:58:36 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FDetManInvoiceCA - CVS revision 1.28
// Version                              Modified By                          Reason
// V 1.1                                SM (TCS)                          R2012.1 - BDFR - Address de Facturation
//=============================================================================

unit FDetManInvoiceCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sfdetail_BDE_DBC, OvcBase, ComCtrls, StdCtrls, Buttons, ExtCtrls, ScUtils,
  MMntInvoice, Action, IniFiles, ImgList, Db, ovcef, ovcpb, ovcpf,
  ScDBUtil_BDE, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  ScUtils_Dx;

//=============================================================================
// Global resourcestrings
//=============================================================================

resourcestring  // common messages
  CtTxtSureRemoveItem   = 'Are you sure you want te remove the item %s?';
  CtTxtSureSelectCust   = 'Do you want to use customer %s (%s)?';

resourcestring  // error messages
  CtTxtClassNotFound    = 'There''s no action found for the classification %s' +
                          #10'This classification will not be added to the ' +
                          'payment-methodes';
resourcestring // help messages
  CtTxtFiscalInfo     = '/VFisc=Print fiscal receipt info on invoice';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

//=============================================================================
// TFrmDetManInvoiceCA
//=============================================================================

type
  TFrmDetManInvoiceCA = class(TFrmDetail)
    SvcLFCustomerNumber: TSvcLocalField;
    BtnSelectCustomer: TBitBtn;
    TabShtArticles: TTabSheet;
    LvwArticles: TListView;
    SvcDBLblCustomerNumber: TSvcDBLabelLoaded;
    SvcDBLblCustomerName: TSvcDBLabelLoaded;
    SvcDBLblDateInvoice: TSvcDBLabelLoaded;
    SvcLFDateInvoice: TSvcLocalField;
    LblVatNumber: TLabel;
    SvcDBLblVATNumber: TSvcDBLabelLoaded;
    SvcDBLblAddress: TSvcDBLabelLoaded;
    LblStreet: TLabel;
    LblZipCode: TLabel;
    LblMunicipality: TLabel;
    PnlButtons: TPanel;
    BtnSelectArticle: TBitBtn;
    BtnManuelArticle: TBitBtn;
    BtnComment: TBitBtn;
    BtnEdit: TBitBtn;
    BtnDelete: TBitBtn;
    BtnUp: TBitBtn;
    BtnDown: TBitBtn;
    PnlTotals: TPanel;
    SvcDBLblInvoiceAddress: TSvcDBLabelLoaded;
    LblInvoiceStreet: TLabel;
    LblInvoiceZipCode: TLabel;
    LblInvoiceMunicipality: TLabel;
    BtnPayment: TBitBtn;
    SvcDBLblTotalAmount: TSvcDBLabelLoaded;
    LblTotalAmount: TLabel;
    SvcDBLblTotalToPay: TSvcDBLabelLoaded;
    LblTotalToPay: TLabel;
    SvcDBLblTotalPaid: TSvcDBLabelLoaded;
    LblTotalPaid: TLabel;
    BvlInvoiceDate: TBevel;
    SvcDBLblDispositPlus: TSvcDBLabelLoaded;
    LblTotalDispositPlus: TLabel;
    SvcDBLblDispositMin: TSvcDBLabelLoaded;
    LblTotalDispositMin: TLabel;
    SvcDBLblTotalInvoice: TSvcDBLabelLoaded;
    LblTotalInvoice: TLabel;
    BvlGeneralInfo: TBevel;
    LblCurrTotalAmount: TLabel;
    LblCurrDispositPlus: TLabel;
    LblCurrDispositMin: TLabel;
    LblCurrTotalInvoice: TLabel;
    LblCurrTotalPaid: TLabel;
    LblCurrTotalToPay: TLabel;
    BvlTotalPayment: TBevel;
    BvlTotalAmount: TBevel;
    SvcDBLblCustDiscount: TSvcDBLabelLoaded;
    SvcLFCustDiscount: TSvcLocalField;
    Bevel1: TBevel;
    ImageList1: TImageList;
    DsrPOSTransDetail: TDataSource;
    SvcMECustomerName: TSvcMaskEdit;
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnSelectArticleClick(Sender: TObject);
    procedure BtnManuelArticleClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnSelectCustomerClick(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure BtnDownClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SvcLFCustomerNumberExit(Sender: TObject);
    procedure BtnCommentClick(Sender: TObject);
    procedure LvwArticlesDblClick(Sender: TObject);
    procedure BtnPaymentClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LvwArticlesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ReadIniFile;                                                       //R2012.1 Address De Facturation(SM)
  private
    { Private declarations }
  protected
    FObjTransaction     : TObjTransaction;  // Information of the article
    FCurrTransTicket    : TObjTransTicket;  // Information of the current ticket
    FLstPaymethodes     : TList;            // List with the paymethodes.
    FLstPrevPaymethodes : TList;            // List with the previous values
    FNumTotal           : Currency;         // Total amount to Pay
    FlgFrance           : boolean;                                              //R2012.1 Address De Facturation(SM)
    FFlgFiscal          : Boolean;
    FFlgFiscalInfo      : Boolean;
    FFlgRussia          : Boolean;
    FFlgFrance          : Boolean;                                                 //R2012.1 Address De Facturation(SM)
    FFlgPricing         : Boolean;
    FFlgItaly           : Boolean;
    FIdtDepartment      : integer;
    FFlgPosJournal      : Boolean;
    FIdtPosTransaction  : Integer;
    FCodTrans           : Integer;
    FIdtCheckout        : Integer;
    FDatTransBegin      : TDateTime;
    FIdtCustomer        : Integer;
    FIdtOrigInvoice     : Integer;
    FTxtFiscalInfo      : string;
    FCodCreator         : integer;
    procedure GetSalePrices (    IdtArticle   : string  ;
                                 IdtCustomer  : Integer ;
                             var NumPrcNormal : Currency;
                             var NumPrcPromo  : Currency;
                             var TxtCampDescr : string  ); virtual;
    function GetTotalToPay : Currency; virtual;
    function GetTotalPayed : Currency; virtual;
    function GetCodAction (PActietabelBegin : TGegActPtr;
                           IdtMember        : Integer   ) : Integer; virtual;
    function GetIdtClassOfAction (PActietabelBegin : TGegActPtr;
                                  CodAction        : Integer   ):string;virtual;
    procedure PrepareSprLstClassification; virtual;

    procedure ClearCustomerCaption; virtual;
    procedure FillCustomerCaption (IdtCustomer : Integer); overload; virtual;
    procedure FillCustomerCaption (IdtCustomer : Integer;
                                   CodCreator  : Integer); overload;
    procedure FillArticleInfoInObj (IdtArticle : string); virtual;
    procedure FillPaymentsMethodes; virtual;
    procedure FillTotalsInvoice; virtual;

    procedure SetLvwArticleImage (LvwItmArticle : TListItem;
                                  ObjTrans      : TObjTransaction);
    procedure UpdateButtons;
    procedure MoveLvwItem (SrcDirection : TSearchDirection); virtual;
    procedure AddLvwArticle (ObjTrans : TObjTransaction); virtual;
    procedure AddPayment (ObjTrans : TObjTransaction); virtual;
    procedure UpdateLvwArticle (LvwItmArticle : TListItem;
                                ObjTrans      : TObjTransaction); virtual;
    procedure AddLvwFiscalInfo; virtual;
    procedure BuildInvoiceBodyPart; virtual;
    procedure BuildInvoiceTotalPart; virtual;
    procedure BuildInvoicePaymentPart; virtual;
    procedure FillTicketFromEJ; virtual;
  public
    procedure PrepareFormDependJob; override;

    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property ObjTransaction : TObjTransaction read FObjTransaction
                                              write FObjTransaction;
    property CurrTransTicket : TObjTransTicket read FCurrTransTicket
                                               write FCurrTransTicket;
    property LstPaymethodes : TList read FLstPaymethodes
                                    write FLstPaymethodes;
    property LstPrevPaymethodes : TList read FLstPrevPaymethodes
                                        write FLstPrevPaymethodes;
    property NumTotal : Currency read FNumTotal
                                 write FNumTotal;
    property FlgFiscal: Boolean read FFlgFiscal
                               write FFlgFiscal;
    property FlgFiscalInfo: Boolean read FFlgFiscalInfo
                                   write FFlgFiscalInfo;
    property FlgRussia: Boolean read FFlgRussia
                               write FFlgRussia;
    property FlgItaly: Boolean read FFlgItaly
                               write FFlgItaly;
    property IdtDepartment: integer read FIdtDepartment
                                   write FIdtDepartment;
    property FlgPricing: Boolean read FFlgPricing
                                  write FFlgPricing;
    property FlgPosJournal: Boolean read FFlgPosJournal
                                   write FFlgPosJournal;
    property IdtPosTransaction : Integer read FIdtPosTransaction
                                        write FIdtPosTransaction;
    property IdtCheckout : Integer read FIdtCheckout
                                  write FIdtCheckout;
    property CodTrans : Integer read FCodTrans
                               write FCodTrans;
    property DatTransBegin : TDateTime read FDatTransBegin
                                      write FDatTransBegin;
    property IdtCustomer : integer read FIdtCustomer
                                  write FIdtCustomer;
    property CodCreator : integer read FCodCreator
                                  write FCodCreator;
    property IdtOrigInvoice: integer read FIdtOrigInvoice write FIdtOrigInvoice;
    property TxtFiscalInfo: string read FTxtFiscalInfo write FTxtFiscalInfo;
  end; // of TFrmDetManInvoiceCA

var
  FrmDetManInvoiceCA: TFrmDetManInvoiceCA;
  CIFNConfig            : string = '\FlexPos\Ini\FPSSyst.Ini';                       //R2012.1 Address De Facturation(SM)

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,

  ScTskMgr_BDE_DBC,

  DFpnUtils,
  DFpnArticle,
  DFpnCustomer,
  DFpnAddress,
  DFpnArtPrice,
  DFpnPosTransaction,
  DFpnInvoice,
  DFpnClassification,
  DFpnCampaign,
  SmDBUtil_BDE,
  FVSRptInvoiceCA,
  DFpnInvoiceCA,
  DFpnPosTransActionCA,
  DFpnDepartment,
  DFpnWorkStatCA,
  FVSRptInvoice,
  FVWPosJournalCA,
  UFpsSyst,                           //R2012.1 Address De Facturation (SM) 
  DFpnCustomerCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetManInvoiceCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetManInvoiceCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.6 $';
  CtTxtSrcDate    = '$Date: 2009/09/21 13:58:36 $';

//*****************************************************************************
// Implementation of TFrmDetManInvoiceCA
//*****************************************************************************

procedure TFrmDetManInvoiceCA.PrepareFormDependJob;
begin  // of TFrmDetManInvoiceCA.PrepareFormDependJob
  // If no Customer is selected.  You always have to select one first.
  if CurrTransTicket.IdtCustomer = 0 then
    DisableParentChildCtls (PnlButtons)
  else
    EnableParentChildCtls (PnlButtons);
end;   // of TFrmDetManInvoiceCA.PrepareFormDependJob

//=============================================================================

constructor TFrmDetManInvoiceCA.Create (AOwner : TComponent);
begin  // of TFrmDetManInvoiceCA.Create
  inherited;

  LstPaymethodes := TList.Create;
  LstPrevPaymethodes := TList.Create;
  FillPaymentsMethodes;
end;   // of TFrmDetManInvoiceCA.Create

//=============================================================================

destructor TFrmDetManInvoiceCA.Destroy;
begin  // of TFrmDetManInvoiceCA.Destroy
  LstPaymethodes.Free;
  LstPaymethodes := nil;
  LstPrevPaymethodes.Free;
  LstPrevPaymethodes := nil;

  inherited;
end;   // of TFrmDetManInvoiceCA.Destroy

//=============================================================================
// TFrmDetManInvoiceCA.PrepareSprLstClassification : Fill in the needed
// parameters to of the store proc 'SprLstClassification'
//=============================================================================

procedure TFrmDetManInvoiceCA.PrepareSprLstClassification;
begin  // of TFrmDetManInvoiceCA.PrepareSprLstClassification
  DmdFpnClassification.SprLstClassification.ParamByName
    ('@PrmTxtArrFields').AsString :=
                'Classification.IdtClassification;CodLevel;CodLevelAsTxtShort;'+
                'IdtUpLevel;TxtPublDescr;CodType;CodTypeAsTxtShort;IdtMember;';
  DmdFpnClassification.SprLstClassification.ParamByName
    ('@PrmTxtSequence').AsString := 'CodLevel';
  DmdFpnClassification.SprLstClassification.ParamByName
    ('@PrmTxtFrom').AsString := '3';
  DmdFpnClassification.SprLstClassification.ParamByName
    ('@PrmTxtTo').AsString := '3';
  DmdFpnClassification.SprLstClassification.ParamByName
    ('@PrmIdtTradeMatrix').AsString := DmdFpnUtils.IdtTradeMatrixAssort;
  DmdFpnClassification.SprLstClassification.ParamByName
    ('@PrmIdtLanguage').AsString := DmdFpnUtils.IdtLanguageTradeMatrix;
  DmdFpnClassification.SprLstClassification.ParamByName
    ('@PrmTxtCondition').AsString :=
                                 'CodType = ' + IntToStr(CtCodClassTypeFinance);
  // CtCodClassTypeTurnOver);
  DmdFpnClassification.SprLstClassification.ParamByName
    ('@PrmCodLevel').AsInteger := 3;
  DmdFpnClassification.SprLstClassification.Prepare;
end;   // of TFrmDetManInvoiceCA.PrepareSprLstClassification

//=============================================================================
// TFrmDetManInvoiceCA.ClearCustomerCaption : Clears all customer information
// on the form
//=============================================================================

procedure TFrmDetManInvoiceCA.ClearCustomerCaption;
begin  // of TFrmDetManInvoiceCA.ClearCustomerCaption
  SvcLFCustomerNumber.AsString := '';
  SvcMECustomerName.Text := '';

  LblVatNumber.Caption := '';
  LblStreet.Caption := '';
  LblZipCode.Caption := '';
  LblMunicipality.Caption := '';

  LblInvoiceStreet.Caption := '';
  LblInvoiceZipCode.Caption := '';
  LblInvoiceMunicipality.Caption :='';
end;   // of TFrmDetManInvoiceCA.ClearCustomerCaption

//=============================================================================
// TFrmDetManInvoiceCA.GetNormalPrice : Returns the normal selling price for a
// given article.
//                             ------------------
// Input   : - IdtArticle   : Identification of the article to search the
//                            price for.
//           - IdtCustomer  : Ident. of the customer.
//                             ------------------
// Output  : - NumPrcNormal : Normal saling price of the given article
//           - NumPrcPromo  : Promotion price of the given article
//=============================================================================

procedure TFrmDetManInvoiceCA.GetSalePrices (    IdtArticle   : string  ;
                                                 IdtCustomer  : Integer ;
                                             var NumPrcNormal : Currency;
                                             var NumPrcPromo  : Currency;
                                             var TxtCampDescr : string  );
var
  IdtCampaign      : string;           // Ident of the campaign
  IdtArtPrcProm    : Integer;          // Ident of the ArtPrice
begin  // of TFrmDetManInvoiceCA.GetSalePrices
  try

    DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmIdtArticle').AsString :=
      IdtArticle;
    DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmCodType').AsInteger :=
      CtCodPrcCustomer;
    DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmIdtType').AsInteger :=
      IdtCustomer;
    DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmDatValid').AsDateTime := Now;
    DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmIdtCurrLocal').AsString :=
      DmdFpnUtils.IdtCurrencyLocal;
    DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmIdtCurrMain').AsString :=
      DmdFpnUtils.IdtCurrencyMain;
    DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmValExchange').AsCurrency :=
      DmdFpnUtils.ValExchangeCurrencyMain;
    DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmFlgExchMultiply').AsInteger :=
       StrToInt (BoolToStr (DmdFpnUtils.FlgExchMultiplyCurrencyMain, '9'));
    DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmQtyDecim').AsInteger :=
      DmdFpnUtils.QtyDecimCurrencyMain;
    DmdFpnArtPrice.SprPrcArtDay.Prepare;
    DmdFpnArtPrice.SprPrcArtDay.ExecProc;

    // Getting the prices of the given articles
    NumPrcNormal :=
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmPrcUnNorm').AsCurrency;
    NumPrcPromo :=
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmPrcUnProm').AsCurrency;

    // if there's a campaign, find the discription of the campaign
    if NumPrcPromo <> 0 then begin
      IdtArtPrcProm :=
        DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmIdtArtPrcProm').AsInteger;

      // Getting the Idt in ArtPrice.
      TxtCampDescr := '';
      try
        if DmdFpnUtils.QueryInfo
          ('SELECT IdtCampaign FROM ArtPrice WHERE IdtArtPrice =' +
                                            IntToStr (IdtArtPrcProm)) then begin
          IdtCampaign :=
                       DmdFpnUtils.QryInfo.FieldByName ('IdtCampaign').AsString;
        end;
      finally
        DmdFpnUtils.CloseInfo;
      end;
      TxtCampDescr := CtTxtPromo +
                      DmdFpnCampaign.InfoCampaign [IdtCampaign, 'TxtPublDescr'];
    end;
  finally
    DmdFpnArtPrice.SprPrcArtDay.UnPrepare;
    DmdFpnArtPrice.SprPrcArtDay.Close;
  end;
end;   // of TFrmDetManInvoiceCA.GetSalePrices

//=============================================================================
// TFrmDetManInvoiceCA.GetTotalToPay : Get the total amount of all articles
// to pay.
//                               ---------------
// FuncRes : Returns the total amount to pay.
//=============================================================================

function TFrmDetManInvoiceCA.GetTotalToPay : Currency;
var
  CntItems         : Integer;          // Loop all items in the list
begin  // of TFrmDetManInvoiceCA.GetTotalToPay
  Result := 0;
  // Calculate the total of all lines
  for CntItems := 0 to Pred (LvwArticles.Items.Count) do begin
    if Assigned (LvwArticles.Items[CntItems].Data) then
      Result := Result +
        TObjTransaction(LvwArticles.Items[CntItems].Data).ValInclVAT -
        TObjTransaction(LvwArticles.Items[CntItems].Data).ValDiscInclVAT;
  end;
end;   // of TFrmDetManInvoiceCA.GetTotalToPay

//=============================================================================
// TFrmDetManInvoiceCA.GetTotalPayed : Calculate the total amount already payed
//                               ---------------
// FuncRes : Returns the total amount payed.
//=============================================================================

function TFrmDetManInvoiceCA.GetTotalPayed : Currency;
var
  CntItems         : Integer;          // Loop all items in the list
begin  // of TFrmDetManInvoiceCA.GetTotalPayed
  Result := 0;
  // Calculate what's already payed
  for CntItems := 0 to Pred (LstPaymethodes.Count) do
    Result := Result + TObjTransPayment(LstPaymethodes[CntItems]).PrcAdmInclVAT;
end;   // of TFrmDetManInvoiceCA.GetTotalPayed

//=============================================================================
// TFrmDetManInvoiceCA.GetCodAction : Returns a Codaction depend the IdtSubDiv
// in a given memory block.
//                               --------------------
// Input : PActietabelBegin : Beginpointer to the memory block that contains
//                            the actions
//         IdtMember        : Identification of the subdivision to search.
//                               --------------------
// FuncRes : Returns the found CodAction.  If nothing is found -1 is returned.
//=============================================================================

function TFrmDetManInvoiceCA.GetCodAction (PActietabelBegin : TGegActPtr;
                                           IdtMember        : Integer   ) :
                                                                        Integer;
var
  PActietabel      : TGegActPtr;       // Pointer to entry in table 'Actions'
begin  // of TFrmDetManInvoiceCA.GetCodAction
  Result := -1;
  PActietabel := PActietabelBegin;
  repeat
    if (PActietabel^.SubdivNr = IdtMember) and
       (PActietabel^.Scankd <> 0) then begin
      Result := PActietabel^.Actiekd;
      Break;
    end;
    Inc (PActietabel);
  until PActietabel^.Actiekd = 0;
end;   // of TFrmDetManInvoiceCA.GetCodAction

//=============================================================================
// TFrmDetManInvoiceCA.GetIdtClassOfAction : Search the Classification of the
// given Codaction.
//                               ---------------
// Input : PActietabelBegin : Pointer the first record in memory that stores
//                            the 'Action' information
//         CodAction        : Identification of the action to search for.
//                               ---------------
// FuncRes : Identification of the Classification.
//=============================================================================

function TFrmDetManInvoiceCA.GetIdtClassOfAction
                                        (PActietabelBegin : TGegActPtr;
                                         CodAction        : Integer   ): string;
var
  PActietabel      : TGegActPtr;       // Pointer to entry in table 'Actions'
begin  // of TFrmDetManInvoiceCA.GetIdtClassOfAction
  Result := '';
  PActietabel := PActietabelBegin;
  repeat
    if (PActietabel^.Actiekd = CodAction) and
       (PActietabel^.Scankd <> 0) then begin

      try
        if DmdFpnUtils.QueryInfo
            (#10'SELECT IdtClassification FROM Classification' +
             #10' WHERE IdtMember = ' + IntToStr (PActietabel^.SubdivNr))
                                                                      then begin
          Result := DmdFpnUtils.QryInfo.FieldByName
                                                 ('IdtClassification').AsString;
          Break;
        end;
      finally
        DmdFpnUtils.CloseInfo;
      end;
    end;
    Inc (PActietabel);
  until PActietabel^.Actiekd = 0;
end;   // of TFrmDetManInvoiceCA.GetIdtClassOfAction

//=============================================================================
// TFrmDetManInvoiceCA.FillCustomerCaption : Fill the captions on the form
// with information of the given IdtCustomer,
//                               --------------------
// Input : IdtCustomer : Ident. of the customer
//=============================================================================

procedure TFrmDetManInvoiceCA.FillCustomerCaption (IdtCustomer : Integer;
                                                   CodCreator  : Integer);
var
  FlgVATCodeFound  : Boolean;          // VAT code is found
  TxtCustName      : string;           // Name of the customer
begin  // of TFrmDetManInvoiceCA.FillCustomerCaption
  FlgVATCodeFound := False;
  ClearCustomerCaption;

  if IdtCustomer = 0 then
    Exit;

  // If you're sure about the customer, you can change it anyway.  In case the
  // name isn't found, just exit.  The use can retry an other idtcustomer
  try
    TxtCustName := DmdFpnCustomerCA.InfoCustomer[IdtCustomer,CodCreator,'TxtPublName'];
    if not FlgPosJournal then begin
      if MessageDlg (Format (CtTxtSureSelectCust, [TxtCustName,
                                                   IntToStr(IdtCustomer)]),
                     mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Exit;
    end;
  except
    Exit;
  end;
  try
    SvcLFCustomerNumber.AsString := IntToStr (IdtCustomer);
    SvcMECustomerName.Text := TxtCustName;
    SvcLFCustDiscount.AsFloat := DmdFpnCustomerCA.InfoCustomer [IdtCustomer,
                                                                CodCreator,
                                                               'PctDiscount'];
    LblVatNumber.Caption := DmdFpnCustomerCA.InfoCustomer [IdtCustomer,
                                                           CodCreator,
                                                           'TxtNumVAT'];
    // Fill object information
    CurrTransTicket.IdtCustomer := IdtCustomer;
    TObjTransTicketCA(CurrTransTicket).CodCreator := CodCreator;
    FlgVATCodeFound := True;
  except
  end;

  // Getting general customer information
  try
  if FlgFrance then begin
    LblStreet.Caption :=                                                                 // R2012.1 Invoice Address Management :: START
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                              202, 'TxtStreet'];
    LblZipCode.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                            202, 'TxtCodPost'];
    LblMunicipality.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                            202, 'TxtMunicip'];                       // R2012.1 Invoice Address Management :: END
  end
  else begin
  LblStreet.Caption :=                                                                 // R2012.1 Invoice Address Management :: START
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                              CtCodAddressCommon, 'TxtStreet'];
    LblZipCode.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                            CtCodAddressCommon, 'TxtCodPost'];
    LblMunicipality.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                            CtCodAddressCommon, 'TxtMunicip'];        // R2012.1 Invoice Address Management :: END
  end;
  except
  end;

  // Getting customer Invoice information
  try
    if FlgFrance then begin
    LblInvoiceStreet.Caption :=                                                                 // R2012.1 Invoice Address Management :: START
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                              203, 'TxtStreet'];
    LblInvoiceZipCode.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                            203, 'TxtCodPost'];
    LblInvoiceMunicipality.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                            203, 'TxtMunicip'];                       // R2012.1 Invoice Address Management :: END
  end
  else begin
  LblInvoiceStreet.Caption :=                                                                 // R2012.1 Invoice Address Management :: START
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                             CtCodAddressCustInv, 'TxtStreet'];
    LblInvoiceZipCode.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                              CtCodAddressCustInv, 'TxtCodPost'];
    LblInvoiceMunicipality.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                            CtCodAddressCustInv, 'TxtMunicip'];        // R2012.1 Invoice Address Management :: END
  end;
  except
  end;

  // If a customer is selected, the invoice lines can be inserted.
  // But you can't change the customer information anymore
  if FlgVATCodeFound then begin
    DisableParentChildCtls (PnlInfo);
    EnableParentChildCtls (PnlButtons);
    UpdateButtons;
  end;
end;   // of TFrmDetManInvoiceCA.FillCustomerCaption

//=============================================================================
// TFrmDetManInvoiceCA.FillArticleInfoInObj : Fills the object with information
// depend on the idtarticle that is given.
//                             ------------------
// Input : IdtArticle : Identification of the article to search
//=============================================================================

procedure TFrmDetManInvoiceCA.FillArticleInfoInObj (IdtArticle : string);
var
  NumPrcNormal     : Currency;         // Normal salingprice of article
  NumPrcPromo      : Currency;         // Promoprice of article
  TxtDescrProm     : string;           // Description of the promotion 
begin  // of TFrmDetManInvoiceCA.FillArticleInfoInObj
  // Get article information.
  ObjTransaction.Clear;

  // Default article info
  ObjTransaction.QtyArt := 1;

  // General Article info
  ObjTransaction.CodActTurnOver := CtCodActPLUNum;
  ObjTransaction.IdtArticle := IdtArticle;
  ObjTransaction.NumPLU := DmdFpnArticle.InfoArticleMainPLU [IdtArticle,
                                                             'NumPLU'];
  ObjTransaction.TxtDescrTurnOver := DmdFpnArticle.InfoArticle [IdtArticle,
                                                                'TxtPublDescr'];

  // Get classification to calculate on.
  ObjTransaction.IdtClassification := DmdFpnArticle.InfoArtAssort
                                              [IdtArticle,
                                               DmdFpnUtils.IdtTradeMatrixAssort,
                                               'IdtClassification'];
  ObjTransaction.PctVATCode :=
      DmdFpnArticle.InfoArtAssort [IdtArticle, DmdFpnUtils.IdtTradeMatrixAssort,
                                   'PctVAT'];
  ObjTransaction.IdtVATCode :=
      DmdFpnArticle.InfoArtAssort [IdtArticle, DmdFpnUtils.IdtTradeMatrixAssort,
                                   'IdtVATCode'];

  // Get Prices Excl. VAT
  NumPrcNormal := 0;
  NumPrcPromo  := 0;
  GetSalePrices (IdtArticle, CurrTransTicket.IdtCustomer,
                 NumPrcNormal, NumPrcPromo, TxtDescrProm);

  ObjTransaction.PrcInclVAT := NumPrcNormal;
  ObjTransaction.PrcPromInclVAT := NumPrcPromo;
  ObjTransaction.TxtDescrProm := TxtDescrProm;

  // Get Prices Incl. VAT
  ObjTransaction.PrcExclVAT := NumPrcNormal * 100 /
                            (ObjTransaction.PctVATCode + 100);
  ObjTransaction.PrcPromExclVAT := NumPrcPromo * 100 /
                                (ObjTransaction.PctVATCode + 100);

  // If there's a Customer Discount, take the Customer Discount.
  // Also set the type of discount
  if Abs (SvcLFCustDiscount.AsFloat) < CtValMinFloat then
    ObjTransaction.CodActDisc := CtCodActDiscArtPct
  else begin
    ObjTransaction.CodActDisc := CtCodActDiscCust;
    ObjTransaction.PctDisc := SvcLFCustDiscount.AsFloat;
  end;
end;   // of TFrmDetManInvoiceCA.FillArticleInfoInObj

//=============================================================================
// TFrmDetManInvoiceCA.FillPaymentsMethodes : Get all the payment-types out of
// the DB and put it in objects.
//                            -------------------
// Remark :
//     Only if there's a codaction found for the given classification,
//     put it in the list of payments.  This is needed because (if there isn't
//     a codaction) you can't save it correctly in the database.
//=============================================================================

procedure TFrmDetManInvoiceCA.FillPaymentsMethodes;
var
  IniFile              : TIniFile;          // IniObject to the INI-file
  ObjTransPayment     : TObjTransPayment;   // Paymenttypes
  ObjPrevTransPayment : TObjTransPayment;   // Paymenttypes
  TxtPath             : String;             // Path of the ini-file
  NumPaymentMethods   : Integer;            // Number of payment methods
  NumCounter          : Integer;            // Counter used for loop
//  NumCodActionFound : Integer;          // Codaction found for classification
//  PActietabelBegin  : TGegActPtr;       // Pointer to 1e entry in table 'Actions'
begin  // of TFrmDetManInvoiceCA.FillPaymentsMethodes
  TxtPath := ReplaceEnvVar ('%SycRoot%\FlexPoint\Ini\PaymentMethod.INI');
  IniFile := nil;
  OpenIniFile(TxtPath, IniFile);
  NumPaymentMethods := StrToInt(IniFile.ReadString('General', 'Items', ''));
  for NumCounter := 1 to NumPaymentMethods do begin
    if IniFile.ValueExists('PaymentMethod'+IntToStr(NumCounter),
                           'IdtClassification') then begin
      try
    ObjTransPayment := TObjTransPayment.Create;
    ObjPrevTransPayment := TObjTransPayment.Create;
    ObjTransPayment.IdtAdmClassi :=
         IniFile.ReadString('PaymentMethod'+IntToStr(NumCounter),
         'IdtClassification', '');
    ObjPrevTransPayment.IdtAdmClassi := ObjTransPayment.IdtAdmClassi;
    DmdFpnUtils.CloseInfo;
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.QueryInfo
      ('SELECT TxtPublDescr' +
       #10'FROM Classification' +
       #10'WHERE IdtClassification =' +
       AnsiQuotedStr (ObjTransPayment.IdtAdmClassi, ''''));
    ObjTransPayment.TxtDescrAdm :=
         DmdFpnUtils.QryInfo.FieldByName ('TxtPublDescr').AsString;
    DmdFpnUtils.ClearQryInfo;         
    ObjPrevTransPayment.TxtDescrAdm := ObjTransPayment.TxtDescrAdm;
    ObjTransPayment.CodActAdm :=
         StrToInt(IniFile.ReadString('PaymentMethod'+IntToStr(NumCounter),
         'CodAction', ''));
    ObjPrevTransPayment.CodActAdm := ObjTransPayment.CodActAdm;
    ObjTransPayment.PrcAdmInclVAT := 0;
    ObjPrevTransPayment.PrcAdmInclVAT := ObjTransPayment.PrcAdmInclVAT;
    ObjTransPayment.ValAdmInclVAT := 0;
    ObjPrevTransPayment.ValAdmInclVAT := ObjTransPayment.ValAdmInclVAT;

    // Add the object to the rest of the list.
    LstPaymethodes.Add (ObjTransPayment);
    LstPrevPaymethodes.Add(ObjPrevTransPayment);
      finally
        DmdFpnUtils.CloseInfo;
      end;
    end;        
  end;
end;   // of TFrmDetManInvoiceCA.FillPaymentsMethodes

//=============================================================================
// TFrmDetManInvoiceCA.FillTotalsInvoice : Calculate the totals of the invoice
// and put the results on the screen.
//=============================================================================

procedure TFrmDetManInvoiceCA.FillTotalsInvoice;
var
  NumTotalAmount   : Currency;         // Total amount to pay.
  NumTotalToPay    : Currency;         // Total to pay.
  NumTotalPayed    : Currency;         // Total payed.
  NumTotalInvoice  : Currency;         // Total invoice.
  NumTotalDispMin  : Currency;         // Disposit Min
  NumTotalDispPlus : Currency;         // Disposit Plus
begin  // of TFrmDetManInvoiceCA.FillTotalsInvoice
  NumTotalAmount   := GetTotalToPay;
  NumTotal         := NumTotalAmount;
  NumTotalPayed    := GetTotalPayed;
  NumTotalDispMin  := 0;
  NumTotalDispPlus := 0;

  NumTotalInvoice := NumTotalAmount + NumTotalDispPlus + NumTotalDispMin;

  // Calc the total to pay.
  NumTotalToPay := NumTotalInvoice - NumTotalPayed;


  LblTotalAmount.Caption := CurrToStrF (NumTotalAmount, ffFixed,
                                        DmdFpnUtils.QtyDecsPrice);
  LblTotalDispositPlus.Caption := CurrToStrF (NumTotalDispPlus, ffFixed,
                                              DmdFpnUtils.QtyDecsPrice);
  LblTotalDispositMin.Caption := CurrToStrF (NumTotalDispMin, ffFixed,
                                             DmdFpnUtils.QtyDecsPrice);
  LblTotalInvoice.Caption := CurrToStrF (NumTotalInvoice, ffFixed,
                                         DmdFpnUtils.QtyDecsPrice);
  LblTotalPaid.Caption := CurrToStrF (NumTotalPayed, ffFixed,
                                      DmdFpnUtils.QtyDecsPrice);
  LblTotalToPay.Caption := CurrToStrF (- NumTotalToPay, ffFixed,
                                       DmdFpnUtils.QtyDecsPrice);

  LblCurrTotalAmount.Caption  := DmdFpnUtils.IdtCurrencyMain;
  LblCurrDispositPlus.Caption := DmdFpnUtils.IdtCurrencyMain;
  LblCurrDispositMin.Caption  := DmdFpnUtils.IdtCurrencyMain;
  LblCurrTotalInvoice.Caption := DmdFpnUtils.IdtCurrencyMain;
  LblCurrTotalPaid.Caption   := DmdFpnUtils.IdtCurrencyMain;
  LblCurrTotalToPay.Caption   := DmdFpnUtils.IdtCurrencyMain;

  if NumTotalToPay > 0 then
    DisableControl (BtnOK)
  else
    EnableControl (BtnOK)
end;   // of TFrmDetManInvoiceCA.FillTotalsInvoice

//=============================================================================
// TFrmDetManInvoiceCA.SetLvwArticleImage : Put a image in from the list to
// make it visible what kind of line it is.
//=============================================================================

procedure TFrmDetManInvoiceCA.SetLvwArticleImage
                                              (LvwItmArticle : TListItem;
                                               ObjTrans      : TObjTransaction);
begin  // of TFrmDetManInvoiceCA.SetLvwArticleImage
  if ObjTrans.CodActFree <> 0 then
    LvwItmArticle.ImageIndex := 3
  else if ObjTrans.PrcPromInclVAT <> 0 then
    LvwItmArticle.ImageIndex := 1
  else if ObjTrans.CodActComment = CtCodActComment then
    LvwItmArticle.ImageIndex := 2
  else LvwItmArticle.ImageIndex := 0;

end;   // of TFrmDetManInvoiceCA.SetLvwArticleImage

//=============================================================================
// TFrmDetManInvoiceCA.UpdateButtons : To make it more user friendly, we will
// disable/enable the 'BtnEdit', 'BtnDelete', 'BtnUp' and 'BtnDown' depending
// the status of the items in de listview 'LvwArticle'.
//=============================================================================

procedure TFrmDetManInvoiceCA.UpdateButtons;
begin  // of TFrmDetManInvoiceCA.UpdateButtons
  LockWindowUpdate (PnlButtons.Handle);
  try
    DisableControl (BtnEdit);
    DisableControl (BtnDelete);
    DisableControl (BtnUp);
    DisableControl (BtnDown);

    if LvwArticles.Selected <> nil then begin
      EnableControl (BtnEdit);
      EnableControl (BtnDelete);
      if LvwArticles.Selected.Index > 0 then
        EnableControl (BtnUp);

      if LvwArticles.Selected.Index < Pred (LvwArticles.Items.Count) then
        EnableControl (BtnDown);
    end;
  finally
    LockWindowUpdate (0);
  end;
end;   // of TFrmDetManInvoiceCA.UpdateButtons

//=============================================================================
// TFrmDetManInvoiceCA.MoveLvwItem : Move the selected item in a listview in
// a given direction.
//                             ------------------
// Input : SrcDirection : Direction to move to.
//=============================================================================

procedure TFrmDetManInvoiceCA.MoveLvwItem (SrcDirection : TSearchDirection);
var
  LvwTempItemSource     : TListItem;        // Temperary Listview Source Item
  LvwTempItemNext       : TListItem;        // Temperary Listview Next Item
  LvwTempItemDest       : TListItem;        // Temperary Listview Dest Item
begin  // of TFrmDetManInvoiceCA.MoveLvwItem
  LvwTempItemNext := LvwArticles.GetNextItem
      (LvwArticles.Selected, SrcDirection, [isNone]);
  if not Assigned (LvwTempItemNext) then
    Exit;

  LockWindowUpdate (LvwArticles.Handle);
  try
    LvwTempItemSource := LvwArticles.Selected;
    if SrcDirection = sdBelow then
      LvwTempItemDest := LvwArticles.Items.Insert (LvwTempItemNext.Index + 1)
    else
      LvwTempItemDest := LvwArticles.Items.Insert (LvwTempItemNext.Index);
    LvwTempItemDest.Assign (LvwTempItemSource);
    LvwTempItemSource.Free;

    // Select the moved item. This makes it possible to move this item a second
    // time without selecting it a second time.
    LvwTempItemDest.Selected := True;
    LvwTempItemDest.Focused := True;
    LvwArticles.SetFocus;

    // This line is for a problem in delphi that shows the checkboxes
    // automatically after assigning items
    LvwArticles.Checkboxes := False;
  finally
    LockWindowUpdate (0);
  end;
end;   // of TFrmDetManInvoiceCA.MoveLvwItem

//=============================================================================
// TFrmDetManInvoiceCA.AddLvwArticle : Add a Listitem to the Listview and
// fill it with the given information.
//                              ---------------
// Input : ObjTrans : Object that contains the information of the article
//=============================================================================

procedure TFrmDetManInvoiceCA.AddLvwArticle (ObjTrans : TObjTransaction);
var
  LvwItmArticle    : TListItem;        // New listitem
  CntSubItems      : Integer;          // Loop to build all needed subitems.
begin  // of TFrmDetManInvoiceCA.AddLvwArticle
  LvwItmArticle := LvwArticles.Items.Add;
  for CntSubItems := 0 to 6 do
    LvwItmArticle.SubItems.Add ('');

  UpdateLvwArticle(LvwItmArticle, ObjTrans);
end;   // of TFrmDetManInvoiceCA.AddLvwArticle

//=============================================================================
// TFrmDetManInvoiceCA.UpdateLvwArticle : Fill in the given listitem dependent
// on the data in the given ObjTransaction.
//                             ------------------
// Input : LvwItmArticle : Item in the Listview that must be updated.
//         ObjTransaction: Object that contains the data to fill in the
//                         listitem
//=============================================================================

procedure TFrmDetManInvoiceCA.UpdateLvwArticle(LvwItmArticle : TListItem;
                                               ObjTrans      : TObjTransaction);
begin  // of TFrmDetManInvoiceCA.UpdateLvwArticle
  // In case ObjTrans.TxtDescrTurnOver is filled is a normal line.
  if AnsiCompareText (ObjTrans.TxtDescrTurnOver, '') <> 0 then begin
    LvwItmArticle.Data := ObjTrans;
    LvwItmArticle.Caption := ObjTrans.TxtDescrTurnOver;
    LvwItmArticle.SubItems[0] := CurrToStrF (ObjTrans.QtyArt, ffFixed,
                                             DmdFpnUtils.QtyDecsPrice);
    LvwItmArticle.SubItems[1] := CurrToStrF (ObjTrans.PrcExclVAT, ffFixed,
                                             DmdFpnUtils.QtyDecsPrice);

    // Don't print the promoprice if it's 0
    if ObjTrans.PrcPromExclVAT = 0 then
      LvwItmArticle.SubItems[2] := ''
    else
      LvwItmArticle.SubItems[2] := CurrToStrF (ObjTrans.PrcPromExclVAT, ffFixed,
                                               DmdFpnUtils.QtyDecsPrice);

    // Don't print the % discount if it's 0
    if ObjTrans.PctDisc = 0 then
      LvwItmArticle.SubItems[3] := ''
    else
      LvwItmArticle.SubItems[3] := CurrToStrF (ObjTrans.PctDisc, ffFixed,
                                               DmdFpnUtils.QtyDecsPrice);

    // Procent VAT
    LvwItmArticle.SubItems[4] := CurrToStrF (ObjTrans.PctVATCode, ffFixed,
                                             DmdFpnUtils.QtyDecsPrice);
    if (ObjTrans.QtyArt < 0) and (ObjTrans.ValPromInclVAT = 0) then begin
      LvwItmArticle.SubItems[5] :=
          CurrToStrF (ObjTrans.ValInclVAT - ObjTrans.ValDiscInclVAT,
                      ffFixed, DmdFpnUtils.QtyDecsPrice);
    end
    else begin
      if FlgPosJournal and (ObjTrans.ValPromInclVAT <> 0) then
        ObjTrans.ValInclVAT := ObjTrans.ValPromInclVAT;
      LvwItmArticle.SubItems[5] :=
          CurrToStrF (ObjTrans.ValInclVAT - ObjTrans.ValDiscInclVAT,
                      ffFixed, DmdFpnUtils.QtyDecsPrice);
    end;
    FillTotalsInvoice;
  end
  // In case ObjTrans.TxtDescrComment is filled is a comment line.
  else if AnsiCompareText (ObjTrans.TxtDescrComment, '') <> 0 then begin
    LvwItmArticle.Data := ObjTrans;
    LvwItmArticle.Caption := ObjTrans.TxtDescrComment;
  end;
  SetLvwArticleImage(LvwItmArticle, ObjTrans);
  UpdateButtons;
end;   // of TFrmDetManInvoiceCA.UpdateLvwArticle

//=============================================================================
// TFrmDetManInvoiceCA.BuildInvoiceBodyPart : Put all the 'body' POSTransaction
// in the global list.
//=============================================================================

procedure TFrmDetManInvoiceCA.BuildInvoiceBodyPart;
var
  CntItems         : Integer;          // Loop all items in the list
begin  // of TFrmDetManInvoiceCA.BuildInvoiceBodyPart
  for CntItems := 0 to Pred (LvwArticles.Items.Count) do begin
    CurrTransTicket.StrLstObjTransaction.AddObject
        ('', TObjTransaction (LvwArticles.Items[CntItems].Data));
  end;
end;   // of TFrmDetManInvoiceCA.BuildInvoiceBodyPart

//=============================================================================
// TFrmDetManInvoiceCA.BuildInvoiceTotalPart : Put all the 'total'
// POSTransaction in the global list.
//=============================================================================

procedure TFrmDetManInvoiceCA.BuildInvoiceTotalPart;
var
  ObjLocalTrans    : TObjTransaction;  // Local object to make up the total line
begin  // of TFrmDetManInvoiceCA.BuildInvoiceTotalPart
  // Build the total part.
  ObjLocalTrans := TObjTransaction.Create;
  ObjLocalTrans.CodMainAction := CtCodActTotal;
  ObjLocalTrans.ValInclVAT := GetTotalToPay;
  CurrTransTicket.StrLstObjTransaction.AddObject ('', ObjLocalTrans);
end;   // of TFrmDetManInvoiceCA.BuildInvoiceTotalPart

//=============================================================================
// TFrmDetManInvoiceCA.BuildInvoicePaymentPart : Put all the 'payments'
// POSTransaction in the global list.
//                             ----------------------
// Remark :
// To have the same output generated as FlexPOS, it is necessary to invers
// the sign of 'NumTotalReturn'.
//=============================================================================

procedure TFrmDetManInvoiceCA.BuildInvoicePaymentPart;
var
  CntItems         : Integer;          // Loop all items in the list
  ObjLocalTrans    : TObjTransaction;  // Local object to make up the total line
  NumTotalReturn   : Currency;         // Total amount to return to the customer

  PActietabelBegin : TGegActPtr;       // Pointer to 1e entry in table 'Actions'
begin  // of TFrmDetManInvoiceCA.BuildInvoicePaymentPart

  for CntItems := 0 to Pred (LstPaymethodes.Count) do begin
    // If there's payed with this currency, put it in the list.
    if Abs (TObjTransaction(LstPaymethodes [CntItems]).PrcAdmInclVAT) >=
                                                              CtValMinFloat then
      CurrTransTicket.StrLstObjTransaction.AddObject
                               ('', TObjTransaction(LstPaymethodes [CntItems]));
  end;


  // After all payments put a 'Return'-line if needed.
  // Register the amount of return on the Classification 'Cash';
  NumTotalReturn := GetTotalToPay - GetTotalPayed;
  if NumTotalReturn < 0 then begin
    try
      try
        InlezenActietabel (1, 0, PActietabelBegin);
      except
        try
          OpmakenActietabel (1, 0, PActietabelBegin);
        except
          on E:Exception do begin
            Application.ProcessMessages;
            Halt;
          end;
        end;
      end;

      ObjLocalTrans := TObjTransaction.Create;
      ObjLocalTrans.CodActAdm := CtCodActReturn;
      ObjLocalTrans.ValAdmInclVAT := NumTotalReturn;
      ObjLocalTrans.IdtAdmClassi := GetIdtClassOfAction (PActietabelBegin,
                                                         CtCodActCash);
      ObjLocalTrans.TxtDescrAdm := CtTxtReturn;
      CurrTransTicket.StrLstObjTransaction.AddObject ('', ObjLocalTrans);
    finally
      VrijgevenActietabel (PActietabelBegin);
    end;
  end;
end;   // of TFrmDetManInvoiceCA.BuildInvoicePaymentPart

//=============================================================================

procedure TFrmDetManInvoiceCA.FormCreate(Sender: TObject);
begin  // of TFrmDetManInvoiceCA.FormCreate
  inherited;
  // Create a POSTransaction of the Ticket and put it in the list of tickets
  CurrTransTicket := TObjTransTicketCA.Create;

  // Default values for the invoice
  DmdFpnInvoice.LstTickets.Clear;
  CurrTransTicket.IdtPOSTransaction := 0;
  CurrTransTicket.IdtCheckOut := 0;
  CurrTransTicket.CodTrans := CtCodPttInvoice;
  CurrTransTicket.DatTransBegin := Now;
  DmdFpnInvoice.LstTickets.Add (CurrTransTicket);
  CIFNConfig := ReplaceEnvVar ('%PrgROOT%') + CIFNConfig;                               //R2012.1 Address de facturation (SM)
  ReadIniFile;                                                                          //R2012.1 Address de facturation (SM)
// System Testing fix Address de facturation  ::START
  if FlgFrance then begin
   BvlGeneralInfo.Align:=alClient;
   BvlGeneralInfo.Height:=105;
   BvlGeneralInfo.Left:=344;
   BvlGeneralInfo.Top:=4;
   BvlGeneralInfo.Width:=321;
  end;
 // System Testing fix Address de facturation  ::END
end;   // of TFrmDetManInvoiceCA.FormCreate

//=============================================================================

procedure TFrmDetManInvoiceCA.FormActivate(Sender: TObject);
var
  FlgSucceeded     : Boolean;
begin  // of TFrmDetManInvoiceCA.FormActivate
  inherited;
  // Create a POSTransaction of the Ticket and put it in the list of tickets
  if assigned(CurrTransTicket) then
    CurrTransTicket.Destroy;
  CurrTransTicket := TObjTransTicketCA.Create;

  // Default values for the invoice
  DmdFpnInvoice.LstTickets.Clear;
  CurrTransTicket.IdtPOSTransaction := 0;
  CurrTransTicket.IdtCheckOut := 0;
  CurrTransTicket.CodTrans := CtCodPttInvoice;
  CurrTransTicket.DatTransBegin := Now;
  DmdFpnInvoice.LstTickets.Add (CurrTransTicket);
  if FlgPosJournal then begin
    IdtCustomer := FrmVWPosJournalCA.IdtCustomer;
    IdtOrigInvoice := FrmVWPosJournalCA.IdtOrigInvoice;
    IdtPOSTransaction := FrmVWPosJournalCA.DstLstTrans.
                                     FieldByName('IdtPosTransaction').AsInteger;
    IdtCheckOut := FrmVWPosJournalCA.DstLstTrans.FieldByName('IdtCheckout').
                                                                      AsInteger;
    CodTrans := FrmVWPosJournalCA.DstLstTrans.FieldByName('CodTrans').AsInteger;
    DatTransBegin := FrmVWPosJournalCA.DstLstTrans.FieldByName('DatTransBegin').
                                                                     AsDateTime;
    FlgFiscalInfo := FrmVWPosJournalCA.DstLstTrans.
                                     FieldByName('NumFiscalTicket').AsInteger>0;
  end;
  LblTotalAmount.Visible := False;
  LblTotalDispositPlus.Visible := False;
  LblTotalDispositMin.Visible := False;
  LblCurrTotalAmount.Visible := False;
  LblCurrDispositPlus.Visible := False;
  LblCurrDispositMin.Visible := False;
  LblVatNumber.Visible := False;
  LblStreet.Visible := False;
  LblZipCode.Visible := False;
  LblMunicipality.Visible := False;
  LblInvoiceStreet.Visible := False;
  LblInvoiceZipCode.Visible := False;
  LblInvoiceMunicipality.Visible := False;
  If FlgFiscal and not FlgFiscalInfo then begin
    FlgFiscalInfo := True;
    BtnComment.Click;
    if not FlgFiscalInfo then begin
      Application.Terminate;
      exit;
    end;
  end;
  FlgFiscalInfo := False;
  ClearCustomerCaption;
  // Ask for Department
  if DmdFpnDepartment.NumDepartments > 1 then begin
    FlgSucceeded := SvcTaskMgr.LaunchTask ('AskDepartment');
    if (IdtDepartment = 0) or (not FlgSucceeded) then begin
      Application.Terminate;
      exit;
    end;
  end;
  LblTotalAmount.Visible := True;
  LblTotalDispositPlus.Visible := True;
  LblTotalDispositMin.Visible := True;
  LblCurrTotalAmount.Visible := True;
  LblCurrDispositPlus.Visible := True;
  LblCurrDispositMin.Visible := True;
  LblVatNumber.Visible := True;
  LblStreet.Visible := True;
  LblZipCode.Visible := True;
  LblMunicipality.Visible := True;
  LblInvoiceStreet.Visible := True;
  LblInvoiceZipCode.Visible := True;
  LblInvoiceMunicipality.Visible := True;
  // Initialise information, clear customer information, totals, ...
  if FlgPosJournal then
    FillTicketFromEJ;
  FillTotalsInvoice;

  SvcLFDateInvoice.AsDateTime := Now;
  SvcLFCustomerNumber.Enabled := False;
  Self.Caption := Application.Title;
end;   // of TFrmDetManInvoiceCA.FormActivate

//=============================================================================

procedure TFrmDetManInvoiceCA.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  CntPayments      : integer;
begin  // of TFrmDetManInvoiceCA.FormClose
  inherited;
  LvwArticles.OnChange := nil;
  LvwArticles.Items.Clear;
  LvwArticles.OnChange := LvwArticlesChange;
  if not FlgPosJournal then begin
   IdtCustomer := 0;
   CodCreator := 0;
  end;
  for CntPayments := 0 to Pred (LstPaymethodes.Count) do begin
    TObjTransPayment(LstPaymethodes[CntPayments]).PrcAdmInclVAT := 0;
    TObjTransPayment(LstPaymethodes[CntPayments]).ValAdmInclVAT := 0;
    TObjTransPayment(LstPrevPaymethodes[CntPayments]).PrcAdmInclVAT := 0;
    TObjTransPayment(LstPrevPaymethodes[CntPayments]).ValAdmInclVAT := 0;
  end;
end;   // of TFrmDetManInvoiceCA.FormClose

//=============================================================================
procedure TFrmDetManInvoiceCA.BtnDeleteClick(Sender: TObject);
begin  // of TFrmDetManInvoiceCA.BtnDeleteClick
  inherited;
  if not Assigned (LvwArticles.Selected) then
    Exit;

  if MessageDlg (Format (CtTxtSureRemoveItem, [LvwArticles.Selected.Caption]),
                 mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    LvwArticles.Selected.Delete;
    FillTotalsInvoice;
    UpdateButtons;
  end;
end;   // of TFrmDetManInvoiceCA.BtnDeleteClick

//=============================================================================

procedure TFrmDetManInvoiceCA.BtnSelectArticleClick(Sender: TObject);
var
  FlgSucceeded     : Boolean;          // Is the detailform successfully
begin  // of TFrmDetManInvoiceCA.BtnSelectArticleClick
  inherited;

  StrLstIdtValues.Clear;
  if not SvcTaskMgr.LaunchTask ('ListArticle') then
    Exit;

  FlgSucceeded := False;
  ObjTransaction := TObjTransaction.Create;
  try
    FillArticleInfoInObj (StrLstIdtValues.Values['IdtArticle']);
    CodJob := CtCodJobRecNew;
    FlgSucceeded := SvcTaskMgr.LaunchTask ('DetManInvoiceArticle');
    if FlgSucceeded then
      AddLvwArticle (ObjTransaction);
  finally
    if not FlgSucceeded then begin
      ObjTransaction.Free;
      ObjTransaction := nil;
    end;
  end;
end;   // of TFrmDetManInvoiceCA.BtnSelectArticleClick

//=============================================================================

procedure TFrmDetManInvoiceCA.BtnManuelArticleClick(Sender: TObject);
var
  FlgSucceeded     : Boolean;          // Is the detailform successfully
begin  // of TFrmDetManInvoiceCA.BtnManuelArticleClick
  inherited;

  FlgSucceeded := False;
  ObjTransaction := TObjTransaction.Create;
  try
    CodJob := CtCodJobRecNew;
    ObjTransaction.QtyArt := 1;
    ObjTransaction.CodActTurnOver := CtCodActPLUNum;
    ObjTransaction.IdtVATCode := 0;

    // If there's a Customer Discount, take the Customer Discount.
    // Also set the type of discount
    if Abs (SvcLFCustDiscount.AsFloat) < CtValMinFloat then
      ObjTransaction.CodActDisc := CtCodActDiscArtPct
    else begin
      ObjTransaction.CodActDisc := CtCodActDiscCust;
      ObjTransaction.PctDisc := SvcLFCustDiscount.AsFloat;
    end;

    FlgSucceeded := SvcTaskMgr.LaunchTask ('DetManInvoiceArticle');
    if FlgSucceeded then
      AddLvwArticle (ObjTransaction);
  finally
    if not FlgSucceeded then begin
      ObjTransaction.Free;
      ObjTransaction := nil;
    end;
  end;
end;   // of TFrmDetManInvoiceCA.BtnManuelArticleClick

//=============================================================================

procedure TFrmDetManInvoiceCA.BtnEditClick(Sender: TObject);
begin  // of TFrmDetManInvoiceCA.BtnEditClick
  inherited;
  if not (Assigned (LvwArticles.Selected) and
      Assigned (LvwArticles.Selected.Data)) then
    Exit;

  CodJob := CtCodJobRecMod;
  ObjTransaction := TObjTransaction (LvwArticles.Selected.Data);

  // Examinate the object and launch the correct task.
  if AnsiCompareText (ObjTransaction.TxtDescrTurnOver, '') <> 0 then begin
    if not SvcTaskMgr.LaunchTask ('DetManInvoiceArticle') then
      Exit;
  end
  else if AnsiCompareText (ObjTransaction.TxtDescrComment, '') <> 0 then begin
    if not SvcTaskMgr.LaunchTask ('DetManInvoiceComment') then
      Exit;
  end;

  UpdateLvwArticle (LvwArticles.Selected, ObjTransaction);
end;   // of TFrmDetManInvoiceCA.BtnEditClick

//=============================================================================

procedure TFrmDetManInvoiceCA.BtnSelectCustomerClick(Sender: TObject);
var
  IdtCustomer      : Integer;          // Indentification of the customer.
begin  // of TFrmDetManInvoiceCA.BtnSelectCustomerClick
  inherited;
  StrLstIdtValues.Clear;
  if not SvcTaskMgr.LaunchTask ('ListCustomer') then
    Exit;

  // Get customer information.
  IdtCustomer := StrToInt (StrLstIdtValues.Values ['IdtCustomer']);
  CodCreator := StrToInt (StrLstIdtValues.Values ['CodCreator']);
  FillCustomerCaption (IdtCustomer, CodCreator);
end;   // of TFrmDetManInvoiceCA.BtnSelectCustomerClick

//=============================================================================

procedure TFrmDetManInvoiceCA.BtnUpClick(Sender: TObject);
begin  // of TFrmDetManInvoiceCA.BtnUpClick
  inherited;
  MoveLvwItem (sdAbove);
end;   // of TFrmDetManInvoiceCA.BtnUpClick

//=============================================================================

procedure TFrmDetManInvoiceCA.BtnDownClick(Sender: TObject);
begin  // of TFrmDetManInvoiceCA.BtnDownClick
  inherited;
  MoveLvwItem (sdBelow);
end;   // of TFrmDetManInvoiceCA.BtnDownClick

//=============================================================================

procedure TFrmDetManInvoiceCA.SvcLFCustomerNumberExit(Sender: TObject);
begin  // of TFrmDetManInvoiceCA.SvcLFCustomerNumberExit
  inherited;

  // Get customer information.
  FillCustomerCaption (SvcLFCustomerNumber.AsInteger);
end;   // of TFrmDetManInvoiceCA.SvcLFCustomerNumberExit

//=============================================================================

procedure TFrmDetManInvoiceCA.BtnCommentClick(Sender: TObject);
var
  FlgSucceeded     : Boolean;          // Is the detailform successfully
begin  // of TFrmDetManInvoiceCA.BtnCommentClick
  inherited;

  FlgSucceeded := False;
  ObjTransaction := TObjTransaction.Create;
  try
    CodJob := CtCodJobRecNew;

    ObjTransaction.CodActComment := CtCodActComment;

    FlgSucceeded := SvcTaskMgr.LaunchTask ('DetManInvoiceComment');
    if FlgSucceeded then
      AddLvwArticle (ObjTransaction);
  finally
    If FlgFiscalInfo then 
      FlgFiscalInfo := FlgSucceeded;
    if not FlgSucceeded then begin
      ObjTransaction.Free;
      ObjTransaction := nil;
    end;
  end;
end;   // of TFrmDetManInvoiceCA.BtnCommentClick

//=============================================================================

procedure TFrmDetManInvoiceCA.LvwArticlesDblClick(Sender: TObject);
begin  // of TFrmDetManInvoiceCA.LvwArticlesDblClick
  inherited;

  if Assigned (BtnEdit.OnClick) and
     BtnEdit.Enabled then
    BtnEdit.OnClick (Sender);
end;   // of TFrmDetManInvoiceCA.LvwArticlesDblClick

//=============================================================================

procedure TFrmDetManInvoiceCA.BtnPaymentClick(Sender: TObject);
begin  // of TFrmDetManInvoiceCA.BtnPaymentClick
  inherited;
  SvcTaskMgr.LaunchTask ('DetManInvoicePayment');
  FillTotalsInvoice;
end;   // of TFrmDetManInvoiceCA.BtnPaymentClick

//=============================================================================

procedure TFrmDetManInvoiceCA.BtnOKClick(Sender: TObject);
var
  FrmVSRptInvoice  : TFrmVSRptInvoiceCA;    // Module that contains the rapport.
  objLocalTrans    : TObjTransaction;
begin  // of TFrmDetManInvoiceCA.BtnOKClick
  inherited;

  // Clear the existing information on the ticket.
  CurrTransTicket.StrLstObjTransaction.Clear;

  BuildInvoiceBodyPart;
  BuildInvoiceTotalPart;
  BuildInvoicePaymentPart;
  //Add fiscal info
  if TxtFiscalInfo <> '' then begin
    objLocalTrans := TObjTransactionca.Create;

    objLocalTrans.CodActComment := CtCodActComment;
    objLocalTrans.TxtDescrComment := TxtFiscalInfo;
    TObjTransactionCA(objLocalTrans).CodType := CtCodPdtCommentFiscReceiptInfo;
    CurrTransTicket.StrLstObjTransaction.AddObject('', objLocalTrans);
  end;
  DmdFpnInvoiceCA.SaveInvoice (DmdFpnInvoice.LstTickets, NumTotal,
                               CtCodInvOnSrvManual, IntToStr(IdtDepartment));

  FrmVSRptInvoice := TFrmVSRptInvoiceCA.Create (Self);

  FrmVSRptInvoice.FlgFiscal := FlgFiscal;
  FrmVSRptInvoice.FlgRussia := FlgRussia;
  FrmVSRptInvoice.FlgItaly := FlgItaly;
  FrmVSRptInvoice.IdtDepartment := IdtDepartment;

  try
    FrmVSRptInvoice.AddIdts
        (TObjTransTicket(DmdFpnInvoice.LstTickets[0]).IdtPOSTransaction,
         TObjTransTicket(DmdFpnInvoice.LstTickets[0]).IdtCheckout,
         TObjTransTicket(DmdFpnInvoice.LstTickets[0]).CodTrans,
         TObjTransTicket(DmdFpnInvoice.LstTickets[0]).DatTransBegin);

    FrmVSRptInvoice.CodKind := CodKindInvoice;
    FrmVSRptInvoice.FlgDuplicate := False;
    FrmVSRptInvoice.ShowInvoices;
    // SPAIN V1: Test purposes
    //FrmVSRptInvoice.VspPreview.PrintDoc (False, null, null);
    FrmVSRptInvoice.ShowModal;
  finally
    FrmVSRptInvoice.Free;
  end;
end;   // of TFrmDetManInvoiceCA.BtnOKClick

//=============================================================================

procedure TFrmDetManInvoiceCA.LvwArticlesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin  // of TFrmDetManInvoiceCA.LvwArticlesChange
  inherited;
  UpdateButtons;
end;   // of TFrmDetManInvoiceCA.LvwArticlesChange

//=============================================================================

procedure TFrmDetManInvoiceCA.FillTicketFromEJ;
var
  NumLine          : integer;
  objCurrTrans     : TObjTransaction;
  strLstObjTrans   : TStringList;
  NumSubTot        : Integer;           // Indicates a subtotal in a ticket.
  FlgFound         : Boolean;           // Is a equal Transdetail found?
  CntTransDetail   : Integer;           // Loop all Transdetails
begin  // of TFrmDetManInvoiceCA.FillTicketFromEJ
  FillCustomerCaption(IdtCustomer, CodCreator);
  TObjTransTicketCA(CurrTransTicket).IdtInvoiceOrig := IdtOrigInvoice;
  //Add fiscal info to listview
  AddLvwFiscalInfo;
  StrLstObjTrans := TStringList.Create;
  try
    DmdFpnInvoice.BuildPOSTransDetail(DmdFpnInvoice.QryPOSTransDetail,
                                      IdtPosTransaction,
                                      IdtCheckout,
                                      CodTrans,
                                      DatTransBegin);
    DsrPOSTransDetail.DataSet := DmdFpnInvoice.QryPOSTransDetail;
    DsrPOSTransDetail.DataSet.Open;
    DsrPOSTransDetail.DataSet.First;
    NumLine := DsrPOSTransDetail.DataSet.FieldByName ('NumLineReg').AsInteger;
    NumSubTot := 0;
    repeat
      // Put all POSTransDetail information of one NumLine into one object.
      ObjCurrTrans := TObjTransaction (TObjTransactionCA.Create);
      while (not DsrPOSTransDetail.DataSet.Eof)
      and (NumLine = DsrPOSTransDetail.DataSet.FieldByName ('NumLineReg').AsInteger)
      do begin
        ObjCurrTrans.FillObj (DsrPOSTransDetail.DataSet);
        DsrPOSTransDetail.DataSet.Next;
      end;
      NumLine := DsrPOSTransDetail.DataSet.FieldByName ('NumLineReg').AsInteger;
      // Find all equal POSTransDetails and cummulate them.
      // Start's from the last Subtotal-line
      FlgFound := False;
      for CntTransDetail := NumSubTot to Pred (StrLstObjTrans.Count) do begin
        if TObjTransaction(StrLstObjTrans.Objects[CntTransDetail]).
           Evaluate(ObjCurrTrans) then begin
          TObjTransaction(StrLstObjTrans.
                            Objects[CntTransDetail]).Count (ObjCurrTrans);
          ObjCurrTrans.Free;
          FlgFound := True;
          Break;
        end
      end;
      if not FlgFound then
        StrLstObjTrans.AddObject ('', ObjCurrTrans);
      // In case of a subtotal.
      if DsrPOSTransDetail.DataSet.FieldByName ('CodAction').AsInteger =
          CtCodActSubTotal then
        NumSubTot := StrLstObjTrans.Count;
    until DsrPOSTransDetail.DataSet.Eof;
    CntTransDetail := 0;
    while CntTransDetail  < Pred (StrLstObjTrans.Count) do begin
      ObjCurrTrans := TObjTransactionCA
                                (StrLstObjTrans.Objects [CntTransDetail]);
      case ObjCurrTrans.CodMainAction of
        CtCodActPLUKey, CtCodActPLUNum, CtCodActClassNum,
        CtCodActClassKey: begin
            //pctdisc positief maken (nodig bij maninvoice)
          if (objCurrTrans.PctDisc <> 0) or
             (ObjCurrTrans.ValDiscInclVAT <> 0) then begin
              if not FlgPosJournal then
                objCurrTrans.PctDisc := -(objCurrTrans.PctDisc);
              objCurrTrans.ValDiscInclVAT := - (objCurrTrans.ValDiscInclVAT);
              objCurrTrans.ValDiscExclVAT := - (objCurrTrans.ValDiscExclVAT);
            end;
            AddLvwArticle(ObjCurrTrans);
          CntTransDetail := CntTransDetail + 1;
        end;
        CtCodActCash, CtCodActCheque, CtCodActCheque2, CtCodActEFT, CtCodActEFT2,
        CtCodActEFT3, CtCodActEFT4, CtCodActForCurr, CtCodActForCurr2,
        CtCodActForCurr3, CtCodActMinitel, CtCodActCredCoupAccept,
        CtCodActCreditRepay, CtCodActCreditAllow, CtCodActCreditCust,
        CtCodActTakeBackAdvance, CtCodActDiscCoup, CtCodActBankTransfer,
        CtCodActVarious, CtCodActCoupInternal, CtCodActCoupExternal,
        CtCodActDePCharge, CtCodActDepTakeBack, CtCodActDepCoupAccept,
        CtCodActCredCoupCreate, CtCodActCarteProvisoire: begin
          // Passage Minitel au pc
          AddPayment(ObjCurrTrans);
          ObjCurrTrans.Free;
          StrLstObjTrans.Delete(CntTransDetail);
        end;
        CtCodActDiscPers: begin
          if not FlgItaly then
            AddPayment(ObjCurrTrans);
          ObjCurrTrans.Free;
          StrLstObjTrans.Delete(CntTransDetail);
        end;
        else begin
          ObjCurrTrans.Free;
          StrLstObjTrans.Delete(CntTransDetail);
        end;
      end;
    end;
  finally
    StrLstObjTrans.Free;
  end;
end;   // of TFrmDetManInvoiceCA.FillTicketFromEJ

//=============================================================================

procedure TFrmDetManInvoiceCA.AddPayment(ObjTrans: TObjTransaction);
var
  CntPayments      : integer;
  flgFound         : Boolean;
begin  // of TFrmDetManInvoiceCA.AddPayment
  flgFound := False;
  CntPayments := 0;
  while (CntPayments <= Pred (LstPaymethodes.Count)) and (not flgFound) do begin
    if TObjTransPayment(LstPaymethodes[CntPayments]).IdtAdmClassi =
                                                  ObjTrans.IdtClassification then begin
      TObjTransPayment(LstPaymethodes[CntPayments]).PrcAdmInclVAT :=
                TObjTransPayment(LstPaymethodes[CntPayments]).PrcAdmInclVAT +
                                                       ObjTrans.PrcAdmInclVAT;
      TObjTransPayment(LstPrevPaymethodes[CntPayments]).PrcAdmInclVAT :=
               TObjTransPayment(LstPrevPaymethodes[CntPayments]).PrcAdmInclVAT +
                                                       ObjTrans.PrcAdmInclVAT;
      TObjTransPayment(LstPaymethodes[CntPayments]).ValAdmInclVAT :=
                TObjTransPayment(LstPaymethodes[CntPayments]).ValAdmInclVAT +
                                                      - ObjTrans.ValAdmInclVAT;
      TObjTransPayment(LstPrevPaymethodes[CntPayments]).ValAdmInclVAT :=
                TObjTransPayment(LstPrevPaymethodes[CntPayments]).ValAdmInclVAT +
                                                      - ObjTrans.ValAdmInclVAT;
      flgFound := True;
    end;
    CntPayments := CntPayments + 1;
  end;
end;   // of TFrmDetManInvoiceCA.AddPayment

//=============================================================================

procedure TFrmDetManInvoiceCA.AddLvwFiscalInfo;
{var
  txtDescr         : string;
  NumFiscalReceipt : string;
  DatFiscalReceipt : string;
  NumFiscalPrinter : string;
  posSeperator     : integer;    }
begin  // of TFrmDetManInvoiceCA.AddLvwFiscalInfo
  //ophalen nummer fiscaal ticket
  TxtFiscalInfo := '';
  try
    if not Assigned (DmdFpnUtils) then
      DmdFpnUtils := TDmdFpnUtils.Create (Self);
    DmdFpnUtils.CloseInfo;
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.QueryInfo('Select * from POSTransaction where ' +
                          'IdtPosTransaction = ' +
                          IntToStr(IdtPOSTransaction) +
                          ' and IdtCheckout = ' +
                          IntToStr(IdtCheckout) +
                          ' and CodTrans = ' +
                          IntToStr(CodTrans) +
                          ' and DatTransBegin = ' +
          AnsiQuotedStr (FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                          DatTransBegin), ''''));
    if not (DmdFpnUtils.qryInfo.Eof) then begin
      TObjTransTicketCA(CurrTransTicket).NumFiscalTicket :=
                     DmdFpnUtils.QryInfo.fieldByName('NumFiscalTicket').AsInteger;
    end;
  finally
    DmdFpnUtils.QryInfo.Close;
    Application.ProcessMessages;
  end;

  try
    if TObjTransTicketCA(CurrTransTicket).NumFiscalTicket > 0 then begin
      DmdFpnUtils.QueryInfo('Select * from POSTransDetail where ' +
                            'IdtPosTransaction = ' +
                            IntToStr(IdtPOSTransaction) +
                            ' and CodType = ' +
                            IntToStr(CtCodPdtCommentFiscReceiptInfo) +
                            ' and DatTransBegin = ' +
                AnsiQuotedStr (FormatDateTime(ViTxtDBDatFormat + ' ' +
                            ViTxtDBHouFormat, DatTransBegin), ''''));
      if not (DmdFpnUtils.qryInfo.Eof) then begin
        //info ivm fiscal receipt ophalen
        TxtFiscalInfo := DmdFpnUtils.QryInfo.fieldByName('TxtDescr').AsString;
        {txtDescr := DmdFpnUtils.QryInfo.fieldByName('TxtDescr').AsString;
        NumFiscalReceipt := IntToStr(TObjTransTicketCA(CurrTransTicket).NumFiscalTicket);
        DatFiscalReceipt := Copy(txtDescr,1,2) + '-' + Copy(txtDescr,3,2) + '-' +
                            Copy(txtDescr,5,4);
        txtDescr := Copy(txtDescr,10, length(txtdescr)-9);
        posSeperator := Ansipos(';', txtDescr);
        //NumLastEOD := Copy(txtDescr,1,posSeperator - 1);
        NumFiscalPrinter := Copy(txtDescr, posSeperator + 1,
                                 length(txtDescr) - posSeperator);}
      end;
    end;
  finally
    DmdFpnUtils.QryInfo.Close;
    Application.ProcessMessages;
  end;
  

end;   // of TFrmDetManInvoiceCA.AddLvwFiscalInfo

//=============================================================================

procedure TFrmDetManInvoiceCA.FillCustomerCaption(IdtCustomer: Integer);
var
  FlgVATCodeFound  : Boolean;          // VAT code is found
  TxtCustName      : string;           // Name of the customer
begin  // of TFrmDetManInvoiceCA.FillCustomerCaption
  FlgVATCodeFound := False;
  ClearCustomerCaption;

  if IdtCustomer = 0 then
    Exit;

  // If you're sure about the customer, you can change it anyway.  In case the
  // name isn't found, just exit.  The use can retry an other idtcustomer
  try
    TxtCustName := DmdFpnCustomer.InfoCustomer[IdtCustomer, 'TxtPublName'];
    if not FlgPosJournal then begin
      if MessageDlg (Format (CtTxtSureSelectCust, [TxtCustName,
                                                   IntToStr(IdtCustomer)]),
                     mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Exit;
    end;
  except
    Exit;
  end;
  try
    SvcLFCustomerNumber.AsString := IntToStr (IdtCustomer);
    SvcMECustomerName.Text := TxtCustName;
    SvcLFCustDiscount.AsFloat := DmdFpnCustomer.InfoCustomer [IdtCustomer,
                                                               'PctDiscount'];
    LblVatNumber.Caption := DmdFpnCustomer.InfoCustomer [IdtCustomer,
                                                           'TxtNumVAT'];
    // Fill object information
    CurrTransTicket.IdtCustomer := IdtCustomer;
    FlgVATCodeFound := True;
  except
  end;

  // Getting general customer information
  try
    LblStreet.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                              CtCodAddressCommon, 'TxtStreet'];
    LblZipCode.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                            CtCodAddressCommon, 'TxtCodPost'];
    LblMunicipality.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                            CtCodAddressCommon, 'TxtMunicip'];
  except
  end;

  // Getting customer Invoice information
  try
    LblInvoiceStreet.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                             CtCodAddressCustInv, 'TxtStreet'];
    LblInvoiceZipCode.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                              CtCodAddressCustInv, 'TxtCodPost'];
    LblInvoiceMunicipality.Caption :=
        DmdFpnCustomerCA.InfoCustomerAddress [IdtCustomer, CodCreator,
                                              CtCodAddressCustInv, 'TxtMunicip'];
  except
  end;

  // If a customer is selected, the invoice lines can be inserted.
  // But you can't change the customer information anymore
  if FlgVATCodeFound then begin
    DisableParentChildCtls (PnlInfo);
    EnableParentChildCtls (PnlButtons);
    UpdateButtons;
  end;
end;   // of TFrmDetManInvoiceCA.FillCustomerCaption

//=============================================================================
// R2012.1 Address De Facturation (SM):: START
//=============================================================================
 procedure TFrmDetManInvoiceCA.ReadIniFile;
var
  IniFile          : TIniFile;
  S                : Integer;
begin  // of ReadIniFile
  if not FileExists (CIFNConfig) then begin
    //ShowError ('File not found ' + CIFNConfig, 0);
    Exit;
  end;

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
//=============================================================================
// R2012.1 Address De Facturation (SM):: END
//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FDetManInvoiceCA
