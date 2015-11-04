//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : FlexPoint
// Unit   : FVSRptDocumentBO = Form VideoSoft RePorT Document Back Office
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptDocumentBO.pas,v 1.2 2006/12/22 13:39:45 smete Exp $
// History:
//=============================================================================

unit FVSRptDocumentBO;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfVSPrinter7, ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ToolWin, ExtCtrls, DB, DBTables;

//=============================================================================
// Global definitions
//=============================================================================

resourcestring  // title strings for tables
  CtTxtTitleDocument    = 'Document';
  CtTxtTitleType        = 'Type';
  CtTxtTitleTicketDate  = 'Ticket Date';
  CtTxtTitleTickNb      = 'Ticket Number';
  CtTxtTitleCheckout    = 'Checkout';
  CtTxtTitleOperator    = 'Operator';
  CtTxtTitleClient      = 'Client';
  CtTxtTitleEquivalentFO= 'Equivalent N° in FO';
  CtTxtTitleDocumentDate= 'Document Date';
  CtTxtTitleTotalVente  = 'Total Sales';
  CtTxtTitlePLUNumber   = 'Internal Code';
  CtTxtTitleQty         = 'Quantity';
  CtTxtTitleDescr       = 'Description';
  CtTxtTitlePrice       = 'Price';
  CtTxtTitleValue       = 'Value';

resourcestring
  CtTxtGlobal           = 'Global';
  CtTxtDetail           = 'Detail';
  CtTxtFromToDate       = 'From Date %s To Date %s';

resourcestring // Explanation for tables
  CtTxtExplTransTable   = 'These are the documents that are incorrect entered '+
                          'on the checkout';
  CtTxtExplVenteTable   = 'These are the documents that are not ' +
                          'scanned on the checkout';

var    // Margins
  ViValMarginLeft  : Integer =  900;   // MarginLeft for VspPreview
  ViValMarginHeader: Integer = 1300;   // Adjust MarginTop to leave room for hdr

var    // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables

var    // Fontsizes
  ViValFontHeader  : Integer = 16;     // FontSize header
  ViValFontSubTitle: Integer = 11;     // FontSize SubTitle

var    // Positions and white space
  ViValPosXAddress : Integer = 7000;   // X-position for address
  ViValSpaceBetween: Integer =  200;   // White space between tables

var    // Column-width (in number of characters)
  ViValRptWidthDescr   : Integer = 30; // Width columns description
  ViValRptWidthQty     : Integer = 10; // Width columns quantity
  ViValRptWidthVal     : Integer = 11; // Width columns amount
  ViValRptWidthIdt     : Integer = 11; // Width for an identifier
  ViValRptWidthType    : Integer = 5;  // Width for a type
  ViValRptWidthDat     : Integer = 17; // Width for a datetime
  ViValRptWidthYN      : Integer = 10;  // Width for Y/N field

var  // print detail from the documents (true) or not (false)
  ViFlgDetail          : Boolean = False;

//*****************************************************************************
// TFrmVSRptDocumentBO
//*****************************************************************************

type
  TFrmVSRptDocumentBO = class(TFrmVSPreview)
    QryTransInvBO: TQuery;
    QryVenteInvBO: TQuery;
    QryPosTransDetail: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure VspPreviewBeforeHeader(Sender: TObject);
  protected
    // Datafields for properties
    FTxtFNLogo          : string;      // Filename Logo
    FPicLogo            : TImage;      // Logo
    FDatBeginSel        : TDateTime;   // Begin date of selection
    FDatEndSel          : TDateTime;   // End date of selection
    FFlgPrintRep1       : boolean;     //Print documents
    FNumDaysInfo        : integer;     //Max days info to give
    FFlgNoData          : boolean;     // No data for report
    // Save default settings of VspPreview
    ValOrigMarginTop    : Double;      // Original MarginTop
    // Internal used datafields for current Table on report
    QtyLinesPrinted     : Integer;     // Number of lines printed in table
    TxtTableFmt         : string;      // Format for current Table on report
    TxtTableHdr         : string;      // Header for current Table on report
    // Methods for Read/Write properties
    procedure SetTxtFNLogo (Value : string); virtual;
    // Universal Methods
    function CalcTextHei : Double; virtual;
    function FormatQuantity (QtyFormat : Integer) : string; virtual;
    function FormatValue (ValFormat : Currency) : string; virtual;
    procedure AppendFmtAndHdrQuantity (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrAmount (TxtHdr : string); virtual;
    procedure PrintPageHeader; virtual;
    procedure PrintAddress; virtual;
    procedure PrintTableLine (TxtLine : string); virtual;
    procedure InitializeBeforeStartTable; virtual;
    // Finishing report
    procedure AddFooterToPages; virtual;
    // Table Invalid docs in postransaction
    procedure BuildTableDocBOHdr; virtual;
    procedure BuildTableDocBOFmt; virtual;
    procedure BuildLineDocBO (var TxtLine        : string;
                              var FlgHasData     : Boolean        ); virtual;
    procedure PrintLineDocBO; virtual;
    procedure GenerateTableDocBOBody; virtual;
    procedure GenerateTableDocBO; virtual;
    // Table Invalid docs in VENTE
    procedure BuildTableVenteDocBOFmtAndHdr; virtual;
    procedure BuildLineVenteDocBO (var TxtLine        : string;
                              var FlgHasData     : Boolean        ); virtual;
    procedure PrintLineVenteDocBO; virtual;
    procedure GenerateTableVenteDocBOBody; virtual;
    procedure GenerateTableVenteDocBO; virtual;
   // Table Pos Transaction detail (for articles of a ticket
    procedure BuildTableTransDetailFmtAndHdr; virtual;
    procedure BuildLineTransDetail (var TxtLine        : string;
                              var FlgHasData     : Boolean        ); virtual;
    procedure PrintLineTransDetail; virtual;
    procedure GenerateTableTransDetailBody; virtual;
    procedure GenerateTableTransDetail; virtual;
  public
    { Public declarations }
    // Datafields which are set to default values, but could be adjusted after
    // creating the form.
    FlgPrintNullLine    : Boolean;     // Print lines with all 0-columns (Def=Y)
    FlgSaveDocument     : Boolean;     // Save the generated document (Def=Y)
    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
    // Overriden methods
    procedure DrawLogo (ImgLogo : TImage); override;
    // Methods
    function GenerateReport : boolean; virtual;
    // Properties
    property TxtFNLogo : string read  FTxtFNLogo
                                write SetTxtFNLogo;
    property PicLogo : TImage read  FPicLogo
                              write FPicLogo;
  published
    property DatBeginSel : TDateTime read  FDatBeginSel write FDatBeginSel;
    property DatEndSel : TDateTime read  FDatEndSel write FDatEndSel;
    property FlgPrintRep1 : boolean read FFlgPrintRep1 write FFlgPrintRep1;
    property NumDaysInfo : integer read FNumDaysInfo write FNumDaysInfo;
    property FlgNoData : boolean read FFlgNoData write FFlgNoData;
  end;  // of TFrmVSRptDocumentBO

var
  FrmVSRptDocumentBO: TFrmVSRptDocumentBO;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  StStrW,
  ScTskMgr_BDE_DBC,

  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  SrStnCom,

  DFpn,
  DFpnUtils,
  DFpnTradeMatrix,
  DFpnBODocument,

  RFpnCom;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptDocumentBO';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptDocumentBO.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:39:45 $';

//*****************************************************************************
// Implementation of TFrmVSRptDocumentBO
//*****************************************************************************

constructor TFrmVSRptDocumentBO.Create (AOwner : TComponent);
begin  // of TFrmVSRptDocumentBO.Create
  inherited;
  // Set defaults
  TxtFNLogo := CtTxtEnvVarStartDir + '\Image\FlexPoint.Report.BMP';
  FlgPrintNullLine := True;
  FlgSaveDocument  := True;

  // Overrule default properties for VspPreview.
  VspPreview.MarginLeft := ViValMarginLeft;
  // Leave room for header
  ValOrigMarginTop      := VspPreview.MarginTop;
  VspPreview.MarginTop  := ValOrigMarginTop + ViValMarginHeader;

  // Sets an empty header to make sure OnBeforeHeader is fired.
  VspPreview.Header := ' ';
end;   // of TFrmVSRptDocumentBO.Create

//=============================================================================

destructor TFrmVSRptDocumentBO.Destroy;
begin  // of TFrmVSRptDocumentBO.Destroy
  FPicLogo.Free;

  inherited;
end;   // of TFrmVSRptDocumentBO.Destroy

//=============================================================================
// TFrmVSRptDocumentBO - Methods for read/write properties
//=============================================================================

procedure TFrmVSRptDocumentBO.SetTxtFNLogo (Value : string);
begin  // of TFrmVSRptDocumentBO.SetTxtFNLogo
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
end;   // of TFrmVSRptDocumentBO.SetTxtFNLogo

//=============================================================================
// TFrmVSRptDocumentBO - Protected methods
//=============================================================================

//=============================================================================
// TFrmVSRptDocumentBO.CalcTextHei : calculates VspPreview.TextHei for a single
// line in the current font.
//                                  -----
// FUNCRES : calculated TextHei.
//=============================================================================

function TFrmVSRptDocumentBO.CalcTextHei : Double;
begin  // of TFrmVSRptDocumentBO.CalcTextHei
  VspPreview.X1 := 0;
  VspPreview.Y1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y2 := 0;

  VspPreview.CalcParagraph := 'X';
  Result := VspPreview.TextHei;
end;   // of TFrmVSRptDocumentBO.CalcTextHei

//=============================================================================
// TFrmVSRptDocumentBO.FormatQuantity : converts a quantity to a string ready to
// print.
//                                  -----
// INPUT   : QtyFormat = quantity to format.
//                                  -----
// FUNCRES : QtyFormat converted to string.
//=============================================================================

function TFrmVSRptDocumentBO.FormatQuantity (QtyFormat : Integer) : string;
begin  // of TFrmVSRptDocumentBO.FormatQuantity
  if QtyFormat = 0 then
    Result := '-'
  else
    Result := IntToStr (QtyFormat);
end;   // of TFrmVSRptDocumentBO.FormatQuantity

//=============================================================================
// TFrmVSRptDocumentBO.FormatValue : converts a value to a string ready to print.
//                                  -----
// INPUT   : ValFormat = value to format.
//                                  -----
// FUNCRES : ValFormat converted to string.
//=============================================================================

function TFrmVSRptDocumentBO.FormatValue (ValFormat : Currency) : string;
begin  // of TFrmVSRptDocumentBO.FormatValue
  if ValFormat = 0 then
    Result := '-'
  else
    Result := CurrToStrF (ValFormat, ffFixed, DmdFpnUtils.QtyDecsValue);
end;   // of TFrmVSRptDocumentBO.FormatValue

//=============================================================================
// TFrmVSRptDocumentBO.AppendFmtAndHdrQuantity : appends the format and header
// for a quantity-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptDocumentBO.AppendFmtAndHdrQuantity (TxtHdr : string);
begin  // of TFrmVSRptDocumentBO.AppendFmtAndHdrQuantity
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%s%d',
                         [SepCol, FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthQty))]);
  TxtTableHdr := TxtTableHdr + Format ('%s%s', [SepCol, TxtHdr]);
end;   // of TFrmVSRptDocumentBO.AppendFmtAndHdrQuantity

//=============================================================================
// TFrmVSRptDocumentBO.AppendFmtAndHdrAmount : appends the format and header
// for an amount-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptDocumentBO.AppendFmtAndHdrAmount (TxtHdr : string);
begin  // of TFrmVSRptDocumentBO.AppendFmtAndHdrAmount
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%s%d',
                         [SepCol, FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthVal))]);
  TxtTableHdr := TxtTableHdr + Format ('%s%s', [SepCol, TxtHdr]);
end;   // of TFrmVSRptDocumentBO.AppendFmtAndHdrAmount

//=============================================================================
// TFrmVSRptDocumentBO.PrintPageHeader : prints the header of the report.
//                                  -----
// Restrictions :
// - is called from VspPreview.OnBeforeHeader; provided as virtual method to
//   improve inheritance.
//=============================================================================

procedure TFrmVSRptDocumentBO.PrintPageHeader;
var
  ViValFontSave  : Variant;            // Save original FontSize
  TxtHeader      : string;             // Build header string to print
begin  // of TFrmVSRptDocumentBO.PrintPageHeader
  ViValFontSave := VspPreview.FontSize;
  try
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.CurrentY := ValOrigMarginTop;
    VspPreview.FontSize := ViValFontHeader;
    VspPreview.FontBold := True;
    if ViFlgDetail then
      TxtHeader := Caption + ' - ' + CtTxtDetail
    else
      TxtHeader := Caption + ' - ' + CtTxtGlobal;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.FontSize := ViValFontSubTitle;
    VspPreview.Text := TxtHeader;
    VspPreview.Text := #10 + Format (CtTxtFromToDate, [DateToStr (DatBeginSel),
                                                       DateToStr (DatEndSel)]);
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
  finally
    VspPreview.Fontsize := ViValFontSave;
    VspPreview.FontBold := False;
  end;
end;   // of TFrmVSRptDocumentBO.PrintPageHeader

//=============================================================================
// TFrmVSRptDocumentBO.PrintAddress : prints the address of the TradeMatrix.
//                                  -----
// Restrictions :
// - is called from VspPreview.OnBeforeHeader; provided as virtual method to
//   improve inheritance.
//=============================================================================

procedure TFrmVSRptDocumentBO.PrintAddress;
begin  // of TFrmVSRptDocumentBO.PrintAddress
  // Name
  VspPreview.CurrentX := ViValPosXAddress;
  VspPreview.Text     := DmdFpnUtils.TradeMatrixName;
  VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    // Street
  VspPreview.CurrentX := ViValPosXAddress;
  VspPreview.Text     := DmdFpnTradeMatrix.InfoTradeMatrix
                           [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtStreet'];
  VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    // Place
  VspPreview.CurrentX := ViValPosXAddress;
  VspPreview.Text     := DmdFpnTradeMatrix.InfoTradeMatrix
                           [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] +
                         ' ' +
                         DmdFpnTradeMatrix.InfoTradeMatrix
                           [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'];
  VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    // Idt
  VspPreview.CurrentX := ViValPosXAddress;
  VspPreview.Text     := DmdFpnUtils.IdtTradeMatrixAssort;
  VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
  VspPreview.CurrentX := VspPreview.MarginLeft;
end;   // of TFrmVSRptDocumentBO.PrintAddress

//=============================================================================
// TFrmVSRptDocumentBO.PrintTableLine : adds the line to the current Table.
//                                  -----
// INPUT   : TxtLine = line to add to the Table.
//=============================================================================

procedure TFrmVSRptDocumentBO.PrintTableLine (TxtLine : string);
begin  // of TFrmVSRptDocumentBO.PrintTableLine
  VspPreview.AddTable (TxtTableFmt, TxtTableHdr, TxtLine,
                       ViColHeader, ViColBody, '');
  Inc (QtyLinesPrinted);
end;   // of TFrmVSRptDocumentBO.PrintTableLine

//=============================================================================
// TFrmVSRptDocumentBO.InitializeBeforeStartTable : initialization before
// starting a new table.
//=============================================================================

procedure TFrmVSRptDocumentBO.InitializeBeforeStartTable;
begin  // of TFrmVSRptDocumentBO.InitializeBeforeStartTable
  QtyLinesPrinted := 0;
end;   // of TFrmVSRptDocumentBO.InitializeBeforeStartTable

//=============================================================================
// TFrmVSRptDocumentBO.AddFooterToPages : adds a footer to each page with
// date and pagenumber.
//=============================================================================

procedure TFrmVSRptDocumentBO.AddFooterToPages;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
begin  // of TFrmVSRptDocumentBO.AddFooterToPages
  // Add page number and date to report
  if VspPreview.PageCount > 0 then begin
    for CntPage := 1 to VspPreview.PageCount do begin
      VspPreview.StartOverlay (CntPage, False);
      try
        VspPreview.CurrentX := VspPreview.MarginLeft;
        VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                               VspPreview.TextHeight ['X'];
        VspPreview.Text := CtTxtPrintDate + ' ' + DateToStr (Now);
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
end;   // of TFrmVSRptDocumentBO.AddFooterToPages

//=============================================================================
// TFrmVSRptDocumentBO - Public methods
//=============================================================================

procedure TFrmVSRptDocumentBO.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptDocumentBO.DrawLogo
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
end;   // of TFrmVSRptDocumentBO.DrawLogo

//=============================================================================
// TFrmVSRptDocumentBO.GenerateReport : generates the report.
//                                  -----
// FuncRes: Generate succeeded or not
//                                  -----
// Restrictions :
// - document must be generated in preview mode, because after generating, we
//   have to overlay all pages to add the pagenumber to each page.
//   But, even when creating in Preview mode, VspPreview must have been visible
//   at least one time (otherwise VspPreview remains empty!).
//=============================================================================

function TFrmVSRptDocumentBO.GenerateReport : Boolean;
begin  // of TFrmVSRptDocumentBO.GenerateReport
  Result := False;
  // Set range if application is started with /VREP1
  if FlgPrintRep1 then begin
    if NumDaysInfo > 0 then
      DatBeginSel := Now - NumDaysInfo
    else
      DatBeginSel := 0;
    DatEndSel := Now;
  end
  // Ask for range if application is not started with /VREP1, begindate may not
  // be before Now - NumDaysInfo (if application is started with /DAYSxx  
  else begin
    if not SvcTaskMgr.LaunchTask ('SelectDate') then
      Exit;
    If (NumDaysInfo > 0) and (DatBeginSel < Now - NumDaysInfo) then
      DatBeginSel := Now - NumDaysInfo;
  end;

  inherited;
  Visible := True;
  Visible := False;

  VspPreview.StartDoc;
  try
    GenerateTableDocBO;
    if not FlgPrintRep1 then
      GenerateTableVenteDocBo;
  finally
    VspPreview.EndDoc;
  end;

  AddFooterToPages;
  Result := True;
end;   // of TFrmVSRptDocumentBO.GenerateReport

//=============================================================================

procedure TFrmVSRptDocumentBO.BuildLineDocBO (var TxtLine: string;
                                              var FlgHasData: Boolean);
begin  // of TFrmVSRptDocumentBO.BuildLineDocBO
  TxtLine := QryTransInvBO.FieldByName ('IdtCVente').AsString +
             SepCol +
             ViArrTxtShortDescrDoc [QryTransInvBO.
                                    FieldByName ('CodTypeVente').AsInteger] +
             SepCol +
             QryTransInvBO.FieldByName ('DatTransBegin').AsString +
             SepCol +
             QryTransInvBO.FieldByName ('IdtPosTransaction').AsString +
             SepCol +
             QryTransInvBO.FieldByName ('IdtCheckout').AsString +
             SepCol +
             QryTransInvBO.FieldByName ('IdtOperator').AsString;
  if QryTransInvBO.FieldByName ('FlgDocExists').AsInteger = 1 then
    TxtLine := TxtLine + SepCol + CtTxtYes
  else
    TxtLine := TxtLine + SepCol + CtTxtNo;
  FlgHasData := True;
end;   // of TFrmVSRptDocumentBO.BuildLineDocBO

//=============================================================================

procedure TFrmVSRptDocumentBO.PrintLineDocBO;
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptDocumentBO.PrintLineDocBO
  BuildLineDocBO (TxtLine, FlgHasData);

  if FlgHasData or FlgPrintNullLine then
    PrintTableLine (TxtLine);
end;   // of TFrmVSRptDocumentBO.PrintLineDocBO

//=============================================================================

procedure TFrmVSRptDocumentBO.GenerateTableDocBOBody;
var
  NumDetCount      : Integer;          // Number of detail records
begin  // of TFrmVSRptDocumentBO.GenerateTableDocBOBody
  NumDetCount := 0;
  QryTransInvBO.First;
  while not QryTransInvBO.Eof do begin
    if ViFlgDetail then begin
      try
        DmdFpnUtils.QueryInfo (
          'SELECT Count (*) as CNT' +
          #10'FROM PosTransDetail' +
          #10'WHERE IdtPosTransaction = ' +
            QryTransInvBO.FieldByName ('IdtPosTransaction').AsString +
          #10'  AND IdtCheckout = ' +
            QryTransInvBO.FieldByName ('IdtCheckout').Asstring +
          #10'  AND CodTrans = ' +
            QryTransInvBO.FieldByName ('CodTrans').AsString +
          #10'  AND DatTransBegin = ' +
            AnsiQuotedStr (FormatDateTime (
                     ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                     QryTransInvBO.FieldByName ('DatTransBegin').AsDateTime),'''') +
          #10'  AND CodAction = 1' +
          #10'  AND IdtCVente IS NULL');
        NumDetCount := DmdFpnUtils.QryInfo.FieldByName ('CNT').AsInteger;
      finally
        DmdFpnUtils.CloseInfo;
      end;
      if VspPreview.CurrentY + ((NumDetCount + 4) * CalcTextHei) >
         VspPreview.PageHeight - VspPreview.MarginBottom then begin
        VspPreview.NewPage;
      end;
    end;
    BuildTableDocBOHdr;
    PrintLineDocBO;
    if ViFlgDetail and (NumDetCount > 0) then begin
      try
        QryPosTransDetail.ParamByName ('IdtPosTransaction').AsInteger :=
          QryTransInvBO.FieldByName ('IdtPosTransaction').AsInteger;
        QryPosTransDetail.ParamByName ('IdtCheckout').AsInteger :=
          QryTransInvBO.FieldByName ('IdtCheckout').AsInteger;
        QryPosTransDetail.ParamByName ('CodTrans').AsInteger :=
          QryTransInvBO.FieldByName ('CodTrans').AsInteger;
        QryPosTransDetail.ParamByName ('DatTransBegin').AsDateTime :=
          QryTransInvBO.FieldByName ('DatTransBegin').AsDateTime;
        QryPosTransDetail.Active := True;
        if not QryPosTransDetail.Eof then begin
          VspPreview.EndTable;
          VspPreview.MarginLeft := ViValMarginLeft + 740;
          GenerateTableTransDetail;
          VspPreview.MarginLeft := ViValMarginLeft;
          VspPreview.StartTable;
        end;
      finally
        QryPosTransDetail.Active := False;
      end;
      BuildTableDocBOFmt;
    end;
    QryTransInvBO.Next;
  end;
end;   // of TFrmVSRptDocumentBO.GenerateTableDocBOBody

//=============================================================================

procedure TFrmVSRptDocumentBO.BuildTableDocBOHdr;
begin  // of TFrmVSRptDocumentBO.BuildTableDocBOHdr
  TxtTableHdr := CtTxtTitleDocument + SepCol + CtTxtTitleType + SepCol +
                 CtTxtTitleTicketDate + SepCol + CtTxtTitleTickNb + SepCol +
                 CtTxtTitleCheckout + SepCol + CtTxtTitleOperator + SepCol +
                 CtTxtTitleEquivalentFO;
end;   // of TFrmVSRptDocumentBO.BuildTableDocBOHdr

//=============================================================================

procedure TFrmVSRptDocumentBO.BuildTableDocBOFmt;
begin  // of TFrmVSRptDocumentBO.BuildTableDocBOFmt
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthIdt)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignHCenter,
                                  ColumnWidthInTwips (ViValRptWidthType)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDat)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthIdt)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthIdt)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthIdt)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignHCenter,
                                  ColumnWidthInTwips (ViValRptWidthIdt)]);
end;   // of TFrmVSRptDocumentBO.BuildTableDocBOFmt

//=============================================================================

procedure TFrmVSRptDocumentBO.GenerateTableDocBO;
begin // of TFrmVSRptDocumentBO.GenerateTableDocBO
  FlgNoData := False;
  BuildTableDocBOHdr;
  InitializeBeforeStartTable;
  BuildTableDocBOFmt;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.Font.Style := VspPreview.Font.Style + [FsBold];
  VspPreview.Paragraph := CtTxtExplTransTable;
  VspPreview.Font.Style := VspPreview.Font.Style - [FsBold];
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  VspPreview.StartTable;
  QryTransInvBO.ParamByName ('PrmDatBegin').AsDateTime := DatBeginSel;
  QryTransInvBO.ParamByName ('PrmDatEnd').AsDateTime := DatEndSel;
  QryTransInvBO.Active := True;
  try
    if FFlgPrintRep1 and (QryTransInvBO.RecordCount = 0) then
      FlgNoData := True;
    GenerateTableDocBOBody;
  finally
    QryVenteInvBO.Active := False;
    QryTransInvBO.Active := False;
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;  // of TFrmVSRptDocumentBO.GenerateTableDocBO

//=============================================================================

procedure TFrmVSRptDocumentBO.BuildLineVenteDocBO (var TxtLine: string;
                                              var FlgHasData: Boolean);
begin  // of TFrmVSRptDocumentBO.BuildLineVenteDocBO
  TxtLine := QryVenteInvBO.FieldByName ('CVENTE').AsString +
             SepCol +
             ViArrTxtShortDescrDoc [QryVenteInvBO.
                                    FieldByName ('TYPE_VENTE').AsInteger] +
             SepCol +
             QryVenteInvBO.FieldByName ('DCREATION').AsString +
             SepCol +
             QryVenteInvBO.FieldByName ('CCLIENT').AsString +
             SepCol +
             FormatValue (QryVenteInvBO.FieldByName ('M_TOTAL_VENTE').AsFloat);
  FlgHasData := True;
end;   // of TFrmVSRptDocumentBO.BuildLineVenteDocBO

//=============================================================================

procedure TFrmVSRptDocumentBO.PrintLineVenteDocBO;
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptDocumentBO.PrintLineVenteDocBO
  BuildLineVenteDocBO (TxtLine, FlgHasData);

  if FlgHasData or FlgPrintNullLine then begin
    PrintTableLine (TxtLine);
  end;
end;   // of TFrmVSRptDocumentBO.PrintLineVenteDocBO

//=============================================================================

procedure TFrmVSRptDocumentBO.GenerateTableVenteDocBOBody;
begin  // of TFrmVSRptDocumentBO.GenerateTableVenteDocBOBody
  QryVenteInvBO.First;
  while not QryVenteInvBO.Eof do begin
    PrintLineVenteDocBO;
    QryVenteInvBO.Next;
  end;
end;   // of TFrmVSRptDocumentBO.GenerateTableVenteDocBOBody

//=============================================================================

procedure TFrmVSRptDocumentBO.BuildTableVenteDocBOFmtAndHdr;
begin  // of TFrmVSRptDocumentBO.BuildTableVenteDocBOFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthIdt)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignHCenter,
                                  ColumnWidthInTwips (ViValRptWidthType)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDat)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthIdt)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthVal)]);

  TxtTableHdr := CtTxtTitleDocument + SepCol + CtTxtTitleType + SepCol +
                 CtTxtTitleDocumentDate + SepCol + CtTxtTitleClient + SepCol +
                 CtTxtTitleTotalVente;
end;   // of TFrmVSRptDocumentBO.BuildTableVenteDocBOFmtAndHdr

//=============================================================================

procedure TFrmVSRptDocumentBO.GenerateTableVenteDocBO;
begin // of TFrmVSRptDocumentBO.GenerateTableVenteDocBO
  InitializeBeforeStartTable;
  BuildTableVenteDocBOFmtAndHdr;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.Font.Style := VspPreview.Font.Style + [FsBold];
  VspPreview.Paragraph := CtTxtExplVenteTable;
  VspPreview.Font.Style := VspPreview.Font.Style - [FsBold];
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  VspPreview.StartTable;
  try
    QryVenteInvBO.ParamByName ('PrmTxtDatFrom').AsString :=
                                 FormatDateTime ('YYYYMMDDHHNNSS', DatBeginSel);
    QryVenteInvBO.ParamByName ('PrmTxtDatTo').AsString :=
                                   FormatDateTime ('YYYYMMDDHHNNSS', DatEndSel);
    QryVenteInvBO.Active := True;
    GenerateTableVenteDocBOBody;
  finally
    QryVenteInvBO.Active := False;
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;  // of TFrmVSRptDocumentBO.GenerateTableVenteDocBO

//=============================================================================

procedure TFrmVSRptDocumentBO.BuildLineTransDetail (var TxtLine: string;
                                                    var FlgHasData: Boolean);
begin  // of TFrmVSRptDocumentBO.BuildLineTransDetail
  TxtLine := QryPosTransDetail.FieldByName ('NumPlu').AsString +
             SepCol +
             FormatQuantity (QryPosTransDetail.FieldByName ('QtyLine')
                                                                   .AsInteger) +
             SepCol +
             QryPosTransDetail.FieldByName ('TxtDescr').AsString +
             SepCol +
             FormatValue (QryPosTransDetail.FieldByName ('PrcInclVat').AsFloat)+
             SepCol +
             FormatValue (QryPosTransDetail.FieldByName ('ValInclVat').AsFloat);
  FlgHasData := True;
end;   // of TFrmVSRptDocumentBO.BuildLineTransDetail

//=============================================================================

procedure TFrmVSRptDocumentBO.PrintLineTransDetail;
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptDocumentBO.PrintLineTransDetail
  BuildLineTransDetail (TxtLine, FlgHasData);

  if FlgHasData or FlgPrintNullLine then
    PrintTableLine (TxtLine);
end;   // of TFrmVSRptDocumentBO.PrintLineTransDetail

//=============================================================================

procedure TFrmVSRptDocumentBO.GenerateTableTransDetailBody;
begin  // of TFrmVSRptDocumentBO.GenerateTableTransDetailBody
  while not QryPosTransDetail.Eof do begin
    PrintLineTransDetail;
    QryPosTransDetail.Next;
  end;
end;   // of TFrmVSRptDocumentBO.GenerateTableTransDetailBody

//=============================================================================

procedure TFrmVSRptDocumentBO.BuildTableTransDetailFmtAndHdr;
begin  // of TFrmVSRptDocumentBO.BuildTableTransDetailFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthIdt)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthQty)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthVal)]) +
                 SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthVal)]);

  TxtTableHdr := CtTxtTitlePLUNumber + SepCol + CtTxtTitleQty + SepCol +
                 CtTxtTitleDescr + SepCol + CtTxtTitlePrice + SepCol +
                 CtTxtTitleValue;
end;   // of TFrmVSRptDocumentBO.BuildTableTransDetailFmtAndHdr

//=============================================================================

procedure TFrmVSRptDocumentBO.GenerateTableTransDetail;
begin // of TFrmVSRptDocumentBO.GenerateTableTransDetail
  InitializeBeforeStartTable;
  BuildTableTransDetailFmtAndHdr;
  VspPreview.StartTable;
  try
    GenerateTableTransDetailBody;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;  // of TFrmVSRptDocumentBO.GenerateTableTransDetail

//=============================================================================
// TFrmVSRptDocumentBO - Event Handlers
//=============================================================================

procedure TFrmVSRptDocumentBO.FormCreate(Sender: TObject);
begin  // of TFrmVSRptDocumentBO.FormCreate
  inherited;
  AllowOpenActions := False;
end;   // of TFrmVSRptDocumentBO.FormCreate

//=============================================================================

procedure TFrmVSRptDocumentBO.VspPreviewBeforeHeader(Sender: TObject);
var
  ValPosYEndHdr    : Double;             // Y-position at end of header
  ValSavMarginLeft : Double;             // Leftmargin
begin  // of TFrmVSRptDocumentBO.VspPreviewBeforeHeader
  inherited;
  ValSavMarginLeft := VspPreview.MarginLeft;
  try
    VspPreview.MarginLeft := ViValMarginLeft;
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

    // Calculate Y-position to start report
    if VspPreview.CurrentY < ValPosYEndHdr then
      VspPreview.CurrentY := ValPosYEndHdr;
  finally
    VspPreview.MarginLeft := ValSavMarginLeft;
  end;
end;   // of TFrmVSRptDocumentBO.VspPreviewBeforeHeader

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of TFrmVSRptDocumentBO
