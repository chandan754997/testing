//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : Form specific for reprinting 'Count Rapport'
// Unit     : FDetTndReprint.PAS : Detailform for TeNDer to REPRINT Count Rapport
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetTndReprint.pas,v 1.7 2010/06/28 06:55:59 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - PRptTndRePrint - CVS revision 1.8
//=============================================================================

unit FDetTndReprintOpr;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, ComCtrls, ScDBUtil_BDE, StdCtrls, Buttons, CheckLst, Menus,
  ImgList, ActnList, ExtCtrls, ScAppRun, SfVSPrinter7, SmVSPrinter7Lib_TLB,
  ScEHdler;

//*****************************************************************************
// Global definitions
//*****************************************************************************

const              // SQL statement to get IdtSafeTransaction
  TxtSql = #10'SELECT DISTINCT IdtSafeTransaction' +
           #10'  FROM SafeTransaction ' +
           #10' WHERE IdtOperator = ''%s''' +
           #10'   AND DatReg > ''%s'' ' +
           #10'   AND DatReg < ''%s''' +
           #10'   AND CodType < 1000';

resourcestring
  CtTxtNoSelection = 'There are no items selected!';
  CtTxtDateFuture  = 'The selected date is in the future!';

resourcestring  // for runparameters of the document.
CtPrmSavingCard = '/VSC=Show Saving Card on report';
CtPrmAutoremise = '/VAR=Show remises auto promopack on report';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetTndReprint = class(TFrmAutoRun)
    Panel1: TPanel;
    ChkLbxOperator: TCheckListBox;
    BtnSelectAll: TBitBtn;
    BtnDeSelectAll: TBitBtn;
    SvcDBLblDate: TSvcDBLabelLoaded;
    DtmPckDay: TDateTimePicker;
    BtnPreview: TSpeedButton;
    BtnPrintSetup: TSpeedButton;
    BtnPrint: TSpeedButton;
    procedure BtnPrintSetupClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnSelectAllClick(Sender: TObject);
    procedure BtnDeSelectAllClick(Sender: TObject);
    procedure ActStartExecExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DtmPckDayExit(Sender: TObject);
  private
    { Private declarations }
    FFrmVSPreview  : TFrmVSPreview;    // VS Preview form
    FFlgPreview    : Boolean;          // Print or Preview the rapport.
    TxtPckDate        : string;           // Date

    procedure Initialize;
    procedure UnInitialize;
    procedure GetTransactionsForOperator (IdtOperator      : string;
                                          LstTransOperator : TList );
    procedure AddVerkTot (    IdtOperator        : string;
                          var IdtSafeTransaction : Integer);
    procedure PrintRapport (TxtRegFor     : string ;
                            TxtNameOperator : string ;
                            IdtSafeTrans  : Integer;
                            TxtPckDate       : string);
  protected
    FlgSavCard  : Boolean;          // Select Saving Card.
    FlgAutoRem  : Boolean;          // Show Auto Remise
    function GetFrmVSPreview : TFrmVSPreview; virtual;
    function GetVspPreview : TVSPrinter; virtual;
    function GetItemsSelected : Boolean; virtual;
    function GetTxtLstOperID : string; virtual;

    procedure AutoStart (Sender : TObject); override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;

  public
    property ItemsSelected : Boolean read GetItemsSelected;
    property FrmVSPreview : TFrmVSPreview read GetFrmVSPreview;
    property VspPreview : TVSPrinter read GetVspPreview;
    property TxtLstOperID : string read GetTxtLstOperID;
    property FlgPreview : Boolean read  FFlgPreview
                                  write FFlgPreview;
    procedure Execute; override;
  end;   // of TFrmDetTndReprint

var
  FrmDetTndReprint: TFrmDetTndReprint;

//*****************************************************************************

implementation

uses
  Variants,

  SmUtils,
  SmDBUtil_BDE,
  SfDialog,

  DFpn,
  DFpnOperator,
  DFpnOperatorCA,
  DFpnUtils,
  DFpnTender,
  DFpnTenderCA,
  DFpnTenderGroup,
  DFpnSafeTransaction,
  DFpnSafeTransactionOprCA,
  DFpnBagCA,

  Operator,
  KasResul,
  FVSRptTndCountOprCA,
  MFpsDBOperation,
  FVSRptTndCount, DFpnWorkStatCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetTndReprint.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2010/06/28 06:55:59 $';

//*****************************************************************************
// Implementation of TFrmDetTndReprint
//*****************************************************************************

procedure TFrmDetTndReprint.GetTransactionsForOperator
                                                     (IdtOperator      : string;
                                                      LstTransOperator : TList);
var
    TxtCountDate        : string;      // Date of last Count
begin
  LstTransOperator.Clear;
  try
    DmdFpnUtils.QueryInfo (
       #10'SELECT TxtDate = CONVERT(varchar, Max(DatReg), 112) + ' + ' + ' +
                            AnsiQuotedStr(' ', '''') + ' + ' +
       #10'                 CONVERT(varchar, DATEADD(S, 1, Max(DatReg)), 108)' +
       #10'From SafeTransaction' +
       #10'WHERE IdtOperator = ' + AnsiQuotedStr(IdtOperator, '''') +
       #10'AND CodType = ' + AnsiQuotedStr('931', '''') +
       #10'AND DatReg < ' + AnsiQuotedStr(
                          FormatDateTime (ViTxtDBDatFormat, DtmPckDay.Date) +
                          ' ' + FormatDateTime (ViTxtDBHouFormat, 0), ''''));
    TxtCountDate := DmdFpnUtils.QryInfo.FieldByName ('TxtDate').AsString;
    DmdFpnUtils.CloseInfo;
    If length(TxtCountDate) = 0 then begin
    if DmdFpnUtils.QueryInfo (Format (TxtSql, [IdtOperator,
                  FormatDateTime (ViTxtDBDatFormat, DtmPckDay.Date) + ' ' +
                  FormatDateTime (ViTxtDBHouFormat, 0),
                  FormatDateTime (ViTxtDBDatFormat, DtmPckDay.Date + 1) + ' ' +
                  FormatDateTime (ViTxtDBHouFormat, 0)])) then begin
      while not DmdFpnUtils.QryInfo.Eof do begin
        // Add this transaction
        LstTransOperator.Add (TObject (DmdFpnUtils.QryInfo.FieldByName
                                             ('IdtSafeTransaction').AsInteger));
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
    end
    else begin
      if DmdFpnUtils.QueryInfo (Format (TxtSql, [IdtOperator,
                  TxtCountDate,
                  FormatDateTime (ViTxtDBDatFormat, DtmPckDay.Date + 1) + ' ' +
                  FormatDateTime (ViTxtDBHouFormat, 0)])) then begin
        while not DmdFpnUtils.QryInfo.Eof do begin
          // Add this transaction
          LstTransOperator.Add (TObject (DmdFpnUtils.QryInfo.FieldByName
                                             ('IdtSafeTransaction').AsInteger));
          DmdFpnUtils.QryInfo.Next;
        end;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;

//=============================================================================

function TFrmDetTndReprint.GetFrmVSPreview : TFrmVSPreview;
begin
  if not Assigned (FFrmVSPreview) then
    FFrmVSPreview := TFrmVSPreview.Create (Application);
  Result := FFrmVSPreview;
end;

//=============================================================================

function TFrmDetTndReprint.GetVspPreview : TVSPrinter;
begin
  Result := FrmVSPreview.VspPreview;
end;

//=============================================================================

function TFrmDetTndReprint.GetItemsSelected : Boolean;
var
  CntIx            : Integer;          // Looping the CheckListBox.
begin  //
  Result := False;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntIx] then begin
      Result := True;
      Break;
    end;
  end;
end;

//=============================================================================

function TFrmDetTndReprint.GetTxtLstOperID : string;
var
  CntOper          : Integer;          // Loop the operators in the Checklistbox
begin
  Result := '';
  for CntOper := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntOper] then
      Result := Result +  AnsiQuotedStr (IntToStr(
          Integer(ChkLbxOperator.Items.Objects[CntOper])), '''') + ',';
  end;
  Result := Copy (Result, 0, Length (Result) - 1);
end;

//=============================================================================

procedure TFrmDetTndReprint.AutoStart (Sender : TObject);
begin
  if Application.Terminated then
    Exit;

  inherited;

  // Fill the listbox with all the operators
  try
    if DmdFpnUtils.QueryInfo
        ('SELECT IdtOperator, TxtName FROM Operator') then begin

      DmdFpnUtils.QryInfo.First;
      ChkLbxOperator.Items.Clear;
      while not DmdFpnUtils.QryInfo.Eof do begin
        ChkLbxOperator.Items.AddObject
           (DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + ' : ' +
            DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString,
            TObject (DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger));
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;

  if ViFlgAutom then
    BtnSelectAllClick (Sender);
  DtmPckDay.DateTime := Now;
  TxtPckDate :=  FormatDateTime (ViTxtDBDatFormat, DtmPckDay.Date);

  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;

//=============================================================================

procedure TFrmDetTndReprint.BtnPrintSetupClick(Sender: TObject);
begin
  inherited;
  FrmVSPreview.ActPrinterSetupExecute (nil);
end;

//=============================================================================

procedure TFrmDetTndReprint.BtnPrintClick(Sender: TObject);
begin
  inherited;
  FlgPreview := (Sender = BtnPreview);
  ActStartExec.Execute;
end;

//=============================================================================

procedure TFrmDetTndReprint.BtnSelectAllClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin
  inherited;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do
    ChkLbxOperator.Checked [CntIx] := True;
end;

//=============================================================================

procedure TFrmDetTndReprint.BtnDeSelectAllClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin
  inherited;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do
    ChkLbxOperator.Checked [CntIx] := False;
end;

//=============================================================================

procedure TFrmDetTndReprint.ActStartExecExecute(Sender: TObject);
begin  // TFrmDetTndReprint.ActStartExecExecute
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;

  if ((DtmPckDay.Date - Date) >= 1) then begin
    MessageDlg (CtTxtDateFuture, mtWarning, [mbOK], 0);
    DtmPckDay.Date := Now;
    Exit;
  end;

  inherited;
end;   // of TFrmDetTndReprint.ActStartExecExecute

//=============================================================================
// TFrmDetTndReprint.Initialize : Creates all the needed objects to generate
// the rapport
//=============================================================================

procedure TFrmDetTndReprint.Initialize;
begin  // of TFrmDetTndReprint.Initialize
  LstSafeTransaction := TLstSafeTransactionCA.Create;

  LstTenderGroup := TLstTenderGroup.Create;
  DmdFpnTenderGroup.BuildListTenderGroup (LstTenderGroup);

  LstTenderClass := TLstTenderClass.Create;
  DmdFpnTenderGroup.BuildListTenderClass (LstTenderClass);

(** KRG ** )
  ObjVerkTotCA := TObjVerkTotCA.Create (CIFNVerkTot);
  ObjVerkTotCA.Prepare (CIFNVerkTot);

  ObjOperator := TObjOperator.Create (CIFNOperator);
  ObjOperator.Prepare (CIFNOperator);
(** KRG **)
  FrmVSRptTndCountCA := TFrmVSRptTndCountCA.Create (Self);
end;   // of TFrmDetTndReprint.Initialize

//=============================================================================
// TFrmDetTndReprint.UnInitialize : Free's all the create objects
//=============================================================================

procedure TFrmDetTndReprint.UnInitialize;
begin  // of TFrmDetTndReprint.UnInitialize
  FrmVSRptTndCountCA.Free;
(** KRG ** )
  ObjOperator.Free;
  ObjOperator := nil;

  ObjVerkTotCA.Free;
  ObjVerkTotCA := nil;
(** KRG **)
  LstTenderClass.ClearTenderClasses;
  LstTenderClass.Free;
  LstTenderClass := nil;

  LstTenderGroup.ClearTenderGroups;
  LstTenderGroup.Free;
  LstTenderGroup := nil;

  LstSafeTransaction.ClearSafeTransactions;
  LstSafeTransaction.Free;
  LstSafeTransaction := nil;
end;   // of TFrmDetTndReprint.UnInitialize

//=============================================================================
// TFrmDetTndReprint.AddVerkTot : Adds the info from VerkTot to the global list
//                                  -----
// INPUT   : IdtOperator = Which operator do we have to get the cumul
//           IdtSafeTransaction = (default = 0) To which IdtSafeTransaction do
//                                we have to add a new entry?
//                                Default is used when no transactions exist yet
//=============================================================================

procedure TFrmDetTndReprint.AddVerkTot (    IdtOperator        : string;
                                        var IdtSafeTransaction : Integer);
var
  ObjSafeTransaction : TObjSafeTransaction;  // Safetransaction to add
                                             // theoretic results
begin  // of TFrmDetTndReprint.AddVerkTot
  ObjSafeTransaction := LstSafeTransaction.AddSafeTransaction
                                                       (IdtSafeTransaction,
                                                        0,
                                                        CtCodSttDrawerCashdesk,
                                                        CtCodDbsNew);
  with ObjSafeTransaction do begin
    DatReg          := Now;
    CodReason       := CtCodStrCount;
    IdtOperator     := IdtOperator;
    IdtOperReg      := IdtOperator;
    IdtCurrency     := DmdFpnUtils.IdtCurrencyMain;
    ValExchange     := DmdFpnUtils.ValExchangeCurrencyMain;
    FlgExchMultiply := DmdFpnUtils.FlgExchMultiplyCurrencyMain;
  end;

  if not Assigned (ObjSalesTotals) then
    ObjSalesTotals := TObjSalesTotals.Create;

  try
    ObjSalesTotals.IdtOperator := IdtOperator;
    ObjSalesTotals.BuildListTransDetail(LstTenderGroup,
                                      LstTenderClass,
                                      ObjSafeTransaction,
                                      LstSafeTransaction.LstTransDetail);
  finally
    ObjSalesTotals.Free;
    ObjSalesTotals := nil;
  end;


  ObjSafeTransaction := LstSafeTransaction.AddSafeTransaction
                                                       (IdtSafeTransaction,
                                                        0,
                                                        CtCodSttFinalCount,
                                                        CtCodDbsNew);
  with ObjSafeTransaction do begin
    DatReg          := Now;
    CodReason       := CtCodStrCount;
    IdtOperator     := IdtOperator;
    IdtOperReg      := IdtOperator;
    IdtCurrency     := DmdFpnUtils.IdtCurrencyMain;
    ValExchange     := DmdFpnUtils.ValExchangeCurrencyMain;
    FlgExchMultiply := DmdFpnUtils.FlgExchMultiplyCurrencyMain;
  end;
end;   // of TFrmDetTndReprint.AddVerkTot

//=============================================================================
// TFrmDetTndReprint.PrintRapport : Common procedure to generate and print
// the count rapport.
//                              -----------------
// INPUT : - TxtRegFor     : Ident of the operator to registrate for.
//         - TxtNameRegFor : Name of the operator to registrate for.
//=============================================================================

procedure TFrmDetTndReprint.PrintRapport (TxtRegFor     : string;
                                          TxtNameOperator : string;
                                          IdtSafeTrans  : Integer;
                                          TxtPckDate       : string);
begin  // of TFrmDetTndReprint.PrintRapport
  if LstSafeTransaction.Count > 0 then begin
    // Adjust settings
    with FrmVSRptTndCountCA do begin
      CodRunFunc         := CtCodFuncCount;
      NumSeqSafeTrans    := 0;
      IdtSafeTransaction := IdtSafeTrans;
      IdtRegFor          := TxtRegFor;
      TxtNameRegFor      := TxtNameOperator;
      TxtDate            := TxtPckDate;
      FlgReprint         := True;

      GenerateReport;

      // Show the report
      if FlgPreview then
        FrmVSRptTndCountCA.ShowModal
      else
        VspPreview.PrintDoc (False, null, null);
    end;   // of FrmVSRptTndCountRePrintCA
  end;   // of if LstSafeTransaction.Count > 0
end;   // of TFrmDetTndReprint.PrintRapport

//=============================================================================

procedure TFrmDetTndReprint.Execute;
var
  CntChkLstBx      : Integer;          // Loop all items in CheckListBox
  CntSafeTrans     : Integer;          // Loop all safetransactions for operator
  IdtSafeTrans     : Integer;          // Number of the safetransaction
  IdtOperator      : string;           // Holds the operator identifier
  TmpOperator      : string;           // Holds the temp operator
  LstTransOperator : TList;            // Available IdtTransactions for operator
  HasFinalCount    : Boolean;          // Has there been a final count?
  FlgVerkTotAdded  : Boolean;          // Is verktot added to the rapport
  NumFinalCount    : Integer;          // Index of final count
  NameOperator     : string;           // Name of the registrating operator
begin  // of TFrmDetTndReprint.Execute
  Initialize;
  LstTransOperator := TList.Create;
  // Loop all operators
  for CntChkLstBx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntChkLstBx] then begin
      FrmVSRptTndCountCA.FlgSavCard := FlgSavCard;
      FrmVSRptTndCountCA.FlgAutoRem := FlgAutoRem;
      // Get the operator from checklistbox
      TmpOperator := ChkLbxOperator.Items.Strings [CntChkLstBx];
      IdtOperator := Trim (Copy (TmpOperator, 1, AnsiPos (':', TmpOperator) - 1));
      NameOperator := Trim (Copy (TmpOperator, AnsiPos (':', TmpOperator) + 1,
                      length(TmpOperator) - AnsiPos(':', TmpOperator)));

      // Get all safetransactions for specified operator (if any)
      LstTransOperator.Clear;
      GetTransactionsForOperator (IdtOperator, LstTransOperator);

      FlgVerkTotAdded := False;
      // Loop all safetransactions for specified operator /date and print
      // a report
      for CntSafeTrans := 0 to Pred (LstTransOperator.Count) do begin
        IdtSafeTrans := (Integer(LstTransOperator[CntSafeTrans]));

        // Build the safetransaction list for specified transaction
        DmdFpnSafeTransaction.BuildListSafeTransactionAndDetail (
                                      LstSafeTransaction,
                                      IdtSafeTrans);
        // Check for final count
        NumFinalCount := LstSafeTransaction.IndexOfIdtAndType
                                                   (IdtSafeTrans,
                                                    CtCodSttFinalCount);
        HasFinalCount := NumFinalCount >= 0;
        if HasFinalCount then begin
          try
            DmdFpnUtils.QueryInfo
              ('SELECT * FROM Pochette ' +
               'WHERE IdtSafetransaction = ' +
                  IntToStr (LstSafeTransaction.SafeTransaction[NumFinalCount].
                                                            IdtSafeTransaction) +
               '  AND NumSeq = ' +
               IntToStr (LstSafeTransaction.SafeTransaction[NumFinalCount].NumSeq));
            TLstSafeTransactionCA (LstSafeTransaction).LstBag.
                                                 FillFromDB (DmdFpnUtils.QryInfo);
          finally
            DmdFpnUtils.CloseInfo;
          end;
        end;

        if (CntSafeTrans = Pred (LstTransOperator.Count)) and
            not HasFinalCount then begin
          AddVerkTot (IdtOperator, IdtSafeTrans);
          FlgVerkTotAdded := True;
        end;

        PrintRapport (
            IntToStr (Integer (ChkLbxOperator.Items.Objects[CntChkLstBx])),
            NameOperator,
            IdtSafeTrans,
            TxtPckDate);
        LstSafeTransaction.ClearSafeTransactions;
        TLstSafeTransactionCA (LstSafeTransaction).LstBag.ClearBags;
      end; // Ends transaction loop

      // if the verktot result aren't added, make a extra report with theze
      // results
      if not FlgVerkTotAdded then begin
        IdtSafeTrans := DmdFpnSafeTransactionOprCA.RetrieveRunningSafeTransOperator (IdtOperator);
        // Build the safetransaction list for specified transaction
        LstSafeTransaction.ClearSafeTransactions;
        DmdFpnSafeTransaction.BuildListSafeTransactionAndDetail (
                                      LstSafeTransaction,
                                      IdtSafeTrans);
        AddVerkTot (IdtOperator, IdtSafeTrans);
        PrintRapport (
            IntToStr (Integer (ChkLbxOperator.Items.Objects[CntChkLstBx])),
            NameOperator,
            IdtSafeTrans,
            TxtPckDate);
        LstSafeTransaction.ClearSafeTransactions;
      end;   // of if not FlgVerkTotAdded

      // Change checkbox
      ChkLbxOperator.State [CntChkLstBx] := cbGrayed;

    end; // Ends if operator selected
  end; // Ends operator loop

  LstTransOperator.Free;
  UnInitialize;
end;   // of TFrmDetTndReprint.Execute

//=============================================================================

procedure TFrmDetTndReprint.FormCreate(Sender: TObject);
var
  TxtCurrDir       : string;
begin  // of TFrmDetTndReprint.FormCreate
  inherited;

  TxtCurrDir := ReplaceEnvVar (CtTxtEnvVarStartDir);
  CIFNVerkTot := ReplaceTxt (CIFNVerkTot, TxtCurrDir,
                             DmdFpnWorkStatCA.GetServer);
end;   // of TFrmDetTndReprint.FormCreate

//=============================================================================

procedure TFrmDetTndReprint.DtmPckDayExit(Sender: TObject);
begin
  inherited;
  TxtPckDate :=  FormatDateTime (ViTxtDBDatFormat, DtmPckDay.Date);
end;

//=============================================================================

procedure TFrmDetTndReprint.BeforeCheckRunParams;
var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
begin  // of TFrmDetTndReprint.BeforeCheckRunParams
  inherited;
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  SplitString (CtPrmSavingCard, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString (CtPrmAutoremise, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);

end;   // of TFrmDetTndReprint.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetTndReprint.CheckAppDependParams (TxtParam : string);
begin  // of TFrmDetTndReprint.CheckAppDependParams
 if (Length (TxtParam) > 2) and (TxtParam[1] = '/') and
    (UpCase (TxtParam[2]) = 'V') then begin
   if AnsiUpperCase (Copy (TxtParam, 3, 2)) = 'SC' then
     FlgSavCard := True
   else if AnsiUpperCase (Copy (TxtParam, 3, 2)) = 'AR' then
     FlgAutoRem := True
   else
     inherited;
  end
  else
    inherited;
end;   // of TFrmDetTndReprint.CheckAppDependParams

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.   // of FDetTndReprint


