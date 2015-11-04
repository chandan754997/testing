//=========== Sycron Computers Belgium (c) 1997-1998 ==========================
// Packet : FlexPos Development
// Unit   : FMntCampaign.PAS : MainForm MaiNTenance CAMPAIGN
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCampaignCA.pas,v 1.2 2007/11/14 16:21:11 smete Exp $
// History:
// Version     Modified by            Reason
// 1.1        Chayanika(TCS)     Regression Fix R2012.1
//=============================================================================

unit FMntCampaignCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FMntCampaign, Db, DBTables, ScTskMgr_BDE_DBC;


resourcestring
CtTxtTitle = 'Maintenance campaign';          //2012.1 Regression Fix (Chayanika)
//=============================================================================
// Global type definitions
//=============================================================================

type
  TFrmMntCampaignCA = class(TFrmMntCampaign)
    procedure FormActivate(Sender: TObject);
    procedure SvcTskDetCampaignCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetArtPriceCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMntCampaignCA: TFrmMntCampaignCA;

//*****************************************************************************

implementation

uses
  SfDialog,
  DFpnArtPriceCA,
  FdetArtPriceCA, FDetCampaignCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntCampaignCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCampaignCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2007/11/14 16:21:11 $';

//*****************************************************************************
// Implementation of TFrmMntCampaignCA
//*****************************************************************************

//=============================================================================

procedure TFrmMntCampaignCA.SvcTskDetArtPriceCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCampaignCA.SvcTskDetArtPriceCreateExecutor
  NewObject := TFrmDetArtPriceCA.Create (Self);
  FlgCreated := True;
  SvcTskDetArtPrice.DynamicExecutor := False;
end;   // of TFrmMntCampaignCA.SvcTskDetArtPriceCreateExecutor

//=============================================================================

procedure TFrmMntCampaignCA.SvcTskDetCampaignCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCampaignCA.SvcTskDetCampaignCreateExecutor
  NewObject := TFrmDetCampaignCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCampaignCA.SvcTskDetCampaignCreateExecutor

//=============================================================================

//2012.1 Regression Fix (Chayanika) :: start
procedure TFrmMntCampaignCA.FormActivate(Sender: TObject);
begin
  inherited;
  Application.Title:= CtTxtTitle;
end;
//2012.1 Regression Fix (Chayanika) :: end

//============================================================================
initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.   // of FMntCampaignCA
