//=========== Centric Retail Solutions (c) 2010 ===============================
// Packet : FlexPoint Development
// Unit   : FDetMunicipality.PAS : Form DETail MUNICIPALITY CAstorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetMunicipalityCA.pas,v 1.3 2010/02/12 12:55:42 BEL\KDeconyn Exp $
// History:
// - Started from Flexpoint 1.6 - revision 1.4
//=============================================================================

unit FDetMunicipalityCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetMunicipality, Db, OvcBase, ComCtrls, DBCtrls, StdCtrls, Buttons,
  OvcEF, OvcPB, OvcPF, OvcDbPF, ScDBUtil, ExtCtrls, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit, ScDBUtil_Dx, ScDBUtil_BDE;

//=============================================================================
// Global resourcestrings
//=============================================================================

resourcestring  // common messages
  CtTxtAlreadyExists   = 'Municipality already exists!';

//=============================================================================
// TFrmDetMunicipalityCA
//=============================================================================

type
  TFrmDetMunicipalityCA = class(TFrmDetMunicipality)
  private
    { Private declarations }
  protected
   { Protected declarations }
    procedure SetDataSetReferences; override;
    function MunicipalityIsUnique : boolean; virtual;
  public
    { Public declarations }
    procedure AdjustDBBeforeApply; override;
    procedure AdjustDataBeforeSave; override;
    procedure InCloseQueryCanDelete; override;
  end;

var
  FrmDetMunicipalityCA: TFrmDetMunicipalityCA;

implementation

{$R *.DFM}

uses
  ScTskMgr_BDE_DBC,
  SfDialog,
  SmDbUtil_BDE,
  SmUtils,
  SrStnCom,

  DFpnUtils,
  DFpnMunicipalityCA,
  DFpnMunicipality,
  RFpnCom;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetMunicipalityCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FDetMunicipalityCA.pas  $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2010/02/12 12:55:42 $';

//*****************************************************************************
// Implementation of TFrmDetMunicipalityCA
//*****************************************************************************

//=============================================================================
// TFrmDetMunicipalityCA - Overriding methods
//=============================================================================

procedure TFrmDetMunicipalityCA.SetDataSetReferences;
begin  // of TFrmDetMunicipalityCA.SetDataSetReferences
  inherited;
  DscMunicipality.DataSet := DmdFpnMunicipalityCA.QryDetMunicipality;
end;   // of TFrmDetMunicipalityCA.SetDataSetReferences

//=============================================================================

procedure TFrmDetMunicipalityCA.AdjustDBBeforeApply;
begin  // of TFrmDetMunicipalityCA.AdjustDBBeforeApply
  // Country is a required field
  if (CodJob in [CtCodJobRecNew, CtCodJobRecMod]) and (not MunicipalityIsUnique) then begin
    raise Exception.Create (CtTxtAlreadyExists);
  end;
  inherited;
end;   // of TFrmDetMunicipalityCA.AdjustDBBeforeApply

//=============================================================================

procedure TFrmDetMunicipalityCA.AdjustDataBeforeSave;
begin  // of TFrmDetMunicipalityCA.AdjustDataBeforeSave
  inherited;
  // Check PostCode
  if DscMunicipality.DataSet.FieldByName ('TxtCodPost').AsString = '' then begin
    if not SvcDBMETxtCodPost.CanFocus then
      SvcDBMETxtCodPost.Show;
    ActiveControl := SvcDBMETxtCodPost;
    raise Exception.Create
      (TrimTrailColon (SvcDBLblTxtCodPost.Caption) + ' ' + CtTxtRequired);
  end;
end;   // of TFrmDetMunicipalityCA.AdjustDataBeforeSave

//=============================================================================

function TFrmDetMunicipalityCA.MunicipalityIsUnique : Boolean;
var
  IdtMunicipality  : string;
  TxtSql           : string;
begin  // of TFrmDetMunicipalityCA.MunicipalityIsUnique
  inherited;
  try
    DmdFpnUtils.CloseInfo;
    DmdFpnUtils.ClearQryInfo;
    IdtMunicipality := StrLstIdtValues.Values['IdtMunicipality'];
    TxtSql :=
      'SELECT * FROM Municipality' +
      '  INNER JOIN Country' +
      '  ON Country.TxtName = ' + AnsiQuotedStr (DBLkpCbxIdtCountry.Text,'''') +
      'WHERE Municipality.TxtCodPost = ' + AnsiQuotedStr
                                            (SvcDBMETxtCodPost.Text,'''') +
      ' AND Municipality.TxtName = ' + AnsiQuotedStr
                                         (SvcDBMETxtName.Text,'''') +
      ' AND Municipality.IdtCountry = Country.IdtCountry';
    if IdtMunicipality <> '' then begin
      TxtSql := TxtSql +
                ' AND Municipality.IdtMunicipality <> ' + IdtMunicipality;
    end;
    if DmdFpnUtils.QueryInfo (TxtSql) then
      Result := False
    else
      Result := True;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetMunicipalityCA.MunicipalityIsUnique

//=============================================================================
// TFrmDetMunicipality.InCloseQueryCanDelete : Checks if the requested deletion
// is allowed. Is called from FormCloseQuery, before asking to confirm deletion.
// Checks that the IdtMunicipality about to be deleted is not use by any
// address.
//=============================================================================

procedure TFrmDetMunicipalityCA.InCloseQueryCanDelete;
var
  IdtMunicipality  : Integer;          // IdtMunicipality to check existance
begin  // of TFrmDetMunicipalityCA.InCloseQueryCanDelete
  IdtMunicipality := DscMunicipality.DataSet.FieldByName
                       ('IdtMunicipality').AsInteger;

  // Check if municipality exists in a the Address Table
  if DmdFpnMunicipalityCA.MunicipalityExistsInTable (IdtMunicipality,
                                                   'Address') then begin
    MessageDlg
      (Format (CtTxtEMDelLinked,
               ['Municipality',
                DscMunicipality.DataSet.FieldByName ('TxtCodPost').AsString +
                ' ' + DscMunicipality.DataSet.FieldByName ('TxtName').AsString,
                'addresses']),
       mtInformation, [mbOk], 0);
    ModalResult := mrCancel;
    Exit;
  end;
end;   // of TFrmDetMunicipalityCA.InCloseQueryCanDelete

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FDetMunicipalityCA
