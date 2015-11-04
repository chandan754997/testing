//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint Development
// Unit     : FDetOperatorCA.PAS : Form DETail OPERATOR
// Customer :  Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetOperatorCA.pas,v 1.6 2009/10/13 12:16:58 BEL\DVanpouc Exp $
// History:
// Version                              Modified By                          Reason
// V 1.7                                VKR (TCS)                          R2011.2 - BRES - Ficha Operator
// V 1.8                                TT(TCS)                            defect fix # 174
// V 1.9                                AM(TCS)                            R2012.1 4701 Security
// V 2.0                                SM(TCS)                            R2012.1 4701 Security
// V 2.1                                AM(TCS)                            R2012.1 4701 Security
// V 2.2                                GG(TCS)                            R2012.1 HPQC Defect 239
// V 2.3                                SM (TCS)                           R2013.1 V3 internal defect

//=============================================================================

unit FDetOperatorCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetOperator, Db, OvcBase, ComCtrls, OvcPF, ScUtils, StdCtrls, DBCtrls,
  Buttons, OvcEF, OvcPB, OvcDbPF, ExtCtrls, cxMaskEdit, ScUtils_Dx,
  ScDBUtil_Ovc, cxControls, cxContainer, cxEdit, cxTextEdit, cxDBEdit,
  ScDBUtil_Dx, ScDBUtil_BDE;

//=============================================================================
// TFrmDetOperatorCA
//=============================================================================

resourcestring // Confirmation questions when leaving Dialog Form
  CtTxtTransactionAfterCount   = 'You can''t delete this operator, a ' +
                              'transaction has been done since the last count!';
  CtTxtOpTitle                 =  'Maintenance Operator';                // defect fix # 174, BDFR/BRES, R2011.2 ,TT.(TCS)
 //R2012.1 4701 Security A.M. (TCS)- Start
  CtTxtNoInitialisation        = 'This password has been re-initialized less than ';
  CtTxtdays                    = ' days ago';
  //CtTxtDeafultPwd              = 'K1NGF1SHER';       //R2012.1 4701 Security A.M. (TCS)(Modifications)
  CtTxtNoRights                = 'you do not have the rights to re-initialize an operator at this level'; //R2012.1 47.01 Security  A.M.(Modifications)
 //R2012.1 4701 Security A.M. (TCS)- End
  CtTxtRefuseNew               =  ' You do not have rights to create new customer';  //R2012.1 4701 Security S.M. (TCS)
var
 BtnInitCodeSecretPressed : Boolean;        //R2012.1 47.01 Security  A.M.(Modifications)
 BtnCancelPressed :Boolean;                 //R2012.1 47.01 Security  A.M.(Modifications)
 BtnApplyPressed :Boolean;                  //R2013.1 V3 internal defect S.M
type
  TFrmDetOperatorCA = class(TFrmDetOperator)
    BtnInitSecretCode: TBitBtn;
    TabShtPosFunc: TTabSheet;
    ScrollBox1: TScrollBox;
    GroupBox1: TGroupBox;
    ChxBlockSale: TCheckBox;
    ChxBlockReturn: TCheckBox;
    BtnFichaOperator: TBitBtn;
    procedure BtnCancelClick(Sender: TObject);   //R2012.1 47.01 Security  A.M.(Modifications)
    procedure DBLkpCbxCodSecurityCloseUp(Sender: TObject);              // Security Point (SM), R2012.1 
    procedure BtnApplyClick(Sender: TObject);                           //Ficha Operator, VKR, R2011.2
    procedure BtnFichaOperatorClick(Sender: TObject);                   //Ficha Operator, VKR, R2011.2
    procedure DscOperatorDataChange(Sender: TObject; Field: TField);    //Ficha Operator, VKR, R2011.2
    procedure ChxBlockExit(Sender: TObject);
    procedure BtnInitSecretCodeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnAddClick(Sender: TObject);
    procedure ModifyCaption; override;                                  // defect fix # 174, BDFR/BRES, R2011.2 ,TT.(TCS)
  private
    { Private declarations }
    //Ficha Operator, VKR, R2011.2 - Start

    IdtOperator              : string;        // Operator Number
    txtName                  : string;        // Name of the operator
    CodSecurity              : string;        // Function of the operator
    FlgTenderCount           : Boolean;       // Indicates if the operator is allowed to count for
                                              // other operators in the Tender modules
    IdtLanguage              : string;        // Language of the operator
    TxtPassword              : string;        // Identification Number of the operator
    DatCreate                : TDateTime;     // date of creation
    DatModify                : TDateTime;     // date of modification
    FFlgOperatorSheet        : Boolean;      // OperatorSheet Button

    //Ficha Operator, VKR, R2011.2 - End

    FFlgNoSecretCode    : Boolean;     // Indicate if init of secret code is
                                       // allowed
    FFlgPosFunc         : Boolean;     // Indicate if posfunction are enabled
    FFlgReInitialisePwd     : Boolean;       //R2012.1 47.01 Security  A.M.(Modifications)
    procedure SetFlgNoSecretCode (Value : Boolean); virtual;
  protected
    procedure CheckPassWordBeforeSave; override;
    procedure CheckIdtOperatorBeforeSave; override;
    procedure SetDataSetReferences; override;
  public
    { Public declarations }
    procedure AdjustDataBeforeSave; override;
    procedure PrepareFormDependJob; override;
    procedure PrepareDataDependJob; override;
    procedure InitialiseAddOperator; virtual;
    function FillString(FillChar: char; Len: integer): string; virtual;
    function NumberOfDays: String; virtual;                        //R2012.1 4701 Security A.M. (TCS)

  published
  //Ficha Operator, VKR, R2011.2 - Start

     property OperatorNumber          : string  read IdtOperator
                                        write IdtOperator;
     property Name                    : string  read txtName
                                        write txtName;
     property OperatorFunction        : string read  CodSecurity
                                        write CodSecurity;
     property IsAdmin                 : Boolean read FlgTenderCount
                                        write FlgTenderCount;
     property Language                : string read  IdtLanguage
                                        write IdtLanguage;
     property IdentificationNumber    : string read  TxtPassword
                                        write TxtPassword;
     property DateCreate              : TDateTime  read DatCreate
                                        write DatCreate;
     property DateModify              : TDateTime  read DatModify
                                        write DatModify;
     property FlgOperatorSheet        : Boolean read FFlgOperatorSheet
                                        write FFlgOperatorSheet;

    //Ficha Operator, VKR, R2011.2 - End

    property FlgNoSecretCode : Boolean read FFlgNoSecretCode
                                       write SetFlgNoSecretCode;
    property FlgPosFunc : Boolean read FFlgPosFunc
                                 write FFlgPosFunc;
    property FlgReInitialisePwd : Boolean read FFlgReInitialisePwd     //R2012.1 47.01 Security  A.M.(Modifications)
                                 write FFlgReInitialisePwd;    //R2012.1 47.01 Security  A.M.(Modifications)
  end;

var
  FrmDetOperatorCA: TFrmDetOperatorCA;
  reinpassword : boolean ;                                        //R2012.1 HPQC Defect 239
//*****************************************************************************

implementation

{$R *.DFM}

uses
  DbConsts,

  ScTskMgr_BDE_DBC,            //Ficha Operator, VKR, R2011.2
  Registry,                   //R2012.1 4701 Security A.M. (TCS)
  IniFiles,                  //R2012.1 4701 Security A.M. (TCS)
  IdHash, IdHashMessageDigest, //R2012.1 47.01 Security  A.M.(TCS)
  SmUtils,
  StUtils,
  SfDialog,

  RFpnCom,
  SrStnCom,

  DFpnOperatorCA,            //R2012.1 4701 Security A.M. (TCS)
  DFpnUtils,
  SfDetail_BDE_DBC, DFpnOperator;  //R2012.1 4701 Security A.M. (TCS)

//=============================================================================
// Source-identifiers
//=============================================================================
//R2012.1 47.01 Security  A.M.(Modifications)-Start
const  // Module-name
  ViDeafultPwdRU = 'F258E2DAE67BC2ED34379158404EA5AF';
  ViDeafultPwd = 'K1NGF1SHER';
//R2012.1 47.01 Security  A.M.(Modifications)-End
const  // Module-name
  CtTxtModuleName = 'FDetOperatorCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetOperatorCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 2.3 $';
  CtTxtSrcDate    = '$Date: 2013/06/11 12:16:58 $';

//*****************************************************************************
// Implementation of TFrmDetOperatorCA
//*****************************************************************************

procedure TFrmDetOperatorCA.SetFlgNoSecretCode (Value : Boolean);
begin  // of TFrmDetOperatorCA.SetFlgNoSecretCode
  FFlgNoSecretCode := Value;
  BtnInitSecretCode.Visible := not Value;
end;   // of TFrmDetOperatorCA.SetFlgNoSecretCode

//=============================================================================

procedure TFrmDetOperatorCA.AdjustDataBeforeSave;
var
Codcheck  : string;                                                                       //System Testing Fix #146 Security Point  (SM)
begin  // of TFrmDetOperatorCA.AdjustDataBeforeSave
  // JVL CheckCodSecurityBeforeSave;
  CheckIdtOperatorBeforeSave;
  CheckPassWordBeforeSave;
  CheckIdtPOSBeforeSave;
  Codcheck := DBLkpCbxCodSecurity.Text[1];                                                 //System Testing Fix #146 Security Point  (SM)
 if (CodJob = CtCodJobRecNew) and (DmdFpnUtils.CodSecurityCurrentOperator<99) then begin                         // Security Point (SM), R2012.1 :: START
   if Codcheck = '9' then  begin                                                           //System Testing Fix #146 Security Point  (SM) ::START
   //ShowMessage (Format (CtTxtRefuseNew, [TxtName]) + '. '
   //                  );                                                                  //System Testing Fix #146 Security Point  (SM) ::END
   raise Exception.Create (CtTxtRefuseNew);
   end;
   end;                                                                                                          // Security Point (SM), R2012.1 :: END
  inherited;
end;   // of TFrmDetOperatorCA.AdjustDataBeforeSave

//=============================================================================

procedure TFrmDetOperatorCA.CheckPassWordBeforeSave;
begin  // of TFrmDetOperatorCA.CheckPassWordBeforeSave

  // Check if Password is filled in
  if (CodJob in [CtCodJobRecNew, CtCodJobRecMod]) and
     ((DscOperator.DataSet.FieldByName ('TxtPassWord').AsString = '') or
     (DscOperator.DataSet.FieldByName ('TxtPassWord').AsString = '0')) then begin
    if not SvcDBMETxtPassword.CanFocus then
      SvcDBMETxtPassword.Show;
    SvcDBMETxtPassword.SetFocus;
    raise Exception.Create (Format (SFieldRequired, [TrimTrailColon (SvcDBLblTxtPassword.Caption)]));
  end;
  // --
  if DmdFpnOperatorCA.PassWordExists
       (DscOperator.DataSet.FieldByName ('IdtOperator').AsString,
        DscOperator.DataSet.FieldByName ('TxtPassWord').AsString) then begin
    if not SvcDBMETxtPassword.CanFocus then
      SvcDBMETxtPassword.Show;
    SvcDBMETxtPassword.SetFocus;
    raise Exception.Create (CtTxtPassWordExists);
  end;
end;   // of TFrmDetOperatorCA.CheckPassWordBeforeSave

//=============================================================================
procedure TFrmDetOperatorCA.CheckIdtOperatorBeforeSave;
var
    NumOperator    : Integer;     // Variable to determine an available operator
begin  // of TFrmDetOperatorCA.CheckIdtOperatorBeforeSave

  if (SvcDBMEIdtOperator.TrimText = '') or
     (StrToInt(SvcDBMEIdtOperator.TrimText) <= 0) then begin
    NumOperator := DmdFpnUtils.GetNextCounter ('Operator', 'IdtOperator') - 1;
    repeat
      NumOperator := NumOperator + 1;
      SvcDBMEIdtOperator.Text := IntToStr(NumOperator);
      DscOperator.DataSet.FieldByName('IdtPOS').AsInteger := NumOperator;
      DscOperator.DataSet.FieldByName('IdtOperator').Text :=
              FillString('0', 3 - length(SvcDBMEIdtOperator.TrimText)) +
              SvcDBMEIdtOperator.TrimText;
    until not (DmdFpnOperatorCA.OperatorExists (SvcDBMEIdtOperator.TrimText) or
          DmdFpnOperatorCA.OperatorExists (IntToStr(NumOperator)) or
          DmdFpnOperatorCA.IdtPosExists(SvcDBMEIdtOperator.TrimText,
          DscOperator.DataSet.FieldByName ('IdtPOS').AsInteger));
  end;
  if (CodJob <> CtCodJobRecNew) or FlgCurrentApplied then
    Exit;

  if DmdFpnOperatorCA.OperatorExists (SvcDBMEIdtOperator.TrimText) then begin
    if not SvcDBMEIdtOperator.CanFocus then
      SvcDBMEIdtOperator.Show;
    SvcDBMEIdtOperator.SetFocus;
    raise Exception.Create (TrimTrailColon (SvcDBLblIdtOperator.Caption) + ' ' +
                            SvcDBMEIdtOperator.TrimText + ' ' +
                            CtTxtAlreadyExist);
  end
  else
    DscOperator.DataSet.FieldByName('IdtPos').Text :=
                          IntToStr(StrToInt(SvcDBMEIdtOperator.TrimText));
end;   // of TFrmDetOperatorCA.CheckIdtOperatorBeforeSave

//=============================================================================

procedure TFrmDetOperatorCA.PrepareDataDependJob;
var
  CodPOSFunctions  : LongInt;          // POS Functions
begin  // of TFrmDetOperatorCA.PrepareDataDependJob
  try
    inherited;
    BtnInitSecretCode.Enabled := (CodJob = CtCodJobRecMod) and
         (DscOperator.DataSet.FieldByName ('TxtSecret').AsString <> '');
    CodPOSFunctions := DscOperator.DataSet.FieldByName('CodPOSFunctions').AsInteger;
    ChxBlockSale.Checked := LongFlagIsSet(CodPOSFunctions, CtCodSaleBlocked);
    ChxBlockReturn.Checked := LongFlagIsSet(CodPOSFunctions, CtCodReturnBlocked);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;   // of try ... except block
end;   // of TFrmDetOperatorCA.PrepareDataDependJob

//=============================================================================

procedure TFrmDetOperatorCA.BtnInitSecretCodeClick(Sender: TObject);
//R2012.1 4701 Security A.M.(TCS)-Start
var
 RegKey : TRegistry;
 InIdtSupervisor : String;
 InTxtNameSupervisor: String;
 OperatorNumber : String;
 OperatorName   : String;
 CurrentDate : TDateTime;
 ModifiedDate : TDateTime;
 CodSecurity   : Integer;          // CodSecurity selected operator
 TxtPassword : String;
//R2012.1 4701 Security A.M.(TCS)-End

 begin  // of TFrmDetOperatorCA.BtnInitSecurityCodeClick
  inherited;
  reinpassword := False; //R2012.1 HPQC Defect 239  TCS-GG
//R2012.1 4701 Security A.M. (TCS) ::Start
  BtnInitCodeSecretPressed :=True;
  InIdtSupervisor := '0';
  InTxtNameSupervisor:= '0';
  CurrentDate := Now;
  //ModifiedDate := StrToDate(SvcDBLFDatModify.Text);             //commented(AM)
  OperatorNumber := SvcDBMEIdtOperator.Text;
  ModifiedDate:= DmdFpnOperatorCA.GetDatModifyFromOprReinitialise (OperatorNumber); //R2012.1 47.01 Security  A.M.(Modifications)
  OperatorName  := SvcDBMETxtName.Text;
  CodSecurity := DmdFpnOperator.InfoOperator[OperatorNumber, 'CodSecurity'];
  TxtPassword := SvcDBMETxtPassword.Text;    //R2012.1 47.01 Security  A.M.(Modifications)
  RegKey := TRegistry.Create;
  RegKey.RootKey := HKEY_CURRENT_USER;

  if RegKey.OpenKey('SOFTWARE\Sycron\Flexpoint\Menu\Logon',False)   then begin
    InIdtSupervisor := RegKey.ReadString('IdOperator') ;
    InTxtNameSupervisor := RegKey.ReadString('Name') ;
  end;
 //R2012.1 47.01 Security  A.M.(Modifications)-Start
  if (CodSecurity = 9) and  (InIdtSupervisor <> 'EXECUTEALL') then begin
   Showmessage(CtTxtNoRights);
   Exit;
  end;
 //R2012.1 47.01 Security  A.M.(Modifications)-End
  if InIdtSupervisor <> 'EXECUTEALL' then begin
   if (CurrentDate - ModifiedDate) <= strtoint(NumberOfDays) then begin
     Showmessage(CtTxtNoInitialisation + NumberOfDays + CtTxtdays);
     Exit;
    end
  end;
 //R2012.1 4701 Security A.M. (TCS) ::end
  if MessageDlg
     (Format (CtTxtConfirmResetCode,
              [DscOperator.DataSet.FieldByName ('IdtOperator').AsString + ' ' +
               DscOperator.DataSet.FieldByName ('TxtName').AsString]),
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit
  else
    reinpassword := True; //R2012.1 HPQC Defect 239 TCS-GG
 //R2012.1 4701 Security A.M. (TCS)-Start
   DscOperator.Edit;
  if CodSecurity < 9 then begin
   with TIdHashMessageDigest5.Create do
    try
  //DscOperator.DataSet.FieldByName ('TxtSecret').AsString := '';            //orignal commented by anoop

   //R2012.1 47.01 Security  A.M.(Modifications)-Start
    if FlgReInitialisePwd then begin
     DscOperator.DataSet.FieldByName ('TxtSecret').AsString := ViDeafultPwdRU
    end
    else begin
     DscOperator.DataSet.FieldByName ('TxtSecret').AsString := TIdHash128.AsHex(HashValue(ViDeafultPwd)) ;
   //R2012.1 47.01 Security  A.M.(Modifications)-.End
    end;
   //Update Flgstatus of Opeartor table to indicate that the opeartor password has been reset
     DscOperator.DataSet.FieldByName ('Flgstatus').AsString := 'R';
    finally
      Free;
    end;
  end
  else begin
    DscOperator.DataSet.FieldByName ('Flgstatus').AsString := 'A';
  end;

    BtnInitSecretCode.Enabled := False;
  //R2012.1 47.01 Security  A.M.(TCS)-Start
  //Insert the values of opeartor and supervisor in  OprReinitialise Table
    DmdFpnOperatorCA.BuildSQLInsertOprReinitialise
         (OperatorNumber,OperatorName,CurrentDate,InIdtSupervisor,InTxtNameSupervisor);
  //R2012.1 4701 Security A.M. (TCS)- End
end;   // of TFrmDetOperatorCA.BtnInitSecurityCodeClick

//=============================================================================
// FillString : Fills up a string of given Length
//  with given char
//                                  -----
// INPUT   :  FillChar = the char to fill the string with
//            Len      = The length of the returned filled string
//                                  -----
// FUNCRES :  The Filled-up-String
//=============================================================================

function TFrmDetOperatorCA.FillString(FillChar: char; Len: integer): string;
var
  Txt               : String;
  Cnt               : integer;
begin  // of TFrmDetOperatorCA.FillString
  SetLength(Txt,Len);
  for Cnt := 1 to Len do Txt[Cnt] := FillChar;
  Result := Txt;
end;   // of TFrmDetOperatorCA.FillString

//=============================================================================

procedure TFrmDetOperatorCA.FormActivate(Sender: TObject);
 begin
  inherited;
  if CodJob = CtCodJobRecNew then
    InitialiseAddOperator;
  SvcDBMEIdtOperator.Enabled := False;
  if (CodJob = CtCodJobRecNew) or (CodJob = CtCodJobRecMod) then
    SvcDBMETxtPassword.Properties.EchoMode := eemNormal
  else
    SvcDBMETxtPassword.Properties.EchoMode := eemPassWord;
  if FlgPosFunc then begin
    TabShtPosFunc.TabVisible := True;
  end;
  //Ficha Operator, VKR, R2011.2 - Start

    if FlgOperatorSheet then
    begin
      BtnFichaOperator.Visible := True;
      if (CodJob in [CtCodJobRecNew]) then
        DisableControl (BtnFichaOperator);
      if (CodJob in [CtCodJobRecMod]) then
        EnableControl (BtnFichaOperator);
      if (CodJob in [CtCodJobRecCons]) then
        EnableControl (BtnFichaOperator);
    end

   //Ficha Operator, VKR, R2011.2 - End
  else begin
    TabShtPosFunc.TabVisible := False;
  end;
end;

//=============================================================================

procedure TFrmDetOperatorCA.InitialiseAddOperator;
begin
  inherited;
  SvcDBMEIdtOperator.Text := '0';

  //First focus other control, to get focus on SvcDBMETxtName
  BtnOK.SetFocus;
  SvcDBMETxtName.SetFocus;

  While DscOperator.DataSet.FieldByName('LkpIdtLanguageTxtPublDescr').
        LookupDataSet.FieldByName('FlgMain').AsString <> '1' do begin
    DscOperator.DataSet.FieldByName('LkpIdtLanguageTxtPublDescr').LookupDataSet.next;
  end;
  DscOperator.DataSet.FieldByName('IdtLanguage').AsString := DscOperator.DataSet.
    FieldByName('LkpIdtLanguageTxtPublDescr').LookupDataSet.
    FieldByName('IdtLanguage').AsString;
end;

//=============================================================================

procedure TFrmDetOperatorCA.FormClose(Sender: TObject;
  var Action: TCloseAction);
 var                         //R2012.1 4701 Security A.M. (TCS)
  OperatorId : string;       //R2012.1 4701 Security A.M. (TCS)
  MaxSeq_No  : string;      //R2012.1 4701 Security A.M. (TCS)
begin
 //R2012.1 4701 Security A.M. (TCS)(Modifications)-Start
 OperatorId := SvcDBMEIdtOperator.Text;

  if (BtnInitCodeSecretPressed and BtnCancelPressed) and not (BtnApplyPressed) then begin  //R2013.1 V3 internal defect S.M
    MaxSeq_No := DmdFpnOperatorCA.GetSequenceNo;
    if reinpassword then            //R2012.1 HPQC Defect 239 TCS-GG
     DmdFpnOperatorCA.DeleteSQLFromOprReinitialise(MaxSeq_No);
  end;

 BtnInitCodeSecretPressed:=False;
 BtnCancelPressed :=False;
 BtnApplyPressed:=False;                                                         //R2013.1 V3 internal defect S.M
//R2012.1 4701 Security A.M. (TCS)(Modifications)-End
  if CodJob = CtCodJobRecDel then begin
    if (DmdFpnOperatorCA.TransactionAfterCount
    (DscOperator.DataSet.FieldByName ('IdtOperator').AsString,
    'SafeTransaction')) and (CodJob = CtCodJobRecDel) then begin
      MessageDlg (CtTxtTransactionAfterCount, mtConfirmation, [mbOK], 0);
      Exit;
    end
    else if (DmdFpnOperatorCA.TransactionAfterCount
    (IntToStr(DscOperator.DataSet.FieldByName ('IdtOperator').AsInteger),
    'POSTransaction')) and (CodJob = CtCodJobRecDel) then begin
      MessageDlg (CtTxtTransactionAfterCount, mtConfirmation, [mbOK], 0);
      Exit;
    end
  end;
  //SvcDBLFTxtPassword.PasswordMode := True;
 //R2012.1 4701 Security A.M. (TCS)-Start
  if CodJob = CtCodJobRecNew then begin
   with TIdHashMessageDigest5.Create do
    try
    DscOperator.Edit;
    if FlgReInitialisePwd then
     DscOperator.DataSet.FieldByName ('TxtSecret').AsString := ViDeafultPwdRU
    else
     DscOperator.DataSet.FieldByName ('TxtSecret').AsString := TIdHash128.AsHex(HashValue(ViDeafultPwd)) ;
    finally
     Free;
   end;
  end;
 //R2012.1 4701 Security A.M. (TCS)-End
  inherited;
  SvcDBMEIdtOperator.Enabled := True;
end;

//=============================================================================

procedure TFrmDetOperatorCA.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if CodJob = CtCodJobRecDel then begin
    if (DmdFpnOperatorCA.TransactionAfterCount
    (DscOperator.DataSet.FieldByName ('IdtOperator').AsString,
    'SafeTransaction')) and (CodJob = CtCodJobRecDel) then begin
      Exit;
    end
    else if (DmdFpnOperatorCA.TransactionAfterCount
    (IntToStr(DscOperator.DataSet.FieldByName ('IdtOperator').AsInteger),
    'POSTransaction')) and (CodJob = CtCodJobRecDel) then begin
      Exit;
    end
  end;
  inherited;
end;

//=============================================================================

procedure TFrmDetOperatorCA.BtnAddClick(Sender: TObject);
begin
  if Assigned (BtnApply.OnClick) then
    BtnApply.OnClick (Sender)
  else
    BtnApplyClick (Sender);

  // Restore orignial situation
  CloseAllDataSets;
  RestoreDisabledControls;
 
  // Prepare for new record
  ActiveControl := SvcDBMETxtName;
  PrepareDataDependJob;

  // Disable Apply as long as nothing has been changed.
  DisableControl (BtnApply);
  FlgDataChanged := False;
  InitialiseAddOperator;
end;

//=============================================================================

procedure TFrmDetOperatorCA.SetDataSetReferences;
begin  // of TFrmDetOperatorCA.SetDataSetReferences;
  inherited;
  DscOperator.DataSet := DmdFpnOperatorCA.QryDetOperator;
end;   // of TFrmDetOperatorCA.SetDataSetReferences;

//=============================================================================

procedure TFrmDetOperatorCA.PrepareFormDependJob;
begin  // of TFrmDetOperatorCA.PrepareFormDependJob
  try
    inherited;
    // Give focus to a control according to the started job
    if not (CodJob in [CtCodJobRecDel, CtCodJobRecCons]) then
      ActiveControl := SvcDBMETxtName;

  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;   // of try ... except block
end;   // of TFrmDetOperatorCA.PrepareFormDependJob

//=============================================================================


procedure TFrmDetOperatorCA.ChxBlockExit(Sender: TObject);
var
  CodPOSFunctions  : LongInt;          // POS Functions
begin
  inherited;
  CodPOSFunctions := 0;
  if ChxBlockSale.Checked then
    SetLongFlag(CodPOSFunctions, CtCodSaleBlocked);
  if ChxBlockReturn.Checked then
    SetLongFlag(CodPOSFunctions, CtCodReturnBlocked);
  DscOperator.DataSet.FieldByName('CodPosFunctions').AsInteger := CodPOSFunctions;
end;

//=============================================================================

//Ficha Operator, VKR, R2011.2 - Start
procedure TFrmDetOperatorCA.BtnFichaOperatorClick(Sender: TObject);
begin
  inherited;
   OperatorNumber           := SvcDBMEIdtOperator.Text;
   Name                     := SvcDBMETxtName.Text;
   OperatorFunction         := DBLkpCbxCodSecurity.Text;
   IsAdmin                  := DBChxFlgTenderCount.Checked;
   Language                 := DBLkpCbxIdtLanguage.Text;
   IdentificationNumber     := SvcDBMETxtPassword.Text;
   if (CodJob in [CtCodJobRecNew, CtCodJobRecMod]) then
    begin
      DscOperator.DataSet.Active := False;
      DmdFpnOperatorCA.QryDetOperator.ParamByName ('PrmIdtOperator').Text :=
                                                                       OperatorNumber;
      DscOperator.DataSet := DmdFpnOperatorCA.QryDetOperator;
      DscOperator.DataSet.Active := True;
      DscOperator.DataSet.Edit;
    end;
   DateCreate               := DscOperator.DataSet.FieldByName('DatCreate').AsDateTime;
   DateModify               := DscOperator.DataSet.FieldByName('DatModify').AsDateTime;
   SvcTaskMgr.LaunchTask ('FichaOperatorReport');
end;
//Ficha Operator, VKR, R2011.2 - End

//=============================================================================

//Ficha Operator, VKR, R2011.2 - Start

procedure TFrmDetOperatorCA.BtnApplyClick(Sender: TObject);
var                          //R2012.1 4701 Security A.M. (TCS)
  OperatorId : string;       //R2012.1 4701 Security A.M. (TCS)
begin
 //R2012.1 4701 Security A.M. (TCS)-Start
 BtnApplyPressed:=True;                                  //R2013.1 V3 internal defect S.M
 if CodJob = CtCodJobRecNew then begin
  with TIdHashMessageDigest5.Create do
    try
   DscOperator.Edit;
    if FlgReInitialisePwd then
     DscOperator.DataSet.FieldByName ('TxtSecret').AsString := ViDeafultPwdRU
    else
     DscOperator.DataSet.FieldByName ('TxtSecret').AsString := TIdHash128.AsHex(HashValue(ViDeafultPwd)) ;
  finally
    Free;
  end;
 end;
 //R2012.1 4701 Security A.M. (TCS)-End
  inherited;
 if FlgOperatorSheet then ;
 BtnFichaOperator.Enabled:=True;
end;

//Ficha Operator, VKR, R2011.2 - End

//=============================================================================
//Ficha Operator, VKR, R2011.2 - Start

procedure TFrmDetOperatorCA.DscOperatorDataChange(Sender: TObject; Field: TField);
begin  // of TFrmDetail.DscOperatorDataChange
  inherited;
  DscCommonDataChange (Sender, Field);
  if FlgOperatorSheet and FlgDataChanged then
    DisableControl (BtnFichaOperator);
end;   // of TFrmDetail.DscOperatorDataChange

//Ficha Operator, VKR, R2011.2 - End
//=============================================================================
//defect fix # 174, BDFR/BRES, R2011.2 ,TT.(TCS) - Start
//=============================================================================
procedure TFrmDetOperatorCA.ModifyCaption;
begin  // of TFrmDetOperatorCA.ModifyCaption
  case CodJob of
    CtCodJobRecNew  : Caption := DeleteAmpersand (CtTxtBtnCreate);
    CtCodJobRecMod  : Caption := DeleteAmpersand (CtTxtBtnModify);
    CtCodJobRecDel  : Caption := DeleteAmpersand (CtTxtBtnDelete);
    CtCodJobRecCons : Caption := DeleteAmpersand (CtTxtBtnConsult);
    else
      Caption := '';
  end;   // of case CodJob of
  Caption := CtTxtOpTitle + ' - ' + Caption + ' ' + TxtRecName;

end;   // of TFrmDetOperatorCA.ModifyCaption

//=============================================================================
//defect fix # 174, BDFR/BRES, R2011.2 ,TT.(TCS) - End
//=============================================================================
//=============================================================================
//R2012.1 4701 Security A.M. (TCS)- Start
//=============================================================================
function TFrmDetOperatorCA.NumberOfDays: String;
var
  Txt               : String;
  TxtSection        : String;
  IniFileInst       : TIniFile;
  TxtSystemPath     : String;
  ReasonsIniPath    : String;
  StrLstSystem      : TStringList;
begin  // of TFrmDetOperatorCA.NumberOfDays

  TxtSection :=  'ReInitDuration';
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
     Txt := StrLstSystem.Values['Duration'];

    except
        on E:Exception do
        raise ESvcLocalScope.Create ('ERROR ' + ReasonsIniPath + ': ' + E.Message);
    end;
  finally
    FreeAndNil(IniFileInst);
    StrLstSystem.Free;
  end;

  Result := Txt;
end;   // of TFrmDetOperatorCA.NumberOfDays
//=============================================================================
procedure TFrmDetOperatorCA.BtnCancelClick(Sender: TObject);
begin
BtnCancelPressed :=True;
end;
//=============================================================================
//R2012.1 4701 Security A.M. (TCS)- End
//=============================================================================
// Security Point (SM), R2012.1 :: START
procedure TFrmDetOperatorCA.DBLkpCbxCodSecurityCloseUp(Sender: TObject);                                      
begin
  inherited;
  if (CodJob = CtCodJobRecNew) and (DmdFpnUtils.CodSecurityCurrentOperator<99) then begin
   if DBLkpCbxCodSecurity.Text = '9=Maintenance' then
   ShowMessage (Format (CtTxtRefuseNew, [TxtName]) + '. '
                     );
  end;

end;                                                                                                          
// Security Point (SM), R2012.1 :: END
//=============================================================================
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FDetOperatorCA
