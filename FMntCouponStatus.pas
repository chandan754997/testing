//=Copyright 2007 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FMntCouponStatus.PAS : Maintenance of credit vouchers
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCouponStatus.pas,v 1.4 2009/10/15 10:17:40 BEL\BHofmans Exp $
// Version    Modified by  Reason
// 1.1        SRM(TCS)     //Regression Fix R2012.1 (SRM)
// 1.2      AJ  (TCS)  R2014.1.Req(31110).Promopack_Improvement.TCS-AJ

//=============================================================================

unit FMntCouponStatus;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FFpnMnt, ScTskMgr_BDE_DBC;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtChangeState      = '/VState=Only possible to change state';
   CtTxtTitle           = 'Maintenance Coupon';                                 //Regression Fix R2012.1 (SRM)

type
  TFrmMntCouponStatus = class(TFrmFpnMnt)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskLstCouponStatus: TSvcListTask;
    SvcTskDetCouponStatus: TSvcFormTask;
    SvcTskListClassificationForCoupon: TSvcListTask;
    SvcTskLstCustomerForCoupon: TSvcListTask;
    procedure FormActivate(Sender: TObject);                                    //Regression Fix R2012.1 (SRM)
    procedure SvcTskLstCustomerForCouponCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskListClassificationForCouponCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetCouponStatusCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstCouponStatusCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
    FFlgChangeState : boolean;
    FFlgChangeReason : boolean;                                                 // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ
  protected
    { Protected declarations }
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    property FlgChangeState: Boolean read FFlgChangeState
                                    write FFlgChangeState;
    // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
    property FlgChangeReason: Boolean read FFlgChangeReason
                                    write FFlgChangeReason;
    // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
  end;

var
  FrmMntCouponStatus: TFrmMntCouponStatus;

implementation

uses
  SfList_BDE_DBC,
  SmUtils,

  FDetCouponStatus,

  DFpnCustomer,
  DFpnCustomerCA,
  DFpnClassification,
  DFpnClassificationCA,
  DFpnCouponStatusCA,
  sfdialog, FLstCouponStatus;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntCouponStatus';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: ';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2012/06/27 10:17:40 $';
  CtTxtSrcTag     = '$Name:  $';

//*****************************************************************************
//Regression Fix R2012.1 (SRM) Start
procedure TFrmMntCouponStatus.FormActivate(Sender: TObject);
begin  // of TFrmMntCouponStatus.FormActivate
  inherited;
    application.Title := CtTxtTitle;        
end;   // of TFrmMntCouponStatus.FormActivate
//Regression Fix R2012.1 (SRM) End
//=============================================================================
procedure TFrmMntCouponStatus.SvcTskLstCouponStatusCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCouponStatus.SvcTskLstCouponStatusCreateExecutor
  NewObject := TFrmLstCouponStatus.Create (Self);
  TFrmLstCouponStatus(NewObject).FlgChangeState := FlgChangeState;
  TFrmLstCouponStatus(NewObject).AllowedJobs := SetEntryCmds;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCouponStatus.SvcTskLstCouponStatusCreateExecutor

//=============================================================================

procedure TFrmMntCouponStatus.SvcTskDetCouponStatusCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCouponStatus.SvcTskDetCouponStatusCreateExecutor
  NewObject := TFrmDetCouponStatus.Create (Self);
  TFrmDetCouponStatus(NewObject).FlgChangeState := FlgChangeState;
  TFrmDetCouponStatus(NewObject).FlgChangeReason := FlgChangeReason;            // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCouponStatus.SvcTskDetCouponStatusCreateExecutor

//=============================================================================

procedure TFrmMntCouponStatus.SvcTskListClassificationForCouponCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCouponStatus.SvcTskListClassificationForCouponCreateExecutor
  inherited;
  NewObject  := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds;
  FlgCreated := True;
end;   // of TFrmMntCouponStatus.SvcTskListClassificationForCouponCreateExecutor

//=============================================================================

procedure TFrmMntCouponStatus.SvcTskLstCustomerForCouponCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCouponStatus.SvcTskLstCustomerForCouponCreateExecutor
  inherited;
  NewObject  := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel];
  FlgCreated := True;
end;  // of TFrmMntCouponStatus.SvcTskLstCustomerForCouponCreateExecutor

//=============================================================================

procedure TFrmMntCouponStatus.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmMntCouponStatus.BeforeCheckRunParams
  inherited;
  SplitString(CtTxtChangeState, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmMntCouponStatus.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntCouponStatus.CheckAppDependParams(TxtParam: string);
begin  // of TFrmMntCouponStatus.CheckAppDependParams
  if Copy(TxtParam,3,5)= 'State' then
    FlgChangeState := True
   // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
  else if Copy(TxtParam,3,4)= 'PI' then
    FlgChangeReason := True
   // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
  else
    inherited;
end;   // of TFrmMntCouponStatus.CheckAppDependParams

//=============================================================================

end.
