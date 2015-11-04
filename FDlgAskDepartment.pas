//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet : FlexPoint Development
// Unit   : FDlgAskDepartment.PAS : Form Dialog Choose Department
// Date   : 090-01-06
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDlgAskDepartment.pas,v 1.3 2006/12/27 08:36:21 NicoCV Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FDlgAskDepartment - CVS revision 1.1
//=============================================================================

unit FDlgAskDepartment;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, StdCtrls, DBCtrls, Db, Buttons, ScDBUtil_BDE;

//=============================================================================
// Global resourcestrings
//=============================================================================
resourcestring // error messages
  CtTxtReqDepartment    = 'Please fill in the department.';

//=============================================================================
// TFrmDlgAskDepartment
//=============================================================================

type
  TFrmDlgAskDepartment = class(TFrmCommon)
    SvcDBLblDepartment: TSvcDBLabelLoaded;
    dscDepartment: TDataSource;
    BtnCancel: TBitBtn;
    BtnOK: TBitBtn;
    DBLkpCbxDepartment: TDBLookupComboBox;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    FIdtDepartment: integer;
  public
    { Public declarations }
  published
    { Published declarations }
    property IdtDepartment: integer read FIdtDepartment write FIdtDepartment;
  end;

var
  FrmDlgAskDepartment: TFrmDlgAskDepartment;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  DFpnDepartment;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDlgAskDepartment';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDlgAskDepartment.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2006/12/27 08:36:21 $';

//*****************************************************************************
// Implementation of TFrmDlgAskDepartment
//*****************************************************************************


//=============================================================================

procedure TFrmDlgAskDepartment.BtnOKClick(Sender: TObject);
begin  // of TFrmDlgAskDepartment.BtnOKClick
  inherited;
  //Check if department is filled in
  if DBLkpCbxDepartment.KeyValue < 1  then begin
    ShowMessage(CtTxtReqDepartment);
    ModalResult := mrNone;
    DBLkpCbxDepartment.SetFocus;
    exit;
  end
  else begin
    IdtDepartment := DBLkpCbxDepartment.KeyValue;
  end;
end;   // of TFrmDlgAskDepartment.BtnOKClick

//=============================================================================

procedure TFrmDlgAskDepartment.BtnCancelClick(Sender: TObject);
begin  // of TFrmDlgAskDepartment.BtnCancelClick
  inherited;
  IdtDepartment := 0;
end;   // of TFrmDlgAskDepartment.BtnCancelClick

//=============================================================================

procedure TFrmDlgAskDepartment.FormActivate(Sender: TObject);
begin
  DmdFpnDepartment.qryDetDepartment.Active := True;
  inherited;
end;

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.
