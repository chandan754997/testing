//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Unit   : FDetClassificationCA : Form DETail CLASSIFICATION CAstorama
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetClassificationCA.pas,v 1.2 2009/09/30 10:07:49 BEL\KDeconyn Exp $
// History:
// - Started from Flexpoint 2.0 - FDetClassification - CVS revision 1.2
//=============================================================================

unit FDetClassificationCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetClassification, DB, ovcbase, ComCtrls, StdCtrls, Grids, DBGrids,
  DBCtrls, ovcef, ovcpb, ovcpf, ovcdbpf, ScDBUtil_Ovc, Buttons, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit, ScDBUtil_Dx,
  ScDBUtil_BDE, ExtCtrls;

//=============================================================================
// TFrmDetClassificationCA
//=============================================================================

type
  TFrmDetClassificationCA = class(TFrmDetClassification)
  private
    { Private declarations }
  protected
    FFlgAllowDuplicates: boolean;
  public
    { Public declarations }
    procedure AdjustDataBeforeSave; override;
    property FlgAllowDuplicates: boolean read FFlgAllowDuplicates
                                        write FFlgAllowDuplicates;
  end;

var
  FrmDetClassificationCA: TFrmDetClassificationCA;

//*****************************************************************************

implementation

uses
  SfDialog;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetClassificationCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetClassificationCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/30 10:07:49 $';

//*****************************************************************************
// Implementation of TFrmDetClassificationCA
//*****************************************************************************

procedure TFrmDetClassificationCA.AdjustDataBeforeSave;
begin // of TFrmDetClassificationCA.AdjustDataBeforeSave
  if not FlgAllowDuplicates then
    inherited;
end; // of TFrmDetClassificationCA.AdjustDataBeforeSave

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   //of FDetClassification
