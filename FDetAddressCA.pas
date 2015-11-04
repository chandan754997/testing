//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Unit   : FDetAddress.PAS : Form DETail ADDRESS
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetAddressCA.pas,v 1.5 2010/06/30 06:54:40 BEL\DVanpouc Exp $
// History:
// - Started from Flexpoint 1.6 - revision 1.13
//=============================================================================

unit FDetAddressCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetAddress, Db, OvcBase, ComCtrls, StdCtrls, CheckLst, ExtCtrls,
  DBCtrls, OvcPF, ScUtils, Buttons, OvcEF, OvcPB, OvcDbPF, cxMaskEdit,
  ScUtils_Dx, cxControls, cxContainer, cxEdit, cxTextEdit, cxDBEdit,
  ScDBUtil_Dx, ScDBUtil_Ovc, ScDBUtil_BDE;

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtErrVATFormatInvalid = 'The format of the CIF is invalid';

//=============================================================================
// TFrmDetAddressCA
//=============================================================================

type
  TFrmDetAddressCA = class(TFrmDetAddress)
    procedure BtnSelectCustomerClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FFlgVAT16              : Boolean;
    FFlgCheckVAT           : Boolean;    // Check VAT number?
    TxtVATNumber           : string;     // VAT number to check
    TxtVATNumberToSave     : string;     // VAT number to save
  protected
    { Protected declarations }
    procedure PerformChecksFlgCheckVAT; virtual;
    function CheckFormatVAT : Boolean; virtual;
  public
    { Public declarations }
    procedure AdjustDataBeforeSave; override;
    property FlgVAT16 : Boolean read FFlgVAT16 write FFlgVAT16;
    property FlgCheckVAT : Boolean read FFlgCheckVAT write FFlgCheckVAT;
  end;

var
  FrmDetAddressCA: TFrmDetAddressCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  OvcData,
  DBConsts,

  ScTskMgr_BDE_DBC,
  SfDialog,
  SmDBUtil_BDE,
  SmUtils,
  SrStnCom,

  DFpnUtils,
  DFpnAddress,
  DFpnCustomer,
  DFpnMunicipality,
  DFpnSupplier;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetAddressCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetAddressCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.5 $';
  CtTxtSrcDate    = '$Date: 2010/06/30 06:54:40 $';

//*****************************************************************************
// Implementation of TFrmDetAddressCA
//*****************************************************************************

procedure TFrmDetAddressCA.BtnSelectCustomerClick(Sender: TObject);
begin  // of TFrmDetAddressCA.BtnSelectCustomerClick
  StrLstRelatedIdt.Clear;
  StrLstRelatedIdt.Add ('IdtCustomer=');
  StrLstRelatedIdt.Add ('CodCreator=');
  if not DscAddress.DataSet.FieldByName ('IdtCustomer').IsNull then
    BuildStrLstFldValues (StrLstRelatedIdt, DscAddress.DataSet);
  if SvcTaskMgr.LaunchTask ('ListCustomerForAddress') then begin
    DscAddress.DataSet.Edit;
    DscAddress.DataSet.FieldByName ('IdtCustomer').Text :=
      StrLstRelatedIdt.Values['IdtCustomer'];
    DscAddress.DataSet.FieldByName ('CodCreator').Text :=
      StrLstRelatedIdt.Values['CodCreator'];
    SvcMECustomerTxtPublName.Text := StrLstRelatedInfo.Values['TxtPublName'];
  end;
end;   // of TFrmDetAddressCA.BtnSelectCustomerClick

//=============================================================================

procedure TFrmDetAddressCA.FormActivate(Sender: TObject);
begin // of TFrmDetAddressCA.FormActivate
  inherited;
  if FlgVAT16 then begin
    SvcDBMETxtNumVAT.Properties.MaxLength := 16;
  end
  else begin
    SvcDBMETxtNumVAT.Properties.MaxLength := 38;
  end;
end; // of TFrmDetAddressCA.FormActivate

//=============================================================================

procedure TFrmDetAddressCA.AdjustDataBeforeSave;
begin  // of TFrmDetAddressCA.AdjustDataBeforeSave
  inherited;
  if (CodJob in [CtCodJobRecNew,CtCodJobRecMod]) and FlgCheckVAT then
    PerformChecksFlgCheckVAT;
  if FlgCheckVAT and (CodJob in [CtCodJobRecNew,CtCodJobRecMod]) then begin
    DscAddress.DataSet.Edit;
    DscAddress.DataSet.FieldByName('TxtNumVat').Text := TxtVATNumberToSave;
    DscAddress.DataSet.Post;
  end;
end;   // of TFrmDetAddressCA.AdjustDataBeforeSave

//=============================================================================

procedure TFrmDetAddressCA.PerformChecksFlgCheckVAT;
begin  // of TFrmDetAddressCA.PerformChecksFlgCheckVAT
  TxtVATNumber := AnsiUpperCase(SvcDBMETxtNumVAT.Text);
 // if TxtVATNumber <> '' then begin
    if (Length (TxtVATNumber) > 1) then begin
      if (SameText (TxtVATNumber[1], 'N')) and (SameText (TxtVATNumber[2], 'E'))
      then
        TxtVATNumberToSave := Copy (TxtVATNumber, 3, Length (TxtVATNumber))
      else begin
        if not CheckFormatVAT then begin
          if not SvcDBMETxtNumVAT.CanFocus then
            SvcDBMETxtNumVAT.Show;
          ActiveControl := SvcDBMETxtNumVAT;
          raise Exception.Create (CtTxtErrVATFormatInvalid);
        end // of if not CheckFormatVAT (VATNumber)
        else
          TxtVATNumberToSave := TxtVATNumber;
      end; // of else begin
    end // of if (Length (TxtVATNumber) > 1)
    else begin
      if not SvcDBMETxtNumVAT.CanFocus then
        SvcDBMETxtNumVAT.Show;
       ActiveControl := SvcDBMETxtNumVAT;
       raise Exception.Create (CtTxtErrVATFormatInvalid);
    end; // of else begin
 // end; // of if TxtVATNumber <> ''
end; // of TFrmDetAddressCA.PerformChecksFlgCheckVAT

//=============================================================================

function TFrmDetAddressCA.CheckFormatVAT : Boolean;
var
  NumCount         : Integer;          // Integer for loop
  CountLetter      : Integer;          // Count letters in VAT number
  CountNumber      : Integer;          // Count numbers in VAT number
begin  // of TFrmDetAddressCA.PerformChecksFlgCheckVAT
  Result      := False;
  CountNumber := 0;
  CountLetter := 0;
  if (Length (TxtVATNumber) = 9) then begin
    if (TxtVATNumber[1] in ['A'..'Z'])  then
      CountLetter := CountLetter + 1;
    if (TxtVATNumber[Length (TxtVATNumber)] in ['A'..'Z']) then
      CountLetter := CountLetter + 1;
    for NumCount := 1 to Length (TxtVATNumber) do begin
      if TxtVATNumber[NumCount] in ['0'..'9'] then
        CountNumber := CountNumber + 1;
    end;
  end;
  if ((CountLetter = 1) and (CountNumber = 8)) or
     ((CountLetter = 2) and (CountNumber = 7)) then
    Result := True;
end;   // of TFrmDetAddressCA.PerformChecksFlgCheckVAT

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.
