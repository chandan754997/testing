//=====Copyright 2009 (c) Centric Retail Solutions. All rights reserved.=======
// Packet   : FlexPoint
// Unit     : FVSRptTndCountCA = Form VideoSoft RePorT TeNDer COUNT CAstorama
// Customer :  Castorama
//-----------------------------------------------------------------------------
// CVS      : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndCountCA.pas,v 1.19 2010/07/09 09:24:28 BEL\DVanpouc Exp $
// History  :
// - Started from Castorama - FlexPoint 2.0 - PRptGlobalCount - CVS revision 1.22
//=============================================================================

unit FVSRptTndCountOprCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FVSRptTndCount, ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ToolWin, DFpnSafeTransaction, DFpnTenderGroup,
  DFpnTenderGroupCA, ExtCtrls;

//=============================================================================
// Global definitions
//=============================================================================

var    // Widths of columns in StringGrid
  ViValRptWidthVAT : Integer =  8;    // Width of column for VAT Codes
  ViValRptWidthBag : Integer = 15;    // Width of column for bag number

//-----------------------------------------------------------------------------

const  // for giving the dimentions of the rectangle.
  CtValConclRecHeight   = 1000;
  CtValConclRecWidth    = 2000;

const  // Prefix for reference report
  CtTxtRep              = 'REP';

const // Start Position of count table
  CtStartPosCountTable  = 3100;  

//-----------------------------------------------------------------------------

resourcestring     // for printing the header of the final count.
  CtTxtHdrFinStateOper  = 'Financial report of the operator';
  CtTxtHdrReprint       = 'Financial report of the operator (Final count)';
  CtTxtHdrNbOperator    = 'Operator Number';
  CtTxtHdrNameOperator  = 'Cashdesk Rapport of';
  CtTxtHdrDat           = 'End Date transaction';
  CtTxtHdrDatBeginTrans = 'Begin Date transaction:';
  CtTxtHdrDatFirstTrans = 'Date first ticket';
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
  CtTxtTheorTotal   = 'Total Theoretical';
  CtTxtRemiseAuto   = 'Remise auto promopack';

resourcestring // Headers of the bag seal part
  CtTxtHdrBagSeal   = 'Sealbag';
  CtTxtHdrSeal      = 'Seal';

resourcestring // For validation
  CtTxtHdrValid     = 'Validations done in transaction:';

resourcestring // For body
  CtTxtVersementAcompte = 'Versement Acompte';
  CtTxtCarteCadeaux     = 'Nombre et montant des cartes cadeaux activiées';
  CtTxtCaution          = 'Caution';
  CtTxtTotal            = 'Total';

  CtTxtSavingCard       = 'Saving Card';
  CtTxtAddingBank       = 'Adding Bank Function';
  CtTxtWithdrawBank     = 'Reducing Bank Function';
  CtTxtDifference       = 'Difference Total';

const  // IdtTenderGroups
  CtCaution                  = 24;         // TenderGroup: Caution
  CtRemiseAuto               = 42;         // TenderGroup: Remise auto
  CtCarteCadeaux             = 47;         // Carte Cadeaux Activée
  CtCodCarteCadeaux          = 161;        // Carte Cadeaux Activée
  CtCodActPayAdvance         = 137;        // Pay the advance
  CtCodActChangeAdvance      = 138;        // Change the advance
  CtCodActTakeBackAdvance    = 139;        // Return the advance
  CtCodActPayForfait         = 142;        // Pay forfait
  CtCodActChargeSavingCard   = 152;        // Charge saving card
  CtCodActWithdrawSavingCard = 153;        // Withdraw funds from saving card

  CtCodPdtAdmin              = 101;        // Min.code Administrative

//*****************************************************************************
// TFrmVSRptTndCount
//*****************************************************************************

type
  TFrmVSRptTndCountCA = class(TFrmVSRptTndCount)
    procedure FormCreate(Sender: TObject);
  private
    FFlgSavCard : Boolean;
    FFlgAutoRem : Boolean;
  protected
    TxtStartDate        : string;      // Date of count
    TxtEndDate          : string;      // Date of count
    IdtOperator         : string;      // operator
    ValTotalTransfert   : Currency;    // Total Transfert
    DatBeginTrans       : TDateTime;   // Begin date of the count transaction
    FRefNum             : string;
    FTxtDate            : string;      // Date
    FFlgCount           : boolean;     // Count
                                                                      
    // Internal used datafields for current Table on report
    ValTotalReturnPayIn : Currency;    // Total Return PayIn
    ValTotalTheorPrint  : Currency;    // Total Theoretic for print
    ValTotalRemiseAuto  : Currency;    // Total Remise auto for print
    ArrPages            : array of Integer; // Array of pages to restart counting

    ValTotalAdding      : double;           // total
    ValTotalReducing    : double;

    function GetRefNum : string; virtual;
    function GetNumEndBaseRapport : Integer; virtual;
    function GetDatBeginTrans :  TDateTime; virtual;
    function GetDatFirstTrans :  TDateTime; virtual;
    function Counted          :  Boolean; virtual;
    function GetTransfers(IdtOperator :  string;
                          IdtTenderGroup : integer) : double;

    procedure PrintPageHeader; override;
    procedure PrintAddress; override;
    procedure PrintConclusion; override;
    procedure InitializeBeforeStartTable; override;

    procedure AppendFmtAndHdrBagNumber (TxtHdr : string); virtual;
    // Universal Methods

    // Table Cash and Countable
    procedure BuildTableCountFmtAndHdr; override;
    procedure BuildLineCount (    ObjTenderGroup : TObjTenderGroup;
                              var TxtLine        : string;
                              var FlgHasData     : Boolean        ); override;
    procedure BuildLineNotCount (    ObjTenderGroup : TObjTenderGroup;
                                 var TxtLine        : string;
                                 var FlgHasData     : Boolean       ); override;
    procedure GenerateTableCountBody; override;
    procedure GenerateTableCountTotal; override;
    procedure AddFooterToPages; override;

    // Table Not countable
    procedure GenerateTableNotCountBody; override;
    procedure PrintLineNotCount (ObjTenderGroup: TObjTenderGroup); override;

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
    procedure BuildLineTheor (var TxtLine    : string;
                              var FlgHasData : Boolean); virtual;
    procedure PrintLineTheor; virtual;
    procedure GenerateTableTheorBody; virtual;
    procedure GenerateTableTheorTotal; virtual;
    procedure GenerateTableTheor; virtual;

    // Table cautions and acomptes
    procedure BuildTableCautActFmtAndHdr; virtual;

    // Table Group totals.
    procedure BuildTableGroupTotalFmtAndHdr; virtual;
    procedure BuildLineGroupTotal (    ObjTenderGroup : TObjTenderGroup;
                                   var TxtLine        : string;
                                   var FlgHasData     : Boolean); virtual;
    procedure PrintLineGroupTotal (ObjTenderGroup : TObjTenderGroup); virtual;
    procedure GenerateTableGroupTotalBody; virtual;
    procedure GenerateTableGroupTotalTotal; virtual;
    procedure GenerateTableGroupTotal; virtual;

    //Table saving card
    procedure BuildTableSavingCardFmtAndHdr; virtual;
    procedure GenerateTableSavingCardBody; virtual;
    procedure GenerateTableSavingCardTotal; virtual;
    procedure GenerateTableSavingCard; virtual;

    // Table Bag Seals
    procedure BuildTableBagFmtAndHdr; virtual;
    procedure BuildLineBag (    TxtExplanation : string;
                            var TxtLine        : string;
                            var FlgHasData     : Boolean); virtual;
    procedure PrintLineBag (TxtExplanation : string); virtual;
    procedure GenerateTableBagBody; virtual;
    procedure GenerateTableBagTotal; virtual;
    procedure GenerateTableBag; virtual;

    // Table Informative
    procedure BuildTableInformativeFmtAndHdr; override;
    procedure BuildLineInformative (    ObjTenderGroup : TObjTenderGroup;
                                    var TxtLine        : string;
                                    var FlgHasData     : Boolean); override;
    procedure GenerateTableInformativeBody; override;
    // Table Change
    procedure GenerateTableChangeBody; override;
    // General Table Detail
    procedure GenerateTableDetailBody (ObjTenderGroup: TObjTenderGroup);override;
    procedure BuildLineDetail (    ObjTransDetail : TObjTransDetail;
                               var TxtLine        : string         ); override;
    // General Table with summary of Foreign currencies
    procedure GenerateTableSummaryCurrBody; override;
    procedure PrintValidation; virtual;
    procedure PrintRef; virtual;
    procedure PrintBagReports; virtual;
  public
    FlgReprint   : boolean;  // specify end date
    property NumEndBaseRapport : Integer read GetNumEndBaseRapport;
    property RefNum : string read GetRefNum
                             write FRefNum;
    procedure GenerateReport; override;

    // Select start- and enddate for acomptes
    procedure SelectDateRange(IdtOperator: string); virtual;

    // Select data for 'Acomptes'
    function BuildStatement : string; virtual;
    function BuildCarteCadeaux : string; virtual;
    function BuildStatementSavingCard : string; virtual;

    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;

  published
    property TxtDate : string read FTxtDate
                              write FTxtDate;
    property FlgCount : boolean read FFlgCount
                              write FFlgCount;
    property FlgSavCard: Boolean read FFlgSavCard write FFlgSavCard;
    property FlgAutoRem: Boolean read FFlgAutoRem write FFlgAutoRem;
  end; // of TFrmVSRptTndCountCA

var
  FrmVSRptTndCountCA: TFrmVSRptTndCountCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  StStrW,
  SmUtils,
  DFpnUtils,
  SmDBUtil_BDE,

  SfDialog,
  DFpnTender,
  DFpnTenderCA,
  DFpnSafeTransactionOprCA,

  RFpnTender,
  RFpnCom,
  DFpnBagCA,
  Variants;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptTndCountCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndCountCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.19 $';
  CtTxtSrcDate    = '$Date: 2010/07/09 09:24:28 $';

//*****************************************************************************
// Implementation of TFrmVSRptTndCountCA
//*****************************************************************************

function TFrmVSRptTndCountCA.GetRefNum : string;
begin  // of TFrmVSRptTndCountCA.GetRefNum
  Result := CtTxtRep + FRefNum;
end;   // of TFrmVSRptTndCountCA.GetRefNum

//=============================================================================

function TFrmVSRptTndCountCA.GetNumEndBaseRapport : Integer;
begin  // of TFrmVSRptTndCountCA.GetNumEndBaseRapport
  Result := ArrPages [1] - 1;
end;   // of TFrmVSRptTndCountCA.GetNumEndBaseRapport

//=============================================================================

function TFrmVSRptTndCountCA.GetDatBeginTrans : TDateTime;
var
  IdtOper  : string;
begin  // of TFrmVSRptTndCountCA.GetDatBeginTrans
  try
    if DmdFpnUtils.QueryInfo ('SELECT IdtOperator FROM Operator' +
          #10'WHERE IdtPOS = ' + AnsiQuotedStr(IdtRegFor, '''')) then
      IdtOper := DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString;
      DmdFpnUtils.CloseInfo;
      if DmdFpnUtils.QueryInfo ('SELECT DatReg = MAX(DatReg)' +
                             #10'From SafeTransaction' +
                             #10'WHERE IdtOperator = ' +
                               AnsiQuotedStr(IdtOper, '''') +
                             #10'AND CodType = ' +
                               AnsiQuotedStr(IntToStr(CtCodSttFinalCount), '''') +
                             #10'AND DatReg < ' + AnsiQuotedStr (FormatDateTime(
                                'yyymmdd hh:mm:ss',
                                 CurrentSafeTransaction.DatReg), '''')) then
        Result := DmdFpnUtils.QryInfo.FieldByName ('DatReg').AsDateTime
      else
        Result := Now;
    DatBeginTrans := Result;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptTndCountCA.GetDatBeginTrans

//=============================================================================

function TFrmVSRptTndCountCA.GetDatFirstTrans : TDateTime;
begin  // of TFrmVSRptTndCountCA.GetDatFirstTrans
  try
    if DmdFpnUtils.QueryInfo ('SELECT DatTransBegin = MIN(DatCreate)' +
                           #10'FROM POSTransaction' +
                           #10'WHERE IdtOperator = ' +
                               AnsiQuotedStr(IntToStr(StrToInt(IdtRegFor)), '''') +
                           #10'AND DatCreate > ' + AnsiQuotedStr(FormatDateTime(
                              'yyymmdd hh:mm:ss', DatBeginTrans), '''')) then
      Result := DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime
    else
      Result := Now;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptTndCountCA.GetDatFirstTrans

//=============================================================================

function TFrmVSRptTndCountCA.GetTransfers(IdtOperator    : string;
                                          IdtTenderGroup : Integer) : Double;
begin  // of TFrmVSRptTndCountCA.GetTransfers
  Result := 0;
  try
    if DmdFpnUtils.QueryInfo ('SELECT ValAmount = (QtyUnit * ValUnit)' +
                           #10'FROM SafeTransdetail STD' +
                           #10'INNER JOIN SafeTransaction' +
                           #10'ON SafeTransaction.IdtSafeTransaction = ' +
                              'STD.IdtSafeTransaction' +
                           #10'AND SafeTransaction.NumSeq = STD.NumSeq' +
                           #10'AND SafeTransaction.CodType IN (801, 911, 921)' +
                           #10'WHERE STD.IdtTenderGroup = ' +
                               IntToStr(IdtTenderGroup) +
                           #10'AND SafeTransaction.IdtOperator = ' +
                                          AnsiQuotedStr(IdtOperator, '''') +
                           #10'AND STD.DatCreate > ' +
                           #10'          (SELECT ISNULL (MAX (DatReg),0)' +
                           #10'           FROM SafeTransaction STA' +
                           #10'           WHERE STA.CodType = ' +
                                          IntToStr(CtCodSttFinalCount) +
                           #10'           AND STA.IdtOperator = ' +
                                          AnsiQuotedStr(IdtOperator, '''') + ')')
    then
      Result := DmdFpnUtils.QryInfo.FieldByName ('ValAmount').AsFloat;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptTndCountCA.GetTransfers

//=============================================================================

function TFrmVSRptTndCountCA.Counted : Boolean;
var
  IdtOper  : string;
begin  // of TFrmVSRptTndCountCA.Counted
  Result := False;
  try
    if DmdFpnUtils.QueryInfo ('SELECT IdtOperator FROM Operator' +
                           #10'WHERE IdtPOS = ' + AnsiQuotedStr(IdtRegFor, ''''))
    then
      IdtOper := DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString;
    DmdFpnUtils.CloseInfo;
    if DmdFpnUtils.QueryInfo ('SELECT *' +
                           #10'From SafeTransaction' +
                           #10'WHERE IdtOperator = ' +
                               AnsiQuotedStr(IdtOper, '''') +
                           #10'AND CodType = ' +
                               AnsiQuotedStr(IntToStr(CtCodSttFinalCount), '''') +
                           #10'AND IdtSafeTransaction = ' + AnsiQuotedStr(
                               IntToStr(CurrentSafeTransaction.
                               IdtSafeTransaction), '''')) then begin
        if DmdFpnUtils.QryInfo.RecordCount > 0 then
          Result := True
        else
          Result := False;
    end; // of if DmdFpnUtils.QueryInfo
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptTndCountCA.Counted

//=============================================================================

procedure TFrmVSRptTndCountCA.PrintPageHeader;
var
  TxtKind          : string;           // Kind of functions
  DatToPrint       : TDateTime;        // Date to print
begin  // of TFrmVSRptTndCountCA.PrintPageHeader
  // This header is only applied to the final count.
  VspPreview.FontBold := True;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.CurrentY := ValOrigMarginTop;
  case CodRunFunc of
    CtCodFuncChange : TxtKind := CtTxtChangeMoney;
    CtCodFuncPayIn  : TxtKind := CtTxtPayIn;
    CtCodFuncPayOut : TxtKind := CtTxtPayOut;
    CtCodFuncRetPayIn : TxtKind := CtTxtReturnPayIn;
    CtCodFuncCount  : TxtKind := CtTxtFinalCount;
  end;
  if (CodRunFunc = CtCodFuncCount) and FlgReprint then
    VspPreview.Text := CtTxtHdrReprint
  else
    VspPreview.Text := CtTxtHdrFinStateOper + ' ('+ TxtKind + ')';
  VspPreview.FontBold := False;

  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.Text := CtTxtHdrNbOperator + ' ' + IdtRegFor;

  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.Text := CtTxtHdrNameOperator + ' ' + TxtNameRegFor;

  if FlgCount or FlgReprint then begin
    VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
    VspPreview.CurrentX := VspPreview.Marginleft;
    DatToPrint := GetDatBeginTrans;
    if DatToPrint = 0 then
      VspPreview.Text := CtTxtHdrDatBeginTrans + ' -'
    else
      VspPreview.Text := CtTxtHdrDatBeginTrans + ' ' +
                         DateTimeToStr (DatToPrint);

    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    VspPreview.CurrentX := VspPreview.Marginleft;
    if Counted then begin
      VspPreview.Text := CtTxtHdrDat + ' : ' +
                         DateTimeToStr (CurrentSafeTransaction.DatReg);
      VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
      VspPreview.CurrentX := VspPreview.Marginleft;
    end;
    DatToPrint := GetDatFirstTrans;
    if DatToPrint = 0 then
      VspPreview.Text := CtTxtHdrDatFirstTrans + ' -'
    else
      VspPreview.Text := CtTxtHdrDatFirstTrans + ' : ' +
                         DateTimeToStr (DatToPrint);
  end
  else begin
    VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.Text := CtTxtHdrDat + ' : ' +
                       DateTimeToStr (CurrentSafeTransaction.DatReg);
  end;

  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
end;   // of TFrmVSRptTndCountCA.PrintPageHeader

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
  ValTotalTransfert   := 0;
end;   // of TFrmVSRptTndCountCA.InitializeBeforeStartTable

//=============================================================================
// TFrmVSRptTndCountCA.AppendFmtAndHdrBagNumber : appends the format and header
// for a bag number-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptTndCountCA.AppendFmtAndHdrBagNumber (TxtHdr : string);
begin  // of TFrmVSRptTndCountCA.AppendFmtAndHdrBagNumber
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthBag))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptTndCountCA.AppendFmtAndHdrBagNumber

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
    Exit;
  end;

  FlgHasData := False;
  TxtLine    := ObjTenderGroup.TxtPublDescr;
  ValTheor   := 0;

  // Retrieve total drawer
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForType
                                             (IdtSafeTransaction,
                                              CtCodSttDrawerCashdesk,
                                              ObjTenderGroup.IdtTenderGroup,
                                              False, QtyTrans, ValTrans); //JVL
  ValTheor := ValTheor + ValTrans;
  ValTotalDrawer := ValTotalDrawer + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);

  // Calculate total PayIn = Change Money + PayIn
  // Definite 'Total PayIN' = 'Startvalue' - 'Change for next' +
  //                          'PayIn in Tender' + 'PayIn in Cashdesk'
  ValPrint := 0;
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForType
                                             (IdtSafeTransaction,
                                              CtCodSttChangeOnStart,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans;
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForType
                                             (IdtSafeTransaction,
                                              CtCodSttChangeForNext,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint - ValTrans;
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForType
                                             (IdtSafeTransaction,
                                              CtCodSttPayInTender,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans;
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForType
                                             (IdtSafeTransaction,
                                              CtCodSttPayInCashdesk,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans;
  ValTheor := ValTheor + ValPrint;
  ValTotalPayIn := ValTotalPayIn + ValPrint;
  FlgHasData := FlgHasData or (ValPrint <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValPrint);

  // Transfer'
  ValPrint := 0;
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForType
                                             (IdtSafeTransaction,
                                              CtCodSttPayInTransfer,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans;
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForType
                                             (IdtSafeTransaction,
                                              CtCodSttPayOutTransfer,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint - ValTrans;
  FlgHasData := FlgHasData or (ValPrint <> 0);
  ValTheor := ValTheor + ValPrint;
  ValTotalTransfert := ValTotalTransfert + ValPrint;
  TxtLine := TxtLine + SepCol + FormatValue (ValPrint);

  // Return of PayIn
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForReason
                                               (IdtSafeTransaction,
                                                CtCodSttPayOutTender,
                                                CtCodStrReturnPayin,
                                                ObjTenderGroup.IdtTenderGroup,
                                                True, QtyTrans, ValTrans);
  ValReturnPayIn := ValTrans;
  ValTotalReturnPayIn := ValTotalReturnPayIn + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);
  ValTheor := ValTheor - ValReturnPayIn;

  // Calculate total PayOut
  ValPrint := 0;
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForType
                                             (IdtSafeTransaction,
                                              CtCodSttPayOutTender,
                                              ObjTenderGroup.IdtTenderGroup,
                                              True, QtyTrans, ValTrans);
  ValPrint := ValPrint + ValTrans - ValReturnPayIn;
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForType
                                             (IdtSafeTransaction,
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
  ValTrans := 0;
  // Retrieve total count
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetail
                                      (IdtSafeTransaction,
                                       NumSeqSafeTrans,
                                       ObjTenderGroup.IdtTenderGroup,
                                       True, QtyTrans, ValTrans);
  ValTotalCount := ValTotalCount + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);

  if (CodRunFunc = CtCodFuncCount) or
     (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then begin
    // Append difference
    ValTheor := DmdFpnUtils.RoundCurrency('', ValTheor, 2);
    ValTrans := DmdFpnUtils.RoundCurrency('', ValTrans, 2);
    TxtLine := TxtLine + SepCol + FormatValue (ValTheor - ValTrans);
  end;
end;   // of TFrmVSRptTndCountCA.BuildLineCount

//=============================================================================

procedure TFrmVSRptTndCountCA.BuildLineNotCount
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean        );
var
  QtyTrans         : Integer;          // Total Quantity TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
begin  // of TFrmVSRptTndCountCA.BuildLineNotCount
  FlgHasData := False;
  TxtLine    := ObjTenderGroup.TxtPublDescr;

  LstSafeTransaction.TotalTransDetailTheoreticForCount
    (IdtSafeTransaction, ObjTenderGroup.IdtTenderGroup,
     False, QtyTrans, ValTrans);
  if ObjTenderGroup.IdtTenderGroup = CtRemiseAuto then
    ValTotalRemiseAuto := ValTotalRemiseAuto + ValTrans
  else
    ValTotalTheor := ValTotalTheor + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);
end;   // of TFrmVSRptTndCountCA.BuildLineNotCount

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableCountBody;
begin  // of TFrmVSRptTndCountCA.GenerateTableCountBody
  inherited;
  VspPreview.TableCell
      [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
  VspPreview.TableCell
      [tcAlign, 0, 2, 0,
       VspPreview.TableCell [tcCols, 0, 0, 0, 0]] := taCenterMiddle;
end;   // of TFrmVSRptTndCountCA.GenerateTableCountBody

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableCountTotal;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptTndCountCA.GenerateTableCountTotal
  if CodRunFunc <> CtCodFuncCount then begin
    inherited;
    Exit;
  end;

  TxtLine := CtTxtTotal +
             SepCol + FormatValue (ValTotalDrawer) +
             SepCol + FormatValue (ValTotalPayIn) +
             SepCol + FormatValue (ValTotalTransfert) +
             SepCol + FormatValue (ValTotalReturnPayIn) +
             SepCol + FormatValue (ValTotalPayOut) +
             SepCol + FormatValue (ValTotalCount) +
             SepCol + FormatValue (ValTotalTheor - ValTotalCount);
(** KRG ** )
              - ValTotalReturnPayIn);
(** KRG **)

  PrintTableLine (TxtLine);
  ConfigTableTotal;
  ValTotalTheorPrint := ValTotalTheorPrint + ValTotalDrawer;
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
  NumPage  := 0;
  TotPage  := 0;
  CntArray := 0;
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
      VspPreview.Text := CtTxtPrintDate + ' ' + DateToStr (Now);
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
// TFrmVSRptTndCountCA.PrintLineNotCount : generates the body-line of the table
// with the not countable results for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to generate the line for.
//=============================================================================

procedure TFrmVSRptTndCountCA.PrintLineNotCount (ObjTenderGroup: TObjTenderGroup);
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptTndCountCA.PrintLineNotCount
  BuildLineNotCount (ObjTenderGroup, TxtLine, FlgHasData);

  if FlgHasData or FlgPrintNullLine then begin
    if ObjTenderGroup.IdtTenderGroup <> CtRemiseAuto then
      PrintTableLine (TxtLine);
    if FlgExportToFile then
      AppendToMemStmExport (21, TxtLine, ObjTenderGroup.IdtTenderGroup);
  end;
end;   // of TFrmVSRptTndCountCA.PrintLineNotCount

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableNotCountBody;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup
begin  // of TFrmVSRptTndCountCA.GenerateTableNotCountBody
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    if (LstTenderGroup.TenderGroup[CntTenderGroup].CodType =
        CtCodTgtNotCountable) then
      PrintLineNotCount (LstTenderGroup.TenderGroup[CntTenderGroup]);
  end;
  VspPreview.TableCell [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
  VspPreview.TableCell
      [tcAlign, 0, 2, 0,
       VspPreview.TableCell [tcCols, 0, 0, 0, 0]] := taCenterMiddle;

  ValTotalTheorPrint := ValTotalTheorPrint + ValTotalTheor;
end;   // of TFrmVSRptTndCountCA.GenerateTableNotCountBody

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
  ValTransNET      : Currency;         // Total Amount of VAT
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
  ValTransNET := 0.0;

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
        ValTransNET := (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit) /
                       (1 + (PctVAT / 100));
      end;
    end;
  until not Assigned (ObjSafeTrans);

  FlgHasData := ValTrans <> 0;
  TxtLine := ObjTenderGroup.TxtPublDescr +
             SepCol + FormatValue (ValTrans) +
             SepCol + FormatValue (ValTrans - ValTransNET) +
             SepCol + FormatValue (ValTransNET);

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

  VspPreview.TableCell [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
  VspPreview.TableCell
      [tcAlign, 0, 2, 0,
       VspPreview.TableCell [tcCols, 0, 0, 0, 0]] := taCenterMiddle;

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
  FlgHasData := ValTotalTheorPrint <> 0;
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
 if FlgAutoRem then
   PrintTableLine(CtTxtRemiseAuto + SepCol + FormatValue(ValTotalRemiseAuto));
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
// TFrmVSRptTndCountCA.BuildTableCautActFmtAndHdr : builds the Format and Header
// for the table with Caution and Versement acompte.
//=============================================================================

procedure TFrmVSRptTndCountCA.BuildTableCautActFmtAndHdr;
begin  // of TFrmVSRptTndCountCA.BuildTableCautActFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  AppendFmtAndHdrQuantity ('');
  AppendFmtAndHdrAmount ('');
  TxtTableHdr := '';
end;   // of TFrmVSRptTndCountCA.BuildTableCautActFmtAndHdr

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
  TLstSafeTransactionCA(LstSafeTransaction).TotalTransDetailForReason
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
  TxtLine          : string;           // Line to print
  NumCounter       : Integer;          // counter to loop
  LstOperators     : string;           // List with operetors
  QtyNumber        : Integer;          // number of acomptes
  ValTotal         : Double;           // total of acomptes
begin  // of TFrmVSRptTndCountCA.GenerateTableGroupTotalBody
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    if ((LstTenderGroup.TenderGroup[CntTenderGroup].CodType = CtCodTgtCash) or
       (LstTenderGroup.TenderGroup[CntTenderGroup].CodType = CtCodTgtCountable))
       and
       LstTenderGroup.TenderGroup[CntTenderGroup].FlgDetailPrint then
      PrintLineGroupTotal (LstTenderGroup.TenderGroup[CntTenderGroup]);
  end; // of CntTenderGroup := 0 to Pred (LstTenderGroup.Count)
  VspPreview.TableCell [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
  VspPreview.TableCell [tcAlign, 0, 2, 0, VspPreview.TableCell
                       [tcCols, 0, 0, 0, 0]] := taCenterMiddle;
  VspPreview.EndTable;
  VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  BuildTableCautActFmtAndHdr;
  VspPreview.StartTable;
  PrintTableLine (TxtLine);
  TxtLine := '';
  // Versement Acomptes
  DmdFpnUtils.CloseInfo;
  if IdtRegFor = '' then
    TxtLine := CtTxtVersementAcompte + SepCol + '-' + SepCol + '-'
  else begin
    if FlgCount or FlgReprint then begin
      SelectDateRange(IdtRegFor);
      if TxtStartDate = '' then
        TxtLine := CtTxtVersementAcompte + SepCol + '-' + SepCol + '-'
      else begin
        if DmdFpnUtils.QueryInfo (BuildStatement) then begin
          if Trim(DmdFpnUtils.QryInfo.FieldByName ('Number').AsString) = '0' then
            TxtLine := CtTxtVersementAcompte + SepCol + '-' + SepCol + '-'
          else
            TxtLine := CtTxtVersementAcompte +
                 SepCol + DmdFpnUtils.QryInfo.FieldByName ('Number').AsString +
                 SepCol + DmdFpnUtils.QryInfo.FieldByName ('Total').AsString;
        end // of if DmdFpnUtils.QueryInfo (BuildStatement)
        else
          TxtLine := CtTxtVersementAcompte + SepCol + '-' + SepCol + '-';
      end // of else begin
    end // of if FlgCount or FlgReprint
    else begin
      QtyNumber    := 0;
      ValTotal     := 0;
      LstOperators := IdtRegFor;
      NumCounter   := AnsiPos (',', LstOperators);
      if NumCounter = 0 then begin
        IdtOperator := Trim(LstOperators);
        SelectDateRange(IdtOperator);
        if TxtStartDate = '' then
          TxtLine := CtTxtVersementAcompte + SepCol + '-' + SepCol + '-'
        else begin
          if DmdFpnUtils.QueryInfo (BuildStatement) then begin
            if Trim(DmdFpnUtils.QryInfo.FieldByName('Number').AsString) = '0' then
              TxtLine := CtTxtVersementAcompte + SepCol + '-' + SepCol + '-'
            else
              TxtLine := CtTxtVersementAcompte + SepCol +
                         DmdFpnUtils.QryInfo.FieldByName ('Number').AsString +
                         SepCol + DmdFpnUtils.QryInfo.FieldByName ('Total').AsString;
          end // of if DmdFpnUtils.QueryInfo (BuildStatement)
          else
            TxtLine := CtTxtVersementAcompte + SepCol + '-' + SepCol + '-';
        end; // of else begin
      end // of if NumCounter = 0
      else begin
        while NumCounter < Length(LstOperators) do begin
          IdtOperator  := Trim(Copy(LstOperators, 1, numCounter-1));
          LstOperators := Trim(Copy(LstOperators, numCounter+1, length(LstOperators)));
          NumCounter   := AnsiPos (',', LstOperators);
          SelectDateRange(IdtOperator);
          if TxtStartDate <> '' then begin
            if DmdFpnUtils.QueryInfo (BuildStatement) then begin
              QtyNumber := QtyNumber +
                           DmdFpnUtils.QryInfo.FieldByName ('Number').AsInteger;
              ValTotal := ValTotal +
                          DmdFpnUtils.QryInfo.FieldByName ('Total').AsFloat;
            end; // of if DmdFpnUtils.QueryInfo (BuildStatement)
          end; // of if TxtStartDate <> '' then begin
          if NumCounter = 0 then begin
            IdtOperator := Trim(LstOperators);
            numCounter  := Length(LstOperators) + 1;
            SelectDateRange(IdtOperator);
            if TxtStartDate <> '' then begin
              if DmdFpnUtils.QueryInfo (BuildStatement) then begin
                QtyNumber := QtyNumber +
                             DmdFpnUtils.QryInfo.FieldByName ('Number').AsInteger;
                ValTotal := ValTotal +
                            DmdFpnUtils.QryInfo.FieldByName ('Total').AsFloat;
              end; // of if DmdFpnUtils.QueryInfo (BuildStatement)
            end; // of if TxtStartDate <> ''
          end; // of if NumCounter = 0
        end; // of while NumCounter < Length(LstOperators)
        if QtyNumber = 0 then
          TxtLine := CtTxtVersementAcompte + SepCol + '-' + SepCol + '-'
        else
          TxtLine := CtTxtVersementAcompte +
                 SepCol + IntToStr(QtyNumber) + SepCol + FloatToStr(ValTotal);
      end; // of else begin
    end; // of else begin
  end; // of else begin
  PrintTableLine (TxtLine);
  // Carte cadeau activée
  TxtLine := '';
  If FlgAutoRem then begin
    If IdtRegFor = '' then
      TxtLine := CtTxtCarteCadeaux + SepCol + '-' + SepCol + '-'
    else begin
      for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
        if (LstTenderGroup.TenderGroup[CntTenderGroup].IdtTenderGroup =
        CtCarteCadeaux) then begin
          SelectDateRange(IdtRegFor);
          if DmdFpnUtils.QueryInfo (BuildCarteCadeaux) then begin
            if (Length(Trim(DmdFpnUtils.QryInfo.FieldByName ('Number').AsString)) = 0)
            or (Length(Trim(DmdFpnUtils.QryInfo.FieldByName ('Total').AsString)) = 0)
            then
              TxtLine := CtTxtCarteCadeaux + SepCol + '-' + SepCol + '-'
            else
              TxtLine := CtTxtCarteCadeaux + SepCol +
                         DmdFpnUtils.QryInfo.FieldByName ('Number').AsString +
                         SepCol + DmdFpnUtils.QryInfo.FieldByName ('Total').AsString;
          end
          else begin
           TxtLine := CtTxtCarteCadeaux + SepCol + '-' + SepCol + '-';
          end;
        end;
      end;
    end;
    PrintTableLine (TxtLine);
  end;
  DmdFpnUtils.CloseInfo;
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
    if QtyLinesPrinted > 1 then
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
  AppendFmtAndHdrBagNumber (CtTxtHdrSeal);
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
begin  // of TFrmVSRptTndCountCA.BuildLineBag
  SplitString (TxtExplanation, ';', TxtIdtTenderGroup, TxtBagNumber);
  IdtTenderGroup := StrToInt (TxtIdtTenderGroup);
  TxtPublDescr := DmdFpnTenderGroupCA.InfoTenderGroup [IdtTenderGroup,
                                                       'TxtPublDescr'];
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

  if TxtLine <> '' then
    PrintTableLine (TxtLine);
end;   // of TFrmVSRptTndCountCA.PrintLineBag

//=============================================================================
// TFrmVSRptTndCount.GenerateTableBagBody : generates the body of the table
// with the bag numbers.
//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableBagBody;
var
  LstBagPrint      : TLstBagCA;        // Bag list
  CntLine          : Integer;          // Line counter
  StrLstBags       : TStringList;      // Bags that are twice in the list
begin  // of TFrmVSRptTndCountCA.GenerateTableBagBody
  FlgPrintNullLine := True;
  LstBagPrint := TLstSafeTransactionCA(LstSafeTransaction).LstBag;

  StrLstBags := TStringList.Create;
  try
    if LstBagPrint.Count > 0 then begin
      for CntLine := 0 to Pred (LstBagPrint.Count) do begin
        if StrLstBags.IndexOf (LstBagPrint.Bag[CntLine].IdtBag) = -1 then begin
          PrintLineBag (
              IntToStr(LstBagPrint.Bag[CntLine].IdtTenderGroup) + ';' +
              LstBagPrint.Bag[CntLine].IdtBag);
          StrLstBags.Add (LstBagPrint.Bag[CntLine].IdtBag);
        end;
      end;
    end;
  finally
    StrLstBags.Free;
  end;

  VspPreview.TableCell [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
  VspPreview.TableCell
      [tcAlign, 0, 2, 0,
       VspPreview.TableCell [tcCols, 0, 0, 0, 0]] := taCenterMiddle;
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

procedure TFrmVSRptTndCountCA.BuildTableInformativeFmtAndHdr;
begin  // of TFrmVSRptTndCountCA.BuildTableInformativeFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtHdrInformative;

  AppendFmtAndHdrQuantity (CtTxtHdrQtyUnit);
  AppendFmtAndHdrAmount (CtTxtHdrValUnit);
end;   // of TFrmVSRptTndCountCA.BuildTableInformativeFmtAndHdr

//=============================================================================

procedure TFrmVSRptTndCountCA.BuildLineInformative
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean);
var
  QtyArt           : Integer;          // Total QtyArticle TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
  NumSafeTrans     : Integer;          // Number found item in SafeTransaction
  NumTransDetail   : Integer;          // Number found item in TransDetail
  ObjSafeTrans     : TObjSafeTransaction;   // Found SafeTransaction
  ObjTransDetail   : TObjTransDetail;       // Found TransDetail
begin  // of TFrmVSRptTndCountCA.BuildLineInformative
  QtyArt      := 0;
  ValTrans    := 0;

  NumSafeTrans := -1;
  repeat
    ObjSafeTrans := LstSafeTransaction.NextSafeTransactionForType
                     (IdtSafeTransaction, CtCodSttDrawerCashdesk, NumSafeTrans);
    if Assigned (ObjSafeTrans) then begin
      NumTransDetail := -1;
      repeat
        ObjTransDetail := LstSafeTransaction.NextTransDetail
                            (IdtSafeTransaction, ObjSafeTrans.NumSeq,
                             ObjTenderGroup.IdtTenderGroup, NumTransDetail);
        if Assigned (ObjTransDetail) then begin
          QtyArt      := QtyArt + ObjTransDetail.QtyArticle;
          ValTrans    := ValTrans +
                         (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit);
        end;
      until not Assigned (ObjTransDetail);
    end;
  until not Assigned (ObjSafeTrans);

  FlgHasData := (QtyArt <> 0) or (ValTrans <> 0);
  TxtLine := ObjTenderGroup.TxtPublDescr +
             SepCol + FormatQuantity (QtyArt) +
             SepCol + FormatValue (ValTrans);
end;   // of TFrmVSRptTndCountCA.BuildLineInformative

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableInformativeBody;
begin  // of TFrmVSRptTndCountCA.GenerateTableInformativeBody
  inherited;

  VspPreview.TableCell [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
  VspPreview.TableCell
      [tcAlign, 0, 2, 0,
       VspPreview.TableCell [tcCols, 0, 0, 0, 0]] := taCenterMiddle;
end;   // of TFrmVSRptTndCountCA.GenerateTableInformativeBody

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableChangeBody;
begin  // of TFrmVSRptTndCountCA.GenerateTableChangeBody
  inherited;
  VspPreview.TableCell [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
  VspPreview.TableCell
      [tcAlign, 0, 2, 0,
       VspPreview.TableCell [tcCols, 0, 0, 0, 0]] := taCenterMiddle;
end;   // of TFrmVSRptTndCountCA.GenerateTableChangeBody

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableDetailBody
                                              (ObjTenderGroup: TObjTenderGroup);
begin  // of TFrmVSRptTndCountCA.GenerateTableDetailBody
  inherited;
  VspPreview.TableCell [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
  VspPreview.TableCell
      [tcAlign, 0, 2, 0,
       VspPreview.TableCell [tcCols, 0, 0, 0, 0]] := taCenterMiddle;
end;   // of TFrmVSRptTndCountCA.GenerateTableDetailBody

//=============================================================================

procedure TFrmVSRptTndCountCA.BuildLineDetail(  ObjTransDetail: TObjTransDetail;
                                              var TxtLine: string);
var
  ValTrans         : Currency;         // Value of current TransDetail
begin  // of TFrmVSRptTndCountCA.BuildLineDetail
  ValTrans := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
  ValTotalCount := ValTotalCount + ValTrans;
  TxtLine := ObjTransDetail.TxtDescr +
             SepCol + FormatQuantity (ObjTransDetail.QtyUnit) +
             SepCol + FormatValue (ObjTransDetail.ValUnit);

  if (CodRunFunc = CtCodFuncCount) or
     (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    // Empty column for theoretic
    TxtLine := TxtLine + SepCol;

  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);

  if (CodRunFunc = CtCodFuncCount) or
     (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    // Empty column for difference
    TxtLine := TxtLine + SepCol;

end;   // of TFrmVSRptTndCountCA.BuildLineDetail

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableSummaryCurrBody;
begin  // of TFrmVSRptTndCountCA.GenerateTableSummaryCurrBody
  inherited;
  VspPreview.TableCell [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
  VspPreview.TableCell
      [tcAlign, 0, 2, 0,
       VspPreview.TableCell [tcCols, 0, 0, 0, 0]] := taCenterMiddle;
end;   // of TFrmVSRptTndCountCA.GenerateTableSummaryCurrBody

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

procedure TFrmVSRptTndCountCA.PrintRef;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSRptTndCountCA.PrintRef
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, True);
      CurrentX := PageWidth - MarginRight - TextWidth [RefNum] - 1;
      CurrentY := PageHeight - MarginBottom + TextHeight ['X'] - 250;
      Text := RefNum;
      EndOverlay;
    end;
  end;
end;   // of TFrmVSRptTndCountCA.PrintRef

//=============================================================================
// TFrmVSRptTndCountCA.PrintBagReports : Prints a new page for each bag
//=============================================================================

procedure TFrmVSRptTndCountCA.PrintBagReports;
begin  // of TFrmVSRptTndCountCA.PrintBagReports
end;   // of TFrmVSRptTndCountCA.PrintBagReports

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateReport;
begin  // of TFrmVSRptTndCountCA.GenerateReport
  Visible := True;
  Visible := False;

  InitializeBeforeGenerateReport;
  ValTotalTheorPrint := 0;
  ValTotalRemiseAuto := 0;
  SetLength (ArrPages, 1);
  ArrPages [Length (ArrPages) - 1] := 1;

  VspPreview.StartDoc;

  try
    VspPreview.CurrentY := CtStartPosCountTable;
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
    GenerateTableBag;
    PrintExplanation;
    PrintValidation;
    PrintConclusion;
    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
    PrintBagReports;
  finally
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
  PrintRef;
  if FlgSaveDocument and (DmdFpnTenderCA.QtySplRptCount > 0) then
    SaveDocument;
end;   // of TFrmVSRptTndCountCA.GenerateReport

//=============================================================================

procedure TFrmVSRptTndCountCA.SelectDateRange(IdtOperator: string);
var
  TxtQuery      : string;      // variable to store the query
begin  // of TFrmVSRptTndCountCA.SelectDateRange
  DmdFpnUtils.CloseInfo;
  If FlgReprint or FlgCount then begin
    TxtEndDate := FormatDateTime (ViTxtDBDatFormat, CurrentSafeTransaction.DatReg)
         + ' ' + FormatDateTime (ViTxtDBHouFormat, CurrentSafeTransaction.DatReg);
    TxtQuery :=
    #10'SELECT TxtStartDate = CONVERT(varchar, Max(DatReg), 112) + ' + ' + ' +
                              AnsiQuotedStr(' ', '''') + ' + ' +
    #10'                      CONVERT(varchar, Max(DatReg), 108)' +
    #10'FROM SafeTransAction' +
    #10'WHERE CodType = ' + AnsiQuotedStr(IntToStr(CtCodSttFinalCount), '''') +
    #10'AND DatReg < ' + AnsiQuotedStr(TxtEndDate, '''') +
    #10'AND IdtOperator IN (' + IdtRegFor + ')';
    if DmdFpnUtils.QueryInfo (TxtQuery) then
      TxtStartDate := DmdFpnUtils.QryInfo.FieldByName ('TxtStartDate').AsString;
    DmdFpnUtils.CloseInfo;
  end
  else begin
    TxtQuery :=
    #10'SELECT TxtEndDate = CONVERT(varchar, Max(DatReg), 112)' + ' + ' +
                            AnsiQuotedStr(' ', '''') + ' + ' +
    #10'                    CONVERT(varchar, Max(DatReg), 108),' +
    #10'       TxtStartDate = (Select CONVERT(varchar, Max(DatReg), 112)' + ' + '
                              + AnsiQuotedStr(' ', '''') + ' + ' +
    #10'                          ' + 'CONVERT(varchar, Max(DatReg), 108)' +
    #10'               FROM SafeTransaction' +
    #10'               WHERE CodType = ' +
                          AnsiQuotedStr(IntToStr(CtCodSttFinalCount), '''') +
    #10'               AND DatReg < ' +
                          AnsiQuotedStr(TxtDate + ' ' +  '00:00:00', '''') +
    #10'	       AND IdtOperator IN (' + IdtOperator + '))' +
    #10'FROM SafeTransAction' +
    #10'WHERE CodType = ' + AnsiQuotedStr(IntToStr(CtCodSttFinalCount), '''') +
    #10'AND DatReg < ' + AnsiQuotedStr(TxtDate + ' ' +  '23:59:59', '''') +
    #10'AND IdtOperator IN (' + IdtOperator + ')' +
    #10'HAVING DATEDIFF(DAY, Max(DatReg), ' + AnsiQuotedStr(TxtDate, '''') + ') = 0';
    if DmdFpnUtils.QueryInfo (TxtQuery) then begin
      TxtStartDate := DmdFpnUtils.QryInfo.FieldByName ('TxtStartDate').AsString;
      TxtEndDate := DmdFpnUtils.QryInfo.FieldByName ('TxtEndDate').AsString;
    end;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmVSRptTndCountCA.SelectDateRange

//=============================================================================

function TFrmVSRptTndCountCA.BuildStatement : string;
begin  // of TFrmVSRptTndCountCA.BuildStatement
  Result :=
  #10'SELECT Count(*) Number,' +
  #10'       SUM(Det1.ValInclVAT) Total' +
  #10'FROM POSTransDetail Det1' +
  #10'  INNER JOIN POSTransaction Act' +
  #10'  ON Det1.IdtPOSTransaction = Act.IdtPOSTransaction' +
  #10'  AND Det1.IdtCheckOut = Act.IdtCheckOut' +
  #10'  AND Det1.CodTrans = Act.CodTrans' +
  #10'  AND Det1.DatTransBegin = Act.DatTransBegin' +
  #10'WHERE Det1.CodAction IN (' +
        AnsiQuotedStr(IntToStr(CtCodActPayAdvance), '''') +
  #10', ' + AnsiQuotedStr(IntToStr(CtCodActPayForfait), '''') +
  #10', ' + AnsiQuotedStr(IntToStr(CtCodActChangeAdvance), '''') +  ')' +
  #10'AND (Det1.CodTypeVente IN (2,4)' +
  #10'     OR  Det1.CodTypeVente BETWEEN 10 AND 19)';
  if FlgReprint or FlgCount then
    Result := Result +
    #10'AND Act.IdtOperator = ' + AnsiQuotedStr(IntToStr(StrToInt(IdtRegFor)), '''')
  else
    Result := Result + #10'AND Act.IdtOperator = ' +
              AnsiQuotedStr(IntToStr(StrToInt(IdtOperator)), '''');
  Result := Result + #10'AND ISNULL (Act.CodReturn, 0) IN (0, 101, 102)' +
  #10'AND FlgTraining = 0' +
  #10'AND Act.DatTransBegin > ' + AnsiQuotedStr(TxtStartDate, '''') +
  #10'AND Act.DatTransEnd < ' + AnsiQuotedStr(TxtEndDate, '''') +
  #10'AND EXISTS (SELECT *' +
  #10'              FROM PosTransDetail Det2' +
  #10'             WHERE Det1.IdtPOSTransaction = Det2.IdtPOSTransaction' +
  #10'  	       AND Det1.IdtCheckOut = Det2.IdtCheckOut' +
  #10'               AND Det1.CodTrans = Det2.CodTrans' +
  #10'               AND Det1.DatTransBegin = Det2.DatTransBegin' +
  #10'               AND Det1.CodTypeVente = Det2.CodTypeVente' +
  #10'               AND Det1.IdtCVente = Det2.IdtCVente' +
  #10'               AND Det2.CodAction =  135)';

end;   // of TFrmVSRptTndCountCA.BuildStatement

//=============================================================================

function TFrmVSRptTndCountCA.BuildCarteCadeaux : string;
Var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
  TxtIdtOperator   : string;           // string of operators
begin  // of TFrmVSRptTndCountCA.BuildCarteCadeaux
  TxtIdtOperator := '(';
  if pos(',',IdtRegFor) > 0 then begin
  SplitString (IdtRegFor, ',', TxtPartLeft, TxtPartRight);
  TxtIdtOperator := TxtIdtOperator + IntToStr(StrToInt(TxtPartLeft));
  while pos(',',TxtPartRight) > 0 do begin
    SplitString (TxtPartRight, ',', TxtPartLeft, TxtPartRight);
    TxtIdtOperator := TxtIdtOperator + ',' + IntToStr(StrToInt(TxtPartLeft));
    end;
  TxtIdtOperator := TxtIdtOperator + ',' + IntToStr(StrToInt(TxtPartRight)) + ')';
  end
  else
    TxtIdtOperator := TxtIdtOperator + IntToStr(StrToInt(IdtRegFor)) + ')';
  Result :=
  #10'SELECT SUM(Det1.QtyReg) Number,' +
  #10'       SUM(Det1.ValInclVAT) Total' +
  #10'FROM POSTransDetail Det1' +
  #10'  INNER JOIN POSTransaction Act' +
  #10'  ON Det1.IdtPOSTransaction = Act.IdtPOSTransaction' +
  #10'  AND Det1.IdtCheckOut = Act.IdtCheckOut' +
  #10'  AND Det1.CodTrans = Act.CodTrans' +
  #10'  AND Det1.DatTransBegin = Act.DatTransBegin' +
  #10'WHERE Det1.CodAction = ' + IntToStr(CtCodCarteCadeaux);
    Result := Result + #10' AND Act.IdtOperator IN ' + TxtIdtOperator ;
  Result := Result + #10' AND Act.DatTransBegin > ' +
            AnsiQuotedStr(TxtStartDate, '''') +
            #10' AND Act.DatTransEnd < ' + AnsiQuotedStr(TxtEndDate, '''') +
            #10' AND ISNULL (Act.CodReturn, 0) IN (0, 101, 102)' +              // Bugfix 28089
            #10' AND FlgTraining = 0';                                          // Bugfix 28089
end;   // of TFrmVSRptTndCountCA.BuildCarteCadeaux

//=============================================================================

constructor TFrmVSRptTndCountCA.Create (AOwner : TComponent);
begin  // of TFrmVSRptTndCountCA.Create
  ViValRptWidthVal := 9;
  ViValMarginHeader := 1500;
  inherited;
end;   // of TFrmVSRptTndCountCA.Create

//=============================================================================

procedure TFrmVSRptTndCountCA.FormCreate(Sender: TObject);
begin  // of TFrmVSRptTndCountCA.FormCreate
  inherited;
  RefNum := '0001';
  VspPreview.HdrFont.CharSet := DEFAULT_CHARSET;
end;   // of TFrmVSRptTndCountCA.FormCreate

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableSavingCardBody;
var
  TxtLine          : string;           // Line to print
  NumCounter       : Integer;          // counter to loop
  LstOperators     : string;           // List with operetors
begin  // of TFrmVSRptTndCountCA.GenerateTableSavingCardBody
  ValTotalAdding   := 0;
  ValTotalReducing := 0;
  DmdFpnUtils.CloseInfo;
  If IdtRegFor = '' then begin
    TxtLine := CtTxtAddingBank + SepCol + '-';
    PrintTableLine (TxtLine);
    TxtLine := CtTxtWithdrawBank + SepCol + '-';
    PrintTableLine (TxtLine);
  end
  else begin
    if FlgCount or FlgReprint then begin
      SelectDateRange(IdtRegFor);
      If TxtStartDate = '' then begin
        TxtLine := CtTxtAddingBank + SepCol + '-';
        PrintTableLine (TxtLine);
        TxtLine := CtTxtWithdrawBank + SepCol + '-';
        PrintTableLine (TxtLine);
      end
      else begin
        if DmdFpnUtils.QueryInfo (BuildStatementSavingCard) then begin
          while not DmdFpnUtils.QryInfo.Eof do begin
            if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger  =
                                              CtCodActChargeSavingCard then begin
              ValTotalAdding := DmdFpnUtils.QryInfo.
                                  FieldByName ('WaardeInclVAT').AsCurrency;
              TxtLine := CtTxtAddingBank + SepCol +
                  FormatValue(DmdFpnUtils.QryInfo.
                                FieldByName ('WaardeInclVAT').AsCurrency);
              PrintTableLine (TxtLine);
            end // of if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger
            else begin
              if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger  =
                                            CtCodActWithdrawSavingCard then begin
                ValTotalReducing := DmdFpnUtils.QryInfo.
                                      FieldByName ('WaardeInclVAT').AsCurrency;
                TxtLine := CtTxtWithdrawBank + SepCol +
                  FormatValue(DmdFpnUtils.QryInfo.
                                FieldByName ('WaardeInclVAT').AsCurrency);
                PrintTableLine (TxtLine);
              end; // of if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger
            end; // of else begin
            DmdFpnUtils.QryInfo.Next;
          end; // of while not DmdFpnUtils.QryInfo.Eof
        end // of if DmdFpnUtils.QueryInfo (BuildStatementSavingCard)
        else begin
          TxtLine := CtTxtAddingBank + SepCol + '-';
          PrintTableLine (TxtLine);
          TxtLine := CtTxtWithdrawBank + SepCol + '-';
          PrintTableLine (TxtLine);
        end; // of else begin
      end // of else begin
    end // of if FlgCount or FlgReprint
    else begin
      LstOperators := IdtRegFor;
      NumCounter   := AnsiPos (',', LstOperators);
      if NumCounter = 0 then begin
        IdtOperator := Trim(LstOperators);
        SelectDateRange(IdtOperator);
        if TxtStartDate = '' then begin
          TxtLine := CtTxtAddingBank + SepCol + '-';
          PrintTableLine (TxtLine);
          TxtLine := CtTxtWithdrawBank + SepCol + '-';
          PrintTableLine (TxtLine);
        end // of if TxtStartDate = ''
        else begin
          if DmdFpnUtils.QueryInfo (BuildStatementSavingCard) then begin
            while not DmdFpnUtils.QryInfo.Eof do begin
              if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger  =
                                                CtCodActChargeSavingCard then begin
                ValTotalAdding := DmdFpnUtils.QryInfo.
                                    FieldByName ('WaardeInclVAT').AsCurrency;
                TxtLine := CtTxtAddingBank + SepCol +
                  FormatValue(DmdFpnUtils.QryInfo.
                    FieldByName ('WaardeInclVAT').AsCurrency);
                PrintTableLine (TxtLine);
              end // of if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger
              else begin
                if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger  =
                                              CtCodActWithdrawSavingCard then begin
                  ValTotalReducing := DmdFpnUtils.QryInfo.
                                        FieldByName ('WaardeInclVAT').AsCurrency;
                  TxtLine := CtTxtWithdrawBank + SepCol +
                    FormatValue(DmdFpnUtils.QryInfo.
                                  FieldByName ('WaardeInclVAT').AsCurrency);
                  PrintTableLine (TxtLine);
                end; // of if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger
              end; // of else begin
              DmdFpnUtils.QryInfo.Next;
            end;  // of while not DmdFpnUtils.QryInfo.Eof
          end // of if DmdFpnUtils.QueryInfo (BuildStatementSavingCard)
          else begin
            TxtLine := CtTxtAddingBank + SepCol + '-';
            PrintTableLine (TxtLine);
            TxtLine := CtTxtWithdrawBank + SepCol + '-';
            PrintTableLine (TxtLine);
          end; // of else begin
        end; // of else begin
      end // of if NumCounter = 0
      else begin
        while numCounter < Length(LstOperators) do begin
          IdtOperator := Trim(Copy(LstOperators, 1, numCounter-1));
          LstOperators := Trim(Copy(LstOperators, numCounter+1, length(LstOperators)));
          NumCounter := AnsiPos (',', LstOperators);
          SelectDateRange(IdtOperator);
          if TxtStartDate <> '' then begin
            if DmdFpnUtils.QueryInfo (BuildStatementSavingCard) then begin
              while not DmdFpnUtils.QryInfo.Eof do begin
                if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger  =
                                                CtCodActChargeSavingCard then begin
                     ValTotalAdding := ValTotalAdding +
                          DmdFpnUtils.QryInfo.FieldByName ('WaardeInclVAT').AsFloat;
                end // of if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger
                else
                  ValTotalReducing := ValTotalReducing +
                                      DmdFpnUtils.QryInfo.
                                        FieldByName ('WaardeInclVAT').AsFloat;
                DmdFpnUtils.QryInfo.Next;
              end; // of while not DmdFpnUtils.QryInfo.Eof
            end; // of if DmdFpnUtils.QueryInfo (BuildStatementSavingCard)
          end; // of if TxtStartDate <> ''
          if numCounter = 0 then begin
            IdtOperator := Trim(LstOperators);
            numCounter := Length(LstOperators) + 1;
            SelectDateRange(IdtOperator);
            if TxtStartDate <> '' then begin
              if DmdFpnUtils.QueryInfo (BuildStatementSavingCard) then begin
                while not DmdFpnUtils.QryInfo.Eof do begin
                  if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger  =
                                                CtCodActChargeSavingCard then begin
                    ValTotalAdding := ValTotalAdding +
                            DmdFpnUtils.QryInfo.FieldByName ('WaardeInclVAT').AsFloat;
                  end // of if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger
                  else
                    ValTotalReducing := ValTotalReducing +
                                        DmdFpnUtils.QryInfo.
                                          FieldByName ('WaardeInclVAT').AsFloat;
                  DmdFpnUtils.QryInfo.Next;
                end; // of while not DmdFpnUtils.QryInfo.Eof
              end; // of if DmdFpnUtils.QueryInfo (BuildStatementSavingCard)
            end; // of if TxtStartDate <> ''
          end; // of if numCounter = 0
        end; // of while numCounter < Length(LstOperators)
        if ValTotalAdding = 0 then begin
          TxtLine := CtTxtAddingBank + SepCol + '-';
          PrintTableLine (TxtLine);
        end // of if ValTotalAdding = 0
        else begin
          TxtLine := CtTxtAddingBank + SepCol + FormatValue(ValTotalAdding);
          PrintTableLine (TxtLine);
        end; // of else begin
        if ValTotalReducing = 0 then begin
          TxtLine := CtTxtWithdrawBank + SepCol + '-';
          PrintTableLine (TxtLine);
        end // of if ValTotalReducing = 0
        else begin
          TxtLine := CtTxtWithdrawBank + SepCol + FormatValue(ValTotalReducing);
          PrintTableLine (TxtLine);
        end; // of else begin
      end; // of else begin
    end; // of else begin
  end; // of else begin
  DmdFpnUtils.CloseInfo;
end;   // of TFrmVSRptTndCountCA.GenerateTableSavingCardBody

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableSavingCardTotal;
var
  TxtLine          : string;
begin  // of TFrmVSRptTndCountCA.GenerateTableSavingCardTotal
  TxtLine := CtTxtDifference +
             SepCol + FormatValue (ValTotalAdding - ABS(ValTotalReducing));
  PrintTableLine (TxtLine);
  ConfigTableTotal;
end;   // of TFrmVSRptTndCountCA.GenerateTableSavingCardTotal

//=============================================================================

procedure TFrmVSRptTndCountCA.BuildTableSavingCardFmtAndHdr;
begin  // of TFrmVSRptTndCountCA.BuildTableSavingCardFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtSavingCard;
  AppendFmtAndHdrAmount (CtTxtHdrValUnit);
end;   // of TFrmVSRptTndCountCA.BuildTableSavingCardFmtAndHdr

//=============================================================================

procedure TFrmVSRptTndCountCA.GenerateTableSavingCard;
begin  // of TFrmVSRptTndCountCA.GenerateTableSavingCard
  InitializeBeforeStartTable;
  BuildTableSavingCardFmtAndHdr;
  VspPreview.StartTable;
  try
    GenerateTableSavingCardBody;
    if QtyLinesPrinted > 1 then
      GenerateTableSavingCardTotal;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCountCA.GenerateTableSavingCard

//=============================================================================

function TFrmVSRptTndCountCA.BuildStatementSavingCard: string;
begin  // of TFrmVSRptTndCountCA.BuildStatementSavingCard
  Result :=
  #10'SELECT POSDetail.CodAction, sum (PosDetail.ValInclVat) AS WaardeInclVAT' +
  #10'FROM PostransDetail PosDetail ' +
  #10'JOIN PosTransaction PosTrans ' +
  #10'  ON POSTrans.IdtPOSTransaction =PosDetail.IdtPOSTransaction ' +
  #10'     AND POSTrans.IdtCheckOut = PosDetail.IdtCheckOut ' +
  #10'     AND POSTrans.CodTrans = PosDetail.CodTrans ' +
  #10'     AND POSTrans.DatTransBegin = PosDetail.DatTransBegin ' +
  #10'WHERE POSDetail.IdtPosTransaction > 0 ' +
  #10'AND POSTrans.FlgTraining = 0 ' +
  #10'AND POSTrans.CodState = 4 ' +
  #10'AND ISNULL (PosTrans.CodReturn, 0) IN (0, 101, 102) ' ;
  if FlgReprint or FlgCount then
    Result := Result +
    #10'AND POSTrans.IdtOperator = ' + AnsiQuotedStr(IntToStr(StrToInt(IdtRegFor)), '''')
  else
    Result := Result +
              #10'AND POSTrans.IdtOperator = ' +
              AnsiQuotedStr(IntToStr(StrToInt(IdtOperator)), '''');

  Result := Result +
    #10'AND PosTrans.DatCreate > ' + AnsiQuotedStr(TxtStartDate, '''') +
    #10'AND PosTrans.DatCreate < ' + AnsiQuotedStr(TxtEndDate, '''');

  Result := Result +
  #10'AND POSDetail.CodType = ' + IntToStr(CtCodPdtAdmin) + 
  #10'AND POSDetail.Codaction IN (' +
            AnsiQuotedStr(IntToStr(CtCodActChargeSavingCard), '''') + ', ' +
            AnsiQuotedStr(IntToStr(CtCodActWithdrawSavingCard), '''') + ')' +
  #10'GROUP BY PosDetail.CodAction ';

end;   // of TFrmVSRptTndCountCA.BuildStatementSavingCard

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FVSRptTndCountCA
