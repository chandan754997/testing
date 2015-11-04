//= Copyright 2009 (c) Real Software NV - Retail Division. All rights reserved =
// Packet   : FlexPoint
// Unit     : FBonPassageCA = Form BONPASSAGE CAstorama
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FBonPassageCA.pas,v 1.2 2009/10/16 10:11:42 BEL\KDeconyn Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FBonPassageCA - CVS revision 1.3
//=============================================================================

unit FBonPassageCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, Db, StBarC, ExtCtrls;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring               // Form labels
  CtTxtLblMarchandise        = 'Articles collected by:';
  CtTxtLblCommande           = 'Order ticket nr:';

resourcestring               // Error messages
  CtTxtErrorMarchandiseBody  = 'Please fill in who collected the articles!';
  CtTxtErrorCommandeBody     = 'Please fill in the order nr!';
  CtTxtErrorClientType       = 'Please fill in the client type!';
  CtTxtErrorDatCreateBody    = 'Date is in the future!';
  CtTxtErrorHeader           = 'Invalid input';

const
  CtBankTransferPrefix       = '281';
  CtBonPassagePrefix         = '280';

//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmBonPassageCA = class(TForm)
    lblMarchandise: TLabel;
    lblCommande: TLabel;
    edtMarchandise: TEdit;
    edtCommande: TEdit;
    BtnCancel: TBitBtn;
    BtnOK: TBitBtn;
    stsbrStatus: TStatusBar;
    DscBonPassage: TDataSource;
    StBrCdBonPassage: TStBarCode;
    RGClientType: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtMarchandiseKeyPress(Sender: TObject; var Key: Char);
    procedure edtCommandeKeyPress(Sender: TObject; var Key: Char);
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
    TxtCodCreator          : string;     // Extra Idt for customer
    FlgReprint             : Boolean;    // True if reprint, False if creation
    FlgRussia              : Boolean;
  public
    { Public declarations }
    procedure HandleNumPLU; virtual;
    function FillString(FillChar: char; Len: integer): string; virtual;
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
    property CodCreator         : string  read TxtCodCreator
                                          write TxtCodCreator;
    property Reprint            : boolean read FlgReprint
                                          write FlgReprint;
    property Russia             : boolean read FlgRussia
                                          write FlgRussia;
  end;

var
  FrmBonPassageCA: TFrmBonPassageCA;

//*****************************************************************************

implementation

uses
  ScTskMgr_BDE_DBC,
  sfDialog,

  DFpnUtils,
  DFpnBonPassage,
  
  FVSBonPassageCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FBonPassageCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FBonPassageCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/10/16 10:11:42 $';

//*****************************************************************************
// Implementation of TFrmBonPassageCA
//*****************************************************************************

procedure TFrmBonPassageCA.FormCreate(Sender: TObject);
begin   // of TFrmBonPassageCA.FormCreate
  LblMarchandise.Caption := CtTxtLblMarchandise;
  lblCommande.Caption := CtTxtLblCommande;
end;    // of TFrmBonPassageCA.FormCreate

//=============================================================================

procedure TFrmBonPassageCA.BtnOKClick(Sender: TObject);
begin   // of TFrmBonPassageCA.BtnOKClick
  if edtMarchandise.Text = '' then begin
    Application.MessageBox(Pchar(CtTxtErrorMarchandiseBody),
                   PChar(CtTxtErrorHeader), MB_OK);
    edtMarchandise.SetFocus;
    ModalResult := mrNone;
  end
  else if edtCommande.Text = '' then begin
    Application.MessageBox(PChar(CtTxtErrorCommandeBody),
                   PChar(CtTxtErrorHeader), MB_OK);
    edtCommande.SetFocus;
    ModalResult := mrNone;
  end
  else if RGClientType.ItemIndex < 0 then begin
    Application.MessageBox(PChar(CtTxtErrorClientType),
                   PChar(CtTxtErrorHeader), MB_OK);
    RGClientType.SetFocus;
    ModalResult := mrNone;
  end
  else begin
    // Set properties
    if RGClientType.ItemIndex = 0 then
      ClientType := IntToStr(CtCodBonPasClienCompte)
    else
      ClientType := IntToStr(CtCodBonPasBankTransfer);
    Collected := edtMarchandise.Text;
    Order     := edtCommande.Text;
    BonPassage :=
           IntToStr(DmdFpnUtils.GetNextCounter ('BonPassage', 'IdtBonPassage'));
    HandleNumPLU;
    Reprint   := False;
    // Save Bon de Passage to database
    DscBonPassage.DataSet.Active := True;
    DscBonPassage.DataSet.Insert;
    DscBonPassage.DataSet.FieldByName('IdtBonPassage').Text := BonPassage;
    DscBonPassage.DataSet.FieldByName('IdtCustomer').Text := Customer;
    DscBonPassage.DataSet.FieldByName('DatExpired').AsDateTime := Now;
    DscBonPassage.DataSet.FieldByName('TxtCollecter').Text := Collected;
    DscBonPassage.DataSet.FieldByName('TxtBonCommande').Text := Order;
    DscBonPassage.DataSet.FieldByName('ValLimit').Text := Amount;
    DscBonPassage.DataSet.FieldByName('NumPLU').Text := NumPLU;
    DscBonPassage.DataSet.FieldByName('CodType').Text := ClientType;
    DscBonPassage.DataSet.FieldByName('CodCreator').Text := CodCreator;
    DmdFpnBonPassage.QryDetBonPassage.ApplyUpdates;
    // Launch task to preview report
    SvcTaskMgr.LaunchTask ('PrintBonPassageReport');
  end;
end;    // of TFrmBonPassageCA.BtnOKClick

//=============================================================================

procedure TFrmBonPassageCA.FormActivate(Sender: TObject);
begin   // of TFrmBonPassageCA.FormActivate
  edtMarchandise.Text := '';
  edtCommande.Text := '';
  edtMarchandise.SetFocus;
  if Russia then begin
    RGClientType.ItemIndex := -1;
    RGClientType.Enabled := True;
  end
  else begin
    RGClientType.ItemIndex := 0;
    RGClientType.Enabled := False;
  end;
end;    // of TFrmBonPassageCA.FormActivate

//=============================================================================

procedure TFrmBonPassageCA.edtMarchandiseKeyPress(Sender: TObject;
  var Key: Char);
begin   // of TFrmBonPassageCA.edtMarchandiseKeyPress
  if Key = #13 then
    edtCommande.SetFocus;
end;    // of TFrmBonPassageCA.edtMarchandiseKeyPress

//=============================================================================

procedure TFrmBonPassageCA.edtCommandeKeyPress(Sender: TObject;
  var Key: Char);
begin   // of TFrmBonPassageCA.edtCommandeKeyPress
  if Key = #13 then
    BtnOK.Click;
end;    // of TFrmBonPassageCA.edtCommandeKeyPress

//=============================================================================
// HandleNumPLU : Calculates the bar code
//=============================================================================

procedure TFrmBonPassageCA.HandleNumPLU;
var
  C                : Integer;          //Check character
  K                : Integer;          // Second check character (not needed here)
begin  // of TFrmBonPassageCA.HandleNumPLU
  if ClientType = IntToStr(CtCodBonPasClienCompte) then
    NumPLU := CtBonPassagePrefix + FillString('0', 9 - length(BonPassage)) +
                BonPassage
  else
    NumPLU := CtBankTransferPrefix + FillString('0', 9 - length(BonPassage)) +
                BonPassage;
  StBrCdBonPassage.Code := NumPLU;
  StBrCdBonPassage.GetCheckCharacters(NumPLU, C, K);
  NumPLU := NumPLU + IntToStr(C);
end;   // of TFrmBonPassageCA.HandleNumPLU

//=============================================================================
// FillString : Fills up a string of given Length
//  with given char
//                                  -----
// INPUT   :  FillChar = the char to fill the string with
//            Len      = The length of the returned filled string
//                                  -----
// FUNCRES :  The Filled-up-String
//=============================================================================

function TFrmBonPassageCA.FillString(FillChar: char; Len: integer): string;
var
  Txt               : string;
  Cnt               : Integer;
begin  // of TFrmBonPassageCA.FillString
  SetLength(Txt,Len);
  for Cnt := 1 to Len do
    Txt[Cnt] := FillChar;
  Result := Txt;
end;   // of TFrmBonPassageCA.FillString

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FBonPassageCA
