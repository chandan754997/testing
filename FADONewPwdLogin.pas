//=========== TCS 2012 ===============================
// Packet   : FlexPoint
// Unit     : FADONewPwdLogin
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADONewPwdLogin.pas,v 1.0 2012/12/22 13:39:44
// History :
// - Started from Castorama - Flexpoint 2.0 - FADONewPwdLogin - CVS revision 1.0
//=============================================================================
// Version    ModifiedBy         Reason
// 1.0           AM        R2012.1 47.01 Security  A.M.(TCS)
// 1.1           CP        R2012.1 Defect Fix 125

unit FADONewPwdLogin;

//*****************************************************************************
 (*$Include SiCompil.IC*)
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfLogin, StdCtrls, Buttons, ExtCtrls;

//=============================================================================
// TFrmLoginDlg1
//=============================================================================
var
 FlgPwdChanged : Boolean;
 OperatorID : string;
 IdtOpr     : string;
type
  TFrmLoginDlg1 = class(TFrmLoginDlg)
    EdtSecretCode: TEdit;
    EditConfirmPwd: TEdit;
    ImgBackGround: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure EditConfirmPwdKeyPress(Sender: TObject; var Key: Char);
    procedure EdtSecretCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EdtSecretCodeExit(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);

  private
    { Private declarations }
     FValMinimumLength: integer;            // Minimum length of secret code
  public
    { Public declarations }
    procedure CreateDataModules; virtual;
    function NumberOfPwd: string; virtual;
    function ValidateNewPwdfield: Boolean;
    function PwdFormatValidation(PwdEntered: string): Boolean;
    function PasswordFormat: string;
    function MaximumAttempts: string;
    function ReadDefaultPassword: string;                                       //R2012.1 47.01 Security  A.M.(TCS)
    procedure FillLoginField(loginID:string);
   published
    property ValMinimumLength: integer read FValMinimumLength
                                       write FValMinimumLength;
  end;

var
  FrmLoginDlg1: TFrmLoginDlg1;
//*****************************************************************************

resourcestring
  CtTxtNewPwd     = 'Wrong Secret Code';
  CtTxtPwdUsed    = 'This password has already been used';
  CtTxtPwdChanged = 'The password has been changed successfully';
  CtTxtNew        = 'New Password Required';
  CtTxtPwdConfirm = 'Password confirmation Required';
 //R2012.1 47.01 Security  A.M.(Modifications)-Start
  CtTxtPwdFormat1    = 'The password does not conform to security norms: enter at least ';
  CtTxtPwdFormat2    = ' characters with at least ';
  CtTxtPwdFormat3    = ' digits and ';
  CtTxtPwdFormat4    = ' letters';
 //R2012.1 47.01 Security  A.M.(Modifications)-End
  CtTxtDiffPwd    = 'The pass word must be different from login';
  CtTxtDefaultPwd = 'K1NGF1SHER';
implementation

{$R *.dfm}

uses
  FADOLoginCA,
  SfDialog,
  DFpnADOCA,
  StStrW,
  Inifiles,
  SmUtils,
  SrStnCom,
  DFpnADOMenuCA,
  IdHash,
  IdHashMessageDigest;
//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FADONewPwdLogin';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADONewPwdLogin.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2012/10/04 13:39:44 $';

//=============================================================================
// Implementation non-interfaced methods
//=============================================================================
procedure TFrmLoginDlg1.BtnOKClick(Sender: TObject);
var
IdOperator : string;
ChangedPwd : string;
ModifiedDate: TdateTime;
begin       //of TFrmLoginDlg1.BtnOKClick
  inherited;
  if not ValidateNewPwdfield then
   exit;
 if (AnsiUpperCase(EdtSecretCode.Text)) <> (AnsiUpperCase(EditConfirmPwd.Text)) then begin
   MessageDlg (CtTxtNewPwd , mtError, [mbOK], 0);
   EditConfirmPwd .clear;
   EdtSecretCode.SetFocus;
 end
 else begin
    MessageDlg (CtTxtPwdChanged , mtInformation, [mbOK], 0);

  with TIdHashMessageDigest5.Create do
   try
    ChangedPwd := TIdHash128.AsHex(HashValue(AnsiUpperCase(EditConfirmPwd.Text)));
    ModifiedDate := Now;
    DmdFpnADOMenuCA.UpdOperatorPwd (IdtOpr,ChangedPwd);
    //DmdFpnADOMenuCA.InsertOprOldPass (IdtOpr,ChangedPwd,ModifiedDate);
    ModalResult := mrcancel;
    FlgPwdChanged := True;
    FrmLoginDlg1.close;
    FrmLoginDlg.Show;
    FrmLoginDlg.EdtLogin.SetFocus;
   finally
    Free;
  end;
 end;
end;      //of TFrmLoginDlg1.BtnOKClick
//=============================================================================
procedure TFrmLoginDlg1.BtnCancelClick(Sender: TObject);
begin      //of TFrmLoginDlg1.BtnCancelClick
  //inherited;
 FrmLoginDlg1.close;
 FrmLoginDlg.Show;
 FrmLoginDlg.EdtLogin.SetFocus;
end;     //of TFrmLoginDlg1.BtnCancelClick
//=============================================================================
// TFrmLoginDlg1.CreateDataModules : creates the needed DataModules.
//=============================================================================
procedure TFrmLoginDlg1.CreateDataModules;
begin  // of TFrmLoginDlg1.CreateDataModules
  if not Assigned (DmdFpnADOCA) then begin
    DmdFpnADOCA := TDmdFpnADOCA.Create (Application);
    // Don't keep the connection open: database is very infrequently used,
    // so release resources for unused connections
    DmdFpnADOCA.ADOConFlexPoint.KeepConnection        := False;
  end;
  if not Assigned (DmdFpnADOMenuCA) then
    DmdFpnADOMenuCA := TDmdFpnADOMenuCA.Create (Application);
end;   // of TFrmLoginDlg1.CreateDataModules
//=============================================================================
procedure TFrmLoginDlg1.EdtSecretCodeExit(Sender: TObject);
var
IdOperator : string;
SecretCode : string;
DefaultPwd : string;
begin
  inherited;
 if (EdtSecretCode.Text = '') then
   exit;
 if ((AnsiUpperCase(EdtSecretCode.Text)) = EdtLogin.Text) then begin
   MessageDlg (CtTxtDiffPwd, mtError, [mbOK], 0);
   EdtSecretCode.clear;
   EdtSecretCode.SetFocus;
   exit;
 end;
  if not PwdFormatValidation(AnsiUpperCase(EdtSecretCode.Text)) then begin
   //R2012.1 47.01 Security  A.M.(Modifications)-Start
   if PasswordFormat[3] <> 'N' then
    MessageDlg (CtTxtPwdFormat1 + inttostr(strtoint((PasswordFormat[2]+ PasswordFormat[3])))+ CtTxtPwdFormat2 + PasswordFormat[5]
        + CtTxtPwdFormat3 + PasswordFormat[7] + CtTxtPwdFormat4, mtError, [mbOK], 0)
   else
    MessageDlg (CtTxtPwdFormat1 + inttostr(strtoint((PasswordFormat[2])))+ CtTxtPwdFormat2 + PasswordFormat[6]          //R2012.1 Defect Fix 125 (CP)
        + CtTxtPwdFormat3 + PasswordFormat[4] + CtTxtPwdFormat4, mtError, [mbOK], 0);                                   //R2012.1 Defect Fix 125 (CP)
  //R2012.1 47.01 Security  A.M.(Modifications)-End
    EdtSecretCode.clear;
    EdtSecretCode.SetFocus;
    exit;
  end;

 with TIdHashMessageDigest5.Create do
   try
  SecretCode := TIdHash128.AsHex(HashValue(AnsiUpperCase(EdtSecretCode.Text)));
 if ReadDefaultPassword = 'NotRussia' then
  DefaultPwd := TIdHash128.AsHex(HashValue(CtTxtDefaultPwd))
 else
  DefaultPwd := ReadDefaultPassword;

  if DmdFpnADOMenuCA.CheckOldPwd(IdtOpr,SecretCode,strtoint(NumberOfPwd),DefaultPwd) or (SecretCode=DefaultPwd) then begin
     MessageDlg (CtTxtPwdUsed, mtError, [mbOK], 0);
     EdtSecretCode.Clear;
     EdtSecretCode.SetFocus;
  end;
   finally
    Free;
 end;
end;
//=============================================================================
function TFrmLoginDlg1.NumberOfPwd: string;
var
  Txt               : String;
  TxtSection        : String;
  IniFileInst       : TIniFile;
  TxtSystemPath     : String;
  ReasonsIniPath    : String;
  StrLstSystem      : TStringList;
begin  // of TFrmLoginDlg1.NumberOfDays

  TxtSection :=  'UsedPassword';
  IniFileInst:= nil;
  TxtSystemPath:= ReplaceEnvVar ('%SycRoot%');
  ReasonsIniPath  := '\FlexPos\Ini\fpssyst.ini';
  IniFileInst:= TIniFile.Create(TxtSystemPath+ReasonsIniPath);
   try
    OpenIniFile(TxtSystemPath+ReasonsIniPath,IniFileInst);
    StrLstSystem:=  TStringList.Create; // Create the Stringlist.

   try
     StrLstSystem.Clear;
     IniFileInst.ReadSectionValues (TxtSection , StrLstSystem);
     Txt := StrLstSystem.Values['Period'];

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
function TFrmLoginDlg1.PasswordFormat: string;
var
  Txt               : String;
  TxtSection        : String;
  IniFileInst       : TIniFile;
  TxtSystemPath     : String;
  ReasonsIniPath    : String;
  StrLstSystem      : TStringList;
begin  // of TFrmLoginDlg1.PasswordFormat

  TxtSection :=  'PasswordFormat';
  IniFileInst:= nil;
  TxtSystemPath:= ReplaceEnvVar ('%SycRoot%');
  ReasonsIniPath  := '\FlexPos\Ini\fpssyst.ini';
  IniFileInst:= TIniFile.Create(TxtSystemPath+ReasonsIniPath);
   try
    OpenIniFile(TxtSystemPath+ReasonsIniPath,IniFileInst);
    StrLstSystem:=  TStringList.Create; // Create the Stringlist.

   try
     StrLstSystem.Clear;
     IniFileInst.ReadSectionValues (TxtSection , StrLstSystem);
     Txt := StrLstSystem.Values['PassFormat'];

    except
        on E:Exception do
        raise ESvcLocalScope.Create ('ERROR ' + ReasonsIniPath + ': ' + E.Message);
    end;
  finally
    FreeAndNil(IniFileInst);
    StrLstSystem.Free;
  end;

  Result := Txt;
end;   // of TFrmLoginDlg1.PasswordFormat
//=============================================================================
function TFrmLoginDlg1.MaximumAttempts: string;
var
  Txt               : String;
  TxtSection        : String;
  IniFileInst       : TIniFile;
  TxtSystemPath     : String;
  ReasonsIniPath    : String;
  StrLstSystem      : TStringList;
begin  // of TFrmLoginDlg1.MaximumAttempts

  TxtSection :=  'MaximumAttempt';
  IniFileInst:= nil;
  TxtSystemPath:= ReplaceEnvVar ('%SycRoot%');
  ReasonsIniPath  := '\FlexPos\Ini\fpssyst.ini';
  IniFileInst:= TIniFile.Create(TxtSystemPath+ReasonsIniPath);
   try
    OpenIniFile(TxtSystemPath+ReasonsIniPath,IniFileInst);
    StrLstSystem:=  TStringList.Create; // Create the Stringlist.

   try
     StrLstSystem.Clear;
     IniFileInst.ReadSectionValues (TxtSection , StrLstSystem);
     Txt := StrLstSystem.Values['Number'];

    except
        on E:Exception do
        raise ESvcLocalScope.Create ('ERROR ' + ReasonsIniPath + ': ' + E.Message);
    end;
  finally
    FreeAndNil(IniFileInst);
    StrLstSystem.Free;
  end;

  Result := Txt;
end;   // of TFrmLoginDlg1.MaximumAttempts
//============================================================================
function TFrmLoginDlg1.ReadDefaultPassword: string;
var
  Txt               : String;
  TxtSection        : String;
  IniFileInst       : TIniFile;
  TxtSystemPath     : String;
  ReasonsIniPath    : String;
  StrLstSystem      : TStringList;
begin  // of TFrmLoginDlg1.ReadDefaultPassword

  TxtSection :=  'DefaultPwdRu';
  IniFileInst:= nil;
  TxtSystemPath:= ReplaceEnvVar ('%SycRoot%');
  ReasonsIniPath  := '\FlexPos\Ini\fpssyst.ini';
  IniFileInst:= TIniFile.Create(TxtSystemPath+ReasonsIniPath);
   try
    OpenIniFile(TxtSystemPath+ReasonsIniPath,IniFileInst);
    StrLstSystem:=  TStringList.Create; // Create the Stringlist.

   try
     StrLstSystem.Clear;
     IniFileInst.ReadSectionValues (TxtSection , StrLstSystem);
     Txt := StrLstSystem.Values['Password'];

    except
        on E:Exception do
        raise ESvcLocalScope.Create ('ERROR ' + ReasonsIniPath + ': ' + E.Message);
    end;
  finally
    FreeAndNil(IniFileInst);
    StrLstSystem.Free;
  end;

  Result := Txt;
end;   // of TFrmLoginDlg1.ReadDefaultPassword
//=============================================================================
procedure TFrmLoginDlg1.EdtSecretCodeKeyPress(Sender: TObject; var Key: Char);
begin     // of TFrmLoginDlg1.EdtSecretCodeKeyPress
  inherited;
 if (Key = #13) and (Trim (TEdit(Sender).Text) <> '') then begin
    PostMessage (TWinControl(Sender).Handle, WM_KeyDown, VK_TAB, 0);
    Key := #0;
  end
  else if (Key = #13) and (Trim (TEdit(Sender).Text) = '') then begin
   if not ValidateNewPwdfield then
    exit;
  end;
end;     // of TFrmLoginDlg1.EdtSecretCodeKeyPress
//=============================================================================
procedure TFrmLoginDlg1.EditConfirmPwdKeyPress(Sender: TObject; var Key: Char);
begin      // of TFrmLoginDlg1.EditConfirmPwdKeyPress
  inherited;
 if (Key = #13) and (Trim (TEdit(Sender).Text) <> '') then begin
    PostMessage (TWinControl(Sender).Handle, WM_KeyDown, VK_TAB, 0);
    Key := #0;
  end
  else if (Key = #13) and (Trim (TEdit(Sender).Text) = '') then begin
   if not ValidateNewPwdfield then
    exit;
  end;  
end;      // of TFrmLoginDlg1.EditConfirmPwdKeyPress
//=============================================================================
function TFrmLoginDlg1.PwdFormatValidation(PwdEntered : string): Boolean;
var
NoOfDigits,NoOfLetters, i ,Lenofpwd,NoOfOtherChars: integer ;
PwdLenInIni,NoOfLettersinIni,NoOfDigitsinIni :string;

begin
 Lenofpwd := length(PwdEntered);
 NoOfDigits := 0;
 NoOfLetters := 0;
 i:=0;                                   //Modifications for R2012.1 47.01 Security  A.M.
 NoOfOtherChars:=0;                      //Modifications for R2012.1 47.01 Security  A.M.


 for  i := 1 to length(PwdEntered) do begin
  if (PwdEntered[i]>='0') and (PwdEntered[i]<='9') then
    NoOfDigits :=  NoOfDigits + 1
  else if (ORD(PwdEntered[i])>= 65) and (ORD(PwdEntered[i])<= 90) or     //Modifications for R2012.1 47.01 Security  A.M.
  ((PwdEntered[i]) in ['É','Ö','Ó','Ê','Å','Í','Ã','Ø','Ù','Õ','Ú','À','Á','Â','Ä','Æ','¨','È','Ë','Ì','Î','Ï','Ð','Ñ','Ò','Ô','ß','Þ','Ç','Û','×','Ü']) then  //Modifications for R2012.1 47.01 Security  A.M.
    NoOfLetters := NoOfLetters + 1
  else
    NoOfOtherChars:= NoOfOtherChars + 1;
 end;
 if PasswordFormat[3] <> 'N' then begin
  PwdLenInIni:= (PasswordFormat[2]+ PasswordFormat[3]);
  NoOfLettersinIni := PasswordFormat[5];
  NoOfDigitsinIni:= PasswordFormat[7];
 end
 else begin
  PwdLenInIni := PasswordFormat[2];
  NoOfLettersinIni := PasswordFormat[4];
  NoOfDigitsinIni:= PasswordFormat[6];
 end;
  if (Lenofpwd >= strtoint(PwdLenInIni)) and (NoOfLetters >= strtoint(NoOfLettersinIni))
    and (NoOfDigits >= strtoint(NoOfDigitsinIni)) and (NoOfOtherChars = 0) then
  Result := True
  else
  Result := False;
end;
//=============================================================================
function TFrmLoginDlg1.ValidateNewPwdfield: Boolean;
begin
 Result := True;
 if (EdtSecretCode.Text = '')  then begin
    MessageDlg (CtTxtNew , mtError, [mbOK], 0);
    EdtSecretCode .SetFocus;
    Result := False;
  end
  else if (EditConfirmPwd.Text = '')  then begin
    MessageDlg (CtTxtPwdConfirm, mtError, [mbOK], 0);
    EditConfirmPwd .SetFocus;
    Result := False;
  end ;
end;
//=============================================================================
procedure TFrmLoginDlg1.FormCreate(Sender: TObject);
var
  TxtPassWordL     : string;           // PassWord Operator

begin
  inherited;
  if FlgNewAccount then begin
   EdtSecretCode.Enabled:= True;
   Label2.Enabled:= True;
   //EdtSecretCode.SetFocus;
   Label1.Enabled:= True;
   EditConfirmPwd.Enabled:= True;
   FlgNewAccount:= False;
  end; 
  EdtLogin.Text := OperatorID;
  TxtPassWordL    := EdtLogin.Text;


  IdtOpr := DmdFpnADOMenuCA.GetOperatorID (TxtPassWordL);

end;
//=============================================================================
procedure TFrmLoginDlg1.FillLoginField(loginID:string);
begin
 OperatorID:= loginID;
end;
//=============================================================================
procedure TFrmLoginDlg1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 FrmLoginDlg.Show;
 FrmLoginDlg.EdtLogin.SetFocus;
end;
//=============================================================================
end.

