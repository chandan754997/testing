//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet   : FlexPoint
// Unit     : FInputOperatorCA : Form to do an INPUT for a Operator CA
//-----------------------------------------------------------------------------
// PVCS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FInputOperatorCA.pas,v 1.1 2006/12/22 15:28:52 NicoCV Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FInputOperatorCA - CVS revision 1.3
//=============================================================================

unit FInputOperatorCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, OvcBase, OvcEF, OvcPB, OvcPF, ScUtils, StdCtrls, Buttons;

//=============================================================================
// Global definitions
//=============================================================================

type
  TFrmInputOperatorCA = class(TFrmCommon)
    LblOperatorNumber: TLabel;
    SvcLFOperatorNumber: TSvcLocalField;
    OvcController1: TOvcController;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    procedure BtnOKClick(Sender: TObject);

    protected
    FOperatorId  : string;           // operator number to pass

    published
    property OperatorId   : string read  FOperatorId
                                   write FOperatorId;
  end;

resourcestring
  CtTxtEnterID    = 'Please enter an operator number';
  CtTxtNoOperator = 'Operator doesn’t exist';

var
  FrmInputOperatorCA: TFrmInputOperatorCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,

  DFpn,
  DFpnUtils,
  RFpnTenderCA,
  StDate,
  DFpnOperatorCA,
  FMntTenderReCountCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FInputOperatorCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FInputOperatorCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.0 $';
  CtTxtSrcDate    = '$Date: 2013/06/20 15:28:52 $';

//*****************************************************************************
// Implementation of FInputOperatorCA
//*****************************************************************************

procedure TFrmInputOperatorCA.BtnOKClick(Sender: TObject);
begin  // of TFrmInputOperatorCA.BtnOKClick
  try
    if SvcLFOperatorNumber.Text = '' then
    begin
      MessageDlg (CtTxtEnterID, mtWarning, [mbOk], 0);
      SvcLFOperatorNumber.Text := '';
      SvcLFOperatorNumber.SetFocus;
    end
    else
    begin
      FrmMntTenderReCountCA.OperatorId := DmdFpnOperatorCA.RetrieveIdtOperator(SvcLFOperatorNumber.Text);
      OperatorId := FrmMntTenderReCountCA.OperatorId;
      if OperatorId = '' then
      begin
        MessageDlg (CtTxtNoOperator, mtWarning, [mbOk], 0);
        SvcLFOperatorNumber.Text := '';
        SvcLFOperatorNumber.SetFocus;
        DmdFpnUtils.ClearQryInfo;
        DmdFpnUtils.CloseInfo;
        Exit;
      end;
    end;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmInputOperatorCA.BtnOKClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FInputOperatorCA
