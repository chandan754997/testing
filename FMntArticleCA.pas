//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Customer: Castorama
// Unit   : FMntArticleCA.PAS : MainForm MaiNTenance ARTICLE for Castorama
//-----------------------------------------------------------------------------
// CVS   :  $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntArticleCA.pas,v 1.8 2009/10/15 10:17:09 BEL\BHofmans Exp $
//=============================================================================
// Version    Modified by        Reason
// 1.9        Chayanika(TCS)     Regression Fix R2012.1
// 1.10       Teesta (TCS)       R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta
// 1.11       SPN (TCS)          R2013.2.ID31070.CAFR.Levels-and-rights-for-menus
unit FMntArticleCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FMntArticle, ScTskMgr_BDE_DBC;

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring  // for runtime parameters
  CtTxtRunParamRussia = 'Russia';
  CtTxtRunParamPCB    = '/VPCB=Quantity PCB can be entered';
  CtTxtRunParamBlock  = 'Blocking of article';
  CtTxtRunParamSA     = 'Service Article';
  CtTxtTitle          = 'Maintenance Article';                                 //Regression Fix R2012.1(Chayanika)
//=============================================================================
// TFrmMntArticleCA
//=============================================================================

type
  TFrmMntArticleCA = class(TFrmMntArticle)
    procedure FormActivate(Sender: TObject);                                   //Regression Fix R2012.1(Chayanika)
    procedure SvcTskDetArtShelfCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetArtPLUCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetArticleCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetArtPriceCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
    FFlgRussia: boolean;
    FFlgEcoTax: boolean;
    FFlgPCB   : Boolean;
    FFlgBlock: boolean;
    FFlgSA: boolean;
    FFlgMOBTax: boolean;                                                        // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta
    FFlgRights: boolean;                                                        //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN
  protected
    { Protected declarations }
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    property FlgRussia: boolean read FFlgRussia write FFlgRussia;
    property FlgEcoTax: boolean read FFlgEcoTax write FFlgEcoTax;
    property FlgPCB   : Boolean read FFlgPCB    write FFlgPCB;
    property FlgBlock: boolean read FFlgBlock write FFlgBlock;
    property FlgSA: boolean read FFlgSA write FFlgSA;
    property FlgMOBTax: boolean read FFlgMOBTax write FFlgMOBTax;               // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta
    property FlgRights: boolean read FFlgRights write FFlgRights;               //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN
  end;

var
  FrmMntArticleCA: TFrmMntArticleCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SfList_BDE_DBC,

  SmUtils,

  DFpn,
  DFpnUtils,

  DFpnArticleCA,
  FDetArticleCA,
  FDetArtPriceCA,
  DFpnCustomer,
  DFpnCustomerCA, FDetArtPLUCA, FDetArtShelfCA;

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntArticleCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntArticleCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.10 $';
  CtTxtSrcDate    = '$Date: 2012/09/27 10:17:09 $';

//*****************************************************************************
// Implementation of TFrmMntArticleCA
//*****************************************************************************

procedure TFrmMntArticleCA.BeforeCheckRunParams;
var
  TxtLeft         : string;
  TxtRight        : string;
begin  // of TFrmMntArticleCA.BeforeCheckRunParams
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  AddRunParams ('/VRussia', CtTxtRunParamRussia);
  SplitString (CtTxtRunParamPCB , '=', TxtLeft, TxtRight);
  AddRunParams (TxtLeft, TxtRight);
  AddRunParams ('/VBlock', CtTxtRunParamBlock);
  AddRunParams ('/VSA', CtTxtRunParamSA);
end;   // of TFrmMntArticleCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntArticleCA.CheckAppDependParams(TxtParam: string);
begin  // of TFrmMntArticleCA.CheckAppDependParams
  if CompareText (Copy (TxtParam, 1, 2), '/V') = 0 then begin
    if AnsiCompareText (copy(TxtParam, 3, 2), 'Ru') = 0 then begin
      FlgRussia := True;
    end
    else if AnsiCompareText (copy(TxtParam, 3, 3), 'D3E') = 0 then begin
      FlgEcoTax := True;
    end
    else if AnsiCompareText (copy(TxtParam, 3, 5), 'Block') = 0 then begin
      FlgBlock := True;
    end
    else if AnsiCompareText (copy(TxtParam, 3, 2), 'SA') = 0 then begin
      FlgSA := True;
    end
    else if AnsiCompareText (copy(TxtParam, 3, 3), 'PCB') = 0 then begin
      FlgPCB := True;
    end                                                                                   // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta
    // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta.Start : Addition
    else if AnsiCompareText (copy(TxtParam, 3, 3), 'MOB') = 0 then begin
      FlgMOBTax := True;
    end
    // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta.End : Addition
    else if AnsiCompareText (copy(TxtParam, 3, 6), 'Rights') = 0 then begin     //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN
      FlgRights := True;
    end;
  end;
end;   // of TFrmMntArticleCA.CheckAppDependParams

//=============================================================================

procedure TFrmMntArticleCA.SvcTskDetArticleCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntArticleCA.SvcTskDetArticleCreateExecutor
  inherited;

  NewObject := TFrmDetArticleCA.Create (Self);
  TFrmDetArticleCA(NewObject).PnlIdtShelfCombo.Visible := FlgComboArtShelf;
  TFrmDetArticleCA(NewObject).PnlIdtShelfSelect.Visible :=
    not TFrmDetArticleCA(NewObject).PnlIdtShelfCombo.Visible;
  TFrmDetArticleCA(NewObject).FlgRussia := FlgRussia;
  TFrmDetArticleCA(NewObject).FlgEcoTax := FlgEcoTax;
  TFrmDetArticleCA(NewObject).FlgBlock := FlgBlock;
  TFrmDetArticleCA(NewObject).FlgSA := FlgSA;
  TFrmDetArticleCA(NewObject).FlgMOBTax := FlgMOBTax;                           // R2011.2(Adhoc).ID17303.EcoTaxREPMOB.BDFR/CAFR.TCS-Teesta
  TFrmDetArticleCA(NewObject).FlgRights := FlgRights;                           //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN
  //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN :: Start
  if FlgRights then
  begin
    TFrmDetArticleCA(NewObject).SvcLFArtPLUNumPLU.Enabled := False;
    TFrmDetArticleCA(NewObject).ChxFlgKlapper.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBMEIdtClassification.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcMEClassificationTxtPublDescr.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnSelectClassification.Enabled := False;
    TFrmDetArticleCA(NewObject).DBLkpCbxPctVAT.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcMEVATCodeTxtPublDescr.Enabled := False;
    TFrmDetArticleCA(NewObject).DBLkpCbxCodSalesUnit.Enabled := False;
    TFrmDetArticleCA(NewObject).DBChxFlgFood.Enabled := False;
    TFrmDetArticleCA(NewObject).DBChxFlgActive.Enabled := False;
    TFrmDetArticleCA(NewObject).DBLkpCbxCodContents.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBLFQtyIndivCons.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBLFQtyIndivPurch.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBLFQtyContents.Enabled := False;
    TFrmDetArticleCA(NewObject).DBChxFlgLabel.Enabled := False;
    TFrmDetArticleCA(NewObject).DBLkpCbxCodLabelLayout.Enabled := False;
    TFrmDetArticleCA(NewObject).DBChxFlgAd.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnNewArtPLU.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnEditArtPLU.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnRemoveArtPLU.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnMainArtPLU.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnConnectArtSupplier.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnEditArtSupplier.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnRemoveArtSupplier.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnMainArtSupplier.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnNewArtPrice.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnEditArtPrice.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnRemoveArtPrice.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnConnectPromo.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBMEIdtArtMake.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcMEArtMakeTxtName.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnSelectArtMake.Enabled := False;
    TFrmDetArticleCA(NewObject).DBLkpCbxIdtPersDiscount.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnRemovePersDiscount.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBMEIdtArtMain.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcMEArtMainTxtPublDescr.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnSelectArtMain.Enabled := False;
    TFrmDetArticleCA(NewObject).DBLkpCbxCodPrcStop.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBLFDatOutAssort.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBLFDatCreate.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBLFDatModify.Enabled := False;
    TFrmDetArticleCA(NewObject).DBChkBxD3E.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBLFPrcD3E.Enabled := False;
    TFrmDetArticleCA(NewObject).DBChkBxMOB.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBLFPrcMOB.Enabled := False;
    TFrmDetArticleCA(NewObject).SvcDBLFQtyPCB.Enabled := False;
    TFrmDetArticleCA(NewObject).BtnConnectArtShelf.Enabled := False;
  end;
  //R2013.2.ID31070.CAFR.Levels-and-rights-for-menus.TCS-SPN :: End
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntArticleCA.SvcTskDetArticleCreateExecutor

//=============================================================================

procedure TFrmMntArticleCA.SvcTskDetArtPriceCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin
  NewObject := TFrmDetArtPriceCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;

//=============================================================================

procedure TFrmMntArticleCA.SvcTskDetArtPLUCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntArticleCA.SvcTskDetArtPLUCreateExecutor
  NewObject := TFrmDetArtPLUCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntArticleCA.SvcTskDetArtPLUCreateExecutor

//=============================================================================

procedure TFrmMntArticleCA.SvcTskDetArtShelfCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntArticleCA.SvcTskDetArtShelfCreateExecutor
  inherited;

  NewObject := TFrmDetArtShelfCA.Create (Self);
  TFrmDetArtShelfCA(NewObject).PnlInfoBottomCombo.Visible := FlgComboArtShelf;
  TFrmDetArtShelfCA(NewObject).PnlInfoBottomSelect.Visible :=
    not TFrmDetArtShelfCA(NewObject).PnlInfoBottomCombo.Visible;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntArticleCA.SvcTskDetArtShelfCreateExecutor

//=============================================================================
// Regression Fix R2012.1(Chayanika) :: START
procedure TFrmMntArticleCA.FormActivate(Sender: TObject);
begin
  inherited;
  Application.Title:= CtTxtTitle;
end;
// Regression Fix R2012.1(Chayanika) :: END
//=============================================================================
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.   // of FrmMntArticleCA

