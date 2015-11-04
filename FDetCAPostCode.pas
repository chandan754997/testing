//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer : Brico Depot
// Unit     : FDetCAPostCode.PAS : Post Code Entry Report
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version    Modified by    Reason
// 1.0    S.M.(TCS)      Initial version created for Post Code Entry Report in R2011.2
// 1.1    G.G.(TCS)      Defect#48 Fixed
// 1.2    SM (TCS)       Defect Fix 124, 125
// 1.3    SM (TCS)       Defect Fix 124, 125 (Refixed)
// 1.4    SM (TCS)       Defect Fix 212
// 1.5    SM (TCS)       Regression Fix R2011.2
//=============================================================================


unit FDetCAPostCode;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils,
  SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring          // of header
  CtTxtTitle            = 'Liste des postaux';//'List of postal codes';


resourcestring          // of table header.

  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtReportDate       = 'Report from %s to %s';
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtErrorHeader      = 'Incorrect Date';
  CtTxtExample          = 'Example' ;


resourcestring          //of Total

  CtTxtTotal             = 'Total';
  CtTxtPostCodeHeader    = 'Code';
  CtTxtPostCode          = 'Postal';                                 // Defect Fix 124 (S.M)
  CtTxtTotalSaisieHeader = 'Total tickets per code postal';
  CtTxtErrMsg            = 'Select less than 10 Operator';


//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetCAPostCode = class(TFrmDetGeneralCA)
    CAPostCodeSpr: TStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
  protected
    CntTot         : Integer;
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableTotal : string; virtual;
    function GetTxtTitRapport : string; override;
  public
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure PrintTotal(TotalTick:Double;SumArray: Array of Integer);
    procedure Execute; override;
    property FmtTableTotal : string read GetFmtTableTotal;
 end;

var
  FrmDetCAPostCode: TFrmDetCAPostCode;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils,
  DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCAPostCode';

const  // CVS-keywords
  CtTxtSrcName                = '$';
  CtTxtSrcVersion             = '$Revision: 1.5 $';
  CtTxtSrcDate                = '$Date: 2012/02/15 09:55:26 $';

//*****************************************************************************
// Implementation of TFrmDetCAPostCode
//*****************************************************************************

function TFrmDetCAPostCode.GetFmtTableHeader: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCAPostCode.GetFmtTableHeader                                          //Regression Fix (SM) R2011.2 ::START
  Result := '^+' + IntToStr (CalcWidthText (12, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (12, False));
  for CntFmt := 1 to CntTot do begin
    Result := Result + TxtSep + '^' + IntToStr (CalcWidthText (12, False))
  end;
end;   // of TFrmDetCAPostCode.GetFmtTableHeader

//=============================================================================

function TFrmDetCAPostCode.GetFmtTableBody: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCAPostCode.GetFmtTableBody
  Result := '>+' + IntToStr (CalcWidthText (12, False));                                  // Defect Fix 124 (S.M) (Refixed)     //Regression Fix (SM)
  Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (12, False));               //Defect Fix 125 (S.M)  (Refixed)      //Regression Fix (SM)
  for CntFmt := 1 to CntTot do begin
    Result := Result + TxtSep + '^' + IntToStr (CalcWidthText (12, False))
  end;
end;   // of TFrmDetCAPostCode.GetFmtTableBody

//=============================================================================
function TFrmDetCAPostCode.GetFmtTableTotal: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCAPostCode.GetFmtTableBody
  Result := '<' + IntToStr (CalcWidthText (12, False));                                   // Defect Fix 124 (S.M)
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (12, False));                // Defect Fix 125 (S.M)
  for CntFmt := 1 to CntTot do begin
    Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (12, False))
  end;
end;
//=============================================================================
function TFrmDetCAPostCode.GetTxtTitRapport : string;
begin  // of TFrmDetCAPostCode.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetCAPostCode.GetTxtTitRapport

//=============================================================================
procedure TFrmDetCAPostCode.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCAPostCode.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF;                                                                  //Regression Fix (SM) R2011.2

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
            DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetCAPostCode.PrintHeader

//=============================================================================

procedure TFrmDetCAPostCode.PrintTableBody;
var

    TitleCount       : integer;
    NumCounter       : integer;
    FldValue         : string;
    HdrOprLeft       : string;
    HdrOprRight      : string;
    FldList          : TStringlist;
    TotalTick        : double;
    VarTickPerc     : Double;
    TktList          : TStringlist;
    Counter1         : integer;
    Counter2         : integer;
    SumArray         : Array of Integer;
    InterFldValue    : string;
    VarRelacedot     : String;
begin  // of TFrmDetCAPostCode.PrintTableBody

  TotalTick:=0;
  VarRelacedot:='';
  FldList := TstringList.Create;
  FldList.Clear;
  TktList:= TStringlist.Create;
  TktList.Clear;

  for NumCounter :=0 to CAPostCodeSpr.FieldCount-1 do begin   // To Get Table field names
    FldList.add(CAPostCodeSpr.Fields.Fields[NumCounter].DisplayName);
  end;
  SetLength(SumArray, FldList.Count-2 );
  TitleCount:=0 ;
  TktList.Clear;
  while not CAPostCodeSpr.eof do
  begin
   VspPreview.StartTable;
   FldValue :='';
   if(TitleCount=0) then
   begin
     for NumCounter :=0 to FldList.Count-1 do
     begin
       if (NumCounter=0) then
         FldValue := CtTxtPostCodeHeader + CRLF +CtTxtPostCode                            // Defect Fix 125 (S.M)
       else if (NumCounter=1) then
         FldValue := FldValue + TxtSep +  CtTxtTotalSaisieHeader
       else begin
        if  CAPostCodeSpr.FieldByName(FldList.Strings[NumCounter]).AsString <> '0' then begin
         HdrOprLeft :=copy(CAPostCodeSpr.FieldByName(FldList.Strings[NumCounter]).AsString,1,(Pos(' ', CAPostCodeSpr.FieldByName(FldList.Strings[NumCounter]).AsString)-1));
         HdrOprRight:=copy(CAPostCodeSpr.FieldByName(FldList.Strings[NumCounter]).AsString,(Length(HdrOprLeft)+2),(Length(CAPostCodeSpr.FieldByName(FldList.Strings[NumCounter]).AsString)-(Length(HdrOprLeft)-1)));
         InterFldValue := HdrOprLeft +  CRLF + HdrOprRight;
        end;
         FldValue := FldValue + TxtSep + InterFldValue ;
        end;
     end;
     CntTot :=  FldList.Count-2;
     VspPreview.AddTable (FmtTableHeader, '', FldValue, clGray,clGray,False);                        //Regression Fix (SM) R2011.2
   end
   else begin

     for NumCounter :=0 to FldList.Count-1 do
     begin

       if (NumCounter=0) then
         FldValue := CAPostCodeSpr.FieldByName(FldList.Strings[NumCounter]).AsString
       else begin
         if (NumCounter = 1) then
         FldValue := FldValue + TxtSep +  CAPostCodeSpr.FieldByName(FldList.Strings[NumCounter]).AsString;
         if (NumCounter>1) then begin
          FldValue := FldValue + TxtSep +  CAPostCodeSpr.FieldByName(FldList.Strings[NumCounter]).AsString + '%';
         end

       end;
       if (NumCounter>1) then
       begin    //
         VarRelacedot :=  StringReplace(CAPostCodeSpr.FieldByName(FldList.Strings[NumCounter]).AsString, '.', ',',[rfReplaceAll, rfIgnoreCase]);
         VarTickPerc := Round(StrToFloat(VarRelacedot) * StrToFloat(CAPostCodeSpr.FieldByName('TotalTickForPost').AsString));


         TktList.Add(FloatTostr(VarTickPerc));
       end;
     end;

     TotalTick:=TotalTick + CAPostCodeSpr.FieldByName('TotalTickForPost').AsFloat;

     VspPreview.AddTable (FmtTableBody, '', FldValue, clWhite,clWhite,False);
   end;

   TitleCount:= TitleCount+1;
   VspPreview.EndTable;

   CAPostCodeSpr.Next;
 end;
    Counter1:=0;
    while Counter1 < FldList.Count-2 do                                                    //Defect Fix 212 R2011.2 (SM)
    begin
    Counter2 :=Counter1;
      while Counter2 < TktList.Count do
        begin
          SumArray[Counter1]:= SumArray[Counter1] + StrToInt(TktList.Strings[Counter2]);
          Counter2:= Counter2 +  FldList.Count-2  ;
        end;
      Counter1 := Counter1 + 1;
    end;

FldList.Free;

PrintTotal (TotalTick,SumArray);

  CAPostCodeSpr.Close;

end;   // of TFrmDetCAPostCode.PrintTableBody

//=============================================================================

procedure TFrmDetCAPostCode.Execute;
var CntIx     : Integer;
    OprString,tempstr : string ;
    Strposi :Integer;
    TempCntr:Integer;
begin  // of TFrmDetCAPostCode.Execute
  CntTot:=0;
  TempCntr:=0;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntIx] then begin
      TempCntr := TempCntr + 1;
      tempstr:='';
      tempstr := ChkLbxOperator.Items[CntIx];
      Strposi := pos(':',tempstr);
      Delete(tempstr,Strposi-1,Length(tempstr)-Strposi + 2);
      OprString:=OprString+ tempstr +',';
      if  TempCntr > 9 then begin
        showmessage(CtTxtErrMsg);
        exit;
      end;
    end;
  end;
 Delete(OprString,Length(OprString),1);
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
  (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date)then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      DtmPckLoadedFrom.Date := Now;
      DtmPckLoadedTo.Date := Now;
      Application.MessageBox(PChar(CtTxtStartEndDate),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now)then begin
      DtmPckDayFrom.Date := Now;
      DtmPckLoadedFrom.Date := Now;
      Application.MessageBox(PChar(CtTxtStartFuture),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
      DtmPckDayto.Date := Now;
      DtmPckLoadedto.Date := Now;
      Application.MessageBox(PChar(CtTxtEndFuture),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin


    CAPostCodeSpr.Active := False;
    CAPostCodeSpr.ParamByName ('@DatFrm').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);
    CAPostCodeSpr.ParamByName ('@DatTo').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);
    CAPostCodeSpr.ParamByName ('@OperatorNumber').AsString :=
        OprString;
    CAPostCodeSpr.Active := True;

    VspPreview.Orientation := orLandscape;
    VspPreview.StartDoc;

    PrintTableBody;
    PrintTableFooter;
    VspPreview.EndDoc;

    PrintPageNumbers;
    PrintReferences;

    if FlgPreview then
      FrmVSPreview.Show;
    //else
    //  VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
      FrmVSPreview.OnActivate(Self);
  end;
end;   // of TFrmDetCAPostCode.Execute

//=============================================================================
procedure TFrmDetCAPostCode.PrintTotal(TotalTick: Double;SumArray: Array of Integer);

var
  TxtLine          : string;           // Line to print
  NumeCounter      : Integer;
  TempString       : string;


begin   // of TFrmDetCAPostCode.PrintTotal
  TempString :='';
  VspPreview.StartTable;


  for NumeCounter := 0 to Length(SumArray)-1 do
   begin
     TempString := TempString + IntToStr(round((SumArray[NumeCounter])*(0.01))) + TxtSep ;
   end;
    TempString := copy(TempString,1,length(TempString)-1)  ;
  TxtLine :=
       CtTxtTotal +  TxtSep + FloatToStr(TotalTick) + TxtSep + TempString;


  VspPreview.AddTable (FmtTableTotal, '', TxtLine, clgray, clgray, False);
  VspPreview.EndTable;


end;


procedure TFrmDetCAPostCode.BtnPrintClick(Sender: TObject);
begin
  inherited;
  //showmessage('SIDD');
end;

procedure TFrmDetCAPostCode.FormCreate(Sender: TObject);
begin
  inherited;
   BtnPreview.Caption := CtTxtExample;
   Application.Title := CtTxtTitle;
end;

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun

