//=Copyright 2009 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FDetCouponStatus.PAS : Detail of credit voucher
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCouponStatus.pas,v 1.7 2010/06/28 06:54:22 BEL\DVanpouc Exp $
// 1.1      AJ   (TCS)   R2014.1 - Req 31110 - CAFR - PromoPack Improvement - TCS(AJ)
//=============================================================================

unit FDetCouponStatus;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfDetail_BDE_DBC, ovcbase, ComCtrls, StdCtrls, Buttons, ExtCtrls, DB,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit,
  ScDBUtil_Dx, ovcef, ovcpb, ovcpf, ovcdbpf, ScDBUtil_Ovc, ScDBUtil_BDE,
  DBTables, DBCtrls, ScUtils_Dx;

resourcestring
  CtTxtInvChange = 'Statuschange not allowed';

   // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
  CtTxtCoupReasonNotSelected    = 'Validation Impossible'+
                                   #10'Please select OK';
  CtTxtReason                   = 'Reason';
   // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
//*****************************************************************************
// Global definitions
//*****************************************************************************

type
  TFrmDetCouponStatus = class(TFrmDetail)
    DscCouponStatus: TDataSource;
    SvcDBLblIdtCouponStatus: TSvcDBLabelLoaded;
    SvcDBLblTxtValCoupon: TSvcDBLabelLoaded;
    SvcDBLFIdtCouponStatus: TSvcDBLocalField;
    SvcDBMETxtValCoupon: TSvcDBMaskEdit;
    TabShtCommon: TTabSheet;
    SvcDBLblDatIssue: TSvcDBLabelLoaded;
    SvcDBLblDatDue: TSvcDBLabelLoaded;
    SvcDBLblIdtCustomer: TSvcDBLabelLoaded;
    SvcDBLblIdtClassification: TSvcDBLabelLoaded;
    SvcDBLblValCoupon: TSvcDBLabelLoaded;
    SvcDBLblFlgCountCustomer: TSvcDBLabelLoaded;
    SvcDBLblCodState: TSvcDBLabelLoaded;
    SvcDBMEDatIssue: TSvcDBMaskEdit;
    SvcDBMEDatDue: TSvcDBMaskEdit;
    SvcDBMEIdtCustomer: TSvcDBMaskEdit;
    SvcDBMEIdtClassification: TSvcDBMaskEdit;
    SvcDBMEValCoupon: TSvcDBMaskEdit;
    DBCbxFlgCountCustomer: TDBCheckBox;
    DBLkpCbxCodState: TDBLookupComboBox;
    SvcMECustomerName: TSvcMaskEdit;
    SvcMEClassDescr: TSvcMaskEdit;
    BtnSelectCustomer: TBitBtn;
    BtnSelectSubdivision: TBitBtn;
    DBLkpCbxCodReason: TDBLookupComboBox;                                       // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ
    SvcDBLblCodReason: TSvcDBLabelLoaded;                                       // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ
    procedure BtnOKClick(Sender: TObject);                                      // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ
    procedure DBLkpCbxCodStateClick(Sender: TObject);                           // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ
    procedure SvcDBMEIdtCustomerPropertiesValidate(Sender: TObject;
    var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure BtnSelectCustomerClick(Sender: TObject);
    procedure BtnSelectSubdivisionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FFlgChangeState : boolean;
    FFlgChangeReason : boolean;                                                 // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ
    FFlgStateHasChanged : boolean;
    function GetIdentForSel : string;
  protected
    { Protected declarations }
    procedure SetDataSetReferences; override;
  public
    { Public declarations }
    procedure FillQuery (QryToFill : TQuery); override;
    procedure PrepareFormDependJob; override;
    procedure PrepareDataDependJob; override;
    procedure TransactionApplied; override;
    procedure AdjustDBBeforeApply; override;
    function IsDataChanged: Boolean; override;
  published
    { Published declarations }
    property TxtIdentForSel : string read GetIdentForSel;
    property FlgChangeState: Boolean read FFlgChangeState
                                    write FFlgChangeState;
     // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
    property FlgChangeReason: Boolean read FFlgChangeReason
                                    write FFlgChangeReason;
     // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
    property FlgStateHasChanged: Boolean read FFlgStateHasChanged
                                        write FFlgStateHasChanged;
  end;

var
  FrmDetCouponStatus: TFrmDetCouponStatus;

//*****************************************************************************

implementation

uses
  SmUtils,
  SrStnCom,
  ScTskMgr_BDE_DBC,
  SmDBUtil_BDE,
  DFpnUtils,
  DFpnCouponStatusCA,
  sfdialog, DFpnCustomer;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCouponStatus';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: ';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2010/06/28 06:54:22 $';
  CtTxtSrcTag     = '$Name:  $';

//*****************************************************************************

{ TFrmDetCouponStatus }

procedure TFrmDetCouponStatus.FillQuery(QryToFill: TQuery);
begin  // of TFrmDetCouponStatus.FillQuery
  if QryToFill = DscCouponStatus.DataSet then
    if (CodJob in [CtCodJobRecNew]) then
      QryToFill.ParamByName ('PrmIdtCouponStatus').Clear
    else
      // Make record
      QryToFill.ParamByName ('PrmIdtCouponStatus').Text :=
        StrLstIdtValues.Values['IdtCouponStatus'];
end;   // of TFrmDetCouponStatus.FillQuery

//=============================================================================

procedure TFrmDetCouponStatus.FormCreate(Sender: TObject);
begin  // of TFrmDetCouponStatus.FormCreate
  SvcDBLblCodReason.Caption := CtTxtReason;
  try
    inherited;

    LstDstStartUp.Add (DscCouponStatus.DataSet);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;   // of try ... except block
end;   // of TFrmDetCouponStatus.FormCreate

//=============================================================================

procedure TFrmDetCouponStatus.PrepareFormDependJob;
begin  // of TFrmDetCouponStatus.PrepareFormDependJob
  try
    inherited;
    if FlgChangeState then begin
      SvcDBLFIdtCouponStatus.Enabled := False;
      SvcDBMETxtValCoupon.Enabled := False;
      SvcDBMEDatIssue.Enabled := False;
      SvcDBMEDatDue.Enabled := False;
      SvcDBMEIdtCustomer.Enabled := False;
      SvcDBMEIdtClassification.Enabled := False;
      SvcDBMEValCoupon.Enabled := False;
      DBCbxFlgCountCustomer.Enabled := False;
      BtnSelectCustomer.Enabled := False;
      BtnSelectSubdivision.Enabled := False;
    end;
    // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
    if FlgChangeReason then begin
      DbLkpCbxCodReason.Visible := True;
      SvcDBLblCodReason.Visible := True;
    end
    else begin
      DbLkpCbxCodReason.Visible := False;
      SvcDBLblCodReason.Visible := False;
    end;
    // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
    // Give focus to a control according to the started job
    if not (CodJob in [CtCodJobRecDel, CtCodJobRecCons]) then begin
      if not (FlgChangeState) then
        ActiveControl := SvcDBMETxtValCoupon;
    end;

  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;   // of TFrmDetCouponStatus.PrepareFormDependJob

//=============================================================================

procedure TFrmDetCouponStatus.SetDataSetReferences;
begin  // of TFrmDetCouponStatus.SetDataSetReferences
  inherited;
  DscCouponStatus.DataSet := DmdFpnCouponStatusCA.QryDetCouponStatus;
end;   // of TFrmDetCouponStatus.SetDataSetReferences

//=============================================================================

procedure TFrmDetCouponStatus.BtnSelectSubdivisionClick(Sender: TObject);
begin  // of TFrmDetCouponStatus.BitBtn1Click
  inherited;
  // Build stringlist
  StrLstRelatedIdt.Clear;
  StrLstRelatedIdt.Add ('IdtClassification=' + SvcDBMEIdtClassification.TrimText);
  if SvcTaskMgr.LaunchTask ('ListClassificationForCoupon') then begin
    // Fill in Idt-field
    SvcDBMEIdtClassification.Text :=
      StrLstRelatedIdt.Values['IdtClassification'];

    // Show Classification description
    SvcMEClassDescr.Text := StrLstRelatedInfo.Values['TxtPublDescr'];
  end;  // of SvcTaskMgr.LaunchTask (TxtLaunchTask)
end;   // of TFrmDetCouponStatus.BitBtn1Click

//=============================================================================

function TFrmDetCouponStatus.GetIdentForSel: string;
begin  // of TFrmDetCouponStatus.GetIdentForSel
  Result := TxtRecName + ' ' +
            DscCouponStatus.DataSet.FieldByName ('IdtCouponStatus').Text + ' - ' +
            DscCouponStatus.DataSet.FieldByName ('TxtValCoupon').Text;
end;   // of TFrmDetCouponStatus.GetIdentForSel

//=============================================================================

procedure TFrmDetCouponStatus.BtnSelectCustomerClick(Sender: TObject);
begin  // of BtnSelectBingoCustomIdtCoupClick
  StrLstRelatedIdt.Clear;
  StrLstRelatedIdt.Add ('IdtCustomer=');

  if not DscCouponStatus.DataSet.FieldByName ('IdtCustomer').IsNull then
    BuildStrLstFldValues (StrLstRelatedIdt, DscCouponStatus.DataSet);
  if SvcTaskMgr.LaunchTask ('ListCustomerForCoupon') then begin
    DscCouponStatus.DataSet.Edit;
    DscCouponStatus.DataSet.FieldByName ('IdtCustomer').AsInteger :=
      StrToInt(StrLstRelatedIdt.Values['IdtCustomer']);
    SvcMECustomerName.Text := StrLstRelatedInfo.Values['TxtPublName'];
  end;
end;   // of BtnSelectBingoCustomIdtCoupClick

//=============================================================================

procedure TFrmDetCouponStatus.SvcDBMEIdtCustomerPropertiesValidate(
  Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
  var Error: Boolean);
begin  // of TFrmDetCouponStatus.SvcDBMEIdtCustomerPropertiesValidate
  inherited;
  if not IsValidationNeeded (Error) then
    Exit;
  try
    if StrToInt(SvcDBMEIdtCustomer.TrimText) <> 0 then
      SvcMECustomerName.TrimText :=
        DmdFpnCustomer.InfoCustomer [StrToInt(SvcDBMEIdtCustomer.TrimText),
                                       'TxtPublName']
    else
      SvcMECustomerName.TrimText := '';

  except
    on E:Exception do begin
      ModalResult := mrNone;
      SvcMECustomerName.TrimText := '';
      Error := True;
      ErrorText := TrimTrailColon (SvcDBLblIdtCustomer.Caption) + ' ' +
                   CtTxtInvalid;
      if (not (E is ESvcNotFound)) and (E.Message <> '') then
        ErrorText := ErrorText + ' (' + E.Message + ')';
    end;
  end;
end;   // of TFrmDetCouponStatus.SvcDBMEIdtCustomerPropertiesValidate

//=============================================================================

procedure TFrmDetCouponStatus.PrepareDataDependJob;
begin  // of TFrmDetCouponStatus.PrepareDataDependJob
  inherited;
  if CodJob <> CtCodJobRecNew then begin
    SvcMECustomerName.TrimText :=
        DscCouponStatus.DataSet.FieldByName ('CustomerTxtPublName').Text;
    SvcMEClassDescr.TrimText :=
       DscCouponStatus.DataSet.FieldByName('ClassificationTxtPublDescr').Text;
  end;
  if DscCouponStatus.DataSet.FieldByName('CodState').AsInteger =
                                                 CtCodStateNotUsed then begin
    EnableDBLkpCbx(DBLkpCbxCodState);
    if FlgChangeState and (CodJob <> CtCodJobRecCons) then
      ActiveControl := DBLkpCbxCodState;
  end
  else begin
    DisableDBLkpCbx(DBLkpCbxCodState);
  end;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
  if FlgChangeReason then begin
    if DscCouponStatus.DataSet.FieldByName('CodState').AsInteger =
                                              CtCodStateDeActivated then begin
      DBLkpCbxCodReason.Enabled := True;
        ActiveControl := DBLkpCbxCodReason;
      if (DBLkpCbxCodState.KeyValue =  CtCodStateDeActivated) then
        DBLkpCbxCodReason.Enabled := False;
    end
    else begin
      DBLkpCbxCodReason.KeyValue := '';
      DBLkpCbxCodReason.Enabled := False;
    end;
  end;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
end;   // of TFrmDetCouponStatus.PrepareDataDependJob

//=============================================================================

procedure TFrmDetCouponStatus.TransactionApplied;
begin  // of TFrmDetCouponStatus.TransactionApplied
  inherited;
  // If CodState has changed or is inserted then insert record into coupstathis
  if (CodJob = CtCodJobRecNew) or
     ((CodJob = CtCodJobRecMod) and (FlgStateHasChanged)) then begin
    DmdFpnCouponStatusCA.InsertCoupStatHis(
          DscCouponStatus.DataSet.FieldByName('IdtCouponStatus').AsInteger,
          DscCouponStatus.DataSet.FieldByName('CodState').AsInteger,
          now,DmdFpnUtils.IdtOperatorCurrentOperator);
  end;
end;   // of TFrmDetCouponStatus.TransactionApplied

//=============================================================================

function TFrmDetCouponStatus.IsDataChanged: Boolean;
begin  // of TFrmDetCouponStatus.IsDataChanged
  inherited IsDataChanged; 
  if DmdFpnCouponStatusCA.QryDetCouponStatus.FieldByName('CodState').OldValue <>
    DmdFpnCouponStatusCA.QryDetCouponStatus.FieldByName('CodState').NewValue then
    FlgStateHasChanged := True

  else
    FlgStateHasChanged := False;
end;   // of TFrmDetCouponStatus.IsDataChanged

//=============================================================================

procedure TFrmDetCouponStatus.AdjustDBBeforeApply;
begin  // of TFrmDetCouponStatus.AdjustDBBeforeApply
  inherited;
   IsdataChanged;
   if FlgStateHasChanged then begin
     if DscCouponStatus.DataSet.FieldByName('CodState').AsInteger <>
                                                 CtCodStateDeActivated then begin
       if not DBLkpCbxCodState.CanFocus then
         DBLkpCbxCodState.Show;
       DBLkpCbxCodState.SetFocus;
       raise Exception.Create (CtTxtInvChange);
     end;
   end;
    // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
    if FlgChangeReason then begin
      if DscCouponStatus.DataSet.FieldByName('CodState').AsInteger <>
                                                 CtCodStateDeActivated then begin
         if not DBLkpCbxCodReason.CanFocus then
           DBLkpCbxCodReason.Show;
       end;
    end;
    // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
end;   // of TFrmDetCouponStatus.AdjustDBBeforeApply

//=============================================================================
 // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
procedure TFrmDetCouponStatus.DBLkpCbxCodStateClick(Sender: TObject);
begin
  inherited;
  if FlgChangeReason then begin
    if DBLkpCbxCodState.KeyValue =  CtCodStateDeActivated then
      DBLkpCbxCodReason.Enabled := True
    else
      DBLkpCbxCodReason.Enabled := False;
      DBLkpCbxCodReason.KeyValue:='';   
  end;
end;
 // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
//=============================================================================
 // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
procedure TFrmDetCouponStatus.BtnOKClick(Sender: TObject);
var
   ValCbxCodReason : Integer;
begin
  inherited;
  if FlgChangeReason then begin
    if (DBLkpCbxCodState.KeyValue = CtCodStateDeActivated) AND
       (DBLkpCbxCodReason.Text = '') then
    begin
      ModalResult := mrNone;
         if MessageDlg (CtTxtCoupReasonNotSelected, mtError,[mbOK],0)= mrOk then
           begin
             DBLkpCbxCodReason.SetFocus;
           end;
    end
    else begin
      if (DBLkpCbxCodState.KeyValue = CtCodStateNotUsed) then
        DscCouponStatus.DataSet.FieldByName('CodReason').AsString:='';
        ModalResult := mrOk;
     end;
  end;
end;
 // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate, CtTxtSrcTag);

end.
