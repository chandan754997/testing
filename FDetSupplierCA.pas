//=========== Sycron Computers Belgium (c) 1997-1999 ==========================
// Packet : FlexPoint Development
// Unit   : FDetSupplier.PAS : Form DETail SUPPLIER CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetSupplierCA.pas,v 1.1 2006/12/19 11:16:34 hofmansb Exp $
// History:
//
//=============================================================================

unit FDetSupplierCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetSupplier, Db, OvcBase, ComCtrls, Grids, DBGrids, DBCtrls, StdCtrls,
  Buttons, OvcEF, OvcPB, OvcPF, OvcDbPF, ExtCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit, ScDBUtil_Dx,
  ScDBUtil_Ovc, ScDBUtil_BDE;

//=============================================================================
// TFrmDetSupplierCA
//=============================================================================

type
  TFrmDetSupplierCA = class(TFrmDetSupplier)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure SetDataSetReferences; override;
  public
    { Public declarations }
  end;

var
  FrmDetSupplierCA: TFrmDetSupplierCA;

implementation

uses
  SfDialog,

  DFpnSupplierCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetSupplierCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetSupplierCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/19 11:16:34 $';

//*****************************************************************************
// Implementation of TFrmDetSupplierCA
//*****************************************************************************

procedure TFrmDetSupplierCA.SetDataSetReferences;
begin  // of TFrmDetSupplierCA.SetDataSetReferences
  inherited;
  DscSupplier.DataSet := DmdFpnSupplierCA.QryDetSupplier;
end;   // of TFrmDetSupplierCA.SetDataSetReferences

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);


end.
