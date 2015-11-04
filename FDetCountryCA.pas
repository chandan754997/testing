//================= Real Software - Retail Division (c) 2006 ==================
// Packet   : FlexPoint 2.0.1
// Customer : Castorama
// Unit     : FDetCountryCA.PAS : : Form DETail COUNTRY CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCountryCA.pas,v 1.2 2006/12/20 13:00:38 JurgenBT Exp $
// History:
//  - Started from Castorama - Flexpoint 2.0 - FDetCountryCA - CVS revision 1.2
//=============================================================================

unit FDetCountryCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetCountry, Db, OvcBase, ComCtrls, StdCtrls, Buttons, OvcEF, OvcPB,
  OvcPF, OvcDbPF, ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDBEdit, ScDBUtil_Dx, ScDBUtil_Ovc, ScDBUtil_BDE;

//=============================================================================
// Global type definitions
//=============================================================================

type
  TFrmDetCountryCA = class(TFrmDetCountry)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDetCountryCA: TFrmDetCountryCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SmUtils,
  SfDialog,
  ScTskMgr_BDE_DBC,

  DFpnUtils,
  DFpnCountry;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCountry';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FDetCountry.pas  $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2006/12/20 13:00:38 $';

//=============================================================================

{ TFrmDetCountryCA }

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.
