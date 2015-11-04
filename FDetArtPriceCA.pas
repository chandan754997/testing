//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Unit   : FDetArtPriceCA.PAS : Form DETail ARTicle PRICE CAstorama
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetArtPriceCA.pas,v 1.4 2009/09/28 13:16:16 BEL\KDeconyn Exp $
// History:
// - Started from Flexpoint 1.6 - revision 1.25
//=============================================================================

unit FDetArtPriceCa;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetArtPrice, Db, OvcBase, ComCtrls, ExtCtrls, Grids, DBGrids, StdCtrls,
  CheckLst, DBCtrls, Buttons, OvcPF, ScUtils, OvcEF, OvcPB, OvcDbPF,
  ScDBUtil, ScDBUtil_Ovc, cxMaskEdit, ScUtils_Dx, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxDBEdit, ScDBUtil_Dx, ScDBUtil_BDE;

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtDuplKeyArtPrice = 'There already exists a price with this begin date.';

//=============================================================================
// TFrmDetArtPriceCA
//=============================================================================

type
  TFrmDetArtPriceCA = class(TFrmDetArtPrice)
  private
    { Private declarations }
  protected
    { Protected declarations }
    // Overriden methods
    procedure SetDataSetReferences; override;
  public
    { Public declarations }
    procedure CheckPriceExistsBeforeSave; virtual;
    procedure AdjustDataBeforeSave; override;
  end;

var
  FrmDetArtPriceCA: TFrmDetArtPriceCA;

//*****************************************************************************

implementation

uses
  sfDialog,

  SmUtils,
  DFpnArtPrice,
  DFpnArtPriceCA,
  DFpnUtils,
  SrStnCom;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetArtPriceCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetArtPriceCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 13:16:16 $';

//*****************************************************************************
// Implementation of TFrmDetArtPriceCA
//*****************************************************************************

//=============================================================================
// TFrmDetArtPriceCA - Protected methods
//=============================================================================

procedure TFrmDetArtPriceCA.SetDataSetReferences;
begin  // of TFrmDetArtPriceCA.SetDataSetReferences
  inherited;
  DscDetArtPrice.DataSet := DmdFpnArtPriceCA.QryDetArtPrice;
end;   // of TFrmDetArtPriceCA.SetDataSetReferences

//=============================================================================

procedure TFrmDetArtPriceCA.AdjustDataBeforeSave;
begin // of TFrmDetArtPriceCA.AdjustDataBeforeSave
  // Check if there are no duplicates
  CheckPriceExistsBeforeSave;
  // Article number
  if DscDetArtPrice.DataSet.FieldByName ('IdtArticle').IsNull then begin
    if not SvcDBMEIdtArticle.CanFocus then
      SvcDBMEIdtArticle.Show;
    SvcDBMEIdtArticle.SetFocus;
    raise ESvcLocalScope.Create (TrimTrailColon (SvcDBLblIdtArticle.Caption) +
                                 ' ' + CtTxtRequired);
  end;
  CheckTypeBeforeSave;
  // Currency: IdtCurrency has to be filled in
  if (DscDetArtPrice.DataSet.FieldByName ('IdtCurrency').IsNull) then begin
    if not DbLkpCbxIdtCurrency.CanFocus then
      DBLkpCbxIdtCurrency.Show;
    DBLkpCbxIdtCurrency.SetFocus;
    raise ESvcLocalScope.Create (TrimTrailColon (SvcDBLblIdtCurrency.Caption) +
                                 ' ' + CtTxtRequired);
  end;   // of check IdtCurrency
end; // of TFrmDetArtPriceCA.AdjustDataBeforeSave

//=============================================================================

procedure TFrmDetArtPriceCA.CheckPriceExistsBeforeSave;
var
  SvcDBLFDatBegin  : TSvcDBLocalField; // Current focused DatBegin field
  TxtTypePrice     : string;           // Type of price
begin  // of TFrmDetArtPriceCA.CheckPriceExistsBeforeSave
  if (CodJob <> CtCodJobRecNew) or FlgCurrentApplied then
    Exit;
  // Check whether artprice already exists
  if not DmdFpnArtPriceCA.ArtPriceExists (DscDetArtPrice.DataSet) then
    Exit;
  TxtTypePrice := DBLkpCbxCodType.Text;
    case CurrCodType of
    CtCodPrcSupplier : begin
      // New Purchase Price (NPP)
      SvcDBLFDatBegin := SvcDBLFNPPDatBegin;
    end;
    CtCodPrcTradeMatrix, CtCodPrcCustPrcCat, CtCodPrcCustomer : begin
      if DscDetArtPrice.DataSet.FieldByName ('IdtCampaign').IsNull then
        // New Sales Price (NSP)
        SvcDBLFDatBegin := SvcDBLFNSPDatBegin
      else
        // New Campaign Price (NCP)
        SvcDBLFDatBegin := SvcDBLFNCPDatBegin;
    end;
    CtCodPrcCompetitor : begin
      // New Competitor Price (NCompP)
      SvcDBLFDatBegin := SvcDBLFNCompPDatBegin;
    end;
    else
      // New Miscellaneous Price (NMiscP)
      SvcDBLFDatBegin := SvcDBLFNMiscPDatBegin;
  end;  // of case CurrCodType of ...
  if not SvcDBLFDatBegin.CanFocus then begin
    PgeCtlDetail.ActivePage := TabShtPrice;
    if Assigned (PgeCtlDetail.OnChange) then
      PgeCtlDetail.OnChange (SvcDBLFDatBegin);
    SvcDBLFDatBegin.Show;
  end;
  SvcDBLFDatBegin.SetFocus;
  raise ESvcLocalScope.Create (CtTxtDuplKeyArtPrice);
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FDetArtPriceCA

