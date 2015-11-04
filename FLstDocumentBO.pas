//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : Castorma Development
// Unit   : FLstDocumentBO.pas = Form LiST DOCUMENT BackOffice
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstDocumentBO.pas,v 1.2 2007/09/18 14:32:58 smete Exp $
// History:
// 1.30    KC   (TCS) R2012.1 - CAFR - Anomalies doc bo
// 1.31    GG   (TCS) R2012.1 - CAFR - 31 Internal Defect Fix 
//=============================================================================

unit FLstDocumentBO;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, Db, OvcBase, ComCtrls, OvcEF, OvcPB, OvcPF,
  ScUtils, StdCtrls, Buttons, Grids, DBGrids, ScEHdler, SfList_BDE_DBC,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx;

//*****************************************************************************
// Implementation of TFrmLstDocumentBO
//*****************************************************************************

type
  TFrmLstDocumentBO = class(TFrmList)
    BtnReportGlobal: TSpeedButton;
    BvlBtnReport: TBevel;
    BtnReportDetail: TSpeedButton;
    procedure BtnReportGlobalClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnReportDetailClick(Sender: TObject);
    procedure MniRecDelClick(Sender: TObject);
    procedure MniSeqRefreshClick(Sender: TObject);

    // KC - CAFR:2012.1 - Anomalies doc bo(start)
    procedure DBGrdListDrawColumnCell(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
    // KC - CAFR:2012.1 - Anomalies doc bo(End)

  private
    { Private declarations }
    FFlgCAFR           : Boolean;         //Regression Defect Fix R2012
  protected
    FNumDaysInfo       : integer;         //Max days info to give
    FFlgDetButton      : boolean;         //Connect documents
  public
    { Public declarations }
    property FlgCAFR : Boolean read FFlgCAFR write FFlgCAFR; //Regression Defect Fix R2012
  published
    property NumDaysInfo : integer read FNumDaysInfo write FNumDaysInfo;
    property FlgDetButton : boolean read FFlgDetButton write FFlgDetButton;
  end;

var
  FrmLstDocumentBO: TFrmLstDocumentBO;

resourcestring
CtTxtTitle = 'Maintenance Doc Bon De Commande';   //Anamolies Doc BO R2012 31 Internal Defect Fix(GG)
//*****************************************************************************

implementation

{$R *.DFM}

uses
  DBTables,
  SmUtils,
  ScTskMgr_BDE_DBC,
  SfDialog,
  SrStnCom,
  DFpnBODocument,
  DFpnPosTransactionCA,
  FVSRptDocumentBO;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLstDocumentBO';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstDocumentBO.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.30 $';
  CtTxtSrcDate    = '$Date: 2012/04/30 14:32:58 $';

  // CAFR : Anomalies doc BO 2012.1 - Start(KC)
const
  // Possible values of CodType
  CtCodTypeInactive = 356;
// CAFR : Anomalies doc BO 2012.1 - End(KC)

  //=============================================================================

procedure TFrmLstDocumentBO.BtnReportGlobalClick(Sender: TObject);
begin  // of TFrmLstDocumentBO.BtnReportClick
  inherited;
  SvcTaskMgr.LaunchTask ('RptDocumentBOGlobal');
end;   // of TFrmLstDocumentBO.BtnReportClick

//=============================================================================

procedure TFrmLstDocumentBO.FormActivate(Sender: TObject);
begin  // of TFrmLstDocumentBO.FormActivate
  // Show list if application is not started with /VA
  if SvcTaskMgr.ActiveTask = SvcTaskMgr.FindTask ('LstDocumentBO') then
    inherited;
  //Self.Caption := Application.Title;     //Anamolies Doc BO R2012 31 Internal Defect Fix(GG)
  self.Caption:=CtTxtTitle;           //Anamolies Doc BO R2012 31 Internal Defect Fix(GG)
  Application.Title:= CtTxtTitle;     //Anamolies Doc BO R2012 31 Internal Defect Fix(GG)
  Self.BtnReportDetail.Enabled := FlgDetButton;    
end;   // of TFrmLstDocumentBO.FormActivate

//=============================================================================

procedure TFrmLstDocumentBO.BtnReportDetailClick(Sender: TObject);
begin  // of TFrmLstDocumentBO.BtnReportDetailClick
  inherited;
  SvcTaskMgr.LaunchTask ('RptDocumentBODetail');
end;   // of TFrmLstDocumentBO.BtnReportDetailClick

//=============================================================================

procedure TFrmLstDocumentBO.MniRecDelClick(Sender: TObject);
begin  // of TFrmLstDocumentBO.MniRecDelClick
//  inherited;
  if MessageDlg (Format (CtTxtConfirmDelete,
                         [CtTxtTitleDocument + ' ' +
                          DscList.DataSet.FieldByName ('IdtCVente').asString]),
                         mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    DmdFpnBODocument.ChangePosTransCodType
      (DscList.DataSet.FieldByName ('IdtPosTransaction').AsInteger,
       DscList.DataSet.FieldByName ('DatTransBegin').AsDateTime,
       DscList.DataSet.FieldByName ('CodTrans').AsInteger,
       DscList.DataSet.FieldByName ('IdtCheckout').AsInteger,
       DscList.DataSet.FieldByName ('IdtCVente').asInteger,
       CtCodPdtInfoDocBOLocalDelete);
    DoTheRefresh;
  end;
end;   // of TFrmLstDocumentBO.MniRecDelClick

//=============================================================================

procedure TFrmLstDocumentBO.MniSeqRefreshClick(Sender: TObject);
var IsCAFR : String;  //Regression Defect Fix R2012
begin
   IsCAFR := '';   //Regression Defect Fix R2012
  // Set range if application is started with /VDAYSxx
  //Regression Defect Fix R2012 ::START
  If FlgCAFR then
    IsCAFR := 'Y'
  else
    IsCAFR := 'N';
	//Regression Defect Fix R2012 ::END
  if NumDaysInfo > 0 then begin
    TStoredProc(DscList.DataSet).ParamByName('@PrmTxtSearch').AsString :=
                                 'IdtPOSTransaction';
    TStoredProc(DscList.DataSet).ParamByName('@PrmDatTransFrom').AsString :=
                                 FormatDatetime('yyyymmdd hh:mm:ss',
                                 Now-NumDaysInfo);
    TStoredProc(DscList.DataSet).ParamByName('@PrmDatTransTo').AsString :=
                                 FormatDatetime('yyyymmdd hh:mm:ss', Now);
    TStoredProc(DscList.DataSet).ParamByName('@PrmIsCAFR').AsString :=         //Regression Defect Fix R2012
                                 IsCAFR;
  end;
  inherited;
end;


//=============================================================================
  // CAFR : Anomalies doc BO 2012.1 - Start(KC)
 procedure TFrmLstDocumentBO.DBGrdListDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Grid : TDBGrid;
  CodType : Integer;
begin
  inherited;
  Grid := sender as TDBGrid;
  CodType := Grid.DataSource.DataSet.FieldByName('CodType').AsInteger;
  if (CodType = CtCodPdtInfoDocBOConnFail)  then begin                   //31 Internal Defect Fix(KB)
   if FlgCAFR then  //Regression Defect Fix R2012
     if (gdSelected in State) then
      Grid.Canvas.Brush.Color := clSilver
     else
      Grid.Canvas.Brush.Color := clDkGray;
  end;
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State) ;

 end;
// CAFR : Anomalies doc BO 2012.1 - End(KC)
 //=============================================================================


initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FLstDocumentBO
