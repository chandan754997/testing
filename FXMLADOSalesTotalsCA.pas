//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : FlexPoint 2.0
// Customer : Castorama
// Unit     : FXMLADOSalesTotalsCA = processes XML-string with SALES TOTALS
//                                CAstorama
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOSalesTotalsCA.pas,v 1.1 2006/12/22 13:41:52 smete Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - FXMLADOSalesTotalsCA - CVS revision 1.6
//=============================================================================

unit FXMLADOSalesTotalsCA;

//*****************************************************************************

interface

uses
  MSXML_TLB, ADODB,
  FXMLADOGeneral,

  KasResul;

//*****************************************************************************
// TXMLADOSalesTotalsCA
//*****************************************************************************

type
  TXMLADOSalesTotalsCA = class (TXMLADOGeneral)
  protected
    IdtCashDesk    : Word;
    IdtOperator    : Word;
    CodTrans       : Byte;
    RecKasTotXML   : TKasTot;         // Record VerkTot with data from XML

    procedure AddGenInfoXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure AddVATXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure AddCustDepXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure AddSubdivXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure AddNDSubdivXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure AddValCurrXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure AddReturnXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure AddStateDocXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure AddHourDocXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure AddPromoXMLToSalesTot (NdeSalTot : IXMLDOMNode);
    procedure ProcessXMLFields (NdeSalTot : IXMLDOMNode);

    procedure UpdateVerkTot (IdtCashOper : Word;
                             CodCashOper : Byte);
    procedure UpdateCashDesk (NdeSalTot : IXMLDOMNode);
    procedure UpdateOperator (NdeSalTot : IXMLDOMNode);
    procedure ProcessSalesTotals (NdeSalTot : IXMLDOMNode);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure ProcessXML (TxtXML : string); override;
  end;  // of TXMLADOSalesTotalsCA

var
  XMLADOSalesTotalsCA : TXMLADOSalesTotalsCA;

//*****************************************************************************

implementation

uses
  Classes,
  SysUtils,

  BTIsBase,

  DFpnADOServiceMQ,
  SfDialog,
  SmWinApi,

  Kassa,
  MFpsADOFileOperation, // Is not used anymore
  MFpsADOFileOperationCA, // Is not used anymore
  Operator,
  Subdiv,
  MLogging;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FXMLADOSalesTotalsCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOSalesTotalsCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:41:52 $';

//*****************************************************************************
// Implementation of TXMLADOSalesTotalsCA
//*****************************************************************************

//=============================================================================
// TXMLADOSalesTotalsCA.Create
//=============================================================================

constructor TXMLADOSalesTotalsCA.Create;
begin  // of TXMLADOSalesTotalsCA.Create
  inherited Create;

  // Create VerkTot if necessary
  if ApiGetEnvironmentVariable ('SycRoot') = '' then
    CIFNVerkTot := 'D:\Sycron' + CIFNVerkTot;
  if not FileExists (CIFNVerkTot + '.' + BTIsBase.DatExtension) then
    KreeerVerkTot (CIFNVerkTot);

  // The verktot is not used anymore in the décompte
  // Create object VerkTot
  if not Assigned (ObjVerkTotCA) then
    ObjVerkTotCA := TObjVerkTotCA.Create (CIFNVerkTot)
  else
    ObjVerkTotCA.Prepare (CIFNVerkTot);
  ObjVerkTotCA.FlgLockOnRead := True;

  // Create object Kassa
  if ApiGetEnvironmentVariable ('SycRoot') = '' then
    CIFNKassa := 'D:\Sycron' + CIFNKassa;
  if not Assigned (ObjKassa) then
    ObjKassa := TObjKassa.Create (CIFNKassa)
  else
    ObjKassa.Prepare (CIFNKassa);
  ObjKassa.FlgLockOnRead := True;

  // Create object Operator
  if ApiGetEnvironmentVariable ('SycRoot') = '' then
    CIFNOperator := 'D:\Sycron' + CIFNOperator;
  if not Assigned (ObjOperator) then
    ObjOperator := TObjOperator.Create (CIFNOperator)
  else
    ObjOperator.Prepare (CIFNOperator);
  ObjOperator.FlgLockOnRead := True;

  HgsteSubdivRecNr := CTMaxAantSubdiv;
end;   // of TXMLADOSalesTotalsCA.Create

//=============================================================================
// TXMLADOSalesTotalsCA.Destroy
//=============================================================================

destructor TXMLADOSalesTotalsCA.Destroy;
begin  // of TXMLADOSalesTotalsCA.Destroy
  inherited;

  if Assigned (ObjOperator) then
    ObjOperator.UnPrepare (True);
  if Assigned (ObjKassa) then
    ObjKassa.UnPrepare (True);
  if Assigned (ObjVerkTotCA) then
    ObjVerkTotCA.UnPrepare (True);
end;   // of TXMLADOSalesTotalsCA.Destroy

//=============================================================================
// TXMLADOSalesTotalsCA.AddGenInfoXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddGenInfoXMLToSalesTot (NdeSalTot : IXMLDOMNode);
begin  // of TXMLADOSalesTotalsCA.AddGenInfoXMLToSalesTot
  IdtCashDesk := StrToInt (NdeSalTot.selectSingleNode ('IdtCheckOut').text);
  IdtOperator := StrToInt (NdeSalTot.selectSingleNode ('IdtOperator').text);
  CodTrans := StrToInt (NdeSalTot.selectSingleNode ('KdTotaal').text);
end;   // of TXMLADOSalesTotalsCA.AddGenInfoXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.AddVATXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddVATXMLToSalesTot (NdeSalTot : IXMLDOMNode);
var
  NdeParent        : IXMLDOMNode;      // XML node that contains a full table
  NdeRecord        : IXMLDOMNode;      // XML node that contains a record
  NdeChild         : IXMLDOMNode;      // XML node that contains a field
  IdtVATCode       : Byte;
  CodConvert       : Integer;          // Code convert float with Val
begin  // of TXMLADOSalesTotalsCA.AddVATXMLToSalesTot
  NdeParent := NdeSalTot.selectSingleNode ('TabBTWTot');
  if NdeParent <> nil then begin
    NdeRecord := NdeParent.firstChild;
    repeat
      NdeChild := NdeRecord.selectSingleNode ('IdtVATCode');
      if NdeChild <> nil then begin
        IdtVATCode := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('ValVATCode');
        if NdeChild <> nil then
          Val (NdeChild.text, RecKasTotXML.TabBTWTot[IdtVATCode], CodConvert);
      end;
      NdeRecord := NdeRecord.nextSibling;
    until NdeRecord = nil;
  end;
end;   // of TXMLADOSalesTotalsCA.AddVATXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.AddCustDepXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddCustDepXMLToSalesTot (NdeSalTot : IXMLDOMNode);
var
  NdeParent        : IXMLDOMNode;      // XML node that contains a full table
  NdeRecord        : IXMLDOMNode;      // XML node that contains a record
  NdeChild         : IXMLDOMNode;      // XML node that contains a field
  NumIxDep         : Byte;
begin  // of TXMLADOSalesTotalsCA.AddCustDepXMLToSalesTot
  NdeParent := NdeSalTot.selectSingleNode ('TabKlPerDep');
  if NdeParent <> nil then begin
    NdeRecord := NdeParent.firstChild;
    repeat
      NdeChild := NdeRecord.selectSingleNode ('NumIxDep');
      if NdeChild <> nil then begin
        NumIxDep := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('NumCustDep');
        if NdeChild <> nil then
          RecKasTotXML.TabKlPerDep[NumIxDep] := StrToInt (NdeChild.text);
      end;
      NdeRecord := NdeRecord.nextSibling;
    until NdeRecord = nil;
  end;
end;   // of TXMLADOSalesTotalsCA.AddCustDepXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.AddSubdivXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddSubdivXMLToSalesTot;
var
  NdeParent        : IXMLDOMNode;
  NdeRecord        : IXMLDOMNode;      // XML node that contains a record
  NdeChild         : IXMLDOMNode;
  NumIx            : Word;
  CodConvert       : Integer;          // Code convert float with Val
begin  // of TXMLADOSalesTotalsCA.AddSubdivXMLToSalesTot
  NdeParent := NdeSalTot.selectSingleNode ('TabSubdiv');
  if NdeParent <> nil then begin
    NdeRecord := NdeParent.firstChild;
    repeat
      NdeChild := NdeRecord.selectSingleNode ('NumIxSubdiv');
      if NdeChild <> nil then begin
        NumIx := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('AantKlant');
        if NdeChild <> nil then
          RecKasTotXML.TabSubdiv[NumIx].AantKlant := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('AantArt');
        if NdeChild <> nil then
          RecKasTotXML.TabSubdiv[NumIx].AantArt := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('WrdeVerk');
        if NdeChild <> nil then
          Val (NdeChild.text, RecKasTotXML.TabSubdiv[NumIx].WrdeVerk,
               CodConvert);
        NdeChild := NdeRecord.selectSingleNode ('WrdeKort');
        if NdeChild <> nil then
          Val (NdeChild.text, RecKasTotXML.TabSubdiv[NumIx].WrdeKort,
               CodConvert);
      end;
      NdeRecord := NdeRecord.nextSibling;
    until NdeRecord = nil;
  end;
end;   // of TXMLADOSalesTotalsCA.AddSubdivXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.AddNDSubdivXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddNDSubdivXMLToSalesTot;
var
  NdeParent        : IXMLDOMNode;
  NdeRecord        : IXMLDOMNode;      // XML node that contains a record
  NdeChild         : IXMLDOMNode;
  NumIx            : Word;
  CodConvert       : Integer;          // Code convert float with Val
begin  // of TXMLADOSalesTotalsCA.AddNDSubdivXMLToSalesTot
  NdeParent := NdeSalTot.selectSingleNode ('NDSubdiv');
  if NdeParent <> nil then begin
    NdeRecord := NdeParent.firstChild;
    repeat
      NdeChild := NdeRecord.selectSingleNode ('NumIxNDSubdiv');
      if NdeChild <> nil then begin
        NumIx := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('AantKlant');
        if NdeChild <> nil then
          RecKasTotXML.NDSubdiv[NumIx].AantKlant := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('AantArt');
        if NdeChild <> nil then
          RecKasTotXML.NDSubdiv[NumIx].AantArt := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('WrdeVerk');
        if NdeChild <> nil then
          Val (NdeChild.text, RecKasTotXML.NDSubdiv[NumIx].WrdeVerk,
               CodConvert);
        NdeChild := NdeRecord.selectSingleNode ('WrdeKort');
        if NdeChild <> nil then
          Val (NdeChild.text, RecKasTotXML.NDSubdiv[NumIx].WrdeKort,
               CodConvert);
      end;
      NdeRecord := NdeRecord.nextSibling;
    until NdeRecord = nil;
  end;
end;   // of TXMLADOSalesTotalsCA.AddNDSubdivXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.AddValCurrXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddValCurrXMLToSalesTot;
var
  NdeParent        : IXMLDOMNode;
  NdeRecord        : IXMLDOMNode;      // XML node that contains a record
  NdeChild         : IXMLDOMNode;
  IdtCurrency      : Byte;
  CodConvert       : Integer;          // Code convert float with Val
begin  // of TXMLADOSalesTotalsCA.AddValCurrXMLToSalesTot
  NdeParent := NdeSalTot.selectSingleNode ('SaldoVM');
  if NdeParent <> nil then begin
    NdeRecord := NdeParent.firstChild;
    repeat
      NdeChild := NdeRecord.selectSingleNode ('IdtCurrency');
      if NdeChild <> nil then begin
        IdtCurrency := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('ValCurrency');
        if NdeChild <> nil then
          Val (NdeChild.text, RecKasTotXML.SaldoVM[IdtCurrency], CodConvert);
      end;
      NdeRecord := NdeRecord.nextSibling;
    until NdeRecord = nil;
  end;
end;   // of TXMLADOSalesTotalsCA.AddValCurrXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.AddReturnXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddReturnXMLToSalesTot (NdeSalTot : IXMLDOMNode);
var
  NdeChild         : IXMLDOMNode;
  CodConvert       : Integer;          // Code convert float with Val
begin  // of TXMLADOSalesTotalsCA.AddReturnXMLToSalesTot
  NdeChild := NdeSalTot.selectSingleNode ('AantKlant');
  if NdeChild <> nil then
    RecKasTotXML.AantKlant := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('AantArt');
  if NdeChild <> nil then
    RecKasTotXML.AantArt := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('AantAnnul');
  if NdeChild <> nil then
    RecKasTotXML.AantAnnul := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('BedrAnnul');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.BedrAnnul, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('AantKorr');
  if NdeChild <> nil then
    RecKasTotXML.AantKorr := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('BedrKorr');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.BedrKorr, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('AantTerugn');
  if NdeChild <> nil then
    RecKasTotXML.AantTerugn := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('BedrTerugn');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.BedrTerugn, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('Aant0Tick');
  if NdeChild <> nil then
    RecKasTotXML.Aant0Tick := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('AantLadeOpen');
  if NdeChild <> nil then
    RecKasTotXML.AantLadeOpen := StrToInt (NdeChild.text);
end;   // of TXMLADOSalesTotalsCA.AddReturnXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.AddStateDocXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddStateDocXMLToSalesTot;
var
  NdeParent        : IXMLDOMNode;
  NdeRecord        : IXMLDOMNode;      // XML node that contains a record
  NdeChild         : IXMLDOMNode;
  NumIx            : Byte;
  CodConvert       : Integer;          // Code convert float with Val
begin  // of TXMLADOSalesTotalsCA.AddStateDocXMLToSalesTot
  NdeParent := NdeSalTot.selectSingleNode ('StatusRapp');
  if NdeParent <> nil then begin
    NdeRecord := NdeParent.firstChild;
    repeat
      NdeChild := NdeRecord.selectSingleNode ('NumIxStatusRapp');
      if NdeChild <> nil then begin
        NumIx := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('ValStatusRapp');
        if NdeChild <> nil then
          Val (NdeChild.text, RecKasTotXML.StatusRapp [NumIx], CodConvert);
      end;
      NdeRecord := NdeRecord.nextSibling;
    until NdeRecord = nil;
  end;
end;   // of TXMLADOSalesTotalsCA.AddStateDocXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.AddHourDocXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddHourDocXMLToSalesTot;
var
  NdeParent        : IXMLDOMNode;
  NdeRecord        : IXMLDOMNode;      // XML node that contains a record
  NdeChild         : IXMLDOMNode;
  NumIx            : Byte;
  CodConvert       : Integer;          // Code convert float with Val
begin  // of TXMLADOSalesTotalsCA.AddHourDocXMLToSalesTot
  NdeParent := NdeSalTot.selectSingleNode ('UurRapp');
  if NdeParent <> nil then begin
    NdeRecord := NdeParent.firstChild;
    repeat
      NdeChild := NdeRecord.selectSingleNode ('NumUurRapp');
      if NdeChild <> nil then begin
        NumIx := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('AantKlant');
        if NdeChild <> nil then
          RecKasTotXML.UurRapp[NumIx].AantKlant := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('AantArt');
        if NdeChild <> nil then
          RecKasTotXML.UurRapp[NumIx].AantArt := StrToInt (NdeChild.text);
        NdeChild := NdeRecord.selectSingleNode ('Bedrag');
        if NdeChild <> nil then
          Val (NdeChild.text, RecKasTotXML.UurRapp[NumIx].Bedrag,
               CodConvert);
        NdeChild := NdeRecord.selectSingleNode ('ExacteTijd');
        if NdeChild <> nil then
          RecKasTotXML.UurRapp[NumIx].ExacteTijd := StrToInt (NdeChild.text);
      end;
      NdeRecord := NdeRecord.nextSibling;
    until NdeRecord = nil;
  end;
end;   // of TXMLADOSalesTotalsCA.AddHourDocXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.AddPromoXMLToSalesTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.AddPromoXMLToSalesTot;
var
  NdeChild         : IXMLDOMNode;
  CodConvert       : Integer;          // Code convert float with Val
begin  // of TXMLADOSalesTotalsCA.AddPromoXMLToSalesTot
  NdeChild := NdeSalTot.selectSingleNode ('BonUitGeteld');
  if NdeChild <> nil then
    RecKasTotXML.BonUitGeteld := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('BonUitNtGet');
  if NdeChild <> nil then
    RecKasTotXML.BonUitNtGet := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('BonUitZBadge');
  if NdeChild <> nil then
    RecKasTotXML.BonUitZBadge := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('WBUitGeteld');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.WBUitGeteld, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('WBUitNtGet');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.WBUitNtGet, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('WBUitZBadge');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.WBUitZBadge, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('BonBetGeteld');
  if NdeChild <> nil then
    RecKasTotXML.BonBetGeteld := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('BonBetNtGet');
  if NdeChild <> nil then
    RecKasTotXML.BonBetNtGet := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('BonBetZBadge');
  if NdeChild <> nil then
    RecKasTotXML.BonBetZBadge := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('WBBetGeteld');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.WBBetGeteld, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('WBBetNtGet');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.WBBetNtGet, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('WBBetZBadge');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.WBBetZBadge, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('PntToe');
  if NdeChild <> nil then
    RecKasTotXML.PntToe := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('PntToeBadge');
  if NdeChild <> nil then
    RecKasTotXML.PntToeBadge := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('PntAf');
  if NdeChild <> nil then
    RecKasTotXML.PntAf := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('PntAfBadge');
  if NdeChild <> nil then
    RecKasTotXML.PntAfBadge := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('AantKlBadge');
  if NdeChild <> nil then
    RecKasTotXML.AantKlBadge := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('OmzBadge');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.OmzBadge, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('OmzPnt');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.OmzPnt, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('OmzPntBadge');
  if NdeChild <> nil then
    Val (NdeChild.text, RecKasTotXML.OmzPntBadge, CodConvert);

  NdeChild := NdeSalTot.selectSingleNode ('ArtBadge');
  if NdeChild <> nil then
    RecKasTotXML.ArtBadge := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('ArtPnt');
  if NdeChild <> nil then
    RecKasTotXML.ArtPnt := StrToInt (NdeChild.text);

  NdeChild := NdeSalTot.selectSingleNode ('ArtPntBadge');
  if NdeChild <> nil then
    RecKasTotXML.ArtPntBadge := StrToInt (NdeChild.text);
end;   // of TXMLADOSalesTotalsCA.AddPromoXMLToSalesTot

//=============================================================================
// TXMLADOSalesTotalsCA.ProcessXMLFields
//=============================================================================

procedure TXMLADOSalesTotalsCA.ProcessXMLFields (NdeSalTot : IXMLDOMNode);
begin  // of TXMLADOSalesTotalsCA.ProcessXMLFields
  InitTKasTot (RecKasTotXML);

  AddGenInfoXMLToSalesTot (NdeSalTot);
  AddVATXMLToSalesTot (NdeSalTot);
  AddCustDepXMLToSalesTot (NdeSalTot);
  AddSubdivXMLToSalesTot (NdeSalTot);
  AddNDSubdivXMLToSalesTot (NdeSalTot);
  AddValCurrXMLToSalesTot (NdeSalTot);
  AddReturnXMLToSalesTot (NdeSalTot);
  AddStateDocXMLToSalesTot (NdeSalTot);
  AddHourDocXMLToSalesTot (NdeSalTot);
  AddPromoXMLToSalesTot (NdeSalTot);
end;   // of TXMLADOSalesTotalsCA.ProcessXMLFields

//=============================================================================
// TXMLADOSalesTotalsCA.UpdateVerkTot
//=============================================================================

procedure TXMLADOSalesTotalsCA.UpdateVerkTot (IdtCashOper : Word;
                                              CodCashOper : Byte);
begin  // of TXMLADOSalesTotalsCA.UpdateVerkTot
  if ObjVerkTotCA.NumRec <> 0 then begin
    try
      ObjVerkTotCA.ReadRec;
      if (ObjVerkTotCA.RecVerkTot.KdTotaal <> CodCashOper) or
         (ObjVerkTotCA.RecVerkTot.NrKasOpe <> IdtCashOper) then
        raise Exception.Create ('Failure in UpdateVerkTot: ' +
                                'Fieldvalues are different');
    except
      on E : Exception do begin
        ObjVerkTotCA.NumRec := 0;
        DmdFpnServiceMQ.ExceptionHandler (Self, E);
      end;
    end;
  end;

  if ObjVerkTotCA.NumRec = 0 then begin
    InitVerkTot (ObjVerkTotCA.RecVerkTot);
    ObjVerkTotCA.RecVerkTot.KdTotaal := CodCashOper;
    ObjVerkTotCA.RecVerkTot.NrKasOpe := IdtCashOper;
  end;

  KumulTKasTot (RecKasTotXML, ObjVerkTotCA.RecVerkTot.KasTot);

  ObjVerkTotCA.WriteRec;
end;   // of TXMLADOSalesTotalsCA.UpdateVerkTot

//=============================================================================
// TXMLADOSalesTotalsCA.UpdateCashDesk
//=============================================================================

procedure TXMLADOSalesTotalsCA.UpdateCashDesk (NdeSalTot : IXMLDOMNode);
var
  UpdateCashDesk   : Boolean;          // Update CashDesk-record with rec.nr.
begin  // of TXMLADOSalesTotalsCA.UpdateCashDesk
  UpdateCashDesk := True;

  ObjKassa.IdtCashDesk := IdtCashDesk;
  try
    try
      ObjKassa.ReadRec;
      case CodTrans of
        1 : ObjVerkTotCA.NumRec := ObjKassa.RecKassa.RecVerkKas;
        2 : ObjVerkTotCA.NumRec := ObjKassa.RecKassa.RecLevKas;
        3 : ObjVerkTotCA.NumRec := ObjKassa.RecKassa.RecFaktKas;
        4 : ObjVerkTotCA.NumRec := ObjKassa.RecKassa.RecTrainKas;
        else
          ObjVerkTotCA.NumRec := 0;
      end;
      if ObjVerkTotCA.NumRec <> 0 then
        UpdateCashDesk := False;
    except
      on E : Exception do begin
        UpdateCashDesk := False;
        ObjVerkTotCA.NumRec := 0;
        DmdFpnServiceMQ.ExceptionHandler (Self, E);
      end;
    end;

    UpdateVerkTot (IdtCashDesk, CodTrans);

    if UpdateCashDesk then begin
      case CodTrans of
        1 : ObjKassa.RecKassa.RecVerkKas  := ObjVerkTotCA.NumRec;
        2 : ObjKassa.RecKassa.RecLevKas   := ObjVerkTotCA.NumRec;
        3 : ObjKassa.RecKassa.RecFaktKas  := ObjVerkTotCA.NumRec;
        4 : ObjKassa.RecKassa.RecTrainKas := ObjVerkTotCA.NumRec;
      end;
      ObjKassa.WriteRec;
    end;
  finally
    if Assigned (ObjKassa) then
      ObjKassa.UnPrepare (False);
  end;
end;   // of TXMLADOSalesTotalsCA.UpdateCashDesk

//=============================================================================
// TXMLADOSalesTotalsCA.UpdateOperator
//=============================================================================

procedure TXMLADOSalesTotalsCA.UpdateOperator (NdeSalTot : IXMLDOMNode);
var
  UpdateOperator   : Boolean;          // Update Operator-record with rec.nr.
begin  // of TXMLADOSalesTotalsCA.UpdateOperator;
  UpdateOperator := True;

  ObjOperator.IdtOperator := IdtOperator;
  try
    try
      ObjOperator.ReadRec;
      case CodTrans of
        1 : ObjVerkTotCA.NumRec := ObjOperator.RecOperator.RecVerkOpe;
        2 : ObjVerkTotCA.NumRec := ObjOperator.RecOperator.RecLevOpe;
        3 : ObjVerkTotCA.NumRec := ObjOperator.RecOperator.RecFaktOpe;
        4 : ObjVerkTotCA.NumRec := ObjOperator.RecOperator.RecTrainOpe;
        else
          ObjVerkTotCA.NumRec := 0;
      end;
      if ObjVerkTotCA.NumRec <> 0 then
        UpdateOperator := False;
    except
      on E : Exception do begin
        UpdateOperator := False;
        ObjVerkTotCA.NumRec := 0;
        DmdFpnServiceMQ.ExceptionHandler (Self, E);
      end;
    end;

    UpdateVerkTot (IdtOperator, CodTrans + 100);

    if UpdateOperator then begin
      case CodTrans of
        1 : ObjOperator.RecOperator.RecVerkOpe  := ObjVerkTotCA.NumRec;
        2 : ObjOperator.RecOperator.RecLevOpe   := ObjVerkTotCA.NumRec;
        3 : ObjOperator.RecOperator.RecFaktOpe  := ObjVerkTotCA.NumRec;
        4 : ObjOperator.RecOperator.RecTrainOpe := ObjVerkTotCA.NumRec;
      end;
      ObjOperator.WriteRec;
    end;
  finally
    if Assigned (ObjOperator) then
      ObjOperator.UnPrepare (False);
  end;
end;   // of TXMLADOSalesTotalsCA.UpdateOperator;

//=============================================================================
// TXMLADOSalesTotalsCA.ProcessSalesTotals : Processes the sales totals that is
// included in the IXMLDOMNode.
//                                  -----
// INPUT  : NdeSalTot = Node containing XML-statement with sales totals.
//=============================================================================

procedure TXMLADOSalesTotalsCA.ProcessSalesTotals (NdeSalTot : IXMLDOMNode);
begin  // of TXMLADOSalesTotalsCA.ProcessSalesTotals
  // Extract all fields from the XML-message
  ProcessXMLFields (NdeSalTot);

  // Update VerkTot with data for cashdesk
  UpdateCashDesk (NdeSalTot);

  // Update VerkTot with data for operator
  UpdateOperator (NdeSalTot);
end;   // of TXMLADOSalesTotalsCA.ProcessSalesTotals

//=============================================================================

procedure TXMLADOSalesTotalsCA.ProcessXML (TxtXML : string);
begin // of TXMLADOSalesTotalsCA.ProcessXML
  ObjXMLDoc.loadXML (TxtXML);
  if ObjXMLDoc.childNodes.Length = 0 then
    raise EInvalidOperation.Create ('Invalid XML statement');
  ProcessSalesTotals (ObjXMLDoc.firstChild);
end;  // of TXMLADOSalesTotalsCA.ProcessXML

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FXMLADOSalesTotalsCA

