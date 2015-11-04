//================= Real Software - Retail Division (c) 2006 ==================
// Packet   : FlexPoint 2.0.1
// Customer : Castorama
// Unit     : FDetTradeMatrixCA
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetTradeMatrixCA.pas,v 1.1 2006/12/18 15:22:24 hofmansb Exp $
// History:
//  - Started from Castorama - Flexpoint 2.0 - FDetTradeMatrixCA - CVS rev1.1
//=============================================================================

unit FDetTradeMatrixCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetTradeMatrix, Db, OvcBase, ComCtrls, Grids, DBGrids, DBCtrls,
  StdCtrls, Buttons, OvcEF, OvcPB, OvcPF, OvcDbPF, ScDBUtil, ExtCtrls,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit,
  ScDBUtil_Dx, ScDBUtil_BDE;

//=============================================================================
// TFrmDetTradeMatrixCA
//=============================================================================

type
  TFrmDetTradeMatrixCA = class(TFrmDetTradeMatrix)
    GbxRussia: TGroupBox;
    SvcDBLblTxtINN: TSvcDBLabelLoaded;
    SvcDBLblTxtKPP: TSvcDBLabelLoaded;
    SvcDBLblTxtOKPO: TSvcDBLabelLoaded;
    SvcDBLblTxtCompanyType: TSvcDBLabelLoaded;
    SvcDBMEINN: TSvcDBMaskEdit;
    SvcDBMEKPP: TSvcDBMaskEdit;
    SvcDBMEOKPO: TSvcDBMaskEdit;
    SvcDBMECompanyType: TSvcDBMaskEdit;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FFlgRussia: boolean;
  protected
    procedure SetDataSetReferences; override;
  public
    { Public declarations }
    property FlgRussia: boolean read FFlgRussia write FFlgRussia;
  end;

var
  FrmDetTradeMatrixCA: TFrmDetTradeMatrixCA;

//*****************************************************************************

implementation

uses sfdialog, DFpnTradeMatrixCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetTradeMatrixCA';

const  // CVS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetTradeMatrixCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/18 15:22:24 $';

//*****************************************************************************
// Implementation of TFrmDetTradeMatrix
//*****************************************************************************


procedure TFrmDetTradeMatrixCA.FormActivate(Sender: TObject);
begin
  inherited;
  if FlgRussia then
    GbxRussia.Visible := True
  else
    GbxRussia.Hide;
end;

//=============================================================================

procedure TFrmDetTradeMatrixCA.SetDataSetReferences;
begin  // of TFrmDetTradeMatrix.SetDataSetReferences
  DscTradematrix.DataSet := DmdFpnTradematrixCA.QryDetTradematrix;
  DscTMLanguage.DataSet  := DmdFpnTradematrixCA.QryDetTMLanguage;
end;   // of TFrmDetTradeMatrix.SetDataSetReferences

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of TFrmDetTradeMatrixCA


