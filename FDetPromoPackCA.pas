//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Unit   : FDetPromoPackCA.PAS : Form DETail PROMOPACK
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: $
// History:
// Version           Modified By         Reason
// V 1.29            TT    (TCS)         R2011.2 - CAFR - Logo Alerte Cible
// V 1.30            TT    (TCS)         R2011.2 - CAFR - Gestion des promopack
// V 1.31            PRG   (TCS)         R2011.2 - CAFR - Opérations multiples
// V 1.32            TT    (TCS)         R2011.2 - CAFR - Gestion des promopack - Post Integration
// V 1.33            TT    (TCS)         R2011.2 - CAFR - Defect fix 350
// V 1.34            PRG   (TCS)         R2011.2 - CAFR - Opérations Multiples - Defect#204 fix
// V 1.35            Teesta(TCS)         R2012.1 - BRES - Promopack
// V 1.36            GG    (TCS)         R2012.1 - BRES - Promopack fix
// V 1.37            Teesta(TCS)         R2011.2 - CAFR - defect_434 fix (enhancement)
// V 1.38            TK    (TCS)         R2012.1 - Applix 2388846 - All OPCO - PmntPromopackisntWorking - TCS(TK)
// V 1.39            SRM   (TCS)         R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
// V 1.40   		 MeD   (TCS)         R2014.2.51060-GOP_and_Fidelity_card_Enhancement.CAFR
// V 1.41            RC(TCS)             R2014.1 - CAFR - ALM-defect-235 fix (enhancement)
//=============================================================================

unit FDetPromoPackCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetPromoPack, ExtDlgs, DB, ovcbase, ComCtrls, Grids, DBGrids,
  StdCtrls, cxMaskEdit, ScUtils_Dx, DBCtrls, Buttons, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxDBEdit, ScDBUtil_Dx, ovcef, ovcpb, ovcpf, ovcdbpf,
  ScDBUtil_Ovc, ScDBUtil_BDE, ExtCtrls, StBarC;

//=============================================================================
// Constants
//=============================================================================

const
  // Possible values of CodTypePeriod
  CtCodFullDay   = 0;
  CtCodHappyHour = 1;
  CtCodNocturne  = 2;
  // Possible values of CodOccurence
  CtCodOccurSingle = 0;
  CtCodOccurMultiple = 1;
  // Possible values of CodCustomer
  CtCodPromoCustCard = 100;
  CtCodPromoCustNoCard = 101;
  // Possible values of CodState - Gestion des promopack, TT, R2011.2 - start
  CtCodStatInactive = 0;
  CtCodStatActive = 1;
  CtCodStatActiveSoon =2;   // R2014.1.ALM-Defect-235(enhancement).TCS-RC
  //Gestion des promopack, TT, R2011.2 - end
  CtCodDateCompareVal = -1;                                                                // Defect fix 350,TT, R2011.2 - CAFR

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtSimultPromoPack = 'There already exists a promopack for that period. ' +
                          #10'Promopack %s runs from %s to %s for %s. There ' +
                          #10'is a conflict from %s to %s with current promopack.';
 CtTxtPromoAllCustom   = 'All customers';
 CtTxtPromoCustomCard  = 'Customers with card';
 CtTxtPromoNoCard      = 'Customers without card';
 CtTxtConfDuration     = 'The difference between begindate and enddate is ' +
                         'more than 1 day.' +
                          #10'Do you want to continue?';
 CtTxtNocturne         = 'A nocturne may not be longer then one day.';
 CtTxtDatPast          = 'Promopack is (partly) in the past.';
 CtTxtAlreadyExists    = '%s already exists.';
 CtTxtErrorLength      = 'Length should be %s characters.';
 CtTxtZeroPct          = 'The discount percentage must be more than 0.';
 CtTxtNoCoup           = 'A coupon must be added to this promopack.';
 CtTxtNoBarcode        = 'Impossible to validate the %s Promopack ' +                       // Logo Alerte Cible, TT, R2011.2
                          #10'You must enter an activation code for the target %s ';        // Logo Alerte Cible, TT, R2011.2
 CtTxtBonAlert         = 'Validation impossible. You must select a gift coupon ';           // Logo Alerte Cible, TT, R2011.2
 //Gestion des promopack, TT, R2011.2 - Start
 CtTxtPromoDeactivate  = 'Confirm the deactivation by clicking on OK if not click Cancel';
 CtTxtPromoActivate    = 'Confirm the activation by clicking on OK if not click Cancel';
 CtTxtSimultPromoPackActivate = 'Activation impossible. The Promopack %s is on going';
 //Gestion des promopack - Post Integration, TT, R2011.2 - Start
 CtTxtDelErrorMsgAct   = 'Suppression impossible' +
                          #10'The Promopack %s is in progress' +
                          #10'You can only deactivate it';
 CtTxtDelErrorMsgDeact = 'Suppression impossible' +
                          #10'The Promopack %s is currently Deactivated' +
                          #10'You can only activate it';
 //Gestion des promopack - Post Integration, TT, R2011.2 - End
 CtTxtModWarnMsg       = 'Modification impossible' +
                          #10'The Promopack %s is in progress' +
                          #10'You can only deactivate it';
 //Gestion des promopack - Post Integration, TT, R2011.2 - Start
 CtTxtModActCurrMsg    = 'Modification impossible' +
                          #10'The Promopack %s is currently Deactivated' +
                          #10'You can only activate it';
 CtTxtModActFutMsg     = 'Promopack %s is deactivated' +
                          #10'To modify it, you should activate it by clicking the button "Activate"';
 //Gestion des promopack - Post Integration, TT, R2011.2 - End
 //Gestion des promopack, TT, R2011.2 - End
 CtTxtPromoTitle       = 'Maintenance PromoPack';                               //Promopack - BRES - R2012.1, Teesta
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
 // Promopack validations before save
 CtTxtMinPromoVal      =  'Validation not possible' +
                          #10'You must enter an amount'+
                          #10'(minimum %s euro)';
 CtTxtMaxPromoVal      =  'The amount before triggering the allocation'+
                          #10' of vouchers is  < %s euros.'+
                          #10' You confirm your entry?';
 CtTxtVouPerLimWarng   =  'The report'+
                          #10'amount of the purchase order / limited'+
                          #10' amount is > %s%%'+
                          #10' You confirm it?';
 CtTxtVouPerSliceWarng =  'The report'+
                          #10'amount of the voucher / Slice'+
                          #10'of purchase amount is> %s%%'+
                          #10'You confirm it?';
 CtTxtMaxDiscValue     =  'The discount amount entered is > %s%%'+
                          #10'You confirm it?'; 
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
 //R2014.2-51060-GOP_and_Fidelity_card_Enhancement.CAFR-TCS(MeD).start
 CtTxtNonCarteExists         = 'The promopack type must be the same as the promopack'+
                          #10' « Non porteurs carte Fidélité & Castorama  » N°';
 CtTxtCarteExists            = 'The promopack type must be the same as the promopack'+
                          #10' « Porteurs carte Fidélité & Castorama  » N°';

 //R2014.2-51060-GOP_and_Fidelity_card_Enhancement.CAFR-TCS(MeD).end

//=============================================================================
                 
type
  TFrmDetPromoPackCA = class(TFrmDetPromoPack)
    TabShtDate: TTabSheet;
    GroupBox1: TGroupBox;
    SvcDBLblDateBegin: TSvcDBLabelLoaded;
    SvcDBLblDateEnd: TSvcDBLabelLoaded;
    SvcDBLabelLoaded3: TSvcDBLabelLoaded;
    SvcDBLabelLoaded4: TSvcDBLabelLoaded;
    SvcDBLFDateBegin: TSvcDBLocalField;
    SvcDBLFDateEnd: TSvcDBLocalField;
    SvcDBLFHourBegin: TSvcDBLocalField;
    SvcDBLFHourEnd: TSvcDBLocalField;
    GroupBox2: TGroupBox;
    RdbtnSingleOccurence: TRadioButton;
    RdBtnMultipleOccurence: TRadioButton;
    ChkBxMonday: TCheckBox;
    ChkBxTuesday: TCheckBox;
    ChkBxWednesday: TCheckBox;
    ChkBxThursday: TCheckBox;
    ChkBxFriday: TCheckBox;
    ChkBxSaturday: TCheckBox;
    ChkBxSunday: TCheckBox;
    TabShtActBarcode: TTabSheet;
    StBrCdPromoPack: TStBarCode;
    BitBtnPrintPromoPackReport: TBitBtn;
    SvcDBLblBarcode: TSvcDBLabelLoaded;
    DBRgpTypePeriod: TDBRadioGroup;
    GbxCoupSlice: TGroupBox;
    SvcDBLabelLoaded7: TSvcDBLabelLoaded;
    SvcDBLblCoupPerSlice: TSvcDBLabelLoaded;
    SvcDBLFAmtPerSlice: TSvcDBLocalField;
    SvcDBLFCoupPerSlice: TSvcDBLocalField;
    BtnSelectCoupPerSlice: TBitBtn;
    SvcMECoupPerSliceTxtPublDescr: TSvcMaskEdit;
    GbxCoupTreshold: TGroupBox;
    SvcDBLabelLoaded6: TSvcDBLabelLoaded;
    SvcDBLblCoupTreshold1: TSvcDBLabelLoaded;
    SvcDBLabelLoaded10: TSvcDBLabelLoaded;
    SvcDBLblCoupTreshold2: TSvcDBLabelLoaded;
    SvcDBLabelLoaded12: TSvcDBLabelLoaded;
    SvcDBLblCoupTreshold3: TSvcDBLabelLoaded;
    LblIdtCurrency11: TLabel;
    LblIdtCurrency12: TLabel;
    LblIdtCurrency13: TLabel;
    SvcDBLFAmtTreshold1: TSvcDBLocalField;
    SvcDBLFAmtTreshold2: TSvcDBLocalField;
    SvcDBLFAmtTreshold3: TSvcDBLocalField;
    SvcDBLFCoupTreshold1: TSvcDBLocalField;
    BtnSelectCoupTreshold1: TBitBtn;
    SvcDBLFCoupTreshold2: TSvcDBLocalField;
    BtnSelectCoupTreshold2: TBitBtn;
    SvcDBLFCoupTreshold3: TSvcDBLocalField;
    BtnSelectCoupTreshold3: TBitBtn;
    SvcMECoupTreshold1TxtPublDescr: TSvcMaskEdit;
    SvcMECoupTreshold2TxtPublDescr: TSvcMaskEdit;
    SvcMECoupTreshold3TxtPublDescr: TSvcMaskEdit;
    SvcDBLFBarcode: TSvcDBLocalField;
    BtnActivate: TBitBtn;
    BtnDeactivate: TBitBtn;
    DscStatPromoPack: TDataSource;
    SvcDBLblPromoPackStatus: TSvcDBLabelLoaded;
    procedure BtnActivateClick(Sender: TObject);                                // Gestion des promopack, TT, R2011.2
    procedure BtnDeactivateClick(Sender: TObject);                              // Gestion des promopack, TT, R2011.2
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);           // Gestion des promopack, TT, R2011.2
    procedure FormClose(Sender: TObject; var Action: TCloseAction);             // Gestion des promopack - Post Integration, TT, R2011.2
    procedure BtnApplyClick(Sender: TObject);                                   // Logo Alerte Cible, TT, R2011.2
    procedure SvcDBLFBarcodeExit(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure DscPromoPackDataChange(Sender: TObject; Field: TField);
    procedure DBLkpCbxCodTypeExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DBRgpTypePeriodChange(Sender: TObject);
    procedure BitBtnPrintPromoPackReportClick(Sender: TObject);
    procedure RdBtnOccurenceClick(Sender: TObject);
    procedure SvcDBMETxtLogoPropertiesEditValueChanged(Sender: TObject);
    procedure ValidatePromopack;                                                // Logo Alerte Cible, TT, R2011.2
    procedure ModifyCaption; override;                                          // Promopack - BRES - R2012.1, Teesta
  private
    { Private declarations }
    BrcdPromopack            : string;     // Barcode promopack
    FIdtPromopack            : string;     // Promopack number
    FTxtDescrPromopack       : string;     // Description promopack
    FFlgActDeact             : boolean;    // Flag to record Activate/Deactivate// Gestion des promopack, TT, R2011.2
    FFlgDelMsg               : boolean;    //Gestion des promopack, TT, R2011.2
    FFlgBDES                 : Boolean;    //R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
    FFlgPromImprov           : Boolean;
    MinPromoVal              : Double;
    MaxPromoVal              : Double;
    AmntMaxDiscVal           : Double;
    AmntVouPerSliceTotTick   : Double;
    AmntVouPerMinTotTick     : Double;
    ValCoupon                : Double;
    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
  protected
    { Protected declarations }
    procedure SetDataSetReferences; override;

    procedure CouponUserValidationCaseSender
                               (    Sender                 : TObject;
                                var SvcDBLFCoupon          : TSvcDBLocalField;
                                var SvcMECouponDescription : TSvcMaskEdit;
                                var SvcDBLblCoupon         : TSvcDBLabelLoaded);
                                                                       override;
    procedure InvestCodTypeAddCaseCodType (    CodType           : Integer;
                                           var CtlPromo          : TWinControl;
                                           var FlgEnableClass    : Boolean;
                                           var FlgEnableClassInfo: Boolean    );
                                                                       override;
    procedure SelectCouponCaseSender (    Sender           : TObject;
                                      var SvcDBLFIdtCoupon : TSvcDBLocalField;
                                      var SvcMECouponDescr : TSvcMaskEdit  );
                                                                       override;
    procedure EnableBeginAndEndHour; override;
  published
    { Published declarations }
    property IdtPromoPack : string  read FIdtPromopack
                                       write FIdtPromopack;
    property BarcodePromoPack : string  read BrcdPromopack
                                       write BrcdPromopack;
    property TxtDescrPromoPack : string  read FTxtDescrPromopack
                                        write FTxtDescrPromopack;
    property FlgActDeact      : boolean  read FFlgActDeact                      // Gestion des promopack, TT, R2011.2
                                         write FFlgActDeact;                    // Gestion des promopack, TT, R2011.2
    property FlgDelMsg        : boolean  read FFlgDelMsg                        // Gestion des promopack, TT, R2011.2
                                         write FFlgDelMsg;                      // Gestion des promopack, TT, R2011.2
    property FlgBDES          : Boolean read FFlgBDES                           // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
                                         write FFlgBDES;                        // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
    property FlgPromImprov    : Boolean read FFlgPromImprov
                                        write FFlgPromImprov;
    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
  public
    { Public declarations }
    procedure PrepareDataDependJob; override;
    procedure PrepareDataDependJobAddCaseCodType (CodType : Integer); override;
    procedure PrepareFormDependJob; override;
    procedure AdjustDataBeforeSave; override;
    procedure AdjustDBBeforeApplyAdditional; override;
    procedure TransactionApplied; override;

    procedure CheckPromoAgenda(FlgActivate: Boolean = False); virtual;          // Gestion des promopack, TT, R2011.2
    procedure UpdatePromoAgenda; virtual;
    function DateIsChecked(DatToCheck: TDateTime): Boolean; virtual;
    // Validates the field values before saving it to the database
    procedure ValidatePromoValues;                                              // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    // Collecting parameters from database
    procedure GetPromoParamValues;                                              // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  end;

var
  FrmDetPromoPackCA: TFrmDetPromoPackCA;

//*****************************************************************************

implementation

{$R *.dfm}

uses
  DFpnPromoPack,
  DFpnPromoPackCA,
  SmUtils,
  StUtils,
  DateUtils,                                                                    // Defect fix 350,TT, R2011.2 - CAFR
  SrStnCom,
  SmDBUtil_BDE,
  ScTskMgr_BDE_DBC,
  DFpnUtils,
  sfDialog,
  StStrW,
  OvcData,
  OvcConst, SfDetail_BDE_DBC;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetPromoPackCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: $';
  CtTxtSrcVersion = '$Revision: 1.39';
  CtTxtSrcDate    = '$Date: 2014/03/04 03:37:36 $';

//=============================================================================

procedure TFrmDetPromoPackCA.PrepareDataDependJob;
var
  TxtDaysWeek: string;
begin  // of TFrmDetPromoPackCA.PrepareDataDependJob
  inherited;
  DBLkpCbxCodAffect.Enabled := False;
  if CodJob in [CtCodJobRecNew, CtCodJobRecMod] then begin
    DscPromoPack.DataSet.FieldByName ('CodAffect').Text :=
                                                IntToStr(CtCodPromoLevelTot);
    if CodJob = CtCodJobRecNew then begin
      DscPromoPack.DataSet.FieldByName('HouBegin').AsString := '00:00';
      DscPromoPack.DataSet.FieldByName('HouEnd').AsString := '23:59';
    end;
  end;
  DBRgpTypePeriod.ItemIndex :=
               DscPromoPack.DataSet.FieldByName ('CodTypePeriod').AsInteger;
  //Set occurence
  TxtDaysWeek := DscPromoPack.DataSet.FieldByName('TxtDaysWeek').AsString;
  if (DscPromoPack.DataSet.FieldByName('CodDaysWeek').AsString = '1') and
    (Length(TxtDaysWeek) = 7) then begin
    RdBtnMultipleOccurence.Checked := True;
    ChkBxMonday.Checked := Copy(TxtDaysWeek,1,1) = '1';
    ChkBxTuesday.Checked := Copy(TxtDaysWeek,2,1) = '1';
    ChkBxWednesday.Checked := Copy(TxtDaysWeek,3,1) = '1';
    ChkBxThursday.Checked := Copy(TxtDaysWeek,4,1) = '1';
    ChkBxFriday.Checked := Copy(TxtDaysWeek,5,1) = '1';
    ChkBxSaturday.Checked := Copy(TxtDaysWeek,6,1) = '1';
    ChkBxSunday.Checked := Copy(TxtDaysWeek,7,1) = '1';
  end
  else
    RdbtnSingleOccurence.Checked := True;
end;   // of TFrmDetPromoPackCA.PrepareDataDependJob

//=============================================================================

procedure TFrmDetPromoPackCA.PrepareFormDependJob;
begin  // of TFrmDetPromoPackCA.PrepareFormDependJob
  inherited;
  SvcDBLblFlgExclusion.Visible := False;
  DBChxFlgExclusion.Visible := False;
  SvcDBLFCharTicket.Visible := False;
  SvcDBLFTxtCharTicket.Visible := False;
  GbxClassification.Visible := False;
  GbxDates.Visible := False;
  TabShtArticle.TabVisible := False;
  TabShtClassification.TabVisible := False;
  ChkBxMonday.Checked := False;
  ChkBxTuesday.Checked := False;
  ChkBxWednesday.Checked := False;
  ChkBxThursday.Checked := False;
  ChkBxFriday.Checked := False;
  ChkBxSaturday.Checked := False;
  ChkBxSunday.Checked := False;
  DBLkpCbxCodCustomer.Enabled := True;
  FFlgActDeact := False;                                                        // Gestion des promopack, TT, R2011.2
  FFlgDelMsg := False;                                                          // Gestion des promopack, TT, R2011.2
  // Fill in CodTypePeriod
  try
    DmdFpnPromoPackCA.SprLkpCodTypePeriod.Open;
    if DmdFpnPromoPackCA.SprLkpCodTypePeriod.RecordCount > 0 then begin
      DBRgpTypePeriod.Values.Clear;
      DBRgpTypePeriod.Items.Clear;
    end;
    while not (DmdFpnPromoPackCA.SprLkpCodTypePeriod.Eof) do begin
      DBRgpTypePeriod.Values.Add(DmdFpnPromoPackCA.SprLkpCodTypePeriod.
        FieldByName('TxtFldCode').AsString);
      DBRgpTypePeriod.Items.Add(DmdFpnPromoPackCA.SprLkpCodTypePeriod.
        FieldByName('TxtChcLong').AsString);
      DmdFpnPromoPackCA.SprLkpCodTypePeriod.Next;
    end;
  finally
    DmdFpnPromoPackCA.SprLkpCodTypePeriod.Close;
    if DBRgpTypePeriod.Items.Count > 1 then
      DBRgpTypePeriod.ItemIndex := CtCodHappyHour;
  end;
end;   // of TFrmDetPromoPackCA.PrepareFormDependJob

//=============================================================================

procedure TFrmDetPromoPackCA.RdBtnOccurenceClick(Sender: TObject);
var
  FlgMultiple      : boolean;
begin  // of TFrmDetPromoPackCA.RdBtnOccurenceClick
  inherited;


  FlgMultiple := RdBtnMultipleOccurence.Checked;

  ChkBxMonday.Enabled := FlgMultiple;
  ChkBxTuesday.Enabled := FlgMultiple;
  ChkBxWednesday.Enabled := FlgMultiple;
  ChkBxThursday.Enabled := FlgMultiple;
  ChkBxFriday.Enabled := FlgMultiple;
  ChkBxSaturday.Enabled := FlgMultiple;
  ChkBxSunday.Enabled := FlgMultiple;
end;   // of TFrmDetPromoPackCA.RdBtnOccurenceClick

//=============================================================================

procedure TFrmDetPromoPackCA.BitBtnPrintPromoPackReportClick(Sender: TObject);
begin  // of TFrmDetPromoPackCA.BitBtnPrintPromoPackReportClick
  inherited;
  BrcdPromopack := SvcDBLFBarcode.Text;
  TxtDescrPromoPack := SvcDBMETxtPublDescr.TrimText;
  IdtPromoPack := SvcDBLFIdtPromoPack.Text;
  SvcTaskMgr.LaunchTask ('PrintPromopackReport');
end;   // of TFrmDetPromoPackCA.BitBtnPrintPromoPackReportClick


//=============================================================================

procedure TFrmDetPromoPackCA.AdjustDataBeforeSave;
var
  TxtDaysWeek      : string;
begin  // of TFrmDetPromoPackCA.AdjustDataBeforeSave
  inherited;
  // Check if enddate filled in
  if DscPromoPack.DataSet.FieldByName ('DatEnd').IsNull  and
     (DBRgpTypePeriod.Value <> IntToStr(CtCodNocturne))then begin
    if not SvcDBLFDatEnd.CanFocus then
      SvcDBLFDateEnd.Show;
    SvcDBLFDateEnd.SetFocus;
    raise Exception.Create (GetOrphStr (SCRequiredField));
  end;
  if RdbtnSingleOccurence.Checked then begin
    DscPromoPack.DataSet.FieldByName('CodDaysWeek').AsString := '0';
    DscPromoPack.DataSet.FieldByName('TxtDaysWeek').AsString := '1111111';
  end;
  if RdBtnMultipleOccurence.Checked then begin
    DscPromoPack.DataSet.FieldByName('CodDaysWeek').AsString := '1';
    if ChkBxMonday.Checked then
      TxtDaysWeek := TxtDaysWeek + '1'
    else
      TxtDaysWeek := TxtDaysWeek + '0';
    if ChkBxTuesday.Checked then
      TxtDaysWeek := TxtDaysWeek + '1'
    else
      TxtDaysWeek := TxtDaysWeek + '0';
    if ChkBxWednesday.Checked then
      TxtDaysWeek := TxtDaysWeek + '1'
    else
      TxtDaysWeek := TxtDaysWeek + '0';
    if ChkBxThursday.Checked then
      TxtDaysWeek := TxtDaysWeek + '1'
    else
      TxtDaysWeek := TxtDaysWeek + '0';
    if ChkBxFriday.Checked then
      TxtDaysWeek := TxtDaysWeek + '1'
    else
      TxtDaysWeek := TxtDaysWeek + '0';
    if ChkBxSaturday.Checked then
      TxtDaysWeek := TxtDaysWeek + '1'
    else
      TxtDaysWeek := TxtDaysWeek + '0';
    if ChkBxSunday.Checked then
      TxtDaysWeek := TxtDaysWeek + '1'
    else
      TxtDaysWeek := TxtDaysWeek + '0';
    DscPromoPack.DataSet.FieldByName('TxtDaysWeek').AsString := TxtDaysWeek;
  end;
  if (Integer(DBLkpCbxCodType.KeyValue) = CtCodPctAmntArt) and
     (DscPromoPack.DataSet.FieldByName ('Pct1PromoCrit').Value = 0) then begin
    if MessageDlg(CtTxtZeroPct, mtConfirmation, [mbOK], 0) = mrOK then
      raise EAbort.Create ('');
  end;

  if (Integer(DBLkpCbxCodType.KeyValue) = CtCodCoupPerSlice) and not
     (DscPromoPack.DataSet.FieldByName ('IdtCoup1PromoCrit').Value > 0) then begin
    if MessageDlg(CtTxtNoCoup, mtConfirmation, [mbOK], 0) = mrOK then
      raise EAbort.Create ('');
  end;
  if(DBRgpTypePeriod.Value = IntToStr(CtCodNocturne)) then
    if DscPromoPack.DataSet.FieldByName('HouEnd').AsDateTime >
       DscPromoPack.DataSet.FieldByName('Houbegin').AsDateTime then begin
      DscPromoPack.DataSet.FieldByName('DatEnd').AsDateTime :=
      DscPromoPack.DataSet.FieldByName('DatBegin').AsDateTime;
    end
    else begin
      DscPromoPack.DataSet.FieldByName('DatEnd').AsDateTime :=
      DscPromoPack.DataSet.FieldByName('DatBegin').AsDateTime + 1;
    end;
  if (DscPromoPack.DataSet.FieldByName('DatBegin').AsDateTime < Now() - 1) or
     (DscPromoPack.DataSet.FieldByName('DatEnd').AsDateTime < Now() - 1) then begin
    if MessageDlg(CtTxtDatPast, mtConfirmation, [mbOK], 0) = mrOK then
      raise EAbort.Create ('');
  end;
  if DscPromoPack.DataSet.FieldByName('DatEnd').AsDateTime -
     DscPromoPack.DataSet.FieldByName('DatBegin').AsDateTime > 1 then begin
    if MessageDlg(CtTxtConfDuration, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      raise EAbort.Create ('');

  end;

end;   // of TFrmDetPromoPackCA.AdjustDataBeforeSave

//=============================================================================

procedure TFrmDetPromoPackCA.UpdatePromoAgenda;
var
  DTBegin          : TDateTime;
  DTEnd            : TDateTime;
  DatTemp          : TDateTime;
begin  // of TFrmDetPromoPackCA.UpdatePromoAgenda
  DTBegin := Now;
  DTEnd   := Now;
  //Delete records for current promopack in promoagenda
  try
    DmdFpnPromoPackCA.DelSqlPromoAgenda.ParamByName('IdtPromoPack').AsInteger :=
      SvcDBLFIdtPromoPack.AsInteger;
    DmdFpnPromoPackCA.DelSqlPromoAgenda.ExecSQL;
  finally
    DmdFpnPromoPackCA.DelSqlPromoAgenda.Close;
  end;
  if CodJob = CtCodJobRecDel then
    exit;
  //Insert records for promopack
  DatTemp := SvcDBLFDateBegin.AsDateTime;
  while (DatTemp >= SvcDBLFDateBegin.AsDateTime) and
        (DatTemp <= SvcDBLFDateEnd.AsDateTime) do begin
    if (RdbtnSingleOccurence.Checked) or (RdBtnMultipleOccurence.Checked and
        DateIsChecked(DatTemp)) then begin
      //insert record 
     if (DBRgpTypePeriod.Value = IntToStr(CtCodFullDay)) then begin
        if (DatTemp = SvcDBLFDateBegin.AsDateTime) then begin                   // Opérations Multiples - Defect#204 fix PRG R2011.2
          DTBegin := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                         SvcDBLFHourBegin.AsStTime);            // Opérations Multiples - Defect#204 fix PRG R2011.2
          //Opérations Multiples - Defect#204 fix PRG R2011.2 - start
          if DTBegin < Now then
            DTBegin := Now;  //Don't start from start of day but current time
        end
          //Opérations Multiples - Defect#204 fix PRG R2011.2 - end
        else
          DTBegin := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp),0);
        if (DatTemp = SvcDBLFDateEnd.AsDateTime) then
          DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                         SvcDBLFHourEnd.AsStTime)
        else
          DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp),86399);
     end
     else begin
       if (DBRgpTypePeriod.Value = IntToStr(CtCodHappyHour)) then begin
         DTBegin := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                        SvcDBLFHourBegin.AsStTime);
         //Opérations Multiples - Defect#204 fix PRG R2011.2 - start
         if DTBegin < Now then
           DTBegin := Now;  //Don't start from start of day but current time
         //Opérations Multiples - Defect#204 fix PRG R2011.2 - end
         DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                        SvcDBLFHourEnd.AsStTime);
       end
       else begin
         //for nocturnes
         if((SvcDBLFDateBegin.AsDateTime + 1) = SvcDBLFDateEnd.AsDateTime) and
           (Dattemp = SvcDBLFDateEnd.AsDateTime) then begin
         end
         else begin
           DTBegin := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                         SvcDBLFHourBegin.AsStTime);
           //Opérations Multiples - Defect#204 fix PRG R2011.2 - start
           if DTBegin < Now then
             DTBegin := Now;  //Don't start from start of day but current time
           //Opérations Multiples - Defect#204 fix PRG R2011.2 - end
           if (SvcDBLFHourEnd.AsStTime > SvcDBLFHourbegin.AsStTime) then
             DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp),
                                          SvcDBLFHourEnd.AsStTime)
           else
             DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) + 1 ,
                                             SvcDBLFHourEnd.AsStTime);
         end;
       end;
      // execute sql-statement
      end;
      try
        if not(((SvcDBLFDateBegin.AsDateTime + 1) = SvcDBLFDateEnd.AsDateTime) and
                (Dattemp = SvcDBLFDateEnd.AsDateTime) and
                (DBRgpTypePeriod.Value = IntToStr(CtCodNocturne)) )then begin
          DmdFpnPromoPackCA.InsSqlPromoAgenda.ParamByName('IdtPromoPack').AsInteger :=
            SvcDBLFIdtPromoPack.AsInteger;
          DmdFpnPromoPackCA.InsSqlPromoAgenda.ParamByName('DatBegin').AsDateTime :=
            DTBegin;
          DmdFpnPromoPackCA.InsSqlPromoAgenda.ParamByName('DatEnd').AsDateTime :=
            DTEnd;
          DmdFpnPromoPackCA.InsSqlPromoAgenda.Prepare;
          DmdFpnPromoPackCA.InsSqlPromoAgenda.ExecSQL;
        end
      finally
        DmdFpnPromoPackCA.InsSqlPromoAgenda.Close;
      end;
    end;
    DatTemp := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) + 1, 0);
  end;
end;   // of TFrmDetPromoPackCA.UpdatePromoAgenda

//=============================================================================

function TFrmDetPromoPackCA.DateIsChecked(DatToCheck: TDateTime): Boolean;
begin  // of TFrmDetPromoPackCA.DateIsChecked
  Result := True;
  case DayOfWeek(DatToCheck) of
     1 : Result := ChkBxSunday.Checked;
     2 : Result := ChkBxMonday.Checked;
     3 : Result := ChkBxTuesday.Checked;
     4 : Result := ChkBxWednesday.Checked;
     5 : Result := ChkBxThursday.Checked;
     6 : Result := ChkBxFriday.Checked;
     7 : Result := ChkBxSaturday.Checked;
  end;
end;   // of TFrmDetPromoPackCA.DateIsChecked

//=============================================================================

procedure TFrmDetPromoPackCA.AdjustDBBeforeApplyAdditional;
begin  // of TFrmDetPromoPackCA.AdjustDBBeforeApplyAdditional
  inherited;
  if(DBRgpTypePeriod.Value <> IntToStr(CtCodNocturne)) then begin
    if(DscPromoPack.DataSet.FieldByName ('HouEnd').AsDateTime <=
       DscPromoPack.DataSet.FieldByName ('HouBegin').AsDateTime) and
      (not DscPromoPack.DataSet.FieldByName ('HouEnd').IsNull) then begin
     if not SvcDBLFHourEnd.CanFocus then
       SvcDBLFHourEnd.Show;
     SvcDBLFHourEnd.SetFocus;
     raise Exception.Create
       (Format (CtTxtGreater,
                [TrimTrailColon (SvcDBLabelLoaded4.Caption),
                 TrimTrailColon (SvcDBLabelLoaded3.Caption)]));
   end;
    if(DscPromoPack.DataSet.FieldByName ('DatEnd').AsDateTime <
       DscPromoPack.DataSet.FieldByName ('DatBegin').AsDateTime) and
      (not DscPromoPack.DataSet.FieldByName ('DatEnd').IsNull) then begin
     if not SvcDBLFDateEnd.CanFocus then
       SvcDBLFDateEnd.Show;
     SvcDBLFDateEnd.SetFocus;
     raise Exception.Create
       (Format (CtTxtLessOrEqual,
                [TrimTrailColon (SvcDBLblDateBegin.Caption),
                 TrimTrailColon (SvcDBLblDateEnd.Caption)]));
   end;
  end;
  CheckPromoAgenda;
end;   // of TFrmDetPromoPackCA.AdjustDBBeforeApplyAdditional

//=============================================================================

procedure TFrmDetPromoPackCA.CheckPromoAgenda(FlgActivate: Boolean);            //Gestion des promopack, TT, R2011.2
var
  DTBegin          : TDateTime;
  DTEnd            : TDateTime;
  DatTemp          : TDateTime;
  txtSql           : string;
  TxtError         : string;
  TxtPromoPack     : string;
  TxtCodCustomer   : string;
  TxtDatBegin      : string;
  TxtDatEnd        : string;
  TxtPADatBegin    : string;
  TxtPADatEnd      : string;
begin  // of TFrmDetPromoPackCA.CheckPromoAgenda
  DatTemp := SvcDBLFDateBegin.AsDateTime;
  // Defect fix 350,TT, R2011.2 - CAFR - Start
  if CompareDate(DatTemp, Now)= CtCodDateCompareVal then
    DatTemp := DateOf(Now);
  // Defect fix 350,TT, R2011.2 - CAFR - End
  while (DatTemp >= SvcDBLFDateBegin.AsDateTime) and
        (DatTemp <= SvcDBLFDateEnd.AsDateTime) do begin
    if (RdbtnSingleOccurence.Checked) or (RdBtnMultipleOccurence.Checked and
        DateIsChecked(DatTemp)) then begin
      //insert record
      DTBegin := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                         SvcDBLFHourBegin.AsStTime);
      if  DBRgpTypePeriod.Value = IntToStr(CtCodHappyHour) then
        DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                         SvcDBLFHourEnd.AsStTime)
      else if DBRgpTypePeriod.Value = IntToStr(CtCodFullDay) then
        DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp),             // Opérations multiples, PRG, R2011.2
                                         SvcDBLFHourEnd.AsStTime)
      else begin
       //for nocturnes
        if SvcDBLFHourEnd.AsStTime < SvcDBLFHourBegin.AsStTime then
          DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) + 1 ,
                                           SvcDBLFHourEnd.AsStTime)
        else
          DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp),
                                           SvcDBLFHourEnd.AsStTime)
      end;
    //Check in promoagenda
      txtSql :=
      'SELECT PromoAgenda.IdtPromoPack, PromoPack.DatBegin, PromoPack.DatEnd, ' +
   #10'  PromoAgenda.DatBegin as PADatBegin, ' +
   #10'  PromoAgenda.DatEnd as PADatEnd, PromoPack.TxtPublDescr,' +
   #10'  PromoPack.DatBegin, PromoPack.DatEnd, PromoPack.CodCustomer' +
   #10'FROM PromoAgenda ' +
   #10'INNER JOIN PromoPack ON ' +
   #10'  PromoPack.IdtPromoPack = PromoAgenda.IdtPromoPack ' +
      // Opérations multiples, PRG, R2011.2 - start
      // Allow date overlap for promopacks on different days of week
   #10'WHERE ' + AnsiQuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss',
                                DTBegin), '''') + ' < PromoAgenda.DatEnd ' +
   #10'AND ' + AnsiQuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss',
                              DTEnd), '''') + ' > PromoAgenda.DatBegin ' +
      // Opérations multiples, PRG, R2011.2 - end
   #10'AND PromoAgenda.IdtPromoPack <> ' + SvcDBLFIdtPromoPack.AsString;

      if (DscPromoPack.DataSet.FieldByName ('CodCustomer').AsInteger =
          CtCodPromoCustCard) then
        txtSql := txtSql + #10'AND PromoPack.CodCustomer IN (' +
                    IntToStr(CtCodPromoCustCard) + ', ' +
                    IntToStr(CtCodPromoAllCustom) + ')'
      else if (DscPromoPack.DataSet.FieldByName ('CodCustomer').AsInteger =
               CtCodPromoCustNoCard) then
        txtSql := txtSql + #10'AND PromoPack.CodCustomer IN (' +
                    IntToStr(CtCodPromoCustNoCard) + ', ' +
                    IntToStr(CtCodPromoAllCustom) + ')';
      // Opérations multiples, PRG, R2011.2 - start
      // Allow overlap for promopacks with activation barcode
      if (DscPromoPack.DataSet.FieldByName ('NumPLUActivation').AsString = '') then
        txtSql := txtSql + #10'AND PromoPack.NumPLUActivation IS NULL'
      else
        txtSql := txtSql + #10'AND PromoPack.NumPLUActivation = ' +
                  AnsiQuotedStr(DscPromoPack.DataSet.FieldByName ('NumPLUActivation').AsString,'''');
      // Consider only active promopacks
      txtSql := txtSql + #10'AND (PromoPack.CodState IS NULL OR PromoPack.CodState = ' +
                AnsiQuotedStr(IntToStr(CtCodStatActive) ,'''') ;//+ ')';  // R2014.1.ALM-Defect-235(enhancement).TCS-RC.commented
      txtSql := txtSql + #10' OR PromoPack.CodState = ' +
                AnsiQuotedStr(IntToStr(CtCodStatActiveSoon),'''') + ')';  // R2014.1.ALM-Defect-235(enhancement).TCS-RC
      // Opérations multiples, PRG, R2011.2 - end
      try
        if DmdFpnUtils.QueryInfo(txtSql) then begin
         //simultaneous promopack found
         TxtPromoPack :=
              DmdFpnUtils.QryInfo.FieldByName('IdtPromoPack').AsString + ' ' +
              DmdFpnUtils.QryInfo.FieldByName('TxtPublDescr').AsString;
         case DmdFpnUtils.QryInfo.FieldByName('CodCustomer').AsInteger of
           CtCodPromoAllCustom: TxtCodCustomer := CtTxtPromoAllCustom;
           CtCodPromoCustCard: TxtCodCustomer := CtTxtPromoCustomCard;
           CtCodPromoCustNoCard: TxtCodCustomer := CtTxtPromoNoCard;
         end;
         TxtDatBegin   := FormatDateTime(CtTxtDatFormat, DmdFpnUtils.QryInfo.
                          FieldByName('DatBegin').AsDateTime);
         TxtDatEnd     := FormatDateTime(CtTxtDatFormat, DmdFpnUtils.QryInfo.
                          FieldByName('DatEnd').AsDateTime);
         TxtPADatBegin := FormatDateTime(CtTxtDatFormat + ' ' + CtTxtHouFormatS,
                          DmdFpnUtils.QryInfo.FieldByName('PADatBegin').AsDateTime);
         TxtPADatEnd   := FormatDateTime(CtTxtDatFormat + ' ' + CtTxtHouFormatS,
                          DmdFpnUtils.QryInfo.FieldByName('PADatEnd').AsDateTime);
         //Gestion des promopack, TT, R2011.2 - start
         //Show different message if the procedure call orginated from
         //Promopack activation module
         if FlgActivate then
           TxtError      := Format (CtTxtSimultPromoPackActivate, [Trim (TxtPromoPack)])
         else
           TxtError      := Format (CtTxtSimultPromoPack, [Trim (TxtPromoPack),
                            TxtDatBegin, TxtDatEnd, LowerCase(TxtCodCustomer),
                            TxtPADatBegin, TxtPADatEnd]);
         //Gestion des promopack, TT, R2011.2 - end
         //simultaneous promopack found
          raise Exception.Create (TxtError);
        end;
      finally
        DmdFpnUtils.CloseInfo;
      end;
    end;
    DatTemp := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) + 1, 0);
    if (DBRgpTypePeriod.Value = IntToStr(CtCodNocturne)) then
      exit;
  end;
end;   // of TFrmDetPromoPackCA.CheckPromoAgenda

//=============================================================================
// GetPromoParamValues  : Collecting all the values from applicparam table
//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
Procedure TFrmDetPromoPackCA.GetPromoParamValues;
var
TxtSQL     : string;
begin  // of TFrmDetPromoPackCA.GetPromoParamValues

 if not FlgPromImprov then
   Exit;

  TxtSQL := 'Select IdtApplicParam,ValParam'+
             #10'FROM ApplicParam (NOLOCK) '+
             #10' where IdtApplicParam in (''AmntVouPerMinTotTk'','+
             #10'''AmntVouPerSliceTotTk'',''MinPromoVal'',''MaxPromoVal'','+
             #10'''AmntMaxDiscVal'')';
  try
    if DmdFpnUtils.QueryInfo(TxtSQL) then begin
      DmdFpnUtils.QryInfo.First;
     while not DmdFpnUtils.QryInfo.Eof do begin
        if DmdFpnUtils.QryInfo.FieldByName ('IdtApplicParam').AsString =
                                                      'AmntVouPerMinTotTk' then
          AmntVouPerMinTotTick := DmdFpnUtils.QryInfo.FieldByName ('ValParam').AsFloat;
        if DmdFpnUtils.QryInfo.FieldByName ('IdtApplicParam').AsString
                                                  = 'AmntVouPerSliceTotTk' then
          AmntVouPerSliceTotTick := DmdFpnUtils.QryInfo.FieldByName ('ValParam').AsFloat;
        if DmdFpnUtils.QryInfo.FieldByName ('IdtApplicParam').AsString = 'AmntMaxDiscVal' then
          AmntMaxDiscVal := DmdFpnUtils.QryInfo.
                                 FieldByName ('ValParam').AsFloat;
        if DmdFpnUtils.QryInfo.FieldByName ('IdtApplicParam').AsString
                                                           = 'MinPromoVal' then
          MinPromoVal := DmdFpnUtils.QryInfo.FieldByName ('ValParam').AsFloat;
        if DmdFpnUtils.QryInfo.FieldByName ('IdtApplicParam').AsString = 'MaxPromoVal' then
          MaxPromoVal := DmdFpnUtils.QryInfo.
                                 FieldByName ('ValParam').AsFloat;
        DmdFpnUtils.QryInfo.Next;
      end;   // end of while
    end  // end of if
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;  //of TFrmDetPromoPackCA.GetPromoParamValues

//=============================================================================
// ValidatePromoValues : Validates the field values before saving it to the
//                       database
//=============================================================================
Procedure TFrmDetPromoPackCA.ValidatePromoValues;
Procedure GetCouponValue;
var
 TxtSQL    : string;
begin
  // finding the value of a coupon
  TxtSQL := '';
  TxtSQL := 'Select IdtCoupon,Valcoupon from coupon (NOLOCK) '+
            #10' where IdtCoupon ='+QuotedStr(SvcDBLFCoupPerSlice.AsString);
  try
    if DmdFpnUtils.QueryInfo(TxtSQL) then begin
      DmdFpnUtils.QryInfo.First;
      while not DmdFpnUtils.QryInfo.Eof do begin
        if (DmdFpnUtils.QryInfo.FieldByName('IdtCoupon').AsInteger =
          SvcDBLFCoupPerSlice.AsInteger) then begin
          ValCoupon := DmdFpnUtils.QryInfo.FieldByName('ValCoupon').AsFloat;
          DmdFpnUtils.QryInfo.Next;
        end;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;

//=============================================================================
var     
 AmtPerSlice : Double;
begin  // of TFrmDetPromoPackCA.ValidatePromoValues
  if not FlgPromImprov then
    Exit;
  // get the default values
  GetCouponValue;

  AmtPerSlice := DmdFpnPromoPackCA.
                 QryDetPromoPack.FieldByName('Val1PromoCrit').AsCurrency;
  // Warnig to put Minimum value
  if (AmtPerSlice < MinPromoVal) then begin
    if (DBLkpCbxCodType.KeyValue <> CtCodPctAmntArt) then begin
      if (DBLkpCbxCodType.KeyValue = CtCodCoupPerSlice) then begin
        if not SvcDBLFAmtPerSlice.CanFocus then
          SvcDBLFAmtPerSlice.Show;
        SvcDBLFAmtPerSlice.SetFocus;
      end
      else if (DBLkpCbxCodType.KeyValue = CtCodCoupTresHold) then begin
        if not SvcDBLFAmtTreshold1.CanFocus then
          SvcDBLFAmtTreshold1.Show;
        SvcDBLFAmtTreshold1.SetFocus;
      end;
      ModalResult := mrNone;
      MessageDlg(Format(CtTxtMinPromoVal,[Trim(FloatToStr(MinPromoVal))]),
                         mtError,[mbOK], 0);
      // raise exception silently if cancel is selected
        raise EAbort.Create ('');
    end;
  end;
  // Warning if Maximum limited value exceeds
  if (AmtPerSlice > MinPromoVal) and (AmtPerSlice < MaxPromoVal) then begin
    if (DBLkpCbxCodType.KeyValue <> CtCodPctAmntArt) then begin
      if (DBLkpCbxCodType.KeyValue = CtCodCoupPerSlice) then begin
        if not SvcDBLFAmtPerSlice.CanFocus then
          SvcDBLFAmtPerSlice.Show;
        SvcDBLFAmtPerSlice.SetFocus;
      end
      else if (DBLkpCbxCodType.KeyValue = CtCodCoupTresHold) then begin
        if not SvcDBLFAmtTreshold1.CanFocus then
          SvcDBLFAmtTreshold1.Show;
        SvcDBLFAmtTreshold1.SetFocus;
      end;
      ModalResult := mrNone;
      case MessageDlg(Format(CtTxtMaxPromoVal,[Trim(FloatToStr(MaxPromoVal))]),
                         mtConfirmation,[mbYes,mbNo], 0) of
       mrYes  : ModalResult := mrOK;
       mrNo   : ModalResult := mrNone;
      end;
      // raise exception silently if cancel is selected
      if (ModalResult = mrNone) then begin
        raise EAbort.Create ('');
      end;
    end;
  end;
  // Warnig if Maximum value for % discount exceeds
  if (SvcDBLFPctOnLimValPctPromo.AsFloat > AmntMaxDiscVal) then begin
    if not SvcDBLFPctOnLimValPctPromo.CanFocus then
      SvcDBLFPctOnLimValPctPromo.Show;
    SvcDBLFPctOnLimValPctPromo.SetFocus;
    ModalResult := mrNone;
    case MessageDlg(Format(CtTxtMaxDiscValue,[Trim(FloatToStr(AmntMaxDiscVal))]),
                       mtConfirmation,[mbYes,mbNo], 0) of
      mrYes  : ModalResult := mrOK;
      mrNo   : ModalResult := mrNone;
    end;
    // raise exception silently if cancel is selected
    if (ModalResult = mrNone) then
      raise EAbort.Create ('');
  end;
  // Warning if the amount of voucher type / minimum of total ticket exceeds
  if (DBLkpCbxCodType.KeyValue = CtCodCoupPerSlice) then begin
    if (((ValCoupon/AmtPerSlice) * 100) >
         AmntVouPerMinTotTick)  then begin
      if not SvcDBLFCoupPerSlice.CanFocus then
        SvcDBLFCoupPerSlice.Show;
      SvcDBLFCoupPerSlice.SetFocus;
      ModalResult := mrNone;
      case MessageDlg(Format(CtTxtVouPerLimWarng,
                      [Trim(FloatToStr(AmntVouPerMinTotTick))]),
                      mtConfirmation,[mbYes,mbNo], 0) of
        mrYes  : ModalResult := mrOK;
        mrNo   : ModalResult := mrNone;
      end;
      if (ModalResult = mrNone) then begin
        raise EAbort.Create ('');
      end
    end
  end;
  // Warning if amount of voucher type / slice of total ticket exceeds
  if (DBLkpCbxCodType.KeyValue = CtCodCoupTresHold) then begin
    if (((ValCoupon/AmtPerSlice) * 100) >
       AmntVouPerSliceTotTick)  then begin
      if not SvcDBLFCoupTreshold1.CanFocus then
        SvcDBLFCoupTreshold1.Show;
      SvcDBLFCoupTreshold1.SetFocus;
      ModalResult := mrNone;
      case MessageDlg(Format(CtTxtVouPerSliceWarng,
                       [Trim(FloatToStr(AmntVouPerSliceTotTick))]),
                       mtConfirmation,[mbYes,mbNo], 0) of
        mrYes  : ModalResult := mrOK;
        mrNo   : ModalResult := mrNone;
      end;
      if (ModalResult = mrNone) then begin
        raise EAbort.Create ('');
      end;
    end
  end;
end;   // of TFrmDetPromoPackCA.ValidatePromoValues
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
//=============================================================================

procedure TFrmDetPromoPackCA.TransactionApplied;
begin  // of TFrmDetPromoPackCA.TransactionApplied
  inherited;
  UpdatePromoAgenda;
  DmdFpnPromoPackCA.InsertPromoPackRepl(DmdFpnPromoPackCA.QryDetPromoPack);
end;   // of TFrmDetPromoPackCA.TransactionApplied

//=============================================================================

procedure TFrmDetPromoPackCA.DBRgpTypePeriodChange(Sender: TObject);
begin  // of TFrmDetPromoPackCA.DBRgpTypePeriodChange
  inherited;
  DscPromoPack.Edit;
  if DBRgpTypePeriod.Value = IntToStr(CtCodNocturne) then begin
    SvcDBLFDateEnd.Enabled := False;
    RdBtnMultipleOccurence.Checked := False;
    RdBtnSingleOccurence.Checked := True;
    RdBtnMultipleOccurence.Enabled := False;
    RdBtnOccurenceClick(sender);
  end
end;   // of TFrmDetPromoPackCA.DBRgpTypePeriodChange

//=============================================================================

procedure TFrmDetPromoPackCA.InvestCodTypeAddCaseCodType(CodType: Integer;
  var CtlPromo: TWinControl; var FlgEnableClass, FlgEnableClassInfo: Boolean);
begin  // of TFrmDetPromoPackCA.InvestCodTypeAddCaseCodType
  inherited;
  case DscPromoPack.DataSet.FieldByName ('CodType').AsInteger of
    CtCodPctAmntArt : CtlPromo := GbxPromoPctOnLimVal;
    CtCodCoupPerSlice : CtlPromo := GbxCoupSlice;
    CtCodCoupTresHold : CtlPromo := GbxCoupTreshold; 
  end;
end;   // of TFrmDetPromoPackCA.InvestCodTypeAddCaseCodType

//=============================================================================

procedure TFrmDetPromoPackCA.SelectCouponCaseSender(Sender: TObject;
  var SvcDBLFIdtCoupon: TSvcDBLocalField; var SvcMECouponDescr: TSvcMaskEdit);
begin  // of TFrmDetPromoPackCA.SelectCouponCaseSender
  inherited;
  if Sender = BtnSelectCoupTreshold1 then begin
    SvcDBLFIdtCoupon := SvcDBLFCoupTreshold1;
    SvcMECouponDescr := SvcMECoupTreshold1TxtPublDescr;
  end
  else if Sender = BtnSelectCoupTreshold2 then begin
    SvcDBLFIdtCoupon := SvcDBLFCoupTreshold2;
    SvcMECouponDescr := SvcMECoupTreshold2TxtPublDescr;
  end
  else if Sender = BtnSelectCoupTreshold3 then begin
    SvcDBLFIdtCoupon := SvcDBLFCoupTreshold3;
    SvcMECouponDescr := SvcMECoupTreshold3TxtPublDescr;
  end
  else if Sender = BtnSelectCoupPerSlice then begin
    SvcDBLFIdtCoupon := SvcDBLFCoupPerSlice;
    SvcMECouponDescr := SvcMECoupPerSliceTxtPublDescr;
  end;
end;   // of TFrmDetPromoPackCA.SelectCouponCaseSender

//=============================================================================

procedure TFrmDetPromoPackCA.SetDataSetReferences;
begin  // of TFrmDetPromoPackCA.SetDataSetReferences
  inherited;
  DscPromoPack.DataSet     := DmdFpnPromoPackCA.QryDetPromoPack;
end;   // of TFrmDetPromoPackCA.SetDataSetReferences

//=============================================================================

procedure TFrmDetPromoPackCA.FormActivate(Sender: TObject);
var
  IdtCurrency      : string;           // Abbreviation currency
begin  // of TFrmDetPromoPackCA.FormActivate
  inherited;
  IdtCurrency := SprRTCurrency.FieldByName ('IdtCurrency').AsString;
  LblIdtCurrency11.Caption := IdtCurrency;
  LblIdtCurrency12.Caption := IdtCurrency;
  LblIdtCurrency13.Caption := IdtCurrency;
  if FlgBDES then                                                                         //R2012.1 BDES PromoPack - Internal defect Fix Cycle 3         
  SvcDBLFBarcode.Left:=160;                                                               //R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
  if (SvcDBLFDateEnd.asdatetime > 0) and (SvcDBLFDateEnd.asdatetime < (now()-1))
  then begin
    DBLkpCbxCodCustomer.Enabled := False;
    ChkbxMonday.Enabled := False;
    ChkBxTuesday.Enabled := False;
    ChkBxWednesday.Enabled := False;
    ChkBxThursday.Enabled := False;
    ChkBxFriday.Enabled := False;
    ChkBxSaturday.Enabled := False;
    ChkBxSunday.Enabled := False;
    SvcDBLFHourBegin.Enabled := False;
    SvcDBLFHourEnd.Enabled := False;
  end;
  // Gestion des promopack, TT, R2011.2 - Start
  BtnActivate.Enabled := True;
  BtnDeactivate.Enabled := True;
  DmdFpnPromoPackCA.QryStatPromoPack.ParamByName('PrmIdtPromoPack').AsInteger
                            := StrToInt(SvcDBLFIdtPromoPack.Text);
  DmdFpnPromoPackCA.QryStatPromoPack.ParamByName('PrmIdtLanguage').AsString
                            := ViTxtUserLanguage;
  DscStatPromoPack.DataSet := DmdFpnPromoPackCA.QryStatPromoPack;
  DscStatPromoPack.DataSet.Open;
  SvcDBLblPromoPackStatus.Caption := DscStatPromoPack.Dataset.FieldByName('CodState').AsString;
  if CodJob = CtCodJobRecMod then begin

    if DscStatPromoPack.Dataset.FieldByName('CodStateId').AsString =
                                              IntToStr(CtCodStatInactive) then
      BtnDeactivate.Enabled := False
    else
      BtnActivate.Enabled := False;
  end;
  if (CodJob = CtCodJobRecNew) then begin
    BtnDeactivate.Enabled := False;
    BtnActivate.Enabled := False;
  end;
// R2013.1 - Applix 2388846 - All OPCO - PmntPromopackisntWorking - TCS(TK)- Start
  if (CodJob = CtCodJobRecCons) then begin
    BtnDeactivate.Enabled := False;
    BtnActivate.Enabled := False;
    DisableControl(SvcDBMETxtExplanation);
    DisableControl(SvcDBMETxtPublDescr);
    DisableControl(DBLkpCbxCodCustomer);
    DisableControl(DBLkpCbxCodType);
    DisableControl(DBLkpCbxCodAffect);
    DisableControl(DBChxFlgCentre);
    DisableControl(SvcDBLFPctOnLimValValLimit);
    DisableControl(SvcDBLFPctOnLimValPctPromo);
    DisableControl(SvcDBLFAmtPerSlice);
    DisableControl(SvcDBLFCoupPerSlice);
    DisableControl(SvcMECoupPerSliceTxtPublDescr);
    DisableControl(BtnSelectCoupPerSlice);
    DisableControl(SvcDBLFAmtTreshold1);
    DisableControl(SvcDBLFCoupTreshold1);
    DisableControl(SvcMECoupTreshold1TxtPublDescr);
    DisableControl(BtnSelectCoupTreshold1);
    DisableControl(SvcDBLFDateBegin);
    DisableControl(SvcDBLFDateEnd);
    DisableControl(SvcDBLFHourBegin);
    DisableControl(SvcDBLFHourEnd);
    DisableControl(DBRgpTypePeriod);
    DisableControl(RdbtnSingleOccurence);
    DisableControl(RdBtnMultipleOccurence);
    DisableControl(ChkBxMonday);
    DisableControl(ChkBxTuesday);
    DisableControl(ChkBxWednesday);
    DisableControl(ChkBxThursday);
    DisableControl(ChkBxFriday);
    DisableControl(ChkBxSaturday);
    DisableControl(ChkBxSunday);
    DisableControl(SvcDBLFBarcode);
  end;
// R2013.1 - Applix 2388846 - All OPCO - PmntPromopackisntWorking - TCS(TK)- End
  if (CodJob = CtCodJobRecDel) and
     (DscPromoPack.Dataset.FieldByName('DatBegin').AsDateTime < now) then
  begin
    FFlgDelMsg := True;
    //Gestion des promopack - Post Integration, TT, R2011.2 - Start
    if(DscStatPromoPack.Dataset.FieldByName('CodStateId').AsString =
                                              IntToStr(CtCodStatActive)) then
    begin                                                                        // Promopack fix, GG(TCS)
      DscStatPromoPack.DataSet.Close;                                            // Promopack fix, GG(TCS)
      raise Exception.Create(Format(CtTxtDelErrorMsgAct,[Trim(SvcDBLFIdtPromoPack.Text)]));
      end                                                                        // Promopack fix, GG(TCS)
    else
    begin                                                                        // Promopack fix, GG(TCS)
      DscStatPromoPack.DataSet.Close;                                            // Promopack fix, GG(TCS)
      raise Exception.Create(Format(CtTxtDelErrorMsgDeact,[Trim(SvcDBLFIdtPromoPack.Text)]));
   end;                                                                          // Promopack fix, GG(TCS)
  end;
    //Gestion des promopack - Post Integration, TT, R2011.2 - End

  if (CodJob = CtCodJobRecMod) and
     ((DscPromoPack.Dataset.FieldByName('DatBegin').AsDateTime < now) or
      (DscStatPromoPack.Dataset.FieldByName('CodStateId').AsString =
                                              IntToStr(CtCodStatInactive))) then
  begin
    DisableControl(SvcDBMETxtExplanation);
    DisableControl(SvcDBMETxtPublDescr);
    DisableControl(DBLkpCbxCodCustomer);
    DisableControl(DBLkpCbxCodType);
    DisableControl(DBLkpCbxCodAffect);
    DisableControl(DBChxFlgCentre);
    DisableControl(SvcDBLFPctOnLimValValLimit);
    DisableControl(SvcDBLFPctOnLimValPctPromo);
    DisableControl(SvcDBLFAmtPerSlice);
    DisableControl(SvcDBLFCoupPerSlice);
    DisableControl(SvcMECoupPerSliceTxtPublDescr);
    DisableControl(BtnSelectCoupPerSlice);
    DisableControl(SvcDBLFAmtTreshold1);
    DisableControl(SvcDBLFCoupTreshold1);
    DisableControl(SvcMECoupTreshold1TxtPublDescr);
    DisableControl(BtnSelectCoupTreshold1);
    DisableControl(SvcDBLFDateBegin);
    DisableControl(SvcDBLFDateEnd);
    DisableControl(SvcDBLFHourBegin);
    DisableControl(SvcDBLFHourEnd);
    DisableControl(DBRgpTypePeriod);
    DisableControl(RdbtnSingleOccurence);
    DisableControl(RdBtnMultipleOccurence);
    DisableControl(ChkBxMonday);
    DisableControl(ChkBxTuesday);
    DisableControl(ChkBxWednesday);
    DisableControl(ChkBxThursday);
    DisableControl(ChkBxFriday);
    DisableControl(ChkBxSaturday);
    DisableControl(ChkBxSunday);
    DisableControl(SvcDBLFBarcode);
    //DisableControl(BitBtnPrintPromoPackReport);                               //commented out for enahancement of R2011.2, CAFR, defect_434, Teesta(TCS)
    DisableControl(BtnOK);
    DisableControl(BtnApply);
    //Gestion des promopack - Post Integration, TT, R2011.2 - Start
    if (DscPromoPack.Dataset.FieldByName('DatBegin').AsDateTime < now) and
       (DscStatPromoPack.Dataset.FieldByName('CodStateId').AsString =
       IntToStr(CtCodStatActive)) then
      MessageDlg(Format(CtTxtModWarnMsg,[Trim(SvcDBLFIdtPromoPack.Text)]),
                                                            mtError, [mbOk], 0)
    else if(DscPromoPack.Dataset.FieldByName('DatBegin').AsDateTime < now) then
      MessageDlg(Format(CtTxtModActCurrMsg,[Trim(SvcDBLFIdtPromoPack.Text)]),
                                                            mtError, [mbOk], 0)
    else
      MessageDlg(Format(CtTxtModActFutMsg,[Trim(SvcDBLFIdtPromoPack.Text)]),
                                                            mtError, [mbOk], 0);
    //Gestion des promopack - Post Integration, TT, R2011.2 - End
  end;
  DscStatPromoPack.DataSet.Close;
  // Gestion des promopack, TT, R2011.2 - End
end;   // of TFrmDetPromoPackCA.FormActivate

//=============================================================================

procedure TFrmDetPromoPackCA.DBLkpCbxCodTypeExit(Sender: TObject);
begin  // of TFrmDetPromoPackCA.DBLkpCbxCodTypeExit
  inherited;
  if Integer(DBLkpCbxCodType.KeyValue) = CtCodBingoCustom then begin
    DBLkpCbxCodCustomer.Enabled := False;
    DscPromoPack.DataSet.FieldByName('CodCustomer').AsInteger := 0;
  end
  else
    DBLkpCbxCodCustomer.Enabled := True;
end;   // of TFrmDetPromoPackCA.DBLkpCbxCodTypeExit

//=============================================================================

procedure TFrmDetPromoPackCA.EnableBeginAndEndHour;
begin  // of TFrmDetPromoPackCA.EnableBeginAndEndHour
  //inherited;
  // Hours must stay enabled if record is inserted or modified
end;   // of TFrmDetPromoPackCA.EnableBeginAndEndHour

//=============================================================================

procedure TFrmDetPromoPackCA.CouponUserValidationCaseSender(Sender: TObject;
  var SvcDBLFCoupon: TSvcDBLocalField; var SvcMECouponDescription: TSvcMaskEdit;
  var SvcDBLblCoupon: TSvcDBLabelLoaded);
begin  // of TFrmDetPromoPackCA.CouponUserValidationCaseSender
  inherited;
  if Sender = SvcDBLFCoupTreshold1 then begin
    SvcDBLFCoupon          := SvcDBLFCoupTreshold1;
    SvcMECouponDescription := SvcMECoupTreshold1TxtPublDescr;
    SvcDBLblCoupon         := SvcDBLblCoupTreshold1;
  end
  else if Sender = SvcDBLFCoupTreshold2 then begin
    SvcDBLFCoupon          := SvcDBLFCoupTreshold2;
    SvcMECouponDescription := SvcMECoupTreshold2TxtPublDescr;
    SvcDBLblCoupon         := SvcDBLblCoupTreshold2;
  end
  else if Sender = SvcDBLFCoupTreshold3 then begin
    SvcDBLFCoupon          := SvcDBLFCoupTreshold3;
    SvcMECouponDescription := SvcMECoupTreshold3TxtPublDescr;
    SvcDBLblCoupon         := SvcDBLblCoupTreshold3;
  end
  else if Sender = SvcDBLFCoupPerSlice then begin
    SvcDBLFCoupon          := SvcDBLFCoupPerSlice;
    SvcMECouponDescription := SvcMECoupPerSliceTxtPublDescr;
    SvcDBLblCoupon         := SvcDBLblCoupPerSlice;
  end
  else if Sender = SvcDBLFBingoCustomIdtCoup then begin
    SvcDBLFCoupon          := SvcDBLFBingoCustomIdtCoup;
    SvcMECouponDescription := SvcMEBingoCustomCouponTxtPublDescr;
    SvcDBLblCoupon         := SvcDBLblBingoCustomIdtCoup;
  end;
end;   // of TFrmDetPromoPackCA.CouponUserValidationCaseSender

//=============================================================================

procedure TFrmDetPromoPackCA.PrepareDataDependJobAddCaseCodType(
  CodType: Integer);
var
  CodError         : Word;             // ErrorCode for UserValidation
begin  // of TFrmDetPromoPackCA.PrepareDataDependJobAddCaseCodType
  inherited;
  case DscPromoPack.DataSet.FieldByName ('CodType').AsInteger of
    CtCodCoupPerSlice         : begin
      if SvcDBLFCoupPerSlice.AsInteger > 0 then
        if Assigned (SvcDBLFCoupPerSlice.OnUserValidation) then begin
          CodError := 0;
          SvcDBLFCoupPerSlice.Modified := True;
          CouponUserValidation (SvcDBLFCoupPerSlice, CodError);
        end;
    end;
    CtCodCoupTresHold        : begin
      if SvcDBLFCoupTreshold1.AsInteger > 0 then
        if Assigned (SvcDBLFCoupTreshold1.OnUserValidation) then begin
          CodError := 0;
          SvcDBLFCoupTreshold1.Modified := True;
          CouponUserValidation (SvcDBLFCoupTreshold1, CodError);
        end;
      if SvcDBLFCoupTreshold2.AsInteger > 0 then
        if Assigned (SvcDBLFCoupTreshold2.OnUserValidation) then begin
          CodError := 0;
          SvcDBLFCoupTreshold2.Modified := True;
          CouponUserValidation (SvcDBLFCoupTreshold2, CodError);
        end;
      if SvcDBLFCoupTreshold3.AsInteger > 0 then
        if Assigned (SvcDBLFCoupTreshold3.OnUserValidation) then begin
          CodError := 0;
          SvcDBLFCoupTreshold3.Modified := True;
          CouponUserValidation (SvcDBLFCoupTreshold3, CodError);
        end;
    end;
  end;
end;   // of TFrmDetPromoPackCA.PrepareDataDependJobAddCaseCodType

//=============================================================================

procedure TFrmDetPromoPackCA.DscPromoPackDataChange(Sender: TObject;
  Field: TField);
begin  // of TFrmDetPromoPackCA.DscPromoPackDataChange
  if ((Field = DscPromoPack.DataSet.FieldByName ('CodType')) or
      (Field = DscPromoPack.DataSet.FieldByName ('CodTypePoint'))) and
     (CodJob in [CtCodJobRecNew, CtCodJobRecMod]) then begin
    SvcMECoupPerSliceTxtPublDescr.Text := '';
    SvcMECoupTreshold1TxtPublDescr.Text := '';
    SvcMECoupTreshold2TxtPublDescr.Text := '';
    SvcMECoupTreshold3TxtPublDescr.Text := '';
    SvcMEBingoCustomCouponTxtPublDescr.Text := '';
  end;
  inherited;
end;   // of TFrmDetPromoPackCA.DscPromoPackDataChange

//=============================================================================

procedure TFrmDetPromoPackCA.BtnOKClick(Sender: TObject);
begin // of TFrmDetPromoPackCA.BtnOKClick
  inherited;
  if DscPromoPack.DataSet.FieldByName ('DatBegin').IsNull then begin
    if not SvcDBLFDatBegin.CanFocus then
      SvcDBLFDateBegin.Show;
    SvcDBLFDateBegin.SetFocus;
    ModalResult := mrNone;
    raise Exception.Create (GetOrphStr (SCRequiredField));
  end;
  ValidatePromopack;                                                            //Logo Alerte Cible, TT, R2011.2
  ValidatePromoValues;                                                          // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
end;// of TFrmDetPromoPackCA.BtnOKClick

//=============================================================================

procedure TFrmDetPromoPackCA.BtnAddClick(Sender: TObject);
begin  // of TFrmDetPromoPackCA.BtnAddClick
  inherited;
  if DscPromoPack.DataSet.FieldByName ('DatBegin').IsNull then begin
    if not SvcDBLFDatBegin.CanFocus then
      SvcDBLFDateBegin.Show;
    SvcDBLFDateBegin.SetFocus;
    ModalResult := mrNone;
    raise Exception.Create (GetOrphStr (SCRequiredField));
  end;
  ValidatePromopack;                                                            //Logo Alerte Cible, TT, R2011.2
  ValidatePromoValues;                                                          // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
end; // of TFrmDetPromoPackCA.BtnAddClick

//=============================================================================
 
procedure TFrmDetPromoPackCA.SvcDBLFBarcodeExit(Sender: TObject);
 var
  TxtSql           : string;
  Error            : Boolean;
begin // of TFrmDetPromoPackCA.SvcDBLFBarcodeExit
  inherited;
  if not IsValidationNeeded (Error) then
    Exit;
  if (Trim(SvcDBLFBarcode.Text) <> '') and (Length(Trim(SvcDBLFBarcode.Text)) <> 13)
  then begin
    if not SvcDBLFBarcode.CanFocus then
      SvcDBLFBarcode.Show;
    SvcDBLFBarcode.SetFocus;
    ModalResult := mrNone;
    raise Exception.Create (Format(CtTxtErrorLength,['13']));
  end;
  //barcode must be unique
  if (Trim(SvcDBLFBarcode.Text) <> '') then begin
    try
      TxtSql :=  'SELECT * FROM PROMOPACK ' +
                 #10'WHERE NumPLUActivation = ' +
                              AnsiQuotedStr(Trim(SvcDBLFBarcode.Text), '''');
      if CodJob = CtCodJobRecMod then
        TxtSql := TxtSql + #10'AND IdtPromoPack <> ' + SvcDBLFIdtPromoPack.Text;
      if DmdFpnUtils.QueryInfo(TxtSql) then begin
        if not SvcDBLFBarcode.CanFocus then
          SvcDBLFBarcode.Show;
        SvcDBLFBarcode.SetFocus;
        ModalResult := mrNone;
        raise Exception.Create(Format(CtTxtAlreadyExists,
                             [TrimTrailColon (SvcDBLblBarcode.Caption)]));
      end;
    finally
      DmdFpnUtils.CloseInfo;
    end;
  end;
end;  // of TFrmDetPromoPackCA.SvcDBLFBarcodeExit

//=============================================================================

procedure TFrmDetPromoPackCA.SvcDBMETxtLogoPropertiesEditValueChanged(
  Sender: TObject);
var
  TxtLogo          : string;
begin  // of TFrmDetPromoPackCA.SvcDBMETxtLogoPropertiesEditValueChanged
  if CodJob <> CtCodJobRecCons then begin
    if SvcDBMETxtLogo.TrimText <> '' then begin
      TxtLogo := ForceExtensionW (SvcDBMETxtLogo.TrimText, 'stp');
      SvcDBMETxtLogo.TrimText := TxtLogo;
      DscPromoPack.edit;
      DscPromoPack.DataSet.FieldByName ('TxtLogo').AsString := TxtLogo;
    end;
  end;
end;   // of TFrmDetPromoPackCA.SvcDBMETxtLogoPropertiesEditValueChanged

//=============================================================================
// Logo Alerte Cible, TT, R2011.2 - Start
//=============================================================================
procedure TFrmDetPromoPackCA.ValidatePromopack;
//R2014.2-51060-GOP_and_Fidelity_card_Enhancement.CAFR-TCS(MeD).start
var
  TxtCarteSql : String;
  TxtNonCarteSql : String;
  PromoNum : String;
//R2014.2-51060-GOP_and_Fidelity_card_Enhancement.CAFR-TCS(MeD).end
begin
//R2014.2-51060-GOP_and_Fidelity_card_Enhancement.CAFR-TCS(MeD).start
  TxtCarteSql := 'SELECT TOP 1 *'+
                  #10'from promopack'+
                  #10'WHERE codcustomer = 100'+
                  #10'ORDER BY datcreate DESC';
  TxtNonCarteSql := 'SELECT TOP 1 *'+
                     #10'from promopack'+
                     #10'WHERE codcustomer = 101'+
                     #10'ORDER BY datcreate DESC';
//R2014.2-51060-GOP_and_Fidelity_card_Enhancement.CAFR-TCS(MeD).end
  if (DBLkpCbxCodCustomer.KeyValue = 102) then
  begin
    if (Trim(SvcDBLFBarcode.Text) = '') then begin
      if not SvcDBLFBarcode.CanFocus then
        SvcDBLFBarcode.Show;
      SvcDBLFBarcode.SetFocus;
      ModalResult := mrNone;
      raise Exception.Create(Format(CtTxtNoBarcode,[Trim(SvcDBLFIdtPromoPack.Text),
                             DBLkpCbxCodCustomer.text]));
    end;
  end;
  if (DBLkpCbxCodType.KeyValue = 1001)and (SvcDBLFCoupPerSlice.AsInteger = 0) then
  begin
    if not SvcDBLFCoupPerSlice.CanFocus then
      SvcDBLFCoupPerSlice.Show;
    SvcDBLFCoupPerSlice.SetFocus;
    ModalResult := mrNone;
    raise Exception.Create (CtTxtBonAlert);
  end;
  if(DBLkpCbxCodType.KeyValue = 1002) and (SvcDBLFCoupTreshold1.AsInteger = 0) then
  begin
    if not SvcDBLFCoupTreshold1.CanFocus then
      SvcDBLFCoupTreshold1.Show;
    SvcDBLFCoupTreshold1.SetFocus;
    ModalResult := mrNone;
    raise Exception.Create (CtTxtBonAlert);
  end;
//R2014.2-51060-GOP_and_Fidelity_card_Enhancement.CAFR-TCS(MeD).Start
  if((DBLkpCbxCodCustomer.KeyValue = 100) and (DBLkpCbxCodType.KeyValue = 1000))
    then begin
        DmdFpnPromoPackCA.SprLstPromoPack.First;
        while not DmdFpnPromoPackCA.SprLstPromoPack.Eof do
          begin
            if
            ((DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodCustomerAsTxtShort').AsString = 'SsCarte')
            and (DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodTypeAsTxtShort').AsString <> '%RemMntant'))
              then begin
                ModalResult := mrNone;
                try
                  if DmdFpnUtils.QueryInfo(TxtNonCarteSql) then
                    PromoNum :=  DmdFpnUtils.QryInfo.FieldByName('IdtPromoPack').AsString
                finally
                  DmdFpnUtils.CloseInfo;
                end;
                  raise Exception.Create (CtTxtNonCarteExists + '' + PromoNum );
             end;
             DmdFpnPromoPackCA.SprLstPromoPack.Next;
          end;
    end
  else
  if((DBLkpCbxCodCustomer.KeyValue = 100) and (DBLkpCbxCodType.KeyValue = 1002))
    then begin
        DmdFpnPromoPackCA.SprLstPromoPack.First;
        while not DmdFpnPromoPackCA.SprLstPromoPack.Eof do
          begin
            if
            ((DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodCustomerAsTxtShort').AsString = 'SsCarte')
            and (DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodTypeAsTxtShort').AsString <> 'BonPallier'))
              then begin
                ModalResult := mrNone;
                try
                  if DmdFpnUtils.QueryInfo(TxtNonCarteSql) then
                    PromoNum :=  DmdFpnUtils.QryInfo.FieldByName('IdtPromoPack').AsString
                finally
                  DmdFpnUtils.CloseInfo;
                end;
                  raise Exception.Create (CtTxtNonCarteExists + '' + PromoNum);
             end;
             DmdFpnPromoPackCA.SprLstPromoPack.Next;
          end;
    end
   else
   if((DBLkpCbxCodCustomer.KeyValue = 100) and (DBLkpCbxCodType.KeyValue = 1001))
    then begin
        DmdFpnPromoPackCA.SprLstPromoPack.First;
        while not DmdFpnPromoPackCA.SprLstPromoPack.Eof do
          begin
            if
            ((DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodCustomerAsTxtShort').AsString = 'SsCarte')
            and (DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodTypeAsTxtShort').AsString <> 'BonMontant'))
              then begin
                ModalResult := mrNone;
                try
                  if DmdFpnUtils.QueryInfo(TxtNonCarteSql) then
                    PromoNum :=  DmdFpnUtils.QryInfo.FieldByName('IdtPromoPack').AsString
                finally
                  DmdFpnUtils.CloseInfo;
                end;
                  raise Exception.Create (CtTxtNonCarteExists + '' + PromoNum);
             end;
             DmdFpnPromoPackCA.SprLstPromoPack.Next;
          end;
    end
   else
   if((DBLkpCbxCodCustomer.KeyValue = 101) and (DBLkpCbxCodType.KeyValue = 1000))
    then begin
        DmdFpnPromoPackCA.SprLstPromoPack.First;
        while not DmdFpnPromoPackCA.SprLstPromoPack.Eof do
          begin
            if
            ((DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodCustomerAsTxtShort').AsString = 'Carte')
            and (DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodTypeAsTxtShort').AsString <> '%RemMntant'))
              then begin
                ModalResult := mrNone;
                try
                  if DmdFpnUtils.QueryInfo(TxtCarteSql) then
                    PromoNum :=  DmdFpnUtils.QryInfo.FieldByName('IdtPromoPack').AsString
                finally
                  DmdFpnUtils.CloseInfo;
                end;
                  raise Exception.Create (CtTxtCarteExists + '' + PromoNum);
             end;
             DmdFpnPromoPackCA.SprLstPromoPack.Next;
          end;
    end
   else
   if((DBLkpCbxCodCustomer.KeyValue = 101) and (DBLkpCbxCodType.KeyValue = 1002))
   then begin
    DmdFpnPromoPackCA.SprLstPromoPack.First;
      while not DmdFpnPromoPackCA.SprLstPromoPack.Eof do
      begin
         if ((DmdFpnPromoPackCA.SprLstPromoPack.
             FieldByName ('CodCustomerAsTxtShort').AsString = 'Carte')
             and (DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
              ('CodTypeAsTxtShort').AsString <> 'BonPallier')) then
         begin
           ModalResult := mrNone;
                try
                  if DmdFpnUtils.QueryInfo(TxtCarteSql) then
                    PromoNum :=  DmdFpnUtils.QryInfo.FieldByName('IdtPromoPack').AsString
                finally
                  DmdFpnUtils.CloseInfo;
                end;
                  raise Exception.Create (CtTxtCarteExists + '' + PromoNum);
             end;
       DmdFpnPromoPackCA.SprLstPromoPack.Next;
     end;
   end
   else
   if((DBLkpCbxCodCustomer.KeyValue = 101) and (DBLkpCbxCodType.KeyValue = 1001))
    then begin
        DmdFpnPromoPackCA.SprLstPromoPack.First;
        while not DmdFpnPromoPackCA.SprLstPromoPack.Eof do
          begin
            if
            ((DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodCustomerAsTxtShort').AsString = 'Carte')
            and (DmdFpnPromoPackCA.SprLstPromoPack.FieldByName
            ('CodTypeAsTxtShort').AsString <> 'BonMontant'))
              then begin
                ModalResult := mrNone;
                try
                  if DmdFpnUtils.QueryInfo(TxtCarteSql) then
                    PromoNum :=  DmdFpnUtils.QryInfo.FieldByName('IdtPromoPack').AsString
                finally
                  DmdFpnUtils.CloseInfo;
                end;
                  raise Exception.Create (CtTxtCarteExists + '' + PromoNum);
             end;
             DmdFpnPromoPackCA.SprLstPromoPack.Next;
          end;
    end;
//R2014.2-51060-GOP_and_Fidelity_card_Enhancement.CAFR-TCS(MeD).End
end;

//=============================================================================

procedure TFrmDetPromoPackCA.BtnApplyClick(Sender: TObject);
begin
  ValidatePromopack;
  ValidatePromoValues;                                                          // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  inherited;
end;
//=============================================================================
// Logo Alerte Cible, TT, R2011.2 - End
//=============================================================================

//=============================================================================
// Gestion des promopack, TT, R2011.2 - Start
//=============================================================================
procedure TFrmDetPromoPackCA.BtnDeactivateClick(Sender: TObject);
var
  ConfMsg: Integer;
begin
  inherited;
  ValidatePromopack;
  ConfMsg := MessageDlg (CtTxtPromoDeactivate, mtConfirmation , [mbOK,mbCancel], 0);
  if ConfMsg = 1 then begin
    DmdFpnPromoPackCA.UpdStatPromopack.ModifySQL.Clear;
    DmdFpnPromoPackCA.UpdStatPromopack.ModifySQL.Text := 'UPDATE Promopack'+
                                       #10'SET CodState = ' + AnsiQuotedStr (IntToStr(CtCodStatInactive),'''') +
                                       #10'WHERE IdtPromoPack = ' +  SvcDBLFIdtPromoPack.Text;
    DmdFpnPromoPackCA.UpdStatPromopack.ExecSQL(ukModify);
    //Gestion des promopack - Post Integration, TT, R2011.2 - Start
    try
      //Delete future Agenda
      DmdFpnPromoPackCA.AdjustPromoAgenda.SQL.Clear;
      DmdFpnPromoPackCA.AdjustPromoAgenda.SQL.Text := 'DELETE FROM PromoAgenda'+
                                         #10'WHERE IdtPromoPack = ' + SvcDBLFIdtPromoPack.Text +
                                         #10'AND DatBegin > ' + AnsiQuotedStr (FormatDateTime('yyyy-mm-dd hh:mm:ss',Now),'''');
      DmdFpnPromoPackCA.AdjustPromoAgenda.ExecSQL;
      //Adjust current agenda
      DmdFpnPromoPackCA.AdjustPromoAgenda.SQL.Clear;
      DmdFpnPromoPackCA.AdjustPromoAgenda.SQL.Text := 'UPDATE PromoAgenda'+
                                         #10'SET DatEnd = ' +  AnsiQuotedStr (FormatDateTime('yyyy-mm-dd hh:mm:ss',Now),'''') +
                                         #10'WHERE IdtPromoPack = ' + SvcDBLFIdtPromoPack.Text +
                                         #10'AND DatEnd > ' +   AnsiQuotedStr (FormatDateTime('yyyy-mm-dd hh:mm:ss',Now),'''');
      DmdFpnPromoPackCA.AdjustPromoAgenda.ExecSQL;
    finally
      DmdFpnPromoPackCA.AdjustPromoAgenda.Close;
    end;
    //Gestion des promopack - Post Integration, TT, R2011.2 - End
    FFlgActDeact := True;
  end;
  Close;
end;

//=============================================================================

procedure TFrmDetPromoPackCA.BtnActivateClick(Sender: TObject);
var
  ConfMsg: Integer;
  //Gestion des promopack - Post Integration, TT, R2011.2 - Start
  DatTemp: TDateTime;
  DTBegin: TDateTime;
  DTEnd:   TDateTime;
  DatRef:  TDateTime;
  //Gestion des promopack - Post Integration, TT, R2011.2 - End
begin
  inherited;
  ValidatePromopack;
  ConfMsg := MessageDlg (CtTxtPromoActivate, mtConfirmation , [mbOK,mbCancel], 0);
  if ConfMsg = 1 then begin
    CheckPromoAgenda(True); //Check creation/activation rules
    DmdFpnPromoPackCA.UpdStatPromopack.ModifySQL.Clear;
    DmdFpnPromoPackCA.UpdStatPromopack.ModifySQL.Text := 'UPDATE Promopack'+
                                       #10'SET CodState = ' + AnsiQuotedStr (IntToStr(CtCodStatActive),'''') +
                                       #10'WHERE IdtPromoPack = ' +  SvcDBLFIdtPromoPack.Text;
    DmdFpnPromoPackCA.UpdStatPromopack.ExecSQL(ukModify);
    //Gestion des promopack - Post Integration, TT, R2011.2 - Start
    //Insert PromoAgenda till DatEnd
    DTBegin := Now;
    DTEnd   := Now;
    DatRef  := Date;                                                            //Opérations Multiples - Defect#204 fix PRG R2011.2
    if DatRef < SvcDBLFDateBegin.AsDateTime then
      DatRef := SvcDBLFDateBegin.AsDateTime;
    DatTemp := DatRef;
    while DatTemp <= SvcDBLFDateEnd.AsDateTime do begin
      if (RdbtnSingleOccurence.Checked) or (RdBtnMultipleOccurence.Checked and
        DateIsChecked(DatTemp)) then begin
        //insert record
        if (DBRgpTypePeriod.Value = IntToStr(CtCodFullDay)) then begin
          if (DatTemp = DatRef) then begin                                      //Opérations Multiples - Defect#204 fix PRG R2011.2
            DTBegin := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                               SvcDBLFHourBegin.AsStTime);      //Opérations Multiples - Defect#204 fix PRG R2011.2
            //Opérations Multiples - Defect#204 fix PRG R2011.2 - start
            if DTBegin < Now then
              DTBegin := Now;  //Don't start from start of day but current time
          end
            //Opérations Multiples - Defect#204 fix PRG R2011.2 - end
          else
            DTBegin := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp),0);
          if (DatTemp = SvcDBLFDateEnd.AsDateTime) then
            DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                           SvcDBLFHourEnd.AsStTime)
          else
            DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp),86399);
        end
        else begin
          if (DBRgpTypePeriod.Value = IntToStr(CtCodHappyHour)) then begin
            DTBegin := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                            SvcDBLFHourBegin.AsStTime);
            //Opérations Multiples - Defect#204 fix PRG R2011.2 - start
            if DTBegin < Now then
              DTBegin := Now;  //Don't start from start of day but current time
            //Opérations Multiples - Defect#204 fix PRG R2011.2 - end
            DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                            SvcDBLFHourEnd.AsStTime);
          end
          else begin
            //for nocturnes
            if((DatRef + 1) = SvcDBLFDateEnd.AsDateTime) and
              (Dattemp = SvcDBLFDateEnd.AsDateTime) then begin
            end
            else begin
              DTBegin := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) ,
                                            SvcDBLFHourBegin.AsStTime);
              //Opérations Multiples - Defect#204 fix PRG R2011.2 - start
              if DTBegin < Now then
                DTBegin := Now;  //Don't start from start of day but current time
              //Opérations Multiples - Defect#204 fix PRG R2011.2 - end
              if (SvcDBLFHourEnd.AsStTime > SvcDBLFHourbegin.AsStTime) then
                DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp),
                                             SvcDBLFHourEnd.AsStTime)
              else
                DTEnd := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) + 1 ,
                                                SvcDBLFHourEnd.AsStTime);
            end;
          end;
          // execute sql-statement
        end;
        try
          if not(((DatRef + 1) = SvcDBLFDateEnd.AsDateTime) and
                  (Dattemp = SvcDBLFDateEnd.AsDateTime) and
                  (DBRgpTypePeriod.Value = IntToStr(CtCodNocturne)) )then begin
            DmdFpnPromoPackCA.InsSqlPromoAgenda.ParamByName('IdtPromoPack').AsInteger :=
              SvcDBLFIdtPromoPack.AsInteger;
            DmdFpnPromoPackCA.InsSqlPromoAgenda.ParamByName('DatBegin').AsDateTime :=
              DTBegin;
            DmdFpnPromoPackCA.InsSqlPromoAgenda.ParamByName('DatEnd').AsDateTime :=
              DTEnd;
            DmdFpnPromoPackCA.InsSqlPromoAgenda.Prepare;
            DmdFpnPromoPackCA.InsSqlPromoAgenda.ExecSQL;
          end
        finally
          DmdFpnPromoPackCA.InsSqlPromoAgenda.Close;
        end;
      end;
      DatTemp := StDateAndTimeToDateTime(DateTimeToStDate(DatTemp) + 1, 0);
    end;
    //Gestion des promopack - Post Integration, TT, R2011.2 - End
    FFlgActDeact := True;
  end;
  Close;
end;


//=============================================================================
// Inherit procedure for customization. No call to parent procedure

procedure TFrmDetPromoPackCA.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin  // of TFrmDetPromoPackCA.FormCloseQuery
  // When creating New: if nothing has been changed yet, then it is most
  // likely we are still on the first Idt-field.
  // To avoid 'Value is required' when trying to close with an empty Idt,
  // we act as if the Cancel-button was clicked.
  // The only risk here is that an Idt is entered, and immediatly, without
  // focus change, <Alt+F4> is used to close, then the Idt will be ignored.
  // However, this is a very little risk, comparing to the frustration
  // not allowing to close an erroneous use of Insert.

  // Force DBGrid refresh in parent form on Activate/Deactivate of PromoPack
  if FFlgActDeact then begin
    ModalResult := mrOK;
    Exit;
  end;

  if (CodJob = CtCodJobRecNew) and
     (not FlgDataChanged) and (ModalResult = mrCancel) then
    ModalResult := mrIgnore;

  // Check if Cancel-button clicked
  if ModalResult = mrIgnore then
    Exit;

  // ForceFocusChange to force an OnExit- or an OnPostEdit-handler to be
  // executed before further execution.
  if CodJob in [CtCodJobRecNew, CtCodJobRecMod] then begin
    ForceFocusChange;
    if ModalResult = mrNone then begin
      CanClose := False;
      Exit;
    end;
  end;

  if FFlgDelMsg then
    ModalResult := mrIgnore

  else if (ModalResult = mrOK) and (CodJob = CtCodJobRecDel) then begin
    InCloseQueryCanDelete;
    if ModalResult = mrOK then begin
      // Ask confirmation for delete
      case MessageDlg (Format (CtTxtConfirmDelete, [TxtRecName]),
                       mtConfirmation, [mbYes, mbNo, MbCancel], 0) of
        mrYes    : ModalResult := mrOK;
        mrNo     : ModalResult := mrIgnore;
        mrCancel : ModalResult := mrNone;
      end;    // of case MessageDlg ... of
    end
    else if ModalResult = mrYes then
      ModalResult := mrOK
    else
      ModalResult := mrIgnore;
  end  // of (ModalResult = mrOK) and (CodJob = CtCodJobRecDel)

  else if (ModalResult = mrOK) and (CodJob = CtCodJobRecMod) then begin
    AdjustDataBeforeSave;
    if IsDataChanged then
      ModalResult := mrOK
    else
      ModalResult := mrCancel;
  end  // of (ModalResult = mrOK) and (CodJob = CtCodJobRecMod)

  else if (ModalResult = mrOK) and (CodJob = CtCodJobRecNew) then
    AdjustDataBeforeSave

  else if ModalResult = mrCancel then begin  // <Alt+F4> or border-icon close
    // Check if data is modified
    case CodJob of
      CtCodJobRecMod, CtCodJobRecNew : begin
        AdjustDataBeforeSave;
        if IsDataChanged then
          ModalResult := MrYes;
      end;
      CtCodJobRecDel, CtCodJobRecCons : ModalResult := mrIgnore;
    end;
  end;  // of ModalResult = mrCancel

  if ModalResult = mrYes then begin
    // Ask confirmation for ignoring changes
    case MessageDlg (CtTxtConfirmChanges,
                     mtConfirmation, [mbYes, mbNo, MbCancel], 0) of
      mrYes    : ModalResult := mrOK;
      mrNo     : ModalResult := mrIgnore;
      mrCancel : ModalResult := mrNone;
    end;    // of case MessageDlg ... of
  end;

  CanClose := ModalResult <> mrNone;
end;   // of TFrmDetPromoPackCA.FormCloseQuery

//=============================================================================

//=============================================================================
// Gestion des promopack, TT, R2011.2 - End
//=============================================================================

// Gestion des promopack - Post Integration, TT, R2011.2 - Start
//=============================================================================
// Inherit procedure for customization. No call to parent procedure
procedure TFrmDetPromoPackCA.FormClose(Sender: TObject; var Action: TCloseAction);
begin  // of FormClose
  if FFlgActDeact then
    Exit;
  inherited;
end;   // of FormClose
//=============================================================================
// Gestion des promopack - Post Integration, TT, R2011.2 - End
//=============================================================================

//=============================================================================
//Promopack - BRES - R2012.1, Teesta - Start
//=============================================================================
procedure TFrmDetPromoPackCA.ModifyCaption;
begin  // of TFrmDetPromoPackCA.ModifyCaption
  case CodJob of
    CtCodJobRecNew  : Caption := DeleteAmpersand (CtTxtBtnCreate);
    CtCodJobRecMod  : Caption := DeleteAmpersand (CtTxtBtnModify);
    CtCodJobRecDel  : Caption := DeleteAmpersand (CtTxtBtnDelete);
    CtCodJobRecCons : Caption := DeleteAmpersand (CtTxtBtnConsult);
    else
      Caption := '';
  end;   // of case CodJob of
  Caption := CtTxtPromoTitle + ' - ' + Caption + ' ' + TxtRecName;
end;
//=============================================================================
//Promopack - BRES - R2012.1, Teesta - End
//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.
