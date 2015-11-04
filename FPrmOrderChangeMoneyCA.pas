//=Copyright 2009 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint
// Customer : Castorama
// Unit     : FPrmOrderChangeMoneyCA: Form PaRaMeters Order Change Money
//            CASTORAMA
//-----------------------------------------------------------------------------
// CVS      : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FPrmOrderChangeMoneyCA.pas,v 1.3 2009/09/22 09:03:12 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0.1 - FSetFormation - CVS revision 1.1
//=============================================================================

unit FPrmOrderChangeMoneyCA;

//*****************************************************************************

interface

//*****************************************************************************

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ovcbase, ovcef, ovcpb, ovcpf, ScUtils,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx;

//*****************************************************************************
// FPrmOrderChangeMoneyCA
//*****************************************************************************

//=============================================================================
// Identification for parameters Order change money
//=============================================================================

const  // Systemparameters in ApplicParam
       // - IdtApplicParam for parameters Order change money
  CtTxtPrmFinNameBank             = 'FinNameBank';
  CtTxtPrmFinNameBankDescr        = 'Name of the bank';
  CtTxtPrmFinAddressBank          = 'FinAddressBank';
  CtTxtPrmFinAddressBankDescr     = 'Address of the bank';
  CtTxtPrmFinCityBank             = 'FinCityBank';
  CtTxtPrmFinCityBankDescr        = 'City of the bank';
  CtTxtPrmFinSecurityCompany      = 'FinSecurityCompany';
  CtTxtPrmFinSecurityCompanyDescr = 'Name of the security company';
  CtTxtPrmFinBankAccount          = 'FinBankAccount';
  CtTxtPrmFinBankAccountDescr     = 'Bank account';
  CtTxtPrmFinNameRespPerson1      = 'FinNameRespPerson1';
  CtTxtPrmFinNameRespPerson1Descr = 'Name of the first responsible person';
  CtTxtPrmFinNameRespPerson2      = 'FinNameRespPerson2';
  CtTxtPrmFinNameRespPerson2Descr = 'Name of the second responsible person';
  CtTxtPrmFinDNIRespPerson1       = 'FinDNIRespPerson1';
  CtTxtPrmFinDNIRespPerson1Descr  = 'DNI number of the first responsible person';
  CtTxtPrmFinDNIRespPerson2       = 'FinDNIRespPerson2';
  CtTxtPrmFinDNIRespPerson2Descr  = 'DNI number of the second responsible person';

resourcestring
  CtTxtExpectedFmt = 'Expected format';

type
  TFrmPrmOrderChangeMoneyCA = class(TFrmAutoRun)
    BtnActivate: TSpeedButton;
    ActSave: TAction;
    PgeCtlPrmOrderChangeMoney: TPageControl;
    TabShtPrmOrderChangeMoney: TTabSheet;
    SbxPrmOrderChangeMoney: TScrollBox;
    GbxPrmBankData: TGroupBox;
    LblNameBank: TLabel;
    LblAddress: TLabel;
    LblCity: TLabel;
    LblBankAccount: TLabel;
    PnlBottom: TPanel;
    PnlBottomRight: TPanel;
    GbxSecurity: TGroupBox;
    LblSecurity: TLabel;
    GbxResponsible: TGroupBox;
    LblNameRespPerson1: TLabel;
    LblNameRespPerson2: TLabel;
    LblDNIRespPerson1: TLabel;
    SvcLFDNIRespPerson1: TSvcLocalField;
    LblDNIRespPerson2: TLabel;
    SvcLFDNIRespPerson2: TSvcLocalField;
    BtnCancel: TBitBtn;
    BtnOK: TBitBtn;
    OvcCtlPrm: TOvcController;
    SvcMENameBank: TSvcMaskEdit;
    SvcMESecurity: TSvcMaskEdit;
    SvcMEAddress: TSvcMaskEdit;
    SvcMECity: TSvcMaskEdit;
    SvcMEBankAccount: TSvcMaskEdit;
    SvcMENameRespPerson1: TSvcMaskEdit;
    SvcMENameRespPerson2: TSvcMaskEdit;
    procedure SvcLFDNIRespPersonUserValidation(Sender: TObject;
      var ErrorCode: Word);
    procedure OvcCtlPrmIsSpecialControl(Sender: TObject; Control: TWinControl;
      var Special: Boolean);
    procedure BtnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  protected
    procedure SetParam; virtual;
    procedure DefineStandardRunParams; override;
  public
    procedure CreateAdditionalModules; override;
  end;

var
  FrmPrmOrderChangeMoneyCA: TFrmPrmOrderChangeMoneyCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  OvcData,
  
  SfDialog,
  SmUtils,
  SrStnCom,
  
  DFpn,
  DFpnUtils,
  DFpnApplicParam;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FPrmOrderChangeMoneyCA';

const  // CVS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FPrmOrderChangeMoneyCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/09/22 09:03:12 $';
  CtTxtSrcTag     = '$Name:  $';

//*****************************************************************************
// Implementation of TFrmPrmOrderChangeMoneyCA
//*****************************************************************************

procedure TFrmPrmOrderChangeMoneyCA.CreateAdditionalModules;
begin  // of TFrmPrmOrderChangeMoneyCA.CreateAdditionalModules
  if not Assigned (DmdFpn) then
    DmdFpn := TDmdFpn.Create (Self);
  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Self);
  if not Assigned (DmdFpnApplicParam) then
    DmdFpnApplicParam := TDmdFpnApplicParam.Create (Self);
end;   // of TFrmPrmOrderChangeMoneyCA.CreateAdditionalModules

//=============================================================================

procedure TFrmPrmOrderChangeMoneyCA.FormActivate(Sender: TObject);
begin  // of TFrmPrmOrderChangeMoneyCA.FormActivate
  inherited;
  SvcMENameBank.SetFocus;
  SvcMENameBank.Text        := DmdFpnApplicParam.InfoApplicParam
                                       [CtTxtPrmFinNameBank, 'TxtParam'];
  SvcMEAddress.Text         := DmdFpnApplicParam.InfoApplicParam
                                       [CtTxtPrmFinAddressBank, 'TxtParam'];
  SvcMECity.Text            := DmdFpnApplicParam.InfoApplicParam
                                       [CtTxtPrmFinCityBank, 'TxtParam'];
  SvcMESecurity.Text        := DmdFpnApplicParam.InfoApplicParam
                                       [CtTxtPrmFinSecurityCompany, 'TxtParam'];
  SvcMEBankAccount.Text     := DmdFpnApplicParam.InfoApplicParam
                                       [CtTxtPrmFinBankAccount, 'TxtParam'];
  SvcMENameRespPerson1.Text := DmdFpnApplicParam.InfoApplicParam
                                       [CtTxtPrmFinNameRespPerson1, 'TxtParam'];
  SvcMENameRespPerson2.Text := DmdFpnApplicParam.InfoApplicParam
                                       [CtTxtPrmFinNameRespPerson2, 'TxtParam'];
  SvcLFDNIRespPerson1.Text  := DmdFpnApplicParam.InfoApplicParam
                                       [CtTxtPrmFinDNIRespPerson1, 'TxtParam'];
  SvcLFDNIRespPerson2.Text  := DmdFpnApplicParam.InfoApplicParam
                                       [CtTxtPrmFinDNIRespPerson2, 'TxtParam'];
end;   // of TFrmPrmOrderChangeMoneyCA.FormActivate

//=============================================================================

procedure TFrmPrmOrderChangeMoneyCA.SetParam;
begin  // of TFrmPrmOrderChangeMoneyCA.SetParam
  DmdFpnUtils.ClearQryInfo;
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtPrmFinNameBank, 0,
                    SvcMENameBank.Text, CtTxtPrmFinNameBankDescr);
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtPrmFinAddressBank, 0,
                    SvcMEAddress.Text, CtTxtPrmFinAddressBankDescr);
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtPrmFinCityBank, 0,
                    SvcMECity.Text, CtTxtPrmFinCityBankDescr);
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtPrmFinSecurityCompany, 0,
                    SvcMESecurity.Text, CtTxtPrmFinSecurityCompanyDescr);
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtPrmFinBankAccount, 0,
                    SvcMEBankAccount.Text, CtTxtPrmFinBankAccountDescr);
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtPrmFinNameRespPerson1, 0,
                    SvcMENameRespPerson1.Text, CtTxtPrmFinNameRespPerson1Descr);
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtPrmFinNameRespPerson2, 0,
                    SvcMENameRespPerson2.Text, CtTxtPrmFinNameRespPerson2Descr);
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtPrmFinDNIRespPerson1, 0,
                    SvcLFDNIRespPerson1.Text, CtTxtPrmFinDNIRespPerson1Descr);
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtPrmFinDNIRespPerson2, 0,
                    SvcLFDNIRespPerson2.Text, CtTxtPrmFinDNIRespPerson2Descr);
  DmdFpnUtils.ExecQryInfo;
end;   // of TFrmPrmOrderChangeMoneyCA.SetParam

//=============================================================================
// TFrmPrmOrderChangeMoneyCA.DefineStandardRunParams
// Fill in the standard runparameters.
//=============================================================================

procedure TFrmPrmOrderChangeMoneyCA.DefineStandardRunParams;
begin  // of TFrmPrmOrderChangeMoneyCA.DefineStandardRunParams
  SmUtils.ViTxtRunPmAllow := '';
  // If a required ini-file is missing, then raise an exception when
  // automatic running
  SmUtils.ViSetDefIni := SmUtils.ViSetDefIni + [SmUtils.IniMissingRaise];
end;   // of TFrmPrmOrderChangeMoneyCA.DefineStandardRunParams

//=============================================================================

procedure TFrmPrmOrderChangeMoneyCA.BtnOKClick(Sender: TObject);
begin // of TFrmPrmOrderChangeMoneyCA.BtnOKClick
  inherited;
  Setparam;
  self.Close;
end; // of TFrmPrmOrderChangeMoneyCA.BtnOKClick

//=============================================================================

procedure TFrmPrmOrderChangeMoneyCA.OvcCtlPrmIsSpecialControl(Sender: TObject;
  Control: TWinControl; var Special: Boolean);
begin  // of TFrmPrmOrderChangeMoneyCA.OvcCtlPrmIsSpecialControl
  inherited;
  Special := Control = BtnCancel;
end;   // of TFrmPrmOrderChangeMoneyCA.OvcCtlPrmIsSpecialControl

//=============================================================================

procedure TFrmPrmOrderChangeMoneyCA.SvcLFDNIRespPersonUserValidation(
  Sender: TObject; var ErrorCode: Word);
var
  TxtDNI           : string;           // DNI number
  TxtNameCmp       : string;           // Caption of component
begin  // of TFrmPrmOrderChangeMoneyCA.SvcLFDNIRespPersonUserValidation
  inherited;

  try
    if TSvcLocalField(Sender).Modified then begin
      TxtDNI := Trim (TSvcLocalField(Sender).Text);
      if (TxtDNI <> '') then begin
        if (Length (TxtDNI) <> 10) or
           (TxtDNI[9] <> '-') or
           (not (TxtDNI[10] in ['A'..'Z'])) then
          raise EAbort.Create ('');
        StrToInt (Copy (TxtDNI, 1, 8));
      end;
    end;
  except
    on E:Exception do begin
      ErrorCode := oeCustomError;
      if Sender = SvcLFDNIRespPerson1 then
        TxtNameCmp := LblDNIRespPerson1.Caption
      else
        TxtNameCmp := LblDNIRespPerson2.Caption;
      TSvcLocalField(Sender).Controller.ErrorText :=
        TrimTrailColon (TxtNameCmp) + ' ' + CtTxtInvalid +
        #10 + CtTxtExpectedFmt + ' 99999999-X';
    end;
  end;
end;   // of TFrmPrmOrderChangeMoneyCA.SvcLFDNIRespPersonUserValidation

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.  // of TFrmPrmOrderChangeMoneyCA
