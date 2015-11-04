//=========== Sycron Computers Belgium (c) 1997-1998 ==========================
// Packet : FlexPos Development
// Unit   : FMntCountryCA.PAS : MainForm MaiNTenance COUNTRY CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCountryCA.pas,v 1.1 2006/12/18 13:05:01 hofmansb Exp $
// Version    Modified by  Reason
// 1.1        Chayanika(TCS)    //Regression Fix R2012.1 
//=============================================================================

unit FMntCountryCa;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FMntCountry, ScTskMgr_BDE_DBC;

//=============================================================================
 resourcestring                                                                 //Regression Fix R2012.1 (Chayanika)
  CtTxtTitle             = 'Maintenance Country';                               //Regression Fix R2012.1 (Chayanika)
type
  TFrmMntCountryCA = class(TFrmMntCountry)
     procedure FormActivate(Sender: TObject);                                   //Regression Fix R2012.1 (Chayanika)
    procedure SvcTskLstCountryCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetCountryCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMntCountryCA: TFrmMntCountryCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses

  SfList_BDE_DBC,
  SfDetail_BDE_DBC,
  SfDialog,

  SmUtils,
  SrStnCom,

  RFpnCom,

  DFpn,
  DFpnUtils,

  DFpnCountryCA,

  FDetCountryCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FrmMntCountryCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FMntCountryCA.pas $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/18 13:05:01 $';

//*****************************************************************************
// Implementation of TFrmMntCountryCA
//*****************************************************************************
//Regression Fix R2012.1 (Chayanika)Start
procedure TFrmMntCountryCA.FormActivate(Sender: TObject);
begin  // of TFrmMntCountryCA.FormActivate
  inherited;
    application.Title := CtTxtTitle;        
end;   // of TFrmMntCountryCA.FormActivate
//Regression Fix R2012.1 (Chayanika) End
//=============================================================================
procedure TFrmMntCountryCA.SvcTskLstCountryCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCountryCA.SvcTskLstCountryCreateExecutor
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds;
  FlgCreated := True;
end;   // of TFrmMntCountryCA.SvcTskLstCountryCreateExecutor

//=============================================================================

procedure TFrmMntCountryCA.SvcTskDetCountryCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCountryCA.SvcTskDetCountryCreateExecutor
  NewObject := TFrmDetCountryCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCountryCA.SvcTskDetCountryCreateExecutor

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);


end.
