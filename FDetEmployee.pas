//= Copyright 2002 (c) Real Software NV - Retail Division. All rights reserved =
// Packet : FlexPoint Development
// Unit   : FDetEmployee.PAS : MainForm DETail Employee
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetEmployee.pas,v 1.4 2008/01/04 09:24:08 smete Exp $
// History:
//=============================================================================
unit FDetEmployee;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OvcBase, ComCtrls, StdCtrls, Buttons, ExtCtrls, ScDBUtil, Db,
  OvcEF, OvcPB, OvcPF, OvcDbPF,DBTables, SfDetail_BDE_DBC, ScDBUtil_Ovc,
  ScDBUtil_BDE, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDBEdit, ScDBUtil_Dx;

//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmDetEmployee = class(TFrmDetail)
    SvcDBLblIdtEmployee: TSvcDBLabelLoaded;
    SvcDBLblTxtLastName: TSvcDBLabelLoaded;
    SvcDBLblFirstName: TSvcDBLabelLoaded;
    SvcDBLFIdtEmployee: TSvcDBLocalField;
    DscEmployee: TDataSource;
    Common: TTabSheet;
    SbxCommon: TScrollBox;
    SvcDBLblTxtLastNamePartner: TSvcDBLabelLoaded;
    SvcDBLblTxtFirstNamePartner: TSvcDBLabelLoaded;
    SvcDBLblDatStartContract: TSvcDBLabelLoaded;
    SvcDBLblDatEndContract: TSvcDBLabelLoaded;
    SvcDBLblDatActivated: TSvcDBLabelLoaded;
    SvcDBLblDatDisactivated: TSvcDBLabelLoaded;
    lblNumCard: TLabel;
    SvcDBLFDatEndContract: TSvcDBLocalField;
    SvcDBDatStartContract: TSvcDBLocalField;
    SvcDBLFDatActivated: TSvcDBLocalField;
    SvcDBLFDatDisactivated: TSvcDBLocalField;
    SvcDBMETxtLastName: TSvcDBMaskEdit;
    SvcDBMETxtFirstName: TSvcDBMaskEdit;
    SvcDBMETxtLastNamePartner: TSvcDBMaskEdit;
    SvcDBMETxtFirstNamePartner: TSvcDBMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SvcDBLFIdtEmployeeExit(Sender: TObject);
  private
    { Private declarations }
    FFlgShowCard: Boolean;
  protected
    // Protected methods - provided to improve inheritance
    procedure CheckIdtEmployeeBeforeSave; virtual;
    procedure SetDataSetReferences; override;
  public
    { Public declarations }
    procedure FillQuery (QryToFill : TQuery); override;
    procedure PrepareFormDependJob; override;
    procedure AdjustDataBeforeSave; override;
    property FlgShowCard: Boolean read FFlgShowCard write FFlgShowCard;
  end;

var
  FrmDetEmployee: TFrmDetEmployee;

//*****************************************************************************

implementation

uses
  OvcData,

  ScTskMgr_BDE_DBC,
  SfDialog,
  SmDbUtil_BDE,
  SmUtils,
  SrStnCom,

  RFpnCom,
  DFpnEmployee,
  DFpnUtils;

{$R *.DFM}

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetEmployee';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetEmployee.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2008/01/04 09:24:08 $';

//*****************************************************************************
// Implementation of TFrmDetEmployee
//*****************************************************************************

procedure TFrmDetEmployee.AdjustDataBeforeSave;
begin  // of TFrmDetEmployee.AdjustDataBeforeSave
  CheckIdtEmployeeBeforeSave;
end;   // of TFrmDetEmployee.AdjustDataBeforeSave

//=============================================================================

procedure TFrmDetEmployee.CheckIdtEmployeeBeforeSave;
begin  // of TFrmDetEmployee.CheckIdtEmployeeBeforeSave
  if (CodJob = CtCodJobRecNew) and (SvcDBLFIdtEmployee.AsString <> '') and
     (SvcDBLFIdtEmployee.AsInteger <> 0) and (not FlgCurrentApplied) then begin
    if DmdFpnEmployee.EmployeeExists (SvcDBLFIdtEmployee.AsInteger) then begin
      if not SvcDBLFIdtEmployee.CanFocus then
        SvcDBLFIdtEmployee.Show;
      SvcDBLFIdtEmployee.SetFocus;
      raise Exception.Create (TrimTrailColon (SvcDBLblIdtEmployee.Caption) +
                              ' ' + Trim (SvcDBLFIdtEmployee.AsString) + ' ' +
                              CtTxtAlreadyExist);
    end;
  end
  else begin
    if (CodJob = CtCodJobRecNew) and (SvcDBLFIdtEmployee.AsString = '') or
     (SvcDBLFIdtEmployee.AsInteger = 0) then begin
      if not SvcDBLFIdtEmployee.CanFocus then
          SvcDBLFIdtEmployee.Show;
      SvcDBLFIdtEmployee.SetFocus;
      raise Exception.Create
      (TrimTrailColon (SvcDBLblIdtEmployee.Caption) + ' ' + CtTxtRequired);
    end;
  end;
end;   // of TFrmDetEmployee.CheckIdtEmployeeBeforeSave

//=============================================================================

procedure TFrmDetEmployee.FillQuery(QryToFill: TQuery);
begin // of TFrmDetEmployee.FillQuery
  if QryToFill = DscEmployee.DataSet then begin
    if CodJob = CtCodJobRecNew then
      QryToFill.ParamByName ('PrmIdtEmployee').Clear
    else
      QryToFill.ParamByName ('PrmIdtEmployee').Text :=
        StrLstIdtValues.Values['IdtEmployee'];
  end;
end;  // of TFrmDetEmployee.FillQuery

//=============================================================================

procedure TFrmDetEmployee.FormCreate(Sender: TObject);
begin // of TFrmDetEmployee.FormCreate
  try
    inherited;
    LstDstStartUp.Add (DscEmployee.DataSet);
    AddIdtControls ([SvcDBLFIdtEmployee]);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;   // of try ... except block
end;  // of TFrmDetEmployee.FormCreate

//=============================================================================

procedure TFrmDetEmployee.PrepareFormDependJob;
begin // of TFrmDetEmployee.PrepareFormDependJob
  try
    inherited;

    // Give focus to a control according to the started job
    if not (CodJob in [CtCodJobRecDel, CtCodJobRecCons]) then
      if CodJob = CtCodJobRecNew then
        ActiveControl := SvcDBLFIdtEmployee
      else
        ActiveControl := SvcDBMETxtLastName;
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;  // of TFrmDetEmployee.PrepareFormDependJob

//=============================================================================

procedure TFrmDetEmployee.SetDataSetReferences;
begin  // of TFrmDetEmployee.SetDataSetReferences
  DscEmployee.DataSet := DmdFpnEmployee.QryDetEmployee;
end;   // TFrmDetEmployee.SetDataSetReferences

//=============================================================================

procedure TFrmDetEmployee.FormActivate(Sender: TObject);
begin
  inherited;
  if FlgShowCard then
    lblNumCard.Visible := True
  else
    lblNumCard.Visible := False;
  lblNumCard.Caption := '';
  if FlgShowCard and (Trim(SvcDBLFIdtEmployee.AsString) <> '0') then begin
    lblNumCard.Caption := DmdFpnEmployee.CalcNumCard(Trim(SvcDBLFIdtEmployee.AsString));
  end;
end;

//=============================================================================

procedure TFrmDetEmployee.SvcDBLFIdtEmployeeExit(Sender: TObject);
begin
  inherited;
  if FlgShowCard and (SvcDBLFIdtEmployee.AsString <> '') then begin
    lblNumCard.Caption := DmdFpnEmployee.CalcNumCard(Trim(SvcDBLFIdtEmployee.AsString));
  end;
end;

//=============================================================================


initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end. // of TFrmDetEmployee
