//=========== Sycron Computers Belgium (c) 2001 ===============================
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FDetCustCardCA : Form DETail CUSTomer CARD CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCustCardCA.pas,v 1.2 2008/04/22 07:40:02 dietervk Exp $
// History:
//=============================================================================

unit FDetCustCardCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetCustCard, DB, ovcbase, ComCtrls, StdCtrls, Buttons, DBCtrls,
  ovcef, ovcpb, ovcpf, ovcdbpf, ScDBUtil_Ovc, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, ScUtils_Dx, ScDBUtil_BDE, ExtCtrls;

//=============================================================================
// TFrmDetCustCard
//=============================================================================

type
  TFrmDetCustCardCA = class(TFrmDetCustCard)
    SvcDBLblDatRelease: TSvcDBLabelLoaded;
    SvcDBLFDatRelease: TSvcDBLocalField;
    SvcDBLblCodDiscount: TSvcDBLabelLoaded;
    DBLkpCbxCodDiscount: TDBLookupComboBox;
    SvcDBLblPctDiscount: TSvcDBLabelLoaded;
    SvcDBLFPctDiscount: TSvcDBLocalField;
    SvcDBLblFlgPoints: TSvcDBLabelLoaded;
    DBCbxFlgPoints: TDBCheckBox;
    SvcDBLblFlgRebate: TSvcDBLabelLoaded;
    DBCbxFlgRebate: TDBCheckBox;
    SvcDBLblNumMasterCard: TSvcDBLabelLoaded;
    SvcDBLFNumMasterCard: TSvcDBLocalField;
    SvcDBLblFlgActive: TSvcDBLabelLoaded;
    DBCbxFlgActive: TDBCheckBox;
    procedure DBLkpCbxCodDiscountClick(Sender: TObject);
  
    procedure SvcDBLFNumCardUserValidation(Sender: TObject;
      var ErrorCode: Word);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    FCodCreatorForNew   : string;      // CodCreator for new CustCard
  public
    { Public declarations }
    property CodCreatorForNew : string read  FCodCreatorForNew
                                       write FCodCreatorForNew;
    procedure PrepareDataDependJob; override;
    procedure AdjustDataBeforeSave; override;
  end;

var
  FrmDetCustCardCA: TFrmDetCustCardCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCustCardCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCustCardCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2008/04/22 07:40:02 $';

//*****************************************************************************
// Implementation of TFrmDetCustCardCA
//*****************************************************************************

procedure TFrmDetCustCardCA.PrepareDataDependJob;
begin  // of TFrmDetCustCardCA.PrepareDataDependJob
  try
    inherited;
    // Fill in Idt's for new record
    if CodJob = CtCodJobRecNew then begin
      DscCustCard.DataSet.FieldByName ('CodCreator').Text := CodCreatorForNew;
    end;
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;   // of TFrmDetCustCardCA.PrepareDataDependJob

//=============================================================================

procedure TFrmDetCustCardCA.AdjustDataBeforeSave;
begin  // of TFrmDetCustCardCA.AdjustDataBeforeSave
  inherited;
end;   // of TFrmDetCustCardCA.AdjustDataBeforeSave

//=============================================================================

procedure TFrmDetCustCardCA.FormCreate(Sender: TObject);
begin
  try
    SetDataSetReferences;

    LstDstStartUp.Add (DscCustCard.DataSet);

    if not FlgAllowModNumCard then
      AddIdtControls ([SvcDBLFNumCard]);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;

//=============================================================================

procedure TFrmDetCustCardCA.FormActivate(Sender: TObject);
begin  // of TFrmDetCustCardCA.FormActivate
  try                             // Fill in properties
    if CodJob = CtCodJobRecNew then
      CodCreatorForNew := StrLstRelatedInfo.Values['CodCreator'];
    inherited;
    if DBLkpCbxCodDiscount.Text = '' then
    SvcDBLFPctDiscount.Enabled := False
 else
    SvcDBLFPctDiscount.Enabled := True;

  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;   // of try ... except block
end;   // of TFrmDetCustCardCA.FormActivate

//=============================================================================

procedure TFrmDetCustCardCA.SvcDBLFNumCardUserValidation(Sender: TObject;
  var ErrorCode: Word);
begin
  ;   // No check
end;

//=============================================================================

procedure TFrmDetCustCardCA.DBLkpCbxCodDiscountClick(Sender: TObject);
begin
  inherited;
  if DBLkpCbxCodDiscount.Text = '' then begin
    SvcDBLFPctDiscount.Text := '';
    SvcDBLFPctDiscount.Enabled := False;
  end
  else
    SvcDBLFPctDiscount.Enabled := True;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FDetCustCardCA
