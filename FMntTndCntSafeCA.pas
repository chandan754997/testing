//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : FlexPos
// Customer : Castorama
// Unit     : FMntTndCntSafeCA : Main form TENDER COUNT Safe
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntTndCntSafeCA.pas,v 1.1 2007/01/11 08:12:31 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FMntTndCntSafeCA - CVS revision 1.1
// Version            Modified By          Reason
// 1.2                P.M. (TCS)           R2011.2 - BDFR - SafetyBox Traceability
// 1.3                M.D. (TCS)           R2011.2 - CAFR - Bug17
// 1.4                SC. (TCS)            R2012.1--CAFR-suppression mention cheque kdo
// 1.5                Chayanika(TCS)       Regression Fix R2012.1
// 1.6                TK   (TCS)           R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques
//=============================================================================

unit FMntTndCntSafeCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sfmaintenance_BDE_DBC, ScTskMgr_BDE_DBC,
  SfMenu, IniFiles, SfAutoRun; // Added for SD04 - Safetybox Traceability, PM (TCS), R2011.2, BDFR

// Added for SD04 - Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start
resourcestring
  CtTxtRelogin = 'Display Login Screen';
  CtTxtAuthorisation = 'You are not authorised to open the screen';
  CtTxtNbrofCheques = 'Number of cheques';                                      //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

// Added for SD04 - Safetybox Traceability, PM (TCS), R2011.2, BDFR - End

resourcestring
  CtTxtRemoveChequeKDO       = '/VRCK';    //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
  CtTxtOthers                = 'Others';   //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
  CtTxtTitle = 'Count of the safe';         //Regression Fix R2012.1 (Chayanika)

 //=============================================================================
// TFrmMntTndCntSafeCA
//   Remark : is NOT inherited from FFpnMnt to avoid overhead of modules for
//            AddOn.
//=============================================================================

type
  TFrmMntTndCntSafeCA = class(TFrmMaintenance)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskFrmRegCountSafe: TSvcFormTask;
    SvcTskFrmRptCntSafe: TSvcFormTask;
    procedure FormActivate(Sender: TObject);                       //Regression Fix R2012.1 (Chayanika)
    procedure SvcTskFrmRegCountSafeCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmRptCntSafeCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmRptCntSafeExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
  private
    { Private declarations }
// ****** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start  ******
    FFlgLoginRequired  : Boolean;
    FFlgIniSpl  : Boolean;
    StrLstIniSec:TStringList;      // Stringlist main-section from ini-file
    IniFilMenuObj     : TIniFile;         // INI-file
    FAuthorisation           : string;
  protected
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure DefineStandardRunParams; override;
 // ****** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - End  ******

  public
    { Public declarations }
    FlgRemoveChequeKDO : Boolean;  //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
// ****** Added for  Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start  ******
    FlgOperKnown   : Boolean;          // True=operator known, False=logged off
    CodSecurity : Integer;
    IdtOperator    : string;           // Identification Operator
    OperatorTxtName: string;           // Name Operator
    TxtPassWord    : string;           // PassWord Operator
    OperatorIdtLanguage : string;      // Language Operator
    FlgNbrofCheques : Boolean;                                                  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  property FlgLoginRequired : Boolean read FFlgLoginRequired write FFlgLoginRequired;
  property FlgIniSpl : Boolean read FFlgIniSpl write FFlgIniSpl;
// ****** Added for  Safetybox Traceability, PM (TCS), R2011.2, BDFR - End  ******
  end;

var
  FrmMntTndCntSafeCA: TFrmMntTndCntSafeCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  // ****** Added for  Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start  ******
  SFlogin,
  FADOloginCA,
  // ****** Added for  Safetybox Traceability, PM (TCS), R2011.2, BDFR - End  ******
  FTndRegCountSafeCA,
  // ****** Added for  Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start  ******
  SmUtils,
  DFpnSafeTransactionCA,
  // ****** Added for  Safetybox Traceability, PM (TCS), R2011.2, BDFR - End  ******
  FVsRptTndCntSafeCA,
  DFpnBagCA;                                                                    //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FrmMntTndCntSafeCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntTndCntSafeCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.5 $';
  CtTxtSrcDate    = '$Date: 2011/09/23 08:12:31 $';

const
  CtIniFileName  = 'FpnMenu.Ini';

//*****************************************************************************
// Implementation of TFrmMntTndCntSafeCA.SvcTskFrmRegCountSafeCreateExecutor
//*****************************************************************************

procedure TFrmMntTndCntSafeCA.SvcTskFrmRegCountSafeCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
var
    TxtPath          : string;   // ****** Added for  Safetybox Traceability, PM (TCS), R2011.2, BDFR ******
begin  // of TFrmMntTndCntSafeCA.SvcTskFrmRegCountSafeCreateExecutor
  inherited;
 // ****** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start  ******
  if FlgLoginRequired = True then begin
    SfLogin.FrmLoginDlg := TFrmLoginFpn.Create (Application);
    ViProcCreateLogin;
    TFrmLoginFpn(SfLogin.FrmLoginDlg).ValMinimumLength := 0; //ValMinimumLength;

    try
      if SfLogin.FrmLoginDlg.ShowModal <> mrCancel then begin
         FlgOperKnown := True;
         CodSecurity := FrmLoginDlg.CodSecurity;
         IdtOperator := FrmLoginDlg.IdtOperator;
         DFpnSafeTransactionCA.CtTxtOpLogin := FrmLoginDlg.IdtOperator; //Tcs Testing
         OperatorTxtName := FrmLoginDlg.TxtName;
         OperatorIdtLanguage := FrmLoginDlg.TxtOperLanguage;
         StrLstIniSec := TStringList.Create;
         TxtPath := ExtractFilePath (ExtractFileDir (Application.ExeName));
         //If ViTxtFNIni = '' then
         //     ViTxtFNIni := TxtPath + AppendTrailBackSlash (ViTxtDirIni) + ViTxtFNIni;
         ViTxtFNIni :=  TxtPath + AppendTrailBackSlash (ViTxtDirIni) + CtIniFileName;
         SmUtils.OpenIniFile (ViTxtFNIni, IniFilMenuObj);
         //IniFilMenuObj.ReadSectionValues ('General', StrLstIniSec);
         IniFilMenuObj.ReadSectionValues ('COUNTSAFE', StrLstIniSec);
         //FAuthorisation := StrLstIniSec.Values['Auth'];
         FAuthorisation := StrLstIniSec.Values['SuperV'];
         StrLstIniSec.Free;
         StrLstIniSec := nil;
         IniFilMenuObj.Free;
         IniFilMenuObj := nil;
         If CodSecurity >= StrToInt(FAuthorisation) then begin
            NewObject := TFrmTndRegCountSafeCA.Create (Application);
            FlgCreated := True;
            SvcTskFrmRegCountSafe.DynamicExecutor := False;
         end
         else begin
            MessageDlg (CtTxtAuthorisation, mtinformation, [mbOK], 0);
            FlgCreated := False;
            SvcTskFrmRegCountSafe.DynamicExecutor := False;
            Application.Terminate;
            Exit;
         end;
      end
      else begin
        Application.Terminate;
        Exit;
      end;
    finally
      FrmLoginDlg.Release;
      FrmLoginDlg := nil;

    end;
  end
  else begin

      NewObject := TFrmTndRegCountSafeCA.Create (Application);
      FlgCreated := True;
      SvcTskFrmRegCountSafe.DynamicExecutor := False;


  end;
// ***** Added for  Safetybox Traceability, PM (TCS), R2011.2, BDFR - End ****


//Below code is commented by P.M.(TCS) for SD04 - R2011 BDFR Safetybox Traceability on 11-jan-2011

  {NewObject := TFrmTndRegCountSafeCA.Create (Application);
   FlgCreated := True;
   SvcTskFrmRegCountSafe.DynamicExecutor := False; }

// End of commented code

end;   // of TFrmMntTndCntSafeCA.SvcTskFrmRegCountSafeCreateExecutor

// **** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - Start ****
//==============================================================================================
// TFrmMntTndCntSafeCA.BeforeCheckRunParams
//==============================================================================================
procedure TFrmMntTndCntSafeCA.BeforeCheckRunParams;
begin  // of TFrmMntCustomerCA.BeforeCheckRunParams
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
    AddRunParams ('/VRELOGIN', CtTxtRelogin);
    AddRunParams ('/VRCK',CtTxtRemoveChequeKDO );                               //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
    AddRunParams ('/VNbC', CtTxtNbrofCheques);                                  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
end;   // of TFrmMnt

//==============================================================================================
// TFrmMntTndCntSafeCA.CheckAppDependParams: Check if relogin is required
//==============================================================================================
procedure TFrmMntTndCntSafeCA.CheckAppDependParams (TxtParam : string);
begin  // of TFrmMntCustomerCA.CheckAppDependParams
  //FlgLoginRequired := False;                                                  //Commented for R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  DFpnSafeTransactionCA.CtTxtFlgLogin := False;
  FlgIniSpl := False;
  if AnsiUpperCase (Copy (TxtParam, 3, 3)) = 'RCK' then                //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
         FlgRemoveChequeKDO := True  ;                                 //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
  if AnsiCompareText (Copy(TxtParam, 3, 7), 'RELOGIN') = 0 then
    FlgLoginRequired := True;
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if AnsiCompareText (Copy (TxtParam, 3, 3), 'NbC') = 0 then
    FlgNbrofCheques := True;
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  DFpnSafeTransactionCA.CtTxtFlgLogin := True;

end;   // of TFrmMntCustomerCA.CheckAppDependParams
//=============================================================================
// TFrmMntTndCntSafeCA.DefineStandardRunParams : fill in the standard runparameters.
//=============================================================================
procedure TFrmMntTndCntSafeCA.DefineStandardRunParams;
begin  // of TFrmPrnSpl.DefineStandardRunParams
  inherited;
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'IV';
end;   // of TFrmPrnSpl.DefineStandardRunParams
//=============================================================================
// **** Added for Safetybox Traceability, PM (TCS), R2011.2, BDFR - End ****
procedure TFrmMntTndCntSafeCA.SvcTskFrmRptCntSafeCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntTndCntSafeCA.SvcTskFrmRptCntSafeCreateExecutor
  NewObject := TFrmVSRptTndCntSafeCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmRptCntSafe.DynamicExecutor := False;
end;   // of TFrmMntTndCntSafeCA.SvcTskFrmRptCntSafeCreateExecutor

//=============================================================================

procedure TFrmMntTndCntSafeCA.SvcTskFrmRptCntSafeExecute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
begin  // of TFrmMntTndCntSafeCA.SvcTskFrmRptCntSafeExecute
  inherited;
  try // R2011.2 TCS(Mohan) Bug 17 : Added try & except bloak
    TFrmVSRptTndCntSafeCA(TSvcFormTask(Sender).Executor).GenerateReport;
  except
   { }
  end;

{  TFrmVSRptTndCntSafeCA(TSvcFormTask(Sender).Executor).VspPreview.PrintDoc
    (False, Null, Null);
  FlgAllow := False;}
end;   // of TFrmMntTndCntSafeCA.SvcTskFrmRptCntSafeExecute

//=============================================================================

//Regression Fix R2012.1 (Chayanika):start
procedure TFrmMntTndCntSafeCA.FormActivate(Sender: TObject);
begin
  inherited;
 Application.Title := CtTxtTitle;
end;
//Regression Fix R2012.1 (Chayanika) :end
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FMntTndCntSafeCA 
