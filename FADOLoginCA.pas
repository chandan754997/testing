//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : FlexPoint
// Unit     : FADOLoginCA = Form ADO LOGIN for CAstorama
// This is a special form for the ADO menu for castorama Only for Delphi 5
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADOLoginCA.pas,v 1.2 2006/12/22 13:39:44 smete Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - FADOLoginCA - CVS revision 1.2
// Version    ModifiedBy     Reason
// 1.3        AM   (TCS)     R2012.1 47.01 Security  A.M.(TCS)
// 1.4        SC   (TCS)     R2012.1  Defect Fix 94
// 1.5        SM   (TCS)     R2012.1  Defect Fix 255
// 1.6        AS   (TCS)     R2013.1-Applix2788167
//=============================================================================

unit FADOLoginCA;

(*$Include SiCompil.IC*)

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SfLogin, Buttons, ExtCtrls;

//=============================================================================
// TFrmLoginFpn
//=============================================================================
var
   NumberofAttempts : Integer;      // To store number of attempts to enter password   //R2012.1 47.01 Security  A.M.(TCS)
   FlgNewAccount    :  Boolean;                                                  //R2012.1 47.01 Security  A.M.(TCS)
type
  TFrmLoginFpn = class(TFrmLoginDlg)
    ImgBackGround: TImage;
    EdtSecretCode: TEdit;
    LblSecretCode: TLabel;
    procedure EdtLoginKeyPress(Sender: TObject; var Key: Char);
    procedure EdtSecretCodeExit(Sender: TObject);
    procedure EdtSecretCodeKeyPress(Sender: TObject; var Key: Char);
    procedure ShowNewPwdScreen;                                                 //R2012.1 47.01 Security  A.M.(TCS)

  private
    { Private declarations }
    FValMinimumLength: integer;            // Minimum length of secret code
  public
    { Public declarations }
    procedure CreateDataModules; virtual;
    function ValidateInternalLogIn : Boolean; virtual;
    function ValidateOperatorLogIn : Boolean; virtual;
    function ValidateLogIn : Boolean; override;
    function PwdUpdatePeriod: String; virtual;                                  //R2012.1 4701 Security A.M. (TCS)
    function Daysleft: string;                                                  //R2012.1 4701 Security A.M. (TCS)
    procedure ClearFieldsafterPwdChange;                                        //R2012.1 47.01 Security  A.M.(TCS)
  published
    property ValMinimumLength: integer read FValMinimumLength
                                       write FValMinimumLength;
  end;  // of TFrmLoginFpn

//*****************************************************************************
//R2012.1 Defect Fix 94(SC) :: START
var
  SystemName        : string ;
  SystemCodType     : integer ;

function CheckSystemIsPCDedi : Boolean;
//R2012.1 Defect Fix 94(SC) :: END

resourcestring
  CtTxtInvalidLength    = '%s is invalid. Minimum length = %s';
 //R2012.1 47.01 Security  A.M.(TCS)- Start
  CtTxtPwdUsed          = 'This password has already been used';
  CtTxtAccBlock         = 'Account blocked, please contact supervisor';
  CtTxtChngPwd          = 'Your password expired in ';
  CtTxtPwdQstn          = ' days. Do you want it to change now?';
  CtTxtWarning          = 'Warning last attempt before locking your account';
  CtTxtAccSupport       = 'Account reserved for the media. Must be activated beforehand';
  CtTxtAccExpired       = 'Operator account Expired';
  CtTxtContactsupport   = 'Account blocked, please contact support';
 //R2012.1 47.01 Security  A.M.(TCS) - End

implementation

{$R *.DFM}

uses
  StStrW,

  SfDialog,
  SmUtils,
  SrStnCom,

  DFpnADOCA,
  DFpnADOMenuCA,
  FADONewPwdlogin,           //R2012.1 47.01 Security  A.M.(TCS)-Start
  IniFiles,           
  DateUtils,
  IdHash,
  IdHashMessageDigest,       //R2012.1 4701 Security A.M. (TCS)-End
  FSplash;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FADOLoginCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADOLoginCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.5 $';
  CtTxtSrcDate    = '$Date: 2012/12/03 13:39:44 $';

//=============================================================================
// Implementation non-interfaced methods
//=============================================================================

procedure CreateLoginFpn;
begin  // of CreateLoginFpn
  SfLogin.FrmLoginDlg := TFrmLoginFpn.Create (Application);
  if Assigned (FrmSplash) then begin
    FrmSplash.Hide;
    FrmSplash.Release;
    FrmSplash := nil;
  end;
end;   // of CreateLoginFpn

//*****************************************************************************
// Implementation of TFrmLoginFpn
//*****************************************************************************

//=============================================================================
// TFrmLoginFpn.CreateDataModules : creates the needed DataModules.
//=============================================================================

procedure TFrmLoginFpn.CreateDataModules;
begin  // of TFrmFpnMenu.CreateDataModules
  if not Assigned (DmdFpnADOCA) then begin
    DmdFpnADOCA := TDmdFpnADOCA.Create (Application);
    // Don't keep the connection open: database is very infrequently used,
    // so release resources for unused connections
    DmdFpnADOCA.ADOConFlexPoint.KeepConnection        := False;
  end;
  if not Assigned (DmdFpnADOMenuCA) then
    DmdFpnADOMenuCA := TDmdFpnADOMenuCA.Create (Application);
end;   // of TFrmLoginFpn.CreateDataModules
//=============================================================================
//R2012.1 Defect Fix 94(SC) :: START
function CheckSystemIsPCDedi : Boolean;
var
  Buffer : array[0..255] of char;
  Size   : dword;
begin
  Result := False;
  size := 256;
  try
    if GetComputerName(Buffer, Size) then
     SystemName :=  StrPas(Buffer);
     DmdFpnADOCA.ADOQryCheckPCDedi.SQL.Clear;
     DmdFpnADOCA.ADOQryCheckPCDedi.SQL.Add('select CodType from workstat ' +
                               #10 + 'where IdtWorkStat =' +
                               AnsiQuotedStr (SystemName, ''''));
     DmdFpnADOCA.ADOQryCheckPCDedi.Active := True;
     if DmdFpnADOCA.ADOQryCheckPCDedi.RecordCount > 0 then begin
      SystemCodType := DmdFpnADOCA.ADOQryCheckPCDedi.FieldByName('CodType').AsInteger;
     end
     else
      SystemCodType:= 0;

     DmdFpnADOCA.ADOQryCheckPCDedi.Active := False;
     DmdFpnADOCA.ADOQryCheckPCDedi.Close;

    if (SystemCodType = 11) then
     Result := True;
    except
     on e : exception do begin
       showmessage('exception : ' + e.Message);
     end;
    end; 
end;
//R2012.1 Defect Fix 94(SC) :: END
//=============================================================================
// TFrmLoginFpn.ValidateInternalLogIn : validates the LogIn against the
// internal LogIn.
//                              ---
// FUNCRES : True = LogIn OK; False = LogIn not OK.
//=============================================================================

function TFrmLoginFpn.ValidateInternalLogIn : Boolean;
begin  // of TFrmLoginFpn.ValidateInternalLogIn
  Result := EdtLogin.Text =
            DFpnADOMenuCA.CtTxtIdtOperExecAll +
            LeftPadStringCh (IntToStr (StrToInt (FormatDateTime ('d', Date)) * 2),
                        '0', 2) +
            '999' +
            LeftPadStringCh (IntToStr (StrToInt (FormatDateTime ('d', Date)) * 3),
                        '0', 2);

  if Result then begin
    // Allow login with EXECUTEALL
    IdtOperator := DFpnADOMenuCA.CtTxtIdtOperExecAll;
    TxtName     := '';
    CodSecurity := DFpnADOMenuCA.ViCodSecOperExecAll;
  end;
end;   // of TFrmLoginFpn.ValidateInternalLogIn

//=============================================================================
// TFrmLoginFpn.ValidateOperatorLogIn : validates the LogIn against the
// Operators in the Database.
//                              ---
// FUNCRES : True = LogIn OK; False = LogIn not OK.
//=============================================================================

function TFrmLoginFpn.ValidateOperatorLogIn : Boolean;
var
  IdtOperatorL     : string;           // Identification Operator
  IdtLanguageL     : string;           // Language Operator
  IdtPosL          : Integer;          // Identification POS Operator
  TxtWinUserNameL  : string;           // Windows User name Operator
  TxtNameL         : string;           // Name Operator
  TxtPassWordL     : string;           // PassWord Operator
  CodSecurityL     : Integer;          // Security code
  TxtSecretCode    : string;           // Secret of the operator.
  AccountStatus    : string;          //R2012.1 47.01 Security  A.M.(TCS)
  Password         : string;          //R2012.1 47.01 Security  A.M.(TCS)

begin  // of TFrmLoginFpn.ValidateOperatorLogIn
  // Lookup given password
  IdtOperatorL    := '';
  IdtLanguageL    := '';
  IdtPosl         := 0;
  TxtWinUserNameL := '';
  TxtNameL        := '';
  TxtPassWordL    := EdtLogin.Text;
  CodSecurityL    := 0;

  if not Assigned (DmdFpnADOMenuCA) then
    CreateDataModules;

  if (Length(EdtSecretCode.Text) < ValMinimumLength) and (ValMinimumLength > 0)
  then begin
    MessageDlg (Format(CtTxtInvalidLength,
                       [CtTxtSecretCode,IntToStr(ValMinimumLength)]) ,
                mtError, [mbOK], 0);
    EdtSecretCode.Clear;
    EdtSecretCode.SetFocus;
    Result := False;
    exit;
  end;

  Result := DmdFpnADOMenuCA.GetOperator (IdtOperatorL, IdtLanguageL, IdtPosL,
                                         TxtWinUserNameL, TxtNameL,
                                         TxtPassWordL, CodSecurityL);
 //R2012.1 47.01 Security  A.M.(TCS)-Start
  if IdtOperator <> IdtOperatorL then
     NumberofAttempts := 0;
 //R2012.1 47.01 Security  A.M.(TCS)- End
  if Result then begin
    IdtOperator     := IdtOperatorL;
    TxtName         := TxtNameL;
    CodSecurity     := CodSecurityL;
    TxtOperLanguage := IdtLanguageL;
  end
  else begin
    MessageDlg (Caption + ' ' + CtTxtInvalid, mtError, [mbOK], 0);
    EdtLogin.Clear;
    EdtLogin.SetFocus;
  end;
  if Result = False then
    Exit;
 //R2012.1 47.01 Security  A.M.(TCS)-Start
  AccountStatus := DmdFpnADOMenuCA.GetOperatorStatus (IdtOperator);

   if AccountStatus = 'L' then begin
     if Codsecurity < 9 then
       MessageDlg (CtTxtAccBlock, mtError, [mbOK], 0)
     else
       MessageDlg (CtTxtContactsupport, mtError, [mbOK], 0);
       EdtSecretCode.Clear;
       EdtLogin.SetFocus;
       Result:= False;
       exit;
    end;
 //R2012.1 47.01 Security  A.M.(TCS)- End
  if not Assigned (DmdFpnADOMenuCA) then
    CreateDataModules;

  TxtSecretCode := DmdFpnADOMenuCA.GetSecretCode (IdtOperator);
 //R2012.1 47.01 Security  A.M.(TCS)-Start
 with TIdHashMessageDigest5.Create do
   try
   Password:= TIdHash128.AsHex(HashValue(AnsiUpperCase(EdtSecretCode.Text)));
 //R2012.1 47.01 Security  A.M.(TCS)-End
  if TxtSecretCode <> Password then begin
    MessageDlg (CtTxtSecretCode + ' ' + CtTxtInvalid, mtError, [mbOK], 0);
    NumberofAttempts := NumberofAttempts + 1;    //R2012.1 47.01 Security  A.M.(TCS)
    EdtSecretCode.Clear;
    EdtSecretCode.SetFocus;
   //R2012.1 47.01 Security  A.M.(TCS)-Start
    if (strtoint(FrmLoginDlg1.MaximumAttempts) -  NumberofAttempts) = 1 then
      MessageDlg (CtTxtWarning, mtError, [mbOK], 0);
    if  NumberofAttempts = strtoint(FrmLoginDlg1.MaximumAttempts) then begin
       DmdFpnADOMenuCA.LockOprAccount (IdtOperator);
       MessageDlg (CtTxtAccBlock, mtError, [mbOK], 0)
    end;
   //R2012.1 47.01 Security  A.M.(TCS)- End
    Result := False;
  end
  else begin                                 //R2012.1 47.01 Security  A.M.(TCS)-Start
    NumberofAttempts := 0;
  end;
  finally
    Free;
 end;                                       //R2012.1 47.01 Security  A.M.(TCS)- End
end;   // of TFrmLoginFpn.ValidateOperatorLogIn

//=============================================================================
// TFrmLoginFpn.ValidateLogIn : validates the LogIn.
//                              ---
// FUNCRES : True = LogIn OK; False = LogIn not OK.
//=============================================================================

function TFrmLoginFpn.ValidateLogIn : Boolean;
//R2012.1 47.01 Security  A.M.(TCS)-Start
var
  PwdModifiedDate  : Tdate;    // Date of modifiaction of password for a opeartor
  AccountStatus    : string;
  NoOfDaysBetween,UpdatePeriod : double;
//R2012.1 47.01 Security  A.M.(TCS)- End

begin  // of TFrmLoginFpn.ValidateLogIn
  Result := False;
  if ((not ValidateInternalLogIn) and (EdtSecretCode.Text = '')) then begin
    // Blanc Secret Code is not allowed
    MessageDlg (CtTxtSecretCode + ' ' + CtTxtRequired, mtError, [mbOK], 0);
    Exit;
  end;
  if ValidateInternalLogIn and (EdtSecretCode.Text <> '') then begin
    // invalid secret code for Internal Login
    MessageDlg (CtTxtSecretCode + ' ' + CtTxtInvalid, mtError, [mbOK], 0);
    EdtSecretCode.Clear;
    EdtSecretCode.SetFocus;
    Exit;
  end;
  Result := False;
  if EdtLogin.Text = '' then begin
    // Blanc login is not allowed
    MessageDlg (Caption + ' ' + CtTxtRequired, mtError, [mbOK], 0);
    Exit;
  end;

  Result := ValidateInternalLogIn;
  //R2012.1 Defect Fix 94/255(SC) ::START
  if DmdFpnADOCA <> nil then begin
    if CheckSystemIsPCDedi then
     Result := False;
  end;
  //R2012.1 Defect Fix 94/255(SC) :: END 
  if not Result then
    Result := ValidateOperatorLogIn;

   //R2012.1 47.01 Security  A.M.(TCS)-Start
if  (IdtOperator <> DFpnADOMenuCA.CtTxtIdtOperExecAll) and Result then begin       //R2013.1-Applix2788167-TCS-AS
  AccountStatus := DmdFpnADOMenuCA.GetOperatorStatus (IdtOperator);

   if AccountStatus = 'L' then begin
     if Codsecurity < 9 then
       MessageDlg (CtTxtAccBlock, mtError, [mbOK], 0)
     else
       MessageDlg (CtTxtContactsupport, mtError, [mbOK], 0);
       EdtLogin.Clear;
       EdtSecretCode.Clear;
       Result := False;
   end
   else if (AccountStatus ='N') then begin
      FlgNewAccount:= True;
      ShowNewPwdScreen;
      Result := False;
   end
  //R2012.1 47.01 Security  A.M.(Modifications)-Start
   else if (AccountStatus ='E') then begin
      MessageDlg (CtTxtAccExpired, mtError, [mbOK], 0);
      ShowNewPwdScreen;
      Result := False;
   end
   else if (AccountStatus ='N') or (AccountStatus ='R') then begin
      ShowNewPwdScreen;
      Result := False;
   end
  //R2012.1 47.01 Security  A.M.(Modifications)-End
   else if AccountStatus = 'D' then begin
       MessageDlg (CtTxtAccSupport, mtError, [mbOK], 0);
       EdtSecretCode.Clear;
       EdtLogin.SetFocus;
       Result := False;
   end;
 end
 else
 Exit;

 if  AccountStatus = 'A' then begin
   PwdModifiedDate := DmdFpnADOMenuCA.GetDatModify (IdtOperator);
   NoOfDaysBetween := (DaysBetween(now, PwdModifiedDate));
   UpdatePeriod := StrToFloat(PwdUpdatePeriod);

    if ((UpdatePeriod - NoOfDaysBetween) <= StrToFloat(Daysleft)) and (UpdatePeriod>NoOfDaysBetween) and (Codsecurity < 9)  then begin
      if MessageDlg(CtTxtChngPwd + FloatToStr((UpdatePeriod - NoOfDaysBetween)) + CtTxtPwdQstn,mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
        ShowNewPwdScreen;
        Result := False;
      end
      else begin
       Result := True;
      end;
    end;
 end;
 //R2012.1 47.01 Security  A.M.(TCS)- End
end;   // of TFrmLoginFpn.ValidateLogIn

//=============================================================================

procedure TFrmLoginFpn.EdtLoginKeyPress(Sender: TObject; var Key: Char);
begin // of TFrmLoginFpn.EdtLoginKeyPress
  inherited;
  if (Key = #13) and (Trim (TEdit(Sender).Text) <> '') then begin
    if ValidateInternalLogIn then
      ModalResult := mrOk
    else
      PostMessage (TWinControl(Sender).Handle, WM_KeyDown, VK_TAB, 0);
    Key := #0;
  end;
end;  // of TFrmLoginFpn.EdtLoginKeyPress

//=============================================================================

procedure TFrmLoginFpn.EdtSecretCodeExit(Sender: TObject);
begin // of TFrmLoginFpn.EdtSecretCodeExit
  inherited;
  if ValidateInternalLogIn then
    ModalResult := mrOK;
end;  // of TFrmLoginFpn.EdtSecretCodeExit

//=============================================================================

procedure TFrmLoginFpn.EdtSecretCodeKeyPress(Sender: TObject; var Key: Char);
begin // of TFrmLoginFpn.EdtSecretCodeKeyPress
  inherited;
  if (Key = #13) and (Trim (TEdit(Sender).Text) <> '') then begin
    PostMessage (TWinControl(Sender).Handle, WM_KeyDown, VK_TAB, 0);
    Key := #0;
  end;
end;  // of TFrmLoginFpn.EdtSecretCodeKeyPress

//=============================================================================
//R2012.1 47.01 Security  A.M.(TCS)- Start
procedure TFrmLoginFpn.ShowNewPwdScreen;
begin // of TFrmLoginFpn.ShowNewPwdScreen
  FrmLoginDlg1.FillLoginField(EdtLogin.text);
  FrmLoginDlg1 := TFrmLoginDlg1.Create (Application);
  EdtSecretCode.Clear;
  EdtLogin.Clear;
  FrmLoginDlg.Hide;
  FrmLoginDlg1.show;
end;  // of TFrmLoginFpn.ShowNewPwdScreen
//=============================================================================
function TFrmLoginFpn.PwdUpdatePeriod: String;
var
  Txt               : String;
  TxtSection        : String;
  IniFileInst       : TIniFile;
  TxtSystemPath     : String;
  ReasonsIniPath    : String;
  StrLstSystem      : TStringList;
begin  // of TFrmDetOperatorCA.PwdUpdatePeriod

  TxtSection :=  'PwdUpdateFrequency ';
  IniFileInst:= nil;
  TxtSystemPath:= ReplaceEnvVar ('%SycRoot%');
  ReasonsIniPath  := '\FlexPos\Ini\fpssyst.ini';
  IniFileInst:= TIniFile.Create(TxtSystemPath+ReasonsIniPath);
  StrLstSystem:=  TStringList.Create; // Create the Stringlist.
   try
    OpenIniFile(TxtSystemPath+ReasonsIniPath,IniFileInst);


   try
     StrLstSystem.Clear;
     IniFileInst.ReadSectionValues (TxtSection , StrLstSystem);
     Txt := StrLstSystem.Values['Frequency'];

    except
        on E:Exception do
        raise ESvcLocalScope.Create ('ERROR ' + ReasonsIniPath + ': ' + E.Message);
    end;
  finally
    FreeAndNil(IniFileInst);
    StrLstSystem.Free;
  end;

  Result := Txt;
end;   // of TFrmDetOperatorCA.PwdUpdatePeriod

//=============================================================================
function TFrmLoginFpn.Daysleft: string;
var
  Txt               : String;
  TxtSection        : String;
  IniFileInst       : TIniFile;
  TxtSystemPath     : String;
  ReasonsIniPath    : String;
  StrLstSystem      : TStringList;
begin  // of TFrmLoginDlg1.NumberOfDays

  TxtSection :=  'DaysToChangePwd';
  IniFileInst:= nil;
  TxtSystemPath:= ReplaceEnvVar ('%SycRoot%');
  ReasonsIniPath  := '\FlexPos\Ini\fpssyst.ini';
  IniFileInst:= TIniFile.Create(TxtSystemPath+ReasonsIniPath);
  StrLstSystem:=  TStringList.Create; // Create the Stringlist.
   try
    OpenIniFile(TxtSystemPath+ReasonsIniPath,IniFileInst);


   try
     StrLstSystem.Clear;
     IniFileInst.ReadSectionValues (TxtSection , StrLstSystem);
     Txt := StrLstSystem.Values['DAYS'];

    except
        on E:Exception do
        raise ESvcLocalScope.Create ('ERROR ' + ReasonsIniPath + ': ' + E.Message);
    end;
  finally
    FreeAndNil(IniFileInst);
    StrLstSystem.Free;
  end;

  Result := Txt;
end;   // of TFrmLoginDlg1.NumberOfDays
//=============================================================================
procedure TFrmLoginFpn.ClearFieldsafterPwdChange;
begin // of TFrmLoginFpn.ShowNewPwdScreen
   if FlgPwdChanged then begin
    EdtSecretCode.Clear;
    EdtLogin.clear;
   end;
end;  // of TFrmLoginFpn.ShowNewPwdScreen
//R2012.1 47.01 Security  A.M.(TCS)- End
//=============================================================================

initialization
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
  SfLogin.ViProcCreateLogin := CreateLoginFpn;
end.   // of FADOLoginCA
