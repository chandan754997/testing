//================= Real Software - Retail Division (c) 2006 ==================
// Packet   : FlexPoint 2.0.1
// Customer : Castorama
// Unit     : FDetCarteCadeauCA.PAS : : Form DETail Carte Cadeau CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCarteCadeauCA.pas,v 1.2 2006/12/20 13:00:38 JurgenBT Exp $
// History:
//  - Started from Castorama - Flexpoint 2.0 - FDetCarteCadeauCA - CVS revision 1.2
//=============================================================================


unit FDetCarteCadeauCA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfDetail_BDE_DBC, ovcbase, ComCtrls, StdCtrls, Buttons, ExtCtrls, DB,
  ScDBUtil_BDE, ScFile, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDBEdit, ScDBUtil_Dx, ovcef, ovcpb, ovcpf, ovcdbpf, ScDBUtil_Ovc, ScUtils_Dx,dbtables;


resourcestring

CtTxtInvaliddays = 'Days Valid should be between 10 and 370' ;



type
  TFrmDetCarteCadeauCA = class(TFrmDetail)
    DscCarteCadeau: TDataSource;
    SvcDBLabelLoaded1: TSvcDBLabelLoaded;
    SvcDBLabelLoaded2: TSvcDBLabelLoaded;
    CarteCadeau: TSvcFileMaskEdit;
    SvcDBLabelLoaded3: TSvcDBLabelLoaded;
    SvcDBMEDaysValid: TSvcDBMaskEdit;
    TabShtGeneralities: TTabSheet;
    SvcDBLabelLoaded4: TSvcDBLabelLoaded;
    SvcDBMaskEdit1: TSvcDBMaskEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  protected

  procedure SetDataSetReferences; override;

  public
    { Public declarations }
    procedure FillQuery (QryToFill : TQuery); override;
    procedure PrepareFormDependJob; override;
    procedure AdjustDataBeforeSave; override;

  end;

var
  FrmDetCarteCadeauCA: TFrmDetCarteCadeauCA;

implementation

{$R *.dfm}

uses
SmDBUtil_BDE,

SfDialog,
  SmUtils,
  SrStnCom,

  DFpnUtils,
  DFpnCarteCadeau;


procedure TFrmDetCarteCadeauCA.FormCreate(Sender: TObject);
begin  // of TFrmDetCarteCadeauCA.FormCreate
  try
    inherited;

    LstDstStartUp.Add (DscCarteCadeau.DataSet);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;   // of try ... except block
end;   // of TFrmDetCarteCadeauCA.FormCreate

procedure TFrmDetCarteCadeauCA.FillQuery (QryToFill : TQuery);
begin  // of TFrmDetCarteCadeauCA.FillQuery
  if QryToFill = DscCarteCadeau.DataSet then
    if (CodJob in [CtCodJobRecNew]) then
      QryToFill.ParamByName ('PrmIdtArtCode').Clear
    else
      // Make record
      QryToFill.ParamByName ('PrmIdtArtCode').Text :=
        StrLstIdtValues.Values['IdtArtCode'];
end;   // of TFrmDetCarteCadeauCA.FillQuery


procedure TFrmDetCarteCadeauCA.SetDataSetReferences;
begin  // of TFrmDetCarteCadeauCA.SetDataSetReferences
  inherited;
  DscCarteCadeau.DataSet := DmdFpnCarteCadeau.QryDetCarteCadeau;
end;   // of TFrmDetCarteCadeauCA.SetDataSetReferences

procedure TFrmDetCarteCadeauCA.PrepareFormDependJob;
begin  // of TFrmDetCarteCadeauCA.PrepareFormDependJob
  try
    inherited;

    // Give focus to a control according to the started job
    if not (CodJob in [CtCodJobRecDel, CtCodJobRecCons]) then
      ActiveControl := SvcDBMEDaysValid

  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;   // of TFrmDetCarteCadeauCA.PrepareFormDependJob


procedure TFrmDetCarteCadeauCA.AdjustDataBeforeSave;
begin  // of TFrmDetCarteCadeauCA.AdjustDataBeforeSave
  inherited;
  if (CodJob in [CtCodJobRecNew, CtCodJobRecMod]) and
     (DscCarteCadeau.DataSet.FieldByName ('DaysValid').AsString = '') or (DscCarteCadeau.DataSet.FieldByName ('DaysValid').AsInteger > 370)
      or(DscCarteCadeau.DataSet.FieldByName ('DaysValid').AsInteger < 10) then begin
    if not SvcDBMEDaysValid.CanFocus then
      SvcDBMEDaysValid.Show;
    SvcDBMEDaysValid.SetFocus;
    raise Exception.Create (//TrimTrailColon (SvcDBLabelLoaded3.Caption) +
                             CtTxtInvaliddays);
  end;
                              

end;   // of TFrmDetCountry.AdjustDataBeforeSave
 //end;
//=============================================================================




end.
