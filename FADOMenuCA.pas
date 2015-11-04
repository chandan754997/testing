//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : FlexPoint
// Unit     : FADOMenuCA = Form ADO MENU for CASTORAMA
// This is a special form for the ADO menu for castorama Only for Delphi 5
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADOMenuCA.pas,v 1.6 2010/02/12 08:58:46 BEL\DVanpouc Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - FADOMenuCA - CVS revision 1.2
// Version              Modified By                          Reason
// V 1.3               GG. (TCS)                          R2011.2 - Credit Note Cleansing  Defect(202) Fix
// V 1.4               ARB (TCS)                          R2011.2 - Defect Fix 492
// V 1.5               ARB (TCS)                          R2011.2 - Defect Fix 492(Refix)
// V 1.6                SC (TCS)                          R2012.1 - Enhancement 286
//=============================================================================

unit FADOMenuCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfMenu, Menus, ExtCtrls, ComCtrls, StdCtrls, ScAppRun;

//*****************************************************************************
// Global interfaced identifiers for FlexPoint Menu
//*****************************************************************************

const  // Values allowed for user-defined options in ini-file
  CtTxtDBName      = 'DatabaseName';   // INI-Value : DataBaseName
  CtTxtServerName  = 'ServerName';     // INI-Value : ServerName

//=============================================================================
// Help for application dependent run parameters
//=============================================================================

resourcestring  // Runparameters variants
  CtTxtRunParamNoDB= '/V-DB=Don''t try to connect to database at startup';
  CtTxtRunParamADO = '/VADO=Sets the ADO database. ';
  CtTxtRunParamADOFmt = '/VADO= Format: [DatabaseName] ' +
                        'or [DBServerName.DatabaseName]';

//=============================================================================
// TFrmFpnMenu :
//                                  -----
// DATAFIELDS :
// - FlgDBStartUp : flag set default True during creation, can become False
//   due to runparameter /V-DB to avoid trying to connect to the
//   database at start up.
// - FlgTryDBConnect : keeps a flag if it is practically to try to connect to
//   the database. Without this flag, every call to a method in a datamodule
//   would try to connect. When the database is not available, this can take
//   a lot of time on startup (especially when commands needs replacements of
//   database-properties).
//   Therefor, during startup, we will try to connect only once, and set the
//   flag to False to indicate it is useless to try again.
//   After startup, we set the flag to True again, so next calls will try
//   to connect again.
//=============================================================================

type
  TFrmFpnMenu = class(TFrmMenu)
    ImgLogo: TImage;
    procedure FormActivate(Sender: TObject);
  private
    FValMinimumLength: integer;
    { Private declarations }
  protected
    { Protected declarations }
    // Datafields
    FlgDBStartUp   : Boolean;           // Runparameter to disable DB at startup
    FlgTryDBConnect: Boolean;           // Try to connect to database ???
    // Methods
    function GetMaxLvlSecurity : Integer; override;
    function GetInternalLogOn : string; override;
    function GetTxtChain : string; override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure CreateDataModules; virtual;
    function GetOperatorInfo : Boolean; override;
    procedure UseDefaultOperator; override;
    function CmdUserValue (const TxtOptionKey : string) : string; override;
    procedure InterpretSettingsDOSEnv; override;
    procedure AskLogOn; override;
    procedure CreateRegKeyLogOn; override;   //R2011.2 - Credit Note Cleansing  Defect(202) Fix (GG)
  public
    { Public declarations }
    // Constructor
    constructor Create (AOwner : TComponent); override;
    procedure CreaConnectCashDesk; // R2011.2 Defect 492 Fix ARB
  published
    property ValMinimumLength: integer read FValMinimumLength
                                       write FValMinimumLength;
  end;   // of TFrmFpnMenu

var
  FrmFpnMenu: TFrmFpnMenu;
  FlgCreaConnCashdesk : Boolean = False;          // R2011.2 Defect 492 Fix KB ::START

//*****************************************************************************

implementation

{$R *.DFM}

uses
  BdeConst,
  Registry,  //R2011.2 - Credit Note Cleansing  Defect(202) Fix (GG)
  MFpnUtils,

  SfDialog,
  SmUtils,
  SmWinApi,
  SrStnCom,

  DFpnADOCA,
  DFpnADOMenuCA,

  FSplash,
  RFpnCom, FADOLoginCA, SfLogin,
  FlexUtils;        // R2011.2 Defect 492 Fix ARB

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FADOMenuCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FADOMenuCA.pas  $';
  CtTxtSrcVersion = '$Revision: 1.6 $';
  CtTxtSrcDate    = '$Date: 2013/09/30 08:58:46 $';

//=============================================================================
// Constants
//=============================================================================

const  // Registry key hovering
  CtTxtRegKeyHover = '\' + SrStnCom.CtTxtSycRegRoot + '\' +
                     RFpnCom.CtTxtCompanyFpn + '\' +
                     RFpnCom.CtTxtNameFpn + '\Menu\Hover';

const  // Registry key form position
  CtTxtRegKeyPosition   = '\' + SrStnCom.CtTxtSycRegRoot + '\' +
                          RFpnCom.CtTxtCompanyFpn + '\' +
                          RFpnCom.CtTxtNameFpn + '\Menu\Position';

//=============================================================================
// Variables
//=============================================================================

var
  SvcAppPrevInstance : TSvcAppInstance;

//*****************************************************************************
// Implementation of TFrmFpnMenu
//*****************************************************************************

//=============================================================================
// Constructor & destructor
//=============================================================================

constructor TFrmFpnMenu.Create (AOwner : TComponent);
begin  // of TFrmFpnMenu.Create
  // Replace standard registry-keys by FlexPoint keys
  RegKeyLogOn    := CtTxtRegKeyOper;
  RegKeyHover    := CtTxtRegKeyHover;
  RegKeyPosition := CtTxtRegKeyPosition;

  FlgDBStartUp    := True;
  FlgTryDBConnect := True;

  FTxtChain := #0;
  inherited;
end;   // of TFrmFpnMenu.Create

//=============================================================================

function TFrmFpnMenu.GetMaxLvlSecurity : Integer;
begin  // of TFrmFpnMenu.GetMaxLvlSecurity
  Result := DFpnADOMenuCA.ViCodSecOperExecAll;
end;   // of TFrmFpnMenu.GetMaxLvlSecurity

//=============================================================================
// R2011.2 Defect 492 Fix ARB :: START

//=============================================================================
// TFrmFpnMenu.CreaConnectCashDesk : This procedure creates the remote
// connection with all the connected tills after successfully logging into the
// FlexpointMenu Application
//=============================================================================
procedure TFrmFpnMenu.CreaConnectCashDesk;

var
 StrLstCD         : TStringList;
 Counter          : integer;
 TxtPsw           : widestring;
 TxtUserName      : widestring;
 IntResult        : boolean;//integer;
 ArrErrMsgBuf     : array[0..512] of widechar;
 ErrCode          : DWord;                    
 TxtShareCDName   : widestring;
begin
 TxtUserName := 'Root';
 TxtPsw := 'admin' + TxtStoreNum ;
 Counter := 0;  
 StrLstCD := TStringList.Create;
 StrLstCD.Assign( DmdFpnADOMenuCA.LstCashDesk);

 if (Flexutils.CIHandle = 0) then begin
  EXIT
 end;

 if StrlstCD.Count = 0 then
  ShowMessage('No Cashdesk to Connect'); // may need translation
 while Counter<= (StrLstCD.Count-1) do begin
    TxtShareCDName := StrLstCD.Strings[Counter];
    IntResult := AddRemoteConnection(PWideChar(TxtShareCDName),
                                     PWideChar(TxtUserName),PWideChar(TxtPsw));
    if not (IntResult) then begin  // AddRemoteConnection throws error
     ErrCode := GetLastErrorNo;
     if  (ErrCode = ERROR_ALREADY_ASSIGNED) or
     (ErrCode =ERROR_SESSION_CREDENTIAL_CONFLICT) then begin //Connection already exists
                                                             //hence trying to disconnect

      IntResult := CancelRemoteConnection(PWideChar(TxtShareCDName));
      if not (IntResult) then begin // CancelRemote connection throws error
        GetLastErrorMessage(ArrErrMsgBuf,513);
        //showmessage('Could not disconnect remote connection ' + TxtShareCDName+
        //             #13 + ArrErrMsgBuf );  
      end
      else begin                    // CancelRemote connection Successful
        continue;                   // continue the same interation
      end;
     end
     else begin                                     //any other error message
      GetLastErrorMessage(ArrErrMsgBuf,513);   
      //showmessage('Could not connect remotely to ' + TxtShareCDName+ #13      //Error Msg Commented for R2012.1 Enhancement 286 (SC)
      //                   + ArrErrMsgBuf);                                     //Error Msg Commented for R2012.1 Enhancement 286 (SC)
     end;
    end;
    Counter := Counter +1;
  end;
end;
// R2011.2 Defect 492 Fix ARB :: END
//=============================================================================

function TFrmFpnMenu.GetInternalLogOn : string;
begin  // of TFrmFpnMenu.GetIsInternalLogOn
  Result := DFpnADOMenuCA.CtTxtIdtOperExecAll;
end;   // of TFrmFpnMenu.GetInternalLogOn

//=============================================================================

function TFrmFpnMenu.GetTxtChain : string;
begin  // of TFrmFpnMenu.GetTxtChain
  if FTxtChain = #0 then begin
    try  // .. except
      if not Assigned (DmdFpnADOMenuCA) then
        CreateDataModules;
      try  // .. finally
        if not DmdFpnADOMenuCA.QueryInfo
                 ('SELECT TxtParam FROM ApplicParam ' +
                  'WHERE IdtApplicParam = ' + AnsiQuotedStr('Chain', '''')) then
          raise ESvcLocalScope.Create ('ApplicParam ' + CtTxtNotExist)
        else
          FTxtChain :=
            Trim (DmdFpnADOMenuCA.ADOQryInfo.FieldByName ('TxtParam').AsString);
      finally
        DmdFpnADOMenuCA.CloseInfo;
      end;
    except
      on E:Exception do begin
        StrLstAboutApplication.Add (CtTxtEmCommonGet + ' Chain : ' + E.Message);
        FTxtChain := '';
      end;
    end;
  end;

  Result := FTxtChain;
end;   // of TFrmFpnMenu.GetTxtChain

//=============================================================================

procedure TFrmFpnMenu.BeforeCheckRunParams;
var
  TxtLeft          : string;           // Leftside of string after splitstring
  TxtRight         : string;           // Rightside of string after splitstring
begin  // of TFrmFpnMenu.BeforeCheckRunParams
  inherited;

  // Add help for variant no database
  SplitString (CtTxtRunParamNoDB, '=', TxtLeft, TxtRight);
  SfDialog.AddRunParams (TxtLeft, TxtRight);

  // Add help for ADO
  SplitString (CtTxtRunParamADO, '=', TxtLeft, TxtRight);
  SfDialog.AddRunParams (TxtLeft, TxtRight);
  SplitString (CtTxtRunParamADOFmt, '=', TxtLeft, TxtRight);
  SfDialog.AddRunParams (TxtLeft, TxtRight);

end;   // of TFrmFpnMenu.BeforeCheckRunParams

//=============================================================================

procedure TFrmFpnMenu.CheckAppDependParams (TxtParam : string);
begin  // of TFrmFpnMenu.CheckAppDependParams
  if AnsiUpperCase (TxtParam) = '/V-DB' then
    FlgDBStartUp := False
  else if AnsiUpperCase (Copy (TxtParam, 1, 5)) = '/VADO' then
    ViTxtPrmADOAlias := Copy (TxtParam, 6, Length (TxtParam))
  else if AnsiUpperCase (Copy (TxtParam, 1, 4)) = '/VML' then
    ValMinimumLength := StrToInt(Copy (TxtParam, 5, Length (TxtParam)))
  else if AnsiCompareText (Copy (TxtParam, 1, 4), TxtSplashCustomParam) <> 0 then
    inherited;
end;   // of TFrmFpnMenu.CheckAppDependParams

//=============================================================================
// TFrmFpnMenu.CreateDataModules : creates the needed DataModules.
//=============================================================================

procedure TFrmFpnMenu.CreateDataModules;
begin  // of TFrmFpnMenu.CreateDataModules
  if not Assigned (DmdFpnADOCA) and (not FlgTryDBConnect) then
    raise ESvcLocalScope.Create (Format (SLoginError, ['']));

  if not Assigned (DmdFpnADOCA) then begin
    DmdFpnADOCA := TDmdFpnADOCA.Create (Application);
    // Don't keep the connection open: database is very infrequently used,
    // so release resources for unused connections
    DmdFpnADOCA.ADOConFlexpoint.KeepConnection        := False;
  end;
  if not Assigned (DmdFpnADOMenuCA) then
    DmdFpnADOMenuCA := TDmdFpnADOMenuCA.Create (Application);
end;   // of TFrmFpnMenu.CreateDataModules

//=============================================================================

function TFrmFpnMenu.GetOperatorInfo : Boolean;
begin  // of TFrmFpnMenu.GetOperatorInfo
  if not Assigned (DmdFpnADOMenuCA) then
    CreateDataModules;
  Result := DmdFpnADOMenuCA.GetOperator (IdtOperator, OperatorIdtLanguage,
                                        IdtPos, TxtWinUserName, OperatorTxtName,
                                        TxtPassWord, FCodSecurity);
end;   // of TFrmFpnMenu.GetOperatorInfo

//=============================================================================

procedure TFrmFpnMenu.UseDefaultOperator;
begin  // of TFrmFpnMenu.UseDefaultOperator
  inherited;

  if FlgDBStartUp then
    OperatorIdtLanguage := DmdFpnADOMenuCA.IdtLanguageUser
  else
    OperatorIdtLanguage := ViTxtUserLanguage;
  CodSecurity := ViCodSecOperExecAll;
end;   // of TFrmFpnMenu.UseDefaultOperator

//=============================================================================
// TFrmFpnMenu.CmdUserValue : replaces a FlexPoint's user defined option with
// his value. (See documentation for possible user defined options).
//                              ---
// INPUT   : TxtOptionKey = keyword for the user defined keyword to get the
//                                           ---
// FUNCRES : value for the user defined option; empty if option is unknow.
//=============================================================================

function TFrmFpnMenu.CmdUserValue (const TxtOptionKey : string) : string;
begin  // of TFrmFpnMenu.CmdUserValue
  Result := '';
  if (AnsiCompareText (TxtOptionKey, CtTxtDBName) = 0) or
     (AnsiCompareText (TxtOptionKey, CtTxtServerName) = 0) then begin
    if not Assigned (DmdFpnADOMenuCA) then
      CreateDataModules;
    if AnsiCompareText (TxtOptionKey, CtTxtDBName) = 0 then
      // Fetch DBName
      Result := DmdFpnADOMenuCA.TxtDBName
    else if AnsiCompareText (TxtOptionKey, CtTxtServerName) = 0 then
      // Fetch ServerName
      Result := DmdFpnADOMenuCA.TxtServerName;
  end
  else
    Result := inherited CmdUserValue (TxtOptionKey);
end;   // of TFrmFpnMenu.CmdUserValue

//=============================================================================

procedure TFrmFpnMenu.InterpretSettingsDOSEnv;
begin  // of TFrmFpnMenu.InterpretSettingsDOSEnv
  try
    if FlgSetDosEnv then
      SetDosEnvFromFile;
  except
    Application.HandleException (Self);
  end;
end;   // of TFrmFpnMenu.InterpretSettingsDOSEnv

//=============================================================================

procedure TFrmFpnMenu.FormActivate(Sender: TObject);
begin  // of TFrmFpnMenu.FormActivate
  // Add tradematrix name to caption
  try
    if FlgDBStartUp then begin
      if not Assigned (DmdFpnADOMenuCA) then
        CreateDataModules;
      TxtCaptionAddit := ' - ' + DmdFpnADOMenuCA.TradeMatrixName;
    end;
  except
    on E:Exception do begin
      // In case successive calls to database during startup:
      if FlgTryDBConnect then begin
        StrLstAboutApplication.Add (Format (SLoginError, ['']) + ' : ' +
                                    E.Message);
        FlgTryDBConnect := False;
      end;
      TxtCaptionAddit := ' - ' + Format (SLoginError, ['']);
    end;
  end;

  inherited;
end;   // of TFrmFpnMenu.FormActivate

//=============================================================================

procedure TFrmFpnMenu.AskLogon;
begin
  // Create login screen
  ViProcCreateLogin;

  TFrmLoginFpn(SfLogin.FrmLoginDlg).ValMinimumLength := ValMinimumLength;

  try
    if SfLogin.FrmLoginDlg.ShowModal <> mrCancel then begin
      FlgOperKnown := True;
      CodSecurity := FrmLoginDlg.CodSecurity;
      IdtOperator := FrmLoginDlg.IdtOperator;
      OperatorTxtName := FrmLoginDlg.TxtName;
      OperatorIdtLanguage := FrmLoginDlg.TxtOperLanguage;
      if IsInternalLogOn then
        LogInfo (CtNumLogInfIntLogOn, ['LogOn: ' + OperatorTxtName +
                                       ' (Internal)'])
      else
        LogInfo (CtNumLogInfLogOn, ['LogOn: ' + OperatorTxtName]);
      CreateRegKeyLogOn;
      // R2011.2 Defect 492 Fix ARB ::START
      DmdFpnADOMenuCA.ProcessLstCashDesk;
     if FlgCreaConnCashdesk = False then     // R2011.2 Defect 492 Fix KB ::Add
      CreaConnectCashDesk;
      FlgCreaConnCashdesk := True;            // R2011.2 Defect 492 Fix KB ::Add
     // R2011.2 Defect 492 Fix ARB ::END
    end
    else begin
      LogInfo (CtNumLogInfMenuStop, ['MenuStop']);
      Application.Terminate;
      Exit;
    end;
  finally
    FrmLoginDlg.Release;
    FrmLoginDlg := nil;
  end;
end;
//=============================================================================

//R2011.2 - Credit Note Cleansing  Defect(202) Fix (GG) ::Start
procedure TFrmFpnMenu.CreateRegKeyLogOn;
var
RegKey : TRegistry; //TCS Change to fix defect 202
begin  // of TFrmMenu.CreateRegKeyLogOn
  inherited;
  // Create registry keys
    RegKey := TRegistry.Create;
    try
      if RegKey.OpenKey (RegKeyLogOn, True) then begin
        try
          Regkey.WriteString('IdOperator',FrmLoginDlg.IdtOperator);             //Code Changed by gg to trace cleansing
        except
        end;
      end;
    finally
      RegKey.Free;
    end;
end;   // of TFrmMenu.CreateRegKeyLogOn
//R2011.2 - Credit Note Cleansing  Defect(202) Fix (GG) ::End

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

  // Go back to previous instance
  SvcAppPrevInstance := TSvcAppInstance.Create (nil);
  SvcAppPrevInstance.InstanceOption := aioPrevious;
  SvcAppPrevInstance.MutexName      := 'SycronFlexPointMenu';
  SvcAppPrevInstance.Name           := 'SvcAppPrevInstance';
  SvcAppPrevInstance.Execute;
end.   // of FADOMenuCA
