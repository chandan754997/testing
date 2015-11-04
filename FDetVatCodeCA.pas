//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Customer: Castorama
// Unit   : FDetVATCode : Form DETail VAT CODE
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetVatCodeCA.pas,v 1.4 2010/04/27 09:18:18 BEL\DVanpouc Exp $
// History:
// - Started from Flexpoint 2.0 - FDetVATCode - CVS revision 1.1
//=============================================================================

unit FDetVatCodeCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetVATCode, DB, ovcbase, ComCtrls, StdCtrls, Buttons, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit, ScDBUtil_Dx, ovcef,
  ovcpb, ovcpf, ovcdbpf, ScDBUtil_Ovc, ScDBUtil_BDE, ExtCtrls;

  //=============================================================================
// TFrmDetVATCodeCA
//=============================================================================

type
  TFrmDetVATCodeCA = class(TFrmDetVATCode)
  private
    { Private declarations }
  protected
    function IdtVatCodeExists (IdtVatCode: Integer) : Boolean; virtual;
  public
    { Public declarations }
    procedure AdjustDataBeforeSave; override;
  end;

var
  FrmDetVATCodeCA: TFrmDetVATCodeCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  DFpnUtils,
  SmUtils,
  SrStnCom,
  sfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetVATCodeCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetVatCodeCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2010/04/27 09:18:18 $';

//*****************************************************************************
// Implementation of TFrmDetVATCodeCA
//*****************************************************************************

procedure TFrmDetVATCodeCA.AdjustDataBeforeSave;
var
  IdtVatCode       : Integer;
begin  // of TFrmDetVATCodeCA.AdjustDataBeforeSave
  inherited;
  //Check if primary key does not exist yet
  if DmdFpnUtils.IdtTradeMatrixAssort <> '' then
    IdtVatCode := DscVatAssort.Dataset.FieldByName('NumVatCode').AsInteger
  else
    IdtVatCode := DscVatCode.Dataset.FieldByName('IdtVatCode').AsInteger;

  if (CodJob in [CtCodJobRecNew]) and (IdtVatCode <> 0)
   and (not FlgCurrentApplied) then begin
    if IdtVatCodeExists(IdtVatCode) then begin
      if DmdFpnUtils.IdtTradeMatrixAssort <> '' then begin
        if not SvcDBLFNumVATCodeOne.CanFocus then
          SvcDBLFNumVATCodeOne.Show;
        SvcDBLFNumVATCodeOne.SetFocus;
        raise Exception.Create (TrimTrailColon (SvcDBLblNumVATCodeOne.Caption) +
                                ' ' + CtTxtAlreadyExist);
      end
      else begin
        if not SvcDBLFIdtVATCode.CanFocus then
          SvcDBLFIdtVATCode.Show;
        SvcDBLFIdtVATCode.SetFocus;
        raise Exception.Create (TrimTrailColon (SvcDBLblIdtVATCode.Caption) +
                                ' ' + CtTxtAlreadyExist);
      end;
    end;
  end;
  if (CodJob in [CtCodJobRecNew]) and (IdtVatCode = 0)
   and (not FlgCurrentApplied)then begin
     if not SvcDBLFNumVATCodeOne.CanFocus then
       SvcDBLFNumVATCodeOne.Show;
        SvcDBLFNumVATCodeOne.SetFocus;
        raise Exception.Create (TrimTrailColon (SvcDBLblNumVATCodeOne.Caption) +
                                ' ' + CtTxtRequired); 
  end;
end;   // of TFrmDetVATCodeCA.AdjustDataBeforeSave

//=============================================================================

function TFrmDetVATCodeCA.IdtVatCodeExists(IdtVatCode: Integer): Boolean;
var
  txtSQL           : string;
begin  // of TFrmDetVATCodeCA.IdtVatCodeExists
  txtSQL :=  'SELECT * FROM VATCODE ' +
             ' WHERE IdtVatCode = ' + IntToStr(IdtVatCode);
  try
    if DmdFpnUtils.QueryInfo (txtSQL) then begin
      Result := True;
    end
    else
      Result := False;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetVATCodeCA.IdtVatCodeExists

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.
