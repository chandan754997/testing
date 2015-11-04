//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet   : FlexPoint
// Unit     : FSelectBag : Form to list the sealbags for that operator
//-----------------------------------------------------------------------------
// PVCS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSelectBag.pas,v 1.1 2006/12/22 15:28:52 NicoCV Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FInputOperatorCA - CVS revision 1.3
//=============================================================================

unit FSelectBag;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, SfCommon,
  Dialogs, SmUtils, StdCtrls, Buttons, StDate, DB, DBTables, ovcbase, ovcef,
  ovcpb, ovcpf, ScUtils, ExtCtrls;

//=============================================================================
// Global definitions
//=============================================================================

type
  TFrmSelectBag = class(TFrmCommon)
    PnlTop: TPanel;
    LblOperator: TLabel;
    SvcLFOperatorName: TSvcLocalField;
    PnlBottom: TPanel;
    BtnAccept: TBitBtn;
    BtnCancel: TBitBtn;
    QryBagInfo: TQuery;
    RdGrpSealbags: TRadioGroup;
    procedure BtnAcceptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  protected
    FTxtBagNumber  : string;           // bag number to pass
    OperatorReg    : String;
    TxtNameRegFor  : String;
    PaymentMode    : String;
  private
    { Private declarations }
  published
    property TxtBagNumber : string read  FTxtBagNumber
                                   write FTxtBagNumber;
  end;
var
  FrmSelectBag: TFrmSelectBag;

implementation

{$R *.dfm}

uses
  DFpnUtils,
  DFpnOperator,
  SfDialog,
  FMntTenderReCountCA,
  DFpnTenderGroup,
  FFpsTndRegReCountCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FSelectBag';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSelectBag.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.0 $';
  CtTxtSrcDate    = '$Date: 2013/07/25 15:28:52 $';

//*****************************************************************************
// Implementation of FInputOperatorCA
//*****************************************************************************

procedure TFrmSelectBag.FormCreate(Sender: TObject);
var
CurrentDate   : String;
begin
  try
    OperatorReg := FrmMntTenderReCountCA.OperatorId;
    DateTimeToString(CurrentDate, CtTxtDateFormat, Date);
    With QryBagInfo.SQL do begin
      Clear;
      Add ('SELECT IDTPOCHETTE,IDTTENDERGROUP FROM POCHETTE');
      Add ('WHERE IDTSAFETRANSACTION IN');
      Add ('(SELECT DISTINCT IDTSAFETRANSACTION FROM SAFETRANSACTION');
      Add ('WHERE IDTOPERREG = ' + AnsiQuotedStr (OperatorReg, ''''));
      Add ('AND CODTYPE IN (921,931)');
      Add ('AND DATREG BETWEEN ' + AnsiQuotedStr(CurrentDate + ' ' +  '00:00:00', ''''));
      Add ('AND ' + AnsiQuotedStr(CurrentDate + ' ' +  '23:59:59', '''') + ')');
      QryBagInfo.Active := True;
      QryBagInfo.First;
      RdGrpSealbags.Items.Clear;
      while not QryBagInfo.Eof do
      begin
        PaymentMode := DmdFpnTenderGroup.InfoTenderGroup [
              (QryBagInfo.FieldByName ('IdtTenderGroup').AsInteger),
               'TxtPublDescr'];
        RdGrpSealbags.Items.AddObject
           ((Format ('%s - %s' ,
             [(QryBagInfo.FieldByName ('IdtPochette').AsString), PaymentMode])),
            TObject (QryBagInfo.FieldByName ('IdtPochette')));
        QryBagInfo.Next;
      end;
      end;
  finally
    QryBagInfo.Close;
    TxtNameRegFor := DmdFpnOperator.InfoOperator[OperatorReg, 'TxtName'];
    SvcLFOperatorName.Text :=  (Format ('%s - %s',
                 [DmdFpnOperator.InfoOperator[OperatorReg, 'TxtPassword'],
                  TxtNameRegFor]));
    SvcLFOperatorName.Enabled := False;
    RdGrpSealBags.ItemIndex := 0;
  end;
end;

procedure TFrmSelectBag.BtnAcceptClick(Sender: TObject);
var
NumCntItems  : Integer;
begin
  for NumCntItems := 0 to RdGrpSealbags.Items.Count-1 do
  begin
    if RdGrpSealBags.ItemIndex = NumCntItems then
    begin
      TxtBagNumber := AdjustStrLen(RdGrpSealbags.Items.Strings[NumCntItems],13);
      Exit;
    end;
  end;
end;

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
