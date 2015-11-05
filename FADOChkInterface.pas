//=== Copyright 2009 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet : Castorama Development
// Unit   : FADOChkInterface.PAS : Form to CHecK if the Interface is running
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADOChkInterface.pas,v 1.3 2009/09/28 13:16:16 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 20 - FADOChkInterface rev 1.2
// --- Rohit Testing ///--
//=============================================================================

unit FADOChkInterface;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, ADODB,Tlhelp32;

//=============================================================================
// Constants
//=============================================================================

const
  CtTxtNetSendCommand   = 'NET SEND';
  CtTxt_NOC_FO_Enlevement = 'O2S_002_NOC_FO_Enlevement';
  CtTxt_NOC_FO_Vente = 'O2S_000_NOC_FO_Vente';
  CtTxt_NOC_FO_Vente_Ligne = 'O2S_001_NOC_FO_Vente_Ligne';
  CtTxt_PackageLogTable = 'msdb..sysdtspackagelog';

const  // WorkStat types
  // Ident the kind of
  CtCodWorkStatCheckOut       = 1;     // Checkout
  CtCodWorkStatMasterCheckOut = 2;     // Master Checkout
  CtCodWorkStatPC             = 11;    // PC
  CtCodWorkStatMasterPC       = 12;    // Master PC
  CtCodWorkStatServer1        = 21;    // Server 1
  CtCodWorkStatServer2        = 22;    // Server 2

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtInterfaceError   = 'The sales documents are not available any more: ' +
                          'Please contact support.';

//*****************************************************************************
// Interface of TFrmADOChkInterface
//*****************************************************************************

type
  TFrmADOChkInterface = class(TFrmAutoRun)
  private
    { Private declarations }
    InterfaceBlocked : Integer;          //Number of minutes
    InterfaceFailed  : Integer;          //Number of last runs
    DatLastRun       : String;           //Date of last run of PChkInterface
  public
    { Public declarations }
    function AreLastRunsFailed(TxtJobName : string): Boolean;
    function IsInterfaceBlocked(TxtJobName : string): Boolean;
    function IsReplicationStopped(TxtJobName : string): Boolean;
    function KillProcess(ExeFileName: string): Integer;

    procedure AutoStart (Sender : TObject); override;
    procedure Execute; override;
    procedure NetSendMsg (TxtMessage: string);
    procedure SaveLastRun;
  end;

var
  FrmADOChkInterface: TFrmADOChkInterface;

//*****************************************************************************

implementation

uses
  DFpnADOUtilsCA,
  SfDialog,
  DFpnADOApplicParamCA,
  SmUtils,
  DFpnADOCA,
  SmDBUtil_BDE;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FADOChkInterface';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADOChkInterface.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 13:16:16 $';

//*****************************************************************************
// Implementation of TFrmADOChkInterface
//*****************************************************************************

function TFrmADOChkInterface.AreLastRunsFailed(TxtJobName: string): Boolean;
var
  TxtSQL           : String;           //SQL statement
  FlgRunFailed     : Boolean;
begin  // of TFrmADOChkInterface.AreLastRunsFailed
  Result := False;
  TxtSql := 'Select TOP ' + IntToStr(InterfaceFailed) + ' * ' +
              ' from ' + CtTxt_PackageLogTable +
              ' where StartTime >= ' + AnsiQuotedStr (DatLastRun, '''') +
              ' and EndTime IS NOT NULL ' +
              ' and Name = ' + AnsiQuotedStr(TxtJobName, '''') +
              ' order by StartTime desc' ;
  try
    DmdFpnADOUtilsCA.ADOQryInfo.Close;
    DmdFpnADOUtilsCA.QueryInfo(TxtSQL);

    If DmdFpnADOUtilsCA.ADOQryInfo.RecordCount < InterfaceFailed then begin
      Result := True;
    end;
    If not Result then begin
      FlgRunFailed := True;
      while (not DmdFpnADOUtilsCA.ADOQryInfo.Eof) and (FlgRunFailed) do begin
        if DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('errorcode').AsInteger <> 0 then
          FlgRunFailed := True
        else
          FlgRunFailed := False;
        DmdFpnADOUtilsCA.ADOQryInfo.Next;
      end;
      if FlgRunFailed then
        Result := True
      else
        Result := False;
    end;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;
end;   // of TFrmADOChkInterface.AreLastRunsFailed

//=============================================================================

procedure TFrmADOChkInterface.AutoStart(Sender: TObject);
begin  // of TFrmADOChkInterface.AutoStart
  if Application.Terminated then
    Exit;

  inherited;

  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;   // of TFrmADOChkInterface.AutoStart

//=============================================================================

procedure TFrmADOChkInterface.Execute;
var
  FlgFailed        : Boolean;          //True if interface not ok
begin  // of TFrmADOChkInterface.Execute
  try
    try
      InterfaceBlocked := DmdFpnADOApplicParamCA.InfoApplicParam['InterfaceBlocked',
                                                                    'ValParam'];
      InterfaceFailed := DmdFpnADOApplicParamCA.InfoApplicParam['InterfaceFailed',
                                                                    'ValParam'];
      DatLastRun :=  DmdFpnADOApplicParamCA.InfoApplicParam ['LstRunChkInterface',
                                                                    'TxtParam'];
      //CHECK 1: Are the last X runs of the same job failed?
      //  Job NOC_FO_Enlevement
      FlgFailed := AreLastRunsFailed(CtTxt_NOC_FO_Enlevement);
      //  Job NOC_FO_Vente
      if not FlgFailed then
        FlgFailed := AreLastRunsFailed(CtTxt_NOC_FO_Vente);
      //  Job NOC_FO_Vente_Ligne
      if not FlgFailed then
        FlgFailed := AreLastRunsFailed(CtTxt_NOC_FO_Vente_Ligne);
      //CHECK 2: Is the replication blocked for more then X minutes?
      If not FlgFailed then
        FlgFailed := IsInterfaceBlocked(CtTxt_NOC_FO_Enlevement);
      if not FlgFailed then
        FlgFailed := IsInterfaceBlocked(CtTxt_NOC_FO_Vente);
      if not FlgFailed then
        FlgFailed := IsInterfaceBlocked(CtTxt_NOC_FO_Vente_Ligne);
      //CHECK 3: Is the replication  started on noc_fo_vente_ligne and noc_fo_enlevement?
      If not FlgFailed then
        FlgFailed := IsReplicationStopped(CtTxt_NOC_FO_Enlevement);
      if not FlgFailed then
        FlgFailed := IsReplicationStopped(CtTxt_NOC_FO_Vente);
      if not FlgFailed then
        FlgFailed := IsReplicationStopped(CtTxt_NOC_FO_Vente_Ligne);
      if FlgFailed then begin
        NetSendMsg(CtTxtInterfaceError);
        KillProcess('dtsrun.exe');
      end;
    except
      if not ViFlgAutom then
        raise;
    end;
  finally
    SaveLastRun;
  end;
end;   // of TFrmADOChkInterface.Execute

//=============================================================================

function TFrmADOChkInterface.IsInterfaceBlocked(TxtJobName: string): Boolean;
var
  TxtSQL           : String;           //SQL statement
  StartTime        : TDateTime;
  CurrentTime      : TDateTime;
begin  // of TFrmADOChkInterface.IsInterfaceBlocked
  Result := False;
  TxtSql := 'Select TOP 1 DateAdd(mi,' + IntToStr(InterfaceBlocked) +
              ' ,starttime) as StartTimeBlocked, *' +
              ' from ' + CtTxt_PackageLogTable +
              ' where Name = ' + AnsiQuotedStr(TxtJobName, '''') +
              ' order by StartTime desc' ;
  try
    DmdFpnADOUtilsCA.CloseInfo;
    DmdFpnADOUtilsCA.QueryInfo(TxtSQL);
    if not DmdFpnADOUtilsCA.ADOQryInfo.Eof then begin
      StartTime := DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('StartTimeBlocked').AsDateTime;
      CurrentTime := now;
      If (StartTime < CurrentTime)
        and (DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('EndTime').isnull) then
        Result := True;
    end
    else
      Result := True;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;

end;   // of TFrmADOChkInterface.IsInterfaceBlocked

//=============================================================================

function TFrmADOChkInterface.IsReplicationStopped(TxtJobName: string): Boolean;
var
  TxtSQL           : String;           //SQL statement
begin  // of TFrmADOChkInterface.IsReplicationStopped
  Result := False;
  TxtSql := 'Select TOP 1 DateAdd(mi,' + IntToStr(InterfaceBlocked) + ' ,starttime) as StartTime' +
              ' from ' + CtTxt_PackageLogTable + ' (NOLOCK)' +
              ' where Name = ' + AnsiQuotedStr(TxtJobName, '''') +
              ' order by StartTime desc' ;
  try
    DmdFpnADOUtilsCA.CloseInfo;
    DmdFpnADOUtilsCA.QueryInfo(TxtSQL);
    if not DmdFpnADOUtilsCA.ADOQryInfo.Eof then begin
      If DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('StartTime').AsDateTime < now then
        Result := True;
    end
    else
      Result := True;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;
end;   // of TFrmADOChkInterface.IsReplicationStopped

//=============================================================================

procedure TFrmADOChkInterface.NetSendMsg(TxtMessage: string);
var
  TxtCompname      : string;                 // computername to send message to
  TxtRes           : string;                 // for the commandline
  QryWorkStat      : TADOQuery;
begin  // of TFrmADOChkInterface.NetSendMsg
  QryWorkStat := TADOQuery.Create (Application);
  if not Assigned (DmdFpnADOCA) then
    DmdFpnADOCA := TDmdFpnADOCA.Create (Application);

  try
    //QryWorkStat.DatabaseName := DmdFpn.DbsFlexPoint.DatabaseName;
    QryWorkStat.Connection := DmdFpnADOCA.ADOConFlexpoint;
    QryWorkStat.SQL.Clear;
    QryWorkStat.SQL.Text := 'SELECT IdtWorkStat FROM WORKSTAT (NOLOCK)' +
                            ' WHERE CodType = '+IntToStr (CtCodWorkStatPC) +
                            ' OR CodType = ' + IntToStr (CtCodWorkStatServer1) +
                            ' OR CodType = ' + IntToStr (CtCodWorkStatServer2);
    QryWorkStat.ExecSQL;
    QryWorkStat.Open;

    while not QryWorkStat.Eof do begin
      TxtCompname := QryWorkStat.FieldByName ('IdtWorkStat').AsString;
      if TxtCompName <> '' then begin
        TxtRes := CtTxtNetSendCommand + ' ' + TxtCompName + ' ' +
                  TxtMessage + #0;
        WinExec (@TxtRes[1], SW_HIDE);
      end;
      QryWorkStat.Next;
    end;

  finally
    QryWorkStat.Close;
  end;
end;   // of TFrmADOChkInterface.NetSendMsg

//=============================================================================

procedure TFrmADOChkInterface.SaveLastRun;
begin  // of TFrmADOChkInterface.SaveLastRun
  try
    DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text :=
               #10'UPDATE APPLICPARAM ' +
               #10' SET TxtParam = ' + AnsiQuotedStr (FormatDateTime (
                             ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat, Now), '''') +
               #10' WHERE IdtApplicParam = ' + AnsiQuotedStr('LstRunChkInterface', '''');

    DmdFpnADOUtilsCA.ADOQryInfo.ExecSQL;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;
end;   // of TFrmADOChkInterface.SaveLastRun

//=============================================================================

function TFrmADOChkInterface.KillProcess(ExeFileName: string): Integer;
const
  CtTxtProcess_Terminate = $0001;
var
  FlgContinueLoop   : Boolean;         //used to determine if there are more processes
  HdlSnapshotHandle : THandle;         //handle for the system snapshot
  ProEProcessEntry32 : TProcessEntry32; //handle for the processEntry
begin  // of TFrmADOChkInterface.KillProcess
  Result := 0;
  // create a snapshot of all processes runnin on the system
  HdlSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  ProEProcessEntry32.dwSize := SizeOf(ProEProcessEntry32);
  //retrieve information about the first process in the system snapshot
  FlgContinueLoop := Process32First(HdlSnapshotHandle, ProEProcessEntry32);
  // loop all processes in the system
  while FlgContinueLoop do
  begin
    //determine if current found process in the one we want to kill
    if((UpperCase(ExtractFileName(ProEProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(ProEProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      begin
         //attempt to kill the process
         Result := Integer(TerminateProcess(OpenProcess(CtTxtProcess_Terminate,
                         BOOL(0), ProEProcessEntry32.th32ProcessID), 0));
         if Result = 0 then
           Exit;
      end;
    //retrieve information about the next process in the system snapshot
    FlgContinueLoop := Process32Next(HdlSnapshotHandle, ProEProcessEntry32);
  end;  // of while
  CloseHandle(HdlSnapshotHandle);
end;   // of TFrmADOChkInterface.KillProcess

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.
