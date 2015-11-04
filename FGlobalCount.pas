//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : Flexpoint Development
// Unit     : FGlobalCount
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FGlobalCount.pas,v 1.7 2009/09/22 10:30:41 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FGlobalCount - CVS revision 1.9
// Version ModifiedBy Reason
// 2.0     SC. (TCS)  R2012.1--CAFR-suppression mention cheque kdo
//=============================================================================
// Version          ModifiedBy             Reason
// V 2.1           Teesta (TCS)           R2012.1 - CAFR - Nouveau_moyen_de_paiement

unit FGlobalCount;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, ComCtrls, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, ScUtils, ScDBUtil_BDE;

//=============================================================================
// Resource strings
//=============================================================================

resourcestring     // for runparameters of the document.
 CtPrmNoName   = '/VNN=Do not show operator name on report';
 CtPrmSavingCard = '/VSC=Show Saving Card on report';
 CtTxtRemoveChequeKDO       = '/VRCK=Deletion of Castorama gift cheques';    //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
resourcestring
  CtTxtDeleted               = '(Deleted)';
  CtTxtReqCountReport        = 'Please select count report';
  CtTxtAllReports            = 'All global count reports';
  CtTxtCountRepForDepartment = 'Global count report for department';
  CtPrmAutoremise            = '/VAR=Show remises auto promopack on report';

//*****************************************************************************
// Global definitions
//*****************************************************************************

type
  TFrmGlobalCount = class(TFrmAutoRun)
    DtmPckExecution: TDateTimePicker;
    SvcDBLblExecutionDate: TSvcDBLabelLoaded;
    SvcDBLblCountReport: TSvcDBLabelLoaded;
    CbxCountReports: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  protected
    FlgNoName   : Boolean;          // Select No name.
    FlgSavCard  : Boolean;          // Select Saving Card.
    FlgAutoRem  : Boolean;          // Show Auto Remise
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure CreateTenderGroupLists; virtual;
    function GetAllIdtOperators : string; virtual;
    function GetAllTxtOperators : string; virtual;

    procedure Initialize;
    procedure UnInitialize;
    procedure AddVerkTot (    IdtOperator        : string;
                          var IdtSafeTransaction : Integer);

    procedure AutoStart (Sender : TObject); override;
  public
    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;

    procedure CheckExecAllowed; override;
    procedure Execute; override;
  end;  // of TFrmGlobalCount

var
  FrmGlobalCount: TFrmGlobalCount;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SmUtils,
  SmDbUtil_BDE,

  SfDialog,
  SrStnCom,

  DFpnTender,
  DFpnOperator,
  DFpnTenderGroup,
  DFpnSafeTransaction,
  DFpnSafeTransactionCA,

  Operator,
  KasResul,
  FVSRptTndCountCA,
  MFpsFileOperation,
  MFpsFileOperationCA,

  FVSRptTndGlobalCountCA, DFpnWorkStatCA, DFpnUtils, DFpnDepartment,
  DFpnTenderGroupCA;              //R2012.1--CAFR-suppression mention cheque kdo                                    

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FGlobalCount';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FGlobalCount.pas,v $';
  CtTxtSrcVersion = '$Revision: 2.1 $';
  CtTxtSrcDate    = '$Date: 2009/09/22 10:30:41 $';

//*****************************************************************************
// Implementation of TFrmGlobalCount
//*****************************************************************************

//=============================================================================
// TFrmGlobalCount.CreateTenderGroupLists : creates and loads from database
// the lists with TenderGroup, TenderClass and TenderUnit, which weren't
// created yet.
//=============================================================================

procedure TFrmGlobalCount.CreateTenderGroupLists;
begin  // of TFrmGlobalCount.CreateTenderGroupLists
  if not Assigned (LstTenderGroup) then
    LstTenderGroup := TLstTenderGroup.Create;
  //if FlgRemoveChequeKDO then                                          //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
   DmdFpnTenderGroupCA.BuildListTenderGroupActive(LstTenderGroup);      //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
  //else
  // DmdFpnTenderGroup.BuildListTenderGroup (LstTenderGroup);

  if not Assigned (LstTenderClass) then
    LstTenderClass := TLstTenderClass.Create;
  DmdFpnTenderGroup.BuildListTenderClass (LstTenderClass);

  if not Assigned (LstTenderUnit) then
    LstTenderUnit := TLstTenderUnit.Create;
  DmdFpnTenderGroup.BuildListTenderUnit (LstTenderUnit);
end;   // of TFrmGlobalCount.CreateTenderGroupLists

//=============================================================================
// TFrmGlobalCount.GetAllIdtOperators : Get a list of all IdtOperators that are
// found in the safetransactions
//                                ----------------
// FUNCRES    : Returns a string with all the operators found in the
//              SafeTransaction
//=============================================================================

function TFrmGlobalCount.GetAllIdtOperators : string;
var
  StrLstIdtOper    : TStringList;      // All operators in the SafeTransaction
  CntSafeTrans     : Integer;          // Loop all the SafeTransaction
  TxtSeperator     : string;           // Seperator between operators
begin  // of TFrmGlobalCount.GetAllIdtOperators
  StrLstIdtOper := TStringList.Create;
  try
    Result := '';
    StrLstIdtOper.Sorted := True;
    StrLstIdtOper.Duplicates := dupIgnore;
    for CntSafeTrans := 0 to Pred (LstSafeTransaction.Count) do
      StrLstIdtOper.Add
          (LstSafeTransaction.SafeTransaction [CntSafeTrans].IdtOperator);
    TxtSeperator := '';
    for CntSafeTrans := 0 to Pred (StrLstIdtOper.Count) do begin
      if StrLstIdtOper [CntSafeTrans] <> '' then begin
        Result := Result + TxtSeperator + StrLstIdtOper [CntSafeTrans];
        TxtSeperator := ', ';
      end;
    end;
  finally
    StrLstIdtOper.Free;
  end;
end;   // of TFrmGlobalCount.GetAllIdtOperators

//=============================================================================

procedure TFrmGlobalCount.Initialize;
begin  // of TFrmGlobalCount.Initialize
  CreateTenderGroupLists;

  // Clear LstSafeTransaction
  if not Assigned (LstSafeTransaction) then
    LstSafeTransaction := TLstSafeTransactionCA.Create
  else
    LstSafeTransaction.ClearSafeTransactions;

  ObjVerkTotCA := TObjVerkTotCA.Create (CIFNVerkTot);
  ObjVerkTotCA.Prepare (CIFNVerkTot);

  ObjOperator := TObjOperator.Create (CIFNOperator);
  ObjOperator.Prepare (CIFNOperator);

  FrmVSRptTndGlobalCountCA := TFrmVSRptTndGlobalCountCA.Create (Self);
end;   // of TFrmGlobalCount.Initialize

//=============================================================================

procedure TFrmGlobalCount.UnInitialize;
begin  // of TFrmGlobalCount.UnInitialize
  FrmVSRptTndGlobalCountCA.Free;

  ObjOperator.Free;
  ObjOperator := nil;

  ObjVerkTotCA.Free;
  ObjVerkTotCA := nil;

  LstTenderClass.ClearTenderClasses;
  LstTenderClass.Free;
  LstTenderClass := nil;

  LstTenderGroup.ClearTenderGroups;
  LstTenderGroup.Free;
  LstTenderGroup := nil;

  LstSafeTransaction.ClearSafeTransactions;
  LstSafeTransaction.Free;
  LstSafeTransaction := nil;
end;   // of TFrmGlobalCount.UnInitialize

//=============================================================================

procedure TFrmGlobalCount.AddVerkTot (    IdtOperator        : string;
                                      var IdtSafeTransaction : Integer);
var
  ObjSafeTransaction : TObjSafeTransaction;  // Safetransaction to add
                                             // theoretic results
begin  // of TFrmGlobalCount.AddVerkTot
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

  ObjVerkTotCA.CumulOperator (DmdFpnOperator.InfoOperator[IdtOperator,
                                                          'IdtPos']);

  ObjVerkTotCA.BuildListTransDetail(LstTenderGroup,
                                    LstTenderClass,
                                    ObjSafeTransaction,
                                    LstSafeTransaction.LstTransDetail);

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
end;   // of TFrmGlobalCount.AddVerkTot

//=============================================================================
// TFrmGlobalCount.GetAllTxtOperators : Get a list of all TxtOperators that are
// found in the safetransactions
//                                ----------------
// FUNCRES    : Returns a string with all the operators found in the
//              SafeTransaction
//=============================================================================

function TFrmGlobalCount.GetAllTxtOperators : string;
var
  StrLstIdtOper    : TStringList;      // All operators in the SafeTransaction
  CntSafeTrans     : Integer;          // Loop all the SafeTransaction
  TxtSeperator     : string;           // Seperator between operators
begin  // of TFrmGlobalCount.GetAllTxtOperators
  Result := '';
  StrLstIdtOper := TStringList.Create;
  try
    StrLstIdtOper.Sorted := True;
    StrLstIdtOper.Duplicates := dupIgnore;
    for CntSafeTrans := 0 to Pred (LstSafeTransaction.Count) do
      StrLstIdtOper.Add
          (LstSafeTransaction.SafeTransaction [CntSafeTrans].IdtOperator);
    TxtSeperator := '';
    for CntSafeTrans := 0 to Pred (StrLstIdtOper.Count) do begin
      if StrLstIdtOper [CntSafeTrans] <> '' then begin
        try
          Result := Result + TxtSeperator +
               DmdFpnOperator.InfoOperator[StrLstIdtOper [CntSafeTrans], 'TxtName'];
          TxtSeperator := ', ';
        except
          Result := Result + TxtSeperator + StrLstIdtOper [CntSafeTrans] + ' ' +
                    CtTxtDeleted;
          TxtSeperator := ', ';
        end;
      end;
    end;
  finally
    StrLstIdtOper.Free;
  end;
end;   // of TFrmGlobalCount.GetAllTxtOperators

//=============================================================================

procedure TFrmGlobalCount.AutoStart (Sender: TObject);
begin  // of TFrmGlobalCount.AutoStart
  if Application.Terminated then
    Exit;

  inherited;

  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;   // of TFrmGlobalCount.AutoStart

//=============================================================================

constructor TFrmGlobalCount.Create (AOwner : TComponent);
begin  // of TFrmGlobalCount.Create
  inherited;
  DtmPckExecution.Date := Date;
end;   // of TFrmGlobalCount.Create

//=============================================================================

procedure TFrmGlobalCount.Execute;
var
  IdtDepartment    : Integer;
  FlgAllReports    : Boolean;
begin  // of TFrmGlobalCount.Execute
  Initialize;
  if DmdFpnDepartment.NumDepartments > 1 then
    IdtDepartment := CbxCountReports.ItemIndex
  else
    IdtDepartment := -1;
  if IdtDepartment = 0 then
    FlgAllReports := True
  else
    FlgAllReports := False;
  repeat
    DmdFpnSafeTransactionCA.DatExecution := DtmPckExecution.Date;
    DmdFpnSafeTransactionCA.IdtDepartment := IdtDepartment;
    LstSafeTransaction.ClearSafeTransactions;    
    DmdFpnSafeTransactionCA.BuildListSafeTransAndDetailTotalReport
        (LstSafeTransaction);
    FrmVSRptTndGlobalCountCA.FlgNoName := FlgNoName;
    FrmVSRptTndGlobalCountCA.FlgSavCard := FlgSavCard;
    FrmVSRptTndGlobalCountCA.FlgAutoRem := FlgAutoRem;
    FrmVSRptTndGlobalCountCA.IdtRegFor := GetAllIdtOperators;
    FrmVSRptTndGlobalCountCA.TxtNameRegFor := GetAllTxtOperators;
    FrmVSRptTndGlobalCountCA.CodRunFunc := CtCodFuncCount;
    FrmVSRptTndGlobalCountCA.TxtDate := FormatDateTime (ViTxtDBDatFormat,
                                                        DtmPckExecution.Date);
    FrmVSRptTndGlobalCountCA.IdtDepartment := IdtDepartment;
    FrmVSRptTndGlobalCountCA.NumDepartments := DmdFpnDepartment.NumDepartments;

    FrmVSRptTndGlobalCountCA.GenerateReport;
    FrmVSRptTndGlobalCountCA.ShowModal;
    if FlgAllReports then
      IdtDepartment := IdtDepartment + 1;
  until ((FlgAllReports and (IdtDepartment > DmdFpnDepartment.NumDepartments))
  or not (FlgAllReports));
  UnInitialize;
end;   // of TFrmGlobalCount.Execute

//=============================================================================

procedure TFrmGlobalCount.FormCreate(Sender: TObject);
var
  TxtCurrDir       : string;
begin  // of TFrmGlobalCount.FormCreate
  inherited;
  TxtCurrDir  := ReplaceEnvVar (CtTxtEnvVarStartDir);
  CIFNVerkTot := ReplaceTxt (CIFNVerkTot, TxtCurrDir,DmdFpnWorkStatCA.GetServer);
end;   // of TFrmGlobalCount.FormCreate

//=============================================================================

procedure TFrmGlobalCount.FormActivate(Sender: TObject);
var
  NumDepartments   : integer;
  Cnt              : integer;  //count for loop
begin  // of TFrmGlobalCount.FormActivate
  inherited;
  NumDepartments := DmdFpnDepartment.NumDepartments;
  if NumDepartments > 1 then begin
    // opvullen combobox
    CbxCountReports.Items.Clear;
    CbxCountReports.Items.Add (CtTxtAllReports);
    for Cnt := 1 to NumDepartments do begin
      CbxCountReports.Items.Add (CtTxtCountRepForDepartment + ' ' +
                                                                IntToStr(Cnt));
    end;
    SvcDBLblCountReport.Visible := True;
    CbxCountReports.Visible := True;
    CbxCountReports.ItemIndex := 0;
  end
  else begin
    SvcDBLblCountReport.Visible := False;
    CbxCountReports.Visible := False;
  end;
end;   // of TFrmGlobalCount.FormActivate

//=============================================================================

procedure TFrmGlobalCount.CheckExecAllowed;
begin  // of TFrmGlobalCount.CheckExecAllowed
  // Check if execution date is valid
  if (DtmPckExecution.Date >= (Date + 1)) then begin
    DtmPckExecution.Date := Date;
    raise Exception.Create
      (Format (CtTxtLess, [TrimTrailColon (SvcDBLblExecutionDate.Caption),
                           DateToStr(Date+1)]));
  end;
  if (DmdFpnDepartment.NumDepartments > 1) and not(ViFlgAutom) then begin
    if CbxCountReports.ItemIndex = -1 then
      raise Exception.Create (CtTxtReqCountReport);
  end;
end;   // of TFrmGlobalCount.CheckExecAllowed

//=============================================================================

procedure TFrmGlobalCount.BeforeCheckRunParams;
var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
begin  // of TFrmGlobalCount.BeforeCheckRunParams
  inherited;
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  SplitString (CtPrmNoName, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString (CtPrmSavingCard, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString (CtPrmAutoremise, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmGlobalCount.BeforeCheckRunParams

//=============================================================================

procedure TFrmGlobalCount.CheckAppDependParams (TxtParam : string);
begin  // of TFrmGlobalCount.CheckAppDependParams
  if (Length (TxtParam) > 2) and (TxtParam[1] = '/') and
   (UpCase (TxtParam[2]) = 'V') then begin
    if AnsiUpperCase (Copy (TxtParam, 3, 2)) = 'NN' then
      FlgNoName := True
    else if (Length (TxtParam) > 2) and (TxtParam[1] = '/') and
      (UpCase (TxtParam[2]) = 'V') then begin
       if AnsiUpperCase (Copy (TxtParam, 3, 2)) = 'SC' then
         FlgSavCard := True
       else if AnsiUpperCase (Copy (TxtParam, 3, 2)) = 'AR' then
         FlgAutoRem := True
       else
         inherited;
      end;
  end
  else
    inherited;
end;   // of TFrmGlobalCount.CheckAppDependParams

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FGlobalCount

