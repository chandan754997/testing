//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Development Flexpoint 2.0 CAstorama
// Unit   : FRemFiscPrinter.PAS : Form REMote FISCal PRINTER
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRemFiscPrinter.pas,v 1.3 2009/09/29 11:35:31 BEL\KDeconyn Exp $
// History:
//  - Started from Castorama - Flexpoint 2.0 - fRemFiscPrinter - CVS rev 1.4
//=============================================================================

unit FRemFiscPrinter;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, DBTables;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring               // Run parameter
  CtTxtRunPrmCD              = '/Ff : CD = Close day';
  CtTxtRunPrmC               = '/VCx = cashdesk number';

resourcestring               // Messages
  CtTxtRemExecFailed         = 'Remote execution failed on %s';

const  // Run function parameters
  CtCodFuncCloseDay          = 1;

const  // Possible CodState
  CtCodPtsFiscPrinterOK      =  20; // Remote execution of PFiscPrinter OK
  CtCodPtsFiscPrinterNOK     =  21; // Remote execution of PFiscPrinter NOK

const  // Filenamen FiscPrinter
  CIIniFile      : string = '%SycRoot%\Flexpos\ini\PFpsmenu.ini';
  CICheckFile    : string = '\Data\Pos\';
  CIFiscPrinterFileToCheck : string = '';
  CITimeOut      : integer = 300; // Time out to wait on execution of PFiscPrinter on cashdesk

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmRemFiscPrinter = class(TFrmAutoRun)
  private
    { Private declarations }
    StrCashDesks: TStringList;
  protected
    { Protected declarations }
    CodRunFunc          : Integer;          // Functionality to execute
    SprRTLstWorkStat    : TStoredProc;      // Stored procedure to open item
    TxtOneCashdesk      : string;           // Name Cashdesk in commandline
    // Methods
    procedure DefineStandardRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure AfterCheckRunParams; override;
    procedure ExecOneCashDesk; virtual;
    procedure ExecAllCashDesks; virtual;
    procedure ExecRemFiscPrinter (TxtCashDeskName : string);
    procedure WritePosState (IdtPosState : integer;
                             TxtCashDeskName : string); virtual;
    procedure NetSendFailure (TxtCashDeskName : string); virtual;
  public
    { Public declarations }
    procedure Execute; override;
  published
    procedure AutoStart (Sender : TObject); override;
  end;

var
  FrmRemFiscPrinter: TFrmRemFiscPrinter;

//*****************************************************************************  

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  IniFiles,
  DFpn,
  DFpnUtils,
  DFpnWorkStatCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FRemFiscPrinter';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRemFiscPrinter.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/09/29 11:35:31 $';

//*****************************************************************************
// Implementation of TFrmRemFiscPrinter
//*****************************************************************************

procedure TFrmRemFiscPrinter.DefineStandardRunParams;
begin  // of TFrmRemFiscPrinter.DefineStandardRunParams
  inherited;
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'F' + 'V';
  ViTxtRunPmReq := ViTxtRunPmReq + 'F';
  AddRunParams ('/FCD', CtTxtRunPrmCD);
  AddRunParams ('/VC', CtTxtRunPrmC);
end;   // of TFrmRemFiscPrinter.DefineStandardRunParams

//=============================================================================

procedure TFrmRemFiscPrinter.CheckAppDependParams (TxtParam : string);
begin // of TFrmRemFiscPrinter.CheckAppDependParams
  inherited;
  TxtOneCashdesk := '';
  if TxtParam[2] = 'V' then begin
    if TxtParam[3] = 'C' then
      TxtOneCashdesk := Copy (TxtParam, 4, Length (TxtParam));
  end;
end;  // of TFrmRemFiscPrinter.CheckAppDependParams

//=============================================================================

procedure TFrmRemFiscPrinter.AfterCheckRunParams;
begin // of TFrmRemFiscPrinter.AfterCheckRunParams
  inherited;
  if CompareText (ViTxtFunction, 'CD') = 0 then
    CodRunFunc := CtCodFuncCloseDay
  else
    MissingRunParam ('/F');
end;  // of TFrmRemFiscPrinter.AfterCheckRunParams

//=============================================================================

procedure TFrmRemFiscPrinter.AutoStart (Sender : TObject);
begin  // of TFrmRemFiscPrinter.AutoStart
  if Application.Terminated then
    Exit;
  inherited;
  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;   // of TFrmRemFiscPrinter.AutoStart

//=============================================================================

procedure TFrmRemFiscPrinter.Execute;
var
  IniFile          : TIniFile;
begin  // of Execute
  if CodRunFunc = CtCodFuncCloseDay then begin
    IniFile := nil;
    try
      CIIniFile := ReplaceEnvVar(CIIniFile);
      OpenIniFile (CIIniFile, IniFile);
      CIFiscPrinterFileToCheck := IniFile.ReadString ('FiscPrinter', 'FileToCheck', '');
      CIFiscPrinterFileToCheck := Copy(CIFiscPrinterFileToCheck, AnsiPos('\',
                                   CIFiscPrinterFileToCheck), Length(
                                   CIFiscPrinterFileToCheck) - AnsiPos('\',
                                   CIFiscPrinterFileToCheck) + 1);
      CITimeOut := StrToInt(IniFile.ReadString ('FiscPrinter', 'TimeOut', ''));
    finally
      if Assigned (IniFile) then
        IniFile.Free;
    end;
    if TxtOneCashdesk <> '' then
      ExecOneCashDesk
    else
      ExecAllCashDesks;
  end;
end;   // of Execute

//=============================================================================

procedure TFrmRemFiscPrinter.ExecOneCashDesk;
var
  TxtErrMsg        : string;           // Error message
  NumCounter       : integer;          // Delay
begin  // of ExecOneCashDesk
  try
    PgsBarExec.Max := 2;
    ExecRemFiscPrinter(TxtOneCashdesk);
    ProgressBarPosition := ProgressBarPosition + 1;
    NumCounter := 1;
    while FileExists('\\' + TxtOneCashDesk + CIFiscPrinterFileToCheck)
    or (NumCounter < CITimeOut) do begin
      Sleep(1000);
      NumCounter := NumCounter + 1;
    end;
    ProgressBarPosition := ProgressBarPosition + 1;
    if FileExists('\\' + TxtOneCashDesk + CIFiscPrinterFileToCheck) then begin
      DeleteFile('\\' + TxtOneCashDesk + CIFiscPrinterFileToCheck);
      Raise Exception.Create('File still exists');
    end;
  except
    on E: Exception do begin
      TxtErrMsg := 'Error on workstation ' + TxtOneCashdesk + ' : ' + #10'  ' +
                   E.Message;
      SvcExceptHandler.LogMessage (CtChrLogError,
        SvcExceptHandler.BuildLogMessage (CtNumErrorMax, [TxtErrMsg]));
      if not ViFlgAutom then
        MessageDlg (TxtErrMsg, mtError, [mbOk], 0)
      else
        NetSendFailure(TxtOneCashdesk);
    end;
  end;
end;   // of ExecOneCashDesk

//=============================================================================

procedure TFrmRemFiscPrinter.ExecAllCashDesks;
var
  TxtErrMsg        : string;           // Error message
  TxtCashDeskName  : string;           // ComputerName
  NumCounter       : integer;          // delay
  NumCounter2      : integer;          // counter to loop StrCashDesks
begin  // of ExecAllCashDesks
  StrCashDesks := TStringList.Create;
  if not Assigned (SprRTLstWorkStat) then
    SprRTLstWorkStat := CopyStoredProc
                          (Self, 'SprRTLstWorkStat', DmdFpnUtils.SprLstFullJoin,
                           ['@PrmTxtTable=WorkStat',
                            '@PrmTxtArrFields=IdtWorkStat;CodType',
                            '@PrmTxtSequence=CodType;IdtWorkStat',
                            '@PrmTxtFrom=1',
                            '@PrmTxtTo=10']);
  ProgressBarPosition := 0;
  SprRTLstWorkStat.Active := True;
  PgsBarExec.Max := SprRTLstWorkStat.RecordCount*2;
  try
    while not SprRTLstWorkStat.Eof do begin
      try
        TxtCashDeskName := SprRTLstWorkStat.FieldByName ('IdtWorkstat').AsString;
        if SprRTLstWorkStat.FieldByName ('CodType').AsInteger in
        [CtCodWorkStatCheckOut, CtCodWorkStatMasterCheckOut] then begin
          ExecRemFiscPrinter(TxtCashDeskName);
          ProgressBarPosition := ProgressBarPosition + 1;
        end;
      except
        on E: Exception do begin
          TxtErrMsg := 'Error on workstation ' +
                       SprRTLstWorkStat.FieldByName ('IdtWorkStat').AsString +
                       ' : ' + #10'  ' + E.Message;
          SvcExceptHandler.LogMessage (CtChrLogError,
            SvcExceptHandler.BuildLogMessage (CtNumErrorMax, [TxtErrMsg]));
          if not ViFlgAutom then
            MessageDlg (TxtErrMsg, mtError, [mbOk], 0)
          else
            NetSendFailure(TxtCashDeskName);
          WritePosState(CtCodPtsFiscPrinterNOK, TxtCashDeskName);
        end;
      end;
      SprRTLstWorkStat.Next;
    end;
  finally
    SprRTLstWorkStat.Active := False;
  end;
  NumCounter := 1;
  while (StrCashDesks.Count > 0) and (NumCounter < CITimeOut) do begin
    NumCounter2 := 0;
    while NumCounter2 < StrCashDesks.Count do begin
      if not FileExists(StrCashDesks[NumCounter2]) then begin
        StrCashDesks.Delete(NumCounter2);
        ProgressBarPosition := ProgressBarPosition + 1;
      end;
      NumCounter2 := NumCounter2 + 1;
    end;
    Sleep(1000);
    NumCounter := NumCounter + 1;
  end;
  if FileExists('\\' + TxtCashDeskName + CIFiscPrinterFileToCheck) then begin
    DeleteFile('\\' + TxtCashDeskName + CIFiscPrinterFileToCheck);
    Raise Exception.Create('File still exists');
  end;
  StrCashDesks.Free;
end;   // of ExecAllCashDesks

//=============================================================================

procedure TFrmRemFiscPrinter.ExecRemFiscPrinter(TxtCashDeskName : string);
var
  F                : TextFile;         // Textfile to write to a the cashdesk
begin  // of ExecRemFiscPrinter
  try
    AssignFile(F, '\\' + TxtCashDeskName + '\Sycpos' + CIFiscPrinterFileToCheck);
    Rewrite(F);
    CloseFile(F);
    StrCashDesks.Add('\\' + TxtCashDeskName + '\Sycpos' + CIFiscPrinterFileToCheck);
  finally
  end;
end;   // of ExecRemFiscPrinter

//=============================================================================

procedure TFrmRemFiscPrinter.WritePosState (IdtPosState : integer;
                                            TxtCashDeskName : string);
var
  IdtCheckOut      : Integer;          // N° of the cashdesk
begin  // of WritePosState
  IdtCheckOut := 0;
  try
    if DmdFpnUtils.QueryInfo ('SELECT IdtCheckOut FROM WORKSTAT (NOLOCK)' +
    #13'WHERE IdtWorkStat = ' + AnsiQuotedStr(TxtCashDeskName,'''')) then
      IdtCheckOut := DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsInteger;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
  try
    DmdFpnUtils.QryInfo.SQL.Add('INSERT INTO POSState');
    DmdFpnUtils.QryInfo.SQL.Add('(DatModState, CodState, CodTrans, ' +
                                'IdtOperator, IdtCheckOut)');
    DmdFpnUtils.QryInfo.SQL.Add('VALUES (' + AnsiQuotedStr(FormatDateTime(
                                'yyyymmdd hh:mm:ss', Now),'''') + ', ' +
                                IntToStr(IdtPosState) + ', 0, 0, ' +
                                IntToStr(IdtCheckOut) + ')');
    DmdFpnUtils.QryInfo.ExecSQL;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of WritePosState

//=============================================================================

procedure TFrmRemFiscPrinter.NetSendFailure(TxtCashDeskName : string);
var
  TxtCompName      : string;           // ComputerName
  TxtCommand       : string;           // Command to execute
begin  // of NetSendFailure
  try
    if DmdFpnUtils.QueryInfo ('SELECT IdtWorkStat FROM WORKSTAT (NOLOCK)' +
    #13'WHERE CodType >= '+IntToStr (CtCodWorkStatPC) +
    #13'AND CodType < ' + IntToStr (CtCodWorkStatServer1)) then begin
      DmdFpnUtils.QryInfo.First;
      while not DmdFpnUtils.QryInfo.Eof do
      begin
        TxtCompName := DmdFpnUtils.QryInfo.FieldByName ('IdtWorkstat').AsString;
        if trim (TxtCompName) <> '' then begin
          TxtCommand := 'NET SEND ' + TxtCompName + ' ' +
                        Format(CtTxtRemExecFailed, [TxtCashDeskName])+ #0;
          WinExec (@TxtCommand[1], SW_HIDE);
        end;
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of NetSendFailure

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FRemFiscPrinter
