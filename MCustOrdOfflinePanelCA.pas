//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : MTransPaymentPanelCA : Module TRANSFER PAYMENTs PANEL for
//                                   CAstorama
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MCustOrdOfflinePanelCA.pas,v 1.3 2009/09/28 15:32:01 BEL\KDeconyn Exp $
//=============================================================================

unit MCustOrdOfflinePanelCA;

//*****************************************************************************

interface

uses
  Classes,                             // TComponent
  ExtCtrls,                            // TPanel
  StdCtrls,
  Graphics,
  IniFiles,
  Forms,
  Controls,
  ScUtils_Dx,
  ScUtils,
  OvcPf;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Position variables
//=============================================================================

var
  ViValArticle    : Integer = 57;
  ViValDescr      : Integer = 121;
  ViValUnit       : Integer = 49;
  ViValQty        : Integer = 49;
  ViValPrice      : Integer = 57;
  ViValAmount     : Integer = 73;
  ViValAmountAftDisc : Integer = 73;
  ViValMargin     : Integer = 49;
  ViValNotes      : Integer = 57;
  ViValSep        : Integer = 3;
  ViValTop        : Integer = 7;
  ViValHeight     : Integer = 20;

//=============================================================================
// Object names
//=============================================================================

const
  CtTxtArticle    = 'EdtArticle';
  CtTxtDescr      = 'EdtDescr';
  CtTxtUnit       = 'EdtUnit';
  CtTxtQty        = 'EdtQty';
  CtTxtPrice      = 'EdtPrice';
  CtTxtAmount     = 'EdtAmount';
  CtTxtAmountAftDisc  = 'EdtAmountAftDisc';
  CtTxtMargin         = 'EdtMargin';
  CtBtnNotesProcess   = 'BtnNotes';

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtBtnCaption = 'Notes >>';
  CtTxtEnterNotes = 'Enter the note:';
  CtTxtIncArt     = 'Article doesn''t exist';

//*****************************************************************************
// Global type definitions
//*****************************************************************************

type
  TPnlCustOrdOffline = class(TCustomPanel)
  private
    FOnChange: TNotifyEvent;
    procedure SetOnChange(const Value: TNotifyEvent);
    { Private declarations }

  protected
    { Protected declarations }
  public
    { Public declarations }
    FEdtArticle   : TSvcMaskEdit;
    FEdtDescr     : TSvcMaskEdit;
    FEdtUnit      : TSvcMaskEdit;
    FEdtQty       : TSvcLocalField;
    FEdtPrice     : TSvcLocalField;
    FEdtAmount    : TSvcLocalField;
    FEdtAmountAftDisc : TSvcLocalField;
//    FEdtMargin    : TSvcLocalField;
    TxtNotes     : string;
    FBtnNotes     : TButton;
    PctDiscount : real;
    // constructors and destructors
    property OnChange : TNotifyEvent read FOnChange write SetOnChange;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BtnNotesClick(Sender: TObject);
    procedure SvcOnChange(Sender: TObject);
    procedure RecalculateLine;
    procedure CheckArticle(Sender: TObject);
    procedure ReplaceString (var TxtS      : string;
                             OldSubStr : string;
                             NewSubStr : string);
  published
    { Published declarations }
    property BtnNotes     : TButton   read FBtnNotes
                                       write FBtnNotes;
  end;

//*****************************************************************************

implementation

uses
  SfDialog,
  SmUtils,
  Dialogs,
  SysUtils,
  DFpnUtils,
  DFpnArtPrice;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName  = 'MCustOrdOfflinePanelCA';

const  // PVCS-keywords
  CtTxtSrcName     = '$Workfile: MTransPaymentPanelCA.PAS $';
  CtTxtSrcVersion  = '$ $';
  CtTxtSrcDate     = '$ $';

//*****************************************************************************
// Implementation of TPnlCustOrdOffline
//*****************************************************************************

//=============================================================================
// Constructors & destructors
//=============================================================================

procedure TPnlCustOrdOffline.BtnNotesClick(Sender: TObject);
begin  // of TPnlCustOrdOffline.BtnNotesClick
  TxtNotes := InputBox( CtTxtBtnCaption, CtTxtEnterNotes, TxtNotes)
end;   // of TPnlCustOrdOffline.BtnNotesClick

//=============================================================================

constructor TPnlCustOrdOffline.Create(AOwner: TComponent);
begin  // of TPnlCustOrdOffline.Create
  inherited Create(AOwner);
  // Panel settings
  Self.BorderStyle   := bsNone;
  Self.BevelInner    := bvNone;
  Self.BevelOuter    := bvLowered;
  Self.Height        := ViValHeight + (2 * ViValTop) - 2;
  FEdtArticle        := TSvcMaskEdit.Create(Self);
  FEdtArticle.Name   := CtTxtArticle;
  FEdtArticle.Parent := Self;
  FEdtArticle.Top    := ViValTop;
  FEdtArticle.Left   := 5;
  FEdtArticle.Height := ViValHeight;
  FEdtArticle.Width  := ViValArticle;
  FEdtArticle.Clear;
  FEdtArticle.ActiveProperties.MaxLength := 14;
  FEdtArticle.OnExit := CheckArticle;
  FEdtDescr          := TSvcMaskEdit.Create(Self);
  FEdtDescr.Name     := CtTxtDescr;
  FEdtDescr.Parent   := Self;
  FEdtDescr.Top      := ViValTop;
  FEdtDescr.Left     := FEdtArticle.Left + FEdtArticle.Width + ViValSep;
  FEdtDescr.Height   := ViValHeight;
  FEdtDescr.Width    := ViValDescr;
  FEdtDescr.Clear;
  FEdtDescr.ActiveProperties.MaxLength := 40;
  FEdtUnit        := TSvcMaskEdit.Create(Self);
  FEdtUnit.Name   := CtTxtUnit;
  FEdtUnit.Parent := Self;
  FEdtUnit.Top    := ViValTop;
  FEdtUnit.Left   := FEdtDescr.Left + FEdtDescr.Width + ViValSep;;
  FEdtUnit.Height := ViValHeight;
  FEdtUnit.Width  := ViValUnit;
  FEdtUnit.Clear;
  FEdtQty               := TSvcLocalField.Create(Self);
  FEdtQty.Name          := CtTxtQty;
  FEdtQty.Parent        := Self;
  FEdtQty.Top           := ViValTop;
  FEdtQty.Left          := FEdtUnit.Left + FEdtUnit.Width + ViValSep;;
  FEdtQty.Height        := ViValHeight;
  FEdtQty.Width         := ViValQty;
  FEdtQty.OnChange      := SvcOnChange;
  FEdtQty.DataType      := pftDouble;
  FEdtQty.DecimalPlaces := 3;
  FEdtPrice               := TSvcLocalField.Create(Self);
  FEdtPrice.Name          := CtTxtPrice;
  FEdtPrice.Parent        := Self;
  FEdtPrice.Top           := ViValTop;
  FEdtPrice.Left          := FEdtQty.Left + FEdtQty.Width + ViValSep;;
  FEdtPrice.Height        := ViValHeight;
  FEdtPrice.Width         := ViValPrice;
  FEdtPrice.OnChange      := SvcOnChange;
  FEdtPrice.DataType      := pftDouble;
  FEdtPrice.DecimalPlaces := 2;
  FEdtAmount               := TSvcLocalField.Create(Self);
  FEdtAmount.Name          := CtTxtAmount;
  FEdtAmount.Parent        := Self;
  FEdtAmount.Top           := ViValTop;
  FEdtAmount.Left          := FEdtPrice.Left + FEdtPrice.Width + ViValSep;;
  FEdtAmount.Height        := ViValHeight;
  FEdtAmount.Width         := ViValAmount;
  FEdtAmount.Enabled       := False;
  FEdtAmount.DataType      := pftDouble;
  FEdtAmount.DecimalPlaces := 2;
  FEdtAmountAftDisc               := TSvcLocalField.Create(Self);
  FEdtAmountAftDisc.Name          := CtTxtAmountAftDisc;
  FEdtAmountAftDisc.Parent        := Self;
  FEdtAmountAftDisc.Top           := ViValTop;
  FEdtAmountAftDisc.Left          := FEdtAmount.Left + FEdtAmount.Width + ViValSep;
  FEdtAmountAftDisc.Height        := ViValHeight;
  FEdtAmountAftDisc.Width         := ViValAmountAftDisc;
  FEdtAmountAftDisc.Enabled       := False;
  FEdtAmountAftDisc.DataType      := pftDouble;
  FEdtAmountAftDisc.DecimalPlaces := 2;
  FBtnNotes         := TButton.Create(Self);
  FBtnNotes.Name    := CtBtnNotesProcess;
  FBtnNotes.Parent  := Self;
  FBtnNotes.Top     := ViValTop - 2;
  FBtnNotes.Left    := FEdtAmountAftDisc.Left + FEdtAmountAftDisc.Width + ViValSep;
  FBtnNotes.Height  := ViValHeight;
  FBtnNotes.Width   := ViValNotes;
  FBtnNotes.Caption := CtTxtBtnCaption;
  FBtnNotes.OnClick := BtnNotesClick;
  TxtNotes := '';
end;   // of TPnlCustOrdOffline.Create

//=============================================================================
// Methods
//=============================================================================

destructor TPnlCustOrdOffline.Destroy;
begin  // of TPnlCustOrdOffline.Destroy
  inherited;

end;   // of TPnlCustOrdOffline.Destroy

//=============================================================================

procedure TPnlCustOrdOffline.RecalculateLine;
begin  // of TPnlCustOrdOffline.RecalculateLine
  FEdtAmount.AsFloat := FEdtQty.AsFloat * FEdtPrice.AsFloat;
  FEdtAmountAftDisc.AsFloat := FEdtQty.AsFloat * FEdtPrice.AsFloat * (1-PctDiscount);
end;   // of TPnlCustOrdOffline.RecalculateLine

//=============================================================================

procedure TPnlCustOrdOffline.CheckArticle;
var
  NumPrcNormal : Currency;
  NumPrcPromo : Currency;
  StrPrice : string;
  FlgSearchPrice : boolean;
begin  // of TPnlCustOrdOffline.CheckArticle
  FlgSearchPrice := False;
  try
    if DmdFpnUtils.QueryInfo('SELECT * FROM Article' +
                          #10'WHERE IdtArticle = ' +
                              QuotedStr(Trim(FEdtArticle.Text))) then begin
      FEdtDescr.Text := DmdFpnUtils.QryInfo.FieldByName('TxtPublDescr').AsString;
      FEdtUnit.Text := DmdFpnUtils.QryInfo.FieldByName('TxtUnit').AsString;
      FlgSearchPrice := True;
    end
    else
      Messagedlg(CtTxtIncArt, mtwarning, [mbok],0 )
  finally
    DmdFpnUtils.CloseInfo;
  end;
  if FlgSearchPrice then begin
    try
      DmdFpnArtPrice.SprPrcArtDay.Prepare;
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmIdtArticle').AsString :=
        Trim(FEdtArticle.Text);
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmCodType').AsInteger :=
        1;
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmIdtType').AsInteger :=
        0;
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmDatValid').AsDateTime := Now;
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmIdtCurrLocal').AsString :=
        DmdFpnUtils.IdtCurrencyLocal;
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmIdtCurrMain').AsString :=
        DmdFpnUtils.IdtCurrencyMain;
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmValExchange').AsCurrency :=
        DmdFpnUtils.ValExchangeCurrencyMain;
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmFlgExchMultiply').AsBoolean :=
         DmdFpnUtils.FlgExchMultiplyCurrencyMain;
      DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmQtyDecim').AsInteger :=
        DmdFpnUtils.QtyDecimCurrencyMain;
      DmdFpnArtPrice.SprPrcArtDay.ExecProc;
      NumPrcNormal :=
        DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmPrcUnNorm').AsCurrency;
      NumPrcPromo :=
        DmdFpnArtPrice.SprPrcArtDay.ParamByName ('@PrmPrcUnProm').AsCurrency;
      if NumPrcPromo > 0 then
        StrPrice := CurrToStr(NumPrcPromo)
      else
        StrPrice := CurrToStr(NumPrcNormal);
      ReplaceString(StrPrice, ',', '.');
      FEdtPrice.Text := StrPrice;
    finally
      DmdFpnArtPrice.SprPrcArtDay.Close;
    end;
  end;
end;   // of TPnlCustOrdOffline.CheckArticle

//=============================================================================

procedure TPnlCustOrdOffline.SetOnChange(const Value: TNotifyEvent);
begin  // of TPnlCustOrdOffline.SetOnChange
  FOnChange := Value;
end;   // of TPnlCustOrdOffline.SetOnChange

//=============================================================================

procedure TPnlCustOrdOffline.SvcOnChange(Sender: TObject);
begin  // of TPnlCustOrdOffline.SvcOnChange
  RecalculateLine;
  OnChange (self);
end;   // of TPnlCustOrdOffline.SvcOnChange

//=============================================================================

procedure TPnlCustOrdOffline.ReplaceString (var TxtS      : string;
                             OldSubStr : string;
                             NewSubStr : string);
var
  Len              : Integer;
  P                : Integer;
begin  // of TADOMQWSInterfaces.ReplaceString
  Len := Length (OldSubStr);
  P := AnsiPos (OldSubStr, TxtS);
  while P > 0 do begin
    Delete (TxtS, P, Len);
    Insert (NewSubStr, TxtS, P);
    P := AnsiPos (OldSubStr, TxtS);
  end;
end;   // of TADOMQWSInterfaces.ReplaceString

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.  // of MTimeIntervalPanelBS

