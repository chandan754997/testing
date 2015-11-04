//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet  : FlexPoint Development
// Customer: Castorama
// Unit    : FLstApplicParamCA : LIST form APPLICPARAM for CAstorama
//-----------------------------------------------------------------------------
// PVCS   :  $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstApplicParamCA.pas,v 1.1 2007/04/13 12:56:05 goegebkr Exp $
// History:
//=============================================================================

unit FLstApplicParamCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfList_BDE_DBC, Menus, ExtCtrls, DB, ovcbase, ComCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef, ovcpb, ovcpf,
  ScUtils, StdCtrls, Buttons, Grids, DBGrids;

//=============================================================================
// TFrmListApplicParamCA
//=============================================================================

type
  TFrmListApplicParamCA = class(TFrmList)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmListApplicParamCA: TFrmListApplicParamCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLstApplicParamCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstApplicParamCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2007/04/13 12:56:05 $';

//*****************************************************************************
// Implementation of TFrmLstApplicParamCA
//*****************************************************************************

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.   // of FLstApplicParamCA
