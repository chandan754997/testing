//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint
// Unit     : FDetDetailSales: DETail form for DETAIL SALES report
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetDetailSales.pas,v 1.16 2009/09/29 11:35:31 BEL\KDeconyn Exp $
//=============================================================================

unit FDetDetailSales;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetGeneralCA, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE, SfVSPrinter7,
  SmVSPrinter7Lib_TLB,DB, Mask;

//******************************************************************************
// Global definitions
//******************************************************************************

Const
  CtMaxNumDays        = 30;
  CtTxtDatFormatChina = 'yyyy-mm-dd';

  CtWidthColTransNr   = 10;
  CtWidthColTransDate = 10;
  CtWidthColBarcode   = 10;
  CtWidthColDescr     = 10;
  CtWidthColGroup     = 5;
  CtWidthColPrice     = 10;
  CtWidthColDiscount  = 10;
  CtWidthColQty       = 5;
  CtWidthColAmount    = 10;
  CtWidthColCustNr    = 15;
  CtWidthColCustOrder = 10;
  CtWidthColOperator  = 5;
  CtWidthColSalesType = 20;

resourcestring     // of Sales type
  CtTxtSTDetail       = 'Detail item';
  CtTxtSTCash         = 'Cash sales';
  CtTxtSTActual       = 'Actual sales';

resourcestring     // of header.
  CtTxtTitle            = 'DETAIL SALES REPORT BY PRODUCT';
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtSearchTrans      = 'Transaction nr %s';
  CtTxtSearchDate       = 'Ticket date between %s and %s';
  CtTxtSearchCust       = 'Customer nr %s';
  CtTxtSearchBarcode    = 'Barcode: %s';
  CtTxtSearchDept       = 'Department: %s';
  CtTxtSearchType       = 'Sales type: %s';
  CtTxtSearchCustOrder  = 'Customer order n? %s';
  CtTxtSearchOperator   = 'Cashier nr %s';
  CtTxtHeaderSep        = '; ';

resourcestring     // of table header
  CtTxtTransNum         = 'Transaction nr';
  CtTxtTransDateTime    = 'Transaction date/time';
  CtTxtBarcode          = 'Barcode';
  CtTxtSKU              = 'SKU description';
  CtTxtDept             = 'Dept';
  CtTxtUnitPrice        = 'Unit price with tax';
  CtTxtUnitPriceDisc    = 'Unit price after discount';
  CtTxtDiscount         = 'Discount amt (with tax)';
  CtTxtQty              = 'Qty';
  CtTxtAmount           = 'Amount (after discount with tax)';
  CtTxtCustNum          = 'Customer nr';
  CtTxtCustOrderNum     = 'Customer order nr';
  CtTxtOperatorNum      = 'Cashier nr';
  CtTxtSalesType        = 'Sales type';

resourcestring     // of CodSalesType
  CtTxtInStock          = 'in-stock item';
  CtTxtDownpayment      = 'customer order item with down payment';
  CtTxtCompleteDelivery = 'customer order item with completed delivery';

resourcestring     // of date errors
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtMaxDays          = 'Selected daterange may not contain more then %s days';
  CtTxtErrorHeader      = 'Incorrect Date';
  CtTxtErrorCustNum     = 'Invalid customer number';

//******************************************************************************
// Form-declaration.
//******************************************************************************

type
  TFrmDetDetailSales = class(TFrmDetGeneralCA)
    LblDatTrans: TLabel;
    LblTransNum: TLabel;
    EdtTransNum: TEdit;
    LblCustNum: TLabel;
    EdtCustNum: TEdit;
    LbLBarcode: TLabel;
    EdtBarcode: TEdit;
    LblDepartment: TLabel;
    LblSalesType: TLabel;
    LblCustorder: TLabel;
    EdtCustOrder: TEdit;
    CmbbxDepartment: TComboBox;
    CmbbxSalesType: TComboBox;
    procedure CmbbxDepartmentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnPrintClick(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    DsSales             : TDataSet;
    IdtPosTransaction   : Integer;
    DatTransBegin       : string;
    CodTrans            : integer;
    IdtCheckout         : integer;
    NumLineReg          : integer;
    BarCode             : string;
    ArtDescr            : string;
    Department          : string;
    UnitPrice           : Double;
    ValDiscount         : Double;
    Quantity            : Double;
    PriceAfterDiscount  : Double;
    UnitPriceDisc       : Double;
    CustomerNr          : string;
    CustOrderNr         : string;
    IdtOperator         : string;
    SalesType           : string;
    SubTotalDepartment  : string;
    SubTotalAmount      : Double;
    TotalAmount         : Double;
    // General
    procedure AutoStart (Sender : TObject); override;
    procedure FillSalesTypes; virtual;
    procedure FillDepartments; virtual;
    // Formats of the report
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string; virtual;
    function GetFmtTableTotal : string; virtual;
    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;
    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
    procedure GetInfoLine; virtual;
    procedure CalculateDiscount; virtual;
  public
    { Public declarations }
    property FmtTableSubTotal : string read GetFmtTableSubTotal;
    property FmtTableTotal : string read GetFmtTableTotal;
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure PrintTableFooter; override;
    procedure PrintSubTotalLine; virtual;
  end;

var
  FrmDetDetailSales: TFrmDetDetailSales;

//******************************************************************************

implementation

uses
  SfDialog,
  SmUtils,

  DFpnUtils,
  DFpnTradeMatrix,
  DFpnDetailSalesCA,

  DBTables;

{$R *.dfm}

//==============================================================================
// Source-identifiers
//==============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetDetailSales';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetDetailSales.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.16 $';
  CtTxtSrcDate    = '$Date: 2009/09/29 11:35:31 $';

//******************************************************************************
// Implementation of TFrmDetDetailSales
//******************************************************************************

procedure TFrmDetDetailSales.AutoStart(Sender: TObject);
begin  // of TFrmDetDetailSales.FormCreate
  inherited;
  // Add operator 0 to checklistbox operator
  if ChkLbxOperator.Items.IndexOfObject(TObject(0)) = -1 then
    ChkLbxOperator.Items.InsertObject (0, '0 : ' + CtTxtOperator + ' 0', TObject (0));
  FillSalesTypes;
  FillDepartments;
end;   // of TFrmDetDetailSales.FormCreate

//==============================================================================

procedure TFrmDetDetailSales.FillDepartments;
begin  // of TFrmDetDetailSales.FillDepartments
  inherited;
  try
    if DmdFpnUtils.QueryInfo ('SELECT IdtClassification, TxtPublDescr ' +
                              'FROM Classification ' +
                              'WHERE CodLevel = 1') then begin
      DmdFpnUtils.QryInfo.First;
      while not DmdFpnUtils.QryInfo.Eof do begin
        CmbbxDepartment.Items.Add(
            DmdFpnUtils.QryInfo.FieldByName ('IdtClassification').AsString + ' ' +
            DmdFpnUtils.QryInfo.FieldByName ('TxtPublDescr').AsString);
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetDetailSales.FillDepartments

//==============================================================================

procedure TFrmDetDetailSales.FillSalesTypes;
begin  // of TFrmDetDetailSales.FillSalesTypes
  inherited;
  CmbbxSalesType.Items.Add(CtTxtSTDetail);
  CmbbxSalesType.Items.Add(CtTxtSTCash);
  CmbbxSalesType.Items.Add(CtTxtSTActual);
  CmbbxSalesType.ItemIndex := 0;
end;   // of TFrmDetDetailSales.FillSalesTypes

//==============================================================================

function TFrmDetDetailSales.GetFmtTableHeader: string;
begin  // of TFrmDetDetailSales.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (CtWidthColTransNr, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColTransDate, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColBarcode, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColDescr, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColGroup, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColPrice, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColPrice, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColDiscount, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColQty, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColAmount, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColCustNr, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColCustOrder, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColOperator, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (CtWidthColSalesType, False));
end;   // of TFrmDetDetailSales.GetFmtTableHeader

//=============================================================================

function TFrmDetDetailSales.GetFmtTableBody : string;
begin  // of TFrmDetDetailSales.GetFmtTableBody
  Result := '<' + IntToStr (CalcWidthText (CtWidthColTransNr, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColTransDate, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColBarcode, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColDescr, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColGroup, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColPrice, False)) + TxtSep +
            //unit price before discount
            '<' + IntToStr (CalcWidthText (CtWidthColPrice, False)) + TxtSep +
            //unit price after discount
            '<' + IntToStr (CalcWidthText (CtWidthColDiscount, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColQty, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColAmount, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColCustNr, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColCustOrder, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColOperator, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColSalesType, False));
end;   // of TFrmDetDetailSales.GetFmtTableBody

//=============================================================================

function TFrmDetDetailSales.GetFmtTableTotal : string;
begin  // of TFrmDetDetailSales.GetFmtTableSubTotal
  Result := '<' + IntToStr (CalcWidthText (80, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (50, False));
end;   // of TFrmDetDetailSales.GetFmtTableSubTotal

//=============================================================================

function TFrmDetDetailSales.GetTxtTableTitle : string;
begin  // of TFrmDetDetailSales.GetTxtTableTitle
  Result :=   CtTxtTransNum        + TxtSep +
              CtTxtTransDateTime   + TxtSep +
              CtTxtBarcode         + TxtSep +
              CtTxtSKU             + TxtSep +
              CtTxtDept            + TxtSep +
              CtTxtUnitPrice       + TxtSep +
              CtTxtUnitPriceDisc   + TxtSep +
              CtTxtDiscount        + TxtSep +
              CtTxtQty             + TxtSep +
              CtTxtAmount          + TxtSep +
              CtTxtCustNum         + TxtSep +
              CtTxtCustOrderNum    + TxtSep +
              CtTxtOperatorNum     + TxtSep +
              CtTxtSalesType;
end;   // of TFrmDetDetailSales.GetTxtTableTitle

//=============================================================================

function TFrmDetDetailSales.GetTxtTableFooter : string;
begin  // of TFrmDetDetailSales.GetTxtTableFooter
  Result := TxtSep + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
            TxtSep + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
            TxtSep;
end;   // of TFrmDetDetailSales.GetTxtTableFooter

//=============================================================================

function TFrmDetDetailSales.GetTxtTitRapport : string;
begin  // of TFrmDetDetailSales.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetDetailSales.GetTxtTitRapport

//=============================================================================

function TFrmDetDetailSales.GetTxtRefRapport : string;
begin  // of TFrmDetDetailSales.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0036';
end;   // of TFrmDetDetailSales.GetTxtRefRapport

//=============================================================================

procedure TFrmDetDetailSales.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  CntIx            : Integer;          // Looping the CheckListBox.
  TxtOperators     : string;           // Selected operators
begin  // of TFrmDetDetailSales.PrintHeader
  inherited;
  // Report title
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  // Tradematrix information
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;
  // Search criteria
  if EdtTransNum.Text <> '' then
    TxtHdr := TxtHdr + Format(CtTxtSearchTrans, [EdtTransNum.Text]) + CtTxtHeaderSep;
  TxtHdr := TxtHdr + Format (CtTxtSearchDate,
            [FormatDateTime (CtTxtDatFormatChina, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormatChina, DtmPckDayTo.Date)]);
  if EdtCustNum.Text <> '' then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format(CtTxtSearchCust,
                                               [EdtCustNum.Text]);
  if EdtBarcode.Text <> '' then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format(CtTxtSearchBarcode,
                                               [EdtBarcode.Text]);
  if not (CmbbxDepartment.ItemIndex < 0) then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format(CtTxtSearchDept,
                                               [CmbbxDepartment.Text]);
  if not (CmbbxSalesType.ItemIndex < 0) then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format(CtTxtSearchType,
                                               [CmbbxSalesType.Text]);
  if EdtCustOrder.Text <> '' then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format(CtTxtSearchCustOrder,
              [EdtCustOrder.Text]);
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntIx] then begin
      if TxtOperators = '' then
        TxtOperators := IntToStr(Integer(ChkLbxOperator.Items.Objects[CntIx]))
      else
        TxtOperators := TxtOperators + ', ' + IntToStr(Integer(
                        ChkLbxOperator.Items.Objects[CntIx]));
    end;
  end;
  if TxtOperators <> '' then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format (CtTxtSearchOperator,
              [TxtOperators]);
    // Report date
  TxtHdr := TxtHdr + CRLF + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormatChina, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetDetailSales.PrintHeader

//=============================================================================

procedure TFrmDetDetailSales.PrintTableBody;
var
  TxtLine          : string;           // Line to print
  LstOperators     : TStringList;
  CntIx            : integer;
  FlgSubTotal      : Boolean;
begin  // of TFrmDetDetailSales.PrintTableBody
  inherited;
  FlgSubTotal    := False;
  SubTotalAmount := 0;
  TotalAmount    := 0;
  TxtLine        := '';
  Department     := '';
  LstOperators   := TStringList.Create;
  try
    for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
      if ChkLbxOperator.Checked [CntIx] then
        LstOperators.Add(IntToStr(Integer(ChkLbxOperator.Items.Objects[CntIx])));
    end;
    with DmdFpnDetailSalesCA.SprRptSalesByProduct do begin
      ParamByName('PrmDatFrom').AsString := FormatDateTime(CtTxtDatFormatChina +
        ' 00:00:00', DtmPckDayFrom.Date);
      ParamByName('PrmDatTo').AsString := FormatDateTime(CtTxtDatFormatChina +
        ' 23:59:59', DtmPckDayTo.Date);
      if EdtTransNum.Text <> '' then
        ParamByName('PrmIdtPOSTransaction').AsInteger := StrToInt(EdtTransNum.Text)
      else
        ParamByName('PrmIdtPOSTransaction').Clear;
      if EdtCustNum.Text <> '' then
        ParamByName('PrmIdtCustomer').AsString := (EdtCustNum.Text)
      else
        ParamByName('PrmIdtCustomer').Clear;
      if EdtBarCode.Text <> '' then
        ParamByName('PrmNumPLU').AsString := Trim(EdtBarcode.Text)
      else
        ParamByName('PrmNumPLU').Clear;
      if CmbbxDepartment.ItemIndex <> -1 then
        ParamByName('PrmIdtGroup').AsString := Copy(CmbbxDepartment.Text,0,2)
      else
        ParamByName('PrmIdtGroup').Clear;
      if CmbbxSalesType.ItemIndex <> -1 then
        ParamByName('PrmCodSalesType').AsInteger := CmbbxSalesType.ItemIndex
      else
        ParamByName('PrmCodSalesType').Clear;
      if EdtCustOrder.Text <> '' then
        ParamByName('PrmIdtCVente').AsFloat := StrToFloat(EdtCustOrder.Text)
      else
        ParamByName('PrmIdtCVente').Clear;
      Open;
    end;
    DsSales := DmdFpnDetailSalesCA.SprRptSalesByProduct;
    while not DsSales.Eof do begin
      GetInfoLine;
      DsSales.Next;
      if (LstOperators.IndexOf(IdtOperator) > -1) then begin
        ValDiscount := 0;
        if not DsSales.Eof
        and ((IdtPosTransaction = DsSales.FieldByName('IdtPOSTransaction').AsInteger)
        and (DatTransBegin = DsSales.FieldByName('DatTransBegin').AsString)
        and (CodTrans = DsSales.FieldByName('CodTrans').AsInteger)
        and (IdtCheckout = DsSales.FieldByName('IdtCheckout').AsInteger)
        and (NumLineReg = DsSales.FieldByName('NumLineReg').AsInteger)) then
          CalculateDiscount;
        PriceAfterDiscount := (Quantity * UnitPrice) + ValDiscount;
        SubTotalAmount := SubTotalAmount + PriceAfterDiscount;
        UnitPriceDisc := PriceAfterDiscount / Quantity;
        SubTotalDepartment := Department;
        //PrintLine
        TxtLine := IntToStr(IdtPosTransaction) + TxtSep + DatTransBegin + TxtSep +
                   BarCode + TxtSep + ArtDescr + TxtSep + Department + TxtSep +
                   CurrToStrF (UnitPrice, ffFixed, DmdFpnUtils.QtyDecsValue) +
                   TxtSep + CurrToStrF (UnitPriceDisc, ffFixed,
                   DmdFpnUtils.QtyDecsValue) + TxtSep + CurrToStrF (-ValDiscount,
                   ffFixed, DmdFpnUtils.QtyDecsValue) + TxtSep +  //Reverse sign
                   CurrToStrF (Quantity, ffFixed, DmdFpnUtils.QtyDecsValue) +
                   TxtSep + CurrToStrF (PriceAfterDiscount, ffFixed,
                   DmdFpnUtils.QtyDecsValue) + TxtSep + CustomerNr + TxtSep +
                   CustOrderNr + TxtSep + IdtOperator + TxtSep + SalesType;
        VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
        FlgSubTotal := True;
        if Department <> DsSales.FieldByName('IdtGroup').AsString then begin
          TotalAmount := TotalAmount + SubTotalAmount;
          PrintSubTotalLine;
          FlgSubTotal := False;
          SubTotalAmount := 0;
        end;
      end;; //of if pos(idtoperator
    end; //of while
    TotalAmount := TotalAmount + SubTotalAmount;
    if FlgSubTotal then
      PrintSubTotalLine;
    SubTotalAmount := 0;
  finally
    DsSales.Close;
    LstOperators.Free
  end;
end;   // of TFrmDetDetailSales.PrintTableBody

//=============================================================================

procedure TFrmDetDetailSales.PrintTableFooter;
var
  TxtLine          : string;
begin  // of TFrmDetDetailSales.PrintTableFooter
  TxtLine := 'TOTAL' + TxtSep +
             CurrToStrF (TotalAmount, ffFixed, DmdFpnUtils.QtyDecsValue);
  VspPreview.AddTable (FmtTableTotal, '', TxtLine, clWhite, clWhite, False);
  //VspPreview.Text := CRLF;
end;   // of TFrmDetDetailSales.PrintTableFooter

//=============================================================================

procedure TFrmDetDetailSales.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetDetailSales.BtnPrintClick
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
    Application.MessageBox(PChar(Format (CtTxtMaxDays,[IntToStr(CtMaxNumDays)])),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  else
    inherited;
end;   // of TFrmDetDetailSales.BtnPrintClick

//=============================================================================

procedure TFrmDetDetailSales.GetInfoLine;
var
  CodSalesType     : integer;
begin  // of TFrmDetDetailSales.GetInfoLine
  IdtPosTransaction := DsSales.FieldByName('IdtPOSTransaction').AsInteger;
  DatTransBegin := DsSales.FieldByName('DatTransBegin').AsString;
  CodTrans := DsSales.FieldByName('CodTrans').AsInteger;
  IdtCheckout := DsSales.FieldByName('IdtCheckout').AsInteger;
  NumLineReg := DsSales.FieldByName('NumLineReg').AsInteger;
  BarCode := DsSales.FieldByName('NumPLU').AsString;
  ArtDescr := DsSales.FieldByName('TxtDescr').AsString;
  Department := DsSales.FieldByName('IdtGroup').AsString;
  UnitPrice := DsSales.FieldByName('PrcInclVAT').AsFloat;
  Quantity := DsSales.FieldByName('QtyReg').AsFloat;
  PriceAfterDiscount := DsSales.FieldByName('ValInclVAT').AsFloat;
  CustomerNr := DsSales.FieldByName('NumCard').AsString;
  CustOrderNr := DsSales.FieldByName('IdtCVente').AsString;
  IdtOperator := DsSales.FieldByName('IdtOperator').AsString;
  CodSalesType := DsSales.FieldByName('CodSalesType').AsInteger;
  case CodSalesType of
    0: SalesType := CtTxtInStock;
    1: SalesType := CtTxtDownpayment;
    2: SalesType := CtTxtCompleteDelivery;
  end;
end;   // of TFrmDetDetailSales.GetInfoLine

//=============================================================================

procedure TFrmDetDetailSales.CalculateDiscount;
begin  // of TFrmDetDetailSales.CalculateDiscount
  ValDiscount := 0;
  while not DsSales.Eof
  and ((IdtPosTransaction = DsSales.FieldByName('IdtPOSTransaction').AsInteger)
  and (DatTransBegin = DsSales.FieldByName('DatTransBegin').AsString)
  and (CodTrans = DsSales.FieldByName('CodTrans').AsInteger)
  and (IdtCheckout = DsSales.FieldByName('IdtCheckout').AsInteger)
  and (NumLineReg = DsSales.FieldByName('NumLineReg').AsInteger)) do begin
    case DsSales.FieldByName('CodAction').AsInteger of
      90 : begin // amount discount on article
        ValDiscount := ValDiscount + DsSales.FieldByName('ValInclVAT').AsFloat;
      end;
      91 : begin // free article
        ValDiscount := Quantity * UnitPrice;
      end;
      93 : begin // campaign price
        ValDiscount := ValDiscount + (Quantity * (
                       DsSales.FieldByName('PrcInclVAT').AsFloat - UnitPrice));
      end;
      95 : begin // discount on customer base
        ValDiscount := ValDiscount + DsSales.FieldByName('ValInclVAT').AsFloat;
      end;
      120: begin // overwrite price with manual price
                 // ==> this is no discount but a new unitprice
        ValDiscount := 0;
      end;
    end;
    DsSales.Next;
  end;
end;   // of TFrmDetDetailSales.CalculateDiscount

//=============================================================================

procedure TFrmDetDetailSales.PrintSubTotalLine;
var
  TxtLine          : string;
begin  // of TFrmDetDetailSales.PrintSubTotalLine
  TxtLine := 'SUBTOTAL' + TxtSep + SubTotalDepartment + TxtSep + TxtSep +
             CurrToStrF (SubTotalAmount, ffFixed, DmdFpnUtils.QtyDecsValue);
  VspPreview.AddTable (FmtTableSubtotal, '', TxtLine, clWhite, clWhite, False);
end;   // of TFrmDetDetailSales.PrintSubTotalLine

//=============================================================================

function TFrmDetDetailSales.GetFmtTableSubTotal: string;
begin  // of TFrmDetDetailSales.GetFmtTableSubTotal
  Result := '<' + IntToStr (CalcWidthText (40, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColGroup, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (35, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (CtWidthColAmount, False)) + TxtSep +
            '<' + IntToStr (CalcWidthText (50, False));
end;   // of TFrmDetDetailSales.GetFmtTableSubTotal

//=============================================================================

procedure TFrmDetDetailSales.CmbbxDepartmentKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmDetDetailSales.CmbbxDepartmentKeyDown
  inherited;
  if Key = VK_DELETE then
    CmbbxDepartment.ItemIndex := -1;
end;   // of TFrmDetDetailSales.CmbbxDepartmentKeyDown

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetDetailSales
