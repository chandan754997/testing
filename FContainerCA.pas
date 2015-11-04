//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : FlexPoint 2.0
// Unit     : FContainerCA = Form ask for CONTAINER CAstorama
//-----------------------------------------------------------------------------
// PVCS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FContainerCA.pas,v 1.3 2009/06/15 12:13:25 BEL\DVanpouc Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FContainerCA - CVS revision 1.2
// Version          ModifiedBy             Reason
// 1.21             TCS  (TCS)             R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques
//=============================================================================

unit FContainerCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, StdCtrls, Buttons, OvcBase, OvcEF, OvcPB, OvcPF, ScUtils,
  DFpnTenderGroup;

resourcestring
  // string formcaption with tendergroup
  CtTxtFormCaption        = 'Container for %s';
  // Warning message for not filling in the container after pressing BtnAccept
  CtTxtWarningNoContainer = 'Container is required';
  CtTxtWarningDuplicateContainer = 'Container already exists';
  CtTxtNbrOfCheques              = 'Number of Cheques';                         //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

//*****************************************************************************
// Global definitions
//*****************************************************************************

type
  TFrmContainerCA = class(TFrmCommon)
    SvcLFContainer: TSvcLocalField;
    OvcCtlContainer: TOvcController;
    LblContainer: TLabel;
    BtnCancel: TBitBtn;
    BtnAccept: TBitBtn;
    LblValTotal: TLabel;
    LblQtyTotal: TLabel;
    SvcLFQtyTotal: TSvcLocalField;
    SvcLFValTotal: TSvcLocalField;
    procedure BtnAcceptClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  protected
    { Protected declarations }
    FObjTenderGroup : TObjTenderGroup; // TenderGroup Object         (passed)
    FQtyTotal       : Currency;        // Total number of bags       (passed)
    FValTotal       : Currency;        // Total amount over all bags (passed)
    FQtyCheq        : Currency;        // Total number of cheques    (passed)   //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
    FIdtContainer   : string;          // IdtContainer               (returned)
  published
    { Published declarations }
    // Properties passed and returned
    property ObjTenderGroup : TObjTenderGroup  read  FObjTenderGroup
                                               write FObjTenderGroup;
    property QtyTotal       : Currency         read  FQtyTotal
                                               write FQtyTotal;
    property ValTotal       : Currency         read  FValTotal
                                               write FValTotal;
    property IdtContainer   : string           read  FIdtContainer
                                               write FIdtContainer;
    property QtyCheq        : Currency         read  FQtyCheq
                                               write FQtyCheq;                  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

  end; // of TFrmContainerCA

var
  FrmContainerCA: TFrmContainerCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  DFpnBagCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FContainerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FContainerCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.21 $';
  CtTxtSrcDate    = '$Date: 2014/01/29 12:13:25 $';

//=============================================================================
// Implementation of TFrmContainerCA
//=============================================================================

procedure TFrmContainerCA.BtnAcceptClick(Sender: TObject);
begin // of TFrmContainerCA.BtnAcceptClick
  IdtContainer := SvcLFContainer.Text;
  if not Assigned (DmdFpnBagCA) then
    DmdFpnBagCA := TDmdFpnBagCA.Create (Self);
  if DmdFpnBagCA.FindContainer (IdtContainer) then begin
    MessageDlg (CtTxtWarningDuplicateContainer, mtWarning, [mbOK], 0);
    ModalResult := mrNone;
    SvcLFContainer.SetFocus;
  end;
  if SvcLFContainer.Text =  '             ' then begin
    MessageDlg (CtTxtWarningNoContainer, mtWarning, [mbOK], 0);
    ModalResult := mrNone;
    SvcLFContainer.SetFocus;
  end;
end;  // of TFrmContainerCA.BtnAcceptClick

//=============================================================================

procedure TFrmContainerCA.FormActivate(Sender: TObject);
begin // of TFrmContainerCA.FormActivate
  inherited;
  IdtContainer := '';
  Caption := Format (CtTxtFormCaption, [ObjTenderGroup.TxtPublDescr]);
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if ObjTenderGroup.TxtPublDescr = CtTxtBankCheques then
  begin
    LblQtyTotal.Caption := CtTxtNbrOfCheques;
    SvcLFQtyTotal.AsFloat := QtyCheq;
  end
  else
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  SvcLFQtyTotal.AsFloat := QtyTotal;
  SvcLFValTotal.PictureMask := '###,###.## ' + ObjTenderGroup.IdtCurrency;
  SvcLFValTotal.AsFloat := ValTotal;
  SvcLFContainer.Text:= '';
  SvcLFContainer.SetFocus;
end;  // of TFrmContainerCA.FormActivate

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
