//=Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved.=
// Packet   : FlexPoint Development 2.0.1
// Customer : Castorama
// Unit     : FRptVSCfgGeneral.PAS : General Configuration form to print reports
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptVSCfgGeneral.pas,v 1.2 2007/04/05 14:25:28 goegebkr Exp $
// History :
//=============================================================================

unit FRptVSCfgGeneral;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, SfVSPrinter7,
  SmVSPrinter7Lib_TLB, Db, DBTables;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtNoSelection = 'Not all necessary items are selected!';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmRptCfgGeneral = class(TFrmAutoRun)
    BtnPreview: TSpeedButton;
    BtnPrintSetup: TSpeedButton;
    BtnPrint: TSpeedButton;
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnPrintSetupClick(Sender: TObject);
    procedure ActStartExecExecute(Sender: TObject);
  private
    { Private declarations }
    FFlgPreview    : Boolean;          // Print or Preview the rapport.

  protected
    FFrmVSPreview  : TFrmVSPreview;    // VS Preview form

    procedure DefineStandardRunParams; override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure AfterCheckRunParams; override;
    procedure AutoStart (Sender : TObject); override;
    procedure PrepareForm; virtual;

    function GetFrmVSPreview : TFrmVSPreview; virtual;
    function GetVspPreview : TVSPrinter; virtual;
    function GetItemsSelected : Boolean; virtual;
    procedure PreparePreview; virtual;
    procedure GeneratePreview; virtual;
  public
    { Public declarations }
    property ItemsSelected : Boolean read GetItemsSelected;
    property FrmVSPreview : TFrmVSPreview read GetFrmVSPreview;
    property VspPreview : TVSPrinter read GetVspPreview;
    property FlgPreview : Boolean read FFlgPreview
                                  write FFlgPreview;
    procedure CreateAdditionalModules; override;
    procedure Execute; override;
  end;

var
  FrmRptCfgGeneral: TFrmRptCfgGeneral;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils, DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FRptVSCfgGeneral';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptVSCfgGeneral.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2007/04/05 14:25:28 $';

//*****************************************************************************
// Implementation of TFrmRptCfgGeneral
//*****************************************************************************

function TFrmRptCfgGeneral.GetItemsSelected : Boolean;
begin  // of TFrmRptCfgGeneral.GetItemsSelected
  Result := True;
end;   // of TFrmRptCfgGeneral.GetItemsSelected

//=============================================================================
// TFrmRptCfgGeneral.DefineStandardRunParams : fill in the standard runparameters.
//=============================================================================

procedure TFrmRptCfgGeneral.DefineStandardRunParams;
begin  // of TFrmRptCfgGeneral.DefineStandardRunParams
  inherited;
end;   // of TFrmRptCfgGeneral.DefineStandardRunParams

//=============================================================================
// TFrmRptCfgGeneral.BeforeCheckRunParams : placeholder to provide an inherited
// form with the possibility of adding some specific runparameters.
//=============================================================================

procedure TFrmRptCfgGeneral.BeforeCheckRunParams;
begin  // of TFrmRptCfgGeneral.BeforeCheckRunParams
end;   // of TFrmRptCfgGeneral.BeforeCheckRunParams

//=============================================================================

procedure TFrmRptCfgGeneral.CheckAppDependParams (TxtParam : string);
begin  // of TFrmRptCfgGeneral.CheckAppDependParams
  inherited;
end;   // of TFrmRptCfgGeneral.CheckAppDependParams

//=============================================================================

procedure TFrmRptCfgGeneral.AfterCheckRunParams;
begin  // of TFrmRptCfgGeneral.AfterCheckRunParams
  inherited;
end;   // of TFrmRptCfgGeneral.AfterCheckRunParams

//=============================================================================

procedure TFrmRptCfgGeneral.AutoStart (Sender : TObject);
begin  // of TFrmRptCfgGeneral.AutoStart
  if Application.Terminated then
    Exit;

  inherited;

  PrepareForm;

  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;   // of TFrmRptCfgGeneral.AutoStart

//=============================================================================

procedure TFrmRptCfgGeneral.PrepareForm;
begin  // of TFrmRptCfgGeneral.PrepareForm
end;   // of TFrmRptCfgGeneral.PrepareForm

//=============================================================================

function TFrmRptCfgGeneral.GetFrmVSPreview : TFrmVSPreview;
begin  // of TFrmRptCfgGeneral.GetFrmVSPreview
  if not Assigned (FFrmVSPreview) then
    FFrmVSPreview := TFrmVSPreview.Create (Application);
  Result := FFrmVSPreview;
end;   // of TFrmRptCfgGeneral.GetFrmVSPreview

//=============================================================================

function TFrmRptCfgGeneral.GetVspPreview : TVSPrinter;
begin  // of TFrmRptCfgGeneral.GetVspPreview
  Result := FrmVSPreview.VspPreview;
end;   // of TFrmRptCfgGeneral.GetVspPreview

//=============================================================================

procedure TFrmRptCfgGeneral.CreateAdditionalModules;
begin  // of TFrmRptCfgGeneral.CreateAdditionalModules
  if not Assigned (DmdFpn) then
    DmdFpn := TDmdFpn.Create (Application);

  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Application);

  if not Assigned (DmdFpnTradeMatrix) then
    DmdFpnTradeMatrix := TDmdFpnTradeMatrix.Create (Application);

  inherited;
end;   // of TFrmRptCfgGeneral.CreateAdditionalModules

//=============================================================================

procedure TFrmRptCfgGeneral.Execute;
begin  // of TFrmRptCfgGeneral.Execute
  PreparePreview;
  GeneratePreview;
  if FlgPreview then
    FrmVSPreview.ShowModal
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
end;   // of TFrmRptCfgGeneral.Execute

//=============================================================================

procedure TFrmRptCfgGeneral.PreparePreview;
begin  // of TFrmRptCfgGeneral.PreparePreview
end;   // of TFrmRptCfgGeneral.PreparePreview

//=============================================================================

procedure TFrmRptCfgGeneral.GeneratePreview;
begin  // of TFrmRptCfgGeneral.GeneratePreview
end;   // of TFrmRptCfgGeneral.GeneratePreview

//=============================================================================

procedure TFrmRptCfgGeneral.BtnPrintClick(Sender: TObject);
begin  // of TFrmRptCfgGeneral.BtnPrintClick
  inherited;
  FlgPreview := (Sender = BtnPreview);
  ActStartExec.Execute;
end;   // of TFrmRptCfgGeneral.BtnPrintClick

//=============================================================================

procedure TFrmRptCfgGeneral.BtnPrintSetupClick(Sender: TObject);
begin  // of TFrmRptCfgGeneral.BtnPrintSetupClick
  inherited;
  FrmVSPreview.ActPrinterSetupExecute (nil);
end;   // of TFrmRptCfgGeneral.BtnPrintSetupClick

//=============================================================================

procedure TFrmRptCfgGeneral.ActStartExecExecute(Sender: TObject);
begin  // of TFrmRptCfgGeneral.ActStartExecExecute
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;

  inherited;
end;   // of TFrmRptCfgGeneral.ActStartExecExecute

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FRptVSCfgGeneral

