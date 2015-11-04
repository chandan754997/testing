//=========== Sycron Computers Belgium (c) 1997-1998 ==========================
// Packet  : FlexPoint Development
// Customer: Castorama
// Unit    : FMntTradeMatrixCA.PAS : Form Maintenance TRADEMATRIX for castorama
// Date    : 17/03/05
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntTradeMatixCA.pas,v 1.1 2006/12/18 15:44:30 hofmansb Exp $
// History :
// Version    Modified by              Reason
// 1.1        Chayanika(TCS)     Regression Fix R2012.1
//=============================================================================

unit FMntTradeMatixCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FMntTradeMatrix, ScTskMgr_BDE_DBC;

resourcestring  // for runtime parameters
  CtTxtRunParamRussia = 'Russia';
  CtTxtTitle = 'Maintenance Tradematrix';  // Regression Fix R2012.1(Chayanika)

//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmMntTradeMatrixCA = class(TFrmMntTradeMatrix)
    procedure FormActivate(Sender: TObject);    // Regression Fix R2012.1(Chayanika)
    procedure SvcTskDetTradeMatrixCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
    FFlgRussia: boolean;
  protected
    { Protected declarations }
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    property FlgRussia: boolean read FFlgRussia write FFlgRussia;
  end;

var
  FrmMntTradeMatrixCA: TFrmMntTradeMatrixCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  sfDialog,
  SmUtils,
  FDetTradeMatrixCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntTradeMatixCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/18 15:44:30 $';

//*****************************************************************************
// Implementation of TFrmMntTradeMatrixCA
//*****************************************************************************

procedure TFrmMntTradeMatrixCA.BeforeCheckRunParams;
begin  // of TFrmMntTradeMatrixCA.BeforeCheckRunParams
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  AddRunParams ('/VRussia', CtTxtRunParamRussia);
end;   // of TFrmMntTradeMatrixCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntTradeMatrixCA.CheckAppDependParams(TxtParam: string);
begin  // of TFrmMntTradeMatrixCA.CheckAppDependParams
  if AnsiCompareText (copy(TxtParam, 3, 2), 'Ru') = 0 then begin
    FlgRussia := True;
  end;
end;   // of TFrmMntTradeMatrixCA.CheckAppDependParams

//=============================================================================

procedure TFrmMntTradeMatrixCA.SvcTskDetTradeMatrixCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntTradeMatrixCA.SvcTskDetTradeMatrixCreateExecutor
  NewObject := TFrmDetTradeMatrixCA.Create (Self);
  TFrmDetTradeMatrixCA(NewObject).FlgRussia := FlgRussia;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntTradeMatrixCA.SvcTskDetTradeMatrixCreateExecutor

//=============================================================================
// Regression Fix R2012.1(Chayanika) :: start
procedure TFrmMntTradeMatrixCA.FormActivate(Sender: TObject);
begin
  inherited;
Application.Title:=CtTxtTitle;
end;
// Regression Fix R2012.1(Chayanika)  ::end

//==============================================================================
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.
