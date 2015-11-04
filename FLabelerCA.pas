//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FLabelerCA.PAS : Form LABELER CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLabelerCA.pas,v 1.3 2007/04/27 12:37:37 goegebkr Exp $
// History:
//=============================================================================

unit FLabelerCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FLabeler, ScTskMgr_BDE_DBC, StdCtrls, Buttons;

//*****************************************************************************
// Global identifiers
//*****************************************************************************

//=============================================================================
// TFrmLabelerCA
//=============================================================================

type
  TFrmLabelerCA = class(TFrmLabeler)
    procedure FormCreate(Sender: TObject);
    procedure SvcTskArtFreeCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskCampaignCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskArtPrcCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskArtNewCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskCustFreeCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskCustFreeBeforeExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
  private
    { Private declarations }
  protected
    { Protected declarations }
    // Methods
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure AfterCheckRunParams; override;
    procedure ConfigTskArtBeforeExecute (SvcTskLst  : TSvcListTask;
                                         CodLblTask : Integer     ); override;
  public
    { Public declarations }
  end;

var
  FrmLabelerCA: TFrmLabelerCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,

  SmUtils,

  DFpnLabeler,
  DFpnLabelerCA,
  DFpnUtilsCA,

  FLstLabelerCA,
  RFpnCom;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLabelerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLabelerCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2007/04/27 12:37:37 $';

//*****************************************************************************
// Implementation of TFrmLabelerCA
//*****************************************************************************

//=============================================================================
// TFrmLabelerCA.BeforeCheckRunParams
//=============================================================================

procedure TFrmLabelerCA.BeforeCheckRunParams;
var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
begin  // of TFrmLabeler.BeforeCheckRunParams
  ViTxtRunPmAllow := 'VF';

  AddRunParams (CtTxtRunParamFArtNew, SvcTskArtNew.ListName);
  AddRunParams (CtTxtRunParamFArtPrc, SvcTskArtPrc.ListName);
  AddRunParams (CtTxtRunParamFCampaign, SvcTskCampaign.ListName);
  AddRunParams (CtTxtRunParamFArtFree, SvcTskArtFree.ListName);

  SplitString (CtTxtRunParamPPrint, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString (CtTxtRunParamPRePrint, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);

  SplitString (CtTxtRunParamListLabeler, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);

  SplitString (CtTxtRunParamLabelPLU, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmLabelerCA.BeforeCheckRunParams

//=============================================================================
// TFrmLabelerCA.CheckAppDependParams
//                              ------
// INPUT: TxtParam = Complete run parameter (in other words: '/' and main
//                                           letter included)
//=============================================================================

procedure TFrmLabelerCA.CheckAppDependParams (TxtParam : string);
var
  TxtPrmCheck      : string;           // Parameter to check
begin  // of TFrmLabelerCA.CheckAppDependParams
  if (Length (TxtParam) > 2) and (TxtParam[1] = '/') and
     (UpCase (TxtParam[2]) = 'V') then begin
    TxtPrmCheck := AnsiUpperCase (Copy (TxtParam, 3, Length (TxtParam)));
    if Copy (TxtPrmCheck, 1, 2) = 'DL' then
      InvalidRunParam (TxtParam)
    else
      inherited CheckAppDependParams (TxtParam);
  end  // of TxtParam[2] = 'V'
  else
    inherited CheckAppDependParams (TxtParam);
end;   // of TFrmLabelerCA.CheckAppDependParams

//=============================================================================
// TFrmLabelerCA.AfterCheckRunParams: Placeholder to provide an inherited
// form with the possibility of checking the settings of given run parameters
//=============================================================================

procedure TFrmLabelerCA.AfterCheckRunParams;
begin  // of TFrmLabelerCA.AfterCheckRunParams
  inherited;
  if CodLabelerFunc = CtCodLtkCustFree then begin
    CodLabelerFunc := -1;
    InvalidRunParam ('/F' + ViTxtFunction);
  end;
end;   // of TFrmLabelerCA.AfterCheckRunParams

//=============================================================================
// TFrmLabelerCA.ConfigTskArtBeforeExecute : configures tasks and the executor
// for the task.
//                              ------
// INPUT: SvcTskLst = task to configure.
//        CodLblTask = code labeler task.
//=============================================================================

procedure TFrmLabelerCA.ConfigTskArtBeforeExecute (SvcTskLst  : TSvcListTask;
                                                   CodLblTask : Integer     );
var CntSeq : integer;                  // Counter sequences
begin  // of TFrmLabelerCA.ConfigTskArtBeforeExecute
  inherited;
  // Remove Sequence IdtShelf
  for CntSeq := 0 to SvcTskLst.Sequences.Count - 1 do begin
    if SvcTskLst.Sequences[CntSeq].Name = 'IdtShelf' then begin
      SvcTskLst.Sequences.Delete (CntSeq);
      break;
    end;
  end;
  // Enable Import
  TFrmLstLabelerCA (SvcTskLst.Executor).BtnImport.Enabled :=
    CodLblTask = CtCodLtkArtFree;
  TFrmLstLabelerCA (SvcTskLst.Executor).BtnImport.Visible :=
    CodLblTask = CtCodLtkArtFree;
end;   // of TFrmLabelerCA.ConfigTskArtBeforeExecute

//=============================================================================

procedure TFrmLabelerCA.SvcTskCustFreeBeforeExecute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
begin
  // Do nothing
end;

//=============================================================================

procedure TFrmLabelerCA.SvcTskCustFreeCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin
  // Do nothing
end;

//=============================================================================

procedure TFrmLabelerCA.SvcTskArtNewCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin
  NewObject := TFrmLstLabelerCA.Create (Self);
  FlgCreated := True;
end;

//=============================================================================

procedure TFrmLabelerCA.SvcTskArtPrcCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin
  NewObject := TFrmLstLabelerCA.Create (Self);
  FlgCreated := True;
end;

//=============================================================================

procedure TFrmLabelerCA.SvcTskCampaignCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin
  NewObject := TFrmLstLabelerCA.Create (Self);
  FlgCreated := True;
end;

//=============================================================================

procedure TFrmLabelerCA.SvcTskArtFreeCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin
  NewObject := TFrmLstLabelerCA.Create (Self);
  FlgCreated := True;
end;

//=============================================================================

procedure TFrmLabelerCA.FormCreate(Sender: TObject);
begin
  inherited;
  //Create Datamodules here due to problems when autocreating them
  if not Assigned (DmdFpnLabelerCA) then
    DmdFpnLabelerCA := TDmdFpnLabelerCA.Create(Self);
  if not Assigned (DmdFpnLabeler) then
    DmdFpnLabeler := DmdFpnLabelerCA;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.   // end of FLabelerCA
