//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : Castorama Development
// Unit     : FVWPosJournalCA : Form VieW POS JOURNAL TICKET LIST for CAstorama
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVWPosJournalTicketLst.pas,v 1.3 2009/09/22 10:30:42 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FVWPosJournalTicketLst - CVS revision 1.65
// Version     ModifiedBy       Reason
// 1.66        PRG. (TCS)       R2011.2 - BDES - Facture multi-tickets - Known Issues Fix
//=============================================================================

unit FVWPosJournalTicketLst;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Buttons, ExtCtrls, Grids, DBGrids, DB, dxmdaset;


//=============================================================================
// TfrmFVWPosJournalTicket
//=============================================================================

type
  TfrmFVWPosJournalTicket = class(TForm)
    PnlBtnsTop: TPanel;
    BtnClose: TSpeedButton;
    LblCurTicketNumber: TLabel;
    PnlTicketList: TPanel;
    DBGrdTicket: TDBGrid;
    BtnDelTicket: TBitBtn;
    BtnRemoveAll: TBitBtn;
    DxMDTicket: TdxMemData;
    NumTicket: TLargeintField;
    NumCashD: TLargeintField;
    DatTicket: TDateTimeField;
    CodTrans: TSmallintField;
    DscTicket: TDataSource;
    TcktType: TSmallintField;
    procedure BtnRemoveAllClick(Sender: TObject);
    procedure BtnDelTicketClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFVWPosJournalTicket      : TfrmFVWPosJournalTicket;

implementation

{$R *.dfm}

uses
  FVWPosJournalCA,
  sfdialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const // Module-name
  CtTxtModuleName             = 'FVWPosJournalCA';

const // PVCS-keywords
  CtTxtSrcName                = '$Source: $';
  CtTxtSrcVersion             = '$Revision: 1.66 $';
  CtTxtSrcDate                = '$Date: 2011/09/22 15:22:42 $';

//*****************************************************************************
// Implementation of Interfaced routines
//*****************************************************************************

procedure TfrmFVWPosJournalTicket.FormShow(Sender: TObject);
var
  ticket                      : TObjTicket;
  CntTrans                    : Integer;
begin // of TfrmFVWPosJournalTicket.FormShow
  DxMDTicket.Active := True;
  for CntTrans := 0 to FrmVWPosJournalCA.StrLstObjTicket.Count - 1 do begin
    ticket := TObjticket(FrmVWPosJournalCA.StrLstObjTicket.Objects[CntTrans]);
    DxMDTicket.Append;
    DxMDTicket.FieldByName('IdtPOSTransaction').AsInteger := ticket.IdtPOSTransaction;
    DxMDTicket.FieldByName('IdtCheckout').AsInteger := ticket.IdtCheckout;
    DxMDTicket.FieldByName('CodTrans').AsInteger := ticket.CodTrans;
    DxMDTicket.FieldByName('DatTransBegin').AsDateTime := ticket.DatTransBegin;
    DxMDTicket.FieldByName('TcktType').AsVariant := ticket.TcktType;            // Facture multi-tickets - Known Issues Fix, PRG, R2011.2
    DxMDTicket.Post;
  end
end; // of TfrmFVWPosJournalTicket.FormShow

//*****************************************************************************

procedure TfrmFVWPosJournalTicket.BtnCloseClick(Sender: TObject);
begin // of TfrmFVWPosJournalTicket.BtnCloseClick
  FrmVWPosJournalCA.StrLstObjTicket.Clear;
  if DscTicket.DataSet.RecordCount > 0 then begin
    DxMDTicket.First;
    repeat
      FrmVWPosJournalCA.StrLstObjTicket.AddObject(' ',
        TObjTicket.Create(DxMDTicket.FieldByName('IdtPosTransaction').AsInteger,
        DxMDTicket.FieldByName('IdtCheckout').AsInteger,
        DxMDTicket.FieldByName('CodTrans').AsInteger,
        DxMDTicket.FieldByName('DatTransBegin').AsDateTime,                     // Facture multi-tickets - Known Issues Fix, PRG, R2011.2
        DxMDTicket.FieldByName('TcktType').AsVariant));                         // Facture multi-tickets - Known Issues Fix, PRG, R2011.2
      DxMDTicket.Next;
    until DxMDTicket.Eof;
  end;
  DxMDTicket.Active := False;
  Close;
end; // of TfrmFVWPosJournalTicket.BtnCloseClick

//*****************************************************************************

procedure TfrmFVWPosJournalTicket.BtnDelTicketClick(Sender: TObject);
begin // of TfrmFVWPosJournalTicket.BtnDelTicketClick
  if DscTicket.DataSet.RecordCount <> 0 then begin
    DscTicket.DataSet.Delete;
  end;
end; // of TfrmFVWPosJournalTicket.BtnDelTicketClick

//*****************************************************************************

procedure TfrmFVWPosJournalTicket.BtnRemoveAllClick(Sender: TObject);
begin // of TfrmFVWPosJournalTicket.BtnRemoveAllClick
  DscTicket.DataSet.Last;
  while not DscTicket.DataSet.Bof do begin
    DscTicket.DataSet.Delete;
  end;
end; // of TfrmFVWPosJournalTicket.BtnRemoveAllClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent(CtTxtModuleName, CtTxtSrcName,
    CtTxtSrcVersion, CtTxtSrcDate);

end. // of FVWPosJournalTicketLst

