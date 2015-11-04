//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Manuel Invoice
// Unit   : FDetManInvoiceArticleCA.PAS : Form DETail MANuele INVOICES ARTICLE
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetManInvoiceArticleCA.pas,v 1.6 2009/09/22 12:37:29 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FDetManInvoiceArticleCA - CVS revision 1.7
//=============================================================================

unit FDetManInvoiceArticleCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sfdetail_BDE_DBC, ComCtrls, StdCtrls, ScDBUtil_BDE, OvcBase, OvcEF, OvcPB, OvcPF,
  ScUtils, Buttons, ExtCtrls, MMntInvoice, Db, DBTables, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx;

resourcestring
  CtTxtPrcDiscount = '%s discount';

//=============================================================================
// TFrmDetManInvoiceArticleCA
//=============================================================================

type
  TFrmDetManInvoiceArticleCA = class(TFrmDetail)
    SvcDBLblArticleNumber: TSvcDBLabelLoaded;
    SvcDBLblArticleDescription: TSvcDBLabelLoaded;
    TabShtData: TTabSheet;
    SvcLFQuantity: TSvcLocalField;
    SvcLFPrcUnit: TSvcLocalField;
    SvcLFPrcInclVAT: TSvcLocalField;
    SvcLFPrcExclVAT: TSvcLocalField;
    SvcLFValVAT: TSvcLocalField;
    CbxVATCode: TComboBox;
    SvcLFPrcPromo: TSvcLocalField;
    SvcLFPrcDiscount: TSvcLocalField;
    SvcDBLblNormalPrice: TSvcDBLabelLoaded;
    SvcDBLblPromoPrice: TSvcDBLabelLoaded;
    SvcDBLblDiscount: TSvcDBLabelLoaded;
    SvcLFDisposit: TSvcLocalField;
    SvcDBLblVATCode: TSvcDBLabelLoaded;
    SvcDBLblDisposit: TSvcDBLabelLoaded;
    SvcDBLblTotal: TSvcDBLabelLoaded;
    BvlTotal: TBevel;
    BvlExtra: TBevel;
    BvlPrice: TBevel;
    BtnSelectClassification: TBitBtn;
    SvcDBLblArticleClassification: TSvcDBLabelLoaded;
    ChkBxFreeArticle: TCheckBox;
    Bevel1: TBevel;
    SvcMEArticleNumber: TSvcMaskEdit;
    SvcMEArticleDescription: TSvcMaskEdit;
    SvcMEArticleClassification: TSvcMaskEdit;
    SvcMEFreeDescription: TSvcMaskEdit;
    procedure SvcMEArticleDescriptionPropertiesChange(Sender: TObject);
    procedure SvcLFQuantityChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnSelectClassificationClick(Sender: TObject);
    procedure ChkBxFreeArticleClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  protected
    FObjTransaction     : TObjTransaction;  // Information of the article
    FCodDiscPriority    : Integer;          // Code of Discount that has prior.
    FPctDiscCustomer    : Currency;         // Procent Discount for customer.
    ValPrcExclVat       : Currency;         // Price inclusief VAT (rounding)
    FFlgPricing: Boolean;
    function RoundTwoDicimal (NumAmount : Currency) : Currency; virtual;
    procedure CalcTotal; virtual;
  public
    { Public declarations }
    procedure AdjustDataBeforeSave; override;
    procedure PrepareFormDependJob; override;
    procedure PrepareDataDependJob; override;

    function IsDataChanged : Boolean; override;
  published
    property ObjTransaction : TObjTransaction read FObjTransaction
                                              write FObjTransaction;
    property FlgPricing: Boolean read FFlgPricing
      write FFlgPricing;
  end;  // of TFrmDetManInvoiceArticleCA

var
  FrmDetManInvoiceArticleCA: TFrmDetManInvoiceArticleCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,

  ScTskMgr_BDE_DBC,

  DFpnVATCode,
  DFpnClassification,
  DFpnUtils,
  DFpnPosTransaction,
  DFpnInvoice,

  SmDBUtil_BDE,
  SmUtils, DFpnArticleCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetManInvoiceArticleCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetManInvoiceArticleCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.6 $';
  CtTxtSrcDate    = '$Date: 2009/09/22 12:37:29 $';

//*****************************************************************************
// Implementation of TFrmDetManInvoiceArticleCA
//*****************************************************************************

//=============================================================================
// TFrmDetManInvoiceArticleCA.RoundTwoDicimal : Round a given amount to 2
// digits.
//                                -----------------
// Input   : NumAmount : Amount that must be rounded to 2 digits.
//                                -----------------
// FuncRes : The rounded amount
//=============================================================================

function TFrmDetManInvoiceArticleCA.RoundTwoDicimal (NumAmount : Currency) :
                                                                       Currency;
begin  // of TFrmDetManInvoiceArticleCA.RoundTwoDicimal
  Result := Round (NumAmount * 100) / 100;
end;   // of TFrmDetManInvoiceArticleCA.RoundTwoDicimal

//=============================================================================
// TFrmDetManInvoiceArticleCA.CalcTotal : Calculate the total article price.
//=============================================================================

procedure TFrmDetManInvoiceArticleCA.CalcTotal;
var
  NumExclAmount    : Currency;         // Calculated amount.
  NumTotalVAT      : Currency;         // Total VAT.
  NumPrcVAT        : Double;           // Procent VAT
  NumCode          : Integer;          // Error code
begin  // of TFrmDetManInvoiceArticleCA.CalcTotal
  NumTotalVAT := 0;
  // If a free article, don't count anything.
  if ChkBxFreeArticle.Checked then
    NumExclAmount := 0
  else begin
    // Promo is diff. from zero.
    if (Abs (SvcLFPrcPromo.AsFloat) >= CtValMinFloat) then
      NumExclAmount := SvcLFQuantity.AsFloat * SvcLFPrcPromo.AsFloat
    else
      NumExclAmount := SvcLFQuantity.AsFloat * ValPrcExclVat;
  end;
  NumExclAmount := NumExclAmount -
                  (NumExclAmount * SvcLFPrcDiscount.AsFloat / 100);
  SvcLFPrcExclVAT.AsFloat := RoundTwoDicimal (NumExclAmount);
  // Calculate the VAT
  Val (CbxVATCode.Items[CbxVATCode.ItemIndex], NumPrcVAT, NumCode);
  if NumCode = 0 then
    NumTotalVAT := NumExclAmount * NumPrcVAT / 100;
  SvcLFValVAT.AsFloat := RoundTwoDicimal (NumTotalVAT);
  // In case of a free article only the Diposit is counted
  if ChkBxFreeArticle.Checked then
    SvcLFPrcInclVAT.AsFloat := SvcLFDisposit.AsFloat
  else
    SvcLFPrcInclVAT.AsFloat := RoundTwoDicimal (NumExclAmount + NumTotalVAT +
                               SvcLFDisposit.AsFloat);
end;   // of TFrmDetManInvoiceArticleCA.CalcTotal

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.AdjustDataBeforeSave;
var
  CodBlocked       : Integer;
  NumPrcVAT        : Double;           // Procent VAT
  NumCode          : Integer;          // Errorcode of convertion
  NumTotInclNoDisc : Currency;         // Total amount without discount (Incl)
  NumTotExclNoDisc : Currency;         // Total amount without discount (Excl)
begin  // of TFrmDetManInvoiceArticleCA.AdjustDataBeforeSave
  inherited;
  ObjTransaction.IdtArticle        := SvcMEArticleNumber.Text;
  ObjTransaction.TxtDescrTurnOver  := SvcMEArticleDescription.Text;
  ObjTransaction.IdtClassification := SvcMEArticleClassification.Text;
  // VAT Code
  if CbxVATCode.ItemIndex < 0 then
    CbxVATCode.ItemIndex := 0;
  ObjTransaction.IdtVATCode :=
    Integer (CbxVATCode.Items.Objects [CbxVATCode.ItemIndex]);
  Val (CbxVATCode.Items[CbxVATCode.ItemIndex], NumPrcVAT, NumCode);
  if NumCode = 0 then
    ObjTransaction.PctVATCode := NumPrcVAT;
  // Normal price
  ObjTransaction.QtyArt     := SvcLFQuantity.AsFloat;
  ObjTransaction.PrcExclVAT := ValPrcExclVat;
  ObjTransaction.PrcInclVAT := ObjTransaction.PrcExclVAT *
                                        (1 + (ObjTransaction.PctVATCode / 100));
  // Promotion price
  if FlgPricing and (SvcLFPrcUnit.AsFloat < SvcLFPrcPromo.AsFloat) then
    ObjTransaction.PrcPromExclVAT := ObjTransaction.PrcExclVAT //SvcLFPrcUnit.AsFloat
  else
    ObjTransaction.PrcPromExclVAT := SvcLFPrcPromo.AsFloat;
  ObjTransaction.ValPromExclVAT := ObjTransaction.QtyArt *
                                     ObjTransaction.PrcPromExclVAT;
  ObjTransaction.PrcPromInclVAT := ObjTransaction.PrcPromExclVAT *
                                     (1 + (ObjTransaction.PctVATCode / 100));
  ObjTransaction.ValPromInclVAT := ObjTransaction.QtyArt *
                                     ObjTransaction.PrcPromInclVAT;
  if ObjTransaction.PrcPromExclVAT <> 0 then
    ObjTransaction.TxtDescrProm := CtTxtPromo;
  // If it's a free article, don't get a price.
  if ChkBxFreeArticle.Checked then
    NumTotExclNoDisc := 0
  else begin
    // Total, if there's a campaign, take this in account.  Otherwise take the
    // normal price.
    if Abs (ObjTransaction.PrcPromExclVAT) >= CtValMinFloat then
      NumTotExclNoDisc := ObjTransaction.QtyArt * ObjTransaction.PrcPromExclVAT
    else
      NumTotExclNoDisc := ObjTransaction.QtyArt * ObjTransaction.PrcExclVAT;
  end;
  NumTotInclNoDisc := NumTotExclNoDisc * (1 +(ObjTransaction.PctVATCode / 100));
  // Discounts
  // Remark : DON't fill CodActDisc in.  Otherwise you never will know if the
  // discount was on article-level or on customer-level.
  ObjTransaction.PctDisc          := SvcLFPrcDiscount.AsFloat;
  ObjTransaction.TxtDescrDiscount := Format (CtTxtPrcDiscount, [CurrToStrF
                                      (ObjTransaction.PctDisc, ffFixed,
                                       DmdFpnUtils.QtyDecimCurrencyMain)]);
  ObjTransaction.ValDiscInclVAT   := RoundTwoDicimal (NumTotInclNoDisc *
                                      (ObjTransaction.PctDisc /100));
  ObjTransaction.ValDiscExclVAT   := RoundTwoDicimal (NumTotExclNoDisc *
                                      (ObjTransaction.PctDisc /100));
  // Total to pay
  ObjTransaction.ValExclVAT := RoundTwoDicimal (NumTotExclNoDisc);
  ObjTransaction.ValInclVAT := RoundTwoDicimal (NumTotInclNoDisc);
  // In case of a free article.
  if ChkBxFreeArticle.Checked then begin
    ObjTransaction.CodActFree   := CtCodActFree;
    ObjTransaction.TxtDescrFree := SvcMEFreeDescription.Text;
  end
  else begin
    ObjTransaction.CodActFree   := 0;
    ObjTransaction.TxtDescrFree := '';
  end;
  // Check if article is blocked
  CodBlocked := 0;
  if AnsiCompareText (ObjTransaction.IdtArticle, '') <> 0 then
    CodBlocked := DmdFpnArticleCA.InfoArticle [ObjTransaction.IdtArticle,
                                             'CodBlocked'];
  if CodBlocked > CtCodBlockedNoBlock then begin
    if ((ObjTransaction.QtyArt > 0) and (CodBlocked <> CtCodBlockedReturn))
    or ((ObjTransaction.QtyArt < 0) and (CodBlocked <> CtCodBlockedSale))
    then begin
      case CodBlocked of
        CtCodBlockedSale: ShowMessage(CtTxtArtBlockSales);
        CtCodBlockedReturn: ShowMessage(CtTxtArtBlockReturn);
        CtCodBlockedSaleReturn: ShowMessage(CtTxtArtBlockSalesReturn);
      end;
      ModalResult := mrCancel;
    end;
  end;
end;   // of TFrmDetManInvoiceArticleCA.AdjustDataBeforeSave

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.PrepareFormDependJob;
begin  // of TFrmDetManInvoiceArticleCA.PrepareFormDependJob
  inherited;
  // Never shows the BtnAdd.
  // You only can add one article on a screen once.
  BtnAdd.Visible := False;

  // Force focus
  if SvcLFQuantity.Enabled then
    SvcLFQuantity.SetFocus;

  // Set Customer discount
  if ObjTransaction.CodActDisc = CtCodActDiscArtPct then
    EnableControl (SvcLFPrcDiscount)
  else
    DisableControl (SvcLFPrcDiscount);


  // Evaluate if it's a manual or existing article.
  if AnsiCompareText (ObjTransaction.IdtArticle, '') <> 0 then begin
    DisableControl (BtnSelectClassification);
    if SvcLFQuantity.Enabled then
      SvcLFQuantity.SetFocus;
  end
  else begin
    EnableControl (BtnSelectClassification);
    if SvcMEArticleDescription.Enabled then
      SvcMEArticleDescription.SetFocus;
  end;

  // If there's no discription, you can't save the detail line.
  if ObjTransaction.TxtDescrTurnOver = '' then
    DisableControl (BtnOK)
  else
    EnableControl (BtnOK);

  // Free article
  if ObjTransaction.CodActFree = CtCodActFree then begin
    ChkBxFreeArticle.State := cbChecked;
    EnableControl (SvcMEFreeDescription);
  end
  else begin
    ChkBxFreeArticle.State := cbUnchecked;
    DisableControl (SvcMEFreeDescription);
  end;
end;   // of TFrmDetManInvoiceArticleCA.PrepareFormDependJob

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.PrepareDataDependJob;
begin  // of TFrmDetManInvoiceArticleCA.PrepareDataDependJob
  inherited;
  SvcMEArticleNumber.Text := ObjTransaction.IdtArticle;
  SvcMEArticleDescription.Text := ObjTransaction.TxtDescrTurnOver;
  SvcMEArticleClassification.Text := ObjTransaction.IdtClassification;

  // VAT Code
  CbxVATCode.ItemIndex :=
      CbxVATCode.Items.IndexOfObject (TObject (ObjTransaction.IdtVATCode));

  // Normal price
  SvcLFQuantity.AsFloat := ObjTransaction.QtyArt;
  ValPrcExclVat := ObjTransaction.PrcExclVAT;
  SvcLFPrcUnit.AsFloat := ValPrcExclVat;
  SvcLFPrcExclVAT.AsFloat := ObjTransaction.ValExclVAT;

  // Promotion price
  SvcLFPrcPromo.AsFloat := ObjTransaction.PrcPromExclVAT;

  // Discounts
  SvcLFPrcDiscount.AsFloat := ObjTransaction.PctDisc;

  // Disposit
  (** KRG -> Wasn't needed for Castorama, watch out if you use it in
             other applications.! **)

  // Total
  SvcLFPrcInclVAT.AsFloat := ObjTransaction.ValInclVAT;

  // Free article
  SvcMEFreeDescription.Text := ObjTransaction.TxtDescrFree;

  CalcTotal;
end;   // of TFrmDetManInvoiceArticleCA.PrepareDataDependJob

//=============================================================================
// TFrmDetManInvoiceArticleCA.IsDataChanged : This form doen't use DB-controls,
// Normaly the form 'detects' by his own if there's a changing.  Now he doesn't
// do that so (if we want to save something) we return always True.
//=============================================================================

function TFrmDetManInvoiceArticleCA.IsDataChanged : Boolean;
begin  // of TFrmDetManInvoiceArticleCA.IsDataChanged
  Result := True;
end;   // of TFrmDetManInvoiceArticleCA.IsDataChanged

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.FormCreate(Sender: TObject);
var
  SprVATCode       : TStoredProc;      // Stored proc. for VAT code
  TxtVAT           : string;           // string VAT code
begin  // of TFrmDetManInvoiceArticleCA.FormCreate
  inherited;

  // Make a list of all VAT codes
  SprVATCode :=
    CopyStoredProc (Self, 'SprRTLstVATCode',
                    DmdFpnVATCode.SprLstVATCode, []);

  // Here we have to build the list manual.  We can't use the procedure
  // BuildStrLstCodes because this doesn't return the correct values in the
  // combobox
  try
    SprVATCode.Active := True;
    while not SprVATCode.Eof do begin
      Str (SprVATCode.FieldByName ('PctVAT').AsFloat : 10 : 2, TxtVAT);
      TxtVAT := TrimRight (TrimLeft (TxtVAT));

      CbxVATCode.Items.AddObject (TxtVAT,
          TObject (SprVATCode.FieldByName ('IdtVATCode').AsInteger));
      SprVATCode.Next;
    end;
  finally
    SprVATCode.Free;
  end;
end;   // of TFrmDetManInvoiceArticleCA.FormCreate

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin  // of TFrmDetManInvoiceArticleCA.FormClose
  inherited;
  CbxVATCode.ItemIndex := 0;
end;   // of TFrmDetManInvoiceArticleCA.FormClose

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.SvcLFQuantityChange(Sender: TObject);
begin  // of TFrmDetManInvoiceArticleCA.SvcLFQuantityChange
  inherited;
  if Sender = SvcLFPrcUnit then
    ValPrcExclVat := SvcLFPrcUnit.AsFloat;
  CalcTotal;
end;   // of TFrmDetManInvoiceArticleCA.SvcLFQuantityChange

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.BtnSelectClassificationClick(
  Sender: TObject);
var
  IdtVatCode       : Integer;          // Ident of the VAT Code.
begin  // of TFrmDetManInvoiceArticleCA.BtnSelectClassificationClick
  inherited;

  StrLstIdtValues.Clear;
  if SvcTaskMgr.LaunchTask ('ListClassification') then begin
    SvcMEArticleClassification.Text :=
        StrLstIdtValues.Values ['IdtClassification'];

    IdtVatCode := DmdFpnClassification.InfoClassAssort
                                  [StrLstIdtValues.Values ['IdtClassification'],
                                   DmdFpnUtils.IdtTradeMatrixAssort,
                                   'IdtVATCode'];
    CbxVATCode.ItemIndex := CbxVATCode.Items.IndexOfObject(TObject(IdtVATCode));
    CalcTotal;
  end;
end;   // of TFrmDetManInvoiceArticleCA.BtnSelectClassificationClick

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.ChkBxFreeArticleClick(
  Sender: TObject);
begin  // of TFrmDetManInvoiceArticleCA.ChkBxFreeArticleClick
  inherited;
  if ChkBxFreeArticle.Checked then
    EnableControl  (SvcMEFreeDescription)
  else
    DisableControl (SvcMEFreeDescription);

  CalcTotal;
end;   // of TFrmDetManInvoiceArticleCA.ChkBxFreeArticleClick

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.FormActivate(Sender: TObject);
begin  // of TFrmDetManInvoiceArticleCA.FormActivate
  inherited;
  If SvcMEArticleClassification.Text = '' then begin
    SvcLFValVAT.AsFloat := 0;
    SvcLFPrcInclVAT.AsFloat := 0;
  end;
end;   // of TFrmDetManInvoiceArticleCA.FormActivate

//=============================================================================

procedure TFrmDetManInvoiceArticleCA.SvcMEArticleDescriptionPropertiesChange(
  Sender: TObject);
begin  // of TFrmDetManInvoiceArticleCA.SvcMEArticleDescriptionPropertiesChange
  inherited;
  if SvcMEArticleDescription.Text = '' then
    DisableControl (BtnOK)
  else
    EnableControl (BtnOK);
end;   // of TFrmDetManInvoiceArticleCA.SvcMEArticleDescriptionPropertiesChange

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FDetManInvoiceArticleCA
