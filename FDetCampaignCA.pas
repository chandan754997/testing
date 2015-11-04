//=========== Centric Retail Solutions (c) 2010 ===============================
// Packet  : FlexPoint Development
// Customer: Castorama
// Unit    : FDetCampaignCA : Form DETail CAMPAIGN
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCampaignCA.pas,v 1.3 2010/02/12 12:55:42 BEL\KDeconyn Exp $
//=============================================================================


unit FDetCampaignCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetCampaign, Menus, DB, ovcbase, ComCtrls, Grids, DBGrids, ExtCtrls,
  StdCtrls, CheckLst, ovcef, ovcpb, ovcpf, ovcdbpf, ScDBUtil_Ovc, Buttons,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit,
  ScDBUtil_Dx, ScDBUtil_BDE;

//=============================================================================
// TFrmDetCampaign
//=============================================================================

type
  TFrmDetCampaignCA = class(TFrmDetCampaign)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AdjustDataBeforeSave; override;
  end;

var
  FrmDetCampaignCA: TFrmDetCampaignCA;

//*****************************************************************************

implementation

uses
  DFpnCampaign,
  DFpnArtPrice,
  DFpnUtils,

  SmDBUtil_BDE,
  SmUtils,
  ScTskMgr_BDE_DBC,
  SfDialog,
  SrStnCom;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCampaignCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCampaignCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2010/02/12 12:55:42 $';

//*****************************************************************************
// Implementation of TFrmDetCampaign
//*****************************************************************************

procedure TFrmDetCampaignCA.FormCreate(Sender: TObject);
//-----------------------------------------------------------------------------
// CheckAll : Checks all the chechboxes of a given CheckListBox.
//                                  -----
// INPUT   : ChlToCheck = CheckListBox to check all items.
//-----------------------------------------------------------------------------

procedure CheckAll (ChlToCheck : TCheckListBox);
var
  CntItem          : Byte;             // Counter for price types
begin  // of CheckAll
  for CntItem := 0 to Pred (ChlToCheck.Items.Count) do
    ChlToCheck.Checked[CntItem] := True;
end;   // of CheckAll

//-----------------------------------------------------------------------------

begin  // of TFrmDetCampaignCA.FormCreate
  try
    //inherited;

    // Copy stored procedure - ArtPrice
    DscArtPrice.DataSet :=
      CopyStoredProc (Self, 'SprRTLstArtPrice', DmdFpnCampaign.SprLstCampPrc,
       ['@PrmTxtSequence=ArtPrice.IdtArticle,ArtPrice.CodType,' +
        'IdtType,DatBegin,DatEnd']);
    AdjustColorDBGrdTitle (DBGrdArtPrice, ['IdtArticle']);

    LstDstStartUp.Add (DscCampaign.DataSet);

    if DmdFpnUtils.IdtTradeMatrixAssort <> '' then
      LstDstStartUp.Add (DscCampAssort.DataSet);

    AddIdtControls ([SvcDBMEIdtCampaign]);

    if not SvcTaskMgr.IsTaskEnabled ('ListArticleForCampaign') then
      BtnArticlesArtPrice.Visible := False;
    if not SvcTaskMgr.IsTaskEnabled ('DetailArtPrice') then begin
      BtnNewArtPrice.Visible := False;
      BtnEditArtPrice.Visible := False;
      BtnConsultArtPrice.Visible := False;
      BtnArticlesArtPrice.Visible := False;
    end;

    // Price types
    if not DmdFpnArtPrice.SprLstCodTypeArtPrice.Active then
      DmdFpnArtPrice.SprLstCodTypeArtPrice.Active := True;

    BuildStrLstCodes (ChlPrcCodType.Items, DmdFpnArtPrice.SprLstCodTypeArtPrice,
                      'TxtChcShort', 'TxtFldCode');
    CheckAll (ChlPrcCodType);
    BuildStrLstCodes (ChlSyncBegin.Items, DmdFpnArtPrice.SprLstCodTypeArtPrice,
                      'TxtChcShort', 'TxtFldCode');
    CheckAll (ChlSyncBegin);
    BuildStrLstCodes (ChlSyncEnd.Items, DmdFpnArtPrice.SprLstCodTypeArtPrice,
                      'TxtChcShort', 'TxtFldCode');
    CheckAll (ChlSyncEnd);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;   // of TFrmDetCampaignCA.FormCreate

//=============================================================================

procedure TFrmDetCampaignCA.AdjustDataBeforeSave;
begin  // of TFrmDetCampaignCA.AdjustDataBeforeSave
  inherited;
  // Check Begin date
  if DscCampaign.DataSet.FieldByName ('DatBegin').AsString = '' then begin
    if not SvcDBLFDatBegin.CanFocus then
      SvcDBLFDatBegin.Show;
    ActiveControl := SvcDBLFDatBegin;
    raise Exception.Create
      (GetApplicText ('DatBegin', 0, DmdFpnUtils.SprCnvApplicText) + ' ' +
       CtTxtRequired);
  end;
end;   // of TFrmDetCampaignCA.AdjustDataBeforeSave

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end. // of TFrmDetCampaignCA
