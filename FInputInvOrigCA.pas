//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : FlexPoint
// Unit   : FVSRptInvoice = Form VideoSoft RePorT Invoice
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FInputInvOrigCA.pas,v 1.2 2007/02/01 16:21:55 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FInputInvOrigCA - CVS revision 1.1
//=============================================================================

unit FInputInvOrigCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, OvcBase, OvcEF, OvcPB, OvcPF, ScUtils, StdCtrls, Buttons,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx;

//=============================================================================
// Global definitions
//=============================================================================

resourcestring
  CtTxtInvalidInvNumber = 'The invoice does not exist.';

type
  TFrmInputInvOrigCA = class(TFrmCommon)
    LblInvoiceNumber: TLabel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    SvcMEInvoiceNumber: TSvcMaskEdit;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    FIdtInvoice: integer;
    { Private declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property IdtInvoice : integer read  FIdtInvoice
                                  write FIdtInvoice;
  end;

var
  FrmInputInvOrigCA: TFrmInputInvOrigCA;

//*****************************************************************************

implementation

uses
  SfDialog,
  DFpnUtils;

{$R *.DFM}



//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptInvoice';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FInputInvOrigCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2007/02/01 16:21:55 $';

//*****************************************************************************
// Implementation of TFrmInputInvOrigCA
//*****************************************************************************

procedure TFrmInputInvOrigCA.BtnOKClick(Sender: TObject);
begin
  if SvcMEInvoiceNumber.Text = '' then begin
    MessageDlg (CtTxtInvalidInvNumber, mtWarning, [mbOk], 0);
    SvcMEInvoiceNumber.Text := '';
    SvcMEInvoiceNumber.SetFocus;
    ModalResult := mrNone;
  end
  else begin
    //check if invoice exists
    DmdFpnUtils.QryInfo.Close;
    if DmdFpnUtils.QueryInfo
                ('SELECT IdtInvoice' +
                 #10'FROM PosTransInvoice' +
                 #10'WHERE IdtInvoice = ' + SvcMEInvoiceNumber.Text) then begin
      IdtInvoice := StrToInt(Trim (SvcMEInvoiceNumber.Text));
      ModalResult := mrOK;
    end
    else begin
      IdtInvoice := 0;
      MessageDlg (CtTxtInvalidInvNumber, mtWarning, [mbOk], 0);
      SvcMEInvoiceNumber.Text := '';
      SvcMEInvoiceNumber.SetFocus;
      ModalResult := mrNone;
    end;
    DmdFpnUtils.QryInfo.Close;
  end;
end;

//=============================================================================

procedure TFrmInputInvOrigCA.BtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  IdtInvoice := 0;
end;

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FInputBagCA
 