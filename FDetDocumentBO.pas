//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : Castorama Development
// Unit   : FDetDocumentBO.Pas : Form Detail document Back Office
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetDocumentBO.pas,v 1.1 2006/12/22 11:22:59 hofmansb Exp $
// History:
//1.40   KC   (TCS) R2012.1 - CAFR - Anomalies doc bo
//1.41   GG   (TCS) R2012.1 -CAFR - 31 Internal Defect Fix
//=============================================================================

unit FDetDocumentBO;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OvcBase, ComCtrls, StdCtrls, Buttons, ExtCtrls, Db, OvcEF,
  OvcPB, OvcPF, OvcDbPF, ScDBUtil, DBTables, Grids, DBGrids, ScUtils,
  SfDetail_BDE_DBC, ScDBUtil_Ovc, ScDBUtil_BDE,sflist_BDE_DBC;

resourcestring
  CtTxtConnectSucceeded = 'Connection Succeeded';
  CtTxtConnectFailed    = 'Connection Failed';

//=============================================================================
// Global type definitions
//=============================================================================

type
  TFrmDetDocumentBO = class(TFrmDetail)
    DscDocumentBO: TDataSource;
    SvcDBLblIdtPosTransaction: TSvcDBLabelLoaded;
    SvcDBLFIdtPosTransaction: TSvcDBLocalField;
    SvcDBLFIdtCheckout: TSvcDBLocalField;
    SvcDBLblIdtCheckout: TSvcDBLabelLoaded;
    SvcDBLFDatTransBegin: TSvcDBLocalField;
    SvcDBLblDatTransBegin: TSvcDBLabelLoaded;
    SvcDBLFIdtCVente: TSvcDBLocalField;
    SvcDBLblIdtCVente: TSvcDBLabelLoaded;
    SvcDBLblCodTypeVente: TSvcDBLabelLoaded;
    SvcDBLFCodTypeVente: TSvcDBLocalField;
    SvcDBLFTimTransBegin: TSvcDBLocalField;
    TabShtDocumentBOTrans: TTabSheet;
    SbxArticle: TScrollBox;
    DBGrid1: TDBGrid;
    DscDocBOTrans: TDataSource;
    BtnModifyDocNb: TBitBtn;
    BtnConnect: TBitBtn;
    SvcLFTypeText: TSvcLocalField;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnConnectClick(Sender: TObject);
    procedure BtnModifyDocNbClick(Sender: TObject);
    procedure SvcDBLFCodTypeVenteChange(Sender: TObject);
  private
  public
    procedure FillQuery (QryToFill : TQuery); override;
    procedure PrepareFormDependJob; override;
    procedure PrepareDataDependJob; override;
  end;

var
  FrmDetDocumentBO: TFrmDetDocumentBO;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SmUtils,
  SfDialog,
  ScTskMgr_BDE_DBC,

  DFpnUtils,
  DFpn,
  // KC - CAFR:2012.1 - Anomalies doc bo (start)
  DFpnPosTransactionCA,
  DFpnBODocument,

  SrStnCom, 
  FVSRptDocumentBO, FLstDocumentBO;
  // KC - CAFR:2012.1 - Anomalies doc bo (End)

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetDocumentBO';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetDocumentBO.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 11:22:59 $';
resourcestring
 CtTxtTitle = 'Maintenance BO Doc- Detail';       //Anamolies Doc BO R2012 31 Internal Defect Fix(GG)
//*****************************************************************************
// Implementation of TFrmDetDocumentBO
//*****************************************************************************

//=============================================================================
// TFrmDetDocumentBO.FillQuery : Fill in the primary keys for a query
//                                  -----
// INPUT  : QryToFill = The query of which the parameters have to be changed
//                                  -----
// OUTPUT : QryToFill = The query with the changed parameters to return
//=============================================================================

procedure TFrmDetDocumentBO.FillQuery (QryToFill : TQuery);
begin  // of TFrmDetDocumentBO.FillQuery
  if (QryToFill = DscDocumentBO.DataSet) or
     (QryToFill = DscDocBOTrans.DataSet) then begin
    // Make record
    QryToFill.ParamByName ('PrmIdtPosTransaction').Text :=
      StrLstIdtValues.Values['IdtPosTransaction'];
    QryToFill.ParamByName ('PrmIdtCheckout').Text :=
      StrLstIdtValues.Values['IdtCheckout'];
    QryToFill.ParamByName ('PrmCodTrans').Text :=
      StrLstIdtValues.Values['CodTrans'];
    QryToFill.ParamByName ('PrmDatTransBegin').AsDateTime :=
      SysUtils.StrToDateTime (StrLstIdtValues.Values['DatTransBegin']);
    if QryToFill = DscDocumentBO.DataSet then begin
      QryToFill.ParamByName ('PrmIdtCVente').Text :=
        StrLstIdtValues.Values['IdtCVente'];
      QryToFill.ParamByName ('PrmCodTypeVente').Text :=
        StrLstIdtValues.Values['CodTypeVente'];
    end;
  end
end;   // of TFrmDetDocumentBO.FillQuery

//=============================================================================
// TFrmDetDocumentBO.PrepareFormDependJob : Focus the correct control
//=============================================================================

procedure TFrmDetDocumentBO.PrepareFormDependJob;
begin  // of TFrmDetDocumentBO.PrepareFormDependJob
  try
    inherited;
    // Give focus to a control according to the started job
    EnableControl (BtnConnect);
    EnableControl (BtnModifyDocNb);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;   // of TFrmDetDocumentBO.PrepareFormDependJob

//=============================================================================
// TFrmDetDocumentBO.PrepareDataDependJob : Activates dataset and changes button
// states
//=============================================================================

procedure TFrmDetDocumentBO.PrepareDataDependJob;
begin  // of TFrmDetDocumentBO.PrepareDataDependJob
  try
    inherited;

    if not (CodJob in [CtCodJobRecNew]) then
      ActivateDataSet (DscDocBOTrans.DataSet);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;   // of try ... except block
end;   // of TFrmDetDocumentBO.PrepareDataDependJob

//=============================================================================

procedure TFrmDetDocumentBO.FormCreate(Sender: TObject);
begin  // of TFrmDetDocumentBO.FormCreate
  inherited;
  try
    LstDstStartUp.Add (DscDocumentBO.DataSet);

    AddIdtControls ([SvcDBLFIdtPosTransaction]);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
  self.caption:= CtTxtTitle;  //Anamolies Doc BO R2012 31 Internal Defect Fix(GG)
  Application.Title :=CtTxtTitle; //31 Internal Defect Fix(GG)
  end;   // of TFrmDetDocumentBO.FormCreate

//=============================================================================

procedure TFrmDetDocumentBO.BtnConnectClick(Sender: TObject);
begin  // of TFrmDetDocumentBO.BtnConnectWithBODocClick
  inherited;

  try
    DmdFpnBODocument.FlgLogging := True;
    if not DmdFpnBODocument.LinkTicketToBODoc (
        DscDocumentBO.DataSet.FieldByName ('IdtPosTransaction').AsInteger,
        DscDocumentBO.DataSet.FieldByName ('IdtCheckout').AsInteger,
        DscDocumentBO.DataSet.FieldByName ('IdtOperator').AsInteger,
        DscDocumentBO.DataSet.FieldByName ('CodTrans').AsInteger,
        DscDocumentBO.DataSet.FieldByName ('DatTransBegin').AsDateTime,
        DscDocumentBO.DataSet.FieldByName ('IdtCVente').AsInteger) then begin
    // CAFR : Anomalies doc BO 2012.1 - Start(KC)
      MessageDlg (CtTxtConnectFailed, mtError, [mbOk], 0);
       DmdFpnBODocument.ChangePosTransCodType
      (DscDocumentBO.DataSet.FieldByName ('IdtPosTransaction').AsInteger,
       DscDocumentBO.DataSet.FieldByName ('DatTransBegin').AsDateTime,
       DscDocumentBO.DataSet.FieldByName ('CodTrans').AsInteger,
       DscDocumentBO.DataSet.FieldByName ('IdtCheckout').AsInteger,
       DscDocumentBO.DataSet.FieldByName ('IdtCVente').asInteger,
       CtCodPdtInfoDocBOConnFail);
     end
   // CAFR : Anomalies doc BO 2012.1 - End(KC)
    else begin
      MessageDlg (CtTxtConnectSucceeded, mtInformation, [mbOk], 0);
      DmdFpnBODocument.QryDetDocumentBO.Active := False;
      ActivateDataSet (DscDocumentBO.DataSet);
    end;
  except
    if DmdFpn.DbsFlexPoint.InTransaction then
      DmdFpn.DbsFlexPoint.Rollback;
    raise;
  end;
end;  // of TFrmDetDocumentBO.BtnConnectWithBODocClick

//=============================================================================

procedure TFrmDetDocumentBO.BtnModifyDocNbClick(Sender: TObject);
begin  // of TFrmDetDocumentBO.BtnChangeDocNbClick
  inherited;
  if SvcTaskMgr.LaunchTask ('ChangeDocBONb') then begin
    DscDocumentBO.DataSet.Active := False;
    ActivateDataSet (DscDocumentBO.DataSet);
  end;
end;   // of TFrmDetDocumentBO.BtnChangeDocNbClick

//=============================================================================

procedure TFrmDetDocumentBO.SvcDBLFCodTypeVenteChange(Sender: TObject);
begin
  inherited;
  if SvcDBLFCodTypeVente.AsInteger <= CtCodLastDoc then
    SvcLFTypeText.AsString := ViArrTxtShortDescrDoc
                                [SvcDBLFCodTypeVente.AsInteger];
end;

// 31 Internal Defect Fix GG -Start
procedure TFrmDetDocumentBO.FormActivate(Sender: TObject);
begin
  inherited;
     self.caption:= CtTxtTitle;  //Anamolies Doc BO R2012
  Application.Title :=CtTxtTitle;
end;
// 31 Internal Defect Fix - End
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FDetDocumentBO
