//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet  : FlexPoint Development
// Customer: Castorama
// Unit    : FMntApplicParamCA.PAS : MainForm MaiNTenance APPLICPARAM for CAstorama
//-----------------------------------------------------------------------------
// PVCS   :  $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntApplicParamCA.pas,v 1.3 2007/04/17 12:54:56 RETAIL\goegebkr Exp $
// History:
//=============================================================================

unit FMntApplicParamCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMntApplicParam, ScTskMgr_BDE_DBC;

//=============================================================================
// Definitions for run-parameters
//=============================================================================

resourcestring
  CtTxtRunParamVIDT     = '/VIDT[x]=show detail of identification [x]';

resourcestring
  CtTxtEmInvalidIdt     = 'Invalid identification :';

//=============================================================================
// TFrmMntApplicParamCA
//=============================================================================

type
  TFrmMntApplicParamCA = class(TFrmMntApplicParam)
    procedure SvcTskDetApplicParamCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  protected
    { Protected declarations }
    // Datafields for run parameters
    IdtApplicParam      : string;      // Idt of ApplicParam to show directly
    // Methods
    procedure DefineStandardRunParams; override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure AfterCheckRunParams; override;
    procedure AutoStart (Sender : TObject); override;
  public
    { Public declarations }
  end;

var
  FrmMntApplicParamCA   : TFrmMntApplicParamCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SfList_BDE_DBC,

  smUtils,

  DFpnUtils,

  FDetApplicParam;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntApplicParamCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntApplicParamCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2007/04/17 12:54:56 $';


//*****************************************************************************
// Implementation of TFrmMntApplicParamCA
//*****************************************************************************

//=============================================================================
// TFrmMntApplicParamCA.AutoStart : Start the main task (which will be installed
// at design time most of the times).
//=============================================================================

procedure TFrmMntApplicParamCA.AutoStart (Sender : TObject);
begin  // of TFrmMntApplicParamCA.AutoStart
  if Application.Terminated then
    Exit;

  Application.OnActivate := PSavAppOnAct;
  if Assigned (SvcTaskMgr) then begin
    Visible := False;
    if IdtApplicParam <> '' then begin
      if SvcTskLstApplicParam.DetailTask <> '' then
        SvcTaskMgr.LaunchTask (SvcTskLstApplicParam.DetailTask);
    end
    else begin
      SvcTaskMgr.Start;
    end;
    Application.Terminate;
  end;
end;   // of TFrmMaintenance.AutoStart

//=============================================================================

procedure TFrmMntApplicParamCA.DefineStandardRunParams;
begin  // of TFrmMntApplicParamCA.DefineStandardRunParams
  inherited;
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'V';
end;   // of TFrmMntApplicParamCA.DefineStandardRunParams

//=============================================================================

procedure TFrmMntApplicParamCA.BeforeCheckRunParams;
var
  TxtLeft          : string;           // Left part of splitted string
  TxtRight         : string;           // Right part of splitted string
begin  // of TFrmMntApplicParamCA.BeforeCheckRunParams
  inherited;
  SplitString (CtTxtRunParamVIDT, '=', TxtLeft, TxtRight);
  AddRunParams (TxtLeft, TxtRight);
end;   // of TFrmMntApplicParamCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntApplicParamCA.CheckAppDependParams (TxtParam : string);
begin  // of TFrmMntApplicParamCA.CheckAppDependParams
  if (TxtParam[1] = '/') and (UpCase (TxtParam[2]) = 'V') then
    if CompareText (Copy (TxtParam, 3, 3), 'IDT') = 0 then begin
      if Length (TxtParam) > 5 then begin
        IdtApplicParam := Copy (TxtParam, 6, Length (TxtParam));
        if not DmdFpnUtils.QueryInfo (
          'SELECT * FROM ApplicParam' +
       #10' WHERE IdtApplicParam = ' + QuotedStr (IdtApplicParam)) then begin
          ExitCode := CtNumExitRunPmInvalid;
          ShowAboutWithMessage (CtTxtEmInvalidIdt + ' ' + IdtApplicParam);
        end;
        DmdFpnUtils.CloseInfo;
      end
      else
        InvalidRunParam (TxtParam)
    end
  else
    inherited CheckAppDependParams (TxtParam);
end;   // of TFrmMntApplicParamCA.CheckAppDependParams

//=============================================================================
// TFrmMaintenance.AfterCheckRunParams: Placeholder to provide an inherited
// form with the possibility of checking the settings of given run parameters
//=============================================================================

procedure TFrmMntApplicParamCA.AfterCheckRunParams;
begin  // of TFrmMntApplicParamCA.AfterCheckRunParams
  inherited;
  if Application.Terminated then
    Exit;

  if (IdtApplicParam <> '') and
     ((SetEntryCmds <> [CtCodJobRecCons]) or FlgFullFunc) then begin
   ExitCode := CtNumExitRunPmInvalid;
   InvalidRunParamCombination ('/V[?]', CtTxtRunParamVIDT);
  end;
end;   // of TFrmMntApplicParamCA.AfterCheckRunParams

//=============================================================================

procedure TFrmMntApplicParamCA.SvcTskDetApplicParamCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin
  inherited;
  if IdtApplicParam <> '' then begin
    TFrmDetApplicParam (NewObject).StrLstIdtValues.Clear;
    TFrmDetApplicParam (NewObject).StrLstIdtValues.
      Add (SvcTskLstApplicParam.IdtFields[0] + '=' + IdtApplicParam);
    if not Assigned (SvcTskLstApplicParam.ActiveSequence) then
      SvcTskLstApplicParam.ActiveSequence := SvcTskLstApplicParam.Sequences[0];
    SvcTskLstApplicParam.ActiveSequence.DataSet.Active := True;
    SvcTskLstApplicParam.
      LocateRow (TFrmDetApplicParam (NewObject).StrLstIdtValues);
    TFrmDetApplicParam (NewObject).CodJob := CtCodJobRecMod
  end;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.   // of FMntApplicParamCA
