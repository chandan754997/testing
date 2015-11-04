//================= Real Software - Retail Division (c) 2006 ==================
// Packet : Castorama Development
// Unit   : FArchiveDB : Form Archive Electronic Journal
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/fArchiveDB.pas,v 1.1 2007/01/12 15:04:02 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FArchiveDB - CVS revision 1.3
//=============================================================================

unit fArchiveDB;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, Db, DBTables;

//*****************************************************************************
// Resource strings
//*****************************************************************************

resourcestring
  CtTxtErrDayInFuture = 'Archive date may not be in the future.';
  CtTxtArchiveNotPossible = 'Archiving is not possible because electronic journals have been deleted for selected date.';
  CtTxtArchiveOverwritten = 'The created archive will be overwritten by the automatic archiving in time.';
  CtTxtErrDTSFileNotExists = 'The DTS-package has not been found.';
  CtTxtErrFailedArchive = 'Failed to archive DB.';
  CtTxtArchivedSuccess = 'Archived DB succesfully.';
//*****************************************************************************
// Constants
//*****************************************************************************

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmArchiveDB = class(TFrmAutoRun)
    DTPickerArchiveDate: TDateTimePicker;
    LblArchiveDate: TLabel;
    qryJobStatus: TQuery;
    SprJobStatus: TStoredProc;
    SprManArchive: TStoredProc;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute; override;
    procedure InitOnStartExec (TxtReason : string); override;
    function GetServerName: string;
  end;

var
  FrmArchiveDB: TFrmArchiveDB;

//*****************************************************************************

implementation

{$R *.DFM}

{ TFrmArchiveDB }

Uses
  ShellAPI,
  SfDialog,
  SmDBUtil_BDE,
  SmUtils,
  DFpnUtils,
  inifiles,
  DFpnApplicParam;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FArchiveDB';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/fArchiveDB.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2007/01/12 15:04:02 $';

//=============================================================================

procedure TFrmArchiveDB.Execute;
var
  TxtDate          : string;
  LastArchivedDate : TDateTime;
  LastDeletedDate  : TDateTime;
  DatManArchive    : TDateTime;
  ErrorCode        : string;
  TxtSql           : string;
  TimeJobStarted   : TDateTime;
  strJobID         : string;
begin  // of TFrmArchiveDB.Execute
  //Check on archive date
  //Archive date may not be in the future
  if DTPickerArchiveDate.Date > now then begin
    ShowMessage (CtTxtErrDayInFuture);
    Exit;
  end;
  //Archive date <= LastDeletedDate
  txtSql := 'SELECT TxtParam FROM ApplicParam ' +
            #10'WHERE IdtApplicParam = ' + AnsiQuotedStr('LastDeletedDate', '''');
  try
    if DmdFpnUtils.QueryInfo(TxtSql) then begin
      TxtDate := DmdFpnUtils.QryInfo.FieldByName('TxtParam').AsString;
      if (TxtDate <> '') and (TxtDate <> 'NULL') then begin
        LastDeletedDate := StrToDateTime(TxtDate, 'YYYY-MM-DD', '');
        TxtDate := FormatDateTime('DD' + DateSeparator + 'MM' + DateSeparator + 'YYYY', DTPickerArchiveDate.Date);
        DatManArchive := StrToDate(TxtDate);
        if DatManArchive <= LastDeletedDate then begin
          ShowMessage(CtTxtArchiveNotPossible);
          Exit;
        end;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
  //Archive date > LastArchivedDate
  txtSql := 'SELECT TxtParam FROM ApplicParam ' +
            #10'WHERE IdtApplicParam = ' + AnsiQuotedStr('LastArchivedDate', '''');
  try
    if DmdFpnUtils.QueryInfo(TxtSql) then begin
      TxtDate := DmdFpnUtils.QryInfo.FieldByName('TxtParam').AsString;
      if (TxtDate <> '') and (TxtDate <> 'NULL') then begin
        LastArchivedDate := StrToDateTime(TxtDate, 'yyyy-mm-dd', '00:00:00');
        if DTPickerArchiveDate.Date > LastArchivedDate then begin
          ShowMessage(CtTxtArchiveOverwritten);
        end;
      end
      else begin
        ShowMessage(CtTxtArchiveOverwritten);
      end;
    end
    else begin
      ShowMessage(CtTxtArchiveOverwritten);
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
  {TxtPathDTS := ReplaceEnvVar ('%SycRoot%\Replica\DTS\Archive_POSTrans.dts');}
  TxtDate := FormatDateTime('YYYY-MM-DD', DTPickerArchiveDate.Date);

  //insert or update 'DatManArchive' in applicparam
  TxtSql := 'if EXISTS( Select * from applicparam' +
                    #10'where idtapplicparam = ''DatManArchive''' +  ')' +
            #10'UPDATE applicparam ' +
            #10'set TxtParam = ' + AnsiQuotedStr(TxtDate, '''') +
            #10'where IdtApplicParam = ' + AnsiQuotedStr('DatManArchive', '''') +
         #10'ELSE ' +
            #10'INSERT INTO APPLICPARAM (IdtApplicParam, TxtParam)' +
            #10'VALUES (''DatManArchive'', ' + AnsiQuotedStr(TxtDate, '''')+ ')';

  DmdFpnUtils.QryInfo.SQL.Text := TxtSql;
  try
    DmdFpnUtils.ExecQryInfo;
  finally
    DmdFpnUtils.CloseInfo;
  end;

  // Attempts to create the process
  TimeJobStarted := now;

  //Start manual archiving

  SprManArchive.ParamByName ('@Job_Name').AsString := 'Manual back-up electronic journal';
  SprManArchive.ExecProc;

    //check if package stopped
  try
    if dmdfpnutils.QueryInfo('SELECT CONVERT(VARCHAR(1000),job_id) as JobID ' +
                             ' FROM msdb..sysjobs ' +
                             'WHERE name = ' +
                             AnsiQuotedStr('Manual back-up electronic journal', '''')) then begin
      strJobID := DmdFpnUtils.qryInfo.FieldByName('JobID').AsString;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;

  Sleep (10000);
  SprJobStatus.ParamByName ('@Job_ID').AsString := strJobID;
  SprJobStatus.Open;
  while SprJobStatus.FieldByName('Current_Execution_Status').AsInteger <> 4 do begin
    Sleep(5000);
    SprJobStatus.Close;
    SprJobStatus.Open;
  end;
  SprJobStatus.Close;
  //Check msdb..sysdtspackagelog for errors
  try
    if DmdFpnUtils.QueryInfo('select top 1 * from msdb..sysdtspackagelog ' +
                          ' where name = ' + AnsiQuotedStr('Archive_POSTrans', '''') +
                          ' and endtime is not null ' +
                          ' and endtime > '  +
                              AnsiQuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', TimeJobStarted), '''') +
                          ' order by endtime desc') then begin

      ErrorCode := DmdFpnUtils.QryInfo.FieldByName('ErrorCode').AsString;
      //ErrorDescr := DmdFpnUtils.QryInfo.FieldByName('ErrorDescription').AsString;
      if ErrorCode <> '0' then begin
        ShowMessage(CtTxtErrFailedArchive);
      end
      else begin
        ShowMessage(CtTxtArchivedSuccess);
      end;
    end
    else begin
      ShowMessage(CtTxtErrFailedArchive);
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;

  //delete 'DatManArchive' in applicparam
  TxtSql := 'DELETE FROM applicparam ' +
            #10'where IdtApplicParam = ' + AnsiQuotedStr('DatManArchive', '''');
  DmdFpnUtils.QryInfo.SQL.Text := TxtSql;
  try
    DmdFpnUtils.ExecQryInfo;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmArchiveDB.Execute

//=============================================================================

procedure TFrmArchiveDB.FormActivate(Sender: TObject);
begin  // of TFrmArchiveDB.FormActivate
  inherited;
  DTPickerArchiveDate.DateTime := now;
  StsBarExec.Panels[1].Text := '';
end;   // of TFrmArchiveDB.FormActivate

//=============================================================================

function TFrmArchiveDB.GetServerName: string;
var
  IniFilSystem     : TIniFile;
  TxtFNIni         : string;
  ServerName       : string;
begin  //of TFrmArchiveDB.GetServerName
  TxtFNIni := ReplaceEnvVar ('%SycRoot%\FlexPos\Ini\FpsSyst.INI');
  IniFilSystem := nil;
  OpenIniFile (TxtFNIni, IniFilSystem);
  try
    ServerName := IniFilSystem.ReadString('Ping', 'Host', '');
  finally
    IniFilSystem.Free;
  end;
  Result := ServerName;
end;   // of TFrmArchiveDB.GetServerName

//=============================================================================

procedure TFrmArchiveDB.InitOnStartExec(TxtReason: string);
begin
  inherited;
  StsBarExec.Panels[1].Text := '';
end;

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.   // of TFrmArchiveDB
