//================ Kingfisher IT Services (c) 2012 ==========================
// Packet : FlexPoint Development
// Unit   : FChlChoiceListCA : MainForm Choice List VSview Customer
//-----------------------------------------------------------------------------
// $Header: C:\IntDev\Castorama\Flexpoint201\Develop\FChlChoiceListCA.pas,v 1.0 2013/01/10 13:45:50 srmoulik Exp $
// History:
// - Started from Flexpoint20 - FChlChoiceListCA - CVS revision 1.0
// PVCS   :  $Header: $
// Version   Modified by    Reason
// 1.0       SRM.  (TCS)    R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM
// 1.1       SPN   (TCS)    R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet
//=============================================================================

unit FChlChoiceListCA;

 //*****************************************************************************
 
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfRptVSCfgChoice_BDE_DBC, Menus, ovcbase, StdCtrls, Buttons,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef,
  ovcpb, ovcpf, ScUtils, ExtCtrls, ovcmeter,ScTskMgr_BDE_DBC,SrStnCom;

//=============================================================================

type
  TFrmRptCfgChoiceCA = class(TFrmRptCfgChoice)
    procedure MniExportToFileClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AdjustRptExportDialogs; override;
  end;

var
  FrmRptCfgChoiceCA: TFrmRptCfgChoice;

//*****************************************************************************

implementation

{$R *.dfm}

uses FChlVSCustomerCA,
DBTables,
StStrW;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FChlChoiceListCA.pas';
const
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2013/10/03 13:45:50 $';

//*****************************************************************************
// Implementation of TFrmRptCfgChoiceCA
//*****************************************************************************

procedure TFrmRptCfgChoiceCA.FormActivate(Sender: TObject);
begin //TFrmRptCfgChoiceCA.FormActivate
 if not Assigned (SvcTskActive) then
   raise Exception.Create (Format (CtTxtEmPropMissing, ['ActiveTask']));

  if FlgFirstActive then begin
    // Build Listbox with available fields to include in report
    SvcTskActive.BuildStrLstReportFields (TStringList(LbxAvail.Items));
    inherited;
    // Initialize Combobox conditions
    if not Assigned (ActiveListBox) then
      ActiveListBox := LbxAvail;
    if SelectedItem = LB_ERR then
      SelectedItem := 0;

    if FrmChlCustomerCA.FFlgLCBDFR then begin
      LbxAvail.Items.Delete(23);                                                //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS (SPN)
      LbxAvail.Items.Delete(17);
      LbxAvail.Items.Delete(13);
      LbxAvail.Items.Delete(12);
      LbxAvail.Items.Delete(11);
      LbxAvail.Items.Delete(10);
      LbxAvail.Items.Delete(9);
      LbxAvail.Items.Delete(8);
    end;
    if FrmChlCustomerCA.FFlgLCCAFR then begin
      LbxAvail.Items.Delete(23);                                                //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS (SPN)
      LbxAvail.Items.Delete(22);
      LbxAvail.Items.Delete(21);
      LbxAvail.Items.Delete(17);
      LbxAvail.Items.Delete(13);
      LbxAvail.Items.Delete(12);
      LbxAvail.Items.Delete(11);
      LbxAvail.Items.Delete(10);
      LbxAvail.Items.Delete(9);
      LbxAvail.Items.Delete(8);
    end;
    if FrmChlCustomerCA.FFlgLCCARU then begin
      LbxAvail.Items.Delete(23);                                                //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS (SPN)
      LbxAvail.Items.Delete(22);
      LbxAvail.Items.Delete(21);
      LbxAvail.Items.Delete(17);
      LbxAvail.Items.Delete(9);
      LbxAvail.Items.Delete(8);
    end;
    if FrmChlCustomerCA.FFlgLCBDES then begin
      LbxAvail.Items.Delete(22);
      LbxAvail.Items.Delete(21);
      LbxAvail.Items.Delete(17);
      LbxAvail.Items.Delete(13);
      LbxAvail.Items.Delete(12);
      LbxAvail.Items.Delete(11);
      LbxAvail.Items.Delete(10);
      LbxAvail.Items.Delete(9);
      LbxAvail.Items.Delete(8);
    end;
  end;                                                                          //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN
end;  //TFrmRptCfgChoiceCA.FormActivate

//=============================================================================

procedure TFrmRptCfgChoiceCA.MniExportToFileClick(Sender: TObject);
var
  TxtFNSave        : string;           // FileName to save
begin  //TFrmRptCfgChoiceCA.MniExportToFileClick
  ForceFocusChange;

  TxtFNSave := TxtFNReportExport;
  if TxtFNReportExport <> '' then
    SavDlgExportFile.FileName := TxtFNReportExport;

  SavDlgExportFile.InitialDir := TxtDirReportExport;
  if not SavDlgExportFile.Execute then
    Exit;

  TxtFNSave := SavDlgExportFile.FileName;

  if Assigned (RptExportFile) then begin
    TxtSeparatorColumn := RptExportFile.SeparatorColumnAsRptFmt;
    TxtSeparatorRow    := RptExportFile.SeparatorRowAsRptFmt;
    if (JustExtensionW (TxtFNSave) = '') and
       (RptExportFile.DefaultExtension <> '') then
      TxtFNSave := ForceExtensionW (SavDlgExportFile.FileName,
                                    RptExportFile.DefaultExtension);
  end
  else begin
    TxtSeparatorColumn := CtTxtDefSepColumn;
    TxtSeparatorRow    := CtTxtDefSepRow;
  end;

  if TxtFNSave <> '' then
    ExportReport (TxtFNSave);
end;  //TFrmRptCfgChoiceCA.MniExportToFileClick

//=============================================================================
// TFrmRptCfgChoiceCA.AdjustRptExportDialogs : adjusts the dialogs for export the
// report to a file.
//                                         ----
// Restrictions:
// - is mainly intented to call just once from FormActivate.
//=============================================================================

procedure TFrmRptCfgChoiceCA.AdjustRptExportDialogs;
var
  QryHlp              : TQuery;                                                 
begin  // of TFrmRptCfgChoiceCA.AdjustRptCfgDialogs
  if not SvcTskActive.AllowExport then begin
    MniExport.Visible := False;
    BtnExportToFile.Visible := False;
    Exit;
  end;
  if FrmChlCustomerCA.FlgListOfCustomer then begin
    QryHlp := TQuery.Create(self);
    try
      QryHlp.DatabaseName := 'DBFlexPoint';
      QryHlp.Active := False;
      QryHlp.SQL.Clear;
      QryHlp.SQL.Add('select * from ApplicParam' +
                     ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
      QryHlp.Active := True;
       TxtDirReportExport := QryHlp.FieldByName('TxtParam').AsString;
       if not DirectoryExists(TxtDirReportExport) then
        TxtDirReportExport :=
        ExtractFilePath (ExtractFileDir (Application.ExeName)) + 'Spool\';
    finally
      QryHlp.Active := False;
      QryHlp.Free;
    end;
  end;
  if not DirectoryExists(TxtDirReportExport) then
      ForceDirectories(TxtDirReportExport);
    SavDlgExportFile.InitialDir := TxtDirReportExport;

  // Configure Save-dialog
  SavDlgExportFile.Filter := SvcTskActive.ExportFiles.Filter;

  SavDlgExportFile.Title :=
    Format (SavDlgExportFile.Title, [SvcTskActive.TaskName]);
end;   // of TFrmRptCfgChoiceCA.AdjustRptExportDialogs

 //============================================================================
 
end. // of FChlChoiceListCA.pas
