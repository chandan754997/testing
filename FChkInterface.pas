//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : Castorama Development
// Unit   : FChkInterface.PAS : Form to CHecK if the Interface is running
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChkInterface.pas,v 1.2 2007/03/01 10:19:58 goegebkr Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - FChkInterface - CVS revision 1.1
//=============================================================================

unit FChkInterface;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, DFpn, Db, DBTables;

//=============================================================================
// Const
//=============================================================================

Const
  CtTxtNetSendCommand   = 'NET SEND';
  CtTxt_NOC_FO_Enlevement = 'O2S_002_NOC_FO_Enlevement';
  CtTxt_NOC_FO_Vente = 'O2S_000_NOC_FO_Vente';
  CtTxt_NOC_FO_Vente_Ligne = 'O2S_001_NOC_FO_Vente_Ligne';
  CtTxt_PackageLogTable = 'msdb..sysdtspackagelog';
//=============================================================================
// Resourcestrings
//=============================================================================

Resourcestring
  CtTxtInterfaceError   = 'The sales documents are not available any more: Please contact support.';

//*****************************************************************************
// Interface of TFrmChkReplication
//*****************************************************************************

type
  TFrmChkInterface = class(TFrmAutoRun)
    Query1: TQuery;
    Query2: TQuery;
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

    procedure AutoStart (Sender : TObject); override;
    procedure Execute; override;
    procedure NetSendMsg (TxtMessage: string);
    procedure SaveLastRun;
  end;  // of TFrmChkReplication

var
  FrmChkInterface: TFrmChkInterface;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SmUtils,
  SfDialog,
  DFpnCommon,
  DFpnApplicParam,
  DFpnWorkStatCA,
  DFpnUtils,
  SmDBUtil_BDE;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FChkInterface';

const  // PVCS-keywords
  CtTxtSrcName    = '$';
  CtTxtSrcVersion = '$';
  CtTxtSrcDate    = '$';

//*****************************************************************************
// Implementation of TFrmChkInterface
//*****************************************************************************

function TFrmChkInterface.AreLastRunsFailed(TxtJobName: string): Boolean;
var
  TxtSQL           : String;           //SQL statement
  FlgRunFailed     : Boolean;
begin  // of TFrmChkInterface.AreLastRunsFailed
  Result := False;
  TxtSql := 'Select TOP ' + IntToStr(InterfaceFailed) + ' * ' +
              ' from ' + CtTxt_PackageLogTable +
              ' where StartTime >= ' + AnsiQuotedStr (DatLastRun, '''') +
              ' and EndTime IS NOT NULL ' +
              ' and Name = ' + AnsiQuotedStr(TxtJobName, '''') +
              ' order by StartTime desc' ;
  try
    DmdFpnUtils.QryInfo.Close;
    DmdFpnUtils.QueryInfo(TxtSQL);

    If DmdFpnUtils.QryInfo.RecordCount < InterfaceFailed then begin
      Result := True;
    end;
    If not Result then begin
      FlgRunFailed := True;
      while (not DmdFpnUtils.QryInfo.Eof) and (FlgRunFailed) do begin
        if DmdFpnUtils.QryInfo.FieldByName('errorcode').AsInteger <> 0 then
          FlgRunFailed := True
        else
          FlgRunFailed := False;
        DmdFpnUtils.QryInfo.Next;
      end;
      if FlgRunFailed then
        Result := True
      else
        Result := False;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmChkInterface.AreLastRunsFailed

//=============================================================================

procedure TFrmChkInterface.AutoStart(Sender: TObject);
begin  // of TFrmChkInterface.AutoStart
  if Application.Terminated then
    Exit;

  inherited;

  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;   // of TFrmChkInterface.AutoStart

//=============================================================================

procedure TFrmChkInterface.Execute;
var
  FlgFailed        : Boolean;          //True if interface not ok
begin  // of TFrmChkInterface.Execute
  try
    try
      FlgFailed := False;

      InterfaceBlocked := DmdFpnApplicParam.InfoApplicParam['InterfaceBlocked',
                                                                    'ValParam'];
      InterfaceFailed := DmdFpnApplicParam.InfoApplicParam['InterfaceFailed',
                                                                    'ValParam'];
      DatLastRun :=  DmdFpnApplicParam.InfoApplicParam ['LstRunChkInterface','TxtParam'];
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


      if FlgFailed then
        NetSendMsg(CtTxtInterfaceError);
    except
      if not ViFlgAutom then
        Raise;
    end;
  finally
    SaveLastRun;
  end;

end;   // of TFrmChkInterface.Execute

//=============================================================================

function TFrmChkInterface.IsInterfaceBlocked(TxtJobName: string): Boolean;
var
  TxtSQL           : String;           //SQL statement
  StartTime        : TDateTime;
  CurrentTime      : TDateTime;
begin  // of TFrmChkInterface.IsInterfaceBlocked
  Result := False;
  TxtSql := 'Select TOP 1 DateAdd(mi,' + IntToStr(InterfaceBlocked) +
              ' ,starttime) as StartTimeBlocked, *' +
              ' from ' + CtTxt_PackageLogTable +
              ' where Name = ' + AnsiQuotedStr(TxtJobName, '''') +
              ' order by StartTime desc' ;
  try
    DmdFpnUtils.CloseInfo;
    DmdFpnUtils.QueryInfo(TxtSQL);
    if not DmdFpnUtils.QryInfo.Eof then begin
      StartTime := DmdFpnUtils.QryInfo.FieldByName('StartTimeBlocked').AsDateTime;
      CurrentTime := now;
      If (StartTime < CurrentTime)
        and (DmdFpnUtils.QryInfo.FieldByName('EndTime').isnull) then
        Result := True;
    end
    else
      Result := True;
  finally
    DmdFpnUtils.CloseInfo;
  end;

end;   // of TFrmChkInterface.IsInterfaceBlocked

//=============================================================================

function TFrmChkInterface.IsReplicationStopped(TxtJobName: string): Boolean;
var
  TxtSQL           : String;           //SQL statement
begin  // of TFrmChkInterface.IsReplicationStopped
  Result := False;
  TxtSql := 'Select TOP 1 DateAdd(mi,' + IntToStr(InterfaceBlocked) + ' ,starttime) as StartTime' +
              ' from ' + CtTxt_PackageLogTable +
              ' where Name = ' + AnsiQuotedStr(TxtJobName, '''') +
              ' order by StartTime desc' ;
  try
    DmdFpnUtils.CloseInfo;
    DmdFpnUtils.QueryInfo(TxtSQL);
    if not DmdFpnUtils.QryInfo.Eof then begin
      If DmdFpnUtils.QryInfo.FieldByName('StartTime').AsDateTime < now then
        Result := True;
    end
    else
      Result := True;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmChkInterface.IsReplicationStopped

//=============================================================================

procedure TFrmChkInterface.NetSendMsg(TxtMessage: string);
var
  TxtCompname      : string;                 // computername to send message to
  TxtRes           : string;                 // for the commandline
  QryWorkStat      : TQuery;
begin  // of TFrmChkInterface.NetSendMsg
  QryWorkStat := TQuery.Create (Application);
  if not Assigned (DmdFpn) then
    DmdFpn := TDmdFpn.Create (Application);

  try
    QryWorkStat.DatabaseName := DmdFpn.DbsFlexPoint.DatabaseName;
    QryWorkStat.SQL.Clear;
    QryWorkStat.SQL.Text := 'SELECT IdtWorkStat FROM WORKSTAT (NOLOCK)' +
                            ' WHERE CodType = '+IntToStr (CtCodWorkStatPC);
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
end;   // of TFrmChkInterface.NetSendMsg

//=============================================================================

procedure TFrmChkInterface.SaveLastRun;
begin  // of TFrmChkInterface.SaveLastRun
  try
    DmdFpnUtils.QryInfo.SQL.Text :=
               #10'UPDATE APPLICPARAM ' +
               #10' SET TxtParam = ' + AnsiQuotedStr (FormatDateTime (
                             ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat, Now), '''') +
               #10' WHERE IdtApplicParam = ' + AnsiQuotedStr('LstRunChkInterface', '''');

    DmdFpnUtils.QryInfo.ExecSQL;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmChkInterface.SaveLastRun

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FChkInterface
