//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Customer : Castorama
// Unit   : FMntAddressCA.PAS : Form MaiNTenance ADDRESS CAstorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntAddressCA.pas,v 1.5 2009/10/16 10:11:42 BEL\KDeconyn Exp $
//=============================================================================
// Version    Modified by            Reason
// 1.1        Chayanika(TCS)     Regression Fix R2012.1
//=============================================================================

unit FMntAddressCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FMntAddress, ScTskMgr_BDE_DBC;

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtRunParamVATLength = 'Maximum length of vatcode is 16';
  CtTxtRunParamCheckVAT  = 'Check VAT number';
  CtTxtTitle = 'Maintenance Address' ;                                              //Regression Fix (Chayanika)

//=============================================================================
// TFrmMntAddressCA
//=============================================================================

type
  TFrmMntAddressCA = class(TFrmMntAddress)
    procedure FormActivate(Sender: TObject);                                        //Regression Fix (Chayanika)
    procedure SvcTskLstAddressCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetAddressCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstCustomerForAddressCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetCustomerCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstSupplierForAddressCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetSupplierCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstMunicipalityForAddressCreateExecutor(
      Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetMunicipalityCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
    FFlgVat16         : Boolean;
    FFlgCheckVAT      : Boolean;
  protected
    { Protected declarations }
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    property FlgCheckVAT : Boolean read FFlgCheckVAT write FFlgCheckVAT;
    property FlgVat16: Boolean read FFlgVat16 write FFlgVat16;
  end;

var
  FrmMntAddressCA: TFrmMntAddressCA;

//*****************************************************************************

implementation

uses
  SfList_BDE_DBC,
  SfDialog,
  SmUtils,

  DFpn,
  DFpnUtils,

  DFpnAddressCA,
  DFpnCustomerCA,
  DFpnMunicipalityCA,
  DFpnSupplier,
  DFpnSupplierCA,

  FDetAddressCA,
  FDetCustomerCA,
  FDetMunicipalityCA,
  FDetSupplier,
  FDetSupplierCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntAddressCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FMntAddress.pas  $';
  CtTxtSrcVersion = '$Revision: 1.5 $';
  CtTxtSrcDate    = '$Date: 2009/10/16 10:11:42 $';

//*****************************************************************************
// Implementation of TFrmMntAddress
//*****************************************************************************

procedure TFrmMntAddressCA.FormActivate(Sender: TObject);
begin  // of TFrmMntAddressCA.FormActivate
  inherited;
  if FlgFullFunc then begin
    SvcTskLstCustomerForAddress.Enabled := True;
    SvcTskLstSupplierForAddress.Enabled := True;
    SvcTskLstMunicipalityForAddress.Enabled := True;
  end;
  Application.Title:= CtTxtTitle;                                             // Regression Fix R2012.1(Chayanika)
  end;   // of TFrmMntAddressCA.FormActivate

//=============================================================================

procedure TFrmMntAddressCA.SvcTskLstAddressCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntAddressCA.SvcTskLstAddressCreateExecutor
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds;
  FlgCreated := True;
end;   // of TFrmMntAddressCA.SvcTskLstAddressCreateExecutor

//=============================================================================

procedure TFrmMntAddressCA.SvcTskLstCustomerForAddressCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntAddressCA.SvcTskLstCustomerForAddressCreateExecutor
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel, CtCodJobRecCons];
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntAddressCA.SvcTskLstCustomerForAddressCreateExecutor

//=============================================================================

procedure TFrmMntAddressCA.SvcTskLstSupplierForAddressCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntAddressCA.SvcTskLstSupplierForAddressCreateExecutor
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel, CtCodJobRecCons];
  FlgCreated := True;
end;   // of TFrmMntAddressCA.SvcTskLstSupplierForAddressCreateExecutor

//=============================================================================

procedure TFrmMntAddressCA.SvcTskLstMunicipalityForAddressCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntAddressCA.SvcTskLstMunicipalityForAddressCreateExecutor
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds + [CtCodJobRecSel];
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntAddressCA.SvcTskLstMunicipalityForAddressCreateExecutor

//=============================================================================

procedure TFrmMntAddressCA.SvcTskDetAddressCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntAddressCA.SvcTskDetAddressCreateExecutor
  NewObject := TFrmDetAddressCA.Create (Self);
  TFrmDetAddressCA(NewObject).FlgVat16    := FlgVat16;
  TFrmDetAddressCA(NewObject).FlgCheckVAT := FlgCheckVAT;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntAddressCA.SvcTskDetAddressCreateExecutor

//=============================================================================

procedure TFrmMntAddressCA.SvcTskDetCustomerCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntAddressCA.SvcTskDetCustomerCreateExecutor
  NewObject := TFrmDetCustomerCA.Create (Self);
  TFrmDetCustomerCA(NewObject).FlgDisableBonPassage := True;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntAddressCA.SvcTskDetCustomerCreateExecutor

//=============================================================================

procedure TFrmMntAddressCA.SvcTskDetSupplierCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntAddressCA.SvcTskDetSupplierCreateExecutor
  NewObject := TFrmDetSupplierCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntAddressCA.SvcTskDetSupplierCreateExecutor

//=============================================================================

procedure TFrmMntAddressCA.SvcTskDetMunicipalityCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntAddressCA.SvcTskDetMunicipalityCreateExecutor
  NewObject := TFrmDetMunicipalityCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntAddressCA.SvcTskDetMunicipalityCreateExecutor

//=============================================================================

procedure TFrmMntAddressCA.BeforeCheckRunParams;
begin  // of TFrmMntAddressCA.BeforeCheckRunParams
  inherited;
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  AddRunParams ('/VVAT16', CtTxtRunParamVATLength);
  AddRunParams ('/VCheckVAT', CtTxtRunParamCheckVAT);
end;   // of TFrmMntAddressCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntAddressCA.CheckAppDependParams(TxtParam: string);
begin  // of TFrmMntAddressCA.CheckAppDependParams(TxtParam: string)
  if AnsiCompareText (Copy(TxtParam, 3, 5) ,'VAT16') = 0 then
    FlgVat16 := True;
  if AnsiCompareText (Copy(TxtParam, 3, 8), 'CheckVAT') = 0 then
    FlgCheckVAT := True;
end;   // of TFrmMntAddressCA.CheckAppDependParams(TxtParam: string)

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.
