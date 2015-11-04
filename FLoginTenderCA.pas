//========Copyright 2009 (c) Centric Retail Solutions. All rights reserved.====
// Packet   : FlexPoint
// Unit     : FLoginTenderCA = Form LOGIN in TENDER CAstorama
// Customer :  Castorama
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLoginTenderCA.pas,v 1.5 2009/09/23 10:08:59 BEL\KDeconyn Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - FLoginTenderCA - CVS revision 1.7
//=============================================================================

unit FLoginTenderCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FLoginCA, StdCtrls, Buttons, ExtCtrls;

//=============================================================================

resourcestring
  CtTxtSupervisorValid  = 'Supervisor Validation';// Supervisor validation
  CtTxtLoginLabel       = 'Enter identification'; // Identification label
  CtTxtOperatorInPause  = 'Another operator is in pause on this cashdesk';
  CtTxtNotLoggedOff     = 'Operator %s is not logged off on cashdesks %s';
  CtTxtSecretCode       = 'Secret Code';
  CtTxtInvalidLength    = '%s is invalid. Minimum length = %s';

var  // variable that contains the login message
  ViTxtLoginMessage     : string = '';
  ViTxtLoginCaption     : string = '';

const  // Possible settings for CodIsRunningOn...
  CtCodRunOnUndefined   = 0;           // Not defined where running
  CtCodRunOnBackoffice  = 1;           // Running on backoffice-PC
  CtCodRunOnCashdesk    = 2;           // Running on cashdesk
  
const  // Codes indicating functionality in application Tender Count
  CtCodFuncChange  = 1;                // Registration change money
  CtCodFuncPayIn   = 2;                // Registration PayIn
  CtCodFuncPayOut  = 3;                // Registration PayOut
  CtCodFuncCount   = 4;                // Registration Final count of drawer

//=============================================================================
// TFrmLoginTenderCA
//=============================================================================

type
  TFrmLoginTenderCA = class(TFrmLoginFpnCA)
    LblMessage: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EdtKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FValMinimumLength   : integer;
    FTxtKeyboardIni: string;         // Minimum length of secret code
    FCodRunFunc : integer;
    FViCodIsRunningOn : integer;
  public
    { Public declarations }
    function OperatorInPause: Boolean; virtual;
    function OperatorLoggedIn: Boolean; virtual;
    function LengthSecretCode: Boolean; virtual;
    function ValidateLogIn : Boolean; override;
    function ValidateInternalLogIn : Boolean; override;
    function DetermineCashDesk: Word; virtual;
  published
    property ValMinimumLength : integer read FValMinimumLength
                                       write FvalMinimumLength;
    property TxtKeyboardIni : string read FTxtKeyboardIni write FTxtKeyboardIni;
    property CodRunFunc : integer read FCodRunFunc write FCodRunFunc;
    property ViCodIsRunningOn : integer read FViCodIsRunningOn write FViCodIsRunningOn;
  end; // of TFrmLoginTenderCA


//*****************************************************************************

var
  FrmLoginTenderCA: TFrmLoginTenderCA;

implementation

{$R *.DFM}

uses
  StStrW,

  ScFile,
  SfDialog,
  SmUtils,
  DFpnUtils,
  Kassa,
  SmFile,
  SmFiler,
  SrStnCom,
  
  UFpsSyst,
  FNumericInput;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLoginTenderCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FLoginTenderCA.pas  $';
  CtTxtSrcVersion = '$Revision: 1.5 $';
  CtTxtSrcDate    = '$Date: 2009/09/23 10:08:59 $';

//*****************************************************************************
// Implementation of TFrmLoginTenderCA
//*****************************************************************************

//=============================================================================
// TFrmLoginFpn.OperatorInPause : checkes if an operator is in pause on this
//                                cashdesk
//                              ---
// FUNCRES : True = Nobody in pause, op operator in pause is registrating
//           operator; False = operator in pause is not the registrating
//           operator
//=============================================================================

function TFrmLoginTenderCA.OperatorInPause : Boolean;
var
  FIdtCashDsk      : Word;             // CashDesk
  FIdtLogIn        : string;           // Operator
begin  // of TFrmLoginTenderCA.OperatorInPause
  FIdtCashDsk := DetermineCashDesk;
  DmdFpnUtils.QueryInfo(
    #10'SELECT TxtPassword' +
    #10'FROM Operator' +
    #10'WHERE IdtCheckOut = ' + AnsiQuotedStr(IntToStr(FIdtCashDsk), ''''));
  FIdtLogIn := DmdFpnUtils.QryInfo.FieldByName('TxtPassword').AsString;
  DmdFpnUtils.CloseInfo;

  If (Length(FIdtLogIn) = 0) or (Trim(FIdtLogIn) = Trim(EdtLogin.text)) then
    Result := True
  else
    Result := False;

  if not Result then begin
    MessageDlgBtns (CtTxtOperatorInPause,mtError, ['OK'], 1, 0, 0);
    EdtLogin.Clear;
    EdtSecretCode.Clear;
    EdtLogin.SetFocus;
  end;
end;   // of TFrmLoginTenderCA.OperatorInPause

//=============================================================================
// TFrmLoginFpn.OperatorInPause : checkes if an operator is in pause on this
//                                cashdesk
//                              ---
// FUNCRES : True = Nobody in pause, op operator in pause is registrating
//           operator; False = operator in pause is not the registrating
//           operator
//=============================================================================

function TFrmLoginTenderCA.OperatorLoggedIn : Boolean;
begin  // of TFrmLoginTenderCA.OperatorLoggedIn
  try
    if DmdFpnUtils.QueryInfo
                  (#10'SELECT' +
                   #10'  IdtCheckOut' +
                   #10'FROM Operator (NOLOCK)' +
                   #10'WHERE IdtOperator = ' +
                                   AnsiQuotedStr (Trim(edtLogin.Text), '''') +
                   #10'AND NOT IdtCheckOut IS NULL') then begin
      Result := False;
    end
    else
      Result := True;

    if not Result then begin
      MessageDlgBtns (Format (CtTxtNotLoggedOff, [Trim(edtLogin.Text),
                    DmdFpnUtils.QryInfo.FieldByName('IdtCheckOut').AsString]),mtError, ['OK'], 1, 0, 0);
      EdtLogin.Clear;
      EdtSecretCode.Clear;
      EdtLogin.SetFocus;
    end;

  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmLoginTenderCA.OperatorLoggedIn

//=============================================================================

function TFrmLoginTenderCA.DetermineCashDesk : Word;
var
  NumNode          : LongInt;          // Number of the node
  RecKassa         : TKassa;           // Record for cashdesk
begin  // of TFrmLoginTenderCA.DetermineCashDesk
  Result := 0;
  try
    NumNode := MyID;
    try
      FbtOpen (CIFNKassa, FKassa, SizeOf (TKassa));
      FbtGetRec (CIFNKassa, FKassa, NumNode, RecKassa);
    except
      Exit;
    end;
  finally
    if Assigned (FKassa) then
      FbtClose (CIFNKassa, FKassa);
  end;
  Result := RecKassa.NrKassa;
end;   // of TFrmLoginTenderCA.DetermineCashDesk

//=============================================================================

function TFrmLoginTenderCA.ValidateLogIn : Boolean;
begin  // of TFrmLoginTenderCA.ValidateLogIn
  if (inherited ValidateLogin) and OperatorInPause and OperatorLoggedIn
   and LengthSecretCode then
    Result := True
  else begin
    Result := False;
    if ViFlgTouchScreen then begin
      FrmNumericInput.Free;
      FrmNumericInput := nil;
      If not assigned(FrmNumericInput) then
        FrmNumericInput := TFrmNumericInput.Create(Self);
        FrmNumericInput.TxtKeyboardIni := TxtKeyboardIni;
      FrmNumericInput.Visible := true;
      Self.SetFocus;
    end;
  end;
end;   // of TFrmLoginTenderCA.ValidateLogIn

//=============================================================================
// TFrmLoginTenderCA.ValidateInternalLogIn :
// Ignore INHERITED because we cannot internal LogIn is NOT allowed for Tender.
//=============================================================================

function TFrmLoginTenderCA.ValidateInternalLogIn : Boolean;
begin  // of TFrmLoginTender.ValidateInternalLogIn
  Result := False;
end;   // of TFrmLoginTender.ValidateInternalLogIn

//=============================================================================

procedure TFrmLoginTenderCA.FormActivate(Sender: TObject);
begin  // of TFrmLoginTenderCA.FormActivate
  inherited;
  if Trim (ViTxtLoginCaption) <> '' then
    LbLLogin.Caption := ViTxtLoginCaption
  else
  LbLLogin.Caption := CtTxtLoginLabel;
  LblMessage.Width := Width - (LblMessage.Left * 2);
  if Trim (ViTxtLoginMessage) <> '' then begin
    LblMessage.Caption := ViTxtLoginMessage;
    if not assigned(FrmNumericInput) then
      LblMessage.Height := LblMessage.Height + 15;
  end
  else begin
    LblMessage.Height := 0;
  end;
  if not assigned(FrmNumericInput) then
    Height := Height + LblMessage.Height;
  if Trim (ViTxtLoginCaption) <> '' then
    Caption := ViTxtLoginCaption;
  if ViFlgTouchScreen then begin
    if not assigned(FrmNumericInput) then begin
      FrmNumericInput := TFrmNumericInput.Create(Self);
      FrmNumericInput.TxtKeyboardIni := TxtKeyboardIni;
      FrmNumericInput.Visible := true;
      Self.SetFocus;
    end;
  end;
  DmdFpnUtils.ClearQryInfo;
  DmdFpnUtils.CloseInfo;
end;   // of TFrmLoginTenderCA.FormActivate

//=============================================================================

procedure TFrmLoginTenderCA.FormDestroy(Sender: TObject);
begin  // of TFrmLoginTenderCA.FormDestroy
  inherited;
  ViTxtLoginMessage := '';
  ViTxtLoginCaption := '';
end;   // of TFrmLoginTenderCA.FormDestroy

//=============================================================================

procedure TFrmLoginTenderCA.EdtKeyPress(Sender: TObject;
  var Key: Char);
begin  // of TFrmLoginTenderCA.EdtKeyPress
  inherited;
  if (Key = #13) and (Trim (TEdit (Sender).Text) <> '') then begin
    PostMessage (TWinControl (Sender).Handle, WM_KeyDown, VK_TAB, 0);
    Key := #0;
  end;
end;   // of TFrmLoginTenderCA.EdtKeyPress

//=============================================================================

function TFrmLoginTenderCA.LengthSecretCode: Boolean;
begin  // of TFrmLoginTenderCA.LengthSecretCode
  Result := false;
  if Length(Trim(EdtSecretCode.Text)) >= ValMinimumLength then
    Result := true;
  if not Result then begin
    MessageDlgBtns (Format(ctTxtInvalidLength,
                [CtTxtSecretCode, IntToStr(ValMinimumLength)]),mtError, ['OK'], 1, 0, 0);
    EdtSecretCode.Clear;
    EdtSecretCode.SetFocus;
  end;
end;   // of TFrmLoginTenderCA.LengthSecretCode

//=============================================================================

initialization
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.  // of TFrmLoginTenderCA
