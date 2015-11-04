//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : Flexpoint
// Customer : Castorama
// Unit     : FVSRptTndCntSafeCA = Form VideoSoft RePorT TeNDer CouNT SAFE
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndCntSafeCA.pas,v 1.1 2006/12/22 13:57:24 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FVSRptTndCntSafeCA - CVS revision 1.2
// Version               Modified By          Reason
// 1.2                   PM (TCS)             R2011.2 - BDFR - Safetybox Traceability
// 1.3                   MD (TCS)             R2011.2 - CAFR - Bug 17 : Added
// 1.4                   SC (TCS)             R2011.2 - CAFR - Defect Fix-252
// 1.5                   SC. (TCS)            R2012.1--CAFR-suppression mention cheque kdo
//=============================================================================

unit FVSRptTndCntSafeCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ToolWin, ExtCtrls, SfVSPrinter7,
  FMntTndCntSafeCA; // **** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR ****

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Codes to identify the different types of lines to print
//=============================================================================

const
  CtCodPrnMoney         = 1;           // Info on the money in the safe
  CtCodPrnTotMoney      = 2;           // Print Total of money in safe
  CtCodPrnSealedBags    = 3;           // Quantity sealed bags in the safe
  CtCodPrnCollBags      = 4;           // Sealed collection bags in the safe
  CtCodPrnGCStarted     = 5;           // Started book gift coupons
  CtCodPrnGCNotStarted  = 6;           // Not started book gift coupons
  CtCodPrnKeys          = 7;           // Number of the bags with the keys
  CtCodPrnForCurr       = 8;           // Info on the foreign currencies in safe
  CtCodPrnTransKey      = 9;           // Transfer of the key

//=============================================================================
// Settings for the report
//=============================================================================

var    // Margins
  ViValMarginLeft  : Integer =  900;   // MarginLeft for VspPreview
  ViValMarginHeader: Integer = 1700;   // Adjust MarginTop to leave room for hdr

var    // Fontsizes
  ViValFontHeader  : Integer = 16;     // FontSize header
  ViValFontSubTitle: Integer = 11;     // FontSize SubTitle
  ViValFontSign    : Integer = 6;      // Fontsize signature-text

var    // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables

var    // Positions and white space
  ViValSpaceBetweenLines     : Integer = 75;     // White space between lines
  ViValSpaceBetweenDetLines  : Integer = 50;     // White space between detail

var    // Column-width (in number of characters)
  ViValWidthDate        : Integer = 10;          // Width of the date (header)
  ViValWidthDescr       : Integer = 50;          // Width of descr normal line
  ViValWidthValues      : Integer = 15;          // Width of values
  ViValWidthSpace       : Integer = 10;          // Space betwee two collumns
  ViValWidthInPause     : Integer = 30;          // Width descr 'in pause'
  ViValWidthExtraInf    : Integer = 10;          // Width Extra info
  ViValWidthTransKeys   : Integer = 10;          // Width of Transfer keys
  ViValWidthTransKDescr : Integer = 15;          // Width of transfer key text

var    // Dimensions for the 'signature'-rectangles
  ViValSignatureRecHeight    : Integer = 1000;   // Heigth rectangle signature
  ViValSignatureRecWidth     : Integer = 2000;   // Width rectangle signature

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring  // Text for the header
  CtTxtTitleCntSafe     ='Contradictory transfer of responsability of the safe';
  CtTxtHdrDate          = 'Date:';
  CtTxtHdrTime          = 'Time:';

resourcestring  // Text for the subtitle
  CtTxtValTheor         = 'Theoretical Values';
  CtTxtValInvent        = 'Inventorised Values';

resourcestring  // For the 'Bags in pause'
  CtTxtQtyCaishierPause = 'Caishiers in pause';
  CtTxtQtyLockers       = 'or number of lockers';

resourcestring  // For 'Divers'
  CtTxtDescrDivers      = 'Divers';

resourcestring  // For the signatures
  CtTxtSignEndResp      = 'End of responsability (name + visa)';
  CtTxtSignBegResp      = 'Beginning of responsability (name + visa)';

// **** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start ****
resourcestring //For Operator Info
  CtTxtOperatorInfo     = 'Checks by : ';
// **** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - End ****

//*****************************************************************************
// TObjCntSafe : object that will be used to define the lines to print
//*****************************************************************************

type
  TObjCntSafe = class
  private
    FCodLine       : Byte;              // Code to the identify the line
    FTxtDescr      : string;            // Description
    FTxtExtraInfo  : string;            // Extra info (eg kind of foreign curr)
    FTxtValTheor   : string;            // Theoretical value
    FTxtValInvent  : string;            // Inventory value
  public
    property CodLine : Byte read FCodLine
                            write FCodLine;
    property TxtDescr : string read FTxtDescr
                               write FTxtDescr;
    property TxtExtraInfo : string read FTxtExtraInfo
                                   write FTxtExtraInfo;
    property TxtValTheor : string read FTxtValTheor
                                  write FTxtValTheor;
    property TxtValInvent : string read FTxtValInvent
                                   write FTxtValInvent;
  end;

//*****************************************************************************
// TFrmVSRptTndCntSafeCA
//*****************************************************************************

type
  TFrmVSRptTndCntSafeCA = class(TFrmVSPreview)
    procedure VspPreviewBeforeHeader(Sender: TObject);
  private
  protected
    FTxtFNLogo          : string;      // Filename Logo
    FPicLogo            : TImage;      // Logo
    FLstCntSafe         : TList;       // List of lines to print
    ValOrigMarginTop    : Double;      // Original MarginTop
    ValWidthSpace       : Integer;     // Width for space
    TxtTableFmt         : string;      // Format for current Table on report
    procedure SetTxtFNLogo (Value : string); virtual;
    // Virtual methods
    function CalcTextHei : Double; virtual;
    procedure BuildFmtNormalLine; virtual;
    procedure BuildFmtExtraLine; virtual;
    procedure BuildFmtBagsInPauseLine; virtual;
    procedure BuildFmtTransKeysLine; virtual;
    procedure BuildFmtTotalLine; virtual;
    procedure PrintDateTime; virtual;
    procedure PrintSubTitle; virtual;
    procedure PrintPageHeader; virtual;
    procedure PrintBagsInPause; virtual;
    procedure PrintTotalLine (ObjCntSafe : TObjCntSafe); virtual;
    procedure PrintNormalLine (ObjCntSafe : TObjCntSafe;
                              CodKind : Byte); virtual;
    procedure PrintExtraLine (ObjCntSafe : TObjCntSafe); virtual;
    procedure PrintTransKeysLine (ObjCntSafe : TObjCntSafe); virtual;
    procedure PrintItemsList (CodKind : Byte); virtual;
    procedure PrintDivers; virtual;
    procedure PrintRectSignature; virtual;
    procedure PrintDetail; virtual;
    procedure PrintOperatorInfo; virtual;
  public
    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
    // Overriden methods
    procedure DrawLogo (ImgLogo : TImage); override;

    // Virtual methods
    procedure GenerateReport; virtual;
    // Print references
    procedure PrintReferences; virtual;

    // Properties
    property TxtFNLogo : string read  FTxtFNLogo
                                write SetTxtFNLogo;
    property PicLogo : TImage read  FPicLogo
                              write FPicLogo;
  published
    property LstCntSafe : TList read FLstCntSafe
                                write FLstCntSafe;
  end;

var
  FrmVSRptTndCntSafeCA: TFrmVSRptTndCntSafeCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  StStrW,

  SfDialog,
  SmUtils,

  DFpnUtils,
  FTndRegCountSafeCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptTndCntSafeCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndCntSafeCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2011/12/21 17:45:24 $';

//*****************************************************************************
// Implementation of TFrmVSRptTndCntSafeCA
//*****************************************************************************

//=============================================================================
// TFrmVSRptTndCntSafeCA - Constructor / Destructor
//=============================================================================

constructor TFrmVSRptTndCntSafeCA.Create (AOwner : TComponent);
begin  // of TFrmVSRptTndCntSafeCA.Create
  inherited;
  // Set defaults
  TxtFNLogo := CtTxtEnvVarStartDir + '\Image\FlexPoint.Report.BMP';

  // Overrule default properties for VspPreview.
  VspPreview.Orientation := orLandscape;
  VspPreview.MarginLeft := ViValMarginLeft;

  // Leave room for header
  ValOrigMarginTop      := VspPreview.MarginTop;
  VspPreview.MarginTop  := ValOrigMarginTop + ViValMarginHeader;

  // Sets an empty header to make sure OnBeforeHeader is fired.
  VspPreview.Header := ' ';
end;   // of TFrmVSRptTndCntSafeCA.Create

//=============================================================================

destructor TFrmVSRptTndCntSafeCA.Destroy;
begin  // of TFrmVSRptTndCntSafeCA.Destroy
  FPicLogo.Free;

  inherited;
end;   // of TFrmVSRptTndCntSafeCA.Destroy

//=============================================================================
// TFrmVSRptTndCntSafeCA - Methods to read/write properties
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.SetTxtFNLogo (Value : string);
begin  // of TFrmVSRptTndCntSafeCA.SetTxtFNLogo
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
end;   // of TFrmVSRptTndCntSafeCA.SetTxtFNLogo

//=============================================================================
// TFrmVSRptTndCntSafeCA - Protected methods
//=============================================================================

//=============================================================================
// TFrmVSRptTndCntSafeCA.CalcTextHei: calculates VspPreview.TextHei for a single
// line in the current font.
//                                  -----
// FUNCRES : calculated TextHei.
//=============================================================================

function TFrmVSRptTndCntSafeCA.CalcTextHei : Double;
begin  // of TFrmVSRptTndCntSafeCA.CalcTextHei
  VspPreview.X1 := 0;
  VspPreview.Y1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y2 := 0;

  VspPreview.CalcParagraph := 'X';
  Result := VspPreview.TextHei;
end;   // of TFrmVSRptTndCntSafeCA.CalcTextHei

//=============================================================================
// TFrmVSRptTndCntSafeCA.BuildFmtNormalLine : construct the format for a normal
// line on the report.
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.BuildFmtNormalLine;
begin  // of TFrmVSRptTndCntSafeCA.BuildFmtNormalLine
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValWidthDescr)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (CharStrW('X',
                                                      ViValWidthValues))]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValWidthSpace)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (CharStrW('X',
                                                      ViValWidthValues))]);
end;   // of TFrmVSRptTndCntSafeCA.BuildFmtNormalLine

//=============================================================================
// TFrmVSRptTndCntSafeCA.BuildFmtExtraLine : construct the format for an extra
// line on the report.
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.BuildFmtExtraLine;
begin  // of TFrmVSRptTndCntSafeCA.BuildFmtExtraLine
  ValWidthSpace :=
    (ColumnWidthInTwips (ViValWidthDescr) -
     ColumnWidthInTwips (ViValWidthInPause) -
     ColumnWidthInTwips (ViValWidthExtraInf)) div 2;
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValWidthInPause)]) +
                 SepCol + IntToStr (ValWidthSpace) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValWidthExtraInf)]) +
                 SepCol + IntToStr (ValWidthSpace) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (CharStrW('X',
                                                      ViValWidthValues))]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValWidthSpace)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (CharStrW('X',
                                                      ViValWidthValues))]);
end;   // of TFrmVSRptTndCntSafeCA.BuildFmtExtraLine

//=============================================================================
// TFrmVSRptTndCntSafeCA.BuildFmtBagsInPauseLine : construct the format for a
// 'Bags in pause' line on the report.
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.BuildFmtBagsInPauseLine;
begin  // of TFrmVSRptTndCntSafeCA.BuildFmtBagsInPauseLine
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValWidthInPause)]) +
                 SepCol;
end;   // of TFrmVSRptTndCntSafeCA.BuildFmtBagsInPauseLine

//=============================================================================
// TFrmVSRptTndCntSafeCA.BuildFmtTransKeysLine : construct the format for a
// 'Transfer keys' line on the report.
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.BuildFmtTransKeysLine;
begin  // of TFrmVSRptTndCntSafeCA.BuildFmtTransKeysLine
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValWidthTransKDescr)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignHCenter,
                                  ColumnWidthInTwips (CharStrW('X',
                                                      ViValWidthTransKeys))]);
end;   // of TFrmVSRptTndCntSafeCA.BuildFmtTransKeysLine

//=============================================================================
// TFrmVSRptTndCntSafeCA.BuildFmtTotalLine : construct the format for a
// total-line on the report.
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.BuildFmtTotalLine;
begin  // of TFrmVSRptTndCntSafeCA.BuildFmtTotalLine
  TxtTableFmt := Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValWidthDescr)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (CharStrW('X',
                                                      ViValWidthValues))]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValWidthSpace)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (CharStrW('X',
                                                      ViValWidthValues))]);
end;   // of TFrmVSRptTndCntSafeCA.BuildFmtTotalLine

// **** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start ****
//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintOperatorInfo : prints Operator Info
//=============================================================================
procedure TFrmVSRptTndCntSafeCA.PrintOperatorInfo;
begin
     VspPreview.CurrentX := VspPreview.MarginLeft;
     VspPreview.FontBold := True;
      try

        VspPreview.Text := CtTxtOperatorInfo +
                            FMntTndCntSafeCA.FrmMntTndCntSafeCA.IdtOperator + ' ' +
                            FMntTndCntSafeCA.FrmMntTndCntSafeCA.OperatorTxtName;

      finally
        VspPreview.FontUnderline := False;
        VspPreview.FontBold := False;
      end;
      VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei +
                         ViValSpaceBetweenLines;
end;

// **** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - End ****

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintDateTime : prints date and time
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintDateTime;
begin  // of TFrmVSRptTndCntSafeCA.PrintDateTime
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValWidthDate)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (CharStrW('0',
                                                      ViValWidthDate))]);
  VspPreview.TableBorder := tbNone;
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.StartTable;
  VspPreview.AddTable (TxtTableFmt, '', CtTxtHdrDate + SepCol + DateToStr (Now),
                       0, 0, False);
  VspPreview.DrawRectangle (VspPreview.CurrentX +
                            ColumnWidthInTwips (ViValWidthDate),
                            VspPreview.CurrentY,
                            VspPreview.CurrentX +
                            ColumnWidthInTwips (ViValWidthDate) +
                            ColumnWidthInTwips(CharStrW('0',ViValWidthDate)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  VspPreview.EndTable;
  VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei +
                         ViValSpaceBetweenLines;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.StartTable;
  VspPreview.AddTable (TxtTableFmt, '', CtTxtHdrTime + SepCol + TimeToStr (Now),
                       0, 0, False);
  VspPreview.DrawRectangle (VspPreview.CurrentX +
                            ColumnWidthInTwips (ViValWidthDate),
                            VspPreview.CurrentY,
                            VspPreview.CurrentX +
                            ColumnWidthInTwips (ViValWidthDate) +
                            ColumnWidthInTwips (CharStrW('0', ViValWidthDate)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  VspPreview.EndTable;
end;   // of TFrmVSRptTndCntSafeCA.PrintDateTime

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintDateTime : prints date and time
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintSubTitle;
begin  // of TFrmVSRptTndCntSafeCA.PrintSubTitle
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.FontUnderline := True;
  VspPreview.FontBold := True;
  try
    VspPreview.CurrentX := VspPreview.CurrentX +
                           ColumnWidthInTwips (ViValWidthDescr);
    VspPreview.Text := CtTxtValTheor;
    VspPreview.CurrentX := VspPreview.MarginLeft +
                           ColumnWidthInTwips (ViValWidthDescr) +
                           ColumnWidthInTwips (ViValWidthValues) +
                           ColumnWidthInTwips (ViValWidthSpace);
    VspPreview.Text := CtTxtValInvent;
  finally
    VspPreview.FontUnderline := False;
    VspPreview.FontBold := False;
  end;
  VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei +
                         ViValSpaceBetweenLines;
end;   // of TFrmVSRptTndCntSafeCA.PrintSubTitle

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintPageHeader : prints the header of the report.
//                                  -----
// Restrictions :
// - is called from VspPreview.OnBeforeHeader; provided as virtual method to
//   improve inheritance.
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintPageHeader;
var
  ViValFontSave  : Variant;            // Save original FontSize
begin  // of TFrmVSRptTndCntSafeCA.PrintPageHeader
  ViValFontSave := VspPreview.FontSize;
  try
    // Header report count
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.CurrentY := ValOrigMarginTop;
    VspPreview.FontSize := ViValFontHeader;
    VspPreview.FontBold := True;
    VspPreview.FontUnderline := True;
    VspPreview.Text := CtTxtTitleCntSafe;

    VspPreview.FontUnderline := False;
    VspPreview.FontSize := ViValFontSubTitle;
    VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHei * 2);

    // **** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start ****
    if FMntTndCntSafeCA.FrmMntTndCntSafeCA.FlgLoginRequired = True then begin
      PrintOperatorInfo;  //Operator Information
    end;
    // **** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - End ****
    // Header date-time registration
    PrintDateTime;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    VspPreview.CurrentX := VspPreview.MarginLeft;

    VspPreview.Fontsize := ViValFontSave;
    BuildFmtNormalLine;
//SVE    PrintSubTitle;
//SVE    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei +
//SVE                           ViValSpaceBetweenLines;
    VspPreview.CurrentX := VspPreview.MarginLeft;
  finally
    VspPreview.Fontsize := ViValFontSave;
    VspPreview.FontBold := False;
  end;
end;   // of TFrmVSRptTndCntSafeCA.PrintPageHeader

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintBagsInPause : print two lines on the report.
// These lines have reserved space where something can be filled in manually.
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintBagsInPause;
var
  ValWidthCell     : Integer;          // Width of one cell to print
  ValPosX          : Integer;          // X-position to draw the rectangle
  CntIx            : Byte;             // Counter to print rectangles
begin  // of TFrmVSRptTndCntSafeCA.PrintBagsInPause
  BuildFmtBagsInPauseLine;
  VspPreview.TableBorder := tbNone;
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  ValWidthCell := (ColumnWidthInTwips (ViValWidthDescr) +
                   ColumnWidthInTwips (CharStrW('X',ViValWidthValues)) -
                   ColumnWidthInTwips (ViValWidthInPause)) div 6;
  ValPosX := VspPreview.CurrentX + ColumnWidthInTwips (ViValWidthInPause);
  // Print first line
  VspPreview.StartTable;
  VspPreview.AddTable (TxtTableFmt, '', CtTxtQtyCaishierPause + SepCol, 0, 0,
                       False);
  for CntIx := 1 to 6 do
    VspPreview.DrawRectangle (ValPosX + ((CntIx - 1) * ValWidthCell),
                              VspPreview.CurrentY,
                              ValPosX + (CntIx * ValWidthCell),
                              VspPreview.CurrentY  + CalcTextHei, 0, 0);
  ValPosX := VspPreview.MarginLeft + ColumnWidthInTwips (ViValWidthDescr) +
             ColumnWidthInTwips (CharStrW('X',ViValWidthValues)) +
             ColumnWidthInTwips (ViValWidthSpace);
  for CntIx := 1 to 6 do
    VspPreview.DrawRectangle (ValPosX + ((CntIx - 1) * ValWidthCell),
                              VspPreview.CurrentY,
                              ValPosX + (CntIx * ValWidthCell),
                              VspPreview.CurrentY  + CalcTextHei, 0, 0);
  VspPreview.EndTable;
  // Print second line
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetweenDetLines;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.StartTable;
  VspPreview.AddTable (TxtTableFmt, '', CtTxtQtyLockers + SepCol, 0, 0, False);
  ValPosX := VspPreview.MarginLeft + ColumnWidthInTwips (ViValWidthInPause);
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX + ValWidthCell,
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  ValPosX := VspPreview.MarginLeft + ColumnWidthInTwips (ViValWidthDescr) +
             ColumnWidthInTwips (CharStrW('X',ViValWidthValues)) +
             ColumnWidthInTwips (ViValWidthSpace);
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX + ValWidthCell,
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);

  VspPreview.EndTable;
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetweenDetLines;
end;   // of TFrmVSRptTndCntSafeCA.PrintBagsInPause

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintTotalLine : prints a total line
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintTotalLine (ObjCntSafe : TObjCntSafe);
var
  TxtLine          : string;           // Line to print
  ValPosX          : Integer;          // X-position to draw the rectangle
begin  // of TFrmVSRptTndCntSafeCA.PrintTotalLine
  BuildFmtTotalLine;
  VspPreview.TableBorder := tbNone;
  VspPreview.BrushStyle := bsSolid;
  VspPreview.BrushColor := clLtGray;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.StartTable;
  TxtLine := ObjCntSafe.TxtDescr + SepCol + ObjCntSafe.TxtValTheor +
             SepCol + SepCol + ObjCntSafe.TxtValInvent;
  VspPreview.AddTable (TxtTableFmt, '', TxtLine, 0, 0, False);
  VspPreview.TableCell[tcFontBold, 1, 1, 1, 1] := True;
  VspPreview.TableCell[tcFontUnderline, 1, 1, 1, 1] := True;
  ValPosX := VspPreview.CurrentX + ColumnWidthInTwips (ViValWidthDescr);
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (CharStrW('X',ViValWidthValues)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  ValPosX := ValPosX + ColumnWidthInTwips (CharStrW('X',ViValWidthValues)) +
             ColumnWidthInTwips (ViValWidthSpace);
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (CharStrW('X',ViValWidthValues)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  VspPreview.EndTable;
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetweenDetLines;
  VspPreview.CurrentX := VspPreview.MarginLeft;
end;   // of TFrmVSRptTndCntSafeCA.PrintTotalLine

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintNormalLine : prints a normal line
//                                  -----
// INPUT : ObjCntSafe  -  Instance to print
//         CodKind - Kind of the item to print
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintNormalLine (ObjCntSafe : TObjCntSafe;
                                                CodKind : Byte);
var
  TxtLine          : string;           // Line to print
  ValPosX          : Integer;          // X-position to draw the rectangle
begin  // of TFrmVSRptTndCntSafeCA.PrintNormalLine
  BuildFmtNormalLine;
  VspPreview.TableBorder := tbNone;
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.StartTable;
  If CodKind = CtCodPrnCollBags then begin
    if ObjCntSafe.TxtValTheor = ObjCntSafe.TxtValInvent then
      TxtLine := ObjCntSafe.TxtDescr + SepCol + ObjCntSafe.TxtValTheor +
                 SepCol + SepCol + CtTxtTransferKeysOK
    else
      TxtLine := ObjCntSafe.TxtDescr + SepCol + ObjCntSafe.TxtValTheor +
                 SepCol + SepCol + CtTxtTransferKeysNOK;
  end
  //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)--start
  else begin
   if FrmMntTndCntSafeCA.FlgRemoveChequeKDO and (ObjCntSafe.TxtDescr = 'Pocketbooks gift coupons not started') then
    TxtLine := CtTxtOthers + SepCol + ObjCntSafe.TxtValTheor +
               SepCol + SepCol + ObjCntSafe.TxtValInvent
   //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)--end
   else
    TxtLine := ObjCntSafe.TxtDescr + SepCol + ObjCntSafe.TxtValTheor +
               SepCol + SepCol + ObjCntSafe.TxtValInvent;
  end;            //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)


  
  VspPreview.AddTable (TxtTableFmt, '', TxtLine, 0, 0, False);
  If CodKind = CtCodPrnSealedBags then begin
    if (ObjCntSafe.TxtValTheor <> ObjCntSafe.TxtValInvent) and
    (Length(Trim(ObjCntSafe.TxtValTheor)) < 3) then
      VspPreview.TableCell[tcFontBold, 1, 2, 1, 4] := True;
  end;
  ValPosX := VspPreview.CurrentX + ColumnWidthInTwips (ViValWidthDescr);
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (CharStrW('X',ViValWidthValues)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  ValPosX := ValPosX + ColumnWidthInTwips (CharStrW('X',ViValWidthValues)) +
             ColumnWidthInTwips (ViValWidthSpace);

  VspPreview.Text :='  '; // R2011.2 TCS(Mohan) Bug 17 : Added
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (CharStrW('X',ViValWidthValues)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  VspPreview.EndTable;
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetweenDetLines;
  VspPreview.CurrentX := VspPreview.MarginLeft;
end;   // of TFrmVSRptTndCntSafeCA.PrintNormalLine

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintExtraLine : prints a line containing 'extra info'
//                                  -----
// INPUT : ObjCntSafe  -  Instance to print
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintExtraLine (ObjCntSafe : TObjCntSafe);
var
  TxtLine          : string;           // Line to print
  ValPosX          : Integer;          // X-position to draw the rectangle
begin  // of TFrmVSRptTndCntSafeCA.PrintExtraLine
  BuildFmtExtraLine;
  VspPreview.TableBorder := tbNone;
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.StartTable;
  TxtLine := ObjCntSafe.TxtDescr + SepCol + SepCol + ObjCntSafe.TxtExtraInfo +
             SepCol + SepCol + ObjCntSafe.TxtValTheor +
             SepCol + SepCol + ObjCntSafe.TxtValInvent;
  VspPreview.AddTable (TxtTableFmt, '', TxtLine, 0, 0, False);
  ValPosX := VspPreview.CurrentX + ColumnWidthInTwips (ViValWidthInPause) +
             ValWidthSpace;
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (ViValWidthExtraInf),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  ValPosX := ValPosX + ColumnWidthInTwips (ViValWidthExtraInf) + ValWidthSpace;
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (CharStrW('X',ViValWidthValues)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  ValPosX := ValPosX + ColumnWidthInTwips (CharStrW('X',ViValWidthValues)) +
             ColumnWidthInTwips (ViValWidthSpace);
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (CharStrW('X',ViValWidthValues)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  VspPreview.EndTable;
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetweenDetLines;
  VspPreview.CurrentX := VspPreview.MarginLeft;
end;   // of TFrmVSRptTndCntSafeCA.PrintExtraLine

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintExtraLine : prints a line containing for transfer
// key.
//                                  -----
// INPUT : ObjCntSafe  -  Instance to print
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintTransKeysLine (ObjCntSafe : TObjCntSafe);
var
  TxtLine          : string;           // Line to print
  ValPosX          : Integer;          // X-position to draw the rectangle
begin  // of TFrmVSRptTndCntSafeCA.PrintTransKeysLine
  BuildFmtTransKeysLine;
  VspPreview.TableBorder := tbNone;
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.StartTable;
  TxtLine := ObjCntSafe.TxtDescr + SepCol + ObjCntSafe.TxtExtraInfo;
  VspPreview.AddTable (TxtTableFmt, '', TxtLine, 0, 0, False);
  ValPosX := VspPreview.CurrentX + ColumnWidthInTwips (ViValWidthTransKDescr);
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (CharStrW('X',
                                                ViValWidthTransKeys)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  VspPreview.EndTable;
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetweenDetLines;
  VspPreview.CurrentX := VspPreview.MarginLeft;
end;   // of TFrmVSRptTndCntSafeCA.PrintTransKeysLine

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintItemsList : prints all the items of a given kind.
//                                  -----
// INPUT : CodKind - Kind of the item to print
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintItemsList (CodKind : Byte);
var
  CntIx            : Byte;             // Counter
begin  // of TFrmVSRptTndCntSafeCA.PrintItemsList
  for CntIx := 0 to Pred (LstCntSafe.Count) do begin
    if TObjCntSafe (LstCntSafe[CntIx]).CodLine = CodKind then begin
      case CodKind of
        CtCodPrnTotMoney : PrintTotalLine (TObjCntSafe (LstCntSafe[CntIx]));
        CtCodPrnGCStarted, CtCodPrnForCurr :
          PrintExtraLine (TObjCntSafe (LstCntSafe[CntIx]));
        CtCodPrnTransKey : PrintTransKeysLine (TObjCntSafe (LstCntSafe[CntIx]));
        else
          PrintNormalLine (TObjCntSafe (LstCntSafe[CntIx]), CodKind);
      end;
    end;
  end;
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetweenLines;
end;   // of TFrmVSRptTndCntSafeCA.PrintItemsList

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintDivers : print the 'Divers'-line
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintDivers;
var
  TxtLine          : string;           // Line to print
  ValPosX          : Integer;          // X-position to draw the rectangle
begin  // of TFrmVSRptTndCntSafeCA.PrintDivers
  BuildFmtNormalLine;
  VspPreview.TableBorder := tbNone;
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.StartTable;
  TxtLine := CtTxtDescrDivers + SepCol + SepCol + SepCol;
  VspPreview.AddTable (TxtTableFmt, '', TxtLine, 0, 0, False);
  ValPosX := VspPreview.CurrentX + ColumnWidthInTwips (ViValWidthDescr);
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (CharStrW('X',ViValWidthValues)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  ValPosX := ValPosX + ColumnWidthInTwips (CharStrW('X',ViValWidthValues)) +
             ColumnWidthInTwips (ViValWidthSpace);
  VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY,
                            ValPosX +
                            ColumnWidthInTwips (CharStrW('X',ViValWidthValues)),
                            VspPreview.CurrentY  + CalcTextHei, 0, 0);
  VspPreview.EndTable;
  VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei +
                         ViValSpaceBetweenDetLines;
  VspPreview.CurrentX := VspPreview.MarginLeft;
end;   // of TFrmVSRptTndCntSafeCA.PrintDivers

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintRectSignature : prints two rectangles reservered
// for the signatures.
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintRectSignature;
var
  ValPosX          : Integer;          // X-position to draw the rectangle
var
  ViValFontSave  : Variant;            // Save original FontSize
begin  // of TFrmVSRptTndCntSafeCA.PrintRectSignature
  ViValFontSave := VspPreview.FontSize;
  try
    VspPreview.TableBorder := tbNone;
    VspPreview.BrushStyle := bsTransparent;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    ValPosX := VspPreview.CurrentX +
               ColumnWidthInTwips (CharStrW('X',ViValWidthDescr)) +
               ColumnWidthInTwips (CharStrW('X',ViValWidthValues)) +
               ColumnWidthInTwips (ViValWidthSpace);
    VspPreview.CurrentX := ValPosX;
    VspPreview.FontSize := ViValFontSign;
    VspPreview.Text := CtTxtSignEndResp;
    VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY + CalcTextHei,
                              ValPosX + ViValSignatureRecWidth,
                              VspPreview.CurrentY  + CalcTextHei +
                              ViValSignatureRecHeight, 0, 0);
    ValPosX := ValPosX + ViValSignatureRecWidth + 250;
    VspPreview.CurrentX := ValPosX;
    VspPreview.Text := CtTxtSignBegResp;
    VspPreview.DrawRectangle (ValPosX, VspPreview.CurrentY + CalcTextHei,
                              ValPosX + ViValSignatureRecWidth,
                              VspPreview.CurrentY + CalcTextHei +
                              ViValSignatureRecHeight, 0, 0);
    VspPreview.CurrentY := VspPreview.CurrentY + ViValSignatureRecHeight +
                           ViValSpaceBetweenDetLines;
    VspPreview.CurrentX := VspPreview.MarginLeft;
  finally
    VspPreview.FontSize := ViValFontSave;
  end;
end;   // of TFrmVSRptTndCntSafeCA.PrintRectSignature

//=============================================================================
// TFrmVSRptTndCntSafeCA.PrintDetail : prints the detail of the report
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintDetail;
begin  // of TFrmVSRptTndCntSafeCA.PrintDetail
  PrintSubTitle;
  PrintItemsList (CtCodPrnMoney);
  PrintItemsList (CtCodPrnTotMoney);
  PrintBagsInPause;
  PrintItemsList (CtCodPrnSealedBags);
  PrintItemsList (CtCodPrnCollBags);
  PrintItemsList (CtCodPrnGCStarted);
  PrintItemsList (CtCodPrnGCNotStarted);
  PrintItemsList (CtCodPrnKeys);
  PrintItemsList (CtCodPrnForCurr);
  PrintDivers;
  PrintItemsList (CtCodPrnTransKey);
  PrintRectSignature;
end;   // of TFrmVSRptTndCntSafeCA.PrintDetail

//=============================================================================
// TFrmVSRptTndCntSafeCA - Public methods
//=============================================================================

procedure TFrmVSRptTndCntSafeCA.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptTndCntSafeCA.DrawLogo
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
end;   // of TFrmVSRptTndCntSafeCA.DrawLogo

//=============================================================================

procedure TFrmVSRptTndCntSafeCA.GenerateReport;
begin  // of TFrmVSRptTndCntSafeCA.GenerateReport
  inherited;
  Visible := True;
  Visible := False;

  VspPreview.StartDoc;
  try
    PrintDetail;
  finally
    VspPreview.EndDoc;
    try // // R2011.2 TCS(Mohan) Bug 17 : Added Try Except block
      PrintReferences;
    except
       { }
    end;
  end;
end;   // of TFrmVSRptTndCntSafeCA.GenerateReport

//=============================================================================

procedure TFrmVSRptTndCntSafeCA.PrintReferences;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSRptTndCntSafeCA.PrintReferences
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, TRUE);
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1000;
      CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom + 50;
      Text := 'REP0021';
      //commented for Defect Fix-252(SC) //FontSize := VspPreview.FontSize - 5;
      FontSize := 3;  //Defect Fix-252(SC)
      EndOverlay;
    end;
  end;
end;   // of TFrmVSRptTndCntSafeCA.PrintReferences

//=============================================================================

procedure TFrmVSRptTndCntSafeCA.VspPreviewBeforeHeader(Sender: TObject);
begin  // of TFrmVSRptTndCntSafeCA.VspPreviewBeforeHeader
  inherited;

  DrawLogo (PicLogo);
  PrintPageHeader;
end;   // of TFrmVSRptTndCntSafeCA.VspPreviewBeforeHeader

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FVSRptTndCntSafeCA
