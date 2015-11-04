//= Copyright 2002 (c) Real Software NV - Retail Division. All rights reserved =
// Packet : FlexPoint Development
// Unit   : FMntEmployee.PAS : Maintenance form Employee
//-----------------------------------------------------------------------------
// PVCS   : $header: $
// History:
//=============================================================================

unit FMntEmployee;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FFpnMnt, ScTskMgr_BDE_DBC;

resourcestring
  CtTxtShowCardNumber    ='/VSC=Show card number';
  CtTxtPrintCards        ='/VPC=Print cards';
//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmMntEmployee = class(TFrmFpnMnt)
    SvcTskMgrEmployee: TSvcTaskManager;
    SvcTskLstEmployee: TSvcListTask;
    SvcTskDetEmployee: TSvcFormTask;
    SvcTskPrintCards: TSvcFormTask;
    procedure SvcTskLstEmployeeCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetEmployeeCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskPrintCardsCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
    FFlgPrintCards: Boolean;
    FFlgShowCard: Boolean;
  protected
    { Protected declarations }
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    property FlgPrintCards: Boolean read FFlgPrintCards write FFlgPrintCards;
    property FlgShowCard: Boolean read FFlgShowCard write FFlgShowCard;
  end;

var
  FrmMntEmployee: TFrmMntEmployee;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SfList_BDE_DBC,
  SmUtils,

  MFpnAddOn,

  DFpn,
  DFpnUtils,
  FDetEmployee,
  DFpnEmployee,
  FLstEmployee,
  FVSPrintCard;

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntEmployee';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntEmployee.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2008/01/04 09:24:08 $';

//*****************************************************************************
// Implementation of TFrmMntEmployee
//*****************************************************************************

procedure TFrmMntEmployee.SvcTskLstEmployeeCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin // of TFrmMntEmployee.SvcTskLstEmployeeCreateExecutor
  NewObject := TFrmLstEmployee.Create (Self);
  TFrmLstEmployee(NewObject).AllowedJobs := SetEntryCmds;
  TFrmLstEmployee(NewObject).FlgShowCard := FlgShowCard;
  TFrmLstEmployee(NewObject).FlgPrintCards := FlgPrintCards;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;  // of TFrmMntEmployee.SvcTskLstEmployeeCreateExecutor

//=============================================================================

procedure TFrmMntEmployee.SvcTskDetEmployeeCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin // of TFrmMntEmployee.SvcTskDetEmployeeCreateExecutor
  NewObject := TFrmDetEmployee.Create (Self);
  TFrmDetEmployee(NewObject).FlgShowCard := FlgShowCard;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end; // of TFrmMntEmployee.SvcTskDetEmployeeCreateExecutor

//=============================================================================

procedure TFrmMntEmployee.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmMntEmployee.BeforeCheckRunParams
  inherited;
  // Param /VSC
  SplitString(CtTxtShowCardNumber, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // Param /VPC
  SplitString(CtTxtPrintCards, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmMntEmployee.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntEmployee.CheckAppDependParams(TxtParam: string);
begin
  if (Length(TxtParam) = 4) and (Copy(TxtParam,3,2)= 'SC') then
    FlgShowCard := True
  else if (Length(TxtParam) = 4) and (Copy(TxtParam,3,2) = 'PC') then
    FlgPrintCards := True
  else
    inherited;
end;

//=============================================================================

procedure TFrmMntEmployee.SvcTskPrintCardsCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin
  NewObject := TFrmVSPrintCard.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end. // of TFrmMntEmployee
