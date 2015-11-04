//================ Kingfisher IT Services (c) 2012 ==========================
// Packet : FlexPoint Development
// Unit   : FChlVSCustomerCA : MainForm Choice List VSview Customer
//-----------------------------------------------------------------------------
// $Header: C:\IntDev\Castorama\Flexpoint201\Develop\FChlVSCustomerCA.pas,v 1.0 2013/01/10 13:45:50 srmoulik Exp $
// History:
// - Started from Flexpoint20 - FChlVSCustomerCA - CVS revision 1.0
// Version   Modified by    Reason
// 1.0       SRM.  (TCS)    R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM
//=============================================================================

unit FChlVSCustomerCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FChlVSCustomer, DB, DBTables, ScTskMgr_BDE_DBC,SfRptVSCfgChoice_BDE_DBC,
  FChlChoiceListCA;

//=============================================================================

resourcestring
   CtTxtRunParamBDFR = 'BDFR';
   CtTxtRunParamBDES = 'BDES';
   CtTxtRunParamCAFR = 'CAFR';
   CtTxtRunParamCARU = 'CARU';
   CtTxtTitle        = 'Choice list Customer';

type
  TFrmChlCustomerCA = class(TFrmChlCustomer)
    procedure SvcTskChlCreateExecutor(Sender: TObject; var NewObject: TObject;
      var FlgCreated: Boolean);
    procedure FormActivate(Sender: TObject);

  public
    { Private declarations }
   FFlgLCBDFR          : Boolean;
   FFlgLCBDES          : Boolean;
   FFlgLCCAFR          : Boolean;
   FFlgLCCARU          : Boolean;
   FlgListOfCustomer   : Boolean;

  protected
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }

    property FlgLCBDFR               : Boolean read FFlgLCBDFR
                                               write FFlgLCBDFR;
    property FlgLCBDES               : Boolean read FFlgLCBDES
                                               write FFlgLCBDES;
    property FlgLCCAFR               : Boolean read FFlgLCCAFR
                                               write FFlgLCCAFR;
    property FlgLCCARU               : Boolean read FFlgLCCARU
                                               write FFlgLCCARU;                                         
  end;

type
  TFrmrptTest = class(TFrmRptCfgChoice)
end;
var
  FrmChlCustomerCA: TFrmChlCustomerCA;

//*****************************************************************************
implementation

{$R *.dfm}
uses
SfDialog,
SmUtils;
//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FChlVSCustomerCA';
const
  CtTxtSrcVersion = '$Revision: 1.0 $';
  CtTxtSrcDate    = '$Date: 2013/01/10 13:45:50 $';

//*****************************************************************************
// Implementation of TFrmChlCustomerCA
//*****************************************************************************

//=============================================================================

procedure TFrmChlCustomerCA.BeforeCheckRunParams;
begin  // of TFrmChlCustomerCA.BeforeCheckRunParams
 inherited;
   AddRunParams ('/VBDFR', CtTxtRunParamBDFR);
   AddRunParams ('/VBDES', CtTxtRunParamBDES);
   AddRunParams ('/VCAFR', CtTxtRunParamCAFR);
   AddRunParams ('/VCARU', CtTxtRunParamCARU);
end;   // of TFrmChlCustomerCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmChlCustomerCA.CheckAppDependParams (TxtParam : string);
begin  // of TFrmChlCustomerCA.CheckAppDependParams
  FlgListOfCustomer := False;
  TxtParam := AnsiUppercase (TxtParam);
  if FlgRunPmConfigFileSave and (TxtParam = '/VCS') then
    FlgEnableConfigFileSave := True
  else if FlgRunPmConfigFileOpen and (TxtParam = '/VCO') then
    FlgEnableConfigFileOpen := True
  else if FlgRunPmReportFileSave and (TxtParam = '/VRS') then
    FlgEnableReportFileSave := True
  else if FlgRunPmReportFileOpen and (TxtParam = '/VRO') then
    FlgEnableReportFileOpen := True
  else if FlgRunPmExportFileSave and (TxtParam = '/VES') then
    FlgEnableExportFileSave := True
  else if FlgRunPmExportFileSave and FlgRunPmExportRawData and
          (TxtParam = '/VESD') then begin
    FlgEnableExportFileSave := True;
    FlgExportRawData := True;
    end
  else if AnsiCompareText (Copy(TxtParam, 3, 7), 'LCBDFR') = 0 then begin
    FlgLCBDFR := True;
  end
  else if AnsiCompareText (Copy(TxtParam, 3, 7), 'LCBDES') = 0 then
    FlgLCBDES := True
  else if AnsiCompareText (Copy(TxtParam, 3, 7), 'LCCAFR') = 0 then
    FlgLCCAFR := True
  else if AnsiCompareText (Copy(TxtParam, 3, 7), 'LCCARU') = 0 then
    FlgLCCARU := True
   else
    InvalidRunParam (TxtParam);
   FlgListOfCustomer := True;
end;   // of TFrmChlCustomerCA.CheckAppDependParams

//=============================================================================

procedure TFrmChlCustomerCA.FormActivate(Sender: TObject);
begin // of TFrmChlCustomerCA.FormActivate
  inherited;
  Application.Title:= CtTxtTitle;
end;  // of TFrmChlCustomerCA.FormActivate

//=============================================================================

procedure TFrmChlCustomerCA.SvcTskChlCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin // of TFrmChlCustomerCA.SvcTskChlCreateExecutor
  NewObject := TFrmRptCfgChoiceCA.Create (Self);
  FlgCreated := True;
  if ViTxtFNIni <> '' then
    TFrmRptCfgChoice(NewObject).TxtFNReportConfig := ViTxtFNIni;

  TFrmRptCfgChoice(NewObject).FNLogo :=
 ReplaceEnvVar ('%SYCROOT%\Image\FlexPoint.Report.BMP');

  TFrmRptCfgChoice(NewObject).VspPreview.OnNewPage := LocalOnNewPage;

  with TFrmRptCfgChoice(NewObject) do begin
    AllowConfigFileSave (FlgEnableConfigFileSave);
    AllowConfigFileOpen (FlgEnableConfigFileOpen);
    AllowReportFileSave (FlgEnableReportFileSave);
    AllowReportFileOpen (FlgEnableReportFileOpen);
    AllowExportFileSave (FlgEnableExportFileSave and
                         TSvcRptCfgChoiceTask(Sender).AllowExport);
 end;
end;  // of TFrmChlCustomerCA.SvcTskChlCreateExecutor

//=============================================================================

end.   // of FChlVSCustomerCA
