//=========== Sycron Computers Belgium (c) 2002 ==========================
// Packet : Castorama Development
// Unit   : FDetChangeDocBONb.pas = Form DETail for CHANGE of the DOCument
//          BackOffice NumBer
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetChangeDocBONb.pas,v 1.1 2006/12/20 14:38:04 hofmansb Exp $
// History:
// Version  Modified By  Reason
// 1.52     KC    (TCS)  R2012.1 - CAFR - Anomalies doc bo
// 1.53     GG    (TCS)  R2012.1 - CAFR - 31 Internal Defect Fix 
// 1.54     KB    (TCS)  R2012.1 - CAFR - 31 Internal Defect Fix  
// 1.55     CP    (TCS)  R2012.1 - R2012.1 Defect fix 333
//=============================================================================

unit FDetChangeDocBONb;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfDetail_BDE_DBC, StdCtrls, Buttons, OvcBase, OvcEF, OvcPB, OvcPF, ScUtils,
  SfCommon, ComCtrls, ExtCtrls, DB;

resourcestring
  CtTxtNoDocBoExists    = 'No Document BO with type %s and number %s exists ' + //R2012.1 Defect fix 333 (CP)            
                          'in the FO' +
                          #10'Proceed with to change?';                      
  CtTxtTitle = 'Modified Document Number';
  CtTxtCaption          = 'Change Document Number';                             //Internal Defect Fix(Sidhant)
//*****************************************************************************
// Interface of TFrmDetChangeDocNb
//*****************************************************************************

type
  TFrmDetChangeDocBONb = class(TFrmDetail)
    SvcLFIdtCVente: TSvcLocalField;
    LblNewVenteId: TLabel;
    LblNewTypeVente: TLabel;
    CbxTypeVente: TComboBox;
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
	private
	    FFlgCAFR           : Boolean;                                             //Regression Defect Fix R2012
  protected
    // Data variables
  public
      property FlgCAFR : Boolean read FFlgCAFR write FFlgCAFR;                  //Regression Defect Fix R2012
  end;

var
  FrmDetChangeDocBONb: TFrmDetChangeDocBONb;

//*****************************************************************************

implementation

uses
  SfDialog,

  DFpnUtils,
  DFpnBODocument;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetChangeDocBONb';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetChangeDocBONb.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.55 $';
  CtTxtSrcDate    = '$Date: 2013/01/30 14:38:04 $';

//*****************************************************************************
// Implementation of TFrmDetChangeDocNb
//*****************************************************************************

procedure TFrmDetChangeDocBONb.FormActivate(Sender: TObject);
//31 Internal Defect Fix KB -Start
var
itmindx : Integer;
  CntIndex         : Integer;       // Index counter                            //Regression Defect Fix R2012
//31 Internal Defect Fix KB -End
begin  // of TFrmDetChangeDocBONb.FormActivate
  inherited;
  Caption := CtTxtCaption;                                                      //Internal Defect Fix(Sidhant)
//Regression Defect Fix R2012 ::START
  self.caption := CtTxtTitle;                                                   //GG 31 Internal Defect Fix
  application.title := CtTxtTitle;                                              //GG 31 Internal Defect Fix
    if FlgCAFR then begin
    //CAFR:2012.1 Anomalies Doc BO - KC(TCS): Start
   for CntIndex := 1 to CtCodLastDoc do begin
     if (Trim(ViArrTxtShortDescrDoc[CntIndex])<>'BV') and (Trim(ViArrTxtShortDescrDoc[CntIndex])<>'LOC') then  begin   // Added By Koyel Chk.
       CbxTypeVente.Items.Add(ViArrTxtShortDescrDoc[CntIndex]);
     end;
   end;

   end
   else begin
    for CntIndex := 1 to CtCodLastDoc do
    CbxTypeVente.Items.Add (ViArrTxtShortDescrDoc [CntIndex]);
   end;
 If FlgCafr then begin
 //Regression Defect Fix R2012 ::END
   if StrToInt (StrLstIdtValues.Values ['CodTypeVente']) = 2 then
    itmindx := 0
  else
    itmindx := 1;
  //31 Internal Defect Fix KB - End
  SvcLFIdtCVente.AsString := trim(StrLstIdtValues.Values ['IdtCVente']);        //31 Internal Defect Fix KB
  CbxTypeVente.ItemIndex := itmindx; {StrToInt (StrLstIdtValues.Values ['CodTypeVente'])   //31 Internal Defect Fix KB
                            - 1;}                                               //31 Internal Defect Fix KB
 //Regression Defect Fix R2012 ::START
 end
 else begin
  SvcLFIdtCVente.AsString := StrLstIdtValues.Values ['IdtCVente'];
  CbxTypeVente.ItemIndex := StrToInt (StrLstIdtValues.Values ['CodTypeVente'])
                            - 1;
  end;
//Regression Defect Fix R2012 ::END  
end;   // of TFrmDetChangeDocBONb.FormActivate

//=============================================================================

procedure TFrmDetChangeDocBONb.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
ItemIndx : integer;                                                             // 31 Internal Defect Fix KB
begin  // of TFrmDetChangeDocBONb.FormCloseQuery
  if ModalResult in [mrIgnore, mrCancel] then
    Exit;
  CanClose := False;
  inherited;
  try
  // 31 Internal Defect Fix KB -Start
   If FlgCAFR then begin  //Regression Defect Fix R2012
    if  (CbxTypeVente.ItemIndex = 0) then
      ItemIndx :=2
    else
      ItemIndx :=4;
   end;	                                                                        //Regression Defect Fix R2012
 // 31 Internal Defect Fix Kb - End
    if FlgCAFR then begin  //Regression Defect Fix R2012
	 if not DmdFpnUtils.QueryInfo (
              'SELECT * ' +
              '  FROM VENTE ' +
              ' WHERE CVENTE  = ' + SvcLFIdtCVente.AsString +

              '   AND TYPE_VENTE = ' +{ IntToStr (CbxTypeVente.ItemIndex+1))} InttoStr(ItemIndx)) then  // 31 Internal Defect Fix KB
       if MessageDlg (Format (CtTxtNoDocBoExists,
                             [CbxTypeVente.Text,Trim(SvcLFIdtCVente.AsString)]),                       //R2012.1 Defect fix 333 (CP)
                     mtWarning, [mbYes,mbNo], 0) = mrNo then begin
        ModalResult := mrNone;
        Exit;
//Regression Defect Fix R2012 ::START		
       end;
	 end
	else begin
     if not DmdFpnUtils.QueryInfo (
              'SELECT * ' +
              '  FROM VENTE ' +
              ' WHERE CVENTE  = ' + SvcLFIdtCVente.AsString +
              '   AND TYPE_VENTE = ' + IntToStr (CbxTypeVente.ItemIndex+1)) then
       if MessageDlg (Format (CtTxtNoDocBoExists,
                             [CbxTypeVente.Text,Trim(SvcLFIdtCVente.AsString)]),//R2012.1 Defect fix 333 (CP)
                     mtWarning, [mbYes,mbNo], 0) = mrNo then begin
        ModalResult := mrNone;
        Exit;
       end;
//Regression Defect Fix R2012 ::END	   
	  end;
  finally
    DmdFpnUtils.CloseInfo;
  end;

  // Update PosTransDetail
  DmdFpnUtils.QryInfo.SQL.Text :=
    'UPDATE PosTransDetail ' +
    #10'   SET IdtCVente    = :PrmNewIdtCVente,' +
    #10'       CodTypeVente = :PrmNewCodTypeVente' +
    #10' WHERE IdtPosTransaction = :PrmIdtPosTransaction' +
    #10'   AND IdtCheckout = :PrmIdtCheckout' +
    #10'   AND CodTrans = :PrmCodTrans' +
    #10'   AND DatTransBegin = :PrmDatTransBegin' +
    #10'   AND IdtCVente = :PrmIdtCVente' +
    #10'   AND CodTypeVente = :PrmCodTypeVente';
  DmdFpnUtils.QryInfo.Prepare;
  DmdFpnUtils.QryInfo.ParamByName ('PrmNewIdtCVente').AsString :=
   SvcLFIdtCVente.AsString;
   //Regression Defect Fix R2012 ::START
  If FlgCAFR then 
  DmdFpnUtils.QryInfo.ParamByName ('PrmNewCodTypeVente').AsInteger := ItemIndx  // 31 Internal Defect Fix KB
  else
  DmdFpnUtils.QryInfo.ParamByName ('PrmNewCodTypeVente').AsInteger :=
   CbxTypeVente.ItemIndex + 1;
   //Regression Defect Fix R2012 ::END
  DmdFpnUtils.QryInfo.ParamByName ('PrmIdtPosTransaction').AsString :=
    StrLstIdtValues.Values ['IdtPosTransaction'];
  DmdFpnUtils.QryInfo.ParamByName ('PrmIdtCheckout').AsString :=
    StrLstIdtValues.Values ['IdtCheckout'];
  DmdFpnUtils.QryInfo.ParamByName ('PrmCodTrans').AsString :=
    StrLstIdtValues.Values ['CodTrans'];
  DmdFpnUtils.QryInfo.ParamByName ('PrmDatTransBegin').AsDateTime :=
    StrToDateTime (StrLstIdtValues.Values ['DatTransBegin']);
  DmdFpnUtils.QryInfo.ParamByName ('PrmIdtCVente').AsString :=
    StrLstIdtValues.Values ['IdtCVente'];
  DmdFpnUtils.QryInfo.ParamByName ('PrmCodTypeVente').AsString :=
    StrLstIdtValues.Values ['CodTypeVente'];
  DmdFpnUtils.QryInfo.ExecSQL;

  // Update GlobalAcomptes
  DmdFpnUtils.QryInfo.SQL.Text :=
    'UPDATE GlobalAcomptes ' +
    #10'   SET IdtCVente    = :PrmNewIdtCVente,' +
    #10'       CodTypeVente = :PrmNewCodTypeVente' +
    #10' WHERE IdtPosTransaction = :PrmIdtPosTransaction' +
    #10'   AND IdtCheckout = :PrmIdtCheckout' +
    #10'   AND CodTrans = :PrmCodTrans' +
    #10'   AND DatTransBegin = :PrmDatTransBegin' +
    #10'   AND IdtCVente = :PrmIdtCVente' +
    #10'   AND CodTypeVente = :PrmCodTypeVente';
  DmdFpnUtils.QryInfo.ExecSQL;
  DmdFpnUtils.CloseInfo;

  StrLstIdtValues.Values['IdtCVente'] := SvcLFIdtCVente.AsString;
  //Regression Defect Fix R2012 ::START
  If FlgCAFR then
   StrLstIdtValues.Values['CodTypeVente'] := Inttostr(ItemIndx)// IntToStr (CbxTypeVente.ItemIndex+1) // 31 Internal Defect Fix KB
  else
   StrLstIdtValues.Values['CodTypeVente'] := IntToStr (CbxTypeVente.ItemIndex+1);
  //Regression Defect Fix R2012 ::END
  CanClose := True;
end;   // of TFrmDetChangeDocBONb.FormCloseQuery

//=============================================================================

procedure TFrmDetChangeDocBONb.FormCreate(Sender: TObject);
begin  // of TFrmDetChangeDocBONb.FormCreate
  inherited;
end;   // of TFrmDetChangeDocBONb.FormCreate

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FDetChangeDocBONb
