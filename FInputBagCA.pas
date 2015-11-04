//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet   : FlexPoint
// Unit     : FInputBagCA : Form to do an INPUT for a BAG CA
//-----------------------------------------------------------------------------
// PVCS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FInputBagCA.pas,v 1.1 2006/12/22 15:28:52 NicoCV Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FInputBagCA - CVS revision 1.3
//=============================================================================

unit FInputBagCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, OvcBase, OvcEF, OvcPB, OvcPF, ScUtils, StdCtrls, Buttons;

//=============================================================================
// Global definitions
//=============================================================================

type
  TFrmInputBagCA = class(TFrmCommon)
    LblBagNumber: TLabel;
    SvcLFBagNumber: TSvcLocalField;
    OvcController1: TOvcController;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    FTxtBagNumber  : string;           // bag number to pass
  public
  published
    property TxtBagNumber : string read  FTxtBagNumber
                                   write FTxtBagNumber;
  end;

var
  FrmInputBagCA: TFrmInputBagCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,

  DFpn,
  DFpnUtils,
  RFpnTenderCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FInputBagCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FInputBagCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 15:28:52 $';

//*****************************************************************************
// Implementation of TFrmInputBagCA
//*****************************************************************************

procedure TFrmInputBagCA.BtnOKClick(Sender: TObject);
begin  // of TFrmInputBagCA.BtnOKClick
  if Length (Trim (SvcLFBagNumber.Text)) <> ViValWidthIdtBag then begin
    MessageDlg (Format(CtTxtBagInvalidLength,[IntToStr(ViValWidthIdtBag)]),
                mtWarning, [mbOk], 0);
    SvcLFBagNumber.Text := '';
    SvcLFBagNumber.SetFocus;
  end
  else begin
    TxtBagNumber := Trim (SvcLFBagNumber.Text);
  end;
end;   // of TFrmInputBagCA.BtnOKClick

//=============================================================================

procedure TFrmInputBagCA.FormCreate(Sender: TObject);
begin
  inherited;
  try
    if not Assigned (DmdFpn) then
      DmdFpn := TDmdFpn.Create (Self);
    if not Assigned (DmdFpnUtils) then
      DmdFpnUtils := TDmdFpnUtils.Create (Self);
    if DmdFpnUtils.QueryInfo
        (#10'SELECT ValWidtIdtBag = ValParam' +
         #10'FROM ApplicParam' +
         #10'WHERE IdtApplicParam = ' +
           AnsiQuotedStr('ValWidthIdtBag', '''')) then
      ViValWidthIdtBag := DmdFpnUtils.QryInfo.FieldByName ('ValWidtIdtBag').AsInteger
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FInputBagCA
