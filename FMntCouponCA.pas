//=Copyright 2007 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FMntCouponCA.PAS : <some info about this unit>
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCouponCA.pas,v 1.2 2008/06/12 11:44:11 dietervk Exp $
// Version   ModifiedBy    Reason
// 1.1       CP   (TCS)    R2012.1 Defect fix(131)
// 1.2       SRM  (TCS)    R2014.1.Req(31110).Promopack_Improvement
//=============================================================================

unit FMntCouponCA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMntCoupon, ScTskMgr_BDE_DBC,                                        // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  SfCommon,SmUtils;                                                             // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
 const
  // Jobs for Print , Export of records in a file
  CtCodJobRecSel      =  6;
  CtCodJobRecPrint    = CtCodJobRecSel + 1;     // Record print
  CtCodJobRecExport   = CtCodJobRecPrint + 1;   // Record export

 var
  ViSetAllowEntryCmds  : TSetListJobs = [CtCodJobRecCons, CtCodJobRecNew,
                                         CtCodJobRecMod, CtCodJobRecDel,
                                         CtCodJobRecPrint,CtCodJobRecExport];
  FlgPromImprov        : Boolean = False;
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End

type
  TFrmMntCouponCA = class(TFrmMntCoupon)
    procedure FormActivate(Sender: TObject);
    procedure SvcTskDetCouponCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
    procedure SvcTskLstCouponCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure BeforeCheckRunParams;override;                                    
    procedure AppRunParams;override;
    procedure CheckAppDependParams (TxtParam : string); override;
   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
  private
    { Private declarations }
    // DataFields
    CodFunc        : TCodFunc;         // Function to process
  public
    { Public declarations }
  end;

var
  FrmMntCouponCA: TFrmMntCouponCA;


resourcestring
  CtTxtTitle = 'Maintenance Coupon';                                            // R2012.1 Defect fix 131 (CP)
  CtTxtRunParamPrint     = '/VP=Report Print';                                  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  CtTxtRunParamExp       = '/VX=Export Excel';
  CtTxtRunParamPromImprv = '/VPI = Promopack Improvement';
  CtTxtValCoupon         = 'ValCoupon';                                         // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End

//*****************************************************************************

implementation

uses
  SfDialog,
  SfList_BDE_DBC,
  //SmUtils,                                                                    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  SrStnCom,

  DFpn,
  DFpnUtils,
  DFpnCoupon,
  FDetCouponCA,                                                                 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  DFpnTradeMatrix,
  FLstCouponCA,
  SfMaintenance_BDE_DBC;                                                        // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntCouponCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: ';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2014/04/10 11:44:11 $';
  CtTxtSrcTag     = '$Name:  $';

//*****************************************************************************
// Implementation of TFrmMntCouponCA
//*****************************************************************************

procedure TFrmMntCouponCA.SvcTskDetCouponCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCouponCA.SvcTskDetCouponCreateExecutor
  NewObject := TFrmDetCouponCA.Create (Self);
  TFrmDetCouponCA(NewObject).CodCoupon := CodCoupon;
  if CodFunc = cfCoupCust then begin
    TFrmDetCouponCA(NewObject).StrLstIdtValues.Clear;
    TFrmDetCouponCA(NewObject).StrLstIdtValues.Add ('IdtCoupon=' +
                                                  IntToStr (CtValCoupCustMin));
    if (CtCodJobRecNew in SetEntryCmds) then
      TFrmDetCouponCA(NewObject).CodJob := CtCodJobRecNew
    else if (CtCodJobRecMod in SetEntryCmds) then
      TFrmDetCouponCA(NewObject).CodJob := CtCodJobRecMod
    else if (CtCodJobRecDel in SetEntryCmds) then
      TFrmDetCouponCA(NewObject).CodJob := CtCodJobRecDel
    else TFrmDetCouponCA(NewObject).CodJob := CtCodJobRecCons;
  end;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCouponCA.SvcTskDetCouponCreateExecutor

//=============================================================================
//R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
//=============================================================================

procedure TFrmMntCouponCA.SvcTskLstCouponCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCoupon.SvcTskLstCouponCreateExecutor
 DmdFpnCoupon.SprLstCoupon.ParamByName ('@PrmCodCoupon').AsInteger :=
    CodCoupon;
  if FlgPromImprov then
    DmdFpnCoupon.SprLstCoupon.ParamByName ('@PrmCoupVAL').AsString :='ValCoupon'
  else
    DmdFpnCoupon.SprLstCoupon.ParamByName ('@PrmCoupVAL').AsString :='';
  NewObject := TFrmLstCouponCA.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCoupon.SvcTskLstCouponCreateExecutor

//=============================================================================

procedure TFrmMntCouponCA.BeforeCheckRunParams;
var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
begin  // of TFrmMntCouponCA.BeforeCheckRunParams
 inherited;
  SplitString (CtTxtRunParamPrint , '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString (CtTxtRunParamExp , '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString (CtTxtRunParamPromImprv , '=', TxtPartLeft, TxtPartRight);        
  AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmMntCouponCA.BeforeCheckRunParams

//=============================================================================
// TFrmMaintenance.CheckAppDependParams: Placeholder to provide an inherited
// form with the possibility of examing extra variants (/V)
//                              ------
// INPUT: TxtParam = Complete run parameter (in other words: '/' and main
//                                           letter included)
//=============================================================================

procedure TFrmMntCouponCA.CheckAppDependParams (TxtParam : string);
begin
  if AnsiCompareText (Copy(TxtParam, 3, 4), 'PI') = 0 then
    FlgPromImprov := True;
end;

//=============================================================================
// TFrmMntCouponCA.AppRunParams : Investigates the standard run parameters and
// assigns it to form properties.
//=============================================================================

procedure TFrmMntCouponCA.AppRunParams;
var
  NumParam         : Integer;          // Loop-variable number of params
  TxtParam         : string;           // Current runparameter
  TxtPrmCheck      : string;           // Parameter to check
begin  // of TFrmMaintenance.AppRunParams
    inherited;
  // Check application-dependent runparameters
  Include (SetEntryCmds, CtCodJobRecCons);
  for NumParam := 1 to ParamCount do begin
    TxtParam := ParamStr (NumParam);
    if (TxtParam[1] = '/') and (Length (TxtParam) >= 2) and
       (UpCase (TxtParam[2]) = 'V') then begin
      TxtPrmCheck := AnsiUpperCase (Copy (TxtParam, 3, Length (TxtParam)));
      if TxtPrmCheck = 'P' then begin                                           // print task
        if CtCodJobRecPrint in ViSetAllowEntryCmds then                         // print task
          Include (SetEntryCmds, CtCodJobRecPrint)                              // print task
        else                                                                    // print task
          InvalidRunParam (TxtParam);                                           // print task
      end                                                                       // print task
      else if TxtPrmCheck = 'X' then begin                                      // export task
      if CtCodJobRecExport in ViSetAllowEntryCmds then                          // export task
          Include (SetEntryCmds, CtCodJobRecExport)                             // export task
        else                                                                    // export task
          InvalidRunParam (TxtParam);                                           // export task
      end                                                                       // export task
    end;  // of (TxtParam[1] = '/') and (Length (TxtParam) >= 2)...
  end; // of for NumParam := 1...
end;   

//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
//=============================================================================
procedure TFrmMntCouponCA.FormActivate(Sender: TObject);
begin
  inherited;
  Application.Title := CtTxtTitle;   //R2012.1 Defect fix 131 (CP)
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.
