//===== Copyright 2011 (c) Kingfisher IT Services. All rights reserved. =======
// Packet   : FlexPoint Development
// Unit     : FVSCustomerSheet.PAS : Form VideoSoft RePorT CustomerSheet CAstorama
//                                 Report 'Ficha Cliente'
//-----------------------------------------------------------------------------
// PVCS   :  $Header: $
// History:
// Version      ModifiedBy      Reason
// 1.0          TT. (TCS)       Initial Write - R2011.2 - BRES - Ficha Cliente
// 1.1          ARB             Small Fix - R2011.2.19.1 - BRES - Ficha Cliente
// 1.2          TT. (TCS)       Defect#29 Fix - R2011.2 - BRES - Ficha Cliente
// 1.3          SPN (TCS)       R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet
//=============================================================================

unit FVSCustomerSheet;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfVSPrinter7, ActnList, ImgList, Menus, ExtCtrls, Buttons, OleCtrls,
  SmVSPrinter7Lib_TLB, ComCtrls, StdCtrls;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtHeading = 'CUSTOMER SHEET';
  CtTxtCustomerNum = 'Customer Number';
  CtTxtCustomerName = 'Name';
  CtTxtCustomerTitle = 'Title';
  CtTxtAddress = 'Street';
  CtTxtPostalCode = 'Zip Code';
  CtTxtMunicipality = 'Municipality';
  CtTxtProvince = 'Province';
  CtTxtCountry = 'Country';
  CtTxtCredit = 'Credit Limit';
  CtTxtVATNum = 'VAT Number';
  CtTxtCodeVat = 'Code VAT';
  CtTxtInvoiceNum = 'No. of copies invoice';
  CtTxtDatCreate = 'Date of Creation';
  CtTxtDatModify = 'Date of Modification';
  CtTxtCustomer = 'Customer';
  CtTxtPrint = 'Printed on';
  CtTxtAt = 'at';
  //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN.start
  CtTxtCustCommunication = 'Want to receive commertial communications';
  CtTxtYes = 'Yes' ;                                                           
  CtTxtNo = 'No' ;
  //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN.end
//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmVSCustomerSheet = class(TFrmVSPreview)
   procedure FormActivate(Sender: TObject);
  private
    // Labels for report
    { Private declarations }
    TxtName                  : string;     // Name of the customer
    TxtTitle                 : string;     // Title of the customer
    IdtCustomer              : string;     // Customer identification
    TxtAddress               : string;     // Address of the customer
    TxtPostalCode            : string;     // Postal Code of the customer
    TxtMunicipality          : string;     // Municipality of the customer
    TxtNameCountry           : string;     // Country of the customer
    TxtProvince              : string;     // Province of the customer
    FFlgCreditLim            : Boolean;    // Credit amount is available or not
    ValCreditLim             : string;     // Credit amount of the customer
    IdtCurrency              : string;     // Currency
    TxtNumVAT                : string;     // Customer VAT number
    TxtPublDescr             : string;     // Customer VAT code
    QtyCopyInv               : string;     // Number of invoice copy
    DatCreate                : TDateTime;  // Date of creation
    DatModify                : TDateTime;  // Date of modification
    CustCommunication        : String;     // Commertial communication          //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN
  published
    // Properties for the report
    property Name                  : string     read txtName
                                                write txtName;
    property Customer              : string     read Idtcustomer
                                                write IdtCustomer;
    property Title                 : string     read TxtTitle
                                                write TxtTitle;
    property Address               : string     read TxtAddress
                                                write TxtAddress;
    property PostalCode            : string     read TxtPostalCode
                                                write TxtPostalCode;
    property Municipality          : string     read TxtMunicipality
                                                write TxtMunicipality;
    property Country               : string     read TxtNameCountry
                                                write TxtNameCountry;
    property Province              : string     read TxtProvince
                                                write TxtProvince;
    property FlgCreditLim          : Boolean    read FFlgCreditLim
                                                write FFlgCreditLim;
    property Amount                : string     read ValCreditLim
                                                write ValCreditLim;
    property Currencycust          : string     read IdtCurrency
                                                write IdtCurrency;
    property VATNum                : string     read TxtNumVAT
                                                write TxtNumVAT;
    property CodeVAT               : string     read TxtPublDescr
                                                write TxtPublDescr;
    property InvoiceNum            : string     read QtyCopyInv
                                                write QtyCopyInv;
    property DateCreate            : TDateTime  read DatCreate
                                                write DatCreate;
    property DateModify            : TDateTime  read DatModify
                                                write DatModify;
    property CustomerCommunication : string     read CustCommunication          //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN
                                                write CustCommunication;


    // Property to build the report
    procedure PrintReport; virtual;
  public
    { Public declarations }
  end;

var
  FrmVSCustomerSheet: TFrmVSCustomerSheet;

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
  DFpnUtils,
  DFpnTradeMatrix,
  FDetCustomerCA;
{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSCustomerSheet';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2013/10/03 08:13:53 $';

//*****************************************************************************
// Implementation of TFrmVSCustomerSheet
//*****************************************************************************

procedure TFrmVSCustomerSheet.PrintReport;
var
  LeftMargin            : string;
  RightMargin           : string;
  tempy:string;   //ARB R2011.2.19.1
//R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN.Start
const
  CtTextYes = 1;
  CtTextNo  = 0;
//R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN.End
begin
  LeftMargin            := VspPreview.CurrentX - 200;
  RightMargin           := VspPreview.CurrentX + 10650;

  //CustomerSheet Heading
  VspPreview.FontSize   := 14;
  VspPreview.CurrentX   := (VspPreview.PageWidth -
                            VspPreview.TextWidth[CtTxtHeading]) / 2;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.Text       := CtTxtHeading;

  VspPreview.BrushStyle := bsTransparent;
  VspPreview.BrushColor := clBlack;
  tempy:= VspPreview.CurrentY;  //ARB007
  VspPreview.TextBox ('', LeftMargin,
                          VspPreview.CurrentY + 500, RightMargin,
                          VspPreview.CurrentY - 100, True, False, True);

  //CustomerNumber
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY := tempy;//ARB0077
  VspPreview.CurrentY   := VspPreview.CurrentY + 600;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtCustomerNum + ':' ;
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := Customer;

  //CustomerName
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := VspPreview.CurrentY + 400;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtCustomerName + ':' ;
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := Name;

  tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.BrushColor := clBlack;
  VspPreview.TextBox ('', LeftMargin,
                          VspPreview.CurrentY + 1000, RightMargin,
                          VspPreview.CurrentY - 0, True, False, True);

  //CustomerTitle
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := tempy;//ARB R2011.2.19.1
  VspPreview.CurrentY   := VspPreview.CurrentY + 1200;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtCustomerTitle + ':';
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := Title;

  //CustomerStreet
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := VspPreview.CurrentY + 400;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtAddress + ':' ;
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := Address;

  //CustomerZipcode
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := VspPreview.CurrentY + 400;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtPostalCode + ':' ;
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := PostalCode;

  //CustomerMunicipality
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := VspPreview.CurrentY + 400;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtMunicipality + ':';
  VspPreview.CurrentX   := VspPreview.PageWidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := Municipality;

  //CustomerProvince
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := VspPreview.CurrentY + 400;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtProvince + ':' ;
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := Province;

  //CustomerCountry
  VspPreview.CurrentX   := VspPreview.PageWidth / 2 - 500;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtCountry + ':';
  VspPreview.CurrentX   := VspPreview.PageWidth / 2 + 1000;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := Country;
  tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.BrushColor := clBlack;
  VspPreview.TextBox ('', LeftMargin,
                          VspPreview.CurrentY + 800, RightMargin,
                          VspPreview.CurrentY - 4500, True, False, True);

  //CustomerCreditlimit flag
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY := tempy;//ARB R2011.2.19.1
  VspPreview.CurrentY   := VspPreview.CurrentY + 900;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtCredit + ':' ;
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := BoolToStr(FlgCreditLim,'Y');

  //CustomerCreditlimt value
  VspPreview.CurrentX   := VspPreview.PageWidth / 2 - 500;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtCredit + ':';
  VspPreview.CurrentX   := VspPreview.PageWidth / 2 + 2500;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := Amount + ' ' + Currencycust;

  tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.BrushColor := clBlack;
  VspPreview.TextBox ('', LeftMargin,
                          VspPreview.CurrentY + 800, RightMargin,
                          VspPreview.CurrentY - 4500, True, False, True);

  //CustomerVATnumber
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY := tempy;//ARB R2011.2.19.1
  VspPreview.CurrentY   := VspPreview.CurrentY + 1000;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtVATNum + ':';
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := VATNum;

  //CustomerVATcode
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := VspPreview.CurrentY + 400;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtCodeVat + ':';
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CodeVAT ;

  //Number of Invoice
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := VspPreview.CurrentY + 400;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtInvoiceNum  + ':';
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := InvoiceNum ;

  //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN.Start
  tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
  VspPreview.TextBox ('', LeftMargin,
                          VspPreview.CurrentY + 800, RightMargin,
                          VspPreview.CurrentY - 7200, True, False, True);

  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := tempy;
  VspPreview.CurrentY   := VspPreview.CurrentY + 900;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtCustCommunication  + ':';
  VspPreview.CurrentX   := VspPreview.pagewidth / 2;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  if (CustomerCommunication = inttostr(CtTextNo)) then
    VspPreview.Text     := CtTxtNo
  else if (CustomerCommunication = inttostr(CtTextYes)) then
    VspPreview.Text     := CtTxtYes
  else
    VspPreview.Text     := '';
  //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN.End

  tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
  VspPreview.TextBox ('', LeftMargin,
                          VspPreview.CurrentY + 800, RightMargin,
                          VspPreview.CurrentY - 7200, True, False, True);


  //Date of Creation
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY := tempy;//ARB R2011.2.19.1
  VspPreview.CurrentY   := VspPreview.CurrentY + 1000;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtDatCreate + ':';
  VspPreview.CurrentX   := VspPreview.pagewidth / 4 + 600;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := FormatDateTime('dd/mm/yyyy', DateCreate);

  //Date of Modification
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := VspPreview.CurrentY + 500;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtDatModify + ':';
  VspPreview.CurrentX   := VspPreview.pagewidth / 4 + 600;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := FormatDateTime('dd/mm/yyyy', DateModify);

  tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
  VspPreview.BrushStyle := bsTransparent;
  VspPreview.BrushColor := clBlack;
  VspPreview.TextBox ('', VspPreview.PageWidth / 2 - 700,
                          VspPreview.CurrentY + 1000, VspPreview.CurrentX + 1500,
                          VspPreview.CurrentY - 7500, True, False, True);

  //Customer Signature
  VspPreview.CurrentX   := VspPreview.PageWidth / 2 - 500;
  VspPreview.CurrentY := tempy;//ARB R2011.2.19.1
  VspPreview.CurrentY   := VspPreview.CurrentY + 1100;                              //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtCustomer;

  //Customer Sheet Printing date and time
  VspPreview.CurrentX   := VspPreview.MarginLeft;
  VspPreview.CurrentY   := VspPreview.CurrentY + 3000;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := CtTxtPrint  + ':';
  VspPreview.CurrentX   := VspPreview.pagewidth / 4;
  VspPreview.CurrentY   := VspPreview.CurrentY + 0;
  VspPreview.FontSize   := 12;
  VspPreview.Text       := FormatDateTime('dd/mm/yyy', Now) + ' ' + CtTxtAt + ' ' +     //R2011.2 - BRES - Ficha Cliente - Defect#29 Fix
                           FormatDateTime('hh:m:ss', Now);

end;
//=============================================================================

procedure TFrmVSCustomerSheet.FormActivate(Sender: TObject);
begin
  inherited;
  VspPreview.Orientation := orPortrait;
  VspPreview.StartDoc;
  PrintReport;
  VspPreview.EndDoc;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FVSCustomerSheet
