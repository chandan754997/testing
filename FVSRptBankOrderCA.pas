//======Copyright 2009 (c) Centric Retail Solutions. All rights reserved.======
// Packet   : Flexpoint
// Unit     : FVSRptBankOrderCA = Form Video Soft RePorT BANK ORDER CAstorama
//            Report of order of cash money placed with bank.
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS      : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptBankOrderCA.pas,v 1.4 2010/06/15 11:53:45 BEL\DVanpouc Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FVSRptBankOrderCA - CVS revision 1.7
//=============================================================================

unit FVSRptBankOrderCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ExtCtrls, ToolWin, DFpnSafeTransaction, DFpnTradeMatrix,
  SfVSPrinter7, Variants;

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  // format report headers
  // money order
  CtTxtRptTitleOrder          = 'Money Order';
  CtTxtRptTitleShop           = 'Shop : ';
  CtTxtRptTitleOperPrep       = 'Prepared by : ';
  CtTxtRptTitleDeliveryDate   = 'Date of Delivery : ___/___/______';
  CtTxtOverallTotalOrdered    = 'Total amount ordered : ';
  CtTxtOrderNumber            = 'Accountancy number : ______________';
  CtTxtVisaResponsable        = 'Visa responsable';
  // accceptation of money order
  CtTxtRptTitleAccept         = 'Acceptation Money Order';
  CtTxtRptTitleOperAccept     = 'Accepted by : ';
  CtTxtRptTitleAcceptDate     = 'Date of Acceptation : ___/___/______';
  CtTxtOverallTotalAccepted   = 'Total amount accepted : ';
  // table headers
  CtTxtHdrDetail              = 'Detail';
  CtTxtHdrQty                 = 'Qty';
  CtTxtHdrValue               = 'Value Cilinder';
  CtTxtHdrAmount              = 'Amount';
  // text header /FOrderParam
  CtTxtHdr1                   = 'Dear Sir, Dear Madam,';
  CtTxtHdr2                   = 'Could you please provide us for';
  CtTxtHdr3                   = 'with below detailed funds through';
  CtTxtHdr4                   = 'to the account of';
  CtTxtHdr5                   = ', registered on EURO DEPOT ESPAÑA S.A.';
  // text trailer /FOrderParam
  CtTxtTrl1                   = 'The place of delivery of the mentioned funds' +
                                ' will be';
  CtTxtTrl2                   = 'in';
  CtTxtTrl3                   = ', the reception of the funds will only be ' +
                                'executed by following persons:';
  CtTxtTrl4                   = 'Spanish addressing';
  CtTxtTrl5                   = 'with national identity card';
  CtTxtTrl6                   = 'We remain yours faithfully';

//=============================================================================
// Variables
//=============================================================================

var
  // Margins
  ViValMarginLeft   : Integer = 900;  // MarginLeft for VspPreview
  ViValMarginHeader : Integer = 1300; // Adjust MarginTop to leave room for hdr
  ViValHeaderHeight : Integer = 600;  // headerrow height
  ViValMarginTab    : Integer = 400;  // MarginLeft for first line
  // Fontsizes
  ViValFont16       : Integer = 16;   // FontSize for main header
  ViValFont12       : Integer = 12;   // FontSize for in between
  ViValFont10       : Integer = 10;   // Normal FontSize
  // Positions and white space
  ViValSpaceBetween: Integer =  200;   // White space between tables

var // Column-width (in number of characters)
  ViValRptWidthDetail  : Integer = 20; // Width columns detail
  ViValRptWidthQty     : Integer = 8;  // Width columns quantity
  ViValRptWidthValue   : Integer = 8;  // Width columns value
  ViValRptWidthAmount  : Integer = 13; // Width columns amount

var // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables

//=============================================================================
// Constants
//=============================================================================

const  // for the dimensions of the rectangle (Address).
  CtValAddressRecHeight   = 1500;
  CtValAddressRecWidth    = 3500;

const  // for the dimensions of the rectangle (Visa responsable).
  CtValVisaRespRecHeight  = 1000;
  CtValVisaRespRecWidth   = 2000;

const  // Systemparameters in ApplicParam
  CtTxtPrmFinNameBank             = 'FinNameBank';
  CtTxtPrmFinAddressBank          = 'FinAddressBank';
  CtTxtPrmFinCityBank             = 'FinCityBank';
  CtTxtPrmFinSecurityCompany      = 'FinSecurityCompany';
  CtTxtPrmFinBankAccount          = 'FinBankAccount';
  CtTxtPrmFinNameRespPerson1      = 'FinNameRespPerson1';
  CtTxtPrmFinNameRespPerson2      = 'FinNameRespPerson2';
  CtTxtPrmFinDNIRespPerson1       = 'FinDNIRespPerson1';
  CtTxtPrmFinDNIRespPerson2       = 'FinDNIRespPerson2';

//=============================================================================
// Form declaration
//=============================================================================

type
  TFrmVSRptBankOrderCA = class(TFrmVSPreview)
    procedure FormCreate(Sender: TObject);
  protected
    { Protected declarations }
    // Properties
    FPreviewReport      : Boolean;          // should report be previewed first.
    FNumEndPageRapport  : Integer;          // last pagenumber of report
    FCodRunFunc         : Integer;          // functionality of executable
    FIdtOperReg         : string;           // IdtOperator registrating
    FTxtNameOperReg     : string;           // Name operator registrating
    FIdtOrderNumber     : Integer;          // BankOrdernumber
    FIdtAddrPayOrg      : Integer;          // Link to address of Pay organization
    FLstTransDet        : TLstTransDetail;  // list of SafeTransdetail
    FPicLogo            : TImage;           // Logo
    FTxtFNLogo          : string;           // Filename Logo
    ValOrigMarginTop    : Double;           // Original MarginTop
    QtyLinesPrinted     : Integer;          // Linecounter for report
    TxtTableFmt         : string;           // Format for current Table on report
    TxtTableHdr         : string;           // Header for current Table on report
    ArrPages            : array of Integer; // Array of pages to restart counting
    ValTotalAmountC     : Currency;         // Total amount of cilinder units
    ValTotalAmountB     : Currency;         // Total amount of bill units
    ValTotalAmountParam : Currency;         // Total amount (FOrderParam)
    ValSaveCurrentY     : Double;           // Saved value of y-coordinate report
    IdtCurrency         : string;           // currency of the tendergroup
    FNumRef             : string;           // Report reference number
    // getters/setters
    function GetTotalAmount : Currency; virtual;
    // routines only used within the boundary of this report
    function GetNumEndPageRapport : Integer; virtual;
    procedure SetTxtFNLogo (Value : string); virtual;
    function CalcTextHei : Double; virtual;
    function FormatValue (ValFormat : Currency) : string; virtual;
    procedure PrintHeader; virtual;
    procedure PrintAddress; virtual;
    procedure PrintAddressParam; virtual;
    procedure PrintOrderInformation; virtual;
    procedure PrintOrderInformationParam; virtual;
    procedure AddFooterToPages; virtual;
    procedure InitializeBeforeStartTableUnitCilinders; virtual;
    procedure InitializeBeforeStartTableUnitBills; virtual;
    procedure InitializeBeforeStartTable; virtual;
    procedure BuildTableUnitCilindersFmtAndHdr; virtual;
    procedure BuildTableUnitBillsFmtAndHdr; virtual;
    procedure BuildTableFmtAndHdr; virtual;
    procedure GenerateTableUnitCilinders; virtual;
    procedure GenerateTableUnitBills; virtual;
    procedure GenerateTable; virtual;
    procedure GenerateTableUnitCilindersBody; virtual;
    procedure GenerateTableUnitBillsBody; virtual;
    procedure GenerateTableBody; virtual;
    procedure GenerateTableUnitCilindersTotal; virtual;
    procedure GenerateTableUnitBillsTotal; virtual;
    procedure GenerateTableTotal; virtual;
    procedure ConfigTableCilinders; virtual;
    procedure ConfigTableBills; virtual;
    procedure ConfigTable; virtual;
    procedure GenerateOverallTotal; virtual;
    procedure PrintEndClause; virtual;
    procedure PrintTrailer; virtual;
    procedure PrintTableLine (TxtLine : string); virtual;
    procedure PrintRef; virtual;
    function DetermineTxtDescrBills: String; virtual;
    // properties for total values
    property ValTotalAmount : Currency read  GetTotalAmount;
  public
    { Public declarations }
    // Does the user wishes to view a preview of the report Y/N
    property PreviewReport : Boolean read  FPreviewReport write FPreviewReport;
    // last page number generated
    property NumEndPageRapport : Integer read GetNumEndPageRapport;
    // filename that holds the logo for the right upper corner of the report
    property TxtFNLogo : string read  FTxtFNLogo write SetTxtFNLogo;
    // object that holds the bitmap of the report-logo
    property PicLogo : TImage read  FPicLogo write FPicLogo;
    property NumRef : string read  FNumRef write FNumRef;
    procedure DrawLogo (ImgLogo : TImage); override;
    procedure GenerateReport; virtual;
  published
    { Published declarations }
    property CodRunFunc : Integer read  FCodRunFunc write FCodRunFunc;
    property IdtOperReg : string read  FIdtOperReg write FIdtOperReg;
    property TxtNameOperReg : string read  FTxtNameOperReg write FTxtNameOperReg;
    property IdtOrderNumber : integer read  FIdtOrderNumber write FIdtOrderNumber;
    property IdtAddrPayOrg : Integer read  FIdtAddrPayOrg write FIdtAddrPayOrg;
    property LstTransDet : TLstTransDetail read  FLstTransDet write FLstTransDet;
  end;

var
  FrmVSRptBankOrderCA: TFrmVSRptBankOrderCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,

  DFpnUtils,
  DFpnAddress,
  DFpnApplicParam,

  FFpnTndBankOrderCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptBankOrderCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptBankOrderCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2010/06/15 11:53:45 $';

//*****************************************************************************
// Implementation of TFrmVSRptBankOrderCA
//*****************************************************************************

procedure TFrmVSRptBankOrderCA.FormCreate(Sender: TObject);
begin // of TFrmVSRptBankOrderCA.FormCreate
  inherited;
  if not Assigned (DmdFpnTradeMatrix) then
    DmdFpnTradeMatrix := TDmdFpnTradeMatrix.Create (Self);
  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Self);
  if not Assigned (DmdFpnAddress) then
    DmdFpnAddress := TDmdFpnAddress.Create (Self);
  if not Assigned (DmdFpnApplicParam) then
    DmdFpnApplicParam := TDmdFpnApplicParam.Create (Self);
  // Set defaults
  TxtFNLogo := CtTxtEnvVarStartDir + '\Image\FlexPoint.Report.BMP';
  // Overrule default properties for VspPreview.
  VspPreview.MarginLeft := ViValMarginLeft;
  // Leave room for header
  ValOrigMarginTop      := VspPreview.MarginTop;
  VspPreview.MarginTop  := ValOrigMarginTop + ViValMarginHeader;
end;  // of TFrmVSRptBankOrderCA.FormCreate

//=============================================================================
// TFrmVSRptBankOrderCA.GetNumEndPageRapport : Fetch last pagenumber of report.
//                                             To be used in the PrintDoc method
//                                             of the maintenance task form
//=============================================================================

function TFrmVSRptBankOrderCA.GetNumEndPageRapport : Integer;
begin  // of TFrmVSRptBankOrderCA.GetNumEndPageRapport
  Result := ArrPages [1] - 1;
end;   // of TFrmVSRptBankOrderCA.GetNumEndPageRapport

//=============================================================================
// TFrmVSRptBankOrderCA.SetTxtFNLogo: loads the logo file into an image-object
//=============================================================================

procedure TFrmVSRptBankOrderCA.SetTxtFNLogo (Value: string);
begin // of TFrmVSRptBankOrderCA.SetTxtFNLogo
  FTxtFNLogo := ReplaceEnvVar (Value);
  if (TxtFNLogo <> '') and FileExists (TxtFNLogo) then begin
    if not Assigned (PicLogo) then begin
      PicLogo := TImage.Create (Self);
      PicLogo.AutoSize := True;
    end;
    PicLogo.Picture.LoadFromFile (TxtFNLogo);
  end;
end;  // of TFrmVSRptBankOrderCA.SetTxtFNLogo

//=============================================================================
// TFrmVSRptBankOrderCA.CalcTextHei : calculates VspPreview.TextHei for a
// single line in the current font.
//                                  -----
// FUNCRES : calculated TextHei.
//=============================================================================

function TFrmVSRptBankOrderCA.CalcTextHei : Double;
begin  // of TFrmVSRptBankOrderCA.CalcTextHei
  VspPreview.X1 := 0;
  VspPreview.Y1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y2 := 0;
  VspPreview.CalcParagraph := 'X';
  Result := VspPreview.TextHei;
end;   // of TFrmVSRptBankOrderCA.CalcTextHei

//=============================================================================
// TFrmVSRptBankOrderCA.FormatValue : converts a value to a string ready to print.
//                                  -----
// INPUT   : ValFormat = value to format.
//                                  -----
// FUNCRES : ValFormat converted to string.
//=============================================================================

function TFrmVSRptBankOrderCA.FormatValue (ValFormat : Currency) : string;
begin  // of TFrmVSRptBankOrderCA.FormatValue
  if ValFormat = 0 then
    Result := '-'
  else
    Result := CurrToStrF (ValFormat, ffFixed, DmdFpnUtils.QtyDecsValue);
end;   // of TFrmVSRptBankOrderCA.FormatValue

//=============================================================================
// TFrmVSRptBankOrderCA.PrintHeader : prints the header information
//=============================================================================

procedure TFrmVSRptBankOrderCA.PrintHeader;
begin // of TFrmVSRptBankOrderCA.PrintHeader
  DrawLogo (PicLogo);
  case CodRunFunc of
    CtCodFuncOrder, CtCodFuncAccept: begin
      // prints the address of the pay organisation
      PrintAddress;
      // prints the order information
      PrintOrderInformation;
      end; // of begin
    CtCodFuncOrderParam : begin
      // prints the address of the pay organisation
      PrintAddressParam;
      // prints the order information
      PrintOrderInformationParam;
      end; // of begin
  end; // of case
end;  // of TFrmVSRptBankOrderCA.PrintHeader

//=============================================================================
// TFrmVSRptBankOrderCA.PrintAddress : prints the address rectangle with
// its information & fetches the Address information for IdtAddrPayOrg
// (the supplier of the money)
//=============================================================================

procedure TFrmVSRptBankOrderCA.PrintAddress;
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptBankOrderCA.PrintAddress
  ValSaveMargin := VspPreview.MarginTop;
  VspPreview.MarginTop := ValOrigMarginTop + 200;
  try
    VspPreview.BrushStyle := bsTransparent;
    // Print a rectangle for holding the address
    VspPreview.DrawRectangle(VspPreview.PageWidth - VspPreview.MarginRight
                             - CtValAddressRecWidth, VspPreview.MarginTop + 500,
                             VspPreview.PageWidth - VspPreview.MarginRight,
                             VspPreview.MarginTop + CtValAddressRecHeight, 0,0);
    VspPreview.FontSize   := ViValFont12;
    VspPreview.DrawRectangle(VspPreview.PageWidth - VspPreview.MarginRight
                             - CtValAddressRecWidth, VspPreview.MarginTop + 500,
                             VspPreview.PageWidth - VspPreview.MarginRight,
                             VspPreview.MarginTop + CtValAddressRecHeight, 0,0);
    VspPreview.FontSize   := ViValFont12;

    // Fills the rectangle with the address of the pay organisation
    if IdtAddrPayOrg = 0 then begin
      VspPreview.Text    := '';
    end  // of IdtAddrPayOrg = 0
    else begin
      VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight
                              - CtValAddressRecWidth + 50;
      VspPreview.CurrentY := VspPreview.MarginTop + 600;
      VspPreview.Text := DmdFpnAddress.InfoAddress [IdtAddrPayOrg, 'TxtName'];
      VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight
                              - CtValAddressRecWidth + 50;
      VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
      VspPreview.Text :=
        DmdFpnAddress.InfoAddress [IdtAddrPayOrg, 'TxtStreet'] + ' ' +
        DmdFpnAddress.InfoAddress [IdtAddrPayOrg, 'TxtNumHouse'] + ' ' +
        DmdFpnAddress.InfoAddress [IdtAddrPayOrg, 'TxtNumBox'];
      VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight
                              - CtValAddressRecWidth + 50;
      VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
      VspPreview.Text :=
        DmdFpnAddress.InfoAddress [IdtAddrPayOrg, 'TxtCodPost'] + ' ' +
        DmdFpnAddress.InfoAddress [IdtAddrPayOrg, 'TxtMunicip'];
    end;  // of of IdtAddrPayOrg <> 0
  finally
    VspPreview.MarginTop := ValSaveMargin;
  end;
end;   // of TFrmVSRptBankOrderCA.PrintAddress

//=============================================================================
// TFrmVSRptBankOrderCA.PrintOrderInformation : prints the following
// information at the top of the page:
// Report Title, Shop who ordered the money, ordered by which operator,
// probable date of delivery.
//=============================================================================

procedure TFrmVSRptBankOrderCA.PrintOrderInformation;
var
  ValSaveMargin       : Double;        // Save current MarginTop
  NumLeftOffsetMargin : Double;        // Offset from Left Margin
  IdtTradeMatrix      : string;        // IdtTradeMatrix of the shop
begin // of FrmVSRptBankOrderCA.PrintOrderInformation
  NumLeftOffsetMargin := 250;
  ValSaveMargin := VspPreview.MarginTop;
  VspPreview.MarginTop := ValOrigMarginTop + 200;
  try
    // print main title of report
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.MarginTop;
    VspPreview.FontSize   := ViValFont16;
    case CodRunFunc of
      CtCodFuncOrder       : VspPreview.Text := CtTxtRptTitleOrder + ' '
                             + IntToStr (IdtOrderNumber);
      CtCodFuncAccept      : VspPreview.Text := CtTxtRptTitleAccept + ' '
                             + IntToStr (IdtOrderNumber);
    end;
    // print shop information
    VspPreview.FontSize := ViValFont12;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 400;
    VspPreview.Text := CtTxtRptTitleShop;
    IdtTradeMatrix := DmdFpnUtils.IdtTradeMatrixAssort;
    VspPreview.CurrentX := VspPreview.MarginLeft + NumLeftOffsetMargin;
    VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
    VspPreview.Text :=
      DmdFpnTradeMatrix.InfoTradeMatrix [IdtTradeMatrix, 'TxtName'];
    VspPreview.CurrentX := VspPreview.MarginLeft + NumLeftOffsetMargin;
    VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
    VspPreview.Text :=
        DmdFpnTradeMatrix.InfoTradeMatrix [IdtTradeMatrix, 'TxtStreet'];
    VspPreview.CurrentX := VspPreview.MarginLeft + NumLeftOffsetMargin;
    VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
    VspPreview.Text :=
        DmdFpnTradeMatrix.InfoTradeMatrix [IdtTradeMatrix, 'TxtCodPost'] + ' ' +
        DmdFpnTradeMatrix.InfoTradeMatrix [IdtTradeMatrix, 'TxtMunicip'];
    // print registrating operator
    VspPreview.FontSize   := ViValFont10;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 400;
    case CodRunFunc of
      CtCodFuncOrder  :
        VspPreview.Text := CtTxtRptTitleOperPrep + TxtNameOperReg;
      CtCodFuncAccept :
        VspPreview.Text := CtTxtRptTitleOperAccept + TxtNameOperReg;
    end;
    // print delivery date
    VspPreview.FontSize   := ViValFont10;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
    case CodRunFunc of
      CtCodFuncOrder  : VspPreview.Text := CtTxtRptTitleDeliveryDate;
      CtCodFuncAccept : VspPreview.Text := CtTxtRptTitleAcceptDate;
    end;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 400;
  finally
    VspPreview.MarginTop := ValSaveMargin;
  end;
end; // of FrmVSRptBankOrderCA.PrintOrderInformation

//=============================================================================
// TFrmVSRptBankOrderCA.PrintOrderInformationParam : prints the following
// information at the top of the page:
// Report Title, Shop who ordered the money, ordered by which operator,
// probable date of delivery.
//=============================================================================

procedure TFrmVSRptBankOrderCA.PrintOrderInformationParam;
var
  ValSaveMargin       : Double;        // Save current MarginTop
  IdtTradeMatrix      : string;        // IdtTradeMatrix of the shop
begin // of FrmVSRptBankOrderCA.PrintOrderInformationParam
  ValSaveMargin := VspPreview.MarginTop;
  VspPreview.MarginTop := ValOrigMarginTop + 500;
  try
    // print shop information
    IdtTradeMatrix      := DmdFpnUtils.IdtTradeMatrixAssort;
    VspPreview.FontSize := ViValFont10;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.MarginTop;
    VspPreview.Text :=
      DmdFpnTradeMatrix.InfoTradeMatrix [IdtTradeMatrix, 'TxtName'];
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
    VspPreview.Text :=
      DmdFpnTradeMatrix.InfoTradeMatrix [IdtTradeMatrix, 'TxtStreet'];
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
    VspPreview.Text :=
      DmdFpnTradeMatrix.InfoTradeMatrix [IdtTradeMatrix, 'TxtCodPost'] + ' ' +
      DmdFpnTradeMatrix.InfoTradeMatrix [IdtTradeMatrix, 'TxtMunicip'];
    VspPreview.FontSize := ViValFont10;
    VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight -
                           (length(DmdFpnTradeMatrix.InfoTradeMatrix
                           [IdtTradeMatrix, 'TxtMunicip'] + ', ' +
                           DateToStr(now))*100);

    VspPreview.CurrentY := VspPreview.MarginTop + 1000;
    VspPreview.Text := DmdFpnTradeMatrix.InfoTradeMatrix
                       [IdtTradeMatrix, 'TxtMunicip'] + ', ';
    VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight -
                           (length(DmdFpnTradeMatrix.InfoTradeMatrix
                           [IdtTradeMatrix, 'TxtMunicip'] + ', ' +
                           DateToStr(now))*100);
    VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];

    VspPreview.Text := DateToStr(now);
    // print header text
    VspPreview.FontSize := ViValFont10;
    VspPreview.CurrentX := VspPreview.MarginLeft + ViValMarginTab;
    VspPreview.CurrentY := VspPreview.MarginTop + 3500;
    VspPreview.Text := CtTxtHdr1;
    VspPreview.CurrentX := VspPreview.MarginLeft + ViValMarginTab;
    VspPreview.CurrentY := VspPreview.MarginTop + 4000;
    VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
    VspPreview.Text := CtTxtHdr2 + ' ' + DateToStr(now + 1) + ' ' + CtTxtHdr3 +
                       ' ' + DmdFpnApplicParam.InfoApplicParam
                       [CtTxtPrmFinSecurityCompany, 'TxtParam'] + ' ' +
                       CtTxtHdr4 + ' ' + DmdFpnApplicParam.InfoApplicParam
                       [CtTxtPrmFinBankAccount, 'TxtParam'] + CtTxtHdr5;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + ViValMarginTab;
  finally
    VspPreview.MarginTop := ValSaveMargin;
  end;
end; // of FrmVSRptBankOrderCA.PrintOrderInformationParam

//=============================================================================
// TFrmVSRptBankOrderCA.AddFooterToPages
//=============================================================================

procedure TFrmVSRptBankOrderCA.AddFooterToPages;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
  NumPage          : Integer;          // PageNumber
  TotPage          : Integer;          // total Pages
  CntArray         : Integer;          // Array counter
begin  // of TFrmVSRptBankOrderCA.AddFooterToPages
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
end;   // of TFrmVSRptBankOrderCA.AddFooterToPages

//=============================================================================
// TFrmVSRptBankOrderCA.InitializeBeforeStartTableUnitCilinders : initialization
// before starting a new table.
//=============================================================================

procedure TFrmVSRptBankOrderCA.InitializeBeforeStartTableUnitCilinders;
begin  // of TFrmVSRptBankOrderCA.InitializeBeforeStartTableUnitCilinders
  QtyLinesPrinted := 0;
  ValTotalAmountC := 0;
end;   // of TFrmVSRptBankOrderCA.InitializeBeforeStartTableUnitCilinders

//=============================================================================
// TFrmVSRptBankOrderCA.InitializeBeforeStartTableUnitBills : initialization
// before starting a new table of TenderUnits in bills.
//=============================================================================

procedure TFrmVSRptBankOrderCA.InitializeBeforeStartTableUnitBills;
begin  // of TFrmVSRptBankOrderCA.InitializeBeforeStartTableUnitBills
  QtyLinesPrinted := 0;
  ValTotalAmountB := 0;
end;   // of TFrmVSRptBankOrderCA.InitializeBeforeStartTableUnitBills

//=============================================================================
// TFrmVSRptBankOrderCA.InitializeBeforeStartTable : initialization
// before starting a new table (FOrderParam).
//=============================================================================

procedure TFrmVSRptBankOrderCA.InitializeBeforeStartTable;
begin  // of TFrmVSRptBankOrderCA.InitializeBeforeStartTable
  QtyLinesPrinted     := 0;
  ValTotalAmountParam := 0;
end;   // of TFrmVSRptBankOrderCA.InitializeBeforeStartTable

//=============================================================================
// TFrmVSRptBankOrderCA.BuildTableUnitCilindersFmtAndHdr : format table to print
//=============================================================================

procedure TFrmVSRptBankOrderCA.BuildTableUnitCilindersFmtAndHdr;
begin // of TFrmVSRptBankOrderCA.BuildTableUnitCilindersFmtAndHdr
  // set table and header format
  // detail
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDetail)]);
  // Quantity
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignHCenter,
                                  ColumnWidthInTwips (ViValRptWidthQty)]);
  // Value
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignHCenter,
                                  ColumnWidthInTwips (ViValRptWidthValue)]);
  // Amount
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthAmount)]);
  TxtTableHdr := CtTxtHdrDetail + SepCol + CtTxtHdrQty + SepCol +
                 CtTxtHdrvalue + SepCol + CtTxtHdrAmount;
end;  // of TFrmVSRptBankOrderCA.BuildTableUnitCilindersFmtAndHdr

//=============================================================================
// TFrmVSRptBankOrderCA.BuildTableUnitBillsFmtAndHdr : format table to print
//=============================================================================

procedure TFrmVSRptBankOrderCA.BuildTableUnitBillsFmtAndHdr;
begin // of TFrmVSRptBankOrderCA.BuildTableUnitBillsFmtAndHdr
  // set table and header format
  // detail
  VspPreview.CurrentX := ViValMarginLeft + ColumnWidthInTwips (ViValRptWidthQty);
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDetail)]);
  // Quantity
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignHCenter,
                                  ColumnWidthInTwips (ViValRptWidthQty)]);
  // Amount
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthAmount)]);
  TxtTableHdr := CtTxtHdrDetail + SepCol + CtTxtHdrQty + SepCol +
                 CtTxtHdrAmount;
end;  // of TFrmVSRptBankOrderCA.BuildTableUnitBillsFmtAndHdr

//=============================================================================
// TFrmVSRptBankOrderCA.BuildTableFmtAndHdr : format table to print
// if /FOrderParam
//=============================================================================

procedure TFrmVSRptBankOrderCA.BuildTableFmtAndHdr;
begin // of TFrmVSRptBankOrderCA.BuildTableFmtAndHdr
  // set table and header format
  // detail
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDetail)]);
  // Value of unit
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthAmount)]);
  // Quantity
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthQty)]);
  // Amount
  TxtTableFmt := TxtTableFmt + SepCol +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthAmount)]);
  TxtTableHdr := CtTxtHdrDetail + SepCol + SepCol +
                 CtTxtHdrQty + SepCol + CtTxtHdrAmount;
end;  // of TFrmVSRptBankOrderCA.BuildTableFmtAndHdr

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateTableUnitCilinders : print cilinder units
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateTableUnitCilinders;
begin // of TFrmVSRptBankOrderCA.GenerateTableUnitCilinders
  InitializeBeforeStartTableUnitCilinders;
  BuildTableUnitCilindersFmtAndHdr;
  // save startposition of the left table (cilinders)
  ValSaveCurrentY := VspPreview.CurrentY;
  VspPreview.StartTable;
  try
    GenerateTableUnitCilindersBody;
    if QtyLinesPrinted > 0 then
       GenerateTableUnitCilindersTotal;
  finally
    VspPreview.EndTable;
  end;
end;  // of TFrmVSRptBankOrderCA.GenerateTableUnitCilinders

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateTableUnitBills : print bill units
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateTableUnitBills;
begin // of TFrmVSRptBankOrderCA.GenerateTableUnitBills
  InitializeBeforeStartTableUnitBills;
  BuildTableUnitBillsFmtAndHdr;
  VspPreview.CurrentY := ValSaveCurrentY;
  VspPreview.StartTable;
  try
    GenerateTableUnitBillsBody;
    if QtyLinesPrinted > 0 then
       GenerateTableUnitBillsTotal;
  finally
    VspPreview.EndTable;
  end;
end;  // of TFrmVSRptBankOrderCA.GenerateTableUnitBills

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateTable: print table for /FOrderParam
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateTable;
begin // of TFrmVSRptBankOrderCA.GenerateTable
  VspPreview.TableBorder := bsNone;
  InitializeBeforeStartTable;
  BuildTableFmtAndHdr;
  VspPreview.StartTable;
  try
    GenerateTableBody;
    if QtyLinesPrinted > 0 then
       GenerateTableTotal;
  finally
    VspPreview.EndTable;
  end;
end;  // of TFrmVSRptBankOrderCA.GenerateTable

//=============================================================================
// TFrmVSRptBankOrderCA.DetermineTxtDescrBills : Determine TxtDescr of bills
//=============================================================================

function TFrmVSRptBankOrderCA.DetermineTxtDescrBills: String;
begin // of TFrmVSRptBankOrderCA.DetermineTxtDescrBills
  try
    DmdFpnUtils.QueryInfo('SELECT TOP 1 TenderUnit.TxtDescr' +
                       #10'FROM TenderUnit' +
                       #10'WHERE IdtTenderGroup = 1');
    Result := DmdFpnUtils.QryInfo.FieldByName('TxtDescr').AsString;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;  // of TFrmVSRptBankOrderCA.DetermineTxtDescrBills

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateTableUnitCilindersBody : prints the body of table
// with tenderunits that can be stored in cilinders (rolletjes met munten)
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateTableUnitCilindersBody;
var
  TxtLine          : string;           // line with detail to print
  CntItem          : Integer;          // counter for LstTransDet
  TxtDetail        : string;           // Column 1 (detail of unit)
  ValQty           : Integer;          // Column 2 (Quantity of units)
  ValCilinder      : Currency;         // Column 3 (Value of one cilinder)
  ValAmount        : Currency;         // Column 4 (Amount of unit)
  StrDescrBills    : String;           // TxtDescr of bills
begin // of TFrmVSRptBankOrderCA.GenerateTableUnitCilindersBody
  // this is only valid for Euro currency
  StrDescrBills := DetermineTxtDescrBills;
  for CntItem := Pred (LstTransDet.Count) downto 0 do begin
    if StrComp(PChar(StrDescrBills),
    PChar(LstTransDet.TransDetail[CntItem].TxtDescr)) <> 0 then begin
      ValCilinder := LstTransDet.TransDetail[CntItem].ValUnit;
      TxtDetail := LstTransDet.TransDetail[CntItem].TxtDescr;
      ValQty    := LstTransDet.TransDetail[CntItem].QtyUnit;
      ValAmount := ValQty * ValCilinder;
      TxtLine := TxtDetail + SepCol +
                 FloatToStr (ValQty) + SepCol +
                 FormatValue (ValCilinder) + SepCol +
                 FormatValue (ValAmount);
      ValTotalAmountC := ValTotalAmountC + ValAmount;
      PrintTableLine (TxtLine);
    end
  end; // for
end;  // of TFrmVSRptBankOrderCA.GenerateTableUnitCilindersBody

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateTableUnitBillsBody : prints the body of table
// with tenderunits that can be stored in bills (biljetten)
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateTableUnitBillsBody;
var
  TxtLine          : string;           // line with detail to print
  CntItem          : Integer;          // counter for LstTransDet
  TxtDetail        : string;           // Column 1 (detail of unit)
  ValQty           : Integer;          // Column 2 (Quantity of units)
  ValAmount        : Currency;         // Column 3 (Amount of unit)
  StrDescrBills    : String;           // TxtDescr of bills  
begin // of TFrmVSRptBankOrderCA.GenerateTableUnitBillsBody
  StrDescrBills := DetermineTxtDescrBills;
  for CntItem := Pred (LstTransDet.Count) downto 0 do begin
    if StrComp(PChar(StrDescrBills),
    PChar(LstTransDet.TransDetail[CntItem].TxtDescr)) = 0 then begin
      TxtDetail := FormatValue (LstTransDet.TransDetail[CntItem].ValUnit);
      ValQty    := LstTransDet.TransDetail[CntItem].QtyUnit;
      ValAmount := LstTransDet.TransDetail[CntItem].QtyUnit *
                   LstTransDet.TransDetail[CntItem].ValUnit;
      TxtLine := TxtDetail + SepCol +
                 FloatToStr (ValQty) + SepCol +
                 FormatValue (ValAmount);
      ValTotalAmountB := ValTotalAmountB + ValAmount;
      PrintTableLine (TxtLine);
    end
  end; // for
end;  // of TFrmVSRptBankOrderCA.GenerateTableUnitBillsBody

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateTableBody : prints the body of table
// with tenderunits (/FOrderParam)
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateTableBody;
var
  TxtLine          : string;           // line with detail to print
  CntItem          : Integer;          // counter for LstTransDet
  ValAmount        : Currency;         // Column 3 (Amount of unit)
begin // of TFrmVSRptBankOrderCA.GenerateTableBody
  for CntItem := Pred (LstTransDet.Count) downto 0 do begin
    ValAmount := LstTransDet.TransDetail[CntItem].QtyUnit *
                 LstTransDet.TransDetail[CntItem].ValUnit;
    TxtLine   := LstTransDet.TransDetail[CntItem].TxtDescr + SepCol +
                 FormatValue (LstTransDet.TransDetail[CntItem].ValUnit)+ SepCol +
                 IntToStr (LstTransDet.TransDetail[CntItem].QtyUnit) + SepCol +
                 FormatValue (ValAmount);
    ValTotalAmountParam := ValTotalAmountParam + ValAmount;
    PrintTableLine (TxtLine);
  end; // for
end;  // of TFrmVSRptBankOrderCA.GenerateTableBody

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateTableUnitCilindersTotal : generates the table
// with the totals of the counted results.
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateTableUnitCilindersTotal;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptBankOrderCA.GenerateTableUnitCilindersTotal
  TxtLine := ' ' + SepCol +
             ' ' + SepCol +
             ' ' + SepCol + FormatValue (ValTotalAmountC) +
             ' ' + IdtCurrency;
  VspPreview.TableCell[tcRows, Null, Null, Null, Null] := 8;
  VspPreview.TableCell[tcRowHeight, 0, 0, Null, Null] := ViValHeaderHeight;
  PrintTableLine (TxtLine);
  ConfigTableCilinders;
end;   // of TFrmVSRptBankOrderCA.GenerateTableUnitCilindersTotal

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateTableUnitBillsTotal : generates the table
// with the totals of the counted results for bills.
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateTableUnitBillsTotal;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptBankOrderCA.GenerateTableUnitBillsTotal
  TxtLine := ' ' + SepCol +
             ' ' + SepCol + FormatValue (ValTotalAmountB) +
             ' ' + IdtCurrency;
  VspPreview.TableCell[tcRows, Null, Null, Null, Null] := 8;
  PrintTableLine (TxtLine);
  ConfigTableBills;
end;   // of TFrmVSRptBankOrderCA.GenerateTableUnitBillsTotal

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateTableTotal : generates the table with the
// totals of the counted results.
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateTableTotal;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptBankOrderCA.GenerateTableTotal
  TxtLine := SepCol + SepCol + SepCol +
             FormatValue (ValTotalAmountParam) + ' ' + IdtCurrency;
  PrintTableLine (TxtLine);
  ConfigTable;
end;   // of TFrmVSRptBankOrderCA.GenerateTableTotal

//=============================================================================
// TFrmVSRptBankOrderCA.ConfigTableCilinders : configures the table Cilinders.
//=============================================================================

procedure TFrmVSRptBankOrderCA.ConfigTableCilinders;
var
  QtyRows          : Integer;          // Number of rows in table
  QtyCols          : Integer;          // Number of columns in table
begin  // of TFrmVSRptBankOrderCA.ConfigTableCilinders
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
end;   // of TFrmVSRptBankOrderCA.ConfigTableCilinders

//=============================================================================
// TFrmVSRptBankOrderCA.ConfigTable : configures the table if /FOrderParam
//=============================================================================

procedure TFrmVSRptBankOrderCA.ConfigTable;
var
  QtyRows          : Integer;          // Number of rows in table
  QtyCols          : Integer;          // Number of columns in table
begin  // of TFrmVSRptBankOrderCA.ConfigTableBills
  // Retrieve number of rows and columns
  QtyRows := VspPreview.TableCell[tcRows, Null, Null, Null, Null];
  QtyCols := VspPreview.TableCell[tcCols, Null, Null, Null, Null];

  // Set last line (= total line) bold
  VspPreview.TableCell[tcFontBold, QtyRows, 1, QtyRows, QtyCols] := True;
  // Prevent page break before total-line
  VspPreview.TableCell[tcRowKeepWithNext, QtyRows - 1, 1,
                                          QtyRows - 1, QtyCols] := True;
end;   // of TFrmVSRptBankOrderCA.ConfigTable

//=============================================================================
// TFrmVSRptBankOrderCA.ConfigTableBills : configures the table Bills
//=============================================================================

procedure TFrmVSRptBankOrderCA.ConfigTableBills;
var
  QtyRows          : Integer;          // Number of rows in table
  QtyCols          : Integer;          // Number of columns in table
begin  // of TFrmVSRptBankOrderCA.ConfigTableBills
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
  // indent the bills table so it appears on the right of the cilinders table
  VspPreview.TableCell[tcIndent, Null, Null, Null, Null] :=
                               ViValMarginLeft +
                               ColumnWidthInTwips (ViValRptWidthDetail) +
                               ColumnWidthInTwips (ViValRptWidthQty) +
                               ColumnWidthInTwips (ViValRptWidthValue) +
                               ColumnWidthInTwips (ViValRptWidthAmount) +
                               ViValSpaceBetween;
end;   // of TFrmVSRptBankOrderCA.ConfigTableBills

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateOverallTotal : generates the total result for
// both the cilinders and the bills
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateOverallTotal;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptBankOrderCA.GenerateOverallTotal
  case CodRunFunc of
    CtCodFuncOrder  :
      TxtLine := CtTxtOverallTotalOrdered + FormatValue (ValTotalAmount) +
                 ' ' + IdtCurrency;
    CtCodFuncAccept :
      TxtLine := CtTxtOverallTotalAccepted + FormatValue (ValTotalAmount) +
                 ' ' + IdtCurrency;
  end;
  VspPreview.FontSize := ViValFont12;
  VspPreview.FontBold := True;
  VspPreview.CurrentX := ViValMarginLeft;
  VspPreview.CurrentY := 7500;
  VspPreview.Text := TxtLine;
  VspPreview.FontBold := False;  
end;   // of TFrmVSRptBankOrderCA.GenerateOverallTotal

//=============================================================================
// TFrmVSRptBankOrderCA.PrintEndClause: prints the text for pièce comptable, the
// rectangle and text for 'Visa Responsable'.
//=============================================================================

procedure TFrmVSRptBankOrderCA.PrintEndClause;
begin  // of TFrmVSRptBankOrderCA.PrintEndClause
  VspPreview.FontSize := ViValFont10;
  VspPreview.CurrentX := ViValMarginLeft;
  VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom -
                         CtValVisaRespRecHeight - 750;
  VspPreview.Text := CtTxtOrderNumber;
  VspPreview.BrushStyle := bsTransparent;
  // Print a rectangle for holding the visa responsable
  VspPreview.DrawRectangle (ViValMarginLeft, VspPreview.PageHeight -
                            VspPreview.MarginBottom - CtValVisaRespRecHeight -
                            400, VspPreview.MarginLeft + CtValVisaRespRecWidth,
                            VspPreview.PageHeight - VspPreview.MarginBottom -400,
                            0, 0);
  VspPreview.FontSize := ViValFont10;
  VspPreview.CurrentX := ViValMarginLeft;
  VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom - 300;
  VspPreview.Text := CtTxtVisaResponsable;
end;   // of TFrmVSRptBankOrderCA.PrintEndClause

//=============================================================================
// TFrmVSRptBankOrderCA.PrintTrailer:
// if /FOrderParam: prints the text for the resposible persons
//=============================================================================

procedure TFrmVSRptBankOrderCA.PrintTrailer;
var
  IdtTradeMatrix      : string;        // IdtTradeMatrix of the shop
begin  // of TFrmVSRptBankOrderCA.PrintTrailer
  IdtTradeMatrix      := DmdFpnUtils.IdtTradeMatrixAssort;
  VspPreview.FontSize := ViValFont10;
  VspPreview.CurrentX := ViValMarginLeft + ViValMarginTab;
  VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom -
                         3500;
  VspPreview.Text := CtTxtTrl1 + ' ' + DmdFpnTradeMatrix.InfoTradeMatrix
                     [IdtTradeMatrix, 'TxtStreet'] + ' ' + CtTxtTrl2 + ' ' +
                     DmdFpnTradeMatrix.InfoTradeMatrix
                     [IdtTradeMatrix, 'TxtCodPost'] + ' ' +
                     DmdFpnTradeMatrix.InfoTradeMatrix
                     [IdtTradeMatrix, 'TxtMunicip'] + CtTxtTrl3;
  VspPreview.CurrentX := ViValMarginLeft + ViValMarginTab;
  VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom -
                         2750;
  VspPreview.Text := CtTxtTrl4 + ' ' + DmdFpnApplicparam.InfoApplicParam
                     [CtTxtPrmFinNameRespPerson1, 'TxtParam'] + ' ' + CtTxtTrl5
                     + ' ' + DmdFpnApplicparam.InfoApplicParam
                     [CtTxtPrmFinDNIRespPerson1, 'TxtParam'];
  VspPreview.CurrentX := ViValMarginLeft + ViValMarginTab;
  VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom - 2750
                         + VspPreview.TextHeight ['X'];
  VspPreview.Text := CtTxtTrl4 + ' ' + DmdFpnApplicparam.InfoApplicParam
                     [CtTxtPrmFinNameRespPerson2, 'TxtParam'] + ' ' + CtTxtTrl5
                     + ' ' + DmdFpnApplicparam.InfoApplicParam
                     [CtTxtPrmFinDNIRespPerson2, 'TxtParam'];
  VspPreview.CurrentX := ViValMarginLeft + ViValMarginTab;
  VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom -
                         1500;
  VspPreview.Text := CtTxtTrl6;
end;   // of TFrmVSRptBankOrderCA.PrintTrailer

//=============================================================================
// TFrmVSRptBankOrderCA.PrintTableLine : adds the line to the current Table.
//                                  -----
// INPUT   : TxtLine = line to add to the Table.
//=============================================================================

procedure TFrmVSRptBankOrderCA.PrintTableLine (TxtLine : string);
begin  // of TFrmVSRptBankOrderCA.PrintTableLine
  VspPreview.AddTable (TxtTableFmt, TxtTableHdr, TxtLine,
                       ViColHeader, ViColBody, null);
  Inc (QtyLinesPrinted);                       
end;   // of TFrmVSRptBankOrderCA.PrintTableLine

//=============================================================================
// TFrmVSRptBankOrderCA.PrintAddressParam : fetches the information of the
// pay organisation from PMntOrderChangeMoney.exe (parameters in applicparam)
//=============================================================================

procedure TFrmVSRptBankOrderCA.PrintAddressParam;
begin // of TFrmVSRptBankOrderCA.PrintAddressParam
  VspPreview.FontSize := ViValFont10;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.MarginTop + 1000;
  VspPreview.Text :=
    DmdFpnApplicParam.InfoApplicParam [CtTxtPrmFinNameBank, 'TxtParam'];
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
  VspPreview.Text :=
    DmdFpnApplicParam.InfoApplicParam [CtTxtPrmFinAddressBank, 'TxtParam'];
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + VspPreview.TextHeight ['X'];
  VspPreview.Text :=
     DmdFpnApplicParam.InfoApplicParam [CtTxtPrmFinCityBank, 'TxtParam'];
end;  // of TFrmVSRptBankOrderCA.PrintAddressParam

//=============================================================================
// TFrmVSRptBankOrderCA.PrintRef : Prints the reference
//=============================================================================

procedure TFrmVSRptBankOrderCA.PrintRef;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSRptBankOrderCA.PrintRef
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, True);
      CurrentX := PageWidth - MarginRight - TextWidth [NumRef] - 1;
      CurrentY := PageHeight - MarginBottom + TextHeight ['X'] - 250;
      Text := NumRef;
      EndOverlay;
    end;
  end;
end;   // of TFrmVSRptBankOrderCA.PrintRef

//=============================================================================
// TFrmVSRptBankOrderCA.GetTotalAmount : Getter for ValTotalAmount
//=============================================================================

function TFrmVSRptBankOrderCA.GetTotalAmount : Currency;
begin // of TFrmVSRptBankOrderCA.GetTotalAmount
  Result := ValTotalAmountB + ValTotalAmountC;
end;  // of TFrmVSRptBankOrderCA.GetTotalAmount

//=============================================================================
// TFrmVSRptBankOrderCA.DrawLogo
//=============================================================================

procedure TFrmVSRptBankOrderCA.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptBankOrderCA.DrawLogo
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
end;   // of TFrmVSRptBankOrderCA.DrawLogo

//=============================================================================
// TFrmVSRptBankOrderCA.GenerateReport : Main routine for printing the report
//=============================================================================

procedure TFrmVSRptBankOrderCA.GenerateReport;
begin // of TFrmVSRptBankOrderCA.GenerateReport
  Visible := True;
  Visible := False;
  SetLength (ArrPages, 1);
  ArrPages [Length (ArrPages) - 1] := 1;
  case CodRunFunc of
    CtCodFuncOrder, CtCodFuncAccept:   VspPreview.Orientation := orLandscape;
    CtCodFuncOrderParam:               VspPreview.Orientation := orPortrait;
  end;
  VspPreview.StartDoc;
  try
    PrintHeader;
    if LstTransDet.Count > 0 then
      IdtCurrency := LstTransDet.TransDetail[0].IdtCurrency;
    case CodRunFunc of
      CtCodFuncOrder, CtCodFuncAccept : begin
        GenerateTableUnitCilinders;
        GenerateTableUnitBills;
        GenerateOverallTotal;
        PrintEndClause;
      end;
      CtCodFuncOrderParam : begin
        GenerateTable;
        PrintTrailer;
      end;
    end;
    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
  finally
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
  PrintRef;
  if PreviewReport then
    FrmVSRptBankOrderCA.ShowModal;
end;  // of TFrmVSRptBankOrderCA.GenerateReport

//*****************************************************************************

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end. // of TFrmVSRptBankOrderCA
