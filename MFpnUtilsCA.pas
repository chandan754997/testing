//=Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved.========
// Packet : FlexPoint Development
// Unit   : MFpnUtils.PAS : Module FlexPoiNt UTILitieS CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MFpnUtilsCA.pas,v 1.2 2007/04/10 12:35:44 JurgenBT Exp $
// History:
//=============================================================================

unit MFpnUtilsCA;

//*****************************************************************************

interface


resourcestring
  CtTxtNumZero  = 'zero';
  CtTxtNumOne   = 'one';
  CtTxtNumTwo   = 'two';
  CtTxtNumThree = 'three';
  CtTxtNumFour  = 'four';
  CtTxtNumFive  = 'five';
  CtTxtNumSix   = 'six';
  CtTxtNumSeven = 'seven';
  CtTxtNumEight = 'eight';
  CtTxtNumNine  = 'nine';

type
  TArrNumeral = array [0..9] of string;

//*****************************************************************************
// Interfaced procedures and functions
//*****************************************************************************

//=============================================================================
// GetFWFontForLangID : returns the name of a fixed width font to use for the
//   given language Id. See Windows unit for valid language Id codes.
//                                     ---
// INPUT  : IdtLanuage = language Id value
//                                     ---
// RESULT : string of a fixed width font that can be used for the given codepage.
//=============================================================================

function GetFWFontForLangID (IdtLanguage : Word): string;

//=============================================================================
// GetFWFontForCurrLanguage : returns the name of a fixed width font to use for
//   the current systems language (user language).
//                                     ---
// RESULT : string of a fixed width font that can be used for the given codepage.
//=============================================================================

function GetFWFontForCurrLanguage (): string;

//=============================================================================
// FloatToWrittenNumerals: converts a given float to written numeral text.
//                                     ---
// INPUT  : ValFloat      = float value to convert to written numerals
//          NumDigits     = number of digits to display in result
//          NumDecimals   = number of decimals to display in result
//          CharSep       = seperator to use inbetween numerals
//          TxtDecimalSep = text to use for decimal seperator
//          ArrNumerals   = array containing text to use for numerals,
//                          where array index = decimal digit for numeral value.
//                                     ---
// RESULT : string containing given float converted into written text, using
//          given formatting and seperator character inbetween the numerals.
//=============================================================================

function FloatToWrittenNumerals (ValFloat      : Double;
                                 NumDigits     : Integer;
                                 NumDecimals   : Integer;
                                 CharSep       : Char;
                                 TxtDecimalSep : string;
                                 ArrNumerals   : TArrNumeral): string;

//=============================================================================
// GetArrNumerals : 
//=============================================================================

function GetArrNumerals: TArrNumeral;

//*****************************************************************************

implementation


uses
  Windows,

  sysutils,
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'MFpnUtilsCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MFpnUtilsCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2007/04/10 12:35:44 $';

//*****************************************************************************
// Implementation of interfaced procedures and functions
//*****************************************************************************

//=============================================================================

function GetFWFontForLangID (IdtLanguage: Word): string;
begin  // of GetFWFontForLangID
  // Extract primary language ID from IdtLanguage value stored in the first
  // 10 bits of the Words value (see Windows unit for more info).
  IdtLanguage := IdtLanguage Mod 1024;
  case IdtLanguage of
    LANG_CHINESE : Result := 'SimHei';
    else
      Result := 'Courier New';
  end;
end;   // of GetFWFontForLangID

//=============================================================================

function GetFWFontForCurrLanguage (): string;
begin  // of GetFWFontForCurrLanguage
  Result := GetFWFontForLangId (GetUserDefaultLangID());
end;   // of GetFWFontForCurrLanguage

//=============================================================================

function FloatToWrittenNumerals (ValFloat      : Double;
                                 NumDigits     : Integer;
                                 NumDecimals   : Integer;
                                 CharSep       : Char;
                                 TxtDecimalSep : string;
                                 ArrNumerals   : TArrNumeral): string;
var
  TxtTmp     : string;
  CntIx      : Integer;
begin  // of FloatToWrittenNumerals
  TxtTmp := StringOfChar ('0', NumDigits) + '.' + StringOfChar ('0', NumDecimals);
  TxtTmp := FormatFloat(TxtTmp, ValFloat);
  // Put seperator inbetween string digits
  if TxtDecimalSep = '' then
    TxtTmp := StringReplace (TxtTmp, DecimalSeparator, '', []);
  for CntIx := 0 to Length (TxtTmp) do
    Result := Result + TxtTmp[CntIx+1] + CharSep;
  if TxtDecimalSep <> '' then
    Result := StringReplace (Result, DecimalSeparator, TxtDecimalSep, []);
  // Replace digits with numerals from array
  for CntIx := 0 to Length(ArrNumerals) do
    Result := StringReplace (Result, IntToStr(CntIx), ArrNumerals[CntIx],
                             [rfReplaceAll]);
end;   // of FloatToWrittenNumerals

//=============================================================================

function GetArrNumerals: TArrNumeral;
var
  ArrResult  : TArrNumeral;
begin  // of GetArrNumerals
  ArrResult [0] := CtTxtNumZero;
  ArrResult [1] := CtTxtNumOne;
  ArrResult [2] := CtTxtNumTwo;
  ArrResult [3] := CtTxtNumThree;
  ArrResult [4] := CtTxtNumFour;
  ArrResult [5] := CtTxtNumFive;
  ArrResult [6] := CtTxtNumSix;
  ArrResult [7] := CtTxtNumSeven;
  ArrResult [8] := CtTxtNumEight;
  ArrResult [9] := CtTxtNumNine;
  Result := ArrResult;
end;   // of GetArrNumerals

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of MFpnUtilsCA

