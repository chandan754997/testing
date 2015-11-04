//=====Copyright 2009 (c) Centric Retail Solutions. All rights reserved.=======
// Packet   : FlexPoint
// Unit     : FVSRptTndGlobalCountCA = Form VideoSoft RePorT TeNDer GLOBAL COUNT
//                                    for CAstorama
// Customer :  Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndGlobalCountCA.pas,v 1.7 2010/04/21 08:07:46 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - PRptGlobalCount - CVS revision 1.10
//=============================================================================

unit FVSRptTndGlobalCountCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FVSRptTndCountCA, ActnList, ImgList, Menus, OleCtrls,
  SmVSPrinter7Lib_TLB, Buttons, ComCtrls, ToolWin, DFpnTenderGroup, ExtCtrls;

//=============================================================================
// Global definitions
//=============================================================================


resourcestring     // for printing the header of the final count.
  CtTxtHdrGlobalReport  = 'Financial report of the operator (Final count)';
  CtTxtHdrDepartment    = 'Department:';

//*****************************************************************************
// TFrmVSRptTndGlobalCountCA
//*****************************************************************************

type
  TFrmVSRptTndGlobalCountCA = class(TFrmVSRptTndCountCA)
    PageControl1: TPageControl;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FFlgNoName: Boolean; 
  protected
    { Protected declarations }
    FIdtDepartment : integer;
    FNumDepartments : integer;    
    function FndIdtSafeTransAndNumSeq (IdtSafeTransaction : Integer;
                                       NumSeq             : Integer) : Boolean;
                                                              overload; virtual;
    function FndIdtSafeTransAndNumSeq (IdtSafeTransaction : Integer;
                                       NumSeq             : Integer;
                                       CodType            : Integer) : Boolean;
                                                              overload; virtual;
    function FndIdtSafeTransAndNumSeq (IdtSafeTransaction : Integer;
                                       NumSeq             : Integer;
                                       CodType            : Integer;
                                       CodReason          : Integer) : Boolean;
                                                              overload; virtual;
    procedure PrintPageHeader; override;
    procedure InitializeBeforeGenerateReport; override;

    // Table Cash and Countable
    procedure BuildLineCount (    ObjTenderGroup : TObjTenderGroup;
                              var TxtLine        : string;
                              var FlgHasData     : Boolean        ); override;

    // Table Not countable
    procedure BuildLineNotCount (    ObjTenderGroup : TObjTenderGroup;
                                 var TxtLine        : string;
                                 var FlgHasData     : Boolean        ); override;

    // Table VAT values.
    procedure BuildLineVAT (    ObjTenderGroup : TObjTenderGroup;
                            var TxtLine        : string;
                            var FlgHasData     : Boolean        ); override;

    // Table Group totals.
    procedure BuildLineGroupTotal (    ObjTenderGroup : TObjTenderGroup;
                                   var TxtLine        : string;
                                   var FlgHasData     : Boolean); override;

    // Table Bag Seals
    procedure BuildLineBag (    TxtExplanation : string;
                            var TxtLine        : string;
                            var FlgHasData     : Boolean); override;

    // Table Informative
    procedure BuildLineInformative (    ObjTenderGroup : TObjTenderGroup;
                                    var TxtLine        : string;
                                    var FlgHasData     : Boolean); override;


    // General Table with summary of Foreign currencies
    procedure BuildTableSummaryCurrFmtAndHdr; override;
  public
    { Public declarations }
    procedure GenerateReport; override;
  published
    { Published declarations }
    property IdtDepartment : integer read FIdtDepartment
                                    write FIdtDepartment;
    property NumDepartments : integer read FNumDepartments
                                    write FNumDepartments;
    property FlgNoName: Boolean read FFlgNoName write FFlgNoName;
  end; // of TFrmVSRptTndGlobalCountCA

var
  FrmVSRptTndGlobalCountCA: TFrmVSRptTndGlobalCountCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  StStrW,
  SfDialog,
  SmUtils,

  RFpnTender,

  FVSRptTndCount,

  DFpnSafeTransaction,
  DFpnSafeTransactionCA,
  DFpnTender, DFpnUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptTndGlobalCountCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndGlobalCountCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2010/04/21 08:07:46 $';

//*****************************************************************************
// Implementation of TFrmVSRptTndGlobalCountCA
//*****************************************************************************

//=============================================================================
// TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq : evaluate if the current
// IdtSafeTransaction and NumSeq is found in the LstSafeTransaction
//                                  -----
// INPUT   : IdtSafeTransaction, NumSeq = key-fields to search for.
//                                  -----
// FUNCRES : Returns True if an entry is found.
//=============================================================================

function TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq
                                      (IdtSafeTransaction : Integer;
                                       NumSeq             : Integer) : Boolean;
var
  CntItem          : Integer;          // Loop all LstSafeTransaction
begin  // of TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq
  Result := False;
  for CntItem := 0 to Pred (LstSafeTransaction.Count) do begin
    if (LstSafeTransaction.SafeTransaction[CntItem].IdtSafeTransaction =
        IdtSafeTransaction) and
       (LstSafeTransaction.SafeTransaction[CntItem].NumSeq = NumSeq) then begin
      Result := True;
      Break;
    end;
  end;
end;   // of TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq

//=============================================================================
// TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq : evaluate if the current
// IdtSafeTransaction and NumSeq and CodType is found in the LstSafeTransaction
//                                  -----
// INPUT   : IdtSafeTransaction, NumSeq, CodType = key-fields to search for.
//                                  -----
// FUNCRES : Returns True if an entry is found.
//=============================================================================

function TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq
                                  (IdtSafeTransaction : Integer;
                                   NumSeq             : Integer;
                                   CodType            : Integer) : Boolean;
var
  CntItem          : Integer;          // Loop all LstSafeTransaction
begin  // of TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq
  Result := False;
  for CntItem := 0 to Pred (LstSafeTransaction.Count) do begin
    if (LstSafeTransaction.SafeTransaction[CntItem].IdtSafeTransaction =
        IdtSafeTransaction) and
       (LstSafeTransaction.SafeTransaction[CntItem].NumSeq = NumSeq) and
       (LstSafeTransaction.SafeTransaction[CntItem].CodType = CodType) then
        begin
      Result := True;
      Break;
    end;
  end;
end;   // of TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq

//=============================================================================
// TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq : evaluate if the current
// IdtSafeTransaction, NumSeq, CodType and Reason is found in
// the LstSafeTransaction
//                                  -----
// INPUT   : IdtSafeTransaction, NumSeq, CodType, CodReason = key-fields to
//                                                            search for.
//                                  -----
// FUNCRES : Returns True if an entry is found.
//=============================================================================

function TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeq
                                      (IdtSafeTransaction : Integer;
                                       NumSeq             : Integer;
                                       CodType            : Integer;
                                       CodReason          : Integer) : Boolean;
var
  CntItem          : Integer;          // Loop all LstSafeTransaction
begin  // of TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeqAndReason
  Result := False;
  for CntItem := 0 to Pred (LstSafeTransaction.Count) do begin
    if (LstSafeTransaction.SafeTransaction[CntItem].IdtSafeTransaction =
        IdtSafeTransaction) and
       (LstSafeTransaction.SafeTransaction[CntItem].NumSeq = NumSeq) and
       (LstSafeTransaction.SafeTransaction[CntItem].CodType = CodType) and
       (LstSafeTransaction.SafeTransaction[CntItem].CodReason = CodReason) then
        begin
      Result := True;
      Break;
    end;
  end;
end;   // of TFrmVSRptTndGlobalCountCA.FndIdtSafeTransAndNumSeqAndReason

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.PrintPageHeader;
var
  TxtDepartment    : string;
  NumCounter       : integer;
  TxtHeader        : string;
begin  // of TFrmVSRptTndGlobalCountCA.PrintPageHeader
  // This header is only applied to the final count.
  VspPreview.FontBold := True;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.CurrentY := ValOrigMarginTop;
  VspPreview.Text := CtTxtHdrGlobalReport;
  VspPreview.FontBold := False;
  if IdtDepartment <> -1 then begin
    VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
    VspPreview.CurrentX := VspPreview.Marginleft;
    if IdtDepartment = 0 then begin
      TxtHeader := CtTxtHdrDepartment + ' 1';
      for NumCounter := 2 to NumDepartments do
        TxtHeader := TxtHeader + ', ' + IntToStr(NumCounter);
      VspPreview.Text := TxtHeader;
    end
    else
      VspPreview.Text := CtTxtHdrDepartment + ' ' + IntToStr(IdtDepartment)
  end
  else begin
    TxtDepartment := '';
  end;
  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.Text := CtTxtHdrNbOperator + ' ' + IdtRegFor;

  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  If not FlgNoName then
    VspPreview.Text := CtTxtHdrNameOperator + ' ' + TxtNameRegFor;

  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;

  VspPreview.Text := CtTxtHdrDat + ' : ' +
                     DateToStr (DmdFpnSafeTransactionCA.DatExecution);

  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
end;   // of TFrmVSRptTndGlobalCountCA.PrintPageHeader

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.InitializeBeforeGenerateReport;
begin  // of TFrmVSRptTndGlobalCountCA.InitializeBeforeGenerateReport
end;   // of TFrmVSRptTndGlobalCountCA.InitializeBeforeGenerateReport

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.BuildLineCount
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean        );
var
  ValTrans         : Currency;         // Total Amount TenderGroup
  ValTheor         : Currency;         // Total theoretic
  ValCashDesk      : Currency;         // Total Amount TenderGroup CashDesk
  // Specifiek for counting payin results.
  ValOnStart       : Currency;         // Total Amount TenderGroup OnStart
  ValForNext       : Currency;         // Total Amount TenderGroup ForNext
  ValPayInTender   : Currency;         // Total Amount TenderGroup PayInTender
  ValPayInCashDesk : Currency;         // Total Amount TenderGroup PayInCashD
  ValPayIn         : Currency;         // Total Amount TenderGroup PayIn
  ValTransfer      : Currency;         // Total Amount TenderGroup Transfer
  ValRetPayIn      : Currency;         // Total Amount TenderGroup Ret PayIn
  // Specifiek for counting payin results.
  QtyPayOutTender  : Integer;          // Total Quantity TenderGroup Tender
  ValPayOutTender  : Currency;         // Total Amount TenderGroup Tender
  QtyPayOutCashDesk: Integer;          // Total Quantity TenderGroup CashDesk
  ValPayOutCashDesk: Currency;         // Total Amount TenderGroup CashDesk
  QtyPayOut        : Integer;          // Total Quantity TenderGroup PayOut
  ValPayOut        : Currency;         // Total Amount TenderGroup PayOut
  ValTotalDiff     : Currency;         // Total Amount Difference
  ObjTransDetail   : TObjTransDetail;  // Found TransDetail
  CntItem          : Integer;          // Loop all SafeTransDetails
  IdtSafeTransFnd  : Integer;          // IdtSafeTransaction to found
  NumSeqSafeTransFnd    : Integer;     // NumSeq to found in SafeTransaction
begin  // of TFrmVSRptTndGlobalCountCA.BuildLineCount
  if CodRunFunc <> CtCodFuncCount then begin
    inherited;
    exit;
  end;
  TxtLine     := ObjTenderGroup.TxtPublDescr;
  ValPayIn    := 0;
  ValRetPayIn := 0;
  QtyPayOut   := 0;
  ValPayOut   := 0;
  ValCashDesk := 0;
  ValTrans    := 0;
  ValTransfer := 0;
  for CntItem := 0 to Pred (LstSafeTransaction.LstTransDetail.Count) do begin
    ObjTransDetail := LstSafeTransaction.LstTransDetail.TransDetail[CntItem];
    ValOnStart := 0;
    ValForNext := 0;
    ValPayInTender    := 0;
    ValPayInCashDesk  := 0;
    QtyPayOutTender   := 0;
    ValPayOutTender   := 0;
    QtyPayOutCashDesk := 0;
    ValPayOutCashDesk := 0;
    if ObjTransDetail.IdtTenderGroup = ObjTenderGroup.IdtTenderGroup then begin
      IdtSafeTransFnd := ObjTransDetail.IdtSafeTransaction;
      NumSeqSafeTransFnd := ObjTransDetail.NumSeq;
      // Retrieve total drawer
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttDrawerCashdesk) then
        ValCashDesk := ValCashDesk + ObjTransDetail.ValUnit;
      // Calculate total PayIn = Change Money + PayIn
      // Definite 'Total PayIN' = 'Startvalue' - 'Change for next' +
      //                          'PayIn in Tender' + 'PayIn in Cashdesk'
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttChangeOnStart) then 
        ValOnStart := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttChangeForNext) then
        ValForNext := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttPayInTender) then 
        ValPayInTender := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttPayInCashdesk) then
        ValPayInCashDesk := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      ValPayIn := ValPayIn +
                  (ValOnStart - ValForNext + ValPayInTender + ValPayInCashDesk);
      // Transfer
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttPayInTransfer) then
        ValTransfer := ValTransfer +
                       ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttPayOutTransfer) then
        ValTransfer := ValTransfer -
                       ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      // Return of PayIn
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
           CtCodSttPayOutTender, CtCodStrReturnPayin) then
        ValRetPayIn := ValRetPayIn +
                       ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      // Calculate total PayOut
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttPayOutTender) then begin
        QtyPayOutTender := ObjTransDetail.QtyUnit;
        ValPayOutTender := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      end;
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttPayOutCount) then begin
        QtyPayOutCashDesk := ObjTransDetail.QtyUnit;
        ValPayOutCashDesk := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      end;
      QtyPayOut := QtyPayOut + QtyPayOutTender + QtyPayOutCashDesk;
      ValPayOut := ValPayOut + ValPayOutTender + ValPayOutCashDesk;
      // Retrieve total count
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttFinalCount) then
        ValTrans := ValTrans + ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
    end;
  end;
  // After calculation the total Payout and Return PayIn; the PayOut
  // must be decreased by Return PayIn
  ValPayOut := ValPayOut - ValRetPayIn;
  // Calculate the ValTheor and the ValTotalTheo
  ValTheor := ValCashDesk + ValPayIn - ValPayOut + ValTransfer;
  ValTotalTheor := ValTotalTheor + ValTheor;
  // Counting the Difference
  ValTotalDiff := ValTheor - ValTrans - ValRetPayIn;
  // Calculate totals
  ValTotalDrawer      := ValTotalDrawer + ValCashDesk;
  ValTotalPayIn       := ValTotalPayIn + ValPayIn;
  ValTotalTransfert   := ValTotalTransfert + ValTransfer;
  ValTotalReturnPayIn := ValTotalReturnPayIn + ValRetPayIn;
  ValTotalPayOut      := ValTotalPayOut + ValPayOut;
  ValTotalCount       := ValTotalCount + ValTrans;

  FlgHasData := FlgHasData or (ValCashDesk <> 0) or (ValPayIn <> 0) or
                (ValTransfer <> 0) or (ValRetPayIn <> 0) or
                (ValPayOut <> 0) or (ValTrans <> 0);

  TxtLine := TxtLine +
             SepCol + FormatValue (ValCashDesk) +
             SepCol + FormatValue (ValPayIn) +
             SepCol + FormatValue (ValTransfer) +
             SepCol + FormatValue (ValRetPayIn) +
             SepCol + FormatValue (ValPayOut) +
             SepCol + FormatValue (ValTrans) +
             SepCol + FormatValue (ValTotalDiff);
end;   // of TFrmVSRptTndGlobalCountCA.BuildLineCount

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.BuildLineNotCount
                                        (    ObjTenderGroup : TObjTenderGroup;
                                         var TxtLine        : string;
                                         var FlgHasData     : Boolean        );
var
  QtyTrans         : Integer;          // Total Quantity TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
  ValTotalGroup    : Currency;         // Total amount for all IdtTendergroups
  CntItem          : Integer;          // Loop all items in the LstSafeTrans
  IdtSafeTrans     : Integer;          // Ident of the SafeTransaction to find
  StrLstIdtSafeTr  : TStringList;      // List with unique IdtSafeTransactions
begin  // of TFrmVSRptTndGlobalCountCA.BuildLineNotCount
  FlgHasData := False;
  TxtLine    := ObjTenderGroup.TxtPublDescr;
  StrLstIdtSafeTr := TStringList.Create;
  StrLstIdtSafeTr.Duplicates := dupIgnore;
  StrLstIdtSafeTr.Sorted := True;
  ValTotalGroup := 0;
  try
    for CntItem := 0 to Pred (LstSafeTransaction.Count) do
      StrLstIdtSafeTr.Add (IntToStr (
          LstSafeTransaction.SafeTransaction [CntItem].IdtSafeTransaction));
    for CntItem := 0 to Pred (StrLstIdtSafeTr.Count) do begin
      IdtSafeTrans := StrToInt (StrLstIdtSafeTr [CntItem]);

      LstSafeTransaction.TotalTransDetailTheoreticForCount
        (IdtSafeTrans, ObjTenderGroup.IdtTenderGroup, False, QtyTrans, ValTrans);
      ValTotalGroup := ValTotalGroup + ValTrans;
    end;
  finally
    StrLstIdtSafeTr.Free;
  end;
  if ObjTenderGroup.IdtTenderGroup = CtRemiseAuto then
    ValTotalRemiseAuto := ValTotalRemiseAuto + ValTotalGroup
  else
    ValTotalTheor := ValTotalTheor + ValTotalGroup -
                     GetTransfers (LeftPadStringCh (IdtRegFor, '0', 3),
                                   ObjTenderGroup.IdtTenderGroup);
  FlgHasData := FlgHasData or (ValTotalGroup <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTotalGroup);
end;   // of TFrmVSRptTndGlobalCountCA.BuildLineNotCount

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.BuildLineVAT
                                       (    ObjTenderGroup : TObjTenderGroup;
                                        var TxtLine        : string;
                                        var FlgHasData     : Boolean        );
var
  ValTrans         : Currency;         // Total Amount TenderGroup
  ValTransVAT      : Currency;         // Total Amount of VAT
  PctVAT           : Real;             // Vat percentage
  TxtPctVAT        : string;           // Vat percentage in string format
  TxtLeft          : string;           // Left side for splitstring
  ObjTransDetail   : TObjTransDetail;  // Found TransDetail
  NumCode          : Integer;          // Code for Val

  CntItem          : Integer;          // Loop all TransDetails
  IdtSafeTransFnd  : Integer;          // IdtSafeTransaction to found
  NumSeqSafeTransFnd    : Integer;     // NumSeq to found in SafeTransaction
begin  // of TFrmVSRptTndGlobalCountCA.BuildLineVAT
  ValTrans := 0;
  ValTransVAT := 0.0;
  PctVAT := 0.0;
  for CntItem := 0 to Pred (LstSafeTransaction.LstTransDetail.Count) do begin
    ObjTransDetail := LstSafeTransaction.LstTransDetail.TransDetail[CntItem];
    if ObjTransDetail.IdtTenderGroup = ObjTenderGroup.IdtTenderGroup then begin
      IdtSafeTransFnd := ObjTransDetail.IdtSafeTransaction;
      NumSeqSafeTransFnd := ObjTransDetail.NumSeq;

      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttDrawerCashdesk) then begin
        ValTrans := ValTrans +
                    (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit);
        SplitString (ObjTransDetail.TxtDescr, #9, TxtLeft, TxtPctVAT);
        if Trim (TxtPctVAT) > '' then begin
          Val (TxtPctVAT, PctVAT, NumCode);
          PctVat := PctVat /100;
        end
        else
          PctVAT := 0;
      end;
      ValTransVAT := ValTransVAT +
                  (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit) -
                  (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit/(1+ PctVAT));
    end;
  end;

  FlgHasData := ValTrans <> 0;
  TxtLine := ObjTenderGroup.TxtPublDescr +
             SepCol + FormatValue (ValTrans) +
             SepCol + FormatValue (ValTransVAT) +
             SepCol + FormatValue (ValTrans - ValTransVAT);
end;   // of TFrmVSRptTndGlobalCountCA.BuildLineVAT

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.BuildLineGroupTotal
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean);
var
  ObjTransDetail   : TObjTransDetail;  // Found TransDetail
  CntItem          : Integer;          // Loop all TransDetails
  IdtSafeTransFnd  : Integer;          // IdtSafeTransaction to found
  NumSeqSafeTransFnd    : Integer;     // NumSeq to found in SafeTransaction

  QtyRetPayIn      : Integer;          // Total Quantity TenderGroup Ret PayIn
  ValRetPayIn      : Currency;         // Total Amount TenderGroup Ret PayIn

  // Specifiek for counting payin results.
  QtyPayOutTender  : Integer;           // Total Quantity TenderGroup Tender
  ValPayOutTender  : Currency;          // Total Amount TenderGroup Tender
  QtyPayOutCashDesk: Integer;           // Total Quantity TenderGroup CashDesk
  ValPayOutCashDesk: Currency;          // Total Amount TenderGroup CashDesk
  QtyPayOut        : Integer;           // Total Quantity TenderGroup PayOut
  ValPayOut        : Currency;          // Total Amount TenderGroup PayOut
begin  // of TFrmVSRptTndGlobalCountCA.BuildLineGroupTotal
  FlgHasData := False;
  TxtLine    := ObjTenderGroup.TxtPublDescr;

  QtyRetPayIn := 0;
  ValRetPayIn := 0;
  QtyPayOut := 0;
  ValPayOut := 0;

  for CntItem := 0 to Pred (LstSafeTransaction.LstTransDetail.Count) do begin
    ObjTransDetail := LstSafeTransaction.LstTransDetail.TransDetail[CntItem];
    QtyPayOutTender := 0;
    ValPayOutTender := 0;
    QtyPayOutCashDesk := 0;
    ValPayOutCashDesk := 0;

    if ObjTransDetail.IdtTenderGroup = ObjTenderGroup.IdtTenderGroup then begin
      IdtSafeTransFnd := ObjTransDetail.IdtSafeTransaction;
      NumSeqSafeTransFnd := ObjTransDetail.NumSeq;

      // Return of PayIn
      if FndIdtSafeTransAndNumSeq
          (IdtSafeTransFnd, NumSeqSafeTransFnd,
           CtCodSttPayOutTender, CtCodStrReturnPayin) then begin
        QtyRetPayIn := QtyRetPayIn + ObjTransDetail.QtyUnit;
        ValRetPayIn := ValRetPayIn +
                       ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      end;

      // Calculate total PayOut
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttPayOutTender) then begin
        QtyPayOutTender := ObjTransDetail.QtyUnit;
        ValPayOutTender := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      end;

      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttFinalCount) then begin
        QtyPayOutCashDesk := ObjTransDetail.QtyUnit;
        ValPayOutCashDesk := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
      end;
      QtyPayOut := QtyPayOut + QtyPayOutTender + QtyPayOutCashDesk;
      ValPayOut := ValPayOut + ValPayOutTender + ValPayOutCashDesk;
    end;
  end;

  TxtLine := TxtLine + SepCol + FormatValue (QtyPayOut - QtyRetPayIn) + SepCol +
             FormatValue (ValPayOut - ValRetPayIn);
  FlgHasData := ValPayOut - ValRetPayIn > 0;
end;   // of TFrmVSRptTndGlobalCountCA.BuildLineGroupTotal

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.BuildLineBag (    TxtExplanation : string;
                                                  var TxtLine        : string;
                                                  var FlgHasData     : Boolean);
begin  // of TFrmVSRptTndGlobalCountCA.BuildLineBag
  FlgHasData := False;
end;   // of TFrmVSRptTndGlobalCountCA.BuildLineBag

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.BuildLineInformative
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean        );
var
  QtyArt           : Integer;          // Total QtyArticle TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
  ObjTransDetail   : TObjTransDetail;       // Found TransDetail

  CntItem          : Integer;          // Loop all SafeTransDetails
  IdtSafeTransFnd  : Integer;          // IdtSafeTransaction to found
  NumSeqSafeTransFnd    : Integer;     // NumSeq to found in SafeTransaction
begin  // of TFrmVSRptTndGlobalCountCA.BuildLineInformative
  QtyArt      := 0;
  ValTrans    := 0;

  for CntItem := 0 to Pred (LstSafeTransaction.LstTransDetail.Count) do begin
    ObjTransDetail := LstSafeTransaction.LstTransDetail.TransDetail[CntItem];
    if ObjTransDetail.IdtTenderGroup = ObjTenderGroup.IdtTenderGroup then begin
      IdtSafeTransFnd := ObjTransDetail.IdtSafeTransaction;
      NumSeqSafeTransFnd := ObjTransDetail.NumSeq;

      // Retrieve total drawer
      if FndIdtSafeTransAndNumSeq (IdtSafeTransFnd, NumSeqSafeTransFnd,
                                   CtCodSttDrawerCashdesk) then begin
        QtyArt   := QtyArt + ObjTransDetail.QtyArticle;
        ValTrans := ValTrans +
                    (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit);
      end;
    end;
  end;

  FlgHasData := (QtyArt <> 0) or (ValTrans <> 0);
  TxtLine := ObjTenderGroup.TxtPublDescr +
             SepCol + FormatQuantity (QtyArt) +
             SepCol + FormatValue (ValTrans);
end;   // of TFrmVSRptTndGlobalCountCA.BuildLineInformative

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.BuildTableSummaryCurrFmtAndHdr;
begin  // of TFrmVSRptTndGlobalCountCA.BuildTableSummaryCurrFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtHdrSummaryCurr;

  if (CodRunFunc = CtCodFuncCount) or
     (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    AppendFmtAndHdrAmount (CtTxtHdrTotalTheor);

  AppendFmtAndHdrAmount (CtTxtHdrTotalCount);

  if (CodRunFunc = CtCodFuncCount) or
     (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    AppendFmtAndHdrAmount (CtTxtHdrDifference);

  (** KRG -> CurrentSafeTransaction moet vervangen worden!!! ** )
  // Column for count-result in currency of SafeTransaction
  AppendFmtAndHdrAmount (CtTxtHdrTotalCount + ' ' +
                         CurrentSafeTransaction.IdtCurrency);
  (** KRG **)
end;   // of TFrmVSRptTndGlobalCountCA.BuildTableSummaryCurrFmtAndHdr

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.GenerateReport;
begin  // of TFrmVSRptTndGlobalCountCA.GenerateReport
  Visible := True;
  Visible := False;

  InitializeBeforeGenerateReport;
  ValTotalTheorPrint := 0;
  SetLength (ArrPages, 1);
  ArrPages [Length (ArrPages) - 1] := 1;

  VspPreview.StartDoc;
  try
    if Canvas.TextWidth(TxtNameRegFor) > 565 then
      VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    if IdtDepartment <> -1 then
      VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
    GenerateTableCount;
    if CodRunFunc = CtCodFuncCount then begin
      GenerateTableNotCount;
      GenerateTableTheor;
      GenerateTableVAT;
      GenerateTableGroupTotal;
      if FlgSavCard then
        GenerateTableSavingCard;
      GenerateTableInformative;
    end;
    GenerateTableSummaryCurr;
    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
  finally
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
  PrintRef;
  if ViFlgAutom then begin
     ActPrintAllExecute(Self);
     Application.Terminate;
  end;
end;   // of TFrmVSRptTndGlobalCountCA.GenerateReport

//=============================================================================

procedure TFrmVSRptTndGlobalCountCA.FormCreate(Sender: TObject);
begin  // of TFrmVSRptTndGlobalCountCA.FormCreate
  inherited;
  RefNum := '0002';
end;   // of TFrmVSRptTndGlobalCountCA.FormCreate

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FVSRptTndGlobalCountCA
