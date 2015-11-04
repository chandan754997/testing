//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet : Castorama Flexpos Development
// Unit   : FVSRptTndCountCAPosCA = Form VideoSoft RePorT TeNDer COUNT for
//          CAstorama for POS of CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndCountCAPosCA.pas,v 1.2 2008/09/26 09:50:45 dietervk Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FVSRptTndCountCAPosCA - CVS revision 1.2
// 1.1     AJ (TCS)  R2014.1 - Req(32080) - CARU - PayOut Process
// 1.2     AJ (TCS)  R2014.1 - ALM-Defect-195-Payout Report
//=============================================================================

unit FVSRptTndCountCAPosCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FVSRptTndCountPosCA, ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ToolWin, DFpnTenderGroupPosCA, ExtCtrls;

//=============================================================================
// Global definitions
//=============================================================================

var    // Widths of columns in StringGrid
  ViValRptWidthVAT : Integer =  8;    // Width of column for VAT Codes

//-----------------------------------------------------------------------------

const  // for giving the dimentions of the rectangle.
  CtValConclRecHeight   = 1000;
  CtValConclRecWidth    = 2000;

//-----------------------------------------------------------------------------

resourcestring     // for printing the header of the final count.
  CtTxtHdrFinStateOper  = 'Financial report of the operator';
  CtTxtHdrFinStateCheckout = 'Financial report of the checkout';
  CtTxtHdrNbOperator    = 'Operator Number';
  CtTxtHdrNameOperator  = 'Cashdesk Rapport of';
  CtTxtHdrDat           = 'Date';
  CtTxtHdrBagNumber     = 'Sealbag: %s';

resourcestring  // Headers of the countable part
  CtTxtTransfer         = 'Transfer';
  CtTxtReturnPayIn      = 'Return Pay in';
  CtTxtHdrGroupTotal    = 'Total Pay out and count by group';

resourcestring  // headers of TVA part
  CtTxtVATPrc      = '% VAT';
  CtTxtVATExcl     = 'VAT Excl';
  CtTxtVATIncl     = 'VAT Incl';
  CTTxtVAT         = 'VAT';

resourcestring // Caption of theoretic amount
  CtTxtTheorTotal  = 'Total Theoretical';

resourcestring // Headers of the bag seal part
  CtTxtHdrBagSeal  = 'Bag Seal';
  CtTxtHdrSeal     = 'Seal';

resourcestring // For validation
  CtTxtHdrValid   = 'Validations done in transaction:';

//*****************************************************************************
// TFrmVSRptTndCount
//*****************************************************************************

type
  TFrmVSRptTndCountCA = class(TFrmVSRptTndCount)
  protected
    // Internal used datafields for current Table on report
    ValTotalReturnPayIn : Currency;    // Total Return PayIn
    ValTotalTheorPrint  : Currency;    // Total Theoretic for print
    ArrPages            : array of Integer; // Array of pages to restart counting

    function GetNumEndBaseRapport : Integer; virtual;

    procedure PrintPageHeader; override;
    procedure PrintAddress; override;
    procedure PrintConclusion; override;
    procedure InitializeBeforeStartTable; override;

    // Universal Methods

    // Table Cash and Countable
    procedure BuildTableCountFmtAndHdr; override;
    procedure BuildLineCount (    ObjTenderGroup : TObjTenderGroup;
                              var TxtLine        : string;
                              var FlgHasData     : Boolean        ); override;
    procedure GenerateTableCountTotal; override;
    procedure AddFooterToPages; override;

    // Table VAT values.
    procedure BuildTableVATFmtAndHdr; virtual;
    procedure BuildLineVAT (    ObjTenderGroup : TObjTenderGroup;
                            var TxtLine        : string;
                            var FlgHasData     : Boolean        ); virtual;
    procedure PrintLineVAT (ObjTenderGroup : TObjTenderGroup); virtual;
    procedure GenerateTableVATBody; virtual;
    procedure GenerateTableVATTotal; virtual;
    procedure GenerateTableVAT; virtual;

    // Table Theor total.
    procedure BuildTableTheorFmtAndHdr; virtual;
    procedure BuildLineTheor (var TxtLine        : string;
                              var FlgHasData     : Boolean        ); virtual;
    procedure PrintLineTheor; virtual;
    procedure GenerateTableTheorBody; virtual;
    procedure GenerateTableTheorTotal; virtual;
    procedure GenerateTableTheor; virtual;

    // Table Group totals.
    procedure BuildTableGroupTotalFmtAndHdr; virtual;
    procedure BuildLineGroupTotal (    ObjTenderGroup : TObjTenderGroup;
                                   var TxtLine        : string;
                                   var FlgHasData     : Boolean); virtual;
    procedure PrintLineGroupTotal (ObjTenderGroup : TObjTenderGroup); virtual;
    procedure GenerateTableGroupTotalBody; virtual;
    procedure GenerateTableGroupTotalTotal; virtual;
    procedure GenerateTableGroupTotal; virtual;

    // Table Bag Seals
    procedure BuildTableBagFmtAndHdr; virtual;
    procedure BuildLineBag (    TxtExplanation : string;
                            var TxtLine        : string;
                            var FlgHasData     : Boolean); virtual;
    procedure PrintLineBag (TxtExplanation : string); virtual;
    procedure GenerateTableBagBody; virtual;
    procedure GenerateTableBagTotal; virtual;
    procedure GenerateTableBag; virtual;

    // Table not count total
    procedure GenerateTableNotCountTotal; override;

    procedure PrintValidation; virtual;
    procedure PrintBagReports; virtual;
  public
    property NumEndBaseRapport : Integer read GetNumEndBaseRapport;
    procedure GenerateReport; override;
    procedure GenerateReportPayOut; virtual;                                    //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS
    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;
  end; // of TFrmVSRptTndCountCA

var
  FrmVSRptTndCountCA: TFrmVSRptTndCountCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SmUtils,

  SfDialog,
  DFpnTenderPosCA,
  DFpnSafeTransactionPosCA,

  RFpnTenderCA,
  //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.Start
  RFpnCom,
  SrStnCom,
  FfpsTndRegCountPosCA,
  FLoginTenderPosCA,UfpsSyst,
  MGoPosLinkCA,
  MGoPosFiscPrinterCA ;
  //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.End

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptTndCountCAPosCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndCountCAPosCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2008/09/26 09:50:45 $';

//*****************************************************************************
// Implementation of TFrmVSRptTndCountCA
//*****************************************************************************

function TFrmVSRptTndCountCA.GetNumEndBaseRapport : Integer;
begin  // of TFrmVSRptTndCountCA.GetNumEndBaseRapport
  Result := ArrPages [1] - 1;
end;   // of TFrmVSRptTndCountCA.GetNumEndBaseRapport

//=============================================================================

procedure TFrmVSRptTndCountCA.PrintPageHeader;
var
  TxtKind          : string;           // Kind of functions
begin  // of TFrmVSRptTndCountCA.PrintPageHeader
  // This header is only applied to the final count.
  //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.Start
  if ViFlgCARU  and (ViCodIsRunningOn = CtCodRunOnBackoffice)
                           and (CodRunFunc = CtCodFuncPayOut) then begin
    VspPreview.FontBold := True;
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.CurrentY := ValOrigMarginTop;
    case CodRunFunc of

      CtCodFuncPayOut : TxtKind := CtTxtPayOut;
      CtCodFuncPayOutC : TxtKind := CtTxtPayOutC;

    end;

    if CodRunFunc in [CtCodFuncPayOutC, CtCodFuncPayOut] then
      VspPreview.Text     := CtTxtPayOutReport ;
      VspPreview.FontBold := False;

    if CodRunFunc in [CtCodFuncPayOutC, CtCodFuncPayOut] then begin
      VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
      VspPreview.CurrentX := VspPreview.Marginleft;
      VspPreview.Text :=   CtTxtOperator   + ' ' + ':' + ' ' +
                                      IdtRegResponsibleFor + ' '  ;
    end;

    if CodRunFunc in [CtCodFuncPayOutC, CtCodFuncPayOut] then begin
      VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
      VspPreview.CurrentX := VspPreview.Marginleft;
      VspPreview.Text :=  CtTxtOperatorResponsible + ' ' + ':' + ' ' +
                           IdtOperReg + ' ' + '-' + ' ' + FTxtNameRegFor + ' ' ;
    end;

    VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.Text := CtTxtPayOutDate + ' : ' +
                     FormatDateTime (CtTxtDatFormat,
                                     CurrentSafeTransaction.DatReg) + ' ' +
                     FormatDateTime (CtTxtHouFormat,
                                     CurrentSafeTransaction.DatReg);

    VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
    VspPreview.CurrentX := VspPreview.Marginleft;
  end
  else begin
  //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.End
    VspPreview.FontBold := True;
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.CurrentY := ValOrigMarginTop;
    case CodRunFunc of
      CtCodFuncPayIn  : TxtKind := CtTxtPayIn;
      CtCodFuncPayOut : TxtKind := CtTxtPayOut;
      CtCodFuncRetPayIn : TxtKind := CtTxtReturnPayIn;
      CtCodFuncTransfer : TxtKind := CtTxtTransfer;
      CtCodFuncTransferCM : TxtKind := CtTxtTransferCM;
      CtCodFuncPayOutC : TxtKind := CtTxtPayOutC;
      CtCodFuncPayInC : TxtKind := CtTxtPayinC;
    end;

  if CodRunFunc in [CtCodFuncPayOutC, CtCodFuncPayInC] then
    VspPreview.Text := CtTxtHdrFinStateCheckout + ' (' + TxtKind + ')'
  else
    VspPreview.Text := CtTxtHdrFinStateOper + ' ('+ TxtKind + ')';
  VspPreview.FontBold := False;

  if not (CodRunFunc in  [CtCodFuncTransfer, CtCodFuncTransferCM,
                          CtcodFuncPayOutC, CtCodFuncPayInC]) then begin
    VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.Text := CtTxtHdrNbOperator + ' ' + IdtRegFor;
  end;

  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  if CodRunFunc = CtCodFuncTransfer then
    VspPreview.Text := Format (CtTxtTransferFromTo, [IdtRegFor,TxtNameRegFor,
                                                     IdtOperTrTo,
                                                     TxtNameOperTrTo])
  else if CodRunFunc = CtCodFuncTransferCM then
    VspPreview.text := Format (CtTxtTransferCMTo, [IdtOperTrTo,
                                                   TxtNameOperTrTo])
  else if CodRunFunc in [CtCodFuncPayOutC, CtCodFuncPayInC] then begin
    case CodRunFunc of
      CtCodFuncPayOutC: TxtKind := CtTxtCountCashdeskPO;
      CtCodFuncPayInC:  TxtKind := CtTxtCountCashdeskPI;
      else
        TxtKind := CtTxtHdrNameOperator;
    end;
    case CurrentSafeTransaction.IdtCheckout of
      CtIdtChangeSafe: VspPreview.Text := TxtKind + ' ' + CtTxtCheckoutCM;
      CtIdtExpenseSafe: VspPreview.Text := TxtKind
       + ' ' + CtTxtCheckoutCE;
    end;
  end
  else
    VspPreview.Text := CtTxtHdrNameOperator + ' ' + TxtNameRegFor;

  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.Text := CtTxtHdrDat + ' : ' +
                     FormatDateTime (CtTxtDatFormat,
                                     CurrentSafeTransaction.DatReg) + ' ' +
                     FormatDateTime (CtTxtHouFormat,
                                     CurrentSafeTransaction.DatReg);

    VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
    VspPreview.CurrentX := VspPreview.Marginleft;
  end;                                                                          //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS
  end;   // of TFrmVSRptTndCountCA.PrintPageHeader
 //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.End
//=============================================================================

procedure TFrmVSRptTndCountCA.PrintAddress;
begin  // of TFrmVSRptTndCountCA.PrintAddress
end;   // of TFrmVSRptTndCountCA.PrintAddress

//=============================================================================

procedure TFrmVSRptTndCountCA.PrintConclusion;
var
  ValCentre        : Integer;          // Centre position of the rapport
begin  // of TFrmVSRptTndCountCA.PrintConclusion
  inherited;
  VspPreview.BrushStyle := bsTransparent;

  VspPreview.CurrentY := VspPreview.CurrentY + 250;
  ValCentre := ReportWidthInTwips div 2;

  // Print a rectangle under the text 'Agree Operator'
  VspPreview.DrawRectangle (VspPreview.Marginleft, VspPreview.CurrentY,
                            VspPreview.Marginleft + CtValConclRecWidth,
                            VspPreview.CurrentY + CtValConclRecHeight, 0,0);

  // Print a rectangle under the text 'Agree Manager'
  VspPreview.DrawRectangle
      (VspPreview.Marginleft + ValCentre, VspPreview.CurrentY,
       VspPreview.Marginleft + ValCentre + CtValConclRecWidth,
       VspPreview.CurrentY + CtValConclRecHeight, 0,0);
end;   // of TFrmVSRptTndCountCA.PrintConclusion

//=============================================================================

procedure TFrmVSRptTndCountCA.InitializeBeforeStartTable;
begin  // of TFrmVSRptTndCountCA.InitializeBeforeStartTable
  inherited;
  ValTotalReturnPayIn := 0;
end;   // of TFrmVSRptTndCountCA.InitializeBeforeStartTable

//=============================================================================

procedure TFrmVSRptTndCountCA.BuildTableCountFmtAndHdr;
begin  // of TFrmVSRptTndCountCA.BuildTableCountFmtAndHdr
  inherited;

  if CodRunFunc = CtCodFuncCount then begin
      TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                      ColumnWidthInTwips (ViValRptWidthDescr)]);
      TxtTableHdr := CtTxtHdrCountable;
      AppendFmtAndHdrAmount (CtTxtHdrTotalDrawer);
      AppendFmtAndHdrAmount (CtTxtPayIn);
      AppendFmtAndHdrAmount (CtTxtTransfer);
      AppendFmtAndHdrAmount (CtTxtReturnPayIn);
      AppendFmtAndHdrAmount (CtTxtPayOut);
      AppendFmtAndHdrAmount (CtTxtHdrTotalCount);
      AppendFmtAndHdrAmount (CtTxtHdrDifference);
  end;
end;   // of TFrmVSRptTndCountCA.BuildTableCountFmtAndHdr

//=============================================================================

procedure TFrmVSRptTndCountCA.BuildLineCount
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean        );
var
  QtyTrans         : Integer;          // Total Quantity TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
  ValPrint         : Currency;         // Calculate value to print
  ValTheor         : Currency;         // Total theoretic
  ValReturnPayIn   : Currency;         // Return payin
begin  // of TFrmVSRptTndCountCA.BuildLineCount
  if CodRunFunc <> CtCodFuncCount then begin
    inherited;
    exit;
  end;

  FlgHasData := False;
  TxtLine    := ObjTenderGroup.TxtPublDescr;
  ValTheor   := 0;

  // Retrieve total drawer
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttDrawerCashdesk,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValTheor := ValTheor + ValTrans;
  ValTotalDrawer := ValTotalDrawer + ValTrans;  
       FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);

  // Calculate total PayIn = Change Money + PayIn
  // Definite 'Total PayIN' = 'Startvalue' - 'Change for next' +
  //                          'PayIn in Tender' + 'PayIn in Cashdesk'
  ValPrint := 0;
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttChangeOnStart,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans;
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttChangeForNext,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint - ValTrans;
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttPayInTender,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans;
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttPayInCashdesk,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans;
  ValTheor := ValTheor + ValPrint;
  ValTotalPayIn := ValTotalPayIn + ValPrint;
  FlgHasData := FlgHasData or (ValPrint <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValPrint);

  // Transfer'
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (0);

  // Return of PayIn
  TLstSafeTransaction(LstSafeTransaction).TotalTransDetailForReason
                                               (IdtSafeTransaction,
                                                CtCodSttPayOutTender,
                                                CtCodStrReturnPayin,
                                                ObjTenderGroup.IdtTenderGroup,
                                                True, QtyTrans, ValTrans);
  ValReturnPayIn := ValTrans;
  ValTotalReturnPayIn := ValTotalReturnPayIn + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);

  // Calculate total PayOut
  ValPrint := 0;
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttPayOutTender,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans - ValReturnPayIn;
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttPayOutCount,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans;
  ValTheor := ValTheor - ValPrint;
  ValTotalPayOut := ValTotalPayOut + ValPrint;
  FlgHasData := FlgHasData or (ValPrint <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValPrint);

  // Append total theoretic, but DON't print it!!!
  ValTotalTheor := ValTotalTheor + ValTheor;

  // Retrieve total count
  LstSafeTransaction.TotalTransDetail (IdtSafeTransaction,
                                       NumSeqSafeTrans,
                                       ObjTenderGroup.IdtTenderGroup,
                                       True, QtyTrans, ValTrans);
  ValTotalCount := ValTotalCount + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);

  if (CodRunFunc = CtCodFuncCount) or
     (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    // Append difference
    TxtLine := TxtLine + SepCol + FormatValue (ValTheor - ValTrans);
end;   // of TFrmVSRptTndCountCA.BuildLineCount

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableCountTotal;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptTndCountCA.GenerateTableCountTotal
  if CodRunFunc <> CtCodFuncCount then begin
    inherited;
    exit;
  end;

  TxtLine :=  CtTxtRptTotal;
  TxtLine := TxtLine +
             SepCol + FormatValue (ValTotalDrawer) +
             SepCol + FormatValue (ValTotalPayIn) +
             SepCol + FormatValue (0) +
             SepCol + FormatValue (ValTotalReturnPayIn) +
             SepCol + FormatValue (ValTotalPayOut) +
             SepCol + FormatValue (ValTotalCount) +
             SepCol + FormatValue (ValTotalTheor - ValTotalCount);

  PrintTableLine (TxtLine);
  ConfigTableTotal;
  ValTotalTheorPrint := ValTotalTheorPrint + ValTotalTheor;
end;   // of TFrmVSRptTndCountCA.GenerateTableCountTotal

//=============================================================================

procedure TFrmVSRptTndCountCA.AddFooterToPages;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
  NumPage          : Integer;          // PageNumber
  TotPage          : Integer;          // total Pages
  CntArray         : Integer;          // Array counter
begin  // of TFrmVSRptTndCountCA.AddFooterToPages
  // Add page number and date to report

  TotPage := VspPreview.PageCount;
  CntArray := 0;
  for CntPage := 1 to VspPreview.PageCount do begin
    VspPreview.StartOverlay (CntPage, False);
    try
      NumPage := 1;
      if CntPage >= ArrPages[CntArray] then begin
        NumPage := 1;
        Inc (CntArray);
        TotPage := ArrPages [CntArray] - ArrPages [CntArray - 1];
      end;
      VspPreview.CurrentX := VspPreview.MarginLeft;
      VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                             VspPreview.TextHeight ['X'];
      //VspPreview.Text := CtTxtPrintDate + ' ' + DateToStr (Now);
      VspPreview.Text := CtTxtPrintDate + ' ' + FormatDateTime (CtTxtDatFormat,
                                     CurrentSafeTransaction.DatReg);
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
end;   // of TFrmVSRptTndCountCA.AddFooterToPages

//=============================================================================
// TFrmVSRptTndCount.BuildTableVATFmtAndHdr : builds the Format and Header
// for the table with the VAT results.
//=============================================================================

procedure TFrmVSRptTndCountCA.BuildTableVATFmtAndHdr;
begin  // of TFrmVSRptTndCountCA.BuildTableVATFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtVATPrc;

  AppendFmtAndHdrAmount (CtTxtVATIncl);
  AppendFmtAndHdrAmount (CtTxtVAT);
  AppendFmtAndHdrAmount (CtTxtVATExcl);
end;   // of TFrmVSRptTndCountCA.BuildTableVATFmtAndHdr

//=============================================================================
// TFrmVSRptTndCountCA.BuildLineVAT : builds the body-line of the table
// with the VAT results for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to build the line for.
//                                  -----
// OUTPUT  : TxtLine = builded line.
//           FlgHasData = True if the line contains non-zero data;
//                        False if all numeric data on the line is zero.
//=============================================================================

procedure TFrmVSRptTndCountCA.BuildLineVAT
                                       (    ObjTenderGroup : TObjTenderGroup;
                                        var TxtLine        : string;
                                        var FlgHasData     : Boolean        );
var
  ValTrans         : Currency;         // Total Amount TenderGroup
  ValTransVAT      : Currency;         // Total Amount of VAT
  PctVAT           : Real;             // Vat percentage
  TxtPctVAT        : string;           // Vat percentage in string format
  TxtLeft          : string;           // Left side for splitstring
  NumSafeTrans     : Integer;          // Number found item in SafeTransaction
  NumTransDetail   : Integer;          // Number found item in TransDetail
  ObjSafeTrans     : TObjSafeTransaction;   // Found SafeTransaction
  ObjTransDetail   : TObjTransDetail;       // Found TransDetail
  NumCode          : Integer;          // Code for Val
begin  // of TFrmVSRptTndCountCA.BuildLineVAT
  ValTrans := 0;
  ValTransVAT := 0.0;

  NumSafeTrans := -1;
  repeat
    ObjSafeTrans := LstSafeTransaction.NextSafeTransactionForType
                     (IdtSafeTransaction, CtCodSttDrawerCashdesk, NumSafeTrans);
    if Assigned (ObjSafeTrans) then begin
      NumTransDetail := -1;
      ObjTransDetail := LstSafeTransaction.NextTransDetail
                          (IdtSafeTransaction, ObjSafeTrans.NumSeq,
                           ObjTenderGroup.IdtTenderGroup, NumTransDetail);
      if Assigned (ObjTransDetail) then begin
        ValTrans := ValTrans +
                    (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit);
        SplitString (ObjTransDetail.TxtDescr, #9, TxtLeft, TxtPctVAT);
        if Trim (TxtPctVAT) > '' then
          Val (TxtPctVAT, PctVAT, NumCode)
        else
          PctVAT := 0;
        ValTransVAT := (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit) *
                       PctVAT / 100;
      end;
    end;
  until not Assigned (ObjSafeTrans);

  FlgHasData := ValTrans <> 0;
  TxtLine := ObjTenderGroup.TxtPublDescr +
             SepCol + FormatValue (ValTrans) +
             SepCol + FormatValue (ValTransVAT) +
             SepCol + FormatValue (ValTrans - ValTransVAT);

end;   // of TFrmVSRptTndCountCA.BuildLineVAT

//=============================================================================
// TFrmVSRptTndCountCA.PrintLineVAT : generates the body-line of the table
// with the VAT results for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to generate the line for.
//=============================================================================

procedure TFrmVSRptTndCountCA.PrintLineVAT (ObjTenderGroup : TObjTenderGroup);
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptTndCountCA.PrintLineVAT
  BuildLineVAT (ObjTenderGroup, TxtLine, FlgHasData);

  if FlgHasData or FlgPrintNullLine then
    PrintTableLine (TxtLine);
end;   // of TFrmVSRptTndCountCA.PrintLineVAT

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableVATBody : generates the body of the table
// with the VAT results.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableVATBody;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup
begin  // of TFrmVSRptTndCountCA.GenerateTableVATBody
  FlgPrintNullLine := True;

  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do
    if (LstTenderGroup.TenderGroup[CntTenderGroup].CodType =
        CtCodTgtVATTotal) then
      PrintLineVAT (LstTenderGroup.TenderGroup[CntTenderGroup]);
end;   // of TFrmVSRptTndCountCA.GenerateTableVATBody

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableVATTotal : generates the table with the
// totals of the VAT results.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableVATTotal;
begin  // of TFrmVSRptTndCountCA.GenerateTableVATTotal
end;   // of TFrmVSRptTndCountCA.GenerateTableVATTotal

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableVAT : generates the table with the VAT
// results.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableVAT;
begin  // of TFrmVSRptTndCountCA.GenerateTableVAT
  InitializeBeforeStartTable;
  BuildTableVATFmtAndHdr;

  VspPreview.StartTable;
  try
    GenerateTableVATBody;
    if QtyLinesPrinted > 1 then
      GenerateTableVATTotal;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCountCA.GenerateTableVAT

//=============================================================================
// TFrmVSRptTndCountCA.BuildTableTheorFmtAndHdr : builds the Format and Header
// for the table with the total of theoretic results.
//=============================================================================

procedure TFrmVSRptTndCountCA.BuildTableTheorFmtAndHdr;
begin  // of TFrmVSRptTndCountCA.BuildTableTheorFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  AppendFmtAndHdrAmount ('');
  TxtTableHdr := '';
end;   // of TFrmVSRptTndCountCA.BuildTableTheorFmtAndHdr

//=============================================================================
// TFrmVSRptTndCountCA.BuildLineTheor : builds the body-line of the table
// with the total of theoretic results.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to build the line for.
//                                  -----
// OUTPUT  : TxtLine = builded line.
//           FlgHasData = True if the line contains non-zero data;
//                        False if all numeric data on the line is zero.
//=============================================================================

procedure TFrmVSRptTndCountCA.BuildLineTheor (var TxtLine        : string;
                                              var FlgHasData     : Boolean);
begin  // of TFrmVSRptTndCountCA.BuildLineTheor
  FlgHasData := ValTotalTheor <> 0;
  TxtLine := CtTxtTheorTotal +
             SepCol + FormatValue (ValTotalTheorPrint);
end;   // of TFrmVSRptTndCountCA.BuildLineTheor

//=============================================================================
// TFrmVSRptTndCountCA.PrintLineTheor : generates the body-line of the table
// with the total of theoretic results for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to generate the line for.
//=============================================================================

procedure TFrmVSRptTndCountCA.PrintLineTheor;
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptTndCountCA.PrintLineTheor
  BuildLineTheor (TxtLine, FlgHasData);

  if FlgHasData or FlgPrintNullLine then
    PrintTableLine (TxtLine);
end;   // of TFrmVSRptTndCountCA.PrintLineTheor

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableTheorBody : generates the body of the table
// with the total of theoretic results.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableTheorBody;
begin  // of TFrmVSRptTndCountCA.GenerateTableTheorBody
  FlgPrintNullLine := True;
  PrintLineTheor;
end;   // of TFrmVSRptTndCountCA.GenerateTableTheorBody

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableTheorTotal : generates the table with the
// totals of the theoretic results.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableTheorTotal;
begin  // of TFrmVSRptTndCountCA.GenerateTableTheorTotal
end;   // of TFrmVSRptTndCountCA.GenerateTableTheorTotal

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableTheor : generates the table with the
// theoretic total
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableTheor;
begin  // of TFrmVSRptTndCountCA.GenerateTableTheor
  InitializeBeforeStartTable;
  BuildTableTheorFmtAndHdr;

  VspPreview.StartTable;
  try
    GenerateTableTheorBody;
    if QtyLinesPrinted > 1 then
      GenerateTableTheorTotal;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCountCA.GenerateTableTheor

//=============================================================================
// TFrmVSRptTndCountCA.BuildTableGroupTotalFmtAndHdr : builds the Format and
// Header for the table with the group total results
//=============================================================================

procedure TFrmVSRptTndCountCA.BuildTableGroupTotalFmtAndHdr;
begin  // of TFrmVSRptTndCountCA.BuildTableGroupTotalFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtHdrGroupTotal;

  AppendFmtAndHdrQuantity (CtTxtHdrQtyUnit);
  AppendFmtAndHdrAmount (CtTxtHdrValUnit);
end;   // of TFrmVSRptTndCountCA.BuildTableGroupTotalFmtAndHdr

//=============================================================================
// TFrmVSRptTndCountCA.BuildLineGroupTotal : builds the body-line of the table
// with group total results for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to build the line for.
//                                  -----
// OUTPUT  : TxtLine = builded line.
//           FlgHasData = True if the line contains non-zero data;
//                        False if all numeric data on the line is zero.
//=============================================================================

procedure TFrmVSRptTndCountCA.BuildLineGroupTotal
                                (    ObjTenderGroup : TObjTenderGroup;
                                 var TxtLine        : string;
                                 var FlgHasData     : Boolean);
var
  QtyPrint         : Integer;          // Quantity Tendergroup
  QtyTrans         : Integer;          // Total Quantity TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
  ValPrint         : Currency;         // Calculate value to print
begin  // of TFrmVSRptTndCountCA.BuildLineGroupTotal
  FlgHasData := False;
  TxtLine    := ObjTenderGroup.TxtPublDescr;

  // Return of PayIn
  TLstSafeTransaction(LstSafeTransaction).TotalTransDetailForReason
                                               (IdtSafeTransaction,
                                                CtCodSttPayOutTender,
                                                CtCodStrReturnPayin,
                                                ObjTenderGroup.IdtTenderGroup,
                                                True, QtyTrans, ValTrans);
  ValPrint := ValTrans;
  QtyPrint := QtyTrans;
  // Calculate total PayOut
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttPayOutTender,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValTrans - ValPrint;  // Subtract the return of payin
  QtyPrint := QtyTrans - QtyPrint;
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttFinalCount,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans;
  QtyPrint := QtyPrint + QtyTrans;
  TxtLine := TxtLine + SepCol + FormatValue (QtyPrint) + SepCol +
             FormatValue (ValPrint);
  FlgHasData := ValPrint > 0;
end;   // of TFrmVSRptTndCountCA.BuildLineGroupTotal

//=============================================================================
// TFrmVSRptTndCountCA.PrintLineGroupTotal : generates the body-line of the
// table with the group total for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to generate the line for.
//=============================================================================

procedure TFrmVSRptTndCountCA.PrintLineGroupTotal
                                (ObjTenderGroup : TObjTenderGroup);
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptTndCountCA.PrintLineGroupTotal
  BuildLineGroupTotal (ObjTenderGroup, TxtLine, FlgHasData);

  if FlgHasData or
     (FlgPrintNullLine and AllowTenderGroup (CodRunFunc, ObjTenderGroup)) then
    PrintTableLine (TxtLine);
end;   // of TFrmVSRptTndCountCA.PrintLineGroupTotal


//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableGroupTotalBody : generates the body of the
// table with the group totals
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableGroupTotalBody;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup
begin  // of TFrmVSRptTndCountCA.GenerateTableGroupTotalBody
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    if ((LstTenderGroup.TenderGroup[CntTenderGroup].CodType = CtCodTgtCash) or
       (LstTenderGroup.TenderGroup[CntTenderGroup].CodType = CtCodTgtCountable))
       and
       LstTenderGroup.TenderGroup[CntTenderGroup].FlgDetailPrint then
      PrintLineGroupTotal (LstTenderGroup.TenderGroup[CntTenderGroup]);
  end;
end;   // of TFrmVSRptTndCountCA.GenerateTableGroupTotalBody

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableGroupTotalTotal : generates the table with
// the totals of the group totals.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableGroupTotalTotal;
begin  // of TFrmVSRptTndCountCA.GenerateTableGroupTotalTotal
end;   // of TFrmVSRptTndCountCA.GenerateTableGroupTotalTotal

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableGroupTotal : generates the table with the
// group total results.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableGroupTotal;
begin  // of TFrmVSRptTndCountCA.GenerateTableGroupTotal
  InitializeBeforeStartTable;
  BuildTableGroupTotalFmtAndHdr;
  VspPreview.StartTable;
  try
    GenerateTableGroupTotalBody;
    if QtyLinesPrinted > 0 then
      GenerateTableGroupTotalTotal;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCountCA.GenerateTableGroupTotal

//=============================================================================
// TFrmVSRptTndCount.BuildTableBagFmtAndHdr : builds the Format and Header
// for the table with the bag numbers.
//=============================================================================

procedure TFrmVSRptTndCountCA.BuildTableBagFmtAndHdr;
begin  // of TFrmVSRptTndCountCA.BuildTableBagFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtHdrBagSeal;
  AppendFmtAndHdrBagNumber (CtTxtHdrNumber);
end;   // of TFrmVSRptTndCountCA.BuildTableBagFmtAndHdr

//=============================================================================
// TFrmVSRptTndCountCA.BuildLineBag : builds the body-line of the table
// with group bag numbers for the given TenderGroup.
//                                  -----
// INPUT   : TxtExplanation = Explanation string that has to be converted to
//                            retrieve the bagnumber
//                                  -----
// OUTPUT  : TxtLine = builded line.
//           FlgHasData = True if the line contains non-zero data;
//                        False if all numeric data on the line is zero.
//=============================================================================

procedure TFrmVSRptTndCountCA.BuildLineBag (    TxtExplanation : string;
                                            var TxtLine        : string;
                                            var FlgHasData     : Boolean);
var
  TxtBagNumber     : string;           // Bag number
  TxtIdtTenderGroup: string;           // Identifier tendergroup as string
  IdtTenderGroup   : Integer;          // Identifier tendergroup
  TxtPublDescr     : string;           // description of tendergroup
  CntTender        : Integer;          // TenderGroup Counter
begin  // of TFrmVSRptTndCountCA.BuildLineBag
  SplitString (TxtExplanation, ';', TxtIdtTenderGroup, TxtBagNumber);
  IdtTenderGroup := StrToInt (TxtIdtTenderGroup);
  for CntTender := 0 to Pred (LstTenderGroup.Count) do
    if IdtTenderGroup = LstTenderGroup.TenderGroup[CntTender].
                                                       IdtTenderGroup then begin
      TxtPublDescr := LstTenderGroup.TenderGroup[CntTender].TxtPublDescr;
      Break;
    end;
  TxtLine := TxtPublDescr + SepCol + TxtBagNumber;
end;   // of TFrmVSRptTndCountCA.BuildLineBag

//=============================================================================
// TFrmVSRptTndCountCA.PrintLineBag : generates the body-line of the table
// with the bag numbers in TxtExplanation
//                                  -----
// INPUT   : TxtExplanation = Contains the bagnumber and the group
//=============================================================================

procedure TFrmVSRptTndCountCA.PrintLineBag (TxtExplanation : string);
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptTndCountCA.PrintLineBag
  BuildLineBag (TxtExplanation, TxtLine, FlgHasData);

  if FlgHasData then
    PrintTableLine (TxtLine);
end;   // of TFrmVSRptTndCountCA.PrintLineBag

//=============================================================================
// TFrmVSRptTndCount.GenerateTableBagBody : generates the body of the table
// with the bag numbers.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableBagBody;
var
  StrLstBagPrint   : TStringList;      // Bag list
  CntLine          : Integer;          // Line counter
begin  // of TFrmVSRptTndCountCA.GenerateTableBagBody
  FlgPrintNullLine := True;
  StrLstBagPrint := LstSafeTransaction.GetExplanationForKeyWord
                       (CurrentSafeTransaction, CtTxtFmtExplBagCA);
  try
    if StrLstBagPrint.Count > 0 then begin
      for CntLine := 0 to Pred (StrLstBagPrint.Count) do
        PrintLineBag (StrLstBagPrint[CntLine]);
    end;
  finally
    StrLstBagPrint.Free;
  end;
end;   // of TFrmVSRptTndCountCA.GenerateTableBagBody

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableBagTotal : generates the table with the
// totals of the bag results.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableBagTotal;
begin  // of TFrmVSRptTndCountCA.GenerateTableBagTotal
end;   // of TFrmVSRptTndCountCA.GenerateTableBagTotal

//=============================================================================
// TFrmVSRptTndCountCA.GenerateTableBag : generates the table with the Bag
// numbers
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableBag;
begin  // of TFrmVSRptTndCountCA.GenerateTableBag
  InitializeBeforeStartTable;
  BuildTableBagFmtAndHdr;

  VspPreview.StartTable;
  try
    GenerateTableBagBody;
    if QtyLinesPrinted > 1 then
      GenerateTableBagTotal;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCountCA.GenerateTableBag

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableNotCountTotal;
begin  // of TFrmVSRptTndCountCA.GenerateTableNotCountTotal
  inherited;
  ValTotalTheorPrint := ValTotalTheorPrint + ValTotalTheor;
end;   // of TFrmVSRptTndCountCA.GenerateTableNotCountTotal

//=============================================================================
// TFrmVSRptTndCountCA.PrintValidation : Prints the validations in a list
//=============================================================================

procedure TFrmVSRptTndCountCA.PrintValidation;
var
  StrLstValidPrint : TStringList;      // List of validations
  CntLine          : Integer;          // Line counter
begin  // of TFrmVSRptTndCountCA.PrintValidation
  StrLstValidPrint := LstSafeTransaction.GetExplanationForKeyWord
                        (CurrentSafeTransaction, CtTxtFmtExplValidationCA);
  try
    if StrLstValidPrint.Count > 0 then begin
      VspPreview.CurrentX := VspPreview.MarginLeft;
      VspPreview.Font.Style := VspPreview.Font.Style + [FsBold];
      VspPreview.Paragraph := CtTxtHdrValid;
      VspPreview.Font.Style := VspPreview.Font.Style - [FsBold];
      for CntLine := 0 to Pred (StrLstValidPrint.Count) do begin
        VspPreview.CurrentX := VspPreview.MarginLeft;
        VspPreview.Paragraph := StringReplace (StrLstValidPrint[CntLine],
                                               ';', #9, []);
      end;
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
    end;
  finally
    StrLstValidPrint.Free;
  end;
end;   // of TFrmVSRptTndCountCA.PrintValidation

//=============================================================================
// TFrmVSRptTndCountCA.PrintBagReports : Prints a new page for each bag
//=============================================================================

procedure TFrmVSRptTndCountCA.PrintBagReports;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup
  StrLstBags       : TStringList;      // Stringlist with bags
  TxtBagSeal       : string;           // Bag seal number
  ValFontSave      : Variant;          // Save original FontSize
begin  // of TFrmVSRptTndCountCA.PrintBagReports
  StrLstBags := LstSafeTransaction.
                  GetExplanationForKeyword (CurrentSafeTransaction,
                                            CtTxtFmtExplBagCA);
  StrLstBags.Text := StringReplace (StrLstBags.Text, ';', '=', [rfReplaceAll]);
  StrLstBags.Text := StringReplace (StrLstBags.Text, ' ', '', [rfReplaceAll]);
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    TxtBagSeal := StrLstBags.
                    Values[IntToStr (LstTenderGroup.TenderGroup[CntTenderGroup].
                                       IdtTenderGroup)];
    if Trim (TxtBagSeal) <> '' then begin
      VspPreview.NewPage;
      ValFontSave := VspPreview.FontSize;
      VspPreview.FontSize := ViValFontHeader;
      VspPreview.FontBold := True;
      VspPreview.CurrentX := VspPreview.MarginLeft;
      VspPreview.Paragraph :=
        LstTenderGroup.TenderGroup[CntTenderGroup].TxtPublDescr;
      VspPreview.FontSize := ViValFontSubTitle;
      VspPreview.CurrentX := VspPreview.MarginLeft;
      VspPreview.Paragraph := Format (CtTxtHdrBagNumber, [TxtBagSeal]);
      VspPreview.FontSize := ValFontSave;
      VspPreview.FontBold := False;
      GenerateTableDetailTenderGroup
        (LstTenderGroup.TenderGroup[CntTenderGroup]);
      SetLength (ArrPages, Length (ArrPages) + 1);
      ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
    end;
  end;
end;   // of TFrmVSRptTndCountCA.PrintBagReports

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateReport;
begin  // of TFrmVSRptTndCountCA.GenerateReport
  case CodRunFunc of
    CtCodFuncPayIn, CtCodFuncPayinC:    NumRef := '0027';
    CtCodFuncPayOut, CtCodFuncPayoutC:  NumRef := '0028';
    CtCodFuncTransfer:                  NumRef := '0029';
    CtCodFuncTransferCM:                NumRef := '0030';
  end;
  Visible := True;
  Visible := False;

  InitializeBeforeGenerateReport;
  ValTotalTheorPrint := 0;
  SetLength (ArrPages, 1);                                          
  ArrPages [Length (ArrPages) - 1] := 1;

  VspPreview.StartDoc;
  try
    if CodRunFunc in [CtCodFuncPayOut, CtCodFuncPayOutC, CtCodFuncPayInC] then
    GenerateTableDetail;
    GenerateTableCount;
    GenerateTableSummaryCurr;
    GenerateTableBag;
    PrintExplanation;
    PrintValidation;
    PrintConclusion;
    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
  finally
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
  PrintRef;
  if FlgSaveDocument and (DmdFpnTender.QtySplRptCount > 0) then
    SaveDocument;
end;   // of TFrmVSRptTndCountCA.GenerateReport

//=============================================================================
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.Start
procedure TFrmVSRptTndCountCA.GenerateReportPayOut;
begin  // of TFrmVSRptTndCountCA.GenerateReportPayOut
  case CodRunFunc of
    CtCodFuncPayIn, CtCodFuncPayinC:    NumRef := '0027';
    CtCodFuncPayOut, CtCodFuncPayoutC:  NumRef := '0028';
    CtCodFuncTransfer:                  NumRef := '0029';
    CtCodFuncTransferCM:                NumRef := '0030';
  end;
  Visible := True;
  Visible := False;
  InitializeBeforeGenerateReport;
  ValTotalTheorPrint := 0;
  SetLength (ArrPages, 1);                                          
  ArrPages [Length (ArrPages) - 1] := 1;
  VspPreview.StartDoc;
  try
    if CodRunFunc in [CtCodFuncPayOut, CtCodFuncPayOutC, CtCodFuncPayInC] then
    GenerateTablePayOut;
    PrintConclusion;
    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
  finally
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
  PrintRef;
  if FlgSaveDocument and (DmdFpnTender.QtySplRptCount > 0) then
    SaveDocument;
end;   // of TFrmVSRptTndCountCA.GenerateReportPayOut
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.End
//=============================================================================
constructor TFrmVSRptTndCountCA.Create (AOwner : TComponent);
begin  // of TFrmVSRptTndCountCA.Create
  ViValRptWidthVal := 9;
  ViValMarginHeader := 1500;
  inherited;
end;   // of TFrmVSRptTndCountCA.Create

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FVSRptTndCountCA
