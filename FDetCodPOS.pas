//=========== Sycron Computers Belgium (c) 1997-1998 ==========================
// Packet : FlexPoint Development
// Unit   : TFrmDetCodPos.PAS : Form DETail CodPos
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCodPOS.pas,v 1.1 2009/03/02 12:46:40 dietervk Exp $
// History:
//
//=============================================================================

unit FDetCodPOS;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfDetail_BDE_DBC, OvcBase, ComCtrls, StdCtrls, Buttons, ExtCtrls, ScDBUtil_BDE,
  OvcEF, OvcPB, OvcPF, OvcDbPF, Db, DbTables, DBCtrls,ScDBUtil_Dx, ScDBUtil_Ovc,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDBEdit ;

//=============================================================================
// Global type definitions
//=============================================================================

type
  TFrmDetCodPos = class(TFrmDetail)
    SvcDBLblIdtCheckout: TSvcDBLabelLoaded;
    DscPOS: TDataSource;
    TabShtCommon: TTabSheet;
    GroupBox1: TGroupBox;
    DBLkpCbxCodPos: TDBLookupComboBox;
    SvcDBLblPosType: TSvcDBLabelLoaded;
    SvcDBMEIdtcheckout: TSvcDBMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
     // Methods
    procedure FillQuery (QryToFill : TQuery); override;
    procedure PrepareFormDependJob; override;
  end;   // of TFrmDetCodPos

var
  FrmDetCodPos: TFrmDetCodPos;

//*****************************************************************************

implementation

uses
  SmUtils,
  SfDialog,
  ScTskMgr_BDE_DBC,
  SrStnCom,

  DFpnUtils,
  DFpnCodPOS;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FrmDetCodPos';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FrmDetCodPos.pas  $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2009/03/02 12:46:40 $';

//*****************************************************************************
// Implementation of TFrmDetCodPos
//*****************************************************************************

procedure TFrmDetCodPos.FillQuery (QryToFill : TQuery);
begin  // of TFrmDetCodPos.FillQuery
  if QryToFill = DscPOS.DataSet then
    if (CodJob in [CtCodJobRecNew]) then
      QryToFill.ParamByName ('PrmIdtCheckout').Clear
   else
     // Make record
     QryToFill.ParamByName ('PrmIdtCheckout').Text :=
      StrLstIdtValues.Values['IdtCheckout'];
end;   // of TFrmDetCodPos.FillQuery

//=============================================================================

procedure TFrmDetCodPos.PrepareFormDependJob;
begin  // of TFrmDetCodPos.PrepareFormDependJob
  try
    inherited;

// Give focus to a control according to the started job
      if (CodJob in [CtCodJobRecNew, CtCodJobRecCopy]) then
        ActiveControl := SvcDBMEIdtcheckout
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;   // of TFrmDetCodPos.PrepareFormDependJob

//=============================================================================

procedure TFrmDetCodPos.FormCreate(Sender: TObject);
begin  // of TFrmDetCodPos.FormCreate
  try
    inherited;

    LstDstStartUp.Add (DscPOS.DataSet);
    AddIdtControls ([SvcDBMEIdtcheckout]);

  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;   // of TFrmDetCodPos.FormCreate

//=============================================================================

procedure TFrmDetCodPos.FormActivate(Sender: TObject);
begin  // of TFrmDetCodPos.FormActivate
  try
    inherited;

    AdjustDBLkpCbxDDR (DBLkpCbxCodPos);

  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;   // of try ... except block
end;   // of TFrmDetCodPos.FormActivate

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.   // of TFrmDetCodPos

