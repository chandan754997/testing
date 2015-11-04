//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Castorama Development
// Unit   : FModeMonetique : Form MODE MONETIQUE
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FModeMonetique.pas,v 1.3 2009/09/28 15:32:01 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FModeMonetique - CVS revision 1.5
//=============================================================================

unit FModeMonetique;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, CheckLst, DbTables;

//*****************************************************************************
// Resource strings
//*****************************************************************************

resourcestring
  CtTxtExecFailed = 'Execution failed for cashdesk(s) %s';

//*****************************************************************************
// Constants
//*****************************************************************************

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmModeMonetique = class(TFrmAutoRun)
    ChkLstModeMonetique: TCheckListBox;
    LblSelectCashDesk: TLabel;
    BtnSelect: TButton;
    BtnDeselect: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ActStartExecExecute(Sender: TObject);
    procedure BtnSelectClick(Sender: TObject);
    procedure BtnDeselectClick(Sender: TObject);
  private
    { Private declarations }
  protected
    { Private declarations }
    SprRTLstWorkStat    : TStoredProc; // Stored procedure for Workstat    
  public
    { Public declarations }
  end; // of TFrmModeMonetique

var
  FrmModeMonetique: TFrmModeMonetique;

//*****************************************************************************

implementation

{$R *.DFM}

Uses
  ShellAPI,
  SfDialog,
  SmDBUtil,
  SmUtils,
  SmDBUtil_BDE,
  DFpnUtils,
  DfpnWorkStatCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FModeMonetique';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FModeMonetique.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 15:32:01 $';

//=============================================================================

procedure TFrmModeMonetique.FormCreate(Sender: TObject);
begin  // of TFrmModeMonetique.FormCreate
  inherited;
  SprRTLstWorkStat :=
    CopyStoredProc (Self, 'SprRTLstWorkStat',
                    DmdFpnUtils.SprLstFullJoin,
                    ['@PrmTxtTable=WorkStat',
                     '@PrmTxtArrFields=' +
                     'CodType;IdtCheckOut;TxtPublDescr;IdtWorkStat;',
                     '@PrmTxtSequence=CodType;IdtWorkStat',
                     '@PrmTxtFrom=' + IntToStr(CtCodWorkStatCheckOut),
                     '@PrmTxtTo=' + IntToStr(CtCodWorkStatMasterCheckOut)]);
  SprRTLstWorkStat.Active := True;
  ChkLstModeMonetique.Items.Clear;
  SprRTLstWorkStat.First;
  while not SprRTLstWorkStat.Eof do begin
    ChkLstModeMonetique.Items.Add (
      SprRTLstWorkStat.FieldByName ('TxtPublDescr').AsString);
    SprRTLstWorkStat.Next;
  end;
end;   // of TFrmModeMonetique.FormCreate

//=============================================================================

procedure TFrmModeMonetique.ActStartExecExecute(Sender: TObject);
var
  proc_info: TProcessInformation;
  startinfo: TStartupInfo;
  ExitCode: longword;
  TxtPathBat          : String;           // Path of the batchfile
  TxtPathError        : String;           // Path of the errorfile
  TxtParams           : String;           // Params for batchfile
  StrLstFailed        : TStringlist;      // Stringlist containing failed cashdesks
  TxtFailed           : String;           // String containing failed cashdesks
  NumCntItems         : integer;          // Counter
begin
  // Initialize the structures
  FillChar(proc_info, sizeof(TProcessInformation), 0);
  FillChar(startinfo, sizeof(TStartupInfo), 0);
  startinfo.cb := sizeof(TStartupInfo);

  TxtPathBat := 'c:\bat\exonoff.bat';
  TxtPathError := 'c:\bat\errorfile.txt';
  StrLstFailed := TStringList.Create;
  TxtFailed := '';
  SprRTLstWorkStat.First;
  NumCntItems := 0;
  if FileExists(TxtPathError) then
    DeleteFile(TxtPathError);

  while not SprRTLstWorkStat.Eof do begin
    if ChkLstModeMonetique.Checked [NumCntItems] then
      TxtParams := SprRTLstWorkStat.FieldByName ('IdtCheckout').AsString +
                   ' OFFLINE'
    else
      TxtParams := SprRTLstWorkStat.FieldByName ('IdtCheckout').AsString +
                   ' ONLINE';
    // Attempts to create the process
    if CreateProcess(nil, PChar(TxtPathBat + ' ' + TxtParams), nil, nil, false,
    NORMAL_PRIORITY_CLASS, nil, nil, startinfo, proc_info) <> False then begin
      // The process has been successfully created
      // No let's wait till it ends...
      WaitForSingleObject(proc_info.hProcess, INFINITE);
      // Process has finished. Now we should close it.
      GetExitCodeProcess(proc_info.hProcess, ExitCode);  // Optional
      CloseHandle(proc_info.hThread);
      CloseHandle(proc_info.hProcess);
      if FileExists(TxtPathError) then begin
        StrLstFailed.Add(SprRTLstWorkStat.FieldByName ('IdtCheckout').AsString);
        DeleteFile(TxtPathError);
      end;
    end
    else begin
      // Failure creating the process
      StrLstFailed.Add(SprRTLstWorkStat.FieldByName ('IdtCheckout').AsString);
    end;//if
    SprRTLstWorkStat.Next;
    Inc(NumCntItems);
  end;
  if StrLstFailed.Count > 0 then begin
    for NumCntItems := 0 to StrLstFailed.Count - 1 do begin
      if TxtFailed = '' then
        TxtFailed := StrLstFailed.Strings[NumCntItems]
      else
        TxtFailed := TxtFailed + ', ' + StrLstFailed.Strings[NumCntItems];
    end;
  MessageDlg (Format (CtTxtExecFailed,[TxtFailed]), mtError, [mbOk], 0);    
  end;
end;   // of TFrmModeMonetique.ActStartExecExecute

//=============================================================================

procedure TFrmModeMonetique.BtnSelectClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmModeMonetique.BtnSelectClick
  inherited;
  for CntIx := 0 to Pred (ChkLstModeMonetique.Items.Count) do
    ChkLstModeMonetique.Checked [CntIx] := True;
end;   // of TFrmModeMonetique.BtnSelectClick

//=============================================================================

procedure TFrmModeMonetique.BtnDeselectClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmModeMonetique.BtnDeselectClick
  inherited;
  for CntIx := 0 to Pred (ChkLstModeMonetique.Items.Count) do
    ChkLstModeMonetique.Checked [CntIx] := False;
end;   // of TFrmModeMonetique.BtnDeselectClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end. // of FModeMonetique
