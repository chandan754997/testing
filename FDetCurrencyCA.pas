//=== Copyright 2010 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet : FlexPoint Development
// Unit   : FDetCurrency : Form DETail CURRENCY
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCurrencyCA.pas,v 1.2 2010/02/12 12:55:42 BEL\KDeconyn Exp $
//=============================================================================

unit FDetCurrencyCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetCurrency, DB, ovcbase, ComCtrls, ovcpf, ScUtils, StdCtrls,
  DBCtrls, ovcef, ovcpb, ovcdbpf, ScDBUtil_Ovc, Buttons, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit, ScDBUtil_Dx,
  ScDBUtil_BDE, ExtCtrls;

//=============================================================================
// TFrmDetCurrencyCA
//=============================================================================

type
  TFrmDetCurrencyCA = class(TFrmDetCurrency)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDetCurrencyCA: TFrmDetCurrencyCA;

//*****************************************************************************

implementation

uses SfDialog;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCurrencyCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCurrencyCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2010/02/12 12:55:42 $';

//*****************************************************************************
// Implementation of TFrmDetCurrency
//*****************************************************************************

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end. // of TFrmDetCurrencyCA
