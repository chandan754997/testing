//===== Copyright 2009 (c) Kinfisher IT Services. All rights reserved ======
// Packet  : Form for printing Castorama Report: CreditNote Cleansing
// Customer: Castorama
// Unit    : FDetCreditNoteCleansing.pas : based on FDetGeneralCA (General
//                                  Detailform to print CAstorama rapports)
//------------------------------------------------------------------------------
// History:
// Version              Modified By                          Reason
// V 1.0               GG. (TCS)                          R2011.2 - Credit Note Cleansing
// V 1.1               GG. (TCS)                          R2011.2 - Defect 94 Fix
// V 1.2               GG. (TCS)                          R2011.2 - Defect 197 Fix
// V 1.3               GG. (TCS)                          R2011.2 - Defect 202,100,262,205 Fix
// V 1.4               GG  (TCS)                          R2011.2 - TCS Internal Defect Fix
// V 1.5               GG  (TCS)                          R2011.2 - R2011.2 defect 300,305 fix
// V 1.6               GG  (TCS)                          R2011.2 - R2011.2 defect 362 fix
// V 1.7               GG  (TCS)                          R2012   - R2011.2 defect 283 fix
//==============================================================================

unit FDetCreditNoteCleansing;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, OvcBase, OvcEF, OvcPB,
  OvcPF, ScUtils, SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring        // of header
  CtTxtTitle          = 'Report Credit Note Cleansing';
  CtTxtHdrTitle          = 'Report Credit Note';      //2011.2 defect(101) fix TCS(GG)
  CtTxtCap            =  'Credit Note Cleansing' ;
resourcestring        // for general report labels
  CtTxtNoData         = 'No data found';
  CtTxtNotExist       = 'No coupon for Cleansing';
  CtTxtPrintDate      = 'Printed on';
  CtTxtReportDate     = 'Date of the report';
  CtTxtDetail         = 'List of mouvements';
  CtTxtGlobal         = 'Report Title';
  CtTxtSelected       = 'Type of report: ';
  CtTxtUnpaid         = 'Report of all unpaid credit coupons';
  CtTxtAll            = 'Report of all credit coupons';
  CtTxtDownPaymentNr  = 'Report of credit coupon Nr';
  CtTxtNbCredCoups    = 'Nb credit coupons:';
  CtTxtNotFound       = 'Nr credit coupon does not exist';
  CtTxtExampleType    = 'Previsualization of the report';
  CtTxtRunType        = 'Cleaned credit coupon report';
  CtTxtOk             =  'OK';
  CtTxtCancel         =  'Cancel';
  CtTxtFile           =  'File';
  CtTxtHelp           =  'Help';
  CtTxtAt             =  'At';
  CtTxtAbout          =  'About';

resourcestring        // of table header global report.
  CtTxtCredCoup       = 'Nr credit coupon';
  CtTxtDatOut         = 'Date out';
  CtTxtDatIn          = 'Date in';
  CtTxtValOut         = 'Amount out';
  CtTxtValIn          = 'Amount in';
  CtTxtSaldo          = 'Total';
  CtTxtNOM            = '/VNOM=VNOM month parameter for cleansing';
resourcestring        // of table header detail report.
  CtTxtDate           = 'Date';
  CtTxtMouvement      = 'Mouvement';
  CtTxtCashDesk       = 'CashDesk';
  CtTxtOperator       = 'Nr Operator';
  CtTxtTicket         = 'Nr Ticket';
  CtTxtAmount         = 'Amount';
  CtTxtExample        = 'Example';
  CtTxtStart          = 'Start';
  CtTxtQuit           = 'Quit';

resourcestring        // of mouvements
  CtTxtRegistered     = 'Registered';
  CtTxtPayedBack      = 'Payed back';
  CtTxtCanceled       = 'Canceled';
  CttxtConfirmation   = 'Mark the Credit Coupons?'; //R2011.2 TCS
//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetCreditCouponCleansing = class(TFrmDetGeneralCA)
    MniPreview: TMenuItem;
    procedure MniPreviewClick(Sender: TObject);
    procedure ActStartExecExecute(Sender: TObject);
    procedure EdtCreditCouponKeyPress(Sender: TObject; var Key: Char);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    //procedure PrintPageNumbers; override;
  private
    { Private declarations }
    FlgDetailReport          : boolean;       // Print detail or global report
    NumCredCoups             : integer;       // Number of down payments
    ValOut                   : double;        // Value of expected down payments
    ValIn                    : double;        // Value of real down payment
    ValSaldo                 : double;        // Value of saldo
    FlgUpdCr                 : boolean;
  protected
    // Formats of the rapport
    function GetFmtTableHeader       : string; override;
    function GetFmtTableBody         : string; override;
    function GetTxtTableTitle        : string; override;
    function GetTxtTitRapport        : string; override;
    function GetTxtRefRapport        : string; override;
    function BuildSQLStatementGlobal : string; virtual;
    function BuildSQLStatementUpdate : string; virtual;
    function BuildSQLStatementUpdateCredCoup : string; virtual;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    function DetermineMouvementType  : string; virtual;
    function CreateMessageDlgBtnst (const TxtMsg     : string;
                                     CodDlgType : TMsgDlgType;
                               const ArrTxtBtns : array of string;
                                     NumDefBtn  : Integer;
                                     NumHelpBtn : Integer         ) : TForm;
    procedure ResetValues; virtual;
    procedure CalculateValues; virtual;
  public
    { Public declarations }
    procedure Execute; override;
    procedure PrintHeader; override;
    procedure PrintTableBodyGlobal; virtual;
    procedure PrintTotalGlobal; virtual;
  end;

var
  FrmDetCreditCouponCleansing: TFrmDetCreditCouponCleansing;
  buttonSelected             : Integer; //R2011.2
  VarNOM                     : String;
  FrmMsg                     : TForm;
//*****************************************************************************

implementation

uses
  Registry,         //R2011.2 - Defect 202 Fix(GG)
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  StUtils,
  DFpn,
  DFpnUtils, DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCreditCoupon.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2012/05/14 10:07:24 $';
 const
  CiArrTxtIconIDs  : array[TMsgDlgType] of PChar =
                     (IDI_EXCLAMATION, IDI_HAND, IDI_ASTERISK, IDI_QUESTION,
                      nil);
 type
  TMessageForm = class(TForm)
  private
    procedure HelpButtonClick (Sender : TObject);
  end;
//******************************************************************************
// Implementation of TFrmDetCreditCoupon
//******************************************************************************
procedure TMessageForm.HelpButtonClick (Sender : TObject);
begin  // of TMessageForm.HelpButtonClick
  Application.HelpContext (HelpContext);
end;
//******************************************************************************
function TFrmDetCreditCouponCleansing.GetFmtTableHeader: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCreditCoupon.GetFmtTableHeader
  if FlgDetailReport then begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (25)]);
    for CntFmt := 0 to 3 do
      Result := Result + TxtSep +
                Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                 FrmVsPreview.ColumnWidthInTwips (20)]);
  end
  else
  begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    for CntFmt := 0 to 2 do
      Result := Result + TxtSep +
                Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                 FrmVsPreview.ColumnWidthInTwips (20)]);
  end;
end;   // of TFrmDetCreditCoupon.GetFmtTableHeader

//==============================================================================

function TFrmDetCreditCouponCleansing.GetFmtTableBody: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCreditCoupon.GetFmtTableBody
  if FlgDetailReport then begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (25)]);
    for CntFmt := 0 to 2 do
      Result := Result + TxtSep +
                Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                 FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignRight,
               FrmVsPreview.ColumnWidthInTwips (20)]);
  end
  else
  begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    for CntFmt := 0 to 2 do
      Result := Result + TxtSep +
                Format ('%s%d', [FrmVsPreview.FormatAlignRight,
                 FrmVsPreview.ColumnWidthInTwips (20)]);
  end;
end;   // of TFrmDetCreditCoupon.GetFmtTableBody

//==============================================================================

function TFrmDetCreditCouponCleansing.GetTxtTableTitle : string;
begin  // of TFrmDetCreditCoupon.GetTxtTableTitle
    Result := CtTxtCredCoup + TxtSep + CtTxtDatOut + TxtSep + CtTxtDatIn +
              TxtSep + CtTxtValOut + TxtSep + CtTxtValIn + Txtsep + CtTxtSaldo;
end;   // of TFrmDetCreditCoupon.GetTxtTableTitle)

//==============================================================================

function TFrmDetCreditCouponCleansing.GetTxtTitRapport : string;
begin  // of TFrmDetCreditCoupon.GetTxtTitRapport
  Result := CtTxtHdrTitle;          //2011.2 defect(101) fix TCS(GG)
end;   // of TFrmDetCreditCoupon.GetTxtTitRapport

//==============================================================================

function TFrmDetCreditCouponCleansing.GetTxtRefRapport : string;
begin  // of TFrmDetCreditCoupon.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0035';
end;   // of TFrmDetCreditCoupon.GetTxtRefRapport

//=============================================================================

function TFrmDetCreditCouponCleansing.BuildSQLStatementGlobal : string;
begin  // of TFrmDetCreditCoupon.BuildSQLStatementGlobal
  if   (VarNOM = '')then   begin
     VarNOM := '03';
  end;
  Result :=
    #10'Select distinct IdtCredCoup,Min(globalcredcoup.DatTransBegin) as DatOut,' +
    #10'                getdate() as DatIn,SUM(globalcredcoup.ValAmount) as ValOut,0 as ValIn,' +
    #10'                SUM(globalcredcoup.ValAmount) as Saldo from globalcredcoup' +
    #10'    where codtype = 0' +
    #10'    and Idtcredcoup not in(select Idtcredcoup from globalcredcoup ' +
    #10'                           where codtype <> 0)' +
    #10'    and datcreate <  case when (day(getdate())>20) Then ' +     //R2011.2 - Defect 197 Fix(GG)
    #10'    (select cast(substring(cast(dateadd(day,-day(getdate()-1),dateadd(month,-('+ VarNOM+'),getdate())) as varchar(40)),1,11) as datetime))' +      //Internal testing defect fix R2011.2 P5  R2011.2 - R2011.2 defect 362 fix
    #10'                           else' +
    #10'    (select cast(substring(cast(dateadd(day,-day(getdate()-1),dateadd(month,-('+VarNOM+'+1),getdate())) as varchar(40)),1,11) as datetime))' +  //Internal testing defect fix R2011.2 P5     R2011.2 - R2011.2 defect 362 fix
    #10'                           end' ;
    //if not FlgUpdCr then
     Result := Result+
    // #10'and not(IdtPosTransaction = 0 and IdtCheckout=0 and IdtOperator=0)' ; //R2011.2 - Defect 202 Fix(GG)
     #10'and not(IdtPosTransaction = 0 and IdtCheckout=0)' ;   //R2011.2 - Defect 202 Fix(GG)
    Result := Result+
    #10'   GROUP BY globalcredcoup.IdtCredCoup' +
    #10'   ORDER BY globalcredcoup.IdtCredCoup' ;

end;   // of TFrmDetCreditCoupon.BuildSQLStatementGlobal

//=============================================================================
function TFrmDetCreditCouponCleansing.BuildSQLStatementUpdate : string;
var
RegKey : TRegistry; //R2011.2 - Defect 202 Fix(GG)
InIdtOperator : String; //R2011.2 - Defect 202 Fix(GG)
begin  // of TFrmDetCreditCoupon.BuildSQLStatementGlobal
  if   (VarNOM = '')then   begin
     VarNOM := '03';
  end;
    //R2011.2 - Defect 202 Fix(GG) ::Start
     InIdtOperator := '0';
     RegKey := TRegistry.Create;
     RegKey.RootKey := HKEY_CURRENT_USER;
   if RegKey.OpenKey('SOFTWARE\Sycron\Flexpoint\Menu\Logon',False)   then
    InIdtOperator := RegKey.ReadString('IdOperator') ;
   //R2011.2 - Defect 202 Fix(GG) ::End

  Result := ('SET NOCOUNT ON'+
      #10'Declare @EmmissionDate datetime' +
      #10' Select @EmmissionDate =    case when (day(getdate())>20) Then' +
      #10'(select cast(substring(cast(dateadd(day,-day(getdate()-1),dateadd(month,-('+VarNOM+'),getdate())) as varchar(40)),1,11) as datetime))' +      //Internal testing defect fix R2011.2 P5    R2011.2 - R2011.2 defect 362 fix
      #10'                            else' +
      #10'(select cast(substring(cast(dateadd(day,-day(getdate()-1),dateadd(month,-('+VarNOM+'+1),getdate())) as varchar(40)),1,11) as datetime))' +  //Internal testing defect fix R2011.2 P5     R2011.2 - R2011.2 defect 362 fix
      #10'                            end' +
      #10' Select @EmmissionDate' +
      #10'Insert Into globalcredcoup' +   //R2011.2 Defect 205 Fix
      #10'select distinct 0,0,1,getdate(),Idtcredcoup,'''+InIdtOperator+''',3,SUM(Valamount),getdate(),getdate() from globalcredcoup' + //R2011.2 Defect 205 Fix //R2011.2 - Defect 300 Fix(GG) //R2011.2 defect 362 fix   //R2012 defect 283 fix
      #10' where codtype = 0' +
      #10' and Idtcredcoup not in(select Idtcredcoup from globalcredcoup where codtype <> 0) ' +
      #10' and DatTransBegin <  @EmmissionDate' +         //R2011.2 - Defect 197 Fix(GG)
      #10'GROUP BY globalcredcoup.IdtCredCoup' +         //R2011.2 - Defect 300 Fix(GG)
      #10'SET NOCOUNT OFF' );
     // #10'AND IdtCredCoup = ' + AnsiQuotedStr(EdtCreditCoupon.Text, '''');
end;   // of TFrmDetCreditCoupon.BuildSQLStatementDetail
//==============================================================================
function TFrmDetCreditCouponCleansing.BuildSQLStatementUpdateCredCoup : string;
begin  // of TFrmDetCreditCoupon.BuildSQLStatementGlobal
  if   (VarNOM = '')then   begin
     VarNOM := '03';
  end;
  Result := ('SET NOCOUNT ON'+
      #10'Declare @EmissionDate datetime' +
      #10' Select @EmissionDate =    case when (day(getdate())>20) Then' +
      #10'(select cast(substring(cast(dateadd(day,-day(getdate()-1),dateadd(month,('+VarNOM+'),getdate())) as varchar(40)),1,11) as datetime))' +      //Internal testing defect fix R2011.2 P5  R2011.2 - R2011.2 defect 362 fix
      #10'                            else' +
      #10'(select cast(substring(cast(dateadd(day,-day(getdate()-1),dateadd(month,-('+VarNOM+'+1),getdate())) as varchar(40)),1,11) as datetime))' +  //Internal testing defect fix R2011.2 P5   R2011.2 - R2011.2 defect 362 fix
      #10'                            end' +
      #10' Select @EmissionDate' +
      #10'Update Creditcoupon' +
      #10'Set DatSettle = getdate(),CodState = 1' +
      #10'where IdtCredCoup in' +
      #10'                     (Select distinct IdtCredCoup from globalcredcoup' +
      #10'                                 where codtype = 1' +               //R2011.2 - Defect 197 Fix(GG)
      #10'                                 and IdtPosTransaction =0' +        //R2011.2 - Defect 197 Fix(GG)
      #10'                                 and IdtCheckout =0' +              //R2011.2 - Defect 197 Fix(GG)
      //#10'                                  and datcreate <  @EmissionDate' +      //R2011.2 - Defect 205 Fix(GG)
      #10'                                  GROUP BY globalcredcoup.IdtCredCoup)' +
      #10'SET NOCOUNT OFF' );
     // #10'AND IdtCredCoup = ' + AnsiQuotedStr(EdtCreditCoupon.Text, '''');
end;   // of TFrmDetCreditCoupon.BuildSQLStatementDetail

//==============================================================================

procedure TFrmDetCreditCouponCleansing.Execute;
begin  // of TFrmDetCreditCoupon.Execute
  ResetValues;

  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;

    PrintTableBodyGlobal;
    VspPreview.EndDoc;


  PrintPageNumbers;
  PrintReferences;

  if FlgPreview then
    FrmVSPreview.Show ;

  FrmVSPreview.OnActivate(Self);
end;   // of TFrmDetCreditCoupon.Execute
//==============================================================================
// TFrmDetGlobalAcomptes.PrintHeader : Print header of report
//==============================================================================

procedure TFrmDetCreditCouponCleansing.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  RefMon           : string;
begin  // of TFrmDetCreditCoupon.PrintHeader
  if(copy(datetostr(now),1,2)>='21') then begin   //Internal defect fix 2011.2 phase7 GG(TCS)
    RefMon := '01-'+ copy(datetostr(now),4,2) + '-' +copy(datetostr(now),7,4);   //R2011.2 - Defect 262 Fix GG(TCS)
    end
    else  begin
     if(copy(datetostr(now),4,2) > '10')  then
     RefMon := '01-'+ inttostr(strtoint(copy(datetostr(now),4,2))-1) +'-' +copy(datetostr(now),7,4)
     //R2011.2 Defect  305 Fix GG(TCS) ::Start
     else if  ((copy(datetostr(now),4,2) > '01') and (copy(datetostr(now),4,2) <= '10'))  then
     RefMon := '01-0'+ inttostr(strtoint(copy(datetostr(now),4,2))-1) +'-'+ copy(datetostr(now),7,4)
     else
     RefMon := '01-12'+'-' + inttostr(strtoint(copy(datetostr(now),7,4)) -1);
     //R2011.2 Defect  305 Fix GG(TCS) ::End
     end;
    TxtHdr := CtTxtGlobal + ': ' +TxtTitRapport + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
            DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr + CtTxtReportDate + ' ' + RefMon + CRLF;

  TxtHdr := TxtHdr + CtTxtPrintDate + ' '+copy(datetostr(now),1,2)+'-'+copy(datetostr(now),4,2)+'-'+copy(datetostr(now),7,4)+' '+CtTxtAt+' '+timetostr(time)+CRLF+CRLF;
  if FlgUpdCr  then
   TxtHdr := TxtHdr + CtTxtSelected + ' ' + CtTxtRunType + ' '
  else
   TxtHdr := TxtHdr + CtTxtSelected + ' ' + CtTxtExampleType + ' '; //+
//              EdtCreditCoupon.Text;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetCreditCoupon.PrintHeader

//==============================================================================
// TFrmDetGlobalAcomptes.PrintTableBodyGlobal : Print tablebody of global report
//==============================================================================

procedure TFrmDetCreditCouponCleansing.PrintTableBodyGlobal;
var
  TxtPrintLine        : string;           // String to print
  TxtValIn            :string;
begin  // of TFrmDetCreditCoupon.PrintTableBodyGlobal
  inherited;
  try
    ResetValues;
    if DmdFpnUtils.QueryInfo (BuildSQLStatementGlobal) then begin
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      while not DmdFpnUtils.QryInfo.Eof do begin
        TxtValIn := FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat);
        if (TxtValIn = '0.00') or (TxtValIn = '0,00') then    //R2011.2 Phase 7 Internal Defect Fix
        TxtValIn := '';
        TxtPrintLine :=
          DmdFpnUtils.QryInfo.FieldByName ('IdtCredCoup').AsString + TxtSep;
          if DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime = 0 then
            TxtPrintLine := TxtPrintLine + TxtSep
          else
            TxtPrintLine := TxtPrintLine +
            FormatDateTime (CtTxtDatFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime) + ' ' +
            FormatDateTime (CtTxtHouFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime) + TxtSep;
          if DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime = 0 then
            TxtPrintLine := TxtPrintLine + TxtSep
          else
            TxtPrintLine := TxtPrintLine +
            FormatDateTime (CtTxtDatFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime) + ' ' +
            FormatDateTime (CtTxtHouFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime) + TxtSep;
            if FlgUpdCr  then begin
             TxtPrintLine := TxtPrintLine +
             FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat) + TxtSep +
             FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat) + TxtSep +
             TxtValIn
             end
            else begin
            TxtPrintLine := TxtPrintLine + 
            FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat) + TxtSep +
            TxtValIn + TxtSep +
            FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat)
            end;
            VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                                 clWhite, False);
          CalculateValues;
          DmdFpnUtils.QryInfo.Next;
      end;
      VspPreview.EndTable;
      PrintTotalGlobal;

    end
    else begin
      VspPreview.CurrentY := VspPreview.CurrentY + 250;
      //VspPreview.TableBorder := tbNone;
      VspPreview.StartTable;
      VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                           clWhite, False);
      VspPreview.EndTable;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetCreditCoupon.PrintTableBodyGlobal


//==============================================================================

procedure TFrmDetCreditCouponCleansing.PrintTotalGlobal;
var
  TxtTotal      : string;
  TxtValIn      : string;
begin  // of TFrmDetCreditCoupon.PrintTotalGlobal
 if TxtValIn = '0.00' then
        TxtValIn := '';
  if FlgUpdCr then
  TxtTotal := CtTxtNbCredCoups + ' ' + IntToStr(NumCredCoups) + TxtSep + '' +
              TxtSep + '' + TxtSep + FormatFloat (CtTxtFrmNumber, ValOut) +
              TxtSep + FormatFloat (CtTxtFrmNumber, ValSaldo) + TxtSep +
              ''
  else
  TxtTotal := CtTxtNbCredCoups + ' ' + IntToStr(NumCredCoups) + TxtSep + '' +
              TxtSep + '' + TxtSep + FormatFloat (CtTxtFrmNumber, ValOut) +
              TxtSep + '' + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValSaldo);
  VspPreview.CurrentY := VspPreview.CurrentY + 250;
  VspPreview.StartTable;
  VspPreview.AddTable (FmtTableBody, '', TxtTotal, clWhite,
                       clWhite, False);
  //VspPreview.TableCell[tcFontBold, 1, 1, 1, 8] := True;
  VspPreview.EndTable;
end;   // of TFrmDetCreditCoupon.PrintTotalGlobal

//==============================================================================
// TFrmDetGlobalAcomptes.DetermineMouvementType : Determine mouvement type
//==============================================================================

function TFrmDetCreditCouponCleansing.DetermineMouvementType: string;
begin  // of TFrmDetGlobalAcomptes.DetermineMouvementType
  Case DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger of
    0: Result :=   CtTxtRegistered;
    1: Result :=   CtTxtPayedBack;
    2: Result :=   CtTxtCanceled;
  end;
end;   // of TFrmDetGlobalAcomptes.DetermineMouvementType

//==============================================================================
// TFrmDetGlobalAcomptes.ResetValues : Clear all total values
//==============================================================================

procedure TFrmDetCreditCouponCleansing.ResetValues;
begin  // of TFrmDetGlobalAcomptes.ResetValues
  NumCredCoups    := 0;
  ValOut          := 0;
  ValIn           := 0;
  ValSaldo        := 0;
end;   // of TFrmDetGlobalAcomptes.ResetValues

//==============================================================================
// TFrmDetGlobalAcomptes.CalculateValues : Calculate all total values
//==============================================================================

procedure TFrmDetCreditCouponCleansing.CalculateValues;
begin  // of TFrmDetGlobalAcomptes.CalculateValues
  NumCredCoups    := NumCredCoups + 1;
  ValOut          := ValOut + StrToFloat(
                     DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsString);
  ValIn           := ValIn + StrToFloat(
                     DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsString);
  ValSaldo        := ValSaldo + StrToFloat(
                     DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsString);
end;   // of TFrmDetGlobalAcomptes.CalculateValues

//=============================================================================

procedure TFrmDetCreditCouponCleansing.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetGlobalAcomptes.BtnPrintClick
    FlgUpdCr := False;
    FlgDetailReport := False;
     FlgPreview := (Sender = BtnPreview);
     if FlgDetailReport then begin
       if not DmdFpnUtils.QueryInfo (BuildSQLStatementGlobal) then begin
         MessageDlg (CtTxtNoData, mtWarning, [mbOK], 0);           //Defect 100 Fixed R2011.2(GG)
         //EdtCreditCoupon.Text := '';
         DmdFpnUtils.CloseInfo;
         exit;
       end;
     end
     else begin
       {if not DmdFpnUtils.QueryInfo (BuildSQLStatementGlobal)
       //and RdbtnDownPaymentNr.Checked
       then begin
         MessageDlg (CtTxtNoData, mtWarning, [mbOK], 0);
       //  EdtCreditCoupon.Text := '';
         DmdFpnUtils.CloseInfo;
         exit;
       end;  }
     end;
     DmdFpnUtils.CloseInfo;
     Execute;

  //end;
end;   // of TFrmDetGlobalAcomptes.BtnPrintClick
//=============================================================================

procedure TFrmDetCreditCouponCleansing.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmDetCAEtatCodesInconnus.BeforeCheckRunParams
  inherited;
  // add param /VBQC to help
  SplitString(CtTxtNOM, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end; // of TFrmDetCAEtatCodesInconnus.BeforeCheckRunParams
   
//=============================================================================

procedure TFrmDetCreditCouponCleansing.CheckAppDependParams(TxtParam: string);
begin // of TFrmDetCAEtatCodesInconnus.CheckAppDependParams
  if Copy(TxtParam, 3, 3) = 'NOM' then
    VarNOM :=  Copy(TxtParam, 6, 2);
end; // of TFrmDetCAEtatCodesInconnus.CheckAppDependParams

//==============================================================================
//=============================================================================

procedure TFrmDetCreditCouponCleansing.FormCreate(Sender: TObject);
begin
  inherited;
  Application.Title := CtTxtTitle; //R2011.2 Defect 94 fixed (GG)
  //RdbtnNotPayed.Checked := True;
  DtmPckDayFrom.DateTime := now;
  //EdtCreditCoupon.Text := '';
  // Added for R2011.2
  BtnStart.Visible := True;
  BtnPrintSetup.Visible := False;
  BtnPrint.Visible := False;
  //End of Addition
end;

//=============================================================================

procedure TFrmDetCreditCouponCleansing.FormActivate(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
  DtmSetDayFrom    : TDateTime;        // Variable to prevent date resetting after preview
begin
  inherited;
  DtmSetDayFrom := DtmPckDayFrom.DateTime;
  // Disable ChkLbxOperator and select all available operators

  FrmDetCreditCouponCleansing.Caption :=  CtTxtTitle;
  BtnPreview.Caption := CtTxtExample;
  BtnStart.Caption :=  CtTxtStart;
  BtnExit.Caption := CtTxtQuit;

  AutoStart(Self);
  DtmPckDayFrom.DateTime := DtmSetDayFrom;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do
    ChkLbxOperator.Checked [CntIx] := True;
  ChkLbxOperator.Enabled := False;
  BtnSelectAll.Enabled := False;
  BtnDeSelectAll.Enabled := False;
  RbtDateDayClick(Self);
  MniExit.Caption:= CtTxtQuit; //DFixed
  MniStart.Caption:=  CtTxtStart;//DFixed
  MniPreview.Caption := CtTxtExample;
  mnilogfile.Visible := false;
  MniFile.Caption:=  CtTxtFile;
  MniHelp.Caption:= CtTxtHelp;
  MniAbout.Caption := CtTxtAbout;

end;

//=============================================================================

procedure TFrmDetCreditCouponCleansing.EdtCreditCouponKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key in [chr(32)..chr(47)] + [chr(58)..chr(255)] then Key := #0
end;
//=============================================================================
 //TCS Modification (SC)  Start
 function TFrmDetCreditCouponCleansing.CreateMessageDlgBtnst (const TxtMsg     : string;
                                     CodDlgType : TMsgDlgType;
                               const ArrTxtBtns : array of string;
                                     NumDefBtn  : Integer;
                                     NumHelpBtn : Integer         ) : TForm;
var
  PTxtIconID       : PChar;            // Icon-identification
  TextRect         : TRect;            // Rectangle to draw text
  ValIconTxtWidth  : Integer;          // Width of Message-text and Icon
  ValIconTxtHeight : Integer;          // Height of Message-text and/or Icon
  ValBtnMaxWidth   : Integer;          // Maximum width of buttons
  ValBtnRowWidth   : Integer;          // Maximum width of row with buttons
  ValX             : Integer;          // an X-Offset when needed
  ValY             : Integer;          // an Y-Offset when needed
  BtnNew           : TButton;          // Created button
  NumBtnCount      : Integer;          // Number of Buttons required
  NumBtnRowCount   : integer;          // Number of rows with buttons
  NumBtnPerRow     : Integer;          // Number of buttons per row
  NumBtn           : Integer;          // Loop-variable for calculation of
                                       // Button-offset : Btn-nr in Row
  NumRow           : Integer;          // Loop-variable for calculation of
                                       // Button-offset : Rownr
  NumIndex         : Integer;          // Loop-Variable : actual number of
                                       // items in ArrTxtBtns (empty or not)
const
  SMsgDlgWarning = 'Warning';
  SMsgDlgError   = 'Error' ;
  SMsgDlgInformation = 'Information';
  SMsgDlgConfirm     =  'Confirm'  ;

begin  // of CreateMessageDlgBtns

   Result := TMessageForm.CreateNew(Application);
  with Result do begin
    BorderStyle    := bsDialog;
    Canvas.Font    := Font;
    Width          := CtValFormWidth;
   Position        := poDesigned;
    // Initialization of Button-offsets
    ValBtnMaxWidth := 0;
    ValBtnRowWidth := 0;
    NumBtnPerRow   := 0;
    NumBtnCount    := 0;
    // Calculation of the largest button with a minimum size of 75
    for NumIndex := Low (ArrTxtBtns) to High (ArrTxtBtns) do
      ValBtnMaxWidth := StUtils.MaxLong
                          (Canvas.TextWidth (ArrTxtBtns[NumIndex]) + 15,
                           ValBtnMaxWidth);
    if ValBtnMaxWidth < CtValBtnWidth then
      ValBtnMaxWidth := CtValBtnWidth;
    // Calculation of number of buttons per row and number of rows
    for NumIndex := Low (ArrTxtBtns) to High (ArrTxtBtns) do
      if ArrTxtBtns[NumIndex] <> '' then begin
        if (ValBtnRowWidth + ValBtnMaxWidth) < (ClientWidth - 2 *
                                                CtValHorzSpacing) then begin
            Inc (ValBtnRowWidth, ValBtnMaxWidth + CtValBtnSpacing);
            Inc (NumBtnPerRow);
        end;
        Inc (NumBtnCount);
      end;
    if NumBtnPerRow <> 0 then begin
      NumBtnRowCount := NumBtnCount div NumBtnPerRow;
      if (NumBtnCount mod NumBtnPerRow) <> 0 then
        Inc (NumBtnRowCount);
    end
    else
      NumBtnRowCount := 0;
    // Calculation of Icon- and Text-offsets
    PTxtIconID := CiArrTxtIconIDs[CodDlgType];
    if Assigned (PTxtIconID) then
      ValX := ClientWidth - (32 + (2 * CtValHorzMargin) + CtValHorzSpacing)
    else
      ValX := ClientWidth - (2 * CtValHorzMargin);
    SetRect (TextRect, 0, 0, ValX, 0);
    DrawText (Canvas.Handle, PChar(TxtMsg), -1, TextRect,
              DT_CALCRECT or DT_WORDBREAK);
    ValIconTxtWidth  := TextRect.Right;
    ValIconTxtHeight := TextRect.Bottom;
    if Assigned (PTxtIconID) then begin
      Inc (ValIconTxtWidth, 32 + CtValHorzSpacing);
      if ValIconTxtHeight < 32 then
        ValIconTxtHeight := 32;
    end;
    // Boundary-setting of DialogBox
    ClientWidth  := StUtils.MaxLong (ValIconTxtWidth, ValBtnRowWidth) +
                    (2 * CtValHorzMargin);
    ClientHeight := ValIconTxtHeight + 2 * CtValVertMargin +
                    NumBtnRowCount * (CtValVertSpacing + CtValBtnHeight);
    if Width > CtValFormWidth then begin
      HorzScrollBar.Range := Width;
      Width := CtValFormWidth;
      VertScrollBar.Range := Height;
      if Height > CtValFormHeight then
        Height := CtValFormHeight;
    end
    else if Height > CtValFormHeight then begin
      VertScrollBar.Range := Height;
      Height := CtValFormHeight;
      HorzScrollBar.Range := Width;
    end;
    Left := (Screen.Width div 2) - (Width div 2);
    Top  := (Screen.Height div 2) - (Height div 2);
    // Caption-setting DialogBox
    if CodDlgType <> mtCustom then begin
      case CodDlgType of
        mtWarning      : Caption := 'Warning';
        mtError        : Caption := 'Error';
        mtInformation  : Caption := 'Information';
        mtConfirmation : Caption := 'Confirm';
      end;  // of case CodDlgType
    end
    else
      Caption := CtTxtCap;
    // Creation and Setup of Dialogtype-Icon if necessary
    if Assigned (PTxtIconID) then
      with TImage.Create(Result) do begin
        Name   := 'Image';
        Parent := Result;
        Picture.Icon.Handle := LoadIcon (0, PTxtIconID);
        SetBounds (CtValHorzMargin, CtValVertMargin, 32, 32);
      end;
    // Creation and Setup of Message-text
    with TLabel.Create (Result) do begin
      Name       := 'Message';
      Parent     := Result;
      WordWrap   := True;
      Caption    := TxtMsg;
      BoundsRect := TextRect;
      SetBounds (ValIconTxtWidth - TextRect.Right + CtValHorzMargin,
                 CtValVertMargin,
                 TextRect.Right,
                 TextRect.Bottom);
    end;
    // Creation and Setup of Buttons
    NumBtn := 0;
    NumRow := 0;
    for NumIndex := Low (ArrTxtBtns) to High (ArrTxtBtns) do
      if ArrTxtBtns[NumIndex] <> '' then begin
        BtnNew := TButton.Create (Result);
        with BtnNew do begin
          Name        := 'Btn' + IntToStr (NumIndex);
          Parent      := Result;
          Caption     := ArrTxtBtns[NumIndex];
          ModalResult := - Succ (NumIndex);
          if NumIndex = Pred (NumDefBtn) then begin
            Default := True;
            ActiveControl := BtnNew;
          end;
          if NumIndex = Pred (NumHelpBtn) then begin
            OnClick := TMessageForm(Result).HelpButtonClick;
            ModalResult := mrNone;
          end;
          ValX := ((Result.ClientWidth - ValBtnRowWidth) div 2) +
                  (NumBtn * (CtValBtnSpacing + ValBtnMaxWidth));
          ValY := ValIconTxtHeight + CtValVertMargin + CtValVertSpacing +
                  (NumRow * (CtValBtnHeight + CtValVertSpacing));
          SetBounds (ValX, ValY, ValBtnMaxWidth, CtValBtnHeight);
          if NumBtn < NumBtnPerRow - 1 then
            Inc (NumBtn)
          else begin
            NumBtn := 0;
            if NumRow < NumBtnRowCount - 1 then
              Inc (NumRow);
          end;
        end;   // of with TButton.Create (Result) do
      end;
  end;   // of with Result do
end;   // of CreateMessageDlgBtns

//TCS Modification (SC) End
//=============================================================================

procedure TFrmDetCreditCouponCleansing.ActStartExecExecute(Sender: TObject);
Var
  ButtonSelected : Integer;
const
TestArray : array[0..1] of string = (CtTxtOk,CtTxtCancel);//TCS Modification

begin
  FlgUpdCr := True;
  inherited;
  ResetValues;
  FrmVSPreview.Close();
  FlgUpdCr := True;
  //ShowMessage(inttostr(VarNOM));
  //buttonSelected := CreateMessageDlgBtns(CttxtConfirmation,mtCustom, CttxtConfirmation, 2,0);//to be deleted TCS
  //buttonSelected := MessageDlg(CttxtConfirmation,mtCustom, mbOKCancel, 0);//to be deleted TCS
  //if buttonSelected = 1    then  begin
    //TCS Modification (SC) Begin
   if not DmdFpnUtils.QueryInfo (BuildSQLStatementGlobal) then begin
     MessageDlg (CtTxtNoData, mtWarning, [mbOK], 0);     //Defect 100 Fixed R2011.2(GG)
     DmdFpnUtils.CloseInfo;
     exit;
   end;
   DmdFpnUtils.CloseInfo;

   FrmMsg := CreateMessageDlgBtnst(CttxtConfirmation,mtCustom,TestArray,2,0 );
   FrmMsg.Left  := 600;
   FrmMsg.Top   := 300;
   ButtonSelected := FrmMsg.ShowModal;
  if ButtonSelected > 0 then
      ButtonSelected := ButtonSelected
    else
      ButtonSelected := Abs (ButtonSelected);

  //buttonSelected := Messagedlg  ('abc',mtCustom,[mbOK,mbCancel],0);


  if ButtonSelected = 1    then  begin//if buttonSelected = 1    then  begin
  //TCS Modification (SC) End
   FrmVSPreview.Show;
   DmdFpnUtils.QueryInfo (BuildSQLStatementUpdate);
   DmdFpnUtils.CloseInfo ;
   DmdFpnUtils.QueryInfo (BuildSQLStatementUpdateCredCoup);
   DmdFpnUtils.CloseInfo ;
   end
  else
   FormActivate(FrmDetCreditCouponCleansing);
end;

procedure TFrmDetCreditCouponCleansing.MniPreviewClick(Sender: TObject);
begin
  inherited;
  BtnPreview.Click;
end;
{
procedure TFrmDetCreditCouponCleansing.PrintPageNumbers;

  //inherited;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmDetGeneralCA.PrintPageNumbers
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, TRUE);
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1000;
      CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom + 100;
      Text := CtTxtPage + ' ' + IntToStr (CntPageNb) + '/' +
                                IntToStr (VspPreview.PageCount);
      EndOverlay;
    end;
  end;

end;
}
initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetGlobalAcomptes
