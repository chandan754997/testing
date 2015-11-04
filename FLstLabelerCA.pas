//=== Copyright 2009 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FLstLabelerCA : Form LiST LABELER CAstorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstLabelerCA.pas,v 1.13 2009/09/28 13:16:16 BEL\KDeconyn Exp $
//=============================================================================

unit FLstLabelerCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FLstLabeler, l11, Menus, ExtCtrls, DB, ovcbase, ComCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef, ovcpb, ovcpf,
  ScUtils, StdCtrls, Buttons, Grids, DBGrids, DBTables;

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring  // Errors
  CtTxtEMImportNotFound      = 'Import file %s not found';
  CtTxtEMLayoutNotFound      = 'Label layout file %s not found';
  CtTxtEMLayoutNotDefined    = 'Label layout for %s not defined';
  CtTxtEMNoLayoutsFound      = 'No label layouts found';

resourcestring  // Messages
  CtTxtWMLabelType = 'Make sure that the sheets for label layout %s are ' +
                     'inserted in the printer';

//=============================================================================
// Constants - Variable names (names of List&Label variables) and default
// values for the List&Label variables.
//                                  -----
// The constants are ordened in logical groups of variables connected to
// each other.
// For almost all printeable data, we need a name for a Label, a name for a
// Variable and a default vaulue. The 3 constants to declare those 3 properties
// are declared together.
//                                  -----
// Naming rules for the constants below:
// - CtTxtLbl = List&Label variable which contents is filled with constant
//              text (used to print titles on the Label).
// - CtTxtVar = List&Label variable which contents is filled per Label with
//              data for the current Label.
// - CtTxtDef = default value for List&Label variable.
//=============================================================================

//-----------------------------------------------------------------------------
// Group ShopInfo - List&Label variables and defaults
//-----------------------------------------------------------------------------

const
  // Supervisor
  CtTxtLblTxtPriceSupervisor = 'Labels.ShopInfo.LBL PriceSupervisor';
  CtTxtVarTxtPriceSupervisor = 'ShopInfo.PriceSupervisor';
  CtTxtDefTxtPriceSupervisor = 'ShopInfo PriceSupervisor';
  // Price Bureau
  CtTxtLblTxtPriceBureau     = 'Labels.ShopInfo.LBL PriceBureau';
  CtTxtVarTxtPriceBureau     = 'ShopInfo.PriceBureau';
  CtTxtDefTxtPriceBureau     = 'ShopInfo PriceBureau';
  // CHS Price Bureau
  CtTxtLblTxtPriceBureauCHS  = 'Labels.ShopInfo.LBL PriceBureauCHS';
  CtTxtVarTxtPriceBureauCHS  = 'ShopInfo.PriceBureauCHS';
  CtTxtDefTxtPriceBureauCHS  = 'ShopInfo PriceBureauCHS';

//-----------------------------------------------------------------------------
// Group ArticleCommon - List&Label variables and defaults for common Article
// data.
//-----------------------------------------------------------------------------
const
  // Article ValHeight
  CtTxtLblValHeight          = 'Labels.Article.LBL ValHeight';
  CtTxtVarValHeight          = 'Article.ValHeight';
  CtTxtDefValHeight          = '999999';
  // Article ValLength
  CtTxtLblValLength          = 'Labels.Article.LBL ValLength';
  CtTxtVarValLength          = 'Article.ValLength';
  CtTxtDefValLength          = '999999';
  // Article ValWidth
  CtTxtLblValWidth           = 'Labels.Article.LBL ValWidth';
  CtTxtVarValWidth           = 'Article.ValWidth';
  CtTxtDefValWidth           = '999999';
  // Article Model
  CtTxtLblTxtModel           = 'Labels.Article.LBL Model';
  CtTxtVarTxtModel           = 'Article.Model';
  CtTxtDefTxtModel           = 'Article Model';
  // Article Grade
  CtTxtLblTxtGrade           = 'Labels.Article.LBL Grade';
  CtTxtVarTxtGrade           = 'Article.Grade';
  CtTxtDefTxtGrade           = 'Article Grade';
  // Article Area
  CtTxtLblTxtArea            = 'Labels.Article.LBL Area';
  CtTxtVarTxtArea            = 'Article.Area';
  CtTxtDefTxtArea            = 'Article Area';
  // Article CodSalesUnit
  CtTxtLblCodSalesUnit       = 'Labels.Article.LBL CodSalesUnit';
  CtTxtVarCodSalesUnit       = 'Article.CodSalesUnit';
  CtTxtDefCodSalesUnit       = 'Article CodSalesUnit';
  // Article TxtSalesUnit
  CtTxtLblTxtSalesUnit       = 'Labels.Article.LBL TxtSalesUnit';
  CtTxtVarTxtSalesUnit       = 'Article.TxtSalesUnit';
  CtTxtDefTxtSalesUnit       = 'Article TxtSalesUnit';
  // Article TxtUnit
  CtTxtLblTxtUnit            = 'Labels.Article.LBL TxtUnit';
  CtTxtVarTxtUnit            = 'Article.TxtUnit';
  CtTxtDefTxtUnit            = 'Article TxtUnit';

//=============================================================================
// TFrmLstLabelerCA
//=============================================================================

type
  TFrmLstLabelerCA = class(TFrmLstLabeler)
    BtnImport: TSpeedButton;
    MniImport: TMenuItem;
    procedure MniRecDeSelAllClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MniCombitLLClick(Sender: TObject);
    procedure MniClearClick(Sender: TObject);
    procedure CLLLabelerViewerButtonClicked(Sender: TObject;
      Button: TViewerButton; var PerformDefaultAction: Boolean);
    procedure MniSeqRefreshClick(Sender: TObject);
    procedure MniPrintClick(Sender: TObject);
    procedure MniImportClick(Sender: TObject);
  private
    { Private declarations }
    FlgPreviewPrintBtnPressed : Boolean;  // Button print pressed in preview
  protected
    { Protected declarations }
    StrLstLabelTypes : TStringList;    // list of label types
    CurrentLabelType : Integer;        // CurrentLabelType
    FlgLayoutSkipped : Boolean;        // Flag Layout skipped
    function GetDefaultReport : string; override;
    procedure SetLabelerTask (Value : Integer); override;
    // Group ShopInfo
    procedure TextListReportAddLblsGrpShopInfo; override;
    procedure LLViewDefineLblsGrpShopInfo; override;
    procedure LLViewDefineVarsGrpShopInfo; override;
    procedure LLVarsUsedInitGrpShopInfo (FlgInit : Boolean); override;
    procedure LLVarsUsedFillInGrpShopInfo; override;
    procedure LLViewSetVarValuesGrpShopInfo; override;
    // Group Article
    procedure TextListReportAddLblsGrpArticleCommon; override;
    procedure LLViewDefineLblsGrpArticleCommon; override;
    procedure LLViewDefineVarsGrpArticleCommon; override;
    procedure LLVarsUsedInitGrpArticleCommon (FlgInit : Boolean); override;
    procedure LLVarsUsedFillInGrpArticleCommon; override;
    procedure LLViewSetVarValuesGrpArticleCommon (QryInfo : TQuery); override;
    procedure FillLabelTypesFromDB (StrLstLabelTypes : TStringList); virtual;
    procedure ClearQtyLabelTypes; virtual;
    procedure ChangeItemSelected (TxtItem   : string;
                                  FlgSelect : Boolean); override;
  public
    { Public declarations }
    function LocateSelectedRow (QryInfo : TQuery) : Boolean; override;
    procedure LLPrint (FlgPreview : Boolean); override;
    procedure LLViewInitOnStartPrint (FlgPreview : Boolean;
                                  var NumReturn  : Integer); reintroduce;
    procedure ConvertToPropertiesInDmd; override;
  end;

var
  FrmLstLabelerCA: TFrmLstLabelerCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  Consts,

  CMBTll11,

  SfDialog,
  SmUtils,
  SmWinApi,

  DFpnLabeler,
  DFpnLabelerCA,
  DFpnUtils,
  DFpnUtilsCA,
  DFpnArticleCA,

  FInputLabelerCA,

  RFpnCom,

  SfList_BDE_DBC,
  SfListMultiSel_BDE_DBC;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLstLabelerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstLabelerCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.13 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 13:16:16 $';

//*****************************************************************************
// Implementation of TFrmLabelerCA
//*****************************************************************************

//=============================================================================
// TFrmLstLabeler - Methods for read & write properties
//=============================================================================

function TFrmLstLabelerCA.GetDefaultReport : string;
begin  // of TFrmLstLabelerCA.GetDefaultReport
  if LabelerTask in [CtCodLtkCustFree] then
    result := inherited GetDefaultReport
  else begin
    if not Assigned (StrLstLabelTypes) or (StrLstLabelTypes.Count = 0)  then
      Result := ''
    else begin
      if LabelerTask = CtCodLtkArtPrcCamp then
        Result :=
          TLabelType (StrLstLabelTypes.Objects[CurrentLabelType]).ReportCamp
      else
        Result :=
          TLabelType (StrLstLabelTypes.Objects[CurrentLabelType]).ReportNorm;
    end;
  end;
end;   // of TFrmLstLabelerCA.GetDefaultReport

//=============================================================================

procedure TFrmLstLabelerCA.SetLabelerTask (Value : Integer);
begin  // of TFrmLstLabelerCA.SetLabelerTask
  inherited;
  // Type-RadioGroup never visible
  RgpType.Visible   := False;          // Advertisements are not possible
  BtnReport.Visible := False;          // Choosing aleternative report not
  BtnReport.Enabled := False;          // allowed
  MniReport.Visible := False;
  MniReport.Enabled := False;
end;   // of TFrmLstLabeler.SetLabelerTask

//=============================================================================
// TFrmLstLabelerCA.TextListReportAddLblsGrpShopInfo : adds all Labels for
// group ShopInfo to the TextList for getting ReportTitles from ApplicText.
//=============================================================================

procedure TFrmLstLabelerCA.TextListReportAddLblsGrpShopInfo;
begin  // of TFrmLstLabelerCA.TextListReportAddLblsGrpShopInfo
  inherited;
  TextListReportAddLabel (CtTxtLblTxtPriceSupervisor);
  TextListReportAddLabel (CtTxtLblTxtPriceBureau);
  TextListReportAddLabel (CtTxtLblTxtPriceBureauCHS);
end;   // of TFrmLstLabelerCA.TextListReportAddLblsGrpShopInfo

//=============================================================================
// TFrmLstLabelerCA.LLViewDefineLblsGrpShopInfo : defines all Labels
// (= List&Label variables used for constant text) that can be printed
// on a label of list for group ShopInfo.
//=============================================================================

procedure TFrmLstLabelerCA.LLViewDefineLblsGrpShopInfo;
begin  // of TFrmLstLabelerCA.LLViewDefineLblsGrpShopInfo
  inherited;
  CLLLabeler.LLDefineVariable (CtTxtLblTxtPriceSupervisor,
                               PChar(ApplicText (CtTxtLblTxtPriceSupervisor)));
  CLLLabeler.LLDefineVariable (CtTxtLblTxtPriceBureau,
                               PChar(ApplicText (CtTxtLblTxtPriceBureau)));
  CLLLabeler.LLDefineVariable (CtTxtLblTxtPriceBureauCHS,
                               PChar(ApplicText (CtTxtLblTxtPriceBureauCHS)));
end;   // of TFrmLstLabelerCA.LLViewDefineLblsGrpShopInfo

//=============================================================================
// TFrmLstLabelerCA.LLViewDefineVarsGrpShopInfo : defines all Variables
// (= List&Label variables used for variable text related to current Label)
// that can be printed on a label of list for group ShopInfo.
//=============================================================================

procedure TFrmLstLabelerCA.LLViewDefineVarsGrpShopInfo;
begin  // of TFrmLstLabelerCA.LLViewDefineVarsGrpShopInfo
  inherited;
  CLLLabeler.LLDefineVariable (CtTxtVarTxtPriceSupervisor,
                               CtTxtDefTxtPriceSupervisor);
  CLLLabeler.LLDefineVariable (CtTxtVarTxtPriceBureau, CtTxtDefTxtPriceBureau);
  CLLLabeler.LLDefineVariable (CtTxtVarTxtPriceBureauCHS,
                               CtTxtDefTxtPriceBureauCHS);
end;   // of TFrmLstLabelerCA.LLViewDefineVarsGrpShopInfo

//=============================================================================
// TFrmLstLabelerCA.LLVarsUsedInitGrpShopInfo : initializes the flags for
// used variables in group ShopInfo.
//                              ------
// INPUT   : FlgInit = True: Place variables on True.
//                     False: Place variables on False.
//=============================================================================

procedure TFrmLstLabelerCA.LLVarsUsedInitGrpShopInfo (FlgInit : Boolean);
begin  // of TFrmLstLabelerCA.LLVarsUsedInitGrpShopInfo
  inherited;
  DmdFpnLabelerCA.FlgVUTxtPriceSupervisor  := FlgInit;
  DmdFpnLabelerCA.FlgVUTxtPriceBureau      := FlgInit;
  DmdFpnLabelerCA.FlgVUTxtPriceBureauCHS   := FlgInit;
end;   // of TFrmLstLabelerCA.LLVarsUsedInitGrpShopInfo

//=============================================================================
// TFrmLstLabelerCA.LLVarsUsedFillInGrpShopInfo : sets the flags for
// variables in group ShopInfo used on current Label.
//=============================================================================

procedure TFrmLstLabelerCA.LLVarsUsedFillInGrpShopInfo;
begin  // of TFrmLstLabelerCA.LLVarsUsedFillInGrpShopInfo
  inherited;
  DmdFpnLabelerCA.FlgVUTxtPriceSupervisor   :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarTxtPriceSupervisor) = 1;
  DmdFpnLabelerCA.FlgVUTxtPriceBureau  :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarTxtPriceBureau) = 1;
  DmdFpnLabelerCA.FlgVUTxtPriceBureauCHS  :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarTxtPriceBureauCHS) = 1;
end;   // of TFrmLstLabelerCA.LLVarsUsedFillInGrpShopInfo

//=============================================================================
// TFrmLstLabeler.LLViewSetVarValuesGrpShopInfo : set the values for all
// Variables of the group ShopInfo used on the current Label.
//=============================================================================

procedure TFrmLstLabelerCA.LLViewSetVarValuesGrpShopInfo;
begin  // of TFrmLstLabelerCA.LLViewSetVarValuesGrpShopInfo
  inherited;
  // --- Price Supervisor ---
  if DmdFpnLabelerCA.FlgVUTxtPriceSupervisor then
    CLLLabeler.LLDefineVariable
      (CtTxtVarTxtPriceSupervisor,
       PChar (DmdFpnLabelerCA.TxtPriceSupervisor));
  // --- Price Bureau ---
  if DmdFpnLabelerCA.FlgVUTxtPriceBureau then
    CLLLabeler.LLDefineVariable
      (CtTxtVarTxtPriceBureau,
       PChar (DmdFpnLabelerCA.TxtPriceBureau));
  // --- Price Bureau CHS---
  if DmdFpnLabelerCA.FlgVUTxtPriceBureauCHS then
    CLLLabeler.LLDefineVariable
      (CtTxtVarTxtPriceBureauCHS,
       PChar (DmdFpnLabelerCA.TxtPriceBureauCHS));
end;   // of TFrmLstLabelerCA.LLViewSetVarValuesGrpShopInfo

//=============================================================================
// TFrmLstLabelerCA.TextListReportAddLblsGrpArticleCommon : adds all Labels for
// group ArticleCommon to the TextList for getting ReportTitles from ApplicText.
//=============================================================================

procedure TFrmLstLabelerCA.TextListReportAddLblsGrpArticleCommon;
begin  // of TFrmLstLabelerCA.TextListReportAddLblsGrpArticleCommon
  inherited;
  TextListReportAddLabel (CtTxtLblValHeight);
  TextListReportAddLabel (CtTxtLblValLength);
  TextListReportAddLabel (CtTxtLblValWidth);
  TextListReportAddLabel (CtTxtLblTxtModel);
  TextListReportAddLabel (CtTxtLblTxtArea);
  TextListReportAddLabel (CtTxtLblTxtGrade);
  TextListReportAddLabel (CtTxtLblCodSalesUnit);
  TextListReportAddLabel (CtTxtLblTxtSalesUnit);
  TextListReportAddLabel (CtTxtLblTxtUnit);
end;   // of TFrmLstLabelerCA.TextListReportAddLblsGrpArticleCommon

//=============================================================================
// TFrmLstLabeler.LLViewDefineLblsGrpArticleCommon : defines all Labels
// (= List&Label variables used for constant text) that can be printed
// on a label of list for group ArticleCommon.
//=============================================================================

procedure TFrmLstLabelerCA.LLViewDefineLblsGrpArticleCommon;
begin  // of TFrmLstLabelerCA.LLViewDefineLblsGrpArticleCommon
  inherited;
  CLLLabeler.LLDefineVariable (CtTxtLblValHeight,
                               PChar(ApplicText (CtTxtLblValHeight)));
  CLLLabeler.LLDefineVariable (CtTxtLblValLength,
                               PChar(ApplicText (CtTxtLblValLength)));
  CLLLabeler.LLDefineVariable (CtTxtLblValWidth,
                               PChar(ApplicText (CtTxtLblValWidth)));
  CLLLabeler.LLDefineVariable (CtTxtLblTxtModel,
                               PChar(ApplicText (CtTxtLblTxtModel)));
  CLLLabeler.LLDefineVariable (CtTxtLblTxtArea,
                               PChar(ApplicText (CtTxtLblTxtArea)));
  CLLLabeler.LLDefineVariable (CtTxtLblTxtGrade,
                               PChar(ApplicText (CtTxtLblTxtGrade)));
  CLLLabeler.LLDefineVariable (CtTxtLblCodSalesUnit,
                               PChar(ApplicText (CtTxtLblCodSalesUnit)));
  CLLLabeler.LLDefineVariable (CtTxtLblTxtSalesUnit,
                               PChar(ApplicText (CtTxtLblTxtSalesUnit)));
  CLLLabeler.LLDefineVariable (CtTxtLblTxtUnit,
                               PChar(ApplicText (CtTxtLblTxtUnit)));
end;   // of TFrmLstLabelerCA.LLViewDefineLblsGrpArticleCommon

//=============================================================================
// TFrmLstLabelerCA.LLViewDefineVarsGrpArticleCommon : defines all Variables
// (= List&Label variables used for variable text related to current Label)
// that can be printed on a label of list for group ArticleCommon.
//=============================================================================

procedure TFrmLstLabelerCA.LLViewDefineVarsGrpArticleCommon;
begin  // of TFrmLstLabelerCA.LLViewDefineVarsGrpArticleCommon
  inherited;
  CLLLabeler.LLDefineVariableExt (CtTxtVarValHeight,
                                  CtTxtDefValHeight, LL_NUMERIC);
  CLLLabeler.LLDefineVariableExt (CtTxtVarValLength,
                                  CtTxtDefValLength, LL_NUMERIC);
  CLLLabeler.LLDefineVariableExt (CtTxtVarValWidth,
                                  CtTxtDefValWidth, LL_NUMERIC);
  CLLLabeler.LLDefineVariable (CtTxtVarTxtModel, CtTxtDefTxtModel);
  CLLLabeler.LLDefineVariable (CtTxtVarTxtArea, CtTxtDefTxtArea);
  CLLLabeler.LLDefineVariable (CtTxtVarTxtGrade, CtTxtDefTxtGrade);
  CLLLabeler.LLDefineVariableExt (CtTxtVarCodSalesUnit,
                                  CtTxtDefCodSalesUnit, LL_NUMERIC);
  CLLLabeler.LLDefineVariable (CtTxtVarTxtSalesUnit, CtTxtDefTxtSalesUnit);
  CLLLabeler.LLDefineVariable (CtTxtVarTxtUnit, CtTxtDefTxtUnit);
end;   // of TFrmLstLabelerCA.LLViewDefineVarsGrpArticleCommon

//=============================================================================
// TFrmLstLabelerCA.LLVarsUsedInitGrpArticleCommon : initializes the flags for
// used variables in group ArticleCommon.
//                              ------
// INPUT   : FlgInit = True: Place variables on True.
//                     False: Place variables on False.
//=============================================================================

procedure TFrmLstLabelerCA.LLVarsUsedInitGrpArticleCommon (FlgInit : Boolean);
begin  // of TFrmLstLabelerCA.LLVarsUsedInitGrpArticleCommon
  inherited;
  DmdFpnLabelerCA.FlgVUValHeight           := FlgInit;
  DmdFpnLabelerCA.FlgVUValLength           := FlgInit;
  DmdFpnLabelerCA.FlgVUValWidth            := FlgInit;
  DmdFpnLabelerCA.FlgVUTxtModel            := FlgInit;
  DmdFpnLabelerCA.FlgVUTxtArea             := FlgInit;
  DmdFpnLabelerCA.FlgVUTxtGrade            := FlgInit;
end;   // of TFrmLstLabelerCA.LLVarsUsedInitGrpArticleCommon

//=============================================================================
// TFrmLstLabeler.LLVarsUsedFillInGrpArticleCommon : sets the flags for
// variables in group ArticleCommon used on current Label.
//=============================================================================

procedure TFrmLstLabelerCA.LLVarsUsedFillInGrpArticleCommon;
begin  // of TFrmLstLabelerCA.LLVarsUsedFillInGrpArticleCommon
  inherited;
  DmdFpnLabelerCA.FlgVUValHeight          :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarValHeight)    = 1;
  DmdFpnLabelerCA.FlgVUValLength          :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarValLength)    = 1;
  DmdFpnLabelerCA.FlgVUValWidth           :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarValWidth)     = 1;
  DmdFpnLabelerCA.FlgVUTxtModel           :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarTxtModel)     = 1;
  DmdFpnLabelerCA.FlgVUTxtArea            :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarTxtArea)      = 1;
  DmdFpnLabelerCA.FlgVUTxtGrade           :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarTxtGrade)     = 1;
  DmdFpnLabelerCA.FlgVUCodSalesUnit       :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarCodSalesUnit) = 1;
  DmdFpnLabelerCA.FlgVUTxtSalesUnit       :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarTxtSalesUnit) = 1;
  DmdFpnLabelerCA.FlgVUTxtUnit            :=
    CLLLabeler.LLPrintIsVariableUsed (CtTxtVarTxtUnit)      = 1;
end;   // of TFrmLstLabelerCA.LLVarsUsedFillInGrpArticleCommon

//=============================================================================
// TFrmLstLabelerCA.LLViewSetVarValuesGrpArticleCommon : set the values for all
// Variables of the group ArticleCommon used on the current Label.
//                                  -----
// INPUT   : QryInfo = query containing the info for the current Article.
//=============================================================================

procedure TFrmLstLabelerCA.LLViewSetVarValuesGrpArticleCommon (QryInfo : TQuery);
begin  // of TFrmLstLabelerCA.LLViewSetVarValuesGrpArticleCommon
  inherited;
  // --- Article ValHeigth ---
  if DmdFpnLabelerCA.FlgVUValHeight then
    CLLLabeler.LLDefineVariableExt
      (CtTxtVarValHeight,
       PChar (QryInfo.FieldByName ('ValHeight').AsString), LL_NUMERIC);
  // --- Article ValLength ---
  if DmdFpnLabelerCA.FlgVUValLength then
    CLLLabeler.LLDefineVariableExt
      (CtTxtVarValLength,
       PChar (QryInfo.FieldByName ('ValLength').AsString), LL_NUMERIC);
  // --- Article ValWidth ---
  if DmdFpnLabelerCA.FlgVUValWidth then
    CLLLabeler.LLDefineVariableExt
      (CtTxtVarValWidth,
       PChar (QryInfo.FieldByName ('ValWidth').AsString), LL_NUMERIC);
  // --- Article Model ---
  if DmdFpnLabelerCA.FlgVUTxtModel then
    CLLLabeler.LLDefineVariable
      (CtTxtVarTxtModel,
       PChar (QryInfo.FieldByName ('TxtModel').AsString));
  // --- Article Area ---
  if DmdFpnLabelerCA.FlgVUTxtArea then
    CLLLabeler.LLDefineVariable
      (CtTxtVarTxtArea,
       PChar (QryInfo.FieldByName ('TxtArea').AsString));
  // --- Article Grade ---
  if DmdFpnLabelerCA.FlgVUTxtGrade then
    CLLLabeler.LLDefineVariable
      (CtTxtVarTxtGrade,
       PChar (QryInfo.FieldByName ('TxtGrade').AsString));
  // --- Article TxtUnit ---
  if DmdFpnLabelerCA.FlgVUTxtUnit then
    CLLLabeler.LLDefineVariable
      (CtTxtVarTxtUnit,
       PChar (QryInfo.FieldByName ('TxtUnit').AsString));
  // --- Article CodSalesUnit ---
  if DmdFpnLabelerCA.FlgVUCodSalesUnit then
    CLLLabeler.LLDefineVariableExt
      (CtTxtVarCodSalesUnit,
       PChar (QryInfo.FieldByName ('CodSalesUnit').AsString), LL_NUMERIC);
  // --- Article TxtSalesUnit ---
  if DmdFpnLabelerCA.FlgVUTxtSalesUnit then
    CLLLabeler.LLDefineVariable
      (CtTxtVarTxtSalesUnit,
       PChar (QryInfo.FieldByName ('ArticleTxtSalesUnit').AsString));
end;   // of TFrmLstLabelerCA.LLViewSetVarValuesGrpArticleCommon

//=============================================================================

procedure TFrmLstLabelerCA.MniImportClick(Sender: TObject);
var
  CntItem : integer;
begin
  inherited;
  if not FileExists (DmdFpnLabelerCA.TxtFNImport) then
    MessageDlg (Format (CtTxtEMImportNotFound, [DmdFpnLabelerCA.TxtFNImport]),
                mtError, [mbOK], 0)
  else begin
    if BtnRangeSubStr.Enabled then
      BtnRangeFromTo.Click;
    SvcMELimitFrom.Clear;
    SvcMELimitTo.Clear;
    SvcLFLimitFrom.ClearContents;
    SvcLFLimitTo.ClearContents;
    StrLstSelIdt.Clear;
    ClearQtyLabelTypes;
    BtnRefresh.Click;
    DmdFpnLabelerCA.StrLstImported.LoadFromFile(DmdFpnLabelerCA.TxtFNImport);
    for CntItem := 0 to DmdFpnLabelerCA.StrLstImported.Count - 1 do
      DmdFpnLabelerCA.StrLstImported[CntItem] :=
                           Copy( DmdFpnLabelerCA.StrLstImported[CntItem], 1, 7);

    DBGrdList.DataSource.DataSet.Filtered := True;
  end;
end;

//=============================================================================

procedure TFrmLstLabelerCA.MniPrintClick(Sender: TObject);
var
  Cnt              : Integer;          // Counter
  FlgLayoutSkipped : Boolean;
  FlgReportsExist  : Boolean;
begin  // of TFrmLstLabelerCA.MniPrintClick
  if LabelerTask in [CtCodLtkCustFree] then
    inherited
  else begin
    // Inherited is explicitly not called
    TmrRefresh.Enabled := False;

    if StrLstSelIdt.Count = 0 then
      raise ESvcLocalScope.Create (CtTxtLblerSelArticles);

    if (StrLstLabelTypes.Count = 0) then begin
      MessageDlg (CtTxtEmNoLayoutsFound, mtError, [mbOK], 0);
      Exit;
    end;

    FrmInputLabelerCA := TFrmInputLabelerCA.Create (Self);
    try
      StrLstLabelTypes [0] := '';
      TLabelType (StrLstLabelTypes.Objects [0]).Descr := '';
      TLabelType (StrLstLabelTypes.Objects [0]).LabelType  := 0;
      TLabelType (StrLstLabelTypes.Objects [0]).ReportNorm := '';
      TLabelType (StrLstLabelTypes.Objects [0]).ReportCamp := '';
      for Cnt := 0 to StrLstLabelTypes.Count - 1 do 
        TLabelType (StrLstLabelTypes.Objects [Cnt]).FlgPrintNoType := False;
      if FrmInputLabelerCA.ShowModalWithParams (StrLstLabelTypes) = mrOK then begin
        FlgLayoutSkipped := False;
        FlgReportsExist := True;
        FlgPreviewPrintBtnPressed := False;
        for Cnt := 1 to StrLstLabelTypes.Count - 1 do begin
          CurrentLabelType := Cnt;
          if (TLabelType (StrLstLabelTypes.Objects[Cnt]).LabelType <> 0) and
             ((TLabelType (StrLstLabelTypes.Objects[Cnt]).Qty <> 0) or
              (TLabelType (StrLstLabelTypes.Objects[Cnt]).FlgPrintNoType))
            then begin
            CurrentReport := DefaultReport;
            if MessageDlgBtns (Format (CtTxtWmLabelType,
                 [QuotedStr (TLabelType (StrLstLabelTypes.
                  Objects[CurrentLabelType]).Descr)]),
                  mtConfirmation, [SOKButton, SCancelButton],
                  2, 0, 0) <> 2 then begin
              // Check if report exists
              if CurrentReport <> '' then begin
                if FileExists (CurrentReport) then begin
                  if (Sender = BtnPrint) or (Sender = MniPrint) then
                    LLPrint (False)
                  else if (Sender = BtnPrintPreview) or (Sender = MniPrintPreview) then
                    LLPrint (True);
                end
                else begin
                  FlgReportsExist := False;
                  MessageDlg (Format (CtTxtEmLayoutNotFound,[CurrentReport]),
                              mtError, [mbOK], 0);
                end;
              end
              else begin
                FlgReportsExist := False;
                MessageDlg (Format (CtTxtEmLayoutNotDefined,
                            [TLabelType (StrLstLabelTypes.Objects[Cnt]).Descr]),
                            mtError, [mbOK], 0);
              end;
            end
            else
              FlgLayoutSkipped := True;
          end;
        end;

        if not FlgLayoutSkipped and
           FlgReportsExist and
           (LabelerTask in [CtCodLtkArtNew, CtCodLtkArtPrice,
                            CtCodLtkArtPrcCamp]) and
           (((Sender = BtnPrint) or (Sender = MniPrint)) or
            (((Sender = BtnPrintPreview) or (Sender = MniPrintPreview)) and
             FlgPreviewPrintBtnPressed)) and
           (RgpJob.ItemIndex = 0) then begin
          InsertSelection;
          try
            AdjustTasks;
            StrLstSelIdt.Clear;
            ClearQtyLabelTypes;
            AdjustQtySelected;
          finally
            DropSelectionTable;
          end;
        end;
      end;
      DscList.DataSet.EnableControls;
    finally
      FrmInputLabelerCA.Free;
    end;
    if RefreshNeeded then
      TmrRefresh.Enabled := True;
  end;
end;   // of TFrmLstLabelerCA.MniPrintClick

//=============================================================================

procedure TFrmLstLabelerCA.FillLabelTypesFromDB (StrLstLabelTypes : TStringList);
begin  // of TFrmInputLabelerCA.FillFromDBDefaultLabel
  if not Assigned (StrLstLabelTypes) then
    Exit;
  StrLstLabelTypes.Clear;
  with DmdFpnARticleCA.SprLkpCodLabelerLayout do begin
    Open;
    First;
    while not Eof do begin
      StrLstLabelTypes.AddObject (
        FieldByName ('TxtLongDescr').AsString,
        TLabelType.CreateWithParams (
          FieldByName ('IdtLabelerLayout').AsInteger,
          FieldByName ('TxtLongDescr').AsString,
          DmdFpnUtilsCA.ExecSprEnvReplace (
            FieldByName ('TxtFNLayoutNorm').AsString),
          DmdFpnUtilsCA.ExecSprEnvReplace (
            FieldByName ('TxtFNLayoutCamp').AsString)));
      Next;
    end;
    Close;
  end;
end;   // of TFrmDetTicketInfo.FillFromDBDefaultLabel

//=============================================================================

procedure TFrmLstLabelerCA.ClearQtyLabelTypes;
var
  Cnt              : Integer;          // Counter
begin  // of TFrmLstLabelerCA.ClearQtyLabelTypes
  if not Assigned (StrLstLabelTypes) or (StrLstLabelTypes.Count = 0) then
    Exit;
  for Cnt := 0 to StrLstLabelTypes.Count - 1 do
    TLabelType (StrLstLabelTypes.Objects[Cnt]).Qty := 0;
end;   // of TFrmLstLabelerCA.ClearQtyLabelTypes

//=============================================================================

procedure TFrmLstLabelerCA.ChangeItemSelected (TxtItem   : string;
                                               FlgSelect : Boolean);
var NumOldCountSelected : Integer;
begin  // of TFrmLstLabelerCA.ChangeItemSelected
  NumOldCountSelected := StrLstSelIdt.Count;
  inherited;
  if not Assigned (StrLstLabelTypes) or (StrLstLabelTypes.Count = 0) then
    Exit;
  with TLabelType (StrLstLabelTypes.Objects[DscList.DataSet.
         FieldByName ('IdtLabelerLayout').AsInteger]) do begin
    if NumOldCountSelected < StrLstSelIdt.Count then
      Qty := Qty + (StrLstSelIdt.Count - NumOldCountSelected)
    else
      Qty := Qty - (NumOldCountSelected - StrLstSelIdt.Count);
  end;
end;   // of TFrmLstLabelerCA.ChangeItemSelected

//=============================================================================
// TFrmLstLabelerCA.LocateSelectedRow : locates the item which Idt-values are
// in StrLstIdtValues in the dataset with selected info.
//                                  -----
// INPUT   : QryInfo = Query to locate the current item in.
//                                  -----
// FUNCRES : True = row is located; False = row is not located.
//=============================================================================

function TFrmLstLabelerCA.LocateSelectedRow (QryInfo : TQuery) : Boolean;
begin  // of TFrmLstLabeler.LocateSelectedRow
  Result := inherited LocateSelectedRow (QryInfo);
  if not Assigned (StrLstLabelTypes) or (StrLstLabelTypes.Count = 0) then
    Exit;
  if Result then
    Result :=
      (QryInfo.FieldByName('IdtLabelerLayout').AsInteger =
         TLabelType (StrLstLabelTypes.Objects[CurrentLabelType]).LabelType) or
      ((QryInfo.FieldByName('IdtLabelerLayout').AsInteger = 0) and
        TLabelType (StrLstLabelTypes.Objects[CurrentLabelType]).FlgPrintNoType);
end;   // of TFrmLstLabelerCA.LocateSelectedRow

//=============================================================================
// TFrmLstLabelerCA.LLPrint : Printing routine for lists & labels.
//                                  ------
// INPUT   : FlgPreview = True : Print a preview (on the screen).
//                        False : Print directly to the printer.
//=============================================================================

procedure TFrmLstLabelerCA.LLPrint (FlgPreview : Boolean);
var
  NumReturn        : Integer;          // Return error code
  CntRow           : Integer;          // Row counter
  FlgErrorPrint    : Boolean;          // True=Error occured during printing
  QryInfo          : TQuery;           // Query for retrieving necessary info
  StrLstSelOrder   : TStringList;      // Selected items in selection order
begin   // of TFrmLstLabeler.LLPrint
  if StrLstSelIdt.Count = 0 then
    raise EAbort.Create ('No data');

  if CLLLabeler.LlGetOption(LL_OPTION_DEFPRINTERINSTALLED) < 1 then begin
   MessageDlg (SNoDefaultPrinter, mtError, [mbOk], 0);
   Exit;
  end;

  FillStrLstContents;
  // Define variables/fields
  LLViewDefine;

  FlgErrorPrint := False;
  // Initiate printing
  InsertSelection;                     // Save the selection to the DB
  try
    StrLstSelOrder := nil;
    NumReturn      := 0;

    try
      LLViewInitOnStartPrint (FlgPreview, NumReturn);
      if NumReturn = 0 then begin
        // Initialize and check fields to be printed
        LLVarsUsedInitiliaze (False);
        LLVarsUsedCheckAndFillIn;
        LLViewSetVarValuesForAll;

        // Print information - check all bookmarks
        DBGrdList.DataSource.DataSet.DisableControls;

        QryInfo := TQuery.Create (Self);
        try
          QryInfo.Name := 'QryRTInfoLabeler';
          QryInfo.DatabaseName := QrySelection.DatabaseName;
          QryInfo.Active := False;
          DmdFpnLabeler.NameSelectionTable := NameSelectionTable;
          BuildSQLSelection (QryInfo);
          QryInfo.Active := True;

          // Process every selected Items
          StrLstSelOrder := TStringList.Create;
          // We can't process the dataset, although the selected records have been
          // inserted into the TEMP table in selection order, because a DISTINCT
          // statement is requested, so the selection order is lost.
          // This means that for every record, we have to build the IdtValues
         // again.
           BuildStrLstSelOrder (StrLstSelOrder);
          for CntRow := 0 to Pred (StrLstSelOrder.Count) do begin
            CLLLabeler.LLPrintSetBoxText
              (PChar (''),  (CntRow + 1) * 100 div StrLstSelOrder.Count);

            BuildStrLstIdtValuesSelOrder (StrLstSelOrder, CntRow);

            // Locate selected Record again
            if LocateSelectedRow (QryInfo) then begin
              LLViewPrint (QryInfo);

              // Error during print?
              NumReturn := CLLLabeler.LLPrint;
              if NumReturn = LL_WRN_REPEAT_DATA then
                NumReturn := 0;
              FlgErrorPrint := (NumReturn < 0);
              if FlgErrorPrint then
                Break;
            end;
          end;   // of while not QryInfo.EOF do begin ...
        finally
          DBGrdList.DataSource.DataSet.EnableControls;
          QryInfo.Free;
        end;
      end;
    finally
      CLLLabeler.LLPrintEnd (0);
      StrLstSelOrder.Free;
      LLVarsUsedInitiliaze (False);

      if (NumReturn <> 0) and
         (NumReturn <> LL_ERR_USER_ABORTED) then
        MessageDlg (CtTxtEMErrorPrinting + #10#10 +
                    InterpreteLLErrorCode (NumReturn), mtError, [mbOK], 0)
    end;

    if (not FlgErrorPrint) then begin
      // No errors during printing
      if FlgPreview then begin
        // Show preview
        CLLLabeler.LLPreviewDisplay (PChar (CurrentReport),
                                     PChar(APIGetTempPath), Handle);
        CLLLabeler.LLPreviewDeleteFiles (PChar (CurrentReport),
                                         PChar(APIGetTempPath));
      end;
    end;
  finally
    DropSelectionTable;                // Remove temp-table in DB
  end;
end;  // of TFrmLstLabelerCA.LLPrint

//=============================================================================
// TFrmLstLabelerCA.LLViewInitOnStartPrint : performs some initializations
// on start printing lists & labels.
//                                  ------
// INPUT   : FlgPreview = True : Print a preview (on the screen).
//                        False : Print directly to the printer.
//=============================================================================

procedure TFrmLstLabelerCA.LLViewInitOnStartPrint (FlgPreview : Boolean; var NumReturn : Integer);
var
  QtyItemsPerPage  : Integer;          // Get items per page to calc. pages
  QtyPages         : Integer;          // Calculate number of pages to print
begin  // of TFrmLstLabelerCA.LLViewInitOnStartPrint
  if FlgPreview then begin
    NumReturn := CLLLabeler.LLPrintWithBoxStart
                   (LL_PROJECT_LABEL, PChar (CurrentReport),
                    LL_PRINT_PREVIEW, LL_BOXTYPE_NORMALMETER, Handle,
                    PChar (CtTxtLblerPreview));
    CLLLabeler.LLPreviewSetTempPath (PChar(APIGetTempPath));
  end
  else
    NumReturn := CLLLabeler.LLPrintWithBoxStart
                   (LL_PROJECT_LABEL, PChar (CurrentReport),
                    LL_PRINT_NORMAL, LL_BOXTYPE_NORMALMETER, Handle,
                    PChar (CtTxtLblerPrint));

  if NumReturn <> 0 then
    raise ESvcLocalScope.Create (InterpreteLLErrorCode (NumReturn));

  // Show options dialog
  if not FlgPreview then begin
    QtyItemsPerPage := CLLLabeler.llPrintGetITemsPerPage;
    QtyPages := StrLstSelIdt.Count div QtyItemsPerPage;
    if StrLstSelIdt.Count mod QtyItemsPerPage > 0 then
      Inc (QtyPages);
    NumReturn := CLLLabeler.LLPrintOptionsDialog
                   (Handle,
                    PChar (Format (CtTxtLblerPrintPages, [(QtyPages)])));
    if (NumReturn <> 0) and
       (NumReturn <> LL_ERR_USER_ABORTED) then
      raise ESvcLocalScope.Create (InterpreteLLErrorCode (NumReturn));
  end;
end;   // of TFrmLstLabelerCA.LLViewInitOnStartPrint

//=============================================================================
// TFrmLstLabelerCA.ConvertToPropertiesInDmd : Fill the public properties in
// DmdFpnLabeler by looking at the selected options.
//=============================================================================

procedure TFrmLstLabelerCA.ConvertToPropertiesInDmd;
begin  // of TFrmLstLabelerCA.ConvertToPropertiesInDmd
  inherited;
  // Set CodType
  if (LabelerTask in [CtCodLtkArtNew, CtCodLtkArtPrice,CtCodLtkArtPrcCamp]) then
    DmdFpnLabeler.CodType := CurrTaskTarget
  else
    DmdFpnLabeler.CodType := -1;
end;   // of TFrmLstLabelerCA.ConvertToPropertiesInDmd

//=============================================================================

procedure TFrmLstLabelerCA.MniSeqRefreshClick(Sender: TObject);
begin  // of TFrmLstLabelerCA.MniSeqRefreshClick
  DBGrdList.DataSource.DataSet.Filtered := False;
  inherited;
  StrLstSelIdt.Clear;
  ClearQtyLabelTypes;
  AdjustQtySelected;
end;   // of TFrmLstLabelerCA.MniSeqRefreshClick

//=============================================================================

procedure TFrmLstLabelerCA.CLLLabelerViewerButtonClicked(Sender: TObject;
  Button: TViewerButton; var PerformDefaultAction: Boolean);
begin  // of CLLLabelerViewerButtonClicked
  inherited;
  if Button in [vbPrintPage, vbPrintAll, vbPrintPageWithPrinterSelection,
                vbPrintAllWithPrinterSelection] then
    FlgPreviewPrintBtnPressed := True;
end;   // of CLLLabelerViewerButtonClicked

//=============================================================================

procedure TFrmLstLabelerCA.MniClearClick(Sender: TObject);
begin
  inherited;
  StrLstSelIdt.Clear;
  ClearQtyLabelTypes;
  AdjustQtySelected;
end;

//=============================================================================

procedure TFrmLstLabelerCA.MniCombitLLClick(Sender: TObject);
var
  Cnt              : Integer;       // Counter
  TxtFN            : string;        // Filename
  Attributes       : LongWord;
begin  // of TFrmLstLabelerCA.MniCombitLLClick
  for Cnt := 0 to StrLstLabelTypes.Count - 1 do begin
    TxtFN := TLabelType (StrLstLabelTypes.Objects[Cnt]).ReportCamp;
    if TxtFN <> '' then begin
      Attributes := GetFileAttributes(PChar(TxtFN));
      if (Attributes and FILE_ATTRIBUTE_READONLY) <> 0 then
        SetFileAttributes (PChar(TxtFN),
                           Attributes and not FILE_ATTRIBUTE_READONLY);
    end;
    TxtFN := TLabelType (StrLstLabelTypes.Objects[Cnt]).ReportNorm;
    if TxtFN <> '' then begin
      Attributes := GetFileAttributes(PChar(TxtFN));
      if (Attributes and FILE_ATTRIBUTE_READONLY) <> 0 then
        SetFileAttributes (PChar(TxtFN),
                           Attributes and not FILE_ATTRIBUTE_READONLY);
    end;
  end;
  inherited;
end;   // of TFrmLstLabelerCA.MniCombitLLClick

//=============================================================================

procedure TFrmLstLabelerCA.FormCreate(Sender: TObject);
begin  // of TFrmLstLabelerCA.FormCreate
  inherited;
  StrLstLabelTypes := TStringList.Create;
  FillLabelTypesFromDB (StrLstLabelTypes);
end;   // of TFrmLstLabelerCA.FormCreate

//=============================================================================

procedure TFrmLstLabelerCA.FormDestroy(Sender: TObject);
var
  Cnt              : Integer;
begin  // of TFrmLstLabelerCA.FormDestroy
  inherited;
  for Cnt := 0 to StrLstLabelTypes.Count - 1  do
     StrLstLabelTypes.Objects[Cnt].Free;
  StrLstLabelTypes.Free;
end;   // of TFrmLstLabelerCA.FormDestroy

//=============================================================================

procedure TFrmLstLabelerCA.MniRecDeSelAllClick(Sender: TObject);
begin  // of TFrmLstLabelerCA.MniRecDeSelAllClick
  inherited;
  ClearQtyLabelTypes;
end;   // of TFrmLstLabelerCA.MniRecDeSelAllClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FLstLabelerCA
