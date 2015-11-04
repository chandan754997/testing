//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint
// Unit     : FVSRptCOOffline: Form VS RePorT Customer Order OFFLINE
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptCOOffline.pas,v 1.5 2009/09/28 15:32:01 BEL\KDeconyn Exp $
//=============================================================================

unit FVSRptCOOffline;

//*****************************************************************************

interface                                                    

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfVSPrinter7, ActnList, ImgList, Menus, ExtCtrls, Buttons, OleCtrls,
  SmVSPrinter7Lib_TLB, ComCtrls, ActiveX, AxCtrls, StBarC;

//*****************************************************************************
// Global definitions
//*****************************************************************************

const
  CtTxtFrmNumber   = '#,##0.00';       // How to format a number.

var // Margins
  ViValMarginLeft      : Integer =  900;   // MarginLeft for VspPreview
  ViValMarginHeader    : Integer = 3500;   // Adjust MarginTop to leave room for hdr
  ViValSalesOrderDet   : Integer = 7000;
  ViValHeightCustDet   : Integer = 2000;
  ViValWidthCustDet    : Integer = 5800;
  ViValWidthSalesOrder : Integer = 4000;
  ViValTopTotalTable   : Integer = 13000;
  ViValLeftTotalTable  : Integer = 5350;
  ViValHeightTotalTable: Integer = 700;
  ViValWithTotalTable  : Integer = 5700;

var // Fontsizes
  ViValFontHeader      : Integer = 16;     // FontSize header
  ViValFontSubTit      : Integer = 10;     // FontSize Customer header

var // Positions and white space
  ViValSpaceBetween: Integer =  200;   // White space between tables

var // barcode
  CtTxtBCCustCard      : string = 'BCCD.bmp';
  CtTxtBCSalesOrder    : string = 'BCSO.bmp';

var // Column-width (in number of characters)
  ViValNumber     : Integer = 7;      // Width of 'N°' column
  ViValBarcode    : Integer = 10;      // Width of 'Barcode' column
  ViValDescr      : Integer = 15;      // Width of 'Description' column
  ViValQty        : Integer = 10;      // Width of 'Qty' column
  ViValSU         : Integer = 10;      // Width of 'Sales unit' column
  ViValUP         : Integer = 10;      // Width of 'Unit price' column
  ViValAD         : Integer = 10;      // Width of 'After discount' column
  ViValTotal      : Integer = 10;      // Width of 'Total' column

var // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables

resourcestring     // Labels for report header
  CtTxtHdrRpt1CHS      = 'Sales Order';
  CtTxtHdrRpt2ENG      = 'Sales Order';
  CtTxtHdrRpt3CHS      = '(Only available today)';
  CtTxtGrandTotalCHS   = 'Grand total:';
  CtTxtCustCardCHS     = 'Customer card n°:';
  CtTxtSalesOrderCHS   = 'Sales order n°:';

resourcestring     //  Labels for customer details
  CtTxtCustDetCHS      = 'Customer details';
  CtTxtCustDetENG      = '/Customer details';
  CtTxtCustNoCHS       = 'Customer number';
  CtTxtCustNoENG       = '/Customer number: ';
  CtTxtCustNameCHS     = 'Customer name';
  CtTxtCustNameENG     = '/Customer name: ';
  CtTxtAddressCHS      = 'Address';
  CtTxtAddressENG      = '/Address: ';
  CtTxtTelCHS          = 'Tel';
  CtTxtTelENG          = '/Tel: ';
  CtTxtDelivCHS        = 'Way of pick up';
  CtTxtDelivENG        = '/Way of packup: ';
  CtTxtDelivDateCHS    = 'Delivery date';
  CtTxtDelivDateENG    = '/Delivery date: ';
  CtTxtSalesNoCHS      = 'Number';
  CtTxtSalesNoENG      = '/Number: ';
  CtTxtSalesDateCHS    = 'Date';
  CtTxtSalesDateENG    = '/Date: ';
  CtTxtDiscountCHS     = 'Discount';
  CtTxtDiscountENG     = '/Discount: ';
  CtTxtReceiptCHS      = 'Receipt';
  CtTxtReceiptENG      = '/Receipt: ';
  CtTxtRemarksCHS      = 'Remarks';
  CtTxtRemarksENG      = '/Remarks: ';

resourcestring     // labels for detail table
  CtTxtNumberCHS      = 'N°';
  CtTxtNumberENG      = 'N°';
  CtTxtBarcodeCHS     = 'Barcode';
  CtTxtBarcodeENG     = 'Barcode';
  CtTxtDescrCHS       = 'Description';
  CtTxtDescrENG       = 'Description';
  CtTxtQtyCHS         = 'Qty';
  CtTxtQtyENG         = 'Qty';
  CtTxtSUCHS          = 'Sales unit';
  CtTxtSUENG          = 'Sales unit';
  CtTxtUPCHS          = 'Unit price';
  CtTxtUPENG          = 'Unti price';
  CtTxtADCHS          = 'After discount';
  CtTxtADENG          = 'After discount';
  CtTxtTotalCHS       = 'Total';
  CtTxtTotalENG       = 'Total';

resourcestring     // Labels for footer
  CtTxtCompAddressCHS  = 'Company address';
  CtTxtCompAddressENG  = '/Company address: ';
  CtTxtTelephoneCHS    = 'Tel';
  CtTxtTelephoneENG    = '/Tel: ';
  CtTxtPostalCodeCHS   = 'Post code';
  CtTxtPostalCodeENG   = '/Post code: ';
  CtTxtMunicipalityCHS = 'Municipality: ';

resourcestring     // Labels for grand total
  CtTxtBDTotalCHS     = 'Before discount total';
  CtTxtBDTotalENG     = '/Before discount total: ';
  CtTxtDTotalCHS      = 'Discount total';
  CtTxtDTotalENG      = '/Discount total: ';
  CtTxtGrandTotalENG  = '/Grand total: ';
  CtTxtSignatureCHS   = 'Signature';
  CtTxtSignatureENG   = '/Signature: ';


//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmVSRptCOOffline = class(TFrmVSPreview)
    StBrCdBonPassage: TStBarCode;
    StBrCdCustCard: TStBarCode;
    StBrCdSalesOrder: TStBarCode;
    procedure VspPreviewBeforeHeader(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FIdtCVente          : double;          // IdtCVente of offline customer order
    FPicLogo            : TImage;           // Logo
    FTxtFNLogo          : string;           // Filename Logo
    FNumRef             : string;           // Report reference
    FTxtDelivery        : string;           // Delivery type
    ValBDTotal          : Double;           // Total before discount
    ValGrandTotal       : Double;           // Grand total
    ValDiscount         : Double;
    procedure SetTxtFNLogo (Value : string); virtual;
  protected
    { Protected declarations }
    ValOrigMarginTop    : Double;           // Original MarginTop
    ValLogoWidth        : integer;          // Width of report logo
    ArrPages            : array of Integer; // Array of pages to restart counting
    QtyLinesPrinted     : Integer;          // Linecounter for report
    TxtTableFmt         : string;           // Format for current Table on report
    TxtTableHdr         : string;           // Header for current Table on report
    procedure PrintPageHeader; virtual;
    procedure PrintCustomerDetails; virtual;
    procedure PrintBold (StrToPrint: string); virtual;
    procedure PrintTable; virtual;
    procedure PrintGrandTotal; virtual;
    procedure GenerateBody; virtual;
    procedure PrintTableLine (TxtLine : string); virtual;
    procedure AddFooterToPages; virtual;
    function CalcTextHeight : Double; virtual;
  public
    { Public declarations }
    property IdtCVente : double read FIdtCVente write FIdtCVente;
    property TxtFNLogo : string read  FTxtFNLogo write SetTxtFNLogo;
    property PicLogo : TImage read  FPicLogo write FPicLogo;
    property NumRef : string read  FNumRef write FNumRef;
    property TxtDelivery: string read FTxtDelivery write FTxtDelivery;
    procedure DrawLogo (ImgLogo : TImage); override;
    procedure GenerateReport; virtual;
    procedure CreateBarCode; virtual;
    procedure DestroyBarCode; virtual;
  end;

var
  FrmVSRptCOOffline: TFrmVSRptCOOffline;

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptCOOffline';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptCOOffline.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.5 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 15:32:01 $';

//*****************************************************************************

implementation

uses
  SfDialog,
  SmUtils,
  DFpnUtils,
  DFpnTradematrix, DB;

{$R *.DFM}

//*****************************************************************************
// Implementation of TFrmVSRptCOOffline
//*****************************************************************************

//=============================================================================
// TFrmVSRptCOOffline.DrawLogo
//=============================================================================

procedure TFrmVSRptCOOffline.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
  OlePicLogo       : IPictureDisp;     // Logo picture in OLE format
  ValPosLeft       : Double;           // Position left for picture
  ValPosTop        : Double;           // Position top for picture
begin  // of TFrmVSRptTransPaymentCA.DrawLogo
  if (TxtFNLogo <> '') and (Assigned (ImgLogo)) then begin
    // Assure logo is printed on top of page
    ValSaveMargin := VspPreview.MarginTop;
    VspPreview.MarginTop := ValOrigMarginTop;
    try
      ValLogoWidth := ImgLogo.Width;
      GetOlePicture (ImgLogo.Picture, OlePicLogo);
      VspPreview.X1 := 0;
      VspPreview.X2 := 0;
      VspPreview.Y1 := 0;
      VspPreview.Y2 := 0;
      VspPreview.CalcPicture := OlePicLogo;
      ValPosLeft := VspPreview.MarginLeft;
      ValPosTop := VspPreview.MarginTop;
      VspPreview.DrawPicture (OlePicLogo, ValPosLeft, ValPosTop, '100%', '100%',
                              '', False);
    finally
      VspPreview.MarginTop := ValSaveMargin;
    end;
  end;
end;   // of TFrmVSRptCOOffline.DrawLogo

//=============================================================================
// TFrmVSRptCOOffline.SetTxtFNLogo: loads the logo file into an image-object
//=============================================================================

procedure TFrmVSRptCOOffline.SetTxtFNLogo (Value: string);
begin // of TFrmVSRptCOOffline.SetTxtFNLogo
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
end;  // of TFrmVSRptCOOffline.SetTxtFNLogo

//=============================================================================
// TFrmVSRptCOOffline.GenerateReport : main routine for printing report
//=============================================================================

procedure TFrmVSRptCOOffline.GenerateReport;
begin // of TFrmVSRptCOOffline.GenerateReport
  NumRef := 'REP0039';

  Visible := True;
  Visible := False;

  SetLength (ArrPages, 1);
  ArrPages [Length (ArrPages) - 1] := 1;
  VspPreview.Orientation := orPortrait;
  VspPreview.StartDoc;
  VspPreview.Preview := True;
  try
    QtyLinesPrinted := 0;
    VspPreview.Header := ' ';
    PrintCustomerDetails;
    PrintTable;
    PrintGrandTotal;
//    PrintEndClause;
  finally
    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
//  PrintRef;
  ShowModal;
end;  // of TFrmVSRptCOOffline.GenerateReport

//=============================================================================
// TFrmVSRptCOOffline.PrintPageHeader : prints the header of the report.
//                                  -----
// Restrictions :
// - is called from VspPreview.OnBeforeHeader; provided as virtual method to
//   improve inheritance.
//=============================================================================

procedure TFrmVSRptCOOffline.PrintPageHeader;
var
  ValFontSave  : Variant;            // Save original FontSize
  ValYBC1      : Integer;            // Y value for barcode 1
  ValYBC2      : Integer;            // Y value for barcode 2
  ValYBC3      : Integer;            // Y value for barcode 3
  ValXBC       : Integer;            // X value for barcode
  strFilePath  : string;             // pathname for barcode
  PicBarCode   : TPicture;           // Logo to be printed
  OlePicLogo   : IPictureDisp;       // Logo picture in OLE format
  varPicWidth  : Real;               // Width of pic in twips
begin  // of TFrmVSRptCOOffline.PrintPageHeader
  DrawLogo (PicLogo);
  ValFontSave := VspPreview.FontSize;
  try
    // Header report count
    VspPreview.CurrentX := VspPreview.Marginleft + (ValLogoWidth * 20);
    ValXBC := VspPreview.CurrentX + 4500;
    VspPreview.CurrentY := ValOrigMarginTop;
    VspPreview.FontSize := ViValFontHeader;
    VspPreview.FontBold := True;
    ValYBC1 := VspPreview.CurrentY;
    VspPreview.Text := CtTxtHdrRpt1CHS;
    VspPreview.CurrentX := VspPreview.Marginleft + (ValLogoWidth * 20);
    VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight * 2);
    ValYBC2 := VspPreview.CurrentY;
    VspPreview.Text := CtTxtHdrRpt2ENG;
    VspPreview.CurrentX := VspPreview.Marginleft + (ValLogoWidth * 20);
    VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight * 2);
    ValYBC3 := VspPreview.CurrentY ;
    VspPreview.Text := CtTxtHdrRpt3CHS;
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight * 2);
    VspPreview.Fontsize := ViValFontSubTit;
    VspPreview.CurrentX := ValXBC;
    VspPreview.CurrentY := ValYBC1;
    VspPreview.Text := CtTxtGrandTotalCHS;
    try
      if DmdFpnUtils.QueryInfo('SELECT M_TOTAL_VENTE FROM Vente' +
                            #10'WHERE CVENTE = ' + floatToStr(IdtCVente) +
                            #10'AND FlgOffline = 1') then begin
        VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginLeft -
                                 2000;
        VspPreview.Text := DmdFpnUtils.QryInfo.FieldByName('M_TOTAL_VENTE').AsString;
      end;
    finally
      DmdFpnUtils.CloseInfo;
    end;
    VspPreview.CurrentX := ValXBC;
    VspPreview.CurrentY := ValYBC2;
    VspPreview.Text     := CtTxtCustCardCHS;
    // Barcode Customer card
    strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBCCustCard;
    if FileExists (strFilePath) then begin
      PicBarCode := TPicture.Create;
      PicBarCode.LoadFromFile(ReplaceEnvVar(strFilePath));
      GetOlePicture (PicBarCode, OlePicLogo);
      VspPreview.CalcPicture := OlePicLogo;
      varPicWidth := PicBarCode.Width/Screen.PixelsPerInch*1440;
      VspPreview.DrawPicture (OlePicLogo,
                              VspPreview.PageWidth - VspPreview.MarginLeft -
                              varPicWidth, VspPreview.CurrentY, '100%', '100%',
                              '', False);
    end;
    VspPreview.CurrentX := ValXBC;
    VspPreview.CurrentY := ValYBC3;
    VspPreview.Text := CtTxtSalesOrderCHS;
    // Barcode Saler order
    strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBCSalesOrder;
    if FileExists (strFilePath) then begin
      PicBarCode.LoadFromFile(ReplaceEnvVar(strFilePath));
      GetOlePicture (PicBarCode, OlePicLogo);
      VspPreview.CalcPicture := OlePicLogo;
      varPicWidth := PicBarCode.Width/Screen.PixelsPerInch*1440;
      VspPreview.DrawPicture (OlePicLogo,
                              VspPreview.PageWidth - VspPreview.MarginLeft -
                              varPicWidth, VspPreview.CurrentY, '100%', '100%',
                              '', False);
    end;
  finally
    VspPreview.Fontsize := ValFontSave;
    VspPreview.FontBold := False;
  end;
end;   // of TFrmVSRptCOOffline.PrintPageHeader

//=============================================================================
// TFrmVSRptCOOffline.CreateBarCode : Create a barcode bitmap
//=============================================================================

procedure TFrmVSRptCOOffline.CreateBarCode;
var
  strFilePath      : string;           // pathname for barcode
begin  // of TFrmVSRptCOOffline.CreateBarCode
  try
    if DmdFpnUtils.QueryInfo('SELECT NumCard FROM Vente' +
                        #10'WHERE CVENTE = ' + FloatToStr(IdtCVente) +
                        #10'AND FlgOffline = 1') then
      StBrCdCustCard.Code := DmdFpnUtils.QryInfo.FieldByName('NumCard').AsString
    else
      StBrCdCustCard.Code := '0';
  finally
    DmdFpnUtils.CloseInfo;
  end;
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBCCustCard;
  StBrCdCustCard.SaveToFile(strFilePath);
  StBrCdSalesOrder.Code := FloatToStr(IdtCVente);
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBCSalesOrder;
  StBrCdSalesOrder.SaveToFile(strFilePath);
end;   // of TFrmVSRptCOOffline.CreateBarCode

//=============================================================================
// TFrmVSRptCOOffline.DestroyBarCode : Destroy the barcode bitmap
//=============================================================================

procedure TFrmVSRptCOOffline.DestroyBarCode;
var
  strFilePath      : string;           // pathname for barcode
begin  // of TFrmVSRptCOOffline.DestroyBarCode
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBCCustCard;
  if FileExists (strFilePath) then
     DeleteFile(strFilePath);
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBCSalesOrder;
  if FileExists (strFilePath) then
     DeleteFile(strFilePath);
end;   // of TFrmVSRptCOOffline.DestroyBarCode

//=============================================================================
// TFrmVSRptCOOffline.CalcTextHeight : calculates VspPreview.TextHei for a
// single line in the current font.
//                                  -----
// FUNCRES : calculated TextHeight.
//=============================================================================

function TFrmVSRptCOOffline.CalcTextHeight : Double;
begin  // of TFrmVSRptCOOffline.CalcTextHeight
  VspPreview.X1 := 0;
  VspPreview.Y1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y2 := 0;

  VspPreview.CalcParagraph := 'X';
  Result := VspPreview.TextHei;
end;   // of TFrmVSRptCOOffline.CalcTextHeight

//=============================================================================
// TFrmVSRptCOOffline.PrintCustomerDetails
//=============================================================================

procedure TFrmVSRptCOOffline.PrintCustomerDetails;
var
  ValFontSave  : Variant;            // Save original FontSize
  StrCustNo :  string;
  StrCustName: string;
  StrAddress: string;
  StrTel: string;
  StrDelivDate: string;
  StrDate: string;
  StrDiscount: string;
  StrRemarks: string;
begin  // of TFrmVSRptCOOffline.PrintCustomerDetails
  ValFontSave := VspPreview.FontSize;
  VspPreview.FontSize := ViValFontSubTit;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := ViValMarginHeader;
  PrintBold(CtTxtCustDetCHS + CtTxtCustDetENG);
  try
    if DmdFpnUtils.QueryInfo('SELECT * FROM Vente' +
                        #10'WHERE CVENTE = ' + FloatToStr(IdtCVente) +
                        #10'AND FlgOffline = 1') then begin
      StrCustNo := DmdFpnUtils.QryInfo.FieldByName('IdtCustomer').AsString;
      StrCustName := DmdFpnUtils.QryInfo.FieldByName('TxtNameCust').AsString;
      StrAddress := DmdFpnUtils.QryInfo.FieldByName('TxtDelivAddress').AsString;
      StrTel := DmdFpnUtils.QryInfo.FieldByName('TxtNumPhone').AsString;
      StrDelivDate := DmdFpnUtils.QryInfo.FieldByName('DatDelivery').AsString;
      StrDate :=  DmdFpnUtils.QryInfo.FieldByName('DCreation').AsString;
      StrDiscount := DmdFpnUtils.QryInfo.FieldByName('PctDiscount').AsString;
      ValDiscount := DmdFpnUtils.QryInfo.FieldByName('PctDiscount').AsFloat;
      StrRemarks := DmdFpnUtils.QryInfo.FieldByName('TxtNote').AsString;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight*2);
  VspPreview.DrawRectangle (VspPreview.MarginLeft - 50,
                            VspPreview.CurrentY - 50,
                            VspPreview.MarginLeft + ViValWidthCustDet,
                            VspPreview.CurrentY + ViValHeightCustDet, 10, 10);
  VspPreview.DrawRectangle (ViValSalesOrderDet - 50,
                            VspPreview.CurrentY - 50,
                            ViValSalesOrderDet + ViValWidthSalesOrder,
                            VspPreview.CurrentY + ViValHeightCustDet, 10, 10);
  PrintBold(CtTxtCustNoCHS + CtTxtCustNoENG);
  VspPreview.Text := StrCustNo;
  VspPreview.CurrentX := ViValSalesOrderDet;
  PrintBold(CtTxtSalesNoCHS + CtTxtSalesNoENG);
  VspPreview.Text := FloatToStr(IdtCVente);
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight*1.5);
  PrintBold(CtTxtCustNameCHS + CtTxtCustNameENG);
  VspPreview.Text := StrCustName;
  VspPreview.CurrentX := ViValSalesOrderDet;
  PrintBold(CtTxtSalesDateCHS + CtTxtSalesDateENG);
  VspPreview.Text := StrDate;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight*1.5);
  PrintBold(CtTxtAddressCHS + CtTxtAddressENG);
  VspPreview.Text := StrAddress;
  VspPreview.CurrentX := ViValSalesOrderDet;
  PrintBold(CtTxtDiscountCHS + CtTxtDiscountENG);
  VspPreview.Text := StrDiscount;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight*1.5);
  PrintBold(CtTxtTelCHS + CtTxtTelENG);
  VspPreview.Text := StrTel;
  VspPreview.CurrentX := ViValSalesOrderDet;
  PrintBold(CtTxtReceiptCHS + CtTxtReceiptENG);
  VspPreview.Text := '';
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight*1.5);
  PrintBold(CtTxtDelivCHS + CtTxtDelivENG);
  VspPreview.Text := TxtDelivery;
  VspPreview.CurrentX := ViValSalesOrderDet;
  PrintBold(CtTxtRemarksCHS + CtTxtRemarksENG);
  VspPreview.Text := StrRemarks;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight*1.5);
  PrintBold(CtTxtDelivDateCHS + CtTxtDelivDateENG);
  VspPreview.Text := StrDelivDate;
  VspPreview.Fontsize := ValFontSave;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + (CalcTextHeight*3);
end;   // of TFrmVSRptCOOffline.PrintCustomerDetails

//=============================================================================
// TFrmVSRptCOOffline.PrintBold
//=============================================================================

procedure TFrmVSRptCOOffline.PrintBold (StrToPrint: string);
begin  // of TFrmVSRptCOOffline.PrintBold
  VspPreview.FontBold := True;
  VspPreview.Text := StrToPrint;
  VspPreview.FontBold := False;
end;   // of TFrmVSRptCOOffline.PrintBold

//=============================================================================
// TFrmVSRptCOOffline.PrintTable: Define the format of the table
//=============================================================================

procedure TFrmVSRptCOOffline.PrintTable;
begin // of TFrmVSRptCOOffline.PrintTable

  // initialization of number of lines
  QtyLinesPrinted := 0;

  // set table and header format
  TxtTableFmt := '<' + Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValNumber)]);
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValBarcode)]);
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValDescr)]);
  TxtTableFmt := TxtTableFmt + SepCol + '>' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValQty)]);
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValSU)]);
  TxtTableFmt := TxtTableFmt + SepCol + '>' +
                 Format ('%s%d', [FormatAlignLeft,
                                 ColumnWidthInTwips (ViValUP)]);
  TxtTableFmt := TxtTableFmt + SepCol + '>' +
                 Format ('%s%d', [FormatAlignLeft,
                                 ColumnWidthInTwips (ViValAD)]);
  TxtTableFmt := TxtTableFmt + SepCol + '>' +
                 Format ('%s%d', [FormatAlignLeft,
                                 ColumnWidthInTwips (ViValTotal)]);

  TxtTableHdr :=   CtTxtNumberCHS + #10 + CtTxtNumberENG + SepCol +
                   CtTxtBarcodeCHS + #10 + CtTxtBarcodeENG + SepCol +
                   CtTxtDescrCHS  + #10 + CtTxtDescrENG + SepCol +
                   CtTxtQtyCHS + #10 + CtTxtQtyENG + SepCol + CtTxtSUCHS + #10 +
                   CtTxtSUENG +SepCol + CtTxtUPCHS + #10 + CtTxtUPENG + SepCol +
                   CtTxtADCHS + #10 + CtTxtADENG + SepCol + CtTxtTotalCHS +
                   #10 + CtTxtTotalENG;
  VspPreview.StartTable;
  try
    GenerateBody;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;

end;  // of TFrmVSRptCOOffline.PrintTable

//=============================================================================
// TFrmVSRptCOOffline.GenerateBody : Prints the body (detail) of the table
//=============================================================================

procedure TFrmVSRptCOOffline.GenerateBody;
var
  TxtLine             : string;           // line for payment transfer
  StrNumber           : string;
  StrBarcode          : string;
  StrDescr            : string;
  ValQty              : Double;
  StrSalesUnit        : string;
  ValUnitPrice        : Double;
  ValAfterDiscount    : Double;
  ValTotal            : Double;
begin // of TFrmVSRptCOOffline.GenerateBody
  ValBDTotal := 0; // reset total before discount
  ValGrandTotal := 0; // reset grand total
  VspPreview.TableBorder := tbbox;
  try
    if DmdFpnUtils.QueryInfo('SELECT * FROM Vente_Ligne' +
                          #10'WHERE CVENTE = ' + FloatToStr(IdtCVente)) then begin
      DmdFpnUtils.QryInfo.First;
      while not DmdFpnUtils.QryInfo.Eof do begin
        StrNumber := DmdFpnUtils.QryInfo.FieldByName('CVENTE_LIGNE').AsString;
        StrBarCode := DmdFpnUtils.QryInfo.FieldByName('CESCLAVE').AsString;
        StrDescr := DmdFpnUtils.QryInfo.FieldByName('LIB_ESCLAVE').AsString;
        ValQty := DmdFpnUtils.QryInfo.FieldByName('QTE_SAISI').AsFloat;
        StrSalesUnit := DmdFpnUtils.QryInfo.FieldByName('TxtSalesUnit').AsString;
        ValUnitPrice :=  DmdFpnUtils.QryInfo.FieldByName('M_PV_SAISI').AsFloat;
        ValAfterDiscount := ValUnitPrice / 100 * (100 - ValDiscount);
        ValTotal := ValQty * ValAfterDiscount;
        TxtLine := StrNumber + SepCol + StrBarcode + SepCol + StrDescr + SepCol +
                   FormatFloat (CtTxtFrmNumber, ValQty) + SepCol + StrSalesUnit +
                   SepCol + FormatFloat (CtTxtFrmNumber, ValUnitPrice) +
                   SepCol + FormatFloat (CtTxtFrmNumber, ValAfterDiscount) +
                   SepCol + FormatFloat (CtTxtFrmNumber, ValTotal);
        PrintTableLine (TxtLine);
        ValBDTotal := ValBDTotal + (ValQty * ValUnitPrice);
        ValGrandTotal := ValGrandtotal + (ValQty * ValAfterDiscount);
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;

end;  // of TFrmVSRptCOOffline.GenerateBody

//=============================================================================
// TFrmVSRptCOOffline.PrintTableLine : adds the line to the current Table.
//                                  -----
// INPUT   : TxtLine = line to add to the Table.
//=============================================================================

procedure TFrmVSRptCOOffline.PrintTableLine (TxtLine : string);
begin  // of TFrmVSRptTransPaymentCA.PrintTableLine
  VspPreview.AddTable (TxtTableFmt, TxtTableHdr, TxtLine,
                       ViColBody, ViColBody, False);
  Inc (QtyLinesPrinted);
end;   // of TFrmVSRptCOOffline.PrintTableLine

//=============================================================================
// TFrmVSRptTransPaymentCA.PrintGrandTotal : adds Sub Totals to the report.
//=============================================================================

procedure TFrmVSRptCOOffline.PrintGrandTotal;
var
  TxtGrandTotal     : string;        // printline voor grand totals
  TxtTableFmtGT     : string;
begin  // of TFrmVSRptCOOffline.PrintGrandTotal
  VspPreview.CurrentX := ViValLeftTotalTable + 50;
  VspPreview.CurrentY := ViValTopTotalTable + 50;
  VspPreview.StartTable;
  VspPreview.TableBorder := tbnone;
  TxtTableFmtGT := '<' + Format ('%s%d', [FormatAlignLeft,
                   ColumnWidthInTwips (40)])  + SepCol +
                   '<' + Format ('%s%d', [FormatAlignLeft,
                   ColumnWidthInTwips (35)])  + SepCol + '>' +
                   Format ('%s%d', [FormatAlignLeft, ColumnWidthInTwips (15)]);
  TxtGrandTotal := SepCol +CtTxtBDTotalCHS + CtTxtBDTotalENG + SepCol +
                   FormatFloat(CtTxtFrmNumber, ValBDTotal);
  VspPreview.AddTable (TxtTableFmtGT, '', TxtGrandTotal,
                       ViColBody, ViColBody, False);
  Inc (QtyLinesPrinted);
  TxtGrandTotal := SepCol +CtTxtDTotalCHS + CtTxtDTotalENG + SepCol +
                   FormatFloat(CtTxtFrmNumber, ValBDTotal - ValGrandTotal);
  VspPreview.AddTable (TxtTableFmtGT, '', TxtGrandTotal,
                       ViColBody, ViColBody, False);
  Inc (QtyLinesPrinted);
  TxtGrandTotal := SepCol +CtTxtGrandTotalCHS + CtTxtGrandTotalENG + SepCol +
                   FormatFloat(CtTxtFrmNumber, ValGrandTotal);
  VspPreview.AddTable (TxtTableFmtGT, '', TxtGrandTotal,
                       ViColBody, ViColBody, False);
  Inc (QtyLinesPrinted);
  VspPreview.TableCell[tcFontBold, 1, 2, 3, 2] := True;
  VspPreview.EndTable;
  VspPreview.DrawRectangle (ViValLeftTotalTable,
                            ViValTopTotalTable,
                            ViValLeftTotalTable + ViValWithTotalTable,
                            ViValTopTotalTable + ViValHeightTotalTable, 10, 10);
  VspPreview.CurrentX := ViValLeftTotalTable + 1500;
  VspPreview.CurrentY := ViValTopTotalTable + 750;
  PrintBold(CtTxtSignatureCHS + CtTxtSignatureENG);
end;   // of TFrmVSRptCOOffline.PrintGrandTotal

//=============================================================================
// TFrmVSRptCOOffline.AddFooterToPages
//=============================================================================

procedure TFrmVSRptCOOffline.AddFooterToPages;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
  NumPage          : Integer;          // PageNumber
  TotPage          : Integer;          // total Pages
  CntArray         : Integer;          // Array counter
  TxtNumPhone      : string;           // telephone number
begin  // of TFrmVSRptCOOffline.AddFooterToPages
  CntArray := 0;
  NumPage := 0;
  TotPage := 0;
  try
    if DmdFpnUtils.QueryInfo('SELECT TxtNumPhone FROM Tradematrix') then
      TxtNumphone := DmdFpnUtils.QryInfo.FieldByName('TxtNumPhone').AsString;
  finally
    DmdFpnUtils.CloseInfo;
  end;
  for CntPage := 1 to VspPreview.PageCount do begin
    VspPreview.StartOverlay (CntPage, False);
    try
      Inc (NumPage);
      if CntPage >= ArrPages[CntArray] then begin
        NumPage := 1;
        Inc (CntArray);
        TotPage := ArrPages [CntArray] - ArrPages [CntArray - 1];
      end;
      // Add shop information to report
      VspPreview.CurrentX := VspPreview.MarginLeft;
      VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                             VspPreview.TextHeight ['X'];
      PrintBold(CtTxtCompAddressCHS + CtTxtCompAddressENG);
      VspPreview.Text := DmdFpnTradeMatrix.InfoTradeMatrix
                         [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtStreet'];
      VspPreview.CurrentX := VspPreview.MarginLeft;
      VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                             (VspPreview.TextHeight ['X'] * 2);
      VspPreview.Text := CtTxtTelephoneCHS + CtTxtTelephoneENG + TxtNumPhone +
                         ' ' + CtTxtPostalCodeCHS + CtTxtPostalCodeENG +
                         DmdFpnTradeMatrix.InfoTradeMatrix
                         [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'];
      VspPreview.CurrentX := VspPreview.MarginLeft;
      VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                             (VspPreview.TextHeight ['X'] * 3);
      VspPreview.Text := CtTxtMunicipalityCHS + DmdFpnTradeMatrix.InfoTradeMatrix
                         [DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'];
      // Add page number and date to report
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
end;   // of TFrmVSRptCOOffline.AddFooterToPages

//=============================================================================

procedure TFrmVSRptCOOffline.FormCreate(Sender: TObject);
begin
  inherited;
  // Set defaults
  TxtFNLogo := CtTxtEnvVarStartDir + '\Image\FlexPoint.Report.BMP';

  // Overrule default properties for VspPreview.
  VspPreview.MarginLeft := ViValMarginLeft;
  // Leave room for header
  ValOrigMarginTop      := VspPreview.MarginTop;
  VspPreview.MarginTop  := ValOrigMarginTop + ViValMarginHeader;
end;

//=============================================================================

procedure TFrmVSRptCOOffline.VspPreviewBeforeHeader(Sender: TObject);
begin
  inherited;
  CreateBarCode;
  PrintPageHeader;
  DestroyBarCode;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end. // of TFrmVSRptCOOffline
