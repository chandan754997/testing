//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Unit   : FLstSetupCheckout.PAS : Form DETail CUSTomer PRiCe CATegory
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstSetupCheckout.pas,v 1.2 2009/09/29 11:35:31 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FLstSetupCheckout - CVS revision 1.
//=============================================================================

unit FLstSetupCheckout;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, DBCtrls, StdCtrls, Db, Buttons ;

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtCheckout         = 'Checkout';
  CtTxtErrNoDepartments = 'No departments found. Application will be closed.';
  CtTxtErrDepartmentReq = 'Please fill in a department for %s.';

const  // Constants for readability
  CtTxtNameLbl       = 'LblCheckout';        // Name  label checkout
  CtTxtNameCbx       = 'CbxDepartment';      // Name combobox Department

//=============================================================================
// TFrmLstSetupCheckout
//=============================================================================

type
  TFrmLstSetupCheckout = class(TFrmCommon)
    DscCheckout: TDataSource;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    ScrollBox1: TScrollBox;
    GrbCheckout: TGroupBox;
    ScrBoxCheckout: TScrollBox;
    LblCheckout: TLabel;
    CbxDepartment: TComboBox;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FNumCheckouts: integer;
    FNumDepartments: integer;
  public
    { Public declarations }
    // Methods
    procedure CreateCmpCheckout; virtual;
    procedure SaveDepartments; virtual;
    // Properties
    property NumCheckouts : integer read FNumCheckouts
                                   write FNumCheckouts;
    property NumDepartments: integer read FNumDepartments
                                    write FNumDepartments;
  end;

var
  FrmLstSetupCheckout: TFrmLstSetupCheckout;

implementation

{$R *.DFM}

uses
  SfDialog,

  SmDBUtil_BDE,
  SmUtils,
  RFpnCom,
  DFpnWorkStat,
  DFpnWorkStatCA,
  DFpnDepartment;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLstSetupCheckout';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstSetupCheckout.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/29 11:35:31 $';

//*****************************************************************************
// Implementation of TFrmLstSetupCheckout
//*****************************************************************************

procedure TFrmLstSetupCheckout.CreateCmpCheckout;
var
  LblNew           : TLabel;           // New label - component
  CbxNew           : TComboBox;        // New Combobox - component
  ValTopLbl        : Integer;          // property Top for new Label
  ValTopCbx        : Integer;          // property Top for new Combobox
  IdtCheckout      : Integer;          // IdtCheckout
  IdtDepartment    : Integer;          // IdtDepartment
begin  // of TFrmLstSetupCheckout.CreateCmpCheckout
  ValTopLbl := lblCheckout.Top;
  ValTopCbx := cbxDepartment.Top;
  DscCheckout.DataSet.Open;
  NumCheckouts := DscCheckout.DataSet.RecordCount;
  DmdFpnDepartment.qryDetDepartment.Open;
  GrbCheckout.Visible := False;
  while not DscCheckout.DataSet.Eof do begin
    IdtCheckout := DscCheckout.DataSet.FieldByName('IdtCheckout').AsInteger;
    IdtDepartment := DscCheckout.Dataset.FieldByName('IdtDepartment').AsInteger;
    TComponent(LblNew) := FindComponent (CtTxtNameLbl +
                                             IntToStr (IdtCheckout));

    if not Assigned (LblNew) then begin
      //Create the label
      LblNew := TLabel.Create (Self);
      LblNew.Name        := CtTxtNameLbl + IntToStr (IdtCheckout);
      LblNew.Parent      := lblCheckout.Parent;
      LblNew.Left        := lblCheckout.Left;
      LblNew.Width       := lblCheckout.Width;
      LblNew.Top         := ValTopLbl;
      LblNew.Visible     := True;
      LblNew.Caption     := CtTxtCheckout + ' ' + IntToStr(IdtCheckout);


      CbxNew := TComboBox.Create (Self);
      CbxNew.Name        := CtTxtNameCbx + IntToStr (IdtCheckout);
      CbxNew.Left        := CbxDepartment.Left;
      CbxNew.Width       := CbxDepartment.Width;
      CbxNew.Top         := ValTopCbx;
      CbxNew.Parent      := CbxDepartment.Parent;
      CbxNew.Visible     := True;
      CbxNew.Style       := csDropDownList;

      // Fill the combobox with the given values.
      BuildStrLstCodes (CbxNew.Items, DmdFpnDepartment.QryDetDepartment,
                          'Descr', 'IdtDepartment');
      if IdtDepartment > 0 then
        CbxNew.ItemIndex := CbxNew.Items.IndexOfObject(TObject(IdtDepartment));
    end;
    Inc (ValTopLbl, 26);
    Inc (ValTopCbx, 26);
    DscCheckout.DataSet.Next;
  end;
  GrbCheckout.Visible := True;
  DscCheckout.DataSet.Close;
end;   // of TFrmLstSetupCheckout.CreateCmpCheckout

//=============================================================================

procedure TFrmLstSetupCheckout.FormActivate(Sender: TObject);
begin  // of TFrmLstSetupCheckout.FormActivate
  inherited;
  NumDepartments := DmdFpnDepartment.NumDepartments;
  //Get NumDepartments
  if NumDepartments > 1 then begin
    CreateCmpCheckout;
  end
  else begin
    ShowMessage(CtTxtErrNoDepartments);
    Close;
  end;
end;   // of TFrmLstSetupCheckout.FormActivate

//=============================================================================

procedure TFrmLstSetupCheckout.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IdtCheckout      : integer;
  lblNew           : TLabel;
  cbxNew           : TComboBox;
begin  // of TFrmLstSetupCheckout.FormClose
  inherited;
  DscCheckout.DataSet.Open;
  while not DscCheckout.DataSet.Eof do begin
    IdtCheckout := DscCheckout.DataSet.FieldByName('IdtCheckout').AsInteger;
    TComponent(LblNew) := FindComponent (CtTxtNameLbl +
                                             IntToStr (IdtCheckout));
    if Assigned(LblNew) then
      lblNew.Destroy;

    TComponent(cbxNew) := FindComponent (CtTxtNameCbx +
                                             IntToStr (IdtCheckout));
    if Assigned(cbxNew) then
      cbxNew.Destroy;
    DscCheckout.Dataset.Next;
  end;
  DscCheckout.Dataset.Close;
end;   // of TFrmLstSetupCheckout.FormClose

//=============================================================================

procedure TFrmLstSetupCheckout.BtnCancelClick(Sender: TObject);
begin  // of TFrmLstSetupCheckout.BtnCancelClick
  inherited;
  Close;
end;   // of TFrmLstSetupCheckout.BtnCancelClick

//=============================================================================

procedure TFrmLstSetupCheckout.BtnOKClick(Sender: TObject);
var
  FlgCbxFilled     : Boolean;
  CbxTemp          : TComboBox;
  IdtCheckout      : integer;
begin  // of TFrmLstSetupCheckout.BtnOKClick
  inherited;
  CbxTemp     := nil;
  IdtCheckout := 0;
  //Checken of alle comboboxen zijn ingevuld
  DscCheckout.Dataset.Open;
  FlgCbxFilled := True;
  while (not DscCheckout.Dataset.Eof) and FlgCbxFilled do begin
    IdtCheckout := DscCheckout.DataSet.FieldByName('IdtCheckout').AsInteger;
    TComponent(CbxTemp) := FindComponent(CtTxtNameCbx + IntToStr(IdtCheckout));
    if Assigned(CbxTemp) then
      FlgCbxFilled := CbxTemp.ItemIndex >= 0;
    DscCheckout.Dataset.Next;
  end;
  if FlgCbxFilled then begin
    //opslaan
    SaveDepartments;
    Close;
  end
  else begin
    //Melding geven
    ShowMessage(Format(CtTxtErrDepartmentReq, [CtTxtCheckout + ' ' +
                                               IntToStr(IdtCheckout)]));
    if Assigned(CbxTemp) then
      CbxTemp.SetFocus;
  end;
end;   // of TFrmLstSetupCheckout.BtnOKClick

//=============================================================================

procedure TFrmLstSetupCheckout.SaveDepartments;
var
  CbxTemp          : TComboBox;
  IdtCheckout      : integer;
  IdtDepartment    : integer;
begin  // of TFrmLstSetupCheckout.SaveDepartments
  DscCheckout.Dataset.Close;
  DscCheckout.Dataset.Open;
  while not DscCheckout.Dataset.Eof do begin
    IdtCheckout := DscCheckout.DataSet.FieldByName('IdtCheckout').AsInteger;
    TComponent(CbxTemp) := FindComponent(CtTxtNameCbx + IntToStr(IdtCheckout));
    IdtDepartment := Integer(CbxTemp.Items.Objects[CbxTemp.ItemIndex]);
    DmdFpnWorkStatCA.UpdateCheckoutDepartment(IdtCheckout, IdtDepartment);
    DscCheckout.Dataset.Next;
  end;
  DscCheckout.Dataset.Close;
end;   // of TFrmLstSetupCheckout.SaveDepartments

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.
