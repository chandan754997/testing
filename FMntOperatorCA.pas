//=========== Sycron Computers Belgium (c) 1997 ===============================
// Packet : FlexPoint Development
// Unit   : FMntOperatorCA.PAS : MainForm MaiNTenance OPERATOR for CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntOperatorCA.pas,v 1.5 2009/10/15 14:53:21 BEL\BHofmans Exp $
// History:
// Version                              Modified By                          Reason
// V 1.6                                V.K.R (TCS)                          R2011.2 - BRES - Ficha Operator
// V 1.7                                SM (TCS)                             R2011.2 - Regression Fix DefectId#6
// V 1.8                                SM (TCS)                             R2012.1 - Security Points ID 47
// V 1.9                                AM(TCS)                              R2012.1 47.01 Security  A.M.(Modifications)
// - Started from Flexpoint 1.6 - revision 1.3
//=============================================================================

unit FMntOperatorCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FMntOperator, ScTskMgr_BDE_DBC,FLstOperatorCA;

//=============================================================================
// resourcestrings
//=============================================================================
resourcestring
  CtTxtRunParamPosFunc = 'Enable pos functions';
  CtTxtRunParamOperatorReport = 'Print Operator Report';        //Ficha Operator, VKR, R2011.2
  CtTxtRunActiveSupport = 'Enable Active Support' ;             // Security Point (SM), R2012.1
  CtTxtInsufficRights        = 'You do not have sufficient rights';  // Security Point (SM), R2012.1
  CtTxtRunParamCARUPwdSet = 'Set Default Password for CARU';         //R2012.1 47.01 Security  A.M.(Modifications)

//=============================================================================
// TFrmMntOperatorCA
//=============================================================================

type
  TFrmMntOperatorCA = class(TFrmMntOperator)
  //Ficha Operator, VKR, R2011.2 - Start
    SvcFrmFichaOperatorReport: TSvcFormTask;
    procedure SvcFrmFichaOperatorReportCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  //Ficha Operator, VKR, R2011.2 - End
     procedure SvcTskLstOperatorCreateExecutor(Sender: TObject;                         //Regression Fix (SM) R2011.2
      var NewObject: TObject; var FlgCreated: Boolean); virtual;
    procedure SvcTskDetOperatorBeforeExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
    procedure SvcTskDetOperatorCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
    FFlgPosFunc    : Boolean;
    FFlgOperatorSheet : Boolean;      // OperatorSheet Button   :Ficha Operator, VKR, R2011.2
    FFlgActiveSupport : Boolean;      // Security Point (SM) R2012.1
	  FFlgReInitialisePwd     : Boolean;       //R2012.1 47.01 Security  A.M.(Modifications)
  protected
    { Protected declarations}
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    property FlgPosFunc: boolean read FFlgPosFunc write FFlgPosFunc;
    property FlgOperatorSheet : Boolean read FFlgOperatorSheet     //Ficha Operator, VKR, R2011.2
                                        write FFlgOperatorSheet;   //Ficha Operator, VKR, R2011.2
    property FlgActiveSupport : Boolean read FFlgActiveSupport     // Security Point (SM) R2012.1
                                        write FFlgActiveSupport;
    property FlgReInitialisePwd : Boolean read FFlgReInitialisePwd     //R2012.1 47.01 Security  A.M.(Modifications)
                                        write FFlgReInitialisePwd;    //R2012.1 47.01 Security  A.M.(Modifications)
  end;

var
  FrmMntOperatorCA: TFrmMntOperatorCA;

implementation

{$R *.DFM}

uses
  SfDialog,
  SfList_BDE_DBC,
  SmUtils,
  SrStnCom,

  DFpnUtils,

  FDetOperatorCA,
  DFpnOperator,
  FVSFichaOperator;    //Ficha Operator, VKR, R2011.2

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntOperatorCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntOperatorCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.9 $';
  CtTxtSrcDate    = '$Date: 2012/05/03 14:53:21 $';

//*****************************************************************************
// Implementation of TFrmMntOperatorCA
//*****************************************************************************

procedure TFrmMntOperatorCA.BeforeCheckRunParams;
begin
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  AddRunParams ('/VPF', CtTxtRunParamPosFunc);
  AddRunParams ('/VPR', CtTxtRunParamOperatorReport);         //Ficha Operator, VKR, R2011.2
  AddRunParams ('/VAS', CtTxtRunActiveSupport);              // Security Point (SM), R2012.
  AddRunParams ('/VRU', CtTxtRunParamCARUPwdSet);           //R2012.1 47.01 Security  A.M.(Modifications)
end;

//=============================================================================

procedure TFrmMntOperatorCA.CheckAppDependParams(TxtParam: string);
begin
  if AnsiCompareText (copy(TxtParam, 3, 2), 'PF') = 0 then begin
    FlgPosFunc := True;
  end
  else if AnsiCompareText (Copy(TxtParam, 3, 2), 'PR') = 0 then          //Ficha Operator, VKR, R2011.2
    FlgOperatorSheet := True                                              //Ficha Operator, VKR, R2011.2
  else if  AnsiCompareText (Copy(TxtParam, 3, 2), 'AS') = 0 then          // Security Point (SM), R2012.1
     FFlgActiveSupport :=True
  else if AnsiCompareText (Copy(TxtParam, 3, 2), 'RU') = 0 then          //R2012.1 47.01 Security  A.M.(Modifications)
    FlgReInitialisePwd := True                                           //R2012.1 47.01 Security  A.M.(Modifications)
  else
    //FlgOperatorSheet := False;
    inherited;
end;

//=============================================================================
procedure TFrmMntOperatorCA.SvcTskLstOperatorCreateExecutor(                                   //Regression Fix (SM) R2011.2:: START
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin
  NewObject := TFrmLstOperatorCA.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
  TFrmLstOperatorCA(NewObject).FlgActiveSupport := FlgActiveSupport;                            // Security Point (SM), R2012.1
end;                                                                                            //Regression Fix (SM) R2011.2:: END


procedure TFrmMntOperatorCA.SvcTskDetOperatorCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntOperatorCA.SvcTskDetOperatorCreateExecutor
  NewObject := TFrmDetOperatorCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
  TFrmDetOperatorCA(NewObject).FlgPosFunc := FlgPosFunc;
  TFrmDetOperatorCA(NewObject).FlgOperatorSheet := FlgOperatorSheet;   //Ficha Operator, VKR, R2011.2
  TFrmDetOperatorCA(NewObject).FlgReInitialisePwd := FlgReInitialisePwd;   //R2012.1 47.01 Security  A.M.(Modifications)
end;   // of TFrmMntOperatorCA.SvcTskDetOperatorCreateExecutor

//=============================================================================
// TFrmMntOperatorCA.SvcTskDetOperatorBeforeExecute : Don't let an operator
// be modified or deleted when FlgModify = False
//                                 ---
// Output  : FlgAllow : Allow task to start
//=============================================================================

procedure TFrmMntOperatorCA.SvcTskDetOperatorBeforeExecute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
var
  FrmTempList      : TFrmList;         // Starting List of operators
  TxtName          : string;           // Name selected operator
  IdtOperator      : string;           // IdtOperator selected operator
  CodSecurity      : Integer;          // CodSecurity selected operator
begin
  if FlgAllow then begin
    FrmTempList := TFrmList(SvcTmgMaintenance.FindTask ('ListOperator').Executor);
    if FrmTempList.SelectedJob in [CtCodJobRecMod, CtCodJobRecDel] then begin
      if FrmTempList.DscList.DataSet.FieldByName ('FlgModify').AsInteger = 0 then begin
        TxtName := DmdFpnOperator.InfoOperator[
                     FrmTempList.DscList.DataSet.FieldByName (
                       'IdtOperator').AsString, 'TxtName'];
        if FrmTempList.SelectedJob = CtCodJobRecDel then
          ShowMessage (Format (CtTxtRefuseDel, [TxtName]))
        else
          ShowMessage (Format (CtTxtRefuseMod, [TxtName]));
        FrmTempList.SelectedJob := CtCodJobRecCons;
      end;
    end;
  end;

   //     R2012.1 4701 Security SM.(TCS) ::END
  // --
  {FrmTempList := TFrmList(SvcTmgMaintenance.FindTask ('ListOperator').Executor);            //R2012.1 Security Point (SM) :: START

  if FrmTempList.SelectedJob in [CtCodJobRecMod, CtCodJobRecDel] then begin
    IdtOperator :=
      FrmTempList.DscList.DataSet.FieldByName ('IdtOperator').AsString;

    try
      CodSecurity := DmdFpnOperator.InfoOperator[IdtOperator, 'CodSecurity'];
    except
      CodSecurity := 99999;
    end;

    if CodSecurity >= DmdFpnUtils.CodSecurityCurrentOperator then begin
      TxtName := DmdFpnOperator.InfoOperator[IdtOperator, 'TxtName'];
      if FrmTempList.SelectedJob = CtCodJobRecDel then
        ShowMessage (Format (CtTxtRefuseDel, [TxtName]) + '. ' +
                     CtTxtInsufficRights)
      else
        ShowMessage (Format (CtTxtRefuseMod, [TxtName]) + '. ' +
                     CtTxtInsufficRights);
      FrmTempList.SelectedJob := CtCodJobRecCons;
    end;  // of CodSecurity > DmdFpnUtils.CodSecurityCurrentOperator
  end;  // of FrmTempList.SelectedJob in [CtCodJobRecMod, CtCodJobRecDel]}
 inherited;
end;                                                                                         //R2012.1 Security Point (SM) :: END

//=============================================================================
//Ficha Operator, VKR, R2011.2 - Start

procedure TFrmMntOperatorCA.SvcFrmFichaOperatorReportCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin
  inherited;

  NewObject  := TFrmVSFichaOperator.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;

//Ficha Operator, VKR, R2011.2 - End
//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FMntOperatorCA
