//=========== Sycron Computers Belgium (c) 2001 ===============================
// Packet   : FlexPoint 2.0 Development
// Customer : Castorama
// Unit     : FCmmCtlCashDeskCa : Form Controle CashDesk
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCtlCashDeskCa.pas,v 1.1 2006/12/21 14:00:05 hofmansb Exp $
//=============================================================================

unit FMntCtlCashDeskCa;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FFpnMnt, ScTskMgr_BDE_DBC;

//=============================================================================
// Global type definitions
//=============================================================================

type
  TFrmMntCtlCashDeskCa = class(TFrmFpnMnt)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskLmsCtlCashDesk: TSvcListTask;
    procedure SvcTskLmsCtlCashDeskCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;  // of TFrmMntCtlCashDeskCa

var
  FrmMntCtlCashDeskCa: TFrmMntCtlCashDeskCa;

//*****************************************************************************

implementation

uses
  SfDialog,

  DFpnUtils,
  DFpnCtlCashDeskCa,

  FLmsCtlCashDeskCa;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName  = 'FMntCtlCashDeskCa';

const  // PVCS-keywords
  CtTxtSrcName     = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCtlCashDeskCa.pas,v $';
  CtTxtSrcVersion  = '$Revision: 1.1 $';
  CtTxtSrcDate     = '$Date: 2006/12/21 14:00:05 $';

//*****************************************************************************
// Implementation of TFrmCtlCashDeskCa
//*****************************************************************************

procedure TFrmMntCtlCashDeskCa.SvcTskLmsCtlCashDeskCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCtlCashDeskCa.SvcTskLmsCtlCashDeskCreateExecutor
  NewObject := TFrmLmsCtlCashDeskCa.Create (Self);
  TFrmLmsCtlCashDeskCa(NewObject).CodExecCa := exeItemForCorrection;
  FlgCreated := True;
end;   // of TFrmMntCtlCashDeskCa.SvcTskLmsCtlCashDeskCreateExecutor

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
