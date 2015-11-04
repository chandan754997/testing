//=========== Sycron Computers Belgium (c) 2001 ===============================
// Packet   : FlexPoint 2.0 Development
// Customer : Castorama
// Unit     : FLmsCtlCashDeskCa : MultiSelList Controle CashDesk
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLmsCtlCashDeskCa.pas,v 1.1 2006/12/21 13:59:38 hofmansb Exp $
//=============================================================================

unit FLmsCtlCashDeskCa;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sflistmultisel_BDE_DBC, Menus, ExtCtrls, Db, OvcBase, ComCtrls, OvcEF, OvcPB,
  OvcPF, ScUtils, StdCtrls, Buttons, Grids, DBGrids, ScEHdler, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx;

//=============================================================================
// Global type definitions
//=============================================================================

type
  TCodExecCa = (exeUndefinedCa,                // undefined execution for Ca
                exeItemForCorrection);         // Execution for correcting
                                               // an item for correction from
                                               // table Log_Controle_Caisse

//-----------------------------------------------------------------------------

type
  TFrmLmsCtlCashDeskCa = class(TFrmListMultiSel)
    mniSepLogFile: TMenuItem;
    mniShowLogFile: TMenuItem;
    procedure MniRecExecSelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure mniShowLogFileClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FCodExecCa     : TCodExecCa;
  protected
    { Protected declarations }
    procedure DeleteSelection (ValUpTo : Integer); virtual;
    function  GetNameSelectiontable : string; override;
    procedure ExecSelItemForCorrection (Sender : TObject); virtual;

    procedure SetCodExecuteCa (Value : TCodExecCa); virtual;
  public
    { Public declarations }
  published
    { Published declarations }
    property CodExecCa : TCodExecCa read FCodExecCa write SetCodExecuteCa;
  end;  // of TFrmLmsCtlCashDeskCa

var
  FrmLmsCtlCashDeskCa: TFrmLmsCtlCashDeskCa;

//*****************************************************************************

implementation

uses
  DbTables,
  Printers,

  SfDialog,
  SfVsPrinter7,
  SmUtils,
  ScTskMgr_BDE_DBC,

  SrStnCom,

  DFpnCtlCashDeskCa;

{$R *.DFM}

resourcestring
  CtTxtCorrectingItems   = 'Correcting Items (%d/%d) ...';
  CtTxtRefreshingDataset = 'Refreshing dataset ...';
  CtTxtCorrection        = 'Correction';

  CtTxtApplicationStart  = 'Application started';
  CtTxtApplicationEnd    = 'Application ended';
  CtTxtErrorLine1        = 'There have been %d error(s)';
  CtTxtErrorLine2        = 'Please check the logfile (Help\Consult Logfile...)';
  CtTxtErrorLine3        = 'Or contact the helpdesk.';

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName  = 'FLmsCtlCashDeskCa';

const  // PVCS-keywords
  CtTxtSrcName     = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLmsCtlCashDeskCa.pas,v $';
  CtTxtSrcVersion  = '$Revision: 1.1 $';
  CtTxtSrcDate     = '$Date: 2006/12/21 13:59:38 $';

//*****************************************************************************
// Implementation of TFrmLmsCtlCashDeskCa
//*****************************************************************************

//=============================================================================
// Properties
//=============================================================================

procedure TFrmLmsCtlCashDeskCa.SetCodExecuteCa (Value : TCodExecCa);
begin  // of TFrmLmsCtlCashDeskCa.SetCodExecuteCa
  FCodExecCa := Value;

  if Value = exeItemForCorrection then
    MniRecExecSel.OnClick := ExecSelItemForCorrection;
end;   // of TFrmLmsCtlCashDeskCa.SetCodExecuteCa

//=============================================================================
// Methods
//=============================================================================

procedure TFrmLmsCtlCashDeskCa.DeleteSelection (ValUpTo : Integer);
var
  CntSel           : Integer; // Counter selected
begin  // of TFrmLmsCtlCashDeskCa.DeleteSelection
  if ValUpTo > (StrLstSelIdt.Count) then
    ValUpTo := StrLstSelIdt.Count;
  for CntSel := ValUpTo - 1 downto 0 do begin
    StrLstSelIdt.Delete (CntSel);
  end;
  AdjustQtySelected;
end;   // of TFrmLmsCtlCashDeskCa.DeleteSelection

//=============================================================================

function TFrmLmsCtlCashDeskCa.GetNameSelectiontable : string;
begin  // of TFrmLmsCtlCashDeskCa.GetNameSelectiontable
  case CodExecCa of
    exeItemForCorrection : Result := '#ItemForCorr';
  else
    Result := inherited GetNameSelectionTable;
  end;
end;   // of TFrmLmsCtlCashDeskCa.GetNameSelectiontable

//=============================================================================

procedure TFrmLmsCtlCashDeskCa.ExecSelItemForCorrection (Sender : TObject);
var
  SprLoad          : TStoredProc;
  TxtErrMsg,
  TxtSprErrMsg     : string;
  CntCorrect       : Integer; // number of items corrected
  CntErrors        : Integer;
begin  // of TFrmLmsCtlCashDeskCa.ExecSelItemForCorrection
  SprLoad := DmdFpnCtlCashDeskCa.SprLoadLogControleCaisse;

  if StrLstSelIdt.Count = 0 then
    raise EAbort.Create ('No data');

  InsertSelection;

  DmdFpnCtlCashDeskCa.GetSelItemForCorrection (NameSelectionTable);
  DmdFpnCtlCashDeskCa.QryLmsItemCorrect.Active := True;

  try
    PnlProgress.Visible  := True;
    BtnPgsCancel.Enabled := True;
    BtnPgsCancel.SetFocus;

    PgsBarProc.Max      := StrLstSelIdt.Count;
    PgsBarProc.Position := 0;

    CntCorrect := 0;
    CntErrors  := 0;

    DmdFpnCtlCashDeskCa.QryLmsItemCorrect.First;
    while not DmdFpnCtlCashDeskCa.QryLmsItemCorrect.EOF and FlgInProcess do
    begin
      StsBarList.Panels[2].Text := Format (CtTxtCorrectingItems,
                                           [CntCorrect,StrLstSelIdt.Count]);
      with DmdFpnCtlCashDeskCa.QryLmsItemCorrect do begin
        DmdFpnCtlCashDeskCa.FillPrmsStoredProc
         (FieldByName ('IdtArticle').AsString,
          FieldByName ('NumPLU').AsString,
          FieldByName ('CodType').AsInteger);
      end; // of with DmdFpnCtlCashDeskCa.QryLmsItemCorrect

      try
        TxtErrMsg := '';
        TxtSprErrMsg := '';
        SprLoad.Prepare;
        SprLoad.ExecProc;
      except
        on E:Exception do begin
          SprLoad.ParamByName ('@PrmNumLoaded').AsInteger := 0;
          TxtErrMsg := E.Message;
        end;
      end;  // try
      Application.ProcessMessages;

      TxtSprErrMsg :=
        Trim (SprLoad.ParamByName ('@PrmTxtMessage').AsString);

      // Check if record is loaded
      if (TxtSprErrMsg <> '') then begin
        SvcExceptHandler.LogMessage (CtChrLogInfo,
          SvcExceptHandler.BuildLogMessage (CtNumErrorMin,
                                            [TxtSprErrMsg]));
        inc(CntErrors);
      end;

      if (TxtErrMsg <> '') then begin
        SvcExceptHandler.LogMessage (CtChrLogInfo,
          SvcExceptHandler.BuildLogMessage (CtNumErrorMin,
                                            [TxtErrMsg]));
        inc (CntErrors);
      end;

      PgsBarProc.StepIt;
      inc(CntCorrect);

      // Retrieve next record
      DmdFpnCtlCashDeskCa.QryLmsItemCorrect.Next;
    end;  // of while not DmdFpnCtlCashDeskCa.QryLmsItemCorrect.EOF

    DeleteSelection (CntCorrect);

    if CntErrors > 0 then begin
      ShowMessage (Format(CtTxtErrorLine1,[CntErrors]) + #13#10 +
                   CtTxtErrorLine2 + #13#10 +
                   CtTxtErrorLine3);
    end;
  finally
    PnlProgress.Visible := False;
    StsBarList.Panels[2].Text := CtTxtRefreshingDataset;
    Application.ProcessMessages;

    // Refresh the dataset...
    if Assigned (BtnSeqRefresh.OnClick) then
      BtnSeqRefresh.OnClick (Sender);

    StsBarList.Panels[2].Text := '';
    DmdFpnCtlCashDeskCa.QryLmsItemCorrect.Active := False;
    try
      DropSelectionTable;
    except
      // sometimes the table is already dropped when we come here...
      // why???
    end;
  end;  // of try ... finally
end;   // of TFrmLmsCtlCashDeskCa.ExecSelItemForCorrection

//=============================================================================

procedure TFrmLmsCtlCashDeskCa.MniRecExecSelClick(Sender: TObject);
begin  // of TFrmLmsCtlCashDeskCa.MniRecExecSelClick
  // PDD - temporary solution - property doesn't reassign the OnClick correctly
  if codExecCa = exeItemForCorrection then
    ExecSelItemForCorrection(Sender)
  else
    inherited;
end;   // of TFrmLmsCtlCashDeskCa.MniRecExecSelClick

//=============================================================================

procedure TFrmLmsCtlCashDeskCa.FormActivate(Sender: TObject);
begin  // of TFrmLmsCtlCashDeskCa.FormActivate
  TxtSelectMaster := CtTxtCorrection;
  inherited;

  SvcExceptHandler.LogMessage (CtChrLogInfo,
    SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtApplicationStart]));
end;   // of TFrmLmsCtlCashDeskCa.FormActivate

//=============================================================================

procedure TFrmLmsCtlCashDeskCa.mniShowLogFileClick(Sender: TObject);
begin  // of TFrmLmsCtlCashDeskCa.mniShowLogFileClick
  inherited;
  try
    PreviewFileParams (SvcExceptHandler.FileNameCurrentLog,
                       Application.Title + ' - ' + MniShowLogfile.Caption,
                       poLandscape);
  except
    Application.HandleException (Self);
    MniShowLogfile.Visible := False;
    MniSepLogfile.Visible  := False;
  end;
end;   // of TFrmLmsCtlCashDeskCa.mniShowLogFileClick

//=============================================================================

procedure TFrmLmsCtlCashDeskCa.FormDestroy(Sender: TObject);
begin  // of TFrmLmsCtlCashDeskCa.FormDestroy
  SvcExceptHandler.LogMessage (CtChrLogInfo,
    SvcExceptHandler.BuildLogMessage (CtNumInfoMin,
                                      [CtTxtApplicationEnd]));
  inherited;
end;  // of TFrmLmsCtlCashDeskCa.FormDestroy

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
