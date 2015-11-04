//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : Form specific for reprinting 'Count Rapport'
// Unit     : FDetTndReprint.PAS : Detailform for TeNDer to REPRINT Count Rapport
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetTndReprintCA.pas,v 1.9 2010/05/28 07:57:11 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - PRptTndRePrint - CVS revision 1.8
//=============================================================================
// Version          ModifiedBy        Reason
// 2.0              SM(TCS)           R2012.1 HPQC Defect Fix 416

unit FDetTndReprintCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetTndReprint, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, ComCtrls, StdCtrls, Buttons, CheckLst, DateUtils,
  DFpnSafeTransaction, ScDBUtil_BDE, RfpnTender;

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtEmPropMissing          = 'No value assigned to %s';

resourcestring          // of date errors
  CtTxtStartEndDate          = 'Startdate is after enddate!';
  CtTxtStartFuture           = 'Startdate is in the future!';
  CtTxtEndFuture             = 'Enddate is in the future!';
  CtTxtErrorHeader           = 'Incorrect Date';

//*****************************************************************************
// Global definitions
//*****************************************************************************

const              // SQL statement to get IdtSafeTransaction
  TxtSql2 = #10'SELECT DISTINCT IdtSafeTransaction' +
            #10'  FROM SafeTransaction ' +
            #10' WHERE IdtOperator = ''%s''' +
            #10'   AND DatReg > ''%s'' ' +
            #10'   AND DatReg < ''%s''' +
            #10'   AND CodType = 931';

type
  TFrmDetTndReprintCA = class(TFrmDetTndReprint)
    DtmPckDayStart: TDateTimePicker;
    SvcDBLblDateStart: TSvcDBLabelLoaded;
    SvcDBLblDateEnd: TSvcDBLabelLoaded;
    DtmPckDayEnd: TDateTimePicker;
    procedure BtnPrintClick(Sender: TObject);
    procedure AddSQLWhereForListSafeTransactionDateCA(IdtOperator: string);
    procedure AddSQLSelectForListSafeTransaction;
    procedure AddSQLFromForListSafeTransaction;
    procedure AddSQLOrderByForListSafeTransaction;
    procedure AddSQLWhereForListSafeTransDetailDateCA
      (LstSafeTransaction: TLstSafeTransaction);
    procedure BuildListSafeTransAndDetailTotalReport
      (LstSafeTransaction: TLstSafeTransaction;
      IdtOperator: string);
    procedure AddSQLSelectForListSafeTransDetail;
    procedure AddSQLFromForListSafeTransDetail;
    procedure AddSQLWhereForListSafeTransDetail(IdtSafeTransaction: Integer);
    procedure AddSQLOrderByForListSafeTransDetail;
  private
    TxtPckDate: string; // Date
    procedure Initialize;
    procedure UnInitialize;
    procedure GetTransactionsForOperator(IdtOperator: string;
      LstTransOperator: TList);
    { Private declarations }
  protected
    FlgSavCard: Boolean;                 // Select Saving Card.
    FlgNoName: Boolean;                  // Select No name.
    FCodRunFunc: Integer;                // Functionality to execute
    FNumSeqSafeTrans: Integer;           // NumSeq SafeTransaction to process
    FIdtSafeTransaction: Integer;        // IdtSafeTransaction to process
    ValTotalTheorPrint: Currency;        // Total Theoretic for print
    ArrPages: array of Integer;          // Array of pages to restart counting
    function GetAllIdtOperators: string; virtual;
    function GetAllTxtOperators: string; virtual;
    procedure PrintRapport(TxtRegFor: string;
      TxtNameOperator: string;
      IdtSafeTrans: Integer;
      TxtPckDate: string);virtual;
    procedure AutoStart(Sender: TObject); override;
  public
    { Public declarations }
    procedure Execute; override;
  published
    // Properties
    property CodRunFunc: Integer read FCodRunFunc
                                write FCodRunFunc;
    property NumSeqSafeTrans: Integer read FNumSeqSafeTrans
                                     write FNumSeqSafeTrans;
    property IdtSafeTransaction: Integer read FIdtSafeTransaction
                                         write FIdtSafeTransaction;
  end;

var
  FrmDetTndReprintCA          : TFrmDetTndReprintCA;

//*****************************************************************************

implementation

{$R *.dfm}

uses
  SmDBUtil_BDE,
  SfDialog,
  DBConsts,

  DFpnUtils,
  DFpnSafeTransactionCA,
  DFpnTender,
  DFpnTenderCA,
  DFpnTenderGroup,
  DFpnBagCA,

  FVSRptTndCountCA,
  FVSRptTndGlobalCountSelect,
  FVSRptTndCount;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetTndReprintCA';

const  // CVS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetTndReprintCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 2.0 $';
  CtTxtSrcDate    = '$Date: 2013/06/26 07:57:11 $';

//*****************************************************************************
// Implementation of TFrmDetTndReprintCA
//*****************************************************************************

function TFrmDetTndReprintCA.GetAllTxtOperators: string;
var
  StrLstIdtOper    : TStringList;      // All operators in the SafeTransaction
  CntSafeTrans     : Integer;          // Loop all the SafeTransaction
  CntChkLstBx      : Integer;          // Loop all the SafeTransaction
  TxtSeperator     : string;           // Seperator between operators
  TmpOperator      : string;
begin // of TFrmDetTndReprintCA.GetAllIdtOperators
  StrLstIdtOper := TStringList.Create;
  try
    Result := '';
    StrLstIdtOper.Sorted     := False;
    StrLstIdtOper.Duplicates := dupIgnore;
    for CntChkLstBx := 0 to Pred(ChkLbxOperator.Items.Count) do begin
      if ChkLbxOperator.Checked[CntChkLstBx] then begin
        TmpOperator := ChkLbxOperator.Items.Strings[CntChkLstBx];
        StrLstIdtOper.Add(Trim(Copy(TmpOperator, AnsiPos(':', TmpOperator) + 1,
          length(TmpOperator) - AnsiPos(':', TmpOperator))));
      end;
    end;
    TxtSeperator := '';
    for CntSafeTrans := 0 to Pred(StrLstIdtOper.Count) do begin
      if StrLstIdtOper[CntSafeTrans] <> '' then begin
        Result := Result + TxtSeperator + StrLstIdtOper[CntSafeTrans];
        TxtSeperator := ', ';
      end;
    end;
  finally
    StrLstIdtOper.Free;
  end;
end; // of TFrmDetTndReprintCA.GetAllTxtOperators

//=============================================================================

procedure TFrmDetTndReprintCA.PrintRapport(TxtRegFor: string;
  TxtNameOperator: string;
  IdtSafeTrans: Integer;
  TxtPckDate: string);
begin // of TFrmDetTndReprintCA.PrintRapport
  if LstSafeTransaction.Count > 0 then begin
    // Adjust settings
    with FrmVSRptTndCountCA do begin
      CodRunFunc := CtCodFuncCount;
      NumSeqSafeTrans := 0;
      IdtSafeTransaction := IdtSafeTrans;
      IdtRegFor := TxtRegFor;
      TxtNameRegFor := TxtNameOperator;
      TxtDate := TxtPckDate;
      FlgReprint := True;
      GenerateReport;
      // Show the report
      if FlgPreview then
        FrmVSRptTndCountCA.ShowModal
      else
        VspPreview.PrintDoc(False, null, null);
    end; // of FrmVSRptTndCountRePrintCA
  end; // of if LstSafeTransaction.Count > 0
end;  // of TFrmDetTndReprintCA.PrintRapport

//=============================================================================

procedure TFrmDetTndReprintCA.AddSQLSelectForListSafeTransaction;
begin // of TFrmDetTndReprintCA.AddSQLSelectForListSafeTransaction
  with DmdFpnSafeTransactionCA.QrySafeTransUtil.SQL do begin
    Add('SELECT');
    Add('  SafeTransaction.IdtSafeTransaction,');
    Add('  SafeTransaction.NumSeq,');
    Add('  SafeTransaction.CodType,');
    Add('  SafeTransaction.CodReason,');
    Add('  SafeTransaction.IdtCheckout,');
    Add('  SafeTransaction.IdtOperator,');
    Add('  SafeTransaction.IdtOperReg,');
    Add('  SafeTransaction.DatReg,');
    Add('  SafeTransaction.NumReport,');
    Add('  SafeTransaction.IdtPayOrgan,');
    Add('  SafeTransaction.IdtCurrency,');
    Add('  SafeTransaction.ValExchange,');
    Add('  SafeTransaction.FlgExchMultiply');
  end; // of with QrySafeTransUtil.SQL do...
end; // of TFrmDetTndReprintCA.AddSQLSelectForListSafeTransaction

//=============================================================================
// TDmdFpnSafeTransaction.AddSQLOrderByForListSafeTransaction : adds the
// ORDER BY-clause to select SafeTransactions for a list of SafeTransaction.
//=============================================================================

procedure TFrmDetTndReprintCA.AddSQLOrderByForListSafeTransaction;
begin // of TFrmDetTndReprintCA.AddSQLOrderByForListSafeTransaction
  with DmdFpnSafeTransactionCA.QrySafeTransUtil.SQL do begin
    Add('ORDER BY');
    Add('  SafeTransaction.IdtSafeTransaction,');
    Add('  SafeTransaction.NumSeq');
  end; // of with QrySafeTransUtil.SQL do...
end; // of TFrmDetTndReprintCA.AddSQLOrderByForListSafeTransaction

//=============================================================================
// TFrmDetTndReprintCA.AddSQLWhereForListSafeTransactionDateCA : adds the
// WHERE-clause to select SafeTransactions for a list of SafeTransaction.
//=============================================================================

procedure TFrmDetTndReprintCA.AddSQLWhereForListSafeTransactionDateCA
                                                          (IdtOperator: string);
begin // of TDmdFpnSafeTransactionCA.AddSQLWhereForListSafeTransactionDateCA
  with DmdFpnSafeTransactionCA.QrySafeTransUtil.SQL do begin
    Add('WHERE EXISTS');
    Add('   (SELECT IdtSafeTransaction');
    Add('      FROM SafeTransaction SafeTr (NOLOCK)');
    Add('     WHERE SafeTransaction.IdtSafeTransaction = ' +
      'SafeTr.IdtSafeTransaction');
    Add('       AND SafeTr.DatReg > ' +
      AnsiQuotedStr(FormatDateTime(ViTxtDBDatFormat, DtmPckDayStart.Date - 1) +
      ' 23:59:59', ''''));
    Add('       AND SafeTr.DatReg < ' +
      AnsiQuotedStr(FormatDateTime(ViTxtDBDatFormat, DtmPckDayEnd.Date + 1) +
      ' 00:00:00', ''''));
    Add('       AND SafeTr.IdtOperator IN (' + IdtOperator + ')');
    Add('       AND SafeTr.CodType = ' + IntToStr(CtCodSttFinalCount) + ')');
    Add('AND SafeTransaction.IdtCheckOut IS NULL');
  end; // of with QrySafeTransUtil.SQL do...
end; // of TFrmDetTndReprintCA.AddSQLWhereForListSafeTransactionDateCA

//=============================================================================
// TDmdFpnSafeTransaction.AddSQLFromForListSafeTransaction : adds the
// FROM-clause to select SafeTransactions for a list of SafeTransaction.
//=============================================================================

procedure TFrmDetTndReprintCA.AddSQLFromForListSafeTransaction;
begin // of TFrmDetTndReprintCA.AddSQLFromForListSafeTransaction
  with DmdFpnSafeTransactionCA.QrySafeTransUtil.SQL do begin
    Add('FROM');
    Add('  SafeTransaction (NOLOCK)');
  end; // of with QrySafeTransUtil.SQL do...
end; // of TFrmDetTndReprintCA.AddSQLFromForListSafeTransaction

//=============================================================================
// TDmdFpnSafeTransactionCA.AddSQLWhereForListSafeTransDetailDateCA : adds the
// WHERE-clause to select SafeTransDetail for a list of SafeTransDetail build
// out of the given LstSafeTrans.
//                                  -----
// INPUT   : LstSafeTrans = list containing a LstTransDetail with all the
//                          not remitted SafeTransDetail.
//=============================================================================

procedure TFrmDetTndReprintCA.AddSQLWhereForListSafeTransDetailDateCA
  (LstSafeTransaction: TLstSafeTransaction);
var
  TxtKeyWord                  : string; // Keyword to add to SQL-statement
  CntItem                     : Integer; // Counter items in LstTransaction
  TxtIdtIncluded              : string; // Temp.string to check if Idt included
  TxtIdtNew                   : string; // Build a new string for Idt to include
  ObjTransaction              : TObjSafeTransaction; // Current Transaction in list
begin // of TFrmDetTndReprintCA.AddSQLWhereForListSafeTransDetailDateCA
  TxtKeyWord := '   OR ';
  TxtIdtIncluded := '';
  with DmdFpnSafeTransactionCA.QryTransDetailUtil.SQL do begin
    Add('WHERE IdtSafeTransaction = -1');
    for CntItem := 0 to Pred(LstSafeTransaction.Count) do begin
      ObjTransaction := LstSafeTransaction[CntItem];
      TxtIdtNew := IntToStr(ObjTransaction.IdtSafeTransaction) + '.' +
        IntToStr(ObjTransaction.NumSeq) + ';';
      if AnsiPos(TxtIdtNew, TxtIdtIncluded) = 0 then
        Add(TxtKeyWord + '(SafeTransDetail.IdtSafeTransaction = ' +
          IntToStr(ObjTransaction.IdtSafeTransaction) +
          ' AND SafeTransDetail.NumSeq = ' +
          IntToStr(ObjTransaction.NumSeq) + ')');
      TxtIdtIncluded := TxtIdtIncluded + TxtIdtNew;
    end;
  end; // of with QrySafeDetailUtil.SQL do...
end; // of TFrmDetTndReprintCA.AddSQLWhereForListSafeTransDetailDateCA

//=============================================================================
// TDmdFpnSafeTransaction.AddSQLSelectForListSafeTransDetail : adds the
// SELECT-clause with the list of fields to select for a list of
// SafeTransDetail.
//=============================================================================

procedure TFrmDetTndReprintCA.AddSQLSelectForListSafeTransDetail;
begin // of TFrmDetTndReprintCA.AddSQLSelectForListSafeTransDetail
  with DmdFpnSafeTransactionCA.QryTransDetailUtil.SQL do begin
    Add('SELECT');
    Add('  SafeTransDetail.IdtSafeTransaction,');
    Add('  SafeTransDetail.NumSeq,');
    Add('  SafeTransDetail.NumSeqDetail,');
    Add('  SafeTransDetail.IdtTenderGroup,');
    Add('  SafeTransDetail.FlgTransfer,');
    Add('  SafeTransDetail.TxtDescr,');
    Add('  SafeTransDetail.QtyUnit,');
    Add('  SafeTransDetail.ValUnit,');
    Add('  SafeTransDetail.QtyArticle,');
    Add('  SafeTransDetail.QtyCustomer,');
    Add('  SafeTransDetail.ValDiscount,');
    Add('  SafeTransDetail.IdtCurrency,');
    Add('  SafeTransDetail.ValExchange,');
    Add('  SafeTransDetail.FlgExchMultiply');
  end; // of with QryTransDetailUtil.SQL do...
end; // of TFrmDetTndReprintCA.AddSQLSelectForListSafeTransDetail

//=============================================================================
// TDmdFpnSafeTransaction.AddSQLFromForListSafeTransDetail : adds the
// FROM-clause to select SafeTransDetail for a list of SafeTransDetail.
//=============================================================================

procedure TFrmDetTndReprintCA.AddSQLFromForListSafeTransDetail;
begin // of TFrmDetTndReprintCA.AddSQLFromForListSafeTransDetail
  with DmdFpnSafeTransactionCA.QryTransDetailUtil.SQL do begin
    Add('FROM');
    Add('  SafeTransDetail (NOLOCK)');
  end; // of with QryTransDetailUtil.SQL do...
end; // of TFrmDetTndReprintCA.AddSQLFromForListSafeTransDetail

//=============================================================================
// TDmdFpnSafeTransaction.AddSQLWhereForListSafeTransDetail : adds the
// WHERE-clause to select SafeTransDetail for a list of SafeTransDetail.
//                                  -----
// INPUT   : IdtSafeTransaction = IdtSafeTransaction to get the list for
//                                (to include in the WHERE-clause).
//=============================================================================

procedure TFrmDetTndReprintCA.AddSQLWhereForListSafeTransDetail
  (IdtSafeTransaction: Integer);
begin // of TFrmDetTndReprintCA.AddSQLWhereForListSafeTransDetail
  with DmdFpnSafeTransactionCA.QryTransDetailUtil.SQL do begin
    Add('WHERE SafeTransDetail.IdtSafeTransaction = ' +
      IntToStr(IdtSafeTransaction));
  end; // of with QryTransDetailUtil.SQL do...
end; // of TFrmDetTndReprintCA.AddSQLWhereForListSafeTransDetail

//=============================================================================
// TDmdFpnSafeTransaction.AddSQLOrderByForListSafeTransDetail : adds the
// ORDER BY-clause to select SafeTransDetail for a list of SafeTransDetail.
//=============================================================================

procedure TFrmDetTndReprintCA.AddSQLOrderByForListSafeTransDetail;
begin // of TFrmDetTndReprintCA.AddSQLOrderByForListSafeTransDetail
  with DmdFpnSafeTransactionCA.QryTransDetailUtil.SQL do begin
    Add('ORDER BY');
    Add('  SafeTransDetail.IdtSafeTransaction,');
    Add('  SafeTransDetail.NumSeq,');
    Add('  SafeTransDetail.NumSeqDetail,');
    Add('  SafeTransDetail.IdtTenderGroup');
  end; // of with QryTransDetailUtil.SQL do...
end; // of TFrmDetTndReprintCA.AddSQLOrderByForListSafeTransDetail

//=============================================================================

procedure TFrmDetTndReprintCA.GetTransactionsForOperator
  (IdtOperator: string;
  LstTransOperator: TList);
var
  TxtCountDate                : string; // Date of last Count
begin  // of TFrmDetTndReprintCA.GetTransactionsForOperator
  LstTransOperator.Clear;
  try
    if DmdFpnUtils.QueryInfo(Format(TxtSql2, [IdtOperator,
       FormatDateTime(ViTxtDBDatFormat, DtmPckDay.Date),
       FormatDateTime(ViTxtDBDatFormat, DtmPckDay.Date + 1) + ' ' +
       FormatDateTime(ViTxtDBHouFormat, 0)])) then begin
      while not DmdFpnUtils.QryInfo.Eof do begin
          // Add this transaction
          LstTransOperator.Add(TObject(DmdFpnUtils.QryInfo.FieldByName
            ('IdtSafeTransaction').AsInteger));
          DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;  // of TFrmDetTndReprintCA.GetTransactionsForOperator

//=============================================================================

function TFrmDetTndReprintCA.GetAllIdtOperators: string;
var
  StrLstIdtOper    : TStringList;      // All operators in the SafeTransaction
  CntSafeTrans     : Integer;          // Loop all the SafeTransaction
  CntChkLstBx      : Integer;          // Loop all the SafeTransaction
  TxtSeperator     : string;           // Seperator between operators
begin // of TFrmDetTndReprintCA.GetAllIdtOperators
  StrLstIdtOper := TStringList.Create;
  try
    Result := '';
    StrLstIdtOper.Sorted     := True;
    StrLstIdtOper.Duplicates := dupIgnore;
    for CntChkLstBx := 0 to Pred(ChkLbxOperator.Items.Count) do begin
      if ChkLbxOperator.Checked[CntChkLstBx] then begin
        StrLstIdtOper.Add(Trim(Copy
          (ChkLbxOperator.Items.Strings[CntChkLstBx], 1,
          AnsiPos(':', ChkLbxOperator.Items.Strings[CntChkLstBx]) - 1)));
      end;
    end;
    TxtSeperator := '';
    for CntSafeTrans := 0 to Pred(StrLstIdtOper.Count) do begin
      if StrLstIdtOper[CntSafeTrans] <> '' then begin
        Result := Result + TxtSeperator + StrLstIdtOper[CntSafeTrans];
        TxtSeperator := ', ';
      end;
    end;
  finally
    StrLstIdtOper.Free;
  end;
end; // of TFrmDetTndReprintCA.GetAllIdtOperators

//=============================================================================
// TFrmDetTndReprintCA.Initialize : Creates all the needed objects to generate
// the rapport
//=============================================================================

procedure TFrmDetTndReprintCA.Initialize;
begin // of TFrmDetTndReprintCA.Initialize
  LstSafeTransaction := TLstSafeTransactionCA.Create;
  LstTenderGroup := TLstTenderGroup.Create;
  DmdFpnTenderGroup.BuildListTenderGroup(LstTenderGroup);
  LstTenderClass := TLstTenderClass.Create;
  DmdFpnTenderGroup.BuildListTenderClass(LstTenderClass);
  FrmVSRptTndCountCA := TFrmVSRptTndCountCA.Create(Self);
end; // of TFrmDetTndReprintCA.Initialize

//=============================================================================

procedure TFrmDetTndReprintCA.BuildListSafeTransAndDetailTotalReport
  (LstSafeTransaction: TLstSafeTransaction;
  IdtOperator: string);
begin // of TDmdFpnSafeTransactionCA.BuildListSafeTransAndDetailTotalReport
  // Build the ListSafeTransaction
  if DmdFpnSafeTransactionCA.QrySafeTransUtil.Active then
    raise EInvalidOperation.Create
      (DBConsts.SDataSetOpen +
      ' (' + Name + '.BuildListSafeTransaction : QrySafeTransUtil)');
  // Build the SQL-statement
  DmdFpnSafeTransactionCA.QrySafeTransUtil.SQL.Clear;
  AddSQLSelectForListSafeTransaction;
  AddSQLFromForListSafeTransaction;
  AddSQLWhereForListSafeTransactionDateCA(IdtOperator);
  AddSQLOrderByForListSafeTransaction;
  DmdFpnSafeTransactionCA.QrySafeTransUtil.Active := True;
  try
    if not DmdFpnSafeTransactionCA.QrySafeTransUtil.IsEmpty then
      LstSafeTransaction.FillFromDB(DmdFpnSafeTransactionCA.QrySafeTransUtil);
  finally
    DmdFpnSafeTransactionCA.QrySafeTransUtil.Active := False;
  end;
  DmdFpnSafeTransaction.LoadSafeTransExplanation(LstSafeTransaction);
  // Build the ListSafeTransDetail
  if DmdFpnSafeTransaction.QryTransDetailUtil.Active then
    raise EInvalidOperation.Create
      (DBConsts.SDataSetOpen +
      ' (' + Name + '.BuildListSafeTransDetail : QryTransDetailUtil)');
  // Build the SQL-statement
  DmdFpnSafeTransaction.QryTransDetailUtil.SQL.Clear;
  AddSQLSelectForListSafeTransDetail;
  AddSQLFromForListSafeTransDetail;
  AddSQLWhereForListSafeTransDetailDateCA(LstSafeTransaction);
  AddSQLOrderByForListSafeTransDetail;
  DmdFpnSafeTransaction.QryTransDetailUtil.Active := True;
  try
    if not DmdFpnSafeTransaction.QryTransDetailUtil.IsEmpty then
      LstSafeTransaction.LstTransDetail.FillFromDB(
        DmdFpnSafeTransaction.QryTransDetailUtil);
  finally
    DmdFpnSafeTransaction.QryTransDetailUtil.Active := False;
  end;
end; // of TFrmDetTndReprintCA.BuildListSafeTransAndDetailTotalReport

//=============================================================================


procedure TFrmDetTndReprintCA.Execute;
var
  CntChkLstBx      : Integer;          // Loop all items in CheckListBox
  CntSafeTrans     : Integer;          // Loop all safetransactions for operator
  IdtSafeTrans     : Integer;          // Number of the safetransaction
  IdtOperator      : string;           // Holds the operator identifier
  TmpOperator      : string;           // Holds the temp operator
  LstTransOperator : TList;            // Available IdtTransactions for operator
  HasFinalCount    : Boolean;          // Has there been a final count?
  NumFinalCount    : Integer;          // Index of final count
  NameOperator     : string;           // Name of the registrating operator
  CntDay           : Integer;          // Count days betweeen start and enddate
  ItdLoop          : Integer;
begin // of TFrmDetTndReprintCA.Execute
  CntDay         := DaysBetween(DtmPckDayStart.Date, DtmPckDayEnd.Date);
  DtmPckDay.Date := DtmPckDayStart.Date;
  LstTransOperator := TList.Create;
  for ItdLoop := 0 to CntDay do begin
    Initialize;
    // Loop all operators
    for CntChkLstBx := 0 to Pred(ChkLbxOperator.Items.Count) do begin
      if ChkLbxOperator.Checked[CntChkLstBx] then begin
        FrmVSRptTndCountCA.FlgSavCard := FlgSavCard;
        FrmVSRptTndCountCA.FlgAutoRem := FlgAutoRem;                             //R2012.1 HPQC Defect Fix 416(SM)
        // Get the operator from checklistbox
        TmpOperator  := ChkLbxOperator.Items.Strings[CntChkLstBx];
        IdtOperator  := Trim(Copy(TmpOperator, 1, AnsiPos(':', TmpOperator) - 1));
        NameOperator := Trim(Copy(TmpOperator, AnsiPos(':', TmpOperator) + 1,
                        length(TmpOperator) - AnsiPos(':', TmpOperator)));
        // Get all safetransactions for specified operator (if any)
        LstTransOperator.Clear;
        GetTransactionsForOperator(IdtOperator, LstTransOperator);
        // Loop all safetransactions for specified operator /date and print
        // a report
        for CntSafeTrans := 0 to Pred(LstTransOperator.Count) do begin
          IdtSafeTrans := (Integer(LstTransOperator[CntSafeTrans]));
          // Build the safetransaction list for specified transaction
          DmdFpnSafeTransaction.BuildListSafeTransactionAndDetail(
            LstSafeTransaction, IdtSafeTrans);
          // Check for final count
          NumFinalCount := LstSafeTransaction.IndexOfIdtAndType
            (IdtSafeTrans, CtCodSttFinalCount);
          HasFinalCount := NumFinalCount >= 0;
          if HasFinalCount then begin
            try
              DmdFpnUtils.QueryInfo
                ('SELECT * FROM Pochette ' +
                'WHERE IdtSafetransaction = ' +
                IntToStr(LstSafeTransaction.SafeTransaction[NumFinalCount].
                IdtSafeTransaction) + '  AND NumSeq = ' +
                IntToStr(LstSafeTransaction.SafeTransaction[NumFinalCount].NumSeq));
                TLstSafeTransactionCA(LstSafeTransaction).LstBag.
                FillFromDB(DmdFpnUtils.QryInfo);
            finally
              DmdFpnUtils.CloseInfo;
            end;
          end;
          TxtPckDate :=  FormatDateTime (ViTxtDBDatFormat, DtmPckDay.Date);
          PrintRapport(IntToStr(Integer(ChkLbxOperator.Items.Objects[CntChkLstBx])),
                       NameOperator, IdtSafeTrans, TxtPckDate);
          LstSafeTransaction.ClearSafeTransactions;
          TLstSafeTransactionCA(LstSafeTransaction).LstBag.ClearBags;
        end; // of transaction loop
      end; // of if operator selected
    end; // of operator loop
    DtmPckDay.Date := IncDay(DtmPckDay.Date, 1)
  end;
  DmdFpnSafeTransactionCA.DatExecution := DtmPckDay.Date;
  LstSafeTransaction.ClearSafeTransactions;
  BuildListSafeTransAndDetailTotalReport
    (LstSafeTransaction, GetAllIdtOperators);
  FrmVSRptTndGlobalCountSelect.FlgNoName     := FlgNoName;
  FrmVSRptTndGlobalCountSelect.FlgSavCard    := FlgSavCard;
  FrmVSRptTndGlobalCountSelect.FlgAutoRem    := FlgAutoRem;                       //R2012.1 HPQC Defect Fix 416(SM)
  FrmVSRptTndGlobalCountSelect.IdtRegFor     := GetAllIdtOperators;
  FrmVSRptTndGlobalCountSelect.TxtNameRegFor := GetAllTxtOperators;
  FrmVSRptTndGlobalCountSelect.CodRunFunc    := CtCodFuncCount;
  FrmVSRptTndGlobalCountSelect.TxtDate       := FormatDateTime(ViTxtDBDatFormat,
                                                  DtmPckDay.Date);
  FrmVSRptTndGlobalCountSelect.GenerateReport;
  FrmVSRptTndGlobalCountSelect.ShowModal;
  LstTransOperator.Free;
  UnInitialize;
end; // of TFrmDetTndReprintCA.Execute

//=============================================================================

procedure TFrmDetTndReprintCA.UnInitialize;
begin // of TFrmDetTndReprintCA.UnInitialize
  DtmPckDay.Date := Now;
  LstTenderClass.ClearTenderClasses;
  LstTenderClass.Free;
  LstTenderClass := nil;
  LstTenderGroup.ClearTenderGroups;
  LstTenderGroup.Free;
  LstTenderGroup := nil;
  LstSafeTransaction.ClearSafeTransactions;
  LstSafeTransaction.Free;
  LstSafeTransaction := nil;
end; // of TFrmDetTndReprintCA.UnInitialize

//=============================================================================

procedure TFrmDetTndReprintCA.AutoStart(Sender: TObject);
begin // of TFrmDetTndReprintCA.AutoStart
  if Application.Terminated then
    Exit;
  inherited;
  DtmPckDayStart.DateTime := Now;
  DtmPckDayEnd.DateTime := Now;
end;  // of TFrmDetTndReprintCA.AutoStart

//=============================================================================

procedure TFrmDetTndReprintCA.BtnPrintClick(Sender: TObject);
begin // of TFrmDetTndReprintCA.BtnPrintClick
  // Check is DayFrom < DayTo
  if (DtmPckDayStart.Date > DtmPckDayEnd.Date) then begin
      DtmPckDayStart.Date := Now;
      DtmPckDayEnd.Date := Now;
      Application.MessageBox(PChar(CtTxtStartEndDate),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if DtmPckDayStart.Date > Now then begin
      DtmPckDayStart.Date := Now;
      DtmPckDayEnd.Date := Now;
      Application.MessageBox(PChar(CtTxtStartFuture),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if DtmPckDayEnd.Date > Now then begin
      DtmPckDayStart.Date := Now;
      DtmPckDayEnd.Date := Now;
      Application.MessageBox(PChar(CtTxtEndFuture),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
       inherited;
  end;
end; // of TFrmDetTndReprintCA.BtnPrintClick

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FDetTndReprintCA

