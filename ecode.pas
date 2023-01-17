unit eCode;

{$IFNDEF FPC AND $IFDEF MSWINDOWS}
  {$DEFINE DELPHI}
{$ENDIF}

{$IFDEF MSWINDOWS}
  {$DEFINE WINDOWS}
{$ENDIF}

{$IFDEF FPC}
  {$DEFINE LAZARUS}
{$ENDIF}

{ $IFDEF LINUX OR $IFDEF FREEBSD}
  { $DEFINE UNIX}
{ $ENDIF}

{$mode objfpc}{$H+}

{
Autor: Jacek Leszczyński (tao@bialan.pl)
Copyright (C) Jacek Leszczyński (tao@bialan.pl) & Elmark Marek Łotko

Specyfikacja:
  01 - Procedury i funkcje rozszerzaj±ce kod API.
  02 - Procedury i funkcje przeniesione prosto z języka Ansi C.
  03 - Wysokopoziomowy kod dostępu do plików przeniesiony prosto z języka Ansi C.
Uwagi:
  01: Co do stringów, wszystkie te funkcje używają typu string.
}

{Przykład użycia funkcji QSort:

function CompareF(const A, B: Pointer): Integer;
begin
  Result := PInteger(A)^ - PInteger(B)^;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
  t: array [1..100] of integer;
  i,a: integer;
  s: string;
  compar: TComparisonFunc;
begin
  i:=1;
  a:=0;
  while true do
  begin
    s:=GetLineToStr(Edit13.Text,i,',');
    if s='' then break;
    inc(a);
    t[a]:=StrToInt(s);
    inc(i);
  end;
  compar:=@CompareF;
  qsort(@t,a,sizeof(integer),compar);   // <<<< TUTAJ!
  s:='';
  for i:=1 to a do s:=s+','+IntToStr(t[i]);
  if s[1]=',' then delete(s,1,1);
  Edit15.Text:=s;
end;
}

interface

uses
  Classes, Types;

type
  TComparisonFunc = function(const A, B: Pointer): Integer;

var
  _FF: string[1];
  textseparator: char = '"';

function GetBitness:string; cdecl; external 'libecode.so' name 'GetBitness';
procedure GetLocaleDefault(var Lang, FallbackLang: string); cdecl; external 'libecode.so' name 'GetBitness';
function GetLocaleDefault(res_out: integer = 2):string;
{ ----------------------- KOD DUŻYCH LICZB ----------------------- }
function ArrNormalize(liczba:string):string; cdecl; external 'libecode.so' name 'ArrNormalize';
function ArrAbs(liczba:string):string; cdecl; external 'libecode.so' name 'ArrAbs';
function ArrKtoraLiczbaJestWieksza(a,b:string):byte; cdecl; external 'libecode.so' name 'ArrKtoraLiczbaJestWieksza';
function ArrSuma(a,b:string):string; cdecl; external 'libecode.so' name 'ArrSuma';
function ArrRoznica(a,b:string):string; cdecl; external 'libecode.so' name 'ArrRoznica';
function ArrIloczyn(liczba_a, liczba_b: string): string; cdecl; external 'libecode.so' name 'ArrIloczyn';
function IsLiczbaPierwsza(liczba:qword):boolean; cdecl; external 'libecode.so' name 'IsLiczbaPierwsza';
function IntToBin(liczba:integer):string; cdecl; external 'libecode.so' name 'IntToBin';
function IntToBin(liczba:qword):string; cdecl; external 'libecode.so' name 'QWordToBin';
function IntToSys(liczba,baza:integer):string; cdecl; external 'libecode.so' name 'IntToSys';
function IntToSys(liczba:qword;baza:integer):string; cdecl; external 'libecode.so' name 'QWordToSys';
function IntToSys(liczba:longword;baza:integer):string; cdecl; external 'libecode.so' name 'LongWordToSys';
function IntToSys3(liczba:integer):string; cdecl; external 'libecode.so' name 'IntToSys3';
function IntToSys3(liczba:qword):string; cdecl; external 'libecode.so' name 'QWordToSys3';
function IntToB256(liczba:longword; var buffer; size: integer):integer; cdecl; external 'libecode.so' name 'IntToB256';
function B256ToInt(const buffer; size: integer):integer; cdecl; external 'libecode.so' name 'B256ToInt';
{ ----------------------- KOD OPERACJI BITOWYCH ------------------ }
function BitIndexToNumber(aIndex: integer): integer; cdecl; external 'libecode.so' name 'BitIndexToNumber';
function GetBit(aLiczba,aBitIndex: integer): boolean; cdecl; external 'libecode.so' name 'GetBit';
procedure SetBit(var aLiczba: integer;aBitIndex: integer;aFlaga: boolean = true); cdecl; external 'libecode.so' name 'SetBit';
{ ----------------------- KOD CRYPTO ----------------------------- }
function CalcBuffer(aStrLen: longword; aBase: integer): longword; cdecl; external 'libecode.so' name 'CalcBuffer';
function CreateString(c:char;l:integer):string; cdecl; external 'libecode.so' name 'CreateString';
function EncryptString(s,token: string;force_length:integer=0): string; cdecl; external 'libecode.so' name 'EncryptString';
function DecryptString(s,token: string; trim_spaces: boolean = false): string; cdecl; external 'libecode.so' name 'DecryptString';
{ ----------------------- KOD CZASU ----------------------------- }
function SecToTime(aSec: longword): double; cdecl; external 'libecode_c.so' name 'fSecToTime';
function SecToInteger(aSec: longword): longword; cdecl; external 'libecode_c.so' name 'fSecToInteger';
function MiliSecToTime(aMiliSec: longword): double; cdecl; external 'libecode_c.so' name 'fMiliSecToTime';
function MiliSecToInteger(aMiliSec: longword): longword; cdecl; external 'libecode_c.so' name 'fMiliSecToInteger';
function TimeTruncate(Time: longword): longword; cdecl; external 'libecode_c.so' name 'fTimeTruncateInt';
function TimeTruncate(Time: TDateTime): TDateTime; cdecl; external 'libecode_c.so' name 'fTimeTruncateDT';
function TimeToInteger(Hour,Minutes,Second,Milisecond: word): longword; cdecl; external 'libecode_c.so' name 'fDecodeTimeToInteger';
function TimeToInteger(Time: TDateTime): longword; cdecl; external 'libecode_c.so' name 'fTimeToInteger';
function TimeToInteger: longword; cdecl; external 'libecode_c.so' name 'fNowTimeToInteger';
function IntegerToTime(czas: longword): TDateTime; cdecl; external 'libecode_c.so' name 'fIntegerToTime';
function IntegerToTimeNoMs(czas: longword): TDateTime; cdecl; external 'libecode_c.so' name 'fIntegerToTimeNoMs';
function IntegerToTime(czas: longword; no_milisecond: boolean): TDateTime;
{ ----------------------- KOD 01 ------------------------------- }
function StringTruncate(s: string; max: integer):string; cdecl; external 'libecode.so' name 'StringTruncate';
function GetFileSize(filename:string):int64; cdecl; external 'libecode.so' name 'GetFileSize';
function MD5(const S: String): String; cdecl; external 'libecode.so' name 'MD5';
function MD5File(const Filename: String): String; cdecl; external 'libecode.so' name 'MD5File';
function CrcString(const mystring: string) : longword; cdecl; external 'libecode.so' name 'CrcString';
function CrcStringToHex(const mystring: string) : string; cdecl; external 'libecode.so' name 'CrcStringToHex';
function CrcBlock(buf: Pbyte; len: cardinal) : longword; cdecl; external 'libecode.so' name 'CrcBlock';
function CrcBlockToHex(buf: Pbyte; len: cardinal) : string; cdecl; external 'libecode.so' name 'PByteCrcBlockToHex';
function CrcBlockToHex(buf: Pchar; len: cardinal) : string; cdecl; external 'libecode.so' name 'PCharCrcBlockToHex';
function CrcBlockToHex(const buf; len: cardinal) : string; cdecl; external 'libecode.so' name 'CrcBlockToHex';
function MyTempFileName(const APrefix: string): string; cdecl; external 'libecode.so' name 'MyTempFileName';
function TrimDepth(s:string;c:char=' '):string; cdecl; external 'libecode.so' name 'TrimDepth';
function kropka(str:string;b:boolean=false;usuwac_spacje:boolean=false):string; cdecl; external 'libecode.so' name 'kropka';
function StringToDate(str:string):TDateTime; cdecl; external 'libecode.so' name 'StringToDate';
procedure BinaryToStrings(var vTab:TStrings; Tab:array of byte); cdecl; external 'libecode.so' name 'BinaryToStrings';
function GetLineToStr(const S: string; N: Integer; const Delims: Char; const wynik: string = ''): string;
function GetLineCount(aStr: string; separator: char): integer;
function GetLineCount(aStr: string; separator,forcetextseparator: char): integer;
function GetKeyFromStr(s:string):string; cdecl; external 'libecode.so' name 'GetKeyFromStr';
function GetIntKeyFromStr(s:string):integer; cdecl; external 'libecode.so' name 'GetIntKeyFromStr';
procedure SetDir(Directory:string);
function MyDir(Filename: string = ''; AddingExeExtension: boolean = false): string;
function SetConfDir(Filename: string; Global: boolean = false; OnlyReadOnly: boolean = false): string;
function SetConfDir(Global: boolean = false; OnlyReadOnly: boolean = false): string;
function MyConfDir(Filename:string;Global:boolean=false):string;
function MyConfDir(Global:boolean=false):string;
function Latin2ToUtf8(s:string):string; cdecl; external 'libecode.so' name 'Latin2ToUtf8';
function EncodeEncjon(aValue: string): string; cdecl; external 'libecode.so' name 'EncodeEncjon';
function DecodeHTMLAmp(str:string):string; cdecl; external 'libecode.so' name 'DecodeHTMLAmp';
procedure TextTo2Text(s:string;max:integer;var s1,s2:string); cdecl; external 'libecode.so' name 'TextTo2Text';
procedure ExtractPFE(s:string; var s1,s2,s3:string); cdecl; external 'libecode.so' name 'ExtractPFE';
function OdczytajNazweKomputera:string; cdecl; external 'libecode.so' name 'OdczytajNazweKomputera';
function GetNameComputer:string; cdecl; external 'libecode.so' name 'GetNameComputer';
function GetSysUser:string; cdecl; external 'libecode.so' name 'GetSysUser';
function NrDniaToNazwaDnia(nr:integer):string; cdecl; external 'libecode.so' name 'NrDniaToNazwaDnia';
function GetGenerator(var gen:integer):integer; overload; cdecl; external 'libecode.so' name 'GetGeneratorInt';
function GetGenerator(var gen:cardinal):cardinal; overload; cdecl; external 'libecode.so' name 'GetGeneratorCardinal';
//function StringToItemIndex(slist:TStrings;kod:string;wart_domyslna:integer=-1):integer; cdecl; external 'libecode.so' name 'StringToItemIndex';
procedure StrToListItems(s:string;list:TStrings);
function StringToItemIndex(slist:TStrings;kod:string;wart_domyslna:integer=-1):integer;
function StringToItemIndexEx(slist: TStrings; kod: string; aIndeksOd: integer = 0; aIndeksDo: integer = -1; wart_domyslna: integer = -1): integer;
function ToBoolean(s:string):boolean; overload; cdecl; external 'libecode.so' name 'StrToBoolean';
function ToBoolean(c:char):boolean; overload; cdecl; external 'libecode.so' name 'CharToBoolean';
function ToBoolean(i:integer):boolean; overload; cdecl; external 'libecode.so' name 'IntToBoolean';
function IsCharWord(ch: char): boolean;
function IsCharHex(ch: char): boolean;
function IsPeselValid(pesel: string): boolean; cdecl; external 'libecode.so' name 'IsPeselValid';
function PeselToDate(Pesel:string):TDateTime; cdecl; external 'libecode.so' name 'PeselToDate';
function PeselToWiek(pesel:string):integer; cdecl; external 'libecode.so' name 'PeselToWiek';
function ObliczWiek(dt1,dt2:TDate):integer; cdecl; external 'libecode.so' name 'ObliczWiekEx';
function ObliczWiek(data_urodzenia:TDate):integer; cdecl; external 'libecode.so' name 'ObliczWiek';
function OnlyAlfaCharsAndNumeric(Key: char): char; cdecl; external 'libecode.so' name 'OnlyAlfaCharsAndNumeric';
function OnlyNumeric(Key: char): char; cdecl; external 'libecode.so' name 'OnlyNumeric';
function OnlyNumericAndSpace(Key: char): char; cdecl; external 'libecode.so' name 'OnlyNumericAndSpace';
function OnlyCharForImieNazwisko(Key: char): char; cdecl; external 'libecode.so' name 'OnlyCharForImieNazwisko';
function OnlyAlfaChars(Key: char): char; cdecl; external 'libecode.so' name 'OnlyAlfaChars';
function PrepareFindToLike(FindText:string;AcceptedLength:integer;CountPercent:integer=2):string; cdecl; external 'libecode.so' name 'PrepareFindToLike';
function NormalizeLogin(sLogin:string):string; cdecl; external 'libecode.so' name 'NormalizeLogin';
function NormalizeAdres(kod_pocztowy,miejscowosc,ulica,dom,lokal:string):string; cdecl; external 'libecode.so' name 'NormalizeAdres';
function NormalizeNaglowekAdresowy(fullname,kod_pocztowy,miejscowosc,ulica,dom,lokal:string):string; cdecl; external 'libecode.so' name 'NormalizeNaglowekAdresowy1';
function NormalizeNaglowekAdresowy(imie,nazwisko,kod_pocztowy,miejscowosc,ulica,dom,lokal:string):string; cdecl; external 'libecode.so' name 'NormalizeNaglowekAdresowy2';
function NormalizeNaglowekSpecjalizacji(imie,nazwisko,specjalizacja,nr_prawa_zawodu:string):string; cdecl; external 'libecode.so' name 'NormalizeNaglowekSpecjalizacji';
procedure StringToFile(s,filename:string); cdecl; external 'libecode.so' name 'StringToFile';
function DateTimeToDate(wartosc:TDateTime):TDate; cdecl; external 'libecode.so' name 'DateTimeToDate';
function StrToDateTime(aStr: string): TDateTime; cdecl; external 'libecode.so' name 'StrToDateTime';
function GetPasswordInConsole(InputMask: char = '*'): string; cdecl; external 'libecode.so' name 'GetPasswordInConsole';
function HexToDec(Str: string): Integer; cdecl; external 'libecode.so' name 'HexToDec';
function HexToStr(AHexText:string):string; cdecl; external 'libecode.so' name 'HexToStr';
function StrToHex(str:string):string; cdecl; external 'libecode.so' name 'StrToHex';
function NormalizeB(aFormat: string; aWielkoscBajtowa: int64): string; cdecl; external 'libecode.so' name 'NormalizeB';
function NormalizeFName(s:string):string; cdecl; external 'libecode.so' name 'NormalizeFName';
{ ----------------------- KOD 02 ------------------------------- }
function IsWhiteChar(c:char):boolean;
function IsSpace(c:char):boolean;
function IsDigit(c:char):boolean;
function StrToL(s1:string; var s2:string; baza:integer):longint;
function StrToD(s1:string; var s2:string):double;
function StrToDCurr(s1:string; var s2:string):double;
function AToI(s:string):integer;
function GToS(d:double;l:integer):string;
procedure QSort(base: pointer; num, size: NativeUInt; compare_func: TComparisonFunc); cdecl; external 'libecode_c.so' name 'fQSort';

{$IFDEF UNIX}
{$ELSE}
function ExitsWindows(Flags: Word): Boolean;
function MyDirWindows(Filename:string):string;
function MyDirSystem(Filename:string):string;
//procedure ScanNetRes(ResourceType, DisplayType: DWord; List: TStrings);
{$ENDIF}
function TestDll(Filename:string):boolean;

implementation

uses
{$IFDEF UNIX}
  SysUtils;
{$ELSE}
  Windows, SysUtils, StrUtils, lconvencoding, Winsock, DCPdes, DCPsha1, DCPmd5, Keyboard, gettext, crc;
{$ENDIF}

{$IFDEF UNIX}
{$ELSE}
type
  PNetResourceArray = ^TNetResourceArray;
  TNetResourceArray = array[0..100] of TNetResource;
{$ENDIF}

var
  GlobalDecimalPoint: char;
  ConfigLocalDirectory: string = '';
  ConfigGlobalDirectory: string = '';
  MyDirectory: string = '';

function fDecimalPoint: char; cdecl; external 'libecode.so' name 'fDecimalPoint';
function GET_FF: char; cdecl; external 'libecode.so' name '_FF';
function fGetLineToStr(aStr: Pchar; l: integer; separator,textseparator: char; wynik: pchar; var wartosc: pchar): integer; cdecl; external 'libecode_c' name 'fGetLineToStr';
function fGetLineCount(aStr: Pchar; separator,textseparator: char): integer; cdecl; external 'libecode_c' name 'fGetLineCount';
function fIsSpace(c: char): integer; cdecl; external 'libecode_c' name 'fIsSpace';
function fIsDigit(c: char): integer; cdecl; external 'libecode_c' name 'fIsDigit';
function fStrToL(aStr: Pchar; var reszta: Pchar; baza: integer): integer; cdecl; external 'libecode_c' name 'fStrToL';
function fStrToD(aStr: Pchar; var reszta: Pchar): double; cdecl; external 'libecode_c' name 'fStrToD';
function fAToI(aStr: pchar): integer; cdecl; external 'libecode_c' name 'fAToI';
function fGToS(d: double; l: integer; var wynik: pchar): integer; cdecl; external 'libecode_c' name 'fGToS';
//function fStringToItemIndex(var slist: pchar; kod: pchar; wart_domyslna: integer): integer; cdecl; external 'libecode_c' name 'fStringToItemIndex';

function GetLocaleDefault(res_out: integer): string;
var
  s1,s2: string;
begin
  GetLocaleDefault(s1,s2);
  if res_out=1 then result:=s1 else result:=s2;
end;

type
  TTBuffer256 = array [0..255] of char;
  PPBuffer256 = ^TTBuffer256;

var
  ppp: pchar;

function IntegerToTime(czas: longword; no_milisecond: boolean): TDateTime;
begin
  if no_milisecond then result:=IntegerToTimeNoMs(czas) else result:=IntegerToTime(czas);
end;

//Funkcja zwraca n-ty (l) ciąg stringu (s), o wskazanym separatorze.
//Ewentualnie zwraca wynik, jeśli string będzie pusty, gdy oczywiście się go wypełni!
//Funkcja korzysta z TextSeparator, który można ustawić, wszystkie separatory między
//kolejnymi takimi znakami, są pomijane!
function GetLineToStr(const S: string; N: Integer; const Delims: Char;
  const wynik: string): string;
var
  len: SizeInt;
begin
  len:=fGetLineToStr(pchar(S),N,Delims,textseparator,pchar(wynik),&ppp);
  SetString(result,ppp,len);
end;

function GetLineCount(aStr: string; separator: char): integer;
begin
  result:=fGetLineCount(pchar(aStr),separator,textseparator);
end;

function GetLineCount(aStr: string; separator, forcetextseparator: char
  ): integer;
begin
  result:=fGetLineCount(pchar(aStr),separator,forcetextseparator);
end;

procedure SetDir(Directory:string);
begin
  if Directory='' then MyDirectory:=MyDir else MyDirectory:=Directory;
  {$IFDEF WINDOWS}
  if MyDirectory[length(MyDirectory)]='\' then delete(MyDirectory,length(MyDirectory),1);
  {$ELSE}
  if MyDirectory[length(MyDirectory)]='/' then delete(MyDirectory,length(MyDirectory),1);
  {$ENDIF}
  if not DirectoryExists(MyDirectory) then mkdir(MyDirectory);
end;

//Funkcja zwraca aktualny katalog z którego uruchamiany jest program.
function MyDir(Filename: string; AddingExeExtension: boolean): string;
var
  s,s2: string;
  l: integer;
begin
  if MyDirectory='' then
  begin
    if pos('!',Filename)=1 then
    begin
      s:=ExtractFilePath(ParamStr(0));
      delete(s,1,1);
    end else s:=GetCurrentDir;
    l:=length(s);
    if s[l]=_FF then delete(s,l,1);
  end else s:=MyDirectory;
  {$IFDEF WINDOWS}
  if AddingExeExtension then s2:='.exe' else s2:='';
  if Filename<>'' then s:=StringReplace(s+'\'+Filename+s2,'/','\',[rfReplaceAll]);
  {$ELSE}
  if Filename<>'' then s:=StringReplace(s+'/'+Filename,'\','/',[rfReplaceAll]);
  {$ENDIF}
  result:=s;
end;

function SetConfDir(Filename: string; Global: boolean; OnlyReadOnly: boolean
  ): string;
var
  s: string;
  a: integer;
function cofnij_poziom(sciezka:string):string;
var
  s: string;
  i,a: integer;
begin
  s:=sciezka;
  (* pozbywam się ostatniego znaku '/' lub '\' *)
  a:=length(s);
  if s[a]=_FF then delete(s,a,1);
  (* pozbywam się wszystkiego do kolejnego znaku '/' lub '\' od końca lącznie z tym znakiem *)
  a:=length(s);
  for i:=a downto 1 do if s[i]=_FF then break;
  delete(s,i,1000);
  (* wyrzucam to co zostalo *)
  result:=s;
end;
begin
  s:=GetAppConfigDir(Global);
  if Filename='' then
  begin
    a:=length(s);
    if s[a]=_FF then delete(s,a,1);
  end else s:=cofnij_poziom(s)+_FF+Filename;
  if not OnlyReadOnly then
  begin
    if not DirectoryExists(s) then mkdir(s);
    if Global then ConfigGlobalDirectory:=s else ConfigLocalDirectory:=s;
  end;
  result:=s;
end;

function SetConfDir(Global: boolean; OnlyReadOnly: boolean): string;
begin
  result:=SetConfDir('',Global,OnlyReadOnly);
end;

function MyConfDir(Filename: string; Global: boolean): string;
var
  s: string;
begin
  if global then s:=ConfigGlobalDirectory else s:=ConfigLocalDirectory;
  if Filename<>'' then s:=s+_FF+Filename;
  result:=s;
end;

function MyConfDir(Global: boolean): string;
begin
  result:=MyConfDir('',Global);
end;

procedure StrToListItems(s: string; list: TStrings);
var
  i: integer;
  pom: string;
begin
  list.Clear;
  pom:='';
  for i:=1 to length(s) do
  begin
    if s[i]=#10 then
    begin
      list.Add(pom);
      pom:='';
      continue;
    end;
    if s[i]=#13 then continue;
    pom:=pom+s[i];
  end;
  if pom<>'' then list.Add(pom);
end;

function StringToItemIndex(slist: TStrings; kod: string; wart_domyslna: integer
  ): integer;
var
  i,a: integer;
begin
  a:=wart_domyslna;
  for i:=0 to slist.Count-1 do if slist[i]=kod then
  begin
    a:=i;
    break;
  end;
  result:=a;
end;

function StringToItemIndexEx(slist: TStrings; kod: string; aIndeksOd: integer;
  aIndeksDo: integer; wart_domyslna: integer): integer;
var
  i,a,max: integer;
begin
   a:=wart_domyslna;
   if aIndeksDo=-1 then max:=slist.Count-1 else max:=aIndeksDo;
   for i:=aIndeksOd to max do if slist[i]=kod then
   begin
     a:=i;
     break;
   end;
   result:=a;
end;

function IsCharWord(ch: char): boolean;
begin
  Result:= ch in ['a'..'z', 'A'..'Z', '_', '0'..'9'];
end;

function IsCharHex(ch: char): boolean;
begin
  Result:= ch in ['0'..'9', 'a'..'f', 'A'..'F'];
end;

function IsWhiteChar(c: char): boolean;
begin
  result:=fIsSpace(c)=1;
end;

function IsSpace(c: char): boolean;
begin
  result:=fIsSpace(c)=1;
end;

function IsDigit(c: char): boolean;
begin
  result:=fIsDigit(c)=1;
end;

function StrToL(s1: string; var s2: string; baza: integer): longint;
var
  pom: pchar = nil;
begin
  result:=fStrToL(pchar(s1),&pom,baza);
  s2:=StrPas(pom);
end;

function StrToD(s1: string; var s2: string): double;
var
  s: string;
  pom: pchar = nil;
begin
  if GlobalDecimalPoint='.' then s:=StringReplace(s1,',','.',[rfReplaceAll]) else s:=StringReplace(s1,'.',',',[rfReplaceAll]);
  result:=fStrToD(pchar(s),&pom);
  s2:=StrPas(pom);
end;

function StrToDCurr(s1: string; var s2: string): double;
var
  pom: pchar = nil;
begin
  result:=fStrToD(pchar(s1),&pom);
  s2:=StrPas(pom);
end;

function AToI(s: string): integer;
begin
  result:=fAToI(pchar(s));
end;

function GToS(d: double; l: integer): string;
var
  len: SizeInt;
begin
  len:=fGToS(d,l,&ppp);
  SetString(result,ppp,len);
end;

{$IFDEF UNIX}
{$ELSE}

//Funkcja coś
function ExitsWindows(Flags: Word): Boolean;
var
  iVersionInfo: TOSVersionInfo;
  iToken: THandle;
  iPriveleg: TTokenPrivileges;
  iaresult: DWord;
begin
  Result:=False;
  FillChar(iPriveleg,SizeOf(iPriveleg),#0);
  iVersionInfo.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  GetVersionEx(iVersionInfo);
  if iVersionInfo.dwPlatformId<>VER_PLATFORM_WIN32_NT then Result:=ExitWindowsEx(Flags,0)
  else if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,iToken) then
  if LookupPrivilegeValue(NIL,'SeShutdownPrivilege',iPriveleg.Privileges[0].Luid) then
  begin
    iPriveleg.PrivilegeCount:=1;
    iPriveleg.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
    if AdjustTokenPrivileges(iToken,False,iPriveleg,
    Sizeof(iPriveleg),iPriveleg,iaresult) then
    Result:=ExitWindowsEx(Flags,0);
  end;
end;

//Funkcja zwraca aktualny katalog instalacji "Windows"
function MyDirWindows(Filename:string):string;
var
  p: PChar;
  s: string;
begin
  GetMem(p,255);
  GetWindowsDirectory(p,254);
  s:=StrPas(p);
  FreeMem(p,255);
  if Filename<>'' then s:=s+'\'+Filename;
  result:=s;
end;

//Funkcja zwraca aktualny katalog systemowy "System"
function MyDirSystem(Filename:string):string;
var
  p: PChar;
  s: string;
begin
  GetMem(p,255);
  GetSystemDirectory(p,254);
  s:=StrPas(p);
  FreeMem(p,255);
  if Filename<>'' then s:=s+'\'+Filename;
  result:=s;
end;

//Funkcja i poniżej jej procedura to kod odpowiedzialny za
//wyciagnięcię wszelkich komputerów z otoczenia sieciowego.
function CreateNetResourceList(ResourceType: DWord;
                              NetResource: PNetResource;
                              out Entries: DWord;
                              out List: PNetResourceArray): Boolean;
var
  EnumHandle: THandle;
  BufSize: DWord;
  Res: DWord;
begin
  Result := False;
  List := Nil;
  Entries := 0;
  if WNetOpenEnum(RESOURCE_GLOBALNET,
                  ResourceType,
                  0,
                  NetResource,
                  EnumHandle) = NO_ERROR then begin
    try
      BufSize := $4000;  // 16 kByte
      GetMem(List, BufSize);
      try
        repeat
          Entries := DWord(-1);
          FillChar(List^, BufSize, 0);
          Res := WNetEnumResource(EnumHandle, Entries, List, BufSize);
          if Res = ERROR_MORE_DATA then
          begin
            ReAllocMem(List, BufSize);
          end;
        until Res <> ERROR_MORE_DATA;

        Result := Res = NO_ERROR;
        if not Result then
        begin
          FreeMem(List);
          List := Nil;
          Entries := 0;
        end;
      except
        FreeMem(List);
        raise;
      end;
    finally
      WNetCloseEnum(EnumHandle);
    end;
  end;
end;

{$ENDIF}

//Funkcja sprawdza czy dana biblioteka dll jest dostępna.
function TestDll(Filename:string):boolean;
begin
  {$IFDEF WINDOWS}
  result:= FileExists(MyDir(Filename)) or FileExists(MyDirWindows(Filename)) or FileExists(MyDirSystem(Filename));
  {$ELSE}
  result:=true;
  {$ENDIF}
end;

initialization
  ppp:=nil;
  GlobalDecimalPoint:=fDecimalPoint;
  _FF:=GET_FF;
finalization
  if ppp<>nil then StrDispose(ppp);
end.
