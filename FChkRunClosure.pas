//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : Castorama Development
// Unit   : FChkRunClosure : Form to CHecK if it is possible to RUN the CLOSURE
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChkRunClosure.pas,v 1.2 2006/12/22 13:39:44 smete Exp $
//=============================================================================

unit FChkRunClosure;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls;

//=============================================================================
// Global definitions
//=============================================================================

var  // Exit codes
  ViNumIgnoreDayClose  : Integer = 100102;
  ViNumIgnoreYearClose : Integer = 100103;
  ViNumIgnoreDYClose   : Integer = 100104;

var  // Year close date
  ViTxtYearClose       : string  = '3112'; //Day & Month

resourcestring // Run params
  CtTxtRunParamDateTime = '/D=Date of excecution';

//*****************************************************************************
// Interface of TFrmChkRunClosure
//*****************************************************************************

type
  TFrmChkRunClosure = class(TFrmAutoRun)
  protected
    TxtDatRun      : string;           // Run date
  public
    procedure BeforeCheckRunParams; override;
    procedure AfterCheckRunParams; override;
    procedure AutoStart (Sender : TObject); override;
    procedure Execute; override;
  end;

var
  FrmChkRunClosure: TFrmChkRunClosure;

//*****************************************************************************

implementation

uses
  SfDialog,
  SmDBUtil,
  SmUtils,
  StDate,
  StDateSt,
  DfpnUtils;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FChkRunClosure';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FChkRunClosure.pas  $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:39:44 $';

//*****************************************************************************
// Implementation of TFrmChkRunClosure
//*****************************************************************************

procedure TFrmChkRunClosure.BeforeCheckRunParams;
var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
begin  // of TFrmChkRunClosure.BeforeCheckRunParams
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'D';
  SplitString (CtTxtRunParamDateTime,'=',TxtPartLeft,TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmChkRunClosure.BeforeCheckRunParams

//=============================================================================

procedure TFrmChkRunClosure.AfterCheckRunParams;
var
  TxtParam         : string;           // Run parameter
  CntParam         : Integer;          // Counter for loop
begin  // of TFrmChkRunClosure.AfterCheckRunParams
  for CntParam := 1 to ParamCount do begin
    TxtParam := ParamStr (CntParam);
    if (TxtParam[1] + TxtParam[2] = '/D') then
      TxtDatRun := Copy (Txtparam, 3, length (TxtParam));
  end;
end;   // of TFrmChkRunClosure.AfterCheckRunParams

//=============================================================================

procedure TFrmChkRunClosure.Execute;
var
  DatTransBeginPrm : TDateTime;        // Date To check on
  FlgIgnDayClose   : Boolean;          // Ignore Day Close
  FlgIgnYearClose  : Boolean;          // Ignore year Close
begin  // of TFrmChkRunClosure.Execute
  ExitCode := 0;
  DatTransBeginPrm :=  StDateToDateTime (
                         DateStringToStDate (SmUtils.CtTxtDatFormat, TxtDatRun,
                                             SmUtils.CtValEpoch));
  FlgIgnDayClose :=
    not DmdFpnUtils.QueryInfo ('SELECT TOP 1 IdtPosTransaction' +
                               #10'  FROM PosTransaction' +
                               #10' WHERE DatTransBegin > ' +
                               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat,
                                                     DatTransBeginPrm), '''') +
                               #10'   AND DatTransBegin < ' +
                               AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat,
                                                   DatTransBeginPrm+1), ''''));
  DmdFpnUtils.CloseInfo;
  FlgIgnYearClose := not (AnsiCompareText(FormatDateTime ('DDMM',DatTransBeginPrm),
                                      ViTxtYearClose) = 0);
  if FlgIgnYearClose and FlgIgnDayClose then
    ExitCode := ViNumIgnoreDYClose
  else if FlgIgnYearClose then
    ExitCode := ViNumIgnoreYearClose
  else if FlgIgnDayClose then
    ExitCode := ViNumIgnoreDayClose;
end;   // of TFrmChkRunClosure.Execute

//=============================================================================

procedure TFrmChkRunClosure.AutoStart (Sender : TObject);
begin  // of TFrmChkRunClosure.AutoStart
  if Application.Terminated then
    Exit;

  inherited;

  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;   // of TFrmChkRunClosure.AutoStart

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FChkRunClosure
