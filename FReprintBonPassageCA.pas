//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : FlexPoint
// Unit     : FReprintBonPassageCA = Form REPRINT BONPASSAGE for CAstorama

//-----------------------------------------------------------------------------
// PVCS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FReprintBonPassageCA.pas,v 1.2 2007/01/03 09:11:03 smete Exp $
// History  :
//=============================================================================

unit FReprintBonPassageCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, StdCtrls, Buttons, ComCtrls, Grids, DBGrids;

//*****************************************************************************
// Global definitions
//*****************************************************************************

type
  TFrmReprintBonPassageCA = class(TForm)
    stsbrStatus: TStatusBar;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    DBGrdBonPassage: TDBGrid;
    DscBonPassage: TDataSource;
    procedure FormActivate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure DBGrdBonPassageDblClick(Sender: TObject);
  private
    { Private declarations }
    IdtBonPassage          : String;     // Identification of bon de passage
    TxtCollected           : string;     // Collected by
    TxtOrder               : string;     // Order number
    IdtCustomer            : string;     // Customer identification
    TxtName                : string;     // Name of the customer
    TxtAddress             : string;     // Address of the customer
    TxtPostalCode          : string;     // Postal Code of the customer
    TxtMunicipality        : string;     // Municipality of the customer
    ValAmount              : string;     // Maximum amount of the customer
    TxtNumPLU              : string;     // Bar code
    TxtClientType          : string;     // CodType of Bon Passage
    FlgReprint             : Boolean;    // True if reprint, False if creation
    FlgRussia              : Boolean;
  public
    { Public declarations }
  published
    // Properties for the report
    property BonPassage         : string  read IdtBonPassage
                                          write IdtBonPassage;
    property Collected          : string  read TxtCollected
                                          write TxtCollected;
    property Order              : string  read TxtOrder
                                          write TxtOrder;
    property Customer           : string  read Idtcustomer
                                          write IdtCustomer;
    property Name               : string  read TxtName
                                          write TxtName;
    property Address            : string  read TxtAddress
                                          write TxtAddress;
    property PostalCode         : string  read TxtPostalCode
                                          write TxtPostalCode;
    property Municipality       : string  read TxtMunicipality
                                          write TxtMunicipality;
    property Amount             : string  read ValAmount
                                          write ValAmount;
    property NumPLU             : string  read TxtNumPLU
                                          write TxtNumPLU;
    property ClientType         : string  read TxtClientType
                                          write TxtClientType;
    property Reprint            : boolean read FlgReprint
                                          write FlgReprint;
    property Russia             : boolean read FlgRussia
                                          write FlgRussia;
  end;

var
  FrmReprintBonPassageCA: TFrmReprintBonPassageCA;

implementation

uses
  ScTskMgr_BDE_DBC,
  sfDialog,
  scDBUtil_BDE,
  SmDBUtil_BDE,

  DFpnUtils,
  DFpnBonPassage,

  FVSBonPassageCA;


{$R *.DFM}

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FReprintBonPassageCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FReprintBonPassageCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2007/01/03 09:11:03 $';

//*****************************************************************************
// Implementation of TFrmBonPassageCA
//*****************************************************************************

procedure TFrmReprintBonPassageCA.FormActivate(Sender: TObject);
begin  // Begin of TFrmReprintBonPassageCA.FormActivate
   // Link Address with Customer
   DmdFpnBonPassage.QryDetBonPassage.Active := False;
   DmdFpnBonPassage.QryDetBonPassage.ParamByName('PrmIdtCustomer').Text :=
      Customer;
   DmdFpnBonPassage.QryDetBonPassage.Active := True;
   If DmdFpnBonPassage.QryDetBonPassage.RecordCount = 0 then
      BtnOK.Enabled := False
   else begin
      BtnOK.Enabled := True;
      DmdFpnBonPassage.QryDetBonPassage.First;
      while not DmdFpnBonPassage.QryDetBonPassage.Eof do begin
        DmdFpnBonPassage.QryDetBonPassage.Edit;
        if DmdFpnBonPassage.QryDetBonPassage.FieldByName('Type').AsString = '1111111111111111111111' then
          DmdFpnBonPassage.QryDetBonPassage.FieldByName('Type').AsString := CtTxtCustClientCompte
        else
          DmdFpnBonPassage.QryDetBonPassage.FieldByName('Type').AsString := CtTxtCustBankTransfer;
        DmdFpnBonPassage.QryDetBonPassage.Next;
      end

   end;
   DscBonPassage.DataSet := DmdFpnBonPassage.QryDetBonPassage;

   LoadGridTitles (DBGrdBonPassage, DmdFpnUtils.SprCnvApplicText);

   // Make column codtype invisible
   HideDBGridCol (DBGrdBonPassage, 'CodType');

end;   // End of TFrmReprintBonPassageCA.FormActivate

//=============================================================================

procedure TFrmReprintBonPassageCA.BtnOKClick(Sender: TObject);
begin  // Begin of TFrmReprintBonPassageCA.BtnOKClick
    // Set properties
    BonPassage := DscBonPassage.DataSet.FieldByName('IdtBonPassage').AsString;
    Amount     := DscBonPassage.DataSet.FieldByName('ValLimit').AsString;
    Collected  := DscBonPassage.DataSet.FieldByName('TxtCollecter').AsString;
    Order      := DscBonPassage.DataSet.FieldByName('TxtBonCommande').AsString;
    NumPLU     := DscBonPassage.DataSet.FieldByName('NumPLU').AsString;
    ClientType := DscBonPassage.DataSet.FieldByName('CodType').AsString;
    Reprint    := True;
    // Launch task to preview report
    SvcTaskMgr.LaunchTask ('PrintBonPassageReport');
end;   // End of TFrmReprintBonPassageCA.BtnOKClick

//=============================================================================

procedure TFrmReprintBonPassageCA.DBGrdBonPassageDblClick(Sender: TObject);
begin  // Begin of TFrmReprintBonPassageCA.DBGrdBonPassageDblClick
   BtnOK.Click;
end;   // End of TFrmReprintBonPassageCA.DBGrdBonPassageDblClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FReprintBonPassageCA
