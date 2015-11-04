//=Copyright 2007 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FDetCouponCA.pas
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCouponCA.pas,v 1.7 2009/09/28 14:57:22 BEL\KDeconyn Exp $
// Version  ModifiedBy  Reason
// 1.8      ARB         CAFR.2011.2.23.7.1
// 1.9      SRM  (TCS)  R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
//=============================================================================

unit FDetCouponCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetCoupon, ExtDlgs, DB, ovcbase, ComCtrls, DBCGrids, Grids, DBGrids,
  cxMaskEdit, ScUtils_Dx, StdCtrls, Buttons, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxDBEdit, ScDBUtil_Dx, ovcef, ovcpb, ovcpf, ovcdbpf, ScDBUtil_Ovc,
  DBCtrls, ScDBUtil_BDE, ExtCtrls;

resourcestring
  CtTxtMax90Days = 'is limited to 90 days.';
  CtTxtMin1Days  = 'must be more than 0 days';
  CtTxtDateFuture= 'Date must be in future.';
  CtTxtCoupZero  = 'Coupon must have a value of more than 0.';
  // CAFR.2011.2.23.7.1 ARB Start
  CtTxtCoupAlreadyActive  = 'Modification not allowed Bon D''achat is already linked to active or expied Promopack' +
                            #10'Please create a new Bon D''achat';
  // CAFR.2011.2.23.7.1 ARB End
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  CtTxtConfirmSaveCoup =  'A voucher (No. %S) with these criteria already exists.' +
                            #10'(it is recommended not to create several good'+
                            #10'with the same criteria).'+
                            #10'"OK" toconfirm your creation' +
                            #10'"Cancel" to return to the list';
  CtTxtValCoupon       = 'Value Coupon';
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End

//=============================================================================
// TFrmDetCouponCA
//=============================================================================

type
  TFrmDetCouponCA = class(TFrmDetCoupon)
    SvcDBLFDatEndValidity: TSvcDBLocalField;
    SvcDBLabelLoaded1: TSvcDBLabelLoaded;
    procedure FormCreate(Sender: TObject);
    procedure SvcDBMETxtLogoPropertiesEditValueChanged(Sender: TObject);
    procedure SvcDBLFQtyDayValidUserValidation(Sender: TObject;
      var ErrorCode: Word);
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure SetDataSetReferences; override;
  public
    { Public declarations }
    procedure PrepareFormDependJob; override;
    procedure TransactionApplied; override;
    procedure PrepareDataDependJob; override;
    procedure AdjustDBBeforeApply; override;
    procedure CheckExistingCoupon; virtual;                                     // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  end;

var
  FrmDetCouponCA: TFrmDetCouponCA;

implementation

{$R *.dfm}

uses
  DFpnCouponCA,
  SfDetail_BDE_DBC,
  SmUtils,
  OvcData,
  OvcConst,
  StStrW,
  SrStnCom,
  sfDialog,
  DFpnUtils,
  DFpnCoupon;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCouponCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: ';
  CtTxtSrcVersion = '$Revision: 1.8 $';
  CtTxtSrcDate    = '$Date: 2011/08/10 10:10:13 $';
  CtTxtSrcTag     = '$Name:  $';

//*****************************************************************************
// Implementation of TFrmDetCouponCA
//*****************************************************************************

procedure TFrmDetCouponCA.PrepareDataDependJob;
begin  // of TFrmDetCouponCA.PrepareDataDependJob
  inherited;
  if CodJob = CtCodJobRecNew then
    DscCoupon.DataSet.FieldByName('QtyDayValid').AsInteger := 30;
end;   // of TFrmDetCouponCA.PrepareDataDependJob

//=============================================================================

procedure TFrmDetCouponCA.PrepareFormDependJob;
begin  // of TFrmDetCouponCA.PrepareFormDependJob
  inherited;
  TabShtPoints.TabVisible := False;
  GbxClassification.Visible := False;
  SvcDBLblFlgCountCust.Visible := False;
  DBChxFlgCountCust.Visible := False;
  //CAFR.2011.2.23.7.1 ARB  Start
  if not (CodJob in [CtCodJobRecDel, CtCodJobRecCons]) then begin
    DisableControl(SvcDBLFIdtCoupon);     // Disable “N° bon” since its auto incremented
    ActiveControl := SvcDBMETxtPublDescr; // Put focus on the next control
    DisableControl (SvcDBMETxtLogo);      // Disable Logo Selection
    DisableControl (BtnSelectLogo);       // Disable Button Selection
  end;
  //CAFR.2011.2.23.7.1 ARB End
end;   // of TFrmDetCouponCA.PrepareFormDependJob

//=============================================================================

procedure TFrmDetCouponCA.SetDataSetReferences;
begin  // of TFrmDetCouponCA.SetDataSetReferences
  inherited;
  DscCoupon.DataSet := DmdFpnCouponCA.QryDetCoupon;
end;   // of TFrmDetCouponCA.SetDataSetReferences

//=============================================================================

procedure TFrmDetCouponCA.TransactionApplied;
begin  // of TFrmDetCouponCA.TransactionApplied
  inherited;
  DmdFpnCouponCA.InsertCouponRepl(DmdFpnCouponCA.QryDetCoupon);
end;   // of TFrmDetCouponCA.TransactionApplied

//=============================================================================

procedure TFrmDetCouponCA.SvcDBLFQtyDayValidUserValidation(Sender: TObject;
  var ErrorCode: Word);
begin  // of TFrmDetCouponCA.SvcDBLFQtyDayValidUserValidation
  try
    inherited;
    if SvcDBLFQtyDayValid.AsInteger > 90 then
      raise EAbort.Create ('');
  except
    on E:Exception do begin
      ErrorCode := oeCustomError;
      SvcDBLFQtyDayValid.Controller.ErrorText :=
        TrimTrailColon (SvcDBLblQtyDayValid.Caption) + ' ' + CtTxtMax90Days;
      if (not (E is ESvcNotFound)) and (E.Message <> '') then
        SvcDBLFQtyDayValid.Controller.ErrorText :=
          SvcDBLFQtyDayValid.Controller.ErrorText + ' (' + E.Message + ')';
    end;
  end;
  try
    if SvcDBLFQtyDayValid.AsInteger < 1 then
      raise EAbort.Create ('');
    except
    on E:Exception do begin
      ErrorCode := oeCustomError;
      SvcDBLFQtyDayValid.Controller.ErrorText :=
        TrimTrailColon (SvcDBLblQtyDayValid.Caption) + ' ' + CtTxtMin1Days;
      if (not (E is ESvcNotFound)) and (E.Message <> '') then
        SvcDBLFQtyDayValid.Controller.ErrorText :=
          SvcDBLFQtyDayValid.Controller.ErrorText + ' (' + E.Message + ')';
    end;
  end;
end;   // of TFrmDetCouponCA.SvcDBLFQtyDayValidUserValidation

//=============================================================================

procedure TFrmDetCouponCA.AdjustDBBeforeApply;
begin  // of TFrmDetCouponCA.AdjustDBBeforeApply
  //inherited; //Could not find in ARB file
    CheckExistingCoupon;                                                        // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  if (SvcDBLFDatEndValidity.EverModified) and
     (DscCoupon.DataSet.FieldByName ('DatEndValidity').AsDateTime < now) and
     (not DscCoupon.DataSet.FieldByName ('DatEndValidity').IsNull) then begin
    if not SvcDBLFDatEndValidity.CanFocus then
      SvcDBLFDatEndValidity.Show;
    SvcDBLFDatEndValidity.SetFocus;

    raise Exception.Create (CtTxtDateFuture);
  end;

 // if (SvcDBLFValCoupon.EverModified) and
 //    not (DscCoupon.DataSet.FieldByName ('ValCoupon').AsFloat > 0) then begin
  if not (DscCoupon.DataSet.FieldByName ('ValCoupon').AsFloat > 0) then begin
    if not SvcDBLFValCoupon.CanFocus then
      SvcDBLFValCoupon.Show;
    SvcDBLFValCoupon.SetFocus;

    raise Exception.Create (CtTxtCoupZero);
  end;
  //CAFR.2011.2.23.7.1 ARB  Start
  //inherited; The function had to be implemented in this class since the
  // processing logic required part of the code executed earlier to be executed
  // later
  if CodJob = CtCodJobRecNew then begin
    // Make sure that after Apply has been pressed, then Ok only saves
    // the modifications and do not try to insert anothe new record
    if (BtnApply.Enabled) and (Trim(SvcDBLFIdtCoupon.Text) ='0') then
      begin
      DscCoupon.DataSet.FieldByName ('IdtCoupon').AsString:=
      IntToStr(DmdFpnCouponCA.GetMaxIdtCoupon());
      ForceFocusChange();
      end;
    //CAFR.2011.2.23.7.1 ARB  End
    if Trim (DmdFpnUtils.IdtTradeMatrixAssort) <> '' then begin
      try
        // Perform this Update in an Except block because normaliter no
        // UPDATE statement is available
        DscCoupAssort.DataSet.Edit;
        DscCoupAssort.DataSet.FieldByName ('IdtCoupon').AsString :=
          DscCoupon.DataSet.FieldByName ('IdtCoupon').AsString;
      except
      end;
    end;

    if (DscCoupon.DataSet.FieldByName ('CodCoupon').AsInteger =
        CtCodCoupCust) then begin
      DscCoupSaved.DataSet.First;
      while not DscCoupSaved.DataSet.EOF do begin
        DscCoupSaved.DataSet.Edit;
        DscCoupSaved.DataSet.FieldByName ('IdtCoupon').AsString :=
          DscCoupon.DataSet.FieldByName ('IdtCoupon').AsString;
        DscCoupSaved.DataSet.Next;
      end;
      DscCoupSignal.DataSet.First;
      while not DscCoupSignal.DataSet.EOF do begin
        DscCoupSignal.DataSet.Edit;
      DscCoupSignal.DataSet.FieldByName ('IdtCoupon').AsString :=
        DscCoupon.DataSet.FieldByName ('IdtCoupon').AsString;
        DscCoupSignal.DataSet.Next;
      end
    end
  end
  else if CodJob = CtCodJobRecMod then begin
    if DmdFpnCouponCA.CouponOkForModify
    (DscCoupon.DataSet.FieldByName ('IdtCoupon').AsInteger) then
      raise Exception.Create (CtTxtCoupAlreadyActive);
    end;
 // end;   // of = CtCodJobRecNew
  SvcDBLFIdtCoupon.Modified := False;
  //CAFR.2011.2.23.7.1 ARB  End
end;   // of TFrmDetCouponCA.AdjustDBBeforeApply

//=============================================================================

procedure TFrmDetCouponCA.SvcDBMETxtLogoPropertiesEditValueChanged(
  Sender: TObject);
var
  TxtLogo          : string;
begin  // of TFrmDetCouponCA.SvcDBMETxtLogoPropertiesEditValueChanged
  inherited;
  if CodJob <> CtCodJobRecCons then begin
    if SvcDBMETxtLogo.TrimText <> '' then begin
      TxtLogo := ForceExtensionW (SvcDBMETxtLogo.TrimText, 'stp');
      SvcDBMETxtLogo.Text := TxtLogo;
      DscCoupon.Edit;
      DscCoupon.DataSet.FieldByName ('TxtLogo').AsString := TxtLogo;
    end;
  end;
end;   // of TFrmDetCouponCA.SvcDBMETxtLogoPropertiesEditValueChanged

//=============================================================================
// TFrmDetCouponCA.CheckExistingCoupon : Validates if new generated coupon
// already exists in database and also if it is associated with couptext table.
//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
procedure TFrmDetCouponCA.CheckExistingCoupon;
var
  TxtSQL              : string;
  FlgCouponExist      : Boolean;
  CouponId            : Integer;
begin   // of TFrmDetCouponCA.CheckExistingCoupon
  // Parameterized : if ValCoupon field is not present then exit.Valcoupon field
  // should only be visible in CAFR.
  if not Assigned(DmdFpnCoupon.SprLstCoupon.FindField('Valcoupon')) then
    exit;
  // Find in current record set of any coupon has TxtLine values
  FlgCouponExist := False;
  if (SvcDBLFQtyDayValid.Modified or
      SvcDBLFValCoupon.Modified or
      SvcDBMETxtPublDescr.EditModified) and (not FlgCurrentApplied) and
      (CodJob in [CtCodJobRecNew, CtCodJobRecMod]) then
  begin
    try
      DmdFpnCoupon.SprLstCoupon.First;
      if DmdFpnCoupon.SprLstCoupon.RecordCount > 0 then Begin
        while not DmdFpnCoupon.SprLstCoupon.Eof do begin
          if ((DmdFpnCoupon.SprLstCoupon.FieldByName('QtyDayValid').AsInteger
                = SvcDBLFQtyDayValid.AsInteger) and
               (DmdFpnCoupon.SprLstCoupon.FieldByName('ValCoupon').AsFloat
               = SvcDBLFValCoupon.AsFloat)) then begin
            if (DmdFpnCoupon.SprLstCoupon.FieldByName('TxtLine').AsString = '0') then begin
              FlgCouponExist := True;
              CouponId := DmdFpnCoupon.SprLstCoupon.FieldByName('IdtCoupon').AsInteger;
              Break;
            end;
          end;
          DmdFpnCoupon.SprLstCoupon.Next;
        end
      end
    finally
      if FlgCouponExist  then begin
        case MessageDlg(Format(CtTxtConfirmSaveCoup,
                        [Trim(FloatToStr(CouponId))]),
                         mtConfirmation,[mbOK,MbCancel], 0) of
          mrOK     : ModalResult := mrOK;
          mrCancel : ModalResult := mrCancel;
        end
      end;
      // raise exception silently if cancel is selected
      if (ModalResult = mrCancel) then
        raise EAbort.Create ('');
    end;  // end of Try
  end;  // end of if
end;   // of TFrmDetCouponCA.CheckExistingCoupon

//=============================================================================

procedure TFrmDetCouponCA.FormCreate(Sender: TObject);
begin
  inherited;
  SvcDBLblValCoupon.Caption := CtTxtValCoupon;
end;

//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate, CtTxtSrcTag);

end.
