//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint
// Unit     : FDetSalesByPaymethod: DETail form for SALES BY PAYment METHOD
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetSalesByPaymethod.pas,v 1.19 2009/09/29 11:35:31 BEL\KDeconyn Exp $
//=============================================================================

unit FDetSalesByPaymethod;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetGeneralCA, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE, SfVSPrinter7,
  SmVSPrinter7Lib_TLB;

//******************************************************************************
// Global definitions
//******************************************************************************

Const
  CtMaxNumDays          = 30;
  CtIdtClassCoupon      = '8600,8601,8602,8603,8604,8605,8606,8607,8608,8609,' +
                          '8610,8611,8612,8613,8614,8615,8616,8617,8618,8619,8620';
  CtIdtClassCheque      = '8010';
  CtIdtClassCreditCard  = '8020';
  CtIdtClassInstalment  = '8315';
  CtTxtDatFormatChina   = 'yyyy-mm-dd';
  CtCodActChargeSavCard = 152;
  CtCodactWithdrawSavCard = 153;
  CtIdtClassOldCoupon   = '8611';

Const              //width of columns
  CtColWidthPaymentType = 10;
  CtColWidthTransNumber = 10;
  CtColWidthSalesType   = 10;
  CtColWidthTransDate   = 10;
  CtColWidthCustNumber  = 20;
  CtColWidthIdtOperator = 10;
  CtColWidthTillnumber  = 5;
  CtColWidthValSystem   = 10;
  CtColWidthValActual   = 10;
  CtColWidthDifference  = 10;
  CtColWidthCouponNum   = 20;
  CtColWidthLoanType    = 10;
  CtColWidthLoanPeriod  = 10;


resourcestring     // of header.
  CtTxtTitle            = 'SALES AMOUNT INFORMATION REPORT BY PAYMENT METHOD';
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtSearchTrans      = 'Transaction n°: %s';
  CtTxtSearchDate       = 'Ticket date between %s and %s';
  CtTxtSearchPayType    = 'Payment type: %s';
  CtTxtSearchCreditCard = 'Credit card n°: %s';
  CtTxtSearchCoupon     = 'Coupon n°: %s';
  CtTxtSearchOperator   = 'Cashier n°: %s';
  CtTxtSearchCheckout   = 'Till n°: %s';
  CtTxtHeaderSep        = '; ';

resourcestring     // of date errors
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtMaxDays          = 'Selected daterange may not contain more then %s days';
  CtTxtErrorHeader      = 'Incorrect Date';

resourcestring     // of table header
  CtTxtPayType          = 'Payment type';
  CtTxtTransNum         = 'Transaction n°';
  CtTxtSalesType        = 'Sales type';
  CtTxtTransDate        = 'Transaction date';
  CtTxtCustNum          = 'Customer n°';
  CtTxtOperatorNum      = 'Cashier n°';
  CtTxtCheckoutNum      = 'Till n°';
  CtTxtSystemPayAmount  = 'Payment amount in system';
  CtTxtActualPayAmount  = 'Actual payment amount';
  CtTxtDifference       = 'Difference';
  CtTxtCouponNum        = 'Coupon n°';
  CtTxtCreditCardNum    = 'Credit card n°';
  CtTxtChequeNum        = 'Cheque n°';
  CtTxtOrigTransNum     = 'Original transaction number';
  CtTxtLoanType         = 'Loan Type';
  CtTxtLoanPeriod       = 'Loan Period';

  CtTxtSubTotal         = 'SUB total';
  CtTxtActualSales      = 'Actual Sales';
  CtTxtCancelSales      = 'Cancel Sales';
  CtTxtChargeSavCard    = 'Charge by saving card';
  CtTxtWithdrawSavCard  = 'Withdraw from saving card';
  CtTxtCheckout         = 'Checkout';

//******************************************************************************
// Form-declaration.
//******************************************************************************

type
  TFrmDetSalesByPayMethod = class(TFrmDetGeneralCA)
    Panel2: TPanel;
    ChkLbxCheckout: TCheckListBox;
    BtnSelectAllCheckout: TBitBtn;
    BtnDESelectAllCheckout: TBitBtn;
    LblTransDate: TLabel;
    LblTransNumber: TLabel;
    LblPayType: TLabel;
    EdtCreditCard: TEdit;
    EdtTransNumber: TEdit;
    EdtCoupon: TEdit;
    CmbBxPayType: TComboBox;
    ChkBxCreditCard: TCheckBox;
    ChkBxCoupon: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure ChkBxCouponClick(Sender: TObject);
    procedure ChkBxCreditCardClick(Sender: TObject);
    procedure CmbBxPayTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnDESelectAllCheckoutClick(Sender: TObject);
    procedure BtnSelectAllClickCheckout(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    ValAmountSystem  : Double;       //subtotal of payment amount in system
    ValActualAmount  : Double;       //subtotal of actual payment amount
    ValDifference    : Double;       //subtotal of difference
    QtyLines         : integer;      //number of lines per payment method
    TxtOperators     : string;
    LstOperators     : TStringList;
    TxtCheckouts     : string;
    LstCheckouts     : TStringList;
    FlgHeaderPrinted : Boolean;
    // General
    procedure AutoStart (Sender : TObject); override;
    function GetItemsSelected : Boolean; override;
    // Formats of the report
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string; virtual;
    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;
    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
  public
    { Public declarations }
    procedure SetGeneralSettings; override;
    procedure PrintHeader; override;
    procedure PrintTableHeader; override;
    procedure PrintTableBody; override;
    procedure PrintTableFooter; override;
    procedure PrintLineBody; virtual;
    procedure PrintLineSubTotal; virtual;
    procedure Execute; override;
  end;

var
  FrmDetSalesByPayMethod: TFrmDetSalesByPayMethod;

//******************************************************************************

implementation

uses
  SfDialog,
  SmUtils,

  DFpnUtils,
  DFpnTradeMatrix,
  DFpnSalesByPaymethod,

  DB,
  DBTables;

{$R *.dfm}

//==============================================================================
// Source-identifiers
//==============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetSalesByPaymethod';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetSalesByPaymethod.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.19 $';
  CtTxtSrcDate    = '$Date: 2009/09/29 11:35:31 $';

//******************************************************************************
// Implementation of TFrmDetSalesByPayMethod
//******************************************************************************

procedure TFrmDetSalesByPayMethod.AutoStart (Sender : TObject);
begin  // of TFrmDetSalesByPayMethod.AutoStart
  inherited;
  // Add operator 0 to checklistbox operator
  if ChkLbxOperator.Items.IndexOfObject(TObject(0)) = -1 then
    ChkLbxOperator.Items.InsertObject (0, '0 : ' + CtTxtOperator + ' 0',
      TObject (0));
  // Fill checkout checkbox listbox
  try
    if DmdFpnUtils.QueryInfo
        ('SELECT IdtCheckout, TxtPublDescr' +
      #10'FROM WorkStat WHERE CodType = 1') then begin
      DmdFpnUtils.QryInfo.First;
      ChkLbxCheckout.Items.Clear;
      while not DmdFpnUtils.QryInfo.Eof do begin
        ChkLbxCheckout.Items.AddObject
           (DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsString + ' : ' +
            DmdFpnUtils.QryInfo.FieldByName ('TxtPublDescr').AsString,
            TObject (DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsInteger));
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
  if ChkLbxCheckout.Items.IndexOfObject(TObject(0)) = -1 then
    ChkLbxCheckout.Items.InsertObject (0, '0 : ' + CtTxtCheckout + ' 0',
      TObject (0));
  // Fill Payment type listbox
  try
    if DmdFpnUtils.QueryInfo
        ('SELECT C.IdtClassification, C.TxtPublDescr FROM TenderGroup TG' +
      #10'INNER JOIN TenderClass TC' +
      #10'ON TG.IdtTendergroup = TC.IdtTenderGroup' +
      #10'INNER JOIN Classification C' +
      #10'ON C.IdtClassification >= TC.IdtClassMin' +
      #10' AND C.IdtClassification <= TC.IdtClassMax' +
      #10'WHERE TG.CodType IN (0,1,2)') then begin
      DmdFpnUtils.QryInfo.First;
      CmbBxPayType.Items.Clear;
      while not DmdFpnUtils.QryInfo.Eof do begin
        CmbBxPayType.Items.Add
           (DmdFpnUtils.QryInfo.FieldByName ('TxtPublDescr').AsString + ' - ' +
            DmdFpnUtils.QryInfo.FieldByName ('IdtClassification').AsString);
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetSalesByPayMethod.AutoStart

//=============================================================================

procedure TFrmDetSalesByPayMethod.BtnSelectAllClickCheckout(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetSalesByPayMethod.BtnSelectAllClick
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do
    ChkLbxCheckout.Checked [CntIx] := True;
end;   // of TFrmDetSalesByPayMethod.BtnSelectAllClick

//==============================================================================

procedure TFrmDetSalesByPayMethod.BtnDESelectAllCheckoutClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetSalesByPayMethod.BtnDeSelectAllClick
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do
    ChkLbxCheckout.Checked [CntIx] := False;
end;   // of TFrmDetSalesByPayMethod.BtnDeSelectAllClick;

//==============================================================================

function TFrmDetSalesByPaymethod.GetFmtTableHeader: string;
begin  // of TFrmDetSalesByPaymethod.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (CtColWidthPaymentType, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthTransNumber, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthSalesType, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthTransDate, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthCustNumber, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthIdtOperator, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthTillnumber, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthValSystem, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthValActual, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthDifference, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthCouponNum, False))  + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthLoanType, False))  + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthLoanPeriod, False));
end;   // of TFrmDetSalesByPaymethod.GetFmtTableHeader

//=============================================================================

function TFrmDetSalesByPaymethod.GetFmtTableBody : string;
begin  // of TFrmDetSalesByPaymethod.GetFmtTableBody
  Result := '^+' + IntToStr (CalcWidthText (CtColWidthPaymentType, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthTransNumber, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthSalesType, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthTransDate, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthCustNumber, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthIdtOperator, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthTillnumber, False)) + TxtSep +
            '>+' + IntToStr (CalcWidthText (CtColWidthValSystem, False)) + TxtSep +
            '>+' + IntToStr (CalcWidthText (CtColWidthValActual, False)) + TxtSep +
            '>+' + IntToStr (CalcWidthText (CtColWidthDifference, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthCouponNum, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthLoanType, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthLoanPeriod, False));
end;   // of TFrmDetSalesByPaymethod.GetFmtTableBody

//=============================================================================

function TFrmDetSalesByPaymethod.GetFmtTableSubTotal : string;
begin  // of TFrmDetSalesByPaymethod.GetFmtTableSubTotal
  Result := '<+' + IntToStr (CalcWidthText (CtColWidthPaymentType, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtColWidthTransNumber, False)) + TxtSep +
            '<+' + IntToStr (CalcWidthText (CtColWidthSalesType, False)) + TxtSep +
            '<+' + IntToStr (CalcWidthText (CtColWidthTransDate, False)) + TxtSep +
            '<+' + IntToStr (CalcWidthText (CtColWidthCustNumber, False)) + TxtSep +
            '<+' + IntToStr (CalcWidthText (CtColWidthIdtOperator, False)) + TxtSep +
            '<+' + IntToStr (CalcWidthText (CtColWidthTillnumber, False)) + TxtSep +
            '>+' + IntToStr (CalcWidthText (CtColWidthValSystem, False)) + TxtSep +
            '>+' + IntToStr (CalcWidthText (CtColWidthValActual, False)) + TxtSep +
            '>+' + IntToStr (CalcWidthText (CtColWidthDifference, False)) + TxtSep +
            '<+' + IntToStr (CalcWidthText (CtColWidthCouponNum, False)) + TxtSep +
            '<+' + IntToStr (CalcWidthText (CtColWidthLoanType, False)) + TxtSep +
            '<+' + IntToStr (CalcWidthText (CtColWidthLoanPeriod, False));
end;   // of TFrmDetSalesByPaymethod.GetFmtTableSubTotal

//=============================================================================

function TFrmDetSalesByPaymethod.GetTxtTableTitle : string;
var
  IdtClassification: string;
  IdtSubdiv        : string;
begin  // of TFrmDetSalesByPaymethod.GetTxtTableTitle
  Result :=   CtTxtPayType         + TxtSep +
              CtTxtTransNum        + TxtSep +
              CtTxtSalesType       + TxtSep +
              CtTxtTransDate       + TxtSep +
              CtTxtCustNum         + TxtSep +
              CtTxtOperatorNum     + TxtSep +
              CtTxtCheckoutNum     + TxtSep +
              CtTxtSystemPayAmount + TxtSep +
              CtTxtActualPayAmount + TxtSep +
              CtTxtDifference;
  IdtClassification := Trim(DmdFpnSalesByPaymethod.SprSalesByPaymethod.
                                    FieldByName('IdtClass').AsString);
  IdtSubdiv := Copy(IdtClassification, length(IdtClassification) - 3, 4);
  if POS(IdtSubdiv, CtIdtClassCoupon) > 0 then
    Result := Result + TxtSep + CtTxtCouponNum
  else if IdtSubdiv = CtIdtClassCheque then
    Result := Result + TxtSep + CtTxtChequeNum + TxtSep + CtTxtOrigTransNum
  else if IdtSubdiv = CtIdtClassCreditCard then
    Result := Result + TxtSep + CtTxtCreditCardNum + TxtSep + CtTxtOrigTransNum
  else if IdtSubdiv = CtIdtClassInstalment then 
    Result := Result + TxtSep + CtTxtCreditCardNum + TxtSep + CtTxtLoanType +
              TxtSep + CtTxtLoanPeriod
end;   // of TFrmDetSalesByPaymethod.GetTxtTableTitle

//=============================================================================

function TFrmDetSalesByPaymethod.GetTxtTableFooter : string;
begin  // of TFrmDetSalesByPaymethod.GetTxtTableFooter
  Result := TxtSep + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
            TxtSep + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
            TxtSep;
end;   // of TFrmDetSalesByPaymethod.GetTxtTableFooter

//=============================================================================

function TFrmDetSalesByPaymethod.GetTxtTitRapport : string;
begin  // of TFrmDetSalesByPaymethod.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetSalesByPaymethod.GetTxtTitRapport

//=============================================================================

function TFrmDetSalesByPaymethod.GetTxtRefRapport : string;
begin  // of TFrmDetSalesByPaymethod.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0037';
end;   // of TFrmDetSalesByPaymethod.GetTxtRefRapport

//=============================================================================

procedure TFrmDetSalesByPaymethod.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetSalesByPaymethod.PrintHeader
  inherited;
  // Report title
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  // Tradematrix information
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;
  // Search criteria
  if EdtTransNumber.Text <> '' then
    TxtHdr := TxtHdr + Format(CtTxtSearchTrans, [EdtTransNumber.Text]) +
              CtTxtHeaderSep;
  TxtHdr := TxtHdr + Format (CtTxtSearchDate,
            [FormatDateTime (CtTxtDatFormatChina, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormatChina, DtmPckDayTo.Date)]);
  if not (CmbBxPayType.ItemIndex < 0) then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format(CtTxtSearchPayType,
                                               [CmbBxPayType.Text]);
  if (ChkBxCreditCard.Checked) and (EdtCreditCard.Text <> '') then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format(CtTxtSearchCreditCard,
                                               [EdtCreditCard.Text]);
  if (ChkBxCoupon.Checked) and (EdtCoupon.Text <> '') then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format(CtTxtSearchCoupon,
                                               [EdtCoupon.Text]);
  if TxtOperators <> '' then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format (CtTxtSearchOperator,
              [TxtOperators]);
  if TxtCheckouts <> '' then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format (CtTxtSearchCheckout,
              [TxtCheckouts]);
    // Report date
  TxtHdr := TxtHdr + CRLF + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormatChina, now),
            FormatDateTime (CtTxtHouFormat, now)]) + CRLF;
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetSalesByPaymethod.PrintHeader

//=============================================================================

procedure TFrmDetSalesByPaymethod.PrintTableBody;
var
  PrevIdtClass     : string;
begin  // of TFrmDetSalesByPaymethod.PrintTableBody
  inherited;
  ValAmountSystem := 0;
  ValActualAmount := 0;
  ValDifference := 0;
  QtyLines := 0;
  if not DmdFpnSalesByPaymethod.SprSalesByPaymethod.Eof then begin
    PrevIdtClass := DmdFpnSalesByPaymethod.SprSalesByPaymethod.
                            FieldByName('IdtClass').AsString;
    PrintLineBody;
    FlgHeaderPrinted := False;
  end;
  while not DmdFpnSalesByPaymethod.SprSalesByPaymethod.Eof do begin
    if PrevIdtClass = DmdFpnSalesByPaymethod.SprSalesByPaymethod.
                            FieldByName('IdtClass').AsString then begin

      PrintLineBody;
      FlgHeaderPrinted := False;
    end
    else begin
      if QtyLines > 0 then begin
        PrintLineSubTotal;
        if not FlgHeaderPrinted then
          PrintTableHeader;
      end;
      QtyLines := 0;
      PrevIdtClass := DmdFpnSalesByPaymethod.SprSalesByPaymethod.
                            FieldByName('IdtClass').AsString;
    end;
  end;
  if QtyLines > 0 then
    PrintLineSubTotal;
end;   // of TFrmDetSalesByPaymethod.PrintTableBody

//=============================================================================

procedure TFrmDetSalesByPaymethod.PrintTableFooter;
begin  // of TFrmDetSalesByPaymethod.PrintTableFooter
  VspPreview.Text := CRLF;
end;   // of TFrmDetSalesByPaymethod.PrintTableFooter

//=============================================================================

procedure TFrmDetSalesByPayMethod.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetSalesByPayMethod.BtnPrintClick
  ChkLbxOperator.SetFocus;
  // Check is DayFrom < DayTo
  if DtmPckDayFrom.Date > DtmPckDayTo.Date then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate),PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if DtmPckDayFrom.Date > Now then begin
    DtmPckDayFrom.Date := Now;
    Application.MessageBox(PChar(CtTxtStartFuture),PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if DtmPckDayTo.Date > Now then begin
    DtmPckDayto.Date := Now;
    Application.MessageBox(PChar(CtTxtEndFuture),PChar(CtTxtErrorHeader), MB_OK);
  end
  else if DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayto.Date := Now;
    Application.MessageBox(PChar(Format (CtTxtMaxDays, [IntToStr(CtMaxNumDays)])),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  else 
    inherited;
end;   // of TFrmDetSalesByPayMethod.BtnPrintClick

//=============================================================================

procedure TFrmDetSalesByPayMethod.Execute;
var
  CntIx            : integer;
begin  // of TFrmDetSalesByPayMethod.Execute
  //Start stored procedure
  try
    TxtOperators := '';
    LstOperators := TStringList.Create;
    for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
      if ChkLbxOperator.Checked [CntIx] then begin
        LstOperators.Add(IntToStr(Integer(ChkLbxOperator.Items.Objects[CntIx])));
        if TxtOperators = '' then
          TxtOperators := IntToStr(Integer(ChkLbxOperator.Items.Objects[CntIx]))
        else
          TxtOperators := TxtOperators + ', ' + IntToStr(Integer(
                          ChkLbxOperator.Items.Objects[CntIx]));
      end;
    end;
    // overlopen listbox checkout
    TxtCheckouts := '';
    LstCheckouts := TStringList.Create;
    for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do begin
      if ChkLbxCheckout.Checked [CntIx] then begin
        LstCheckouts.Add(IntToStr(Integer(ChkLbxCheckout.Items.Objects[CntIx])));
        if TxtCheckouts = '' then
          TxtCheckouts := IntToStr(Integer(ChkLbxCheckout.Items.Objects[CntIx]))
        else
          TxtCheckouts := TxtCheckouts + ', ' + IntToStr(Integer(
                          ChkLbxCheckout.Items.Objects[CntIx]));
      end;
    end;
    with DmdFpnSalesByPaymethod.SprSalesByPaymethod do begin
      Close;
      ParamByName('PrmDatFrom').AsString := FormatDateTime(CtTxtDatFormatChina +
        ' 00:00:00', DtmPckDayFrom.Date);
      ParamByName('PrmDatTo').AsString := FormatDateTime(CtTxtDatFormatChina +
        ' 23:59:59', DtmPckDayTo.Date);
      if EdtTransNumber.Text <> '' then
        ParamByName('PrmIdtPOSTransaction').AsInteger := StrToInt(EdtTransNumber.Text)
      else
        ParamByName('PrmIdtPOSTransaction').Clear;
      if CmbBxPayType.ItemIndex <> -1 then
        ParamByName('PrmIdtClassification').AsString := Copy(CmbBxPayType.Text,
          Length(CmbBxPayType.Text) - 10,11)
      else
        ParamByName('PrmIdtClassification').Clear;
      if ChkBxCreditCard.Checked then
        ParamByName('PrmNumCreditCard').AsString := Trim(EdtCreditCard.Text)
      else
        ParamByName('PrmNumCreditCard').Clear;
      if ChkBxCoupon.Checked then
        ParamByName('PrmNumCoupon').AsString := Trim(EdtCoupon.Text)
      else
        ParamByName('PrmNumCoupon').Clear;
      Open;
    end;
    inherited;
  finally
    DmdFpnSalesByPaymethod.SprSalesByPaymethod.Close;
    LstCheckouts.Free;
    LstOperators.Free;
  end;
end;   // of TFrmDetSalesByPayMethod.Execute

//=============================================================================

procedure TFrmDetSalesByPayMethod.PrintLineBody;
var
  TxtLine          : string;
  IdtClassification: string;
  PaymentType      : string;
  TransNumber      : integer;
  TxtSalesType     : string;
  DatTransaction   : TDateTime;
  CustomerNumber   : string;
  IdtOperator      : string;
  IdtCheckout      : string;
  PayAmountSystem  : Double;
  PayActualAmount  : Double;
  PayDifference    : Double;
  TxtCouponNumber  : string;
  TxtCreditCardNum : string;
  TxtLoanID        : string;
  TxtLoanPeriod    : string;
  NumLineReg       : integer;
  IdtPosTransOrig  : integer;
  IdtSubdiv        : string;
  Quantity         : Double;
begin  // of TFrmDetSalesByPayMethod.PrintLineBody
  if (LstOperators.IndexOf(DmdFpnSalesByPaymethod.SprSalesByPaymethod.
      FieldByName('IdtOperator').AsString) > -1 )
  and (LstCheckouts.IndexOf(DmdFpnSalesByPaymethod.SprSalesByPaymethod.
       FieldByName('IdtCheckout').AsString) > -1 ) then begin
    with DmdFpnSalesByPaymethod.SprSalesByPaymethod do begin
      IdtClassification := FieldByName('IdtClass').AsString;
      PaymentType       := FieldByName('TxtDescr').AsString;
      TransNumber       := FieldByName('IdtPOSTransaction').AsInteger;
      if FieldByName('CodSalesType').AsInteger = CtCodActChargeSavCard then
        TxtSalesType    := CtTxtChargeSavCard
      else if FieldByName('CodSalesType').AsInteger = CtCodActWithdrawSavCard then
        TxtSalesType    := CtTxtWithdrawSavCard
      else if not (FieldByName('CodSalesType').AsInteger in [1,102]) then
        TxtSalesType    := CtTxtActualSales
      else
        TxtSalesType    := CtTxtCancelSales;
      DatTransaction    := FieldByName('DatTransBegin').AsDateTime;
      CustomerNumber    := FieldByName('NumCard').AsString;
      IdtOperator       := FieldByName('IdtOperator').AsString;
      IdtCheckout       := FieldByName('IdtCheckout').AsString;
      Quantity          := FieldByName('Qtyreg').AsCurrency;
      PayAmountSystem   := FieldByName('ValInclVAT').AsCurrency;
      PayActualAmount   := FieldByName('ValInclVAT').AsCurrency;
      PayDifference     := 0;
      NumLineReg        := FieldByName('NumLineReg').AsInteger;
      IdtPosTransOrig   := FieldByName('IdtPOSTransOrig').AsInteger;
      Next;
      //get extra info on same numlinereg of ticket
      while (NumLineReg = FieldByName('NumLineReg').AsInteger)
        and (TransNumber = FieldByName('IdtPOSTransaction').AsInteger)
        and (DatTransaction = FieldByName('DatTransBegin').AsDateTime)
        and (IdtCheckout = FieldByName('IdtCheckout').AsString)
        and not Eof do begin
        case FieldByName('CodType').AsInteger of
          441: TxtCouponNumber := FieldByName('TxtDescr').AsString;
          307: TxtCreditCardNum := FieldByName('TxtDescr').AsString;
          430: TxtCreditCardNum := FieldByName('TxtDescr').AsString;
          431: TxtLoanID := FieldByName('TxtDescr').AsString;
          433: TxtLoanPeriod := FieldByName('TxtDescr').AsString;
        end;
        Next;
      end;
      //add values if same paymentmethod on same ticket
      IdtSubdiv := Copy(IdtClassification, length(IdtClassification) - 3, 4);
      if POS(IdtSubDiv, CtIdtClassCoupon + ',' + CtIdtClassCreditCard + ',' +
                        CtIdtClassInstalment) = 0 then begin
        while (IdtClassification = FieldByName('IdtClass').AsString)
          and (TransNumber = FieldByName('IdtPOSTransaction').AsInteger)
          and (DatTransaction = FieldByName('DatTransBegin').AsDateTime)
          and (IdtCheckout = FieldByName('IdtCheckout').AsString)
          and not Eof do begin
            PayAmountSystem   := PayAmountSystem +
                                 FieldByName('ValInclVAT').AsCurrency;
            PayActualAmount   := PayActualAmount +
                                 FieldByName('ValInclVAT').AsCurrency;
          Next;
        end;
      end;
    end;
    if (TxtCouponNumber <> '') and (IdtSubdiv <> CtIdtClassOldCoupon) then begin
      PayActualAmount := Quantity * StrToFloat(Copy(TxtCouponNumber,
                         Length(TxtCouponNumber) - 5, 4));
      PayDifference   := PayActualAmount - PayAmountSystem;
    end;
    TxtLine :=
      PaymentType           + TxtSep +
      IntToStr(TransNumber) + TxtSep +
      TxtSalesType          + TxtSep +
      FormatDateTime(CtTxtDatFormatChina, DatTransaction) + TxtSep +
      CustomerNumber        + TxtSep +
      IdtOperator           + TxtSep +
      IdtCheckout           + TxtSep +
      CurrToStrF (PayAmountSystem, ffFixed, DmdFpnUtils.QtyDecsValue) + TxtSep +
      CurrToStrF (PayActualAmount, ffFixed, DmdFpnUtils.QtyDecsValue) + TxtSep +
      CurrToStrF (PayDifference, ffFixed, DmdFpnUtils.QtyDecsValue);
    if POS(IdtSubdiv, CtIdtClassCoupon) > 0 then
      TxtLine := TxtLine + TxtSep + TxtCouponNumber
    else if IdtSubdiv = CtIdtClassCheque then
      TxtLine := TxtLine + TxtSep + TxtCreditCardNum + TxtSep +
                 IntToStr(IdtPosTransOrig)
    else if IdtSubdiv = CtIdtClassCreditCard then
      TxtLine := TxtLine + TxtSep + TxtCreditCardNum + TxtSep +
                 IntToStr(IdtPosTransOrig)
    else if IdtSubdiv = CtIdtClassInstalment then
      TxtLine := TxtLine + TxtSep + TxtCreditCardNum + TxtSep + TxtLoanID +
                TxtSep + TxtLoanPeriod;
    VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
    Inc(QtyLines);
    ValAmountSystem := ValAmountSystem + PayAmountSystem;
    ValActualAmount := ValActualAmount + PayActualAmount;
    ValDifference := ValDifference + PayDifference;
  end
  else
    DmdFpnSalesByPaymethod.SprSalesByPaymethod.Next;
end;   // of TFrmDetSalesByPayMethod.PrintLineBody

//=============================================================================

procedure TFrmDetSalesByPayMethod.PrintLineSubTotal;
var
  TxtLine          : string;
begin  // of TFrmDetSalesByPayMethod.PrintLineSubTotal
  TxtLine := TxtSep + CtTxtSubTotal + TxtSep +TxtSep +TxtSep +TxtSep +TxtSep +
             TxtSep + CurrToStrF (ValAmountSystem, ffFixed,
             DmdFpnUtils.QtyDecsValue) + TxtSep + CurrToStrF (ValActualAmount,
             ffFixed, DmdFpnUtils.QtyDecsValue) + TxtSep + CurrToStrF (
             ValDifference, ffFixed, DmdFpnUtils.QtyDecsValue);
  VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
  ValAmountSystem := 0;
  ValActualAmount := 0;
  ValDifference   := 0;
end;   // of TFrmDetSalesByPayMethod.PrintLineSubTotal

//=============================================================================

procedure TFrmDetSalesByPayMethod.CmbBxPayTypeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmDetSalesByPayMethod.CmbBxPayTypeKeyDown
  inherited;
  if Key = VK_DELETE then
    CmbBxPayType.ItemIndex := -1;
end;   // of TFrmDetSalesByPayMethod.CmbBxPayTypeKeyDown

//=============================================================================

procedure TFrmDetSalesByPayMethod.ChkBxCreditCardClick(Sender: TObject);
begin  // of TFrmDetSalesByPayMethod.ChkBxCreditCardClick
  inherited;
  EdtCreditCard.Enabled := ChkBxCreditCard.Checked;
end;  // of TFrmDetSalesByPayMethod.ChkBxCreditCardClick

//=============================================================================

procedure TFrmDetSalesByPayMethod.ChkBxCouponClick(Sender: TObject);
begin  // of TFrmDetSalesByPayMethod.ChkBxCouponClick
  inherited;
  EdtCoupon.Enabled := ChkBxCoupon.Checked;
end;   // of TFrmDetSalesByPayMethod.ChkBxCouponClick

//=============================================================================

procedure TFrmDetSalesByPayMethod.FormActivate(Sender: TObject);
begin  // of TFrmDetSalesByPayMethod.FormActivate
  inherited;
  EdtCoupon.Enabled := ChkBxCoupon.Checked;
  EdtCreditCard.Enabled := ChkBxCreditCard.Checked;
end;  // of TFrmDetSalesByPayMethod.FormActivate

//=============================================================================

procedure TFrmDetSalesByPayMethod.SetGeneralSettings;
begin  // of TFrmDetSalesByPayMethod.SetGeneralSettings
  inherited;
  VspPreview.MarginTop := 2800;
end;   // of TFrmDetSalesByPayMethod.SetGeneralSettings

//=============================================================================

procedure TFrmDetSalesByPayMethod.PrintTableHeader;
begin  // of TFrmDetSalesByPayMethod.PrintTableHeader
  if VspPreview.CurrentY < VspPreview.PageHeight - 2000 then begin
    inherited;
    FlgHeaderPrinted := True;
  end
  else
    VspPreview.NewPage;
end;   // of TFrmDetSalesByPayMethod.PrintTableHeader

//=============================================================================

function TFrmDetSalesByPayMethod.GetItemsSelected: Boolean;
var
  CntIx      : Integer;          // Loop the checkouts in the Checklistbox
begin  // of TFrmDetSalesByPayMethod.GetItemsSelected
  Result := False;
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do begin
    if ChkLbxCheckout.Checked [CntIx] then begin
      Result := True;
      Break;
    end;
  end;
  if Result then
    Result := inherited GetItemsSelected;
end;   // of TFrmDetSalesByPayMethod.GetItemsSelected

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetSalesByPaymethod
