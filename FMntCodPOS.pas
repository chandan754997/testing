//=========== Sycron Computers Belgium (c) 1997-1998 ==========================
// Packet : FlexPos Development
// Unit   : FrmMntCodPos.PAS : MainForm MaiNTenance CodPos
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCodPOS.pas,v 1.2 2010/09/02 14:53:01 BEL\BHofmans Exp $
// History:
//Version    Modified by              Reason
// 1.1        Chayanika(TCS)     Regression Fix R2012.1
//=============================================================================

unit FMntCodPOS;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FFpnMnt, ScTskMgr_BDE_DBC;

//=============================================================================

resourcestring
CtTxtTitle = 'Maintenance Checkout Type';   // Regression Fix R2012.1(Chayanika)

//============================================================================

type
  TFrmMntCodPos = class(TFrmFpnMnt)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskLstCodPos: TSvcListTask;
    SvcTskDetCodPos: TSvcFormTask;
    procedure FormCreate(Sender: TObject);  // Regression Fix R2012.1(Chayanika)
    procedure SvcTskLstCodPosCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetCodPosCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;   // of TFrmMntPOS

var
  FrmMntCodPos: TFrmMntCodPos;

//*****************************************************************************

implementation

uses
  SfList_BDE_DBC, SfDialog,

  DFpnUtils, DFpnCodPos,

  FDetCodPos;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FrmMntCodPos';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FrmMntCodPos.pas  $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2010/09/02 14:53:01 $';

//*****************************************************************************
// Implementation of TFrmMntCodPos
//*****************************************************************************

procedure TFrmMntCodPos.SvcTskLstCodPosCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCodPos.SvcTskLstPOSCreateExecutor
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds;
  FlgCreated := True;
end;   // of TFrmMntCodPos.SvcTskLstPOSCreateExecutor

//=============================================================================

procedure TFrmMntCodPos.SvcTskDetCodPosCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCodPos.SvcTskDetPOSCreateExecutor
  NewObject := TFrmDetCodPos.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCodPos.SvcTskDetPOSCreateExecutor

//=============================================================================
// Regression Fix R2012.1(Chayanika)::start
procedure TFrmMntCodPos.FormCreate(Sender: TObject);
begin
  inherited;
   Application.Title:= CtTxtTitle;
end;
// Regression Fix R2012.1(Chayanika)::end
//===============================================================================


initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.   // of TFrmMntCodPos
  //======================================================================================
 
