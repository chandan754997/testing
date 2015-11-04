//===== Copyright 2011 (c) Kingfisher IT Services. All rights reserved. =======
// Packet   : FlexPoint Development
// Unit     : FVSOperatorSheet.PAS : Form VideoSoft RePorT OperatorSheet Castorama
//                                   Report 'Ficha Operateur'
//-----------------------------------------------------------------------------
// PVCS   :  $Header: $
// History:
// Version      ModifiedBy      Reason
// 1.0          VKR. (TCS)      Initial Write - R2011.2 - BRES - Ficha Operator
// 1.1          ARB             Small Fix - R2011.2.19.1 - BRES - Ficha Operator
// 1.2          TT.(TCS)        Defect #238 Enhancement - R2011.2 - BRES - Ficha Operator
//=============================================================================

unit FVSFichaOperator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfVSPrinter7, ActnList, ImgList, Menus, ExtCtrls, Buttons, OleCtrls,
  SmVSPrinter7Lib_TLB, ComCtrls, StdCtrls;


//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring     // Report labels

CtTxtTitle                 = 'OPERATOR DATASHEET REPORT';
CtTxtOperatorNumber        = 'Operator Number';
CtTxtOperatorName          = 'Name';
CtTxtOperatorFunction      = 'Function';
CtTxtIsAdmin               = 'IsAdmin';
CtTxtLanguage              = 'Language';
CtTxtIdentificationNumber  = 'Identification Number';
CtTxtDatCreate             = 'Date of Creation';
CtTxtDatModify             = 'Date of Modification';
CtTxtOperator              = 'Operator';
CtTxtPrint                 = 'Printed on';
CtTxtAt                    = 'at';
//CtTxtPage                  = 'Page';           // Show's the word Page on the buttom of
                                              // each page.
CtTxtTenderCountYes        = 'Yes';           // Defect #238 Enhancement - R2011.2 - BRES - Ficha Operator
CtTxtTenderCountNo         = 'No';            // Defect #238 Enhancement - R2011.2 - BRES - Ficha Operator

type
  TFrmVSFichaOperator = class(TFrmVSPreview)
  procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
     IdtOperator               : string;     // Operator Number
     TxtName                   : string;     // Name of the operator
     CodSecurity               : string;     // Function of the operator
     FlgTenderCount            : Boolean;    // Indicates if the operator is allowed to count for
                                             // other operators in the Tender modules
     IdtLanguage               : string;     // Language of the operator
     TxtPassword               : string;     // Identification Number of the operator
     DatCreate                 : TDateTime;  //date of creation
     DatModify                 : TDateTime;  //date of modification
  published
     property OperatorNumber           : string  read IdtOperator
                                           write IdtOperator;
     property Name                     : string  read txtName
                                           write txtName;
     property OperatorFunction         : string read  CodSecurity
                                           write CodSecurity;
     property IsAdmin                  : Boolean read FlgTenderCount
                                           write FlgTenderCount;
     property Language                 : string read  IdtLanguage
                                           write IdtLanguage;
     property IdentificationNumber     : string read  TxtPassword
                                              write TxtPassword;
     property DateCreate               : TDateTime  read DatCreate
                                              write DatCreate;
    property DateModify                : TDateTime  read DatModify
                                             write DatModify;

    // Property to build the report
    procedure PrintReport; virtual;

  //  procedure PrintPageNumbers; virtual;
  public
    { Public declarations }

  end;

var
  FrmVSFichaOperator: TFrmVSFichaOperator;

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  ScTskMgr_BDE_DBC,
  ActiveX,
  AXCtrls,
  //StDate,
  //StDateSt,
  DFpn,
  DFpnUtils,
 // DFpnTradeMatrix,
  FDetOperatorCA;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSOperatorSheet';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2011/12/13 10:10:13 $';

//*****************************************************************************
// Implementation of TFrmVSOperatorSheet
//*****************************************************************************


procedure TFrmVSFichaOperator.PrintReport;
var
leftmargin:string;
rightmargin:string;
tempy:string;   //ARB R2011.2.19.1
begin
    leftmargin:=VspPreview.CurrentX + 100;
    rightmargin:= VspPreview.CurrentX + 10000;
    VspPreview.BrushStyle := bsTransparent;
    VspPreview.BrushColor := clBlack;

    //Operator Sheet Title
    VspPreview.FontSize := 18;
    VspPreview.CurrentX :=
              (VspPreview.PageWidth - VspPreview.TextWidth[CtTxtTitle]) / 2;
    VspPreview.CurrentY := VspPreview.MarginTop + 0;
    VspPreview.Text := CtTxtTitle;

    tempy:= VspPreview.CurrentY;  //ARB007
    VspPreview.TextBox ('', leftmargin,
                          VspPreview.CurrentY + 700, rightmargin,
                          VspPreview.CurrentY - 0, True, False, True);

    //Operator Number
    VspPreview.CurrentX := VspPreview.MarginLeft + 200;
    VspPreview.CurrentY := tempy;//ARB0077

    VspPreview.CurrentY := VspPreview.CurrentY + 900;
    VspPreview.FontSize := 12;
    VspPreview.Text     := CtTxtOperatorNumber + ':';
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := OperatorNumber;

    //Operator Name
    VspPreview.CurrentX := VspPreview.MarginLeft + 200;
    VspPreview.CurrentY := VspPreview.CurrentY + 500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := CtTxtOperatorName + ':';
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := Name;

    tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
    VspPreview.BrushStyle := bsTransparent;
    VspPreview.BrushColor := clBlack;
    VspPreview.TextBox ('', leftmargin,
                          VspPreview.CurrentY + 1200, rightmargin,
                          VspPreview.CurrentY - 1400, True, False, True);

    //Operator Function
    VspPreview.CurrentX := VspPreview.MarginLeft + 200;
    VspPreview.CurrentY := tempy;//ARB R2011.2.19.1
    VspPreview.CurrentY := VspPreview.CurrentY + 1400;
    VspPreview.FontSize := 12;
    VspPreview.Text     := CtTxtOperatorFunction + ':';
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := OperatorFunction;

    //Operator IsAdmin
    VspPreview.CurrentX := VspPreview.MarginLeft + 200;
    VspPreview.CurrentY := VspPreview.CurrentY + 500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := CtTxtIsAdmin + ':';
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.FontSize := 12;
    //VspPreview.Text     := BoolToStr(FlgTenderCount,'Y');                      // Commented out, Defect #238 Enhancement - R2011.2 - BRES - Ficha Operator
    // Defect #238 Enhancement - R2011.2 - BRES - Ficha Operator - Start
    if FlgTenderCount = true then
      VspPreview.Text   := CtTxtTenderCountYes
    else
      VspPreview.Text   := CtTxtTenderCountNo;
    // Defect #238 Enhancement - R2011.2 - BRES - Ficha Operator - End

    tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
    VspPreview.BrushStyle := bsTransparent;
    VspPreview.BrushColor := clBlack;
    VspPreview.TextBox ('', leftmargin,
                          VspPreview.CurrentY + 1200, rightmargin,
                          VspPreview.CurrentY - 3000, True, False, True);

    //Operator Language
    VspPreview.CurrentX := VspPreview.MarginLeft + 200;
    VspPreview.CurrentY := tempy;//ARB R2011.2.19.1
    VspPreview.CurrentY := VspPreview.CurrentY + 1400;
    VspPreview.FontSize := 12;
    VspPreview.Text     := CtTxtLanguage + ':';
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := Language;

    //Operator Identification Number
    VspPreview.CurrentX := VspPreview.MarginLeft + 200;
    VspPreview.CurrentY := VspPreview.CurrentY + 700;
    VspPreview.FontSize := 12;
    VspPreview.Text     := CtTxtIdentificationNumber + ':';
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := IdentificationNumber;

    tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
    VspPreview.BrushStyle := bsTransparent;
    VspPreview.BrushColor := clBlack;
    VspPreview.TextBox ('', leftmargin,
                          VspPreview.CurrentY + 1200, rightmargin,
                          VspPreview.CurrentY - 5300, True, False, True);


    //Date of Creation
    VspPreview.CurrentX := VspPreview.MarginLeft + 200;
    VspPreview.CurrentY := tempy;//ARB R2011.2.19.1
    VspPreview.CurrentY := VspPreview.CurrentY + 1400;
    VspPreview.FontSize := 12;
    VspPreview.Text     := CtTxtDatCreate + ':';
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := FormatDateTime('dd/mm/yyyy',DateCreate);

    //Date of Modification
    VspPreview.CurrentX := VspPreview.MarginLeft + 200;
    VspPreview.CurrentY := VspPreview.CurrentY + 600;
    VspPreview.FontSize := 12;
    VspPreview.Text     := CtTxtDatModify + ':';
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := FormatDateTime('dd/mm/yyyy', DateModify);

    tempy:= VspPreview.CurrentY;  //ARB R2011.2.19.1
    VspPreview.BrushStyle := bsTransparent;
    VspPreview.BrushColor := clBlack;
    VspPreview.TextBox ('', VspPreview.CurrentX - 1300,
                          VspPreview.CurrentY + 1200, VspPreview.CurrentX - 2000,
                          VspPreview.CurrentY - 5300, True, False, True);

   // Operator Signature
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.CurrentY := tempy;//ARB R2011.2.19.1
    VspPreview.CurrentY := VspPreview.CurrentY +1300;
    VspPreview.FontSize := 12;
    VspPreview.Text     := CtTxtOperator;
    VspPreview.CurrentX := VspPreview.MarginLeft + 200;
    VspPreview.CurrentY := VspPreview.CurrentY + 3500;
    VspPreview.FontSize := 12;

    //Printing Date and Time
    VspPreview.Text     := CtTxtPrint + ':';
    VspPreview.CurrentX := VspPreview.MarginLeft + 5500;
    VspPreview.FontSize := 12;
    VspPreview.Text     := FormatDateTime('dd/mm/yyy', Now) + ' ' + CtTxtAt + ' ' +
                           FormatDateTime('hh:mm:ss', Now);

end;

//=============================================================================
{
procedure TFrmVSFichaOperator.PrintPageNumbers;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSFichaOperator.PrintPageNumbers
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
end;   // of TFrmVSFichaOperator.PrintPageNumbers
                                                           }
//=============================================================================

procedure TFrmVSFichaOperator.FormActivate(Sender: TObject);
begin
  inherited;
  VspPreview.Orientation := orPortrait;
  VspPreview.StartDoc;
  PrintReport;
  VspPreview.EndDoc;
 // PrintPageNumbers;
end;

//=============================================================================
initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FVSOperatorSheet
