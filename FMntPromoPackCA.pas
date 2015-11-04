//=Copyright 2007 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FMntPromoPackCA.PAS 
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// History:
// Version           Modified By        Reason
// V 1.6             TT.   (TCS)        R2011.2 - CAFR - Gestion des promopack
// V 1.7             SM    (TCS)        R2012.1 - BDES PromoPack - Internal defect Fix Cycle 3
// V 1.8             Chayanika(TCS)     R2012.1  - Regression Fix R2012.1(Chayanika)
// V 1.9             SRM   (TCS)        R2014.1.Req(31110).Promopack_Improvement
// V 1.10            AJ    (TCS)        R2014.1.Req(31110).Promopack_Improvement
//=============================================================================

unit FMntPromoPackCA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMntPromoPack, ScTskMgr_BDE_DBC,                                     // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  SmUtils,SrStnCom;                                                             // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM

  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  const
  // Jobs for creation, delete, consultation ,Print , Export of
  // records in a file
  CtCodJobRecSel      =  6;
  CtCodJobRecPrint    = CtCodJobRecSel + 1;     // Record print
  CtCodJobRecExport   = CtCodJobRecPrint + 1;   // Record export

var
  ViSetAllowEntryCmds  : TSetListJobs = [CtCodJobRecCons, CtCodJobRecNew,
                                         CtCodJobRecMod, CtCodJobRecDel,
                                         CtCodJobRecPrint,CtCodJobRecExport];
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
//=============================================================================
// TFrmMntPromoPackCA
//=============================================================================

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtRunParamBDES        = 'BDES';                                            // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
  CtTxtTitle= 'Maintenance promopack';                                          // Regression Fix R2012.1(Chayanika)
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  CtTxtRunParamPrint     = '/VP = Report Print';
  CtTxtRunParamExp       = '/VX = Export Excel';
  CtTxtRunParamPromImprv = '/PI = Promopack Improvement';
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
  CtTxtEndDate           = 'End date';
type
  TFrmMntPromoPackCA = class(TFrmMntPromoPack)
    SvcFrmPromopackReport: TSvcFormTask;
    procedure FormActivate(Sender: TObject);                                    // Regression Fix R2012.1(Chayanika)
    procedure SvcTskLstPromoPackCreateExecutor(Sender: TObject;                 // Gestion des promopack, TT, R2011.2
      var NewObject: TObject; var FlgCreated: Boolean);                         // Gestion des promopack, TT, R2011.2
    procedure SvcTskDetCouponCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcFrmPromopackReportCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetPromoPackCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
    FFlgBDES          : Boolean;                                                // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
  protected
    procedure BeforeCheckRunParams; override;                                   // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
    procedure CheckAppDependParams (TxtParam : string); override;               // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
    procedure AppRunParams;override;                                            // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  public
    { Public declarations }
    FFlgPromImprov    : Boolean;                                                // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    property FlgBDES : Boolean read FFlgBDES write FFlgBDES;                    // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
    property FlgPromImprov  : Boolean
             read FFlgPromImprov  write FFlgPromImprov;
   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
  end;

var
  FrmMntPromoPackCA: TFrmMntPromoPackCA;

//*****************************************************************************

implementation

{$R *.dfm}

uses
  SfDialog,
  SfMaintenance_BDE_DBC,                                                        // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  FDetPromoPackCA,
  FVSPromoPackCA, 
  FDetCouponCA, 
  FLstPromoPackCA,                                                              // Gestion des promopack, TT, R2011.2
  DFpnCoupon,DFpnPromoPack,                                                     // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ
  DFpnPromoPackCA,OvcPF;                                                        // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ
//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntPromoPackCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntPromoPackCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2012/06/04 12:11:36 $';

//=============================================================================

procedure TFrmMntPromoPackCA.SvcTskDetPromoPackCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntPromoPackCA.SvcTskDetPromoPackCreateExecutor
  NewObject  := TFrmDetPromoPackCA.Create (Self);
  TFrmDetPromoPackCA(NewObject).FlgPromoArtisModify := FlgPromoArtisModify;
  TFrmDetPromoPackCA(NewObject).FlgBDES             := FlgBDES;                 // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
  TFrmDetPromoPackCA(NewObject).FlgPromImprov       := FlgPromImprov;           // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  TFrmDetPromoPackCA(NewObject).GetPromoParamValues;                            // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntPromoPackCA.SvcTskDetPromoPackCreateExecutor

//=============================================================================
// Gestion des promopack, TT, R2011.2 - Start
//=============================================================================
procedure TFrmMntPromoPackCA.SvcTskLstPromoPackCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntPromoPackCA.SvcTskLstPromoPackCreateExecutor
  inherited;
  NewObject  := TFrmLstPromoPackCA.Create (Self);
  TFrmLstPromoPackCA(NewObject).AllowedJobs := SetEntryCmds;
  FlgCreated := True;
end;   // of TFrmMntPromoPackCA.SvcTskLstPromoPackCreateExecutor
//=============================================================================
// Gestion des promopack, TT, R2011.2 - End
//=============================================================================

procedure TFrmMntPromoPackCA.SvcFrmPromopackReportCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntPromoPackCA.SvcFrmPromopackReportCreateExecutor 
  NewObject := TFrmVSPromoPackCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntPromoPackCA.SvcFrmPromopackReportCreateExecutor

//=============================================================================

procedure TFrmMntPromoPackCA.SvcTskDetCouponCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntPromoPackCA.SvcTskDetCouponCreateExecutor
  NewObject := TFrmDetCouponCA.Create (Self);
  TFrmDetCouponCA(NewObject).CodCoupon := CtCodCoupPromo;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntPromoPackCA.SvcTskDetCouponCreateExecutor

//=============================================================================

procedure TFrmMntPromoPackCA.BeforeCheckRunParams;
var
  TxtPartLeft      : string;           // Left part of a string                 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
  TxtPartRight     : string;           // Right part of a string                // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
begin
  AddRunParams ('/VBDES', CtTxtRunParamBDES);                                   // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  SplitString (CtTxtRunParamPrint , '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString (CtTxtRunParamExp , '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString (CtTxtRunParamPromImprv , '=', TxtPartLeft, TxtPartRight);        
  AddRunParams (TxtPartLeft, TxtPartRight);
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End  
end;

//=============================================================================

procedure TFrmMntPromoPackCA.CheckAppDependParams (TxtParam : string);
begin
  if AnsiCompareText (Copy(TxtParam, 3, 4), 'BDES') = 0 then                    // R2012.1 BDES PromoPack - Internal defect Fix Cycle 3
    FlgBDES := True;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
  if AnsiCompareText (Copy(TxtParam, 3, 4), 'PI') = 0 then
    FlgPromImprov := True;
 // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
end;

//=============================================================================
// Regression Fix R2012.1(Chayanika) ::start
procedure TFrmMntPromoPackCA.FormActivate(Sender: TObject);
// R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
var
Varcnt   : Integer;
// R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
begin
  inherited;
   Application.Title:= CtTxtTitle;
   // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.Start
   if FlgPromImprov then begin
     Varcnt := 0;
     svctsklstpromopack.Sequences.Insert(Varcnt);
     svctsklstpromopack.Sequences.Items[Varcnt].Name := 'Datend';
     svctsklstpromopack.Sequences.Items[Varcnt].DataType := pftDate;
     svctsklstpromopack.Sequences.Items[Varcnt].AllowSubString := False;
     svctsklstpromopack.Sequences.Items[Varcnt].RangeLo := '01.01.1800';
     svctsklstpromopack.Sequences.Items[Varcnt].RangeHi := '31.12.3999';
     svctsklstpromopack.Sequences.Items[Varcnt].RangeLength := 0;
     svctsklstpromopack.Sequences.Items[Varcnt].DataFieldRange := 'Datend';
     svctsklstpromopack.Sequences.Items[Varcnt].AllowSubString := False; 
     svctsklstpromopack.Sequences.Items[Varcnt].Title := CtTxtEndDate;
     svctsklstpromopack.Sequences.Items[Varcnt].DataSet := DmdFpnPromoPackCA.
                                                      SprLstPromoPack;
     svctsklstpromopack.Sequences.Items[Varcnt].ParamNameSequence := '@PrmTxtSearch';
     svctsklstpromopack.Sequences.Items[Varcnt].ParamNameFrom := '@PrmTxtFrom';
     svctsklstpromopack.Sequences.Items[Varcnt].ParamNameTo := '@PrmTxtTo';
     svctsklstpromopack.Sequences.Items[Varcnt].ParamNameSubString :=
                                                         '@PrmTxtSubString';
     svctsklstpromopack.Sequences.Items[Varcnt].ParamValueSequence := 'Datend';
     svctsklstpromopack.ActiveSequence := svctsklstpromopack.Sequences[0];
   end;
   // R2014.1.Req(31110).Promopack_Improvement.TCS-AJ.End
end;
// Regression Fix R2012.1(Chayanika) ::end

//=============================================================================
// TFrmMntPromoPackCA.AppRunParams : Investigates the standard run parameters and
// assigns it to form properties.
// '/VP' = Activate print task
// '/VX' = Activate export task
//=============================================================================

procedure TFrmMntPromoPackCA.AppRunParams;
var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
  NumParam         : Integer;          // Loop-variable number of params
  TxtParam         : string;           // Current runparameter
  TxtPrmCheck      : string;           // Parameter to check
begin  // of TFrmMntPromoPackCA.AppRunParams   +
  inherited;
  // Check application-dependent runparameters
  Include (SetEntryCmds, CtCodJobRecCons);
  for NumParam := 1 to ParamCount do begin
    TxtParam := ParamStr (NumParam);
    if (TxtParam[1] = '/') and (Length (TxtParam) >= 2) and
       (UpCase (TxtParam[2]) = 'V') then begin
      TxtPrmCheck := AnsiUpperCase (Copy (TxtParam, 3, Length (TxtParam)));
     if TxtPrmCheck = 'P' then begin                                            // print task
        if CtCodJobRecPrint in ViSetAllowEntryCmds then                         // print task
          Include (SetEntryCmds, CtCodJobRecPrint)                              // print task
        else                                                                    // print task
          InvalidRunParam (TxtParam);                                           // print task
      end                                                                       // print task
      else if TxtPrmCheck = 'X' then begin                                      // export task
        if CtCodJobRecExport in ViSetAllowEntryCmds then                        // export task
          Include (SetEntryCmds, CtCodJobRecExport)                             // export task
        else                                                                    // export task
          InvalidRunParam (TxtParam);                                           // export task
      end                                                                       // export task
    end;  // of (TxtParam[1] = '/') and (Length (TxtParam) >= 2)...
  end;  // of for NumParam := 1 to... 
end;  // of TFrmMntPromoPackCA
//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
//=============================================================================
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);


end.
