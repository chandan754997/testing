//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet  : FlexPoint Development
// Customer: Castorama
// Unit    : FVSBonPassageCA.PAS : Form VideoSoft RePorT BONPASSAGE CAstorama
//                                 Report 'bon de passage en caisse'
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSBonPassageCA.pas,v 1.5 2009/10/09 08:13:53 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FVSBonPassageCA - CVS revision 1.3
//=============================================================================

unit FVSBonPassageCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil, OvcBase, OvcEF, OvcPB,
  OvcPF, ScUtils, SmVSPrinter7Lib_TLB, Db, DBTables, OleCtrls,
  ToolWin, StBarC, SfVSPrinter7;

//*****************************************************************************
// Global definitions
//*****************************************************************************

const              // general to the report
  TxtSep           = '|';              // Seperator character
  CRLF             = #13#10;           // Indicate a new line
  CtTxtFrmNumber   = '#,##0.00';       // How to format a number.
  CtTxtLogoName    = 'flexpoint.report.bmp';   // Logo to print on the rapport
  CtTxtBarCode     = 'barcode.bmp';    // bitmap image of the barcode

resourcestring     // Report labels
  CtTxtTitle       = 'ORDER PASSING ON CASH REGISTER Nr';
  CtTxtCompte      = 'Account Nr';
  CtTxtCollected   = 'Products collected by:';
  CtTxtAmount      = 'Maximum amount:';
  CtTxtCreated     = 'Created on';
  CtTxtValid       = 'Only valid on';
  CtTxtLocation    = 'In your shop in';
  CtTxtOrder       = 'Order ticket nr:';
  CtTxtDuplicate   = 'DUPLICATE';
  CtTxtPage        = 'Page';           // Show's the word Page on the buttom of
                                       // each page.

resourcestring     // Type of clients
  CtTxtCustClientCompte = 'Client en compte';
  CtTxtCustBankTransfer = 'Bank Transfer'; 

//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmVSBonPassageCA = class(TFrmVSPreview)
    StBrCdBonPassage: TStBarCode;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    // Labels for report
    IdtBonPassage          : String;     // Identification of bon de passage
    TxtCollected           : string;     // Collected by
    TxtOrder               : string;     // Order number
    IdtCustomer            : string;     // Customer identification
    TxtName                : string;     // Name of the customer
    TxtAddress             : string;     // Address of the customer
    TxtPostalCode          : string;     // Postal Code of the customer
    TxtMunicipality        : string;     // Municipality of the customer
    ValAmount              : string;     // Maximum amount of the customer
    TxtClientType          : string;     // CodType of Bon Passage
    TxtNumPLU              : string;     // Bar code
    FlgReprint             : Boolean;    // True if reprint, False if creation
    FlgRussia              : Boolean;
  published
    // Properties for the report
    property BonPassage         : string  read IdtBonPassage
                                          write IdtBonPassage;
    property Collected          : string  read TxtCollected
                                          write TxtCollected;
    property Order              : string  read TxtOrder
                                          write TxtOrder;
    property Customer           : string  read Idtcustomer
                                          write IdtCustomer;
    property Name               : string  read TxtName
                                          write TxtName;
    property Address            : string  read TxtAddress
                                          write TxtAddress;
    property PostalCode         : string  read TxtPostalCode
                                          write TxtPostalCode;
    property Municipality       : string  read TxtMunicipality
                                          write TxtMunicipality;
    property Amount             : string  read ValAmount
                                          write ValAmount;
    property NumPLU             : string  read TxtNumPLU
                                          write TxtNumPLU;
    property ClientType         : string  read TxtClientType
                                          write TxtClientType;
    property Reprint            : boolean read FlgReprint
                                          write FlgReprint;
    property Russia             : boolean read FlgRussia
                                          write FlgRussia;

    // Property to build the table rapport
    procedure PrintReport; virtual;
    procedure PrintPageNumbers; virtual;
  public
    procedure CreateBarCode; virtual;
    procedure DestroyBarCode; virtual;
  end;

var
  FrmVSBonPassageCA: TFrmVSBonPassageCA;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  ScTskMgr_BDE_DBC,
  ActiveX,
  AXCtrls,

  DFpn,
  DFpnBonPassage,
  DFpnUtils,
  DFpnTradeMatrix,

  FBonPassageCA,
  FDetCustomerCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSBonPassageCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSBonPassageCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.5 $';
  CtTxtSrcDate    = '$Date: 2009/10/09 08:13:53 $';

//*****************************************************************************
// Implementation of TFrmVSBonPassageCA
//*****************************************************************************

procedure TFrmVSBonPassageCA.PrintReport;
var
  StrFilePath      : string;           // pathname for logo
  PicLogo          : TPicture;         // Logo to be printed
  OlePicLogo       : IPictureDisp;     // Logo picture in OLE format
  VarPicWidth      : Real;             // Width of pic in twips
  VarPicHeight     : Real;             // Heigth of pic in twips
  TxtSep           : string;           // Space to put between text variables
  TxtSubTitle      : string;           // Subtitle
begin  // of TFrmVSBonPassageCA.PrintHeader
  VarPicHeight := 0;
  try
    TxtSep := ' ';
    // Logo
    strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\Image\' +
                   CtTxtLogoName;
    PicLogo := TPicture.Create;
    if FileExists (StrFilePath) then begin
      PicLogo.LoadFromFile(ReplaceEnvVar(strFilePath));
      GetOlePicture (PicLogo, OlePicLogo);
      VspPreview.CalcPicture := OlePicLogo;
      VspPreview.DrawPicture (OlePicLogo, VspPreview.MarginRight,
                              VspPreview.CurrentY, '100%', '100%', '', False);
    end; // of if FileExists (StrFilePath)
    // Barcode
    StrFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
    if FileExists (StrFilePath) then begin
      PicLogo.LoadFromFile(ReplaceEnvVar(StrFilePath));
      GetOlePicture (PicLogo, OlePicLogo);
      VspPreview.CalcPicture := OlePicLogo;
      varPicWidth  := PicLogo.Width/Screen.PixelsPerInch * 1440;
      VarPicHeight := PicLogo.Height/Screen.PixelsPerInch * 1440;
      VspPreview.DrawPicture (OlePicLogo, VspPreview.PageWidth -
                              VspPreview.MarginLeft - varPicWidth,
                              VspPreview.CurrentY, '100%', '100%', '', False);
    end; // of if FileExists (StrFilePath)
    // Header
    VspPreview.FontSize := 18;
    VspPreview.CurrentX :=
              (VspPreview.PageWidth - VspPreview.TextWidth[CtTxtTitle]) / 2;
    VspPreview.CurrentY := VspPreview.MarginTop + VarPicHeight  + 1200;
    VspPreview.Text := CtTxtTitle + BonPassage;
    // Print sub-title
    if FlgRussia then begin
      TxtSubTitle := '';
      case StrToInt (ClientType) of
        CtCodBonPasClienCompte  : TxtSubTitle := CtTxtCustClientCompte;
        CtCodBonPasBankTransfer : TxtSubTitle := CtTxtCustBankTransfer;
      end; // of case StrToInt (ClientType)
      if TxtSubTitle <> '' then begin
        VspPreview.FontSize := 16;
        VspPreview.CurrentX :=
              (VspPreview.PageWidth - VspPreview.TextWidth[TxtSubTitle]) / 2;
        VspPreview.CurrentY := VspPreview.CurrentY + 500;
        VspPreview.Text := TxtSubTitle;
      end; // of if TxtSubTitle <> ''
    end; // of if FlgRussia
    if Reprint then begin
      // Duplicate
      VspPreview.FontSize := 12;
      VspPreview.CurrentX :=
            (VspPreview.PageWidth - VspPreview.TextWidth[CtTxtDuplicate]) / 2;
      VspPreview.CurrentY := VspPreview.CurrentY + 500;
      VspPreview.Text := CtTxtDuplicate;
    end; // of if Reprint
    // Customernumber
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 2000;
    VspPreview.FontSize := 14;
    VspPreview.Text     := CtTxtCompte + ' ' + Trim(Customer);
    // Customername
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 400;
    VspPreview.FontSize := 12;
    VspPreview.Text     := TxtName;
    // Collected by... - Label
    VspPreview.CurrentX := VspPreview.PageWidth / 2;
    VspPreview.Text     := CtTxtCollected;
    // Customeraddress - Address
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 300;
    VspPreview.Text     := TxtAddress;
    // Collected by... - Value
    VspPreview.CurrentX := VspPreview.PageWidth / 2;
    VspPreview.Text     := TxtCollected;
    // Customeraddress - Postal code + municipality
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 300;
    VspPreview.Text     := TxtPostalCode + ' ' + TxtMunicipality;
    // CreditLimit
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 1700;
    VspPreview.Text     := CtTxtAmount + txtSep + ValAmount;
    // CreationDate
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 1700;
    VspPreview.Text := CtTxtCreated + txtSep + FormatDateTime('dd/mm/yyy', Now);
    // Order Nr
    VspPreview.CurrentX := VspPreview.PageWidth / 2;
    VspPreview.Text     := CtTxtOrder + txtSep + TxtOrder;
    // Only valid on
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 700;
    VspPreview.Text := CtTxtValid + txtSep + FormatDateTime('dd/mm/yyy', Now);
    // Tradematrix data
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.CurrentY := VspPreview.CurrentY + 1000;
    VspPreview.Text     := CtTxtLocation + txtSep + DmdFpnTradeMatrix.InfoTradeMatrix [
                           DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip']
  finally
    // Restore fontsize for next report (barcode)
    VspPreview.FontSize := 8;
  end;
end;   // of TFrmVSBonPassageCA.PrintHeader

//=============================================================================
// CreateBarCode : Create a barcode bitmap
//=============================================================================

procedure TFrmVSBonPassageCA.CreateBarCode;
var
  strFilePath      : string;           // pathname for barcode
begin  // of TFrmVSBonPassageCA.CreateBarCode
  StBrCdBonPassage.Code := Copy(NumPLU, 0, length(NumPLU)-1);
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  StBrCdBonPassage.SaveToFile(strFilePath);
end;   // of TFrmVSBonPassageCA.CreateBarCode

//=============================================================================
// DestroyBarCode : Destroy the barcode bitmap
//=============================================================================

procedure TFrmVSBonPassageCA.DestroyBarCode;
var
  strFilePath      : string;           // pathname for barcode
begin  // of TFrmVSBonPassageCA.DestroyBarCode
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  if FileExists (strFilePath) then
     DeleteFile(strFilePath);
end;   // of TFrmVSBonPassageCA.DestroyBarCode

//=============================================================================

procedure TFrmVSBonPassageCA.PrintPageNumbers;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSBonPassageCA.PrintPageNumbers
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, TRUE);
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1000;
      CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom + 350;
      Text := CtTxtPage + ' ' + IntToStr (CntPageNb) + '/' +
                                IntToStr (VspPreview.PageCount);
      EndOverlay;
    end;
  end;
end;   // of TFrmVSBonPassageCA.PrintPageNumbers

//=============================================================================

procedure TFrmVSBonPassageCA.FormActivate(Sender: TObject);
begin
  inherited;
  VspPreview.Orientation := orPortrait;
  VspPreview.StartDoc;
  CreateBarCode;
  PrintReport;
  DestroyBarCode;
  VspPreview.EndDoc;
  PrintPageNumbers;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FVSBonPassageCA

