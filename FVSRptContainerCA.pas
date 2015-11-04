//========Copyright 2009 (c) Centric Retail Solutions. All rights reserved.====
// Packet   : FlexPoint
// Unit     : FVSRptContainerCA = Form VideoSoft RePorT CONTAINER CAstorama
//            Report Transfer to bank/Overview Containers
//-----------------------------------------------------------------------------
// CVS      : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptContainerCA.pas,v 1.3 2010/03/02 15:55:15 BEL\DVanpouc Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FVSRptContainerCA - CVS revision 1.5
// Version          ModifiedBy             Reason
// 1.6              TK  (TCS)             R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques
// 1.7              JD  (TCS)             R2014.1_Bug_161_Defect Fix
//=============================================================================

unit FVSRptContainerCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfVSPrinter7, ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ExtCtrls, ToolWin, RFpnTender, DFpnBagCA;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring               // report headers
  CtTxtHdrRpt1               = 'Overview containers';
  CtTxtHdrRpt2               = 'Transfer to Bank';

resourcestring               // table headers
  CtTxtHdrContainer          = 'N° Container';
  CtTxtHdrPayment            = 'Payment Type';
  CtTxtHdrOperator           = 'N° Caissière';
  CtTxtHdrTransactionDate    = 'Transactiondate';
  CtTxtHdrTransactionTime    = 'Transactiontime';
  CtTxtHdrCodType            = 'Type';
  CtTxtHdrNBPochette         = 'Number of bags';
  CtTxtHdrPochette           = 'Bagnumber';
  //CtTxtHdrAccountancy        = '';                                             //R2014.1.BUG-161.TCS-JD.commented
  CtTxtHdrAmount             = 'Euro';
  CtTxtHdrValidated          = 'Validated by';
  CtTxtHdrNbCheques          = 'Nbre Cheques';                                  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

resourcestring               // table totals
  CtTxtSubTotCont            = 'Total Container';
  CtTxtGrandTotal            = 'Grand Total';

resourcestring               // codtypes
  CtTxtPayOut                = 'Pay-Out'; //CodType: 921
  CtTxtFinalCount            = 'Final count'; //CodType: 931

var // Margins
  ViValMarginLeft  : Integer =  900;   // MarginLeft for VspPreview
  ViValMarginHeader: Integer = 1300;   // Adjust MarginTop to leave room for hdr

var // Fontsizes
  ViValFontHeader  : Integer = 16;     // FontSize header

var // Positions and white space
  ViValSpaceBetween: Integer =  200;   // White space between tables

var // Column-width (in number of characters)
  ViValRptWidthContainer     : Integer = 16; // Width columns Containernumber
  ViValRptWidthPayment       : Integer = 15; // Width columns Payment Type
  ViValRptWidthOper          : Integer = 9;  // Width columns operator          //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK      //R2014.1.BUG-161.TCS-JD
  ViValRptWidthTransDate     : Integer = 11; // Width columns Transaction date
  ViValRptWidthTransTime     : Integer = 11; // Width columns Transaction time
  ViValRptWidthCodType       : Integer = 9;  // Width columns CodeType type
  ViValRptWidthNBPochette    : Integer = 7;  // Width columns number of bags    //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  ViValRptWidthPochette      : Integer = 12; // Width columns bagnumber
  //ViValRptWidthFlgAccount  : Integer =  3; // Width columns FlgAccountancy  //R2014.1.BUG-161.TCS-JD
  ViValRptWidthAmount        : Integer = 11; // Width columns Amount in euros
  ViValRptWidthValidated     : Integer = 9;  // Width columns Validated by
  ViValRptWidthNbCheques     : Integer = 9;  // Width columns number of cheques //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

var // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables
  ViFlgReportCheques : Boolean = False; // flag for report of cheques           //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

const  // Run function parameters
  CtCodFuncReprint        = 1;
  CtCodFuncTransfer       = CtCodFuncReprint + 1;

const // General formats to the form
  CtTxtFrmNumber   = '#,##0.00';       // How to format a number.

//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmVSRptContainerCA = class(TFrmVSPreview)
    procedure FormCreate(Sender: TObject);
    procedure VspPreviewBeforeHeader(Sender: TObject);
  private
    qtyBags         : Integer;              // Number of bags in one container
    valAmount       : Double;               // Total Amount in one container
    QtyPTBags       : Integer;              // Number of bags / PaymentType
    ValPTAmount     : Double;               // Total Amount / PaymentType
    qtyGTBags       : Integer;              // Grand Total Bags
    valGTAmount     : Double;               // Grand Total Amount

    numTableRow     : Integer;              // Rownumber used for formatting
    // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
    QtyNbCheques    : Integer;
    NbrCheques      : Integer;
    QtyGTCheques    : Integer;
    ValTotal        : Currency;
    // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  protected
    { Protected declarations }
    FLstContainer       : TLstContainerCA;  // List of containers
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
    function GetNumEndBaseRapport    : Integer; virtual;
    function CalcTextHei             : Double; virtual;
    procedure SetTxtFNLogo (Value : string); virtual;
    procedure PrintPageHeader; virtual;
    procedure PrintBags (ObjContainer : TObjContainerCA;
                         IntCont      : Integer); virtual;
    procedure PrintSubTotal (IntLine : integer);
    procedure PrintGrandTotal;
    procedure GenerateBagBody (LstBag : TLstBagCA;
                              IntCont : Integer); virtual;
    procedure BuildLineBag (ObjBag : TObjBagCA; var TxtLine : string); virtual;
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
    property LstContainer : TLstContainerCA read  FLstContainer
                                            write FLstContainer;
    property CodRunFunc   : Integer         read  FCodRunFunc
                                            write FCodRunFunc;
  end; // of TFrmVSRptContainerCA

var
  FrmVSRptContainerCA: TFrmVSRptContainerCA;

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptContainerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptContainerCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2010/03/02 15:55:15 $';

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  RFpnCom,
  DFpnTenderCA,
  DFpnTenderGroup,
  DFpnTenderGroupCA,
  DFpnOperator,
  SmUtils,
  DFpnSafeTransaction,
  DFpnSafeTransactionCA;

{$R *.DFM}

//*****************************************************************************
// Implementation of TFrmVSRptContainerCA
//*****************************************************************************

//*****************************************************************************
// TFrmVSRptContainerCA - Getters / Setters
//*****************************************************************************

//=============================================================================
// TFrmVSRptContainerCA.GetNumEndBaseRapport : Fetch last pagenumber of report.
//                                             To be used in the PrintDoc method
//                                             of the maintenance task form
//=============================================================================

function TFrmVSRptContainerCA.GetNumEndBaseRapport : Integer;
begin  // of TFrmVSRptContainerCA.GetNumEndBaseRapport
  Result := ArrPages [1] - 1;
end;   // of TFrmVSRptContainerCA.GetNumEndBaseRapport

//=============================================================================
// TFrmVSRptContainerCA.SetTxtFNLogo: loads the logo file into an image-object
//=============================================================================

procedure TFrmVSRptContainerCA.SetTxtFNLogo (Value: string);
begin // of TFrmVSRptContainerCA.SetTxtFNLogo
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
end;  // of TFrmVSRptContainerCA.SetTxtFNLogo

//=============================================================================
// TFrmVSRptContainerCA.CalcTextHei : calculates VspPreview.TextHei for a
// single line in the current font.
//                                  -----
// FUNCRES : calculated TextHei.
//=============================================================================

function TFrmVSRptContainerCA.CalcTextHei : Double;
begin  // of TFrmVSRptTndCount.CalcTextHei
  VspPreview.X1 := 0;
  VspPreview.Y1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y2 := 0;

  VspPreview.CalcParagraph := 'X';
  Result := VspPreview.TextHei;
end;   // of TFrmVSRptContainerCA.CalcTextHei

//=============================================================================
// TFrmVSRptContainerCA.PrintPageHeader : prints the header of the report.
//                                  -----
// Restrictions :
// - is called from VspPreview.OnBeforeHeader; provided as virtual method to
//   improve inheritance.
//=============================================================================

procedure TFrmVSRptContainerCA.PrintPageHeader;
var
  ViValFontSave  : Variant;            // Save original FontSize
  TxtHeader      : string;             // Build header string to print
begin  // of TFrmVSRptContainerCA.PrintPageHeader
  ViValFontSave := VspPreview.FontSize;
  try
    // Header report count
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.CurrentY := ValOrigMarginTop;
    VspPreview.FontSize := ViValFontHeader;
    VspPreview.FontBold := True;
    case CodRunFunc of
     CtCodFuncReprint :
       VspPreview.Text := CtTxtHdrRpt1 + ' ' + TxtHeader;
     CtCodFuncTransfer :
       VspPreview.Text := CtTxtHdrRpt2 + ' ' + TxtHeader;
     else
       VspPreview.Text := CtTxtHdrRpt1 + ' ' + TxtHeader;
    end;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    VspPreview.CurrentX := VspPreview.MarginLeft;

  finally
    VspPreview.Fontsize := ViValFontSave;
    VspPreview.FontBold := False;
  end;
end;   // of TFrmVSRptContainerCA.PrintPageHeader


//=============================================================================
// TFrmVSRptContainerCA.PrintBags: Define the format of the table
//                                  -----
// INPUT   : ObjContainer = Container Object
//=============================================================================

procedure TFrmVSRptContainerCA.PrintBags (ObjContainer : TObjContainerCA;
                                          IntCont      : Integer);
begin // of TFrmVSRptContainerCA.PrintBags

  // initialization of number of lines
  QtyLinesPrinted := 0;

  // set table and header format

  // Containernumber
  TxtTableFmt := '<' + Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthContainer)]);

  // Payment type of the container
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthPayment)]);

  // Operator
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthOper)]);

  // Date on which the bag was created
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthTransDate)]);

  // Time on which the bag was created
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthTransTime)]);

  // CodeType type
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignLeft,
                                 ColumnWidthInTwips (ViValRptWidthCodType)]);

  // Number of bags
  TxtTableFmt := TxtTableFmt + SepCol + '>' +
                 Format ('%s%d', [FormatAlignLeft,
                                 ColumnWidthInTwips (ViValRptWidthNBPochette)]);

  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if (CodRunFunc = CtCodFuncTransfer) then
  begin
    if not ViFlgReportCheques then
  // Bagnumber
      TxtTableFmt := TxtTableFmt + SepCol + '>' +
                        Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthPochette)]);
  end
  else
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
    // Bagnumber
    TxtTableFmt := TxtTableFmt + SepCol + '>' +
                      Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthPochette)]);

  // Code accountancy
 { TxtTableFmt := TxtTableFmt + SepCol + '>' +
                 Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthFlgAccount)]); }   //R2014.1.BUG-161.TCS-JD.commented
//R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if ViFlgReportCheques then
  // number of cheques
    TxtTableFmt := TxtTableFmt + SepCol + '>' +
                   Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthNbCheques)]);
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  // Amount in bag
  TxtTableFmt := TxtTableFmt + SepCol + '>' +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthAmount)]);

  // Validated by
  TxtTableFmt := TxtTableFmt + SepCol + '<' +
                 Format ('%s%d', [FormatAlignRight,
                                  ColumnWidthInTwips (ViValRptWidthValidated)]);
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if (CodRunFunc = CtCodFuncTransfer) and ViFlgReportCheques then
    TxtTableHdr := CtTxtHdrContainer + SepCol + CtTxtHdrPayment + SepCol +
                   CtTxtHdrOperator + SepCol + CtTxtHdrTransactionDate + SepCol +
                   CtTxtHdrTransactionTime + SepCol + CtTxtHdrCodType + SepCol +
                   CtTxtHdrNBPochette + SepCol + {CtTxtHdrAccountancy + SepCol + }   //R2014.1.BUG-161.TCS-JD
                   CtTxtHdrNbCheques + SepCol + CtTxtHdrAmount + SepCol +
                   CtTxtHdrValidated
  else if ViFlgReportCheques then
    TxtTableHdr := CtTxtHdrContainer + SepCol + CtTxtHdrPayment + SepCol +
                   CtTxtHdrOperator + SepCol + CtTxtHdrTransactionDate + SepCol +
                   CtTxtHdrTransactionTime + SepCol + CtTxtHdrCodType + SepCol +
                   CtTxtHdrNBPochette + SepCol + CtTxtHdrPochette + SepCol +
                   {CtTxtHdrAccountancy + SepCol +} CtTxtHdrNbCheques + SepCol +  //R2014.1.BUG-161.TCS-JD
                   CtTxtHdrAmount + SepCol + CtTxtHdrValidated
  else
    TxtTableHdr := CtTxtHdrContainer + SepCol + CtTxtHdrPayment + SepCol +
                   CtTxtHdrOperator + SepCol + CtTxtHdrTransactionDate + SepCol +
                   CtTxtHdrTransactionTime + SepCol + CtTxtHdrCodType + SepCol +
                   CtTxtHdrNBPochette + SepCol + CtTxtHdrPochette + SepCol +
                  { CtTxtHdrAccountancy + SepCol +} CtTxtHdrAmount + SepCol +    //R2014.1.BUG-161.TCS-JD
                   CtTxtHdrValidated;
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End

  VspPreview.StartTable;
  try
    GenerateBagBody (ObjContainer.LstBag, IntCont);
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;

end;  // of TFrmVSRptContainerCA.PrintBags

//=============================================================================
// TFrmVSRptContainerCA.GenerateBagBody : Prints the bag table
//                                  -----
// INPUT   : LstBag = List Bag
//=============================================================================

procedure TFrmVSRptContainerCA.GenerateBagBody (LstBag : TLstBagCA;
                                               IntCont : Integer);
var
  CntItem             : Integer;          // counter for list of bags
  TxtLineBag          : string;           // line for bag
  TxtLineContainer    : string;           // line for container
  IdtTenderGroup      : Integer;          // IdtTenderGroup
  TxtTenderGroupDescr : string;           // description TenderGroup
  IdtCurrency         : string;           // Currency of the TenderGroup
  ObjTendergroup      : TObjTenderGroup;  // object tendergroup
begin // of TFrmVSRptContainerCA.GenerateBagBody
  // Container Data
  // Fetch Bag Data
  qtyBags        := 0; // reset number of bags in container
  valAmount      := 0; // reset total amount in euros
  QtyNbCheques   := 0;                                                          // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  NbrCheques     := 0;                                                          // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  for CntItem := 0 to LstBag.Count - 1 do begin
      IdtTenderGroup := LstBag.Bag[CntItem].IdtTenderGroup;
      ObjTendergroup := LstTenderGroup.FindIdtTenderGroup (IdtTenderGroup);
      TxtTenderGroupDescr := ObjTendergroup.TxtPublDescr;
      TxtLineContainer := LstContainer.Container [IntCont].IdtContainer +
                          SepCol + TxtTenderGroupDescr + SepCol;
      IdtCurrency := ObjTendergroup.IdtCurrency;

      BuildLineBag (LstBag.Bag[CntItem], TxtLineBag);
      PrintTableLine (TxtLineContainer+TxtLineBag);
      qtyBags   := qtyBags + 1;
      valAmount := valAmount +
                   DmdFpnSafeTransactionCA.AmountBag (LstBag.Bag[CntItem]);
      // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
      if ViFlgReportCheques then
      begin
        LstSafeTransaction.TotalTransDetail(LstBag.Bag[CntItem].IdtSafeTransaction,
                                          LstBag.Bag[CntItem].NumSeq,
                                          LstBag.Bag[CntItem].IdtTenderGroup,
                                          False, QtyNbCheques, ValTotal);
        NbrCheques := NbrCheques + QtyNbCheques;
      end;
      // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  end;
  QtyGTBags     := QtyGTBags + QtyBags;     // calculate grand total nb of bags
  ValGTAmount   := ValGTAmount + ValAmount; // Calculate grand total amount
  QtyGTCheques  := QtyGTCheques + NbrCheques;                                   // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  NumTableRow   := LstBag.Count+1;          // Rownumber to format subtotalrow
  PrintSubTotal(NumTableRow);
end;  // of TFrmVSRptContainerCA.GenerateBagBody

//=============================================================================
// TFrmVSRptContainerCA.BuildLineBag : build one bag line
//                                  -----
// INPUT   : ObjBag = Bag Object
//                                  -----
// OUTPUT  : TxtLine = line to print
//=============================================================================

procedure TFrmVSRptContainerCA.BuildLineBag
                                      (    ObjBag  : TObjBagCA;
                                       var TxtLine : string);
var
  CntSafeTransIdx  : Integer;          // Identifier of safetransaction
  IdtOperator      : string;           // identifier of operator
  CodType          : Integer;          // Codtype of the safetransaction
  TxtCodType       : string;           // Typename of CodType
  TxtBagDate       : string;           // Date of bag creation
  TxtBagTime       : string;           // Time of bag creation
  TxtValidation    : string;           // Identifier of supervisor validator
  StrLstExpl       : TStringList;      // Stringlist operator
  ObjSafeTrans     : TObjSafeTransaction; // Safetransaction
  QtyTotal         : Integer;                                                   // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  ValTotal         : Currency;                                                  // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  TxtAccountancy      : string;          // 'C' bag is originated in accountancy
begin // of TFrmVSRptContainerCA.BuildLineBag
  // Bag Data
  if not Assigned (LstSafeTransaction) then
    LstSafeTransaction := TLstSafeTransaction.Create;
  if LstSafeTransaction.IndexOfIdt (ObjBag.IdtSafeTransaction) = -1 then
    DmdFpnSafeTransactionCA.
      BuildListSafeTransactionAndDetail (LstSafeTransaction,
                                         ObjBag.IdtSafeTransaction);
  CntSafeTransIdx := LstSafeTransaction.IndexOfIdtAndSeq
                       (ObjBag.IdtSafeTransaction, ObjBag.NumSeq);
  ObjSafeTrans := LstSafeTransaction.SafeTransaction [CntSafeTransIdx];
  if CntSafeTransIdx = -1 then
    exit;
  StrLstExpl := LstSafeTransaction.GetExplanationForKeyword
                  (ObjSafeTrans, CtTxtFmtExplOper);
  try
    if StrLstExpl.Count > 0 then
      IdtOperator  := LeftPadStringCh (StrLstExpl.Strings[0], '0', 3);
  finally
    StrLstExpl.Free;
  end;
  StrLstExpl := LstSafeTransaction.GetExplanationForKeyword
                  (ObjSafeTrans, CtTxtFmtExplCodType);
  try
    if StrLstExpl.Count > 0 then
      CodType := StrToInt (StrLstExpl.Strings[0]);
  finally
    StrLstExpl.Free;
  end;
  case CodType of
       CtCodSttPayOutTender : TxtCodType := CtTxtPayOut;
       0                    : TxtCodType := CtTxtFinalCount;
  end;
  TxtBagDate := DateToStr (ObjSafeTrans.DatReg);
  TxtBagTime := TimeToStr (ObjSafeTrans.DatReg);
  StrLstExpl := LstSafeTransaction.GetExplanationForKeyword
                  (ObjSafeTrans, CtTxtFmtExplValidationCA);
  try
    TxtValidation := '';
    if StrLstExpl.Count > 0 then begin
      TxtValidation := StrLstExpl.Strings [Pred (StrLstExpl.Count)];
      TxtValidation := Copy (TxtValidation, 1, AnsiPos (';', TxtValidation) - 1);
    end;
  finally
    StrLstExpl.Free;
  end;
  TxtAccountancy := '';
  if ObjBag.FlgAccountancy then
    TxtAccountancy := 'C';

  // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if ViFlgReportCheques then
    LstSafeTransaction.TotalTransDetail(ObjSafeTrans.IdtSafeTransaction,
                                        ObjSafeTrans.NumSeq,ObjBag.IdtTenderGroup,
                                        False, QtyTotal, ValTotal);

  if (CodRunFunc = CtCodFuncTransfer) and ViFlgReportCheques then
    TxtLine := IdtOperator + SepCol + TxtBagDate + SepCol + TxtBagTime + SepCol +
               TxtCodType  + SepCol + '1' + {SepCol + TxtAccountancy + }SepCol +   //R2014.1.BUG-161.TCS-JD
               IntToStr(QtyTotal) + SepCol +
               FormatFloat (CtTxtFrmNumber, DmdFpnSafeTransactionCA.AmountBag (ObjBag))+
               SepCol + TxtValidation
  else if ViFlgReportCheques then
    TxtLine := IdtOperator + SepCol + TxtBagDate + SepCol + TxtBagTime + SepCol +
               TxtCodType  + SepCol + '1' + SepCol + ObjBag.IdtBag +{ SepCol +
               TxtAccountancy + }SepCol + IntToStr(QtyTotal) + SepCol +           //R2014.1.BUG-161.TCS-JD
               FormatFloat (CtTxtFrmNumber, DmdFpnSafeTransactionCA.AmountBag (ObjBag))+
               SepCol + TxtValidation
  else
    TxtLine := IdtOperator + SepCol + TxtBagDate + SepCol + TxtBagTime + SepCol +
               TxtCodType  + SepCol + '1' + SepCol + ObjBag.IdtBag + {SepCol +      //R2014.1.BUG-161.TCS-JD
               TxtAccountancy +} SepCol +
               FormatFloat (CtTxtFrmNumber, DmdFpnSafeTransactionCA.AmountBag (ObjBag)) +
               SepCol + TxtValidation;
   // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
end;  // of TFrmVSRptContainerCA.BuildLineBag

//=============================================================================
// TFrmVSRptContainerCA.AddFooterToPages
//=============================================================================

procedure TFrmVSRptContainerCA.AddFooterToPages;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
  NumPage          : Integer;          // PageNumber
  TotPage          : Integer;          // total Pages
  CntArray         : Integer;          // Array counter
begin  // of TFrmVSRptContainerCA.AddFooterToPages
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
      VspPreview.Text := CtTxtPrintDate + ' ' +
                         FormatDateTime('dd-MM-yyyy hh:mm:ss', Now);
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
end;   // of TFrmVSRptContainerCA.AddFooterToPages

//=============================================================================
// TFrmVSRptContainerCA.PrintTableLine : adds the line to the current Table.
//                                  -----
// INPUT   : TxtLine = line to add to the Table.
//=============================================================================

procedure TFrmVSRptContainerCA.PrintTableLine (TxtLine : string);
begin  // of TFrmVSRptContainerCA.PrintTableLine
  VspPreview.AddTable (TxtTableFmt, TxtTableHdr, TxtLine,
                       ViColHeader, ViColBody, False);
  Inc (QtyLinesPrinted);
end;   // of TFrmVSRptContainerCA.PrintTableLine

//=============================================================================

procedure TFrmVSRptContainerCA.PrintRef;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSRptContainerCA.PrintRef
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, True);
      CurrentX := PageWidth - MarginRight - TextWidth [NumRef] - 1;
      CurrentY := PageHeight - MarginBottom + TextHeight ['X'] - 250;
      Text := NumRef;
      EndOverlay;
    end;
  end;
end;   // of TFrmVSRptContainerCA.PrintRef

//=============================================================================
// TFrmVSRptContainerCA.PrintSubTotal : adds Sub Totals to the report.
//=============================================================================

procedure TFrmVSRptContainerCA.PrintSubTotal (intLine : integer);
var
  TxtSubTotals     : string;        // printline voor subtotals
begin  // of TFrmVSRptContainerCA.PrintSubTotal
  // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if (CodRunFunc = CtCodFuncTransfer) and ViFlgReportCheques then
    TxtSubTotals := CtTxtSubTotCont + SepCol + '' + SepCol + '' +
                      SepCol + '' + SepCol + '' + SepCol + '' + SepCol +
                      IntToStr(qtyBags) {+ SepCol + ''} + SepCol +               //R2014.1.BUG-161.TCS-JD
                      IntToStr(NbrCheques) + SepCol +
                      FormatFloat(CtTxtFrmNumber, valAmount)  + SepCol + ''
  else if ViFlgReportCheques then
    TxtSubTotals := CtTxtSubTotCont + SepCol + '' + SepCol + '' +
                      SepCol + '' + SepCol + '' + SepCol + '' + SepCol +
                      IntToStr(qtyBags) + SepCol + '' + SepCol {+ '' + SepCol} +  //R2014.1.BUG-161.TCS-JD
                      IntToStr(NbrCheques) + SepCol +
                      FormatFloat(CtTxtFrmNumber, valAmount)  + SepCol + ''
  else
    TxtSubTotals := CtTxtSubTotCont + SepCol + '' + SepCol + '' +
                      SepCol + '' + SepCol + '' + SepCol + '' + SepCol +
                      IntToStr(qtyBags) + SepCol + '' + SepCol {+ '' + SepCol }+  //R2014.1.BUG-161.TCS-JD
                      FormatFloat(CtTxtFrmNumber, valAmount)  + SepCol + '';
  // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  VspPreview.AddTable (TxtTableFmt, '', TxtSubTotals,
                       ViColHeader, ViColBody, False);
  VspPreview.TableCell[tcRowBorderAbove, intLine, 1, intLine, 10] := 20;
  Inc (QtyLinesPrinted);
end;   // of TFrmVSRptContainerCA.PrintSubTotal

//=============================================================================
// TFrmVSRptContainerCA.PrintGrandTotal : adds Sub Totals to the report.
//=============================================================================

procedure TFrmVSRptContainerCA.PrintGrandTotal;
var
  TxtGrandTotal     : string;        // printline voor grand totals
begin  // of TFrmVSRptContainerCA.PrintGrandTotal
  // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if (CodRunFunc = CtCodFuncTransfer) and ViFlgReportCheques then
    TxtGrandTotal := CtTxtGrandTotal + SepCol + '' + SepCol + '' +
                     SepCol + '' + SepCol + '' + SepCol + '' + SepCol +
                     IntToStr(QtyGTBags) {+ SepCol + ''} + SepCol +                  //R2014.1.BUG-161.TCS-JD
                     IntToStr(QtyGTCheques) + SepCol +
                     FormatFloat(CtTxtFrmNumber, ValGTAmount)  + SepCol + ''
  else if ViFlgReportCheques then
    TxtGrandTotal := CtTxtGrandTotal + SepCol + '' + SepCol + '' +
                     SepCol + '' + SepCol + '' + SepCol + '' + SepCol +
                     IntToStr(QtyGTBags) + SepCol + ''{ + SepCol + ''} + SepCol +   //R2014.1.BUG-161.TCS-JD
                     IntToStr(QtyGTCheques) + SepCol +
                     FormatFloat(CtTxtFrmNumber, ValGTAmount)  + SepCol + ''
  else
    TxtGrandTotal := CtTxtGrandTotal + SepCol + '' + SepCol + '' +
                     SepCol + '' + SepCol + '' + SepCol + '' + SepCol +
                     IntToStr(QtyGTBags) + SepCol + ''{ + SepCol + '' }+ SepCol +   //R2014.1.BUG-161.TCS-JD
                     FormatFloat(CtTxtFrmNumber, ValGTAmount)  + SepCol + '';
  // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  VspPreview.AddTable (TxtTableFmt, '', TxtGrandTotal,
                       ViColHeader, ViColHeader, False);
  Inc (QtyLinesPrinted);
end;   // of TFrmVSRptContainerCA.PrintGrandTotal

//=============================================================================
// TFrmVSRptContainerCA.DrawLogo
//=============================================================================

procedure TFrmVSRptContainerCA.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptContainerCA.DrawLogo
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
end;   // of TFrmVSRptContainerCA.DrawLogo

//=============================================================================
// TFrmVSRptContainerCA.GenerateReport : main routine for printing report
//=============================================================================

procedure TFrmVSRptContainerCA.GenerateReport;
var
  CntItem             : Integer;          // counter for container list
  ObjContainer        : TObjContainerCA;  // to temporarily hold container object
  IntPrevTendergroup  : Integer;          // holds the previous tendergroup
  // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  ObjTenderGroup      : TObjTenderGroup;  // object tendergroup
  TxtTenderGroupDescr : string;           // description TenderGroup
  // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
begin // of TFrmVSRptContainerCA.GenerateReport
  case CodRunFunc of
    0               : NumRef := 'REP0026';
    CtCodFuncReprint: NumRef := 'REP0025';
    CtCodFuncTransfer:NumRef := 'REP0017';
  end;
  qtyPTBags           := 0;    // initialize sub total bags
  valPTAmount         := 0;    // initialize sub total bags
  qtyGTBags           := 0;    // initialize grand total bags
  valGTAmount         := 0;    // initialize grand total amount
  QtyGTCheques        := 0;    // initialize grand total nbr of cheques         // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

  Visible := True;
  Visible := False;

  SetLength (ArrPages, 1);
  ArrPages [Length (ArrPages) - 1] := 1;
  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  VspPreview.Preview := True;
  IntPrevTendergroup := -1;
  try
    for CntItem := 0 to LstContainer.Count - 1 do begin
      QtyLinesPrinted := 0;
      ObjContainer := LstContainer.Container [CntItem];
      // new page for each tendergroup
      if ObjContainer.LstBag.Count <> 0 then begin
        if (CntItem > 0) and  (IntPrevTendergroup <>
           ObjContainer.LstBag.Bag[0].IdtTenderGroup) then
             VspPreview.NewPage;
        IntPrevTendergroup := ObjContainer.LstBag.Bag[0].IdtTenderGroup;
      end;
     // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
      ObjTendergroup := LstTenderGroup.FindIdtTenderGroup(IntPrevTendergroup);
      TxtTenderGroupDescr := ObjTendergroup.TxtPublDescr;
      if TxtTenderGroupDescr = CtTxtBankCheques then
        ViFlgReportCheques := True;
      // R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
      PrintBags (ObjContainer, CntItem); //table with tableheader
    end;
    if LstContainer.Count > 1 then
       PrintGrandTotal;
  finally
    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
  PrintRef;
  if PreviewReport then
    ShowModal;
end;  // of TFrmVSRptContainerCA.GenerateReport

//*****************************************************************************
// TFrmVSRptContainerCA - Generated Events
//*****************************************************************************

procedure TFrmVSRptContainerCA.FormCreate (Sender: TObject);
begin // of TFrmVSRptContainerCA.FormCreate
  inherited;
  if not Assigned (DMdFpnSafeTransactionCA) then
    DmdFpnSafeTransactionCA := TDmdFpnSafeTransactionCA.Create (Self);
  if not Assigned (DmdFpnTenderGroupCA) then
    DmdFpnTenderGroupCA := TDmdFpnTenderGroupCA.Create (Self);
  if not Assigned (LstTenderGroup) then begin
    LstTenderGroup := TLstTenderGroup.Create;
    DmdFpnTenderGroupCA.BuildListTenderGroup (LstTenderGroup);
  end;
  if not Assigned (LstBag) then
    LstBag := TLstBagCA.create;
  // Set defaults
  TxtFNLogo := CtTxtEnvVarStartDir + '\Image\FlexPoint.Report.BMP';

  // Overrule default properties for VspPreview.
  VspPreview.MarginLeft := ViValMarginLeft;
  // Leave room for header
  ValOrigMarginTop      := VspPreview.MarginTop;
  VspPreview.MarginTop  := ValOrigMarginTop + ViValMarginHeader;

  // Sets an empty header to make sure OnBeforeHeader is fired.
  VspPreview.Header := ' ';
end;  // of TFrmVSRptContainerCA.FormCreate

//=============================================================================
// TFrmVSRptContainerCA.VspPreviewBeforeHeader
//=============================================================================

procedure TFrmVSRptContainerCA.VspPreviewBeforeHeader (Sender: TObject);
var
  ValPosYEndHdr  : Double;             // Y-position at end of header
begin  // of TFrmVSRptContainerCA.VspPreviewBeforeHeader
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
end;   // of TFrmVSRptContainerCA.VspPreviewBeforeHeader

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end. // of TFrmVSRptContainerCA

