//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     :FDetCancelLines.pas : Report for lines cancellations by the operator
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version   Modified by     Reason
// 1.0       S.R.M.(TCS)     R2011.2 - BDES - Operators Audit report
// 1.1       A.K.S.(TCS)     R2012.1 - BDES - Rapport Annulation de lignes
// 1.2       S.R.M.(TCS)     R2012.1 - BDES - HPQC DefectFix (373)
// 1.3       S.R.M.(TCS)     R2013.1 - BDES - Enhancement(123)
// 1.4       A.S   (TCS)     R2013.2 - BDES - Req36040- Add cashdesk column to report
// 1.5       SPN   (TCS)     R2013.2 - BDES - ALM Defect 87
// 1.6       SMB   (TCS)     R2013.2.ALM Defect Fix 164.All OPCO
//=============================================================================

unit FDetCancelLines;

//*****************************************************************************

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
  CtMaxNumDays         =  30;
//=============================================================================
// Resource strings
//=============================================================================

resourcestring     // of header.
  CtTxtTitle            = 'List of cancellations';                              //R2012.1 - BDES - Rapport Annulation de lignes
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtReportDate       = 'Report from %s to %s';

resourcestring     // of table header.
  CtTxtNbOperator       = 'No operator';
  CtTxtAnnulType        = 'Type';
  CtTxtDate             = 'Date';
  CtTxtCashDesk         = 'Cash Desk';                                          //R2013.2 - req36040 - BDES - Add cashdesk column to the Report-TCS-AS
  CtTxtTicketNr         = 'Ticket Nr';
  CtTxtNumPLU           = 'Internal Code';
  CtTxtCodeCasto        = 'Barcode';
  CtTxtQty              = 'Qty';
  CtTxtPrice            = 'Price';
  CtTxtTotalAMount      = 'Total amount';
  CtTxtAuthorisedBy     = 'Cancelled by';
  CtTxtSubTot           = 'S/Total';

resourcestring     // of date errors
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtMaxDays          = 'Selected daterange may not contain more than %s days';
  CtTxtErrorHeader      = 'Incorrect Date';
  CtTxtNotSelected      = 'There are no items selected!';
  CtTxtTitleReportType  = 'Report type selected:';

resourcestring     // of export to excel parameters
  CtTxtPlace            = 'D:\sycron\transfertbo\excel';
  CtTxtExists           = 'File exists, Overwrite?';
resourcestring     //combobox items
  CtTxtAll               ='All';
  CtTxtCancelPreLine     ='Line cancellation';
  CtTxtCancelLastLine    ='Last line cancellation';
  CtTxtCancelTicket      ='Ticket Cancellation';                                // R2012.1 - BDES - Rapport Annulation de lignes(Amit) -Start
  CtTxtCanceledTicket    ='Ticket Canceled';
  CtTxtTicket            ='Ticket';
  CtTxtPLUNo             ='PLU No';
  CtTxtTotal             ='Total';                                              // R2012.1 - BDES - Rapport Annulation de lignes(Amit) -End
//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetCancelLines = class(TFrmDetGeneralCA)
    PnlCheckout: TPanel;
    ChkLbxCheckout: TCheckListBox;
    BtnSelectAllCheckout: TBitBtn;
    BtnDESelectAllCheckout: TBitBtn;
    BtnExport: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    PnlType: TPanel;
    Label1: TLabel;
    CmbbxCancelLine: TComboBox;
    procedure FormCreate(Sender: TObject); 					                            
    procedure cmbbxCancelLineChange(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure CmbbxCancelLineKeyDown(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);
    procedure BtnDESelectAllCheckoutClick(Sender: TObject);
    procedure BtnSelectAllCheckoutClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);

    procedure AutoStart (Sender : TObject); override;
    function GetItemsSelected : Boolean; override;

    procedure FillReportType; virtual;
    procedure FillLbxCheckouts; virtual;
    procedure SetGeneralSettings; virtual;

    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string; virtual;
    function GetFmtTableTotal : string; virtual;
    function GetTxtTableTitle : string; override;

    function GetTxtLstCheckoutID : string; virtual;
    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
    function BuildSQLCancelLines : string;
    function GetTxtTitTypeReport: string; virtual;

  public
    { Public declarations }
    property TxtTitTypeReport: string read GetTxtTitTypeReport;
    procedure PrintHeader; override;
    procedure PrintTableBody; override;

    procedure PrintSubTotal(SubCountOperatorType : Integer;
                            SubTicketNo          : Integer;
                            SubQtyOperAmount     : Integer;
                            SubValOperAmount     : Double);


    procedure PrintTotal (TotCountOperatorType   : Integer;
                          TotTicketNo            : Integer;
                          TotQtyOperAmount       : Integer;
                          TotValOperAmount       : Double);
    property FmtTableSubTotal : string read GetFmtTableSubTotal;
    procedure Execute; override;
  end;

var
  FrmDetCancelLines: TFrmDetCancelLines;
  FlgAll         : Boolean = false;
  FlgPreLine     : Boolean = false;
  FlgLastLine    : Boolean = false;
  FlgCancelTicket: Boolean = false;                                             // R2012.1 - BDES - Rapport Annulation de lignes
  FlgSelectAll   : Boolean = false;
  FlgDeselectAll : Boolean = false;


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
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCancelLines.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.6 $';
  CtTxtSrcDate    = '$Date: 2014/03/06 09:50:31 $';

//*****************************************************************************
// Implementation of TFrmDetCancelLines
//*****************************************************************************

procedure TFrmDetCancelLines.Execute;
begin  // of TFrmDetCancelLines.Execute
  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  PrintTableBody;
  PrintTableFooter;
  VspPreview.EndDoc;
  PrintPageNumbers;
  PrintReferences;
  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
end;   // of TFrmDetCancelLines.Execute

//=============================================================================
// GetFmtTableHeader: Construct the structure of the Table Header of the report
//=============================================================================

function TFrmDetCancelLines.GetFmtTableHeader: string;
begin  // of TFrmDetCancelLines.GetFmtTableHeader
  /// R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -start
    if (flgCancelTicket or flgAll) then                                         // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-Start
    Result := '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +            // R2013.1-BDES-Enhancement(123)
              '^+' + IntToStr (CalcWidthText ( 6, False)) + TxtSep +            // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              '^+' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (20, False))
    else                                                                        // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-End
    Result := '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText ( 6, False)) + TxtSep +            // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              '^+' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (20, False))
    // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -end
end;   // of TFrmDetCancelLines.GetFmtTableHeader

//=============================================================================
//  GetFmtTableBody : Construct the structure of the Table Body of the report
//=============================================================================

function TFrmDetCancelLines.GetFmtTableBody : string;
begin  // of TFrmDetCancelLines.GetFmtTableBody
 // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -start
    if (flgCancelTicket or flgAll) then                                         // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-Start
    Result := '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +             // R2013.1-BDES-Enhancement(123)
              '<' + IntToStr (CalcWidthText ( 6, False)) + TxtSep +             // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              '>' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (8, False))  + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (20, False))
   else                                                                         // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-End
    Result := '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText ( 6, False)) + TxtSep +             // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              '>' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (8, False))  + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (20, False));
   // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -end
end;   // of TFrmDetCancelLines.GetFmtTableBody

//=============================================================================
// GetFmtTableSubTotal : Construct the structure of the Sub Total of the report
//=============================================================================

function TFrmDetCancelLines.GetFmtTableSubTotal : string;
begin  // of TFrmDetCancelLines.GetFmtTableSubTotal
// R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -start
    if (flgCancelTicket or flgAll) then                                         // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-Start
    Result := '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +             // R2013.1-BDES-Enhancement(123)
              '<' + IntToStr (CalcWidthText ( 6, False)) + TxtSep +             // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              '>' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (8, False))  + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (20, False))
     else                                                                       // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-End
     Result := '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
               '>' + IntToStr (CalcWidthText (18, False)) + TxtSep +
               '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
               '<' + IntToStr (CalcWidthText ( 6, False)) + TxtSep +            // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
               '>' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
               '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
               '>' + IntToStr (CalcWidthText (18, False)) + TxtSep +
               '>' + IntToStr (CalcWidthText (8, False))  + TxtSep +
               '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
               '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
               '>' + IntToStr (CalcWidthText (20, False));
// R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -end
end;   // of TFrmDetCancelLines.GetFmtTableSubTotal

//=============================================================================
//  GetFmtTableTotal :  Construct the structure of the Total of the report
//=============================================================================
function TFrmDetCancelLines.GetFmtTableTotal : string;
begin  // of TFrmDetCancelLines.GetFmtTableTotal
// R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -start
    if (flgCancelTicket or flgAll) then                                         // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-Start
    Result := '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +             // R2013.1-BDES-Enhancement(123)
              '<' + IntToStr (CalcWidthText ( 6, False)) + TxtSep +             // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              '>' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (8, False))  + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (20, False))
    else                                                                        // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-End
    Result := '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText ( 6, False)) + TxtSep +             // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              '>' + IntToStr (CalcWidthText ( 8, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (8, False))  + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (20, False));
// R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -start
end;   // of TFrmDetCancelLines.GetFmtTableTotal

//=============================================================================
//  GetTxtTableTitle : Generate the main table titles
//=============================================================================
function TFrmDetCancelLines.GetTxtTableTitle : string;
begin  // of TFrmDetCancelLines.GetTxtTableTitle
    if (flgCancelTicket) then                                                   // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-Start
     Result :=CtTxtNbOperator   + TxtSep +
              CtTxtAnnulType    + TxtSep +
              CtTxtDate         + TxtSep +                                      // R2013.1-BDES-Enhancement(123)
              CtTxtCashDesk     + TxtSep +                                      // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              CtTxtTicketNr     + TxtSep +
              CtTxtNumPLU       + TxtSep +
              CtTxtCodeCasto    + TxtSep +
              CtTxtQty          + TxtSep +
              CtTxtPrice        + TxtSep +
              CtTxtTotalAMount  + TxtSep +
              CtTxtAuthorisedBy
    else
    if (flgAll) then
    Result := CtTxtNbOperator   + TxtSep +
              CtTxtAnnulType    + TxtSep +
              CtTxtDate         + TxtSep +                                      // R2013.1-BDES-Enhancement(123)
              CtTxtCashDesk     + TxtSep +                                      // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              CtTxtTicketNr     + TxtSep +                                      // R2013.2.ALM Defect 87.TCS-SPN
              CtTxtPLUNo        + TxtSep +
              CtTxtCodeCasto    + TxtSep +
              CtTxtQty          + TxtSep +
              CtTxtPrice        + TxtSep +
              CtTxtTotal        + TxtSep +
              CtTxtAuthorisedBy
    else                                                                        // R2012.1 - BDES - Rapport Annulation de lignes(Amit)-End
    Result := CtTxtNbOperator   + TxtSep +
              CtTxtAnnulType    + TxtSep +
              CtTxtDate         + TxtSep +
              CtTxtCashDesk     + TxtSep +                                      // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              CtTxtTicketNr     + TxtSep +
              CtTxtNumPLU       + TxtSep +
              CtTxtCodeCasto    + TxtSep +
              CtTxtQty          + TxtSep +
              CtTxtPrice        + TxtSep +
              CtTxtTotalAMount  + TxtSep +
              CtTxtAuthorisedBy;
end;  // of TFrmDetCancelLines.GetTxtTableTitle
//=============================================================================

function TFrmDetCancelLines.GetTxtTitRapport : string;
begin  // of TFrmDetCancelLines.GetTxtTitRapport
  Result :=CtTxtTitle + CRLF;
end;  // of TFrmDetCancelLines.GetTxtTitRapport

//=============================================================================

function TFrmDetCancelLines.GetTxtRefRapport : string;
begin  // of TFrmDetCancelLines.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0006';
end;  // of TFrmDetCancelLines.GetTxtRefRapport

//=============================================================================

procedure TFrmDetCancelLines.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  TxtDatFormat     : string;
begin  // of TFrmDetCancelLines.PrintHeader
  inherited;
    TxtHdr := TxtTitRapport+ CRLF;

    TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName+ CRLF;
    TxtHdr := TxtHdr +
               DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] + '  ' +
               DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;
    TxtDatFormat := CtTxtDatFormat;
      if RbtDateDay.Checked then
         TxtHdr := TxtHdr + Format (CtTxtReportDate,
                   [FormatDateTime (TxtDatFormat, DtmPckDayFrom.Date),
                     FormatDateTime (TxtDatFormat, DtmPckDayTo.Date)]) + CRLF
      else
         TxtHdr := TxtHdr + Format (CtTxtReportDate,
                   [FormatDateTime (TxtDatFormat, DtmPckLoadedFrom.Date),
                 FormatDateTime (TxtDatFormat, DtmPckLoadedTo.Date)])+ CRLF;
    TxtHdr := TxtHdr + Format (CtTxtPrintDate,
              [FormatDateTime (TxtDatFormat, Now),
              FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF;

    TxtHdr := TxtHdr + TxtTitTypeReport;
    VspPreview.Text := CRLF;
    VspPreview.Header := TxtHdr;
    FrmVSPreview.DrawLogo (Logo);
end;  // of TFrmDetCancelLines.PrintHeader

//=============================================================================
// PrintTableBody : required to struct the data of basic report  with the
//                  calculation of the Total and s/Total
//=============================================================================
procedure TFrmDetCancelLines.PrintTableBody;
var

  TxtLine               : string;    // Line to print
  StoreTicketNo         : Double;    // Temporary storage of ticket no
  SubOperatorPrev       : string;    // To store Operator name
  SubCountOperatorType  : Integer;   // Count operator type at subtotal level
  SubQtyOperAmount      : Integer;   // Count the quantity at subtotal level
  SubValOperAmount      : Double;    // Calculate the ammount of operator at subtotal level
  SubTicketNo           : integer;   // Calculate ticket no at subtotal level

  TotCountOperatorType  : Integer;   // Count operator type at total level
  TotQtyOperAmount      : Integer;   // Count the quantity at total level
  TotValOperAmount      : Double;    // Calculate the ammount of all operator at total level
  TotTicketNo           : Integer;   // Calculate ticket no at total level

begin  // of TFrmDetCancelLines.PrintTableBody
  inherited;
  SubCountOperatorType   := 0;
  SubQtyOperAmount       := 0;
  SubValOperAmount       := 0;
  SubTicketNo            := 1;       //intializing the value to count first line


  TotCountOperatorType   := 0;
  TotQtyOperAmount       := 0;
  TotValOperAmount       := 0;
  TotTicketNo            := 0;
  try
    VspPreview.TableBorder := tbBoxColumns;
    if DmdFpnUtils.QueryInfo (BuildSQLCancelLines) then begin
      SubOperatorPrev := DmdFpnUtils.QryInfo.FieldByName('Operator').AsVariant;
      StoreTicketNo   := DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsVariant;
      while not DmdFpnUtils.QryInfo.Eof do begin
        if SubOperatorPrev = DmdFpnUtils.QryInfo.
            FieldByName('Operator').AsVariant then begin
            SubQtyOperAmount:=SubQtyOperAmount +
                            DmdFpnUtils.QryInfo.FieldByName('QtyReg').AsVariant;
            SubCountOperatorType := SubCountOperatorType + 1;
            SubValOperAmount :=SubValOperAmount +
                          DmdFpnUtils.QryInfo.FieldByName('ValInclVat').Asfloat;
        end;

        if (StoreTicketNo <> DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsVariant) and
            (SubOperatorPrev = DmdFpnUtils.QryInfo.FieldByName('Operator').AsVariant) then begin
           SubTicketNo := SubTicketNo + 1;
           StoreTicketNo   := DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsVariant;
        end;


        if SubOperatorPrev <> DmdFpnUtils.QryInfo.FieldByName('Operator').AsVariant then begin
          PrintSubTotal (SubCountOperatorType,SubTicketNo, SubQtyOperAmount, SubValOperAmount);
          TotCountOperatorType := TotCountOperatorType + SubCountOperatorType;
          TotQtyOperAmount     := TotQtyOperAmount + SubQtyOperAmount;
          TotValOperAmount     := TotValOperAmount + SubValOperAmount;
          TotTicketNo          := TotTicketNo      + SubTicketNo;
          SubCountOperatorType := 1;
          SubQtyOperAmount := 0;
          SubValOperAmount := 0;
          SubTicketNo      := 1;
          TxtLine := TxtSep ;
          SubOperatorPrev := DmdFpnUtils.QryInfo.FieldByName('Operator').AsVariant;
          SubQtyOperAmount:= DmdFpnUtils.QryInfo.FieldByName('QtyReg').AsVariant;
          StoreTicketNo   := DmdFpnUtils.QryInfo.FieldByName('IdtPosTransaction').AsVariant;
          SubValOperAmount :=SubValOperAmount + DmdFpnUtils.QryInfo.FieldByName('ValInclVat').Asfloat;
        end;

        VspPreview.StartTable;
        if(DmdFpnUtils.QryInfo.FieldByName ('Type').AsString=CtTxtCanceledTicket) then// R2012.1 - BDES - Rapport Annulation de lignes -Start
        begin
          TxtLine := DmdFpnUtils.QryInfo.FieldByName ('Operator').AsVariant
             + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Type').AsString
             + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsString // R2013.1-BDES-Enhancement(123)
             + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsString   // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
             + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtPosTransaction').AsString
             + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtArticle').AsString
             + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('NumPLU').AsString
             + TxtSep + ''
             + TxtSep + ''
             + TxtSep + ''
             + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtOperApproval').AsString
        end
        else
        begin
          TxtLine := DmdFpnUtils.QryInfo.FieldByName ('Operator').AsVariant
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Type').AsString
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsString //R2013.1-BDES-Enhancement(123)
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsString   //R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtPosTransaction').AsString                   // R2012.1 - BDES - Rapport Annulation de lignes -End
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtArticle').AsString
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('NumPLU').AsString
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('QtyReg').AsString
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('PrcInclVat').AsString
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('ValInclVat').AsString
            + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtOperApproval').AsString;
          end;                                                                                                           // R2012.1 - BDES - Rapport Annulation de lignes

           VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
           VspPreview.EndTable;
           DmdFpnUtils.QryInfo.Next;
      end;    //end of while condition
      PrintSubTotal (SubCountOperatorType,SubTicketNo, SubQtyOperAmount, SubValOperAmount);
      TotCountOperatorType := TotCountOperatorType + SubCountOperatorType;
      TotQtyOperAmount     := TotQtyOperAmount + SubQtyOperAmount;
      TotValOperAmount     := TotValOperAmount + SubValOperAmount;
      TotTicketNo          := TotTicketNo + SubTicketNo;
      PrintTotal (TotCountOperatorType,TotTicketNo,TotQtyOperAmount,TotValOperAmount);
      TotCountOperatorType := 0;
      TotQtyOperAmount     := 0;
      TotValOperAmount     := 0;
      TotTicketNo          := 1;
     end;    //end of if
       VspPreview.Text := CRLF;
  finally
     DmdFpnUtils.CloseInfo;
  end;
end;  // of TFrmDetCancelLines.PrintTableBody

//=============================================================================
// PrintSubTotal : required to form the "subTotal" row of the required
//                 parameters
//=============================================================================

procedure TFrmDetCancelLines.PrintSubTotal (SubCountOperatorType    : Integer;
                                            SubTicketNo             : Integer;
                                            SubQtyOperAmount        : Integer;
                                            SubValOperAmount        : Double);
var
  TxtLine          : string;           // Line to print
begin  // of TFrmDetCancelLines.PrintSubTotal
  VspPreview.StartTable;
  // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -start
  if (flgCancelTicket) then                                                     // R2012.1 - BDES - Rapport Annulation de lignes -Start
  TxtLine := CtTxtSubTot + TxtSep + IntToStr (SubCountOperatorType) + TxtSep +
    TxtSep + TxtSep + '' + IntToStr(SubTicketNo) + TxtSep + TxtSep+ TxtSep +
    '' + TxtSep + TxtSep +''+ TxtSep + TxtSep
  else
  if ( flgAll) then
  TxtLine := CtTxtSubTot + TxtSep + IntToStr (SubCountOperatorType) + TxtSep +
    TxtSep + TxtSep + '' + IntToStr(SubTicketNo) + TxtSep + TxtSep+ TxtSep +
    IntToStr (SubQtyOperAmount) + TxtSep + TxtSep +
    FormatFloat (CtTxtFrmNumber, SubValOperAmount)+ TxtSep + TxtSep
  else                                                                          // R2012.1 - BDES - Rapport Annulation de lignes -End
  TxtLine := CtTxtSubTot + TxtSep + IntToStr (SubCountOperatorType) + TxtSep +
    TxtSep + TxtSep + '' + IntToStr(SubTicketNo) + TxtSep + TxtSep+
    TxtSep +IntToStr (SubQtyOperAmount) + TxtSep + TxtSep +
    FormatFloat (CtTxtFrmNumber, SubValOperAmount)+ TxtSep + TxtSep;
 // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -end
  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clLtGray, False);
  VspPreview.EndTable;
end;  // of TFrmDetCancelLines.PrintSubTotal

//=============================================================================
//  PrintTotal : required to form the "Total" row  of the required
//               parameters
//=============================================================================

procedure TFrmDetCancelLines.PrintTotal (TotCountOperatorType    : Integer;
                                         TotTicketNo             : Integer;
                                         TotQtyOperAmount        : Integer;
                                         TotValOperAmount        : Double);
var
  TxtLine          : string;           // Line to print
begin  // of TFrmDetCancelLines.PrintTotal
VspPreview.StartTable;
  if (flgCancelTicket) then                                                     // R2012.1 - BDES - Rapport Annulation de lignes -Start
 // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified - start
  TxtLine := CtTxtTotal + TxtSep + IntToStr (TotCountOperatorType) + TxtSep +
    TxtSep + TxtSep + '' + IntToStr(TotTicketNo) + TxtSep + TxtSep+ TxtSep
    +'' + TxtSep + TxtSep +''+ TxtSep+ TxtSep
  else
  if (flgAll) then
  TxtLine := CtTxtTotal + TxtSep + IntToStr (TotCountOperatorType) + TxtSep +
    TxtSep + TxtSep + '' + IntToStr(TotTicketNo) + TxtSep + TxtSep+ TxtSep +
    IntToStr (TotQtyOperAmount) + TxtSep + TxtSep +
    FormatFloat (CtTxtFrmNumber, TotValOperAmount)+ TxtSep+ TxtSep
  else                                                                          // R2012.1 - BDES - Rapport Annulation de lignes -End
  TxtLine := CtTxtTotal + TxtSep + IntToStr (TotCountOperatorType) + TxtSep +
    TxtSep + TxtSep + '' + IntToStr(TotTicketNo) + TxtSep + TxtSep+ TxtSep +
    IntToStr (TotQtyOperAmount) + TxtSep + TxtSep +
    FormatFloat (CtTxtFrmNumber, TotValOperAmount)+ TxtSep+ TxtSep;
 // R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS-modified -end
  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clLtGray, False);
  VspPreview.Text := CRLF;
  VspPreview.EndTable;
end;   // of TFrmDetCancelLines.PrintTotal

//=============================================================================
// BtnPrintClick : is used to print the required report
//=============================================================================

procedure TFrmDetCancelLines.BtnPrintClick(Sender: TObject);
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
// BuildSQLCancelLines : firing required sql query as per as selected combobox
//                       items
//=============================================================================

function TFrmDetCancelLines.BuildSQLCancelLines: string;
begin  // of TFrmDetCancelLines.BuildSQLCancelLines
  //if "All" combobox is selected
  if flgAll = true then begin
    Result :=
    #10' select Operator = posTransAct.IdtOperator +' + ''' ''' + '+posTransAct.TxtName, ' +
    #10'     Type = (case when posTransDetA.CodAction = 6 ' +
    #10'                       then '''+CtTxtCancelLastLine+'''' +
    #10'                  when posTransDetA.CodAction = 7 ' +                   // R2012.1 - BDES - Rapport Annulation de lignes  -Start
    #10'                       then '''+CtTxtCancelPreLine+'''' +
    #10'                  when posTransDetA.CodAction = 86 ' +
    #10'                       then '''+CtTxtCanceledTicket+'''' +              // R2012.1 - BDES - Rapport Annulation de lignes -End
    #10'                 End), ' +
    #10' Convert(varchar(11),posTransAct.DatTransbegin,103)as DatTransBegin,posTransDetB.IdtCheckOut, posTransDetB.IdtPOSTransaction, posTransDetB.IdtArticle, ' +//R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
    #10' posTransDetB.NumPLU,'+
    #10' case when (posTransDetB.IdtPOSTransaction in (select idtpostransaction '+
    #10' from postransdetail (nolock) where codtype = 303 and codaction =8))then -posTransDetB.QtyReg else  Abs(posTransDetB.QtyReg) end as QtyReg,'+
    #10' posTransDetB.PrcInclVat,'+
    #10' case when (posTransDetB.IdtPOSTransaction in (select idtpostransaction '+
    #10' from postransdetail (nolock) where codtype = 303 and codaction =8)) then -posTransDetB.QtyReg * posTransDetB.PrcInclVat else'+
    #10' abs(posTransDetB.QtyReg * posTransDetB.PrcInclVat) end as ValInclVat,' +
    #10' IdtOperApproval = (case when posTransDetA.CodAction in(7,86) then pa.IdtOperApproval End)+' + ''' ''' + '+(case when posTransDetA.CodAction in(7,86) then pa.TxtNameApproval End)' +// R2012.1 - BDES - Rapport Annulation de lignes
    #10'from POSTRANSDETAIL posTransDetA (nolock)  ' +
    #10'inner join POSTRANSDETAIL posTransDetB on posTransDetA.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND posTransDetA.IdtCheckOut = posTransDetB.IdtCheckOut ' +
    #10'  AND posTransDetA.CodTrans = posTransDetB.CodTrans ' +
    #10'  AND posTransDetA.DatTransBegin = posTransDetB.DatTransBegin' +
    #10'  AND posTransDetA.NumLineReg = posTransDetB.NumLineReg' +
    #10'inner join POSTRANSACTION posTransAct ON posTransAct.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND posTransAct.IdtCheckOut = posTransDetB.IdtCheckOut' +
    #10'  AND posTransAct.CodTrans = posTransDetB.CodTrans' +
    #10'  AND posTransAct.DatTransBegin = posTransDetB.DatTransBegin ' +
    #10'Left Outer join PosTransDetApproval pa ON pa.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND pa.DatTransBegin = posTransDetB.DatTransBegin ' +
    #10'  AND pa.NumLineReg  = posTransDetB .NumLineReg ' +
    #10'WHERE posTransDetA.NumLineReg = posTransDetB.NumLineReg ' +
    #10'and posTransDetA.numlinereg not in (select (numlinereg - 1) from postransdetail (nolock) where codaction = 120' +
    #10'                                    and idtpostransaction = posTransDetA.idtpostransaction ' +
    #10'                                    and IdtCheckOut = posTransDetA.IdtCheckOut ';
    Result := Result +
    #10'                                    and posTransDetA.DatTransBegin BETWEEN '+
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                   ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
     Result := Result + ')'+
    #10'and posTransAct.IdtOperator IN (' + TxtLstOperID  + ')' +
    #10'and ((posTransDetA.CodAction in (6,7)'+                                 // R2012.1 - BDES - Rapport Annulation de lignes
    #10'and isnull(posTransAct.Codreturn,0) not in (1))or posTransDetA.CodAction=86) '+ // R2012.1 - BDES - Rapport Annulation de lignes
    #10'and posTransDetB.IdtPOSTransaction not in (select (Idtpostransaction)'+
    #10'     from postransaction (nolock) where codreturn in (101,102)' +
    #10'     AND postransaction.DatTransBegin = posTransDetB.DatTransBegin'+
    #10'     AND postransaction.IdtCheckOut = posTransDetB.IdtCheckOut)'+
    #10'and posTransDetB.IdtPOSTransaction not in (select idtpostransaction from postransinvoice (nolock) where codinvoice = 3'+
    #10'     AND postransinvoice.DatTransBegin = posTransDetB.DatTransBegin'+
    #10'     AND postransinvoice.IdtCheckOut = posTransDetB.IdtCheckOut)'+
    #10'and isnull(posTransAct.FlgTraining,0) not in (1)'+                        
    #10'and posTransDetB.CodAction in (1,86) ';                                 // R2012.1 - BDES - Rapport Annulation de lignes

     if RbtDateDay.Checked then  begin
       Result := Result +
          #10' AND posTransAct.DatTransBegin BETWEEN ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                   ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
     end

     else if RbtDateLoaded.Checked then begin
       Result := Result +
         #10' and posTransAct.DatTransBegin BETWEEN ' +                           
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');   
    end;
        Result := Result +'order by posTransAct.IdtOperator,posTransDetB.DatTransBegin, posTransDetB.IdtPOSTransaction,posTransDetB.NumPLU ';
    end //end of flgAll condition

  // if "Cancel preceding Lines" item is selected
  else if  flgPreLine = true then begin
  Result :=
    #10' select Operator = posTransAct.IdtOperator +' + ''' ''' + '+posTransAct.TxtName, ' +
    #10'     Type = (case when posTransDetA.CodAction = 7 ' +
    #10'                 then '''+CtTxtCancelPreLine+'''' +
    #10'                 End), ' +
    #10' Convert(varchar(11),posTransAct.DatTransbegin,103)as DatTransBegin, posTransDetB.IdtCheckOut, posTransDetB.IdtPOSTransaction, posTransDetB.IdtArticle, ' + //R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
    #10' posTransDetB.NumPLU,'+
    #10' case when (posTransDetB.IdtPOSTransaction in (select idtpostransaction '+
    #10' from postransdetail (nolock) where codtype = 303 and codaction =8))then -posTransDetB.QtyReg else  Abs(posTransDetB.QtyReg) end as QtyReg,'+
    #10' posTransDetB.PrcInclVat,'+
    #10' case when (posTransDetB.IdtPOSTransaction in (select idtpostransaction '+
    #10' from postransdetail (nolock) where codtype = 303 and codaction =8)) then -posTransDetB.QtyReg * posTransDetB.PrcInclVat else'+
    #10' abs(posTransDetB.QtyReg * posTransDetB.PrcInclVat) end as ValInclVat,' +
    #10' IdtOperApproval = (case when posTransDetA.CodAction = 7 then pa.IdtOperApproval End)+' + ''' ''' + '+(case when posTransDetA.CodAction = 7 then pa.TxtNameApproval End)' +
    #10'from POSTRANSDETAIL posTransDetA (nolock)  ' +
    #10'inner join POSTRANSDETAIL posTransDetB on posTransDetA.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND posTransDetA.IdtCheckOut = posTransDetB.IdtCheckOut ' +
    #10'  AND posTransDetA.CodTrans = posTransDetB.CodTrans ' +
    #10'  AND posTransDetA.DatTransBegin = posTransDetB.DatTransBegin' +
    #10'  AND posTransDetA.NumLineReg = posTransDetB.NumLineReg' +
    #10'inner join POSTRANSACTION posTransAct ON posTransAct.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND posTransAct.IdtCheckOut = posTransDetB.IdtCheckOut' +
    #10'  AND posTransAct.CodTrans = posTransDetB.CodTrans' +
    #10'  AND posTransAct.DatTransBegin = posTransDetB.DatTransBegin ' +
    #10'Left Outer join PosTransDetApproval pa ON pa.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND pa.DatTransBegin = posTransDetB.DatTransBegin ' +
    #10'  AND pa.NumLineReg  =posTransDetB .NumLineReg ' +
    #10'WHERE posTransDetA.NumLineReg = posTransDetB.NumLineReg ' +
    #10'and posTransDetA.numlinereg not in (select (numlinereg - 1) from postransdetail (nolock) where codaction = 120' +
    #10'                                    and idtpostransaction = posTransDetA.idtpostransaction ' +
    #10'                                    and IdtCheckOut = posTransDetA.IdtCheckOut ';
    Result := Result +
    #10'                                    and posTransDetA.DatTransBegin BETWEEN '+
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                   ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
     Result := Result + ')'+
    #10'and posTransAct.IdtOperator IN (' + TxtLstOperID  + ')' +
    #10'and posTransDetA.CodAction = 7' +
    #10'and isnull(posTransAct.Codreturn,0) not in (1)'+
    #10'and posTransDetB.IdtPOSTransaction not in (select (Idtpostransaction)'+
    #10'     from postransaction (nolock) where codreturn in (101,102)' +
    #10'     AND postransaction.DatTransBegin = posTransDetB.DatTransBegin'+
    #10'     AND postransaction.IdtCheckOut = posTransDetB.IdtCheckOut)'+
    #10'and posTransDetB.IdtPOSTransaction not in (select idtpostransaction from postransinvoice (nolock) where codinvoice = 3'+
    #10'     AND postransinvoice.DatTransBegin = posTransDetB.DatTransBegin'+
    #10'     AND postransinvoice.IdtCheckOut = posTransDetB.IdtCheckOut)'+
    #10'and isnull(posTransAct.FlgTraining,0) not in (1)'+
    #10'and posTransDetB.CodAction = 1 ';
     if RbtDateDay.Checked then  begin
        Result := Result +
          #10' AND posTransAct.DatTransBegin BETWEEN ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                   ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
     end

      else if RbtDateLoaded.Checked then begin
        Result := Result +
          #10' AND  posTransAct.DatTransBegin BETWEEN ' +                         
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
      end;

        Result := Result +'order by posTransAct.IdtOperator,posTransDetB.DatTransBegin, posTransDetB.IdtPOSTransaction,posTransDetB.NumPLU ';
    end //end of  flgPreLine condition

  //if "Cancel Last Line" item is selected
  else if  flgLastLine = true then begin                                        //R2012.1 - BDES - Rapport Annulation de lignes
  Result :=
    #10' select Operator = posTransAct.IdtOperator +' + '''  ''' + '+posTransAct.TxtName, ' +
    #10'     Type = (case when posTransDetA.CodAction= 6 ' +
    #10'                 then '''+CtTxtCancelLastLine+'''' +
    #10'                 End), ' +
    #10'     Convert(varchar(11),posTransDetB.DatTransbegin,103)as DatTransBegin, posTransDetB.IdtCheckOut, posTransDetB.IdtPOSTransaction, posTransDetB.IdtArticle, ' + //R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
    #10'     posTransDetB.NumPLU,'+
    #10' case when (posTransDetB.IdtPOSTransaction in (select idtpostransaction'+
    #10' from postransdetail (nolock) where codtype = 303 and codaction =8))then -posTransDetB.QtyReg else  Abs(posTransDetB.QtyReg) end as QtyReg,'+
    #10' posTransDetB.PrcInclVat,'+
    #10' case when (posTransDetB.IdtPOSTransaction in (select idtpostransaction '+
    #10' from postransdetail (nolock) where codtype = 303 and codaction =8)) then -posTransDetB.QtyReg * posTransDetB.PrcInclVat else'+
    #10' abs(posTransDetB.QtyReg * posTransDetB.PrcInclVat) end as ValInclVat,' +
    #10'     IdtOperApproval = (case when posTransDetA.CodAction = 7 then pa.IdtOperApproval End)' +
    #10'from POSTRANSDETAIL posTransDetA (nolock)  ' +                            
    #10'inner join POSTRANSDETAIL posTransDetB on posTransDetA.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND posTransDetA.IdtCheckOut = posTransDetB.IdtCheckOut ' +
    #10'  AND posTransDetA.CodTrans = posTransDetB.CodTrans ' +
    #10'  AND posTransDetA.DatTransBegin = posTransDetB.DatTransBegin' +
    #10'  AND posTransDetA.NumLineReg = posTransDetB.NumLineReg' +
    #10'inner join POSTRANSACTION posTransAct ON posTransAct.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND posTransAct.IdtCheckOut = posTransDetB.IdtCheckOut' +
    #10'  AND posTransAct.CodTrans = posTransDetB.CodTrans' +
    #10'  AND posTransAct.DatTransBegin = posTransDetB.DatTransBegin ' +
    #10'Left Outer join PosTransDetApproval pa ON pa.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND pa.DatTransBegin = posTransDetB.DatTransBegin ' +
    #10'  AND pa.NumLineReg  = posTransDetB .NumLineReg ' +
    #10'WHERE posTransDetA.NumLineReg = posTransDetB.NumLineReg ' +
    #10'AND posTransAct.IdtOperator IN (' + TxtLstOperID  + ')' +
    #10'and posTransDetA.CodAction = 6' +
    #10'and isnull(posTransAct.Codreturn,0) not in (1)'+
    #10'and posTransDetB.IdtPOSTransaction not in (select (Idtpostransaction)'+
    #10'     from postransaction (nolock) where codreturn in (101,102)' +
    #10'     AND postransaction.DatTransBegin = posTransDetB.DatTransBegin'+
    #10'     AND postransaction.IdtCheckOut = posTransDetB.IdtCheckOut)'+
    #10'and posTransDetB.IdtPOSTransaction not in (select idtpostransaction from postransinvoice (nolock) where codinvoice = 3'+
    #10'     AND postransinvoice.DatTransBegin = posTransDetB.DatTransBegin'+
    #10'     AND postransinvoice.IdtCheckOut = posTransDetB.IdtCheckOut)'+
    #10'and isnull(posTransAct.FlgTraining,0) not in (1)'+
    #10'and posTransDetB.CodAction = 1 ';
     if RbtDateDay.Checked then  begin
        Result := Result +
          #10' AND posTransAct.DatTransBegin BETWEEN ' +                          
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                   ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
     end

      else if RbtDateLoaded.Checked then begin
        Result := Result +
          #10' AND posTransAct.DatTransBegin BETWEEN ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
      end;

    Result := Result + ' order by posTransAct.IdtOperator,posTransDetB.DatTransBegin,posTransDetB.IdtPOSTransaction,posTransDetB.NumPLU ';
       end  //End of Lastline cancellation

  // if "Cancel Ticket" item is selected
  else if  flgCancelTicket = true then begin                                    // R2012.1 - BDES - Rapport Annulation de lignes -Start
  Result :=
     #10' select Operator = posTransAct.IdtOperator +' + ''' ''' + '+posTransAct.TxtName, ' +
    #10'     Type = (case when posTransDetA.CodAction = 86 ' +
    #10'                 then '''+CtTxtCanceledTicket+'''' +
    #10'                 End), ' +
    #10' Convert(varchar(11),posTransAct.DatTransbegin,103)as DatTransBegin,posTransDetB.IdtCheckOut , posTransDetB.IdtPOSTransaction, posTransDetB.IdtArticle, ' +           //R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
    #10' posTransDetB.NumPLU, Abs(posTransDetB.QtyReg) as QtyReg, posTransDetB.PrcInclVat, abs(posTransDetB.QtyReg * posTransDetB.PrcInclVat) as ValInclVat,' +
    #10' IdtOperApproval = (case when posTransDetA.CodAction in(7,86) then pa.IdtOperApproval End)+' + ''' ''' + '+(case when posTransDetA.CodAction in (7,86) then pa.TxtNameApproval End)' +
    #10'from POSTRANSDETAIL posTransDetA (nolock)  ' +
    #10'inner join POSTRANSDETAIL posTransDetB on posTransDetA.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND posTransDetA.IdtCheckOut = posTransDetB.IdtCheckOut ' +
    #10'  AND posTransDetA.CodTrans = posTransDetB.CodTrans ' +
    #10'  AND posTransDetA.DatTransBegin = posTransDetB.DatTransBegin' +
    #10'  AND posTransDetA.NumLineReg = posTransDetB.NumLineReg' +
    #10'inner join POSTRANSACTION posTransAct ON posTransAct.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND posTransAct.IdtCheckOut = posTransDetB.IdtCheckOut' +
    #10'  AND posTransAct.CodTrans = posTransDetB.CodTrans' +
    #10'  AND posTransAct.DatTransBegin = posTransDetB.DatTransBegin ' +
    #10'Left Outer join PosTransDetApproval pa ON pa.IdtPOSTransaction = posTransDetB.IdtPOSTransaction ' +
    #10'  AND pa.DatTransBegin = posTransDetB.DatTransBegin ' +
    #10'  AND pa.NumLineReg  = posTransDetB .NumLineReg ' +
    #10'WHERE posTransDetA.NumLineReg = posTransDetB.NumLineReg ' +
    #10'and posTransAct.IdtOperator IN (' + TxtLstOperID  + ')' +
    #10'and posTransDetA.CodAction = 86' +
    #10'and isnull(posTransAct.FlgTraining,0) not in (1)'+
    #10'and posTransDetB.CodAction in (1,86) ';
     if RbtDateDay.Checked then  begin
       Result := Result +
         #10' AND posTransAct.DatTransBegin BETWEEN ' +
              AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                         ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
              AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                  ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
     end
     else if RbtDateLoaded.Checked then begin
       Result := Result +
         #10' AND posTransAct.DatTransBegin BETWEEN ' +                          
              AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                         ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
              AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                         ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
      end;

      Result := Result + ' order by posTransAct.IdtOperator,posTransDetB.DatTransBegin,posTransDetB.IdtPOSTransaction,posTransDetB.NumPLU ';
    end
end;
 // of TFrmDetCancelLines.BuildSQLCancelLines

//=============================================================================
procedure TFrmDetCancelLines.AutoStart(Sender: TObject);
begin  // of TFrmDetCancelLines.AutoStart(Sender: TObject)
  inherited;
  PnlType.Visible := True;
  FillReportType;
  PnlCheckout.Visible := False;
  RbtDateLoaded.Visible := True;
  DtmPckLoadedFrom.Visible := True;
  DtmPckLoadedTo.Visible := True;
end;  // of TFrmDetCancelLines.AutoStart(Sender: TObject)

//=============================================================================

procedure TFrmDetCancelLines.FillLbxCheckouts;
begin  // of TFrmDetCancelLines.FillLbxCheckouts
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
end;  // of TFrmDetCancelLines.FillLbxCheckouts

//=============================================================================
// FillReportType : Adding the items and fix the "All" item as default
//=============================================================================

procedure TFrmDetCancelLines.FillReportType;
begin  // of TFrmDetCancelLines.FillReasonCodes
  inherited;
      CmbbxCancelLine.Items.Clear;
      CmbbxCancelLine.Items.Add(CtTxtAll);
      CmbbxCancelLine.Items.Add(CtTxtCancelPreLine);
      CmbbxCancelLine.Items.Add(CtTxtCancelLastLine);
      CmbbxCancelLine.Items.Add(CtTxtCancelTicket);								             	// R2012.1 - BDES - Rapport Annulation de lignes
      CmbbxCancelLine.ItemIndex := 0;
      flgAll :=true;
end;  // of TFrmDetCancelLines.FillReasonCodes

//=============================================================================
procedure TFrmDetCancelLines.BtnSelectAllCheckoutClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetCancelLines.BtnSelectAllCheckoutClick
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do
    ChkLbxCheckout.Checked [CntIx] := True;
end;  // of TFrmDetCancelLines.BtnSelectAllCheckoutClick

//=============================================================================

procedure TFrmDetCancelLines.BtnDESelectAllCheckoutClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetCancelLines.BtnDESelectAllCheckoutClick
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do
    ChkLbxCheckout.Checked [CntIx] := False;
end;  // of TFrmDetCancelLines.BtnDESelectAllCheckoutClick

//=============================================================================

function TFrmDetCancelLines.GetTxtLstCheckoutID: string;
var
  CntCheckout      : Integer;          // Loop the operators in the Checklistbox
begin  // of TFrmDetCancelLines.GetTxtLstCheckoutID
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
end;  // of TFrmDetCancelLines.GetTxtLstCheckoutID

//=============================================================================

function TFrmDetCancelLines.GetItemsSelected: Boolean;
begin  // of TFrmDetCancelLines.GetItemsSelected

    Result := inherited GetItemsSelected;
end;  // of TFrmDetCancelLines.GetItemsSelected

//=============================================================================

procedure TFrmDetCancelLines.CmbbxCancelLineKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmDetCancelLines.CmbbxReasonCodeKeyDown
  inherited;
  if Key = VK_DELETE then
    CmbbxCancelLine.ItemIndex := -1;

end;  // of TFrmDetCancelLines.CmbbxReasonCodeKeyDown

//=============================================================================

function TFrmDetCancelLines.GetTxtTitTypeReport: string;
begin // of TFrmDetCancelLines.GetTxtTitTypeReport
  if flgAll = true then begin
    Result := CtTxtTitleReportType + ' ' + CtTxtAll;
    end
  else if flgPreLine = true then begin
    Result := CtTxtTitleReportType + ' ' + CtTxtCancelPreLine;
    end
  else if flgCancelTicket= true then begin                                      // R2012.1 - BDES - Rapport Annulation de lignes -Start
    Result := CtTxtTitleReportType + ' ' + CtTxtCancelTicket ;
    end                                                                         // R2012.1 - BDES - Rapport Annulation de lignes -End
  else
    Result := CtTxtTitleReportType + ' ' + CtTxtCancelLastLine;
end;  // of TFrmDetCancelLines.GetTxtTitTypeReport

//============================================================================

procedure TFrmDetCancelLines.SetGeneralSettings;
begin  // of TFrmDetCancelLines.SetGeneralSettings
  VspPreview.MarginHeader := 500;
  VspPreview.MarginTop := 2500;
  FNLogo := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\Image\' + CtTxtLogoName;
end;  // of TFrmDetCancelLines.SetGeneralSettings

//=============================================================================
// BtnExportClick : generate required report in excel format
//=============================================================================
procedure TFrmDetCancelLines.BtnExportClick(Sender: TObject);

var
  TxtTitles           : string;
  TxtWriteLine        : string;
  counter             : Integer;
  F                   : System.Text;
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;

begin  // of TFrmDetCancelLines.BtnExportClick
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
      try
        if DmdFpnUtils.QueryInfo(BuildSQLCancelLines) then begin
          while not DmdFpnUtils.QryInfo.Eof do begin
            if (flgCancelTicket or flgAll) then                                 // R2012.1 - BDES - Rapport Annulation de lignes-Start
            TxtWriteLine :=
              DmdFpnUtils.QryInfo.FieldByName ('Operator').AsVariant     + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('Type').AsString          + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsString + ';' +// R2013.1-BDES-Enhancement(123)
              DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsString   + ';' + //R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              DmdFpnUtils.QryInfo.FieldByName ('IdtPosTransaction').AsString  + ';'+
              DmdFpnUtils.QryInfo.FieldByName ('IdtArticle').AsString    + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('NumPLU').AsString        + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('QtyReg').AsString        + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('PrcInclVat').AsString    + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('ValInclVat').AsString    + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('IdtOperApproval').AsString
            else                                                                // R2012.1 - BDES - Rapport Annulation de lignes-End
            TxtWriteLine :=
              DmdFpnUtils.QryInfo.FieldByName ('Operator').AsVariant     + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('Type').AsString          + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsString + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsString   + ';' +//R2013.2-BRES-req36040-Add cashdesk column to the report-TCS-AS
              DmdFpnUtils.QryInfo.FieldByName ('IdtPosTransaction').AsString  + ';'+
              DmdFpnUtils.QryInfo.FieldByName ('IdtArticle').AsString    + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('NumPLU').AsString        + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('QtyReg').AsString        + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('PrcInclVat').AsString    + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('ValInclVat').AsString    + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('IdtOperApproval').AsString;

              WriteLn(F, TxtWriteLine);
              DmdFpnUtils.QryInfo.Next;
          end;    //end of while loop
        end
        else begin
          TxtWriteLine := '';
          WriteLn(F, TxtWriteLine);
        end;  // end of else part of if loop
      finally
        DmdFpnUtils.CloseInfo;
        System.Close(F);
        DecimalSeparator := ChrDecimalSep;
      end;
    end;
  end;
end;  // of TFrmDetCancelLines.BtnExportClick

//=============================================================================
// cmbbxCancelLineChange : generate corrosponding flag for the selected
//                         items
//=============================================================================
procedure TFrmDetCancelLines.cmbbxCancelLineChange(Sender: TObject);

begin  // of TFrmDetCancelLines.cmbbxCancelLineChange
   inherited;
   CmbbxCancelLine.Refresh;
   flgCancelTicket :=False;                                                     // R2012.1 - BDES - Rapport Annulation de lignes
   flgAll :=False;
   flgPreLine := False;
   flgLastLine := False;
   if CmbbxCancelLine.Text = CtTxtAll  then begin
     flgAll :=true;
   end
   else if  CmbbxCancelLine.Text = CtTxtCancelPreLine then begin
     flgPreLine :=true;
   end
   else if  CmbbxCancelLine.Text = CtTxtCancelLastLine then begin
     flgLastLine :=true;
   end
   else if  CmbbxCancelLine.Text = CtTxtCancelTicket then begin                 // R2012.1 - BDES - Rapport Annulation de lignes-Start
     flgCancelTicket :=true;
   end                                                                          // R2012.1 - BDES - Rapport Annulation de lignes-End
 end; // of TFrmDetCancelLines.cmbbxCancelLineChange
 
//=============================================================================

procedure TFrmDetCancelLines.FormCreate(Sender: TObject);

begin // of TFrmDetCancelLines.FormCreate
  inherited;
  application.Title := CtTxtTitle;
  Self.Caption := CtTxtTitle;
end; // of TFrmDetCancelLines.FormCreate

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FDetCancelLines


