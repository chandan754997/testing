//=========== Sycron Computers Belgium (c) 1997-1998 ==========================
// Packet : FlexPos Development
// Unit   : FMntMunicipality.PAS : MainForm MaiNTenance MUNICIPALITY CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntMunicipalityCA.pas,v 1.1 2006/12/18 16:18:04 hofmansb Exp $
// Version    Modified by                      Reason
// 1.1       SRM(TCS)     //Regression Fix R2012.1 
//=============================================================================

unit FMntMunicipalityCA;

//*****************************************************************************

interface

//=============================================================================

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FMntMunicipality, ScTskMgr_BDE_DBC;
//=============================================================================
// Resource strings
//=============================================================================

resourcestring                                                                  //Regression Fix R2012.1 (SRM)
  CtTxtTitle  = 'Maintenance Municipality';                                     //Regression Fix R2012.1 (SRM)

type
  TFrmMntMunicipalityCA = class(TFrmMntMunicipality)
    procedure FormActivate(Sender: TObject);                                    //Regression Fix R2012.1 (SRM)
    procedure SvcTskLstMunicipalityCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetMunicipalityCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMntMunicipalityCA: TFrmMntMunicipalityCA;

//*****************************************************************************

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntMunicipalityCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FMntMunicipalityCA.pas  $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2012/06/27 16:18:04 $';

//*****************************************************************************
// Implementation of TFrmMntMunicipality
//*****************************************************************************

implementation

uses
  SfList_BDE_DBC,
  SfDialog,

  DFpn,
  DFpnUtils,

  DFpnMunicipalityCA,

  FDetMunicipalityCA;

{$R *.DFM}

//*****************************************************************************
// Implementation of TFrmMntMunicipalityCA
//*****************************************************************************
//Regression Fix R2012.1 (SRM) Start
procedure TFrmMntMunicipalityCA.FormActivate(Sender: TObject);
begin  // of TFrmMntMunicipalityCA.FormActivate
  inherited;
    application.Title := CtTxtTitle;        
end;   // of TFrmMntMunicipalityCA.FormActivate
//Regression Fix R2012.1 (SRM) End
//=============================================================================
procedure TFrmMntMunicipalityCA.SvcTskLstMunicipalityCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntMunicipalityCA.SvcTskLstMunicipalityCreateExecutor
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds;
  FlgCreated := True;
end;   // of TFrmMntMunicipalityCA.SvcTskLstMunicipalityCreateExecutor

//=============================================================================

procedure TFrmMntMunicipalityCA.SvcTskDetMunicipalityCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntMunicipalityCA.SvcTskDetMunicipalityCreateExecutor
  NewObject := TFrmDetMunicipalityCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntMunicipalityCA.SvcTskDetMunicipalityCreateExecutor

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);


end.
