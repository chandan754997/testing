//============== Copyright 2010 (c) TCS -  All rights reserved. ==============
// Packet : Castorama Development
// Unit   : FChkRunClosure : Form to Check if the no. of clients in queue is greater than threshold value
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChkQueue.pas,v 1.2 2010/01/28 13:39:44 smete Exp $
//=============================================================================
// Version         Modified By      Reason
// V 1.1           SM    (TCS)      R2012.1-CAFR - Client En Attente
// V 1.2           SM    (TCS)      R2012.1-System Test 4 Fix (R2012.1 Client En Attente)
// V 1.3           SM    (TCS)      R2012.1-Defect 135 Fix
// V 1.4           SRM   (TCS)      R2012.1  PILOT PROBLEM - CAFR(Generic)
// V 1.5           SM    (TCS)      Database Enginer Error Fix
// V 1.6           SRM   (TCS)      R2013.2-Req(35050).Customer_Queue_Alert(BDFR)

unit FChkQueue;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, DB, DBTables,IniFiles, SfAutoRun,SmFile, ADODB;  //Database Engine Error Fix

resourcestring

CtTxtAlert = 'Value exceeded threshold amount';


//=============================================================================
// Global definitions
//=============================================================================
const
  CrLf             = #13#10;
  CtTxtDataFile  = 'cmd /c D:\sycron\bat\psexecqueue.bat';
  CtLogError     : string  = '/VLOG=Enable log';                                // PILOT PROBLEM - CAFR (Generic).TCS-SRM
  CtBDFR         : string  = '/VBDFR=Parameterization for BDFR OPCO';	        // R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM

var  // Exit codes
  ViNumIgnoreDayClose  : Integer = 100102;
  ViNumIgnoreYearClose : Integer = 100103;
  ViNumIgnoreDYClose   : Integer = 100104;
  CtTxtIniPath         : String  = '\FlexPos\Ini\FpsSyst.INI';
  FlgBDFR              : Boolean = False;				      // R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM
  FlgLogErrEnable      : Boolean;					      // PILOT PROBLEM - CAFR (Generic).TCS-SRM

var  // Year close date
  ViTxtYearClose       : string  = '3112'; //Day & Month

resourcestring // Run params
  CtTxtRunParamDateTime = '/D=Date of excecution';

//*****************************************************************************
// Interface of TFrmChkQueue
//*****************************************************************************

type
  TFrmChkQueue = class(TFrmAutoRun)
    QryResult: TQuery;
    SprCheck: TStoredProc;
    QryText: TQuery;
    ADOQryText: TADOQuery;                                                      //Database Engine Error Fix
    ADOSPrCheck: TADOStoredProc;                                                //Database Engine Error Fix
    procedure FormCreate(Sender: TObject);
    procedure ActStartExecExecute(Sender: TObject);
  protected
    TxtDatRun      : string;           // Run date
  public
    procedure AutoStart (Sender : TObject); override;
    procedure SendTxtMessageDediPC;
    function GetResult : string;virtual;
    function GetPrgRoot (TxtFN : string) : string;
    function IsFlexPointOpen : boolean;
//----------------------------------------------------------------------------- // PILOT PROBLEM - CAFR (Generic).TCS-SRM.start

     procedure LogError ( S : string;
                          E : LongInt);

//-----------------------------------------------------------------------------

     procedure LogMessage (ChrMessage : Char;
                           TxtMessage : string;
                           NumError   : Integer);
//-----------------------------------------------------------------------------

     procedure FileSetCreationDate (TxtFNFile : string;
                               DtmToSet  : TDateTime);
//-----------------------------------------------------------------------------

    function BuildLogIdtProcess : string;

//-----------------------------------------------------------------------------

    function  FileGetCreationDate (TxtFNFile : string): TDateTime;

//----------------------------------------------------------------------------- // PILOT PROBLEM - CAFR (Generic).end
//R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.Start
    procedure BeforeCheckRunParams; override;

//-----------------------------------------------------------------------------

    procedure CheckAppDependParams (TxtParam : string); override;

//-----------------------------------------------------------------------------
//R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.End
  end;

var
  FrmChkQueue: TFrmChkQueue;
  CIFNErr          : string = 'D:\sycron\Logging\PChkQueue.LOG';                // PILOT PROBLEM - CAFR (Generic).TCS-SRM:start
  MyName           : String;
  MySession        : String;                                                    // PILOT PROBLEM - CAFR (Generic).TCS-SRM.end

//*****************************************************************************

implementation

uses
  SfDialog,
  SmDBUtil,
  SmUtils,
  StDate,
  StDateSt,
  DfpnUtils,                                                                    //Database Engine Error Fix
  DFpnADOCA;                                                                    //Database Engine Error Fix

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FChkQueue';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FChkQueue.pas  $';
  CtTxtSrcVersion = '$Revision: 1.6 $';
  CtTxtSrcDate    = '$Date: 2013/10/15 13:39:44 $';

//*****************************************************************************
// Implementation of TFrmChkQueue
//*****************************************************************************

function TFrmChkQueue.GetPrgRoot (TxtFN : string) : string;
var
  TxtS             : string;
begin  // of GetPrgRoot
  LogError ('TFrmChkQueue.GetPrgRoot (TxtFN : string) : string : Begin 0 '+ DateTimeToStr(Now), 0);
  TxtS := ReplaceEnvVar ('%PrgROOT%');
  if TxtS <> '' then
    Result := TxtS + TxtFN
  else
    Result := AddStartDirToFN (TxtFN);
  LogError ('TFrmChkQueue.GetPrgRoot (TxtFN : string) : string : End 1 '+ DateTimeToStr(Now), 0);
end;   // of GetPrgRoot
//=============================================================================

function TFrmChkQueue.GetResult:string;
var
  s                : integer;
  s1               : integer;                                                   //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM
  TxtFNIni         : string;           // Filename ini-file
  IniCfg           : TIniFile;         // Ini-object to read configuration
  TxtPath          : string;           // Application path
  ViTxtPingHost    : integer;
begin
  LogError ('TFrmChkQueue.GetResult : Begin 0 '+ DateTimeToStr(Now), 0);
  s  := 0;                                                                      //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.Start
  s1 := 0;                                                                      //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.End
  TxtPath := GetPrgRoot(CtTxtIniPath);
  TxtFNIni := ReplaceEnvVar (TxtPath);
  IniCfg := nil;
  IniCfg:=TIniFile.Create(TxtFNIni);
  OpenIniFile (TxtFNIni, IniCfg);
  LogError ('TFrmChkQueue.GetResult : 1 '+ DateTimeToStr(Now), 0);
  try
    LogError ('TFrmChkQueue.GetResult : 2 '+ DateTimeToStr(Now), 0);
    ADOSprCheck.Active := False;      											                    // PILOT PROBLEM - CAFR (Generic).TCS)SRM
    if FlgBDFR then begin                                                       //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.Start
      ADOSprCheck.Parameters.ParamByName('@FlgBDFR').Value := 'true';
    end
    else
      ADOSprCheck.Parameters.ParamByName('@FlgBDFR').Value := 'false';          //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.End
    ViTxtPingHost:=strtoint(IniCfg.ReadString('AskQManagement', 'NumClientAsk', '0'));
    LogError ('TFrmChkQueue.GetResult : 3 '+ DateTimeToStr(Now), 0);
    ADOSprCheck.Active := True;                                                 // Database Engine Error Fix
    LogError ('TFrmChkQueue.GetResult : 4 '+ DateTimeToStr(Now), 0);
    while not ADOSprCheck.eof do begin                                          // Database Engine Error Fix
      LogError ('TFrmChkQueue.GetResult : 5 '+ DateTimeToStr(Now), 0);
      if FlgBDFR then                                                           //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.Start
        s1:= ADOSprCheck.FieldByName('Res1').AsInteger                          
      else                                                                      //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.End
        s:= ADOSprCheck.FieldByName('Res').AsInteger;                           // Database Engine Error Fix
      LogError ('TFrmChkQueue.GetResult : 6 '+ DateTimeToStr(Now), 0);
	  //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.Start
      if FlgBDFR then
        LogError ('FlgBDFR is true' + DateTimeToStr(Now), 0)
      else
        LogError ('FlgBDFR is false' + DateTimeToStr(Now), 0);
	  //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.End
      if (s1 > ViTxtPingHost) and FlgBDFR then begin								            //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.Start
        LogError ('TFrmChkQueue.GetResult : s1 > ViTxtPingHost' + DateTimeToStr(Now), 0);
        SendTxtMessageDediPC;
        LogError ('TFrmChkQueue.GetResult : after SendTxtMessageDediPC' + DateTimeToStr(Now), 0);
      end
      else if s>ViTxtPingHost then begin										                    //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM.End
        LogError ('TFrmChkQueue.GetResult : s > ViTxtPingHost'+DateTimeToStr(Now), 0);
        SendTxtMessageDediPC;
        LogError ('TFrmChkQueue.GetResult : 7 '+ DateTimeToStr(Now), 0);
      end;
      ADOSprCheck.Next;                                                         // Database Engine Error Fix
    end;
  except                                                                        // PILOT PROBLEM - CAFR (Generic).TCS-SRM.start
    on E:Exception do begin
      LogError ('TFrmChkQueue.GetResult : Exception ,' + E.Message, 0);
    end
  end;
  LogError ('TFrmChkQueue.GetResult : End 8 '+ DateTimeToStr(Now), 0);
end;
//=============================================================================
// Commented for System Fix 4 (R2012.1 Client En Attente) ::START
{procedure TFrmChkQueue.SendTxtMessage;
var
  TxtCompName      : string;           // ComputerName
  TxtCommand       : string;           // Command to execute
  TxtLMessage      : string;           // Local message
begin  // of TFrmChkQueue.SendTxtMessage
  TxtLMessage := CtTxtAlert;
  try
    QryResult.Open;
    while not QryResult.Eof do
    begin
      TxtCompName := QryResult.FieldByName ('IdtWorkstat').AsString;
      if trim (TxtCompName) <> '' then begin
        showmessage(TxtCompName);
        TxtCommand := 'NET SEND ' + TxtCompName + ' ' + TxtLMessage + #0;
        WinExec (@TxtCommand[1], SW_HIDE);
      end;
      QryResult.Next;
    end;
  finally
    QryResult.Close;
  end;
end;  // of TFrmChkQueue.SendTxtMessage }

// Commented for System Fix 4 (R2012.1 Client En Attente) ::END
//=============================================================================

procedure TFrmChkQueue.SendTxtMessageDediPC;
var
  TxtCompName      : string;           // ComputerName
  TxtCommand       : string;           // Command to execute
  TxtLMessage      : string;           // Local message
  TxtCommandCheck  : string;
begin  // of TFrmChkQueue.SendTxtMessageDediPC
  LogError ('TFrmChkQueue.SendTxtMessageDediPC : Begin 0 '+ DateTimeToStr(Now), 0);
  TxtLMessage := CtTxtAlert;
  try
  LogError ('TFrmChkQueue.SendTxtMessageDediPC : 1 '+ DateTimeToStr(Now), 0);
    ADOQryText.Open;                                                            //Database Engine Error Fix
    while not ADOQryText.Eof do                                                 //Database Engine Error Fix
    begin
      LogError ('TFrmChkQueue.SendTxtMessageDediPC : 2 '+ DateTimeToStr(Now), 0);
      TxtCompName := ADOQryText.FieldByName ('IdtWorkstat').AsString;           //Database Engine Error Fix
      if trim (TxtCompName) <> '' then begin
       try
         LogError ('TFrmChkQueue.SendTxtMessageDediPC : 3 '+ DateTimeToStr(Now), 0);
         TxtCommandCheck := CtTxtDataFile + ' ' + TxtCompName + #0;
         LogError ('TFrmChkQueue.SendTxtMessageDediPC : 4 '+ DateTimeToStr(Now), 0);
         WinExec (@TxtCommandCheck[1], SW_HIDE);
         LogError ('TFrmChkQueue.SendTxtMessageDediPC : 5 '+ DateTimeToStr(Now), 0);
         sleep(7000);                                                           //System Test 4 Fix (R2012.1 :: Client En Attente)
         if (IsFlexPointOpen) then begin
          LogError ('TFrmChkQueue.SendTxtMessageDediPC : 6 '+ DateTimeToStr(Now), 0);
           TxtCommand := 'NET SEND ' + TxtCompName + ' ' + TxtLMessage + #0;
           WinExec (@TxtCommand[1], SW_HIDE);
           LogError ('TFrmChkQueue.SendTxtMessageDediPC : 7 '+ DateTimeToStr(Now), 0);
         end;
       except
         on E: Exception do begin
           LogError ('TFrmChkQueue.SendTxtMessageDediPC: ' + E.Message, 0);
         end;
       end;
      end;
      ADOQryText.Next;                                                          //Database Engine Error Fix
    end;
  finally
    LogError ('TFrmChkQueue.SendTxtMessageDediPC : 8 '+ DateTimeToStr(Now), 0);
    ADOQryText.Close;                                                           //Database Engine Error Fix
  end;
  LogError ('TFrmChkQueue.SendTxtMessageDediPC : 9 End '+ DateTimeToStr(Now), 0);
end;  // of TFrmChkQueue.SendTxtMessageDediPC
//=============================================================================

function TFrmChkQueue.IsFlexPointOpen : boolean;
Var
  text   : string;
  Alert : TStringList;  // Define our string list variable
begin
  LogError ('TFrmChkQueue.IsFlexPointOpen : boolean : Begin 0 '+ DateTimeToStr(Now), 0);
  Result := False;
  LogError ('TFrmChkQueue.IsFlexPointOpen : boolean :1 '+ DateTimeToStr(Now), 0);
 // Define a string list object
  Alert := TStringList.Create;
  LogError ('TFrmChkQueue.IsFlexPointOpen : boolean :2 '+ DateTimeToStr(Now), 0);
  Alert.LoadFromFile('C:\TempCheck.txt');
  LogError ('TFrmChkQueue.IsFlexPointOpen : boolean :3 '+ DateTimeToStr(Now), 0);
   text := Alert[0];
 if (trim(text)='1') then  begin
  Result := True;
  end;
  LogError ('TFrmChkQueue.IsFlexPointOpen : boolean :4 '+ DateTimeToStr(Now), 0);
   // Free up the list object
  Alert.Free;
  LogError ('TFrmChkQueue.IsFlexPointOpen : boolean :End 5 '+ DateTimeToStr(Now), 0);
end;
//=============================================================================

procedure TFrmChkQueue.AutoStart (Sender : TObject);
begin  // of TFrmChkQueue.AutoStart
   LogError ('TFrmChkQueue.AutoStart (Sender : TObject) : Begin 0 '+ DateTimeToStr(Now), 0);

   if Application.Terminated then
     Exit;
   LogError ('TFrmChkQueue.AutoStart (Sender : TObject) :1 '+ DateTimeToStr(Now), 0);
   inherited;
   LogError ('TFrmChkQueue.AutoStart (Sender : TObject) :2 '+ DateTimeToStr(Now), 0);
   // Start process
   if ViFlgAutom then begin
    LogError ('TFrmChkQueue.AutoStart (Sender : TObject) :3 '+ DateTimeToStr(Now), 0);
     ActStartExecExecute (Self);
    LogError ('TFrmChkQueue.AutoStart (Sender : TObject) :4 '+ DateTimeToStr(Now), 0);
     Application.Terminate;
    LogError ('TFrmChkQueue.AutoStart (Sender : TObject) :5 '+ DateTimeToStr(Now), 0);
     Application.ProcessMessages;
    LogError ('TFrmChkQueue.AutoStart (Sender : TObject) :6 '+ DateTimeToStr(Now), 0);
   end;
  LogError ('TFrmChkQueue.AutoStart (Sender : TObject) :End 7 '+ DateTimeToStr(Now),0);
end;   // of TFrmChkQueue.AutoStart

//=============================================================================

procedure TFrmChkQueue.ActStartExecExecute(Sender: TObject);
begin
LogError ('TFrmChkQueue.ActStartExecExecute(Sender: TObject) : Begin 0 '+ DateTimeToStr(Now), 0);
  inherited;
 LogError ('TFrmChkQueue.ActStartExecExecute(Sender: TObject) : End 1 '+ DateTimeToStr(Now), 0);
end;

//=============================================================================

procedure TFrmChkQueue.FormCreate(Sender: TObject);
begin
 LogError ('TFrmChkQueue.FormCreate(Sender: TObject) : Begin 0 '+ DateTimeToStr(Now), 0);
  inherited;
  Self.Visible:= False;                                                         //R2012.1 Defect 135 Fix(SM)
 LogError ('TFrmChkQueue.FormCreate(Sender: TObject) : End 1 '+ DateTimeToStr(Now), 0);
end;

//=============================================================================
// PILOT PROBLEM - CAFR (Generic).TCS-SRM.start
//=============================================================================

procedure TFrmChkQueue.LogMessage (ChrMessage : Char;
                                   TxtMessage : string;
                                   NumError   : Integer);
var
  SetSavDBError    : TSetDBError;      // Save original options for DB-error
  FtxLog           : TextFile;         // Filevariable logfile
  TxtIdent         : string;           // Build message identification
  NumLine          : Integer;          // Number logged line
  TxtNumError      : string;           // NumError as string
  TxtLeft          : string;           // Left part splitted string
  TxtRight         : string;           // Right part splitted string
begin  // of TFrmChkQueue.LogMessage
    TxtIdent := BuildLogIdtProcess;
    // Replace all occurences of #10 and #13 by #9
    TxtMessage := StringReplace (TxtMessage, #10, #9, [rfReplaceAll]);
    TxtMessage := StringReplace (TxtMessage, #13, #9, [rfReplaceAll]);
  if not FlgLogErrEnable then
    Exit;
  try
    SetSavDBError := ViSetDBError;
    try
      ViSetDBError := [sfdException];
      if FileExists (CIFNErr) then
        FtxAppend (CIFNErr, FtxLog)
      else begin
        FtxCreate (CIFNErr, FtxLog);
        FtxClose (CIFNErr, FtxLog);
        try
          FileSetCreationDate (CIFNErr, Now);
        finally
          FtxAppend (CIFNErr, FtxLog);
        end;
      end;

      NumLine := 0;
      TxtNumError := LeftPadStringCh (IntToStr (NumError), ' ', 6);
      try
        TxtRight := TxtMessage;
        repeat
          SplitString (TxtRight, #9, TxtLeft, TxtRight);
          if TxtLeft <> '' then begin
            Inc (NumLine);
            FtxWrite (CIFNErr, FtxLog,
                      ChrMessage +
                      LeftPadStringCh (IntToStr (NumLine), '0', 3) + #9 +
                      TxtNumError + #9 +
                      TxtIdent + TxtLeft + #13#10);
          end;
        until TxtRight = '';
      finally
        FtxClose (CIFNErr, FtxLog);
      end;
    finally
      ViSetDBError := SetSavDBError
    end;
  except
    // DON'T let through any exceptions on writing in logfile
  end;
end;   // of TFrmChkQueue.LogMessage

//=============================================================================

procedure TFrmChkQueue.LogError ( S : string;
                                  E : LongInt);
begin  // of TFrmChkQueue.LogError
  if E = 0 then
    E := GetLastError;
  LogMessage ('E', S, E);
end;   // of TFrmChkQueue.LogError

//=============================================================================

procedure TFrmChkQueue.FileSetCreationDate (TxtFNFile : string;
                                            DtmToSet  : TDateTime);
var
  ValDateToSet     : Integer;
  HndlFile         : Integer;
  LocalFileTime, FileTime: TFileTime;

begin  // of TFrmChkQueue.FileSetCreationDate

  if not FileExists (TxtFNFile) then
    Exit;
  ValDateToSet := DateTimeToFileDate (DtmToSet);
  HndlFile := FileOpen (TxtFNFile, fmOpenWrite or fmShareDenyWrite);
  try
    // Following is based on sysutils.FileSetDate, but changed to change the
    // creation date instead of the 'last modified'.
    if DosDateTimeToFileTime (LongRec (ValDateToSet).Hi,
                              LongRec (ValDateToSet).Lo,
                              LocalFileTime) and
       LocalFileTimeToFileTime (LocalFileTime, FileTime) then begin
       SetFileTime (HndlFile, @FileTime, nil, nil)
    end;
  finally
    FileClose (HndlFile);
  end
end;   // of TFrmChkQueue.FileSetCreationDate

//=============================================================================

function TFrmChkQueue.BuildLogIdtProcess : string;
const
  MyID = 1;
begin  // of TFrmChkQueue.BuildLogIdtProcess
  try
    Result := Myname + #9;
  except
    Result := #9;
  end;

  try
    Result := Result + MySession + #9;
  except
    Result := Result + #9;
  end;

  try
    Result := Result + FormatDateTime ('dd-mm-yyyy', Now) + #9;
  except
    Result := Result + #9;
  end;

  try
    Result := Result + FormatDateTime ('hh:mm:ss', Now) + #9;
  except
    Result := Result + #9;
  end;

  try
    Result := Result + 'Node ' + IntToStr (MyID) + #9;
  except
    Result := Result + #9;
  end;
end;   // of TFrmChkQueue.BuildLogIdtProcess

//=============================================================================

function  TFrmChkQueue.FileGetCreationDate (TxtFNFile : string): TDateTime;
var
  LocalFileTime    : TFileTime;        // File time
  RecFindFile      : TSearchRec;       // Search the file
  NumDateFile      : Integer;          // Date of file
begin  // of TFrmChkQueue.FileGetCreationDate
  Result := BadDate;
  try
    if FindFirst (TxtFNFile, faAnyFile, RecFindFile) = 0 then begin
      FileTimeToLocalFileTime (RecFindFile.FindData.ftCreationTime,
                               LocalFileTime);
      if FileTimeToDosDateTime (LocalFileTime, LongRec(NumDateFile).Hi,
                                LongRec(NumDateFile).Lo) then begin
        Result := FileDateToDateTime (NumDateFile);
      end;
    end;
  finally
    FindClose (RecFindFile);
  end;
end;   // of TFrmChkQueue.FileGetCreationDate

//=============================================================================

procedure TFrmChkQueue.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin
  inherited;
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  SplitString(CtLogError, '=', TxtPartLeft , TxtPartRight);
  SplitString(CtBDFR, '=', TxtPartLeft , TxtPartRight);				      //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;

//=============================================================================

 procedure TFrmChkQueue.CheckAppDependParams(TxtParam: string);
begin
 if AnsiCompareText (copy(TxtParam, 3,5), 'LOG') = 0 then
    FlgLogErrEnable := True
 else if AnsiCompareText (copy(TxtParam, 3,6),'BDFR') = 0 then		              //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM
   FlgBDFR := True;								      //R2013.2-Req(35050).Customer_Queue_Alert(BDFR).TCS-SRM
 end;       
//=============================================================================
// PILOT PROBLEM - CAFR (Generic).TCS-SRM.end
//=============================================================================
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FChkQueue
