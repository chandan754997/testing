//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : FlexPoint Development
// Unit   : FLstOperatorCA.pas : LiST of OPERATORs
// Customer   :  Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstOperatorCA.pas,v 1.1 2006/12/21 11:25:43 hofmansb Exp $
// History:
//
//=============================================================================
// Version                              Modified By                          Reason
// V 1.2                                SM (TCS)                             R2011.2 - Regression Fix DefectId#6
// V 1.3                                SM (TCS)                             R2012.1 - SecurityPoints 47
// V 1.4                                SM (TCS)                             R2012.1 - SecurityPoints 47 (System 3 Fix)                     

unit FLstOperatorCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, Db, OvcBase, ComCtrls, OvcEF, OvcPB, OvcPF,
  StdCtrls, Buttons, Grids, DBGrids, SmUtils, SfList_BDE_DBC,DBTables,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ScUtils;    //Regression Fix (SM) R2011.2

//*****************************************************************************
// Form-declaration.
//*****************************************************************************
resourcestring
ctTxtAppTitle = 'Maintenance Operator';                                             //Regression Fix (SM) R2011.2
type
  TFrmLstOperatorCA = class(TFrmList)
    BtnInitSecretCode: TSpeedButton;
    MniSep4: TMenuItem;
    MniInitSecretCode: TMenuItem;
    Button1: TButton;                                                              // Security Point (SM), R2012.1 (System Test 3 Fix)          
    procedure Button1Click(Sender: TObject);                                       // Security Point (SM), R2012.1 (System Test 3 Fix)   
    //procedure SpeedButton1Click(Sender: TObject);                                // Security Point (SM), R2012.1 (System Test 3 Fix)
    procedure MniInitSecretCodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FFlgNoSecretCode    : Boolean;     // Indicate if init of secret code is
                                       // allowed
    FFlgActiveSupport   : Boolean;     // Security Point (SM), R2012.1
    procedure SetFlgNoSecretCode (Value : Boolean);
  public
    { Public declarations }
  published
    property FlgNoSecretCode : Boolean read FFlgNoSecretCode
                                       write SetFlgNoSecretCode;
    property FlgActiveSupport : Boolean read FFlgActiveSupport             // Security Point (SM), R2012.1
                                       write FFlgActiveSupport;
  end;   // of TFrmLstOperatorCA

//=============================================================================

var
  FrmLstOperatorCA: TFrmLstOperatorCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,

  DFpnUtils,
  DFpnOperatorCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLstOperatorCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstOperatorCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2012/05/04 11:25:43 $';


//=============================================================================

procedure TFrmLstOperatorCA.SetFlgNoSecretCode (Value : Boolean);
begin  // of TFrmLstOperatorCA.SetFlgNoSecretCode
  FFlgNoSecretCode := Value;
  BtnInitSecretCode.Visible := not Value;
end;   // of TFrmLstOperatorCA.SetFlgNoSecretCode

//=============================================================================

procedure TFrmLstOperatorCA.FormActivate (Sender: TObject);
begin  // of TFrmLstOperatorCA.FormActivate
  inherited;
  if FlgActiveSupport then                                                   // Security Point (SM), R2012.1
  //SpeedButton1.Visible:=true;                                              // Security Point (SM), R2012.1 (System Test 3 Fix)
  Button1.Visible:=True;                                                     // Security Point (SM), R2012.1 (System Test 3 Fix)
  ConfigOneJob (MniInitSecretCode, BtnInitSecretCode,
                CtCodJobRecMod in AllowedJobs);
end;   // of TFrmLstOperatorCA.FormActivate

//=============================================================================
//=============================================================================

procedure TFrmLstOperatorCA.FormCreate (Sender: TObject);
begin  // of TFrmLstOperatorCA.FormActivate
  Application.Title := ctTxtAppTitle;                                                     //Regression Fix (SM) R2011.2

end;   // of TFrmLstOperatorCA.FormActivate

//=============================================================================

procedure TFrmLstOperatorCA.MniInitSecretCodeClick (Sender: TObject);
begin  // of TFrmLstOperatorCA.MniInitSecretCodeClick
  inherited;
  if MessageDlg (Format (CtTxtConfirmReset,
                         [DmdFpnUtils.CodSecurityCurrentOperator]),
                 mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    DmdFpnOperatorCA.ResetSecretCode (DmdFpnUtils.CodSecurityCurrentOperator);
end;   // of TFrmLstOperatorCA.MniInitSecretCodeClick

//=============================================================================

{procedure TFrmLstOperatorCA.SpeedButton1Click(Sender: TObject);                      // Security Point (SM), R2012.1 (System Test 3 Fix)::START
begin
DmdFpnOperatorCA.SetFlagStatus;
end;}
//=============================================================================


procedure TFrmLstOperatorCA.Button1Click(Sender: TObject);                          
begin
DmdFpnOperatorCA.SetFlagStatus;
end;                                                                                  // Security Point (SM), R2012.1 (System Test 3 Fix)::END


initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FLstOperatorCA
