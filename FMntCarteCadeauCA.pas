//================= Real Software - Retail Division (c) 2006 ==================
// Packet   : FlexPoint 2.0.1
// Customer : Castorama
// Unit     : FMntCarteCadeauCA.PAS : : Form DETail Carte Cadeau CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCarteCadeauCA.pas,v 1.2 2006/12/20 13:00:38 JurgenBT Exp $
// History:
//  - Started from Castorama - Flexpoint 2.0 - FMntCarteCadeauCA - CVS revision 1.2
// Version    Modified by  Reason
// 1.1        SRM(TCS)     Regression Fix R2012.1
//=============================================================================

unit FMntCarteCadeauCA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ScTskMgr_BDE_DBC, FFpnMnt;
 resourcestring                                                                 //Regression Fix R2012.1 (SRM) 
  CtTxtTitle             = 'Maintenance Carte Cadeau';                         //Regression Fix R2012.1 (SRM) 
type
  TFrmMntCarteCadeauCA = class(TFrmFpnMnt)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskDetCarteCadeau: TSvcFormTask;
    SvcTskLstCarteCadeau: TSvcListTask;
     procedure FormActivate(Sender: TObject);                                   //Regression Fix R2012.1 (SRM) 
     procedure SvcTskLstCarteCadeauCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
     procedure SvcTskDetCarteCadeauCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMntCarteCadeauCA: TFrmMntCarteCadeauCA;

implementation

{$R *.dfm}

uses
  SfList_BDE_DBC,
  SfDetail_BDE_DBC,
  SmUtils,
  SrStnCom,
  RFpnCom,
  DFpn,
  DFpnUtils,

  DFpnCarteCadeau,
  FDetCarteCadeauCA;


//=============================================================================
// Source-identifiers
//=============================================================================

//=============================================================================
 //Regression Fix R2012.1 (SRM) Start
procedure TFrmMntCarteCadeauCA.FormActivate(Sender: TObject);
begin  // of TFrmMntCarteCadeauCA.FormActivate
  inherited;
    application.Title := CtTxtTitle;        
end;   // of TFrmMntCarteCadeauCA.FormActivate
//Regression Fix R2012.1 (SRM) End
//=============================================================================
procedure TFrmMntCarteCadeauCA.SvcTskLstCarteCadeauCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin

    NewObject := TFrmList.Create (Self);
    TFrmList(NewObject).AllowedJobs := SetEntryCmds;
    FlgCreated := True;

end;

//=============================================================================
procedure TFrmMntCarteCadeauCA.SvcTskDetCarteCadeauCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCountry.SvcTskDetCountryCreateExecutor
  NewObject := TFrmDetCarteCadeauCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCountry.SvcTskDetCountryCreateExecutor

//=============================================================================


end.
