//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Standard Development
// Unit   : FDetRetoursMarchandises.PAS : Standard Form AUTOmatic RUN
//          Basic mainform with facilities for applications to run automatic.
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetRetoursMarchandises.pas,v 1.17 2010/09/27 09:50:31 BEL\DVanpouc Exp $
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetRetoursMarchandises.pas,v 1.18 2011/08/04 20:00:31 TCS\MVD Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetRetoursMarchandises - CVS revision 1.20
// - Started from Castorama - FlexPoint 2.0 - FDetRetoursMarchandises - CVS revision 1.21 R2011.2 TCS MVD
//=============================================================================
// Version   Modified By    Reason
// V 1.22    SM    (TCS)    R2013.1-21050-Export excel of returned goods report
// V 1.23    SM    (TCS)    R2013.1-Internal Defect Fix 722-Export excel of returned goods report
// V 1.24    SM    (TCS)    R2013.1-Internal Defect Fix 857-Export excel of returned goods report
// V 1.25    SM    (TCS)    R2013.1-Internal Defect Fix 874-Export excel of returned goods report
// V 1.26    SM    (TCS)    R2013.1-HPQC Defect Fix 13-Export excel of returned goods report
// V 1.27    SMB   (TCS)    R2013.2.ALM Defect Fix 164.All OPCO
// V 1.28    MeD   (TCS)    R2014.2.31150-TakeBack_Report.All OPCO
//*****************************************************************************
unit FDetRetoursMarchandises;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE,
  ScUtils, SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables,
  FDetGeneralCA, ExtDlgs;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Constants
//=============================================================================

const
  CtMaxNumDays         = 30;
  CtCodReasonCodeField = 'CodReason';
  CtCodReturnTable     = 'Return';
  CtTxtDatFormatChina  = 'yyyy-mm-dd';

//=============================================================================
// Resource strings
//=============================================================================

resourcestring     // of header.
  CtTxtTitle            = 'Return of merchandise';
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtReportDate       = 'Report from %s to %s';

resourcestring     // of table header.
  CtTxtNbOperator       = 'Operator nr';
  CtTxtCheckout         = 'Checkout nr';						//R2014.2-31150-TakeBack_Report-TCS(MeD)
  CtTxtDate             = 'Date';
  CtTxtRayon            = 'Shelf';
  CtTxtQty              = 'Qty';
  CtTxtNumPLU           = 'PLU Number';
  CtTxtSKUNum           = 'SKU';
  CtTxtCodeCasto        = 'Correction Code Brico';
  CtTxtDescr            = 'Description article';
  CtTxtTicketNr         = 'Ticket Nr';
  CtTxtSuggestPrice     = 'Suggest Price';
  CtTxtMotif            = 'Motif of Take Back';
  CtTxtSubTotCaissiere  = 'S/Total cashier';
  CtTxtSubTotDepartment = 'S/Total department';
  CtTxtSubTotTicket     = 'S/Total ticket';

resourcestring     // of table header (B&Q specific)
  CtTxtSalesType        = 'Sales type';
  CtTxtCustName         = 'Customer name';
  CtTxtSalesQty         = 'Sales qty';
  CtTxtRefundQty        = 'Refund qty';
  CtTxtSalesAmount      = 'Sales amount';
  CtTxtRefundAmount     = 'Refund amount';
  CtTxtDepartment       = 'Department';

resourcestring          // of date errors
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtMaxDays          = 'Selected daterange may not contain more than %s days';
  CtTxtErrorHeader      = 'Incorrect Date';

resourcestring
 CtTxtCustOrder         = 'Customer order item';
 CtTxtInStock           = 'In-stock item';

resourcestring          // of run parameters
  CtTxtBQChina          = '/VBQC=Lay-out for B&Q China';
  CtTxtUOM              = '/VUOM=UOM notation of article code';
  CtTxtBRES             = '/VEXP=EXP export to excel for Spain';
  CtTxtCAFR             = '/VCAFR=CAFR export to excel for CAFR';                //R2013.1-21050-Export excel of returned goods report-TCS(SM)

resourcestring // of export to excel parameters
  CtTxtPlace            = 'D:\sycron\transfertbo\excel';
  CtTxtExists           = 'File exists, Overwrite?';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetRetoursMarchandises = class(TFrmDetGeneralCA)
    SprRetourDetail: TStoredProc;
    SprRetourDetailBQ: TStoredProc;
    PnlBQC: TPanel;
    LblTransNum: TLabel;
    EdtTransNum: TEdit;
    LbLBarcode: TLabel;
    LblDepartment: TLabel;
    LblSalesType: TLabel;
    EdtBarcode: TEdit;
    CmbbxDepartment: TComboBox;
    CmbbxSalesType: TComboBox;
    PnlCheckout: TPanel;
    ChkLbxCheckout: TCheckListBox;
    BtnSelectAllCheckout: TBitBtn;
    BtnDESelectAllCheckout: TBitBtn;
    CmbbxReasonCode: TComboBox;
    Label1: TLabel;
    BtnExport: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    SprPaymentMethodExport: TStoredProc;                                        // R2013.1-HPQC Defect Fix 13-Export excel of returned goods report
    procedure BtnDeSelectAllClick(Sender: TObject);                             // R2011.2 TCS(Mohan) Bug 11
    procedure BtnExportClick(Sender: TObject);
    procedure CmbbxReasonCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CmbbxSalesTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CmbbxDepartmentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnDESelectAllCheckoutClick(Sender: TObject);
    procedure BtnSelectAllCheckoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
  private
    { Private declarations }
    FFlgBQChina    : boolean;
    FFlgUOM        : boolean;          // OUM notation article code
    FFlgSpanje     : boolean;
    FFlgCAFR       : boolean;                                                        //R2013.1-21050-Export excel of returned goods report-TCS(SM)
  protected
    //QtyAmount      : Integer;          // Number of Retours
    QtyAmount      : Double;          // R2011.2 TCS(Mohan) Bug 16
    QtyAmountOrig  : Integer;
    ValAmount      : Double;           // Total Value of all Retours
    ValAmountOrig  : Double;
    // Run params
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure AutoStart (Sender : TObject); override;
    function GetItemsSelected : Boolean; override;
    procedure FillDepartments; virtual;
    procedure FillSalesTransactionTypes; virtual;
    procedure FillReasonCodes; virtual;
    procedure FillLbxCheckouts; virtual;
    // Table functions
    function CreateRefundTable :  boolean; virtual;
    function DropRefundTable : boolean;
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string; virtual;
    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;
    function GetTxtLstCheckoutID : string; virtual;
    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
    function BuildSQLGeneralRetours : string;
    function BuildSQLTmpRefund : string;
    function GetTxtLstOperID : string; override; // R2011.2 TCS(Mohan) Bug 11
  public
    { Public declarations }
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure PrintTableBodyBQ; virtual;
    procedure PrintSubTotalTicket (NumTicket       : Integer;
                                   //QtyTicketAmount : Integer;
                                   QtyTicketAmount : Double; // R2011.2 TCS(Mohan) Bug 16
                                   ValTicketAmount : Double;
                                   StrLstPayments  : TStringList); virtual;
    procedure PrintSubTotal (NumOperator   : Integer;
                             //QtyOperAmount : Integer;
                              QtyOperAmount : Double; // R2011.2 TCS(Mohan) Bug 16
                             ValOperAmount : Double); overload;
    procedure PrintSubTotal (StrDepartment : string;
                             //QtyDepAmount  : Integer;
                              QtyDepAmount  : Double;  // R2011.2 TCS(Mohan) Bug 16
                             QtyDepOrig : Integer;
                             ValDepAmount  : Double;
                             ValDepOrig: Double); overload;
    procedure PrintTableFooter; override;
    property FmtTableSubTotal : string read GetFmtTableSubTotal;
    property FlgBQChina: Boolean read FFlgBQChina write FFlgBQChina;
    property FlgUOM : boolean read FFlgUOM write FFlgUOM;
    property FlgSpanje: boolean read FFlgSpanje write FFlgSpanje;
    property FlgCAFR: boolean read FFlgCAFR write FFlgCAFR;                     //R2013.1-21050-Export excel of returned goods report-TCS(SM)
    property TxtLstCheckoutID : string read GetTxtLstCheckoutID;
    procedure Execute; override;
  end;

var
  FrmDetRetoursMarchandises: TFrmDetRetoursMarchandises;
//R2013.1-21050-Export excel of returned goods report-TCS(SM)::START
  NumCurrentTicket         : integer;
  QtyTickAmount            : double;
  QtyOperAmount            : double;
  ValTickAmount            : double;
  ValOperAmount            : double;
  StrLstPayment            : Tstringlist;
  TxtLine                  : string;           // Line to print
  TxtPayments              : string;           // All payments of one ticket
  CntPayments              : Integer;          // Loop all payments
  TxtSeper                 : string;           // Seperator between payments
//R2013.1-21050-Export excel of returned goods report-TCS(SM)::END


//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils,
  DFpnTradeMatrix,
  DFpnPosTransaction;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetRetoursMarchandises.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.27 $';
  CtTxtSrcDate    = '$Date: 2014/03/06 09:50:31 $';

//*****************************************************************************
// Implementation of TFrmDetRetroursMarchandises
//*****************************************************************************

procedure TFrmDetRetoursMarchandises.Execute;
var CntChkLstBx : integer;  // R2011.2 TCS(Mohan) Bug 11
begin  // of TFrmDetRetoursMarchandises.Execute
  if FlgBQChina then
    VspPreview.Font.Size := 7;
  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  if FlgBQChina then
    PrintTableBodyBQ
  else
    PrintTableBody;
  PrintTableFooter;
  VspPreview.EndDoc;

  PrintPageNumbers;
  PrintReferences;

  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
// R2011.2 TCS(Mohan) Bug 11 Start
   for CntChkLstBx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
     if ChkLbxOperator.Checked [CntChkLstBx] then begin
       ChkLbxOperator.State [CntChkLstBx] := cbGrayed;
     end;
  end;
// R2011.2 TCS(Mohan) Bug 11 End

end;   // of TFrmDetRetoursMarchandises.Execute

//=============================================================================

function TFrmDetRetoursMarchandises.GetFmtTableHeader: string;
begin  // of TFrmDetRetroursMarchandises.GetFmtTableHeader
  if FlgBQChina then begin
    Result := '^+' + IntToStr (CalcWidthText (19, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (8, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (7, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (7, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (17, False));
  end
  else begin
    Result := '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +    //R2014.2-31150-TakeBack_Report-TCS(MeD)
              '^+' + IntToStr (CalcWidthText ( 5, False)) + TxtSep +    //R2014.2-31150-TakeBack_Report-TCS(MeD)
              '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText ( 5, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (15, False));
  end;
end;   // of TFrmDetRetroursMarchandises.GetFmtTableHeader

//=============================================================================

function TFrmDetRetoursMarchandises.GetFmtTableBody : string;
begin  // of TFrmDetRetroursMarchandises.GetFmtTableBody
  if FlgBQChina then begin
    Result := '<' + IntToStr (CalcWidthText (19, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (8, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (7, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (7, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (17, False));
  end
  else begin
    Result := '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +    //R2014.2-31150-TakeBack_Report-TCS(MeD)
              '<' + IntToStr (CalcWidthText ( 5, False)) + TxtSep +    //R2014.2-31150-TakeBack_Report-TCS(MeD)
              '<' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText ( 5, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (15, False));
  end;
end;   // of TFrmDetRetroursMarchandises.GetFmtTableBody

//=============================================================================

function TFrmDetRetoursMarchandises.GetFmtTableSubTotal : string;
begin  // of TFrmDetRetroursMarchandises.GetFmtTableSubTotal
  if FlgBQChina then begin
    Result := '<' + IntToStr (CalcWidthText (19, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (8, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (7, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (7, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (17, False));
  end
  else begin
    Result := '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +  //R2014.2-31150-TakeBack_Report-TCS(MeD)
              '<' + IntToStr (CalcWidthText ( 5, False)) + TxtSep +  //R2014.2-31150-TakeBack_Report-TCS(MeD)
              '<' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText ( 5, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (15, False));
  end;
end;   // of TFrmDetRetroursMarchandises.GetFmtTableSubTotal

//=============================================================================

function TFrmDetRetoursMarchandises.GetTxtTableTitle : string;
begin  // of TFrmDetRetroursMarchandises.GetTxtTableTitle
  if FlgBQChina then begin
    Result := CtTxtSalesType    + TxtSep +
              CtTxtNbOperator   + TxtSep +
              CtTxtDate         + TxtSep +
              CtTxtCustName     + TxtSep +
              CtTxtSalesQty     + TxtSep +
              CtTxtRefundQty    + TxtSep +
              CtTxtSalesAmount  + TxtSep +
              CtTxtRefundAmount + TxtSep +
              CtTxtDepartment   + TxtSep +
              CtTxtSKUNum       + TxtSep +
              CtTxtDescr        + TxtSep +
              CtTxtTicketNr     + TxtSep +
              CtTxtMotif;
  end
  else begin
    Result := CtTxtNbOperator   + TxtSep +
              CtTxtCheckout     + TxtSep +     //R2014.2-31150-TakeBack_Report-TCS(MeD)
              CtTxtDate         + TxtSep +
              CtTxtRayon        + TxtSep +
              CtTxtQty          + TxtSep +
              CtTxtNumPLU       + TxtSep +
              CtTxtCodeCasto    + TxtSep +
              CtTxtDescr        + TxtSep +
              CtTxtTicketNr     + TxtSep +
              CtTxtSuggestPrice + TxtSep +
              CtTxtMotif;
  end;
end;   // of TFrmDetRetroursMarchandises.GetTxtTableTitle

//=============================================================================

function TFrmDetRetoursMarchandises.GetTxtTableFooter : string;
begin  // of TFrmDetRetroursMarchandises.GetTxtTableFooter
  if FlgBQChina then
    Result := CtTxtTotal + TxtSep + TxtSep + TxtSep + TxtSep +
              IntToStr (QtyAmountOrig) + TxtSep +
              {IntToStr (QtyAmount)} FloatToStr(QtyAmount) // R2011.2 TCS(Mohan) Bug 16
              + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValAmountOrig) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValAmount) + TxtSep
  else
    Result := CtTxtTotal + TxtSep + TxtSep + TxtSep + TxtSep + {IntToStr (QtyAmount)} FloatToStr (QtyAmount)  //R2014.2-31150-TakeBack_Report-TCS(MeD)// R2011.2 TCS(Mohan) Bug 16
              + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValAmount);
end;   // of TFrmDetRetroursMarchandises.GetTxtTableFooter

//=============================================================================

function TFrmDetRetoursMarchandises.GetTxtTitRapport : string;
begin  // of TFrmDetRetroursMarchandises.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetRetroursMarchandises.GetTxtTitRapport

//=============================================================================

function TFrmDetRetoursMarchandises.GetTxtRefRapport : string;
begin  // of TFrmDetRetroursMarchandises.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0006';
end;   // of TFrmDetRetroursMarchandises.GetTxtRefRapport

//=============================================================================

procedure TFrmDetRetoursMarchandises.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  TxtDatFormat     : string;
begin  // of TFrmDetRetroursMarchandises.PrintHeader
  inherited;
  if FlgBQChina then
    TxtDatFormat := CtTxtDatFormatChina
  else
    TxtDatFormat := CtTxtDatFormat;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  if RbtDateDay.Checked then
     TxtHdr := TxtHdr + Format (CtTxtReportDate,
               [FormatDateTime (TxtDatFormat, DtmPckDayFrom.Date),
               FormatDateTime (TxtDatFormat, DtmPckDayTo.Date)]) + CRLF
  else
     TxtHdr := TxtHdr + Format (CtTxtReportDate,
               [FormatDateTime (TxtDatFormat, DtmPckLoadedFrom.Date),
               FormatDateTime (TxtDatFormat, DtmPckLoadedTo.Date)]) + CRLF;
  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (TxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;
      
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetRetroursMarchandises.PrintHeader

//=============================================================================

procedure TFrmDetRetoursMarchandises.PrintTableBody;
var
  NumCurrentOper   : Integer;          // Number of current operator to process
  NumCurrentLineReg: Integer;          // Number of current registration line
  ValOperAmount    : Double;           // Turnover for 1 operator
  //QtyOperAmount    : Integer;
  QtyOperAmount    : Double; // R2011.2 TCS(Mohan) Bug 16     // Qty per operator.
  //NumCurrentTicket : Integer;          // Number of current operator to process //Commented for R2013.1-21050-Export excel of returned goods report-TCS(SM)
  //ValTickAmount    : Double;           // Turnover for 1 ticket //Commented for R2013.1-21050-Export excel of returned goods report-TCS(SM)
  //QtyTickAmount  : Integer;          // Qty per ticket. 
  //QtyTickAmount    : Double; // R2011.2 TCS(Mohan) Bug 16 //Commented for R2013.1-21050-Export excel of returned goods report-TCS(SM)
  TxtLine          : string;           // Line to print
  //StrLstPayment    : TStringList;      // List of all the payments for 1 ticket //Commented for R2013.1-21050-Export excel of returned goods report-TCS(SM)
  FlgNext          : boolean;
begin  // of TFrmDetRetroursMarchandises.PrintTableBody
  inherited;
  ValAmount := 0;
  QtyAmount := 0;
  StrLstPayment := TStringList.Create;
  StrLstPayment.Sorted := True;
  StrLstPayment.Duplicates := dupIgnore;
  try
    if DmdFpnUtils.QueryInfo (BuildSQLGeneralRetours) then begin
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      while not DmdFpnUtils.QryInfo.Eof do begin
        NumCurrentOper := DmdFpnUtils.QryInfo.
                            FieldByName ('IdtOperator').AsInteger;
        ValOperAmount  := 0;
        QtyOperAmount  := 0;
        while (NumCurrentOper = DmdFpnUtils.QryInfo.
               FieldByName ('IdtOperator').AsInteger) and not
               DmdFpnUtils.QryInfo.Eof do begin
          NumCurrentTicket :=
              DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsInteger;
          ValTickAmount := 0;
          QtyTickAmount := 0;
          sprRetourDetail.Close;
          sprRetourDetail.ParamByName('@PrmIdtPosTransaction').AsInteger :=
                 DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsInteger;
          sprRetourDetail.ParamByName('@PrmIdtCheckout').AsInteger :=
                 DmdFpnUtils.QryInfo.FieldByName('IdtCheckout').AsInteger;
          sprRetourDetail.ParamByName('@PrmCodTrans').AsInteger :=
                 DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger;
          sprRetourDetail.ParamByName('@PrmDatTransBegin').AsDateTime :=
                 DmdFpnUtils.QryInfo.FieldByName('DatTransBegin').AsDateTime;
          sprRetourDetail.Open;
          if not sprRetourDetail.IsEmpty then begin
            while not sprRetourDetail.Eof do begin
              FlgNext := False;
              if not (sprRetourDetail.FieldByName('CodAction').AsInteger =
                      CtCodActDiscArtPct) then begin
                TxtLine :=
                 SprRetourDetail.FieldByName ('IdtOperator').AsString + TxtSep+
                 SprRetourDetail.FieldByName ('IdtCheckout').AsString + TxtSep+ 			//R2014.2-31150-TakeBack_Report-TCS(MeD)
                 SprRetourDetail.FieldByName ('DatTransBegin').AsString + TxtSep+
                 SprRetourDetail.FieldByName ('Rayon').AsString + TxtSep;
                 //if SprRetourDetail.FieldByName('QtyReg').AsInteger < 0 then   // R2011.2 TCS(Mohan) Bug 16
                 if SprRetourDetail.FieldByName('QtyReg').AsFloat < 0 then
                   //TxtLine := TxtLine + IntToStr (Abs
                   TxtLine := TxtLine + FloatToStr (Abs    // R2011.2 TCS(Mohan) Bug 16
                            //(SprRetourDetail.FieldByName('QtyReg').AsInteger))
                            (SprRetourDetail.FieldByName('QtyReg').AsFloat))  // R2011.2 TCS(Mohan) Bug 16
                 else begin
                   if SprRetourDetail.FieldByName('QtyReg').AsFloat > 0 then    // R2011.2 TCS(Mohan) Bug 16
                     TxtLine := TxtLine + FloatToStr (-
                            (SprRetourDetail.FieldByName('QtyReg').AsFloat));   // R2011.2 TCS(Mohan) Bug 16
                 end;
                 TxtLine := TxtLine + TxtSep +
                 SprRetourDetail.FieldByName ('NumPLU').AsString + TxtSep +
                 SprRetourDetail.FieldByName ('IdtArticle').AsString + TxtSep +
                 SprRetourDetail.FieldByName ('TxtDescr').AsString + TxtSep +
                 SprRetourDetail.FieldByName ('IdtPOSTransaction').AsString +
                 TxtSep + FormatFloat (CtTxtFrmNumber,
                          - SprRetourDetail.FieldByName ('VALInclVAT').AsFloat) +
                 TxtSep +
                 SprRetourDetail.FieldByName ('Modif').AsString;
              end
              else begin
                TxtLine :=  TxtSep + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
                SprRetourDetail.FieldByName ('TxtDescr').AsString + TxtSep + TxtSep +
                FormatFloat (CtTxtFrmNumber,
                       - SprRetourDetail.FieldByName ('VALInclVAT').AsFloat) +
                TxtSep;
              end;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                                   clWhite, False);
             // if SprRetourDetail.FieldByName('QtyReg').AsInteger < 0 then begin
              if SprRetourDetail.FieldByName('QtyReg').AsFloat < 0 then begin    // R2011.2 TCS(Mohan) Bug 16
                QtyOperAmount := QtyOperAmount +
                       // Abs (SprRetourDetail.FieldByName('QtyReg').AsInteger);
                        Abs (SprRetourDetail.FieldByName('QtyReg').AsFloat);     // R2011.2 TCS(Mohan) Bug 16
                QtyTickAmount := QtyTickAmount +
                        //Abs (SprRetourDetail.FieldByName('QtyReg').AsInteger);
                        Abs (SprRetourDetail.FieldByName('QtyReg').AsFloat);    // R2011.2 TCS(Mohan) Bug 16
              end
              else begin
                if SprRetourDetail.FieldByName('QtyReg').AsFloat > 0 then begin   // R2011.2 TCS(Mohan) Bug 16
                  QtyOperAmount := QtyOperAmount +
                         (-SprRetourDetail.FieldByName('QtyReg').AsFloat);    // R2011.2 TCS(Mohan) Bug 16
                  QtyTickAmount := QtyTickAmount +
                         (-SprRetourDetail.FieldByName('QtyReg').AsFloat);   // R2011.2 TCS(Mohan) Bug 16
                end;
              end;
              ValOperAmount := ValOperAmount +
                       - SprRetourDetail.FieldByName('VALInclVAT').AsFloat;
              ValTickAmount := ValTickAmount +
                       - SprRetourDetail.FieldByName('VALInclVAT').AsFloat;

              NumCurrentLineReg := SprRetourDetail.FieldByName ('NumLineReg').AsInteger;
              StrLstPayment.Clear;
              if (SprRetourDetail.FieldByName('CodAction').AsInteger in
                            [CtCodActDiscArtPct,CtCodActDiscArtVal]) then begin
                while (NumCurrentTicket = SprRetourDetail.
                       FieldByName ('IdtPOSTransaction').AsInteger) and
                      (NumCurrentLineReg = SprRetourDetail.
                       FieldByName ('NumLineReg').AsInteger) and
                      (NumCurrentOper = SprRetourDetail.
                       FieldByName ('IdtOperator').AsInteger) and
                      (SprRetourDetail.FieldByName('CodAction').AsInteger in
                      [CtCodActDiscArtPct,CtCodActDiscArtVal]) and
                      not (SprRetourDetail.Eof) do begin
                  StrLstPayment.Add (SprRetourDetail.FieldByName ('Payment').AsString);
                  SprRetourDetail.Next;
                  FlgNext := True;
                end;
              end
              else begin
                while (NumCurrentTicket = SprRetourDetail.
                       FieldByName ('IdtPOSTransaction').AsInteger) and
                      (NumCurrentLineReg = SprRetourDetail.
                       FieldByName ('NumLineReg').AsInteger) and
                      (NumCurrentOper = SprRetourDetail.
                       FieldByName ('IdtOperator').AsInteger) and
                      (not(SprRetourDetail.FieldByName('CodAction').AsInteger in
                      [CtCodActDiscArtPct,CtCodActDiscArtVal])) and
                       not (SprRetourDetail.Eof) do begin
                  StrLstPayment.Add (SprRetourDetail.FieldByName ('Payment').AsString);
                  SprRetourDetail.Next;
                  FlgNext := True;
                end;
              end;
              if not FlgNext then
                SprRetourDetail.Next;
            end;
            PrintSubTotalTicket (NumCurrentTicket, QtyTickAmount, ValTickAmount,
                               StrLstPayment);
          end;
          DmdFpnUtils.QryInfo.Next;
        end;
        PrintSubTotal (NumCurrentOper, QtyOperAmount, ValOperAmount);
      end;
      VspPreview.EndTable;
    end;
  finally
    DmdFpnUtils.CloseInfo;
    StrLstPayment.Free;
  end;
end;   // of TFrmDetRetroursMarchandises.PrintTableBody

//=============================================================================

procedure TFrmDetRetoursMarchandises.PrintTableBodyBQ;
var
  StrDepartment    : string;           // Number of current operator to process
  ValDepAmount     : Double;           // Turnover for 1 operator
 // QtyDepAmount     : Integer;
  QtyDepAmount     : double; // R2011.2 TCS(Mohan) Bug 16 // Qty per operator.
  ValDepOrig       : double;
  QtyDepOrig       : Integer;
  TxtLine          : string;           // Line to print
  StrLstPayment    : TStringList;      // List of all the payments for 1 ticket
  TxtPrevTrans     : string;
  TxtPrevArt       : string;
begin  // of TFrmDetRetroursMarchandises.PrintTableBodyBQ
  ValAmount     := 0;
  ValAmountOrig := 0;
  ValDepAmount  := 0;
  ValDepOrig    := 0;
  QtyAmount     := 0;
  QtyAmountOrig := 0;
  QtyDepAmount  := 0;
  QtyDepOrig    := 0;
  StrLstPayment := TStringList.Create;
  StrLstPayment.Sorted := True;
  StrLstPayment.Duplicates := dupIgnore;
  if CreateRefundTable then begin
    try
      if DmdFpnUtils.QueryInfo (BuildSQLGeneralRetours) then begin
        while not DmdFpnUtils.QryInfo.Eof do begin
          sprRetourDetailBQ.Close;
          sprRetourDetailBQ.ParamByName('@PrmIdtPosTransaction').AsInteger :=
                 DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsInteger;
          sprRetourDetailBQ.ParamByName('@PrmIdtCheckout').AsInteger :=
                 DmdFpnUtils.QryInfo.FieldByName('IdtCheckout').AsInteger;
          sprRetourDetailBQ.ParamByName('@PrmCodTrans').AsInteger :=
                 DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger;
          sprRetourDetailBQ.ParamByName('@PrmDatTransBegin').AsDateTime :=
                 DmdFpnUtils.QryInfo.FieldByName('DatTransBegin').AsDateTime;
          sprRetourDetailBQ.ExecProc;
          DmdFpnUtils.QryInfo.Next;
        end;
      end;
    finally
      DmdFpnUtils.CloseInfo;
      StrLstPayment.Free;
    end;
    try
     // if DmdFpnUtils.QueryInfo (BuildSqlTmpRefund)
      if DmdFpnUtils.QueryInfo (BuildSqlTmpRefund) then begin
        VspPreview.TableBorder := tbBoxColumns;
        VspPreview.StartTable;
        if not DmdFpnUtils.QryInfo.Eof then
          StrDepartment := DmdFpnUtils.QryInfo.
                           FieldByName ('TxtDescrGroup').AsString;
        while not DmdFpnUtils.QryInfo.Eof do begin
          if StrDepartment = DmdFpnUtils.QryInfo.
                             FieldByName ('TxtDescrGroup').AsString then begin
            if not (DmdFpnUtils.QryInfo.FieldByName('CodAction').AsInteger =
                                                  CtCodActDiscArtPct) then begin
              if DmdFpnUtils.QryInfo.FieldByName ('CodSalesType').AsInteger = 1
              then
                TxtLine := CtTxtCustOrder + TxtSep
              else
                TxtLine := CtTxtInStock + TxtSep;
              TxtLine := TxtLine +
                DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + TxtSep+
                DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsString + TxtSep +
                DmdFpnUtils.QryInfo.FieldByName ('TxtNameCust').AsString + TxtSep;
              if (TxtPrevTrans <> DmdFpnUtils.QryInfo.
                                  FieldByName ('IdtPOSTransaction').AsString)
                or (TxtPrevArt <> DmdFpnUtils.QryInfo.
                                  FieldByName ('NumPLU').AsString) then begin
                TxtLine := TxtLine + IntToStr(Abs(DmdFpnUtils.QryInfo.
                           FieldByName('QtyRegOrig').AsInteger)) + TxtSep +
                           FloatToStr(Abs(DmdFpnUtils.QryInfo.FieldByName('QtyReg').     // R2011.2 TCS(Mohan) Bug 16
                           AsFloat)) + TxtSep + FormatFloat (CtTxtFrmNumber,
                           DmdFpnUtils.QryInfo.FieldByName ('ValInclVATOrig').
                           AsFloat) + TxtSep + FormatFloat (CtTxtFrmNumber,
                           - DmdFpnUtils.QryInfo.FieldByName ('ValInclVAT').
                           AsFloat) + TxtSep;
                QtyDepOrig := QtyDepOrig +
                     Abs (DmdFpnUtils.QryInfo.FieldByName('QtyRegOrig').AsInteger);
                ValDepOrig := ValDepOrig +
                     DmdFpnUtils.QryInfo.FieldByName('ValInclVATOrig').AsFloat;
              end
              else
                TxtLine := TxtLine + TxtSep + FloatToStr(Abs(DmdFpnUtils.QryInfo.
                           FieldByName('QtyReg').AsFloat)) + TxtSep + TxtSep +
                           FormatFloat (CtTxtFrmNumber, - DmdFpnUtils.QryInfo.
                           FieldByName ('ValInclVAT').AsFloat) + TxtSep;
              QtyDepAmount := QtyDepAmount +
                        Abs (DmdFpnUtils.QryInfo.FieldByName('QtyReg').AsFloat);         // R2011.2 TCS(Mohan) Bug 16
              ValDepAmount := ValDepAmount +
                       - DmdFpnUtils.QryInfo.FieldByName('VALInclVAT').AsFloat;
              TxtPrevTrans := DmdFpnUtils.QryInfo.
                                FieldByName ('IdtPOSTransaction').AsString;
              TxtPrevArt := DmdFpnUtils.QryInfo.FieldByName ('NumPLU').AsString;
              TxtLine := TxtLine + DmdFpnUtils.QryInfo.FieldByName
              ('TxtDescrGroup').AsString + TxtSep;
              if FlgUOM then
                TxtLine := TxtLine + Copy(DmdFpnUtils.QryInfo.FieldByName
                           ('IdtArticle').AsString,1,7) + TxtSep
              else begin
                TxtLine := TxtLine +
                DmdFpnUtils.QryInfo.FieldByName ('IdtArticle').AsString + TxtSep;
              end;
              TxtLine := TxtLine +
              DmdFpnUtils.QryInfo.FieldByName ('TxtDescr').AsString + TxtSep +
              DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsString +
              TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Modif').AsString;
            end
            else
              TxtLine := TxtSep + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
                         DmdFpnUtils.QryInfo.FieldByName ('TxtDescr').AsString +
                         TxtSep + TxtSep + FormatFloat (CtTxtFrmNumber, -
                         DmdFpnUtils.QryInfo.FieldByName ('VALInclVAT').AsFloat) +
                         TxtSep;
            VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                                 clWhite, False);
            DmdFpnUtils.QryInfo.Next;
          end
          else begin
            PrintSubTotal (StrDepartment, QtyDepAmount, QtyDepOrig, ValDepAmount,
                           ValDepOrig);
            ValDepAmount := 0;
            QtyDepAmount := 0;
            ValDepOrig   := 0;
            QtyDepOrig   := 0;
            StrDepartment:= DmdFpnUtils.QryInfo.
                            FieldByName ('TxtDescrGroup').AsString;
            TxtPrevTrans := '';
            TxtPrevArt   := '';
          end;
        end;
        PrintSubTotal (StrDepartment, QtyDepAmount, QtyDepOrig, ValDepAmount,
                       ValDepOrig);
        VspPreview.EndTable;
      end;
    finally
      DmdFpnUtils.CloseInfo;
    end;
    DropRefundTable;
  end;
end;    // of TFrmDetRetroursMarchandises.PrintTableBodyBQ

//=============================================================================

function TFrmDetRetoursMarchandises.CreateRefundTable : boolean;
begin   // of TFrmDetRetroursMarchandises.CreateRefundTable
  Result := True;
  try
    try
      DmdFpnUtils.QryInfo.SQL.Text :=
                    'CREATE TABLE #TmpRefund' +
                 #10'  (TxtDescr           VARCHAR(250),' +
                 #10'   NumLineReg         INT,' +
                 #10'   CodAction          INT,' +
                 #10'   NumSeq             INT,' +
                 #10'   IdtPOSTransaction  INT,' +
                 #10'   IdtCheckout        INT,' +        //R2014.2-31150-TakeBack_Report-TCS(MeD)
                 #10'   DatTransBegin      DATETIME,' +
                 #10'   QtyReg             INT,' +
                 #10'   ValInclVAT         DECIMAL(13,4),' +
                 #10'   NumPLU             VARCHAR(21),' +
                 #10'   IdtOperator        INT,' +
                 #10'   Modif              VARCHAR(250),' +
                 #10'   IdtArticle         VARCHAR(14),' +
                 #10'   Rayon              VARCHAR(250),' +
                 #10'   Payment            VARCHAR(1000),' +
                 #10'   CodSalesType       INT,' +
                 #10'   IdtGroup           VARCHAR(14),' +
                 #10'   TxtDescrGroup      VARCHAR(250),' +
                 #10'   TxtNameCust        VARCHAR(250),' +
                 #10'   QtyRegOrig         INT,' +
                 #10'   ValInclVATOrig     DECIMAL(13,4),' +
                 #10'   IdtPOSTransOrig    INT,' +
                 #10'   DatTransBeginOrig  DATETIME,' +
                 #10'   IdtCheckOutOrig    INT,' +
                 #10'   CodTransOrig       INT,' +
                 #10'   IdtTradeMatrixOrig INT)';
      DmdFpnUtils.ExecQryInfo;
    finally
      DmdFpnUtils.CloseInfo;
    end;
  except
    Result := False;
  end;
end;    // of TFrmDetRetroursMarchandises.CreateRefundTable

//=============================================================================

function TFrmDetRetoursMarchandises.DropRefundTable;
begin   // of TFrmDetRetroursMarchandises.DropRefundTable
  Result := True;
  try
    try
      DmdFpnUtils.QryInfo.SQL.Text := 'DROP TABLE #TmpRefund';
      DmdFpnUtils.ExecQryInfo;
    finally
      DmdFpnUtils.CloseInfo;
    end;
  except
    Result := False;
  end;
end;    // of TFrmDetRetroursMarchandises.DropRefundTable

//=============================================================================

procedure TFrmDetRetoursMarchandises.PrintSubTotalTicket
                                                 (NumTicket       : Integer;
                                                 // QtyTicketAmount : Integer;
                                                  QtyTicketAmount : Double; // R2011.2 TCS(Mohan) Bug 16
                                                  ValTicketAmount : Double;
                                                  StrLstPayments  : TStringList);
var
  TxtLine          : string;           // Line to print
  TxtPayments      : string;           // All payments of one ticket
  CntPayments      : Integer;          // Loop all payments
  TxtSeper         : string;           // Seperator between payments
begin  // of TFrmDetRetroursMarchandises.PrintSubTotalTicket
  VspPreview.EndTable;

  TxtPayments := '';
  TxtSeper := '';
  for CntPayments := 0 to Pred (StrLstPayments.Count) do begin
    TxtPayments := TxtPayments + TxtSeper + StrLstPayments [CntPayments];
    TxtSeper := ', ';
  end;

  VspPreview.StartTable;
  TxtLine := CtTxtSubTotTicket + ' ' + IntToStr (NumTicket) + TxtSep + TxtSep +
    TxtSep + TxtSep + FloatToStr (QtyTicketAmount) + TxtSep + TxtSep + TxtSep + TxtSep +     // R2011.2 TCS(Mohan) Bug 16        //R2014.2-31150-TakeBack_Report-TCS(MeD)
    TxtSep + FormatFloat (CtTxtFrmNumber, ValTicketAmount) +
    TxtSep + TxtPayments;

  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clLtGray, False);
  VspPreview.EndTable;
  VspPreview.StartTable;
end;   // of TFrmDetRetroursMarchandises.PrintSubTotalTicket

//=============================================================================

procedure TFrmDetRetoursMarchandises.PrintSubTotal (StrDepartment : string;
                                                   // QtyDepAmount  : Integer;
                                                    QtyDepAmount  : Double;  // R2011.2 TCS(Mohan) Bug 16
                                                    QtyDepOrig    : Integer;
                                                    ValDepAmount  : Double;
                                                    ValDepOrig    : Double);
var
  TxtLine          : string;           // Line to print
begin  // of TFrmDetRetroursMarchandises.PrintSubTotal
  VspPreview.EndTable;
  VspPreview.StartTable;
  TxtLine := CtTxtSubTotDepartment + ' ' + StrDepartment + TxtSep +
    TxtSep + TxtSep + TxtSep +IntToStr (QtyDepOrig) + TxtSep +                   //R2014.2-31150-TakeBack_Report-TCS(MeD)
    FloatToStr (QtyDepAmount) + TxtSep + FormatFloat (CtTxtFrmNumber, ValDepOrig) +       // R2011.2 TCS(Mohan) Bug 16
    TxtSep + FormatFloat (CtTxtFrmNumber, ValDepAmount) + TxtSep;

  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clLtGray, False);
  VspPreview.EndTable;

  // One black row
  VspPreview.Text := CRLF;

  VspPreview.StartTable;

  ValAmount := ValAmount + ValDepAmount;
  ValAmountOrig := ValAmountOrig + ValDepOrig;
  QtyAmount := QtyAmount + QtyDepAmount;
  QtyAmountOrig := QtyAmountOrig + QtyDepOrig;
end;   // of TFrmDetRetroursMarchandises.PrintSubTotal

//=============================================================================

procedure TFrmDetRetoursMarchandises.PrintSubTotal (NumOperator    : Integer;
                                                     //QtyOperAmount  : Integer;
                                                     QtyOperAmount : Double; // R2011.2 TCS(Mohan) Bug 16
                                                     ValOperAmount  : Double);
var
  TxtLine          : string;           // Line to print
begin  // of TFrmDetRetroursMarchandises.PrintSubTotal
  VspPreview.EndTable;
  VspPreview.StartTable;
  TxtLine := CtTxtSubTotCaissiere + ' ' + IntToStr (NumOperator) + TxtSep + TxtSep +    //R2014.2-31150-TakeBack_Report-TCS(MeD)
    TxtSep + TxtSep + FloatToStr (QtyOperAmount) + TxtSep + TxtSep + TxtSep +    // R2011.2 TCS(Mohan) Bug 16
    TxtSep + TxtSep + FormatFloat (CtTxtFrmNumber, ValOperAmount);

  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clLtGray, False);
  VspPreview.EndTable;

  // One black row
  VspPreview.Text := CRLF;

  VspPreview.StartTable;

  ValAmount := ValAmount + ValOperAmount;
  QtyAmount := QtyAmount + QtyOperAmount;
end;   // of TFrmDetRetroursMarchandises.PrintSubTotal

//=============================================================================

procedure TFrmDetRetoursMarchandises.PrintTableFooter;
begin  // of TFrmDetRetroursMarchandises.PrintTableFooter
  VspPreview.Text := CRLF;

  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;

  VspPreview.AddTable (FmtTableSubTotal, '', TxtTableFooter, clWhite,
                       clWhite, False);
  VspPreview.EndTable;
end;   // of TFrmDetRetroursMarchandises.PrintTableFooter

//=============================================================================

procedure TFrmDetRetoursMarchandises.BtnPrintClick(Sender: TObject);
begin
  //set focus to other fields than on datefields
  ChkLbxOperator.SetFocus;
  // Check is DayFrom < DayTo
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
  (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date)then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      DtmPckLoadedFrom.Date := Now;
      DtmPckLoadedTo.Date := Now;
      Application.MessageBox(PChar(CtTxtStartEndDate),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now)then begin
      DtmPckDayFrom.Date := Now;
      DtmPckLoadedFrom.Date := Now;
      Application.MessageBox(PChar(CtTxtStartFuture),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
      DtmPckDayto.Date := Now;
      DtmPckLoadedto.Date := Now;
      Application.MessageBox(PChar(CtTxtEndFuture),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  else if (DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays) or
  (DtmPckLoadedTo.Date - DtmPckLoadedFrom.Date > CtMaxNumDays) then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayto.Date := Now;
      Application.MessageBox(PChar(Format (CtTxtMaxDays,
                             [IntToStr(CtMaxNumDays)])),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
     inherited;
  end;
end;

//=============================================================================

function TFrmDetRetoursMarchandises.BuildSQLGeneralRetours: string;
begin  // of TFrmDetRetoursMarchandises.BuildSQLGeneralRetours
  Result :=
    #10'  SELECT PTrans.IdtPosTransaction, PTrans.IdtCheckout, ' +
    #10'  PTrans.DatTransbegin, PTrans.CodTrans, PTrans.IdtOperator ' +
    #10'  FROM POSTransaction PTrans (NOLOCK)' +
    #10'  WHERE PTrans.IdtOperator IN (' + TxtLstOperID  + ')' +
    #10'  AND ISNULL(PTrans.CodReturn, 0) = 0' ;
    if RbtDateDay.Checked then begin
      Result := Result +
        #10' AND PTrans.DatTransBegin BETWEEN ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
    end
    else if RbtDateLoaded.Checked then begin
      Result := Result +
        #10' AND PTrans.DatTransBegin BETWEEN ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
    end;
    if FlgBQChina then begin
      Result := Result +
        #10' AND PTrans.IdtCheckout IN (' + TxtLstCheckoutID  + ')';
      if EdtTransNum.Text <> '' then begin
        Result := Result +
          #10' AND PTrans.IdtPOSTransaction = ' + EdtTransNum.Text;
      end;
    end;
    Result := Result +
    #10'  AND EXISTS(SELECT * FROM POSTransDetail PDet1 (NOLOCK)' +
    #10'               WHERE PTrans.IdtPOSTransaction = PDet1.IdtPOSTransaction' +
    #10'                 AND PTrans.DatTransBegin = PDet1.DatTransBegin' +
    #10'                 AND PTrans.IdtCheckOut = PDet1.IdtCheckOut' +
    #10'                 AND PTrans.CodTrans = PDet1.CodTrans' +
    #10'                 AND PDet1.CodType = 303' +
    #10'                 AND PDet1.CodAction = 8)   -- Retour' +
    #10'  AND NOT EXISTS(SELECT * FROM POSTransDetail PDet2 (NOLOCK)' +
    #10'               WHERE PTrans.IdtPOSTransaction = PDet2.IdtPOSTransaction' +
    #10'                 AND PTrans.DatTransBegin = PDet2.DatTransBegin' +
    #10'                 AND PTrans.IdtCheckOut = PDet2.IdtCheckOut' +
    #10'                 AND PTrans.CodTrans = PDet2.CodTrans' +
    #10'                 AND PDet2.CodAction = 86)   -- Annulatie ticket' +
    #10'  AND PTrans.FlgTraining = 0' +
    #10'  ORDER BY PTrans.IdtOperator, PTrans.IdtPostransaction';

end;   // of TFrmDetRetoursMarchandises.BuildSQLGeneralRetours

//=============================================================================

procedure TFrmDetRetoursMarchandises.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmDetRetoursMarchandises.BeforeCheckRunParams
  inherited;
  // add param /VBQC to help
  SplitString(CtTxtBQChina, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VUOM to help
  SplitString(CtTxtUOM, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VEXP to help
  SplitString(CtTxtBRES, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams(TxtPartLeft, TxtPartRight);
end;   // of TFrmDetRetoursMarchandises.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetRetoursMarchandises.CheckAppDependParams(TxtParam: string);
begin  // of TFrmDetRetoursMarchandises.CheckAppDependParams
  if Copy(TxtParam,3,3)= 'BQC' then
    FlgBQChina := True
  else if Copy(TxtParam,3,3)= 'UOM' then
    FlgUOM := True
  else if Copy(TxtParam, 3, 3) = 'EXP' then
    FlgSpanje := True
  else if Copy(TxtParam, 3, 4) = 'CAFR' then                                    //R2013.1-21050-Export excel of returned goods report-TCS(SM)
    FlgCAFR := True                                                             //R2013.1-21050-Export excel of returned goods report-TCS(SM)
  else
    inherited;
end; // of TFrmDetRetoursMarchandises.CheckAppDependParams

//=============================================================================

procedure TFrmDetRetoursMarchandises.FormCreate(Sender: TObject);
begin // of TFrmDetRetoursMarchandises.FormCreate
  inherited;
  Panel1.Height := Self.Height - 130;
  PnlCheckout.Height := Self.Height - 320;
  if FlgSpanje then
    BtnExport.Visible := True
end; // of TFrmDetRetoursMarchandises.FormCreate

//=============================================================================

procedure TFrmDetRetoursMarchandises.FillDepartments;
begin  // of TFrmDetRetoursMarchandises.FillDepartments
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
end;   // of TFrmDetRetoursMarchandises.FillDepartments

//=============================================================================

procedure TFrmDetRetoursMarchandises.AutoStart(Sender: TObject);
begin  // of TFrmDetRetoursMarchandises.AutoStart(Sender: TObject)
  inherited;
  if FlgBQChina then begin
    FillDepartments;
    FillSalesTransactionTypes;
    FillReasonCodes;
    FillLbxCheckouts;
    PnlBQC.Visible := True;
    PnlCheckout.Visible := True;
    RbtDateLoaded.Visible := False;
    DtmPckLoadedFrom.Visible := False;
    DtmPckLoadedTo.Visible := False;
  end
  else begin
    PnlBQC.Visible := False;
    PnlCheckout.Visible := False;
    RbtDateLoaded.Visible := True;
    DtmPckLoadedFrom.Visible := True;
    DtmPckLoadedTo.Visible := True;
  end;
end;   // of TFrmDetRetoursMarchandises.AutoStart(Sender: TObject)

//=============================================================================

procedure TFrmDetRetoursMarchandises.FillSalesTransactionTypes;
begin  // of TFrmDetRetoursMarchandises.FillSalesTransactionTypes
  inherited;
  CmbbxSalesType.Items.Add(CtTxtCustOrder);
  CmbbxSalesType.Items.Add(CtTxtInStock);
end;   // of TFrmDetRetoursMarchandises.FillSalesTransactionTypes

//=============================================================================

procedure TFrmDetRetoursMarchandises.FillLbxCheckouts;
begin  // of TFrmDetRetoursMarchandises.FillLbxCheckouts
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
end;   // of TFrmDetRetoursMarchandises.FillLbxCheckouts

//=============================================================================

procedure TFrmDetRetoursMarchandises.FillReasonCodes;
begin  // of TFrmDetRetoursMarchandises.FillReasonCodes
  inherited;
  try
    CmbbxReasonCode.Items.Clear;
    DmdFpnUtils.SprCnvCodes.
      ParamByName ('@PrmIdtLanguage').Value := DmdFpnUtils.IdtLanguageTradeMatrix;
    DmdFpnUtils.SprCnvCodes.
      ParamByName ('@PrmTxtField').Value := CtCodReasonCodeField;
    DmdFpnUtils.SprCnvCodes.
      ParamByName ('@PrmTxtTable').Value := CtCodReturnTable;
    DmdFpnUtils.SprCnvCodes.Active := True;
    DmdFpnUtils.SprCnvCodes.First;
    while not DmdFpnUtils.SprCnvCodes.Eof do begin
      CmbbxReasonCode.Items.Add(DmdFpnUtils.SprCnvCodes.FieldByName ('TxtChcLong').AsString);
      DmdFpnUtils.SprCnvCodes.Next;
    end;
  finally
    DmdFpnUtils.SprCnvCodes.Active := False;
  end;
end;   // of TFrmDetRetoursMarchandises.FillReasonCodes

//=============================================================================

procedure TFrmDetRetoursMarchandises.BtnSelectAllCheckoutClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetRetoursMarchandises.BtnSelectAllCheckoutClick
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do
    ChkLbxCheckout.Checked [CntIx] := True;
end;   // of TFrmDetRetoursMarchandises.BtnSelectAllCheckoutClick

//=============================================================================

procedure TFrmDetRetoursMarchandises.BtnDESelectAllCheckoutClick(
  Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetRetoursMarchandises.BtnDESelectAllCheckoutClick
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do
    ChkLbxCheckout.Checked [CntIx] := False;
end;   // of TFrmDetRetoursMarchandises.BtnDESelectAllCheckoutClick

//=============================================================================

function TFrmDetRetoursMarchandises.BuildSQLTmpRefund: string;
var
  TxtWhereClause   : string;
begin
  TxtWhereClause := '';
  Result := Result + 'SELECT * FROM #TmpRefund';
  if FlgBQChina then begin
    if CmbbxSalesType.ItemIndex <> -1 then begin
      if CmbbxSalesType.ItemIndex = 0 then begin
         TxtWhereClause := TxtWhereClause + #10'WHERE CodSalesType = 1';
      end
      else begin
         TxtWhereClause := TxtWhereClause + #10'WHERE CodSalesType <> 1';
      end;
    end;
    if CmbbxReasonCode.ItemIndex <> -1 then begin
      if TxtWhereClause <> '' then
        TxtWhereClause := TxtWhereClause + #10'AND '
      else
        TxtWhereClause := TxtWhereClause + #10'WHERE ';
      TxtWhereClause := TxtWhereClause +
                       'Substring(Modif,1,2) = ' + AnsiQuotedStr(Copy(CmbbxReasonCode.Text,0,2), '''');
    end;
    if CmbbxDepartment.ItemIndex <> -1 then begin
      if TxtWhereClause <> '' then
        TxtWhereClause := TxtWhereClause + #10'AND '
      else
        TxtWhereClause := TxtWhereClause + #10'WHERE ';
      TxtWhereClause := TxtWhereClause +
                        'IdtGroup = ' + Copy(CmbbxDepartment.Text,0,2);
    end;
    if EdtBarcode.Text <> '' then begin
      if TxtWhereClause <> '' then
        TxtWhereClause := TxtWhereClause + #10'AND '
      else
        TxtWhereClause := TxtWhereClause + #10'WHERE ';
      TxtWhereClause := TxtWhereClause + 'IdtArticle LIKE ' +
                        AnsiQuotedStr(Trim(EdtBarcode.Text) + '%', '''');
    end;

  end;
  Result := Result + TxtWhereClause + #10'ORDER BY Rayon, IdtOperator, IdtPOSTransaction ASC';
end;

//=============================================================================

function TFrmDetRetoursMarchandises.GetTxtLstCheckoutID: string;
var
  CntCheckout      : Integer;          // Loop the operators in the Checklistbox
begin  // of TFrmDetRetoursMarchandises.GetTxtLstCheckoutID
  Result := '';
  for CntCheckout := 0 to Pred (ChkLbxCheckout.Items.Count) do begin
    if ChkLbxCheckout.Checked [CntCheckout] then
      Result :=
          Result +
          AnsiQuotedStr
            (IntToStr(Integer(ChkLbxCheckout.Items.Objects[CntCheckout])), '''') +
          ',';
  end;
  Result := Copy (Result, 0, Length (Result) - 1);
end;   // of TFrmDetRetoursMarchandises.GetTxtLstCheckoutID

//=============================================================================

function TFrmDetRetoursMarchandises.GetItemsSelected: Boolean;
var
  CntIx      : Integer;          // Loop the checkouts in the Checklistbox
begin  // of TFrmDetRetoursMarchandises.GetItemsSelected
  if FlgBQChina then begin
    Result := False;
    for CntIx := 0 to Pred(ChkLbxCheckout.Items.Count) do begin
      if ChkLbxCheckout.Checked [CntIx] then begin
        Result := True;
        Break;
      end;
    end;

    if Result then
      Result := inherited GetItemsSelected;
  end
  else begin
   // Result := inherited GetItemsSelected; //Commented :  R2011.2 TCS(Mohan) Bug 11 
   // Start : // R2011.2 TCS(Mohan) Bug 11
    Result := False;
    for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
      if (ChkLbxOperator.Checked [CntIx]) or (ChkLbxOperator.State[CntIx]= cbGrayed) then begin // R2011.2 TCS(Mohan) Bug 11
        Result := True;
        Break;
      end;
    end;
   // End : R2011.2 TCS(Mohan) Bug 11
  end;
end;   // of TFrmDetRetoursMarchandises.GetItemsSelected

//=============================================================================

procedure TFrmDetRetoursMarchandises.CmbbxDepartmentKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmDetRetoursMarchandises.CmbbxDepartmentKeyDown
  inherited;
  if Key = VK_DELETE then
    CmbbxDepartment.ItemIndex := -1;
end;   // of TFrmDetRetoursMarchandises.CmbbxDepartmentKeyDown

//=============================================================================

procedure TFrmDetRetoursMarchandises.CmbbxSalesTypeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmDetRetoursMarchandises.CmbbxSalesTypeKeyDown
  inherited;
  if Key = VK_DELETE then
    CmbbxSalesType.ItemIndex := -1;
end;   // of TFrmDetRetoursMarchandises.CmbbxSalesTypeKeyDown

//=============================================================================

procedure TFrmDetRetoursMarchandises.CmbbxReasonCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmDetRetoursMarchandises.CmbbxReasonCodeKeyDown
  inherited;
  if Key = VK_DELETE then
    CmbbxReasonCode.ItemIndex := -1;
end;   // of TFrmDetRetoursMarchandises.CmbbxReasonCodeKeyDown

//=============================================================================

procedure TFrmDetRetoursMarchandises.BtnExportClick(Sender: TObject);
var
  TxtTitles           : string;
  TxtWriteLine        : string;
  counter             : Integer;
  F                   : System.Text;
  NumCurrentOper      : Integer;       // Number of current operator to process
  NumCurrentTicket : Integer;          // Number of current operator to process
  NumCurrentLineReg: Integer;          // Number of current registration line
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;
  FlgNext             : Boolean;
  NumCurrentTicketVal : integer;                                                // R2013.1-21050-Export excel of returned goods report-TCS(SM)
  NumQtyTickAmount    : double;                                                 // R2013.1-21050-Export excel of returned goods report-TCS(SM)
  Result              : string;                                                 // R2013.1-HPQC Defect Fix 13-Export excel of returned goods report-TCS(SM)
begin // of TFrmDetRetoursMarchandises.BtnExportClick
//R2013.1-21050-Export excel of returned goods report-TCS(SM)::START
  ValTickAmount := 0;
  NumCurrentTicketVal :=0;
  StrLstPayment := TStringList.Create;
  StrLstPayment.Sorted := True;
  StrLstPayment.Duplicates := dupIgnore;
  Result:='';
//R2013.1-21050-Export excel of returned goods report-TCS(SM)::END
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;
  //set focus to other fields than on datefields
  QryHlp := TQuery.Create(self);
  try
    QryHlp.DatabaseName := 'DBFlexPoint';
    QryHlp.Active := False;
    QryHlp.SQL.Clear;
    QryHlp.SQL.Add('select * from ApplicParam' +
                   ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
    QryHlp.Active := True;
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                     //R2013.2.ALM Defect Fix 164.All OPCO.SMB.TCS
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  ChkLbxOperator.SetFocus;
  // Check is DayFrom < DayTo
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
     (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date) then begin
    DtmPckDayFrom.Date    := Now;
    DtmPckDayTo.Date      := Now;
    DtmPckLoadedFrom.Date := Now;
    DtmPckLoadedTo.Date   := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now) then begin
    DtmPckDayFrom.Date    := Now;
    DtmPckLoadedFrom.Date := Now;
    Application.MessageBox(PChar(CtTxtStartFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
    DtmPckDayto.Date    := Now;
    DtmPckLoadedto.Date := Now;
    Application.MessageBox(PChar(CtTxtEndFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  else if (DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays) or
          (DtmPckLoadedTo.Date - DtmPckLoadedFrom.Date > CtMaxNumDays) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayto.Date   := Now;
    Application.MessageBox(PChar(Format(CtTxtMaxDays, [IntToStr(CtMaxNumDays)])),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
    ChrDecimalSep    := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    TxtTitles := GetTxtTableTitle();
    TxtWriteLine := '';
    for counter := 1 to Length(TxtTitles) do
      if TxtTitles[counter] = '|' then
        TxtWriteLine := TxtWriteLine + ';'
      else
        TxtWriteLine := TxtWriteLine + TxtTitles[counter];
    repeat
      Btnselect := mrOk;
      FlgOK := SavDlgExport.Execute;
      if FileExists(SavDlgExport.FileName) and FlgOK then
        Btnselect := MessageDlg(CtTxtExists, mtError, mbOKCancel, 0);
      if not FlgOK then
        Btnselect := mrOK;
    until Btnselect = mrOk;
    if FlgOK then begin
      System.Assign(F, SavDlgExport.FileName);
      Rewrite(F);
      WriteLn(F, TxtWriteLine);
      ValTickAmount := 0;                                                         //R2013.1-21050-Export excel of returned goods report-TCS(SM)
      QtyTickAmount := 0;                                                         //R2013.1-21050-Export excel of returned goods report-TCS(SM)
      try
        if DmdFpnUtils.QueryInfo(BuildSQLGeneralRetours) then begin
         NumCurrentTicketVal:= DmdFpnUtils.QryInfo.                               //R2013.1-21050-Export excel of returned goods report-TCS(SM)
                     FieldByName ('IdtPOSTransaction').AsInteger;
          while not DmdFpnUtils.QryInfo.Eof do begin
            NumCurrentOper := DmdFpnUtils.QryInfo.
                                FieldByName('IdtOperator').AsInteger;
            while (NumCurrentOper = DmdFpnUtils.QryInfo.
                   FieldByName('IdtOperator').AsInteger) and not
                   DmdFpnUtils.QryInfo.Eof do begin
                   NumCurrentTicket :=
                   DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsInteger;
              sprRetourDetail.Close;
              sprRetourDetail.ParamByName('@PrmIdtPosTransaction').AsInteger :=
                DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsInteger;
              sprRetourDetail.ParamByName('@PrmIdtCheckout').AsInteger :=
                DmdFpnUtils.QryInfo.FieldByName('IdtCheckout').AsInteger;
              sprRetourDetail.ParamByName('@PrmCodTrans').AsInteger :=
                DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger;
              sprRetourDetail.ParamByName('@PrmDatTransBegin').AsDateTime :=
                DmdFpnUtils.QryInfo.FieldByName('DatTransBegin').AsDateTime;
              sprRetourDetail.Open;
             //R2013.1-HPQC Defect Fix 13-Export excel of returned goods report-TCS(SM)::START
               SprPaymentMethodExport.Close;
               SprPaymentMethodExport.ParamByName('@PrmIdtPosTransaction').AsInteger :=
                DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsInteger;
               SprPaymentMethodExport.ParamByName('@PrmDatTransBegin').AsDateTime :=
                DmdFpnUtils.QryInfo.FieldByName('DatTransBegin').AsDateTime;
               SprPaymentMethodExport.ParamByName('@PrmIdtCheckout').AsInteger :=
                DmdFpnUtils.QryInfo.FieldByName('IdtCheckout').AsInteger;
               SprPaymentMethodExport.ParamByName('@PrmCodTrans').AsInteger :=
                DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger;
               SprPaymentMethodExport.Open;
             //R2013.1-HPQC Defect Fix 13-Export excel of returned goods report-TCS(SM)::END
              if not sprRetourDetail.IsEmpty then begin
                while not sprRetourDetail.Eof do begin
                  FlgNext := False;
                  //R2013.1-21050-Export excel of returned goods report-TCS(SM)::START
                  if FlgCAFR then begin
                    if NumCurrentTicketVal <> SprRetourDetail.FieldByName ('IdtPOSTransaction').AsInteger then  begin
				  //R2013.1-Internal Defect Fix 874-Export excel of returned goods report-TCS(SM)::START
                       TxtPayments:=Result;
                       Result:='';
                       TxtWriteLine := CtTxtSubTotTicket + ' ' + IntToStr (NumCurrentTicketVal) + ';' + ';' +
                        ';' + FloatToStr (QtyTickAmount)  + ';' + ';' + ';' + ';' +
                        ';' + FormatFloat (CtTxtFrmNumber, ValTickAmount) +
                        ';' + TxtPayments;
				  //R2013.1-Internal Defect Fix 874-Export excel of returned goods report-TCS(SM)::END
          //R2013.1-HPQC Defect Fix 13-Export excel of returned goods report-TCS(SM)::START
                   try
                      TxtSeper := '';
                      while not SprPaymentMethodExport.Eof do begin
                        Result:= Result + TxtSeper +SprPaymentMethodExport.FieldByName ('TxtDescr').AsString;
                        TxtSeper:=',';
                        SprPaymentMethodExport.Next;
                      end;
                   finally
                    SprPaymentMethodExport.Close;
                   end;
         //R2013.1-HPQC Defect Fix 13-Export excel of returned goods report-TCS(SM)::END
                       NumCurrentTicketVal := SprRetourDetail.
                       FieldByName ('IdtPOSTransaction').AsInteger;
                       WriteLn(F, TxtWriteLine);
                       ValTickAmount := 0;
                       QtyTickAmount := 0;
                    end
                  //R2013.1-Internal Defect Fix 857-Export excel of returned goods report-TCS(SM)::START
                    else begin
                //R2013.1-HPQC Defect Fix 13-Export excel of returned goods report-TCS(SM)::START
                      try
                        TxtSeper := '';
                        while not SprPaymentMethodExport.Eof do begin
                          Result:= Result + TxtSeper +SprPaymentMethodExport.FieldByName ('TxtDescr').AsString;
                          TxtSeper:=',';
                          SprPaymentMethodExport.Next;
                        end;
                      finally
                        SprPaymentMethodExport.Close;
                      end;
                //R2013.1-HPQC Defect Fix 13-Export excel of returned goods report-TCS(SM)::END
                    end;
                  //R2013.1-Internal Defect Fix 857-Export excel of returned goods report-TCS(SM)::END
                  end;
                  //R2013.1-21050-Export excel of returned goods report-TCS(SM)::END
                  if not (sprRetourDetail.FieldByName('CodAction').AsInteger =
                    CtCodActDiscArtPct) then begin
                    NumCurrentTicket :=
                      SprRetourDetail.FieldByName ('IdtPOSTransaction').AsInteger;

                    NumCurrentLineReg :=
                      SprRetourDetail.FieldByName ('NumLineReg').AsInteger;
                    TxtWriteLine :=
                      SprRetourDetail.FieldByName('IdtOperator').AsString + ';' +
                      SprRetourDetail.FieldByName('IdtCheckout').AsString + ';' + 				//R2014.2-31150-TakeBack_Report-TCS(MeD)
                      SprRetourDetail.FieldByName('DatTransBegin').AsString + ';' +
                      SprRetourDetail.FieldByName('Rayon').AsString + ';';
                    if SprRetourDetail.FieldByName('QtyReg').AsInteger < 0 then
                      TxtWriteLine := TxtWriteLine + IntToStr(Abs
                        (SprRetourDetail.FieldByName('QtyReg').AsInteger))
                    else begin
                      if SprRetourDetail.FieldByName('QtyReg').AsInteger > 0 then
                        TxtWriteLine := TxtWriteLine + IntToStr(-
                          (SprRetourDetail.FieldByName('QtyReg').AsInteger));
                    end;
                    TxtWriteLine := TxtWriteLine + ';' +
                    '= "" & "' +                                                 //makes excel interpret number as text
                    SprRetourDetail.FieldByName('NumPLU').AsString + '";' +      //makes excel interpret number as text
                      SprRetourDetail.FieldByName('IdtArticle').AsString + ';' +
                      SprRetourDetail.FieldByName('TxtDescr').AsString + ';' +
                      SprRetourDetail.FieldByName('IdtPOSTransaction').AsString +
                      ';' + FormatFloat('0.00',
                      -SprRetourDetail.FieldByName('VALInclVAT').AsFloat) + ';' +
                      SprRetourDetail.FieldByName('Modif').AsString;
                  end
                  else
                    TxtWriteLine := ';' + ';' + ';' + ';' + ';' + ';' +
                                    SprRetourDetail.FieldByName('TxtDescr').
                                    AsString + ';' + ';' + FormatFloat('0.00',
                                    -SprRetourDetail.FieldByName('VALInclVAT').
                                    AsFloat) + ';';
                  WriteLn(F, TxtWriteLine);
            //R2013.1-21050-Export excel of returned goods report-TCS(SM)::START
                 if SprRetourDetail.FieldByName('QtyReg').AsFloat < 0 then begin
                    QtyOperAmount := QtyOperAmount +
                        Abs (SprRetourDetail.FieldByName('QtyReg').AsFloat);
                    QtyTickAmount := QtyTickAmount +
                        Abs (SprRetourDetail.FieldByName('QtyReg').AsFloat);
                 end
                 else begin
                   if SprRetourDetail.FieldByName('QtyReg').AsFloat > 0 then begin
                      QtyOperAmount := QtyOperAmount +
                         (-SprRetourDetail.FieldByName('QtyReg').AsFloat);
                      QtyTickAmount := QtyTickAmount +
                         (-SprRetourDetail.FieldByName('QtyReg').AsFloat);
                   end;
                 end;
                 ValOperAmount := ValOperAmount +
                       - SprRetourDetail.FieldByName('VALInclVAT').AsFloat;
                 ValTickAmount := ValTickAmount +
                       - SprRetourDetail.FieldByName('VALInclVAT').AsFloat;
           //R2013.1-21050-Export excel of returned goods report-TCS(SM)::END
                  if (SprRetourDetail.FieldByName('CodAction').AsInteger in
                     [CtCodActDiscArtPct,CtCodActDiscArtVal]) then begin
                    while (NumCurrentTicket = SprRetourDetail.
                      FieldByName ('IdtPOSTransaction').AsInteger) and
                      (NumCurrentLineReg = SprRetourDetail.
                      FieldByName ('NumLineReg').AsInteger) and
                      (NumCurrentOper = SprRetourDetail.
                      FieldByName ('IdtOperator').AsInteger) and
                      (SprRetourDetail.FieldByName('CodAction').AsInteger in
                      [CtCodActDiscArtPct,CtCodActDiscArtVal]) and
                      not (SprRetourDetail.Eof) do begin
                      SprRetourDetail.Next;
                      FlgNext := True;
                    end;
                  end
                  else begin
                    while (NumCurrentTicket = SprRetourDetail.
                      FieldByName ('IdtPOSTransaction').AsInteger) and
                      (NumCurrentLineReg = SprRetourDetail.
                      FieldByName ('NumLineReg').AsInteger) and
                      (NumCurrentOper = SprRetourDetail.
                       FieldByName ('IdtOperator').AsInteger) and
                      (not(SprRetourDetail.FieldByName('CodAction').AsInteger in
                      [CtCodActDiscArtPct,CtCodActDiscArtVal])) and
                       not (SprRetourDetail.Eof) do begin
                      SprRetourDetail.Next;
                      FlgNext := True;
                    end;
                  end;
                  if not FlgNext then
                    SprRetourDetail.Next;
                 end;
              end;
              DmdFpnUtils.QryInfo.Next;
            end;
          end;
        end;
      //R2013.1-Internal Defect Fix 722-Export excel of returned goods report-TCS(SM)::START
    if not sprRetourDetail.IsEmpty then begin                                               //R2013.1-Internal Defect Fix 874-Export excel of returned goods report-TCS(SM)
     if FlgCAFR then begin
       TxtWriteLine := CtTxtSubTotTicket + ' ' + IntToStr (NumCurrentTicketVal) + ';' + ';' +
                        ';' + FloatToStr (QtyTickAmount)  + ';' + ';' + ';' + ';' +
                        ';' + FormatFloat (CtTxtFrmNumber, ValTickAmount) +
                        ';' + Result;
       WriteLn(F, TxtWriteLine);
     end;
    end;                                                                                   //R2013.1-Internal Defect Fix 874-Export excel of returned goods report-TCS(SM)
   //R2013.1-Internal Defect Fix 722-Export excel of returned goods report-TCS(SM)::END
      finally
        DmdFpnUtils.CloseInfo;
        sprRetourDetail.Close;
        System.Close(F);
        DecimalSeparator := ChrDecimalSep;
      end;
    end;
  end;

 StrLstPayment.Free;                                                             //R2013.1-21050-Export excel of returned goods report-TCS(SM)
end; // of TFrmDetRetoursMarchandises.BtnExportClick

//=============================================================================

procedure TFrmDetRetoursMarchandises.BtnDeSelectAllClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin
 // inherited;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do
    begin
      if ChkLbxOperator.State[CntIx]= cbGrayed then   // R2011.2 TCS(Mohan) Bug 11
         ChkLbxOperator.State[CntIx]:= cbUnchecked;  // R2011.2 TCS(Mohan) Bug 11

      ChkLbxOperator.Checked [CntIx] := False;
    end;
end;

//=============================================================================
// Start : R2011.2 TCS(Mohan) Bug 11
function TFrmDetRetoursMarchandises.GetTxtLstOperID : string;
var
  CntOper          : Integer;          // Loop the operators in the Checklistbox
begin  // of TFrmDetGeneralCA.GetTxtLstOperID
  Result := '';
  for CntOper := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if (ChkLbxOperator.Checked [CntOper]) or (ChkLbxOperator.State[CntOper]= cbGrayed) then
    Result :=  Result +
          AnsiQuotedStr
            (IntToStr(Integer(ChkLbxOperator.Items.Objects[CntOper])), '''')+',';
  end;
  Result := Copy (Result, 0, Length (Result) - 1);
end;   // of TFrmDetGeneralCA.GetTxtLstOperID
// End : R2011.2 TCS(Mohan) Bug 11
//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FDetRetoursMarchandises

