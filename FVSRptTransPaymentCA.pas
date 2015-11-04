//================= Real Software - Retail Division (c) 2006 ==================
// Packet   : FlexPoint 2.0.1
// Customer : Castorama
// Unit     : VSRptTransPaymentCA = Form VideoSoft RePorT TRANSfer PAYMENTs
//            for CAstorama
//---------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTransPaymentCA.pas,v 1.2 2006/12/22 13:39:45 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - VSRptTransPaymentCA - CVS rev 1.3
//=============================================================================

unit FVSRptTransPaymentCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfVSPrinter7, ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ExtCtrls, ToolWin, RFpnTender;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring     // General report labels
  CtTxtHdrRpt      = 'Report payment transfers';
  CtTxtGrandTotal  = 'Total:';
  CtTxtValidatedBy = 'Validated by';
  CtTxtPrintDate   = 'Printed on %s at %s';

resourcestring     // table headers
  CtTxtTicket      = 'N° Ticket';
  CtTxtOrder       = 'N° Order';
  CtTxtCashDesk    = 'N° CashDesk';
  CtTxtOperator    = 'N° Operator';
  CtTxtDate        = 'Ticketdate';
  CtTxtAmount      = 'Amount to transfer';
  CtTxtCount       = 'Count processed?';
  CtTxtTotal       = 'Total:';

var // Margins
  ViValMarginLeft  : Integer =  900;   // MarginLeft for VspPreview
  ViValMarginHeader: Integer = 1300;   // Adjust MarginTop to leave room for hdr

var // Fontsizes
  ViValFontHeader  : Integer = 16;     // FontSize header

var // Positions and white space
  ViValSpaceBetween: Integer =  200;   // White space between tables

var // Column-width (in number of characters)
  ViValTicket     : Integer = 15;      // Width of 'N° Ticket' column
  ViValOrder      : Integer = 15;      // Width of 'N° Order' column
  ViValCashdesk   : Integer = 15;      // Width of 'N° Cashdesk' column
  ViValOperator   : Integer = 15;      // Width of 'N° Operator' column
  ViValDate       : Integer = 15;      // Width of 'Ticketdate' column
  ViValAmount     : Integer = 20;      // Width of 'Amount to transfer' column
  ViValCount      : Integer = 20;      // Width of 'Count processed?' column

var // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables

const  // for the dimensions of the rectangle (signature)
  CtValVisaRespRecHeight  = 1000;
  CtValVisaRespRecWidth   = 3000;

//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmVSRptTransPaymentCA = class(TFrmVSPreview)
    procedure FormCreate(Sender: TObject);
    procedure VspPreviewBeforeHeader(Sender: TObject);
  private
    FLstTransPayments   : TList;           // List with all tranfered records
    ValAmount           : Double;          // Total Amount in one container
  protected
    { Protected declarations }
    FPicLogo            : TImage;           // Logo
    FTxtFNLogo          : string;           // Filename Logo
    ValOrigMarginTop    : Double;           // Original MarginTop
    ArrPages            : array of Integer; // Array of pages to restart counting
    QtyLinesPrinted     : Integer;          // Linecounter for report
    TxtTableFmt         : string;           // Format for current Table on report
    TxtTableHdr         : string;           // Header for current Table on report
    FPreviewReport      : Boolean;          // Preview report Y/N
    FCodRunFunc         : Integer;          // there are two functions for which
                                            // this report is used:
                                            // the first is the list of containers
                                            // with the detail of each bag in
                                            // the container
                                            // the second
    FNumRef             : string;           // Report reference
    FIdtOperReg         : string;           // Operator validating transfers
    FTxtNameOperReg     : string;           // Operator validating transfers
    function GetNumEndBaseRapport    : Integer; virtual;
    function CalcTextHei             : Double; virtual;
    procedure SetTxtFNLogo (Value : string); virtual;
    procedure PrintPageHeader; virtual;
    procedure PrintTable; virtual;
    procedure GenerateBody; virtual;
    procedure PrintGrandTotal;
    procedure PrintEndClause; virtual;
    procedure AddFooterToPages; virtual;
    procedure PrintTableLine (TxtLine : string); virtual;
    procedure PrintRef; virtual;
  public
    { Public declarations }
    property TxtFNLogo : string read  FTxtFNLogo
                                write SetTxtFNLogo;
    property PicLogo : TImage read  FPicLogo
                              write FPicLogo;
    property NumEndBaseRapport : Integer read GetNumEndBaseRapport;
    property PreviewReport : Boolean read  FPreviewReport
                                     write FPreviewReport;
    property NumRef : string read  FNumRef
                             write FNumRef;
    procedure DrawLogo (ImgLogo : TImage); override;
    procedure GenerateReport; virtual;
  published
    { Published declarations }
    property LstTransPayments : TList read FLstTransPayments
                                     write FLstTransPayments;
    property IdtOperReg : string read FIdtOperReg
                                write FIdtOperReg;
    property TxtNameOperReg : string read  FTxtNameOperReg
                                     write FTxtNameOperReg;
  end; // of TFrmVSRptContainerCA

var
  FrmVSRptTransPaymentCA: TFrmVSRptTransPaymentCA;

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptContainerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTransPaymentCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:39:45 $';

//*****************************************************************************

implementation

uses
  SfDialog,
  RFpnCom,
  SmUtils,
  DFpnUtils,
  DFpnTradeMatrix;

{$R *.DFM}

//*****************************************************************************
// Implementation of TFrmVSRptTransPaymentCA
//*****************************************************************************

//*****************************************************************************
// TFrmVSRptTransPaymentCA - Getters / Setters
//*****************************************************************************

//=============================================================================
// TFrmVSRptTransPaymentCA.GetNumEndBaseRapport : Fetch last pagenumber of report.
//                                             To be used in the PrintDoc method
//                                             of the maintenance task form
//=============================================================================

function TFrmVSRptTransPaymentCA.GetNumEndBaseRapport : Integer;
begin  // of TFrmVSRptTransPaymentCA.GetNumEndBaseRapport
  Result := ArrPages [1] - 1;
end;   // of TFrmVSRptTransPaymentCA.GetNumEndBaseRapport

//=============================================================================
// TFrmVSRptContainerCA.SetTxtFNLogo: loads the logo file into an image-object
//=============================================================================

procedure TFrmVSRptTransPaymentCA.SetTxtFNLogo (Value: string);
begin // of TFrmVSRptTransPaymentCA.SetTxtFNLogo
  FTxtFNLogo := ReplaceEnvVar (Value);
  if (TxtFNLogo <> '') and FileExists (TxtFNLogo) then begin
    if not Assigned (PicLogo) then begin
      PicLogo := TImage.Create (Self);
      PicLogo.AutoSize := True;
    end;
    try
      PicLogo.Picture.LoadFromFile (TxtFNLogo);
    except
    end;
  end;
end;  // of TFrmVSRptTransPaymentCA.SetTxtFNLogo

//=============================================================================
// TFrmVSRptContainerCA.CalcTextHei : calculates VspPreview.TextHei for a
// single line in the current font.
//                                  -----
// FUNCRES : calculated TextHei.
//=============================================================================

function TFrmVSRptTransPaymentCA.CalcTextHei : Double;
begin  // of TFrmVSRptTransPaymentCA.CalcTextHei
  VspPreview.X1 := 0;
  VspPreview.Y1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y2 := 0;

  VspPreview.CalcParagraph := 'X';
  Result := VspPreview.TextHei;
end;   // of TFrmVSRptTransPaymentCA.CalcTextHei

//=============================================================================
// TFrmVSRptTransPaymentCA.PrintPageHeader : prints the header of the report.
//                                  -----
// Restrictions :
// - is called from VspPreview.OnBeforeHeader; provided as virtual method to
//   improve inheritance.
//=============================================================================

procedure TFrmVSRptTransPaymentCA.PrintPageHeader;
var
  ViValFontSave  : Variant;            // Save original FontSize
  TxtHeader      : string;             // Build header string to print
begin  // of TFrmVSRptTransPaymentCA.PrintPageHeader
  ViValFontSave := VspPreview.FontSize;
  try
    // Header report count
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.CurrentY := ValOrigMarginTop;
    VspPreview.FontSize := ViValFontHeader;
    VspPreview.FontBold := True;
    VspPreview.Text := CtTxtHdrRpt + ' ' + TxtHeader;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    VspPreview.Fontsize := ViValFontSave;
    VspPreview.Text := DmdFpnTradeMatrix.InfoTradeMatrix [
            DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'];
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    VspPreview.Text := Format (CtTxtPrintDate, [FormatDateTime (CtTxtDatFormat,
                       Now), FormatDateTime (CtTxtHouFormat, Now)]);
  finally
    VspPreview.Fontsize := ViValFontSave;
    VspPreview.FontBold := False;
  end;
end;   // of TFrmVSRptTransPaymentCA.PrintPageHeader

//=============================================================================
// TFrmVSRptTransPaymentCA.PrintTable: Define the format of the table
//=============================================================================

procedure TFrmVSRptTransPaymentCA.PrintTable;
begin // of TFrmVSRptTransPaymentCA.PrintTable

  // initialization of number of lines
  QtyLinesPrinted := 0;

  // set table and header format

  // Ticketnumber
  TxtTableFmt := '<' + Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValTicket)]);

  // Orderdocumentnumber
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValOrder)]);

  // Cashdesk
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValCashDesk)]);

  // Operator
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValOperator)]);

  // Date
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValDate)]);

  // Amount
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                 ColumnWidthInTwips (ViValAmount)]);

  // Count
  TxtTableFmt := TxtTableFmt + SepCol + '>' +
                 Format ('%s%d', [FormatAlignLeft,
                                 ColumnWidthInTwips (ViValCount)]);

  TxtTableHdr :=   CtTxtTicket + SepCol + CtTxtOrder + SepCol + CtTxtCashDesk  +
                   SepCol + CtTxtOperator + SepCol + CtTxtDate + SepCol +
                   CtTxtAmount + SepCol + CtTxtCount;
  VspPreview.StartTable;
  try
    GenerateBody;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;

end;  // of TFrmVSRptTransPaymentCA.PrintTable

//=============================================================================
// TFrmVSRptTransPaymentCA.GenerateBody : Prints the body (detail) of the table
//=============================================================================

procedure TFrmVSRptTransPaymentCA.GenerateBody;
var
  CntItem             : Integer;          // counter for list of bags
  TxtLine             : string;           // line for payment transfer
begin // of TFrmVSRptTransPaymentCA.GenerateBody
  ValAmount      := 0; // reset total amount in euros
  for CntItem := 0 to LstTransPayments.Count - 1 do begin
    TxtLine := TStringList(LstTransPayments[CntItem])[0] + SepCol +
               TStringList(LstTransPayments[CntItem])[1] + SepCol +
               TStringList(LstTransPayments[CntItem])[2] + SepCol +
               TStringList(LstTransPayments[CntItem])[3] + SepCol +
               TStringList(LstTransPayments[CntItem])[4] + SepCol +
               TStringList(LstTransPayments[CntItem])[5] + SepCol +
               TStringList(LstTransPayments[CntItem])[6];
    PrintTableLine (TxtLine);
    ValAmount := ValAmount +
                          StrToFloat(TStringList(LstTransPayments[CntItem])[5]);
  end;
end;  // of TFrmVSRptTransPaymentCA.GenerateBody

//=============================================================================
// TFrmVSRptTransPaymentCA.AddFooterToPages
//=============================================================================

procedure TFrmVSRptTransPaymentCA.AddFooterToPages;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
  NumPage          : Integer;          // PageNumber
  TotPage          : Integer;          // total Pages
  CntArray         : Integer;          // Array counter
begin  // of TFrmVSRptTransPaymentCA.AddFooterToPages
  // Add page number and date to report
  CntArray := 0;
  NumPage := 0;
  TotPage := 0;
  for CntPage := 1 to VspPreview.PageCount do begin
    VspPreview.StartOverlay (CntPage, False);
    try
      Inc (NumPage);
      if CntPage >= ArrPages[CntArray] then begin
        NumPage := 1;
        Inc (CntArray);
        TotPage := ArrPages [CntArray] - ArrPages [CntArray - 1];
      end;
      VspPreview.CurrentX := VspPreview.MarginLeft;
      VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                             VspPreview.TextHeight ['X'];
      TxtPage := Format ('P.%d/%d', [NumPage, TotPage]);
      VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight -
                             VspPreview.TextWidth [TxtPage] - 1;
      VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                             VspPreview.TextHeight ['X'];
      VspPreview.Text := TxtPage;

    finally
      VspPreview.EndOverlay;
    end;
  end;  // of for CntPage := 1 to VspPreview.PageCount
end;   // of TFrmVSRptTransPaymentCA.AddFooterToPages

//=============================================================================
// TFrmVSRptTransPaymentCA.PrintTableLine : adds the line to the current Table.
//                                  -----
// INPUT   : TxtLine = line to add to the Table.
//=============================================================================

procedure TFrmVSRptTransPaymentCA.PrintTableLine (TxtLine : string);
begin  // of TFrmVSRptTransPaymentCA.PrintTableLine
  VspPreview.AddTable (TxtTableFmt, TxtTableHdr, TxtLine,
                       ViColHeader, ViColBody, False);
  Inc (QtyLinesPrinted);
end;   // of TFrmVSRptTransPaymentCA.PrintTableLine

//=============================================================================

procedure TFrmVSRptTransPaymentCA.PrintRef;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSRptTransPaymentCA.PrintRef
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, True);
      CurrentX := PageWidth - MarginRight - TextWidth [NumRef] - 1;
      CurrentY := PageHeight - MarginBottom + TextHeight ['X'] - 250;
      Text := NumRef;
      EndOverlay;
    end;
  end;
end;   // of TFrmVSRptTransPaymentCA.PrintRef

//=============================================================================
// TFrmVSRptTransPaymentCA.PrintGrandTotal : adds Sub Totals to the report.
//=============================================================================

procedure TFrmVSRptTransPaymentCA.PrintGrandTotal;
var
  TxtGrandTotal     : string;        // printline voor grand totals
begin  // of TFrmVSRptTransPaymentCA.PrintGrandTotal
  TxtGrandTotal := '' + SepCol + '' + SepCol + '' + SepCol + '' + SepCol +
                  CtTxtGrandTotal + SepCol +
                  FormatFloat('0.00', ValAmount) + SepCol + '' ;
  VspPreview.AddTable (TxtTableFmt, '', TxtGrandTotal,
                       ViColHeader, ViColHeader, False);
  Inc (QtyLinesPrinted);
end;   // of TFrmVSRptTransPaymentCA.PrintGrandTotal

//=============================================================================
// TFrmVSRptTransPaymentCA.PrintEndClause: prints the text for pièce comptable, the
// rectangle and text for 'Visa Responsable'.
//=============================================================================

procedure TFrmVSRptTransPaymentCA.PrintEndClause;
begin  // of TFrmVSRptTransPaymentCA.PrintEndClause
  VspPreview.FontSize := 10;
  VspPreview.CurrentX := ViValMarginLeft;
  VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom -
                         CtValVisaRespRecHeight - 750;
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.Text := Format ('%s : %s - %s', [CtTxtValidatedBy, IdtOperReg,
                                              TxtNameOperReg]);
  // Print a rectangle for holding the visa responsable
  VspPreview.DrawRectangle (ViValMarginLeft, VspPreview.PageHeight -
                            VspPreview.MarginBottom - CtValVisaRespRecHeight -
                            400, VspPreview.MarginLeft + CtValVisaRespRecWidth,
                            VspPreview.PageHeight - VspPreview.MarginBottom -400,
                            0, 0);
end;   // of TFrmVSRptTransPaymentCA.PrintEndClause

//=============================================================================
// TFrmVSRptContainerCA.DrawLogo
//=============================================================================

procedure TFrmVSRptTransPaymentCA.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptTransPaymentCA.DrawLogo
  if (TxtFNLogo <> '') and (Assigned (ImgLogo)) then begin
    // Assure logo is printed on top of page
    ValSaveMargin := VspPreview.MarginTop;
    VspPreview.MarginTop := ValOrigMarginTop;
    try
      inherited;
    finally
      VspPreview.MarginTop := ValSaveMargin;
    end;
  end;
end;   // of TFrmVSRptTransPaymentCA.DrawLogo

//=============================================================================
// TFrmVSRptTransPaymentCA.GenerateReport : main routine for printing report
//=============================================================================

procedure TFrmVSRptTransPaymentCA.GenerateReport;
begin // of TFrmVSRptTransPaymentCA.GenerateReport
  NumRef := 'REP0035';

  Visible := True;
  Visible := False;

  SetLength (ArrPages, 1);
  ArrPages [Length (ArrPages) - 1] := 1;
  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  VspPreview.Preview := True;
  try
    QtyLinesPrinted := 0;
    PrintTable;
    PrintGrandTotal;
    PrintEndClause;
  finally
    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
  PrintRef;
  if PreviewReport then
    ShowModal;
end;  // of TFrmVSRptTransPaymentCA.GenerateReport

//*****************************************************************************
// TFrmVSRptContainerCA - Generated Events
//*****************************************************************************

procedure TFrmVSRptTransPaymentCA.FormCreate (Sender: TObject);
begin // of TFrmVSRptTransPaymentCA.FormCreate
  inherited;
  // Set defaults
  TxtFNLogo := CtTxtEnvVarStartDir + '\Image\FlexPoint.Report.BMP';

  // Overrule default properties for VspPreview.
  VspPreview.MarginLeft := ViValMarginLeft;
  // Leave room for header
  ValOrigMarginTop      := VspPreview.MarginTop;
  VspPreview.MarginTop  := ValOrigMarginTop + ViValMarginHeader;

  // Sets an empty header to make sure OnBeforeHeader is fired.
  VspPreview.Header := ' ';
end;  // of TFrmVSRptTransPaymentCA.FormCreate

//=============================================================================
// TFrmVSRptTransPaymentCA.VspPreviewBeforeHeader
//=============================================================================

procedure TFrmVSRptTransPaymentCA.VspPreviewBeforeHeader (Sender: TObject);
var
  ValPosYEndHdr  : Double;             // Y-position at end of header
begin  // of TFrmVSRptTransPaymentCA.VspPreviewBeforeHeader
  inherited;

  DrawLogo (PicLogo);
  PrintPageHeader;
  // Save Y-position at end of header
  ValPosYEndHdr := VspPreview.CurrentY;
  // Calculate Y-position for Address to align it with bottom of header
  VspPreview.CurrentY := ValPosYEndHdr - (4 * CalcTextHei);
  if VspPreview.CurrentY < ValOrigMarginTop then
    VspPreview.CurrentY := ValOrigMarginTop;
  // Calculate Y-position to start report
  if VspPreview.CurrentY < ValPosYEndHdr then
    VspPreview.CurrentY := ValPosYEndHdr;
end;   // of TFrmVSRptTransPaymentCA.VspPreviewBeforeHeader

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end. // of TFrmVSRptTransPaymentCA

