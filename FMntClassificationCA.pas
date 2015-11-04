//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint Development
// Project  : FMntClassification = Form MaiNTenance CLASSIFICATION
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntClassificationCA.pas,v 1.2 2009/09/30 10:08:11 BEL\KDeconyn Exp $
// History :
// - Started from Flexpoint 2.0 - PMntClassification - CVS revision 1.1
// Version    Modified by  Reason
// 1.1        Chayanika(TCS)     //Regression Fix R2012.1 
//=============================================================================

unit FMntClassificationCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMntClassification, ScTskMgr_BDE_DBC;

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtRunParamAllowDuplicates = '/VAD=Allow duplicates';
  CtTxtTitle                   = 'Maintenance Classification';                         //Regression Fix R2012.1 (Chayanika)

//=============================================================================
// TFrmMntClassificationCA
//=============================================================================

type
  TFrmMntClassificationCA = class(TFrmMntClassification)
    procedure FormActivate(Sender: TObject);                                    //Regression Fix R2012.1 (Chayanika)
    procedure SvcTskDetClassificationCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  protected
    FFlgAllowDuplicates: boolean;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    property FlgAllowDuplicates: boolean read FFlgAllowDuplicates
                                        write FFlgAllowDuplicates;
  end;

var
  FrmMntClassificationCA: TFrmMntClassificationCA;

//*****************************************************************************

implementation

{$R *.dfm}

uses
  SfDialog,
  SfList_BDE_DBC,
  SmUtils,

  FDetClassificationCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntClassificationCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntClassificationCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2012/06/27 10:08:11 $';

//*****************************************************************************
// Implementation of TFrmMntClassification
//*****************************************************************************
//Regression Fix R2012.1 (Chayanika) Start
procedure TFrmMntClassificationCA.FormActivate(Sender: TObject);
begin  // of TFrmMntClassificationCA.FormActivate
  inherited;
    application.Title := CtTxtTitle;             
end;   // of TFrmMntClassificationCA.FormActivate
//Regression Fix R2012.1 (Chayanika) End
//=============================================================================
procedure TFrmMntClassificationCA.BeforeCheckRunParams;
begin // of TFrmMntClassificationCA.BeforeCheckRunParams
  inherited;
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  AddRunParams ('/VAD', CtTxtRunParamAllowDuplicates);
end; // of TFrmMntClassificationCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntClassificationCA.CheckAppDependParams(TxtParam: string);
begin // of TFrmMntClassificationCA.CheckAppDependParams
  if AnsiCompareText (copy(TxtParam, 3, 2), 'AD') = 0 then
    FlgAllowDuplicates := True
  else
    inherited;
end; // of TFrmMntClassificationCA.CheckAppDependParams

//=============================================================================

procedure TFrmMntClassificationCA.SvcTskDetClassificationCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin // of TFrmMntClassificationCA.SvcTskDetClassificationCreateExecutor
  NewObject := TFrmDetClassificationCA.Create (Self);
  TFrmDetClassificationCA(NewObject).FlgAllowDuplicates := FlgAllowDuplicates;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end; // of TFrmMntClassificationCA.SvcTskDetClassificationCreateExecutor

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FMntClassification
