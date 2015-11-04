//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : FlexPoint
// Unit     : FLogin = Form LOGIN
// Customer   :  Castorama
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLoginCA.pas,v 1.3 2008/08/06 12:44:36 hofmansb Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - FLoginCA - CVS revision 1.3
// Version    ModifiedBy         Reason
// 1.4           AM        //R2012.1 47.01 Security  A.M.(TCS)
//=============================================================================

unit FLoginCA;

(*$Include SiCompil.IC*)

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FLogin, StdCtrls, SfLogin, Buttons, ExtCtrls;

//=============================================================================

type
  TFrmLoginFpnCA = class(TFrmLoginFpn)
    EdtSecretCode: TEdit;
    LblSecretCode: TLabel;
    procedure EdtKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FValMinimumLength   : integer;         // Minimum length of secret code    
  public
    { Public declarations }
    procedure CreateDataModules; override;
    function ValidateOperatorLogIn : Boolean; override;
    function ValidateLogIn : Boolean; override;
  published
    property ValMinimumLength : integer read FValMinimumLength
                                       write FvalMinimumLength;
  end;  // of TFrmLoginFpnCA

//*****************************************************************************

resourcestring
  CtTxtInvalidLength    = '%s is invalid. Minimum length = %s';

var
  FrmLoginFpnCA: TFrmLoginFpnCA;

implementation

uses
  SfDialog,

  SmUtils,
  SrStnCom,

  DFpnOperatorCA,
  FSplash, DFpnOperator,
  IdHash,                    //R2012.1 47.01 Security A.M. (TCS)
  IdHashMessageDigest;       //R2012.1 47.01 Security A.M. (TCS)

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLoginCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLoginCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2012/05/09 12:44:36 $';

//=============================================================================
// Implementation non-interfaced methods
//=============================================================================

procedure CreateLoginFpn;
begin  // of CreateLoginFpn
  SfLogin.FrmLoginDlg := TFrmLoginFpnCA.Create (Application);
  if Assigned (FrmSplash) then begin
    FrmSplash.Hide;
    FrmSplash.Release;
    FrmSplash := nil;
  end;
end;   // of CreateLoginFpn

//*****************************************************************************
// Implementation of TFrmLoginFpnCA
//*****************************************************************************

procedure TFrmLoginFpnCA.CreateDataModules;
begin  // of TFrmLoginFpnCA.CreateDataModules
  if not Assigned (DmdFpnOperatorCA) then
    DmdFpnOperatorCA := TDmdFpnOperatorCA.Create (Application);
  inherited;
end;   // of TFrmLoginFpnCA.CreateDataModules

//=============================================================================

function TFrmLoginFpnCA.ValidateOperatorLogIn : Boolean;
var
  TxtSecretCode    : string;           // Secret of the operator.
  IdtOperatorL     : string;           // Identification Operator
  IdtLanguageL     : string;           // Language Operator
  IdtPosL          : Integer;          // Identification POS Operator
  TxtWinUserNameL  : string;           // Windows User name Operator
  TxtNameL         : string;           // Name Operator
  TxtPassWordL     : string;           // PassWord Operator
  CodSecurityL     : Integer;          // Security code
  Password         : string;          //R2012.1 47.01 Security  A.M.(TCS)
begin  // of TFrmLoginFpnCA.ValidateOperatorLogIn
 // Result := inherited ValidateOperatorLogIn;

  IdtOperatorL    := '';
  IdtLanguageL    := '';
  IdtPosl         := 0;
  TxtWinUserNameL := '';
  TxtNameL        := '';
  TxtPassWordL    := EdtLogin.Text;
  CodSecurityL    := 0;

  if not Assigned (DmdFpnOperator) then
    CreateDataModules;
  Result := DmdFpnOperator.GetOperator (IdtOperatorL, IdtLanguageL, IdtPosL,
                                        TxtWinUserNameL, TxtNameL,
                                        TxtPassWordL, CodSecurityL);
  if Result then begin
    IdtOperator     := IdtOperatorL;
    TxtName         := TxtNameL;
    CodSecurity     := CodSecurityL;
    TxtOperLanguage := IdtLanguageL;
  end
  else begin 
    MessageDlgBtns (Caption + ' ' + CtTxtInvalid,mtError, ['OK'], 1, 0, 0);
    EdtLogin.Clear;
    EdtLogin.SetFocus;
  end;
  if Result = False then
    Exit;

  if not Assigned (DmdFpnOperatorCA) then
    CreateDataModules;

  TxtSecretCode := DmdFpnOperatorCA.GetSecretCode (IdtOperator);

  if (ValMinimumLength > 0) and (Length(Trim(EdtSecretCode.Text)) < ValMinimumLength) then begin
    MessageDlgBtns (Format(CtTxtInvalidLength,[CtTxtSecretCode,IntToStr(ValMinimumLength)]) ,
                    mtError, ['OK'], 1, 0, 0);
    EdtSecretCode.Clear;
    EdtSecretCode.SetFocus;
    Result := False;
    Exit;
  end;
 //R2012.1 47.01 Security  A.M.(TCS)-Start
  with TIdHashMessageDigest5.Create do
    try
    Password:= TIdHash128.AsHex(HashValue(AnsiUpperCase(EdtSecretCode.Text)));     //R2012.1 47.01 Security  A.M.(TCS)
 //R2012.1 47.01 Security  A.M.(TCS)-End

 // if TxtSecretCode <> EdtSecretCode.Text then begin      //R2012.1 47.01 Security  A.M.(TCS)(original commeneted)
  if TxtSecretCode <> Password then begin      //R2012.1 47.01 Security  A.M.(TCS)
    MessageDlgBtns (CtTxtSecretCode + ' ' + CtTxtInvalid,mtError, ['OK'], 1, 0, 0);
    EdtSecretCode.Clear;
    EdtSecretCode.SetFocus;
    Result := False;
  end;
    finally                                  //R2012.1 47.01 Security  A.M.(TCS)- Start
    Free;
  end;                                       //R2012.1 47.01 Security  A.M.(TCS)- End
end;   // of TFrmLoginFpnCA.ValidateOperatorLogIn

//=============================================================================

function TFrmLoginFpnCA.ValidateLogIn : Boolean;
begin  // of TFrmLoginFpnCA.ValidateLogIn
  Result := False;
  if (not ValidateInternalLogIn) and (EdtSecretCode.Text = '') then begin
    // Blanc Secret Code is not allowed
    MessageDlgBtns (CtTxtSecretCode + ' ' + CtTxtRequired,mtError, ['OK'], 1, 0, 0);
    Exit;
  end;
  Result := inherited ValidateLogIn;
end;   // of TFrmLoginFpnCA.ValidateLogIn

//=============================================================================

procedure TFrmLoginFpnCA.EdtKeyPress(Sender: TObject;
  var Key: Char);
begin  // of TFrmLoginFpnCA.EdtKeyPress
  inherited;
  if (Key = #13) and (Trim (TEdit (Sender).Text) <> '') then begin
    PostMessage (TWinControl (Sender).Handle, WM_KeyDown, VK_TAB, 0);
    Key := #0;
  end;
end;   // of TFrmLoginFpnCA.EdtKeyPress

//=============================================================================

initialization
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
  SfLogin.ViProcCreateLogin := CreateLoginFpn;

end.   // of FLoginCA
