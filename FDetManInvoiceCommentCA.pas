//=========== Sycron Computers Belgium (c) 2003 ===============================
// Packet : Manuel Invoice
// Unit   : FDetManInvoiceCommentCA.PAS : Form DETail MANuele INVOICES Comment
// Customer : Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetManInvoiceCommentCA.pas,v 1.2 2006/12/22 13:39:44 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FDetManInvoiceCommentCA - CVS revision 1.4
//=============================================================================

unit FDetManInvoiceCommentCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OvcBase, OvcEF, OvcPB, OvcPF, ScUtils, StdCtrls, ScDBUtil,
  ComCtrls, Buttons, ExtCtrls, MMntInvoice, SfDetail_BDE_DBC, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ScDBUtil_BDE;

//=============================================================================
// Global resourcestrings
//=============================================================================

resourcestring
  CtTxtTitle              = 'Fill in fiscal info';
  CtTxtFiscalInfo         = 'Fiscal info';
  CtTxtInputRequired      = 'Please fill in all fiscal info!';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

//=============================================================================
// TFrmDetManInvoiceCommentCA
//=============================================================================

type
  TFrmDetManInvoiceCommentCA = class(TFrmDetail)
    TabShtComments: TTabSheet;
    SvcDBLblComment: TSvcDBLabelLoaded;
    SvcMEComment: TSvcMaskEdit;
    procedure SvcMECommentPropertiesChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure SvcLFCommentChange(Sender: TObject);
  private
    { Private declarations }
    TxtFormCaption      : string;
    TxtLabelCaption     : string;
    TxtTabShtCaption    : string;
  protected
    FObjTransaction     : TObjTransaction;  // Information of the article
    FFlgFiscalInfo: Boolean;    
    procedure LoadObjInForm; virtual;
    procedure SaveFormToObj; virtual;
  public
    { Public declarations }
    procedure PrepareFormDependJob; override;
  published
    property ObjTransaction : TObjTransaction read FObjTransaction
                                              write FObjTransaction;
    property FlgFiscalInfo: Boolean read FFlgFiscalInfo
                               write FFlgFiscalInfo;
  end;  // of TFrmDetManInvoiceCommentCA

var
  FrmDetManInvoiceCommentCA: TFrmDetManInvoiceCommentCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetManInvoiceCommentCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FDetManInvoiceCommentCA.pas  $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:39:44 $';

//*****************************************************************************
// Implementation of TFrmDetManInvoiceCommentCA
//*****************************************************************************

procedure TFrmDetManInvoiceCommentCA.LoadObjInForm;
begin  // of TFrmDetManInvoiceCommentCA.LoadObjInForm
  SvcMEComment.Text := ObjTransaction.TxtDescrComment;
end;   // of TFrmDetManInvoiceCommentCA.LoadObjInForm

//=============================================================================

procedure TFrmDetManInvoiceCommentCA.SaveFormToObj;
begin  // of TFrmDetManInvoiceCommentCA.SaveFormToObj
  ObjTransaction.TxtDescrComment := SvcMEComment.Text;
end;   // of TFrmDetManInvoiceCommentCA.SaveFormToObj

//=============================================================================

procedure TFrmDetManInvoiceCommentCA.PrepareFormDependJob;
begin  // of TFrmDetManInvoiceCommentCA.PrepareFormDependJob
  inherited;
  if SvcMEComment.Enabled then
    SvcMEComment.SetFocus;
end;   // of TFrmDetManInvoiceCommentCA.PrepareFormDependJob

//=============================================================================

procedure TFrmDetManInvoiceCommentCA.FormActivate(Sender: TObject);
begin  // of TFrmDetManInvoiceCommentCA.FormActivate
  inherited;
  if FlgFiscalInfo then begin
    TxtFormCaption := Self.Caption;
    TxtLabelCaption := SvcDBLblComment.Caption;
    TxtTabShtCaption := TabShtComments.Caption;
    Self.Caption := CtTxtTitle;
    SvcDBLblComment.Caption := CtTxtFiscalInfo + ':';
    TabShtComments.Caption := CtTxtFiscalInfo;
  end
  else if TxtFormCaption <> '' then begin
    Self.Caption := TxtFormCaption;
    SvcDBLblComment.Caption := TxtLabelCaption;
    TabShtComments.Caption := TxtTabShtCaption;
  end;
  LoadObjInForm;
  SvcLFCommentChange(Self);
end;   // of TFrmDetManInvoiceCommentCA.FormActivate

//=============================================================================

procedure TFrmDetManInvoiceCommentCA.BtnOKClick(Sender: TObject);
begin  // of TFrmDetManInvoiceCommentCA.BtnOKClick
  inherited;
  if FlgFiscalInfo and (SvcMEComment.Text = '') then begin
    MessageDlg(CtTxtInputRequired, mtError, [mbOk], 0);
    Self.ModalResult := mrNone;
    SvcMEComment.SetFocus;
    exit;
  end
  else if FlgFiscalInfo then
    SvcMEComment.Text := FormatDateTime ('dd/mm/yyyy', Now) + ' - ' +
                         SvcMEComment.Text;
  SaveFormToObj;
end;   // of TFrmDetManInvoiceCommentCA.BtnOKClick

//=============================================================================

procedure TFrmDetManInvoiceCommentCA.SvcLFCommentChange(Sender: TObject);
begin  // of  TFrmDetManInvoiceCommentCA.SvcLFCommentChange
  inherited;
  if SvcMEComment.Text = '' then
    btnOk.Enabled := False
  else
    btnOk.Enabled := True;
end;   // of TFrmDetManInvoiceCommentCA.SvcLFCommentChange

//=============================================================================

procedure TFrmDetManInvoiceCommentCA.SvcMECommentPropertiesChange(
  Sender: TObject);
begin  // of TFrmDetManInvoiceCommentCA.SvcMECommentPropertiesChange
  inherited;
  if SvcMEComment.Text = '' then
    btnOk.Enabled := False
  else
    btnOk.Enabled := True;
end;   // of TFrmDetManInvoiceCommentCA.SvcMECommentPropertiesChange

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FDetManInvoiceCommentCA
