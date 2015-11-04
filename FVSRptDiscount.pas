//=Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved.=
// Packet   : FlexPoint Development 2.0.1
// Customer : Castorama
// Unit     : FVSRptDiscount = Form VideoSoft RePorT Discount
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptDiscount.pas,v 1.8 2010/02/09 14:11:33 BEL\nclevers Exp $
// History:
//=============================================================================

unit FVSRptDiscount;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfVSPrinter7, ActnList, ImgList, Menus, ExtCtrls, Buttons, OleCtrls,
  SmVSPrinter7Lib_TLB, ComCtrls, DB, DBTables, sfBusy;

//=============================================================================
// Constants for layout report
//=============================================================================

const  // Codes kind of lines present on report
  CtCodRptLinesDetailOnly    = 0;      // Detail lines only
  CtCodRptLinesTotalOnly     = 1;      // Total lines only
  CtCodRptLinesAll           = 2;      // All lines

const  // Codes kind of report layout
  CtCodRptLayOutGlobal       = 0;      // Layout global
  CtCodRptLayOutOperator     = 1;      // Layout operator
  CtCodRptLayOutTicket       = 2;      // Layout ticket
  CtCodRptLayOutCustomer     = 3;      // Layout curstomer
  CtCodRptLayOutPersonnel    = 4;      // Layout personnel

const  // Codes kind of totalLevel
  CtCodTotLvlUndefined       = -1;     // Total undefined
  CtCodTotLvlSub0            = 0;      // subtotal 0
  CtCodTotLvlTicket          = 0;      // Ticket total
  CtCodTotLvlDay             = 0;      // Day total
  CtCodTotLvlSub1            = 1;      // subtotal 1
  CtCodTotLvlOperator        = 1;      // Operator total
  CtCodTotLvlCustomer        = 1;      // Customer total
  CtCodTotLvlPersonnel       = 1;      // Personnel total
  CtCodTotLvlOverall         = 2;      // Overall Total

const  // Codes ApplicConv
  CtCodCustCategoryField     = 'CodCustCategory';
  CtCodDiscountTypeField     = 'CodTypeDiscount';
  CtCodCustCategoryTable     = 'Report';
  CtCodDiscountTypeTable     = 'Report';

const // Start Position of table
  CtStartPosTablePT          = 2500;   // Startposition table portrait
  CtStartPosTableLS          = 2500;   // Startposition table landscape

const  // Codes kind of output medium
  CtCodOutPrinter            = 0;      // Output to printer
  CtCodOutPreview            = 1;      // Output to preview

const
  CtCodPdtCommentDiscPers    = 412;

const
  CtColBodyShade0  = TColor($00F4F4F4);
  CtColBodyShade1  = TColor($00EFEFEF);
  CtColBodyShade2  = TColor($00E9E9E9);
  CtArrSubTotalShades   : array[0..2] of TColor =
                            (CtColBodyShade0, CtColBodyShade1, CtColBodyShade2);

//=============================================================================
// Resource-strings
//=============================================================================

resourcestring
  CtTxtHdrRptCount = 'Report Discount';

// Column Headers
resourcestring
  CtTxtHdrDay                = 'Day';
  CtTxtHdrTotalDay           = 'Total day';
  CtTxtHdrOverallTotal       = 'Overall total';
  CtTxtHdrTypeDiscount       = 'Type of discount';
  CtTxtHdrAmountDiscount     = 'Amount of discount';
  CtTxtHdrOperatorNumber     = 'Operator nb';
  CtTxtHdrOperatorTotal      = 'Total operator';
  CtTxtHdrOperatorName       = 'Operator name';
  CtTxtHdrTicketNumber       = 'Ticket nb';
  CtTxtHdrTicketTotal        = 'Total ticket';
  CtTxtHdrCheckOutNumber     = 'Checkout nb';
  CtTxtHdrDateTime           = 'Date/Time';
  CtTxtHdrCustomerNumber     = 'Customer nb';
  CtTxtHdrCustomerName       = 'Customer name';
  CtTxtHdrCustomerTotal      = 'Customer total';
  CtTxtHdrArticleNumber      = 'Article nb';
  CtTxtHdrArticleDescr       = 'Article description';
  CtTxtHdrQuantity           = 'Qty';
  CtTxtHdrTotTicketAmount    = 'Total ticket amount';
  CtTxtHdrCustomerCategory   = 'Customer category';
  CtTxtHdrPersonnelNumber    = 'Personnel nb';
  CtTxtHdrPersonnelName      = 'Personnel name';
  CtTxtHdrPersonnelTotal     = 'Personnel total';

// Totals
resourcestring
  CtTxtTotDay                = 'Total day %s';
  CtTxtTotOperator           = 'Total operator %s';
  CtTxtTotTicket             = 'Total ticket %s';
  CtTxtTotCustPers           = 'Total customer %s';
  CtTxtTotOverall            = 'Overall total';

// Titles
resourcestring
  CtTxtRptLayOutGlobal       = 'Global';
  CtTxtRptLayOutOperator     = 'Operator';
  CtTxtRptLayOutTicket       = 'Ticket';
  CtTxtRptLayOutCustomer     = 'Customer';
  CtTxtRptLayOutPersonnel    = 'Personnel';

//
resourcestring
  CtTxtRptOperators          = 'Operators';
  CtTxtRptDiscountTypes      = 'Discount types';
  CtTxtRptCustomerCategories = 'Customer categories';

// Footer/Header
resourcestring
  CtTxtPrintDate             = 'Printed on %s at %s';
  CtTxtReportDate            = 'Report from %s to %s';

// Footer/Header
resourcestring
  CtTxtOutputPrint           = 'Print';
  CtTxtOutputPreview         = 'Preview print';

//=============================================================================
// Global definitions
//=============================================================================

var    // Margins
  ViValMarginLeft  : Integer =  900;   // MarginLeft for VspPreview
  ViValMarginHeader: Integer =  1300;  // Adjust MarginTop to leave room for hdr

var    // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables

var    // Fontsizes
  ViValFontHeader  : Integer = 16;     // FontSize header
  ViValFontAddress : Integer =  9;     // FontSize Address
  ViValFontSubTitle: Integer =  8;     // FontSize SubTitle
  ViValFontTablePT : Integer =  9;     // FontSize table portrait
  ViValFontTableLS : Integer =  6;     // FontSize table landscape

var    // Positions and white space
  ViValPosXAddressPT    : Integer = 7000;   // X-position for address Portrait
  ViValPosXAddressLS    : Integer = 10000;  // X-position for address Landscape
  ViValSpaceBetween     : Integer = 200;    // White space between tables

var    // Column-width (in number of characters)
  ViValRptWidthDate     : Integer =  9;     // Width columns Date
  ViValRptWidthDateTotal: Integer = 18;     // Width columns Date with total
  ViValRptWidthDateTime : Integer = 17;     // Width columns Datetime
  ViValRptWidthDescr    : Integer = 26;     // Width columns description
  ViValRptWidthName     : Integer = 26;     // Width columns name
  ViValRptWidthNumber   : Integer =  9;     // Width columns number
  ViValRptWidthNumberTotal   : Integer = 18;     // Width columns number total
  ViValRptWidthQty      : Integer =  7;     // Width columns quantity
  ViValRptWidthVal      : Integer = 10;     // Width columns value
  ViValRptWidthAmount   : Integer = 10;     // Width columns amount

//=============================================================================
// TFrmVSRptDiscount
//=============================================================================

type
  TFrmVSRptDiscount = class(TFrmVSPreview)
    QryReport: TQuery;
    procedure VspPreviewNewPage(Sender: TObject);
  private
    { Private declarations }
  protected
    FTxtFNLogo          : string;      // Filename Logo
    FPicLogo            : TImage;      // Logo
    FCodLayout          : Integer;     // Layout of the report
    FCodDetail          : Integer;     // Kind of lines to print
    FIdtCustPers        : Integer;
    FStrLstOperators    : TStringList; // List of operators
    FStrLstCustCategories    : TStringList; // List of Customer categories
    FStrLstDiscountTypes     : TStringList; // List of Discount types
    FDtmFromDate        : TDateTime;   //
    FDtmToDate          : TDateTime;   //
    // Save default settings of VspPreview
    ValOrigMarginTop    : Double;      // Original MarginTop
    FrmGenerate         : TFrmBusy;    // Progress form generating report
    TxtTableFmt         : string;      // Format for Table on report
    TxtTableHdr         : string;      // Header for Table on report
    // Internal used datafields for Table on report
    QtyLinesPrinted     : Integer;     // Number of lines printed in table
    ValOverallTotalTicket    : Double; // Value Overall Total ticket
    ValOverallTotalDiscount  : Double; // Value Overall Total discount
    DatTicketTotal      : TDateTime;   // Break value for subtotal global layout
    IdtPosTransactionTotal   : string; // Break value for postransactions
    IdtOperatorTotal    : string;      // Break value for subtotal Operator
    IdtCustomerTotal    : string;      // Break value for subtotal Customer
    IdtPersonnelTotal   : string;      // Break value for subtotal Personnel
    ValSubTotalIdtOperator   : Double; // Value subtotal operator layout
    ValSubTotalIdtPosTransaction  : Double; // Value subtotal postransaction
    ValSubTotalDatTicket: Double;      // Value subtotal global layout
    ValSubTotalIdtCustomer   : Double; // Value subtotal Customer layout
    ValSubTotalIdtPersonnel  : Double; // Value subtotal Personnel layout
    ValTotalIdtPosTransaction: Double; // Value total ticket
    ValSubTotalOperatorPT: Double;     // Value total Operator/Postransaction
    ValSubTotalCustomerPT: Double;     // Value total Customer/Postransaction
    ValSubTotalPersonnelPT   : Double; // Value total Personnel/Postransaction
    //
    TxtNameOperatorTotal: string;      // Operator name for total line
    TxtNameCustomerTotal: string;      // Customer name for total line
    TxtNamePersonnelTotal    : string; // Personnelnr name for total line
    TxtIdtCheckoutTotal : string;      // Ident. Checkout for total line
    TxtDatTransBeginTotal    : string; // Date Transbegin for total line
    TxtCustCatTotal     : string;      // Customer category total line
    //
    TxtPrnDatTicket     : string;      // Current value DatTicket to print
    TxtPrnIdtOperator   : string;      // Current value IdtOperator to print
    TxtPrnTxtName       : string;      // Current value TxtName to print
    //
    ValPosYEndHdr       : Extended;    // Y-position at end of header
    //
    function GetOutputMedium : Byte; virtual;
    procedure SetTxtFNLogo (Value : string); virtual;
    function GetTxtReportTitle : string; virtual;
    //
    procedure InitializeBeforeGenerateReport; virtual;
    procedure AddFooterToPages; virtual;
    procedure InitializeBeforeStartTable; virtual;
    // Table Global
    procedure GenerateTableGlobalBody; virtual;
    // Table Operator
    procedure GenerateTableOperatorBody; virtual;
    // Table Ticket
    procedure GenerateTableTicketBody; virtual;
    // Table Customer
    procedure GenerateTableCustomerBody; virtual;
    // Table Personnel
    procedure GenerateTablePersonnelBody; virtual;
    // Totals
    procedure InitTotals; virtual;
    procedure AddToTotals (ValDiscount : Double;
                             ValTicket : Double;
                             CodAction : string);
    procedure PrintOverallTotalLine; virtual;

    procedure BuildOverallTotalLine (var  TxtLine : string); virtual;
    // Global methods for building tables
    procedure BuildTableFmtAndHdr; virtual;
    procedure PrintLineGeneral (var FlgFirst : Boolean); virtual;
    procedure BuildLineGeneral (var TxtLine : string; var FlgFirst : Boolean); virtual;
    procedure PrintTotalLine (CodTotLvl : Integer); virtual;
    procedure BuildTotalLine (var TxtLine : string;
                                CodTotLvl : Integer); virtual;
    // Methods for building the SQL statement
    function BuildSQL : string; virtual;
    function BuildSQLSelect : string; virtual;
    function BuildSQLJoin : string; virtual;
    function BuildSQLWhere : string; virtual;
    function BuildSQLGroupBy : string; virtual;
    function BuildSQLOrderBy : string; virtual;
    // Universal Methods
    procedure BuildTotalDiscountLine (var  TxtLine : string;
                                          TxtDescr : string;
                                  ValDiscountTotal : Double); virtual;
    procedure PrintTotalDiscountLine (TxtDescr : string;
                              ValDiscountTotal : Double); virtual;
    procedure GenerateTableDiscountTotals; virtual;
    procedure PrintReportHeader; virtual;
    procedure PrintPageHeader; virtual;
    procedure PrintAddress; virtual;
    procedure PrintLegend; virtual;
    procedure AppendFmtAndHdr (TxtHdr : string;
                               ChrAlign : Char;
                               NumWidth : Integer);  virtual;
    procedure AppendFmtAndHdrDescr (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrNumber (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrQuantity (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrAmount (TxtHdr : string); virtual;
    function CalcTextHei : Double; virtual;
    procedure PrintTableLine (TxtLine : string; NumTotLvl : Integer); virtual;
    function FldToDate (TxtDat : string) : TDateTime; virtual;
  public
    { Public declarations }
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
    // Overriden methods
    procedure DrawLogo (ImgLogo : TImage); override;
    // Methods
    procedure PrintReport; virtual;
    procedure PrepareReport; virtual;
    procedure GenerateReport; virtual;
    procedure CreateFormGenerate; virtual;
    procedure CheckAbortGenerate; virtual;
    // Properties
    property TxtFNLogo : string read  FTxtFNLogo
                                write SetTxtFNLogo;
    property PicLogo : TImage read  FPicLogo
                              write FPicLogo;
    property StrLstOperators : TStringList read FStrLstOperators
                                          write FStrLstOperators;
    property StrLstCustCategories : TStringList read FStrLstCustCategories
                                               write FStrLstCustCategories;
    property StrLstDiscountTypes : TStringList read FStrLstDiscountTypes
                                           write FStrLstDiscountTypes;
    property DtmFromDate : TDateTime read FDtmFromDate write FDtmFromDate;
    property DtmToDate : TDateTime read FDtmToDate write FDtmToDate;
    property CodOutputMedium : Byte read GetOutputMedium;
    property TxtReportTitle : string read GetTxtReportTitle;
    property IdtCustPers : Integer read FIdtCustPers write FIdtCustPers;
  published
    property CodLayout : Integer read  FCodLayout
                                  write FCodLayout;
    property CodDetail : Integer read  FCodDetail
                                  write FCodDetail;
  end;

type
  TDiscountTotal = class(TObject)
  public
    CodAction      : string;
    Descr          : string;
    Val            : Double;
    constructor CreateWithParams (TxtCodAction: string; TxtDescr : string);
  end;

type
  TCategoryTotal = class(TObject)
  public
    CodCustCat     : string;
    Descr          : string;
    Val            : Double;
    constructor CreateWithParams (TxtCodCustCat: string; TxtDescr : string);
  end;

var
  FrmVSRptDiscount: TFrmVSRptDiscount;

//*****************************************************************************

implementation

uses
  Math,

  SfDialog,
  smUtils,
  srStnCom,

  stDate,
  stStrW,

  RFpnCommunic,

  DFpnCustomer,
  DFpnEmployee,
  DFpnUtils,
  DFpnTradeMatrix,
  DFpnPosTransaction;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptDiscount';

const  // CVS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptDiscount.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.8 $';
  CtTxtSrcDate    = '$Date: 2010/02/09 14:11:33 $';
  CtTxtSrcTag     = '$Name:  $';

//*****************************************************************************
// Implementation of TDiscount
//*****************************************************************************

constructor TDiscountTotal.CreateWithParams (TxtCodAction : string;
                                                 TxtDescr : string);
begin  // of TDiscountTotal.CreateWithParams
  inherited Create;
  CodAction := TxtCodAction;
  Descr := TxtDescr;
  Val := 0;
end;   // of TDiscountTotal.CreateWithParams

//*****************************************************************************
// Implementation of TCategoryTotal
//*****************************************************************************

constructor TCategoryTotal.CreateWithParams (TxtCodCustCat : string;
                                                  TxtDescr : string);
begin  // of TCategoryTotal.CreateWithParams
  inherited Create;
  CodCustCat := TxtCodCustCat;
  Descr := TxtDescr;
  Val := 0;
end;   // of TCategoryTotal.CreateWithParams

//*****************************************************************************
// Implementation of FrmVSRptDiscount
//*****************************************************************************

constructor TFrmVSRptDiscount.Create (AOwner : TComponent);
begin  // of TFrmVSRptDiscount.Create
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

  FStrLstOperators := TStringList.Create;
  FStrLstCustCategories := TStringList.Create;
  FStrLstDiscountTypes := TStringList.Create;
end;   // of TFrmVSRptDiscount.Create

//=============================================================================

destructor TFrmVSRptDiscount.Destroy;
begin  // of TFrmVSRptDiscount.Destroy
  FPicLogo.Free;
  FStrLstOperators.Free;
  FStrLstCustCategories.Free;
  FStrLstDiscountTypes.Free;
  inherited;
end;   // of TFrmVSRptTndCount.Destroy

//=============================================================================
// TFrmVSRptDiscount - Methods for read/write properties
//=============================================================================

function TFrmVSRptDiscount.GetOutputMedium : Byte;
begin  // of TFrmVSRptDiscount.GetOutputMedium
  if VspPreview.Preview then
    Result := CtCodOutPreview
  else
    Result := CtCodOutPrinter;
end;   // of TFrmVSRptDiscount.GetOutputMedium

//=============================================================================

procedure TFrmVSRptDiscount.SetTxtFNLogo (Value : string);
begin  // of TFrmVSRptDiscount.SetTxtFNLogo
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
end;   // of TFrmVSRptDiscount.SetTxtFNLogo

//=============================================================================

function TFrmVSRptDiscount.GetTxtReportTitle : string;
begin  // of TFrmVSRptDiscount.GetTxtReportTitle
  case CodLayout of
    CtCodRptLayOutGlobal   :
      Result := CtTxtRptLayOutGlobal;
    CtCodRptLayOutOperator :
      Result := CtTxtRptLayOutOperator;
    CtCodRptLayOutTicket   :
      Result := CtTxtRptLayOutTicket;
    CtCodRptLayOutCustomer :
    begin
      Result := CtTxtRptLayOutCustomer;
      if IdtCustPers <> 0 then
        if DmdFpnCustomer.CustomerExists (IdtCustPers) then
          Result := Result +
            ' [' + IntToStr (IdtCustPers) + ' - ' +
            DmdFpnCustomer.InfoCustomer[IdtCustPers, 'TxtPublName'] + ']'
        else
          Result := Result +
            ' [' + IntToStr (IdtCustPers) +  ']';
    end;
    CtCodRptLayOutPersonnel:
    begin
      Result := CtTxtRptLayOutPersonnel;
      if IdtCustPers <> 0 then
        if DmdFpnEmployee.EmployeeExists (IdtCustPers) then
          Result := Result +
            ' [' + IntToStr (IdtCustPers) + ' - ' +
            DmdFpnEmployee.InfoEmployee[IdtCustPers, 'TxtLastName'] + ']'
        else
          Result := Result +
            ' [' + IntToStr (IdtCustPers) +  ']';
    end;
  end;
end;   // of TFrmVSRptDiscount.GetTxtReportTitle

//=============================================================================
// TFrmVSRptTndCount.InitializeBeforeGenerateReport : performs some
// initializations before generating the report.
//=============================================================================

procedure TFrmVSRptDiscount.InitializeBeforeGenerateReport;
begin  // of TFrmVSRptDiscount.InitializeBeforeGenerateReport
  case CodLayout of
    CtCodRptLayOutGlobal,
    CtCodRptLayOutOperator :
    begin
      VspPreview.FontSize := ViValFontTablePT;
      VspPreview.Orientation := orPortrait;
    end;
    CtCodRptLayOutTicket,
    CtCodRptLayOutCustomer,
    CtCodRptLayOutPersonnel :
    begin
      VspPreview.FontSize := ViValFontTableLS;
      VspPreview.Orientation := orLandscape;
    end;
  end;
  InitTotals;
  BuildTableFmtAndHdr;
end;   // of TFrmVSRptTndCount.InitializeBeforeGenerateReport

//=============================================================================
// TFrmVSRptDiscount - Public methods
//=============================================================================

procedure TFrmVSRptDiscount.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptDiscount.DrawLogo
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
end;   // of TFrmVSRptDiscount.DrawLogo

//=============================================================================
// TFrmVSRptTndCount.AddFooterToPages : adds a footer to each page with
// date and pagenumber.
//=============================================================================

procedure TFrmVSRptDiscount.AddFooterToPages;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
begin  // of TFrmVSRptDiscount.AddFooterToPages
  // Add page number and date to report
  if VspPreview.PageCount > 0 then begin
    for CntPage := 1 to VspPreview.PageCount do begin
      VspPreview.StartOverlay (CntPage, False);
      try
        VspPreview.CurrentX := VspPreview.MarginLeft;
        VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                               VspPreview.TextHeight ['X'];
        VspPreview.Text := Format (CtTxtPrintDate,
                                   [FormatDateTime (CtTxtDatFormat, Now),
                                    FormatDateTime (CtTxtHouFormat, Now)]);
        TxtPage := Format ('P.%d/%d', [CntPage, VspPreview.PageCount]);
        VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight -
                               VspPreview.TextWidth [TxtPage] - 1;
        VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                               VspPreview.TextHeight ['X'];
        VspPreview.Text := TxtPage;
      finally
        VspPreview.EndOverlay;
      end;
    end;  // of for CntPage := 1 to VspPreview.PageCount
  end;  // of VspPreview.PageCount > 0
end;   // of TFrmVSRptDiscount.AddFooterToPages

//=============================================================================
// TFrmVSRptDiscount.InitializeBeforeStartTable : initialization before
// starting a new table.
//=============================================================================

procedure TFrmVSRptDiscount.InitializeBeforeStartTable;
begin  // of TFrmVSRptDiscount.InitializeBeforeStartTable
  QtyLinesPrinted := 0;
end;   // of TFrmVSRptDiscount.InitializeBeforeStartTable

//=============================================================================
// TFrmVSRptDisCount.BuildOverallTotalLine
//=============================================================================

procedure TFrmVSRptDisCount.BuildOverallTotalLine (var  TxtLine : string);
begin  // of TFrmVSRptDisCount.BuildOverallTotalLine
  case CodLayout of
    CtCodRptLayOutGlobal :
      TxtLine :=
        CtTxtHdrOverallTotal + SepCol + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
          ValOverallTotalDiscount);
    CtCodRptLayOutOperator :
      TxtLine :=
        CtTxtHdrOverallTotal + SepCol + SepCol + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
          ValOverallTotalDiscount);
    CtCodRptLayOutTicket,
    CtCodRptLayOutCustomer,
    CtCodRptLayOutPersonnel :
      TxtLine :=
        CtTxtHdrOverallTotal + SepCol + SepCol + SepCol + SepCol + SepCol
        + SepCol + SepCol + SepCol + SepCol + SepCol + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
          ValOverallTotalDiscount) + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
          ValOverallTotalTicket);
  end;
end;   // of TFrmVSRptDisCount.BuildOverallTotalLine

//=============================================================================
// TFrmVSRptDisCount.PrintLineGeneral : generates the body-line of the table
// with the discount info
//=============================================================================

procedure TFrmVSRptDisCount.PrintLineGeneral (var FlgFirst : Boolean);
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptDisCount.PrintLineGeneral
  if CodDetail in [CtCodRptLinesDetailOnly, CtCodRptLinesAll] then begin
    BuildLineGeneral (TxtLine, FlgFirst);
    PrintTableLine (TxtLine, CtCodTotLvlUndefined);
  end;
end;   // of TFrmVSRptDisCount.PrintLineGeneral

//=============================================================================
// TFrmVSRptDisCount.BuildLineGeneral : builds the body-line of the table
// with the discount info
//=============================================================================

procedure TFrmVSRptDisCount.BuildLineGeneral (var TxtLine : string;
                                              var FlgFirst : Boolean);
begin  // of TFrmVSRptDisCount.BuildLineGeneral
  case CodLayout of
    CtCodRptLayOutGlobal :
      TxtLine :=
        TxtPrnDatTicket + SepCol +
        QryReport.FieldByName ('TxtDescrDiscount').AsString + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
          StrToFloat (QryReport.FieldByName ('ValDiscount').AsString));
    CtCodRptLayOutOperator :
      TxtLine :=
        TxtPrnIdtOperator + SepCol +
        TxtPrnTxtName + SepCol +
        QryReport.FieldByName ('TxtDescrDiscount').AsString + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
          StrToFloat (QryReport.FieldByName ('ValDiscount').AsString));
    CtCodRptLayOutTicket   :
    begin
      if FlgFirst then
        TxtLine := TxtLine +
          QryReport.FieldByName ('IdtOperator').AsString + SepCol +
          QryReport.FieldByName ('TxtName').AsString + SepCol +
          QryReport.FieldByName ('IdtPosTransaction').AsString + SepCol +
          QryReport.FieldByName ('IdtCheckOut').AsString + SepCol +
          QryReport.FieldByName ('DatTransBegin').AsString + SepCol +
          QryReport.FieldByName ('IdtCustomer').AsString + SepCol +
          QryReport.FieldByName ('TxtNameCustomer').AsString + SepCol
      else
        TxtLine := TxtLine +
          SepCol + SepCol + SepCol + SepCol + SepCol + SepCol + SepCol;
      TxtLine := TxtLine +
        QryReport.FieldByName ('IdtArticle').AsString + SepCol +
        QryReport.FieldByName ('TxtDescr').AsString + SepCol +
        QryReport.FieldByName ('QtyReg').AsString + SepCol +
        QryReport.FieldByName ('TxtDescrDiscount').AsString + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
          StrToFloat (QryReport.FieldByName ('ValDiscount').AsString));
    end;
    CtCodRptLayOutCustomer :
    begin
      if FlgFirst then
        TxtLine := TxtLine +
        QryReport.FieldByName ('IdtOperator').AsString + SepCol +
          QryReport.FieldByName ('IdtPosTransaction').AsString + SepCol +
          QryReport.FieldByName ('IdtCheckOut').AsString + SepCol +
          QryReport.FieldByName ('DatTransBegin').AsString + SepCol +
          QryReport.FieldByName ('IdtCustomer').AsString + SepCol +
          QryReport.FieldByName ('TxtNameCustomer').AsString + SepCol +
          QryReport.FieldByName ('TxtDescrCustCat').AsString + SepCol
      else
        TxtLine := TxtLine +
          SepCol + SepCol + SepCol + SepCol + SepCol + SepCol + SepCol;
      TxtLine := TxtLine +
        QryReport.FieldByName ('IdtArticle').AsString + SepCol +
        QryReport.FieldByName ('TxtDescr').AsString + SepCol +
        QryReport.FieldByName ('QtyReg').AsString + SepCol +
        QryReport.FieldByName ('TxtDescrDiscount').AsString + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
          StrToFloat (QryReport.FieldByName ('ValDiscount').AsString));
    end;
    CtCodRptLayOutPersonnel :
    begin
      if FlgFirst then
        TxtLine := TxtLine +
          QryReport.FieldByName ('IdtOperator').AsString + SepCol +
          QryReport.FieldByName ('IdtPosTransaction').AsString + SepCol +
          QryReport.FieldByName ('IdtCheckOut').AsString + SepCol +
          QryReport.FieldByName ('DatTransBegin').AsString + SepCol +
          QryReport.FieldByName ('IdtPersonnel').AsString + SepCol +
          QryReport.FieldByName ('TxtNamePers').AsString + SepCol
      else
        TxtLine := TxtLine +
          SepCol + SepCol + SepCol + SepCol + SepCol + SepCol;
      TxtLine := TxtLine +
        QryReport.FieldByName ('IdtArticle').AsString + SepCol +
        QryReport.FieldByName ('TxtDescr').AsString + SepCol +
        QryReport.FieldByName ('QtyReg').AsString + SepCol +
        QryReport.FieldByName ('TxtDescrDiscount').AsString + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
          StrToFloat (QryReport.FieldByName ('ValDiscount').AsString));
    end;
  end;
  if FlgFirst then
    FlgFirst := False;
end;   // of TFrmVSRptDisCount.BuildLineGeneral

//=============================================================================
// TFrmVSRptDisCount.PrintTotalLine : generates the Total line of the table
//=============================================================================

procedure TFrmVSRptDisCount.PrintTotalLine (CodTotLvl : Integer);
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptDisCount.PrintTotalLineGlobal
  if CodDetail in [CtCodRptLinesTotalOnly, CtCodRptLinesAll] then begin
    BuildTotalLine (TxtLine, CodTotLvl);
    PrintTableLine (TxtLine, CodTotLvl);
  end;
end;   // of TFrmVSRptDisCount.PrintTotalLine

//=============================================================================
// TFrmVSRptDisCount.BuildTotalLine : builds the body total line of the table
//=============================================================================

procedure TFrmVSRptDisCount.BuildTotalLine (var  TxtLine : string;
                                               CodTotLvl : Integer);
begin  // of TFrmVSRptDisCount.BuildTotalLine
  case CodLayout of
    CtCodRptLayOutGlobal   :
      TxtLine := CtTxtHdrTotalDay + ' ' +
        FormatDateTime ('dd/mm/yyyy', DatTicketTotal) + SepCol +  SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                     ValSubTotalDatTicket);
    CtCodRptLayOutOperator :
      TxtLine :=
        CtTxtHdrOperatorTotal + ' ' + IdtOperatorTotal + SepCol +
        TxtNameOperatorTotal +  SepCol + SepCol +
        FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                     ValSubTotalIdtOperator);
    CtCodRptLayOutTicket   :
      case CodTotLvl of
        CtCodTotLvlTicket:
          TxtLine :=
            CtTxtHdrTicketTotal + SepCol +
            TxtNameOperatorTotal + SepCol +
            IdtPosTransactionTotal + SepCol +
            TxtIdtCheckoutTotal + SepCol +
            TxtDatTransBeginTotal + SepCol +
            SepCol + SepCol + SepCol + SepCol + SepCol + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValSubTotalIdtPosTransaction) + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValTotalIdtPosTransaction);
        CtCodTotLvlOperator:
          TxtLine :=
            CtTxtHdrOperatorTotal + ' ' + IdtOperatorTotal + SepCol +
            TxtNameOperatorTotal + SepCol +
            SepCol + SepCol + SepCol + SepCol +
            SepCol + SepCol + SepCol + SepCol + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValSubTotalIdtOperator) + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValSubTotalOperatorPT);
      end;
    CtCodRptLayOutCustomer :
      case CodTotLvl of
        CtCodTotLvlTicket:
          TxtLine :=
            CtTxtHdrTicketTotal + SepCol +
            IdtPosTransactionTotal + SepCol +
            TxtIdtCheckoutTotal + SepCol +
            TxtDatTransBeginTotal + SepCol +
            IdtCustomerTotal + SepCol +
            TxtNameCustomerTotal + SepCol +
            TxtCustCatTotal + SepCol +
            SepCol + SepCol + SepCol + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValSubTotalIdtPosTransaction) + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValTotalIdtPosTransaction);
        CtCodTotLvlCustomer:
          TxtLine :=
            CtTxtHdrCustomerTotal + SepCol + SepCol + SepCol + SepCol +
            IdtCustomerTotal + SepCol +
            TxtNameCustomerTotal + SepCol +
            TxtCustCatTotal + SepCol +
            SepCol + SepCol + SepCol + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValSubTotalIdtCustomer) + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValSubTotalCustomerPT);
      end;
    CtCodRptLayOutPersonnel :
      case CodTotLvl of
        CtCodTotLvlTicket:
          TxtLine :=
            CtTxtHdrTicketTotal + SepCol +
            IdtPosTransactionTotal + SepCol +
            TxtIdtCheckoutTotal + SepCol +
            TxtDatTransBeginTotal + SepCol +
            IdtPersonnelTotal + SepCol +
            TxtNamePersonnelTotal + SepCol +
            SepCol + SepCol + SepCol + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValSubTotalIdtPosTransaction) + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValTotalIdtPosTransaction);
        CtCodTotLvlPersonnel:
          TxtLine :=
            CtTxtHdrPersonnelTotal + SepCol + SepCol + SepCol + SepCol +
            IdtPersonnelTotal + SepCol +
            TxtNamePersonnelTotal + SepCol +
            SepCol + SepCol + SepCol + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValSubTotalIdtPersonnel) + SepCol +
            FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                         ValSubTotalPersonnelPT);
      end;
  end;
end;   // of TFrmVSRptDisCount.BuildTotalLine

//=============================================================================
// TFrmVSRptDisCount.PrintOverallTotalLine
//=============================================================================

procedure TFrmVSRptDisCount.PrintOverallTotalLine;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptDisCount.PrintTotalLineGlobal
  if CodDetail in [CtCodRptLinesTotalOnly, CtCodRptLinesAll] then begin
    BuildOverallTotalLine (TxtLine);
    PrintTableLine (TxtLine, CtCodTotLvlOverall);
  end;
end;   // of TFrmVSRptDisCount.PrintTotalLineGlobal

//=============================================================================
// TFrmVSRptDisCount.BuildTableFmtAndHdr : builds the Format and Header
// for the current table
//=============================================================================

procedure TFrmVSRptDisCount.BuildTableFmtAndHdr;
begin  // of TFrmVSRptDisCount.BuildTableFmtAndHdr
  TxtTableFmt := '';
  TxtTableHdr := '';
  case CodLayout of
    CtCodRptLayOutGlobal :
    begin
      AppendFmtAndHdr (CtTxtHdrDay, FormatAlignLeft, ViValRptWidthDateTotal);
      AppendFmtAndHdrDescr (CtTxtHdrTypeDiscount);
      AppendFmtAndHdrAmount (CtTxtHdrAmountDiscount);
    end;
    CtCodRptLayOutOperator :
    begin
      AppendFmtAndHdr (CtTxtHdrOperatorNumber, FormatAlignLeft,
                       ViValRptWidthNumberTotal);
      AppendFmtAndHdrDescr (CtTxtHdrOperatorName);
      AppendFmtAndHdrDescr (CtTxtHdrTypeDiscount);
      AppendFmtAndHdrAmount (CtTxtHdrAmountDiscount);
    end;
    CtCodRptLayOutTicket :
    begin
      AppendFmtAndHdrNumber (CtTxtHdrOperatorNumber);
      AppendFmtAndHdrDescr (CtTxtHdrOperatorName);
      AppendFmtAndHdrNumber (ctTxtHdrTicketNumber);
      AppendFmtAndHdrNumber (CtTxtHdrCheckOutNumber);
      AppendFmtAndHdr (CtTxtHdrDateTime, FormatAlignLeft, ViValRptWidthDateTime);
      AppendFmtAndHdrNumber (CtTxtHdrCustomerNumber);
      AppendFmtAndHdrDescr (CtTxtHdrCustomerName);
      AppendFmtAndHdrNumber (CtTxtHdrArticleNumber);
      AppendFmtAndHdrDescr (CtTxtHdrArticleDescr);
      AppendFmtAndHdrQuantity (CtTxtHdrQuantity);
      AppendFmtAndHdrDescr (CtTxtHdrTypeDiscount);
      AppendFmtAndHdrAmount (CtTxtHdrAmountDiscount);
      AppendFmtAndHdrAmount (CtTxtHdrTotTicketAmount);
    end;
    CtCodRptLayOutCustomer :
    begin
      AppendFmtAndHdrNumber (CtTxtHdrOperatorNumber);
      AppendFmtAndHdrNumber (ctTxtHdrTicketNumber);
      AppendFmtAndHdrNumber (CtTxtHdrCheckOutNumber);
      AppendFmtAndHdr (CtTxtHdrDateTime, FormatAlignLeft, ViValRptWidthDateTime);
      AppendFmtAndHdrNumber (CtTxtHdrCustomerNumber);
      AppendFmtAndHdrDescr (CtTxtHdrCustomerName);
      AppendFmtAndHdrDescr (CtTxtHdrCustomerCategory);
      AppendFmtAndHdrNumber (CtTxtHdrArticleNumber);
      AppendFmtAndHdrDescr (CtTxtHdrArticleDescr);
      AppendFmtAndHdrQuantity (CtTxtHdrQuantity);
      AppendFmtAndHdrDescr (CtTxtHdrTypeDiscount);
      AppendFmtAndHdrAmount (CtTxtHdrAmountDiscount);
      AppendFmtAndHdrAmount (CtTxtHdrTotTicketAmount);
    end;
    CtCodRptLayOutPersonnel :
    begin
      AppendFmtAndHdrNumber (CtTxtHdrOperatorNumber);
      AppendFmtAndHdrNumber (ctTxtHdrTicketNumber);
      AppendFmtAndHdrNumber (CtTxtHdrCheckOutNumber);
      AppendFmtAndHdr (CtTxtHdrDateTime, FormatAlignLeft, ViValRptWidthDateTime);
      AppendFmtAndHdrNumber (CtTxtHdrPersonnelNumber);
      AppendFmtAndHdrDescr (CtTxtHdrPersonnelName);
      AppendFmtAndHdrNumber (CtTxtHdrArticleNumber);
      AppendFmtAndHdrDescr (CtTxtHdrArticleDescr);
      AppendFmtAndHdrQuantity (CtTxtHdrQuantity);
      AppendFmtAndHdrDescr (CtTxtHdrTypeDiscount);
      AppendFmtAndHdrAmount (CtTxtHdrAmountDiscount);
      AppendFmtAndHdrAmount (CtTxtHdrTotTicketAmount);
    end;
  end;
end;   // of TFrmVSRptDisCount.BuildTableFmtAndHdr

//=============================================================================
// TFrmVSRptDisCount.GenerateTableGlobalBody : generates the body of the table
// with the Global view of the discounts.
//=============================================================================

procedure TFrmVSRptDisCount.GenerateTableGlobalBody;
var
  DatTicket     : TDateTime;
  FlgFirst      : Boolean;
begin  // of TFrmVSRptDisCount.GenerateTableGlobalBody
  if not QryReport.IsEmpty then begin
    QryReport.First;
    DatTicket := FldToDate (QryReport.FieldByName ('DatTicket').AsString);
    TxtPrnDatTicket := FormatDateTime ('dd/mm/yyyy', DatTicket);
    FlgFirst := True;
    AddToTotals (StrToFloat (QryReport.FieldByName ('ValDiscount').AsString), 0,
                 QryReport.FieldByName ('CodAction').AsString);
    repeat
      CheckAbortGenerate;
      case FrmGenerate.ModalResult of
        mrAbort  :
          Abort;
        mrCancel :
          Break;
        mrNone   :
        begin
          PrintLineGeneral (FlgFirst);
          DatTicketTotal := DatTicket;
          QryReport.Next;
          FrmGenerate.PgsBarBusy.StepIt;
          if not QryReport.Eof then begin
            DatTicket := FldToDate (QryReport.
                                      FieldByName ('DatTicket').AsString);
            if DatTicket <> DatTicketTotal then begin
              PrintTotalLine (CtCodTotLvlDay);
              ValSubTotalDatTicket := 0;
              TxtPrnDatTicket := FormatDateTime ('dd/mm/yyyy', DatTicket);
              FlgFirst := True;
            end else
              TxtPrnDatTicket := '';   // Is already printed
            AddToTotals (
              StrToFloat (QryReport.FieldByName ('ValDiscount').AsString), 0,
              QryReport.FieldByName ('CodAction').AsString);
          end;
        end;
      end;
    until QryReport.Eof or (FrmGenerate.ModalResult <> mrNone);
    if FrmGenerate.ModalResult = mrNone then begin
      PrintTotalLine (CtCodTotLvlDay);
      PrintOverallTotalLine;
    end;
  end
  else begin
    VspPreview.Text := CtTxtNoData;
  end;
end;   // of TFrmVSRptDisCount.GenerateTableGlobalBody

//=============================================================================
// TFrmVSRptDisCount.InitTotals :
//=============================================================================
procedure TFrmVSRptDisCount.InitTotals;
var
  Cnt              : Integer;
begin
  ValSubTotalDatTicket := 0;
  ValSubTotalIdtOperator := 0;
  ValSubTotalIdtPosTransaction := 0;
  ValSubTotalIdtCustomer := 0;
  ValSubTotalIdtPersonnel := 0;
  ValSubTotalCustomerPT := 0;
  ValSubTotalPersonnelPT := 0;
  ValSubTotalOperatorPT := 0;
  ValOverallTotalDiscount := 0;
  ValOverallTotalTicket := 0;
  for Cnt := 0 to StrLstDiscountTypes.Count - 1 do
    TDisCountTotal (StrLstDiscountTypes.Objects[Cnt]).Val := 0;
end;

//=============================================================================
// TFrmVSRptDisCount.AddToTotals :
//=============================================================================

procedure TFrmVSRptDisCount.AddToTotals (ValDiscount : Double;
                                           ValTicket : Double;
                                           CodAction : string);
begin
  case CodLayout of
    CtCodRptLayOutGlobal :
      ValSubTotalDatTicket        := ValSubTotalDatTicket + ValDiscount;
    CtCodRptLayOutOperator :
      ValSubTotalIdtOperator      := ValSubTotalIdtOperator + ValDiscount;
    CtCodRptLayOutTicket :
    begin
      ValSubTotalIdtPosTransaction:= ValSubTotalIdtPosTransaction + ValDiscount;
      ValSubTotalIdtOperator      := ValSubTotalIdtOperator + ValDiscount;
      ValSubTotalOperatorPT       := ValSubTotalOperatorPT + ValTicket;
    end;
    CtCodRptLayOutCustomer :
    begin
      ValSubTotalIdtPosTransaction:= ValSubTotalIdtPosTransaction + ValDiscount;
      ValSubTotalIdtCustomer      := ValSubTotalIdtCustomer + ValDiscount;
      ValSubTotalCustomerPT       := ValSubTotalCustomerPT + ValTicket;
    end;
    CtCodRptLayOutPersonnel :
    begin
      ValSubTotalIdtPosTransaction:= ValSubTotalIdtPosTransaction + ValDiscount;
      ValSubTotalIdtPersonnel     := ValSubTotalIdtPersonnel + ValDiscount;
      ValSubTotalPersonnelPT      := ValSubTotalPersonnelPT + ValTicket;
    end;
  end;
  ValOverallTotalDiscount := ValOverallTotalDiscount + ValDiscount;
  ValOverallTotalTicket   := ValOverallTotalTicket + ValTicket;
  TDisCountTotal (StrLstDiscountTypes.
    Objects[StrLstDiscountTypes.IndexOf (CodAction)]).Val :=
    TDisCountTotal (StrLstDiscountTypes.
      Objects[StrLstDiscountTypes.IndexOf (CodAction)]).Val + ValDiscount;
end;

//=============================================================================
// TFrmVSRptDisCount.BuildTotalDiscountLine
//=============================================================================

procedure TFrmVSRptDisCount.BuildTotalDiscountLine (var  TxtLine : string;
                                                        TxtDescr : string;
                                                ValDiscountTotal : Double);
begin  // of TFrmVSRptDisCount.BuildTotalDiscountLine
  case CodLayout of
    CtCodRptLayOutGlobal :
      TxtLine := SepCol;
    CtCodRptLayOutOperator :
      TxtLine := SepCol + SepCol;
    CtCodRptLayOutTicket,
    CtCodRptLayOutCustomer :
      TxtLine := SepCol + SepCol + SepCol + SepCol + SepCol +
                 SepCol + SepCol + SepCol + SepCol + SepCol;
    CtCodRptLayOutPersonnel :
      TxtLine := SepCol + SepCol + SepCol + SepCol + SepCol +
                 SepCol + SepCol + SepCol + SepCol;
  end;
  TxtLine := TxtLine  + TxtDescr + SepCol +
    FormatFloat ('0.' + CharStrW ('0', DmdFpnUtils.QtyDecsValue),
                 ValDiscountTotal);
end;   // of TFrmVSRptDisCount.BuildTotalDiscountLine

//=============================================================================
// TFrmVSRptDisCount.PrintTotalDiscountLine
//=============================================================================

procedure TFrmVSRptDisCount.PrintTotalDiscountLine (TxtDescr : string;
                                            ValDiscountTotal : Double);
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptDisCount.PrintTotalDiscountLine
  if CodDetail in [CtCodRptLinesTotalOnly, CtCodRptLinesAll] then begin
    BuildTotalDiscountLine (TxtLine, TxtDescr, ValDiscountTotal);
    PrintTableLine (TxtLine, CtCodTotLvlOverall);
  end;
end;   // of TFrmVSRptDisCount.PrintTotalDiscountLine

//=============================================================================
// TFrmVSRptDiscount.GenerateTableDiscountTotals : generates the table with the
// discounts totals
//=============================================================================

procedure TFrmVSRptDiscount.GenerateTableDiscountTotals;
var
  Cnt              : Integer;
//  ValFontBoldSave    : Boolean;     // Save original bold flag
begin  // of TFrmVSRptDiscount.GenerateTableDiscountTotals
  for Cnt := 0 to StrLstDiscountTypes.Count - 1 do
     PrintTotalDiscountLine (
       TDiscountTotal (StrLstDiscountTypes.Objects[Cnt]).Descr,
       TDiscountTotal (StrLstDiscountTypes.Objects[Cnt]).Val);
end;   // of TFrmVSRptDiscount.GenerateTableDiscountTotals

//=============================================================================
// TFrmVSRptDisCount.GenerateTableOperatorBody : generates the body of the table
// with the operator view of the discounts.
//=============================================================================

procedure TFrmVSRptDisCount.GenerateTableOperatorBody;
var
  IdtOperator      : string;
  FlgFirst         : Boolean;          // Flag First line of ticket
begin  // of TFrmVSRptDisCount.GenerateTableOperatorBody
  if not QryReport.IsEmpty then begin
    QryReport.First;
    IdtOperator := QryReport.FieldByName ('IdtOperator').AsString;
    TxtPrnIdtOperator := IdtOperator;
    TxtPrnTxtName := QryReport.FieldByName ('TxtName').AsString;
    FlgFirst := True;
    AddToTotals (StrToFloat (QryReport.FieldByName ('ValDiscount').AsString), 0,
                 QryReport.FieldByName ('CodAction').AsString);
    repeat
      CheckAbortGenerate;
      case FrmGenerate.ModalResult of
        mrAbort  :
          Abort;
        mrCancel :
          Break;
        mrNone   :
        begin
          PrintLineGeneral (FlgFirst);
          IdtOperatorTotal := IdtOperator;
          TxtNameOperatorTotal := QryReport.FieldByName ('TxtName').AsString;
          QryReport.Next;
          FrmGenerate.PgsBarBusy.StepIt;
          if not QryReport.Eof then begin
            IdtOperator := QryReport.FieldByName ('IdtOperator').AsString;
            if IdtOperator <> IdtOperatorTotal then begin
              PrintTotalLine (CtCodTotLvlOperator);
              ValSubTotalIdtOperator := 0;
              TxtPrnIdtOperator := IdtOperator;
              TxtPrnTxtName := QryReport.FieldByName ('TxtName').AsString;
              FlgFirst := True;
            end else begin
              TxtPrnIdtOperator := '';
              TxtPrnTxtName := '';
            end;
            AddToTotals (
              StrToFloat (QryReport.FieldByName ('ValDiscount').AsString), 0,
              QryReport.FieldByName ('CodAction').AsString);
          end;
        end;
      end;
    until QryReport.Eof or (FrmGenerate.ModalResult <> mrNone);
    if FrmGenerate.ModalResult = mrNone then begin
      PrintTotalLine (CtCodTotLvlOperator);
      PrintOverallTotalLine;
    end;
  end
  else begin
    VspPreview.Text := CtTxtNoData;
  end;
end;   // of TFrmVSRptDisCount.GenerateTableOperatorBody

//=============================================================================
// TFrmVSRptDisCount.GenerateTableTicketBody : generates the body of the table
// with the Ticket view of the discounts.
//=============================================================================

procedure TFrmVSRptDisCount.GenerateTableTicketBody;
var
  IdtPosTransaction: string;
  IdtOperator      : string;
  FlgFirst         : Boolean;          // Flag First line of ticket
begin  // of TFrmVSRptDisCount.GenerateTableTicketBody
  if not QryReport.IsEmpty then begin
    QryReport.First;
    IdtOperator := QryReport.FieldByName ('IdtOperator').AsString;
    IdtPostransaction := QryReport.FieldByName ('IdtPostransaction').AsString;
    FlgFirst := True;
    ValTotalIdtPosTransaction :=
      StrToFloat (QryReport.FieldByName ('ValTotal').AsString);
    AddToTotals (StrToFloat (QryReport.FieldByName ('ValDiscount').AsString),
                 ValTotalIdtPosTransaction,
                 QryReport.FieldByName ('CodAction').AsString);
    repeat
      CheckAbortGenerate;
      case FrmGenerate.ModalResult of
        mrAbort  :
          Abort;
        mrCancel :
          Break;
        mrNone :
        begin
          PrintLineGeneral (FlgFirst);
          IdtPostransactionTotal := IdtPostransaction;
          IdtOperatorTotal := IdtOperator;
          TxtNameOperatorTotal := QryReport.FieldByName ('TxtName').AsString;
          TxtIdtCheckoutTotal := QryReport.FieldByName ('IdtCheckout').AsString;
          TxtDatTransBeginTotal :=
            QryReport.FieldByName ('DatTransBegin').AsString;
          QryReport.Next;
          FrmGenerate.PgsBarBusy.StepIt;
          if not QryReport.Eof then begin
            IdtOperator := QryReport.FieldByName ('IdtOperator').AsString;
            IdtPostransaction :=
              QryReport.FieldByName ('IdtPostransaction').AsString;
            if IdtOperator <> IdtOperatorTotal then begin
              PrintTotalLine (CtCodTotLvlTicket);
              ValSubTotalIdtPosTransaction := 0;
              PrintTotalLine (CtCodTotLvlOperator);
              ValSubTotalIdtOperator := 0;
              ValSubTotalOperatorPT := 0;
              FlgFirst := True;
              ValTotalIdtPosTransaction :=
                StrToFloat (QryReport.FieldByName ('ValTotal').AsString);
              AddToTotals (
                StrToFloat (QryReport.FieldByName ('ValDiscount').AsString),
                ValTotalIdtPosTransaction,
                QryReport.FieldByName ('CodAction').AsString);
            end
            else if IdtPosTransaction <> IdtPosTransactionTotal then begin
              PrintTotalLine (CtCodTotLvlTicket);
              ValSubTotalIdtPosTransaction := 0;
              ValTotalIdtPosTransaction :=
                StrToFloat (QryReport.FieldByName ('ValTotal').AsString);
              FlgFirst := True;
              AddToTotals (
                StrToFloat (QryReport.FieldByName ('ValDiscount').AsString),
                ValTotalIdtPosTransaction,
                QryReport.FieldByName ('CodAction').AsString);
            end else
              AddToTotals (
                StrToFloat (QryReport.FieldByName ('ValDiscount').AsString), 0,
                QryReport.FieldByName ('CodAction').AsString);
          end;
        end;
      end;
    until QryReport.Eof or (FrmGenerate.ModalResult <> mrNone);
    if FrmGenerate.ModalResult = mrNone then begin
      PrintTotalLine (CtCodTotLvlTicket);
      PrintTotalLine (CtCodTotLvlOperator);
      PrintOverallTotalLine;
    end;
  end
  else begin
    VspPreview.Text := CtTxtNoData;
  end;
end;   // of TFrmVSRptDisCount.GenerateTableTicketBody

//=============================================================================
// TFrmVSRptDisCount.GenerateTableCustomerBody : generates the body of the table
// with the Customer view of the discounts.
//=============================================================================

procedure TFrmVSRptDisCount.GenerateTableCustomerBody;
var
  IdtPosTransaction: string;
  IdtCustomer      : string;
  FlgFirst         : Boolean;          // Flag First line of ticket
begin  // of TFrmVSRptDisCount.GenerateTableCustomerBody
  if not QryReport.IsEmpty then begin
    QryReport.First;
    IdtCustomer := QryReport.FieldByName ('IdtCustomer').AsString;
    IdtPostransaction := QryReport.FieldByName ('IdtPostransaction').AsString;
    FlgFirst := True;
    ValTotalIdtPosTransaction :=
      StrToFloat (QryReport.FieldByName ('ValTotal').AsString);
    AddToTotals (StrToFloat (QryReport.FieldByName ('ValDiscount').AsString),
                 ValTotalIdtPosTransaction,
                 QryReport.FieldByName ('CodAction').AsString);
    repeat
      CheckAbortGenerate;
      case FrmGenerate.ModalResult of
        mrAbort  :
          Abort;
        mrCancel :
          Break;
        mrNone   :
        begin
          PrintLineGeneral (FlgFirst);
          IdtPostransactionTotal := IdtPostransaction;
          IdtCustomerTotal := IdtCustomer;
          TxtNameCustomerTotal :=
            QryReport.FieldByName ('TxtNameCustomer').AsString;
          TxtCustCatTotal := QryReport.FieldByName ('TxtDescrCustCat').AsString;
          TxtIdtCheckoutTotal := QryReport.FieldByName ('IdtCheckout').AsString;
          TxtDatTransBeginTotal :=
            QryReport.FieldByName ('DatTransBegin').AsString;
          QryReport.Next;
          FrmGenerate.PgsBarBusy.StepIt;
          if not QryReport.Eof then begin
            IdtCustomer := QryReport.FieldByName ('IdtCustomer').AsString;
            IdtPostransaction :=
              QryReport.FieldByName ('IdtPostransaction').AsString;
            if IdtCustomer <> IdtCustomerTotal then begin
              PrintTotalLine (CtCodTotLvlTicket);
              ValSubTotalIdtPosTransaction := 0;
              PrintTotalLine (CtCodTotLvlCustomer);
              ValSubTotalIdtCustomer := 0;
              ValSubTotalCustomerPT := 0;
              FlgFirst := True;
              ValTotalIdtPosTransaction :=
                StrToFloat (QryReport.FieldByName ('ValTotal').AsString);
              AddToTotals (
                StrToFloat (QryReport.FieldByName ('ValDiscount').AsString),
                ValTotalIdtPosTransaction,
                QryReport.FieldByName ('CodAction').AsString);
            end
            else if IdtPosTransaction <> IdtPosTransactionTotal then begin
              PrintTotalLine (CtCodTotLvlTicket);
              ValSubTotalIdtPosTransaction := 0;
              FlgFirst := True;
              ValTotalIdtPosTransaction :=
                StrToFloat (QryReport.FieldByName ('ValTotal').AsString);
              AddToTotals (
                StrToFloat (QryReport.FieldByName ('ValDiscount').AsString),
                ValTotalIdtPosTransaction,
                QryReport.FieldByName ('CodAction').AsString);
            end else
              AddToTotals (
                StrToFloat (QryReport.FieldByName ('ValDiscount').AsString), 0,
                QryReport.FieldByName ('CodAction').AsString);
          end;
        end;
      end;
    until QryReport.Eof or (FrmGenerate.ModalResult <> mrNone);
    if FrmGenerate.ModalResult = mrNone then begin
      PrintTotalLine (CtCodTotLvlTicket);
      PrintTotalLine (CtCodTotLvlCustomer);
      PrintOverallTotalLine;
    end;
  end
  else begin
    VspPreview.Text := CtTxtNoData;
  end;
end;   // of TFrmVSRptDisCount.GenerateTableCustomerBody;

//=============================================================================
// TFrmVSRptDisCount.GenerateTablePersonnelBody : generates the body of the table
// with the Personnel view of the discounts.
//=============================================================================

procedure TFrmVSRptDisCount.GenerateTablePersonnelBody;
var
  IdtPosTransaction: string;
  IdtPersonnel     : string;
  FlgFirst         : Boolean;          // Flag First line of ticket
begin  // of TFrmVSRptDisCount.GenerateTablePersonnelBody
  if not QryReport.IsEmpty then begin
    QryReport.First;
    IdtPersonnel := QryReport.FieldByName ('IdtPersonnel').AsString;
    IdtPostransaction := QryReport.FieldByName ('IdtPostransaction').AsString;
    FlgFirst := True;
    ValTotalIdtPosTransaction :=
      StrToFloat (QryReport.FieldByName ('ValTotal').AsString);
    FlgFirst := True;
    AddToTotals (StrToFloat (QryReport.FieldByName ('ValDiscount').AsString),
                 ValTotalIdtPosTransaction,
                 QryReport.FieldByName ('CodAction').AsString);
    repeat
      CheckAbortGenerate;
      case FrmGenerate.ModalResult of
        mrAbort  :
          Abort;
        mrCancel :
          Break;
        mrNone   :
        begin
          PrintLineGeneral (FlgFirst);
          IdtPostransactionTotal := IdtPostransaction;
          IdtPersonnelTotal := IdtPersonnel;
          TxtNamePersonnelTotal :=
            QryReport.FieldByName ('TxtNamePers').AsString;
          TxtIdtCheckoutTotal := QryReport.FieldByName ('IdtCheckout').AsString;
          TxtDatTransBeginTotal :=
            QryReport.FieldByName ('DatTransBegin').AsString;
          QryReport.Next;
          FrmGenerate.PgsBarBusy.StepIt;
          if not QryReport.Eof then begin
            IdtPersonnel := QryReport.FieldByName ('IdtPersonnel').AsString;
            IdtPostransaction :=
              QryReport.FieldByName ('IdtPostransaction').AsString;
            if IdtPersonnel <> IdtPersonnelTotal then begin
              PrintTotalLine (CtCodTotLvlTicket);
              ValSubTotalIdtPosTransaction := 0;
              PrintTotalLine (CtCodTotLvlPersonnel);
              ValSubTotalIdtPersonnel := 0;
              ValSubTotalPersonnelPT := 0;
              FlgFirst := True;
              ValTotalIdtPosTransaction :=
                StrToFloat (QryReport.FieldByName ('ValTotal').AsString);
              AddToTotals (
                StrToFloat (QryReport.FieldByName ('ValDiscount').AsString),
                ValTotalIdtPosTransaction,
                QryReport.FieldByName ('CodAction').AsString);
            end
            else if IdtPosTransaction <> IdtPosTransactionTotal then begin
              PrintTotalLine (CtCodTotLvlTicket);
              ValSubTotalIdtPosTransaction := 0;
              FlgFirst := True;
              ValTotalIdtPosTransaction :=
                StrToFloat (QryReport.FieldByName ('ValTotal').AsString);
              AddToTotals (
                StrToFloat (QryReport.FieldByName ('ValDiscount').AsString),
                ValTotalIdtPosTransaction,
                QryReport.FieldByName ('CodAction').AsString);
            end else
              AddToTotals (
                StrToFloat (QryReport.FieldByName ('ValDiscount').AsString), 0,
                QryReport.FieldByName ('CodAction').AsString);
          end;
        end;
      end;
    until QryReport.Eof or (FrmGenerate.ModalResult <> mrNone);
    if FrmGenerate.ModalResult = mrNone then begin
      PrintTotalLine (CtCodTotLvlTicket);
      PrintTotalLine (CtCodTotLvlPersonnel);
      PrintOverallTotalLine;
    end;
  end
  else begin
    VspPreview.Text := CtTxtNoData;
  end;
end;   // of TFrmVSRptDisCount.GenerateTablePersonnelBody;

//=============================================================================
// TFrmVSRptDisCount.BuildSQL : Builds the SQL statement to retrieve
// the data to depending on the type of report
//=============================================================================

function TFrmVSRptDisCount.BuildSQL : string;
begin  // of TFrmVSRptDisCount.BuildSQL
  Result :=
    BuildSQLSelect +
    BuildSQLJoin +
    BuildSQLWhere +
    BuildSQLGroupBy +
    BuildSQLOrderBy;
end;  // of TFrmVSRptDisCount.BuildSQL

//=============================================================================
// TFrmVSRptDisCount.BuildSQLSelect : Builds the Select part of the SQL statement
// to retrieve the data to depending on the type of report
//=============================================================================

function TFrmVSRptDisCount.BuildSQLSelect : string;
begin  // of TFrmVSRptDisCount.BuildSQLSelect
  Result :=
        'SELECT ';
  case CodLayout of
    CtCodRptLayOutGlobal:
      Result := Result +
     #10'  CONVERT(VARCHAR(8),P.DatTransBegin,112) AS DatTicket,  ' +
     #10'  PDet.CodAction, ' +
     #10'  ValDiscount = COALESCE (SUM (-1 *PDet.ValInclVAT), 0)';
    CtCodRptLayOutOperator:
      Result := Result +
     #10'  P.IdtOperator, ' +
     #10'  Operator.TxtName, ' +
     #10'  PDet.CodAction, ' +
     #10'  ValDiscount = COALESCE (SUM (-1 *PDet.ValInclVAT), 0)';
    CtCodRptLayOutTicket:
    begin
      Result := Result +
     #10'  P.IdtOperator, ' +
     #10'  Operator.TxtName, ' +
     #10'  P.IdtPOSTransaction, ' +
     #10'  P.IdtCheckOut, ' +
     #10'  P.DatTransBegin, ' +
     #10'  ValTotal = COALESCE(( ' +
     #10'    SELECT TOP 1 ValInclVAT FROM POSTransDetail PDet4 (NOLOCK) ' +
     #10'     WHERE P.IdtPOSTransaction = PDet4.IdtPOSTransaction ' +
     #10'       AND P.IdtCheckOut = PDet4.IdtCheckOut ' +
     #10'       AND P.CodTrans = PDet4.CodTrans ' +
     #10'       AND P.DatTransBegin = PDet4.DatTransBegin' +
     #10'       AND PDet4.CodAction = 13 ' +
     #10'    ORDER BY NumLineReg DESC ' +
     #10'                      ), 0) ';
      if CodDetail = CtCodRptLinesTotalOnly then
        Result := Result + ', ' +
     #10'  ValDiscount = COALESCE (SUM (-1 *PDet.ValInclVAT), 0), ' +
     #10'  ' +  QuotedStr(' ') + ' AS IdtCustomer, ' +
     #10'  ' +  QuotedStr(' ') + ' AS TxtNameCustomer, ' +
     #10'  ' +  QuotedStr(' ') + ' AS IdtArticle, ' +
     #10'  ' +  QuotedStr(' ') + ' AS TxtDescr, ' +
     #10'  ' +  QuotedStr(' ') + ' AS QtyReg, ' +
     #10'  PDet.CodAction '
      else
        Result := Result + ', ' +
     #10'  ValDiscount = COALESCE (SUM (CASE WHEN PDet.CodAction = ' + IntToStr (CtCodActComment) +
     #10'                                    THEN PDet.PrcInclVAT ' +
     #10'                                    ELSE -1 * PDet.ValInclVAT ' +
     #10'                               END), 0), ' +
     #10'  PCust.IdtCustomer, ' +
     #10'  PCust.TxtName AS TxtNameCustomer, ' +
     #10'  PDet3.IdtArticle, ' +
     #10'  REPLACE(PDet3.TxtDescr,'';'','' '') AS TxtDescr, ' +
//     #10'  PDet3.TxtDescr, ' +
     #10'  SUM (PDet3.QtyReg) AS QtyReg, ' +
     #10'  CASE WHEN PDet.CodAction = ' + IntToStr (CtCodActComment) +
     #10'       THEN 60 ' +
     #10'       ELSE PDet.CodAction END AS CodAction ';
    end;
    CtCodRptLayOutCustomer :
    begin
      Result := Result +
     #10'  P.IdtOperator, ' +
     #10'  PCust.IdtPOSTransaction, ' +
     #10'  PCust.IdtCheckOut, ' +
     #10'  PCust.DatTransBegin, ' +
     #10'  PCust.IdtCustomer, ' +
     #10'  PCust.CodCustCard AS CodCustCategory, ' +
     #10'  PCust.TxtName AS TxtNameCustomer, ' +
     #10'  ValTotal = COALESCE(( ' +
     #10'    SELECT TOP 1 ValInclVAT FROM POSTransDetail PDet4 (NOLOCK) ' +
     #10'     WHERE PCust.IdtPOSTransaction = PDet4.IdtPOSTransaction ' +
     #10'       AND PCust.IdtCheckOut = PDet4.IdtCheckOut ' +
     #10'       AND PCust.CodTrans = PDet4.CodTrans ' +
     #10'       AND PCust.DatTransBegin = PDet4.DatTransBegin' +
     #10'       AND PDet4.CodAction = 13 ' +
     #10'    ORDER BY NumLineReg DESC ' +
     #10'                      ), 0), '+
     #10'  APCustCat.TxtChcLong AS TxtDescrCustCat ';
      if CodDetail = CtCodRptLinesTotalOnly then
        Result := Result + ', ' +
     #10'  ValDiscount = COALESCE (SUM (-1 *PDet.ValInclVAT), 0), ' +
     #10'  ' +  QuotedStr(' ') + ' AS IdtArticle, ' +
     #10'  ' +  QuotedStr(' ') + ' AS TxtDescr, ' +
     #10'  ' +  QuotedStr(' ') + ' AS QtyReg, ' +
     #10'  PDet.CodAction '
      else
        Result := Result + ', ' +
     #10'  ValDiscount = COALESCE (SUM (CASE WHEN PDet.CodAction = ' + IntToStr (CtCodActComment) +
     #10'                                    THEN PDet.PrcInclVAT ' +
     #10'                                    ELSE -1 * PDet.ValInclVAT ' +
     #10'                               END), 0), ' +
     #10'  PDet3.IdtArticle, ' +
     #10'  REPLACE(PDet3.TxtDescr,'';'','' '') AS TxtDescr, ' +
     //#10'  PDet3.TxtDescr, ' +
     #10'  SUM (PDet3.QtyReg) AS QtyReg, ' +
     #10'  CASE WHEN PDet.CodAction = ' + IntToStr (CtCodActComment) +
     #10'       THEN 60 ' +
     #10'       ELSE PDet.CodAction END AS CodAction ';
    end;
    CtCodRptLayOutPersonnel :
    begin
      Result := Result +
     #10'  P.IdtOperator, ' +
     #10'  P.IdtPOSTransaction, ' +
     #10'  P.IdtCheckOut, ' +
     #10'  P.DatTransBegin, ' +
     #10'  P.IdtPersonnel, ' +
     #10'  ' +  QuotedStr(' ') + ' AS CodCustCategory, ' +
     #10'  P.TxtNamePers, ' +
     #10'  ValTotal = COALESCE(( ' +
     #10'    SELECT TOP 1 ValInclVAT FROM POSTransDetail PDet4 (NOLOCK) ' +
     #10'     WHERE P.IdtPOSTransaction = PDet4.IdtPOSTransaction ' +
     #10'       AND P.IdtCheckOut = PDet4.IdtCheckOut ' +
     #10'       AND P.CodTrans = PDet4.CodTrans ' +
     #10'       AND P.DatTransBegin = PDet4.DatTransBegin' +
     #10'       AND PDet4.CodAction = 13 ' +
     #10'    ORDER BY NumLineReg DESC ' +
     #10'                      ), 0) ';
      if CodDetail = CtCodRptLinesTotalOnly then
        Result := Result + ', ' +
     #10'  ValDiscount = COALESCE (SUM (-1 *PDet.ValInclVAT), 0), ' +
     #10'  ' +  QuotedStr(' ') + ' AS IdtArticle, ' +
     #10'  ' +  QuotedStr(' ') + ' AS TxtDescr, ' +
     #10'  ' +  QuotedStr(' ') + ' AS QtyReg, ' +
     #10'  PDet.CodAction '
      else
        Result := Result + ', ' +
     #10'  ValDiscount = COALESCE (SUM (CASE WHEN PDet.CodAction = ' + IntToStr (CtCodActComment) +
     #10'                                    THEN PDet.PrcInclVAT ' +
     #10'                                    ELSE -1 * PDet.ValInclVAT ' +
     #10'                               END), 0), ' +
     #10'  PDet3.IdtArticle, ' +
     #10'  REPLACE(PDet3.TxtDescr,'';'','' '') AS TxtDescr, ' +
     //#10'  PDet3.TxtDescr, ' +
     #10'  SUM (PDet3.QtyReg) AS QtyReg, ' +
     #10'  CASE WHEN PDet.CodAction = ' + IntToStr (CtCodActComment) +
     #10'       THEN 60 ' +
     #10'       ELSE PDet.CodAction END AS CodAction ';
    end;
  end;
  Result := Result + ',' +
     #10'  ApplicDescr.TxtChcLong AS TxtDescrDiscount ';
  case CodLayout of
    CtCodRptLayOutGlobal,
    CtCodRptLayOutOperator,
    CtCodRptLayOutTicket,
    CtCodRptLayOutPersonnel:
      Result := Result +
     #10'FROM POSTransaction P (NOLOCK)';
    CtCodRptLayOutCustomer :
      Result := Result +
     #10'FROM POSTransCust PCust (NOLOCK)';
  end;

end;  // of TFrmVSRptDisCount.BuildSQLSelect

//=============================================================================
// TFrmVSRptDisCount.BuildSQLJoin : Builds the Join part of the SQL statement
// to retrieve the data to depending on the type of report
//=============================================================================

function TFrmVSRptDisCount.BuildSQLJoin : string;
begin  // of TFrmVSRptDisCount.BuildSQLJoin
  case CodLayout of
    CtCodRptLayOutCustomer :
      Result := Result +
     #10'INNER JOIN POSTransaction P (NOLOCK) ' +
     #10'   ON P.IdtPOSTransaction = PCust.IdtPOSTransaction' +
     #10'  AND P.IdtCheckOut = PCust.IdtCheckOut ' +
     #10'  AND P.CodTrans = PCust.CodTrans ' +
     #10'  AND P.DatTransBegin = PCust.DatTransBegin ' +
     #10'LEFT OUTER JOIN ApplicDescr APCustCat (NOLOCK) ' +
     #10'             ON APCustCat.IdtApplicConv = ' +
                         QuotedStr (CtCodCustCategoryField) +
     #10'            AND APCustCat.TxtTable = ' +
                         QuotedStr (ctCodDisCountTypeTable) +
     #10'            AND APCustCat.TxtFldCode = PCust.CodCustCard ' +
     #10'            AND APCustCat.IdtLanguage = ' +
                         QuotedStr (DmdFpnUtils.IdtLanguageTradeMatrix);
  end;
  Result := Result +
     #10'INNER JOIN POSTransDetail PDet (NOLOCK) ' +
     #10'   ON P.IdtPOSTransaction = PDet.IdtPOSTransaction ' +
     #10'  AND P.IdtCheckOut = PDet.IdtCheckOut ' +
     #10'  AND P.CodTrans = PDet.CodTrans ' +
     #10'  AND P.DatTransBegin = PDet.DatTransBegin ' +
     #10'LEFT OUTER JOIN ApplicDescr (NOLOCK) ' +
     #10'             ON ApplicDescr.IdtApplicConv = ' +
                         QuotedStr (ctCodDisCountTypeField) +
     #10'            AND ApplicDescr.TxtTable = ' +
                         QuotedStr (ctCodDisCountTypeTable) +
     #10'            AND ApplicDescr.TxtFldCode = PDet.CodAction ' +
     #10'            AND ApplicDescr.IdtLanguage = ' +
                         QuotedStr (DmdFpnUtils.IdtLanguageTradeMatrix);
  case CodLayout of
    CtCodRptLayOutGlobal :
      ;
    CtCodRptLayOutOperator :
      Result := Result +
     #10'LEFT OUTER JOIN Operator (NOLOCK) ' +
     #10'             ON Operator.IdtPOS = P.IdtOperator ';
    CtCodRptLayOutTicket :
    begin
      Result := Result +
     #10'LEFT OUTER JOIN Operator (NOLOCK) ' +
     #10'             ON Operator.IdtPOS = P.IdtOperator ';
      if (CodDetail in [CtCodRptLinesDetailOnly, CtCodRptLinesAll]) then
        Result := Result +
     #10'LEFT OUTER JOIN POSTransDetail PDet3 (NOLOCK) ' +
     #10'             ON P.IdtPOSTransaction = PDet3.IdtPOSTransaction ' +
     #10'            AND P.IdtCheckOut = PDet3.IdtCheckOut ' +
     #10'            AND P.CodTrans = PDet3.CodTrans ' +
     #10'            AND P.DatTransBegin = PDet3.DatTransBegin ' +
     #10'            AND PDet.NumLineReg = PDet3.NumLineReg ' +
     #10'            AND PDet.NumSeq <> PDet3.NumSeq ' +
     #10'            AND PDet3.CodAction = 1 ' +
     #10'LEFT OUTER JOIN POSTransCust PCust (NOLOCK) ' +
     #10'             ON P.IdtPOSTransaction = PCust.IdtPOSTransaction ' +
     #10'            AND P.IdtCheckOut = PCust.IdtCheckOut ' +
     #10'            AND P.CodTrans = PCust.CodTrans ' +
     #10'            AND P.DatTransBegin = PCust.DatTransBegin ';
    end;
    CtCodRptLayOutCustomer,
    CtCodRptLayOutPersonnel:
    begin
      if (CodDetail in [CtCodRptLinesDetailOnly, CtCodRptLinesAll]) then
        Result := Result +
     #10'LEFT OUTER JOIN POSTransDetail PDet3 (NOLOCK) ' +
     #10'             ON P.IdtPOSTransaction = PDet3.IdtPOSTransaction ' +
     #10'            AND P.IdtCheckOut = PDet3.IdtCheckOut ' +
     #10'            AND P.CodTrans = PDet3.CodTrans ' +
     #10'            AND P.DatTransBegin = PDet3.DatTransBegin ' +
     #10'            AND PDet.NumLineReg = PDet3.NumLineReg ' +
     #10'            AND PDet.NumSeq <> PDet3.NumSeq ' +
     #10'            AND PDet3.CodAction = 1 ';
    end;
  end;
end;  // of TFrmVSRptDisCount.BuildSQLJoin

//=============================================================================
// TFrmVSRptDisCount.BuildSQLWhere : Builds the Where part of the SQL statement
// to retrieve the data to depending on the type of report
//=============================================================================

function TFrmVSRptDisCount.BuildSQLWhere : string;
begin  // of TFrmVSRptDisCount.BuildSQLWhere
  Result :=
     #10'WHERE P.IdtPosTransaction <> 0 ' +
     #10'  AND ISNULL(P.IdtOperator,' +
           QuotedStr(' ') + ') IN (' + StrLstOperators.CommaText + ') ' +
     #10'  AND P.DatTransBegin >= '   +       
           QuotedStr (FormatDateTime ('yyyymmdd', DtmFromDate)) +
     #10'  AND P.DatTransBegin <  '   +
           QuotedStr (FormatDateTime ('yyyymmdd', DtmToDate + 1)) +
     #10'  AND P.FlgTraining = 0 ' +
     #10'  AND P.CodState = 4 ' +
     #10'  AND P.CodReturn IS NULL ';
  if CodLayout = CtCodRptLayOutCustomer then begin
    Result := Result +
     #10'  AND PCust.DatTransBegin >= '   +
           QuotedStr (FormatDateTime ('yyyymmdd', DtmFromDate)) +
     #10'  AND PCust.DatTransBegin <  '   +
           QuotedStr (FormatDateTime ('yyyymmdd', DtmToDate + 1)) +
     #10'  AND PCust.CodCustCard IN  (' + StrLstCustCategories.CommaText + ') ';
    if IdtCustPers <> 0 then
      Result := Result +
     #10'  AND ISNULL(PCust.IdtCustomer,' +
           QuotedStr('') + ') = ' + QuotedStr (IntToStr (IdtCustPers))
    else
      Result := Result +
     #10'  AND ISNULL(PCust.IdtCustomer,' +
           QuotedStr('') + ') <> ' + QuotedStr ('');
  end;
  if CodLayout = CtCodRptLayOutPersonnel then begin
    if IdtCustPers <> 0 then
      Result := Result +
     #10'  AND ISNULL(P.IdtPersonnel,' +
           QuotedStr('') + ') = ' + QuotedStr (IntToStr (IdtCustPers))
    else
      Result := Result +
     #10'  AND ISNULL(P.IdtPersonnel,' +
           QuotedStr('') + ') <> ' + QuotedStr ('');
  end;
  if (CodDetail in [CtCodRptLinesAll, CtCodRptLinesDetailOnly]) and
     (CodLayout in [CtCodRptLayOutTicket, CtCodRptLayOutCustomer,
                    CtCodRptLayOutPersonnel]) and
     (StrLstDiscountTypes.IndexOf (IntToStr (CtCodActDiscPers)) <> -1) then
        Result := Result +
     #10'  AND (PDet.CodAction IN (' + StrLstDiscountTypes.CommaText + ') ' +
     #10'       OR ' +
     #10'       (PDet.CodAction = ' + IntToStr (CtCodActComment) +
     #10'        AND ' +
     #10'        PDet.CodType = ' + IntToStr (CtCodPdtCommentDiscPers) + ')) '
  else
    Result := Result +
     #10'  AND PDet.CodAction IN (' + StrLstDiscountTypes.CommaText + ') ';
  Result := Result +
     #10'  AND NOT EXISTS( ' +
     #10'      SELECT * FROM POSTransDetail PDet1 (NOLOCK) ' +
     #10'       WHERE P.IdtPOSTransaction = PDet1.IdtPOSTransaction ' +
     #10'         AND P.IdtCheckOut = PDet1.IdtCheckOut ' +
     #10'         AND P.CodTrans = PDet1.CodTrans ' +
     #10'         AND P.DatTransBegin = PDet1.DatTransBegin ' +
     #10'         AND PDet1.CodAction = 86) ' +
     #10'  AND NOT EXISTS( ' +
     #10'      SELECT * FROM POSTransDetail PDet2 (NOLOCK) ' +
     #10'       WHERE P.IdtPOSTransaction = PDet2.IdtPOSTransaction ' +
     #10'         AND P.IdtCheckOut = PDet2.IdtCheckOut ' +
     #10'         AND P.CodTrans = PDet2.CodTrans ' +
     #10'         AND P.DatTransBegin = PDet2.DatTransBegin ' +
     #10'         AND PDet.NumLineReg = PDet2.NumLineReg ' +
     #10'         AND PDet.NumSeq <> PDet2.NumSeq ' +
     #10'         AND (PDet2.CodAnnul IS NOT NULL ' +
     #10'              OR ' +
     #10'              PDet2.CodAction IN (6,7) ' +
     #10'             ) ' +
     #10'      )';
end;  // of TFrmVSRptDisCount.BuildSQLWhere

//=============================================================================
// TFrmVSRptDisCount.BuildSQLGroupBy : Builds the GroupBy part of the SQL statement
// to retrieve the data to depending on the type of report
//=============================================================================

function TFrmVSRptDisCount.BuildSQLGroupBy : string;
begin  // of TFrmVSRptDisCount.BuildSQLGroupBy
  Result := '';
  case CodLayout of
    CtCodRptLayOutGlobal :
      Result := Result +
       #10'GROUP BY CONVERT(VARCHAR(8),P.DatTransBegin,112), ' +
       #10'         PDet.CodAction, ' +
       #10'         ApplicDescr.TxtChcLong';
    CtCodRptLayOutOperator :
      Result := Result +
       #10'GROUP BY P.IdtOperator, ' +
       #10'         PDet.CodAction, ' +
       #10'         ApplicDescr.TxtChcLong, ' +
       #10'         Operator.TxtName ';
    CtCodRptLayOutTicket :
      if CodDetail = CtCodRptLinesTotalOnly then
        Result := Result +
       #10'GROUP BY P.IdtOperator, ' +
       #10'         P.DatTransBegin, ' +
       #10'         P.IdtPosTransaction, ' +
       #10'         P.IdtCheckOut, ' +
       #10'         P.CodTrans, ' +
       #10'         PDet.CodAction, ' +
       #10'         Operator.TxtName, ' +
       #10'         ApplicDescr.TxtChcLong '
      else
        Result := Result +
       #10'GROUP BY P.IdtOperator, ' +
       #10'         P.DatTransBegin, ' +
       #10'         P.IdtPosTransaction, ' +
       #10'         P.IdtCheckOut, ' +
       #10'         P.CodTrans, ' +
       #10'         PDet.CodAction, ' +
       #10'         PDet3.IdtArticle, ' +
       #10'         Operator.TxtName, ' +
       #10'         PCust.IdtCustomer, ' +
       #10'         PCust.TxtName, ' +
       #10'         REPLACE(PDet3.TxtDescr,'';'','' ''), ' +
       #10'         ApplicDescr.TxtChcLong ';
    CtCodRptLayOutCustomer :
      if CodDetail = CtCodRptLinesTotalOnly then
        Result := Result +
       #10'GROUP BY PCust.IdtCustomer, ' +
       #10'         PCust.DatTransBegin, ' +
       #10'         PCust.IdtPOSTransaction, ' +
       #10'         PCust.IdtCheckOut, ' +
       #10'         PCust.CodTrans, ' +
       #10'         PDet.CodAction, ' +
       #10'         PCust.TxtName, ' +
       #10'         ApplicDescr.TxtChcLong, ' +
       #10'         PCust.CodCustCard, ' +
       #10'         APCustCat.TxtChcLong, ' +
       #10'         P.IdtOperator '
      else
        Result := Result +
       #10'GROUP BY PCust.IdtCustomer, ' +
       #10'         PCust.DatTransBegin, ' +
       #10'         PCust.IdtPOSTransaction, ' +
       #10'         PCust.IdtCheckOut, ' +
       #10'         PCust.CodTrans, ' +
       #10'         PDet.CodAction, ' +
       #10'         PDet3.IdtArticle, ' +
       #10'         PCust.TxtName, ' +
       #10'         REPLACE(PDet3.TxtDescr,'';'','' ''), ' +
       #10'         ApplicDescr.TxtChcLong, ' +
       #10'         P.IdtOperator, ' +
       #10'         PCust.CodCustCard, ' +
       #10'         APCustCat.TxtChcLong ';
    CtCodRptLayOutPersonnel :
      if CodDetail = CtCodRptLinesTotalOnly then
        Result := Result +
       #10'GROUP BY P.IdtPersonnel, ' +
       #10'         P.DatTransBegin, ' +
       #10'         P.IdtPOSTransaction, ' +
       #10'         P.IdtCheckOut, ' +
       #10'         P.CodTrans, ' +
       #10'         PDet.CodAction, ' +
       #10'         P.TxtNamePers, ' +
       #10'         ApplicDescr.TxtChcLong, ' +
       #10'         P.IdtOperator '
      else
        Result := Result +
       #10'GROUP BY P.IdtPersonnel, ' +
       #10'         P.DatTransBegin, ' +
       #10'         P.IdtPOSTransaction, ' +
       #10'         P.IdtCheckOut, ' +
       #10'         P.CodTrans, ' +
       #10'         P.IdtOperator, ' +
       #10'         PDet.CodAction, ' +
       #10'         PDet3.IdtArticle, ' +
       #10'         P.TxtNamePers, ' +
       #10'         REPLACE(PDet3.TxtDescr,'';'','' ''), ' +
       #10'         ApplicDescr.TxtChcLong ';
  end;
end;  // of TFrmVSRptDisCount.BuildSQLGroupBy

//=============================================================================
// TFrmVSRptDisCount.BuildSQLOrderBy : Builds the orderBy part of the SQL statement
// to retrieve the data to depending on the type of report
//=============================================================================

function TFrmVSRptDisCount.BuildSQLOrderBy : string;
begin  // of TFrmVSRptDisCount.BuildSQLOrderBy
  Result := '';
  case CodLayout of
    CtCodRptLayOutGlobal   :
        Result := Result +
       #10'ORDER BY CONVERT(VARCHAR(8), P.DatTransBegin,112), ' +
       #10'         PDet.CodAction';
    CtCodRptLayOutOperator :
        Result := Result +
       #10'ORDER BY P.IdtOperator, ' +
       #10'         PDet.CodAction';
    CtCodRptLayOutTicket   :
      if CodDetail = CtCodRptLinesTotalOnly then
        Result := Result +
       #10'ORDER BY P.IdtOperator, ' +
       #10'         P.DatTransBegin, ' +
       #10'         P.IdtPOSTransaction, ' +
       #10'         P.IdtCheckOut, ' +
       #10'         P.CodTrans '
      else
        Result := Result +
       #10'ORDER BY P.IdtOperator, ' +
       #10'         P.DatTransBegin, ' +
       #10'         P.IdtPOSTransaction, ' +
       #10'         P.IdtCheckOut, ' +
       #10'         P.CodTrans, ' +
       #10'         PDet.CodAction, ' +
       #10'         PDet3.IdtArticle ';
    CtCodRptLayOutCustomer :
      if CodDetail = CtCodRptLinesTotalOnly then
        Result := Result +
       #10'ORDER BY PCust.IdtCustomer, ' +
       #10'         PCust.DatTransBegin, ' +
       #10'         PCust.IdtPOSTransaction, ' +
       #10'         PCust.IdtCheckOut, ' +
       #10'         PCust.CodTrans, ' +
       #10'         PDet.CodAction '
       else
         Result := Result +
       #10'ORDER BY PCust.IdtCustomer, ' +
       #10'         PCust.DatTransBegin, ' +
       #10'         PCust.IdtPOSTransaction, ' +
       #10'         PCust.IdtCheckOut, ' +
       #10'         PCust.CodTrans, ' +
       #10'         PDet.CodAction, ' +
       #10'         PDet3.IdtArticle ';
    CtCodRptLayOutPersonnel :
      if CodDetail = CtCodRptLinesTotalOnly then
        Result := Result +
       #10'ORDER BY P.IdtPersonnel, ' +
       #10'         P.DatTransBegin, ' +
       #10'         P.IdtPOSTransaction, ' +
       #10'         P.IdtCheckOut, ' +
       #10'         P.CodTrans, ' +
       #10'         PDet.CodAction '
       else
         Result := Result +
       #10'ORDER BY P.IdtPersonnel, ' +
       #10'         P.DatTransBegin, ' +
       #10'         P.IdtPOSTransaction, ' +
       #10'         P.IdtCheckOut, ' +
       #10'         P.CodTrans, ' +
       #10'         PDet.CodAction, ' +
       #10'         PDet3.IdtArticle ';
  end;
end;  // of TFrmVSRptDisCount.BuildSQLOrderBy

//=============================================================================
// TFrmVSRptTndCount.PrintReportHeader : prints the header of the report.
//=============================================================================

procedure TFrmVSRptDiscount.PrintReportHeader;
begin  // of TFrmVSRptTndCount.PrintReportHeader
  DrawLogo (PicLogo);
  PrintPageHeader;
  // Save Y-position at end of header
  ValPosYEndHdr := VspPreview.CurrentY;
  // Calculate Y-position for Address to align it with bottom of header
  VspPreview.CurrentY := ValPosYEndHdr - (4 * CalcTextHei);
  if VspPreview.CurrentY < ValOrigMarginTop then
    VspPreview.CurrentY := ValOrigMarginTop;
  // Print Address TradeMatrix
  PrintAddress;
  // Print Legend
  PrintLegend;
  // Calculate Y-position to start report
  if VspPreview.Orientation =  orPortrait then
    VspPreview.CurrentY := Max (CtStartPosTablePT, VspPreview.CurrentY)
  else
    VspPreview.CurrentY := Max (CtStartPosTableLS, VspPreview.CurrentY);
  // Save Y-position at end of header
  ValPosYEndHdr := VspPreview.CurrentY;
end;   // of TFrmVSRptTndCount.PrintReportHeader

//=============================================================================
// TFrmVSRptTndCount.PrintPageHeader : prints the header of the page
//=============================================================================

procedure TFrmVSRptDiscount.PrintPageHeader;
var
  ViValFontSave    : Variant;          // Save original FontSize
  FlgValFontBoldSave    : Boolean;     // Save original bold flag
begin  // of TFrmVSRptDiscount.PrintPageHeader
  ViValFontSave := VspPreview.FontSize;
  FlgValFontBoldSave := VspPreview.FontBold;
  try
    // Header report
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.CurrentY := ValOrigMarginTop;
    VspPreview.FontSize := ViValFontHeader;
    VspPreview.FontBold := True;
    VspPreview.Text := CtTxtHdrRptCount + ' ' + TxtReportTitle;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    // Additional info
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.FontSize := ViValFontSubTitle;
    VspPreview.Text  :=
      Format (CtTxtReportDate,
              [FormatDateTime (CtTxtDatFormat, DtmFromDate),
              FormatDateTime (CtTxtDatFormat, DtmToDate)]);
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
  finally
    VspPreview.Fontsize := ViValFontSave;
    VspPreview.FontBold := FlgValFontBoldSave;
  end;
end;   // of TFrmVSRptDiscount.PrintPageHeader

//=============================================================================
// TFrmVSRptDiscount.PrintAddress : prints the address of the TradeMatrix.
//=============================================================================

procedure TFrmVSRptDiscount.PrintAddress;
var
  ViValFontSave    : Variant;          // Save original FontSize
  FlgValFontBoldSave    : Boolean;     // Save original bold flag
  ValPosXAddress   : Integer;
begin  // of TFrmVSRptDiscount.PrintAddress
  ViValFontSave := VspPreview.FontSize;
  FlgValFontBoldSave := VspPreview.FontBold;
  try
    VspPreview.FontBold := False;
    VspPreview.FontSize := ViValFontAddress;
    if VspPreview.Orientation = orPortrait then
      ValPosXAddress := ViValPosXAddressPT
    else
      ValPosXAddress := ViValPosXAddressLS;
    // Name
    VspPreview.CurrentX := ValPosXAddress;
    VspPreview.Text     := DmdFpnUtils.TradeMatrixName;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
      // Street
    VspPreview.CurrentX := ValPosXAddress;
    VspPreview.Text     := DmdFpnTradeMatrix.InfoTradeMatrix
                             [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtStreet'];
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
      // Place
    VspPreview.CurrentX := ValPosXAddress;
    VspPreview.Text     := DmdFpnTradeMatrix.InfoTradeMatrix
                             [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] +
                           ' ' +
                           DmdFpnTradeMatrix.InfoTradeMatrix
                             [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'];
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
      // Idt
    VspPreview.CurrentX := ValPosXAddress;
    VspPreview.Text     := DmdFpnUtils.IdtTradeMatrixAssort;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    VspPreview.CurrentX := VspPreview.MarginLeft;
  finally
    VspPreview.Fontsize := ViValFontSave;
    VspPreview.FontBold := FlgValFontBoldSave;
  end;
end;   // of TFrmVSRptDiscount.PrintAddress

//=============================================================================
// TFrmVSRptDiscount.PrintLegend : prints the legenda
//=============================================================================

procedure TFrmVSRptDiscount.PrintLegend;
var
  TxtOperators     : string;           // Operators
  TxtDiscountTypes : string;           // DiscountTypes
  TxtCustomerCategories : string;      // Customer categories;
  TxtLegend        : string;
  Cnt              : Integer;          // Counter
  ViValFontSave    : Variant;          // Save original FontSize
  FlgValFontBoldSave    : Boolean;     // Save original bold flag
begin  // of TFrmVSRptDiscount.PrintLegend
  ViValFontSave := VspPreview.FontSize;
  FlgValFontBoldSave := VspPreview.FontBold;
  try
    VspPreview.FontBold := False;
    VspPreview.FontSize := ViValFontSubTitle;
    // Operators
    VspPreview.CurrentX := VspPreview.Marginleft;
    TxtLegend := '';
    TxtOperators := CtTxtRptOperators + ': ';
    for Cnt:= 0 to StrLstOperators.Count - 1 do begin
      if TextWidthInTwips (TxtOperators +
           UnquotedStr (StrLstOperators[Cnt]) + '999') <
         ReportWidthInTwips then begin
        if (TxtOperators <> '') and (Cnt > 0) then
          TxtOperators := TxtOperators + ',';
        TxtOperators := TxtOperators + UnquotedStr (StrLstOperators[Cnt]);
      end
      else begin
        TxtLegend := TxtLegend + TxtOperators + #10;
        TxtOperators := UnquotedStr (StrLstOperators[Cnt]);
      end;
    end;
    TxtLegend := TxtLegend + TxtOperators + #10;

    // DiscountTypes
    TxtDiscountTypes := CtTxtRptDiscountTypes + ': ';
    for Cnt:= 0 to StrLstDiscountTypes.Count - 1 do begin
      if TextWidthInTwips (TxtDiscountTypes +
           TDiscountTotal (StrLstDiscountTypes.Objects[Cnt]).Descr + 'MMM') <
         ReportWidthInTwips then begin
        if (TxtDiscountTypes <> '') and (Cnt > 0) then
          TxtDiscountTypes := TxtDiscountTypes + ',';
        TxtDiscountTypes := TxtDiscountTypes +
          TDiscountTotal (StrLstDiscountTypes.Objects[Cnt]).Descr;
      end
      else begin
        TxtLegend := TxtLegend + TxtDiscountTypes + #10;
        TxtDiscountTypes :=
          TDiscountTotal (StrLstDiscountTypes.Objects[Cnt]).Descr;
      end;
    end;
    TxtLegend := TxtLegend + TxtDiscountTypes + #10;

    // Customer categories
    if CodLayout = CtCodRptLayOutCustomer then begin
      TxtCustomerCategories := CtTxtRptCustomerCategories + ': ';
      for Cnt:= 0 to StrLstCustCategories.Count - 1 do begin
        if TextWidthInTwips (TxtCustomerCategories +
             TDiscountTotal (StrLstCustCategories.Objects[Cnt]).Descr + 'MMM') <
           ReportWidthInTwips then begin
          if (TxtCustomerCategories <> '') and (Cnt > 0) then
            TxtCustomerCategories := TxtCustomerCategories + ',';
          TxtCustomerCategories := TxtCustomerCategories +
            TDiscountTotal (StrLstCustCategories.Objects[Cnt]).Descr;
        end
        else begin
          TxtLegend := TxtLegend + TxtCustomerCategories + #10;
          TxtCustomerCategories :=
            TDiscountTotal (StrLstCustCategories.Objects[Cnt]).Descr;
        end;
      end;
      TxtLegend := TxtLegend + TxtCustomerCategories + #10;
    end;
    VspPreview.Text := TxtLegend;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
  finally
    VspPreview.Fontsize := ViValFontSave;
    VspPreview.FontBold := FlgValFontBoldSave;
  end;
end;   // of TFrmVSRptDiscount.PrintLegend

//=============================================================================
// TFrmVSRptDiscount.CalcTextHei : calculates VspPreview.TextHei for a single
// line in the current font.
//                                  -----
// FUNCRES : calculated TextHei.
//=============================================================================

function TFrmVSRptDiscount.CalcTextHei : Double;
begin  // of TFrmVSRptDiscount.CalcTextHei
  VspPreview.X1 := 0;
  VspPreview.Y1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y2 := 0;

  VspPreview.CalcParagraph := 'X';
  Result := VspPreview.TextHei;
end;   // of TFrmVSRptDiscount.CalcTextHei

//=============================================================================
// TFrmVSRptDiscount.PrintTableLine : adds the line to the current Table.
//                                  -----
// INPUT   : TxtLine = line to add to the Table.
//=============================================================================

procedure TFrmVSRptDiscount.PrintTableLine (TxtLine : string; NumTotLvl : Integer);
var FlgValFontBoldSave  : Boolean;     // Save Bold flag
begin  // of TFrmVSRptDiscount.PrintTableLine
  if NumTotLvl > -1 then begin
    FlgValFontBoldSave := VspPreview.FontBold;
    VspPreview.FontBold := True;
    VspPreview.AddTable (TxtTableFmt, '', TxtLine,
                         ViColHeader, CtArrSubTotalShades[NumTotLvl], null);
    VspPreview.FontBold := FlgValFontBoldSave;
  end else
    VspPreview.AddTable (TxtTableFmt, '', TxtLine,
                         ViColHeader, ViColBody, null);
  Inc (QtyLinesPrinted);
end;   // of TFrmVSRptDiscount.PrintTableLine

//=============================================================================
// TFrmVSRptDiscount.FldToDate : converts a date string of the form yyyymmdd
// to a TDatetime value
//                                  -----
// INPUT   : TxtDate = string to convert
//                                  -----
// OUTPUT  : TDateTime Value
//=============================================================================

function TFrmVSRptDiscount.FldToDate (TxtDat : string) : TDateTime;
begin  // of TFrmVSRptDiscount.FldToDate
  Result := EncodeDate (
              StrToIntDef (Copy (TxtDat, 1, 4), 1),
              StrToIntDef (Copy (TxtDat, 5, 2), 1),
              StrToIntDef (Copy (TxtDat, 7, 2), 1));
end;   // of TFrmVSRptDiscount.FldToDate

//=============================================================================
// TFrmVSRptDiscount.AppendFmtAndHdr : appends the format and header
// for a column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//           ChrAlign = Alignment character
//           NumWidth = width in characters
//=============================================================================

procedure TFrmVSRptDiscount.AppendFmtAndHdr (TxtHdr   : string;
                                             ChrAlign : Char;
                                             NumWidth : Integer);
begin  // of TFrmVSRptDiscount.AppendFmtAndHdrNumber
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [ChrAlign,
                          ColumnWidthInTwips(CharStrW('0', NumWidth))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptDiscount.AppendFmtAndHdrDescr

//=============================================================================
// TFrmVSRptDiscount.AppendFmtAndHdrDescr : appends the format and header
// for a Description-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptDiscount.AppendFmtAndHdrDescr (TxtHdr : string);
begin  // of TFrmVSRptDiscount.AppendFmtAndHdrDescr
  AppendFmtAndHdr (TxtHdr, FormatAlignLeft, ViValRptWidthDescr);
end;   // of TFrmVSRptDiscount.AppendFmtAndHdrDescr

//=============================================================================
// TFrmVSRptDiscount.AppendFmtAndHdrNumber : appends the format and header
// for a Number-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptDiscount.AppendFmtAndHdrNumber (TxtHdr : string);
begin  // of TFrmVSRptDiscount.AppendFmtAndHdrNumber
  AppendFmtAndHdr (TxtHdr, FormatAlignRight, ViValRptWidthNumber);
end;   // of TFrmVSRptDiscount.AppendFmtAndHdrNumber

//=============================================================================
// TFrmVSRptDiscount.AppendFmtAndHdrQuantity : appends the format and header
// for a quantity-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptDiscount.AppendFmtAndHdrQuantity (TxtHdr : string);
begin  // of TFrmVSRptDiscount.AppendFmtAndHdrQuantity
  AppendFmtAndHdr (TxtHdr, FormatAlignRight, ViValRptWidthQty);
end;   // of TFrmVSRptDiscount.AppendFmtAndHdrQuantity

//=============================================================================
// TFrmVSRptDiscount.AppendFmtAndHdrAmount : appends the format and header
// for an amount-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptDiscount.AppendFmtAndHdrAmount (TxtHdr : string);
begin  // of TFrmVSRptDiscount.AppendFmtAndHdrAmount
  AppendFmtAndHdr (TxtHdr, FormatAlignRight, ViValRptWidthAmount);
end;   // of TFrmVSRptDiscount.AppendFmtAndHdrAmount

//=============================================================================
// TFrmRptCfgArtHisCmp.PrintReport : prints the report
//=============================================================================

procedure TFrmVSRptDiscount.PrintReport;
begin  // of TFrmVSRptDiscount..PrintReport
  Visible := True;
  Visible := False;
  try
    InitializeBeforeGenerateReport;
    VspPreview.StartDoc;
    try
      PrepareReport;
      GenerateReport;
    finally
      VspPreview.EndDoc;
      AddFooterToPages;
    end;
  finally
    QryReport.Active := False;
  end;
end;   // of TFrmRptCfgArtHisCmp.PrintReport

//=============================================================================

procedure TFrmVSRptDiscount.PrepareReport;
begin  // of TFrmVSRptDiscount.PrepareReport
  // Create progress form
  CreateFormGenerate;
  try
    FrmGenerate.BtnAbort.Visible := False;
    FrmGenerate.Show;
    Application.ProcessMessages;
    QryReport.SQL.Clear;
    QryReport.SQL.Text := BuildSQL;
    QryReport.Active := True;
  finally
    frmGenerate.Hide;
    frmGenerate.Release;
    Application.ProcessMessages;
  end;
end;   // of TFrmRptCfgArtHisCmp.PrepareReport

//=============================================================================
// TFrmVSRptDiscount.GenerateReport : generates the report.
//=============================================================================

procedure TFrmVSRptDiscount.GenerateReport;
begin  // of TFrmVSRptDiscount.GenerateReport
  CreateFormGenerate;
  try
    if QryReport.RecordCount > 0 then
      FrmGenerate.PgsBarBusy.Max := QryReport.RecordCount;
    FrmGenerate.PgsBarBusy.Position := 0;
    FrmGenerate.Show;
    InitializeBeforeStartTable;
    case CodLayout of
      CtCodRptLayOutGlobal   : GenerateTableGlobalBody;
      CtCodRptLayOutOperator : GenerateTableOperatorBody;
      CtCodRptLayOutTicket   : GenerateTableTicketBody;
      CtCodRptLayOutCustomer : GenerateTableCustomerBody;
      CtCodRptLayOutPersonnel: GenerateTablePersonnelBody;
    end;
    if QtyLinesPrinted > 1 then
      GenerateTableDiscountTotals;
  finally
    FrmGenerate.Hide;
    FrmGenerate.Release;
    Application.ProcessMessages;
  end;
end;   // of TFrmVSRptTndCount.GenerateReport

//=============================================================================
// TFrmVSRptDiscount.CreateFormGenerate : creates the form to show the progress
// during report generating.
//                                         ----
// Restrictions:
// - is intended to call in a try..finally where the finally releases the
//   form (usually called in GenerateReport).
//=============================================================================

procedure TFrmVSRptDiscount.CreateFormGenerate;
begin  // of TFrmVSRptDiscount.CreateFormGenerate
  FrmGenerate := TFrmBusy.Create (Application);

  case CodOutputMedium of
    CtCodOutPrinter :
      FrmGenerate.PnlCaption.Caption :=
        Format (CtTxtGenerateReport, [CtTxtOutputPrint, TxtReportTitle]);
    CtCodOutPreview :
      FrmGenerate.PnlCaption.Caption :=
        Format (CtTxtGenerateReport, [CtTxtOutputPreview, TxtReportTitle]);
  end;
end;   // of TFrmVSRptDiscount.CreateFormGenerate

//=============================================================================
// TFrmVSRptDiscount.CheckAbortGenerate : checks if report generation is aborted,
// and sets the ModalResult of FrmGenerate.
//                                         ----
// Restrictions:
// - assumes FrmGenerate is created.
//=============================================================================

procedure TFrmVSRptDiscount.CheckAbortGenerate;
begin  // of TFrmVSRptDiscount.CheckAbortGenerate
  Application.ProcessMessages;

  if FrmGenerate.ModalResult = mrAbort then begin
    FrmGenerate.Visible := False;

    if CodOutputMedium in [CtCodOutPrinter] then begin
      if MessageDlg (CtTxtAskExecInterrupt, mtConfirmation,
                       [mbYes, mbNo], 0) <> mrYes then
        FrmGenerate.ModalResult := mrNone;
    end

    else begin
      case MessageDlgBtns (CtTxtAskExecInterrupt, mtConfirmation,
                           [CtTxtBtnContinue, CtTxtBtnStop,
                            CtTxtBtnConsult], 2, 0, 0) of
        1 : FrmGenerate.ModalResult := mrNone;
        2 : ;
        3 : FrmGenerate.ModalResult := mrCancel;
      end;
    end;

    if FrmGenerate.ModalResult <> mrCancel then
      FrmGenerate.Visible := True;
  end;
end;   // of TFrmVSRptDiscount.CheckAbortGenerate

//=============================================================================

procedure TFrmVSRptDiscount.VspPreviewNewPage(Sender: TObject);
var FlgValFontBoldSave  : Boolean;     // Save Bold flag
begin
  inherited;
  PrintReportHeader;
  FlgValFontBoldSave := VspPreview.FontBold;
  VspPreview.FontBold := True;
  VspPreview.AddTable (TxtTableFmt, TxtTableHdr, '',
                        ViColHeader, ViColBody, null);
  VspPreview.FontBold := FlgValFontBoldSave;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate, CtTxtSrcTag);
end.   // of FVSRptDiscount
