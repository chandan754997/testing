//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   :
// Unit     : FVSRptCaisseMonnaieCA = Form Video Soft RePorT CAISSE MONNAIE
//            CAstorama
//            Report of transfer responsability by store-managers
//-----------------------------------------------------------------------------
// PVCS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptCaisseMonnaieCA.pas,v 1.1 2006/12/22 13:43:37 smete Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FVSRptCaisseMonnaieCA - CVS revision 1.4
//=============================================================================

unit FVSRptCaisseMonnaieCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfVSPrinter7, ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ExtCtrls, ToolWin, DFpnSafeTransaction, DFpnTradeMatrix,
  Variants;

//-----------------------------------------------------------------------------
resourcestring
  // format report headers

  // transfer responsability
  CtTxtRptTitle               = 'TRANSFER OF RESPONSABILITY OF CASH TENDER';
  CtTxtVisaResponsable1       = 'End of responsability (name + visa)';
  CtTxtVisaResponsable2       = 'Start of responsability (name + visa)';

  // table headers
  CtTxtHdrDescr     = '';
  CtTxtHdrValTheor  = 'Theoretic value';
  CtTxtHdrValReal   = 'Real value';

  CtTxtDate         = 'Date';
  CtTxtTime         = 'Time';

var
  // Margins
  ViValMarginLeft   : Integer =  900; // MarginLeft for VspPreview
  ViValMarginHeader : Integer = 1300; // Adjust MarginTop to leave room for hdr
  ViValHeaderHeight : Integer = 600;  // headerrow height

  // Fontsizes
  ViValFont14       : Integer = 14;   // FontSize for report header
  ViValFont12       : Integer = 12;   // FontSize for in between
  ViValFont10       : Integer = 10;       // Normal FontSize
  ViValFont7        : Integer =  7;       // Small FontSize


  // Positions and white space
  ViValSpaceBetween: Integer =  200;   // White space between tables

var // Column-width (in number of characters)
  ViValRptWidthDescr    : Integer = 50; // Width columns description
  ViValRptWidthValTheor : Integer = 20; // Width column theoretic value
  ViValRptWidthValReal  : Integer = 20; // Width columns real value

var // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables

const  // for the dimensions of the rectangle (Address).
  CtValAddressRecHeight   = 2000;
  CtValAddressRecWidth    = 4000;

const  // for the dimensions of the rectangle (Visa responsable).
  CtValVisaRespRecHeight  = 1500;
  CtValVisaRespRecWidth   = 2500;
  CtValVisaRespWidthSpace = 250;

//-----------------------------------------------------------------------------

type
  TFrmVSRptCaisseMonnaieCA = class(TFrmVSPreview)
    procedure FormCreate(Sender: TObject);
  protected
    { Protected declarations }
    // Properties
    FPreviewReport     : Boolean;          // should report be previewed first.
    FNumEndPageRapport : Integer;          // last pagenumber of report
    FCodRunFunc        : Integer;          // functionality of executable
    FIdtOperReg        : string;           // IdtOperator registrating
    FTxtNameOperReg    : string;           // Name operator registrating
    FStrLstBody        : TStringList;      // list containing the information
                                           // for the report
    FIdtOrderNumber    : Integer;          // BankOrdernumber
    FIdtAddrPayOrg     : Integer;          // Link to address of Pay organization
    FPicLogo           : TImage;           // Logo
    FTxtFNLogo         : string;           // Filename Logo
    ValOrigMarginTop   : Double;           // Original MarginTop
    QtyLinesPrinted    : Integer;          // Linecounter for report
    TxtTableFmt        : string;           // Format for current Table on report
    TxtTableHdr        : string;           // Header for current Table on report
    ArrPages           : array of Integer; // Array of pages to restart counting
    ValSaveCurrentY    : Double;           // Saved value of y-coordinate report
    ValSaveMarginLeft  : Double;           // Original margin left
    IdtCurrency        : string;           // currency of the tendergroup
    FNumRef            : string;           // Report reference number
    // routines only used within the boundary of this report
    function GetNumEndPageRapport : Integer; virtual;
    procedure SetTxtFNLogo (Value : string); virtual;
    function CalcTextHei : Double; virtual;
    function FormatValue (ValFormat : Currency) : string; virtual;
    procedure PrintReportHeader; virtual;
    procedure PrintReportTitle; virtual;
    procedure AddFooterToPages; virtual;
    procedure BuildTableBodyFmtAndHdr; virtual;
    procedure GenerateTableTendergroup; virtual;
    procedure GenerateTableTendergroupBody; virtual;
    procedure ConfigTableBody; virtual;
    procedure PrintEndClause; virtual;
    procedure PrintTableLine (TxtLine : string); virtual;
    procedure PrintRef; virtual;
  public
    { Public declarations }
    // Does the user wishes to view a preview of the report Y/N
    property PreviewReport : Boolean read  FPreviewReport
                                     write FPreviewReport;
    // last page number generated
    property NumEndPageRapport : Integer read GetNumEndPageRapport;
    // filename that holds the logo for the right upper corner of the report
    property TxtFNLogo : string read  FTxtFNLogo
                                write SetTxtFNLogo;
    // object that holds the bitmap of the report-logo
    property PicLogo : TImage read  FPicLogo
                              write FPicLogo;

    procedure DrawLogo (ImgLogo : TImage); override;
    procedure GenerateReport; virtual;

    property NumRef : string read  FNumRef
                             write FNumRef;
  published
    { Published declarations }
    property IdtOperReg : string read  FIdtOperReg
                                 write FIdtOperReg;
    property TxtNameOperReg : string read  FTxtNameOperReg
                                     write FTxtNameOperReg;
    property StrLstBody : TStringList read  FStrLstBody
                                      write FStrLstBody;
  end;

var
  FrmVSRptCaisseMonnaieCA: TFrmVSRptCaisseMonnaieCA;

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,
  DFpnUtils,
  DFpnAddress,
  FFpnTndCaisseMonnaieCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptCaisseMonnaieCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptCaisseMonnaieCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:43:37 $';

//*****************************************************************************
// Implementation of TFrmVSRptCaisseMonnaieCA
//*****************************************************************************

procedure TFrmVSRptCaisseMonnaieCA.FormCreate(Sender: TObject);
begin // of TFrmVSRptCaisseMonnaieCA.FormCreate
  inherited;
  if not Assigned (DmdFpnTradeMatrix) then
    DmdFpnTradeMatrix := TDmdFpnTradeMatrix.Create (Self);
  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Self);
  if not Assigned (DmdFpnAddress) then
    DmdFpnAddress := TDmdFpnAddress.Create (Self);
  // Set defaults
  TxtFNLogo := CtTxtEnvVarStartDir + '\Image\FlexPoint.Report.BMP';

  // Overrule default properties for VspPreview.
  VspPreview.MarginLeft := ViValMarginLeft;

  // Leave room for header
  ValOrigMarginTop      := VspPreview.MarginTop;
  VspPreview.MarginTop  := ValOrigMarginTop + 200;

end;  // of TFrmVSRptCaisseMonnaieCA.FormCreate

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.GetNumEndPageRapport : Fetch last pagenumber of report.
//                                             To be used in the PrintDoc method
//                                             of the maintenance task form
//=============================================================================

function TFrmVSRptCaisseMonnaieCA.GetNumEndPageRapport : Integer;
begin  // of TFrmVSRptCaisseMonnaieCA.GetNumEndPageRapport
  Result := ArrPages [1] - 1;
end;   // of TFrmVSRptCaisseMonnaieCA.GetNumEndPageRapport

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.SetTxtFNLogo: loads the logo file into an image-object
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.SetTxtFNLogo (Value: string);
begin // of TFrmVSRptCaisseMonnaieCA.SetTxtFNLogo
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
end;  // of TFrmVSRptCaisseMonnaieCA.SetTxtFNLogo

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.CalcTextHei : calculates VspPreview.TextHei for a
// single line in the current font.
//                                  -----
// FUNCRES : calculated TextHei.
//=============================================================================

function TFrmVSRptCaisseMonnaieCA.CalcTextHei : Double;
begin  // of TFrmVSRptCaisseMonnaieCA.CalcTextHei
  VspPreview.X1 := 0;
  VspPreview.Y1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y2 := 0;

  VspPreview.CalcParagraph := 'X';
  Result := VspPreview.TextHei;
end;   // of TFrmVSRptCaisseMonnaieCA.CalcTextHei

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.FormatValue : converts value to string for printing
//                                  -----
// INPUT   : ValFormat = value to format.
//                                  -----
// FUNCRES : ValFormat converted to string.
//=============================================================================

function TFrmVSRptCaisseMonnaieCA.FormatValue (ValFormat : Currency) : string;
begin  // of TFrmVSRptCaisseMonnaieCA.FormatValue
  if ValFormat = 0 then
    Result := '-'
  else
    Result := CurrToStrF (ValFormat, ffFixed, DmdFpnUtils.QtyDecsValue);
end;   // of TFrmVSRptCaisseMonnaieCA.FormatValue

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.PrintReportHeader : prints the header information
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.PrintReportHeader;
begin // of TFrmVSRptCaisseMonnaieCA.PrintReportHeader
  DrawLogo (PicLogo);
  PrintReportTitle;
end;  // of TFrmVSRptCaisseMonnaieCA.PrintReportHeader

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.PrintReportTitle
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.PrintReportTitle;
begin  // of TFrmVSRptCaisseMonnaieCA.PrintReportTitle
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.MarginHeader;
  VspPreview.FontSize   := ViValFont14;
  VspPreview.FontUnderline := True;
  VspPreview.Text := CtTxtRptTitle + #13;
  VspPreview.FontSize   := ViValFont12;
  VspPreview.FontUnderline := False;
  VspPreview.Text :=  CtTxtDate + ' : ' + FormatDateTime (CtTxtDatFormat,Now) + #13;
  VspPreview.Text := CtTxtTime + ' : ' + FormatDateTime (CtTxtHouFormat,Now) + #13;
end;   // of TFrmVSRptCaisseMonnaieCA.PrintReportTitle

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.AddFooterToPages
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.AddFooterToPages;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
  NumPage          : Integer;          // PageNumber
  TotPage          : Integer;          // total Pages
  CntArray         : Integer;          // Array counter
begin  // of TFrmVSRptCaisseMonnaieCA.AddFooterToPages
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
      VspPreview.Text := CtTxtPrintDate + ' ' + DateTimeToStr (Now);
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
end;   // of TFrmVSRptCaisseMonnaieCA.AddFooterToPages

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.BuildTableBodyFmtAndHdr : format table to print
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.BuildTableBodyFmtAndHdr;
begin // of TFrmVSRptCaisseMonnaieCA.BuildTableBodyFmtAndHdr
  // set table and header format

  // description
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  // Value theoretic
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignHCenter,
                                  ColumnWidthInTwips (ViValRptWidthValTheor)]);
  // Value real
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignHCenter,
                                  ColumnWidthInTwips (ViValRptWidthValReal)]);

  TxtTableHdr := CtTxtHdrDescr + SepCol + CtTxtHdrValTheor + SepCol +
                 CtTxtHdrValReal;
end;  // of TFrmVSRptCaisseMonnaieCA.BuildTableBodyFmtAndHdr

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.GenerateTableTendergroup
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.GenerateTableTendergroup;
begin // of TFrmVSRptCaisseMonnaieCA.GenerateTableTendergroup
  BuildTableBodyFmtAndHdr;
  VspPreview.CurrentY := VspPreview.MarginTop + 1500;
  VspPreview.StartTable;
  try
    GenerateTableTendergroupBody;
  finally
    VspPreview.EndTable;
  end;
end;  // of TFrmVSRptCaisseMonnaieCA.GenerateTableTendergroup

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.GenerateTableTendergroupBody
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.GenerateTableTendergroupBody;
var
  TxtLine          : string;           // line with detail to print
  CntItem          : Integer;          // counter for LstTransDet
  TxtDescr         : string;           // description of detailline
  TxtVal1          : string;           // Value for theoretic qty of amount
  TxtVal2          : string;           // Value for real qty of amount
  ObjDetailLine    : TRptDetailLine;   // object detailline report
begin // of TFrmVSRptCaisseMonnaieCA.GenerateTableTendergroupBody
  // this is only valid for Euro currency
  if Assigned (StrLstBody) then
    for CntItem := 0 to Pred (StrLstBody.Count) do begin
      if Assigned (StrLstBody.Objects[CntItem]) then begin
        ObjDetailLine := TRptDetailLine(StrLstBody.Objects[CntItem]);
        TxtDescr := '';
        TxtVal1  := '';
        TxtVal2  := '';
        if not ObjDetailLine.FlgShowTitle then begin
          if ObjDetailLine.ObjTenderUnit <> nil then
            TxtDescr := '     ' +
                        FloatToStr (ObjDetailLine.ObjTenderUnit.ValUnit) + ' ' +
                        ObjDetailLine.ObjTendergroup.IdtCurrency
          else
            TxtDescr := ObjDetailLine.ObjTenderGroup.TxtPublDescr;
          if ObjDetailLine.FlgShowCount then begin
            TxtVal1 := IntToStr (Trunc(ObjDetailLine.QtyTheor));
            TxtVal2 := IntToStr (Trunc(ObjDetailLine.QtyReal));
          end
          else begin
            TxtVal1 := FormatFloat('0.00', ObjDetailLine.ValTheor);
            TxtVal2 := FormatFloat('0.00', ObjDetailLine.ValReal);
          end;
        end
        else begin
          TxtDescr := ObjDetailLine.ObjTenderGroup.TxtPublDescr
        end;
        TxtLine := TxtDescr + SepCol +
                   TxtVal1 + SepCol + TxtVal2;
        PrintTableLine (TxtLine);
      end; // if
    end; // for
end;  // of TFrmVSRptCaisseMonnaieCA.GenerateTableTendergroupBody

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.ConfigTableBody : configures the table Cilinders.
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.ConfigTableBody;
var
  QtyRows          : Integer;          // Number of rows in table
  QtyCols          : Integer;          // Number of columns in table
begin  // of TFrmVSRptCaisseMonnaieCA.ConfigTableBody
  // Retrieve number of rows and columns
  QtyRows := VspPreview.TableCell[tcRows, Null, Null, Null, Null];
  QtyCols := VspPreview.TableCell[tcCols, Null, Null, Null, Null];

  // Sets the height of the headerrow of the table
  VspPreview.TableCell[tcRowHeight, 0, 0, Null, Null] := ViValHeaderHeight;
  // Set last line (= total line) bold
  VspPreview.TableCell[tcFontBold, QtyRows, 1, QtyRows, QtyCols] := True;
  // Prevent page break before total-line
  VspPreview.TableCell[tcRowKeepWithNext, QtyRows - 1, 1,
                                          QtyRows - 1, QtyCols] := True;
end;   // of TFrmVSRptCaisseMonnaieCA.ConfigTableBody

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.PrintEndClause: prints the text for pièce comptable,
// the rectangle and text for 'Visa Responsable'.
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.PrintEndClause;
var
  ValLeftRect1     : Integer;          // Left offset of first rectangle
  ValLeftRect2     : Integer;          // Left offset of second rectangle
  ValAdditionLeft  : Integer;          // Additional movement to the left
  ValAdditionTop   : Integer;          // Additional movement to the top
begin  // of TFrmVSRptCaisseMonnaieCA.PrintEndClause
  ValAdditionLeft := 250;
  ValAdditionTop := 250;
  ValLeftRect1 := VspPreview.PageWidth - VspPreview.MarginRight -
                  (2 * CtValVisaRespRecWidth) - CtValVisaRespWidthSpace -
                  ValAdditionLeft;
  ValLeftRect2 := VspPreview.PageWidth - VspPreview.MarginRight -
                     CtValVisaRespRecWidth - ValAdditionLeft;

  VspPreview.BrushStyle := bsTransparent;
  // Print two rectangles for holding the 'responsables'
  VspPreview.DrawRectangle (ValLeftRect1, VspPreview.PageHeight -
                            VspPreview.MarginBottom - CtValVisaRespRecHeight -
                            ValAdditionTop,
                            ValLeftRect1 + CtValVisaRespRecWidth,
                            VspPreview.PageHeight - VspPreview.MarginBottom -
                            ValAdditionTop,
                            0, 0);
  ViValMarginLeft := ValLeftRect2;
  VspPreview.DrawRectangle (ValLeftRect2, VspPreview.PageHeight -
                            VspPreview.MarginBottom - CtValVisaRespRecHeight -
                            ValAdditionTop,
                            ValLeftRect2 + CtValVisaRespRecWidth,
                            VspPreview.PageHeight - VspPreview.MarginBottom -
                            ValAdditionTop,
                            0, 0);
  VspPreview.FontSize := ViValFont7;

  // text for rectangle 1
  VspPreview.CurrentX := ValLeftRect1;
  VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom -
                         CtValVisaRespRecHeight - 250 - ValAdditionTop;
  VspPreview.Text := CtTxtVisaResponsable1;

  // text for rectangle 2
  VspPreview.CurrentX := ValLeftRect2;
  VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom -
                         CtValVisaRespRecHeight - 250 - ValAdditionTop;
  VspPreview.Text := CtTxtVisaResponsable2;

  VspPreview.FontSize := ViValFont10;
end;   // of TFrmVSRptCaisseMonnaieCA.PrintEndClause

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.PrintTableLine : adds the line to the current Table.
//                                  -----
// INPUT   : TxtLine = line to add to the Table.
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.PrintTableLine (TxtLine : string);
begin  // of TFrmVSRptCaisseMonnaieCA.PrintTableLine
  VspPreview.AddTable (TxtTableFmt, TxtTableHdr, TxtLine,
                       ViColHeader, ViColBody, null);
  Inc (QtyLinesPrinted);                       
end;   // of TFrmVSRptCaisseMonnaieCA.PrintTableLine

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.PrintRef : Prints the reference
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.PrintRef;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSRptCaisseMonnaieCA.PrintRef
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, True);
      CurrentX := PageWidth - MarginRight - TextWidth [NumRef] - 1;
      CurrentY := PageHeight - MarginBottom + TextHeight ['X'] - 250;
      Text := NumRef;
      EndOverlay;
    end;
  end;
end;   // of TFrmVSRptCaisseMonnaieCA.PrintRef

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.DrawLogo
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptCaisseMonnaieCA.DrawLogo
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
end;   // of TFrmVSRptCaisseMonnaieCA.DrawLogo

//=============================================================================
// TFrmVSRptCaisseMonnaieCA.GenerateReport : Main routine for printing the report
//=============================================================================

procedure TFrmVSRptCaisseMonnaieCA.GenerateReport;
begin // of TFrmVSRptCaisseMonnaieCA.GenerateReport
  Visible := True;
  Visible := False;

  SetLength (ArrPages, 1);
  ArrPages [Length (ArrPages) - 1] := 1;

  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;

  try
    PrintReportHeader;

    GenerateTableTendergroup;
    PrintEndClause;

    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
  finally
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
  PrintRef;

  if PreviewReport then
    FrmVSRptCaisseMonnaieCA.ShowModal;
end;  // of TFrmVSRptCaisseMonnaieCA.GenerateReport

//*****************************************************************************

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
