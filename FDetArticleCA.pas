//= Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved =
// Packet : FlexPoint Development
// Unit   : FDetArticle.PAS : Form DETail ARTICLE CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetArticleCA.pas,v 1.7 2010/02/19 11:25:57 BEL\DVanpouc Exp $
// History:
// - Started from Flexpoint 1.6 - revision 1.24
// Version   ModifiedBy      Reason
// 1.25      Teesta (TCS)    R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta
// 1.26      SPN(TCS)        R2013.2.ID31070.CAFR.Levels-and-rights-for-menus
//=============================================================================

unit FDetArticleCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetArticle, Db, OvcBase, ComCtrls, StdCtrls, ExtCtrls, CheckLst, Grids,
  DBGrids, OvcPF, ScUtils, DBCtrls, Buttons, OvcEF, OvcPB, OvcDbPF,
  cxMaskEdit, ScUtils_Dx, ScDBUtil_Ovc, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxDBEdit, ScDBUtil_Dx, ScDBUtil_BDE;

//=============================================================================
// TFrmDetArticleCA
//=============================================================================

type
  TFrmDetArticleCA = class(TFrmDetArticle)
    GbxImport: TGroupBox;
    SvcDBLblCodCountry: TSvcDBLabelLoaded;
    SvcDBLblNumberGTD: TSvcDBLabelLoaded;
    GbxEcoTax: TGroupBox;
    SvcDBLblPrcD3E: TSvcDBLabelLoaded;
    SvcDBLblFlgD3E: TSvcDBLabelLoaded;
    DBChkBxD3E: TDBCheckBox;
    SvcDBLFPrcD3E: TSvcDBLocalField;
    SvcDBMEISOCountry: TSvcDBMaskEdit;
    SvcDBMEGTDNumber: TSvcDBMaskEdit;
    DBLkpCbxCodBlocked: TDBLookupComboBox;
    SvcDBLblCodBlocked: TSvcDBLabelLoaded;
    DBLkpCbxCodLabelLayout: TDBLookupComboBox;
    SvcDBLblCodLabelLayout: TSvcDBLabelLoaded;
    TabShtGeneral2: TTabSheet;
    SbxGeneral2: TScrollBox;
    GbxServiceArticle: TGroupBox;
    SvcDBLblCodType: TSvcDBLabelLoaded;
    SvcDBLblFlgComment: TSvcDBLabelLoaded;
    DBChkBxComment: TDBCheckBox;
    DBLkpCbxCodType: TDBLookupComboBox;
    GbxPCB: TGroupBox;
    SvcDBLblQtyPCB: TSvcDBLabelLoaded;
    SvcDBLFQtyPCB: TSvcDBLocalField;
	// R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta.Start : Addition
    GbxMOBTax: TGroupBox;
    SvcDBLblFlgMOB: TSvcDBLabelLoaded;
    SvcDBLblPrcMOB: TSvcDBLabelLoaded;
    DBChkBxMOB: TDBCheckBox;
    SvcDBLFPrcMOB: TSvcDBLocalField;                                            
    procedure DBChkBxMOBClick(Sender: TObject); 
	// R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-KB.End : Addition                                
    procedure FormActivate(Sender: TObject);
    procedure DBChkBxD3EClick(Sender: TObject);
    //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN.Start
    procedure AdjustBtnsArtPLU; Override;
    procedure AdjustBtnsArtSupplier; Override;
    procedure AdjustBtnsArtPrice;  Override;
    procedure AdjustBtnsPromoArt;  Override;
    procedure AdjustBtnsArtShelf; Override;
    procedure AdjustDependIdtPersDiscount; Override;
    //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN.End
  private
    { Private declarations }
    FFlgRussia: boolean;
    FFlgEcoTax: boolean;
    FFlgBlock: boolean;
    FFlgSA: boolean;
    FFlgMOBTax: boolean;                                                        // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta
    FFlgRights: boolean;                                                        //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN
  protected
    procedure SetDataSetReferences; override;
  public
    { Public declarations }
    property FlgRussia: boolean read FFlgRussia write FFlgRussia;
    property FlgEcoTax: boolean read FFlgEcoTax write FFlgEcoTax;
    property FlgBlock: boolean read FFlgBlock write FFlgBlock;
    property FlgSA: boolean read FFlgSA write FFlgSA;
    property FlgMOBTax: boolean read FFlgMOBTax write FFlgMOBTax;               // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta
    property FlgRights: boolean read FFlgRights write FFlgRights;               //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN
  end;

var
  FrmDetArticleCA: TFrmDetArticleCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  sfDialog,
  smUtils,

  DFpnArticleCA, FMntArticleCA, SfDetail_BDE_DBC;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetArticleCA';
                                                
const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetArticleCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.25 $';
  CtTxtSrcDate    = '$Date: 2012/06/27 11:25:57 $';

//*****************************************************************************
// Implementation of TFrmDetArticleCA
//*****************************************************************************

procedure TFrmDetArticleCA.FormActivate(Sender: TObject);

begin  // of TFrmDetArticleCA.FormActivate
  inherited;
  // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta.Start : Addition
  if (CodJob in [CtCodJobRecNew,CtCodJobRecMod]) and (not FlgRights) then       //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN
    DBChkBxMOB.Enabled := True
  else if CodJob = CtCodJobRecCons then
    DBChkBxMOB.Enabled := False;
  // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta.End : Addition

  if FlgRussia then
    GbxImport.Visible := True
  else
    GbxImport.Hide;

  if not FlgEcoTax then
    GbxEcoTax.Hide;
  if not FrmMntArticleCA.FlgPCB then
    GbxPCB.Hide;

  if FlgBlock then begin
    SvcDBLblCodBlocked.Visible := True;
    DBLkpCbxCodBlocked.Visible := True;
  end
  else begin
    SvcDBLblCodBlocked.Hide;
    DBLkpCbxCodBlocked.Hide;
  end;

  if FlgSA then begin
    GbxServiceArticle.Visible := True;
    GbxServiceArticle.Enabled := True;
  end
  else begin
    GbxServiceArticle.Hide;
    //Because it is the only control on the tabsheet, we also hide the tabsheet
    TabShtGeneral2.TabVisible := False;
  end;

  // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta.Start : Addition
  if not FlgMOBTax then
    GbxMOBTax.Hide;
  // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta.End : Addition
end;   // of TFrmDetArticleCA.FormActivate

//=============================================================================

procedure TFrmDetArticleCA.SetDataSetReferences;
begin  // of TFrmDetArticleCA.SetDataSetReferences
  Inherited;
  DscArticle.DataSet := DmdFpnArticleCA.SprDetArticle;
end;   // of TFrmDetArticleCA.SetDataSetReferences

//=============================================================================

procedure TFrmDetArticleCA.DBChkBxD3EClick(Sender: TObject);
begin
  inherited;
  if CodJob <> CtCodJobRecCons then begin
    if DBChkBxD3E.Checked then
      SvcDBLFPrcD3E.Enabled := True
    else
      SvcDBLFPrcD3E.Enabled := False;
  end;
end;

//=============================================================================

// R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta.Start : Addition
procedure TFrmDetArticleCA.DBChkBxMOBClick(Sender: TObject);
begin
  inherited;
  if CodJob in [CtCodJobRecMod, CtCodJobRecNew] then begin
    if DBChkBxMOB.Checked then
      SvcDBLFPrcMOB.Enabled := True
    else
      SvcDBLFPrcMOB.Enabled := False;
  end;
end;
// R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta.End : Addition

//R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN :: Begin
procedure TFrmDetArticleCA.AdjustBtnsArtPLU;
begin
  if not FlgRights then
    inherited
end;
procedure TFrmDetArticleCA.AdjustBtnsArtSupplier;
begin
  if not FlgRights then
    inherited;
end;
procedure TFrmDetArticleCA.AdjustBtnsArtPrice;
begin
  if not FlgRights then
    inherited;
end;
procedure TFrmDetArticleCA.AdjustBtnsPromoArt;
begin
  if not FlgRights then
    inherited;
end;
procedure TFrmDetArticleCA.AdjustBtnsArtShelf;
begin
  if not FlgRights then
    inherited;
end;
procedure TFrmDetArticleCA.AdjustDependIdtPersDiscount;
begin
  if not FlgRights then
    inherited;
end;
//R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN :: End
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FDetArticleCA

