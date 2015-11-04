//=========== Sycron Computers Belgium (c) 2003 ===============================
// Packet : Castorama Development
// Unit   : FSetFormation : SET's the FORMATION flag on
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSetFormation.pas,v 1.1 2006/12/20 08:16:41 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FSetFormation - CVS revision 1.1
//=============================================================================

unit FSetFormation;

//*****************************************************************************

interface

//*****************************************************************************

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls;


const
  CtTxtAppPrmFormationMode = 'FormationMode';  // Applicparam for formation
  CtTxtAppPrmFormModeDescr = 'Parameter to set checkouts in formation mode';


type
  TFrmSetFormation = class(TFrmAutoRun)
    ChkLstCheckouts: TCheckListBox;
    BtnActivate: TSpeedButton;
    ActSave: TAction;
    ChkActivated: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActDeactivateExecute(Sender: TObject);
    procedure ChkActivatedClick(Sender: TObject);
  protected
    function GetTxtCheckoutStrings : string;
    procedure SetTxtCheckoutStrings (TxtParam : String);
    procedure SetListOfCheckouts; virtual;
    procedure SetParam; virtual;
  public
    property TxtCheckoutStrings : string read  GetTxtCheckoutStrings
                                         write SetTxtCheckoutStrings;
    procedure CreateAdditionalModules; override;
  end;

var
  FrmSetFormation: TFrmSetFormation;

//*****************************************************************************


implementation

{$R *.DFM}

uses
  SfDialog,

  DFpn,
  DFpnUtils,
  DFpnApplicParam;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FSetFormation';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSetFormation.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/20 08:16:41 $';

//*****************************************************************************
// Implementation of TFrmSetForamtion
//*****************************************************************************

procedure TFrmSetFormation.SetListOfCheckouts;
begin  // of TFrmSetFormation.SetListOfCheckouts
  ChkActivated.Checked := DmdFpnApplicParam.InfoApplicParam
                                     [CtTxtAppPrmFormationMode, 'ValParam'] = 1;
  ChkActivated.OnClick (Self);;
  TxtCheckoutStrings := DmdFpnApplicParam.InfoApplicParam
                                         [CtTxtAppPrmFormationMode, 'TxtParam'];
end;   // of TFrmSetFormation.SetListOfCheckouts

//=============================================================================

procedure TFrmSetFormation.CreateAdditionalModules;
begin  // of TFrmSetFormation.CreateAdditionalModules
  if not Assigned (DmdFpn) then
    DmdFpn := TDmdFpn.Create (Self);
  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Self);
  if not Assigned (DmdFpnApplicParam) then
    DmdFpnApplicParam := TDmdFpnApplicParam.Create (Self);
end;   // of TFrmSetFormation.CreateAdditionalModules

//=============================================================================

function TFrmSetFormation.GetTxtCheckoutStrings : string;
var
  CntIndex         : Integer;          // Loop index
  TxtSep           : string;           // Separator;
begin  // of TFrmSetFormation.GetTxtCheckoutStrings
  TxtSep := '';
  for CntIndex := 0 to ChkLstCheckouts.Items.Count - 1 do begin
    if ChkLstCheckouts.Checked [CntIndex] then begin
      Result := Result + TxtSep +
                IntToStr (Integer (ChkLstCheckouts.Items.Objects[CntIndex]));
      TxtSep := ','
    end;
  end;
end;   // of TFrmSetFormation.GetTxtCheckoutStrings

//=============================================================================

procedure TFrmSetFormation.SetTxtCheckoutStrings (TxtParam : String);
var
  CntIndex         : Integer;          // Loop index
  TxtSep           : string;           // Separator;
begin  // of TFrmSetFormation.SetTxtCheckoutStrings
  TxtSep := '';
  for CntIndex := 0 to ChkLstCheckouts.Items.Count - 1 do
    ChkLstCheckouts.Checked [CntIndex] :=
      AnsiPos (',' + IntToStr (Integer (ChkLstCheckouts.Items.Objects [CntIndex]))
               + ',',
           ',' + TxtParam + ',') > 0;
end;   // of TFrmSetFormation.SetTxtCheckoutStrings

//=============================================================================

procedure TFrmSetFormation.FormActivate(Sender: TObject);
begin  // of TFrmSetFormation.FormActivate
  inherited;
  if DmdFpnUtils.QueryInfo ('Select IdtCheckout, TxtPublDescr ' +
                            ' from Workstat') then begin
    while not DmdFpnUtils.QryInfo.Eof do begin
      ChkLstCheckouts.Items.AddObject
          (DmdFpnUtils.QryInfo.FieldByName ('TxtPublDescr').AsString,
           TObject (DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsInteger));
      DmdFpnUtils.QryInfo.Next;
    end;
    DmdFpnUtils.CloseInfo;
  end;
  BtnActivate.Visible := True;
  SetListOfCheckouts
end;   // of TFrmSetFormation.FormActivate

//=============================================================================

procedure TFrmSetFormation.ActSaveExecute(Sender: TObject);
begin  // of TFrmSetFormation.ActActivateExecute
  inherited;
  Setparam;
end;   // of TFrmSetFormation.ActActivateExecute

//=============================================================================

procedure TFrmSetFormation.ActDeactivateExecute(Sender: TObject);
begin  // of TFrmSetFormation.ActDeactivateExecute
  inherited;
  SetParam;
end;   // of TFrmSetFormation.ActDeactivateExecute

//=============================================================================

procedure TFrmSetFormation.SetParam;
begin  // of TFrmSetFormation.SetParam
  DmdFpnUtils.ClearQryInfo;
  DmdFpnUtils.AddSQLUpdateSysPrm (CtTxtAppPrmFormationMode, Integer (ChkActivated.Checked),
                                  TxtCheckoutStrings, CtTxtAppPrmFormModeDescr);
  DmdFpnUtils.ExecQryInfo;
end;   // of TFrmSetFormation.SetParam

//=============================================================================

procedure TFrmSetFormation.ChkActivatedClick(Sender: TObject);
begin  // of TFrmSetFormation.ChkActivatedClick
  inherited;
  if ChkActivated.Checked then begin
    ChkLstCheckouts.Enabled := True;
    ChkLstCheckouts.Color := ClWhite;
  end
  else begin
    ChkLstCheckouts.Enabled := False;
    ChkLstCheckouts.Color := clBtnFace;
  end;
end;   // of TFrmSetFormation.ChkActivatedClick

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.  // of FSetFormation
