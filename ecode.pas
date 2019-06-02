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

interface

uses
  Classes, Types;

type
  fchar = file;

var
  _eof: string[2];
  _FF: string[1];
  DefConv: string;
  DefConvOff: boolean;
  TextSeparator: char;

function GetBitness:string;
procedure GetLocaleDefault(var Lang, FallbackLang: string);
function GetLocaleDefault(res_out: integer = 2):string;
{ ----------------------- KOD TESTOWANIA CZASU WYKONANIA --------- }
procedure czas_start;
procedure czas_stop;
procedure czas_wynik(var hh,mm,ss,mili: word);
{ ----------------------- KOD DUŻYCH LICZB ----------------------- }
function ArrNormalize(liczba:string):string;
function ArrAbs(liczba:string):string;
function ArrKtoraLiczbaJestWieksza(a,b:string):byte;
function ArrSuma(a,b:string):string;
function ArrRoznica(a,b:string):string;
function ArrIloczyn(liczba_a, liczba_b: string): string;
function IsLiczbaPierwsza(liczba:qword):boolean;
function IntToBin(liczba:integer):string;
function IntToSys(liczba,baza:integer):string;
function IntToSys3(liczba:integer):string;
function IntToBin(liczba:qword):string;
function IntToSys(liczba:qword;baza:integer):string;
function IntToSys3(liczba:qword):string;
{ ----------------------- KOD CRYPTO ----------------------------- }
function CreateString(c:char;l:integer):string;
function EncryptString(s,token: string;force_length:integer=0): string;
function DecryptString(s,token: string; trim_spaces: boolean = false): string;
{ ----------------------- KOD CZASU ----------------------------- }
function SecToTime(aSec: longword): double;
function SecToInteger(aSec: longword): integer;
function MiliSecToTime(aMiliSec: longword): double;
function MiliSecToInteger(aMiliSec: longword): longword;
function TimeTruncate(Time: longword): longword;
function TimeTruncate(Time: TDateTime): TDateTime;
function TimeToInteger(Hour,Minutes,Second,Milisecond: word): longword;
function TimeToInteger(Time: TDateTime): longword;
function TimeToInteger: longword;
function IntegerToTime(czas: longword; no_milisecond: boolean = false): TDateTime;
{ ----------------------- KOD 01 ------------------------------- }
function StringTruncate(s: string; max: integer):string;
function GetFileSize(filename:string):int64;
function MD5(const S: String): String;
function MD5File(const Filename: String): String;
function MyTempFileName(const APrefix: string): string;
function TrimDepth(s:string;c:char=' '):string;
function kropka(str:string;b:boolean=false;usuwac_spacje:boolean=false):string;
function StringToDate(str:string):TDateTime;
procedure BinaryToStrings(var vTab:TStrings; Tab:array of byte);
function GetLineToStr(s:string;l:integer;separator:char;wynik:string=''):string;
function GetLineCount(s: string; separator:char):integer;
function GetKeyFromStr(s:string):string;
function GetIntKeyFromStr(s:string):integer;
procedure SetDir(Directory:string);
function MyDir(Filename:string='';AddingExeExtension:boolean=false):string;
procedure SetConfDir(Filename:string;Global:boolean=false);
procedure SetConfDir(Global:boolean=false);
function MyConfDir(Filename:string;Global:boolean=false):string;
function MyConfDir(Global:boolean=false):string;
function ConvIso(s: string): string;
function ConvOdczyt(s:string):string;
function ConvZapis(s:string):string;
function Latin2ToUtf8(s:string):string;
function DecodeHTMLAmp(str:string):string;
procedure TextTo2Text(s:string;max:integer;var s1,s2:string);
procedure ExtractPFE(s:string; var s1,s2,s3:string);
function OdczytajNazweKomputera:string;
function GetNameComputer:string;
function GetSysUser:string;
function NrDniaToNazwaDnia(nr:integer):string;
function GetGenerator(var gen:integer):integer; overload;
function GetGenerator(var gen:cardinal):cardinal; overload;
function StringToItemIndex(slist:TStrings;kod:string;wart_domyslna:integer=-1):integer;
function ToBoolean(s:string):boolean; overload;
function ToBoolean(c:char):boolean; overload;
function ToBoolean(i:integer):boolean; overload;
function IsPeselValid(pesel: string): boolean;
function PeselToDate(Pesel:string):TDateTime;
function PeselToWiek(pesel:string):integer;
function ObliczWiek(dt1,dt2:TDate):integer;
function ObliczWiek(data_urodzenia:TDate):integer;
function OnlyAlfaCharsAndNumeric(Key: char): char;
function OnlyNumeric(Key: char): char;
function OnlyNumericAndSpace(Key: char): char;
function OnlyCharForImieNazwisko(Key: char): char;
function OnlyAlfaChars(Key: char): char;
function PrepareFindToLike(FindText:string;AcceptedLength:integer;CountPercent:integer=2):string;
function NormalizeLogin(sLogin:string):string;
function NormalizeAdres(kod_pocztowy,miejscowosc,ulica,dom,lokal:string):string;
function NormalizeNaglowekAdresowy(fullname,kod_pocztowy,miejscowosc,ulica,dom,lokal:string):string;
function NormalizeNaglowekAdresowy(imie,nazwisko,kod_pocztowy,miejscowosc,ulica,dom,lokal:string):string;
function NormalizeNaglowekSpecjalizacji(imie,nazwisko,specjalizacja,nr_prawa_zawodu:string):string;
procedure StringToFile(s,filename:string);
function DateTimeToDate(wartosc:TDateTime):TDate;
function GetPasswordInConsole(InputMask: char = '*'): string;
function HexToDec(Str: string): Integer;
function HexToStr(AHexText:string):string;
function StrToHex(str:string):string;

{ -------------------- MEDICINE CODE --------------------------- }
function OMDateToTPDate(om_data: TDate; var tydzien,dzien_cyklu: integer; roznica_czasu: TDateTime = 0):TDate;
function OMDateToTPDate(om_data: TDate; roznica_czasu: TDateTime = 0):TDate;

{$IFDEF UNIX}
{$ELSE}
function ExitsWindows(Flags: Word): Boolean;
function MyDirWindows(Filename:string):string;
function MyDirSystem(Filename:string):string;
//procedure ScanNetRes(ResourceType, DisplayType: DWord; List: TStrings);
{$ENDIF}

function TestDll(Filename:string):boolean;
{ ----------------------- KOD 02 ------------------------------- }
function IsWhiteChar(c:char):boolean;
function IsDigit(c:char):boolean;
function StrToD(s1:string; var s2:string; znak_dziesietny: char = '.'):double;
function StrToDCurr(s1:string; var s2:string; znak_dziesietny: char = '.'):double;
function StrToL(s1:string; var s2:string; baza:integer):longint;
function AToI(s:string):integer;
function GToS(d:double;l:integer):string;
procedure QSort(adr:pointer;size_elementu:longint;adres:pointer;ile,ilosc_elementow:longint);
{ ----------------------- KOD 03 ------------------------------- }
procedure SetWinEof;
procedure SetLinEof;
procedure SetDefEof;
function NormalizeFName(s:string):string;
function FClose(var f:fchar):boolean;
function FOpen(var f:fchar;s:string;a:char):boolean;
function FGets(var cel:string; l:longint; var f:fchar):longint; //buforowanie - działa szybko.
function FGetLn(var cel:string; var f:fchar):longint; //nie zoptymalizowana - działa wolno!
function FPuts(s:string; var f:fchar):longint;
function FPutLn(s:string; var f:fchar):longint;
function FWrite(var f:fchar; s:string):longint;
function FWriteLn(var f:fchar; s:string):longint;
procedure Rewind(var f:fchar);

implementation

uses
{$IFDEF UNIX}
  Unix, SysUtils, StrUtils, lconvencoding, DCPdes, DCPsha1, DCPmd5, Keyboard, gettext;
{$ELSE}
  Windows, SysUtils, StrUtils, lconvencoding, Winsock, DCPdes, DCPsha1, DCPmd5, Keyboard, gettext;
{$ENDIF}

{$IFDEF UNIX}
{$ELSE}
type
  PNetResourceArray = ^TNetResourceArray;
  TNetResourceArray = array[0..100] of TNetResource;
{$ENDIF}

var
  ConfigLocalDirectory: string = '';
  ConfigGlobalDirectory: string = '';
  MyDirectory: string = '';

{ ----------------------- KOD TESTOWANIA CZASU WYKONANIA --------- }

var
  czas_begin,czas_end: TDateTime;

function GetBitness:string;
var
  s: string;
begin
  {$IFDEF CPU32 OR WIN32}
  s:='32';
  {$ELSE}
    {$IFDEF CPU64 OR WIN64}
    s:='64';
    {$ELSE}
    s:='0';
    {$ENDIF}
  {$ENDIF}
  result:=s;
end;

procedure GetLocaleDefault(var Lang, FallbackLang: string);
begin
  GetLanguageIDs(Lang,FallbackLang);
end;

function GetLocaleDefault(res_out: integer): string;
var
  s1,s2: string;
begin
  GetLanguageIDs(s1,s2);
  if res_out=1 then result:=s1 else result:=s2;
end;

procedure czas_start;
begin
  czas_begin:=now;
end;

procedure czas_stop;
begin
  czas_end:=now;
end;

procedure czas_wynik(var hh, mm, ss, mili: word);
begin
  decodetime(czas_end-czas_begin,hh,mm,ss,mili);
end;

{ ----------------------- KOD DUŻYCH LICZB ----------------------- }

function ArrNormalize(liczba:string):string;
var
  s: string;
  l,q: integer;
  ujemna: boolean;
begin
  s:=trim(liczba);
  ujemna:=s[1]='-';
  if ujemna then q:=2 else q:=1;
  while s<>'' do if (s[q]='0') then delete(s,q,1) else break;
  if s='' then s:='0';
  result:=s;
end;

function ArrAbs(liczba: string): string;
var
  s: string;
begin
  if s[1]='-' then delete(s,1,1);
  result:=s;
end;

function ArrKtoraLiczbaJestWieksza(a, b: string): byte; //result: 0: A=B, 1: A>B, 2: A<B
var
  i,j,q: integer;
  res: byte;
begin
  i:=length(a);
  j:=length(b);
  res:=0;
  if i>j then res:=1 else if i<j then res:=2 else
  begin
    for q:=1 to i do
    begin
      if a[q]=b[q] then continue;
      if a[q]>b[q] then
      begin
        res:=1;
        break;
      end;
      if a[q]<b[q] then
      begin
        res:=2;
        break;
      end;
    end;
  end;
  result:=res;
end;

function ArrSuma(a,b:string):string;
var
  s1,s2,s3: string;
  p,w,i,j,k,n: integer;
begin
  s1:=a;
  s2:=b;
  // obliczamy długości każdego z łańcuchów
  i:=length(s1);
  j:=length(s2);
  // w n wyznaczamy długość najkrótszego łańcucha
  n:=i; if j<i then n:=j;
  // zerujemy przeniesienie oraz łańcuch wynikowy
  p:=0;
  s3:='';
  // sumujemy kolejne od końca cyfry obu łańcuchów
  for k:=1 to n do
  begin
    w:=ord(s1[i])+ord(s2[j])+p-96;
    dec(i); dec(j);
    p:=w div 10;
    s3:=chr((w mod 10)+48)+s3;
  end;
  // jeśli łańcuch s1 ma jeszcze cyfry, to dodajemy do nich
  // przeniesienia i umieszczamy w łańcuchu wynikowym
  while i>0 do
  begin
    w:=ord(s1[i])+p-48;
    dec(i);
    p:=w div 10;
    s3:=chr((w mod 10)+48)+s3;
  end;
  // jeśli łańcuch s2 ma jeszcze cyfry, to dodajemy do nich
  // przeniesienia i umieszczamy w łańcuchu wynikowym
  while j>0 do
  begin
    w:=ord(s2[j])+p-48;
    dec(j);
    p:=w div 10;
    s3:=chr((w mod 10)+48)+s3;
  end;
  // jeśli pozostało przeniesienie, to dołączamy je do cyfr
  // w łańcuchu wynikowym
  if p>0 then s3:=chr(p+48)+s3;
  // jeśli w s3 nie ma cyfr, to wpisujemy tam 0
  if s3='' then s3:='0';
  // wyświetlamy wynik
  result:=s3;
end;

function ArrRoznica(a, b: string): string;
var
  s1,s2,s3: string;
  q,p,w,i,j,k,n: integer;
  minus: boolean;
begin
  (* test *)
  q:=ArrKtoraLiczbaJestWieksza(a,b);
  (* jeśli liczby są równe - ustawiam wynik i wychodzę *)
  if q=0 then
  begin
    result:='0';
    exit;
  end;
  (* przygotowanie *)
  if q=1 then
  begin
    s1:=a;
    s2:=b;
    minus:=false;
  end else begin
    s1:=b;
    s2:=a;
    minus:=true;
  end;
  (* procedura odejmowania *)
  // obliczamy długości każdego z łańcuchów
  i:=length(s1);
  j:=length(s2);
  // w n wyznaczamy długość najkrótszego łańcucha
  n:=j;
  // zerujemy przeniesienie oraz łańcuch wynikowy
  p:=0;
  s3:='';
  // odejmujemy kolejne od końca cyfry obu łańcuchów
  for k:=1 to n do
  begin
    if s2[j]='0' then w:=ord(s1[i])+p-48 else w:=ord(s1[i])-ord(s2[j])+p;
    if w<0 then
    begin
      w:=w+10;
      p:=-1;
    end else p:=0;
    dec(i); dec(j);
    s3:=chr(w+48)+s3;
  end;
  // jeśli łańcuch s1 ma jeszcze cyfry, to dodajemy do nich
  // przeniesienia i umieszczamy w łańcuchu wynikowym
  while i>0 do
  begin
    w:=ord(s1[i])+p-48;
    if w<0 then
    begin
      w:=w+10;
      p:=-1;
    end else p:=0;
    dec(i);
    s3:=chr(w+48)+s3;
  end;
  //usuwamy wszystkie "0" z poczatku liczby
  while s3<>'' do if (s3[1]='0') then delete(s3,1,1) else break;
  //jeśli to liczba ujemna dodajemy znak "-"
  if minus then s3:='-'+s3;
  // wyświetlamy wynik
  result:=s3;
end;

type
  TTab = array of integer;

function ile_przekatnych(a,b: integer): integer;
begin
  result:=a+b-1;
end;

function oblicz_sume(t: array of TTab; nr: integer; max1,max2: integer): integer;
var
  x,y,i,j: integer;
  sum: integer;
begin
  sum:=0;
  if nr<=max1 then
  begin
    x:=nr;
    y:=1;
  end else begin
    x:=max1;
    y:=nr-max1+1;
  end;
  for i:=x downto 1 do
  begin
    inc(sum,t[i-1,y-1]);
    inc(y);
    if y>max2 then break;
  end;
  result:=sum;
end;

function ArrIloczyn(liczba_a, liczba_b: string): string;
var
  i,j: integer;
  d1,d2: integer;
  s,s1,s2: string;
  tab: array of TTab;
  sumy: array of integer;
  count: integer;
  liczba,liczba1,liczba2: integer;
  reszta: integer;
begin
  s:='';
  s1:=ReverseString(liczba_a);
  s2:=ReverseString(liczba_b);
  s1:=liczba_a;
  s2:=liczba_b;
  d1:=length(s1);
  d2:=length(s2);

  SetLength(tab,d1);
  for i:=0 to d1-1 do SetLength(tab[i],d2);
  for i:=0 to d1-1 do for j:=0 to d2-1 do
  tab[i,j]:=StrToInt(s1[i+1])*StrToInt(s2[j+1]);

  count:=ile_przekatnych(d1,d2);
  SetLength(sumy,count);
  for i:=1 to count do sumy[i-1]:=oblicz_sume(tab,i,d1,d2);
  reszta:=0;
  for i:=count downto 1 do
  begin
    liczba:=sumy[i-1];
    liczba1:=(liczba+reszta) div 10;
    liczba2:=(liczba+reszta) mod 10;
    s:=s+IntToStr(liczba2);
    reszta:=liczba1;
  end;
  if reszta>0 then s:=s+IntToStr(liczba1);
  result:=ReverseString(s);
end;

function IsLiczbaPierwsza(liczba:qword):boolean;
var
  l,p,g,lp: qword;
  b: boolean;
begin
  l:=liczba;
  b:=false;
  while l>1 do
  begin
    if l=2 then b:=true else
    begin
      if l mod 2 = 0 then b:=false else
      begin
        g:=round(sqrt(l));
        p:=3;
        lp:=0;
        while (p<=g) and (lp=0) do
        begin
          if l mod p = 0 then lp:=1;
          p:=p+2;
        end;
        b:=lp=0;
      end;
    end;
    break;
  end;
  result:=b;
end;

function IntToBin(liczba:integer):string;
var
  wynik: string;
  n: integer;
begin
  wynik:='';
  n:=liczba;
  repeat
    if n mod 2 = 0 then wynik:='0'+wynik
                   else wynik:='1'+wynik;
    n:=n div 2;
  until n=0;
  result:=wynik;
end;

function IntToSys(liczba, baza: integer): string;
var
  wynik: string;
  n,pom: integer;
begin
  wynik:='';
  n:=liczba;
  repeat
    pom:=n mod baza;
    if pom<10 then wynik:=IntToStr(pom)+wynik else wynik:=chr(pom+55)+wynik;
    n:=n div baza;
  until n=0;
  result:=wynik;
end;

function IntToSys3(liczba: integer): string;
var
  wynik: string;
  n: integer;
begin
  wynik:='';
  n:=liczba;
  repeat
    if n mod 3 = 0 then wynik:='0'+wynik else
    if n mod 3 = 1 then wynik:='1'+wynik
                   else wynik:='2'+wynik;
    n:=n div 3;
  until n=0;
  result:=wynik;
end;

function IntToBin(liczba: qword): string;
var
  wynik: string;
  n: integer;
begin
  wynik:='';
  n:=liczba;
  repeat
    if n mod 2 = 0 then wynik:='0'+wynik
                   else wynik:='1'+wynik;
    n:=n div 2;
  until n=0;
  result:=wynik;
end;

function IntToSys(liczba: qword; baza: integer): string;
var
  wynik: string;
  n,pom: integer;
begin
  wynik:='';
  n:=liczba;
  repeat
    pom:=n mod baza;
    if pom<10 then wynik:=IntToStr(pom)+wynik else wynik:=chr(pom+55)+wynik;
    n:=n div baza;
  until n=0;
  result:=wynik;
end;

function IntToSys3(liczba: qword): string;
var
  wynik: string;
  n: integer;
begin
  wynik:='';
  n:=liczba;
  repeat
    if n mod 3 = 0 then wynik:='0'+wynik else
    if n mod 3 = 1 then wynik:='1'+wynik
                   else wynik:='2'+wynik;
    n:=n div 3;
  until n=0;
  result:=wynik;
end;

{ ----------------------- KOD CRYPTO ----------------------------- }

function CreateString(c:char;l:integer):string;
var
  s: string;
  i: integer;
begin
  s:='';
  for i:=1 to l do s:=s+c;
  result:=s;
end;

function EncryptString(s,token: string;force_length:integer=0): string;
var
  Des3: TDCP_3des;
  ss,pom: string;
  a: integer;
begin
  ss:=s;
  a:=length(ss);
  if (force_length>0) and (a<force_length) then ss:=ss+CreateString(' ',force_length-a);
  Des3:=TDCP_3des.Create(nil);
  try
    Des3.InitStr(token,TDCP_sha1);
    pom:=Des3.EncryptString(ss);
    Des3.Burn;
  finally
    Des3.Free;
  end;
  result:=pom;
end;

function DecryptString(s,token: string; trim_spaces: boolean = false): string;
var
  Des3: TDCP_3des;
  pom: string;
begin
  Des3:=TDCP_3des.Create(nil);
  try
    Des3.InitStr(token,TDCP_sha1);
    pom:=Des3.DecryptString(s);
    Des3.Burn;
  finally
    Des3.Free;
  end;
  if trim_spaces then result:=trim(pom) else result:=pom;
end;


{ ----------------------- KOD CZASU ----------------------------- }

function SecToTime(aSec: longword): double;
begin
  result:=aSec/SecsPerDay;
end;

function SecToInteger(aSec: longword): integer;
begin
  result:=TimeToInteger(aSec/SecsPerDay);
end;

function MiliSecToTime(aMiliSec: longword): double;
begin
  result:=aMiliSec/1000/SecsPerDay;
end;

function MiliSecToInteger(aMiliSec: longword): longword;
begin
  result:=TimeToInteger(aMiliSec/1000/SecsPerDay);
end;

function TimeTruncate(Time: longword): longword;
begin
  result:=TimeToInteger(IntegerToTime(Time,true));
end;

function TimeTruncate(Time: TDateTime): TDateTime;
begin
  result:=IntegerToTime(TimeToInteger(Time),true);
end;

function TimeToInteger(Hour, Minutes, Second, Milisecond: word): longword;
begin
  result:=(Hour*60*60*1000)+(Minutes*60*1000)+(Second*1000)+Milisecond;
end;

function TimeToInteger(Time: TDateTime): longword;
var
  godz,min,sec,milisec: word;
begin
  DecodeTime(Time,godz,min,sec,milisec);
  result:=(godz*60*60*1000)+(min*60*1000)+(sec*1000)+milisec;
end;

function TimeToInteger: longword;
begin
  result:=TimeToInteger(time);
end;

function IntegerToTime(czas: longword; no_milisecond: boolean): TDateTime;
var
  c: longword;
  godz,min,sec,milisec: word;
begin
  c:=czas;
  godz:=c div 3600000;
  c:=c-(godz*3600000);
  min:=c div 60000;
  c:=c-(min*60000);
  sec:=c div 1000;
  if no_milisecond then milisec:=0 else milisec:=c-(sec*1000);
  result:=EncodeTime(godz,min,sec,milisec);
end;

{ ----------------------- KOD 01 ------------------------------- }

function StringTruncate(s: string; max: integer):string;
begin
  if length(s)>max-3 then
  begin
    delete(s,max-3,1000);
    s:=s+'...';
  end;
  result:=s;
end;

function GetFileSize(filename:string):int64;
var
  f: TFileStream;
begin
  f:=TFileStream.Create(filename,fmOpenRead);
  try
    result:=f.Size;
  finally
    f.Free;
  end;
end;

function MD5(const S: String): String;
var
  i: Byte;
  digest: array[0..15] of Byte;
begin
  with TDCP_md5.Create(nil) do
  begin
    Init;
    UpdateStr(S);
    Final(digest);
    Free;
  end;
  Result := '';
  for i := 0 to Length(digest)-1 do
    Result := Result + IntToHex(digest[i], 2);
  Result := LowerCase(Result);
end;

function MD5File(const Filename: String): String;
var
  i: Byte;
  digest: array[0..15] of Byte;
  stream: TFileStream;
begin
  with TDCP_md5.Create(nil) do
  begin
    try
      stream:=TFileStream.Create(Filename,fmOpenRead);
      Init;
      UpdateStream(stream,stream.Size);
      Final(digest);
    finally
      stream.Free;
      Free;
    end;
  end;
  Result := '';
  for i := 0 to Length(digest)-1 do
    Result := Result + IntToHex(digest[i], 2);
  Result := LowerCase(Result);
end;

//Pobieram ścieżkę i nazwę pliku do uzycia tymczasowego
function MyTempFileName(const APrefix: string): string;
{$IFDEF WINDOWS}
var
  MyBuffer,MyFileName: array[0..MAX_PATH] of char;
{$ENDIF}
begin
  {$IFDEF UNIX}
  Result:=GetTempFileName('',APrefix);
  {$ELSE}
  FillChar(MyBuffer,MAX_PATH,0);
  FillChar(MyFileName,MAX_PATH,0);
  GetTempPath(SizeOf(MyBuffer),MyBuffer);
  GetTempFileName(MyBuffer,PChar(APrefix),0,MyFileName);
  Result:=MyFileName;
  {$ENDIF}
end;

//Wyrzucam wszystkie znaki 'c' z podanego stringu!
function TrimDepth(s: string; c: char): string;
var
  i: integer;
begin
  for i:=length(s) downto 1 do if s[i]=c then delete(s,i,1);
  result:=s;
end;

//zamiana przecinka na kropkę w treści licz rzczywistych
function kropka(str:string;b:boolean=false;usuwac_spacje:boolean=false):string;
var
  s: string;
  i: integer;
begin
  s:=str;
  case b of
    false: for i:=1 to length(s) do if s[i]=',' then s[i]:='.';
    true:  for i:=1 to length(s) do if s[i]='.' then s[i]:=',';
  end;
  if usuwac_spacje then for i:=length(s) downto 1 do if s[i]=' ' then delete(s,i,1);
  result:=s;
end;

//Zamiana stringu na datę w stałym formacie YYYY-MM-DD
function StringToDate(str:string):TDateTime;
var
  data: TDateTime;
  rok,mm,dd:string;
  f,s,s2: string;
  i: integer;
  q1,q2,q3: integer;
  qq: string;
begin
  rok:=GetLineToStr(str,1,'-');
  mm:=GetLineToStr(str,2,'-');
  dd:=GetLineToStr(str,3,'-');
  f:=ShortDateFormat;
  q1:=0;
  q2:=0;
  q3:=0;
  qq:='';
  for i:=1 to length(f) do
  begin
    case upcase(f[i]) of
      'D': if q1=0 then q1:=i;
      'M': if q2=0 then q2:=i;
      'Y': if q3=0 then q3:=i;
      else if qq='' then qq:=f[i];
    end;
  end;
  s:=''; s2:='';
  for i:=1 to length(f) do
  begin
    if i=q1 then begin s:=s+dd+qq; s2:=s2+dd+'-'; end;
    if i=q2 then begin s:=s+mm+qq; s2:=s2+mm+'-'; end;
    if i=q3 then begin s:=s+rok+qq; s2:=s2+rok+'-'; end;
  end;
  delete(s,length(s),1);
  delete(s2,length(s2),1);
  try
    data:=StrToDate(s);
  except
    data:=StrToDate(s2);
  end;
  result:=data;
end;

//Funkcja kopiujaca tablice binarną do tablicy stringów.
procedure BinaryToStrings(var vTab:TStrings; Tab:array of byte);
var
  i: integer;
  s: string;
begin
  vTab.Clear;
  s:='';
  for i:=0 to SizeOf(tab) do
  begin
    if tab[i]=13 then
    begin
      vTab.Add(s);
      s:='';
    end else s:=s+chr(tab[i]);
  end;
end;

//Funkcja zwraca n-ty (l) ciąg stringu (s), o wskazanym separatorze.
//Ewentualnie zwraca wynik, jeśli string będzie pusty, gdy oczywiście się go wypełni!
//Funkcja korzysta z TextSeparator, który można ustawić, wszystkie separatory między
//kolejnymi takimi znakami, są pomijane!
function GetLineToStr(s:string;l:integer;separator:char;wynik:string=''):string;
var
  i,ll,dl: integer;
  b: boolean;
begin
  b:=false;
  dl:=length(s);
  ll:=1;
  s:=s+separator;
  for i:=1 to length(s) do
  begin
    if s[i]=textseparator then b:=not b;
    if (not b) and (s[i]=separator) then inc(ll);
    if ll=l then break;
  end;
  if ll=1 then dec(i);
  delete(s,1,i);
  b:=false;
  for i:=1 to length(s) do
  begin
    if s[i]=textseparator then b:=not b;
    if (not b) and (s[i]=separator) then break;
  end;
  delete(s,i,dl);
  if (s<>'') and (s[1]=textseparator) then
  begin
    delete(s,1,1);
    delete(s,length(s),1);
  end;
  if s='' then s:=wynik;
  result:=s;
end;

function GetLineCount(s: string; separator:char):integer;
var
  ll,i,ost: integer;
begin
  //liczę separatory by zdiagnozować maksymalną ilość sekcji
  ll:=1;
  for i:=1 to length(s) do if s[i]=separator then inc(ll);
  //szukam ostatniej nie białej zawartości sekcji
  ost:=0;
  for i:=ll downto 1 do if GetLineToStr(s,i,separator,textseparator)<>'' then
  begin
    ost:=i;
    break;
  end;
  //wyjście
  result:=ost;
end;

function GetKeyFromStr(s: string): string;
begin
  if s='' then result:='0' else result:=GetLineToStr(GetLineToStr(s,2,'['),1,']');
end;

function GetIntKeyFromStr(s: string): integer;
begin
  try
    if s='' then result:=0 else result:=StrToInt(GetLineToStr(GetLineToStr(s,2,'['),1,']'));
  except
    result:=0;
  end;
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
begin
  if MyDirectory='' then
  begin
    s:=ExtractFilePath(ParamStr(0));
    delete(s,length(s),1);
  end else s:=MyDirectory;
  {$IFDEF WINDOWS}
  if AddingExeExtension then s2:='.exe' else s2:='';
  if Filename<>'' then s:=StringReplace(s+'\'+Filename+s2,'/','\',[rfReplaceAll]);
  {$ELSE}
  if Filename<>'' then s:=StringReplace(s+'/'+Filename,'\','/',[rfReplaceAll]);
  {$ENDIF}
  result:=s;
end;

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

procedure SetConfDir(Filename: string; Global: boolean);
var
  s: string;
  a: integer;
begin
  s:=GetAppConfigDir(Global);
  if Filename='' then
  begin
    a:=length(s);
    if s[a]=_FF then delete(s,a,1);
  end else s:=cofnij_poziom(s)+_FF+Filename;
  if not DirectoryExists(s) then mkdir(s);
  if Global then ConfigGlobalDirectory:=s else ConfigLocalDirectory:=s;
end;

procedure SetConfDir(Global: boolean);
begin
  SetConfDir('',Global);
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

function ConvIso(s: string): string;
const
  tab: array [1..18] of char = (#202,#211,#165,#140,#163,#175,#143,#198,#209,
                                #234,#243,#156,#191,#159,#230,#241,#185,#179);
var
  a,i: integer;
  pom: string;
begin
  for i:=1 to 17 do
  begin
    a:=pos(tab[i],s);
    if a>0 then break;
  end;
  if a>0 then pom:=ConvertEncoding(s,'cp1250','utf8') else pom:=s;
  result:=pom;
end;

function ConvOdczyt(s: string): string;
var
  pom: string;
begin
  if DefConvOff then pom:=s else pom:=ConvertEncoding(s,DefConv,'utf8');
  result:=pom;
end;

function ConvZapis(s: string): string;
var
  pom: string;
begin
  if DefConvOff then pom:=s else pom:=ConvertEncoding(s,'utf8',DefConv);
  result:=pom;
end;

function Latin2ToUtf8(s: string): string;
var
  i: integer;
  pom: string;
begin
  pom:='';
  for i:=1 to length(s) do
  case s[i] of
  //wyjątki:
#140: pom:=pom+#197#154;
#143: pom:=pom+#197#185;
#156: pom:=pom+#197#155;
#159: pom:=pom+#197#186;
  //tablica podstawowa:
#160: pom:=pom+#194#160;
#161: pom:=pom+#196#132;
#162: pom:=pom+#203#152;
#163: pom:=pom+#197#129;
#164: pom:=pom+#194#164;
#165: pom:=pom+#196#132;
#166: pom:=pom+#197#154;
#167: pom:=pom+#194#167;
#168: pom:=pom+#194#168;
#169: pom:=pom+#197#160;
#170: pom:=pom+#197#158;
#171: pom:=pom+#197#164;
#172: pom:=pom+#197#185;
#173: pom:=pom+#194#173;
#174: pom:=pom+#197#189;
#175: pom:=pom+#197#187;
#176: pom:=pom+#194#176;
#177: pom:=pom+#196#133;
#178: pom:=pom+#203#155;
#179: pom:=pom+#197#130;
#180: pom:=pom+#194#180;
#181: pom:=pom+#196#190;
#182: pom:=pom+#197#155;
#183: pom:=pom+#203#135;
#184: pom:=pom+#194#184;
#185: pom:=pom+#196#133;
#186: pom:=pom+#197#159;
#187: pom:=pom+#197#165;
#188: pom:=pom+#197#186;
#189: pom:=pom+#203#157;
#190: pom:=pom+#197#190;
#191: pom:=pom+#197#188;
#192: pom:=pom+#197#148;
#193: pom:=pom+#195#129;
#194: pom:=pom+#195#130;
#195: pom:=pom+#196#130;
#196: pom:=pom+#195#132;
#197: pom:=pom+#196#185;
#198: pom:=pom+#196#134;
#199: pom:=pom+#195#135;
#200: pom:=pom+#196#140;
#201: pom:=pom+#195#137;
#202: pom:=pom+#196#152;
#203: pom:=pom+#195#139;
#204: pom:=pom+#196#154;
#205: pom:=pom+#195#141;
#206: pom:=pom+#195#142;
#207: pom:=pom+#196#142;
#208: pom:=pom+#196#144;
#209: pom:=pom+#197#131;
#210: pom:=pom+#197#135;
#211: pom:=pom+#195#147;
#212: pom:=pom+#195#148;
#213: pom:=pom+#197#144;
#214: pom:=pom+#195#150;
#215: pom:=pom+#195#151;
#216: pom:=pom+#197#152;
#217: pom:=pom+#197#174;
#218: pom:=pom+#195#154;
#219: pom:=pom+#197#176;
#220: pom:=pom+#195#156;
#221: pom:=pom+#195#157;
#222: pom:=pom+#197#162;
#223: pom:=pom+#195#159;
#224: pom:=pom+#197#149;
#225: pom:=pom+#195#161;
#226: pom:=pom+#195#162;
#227: pom:=pom+#196#131;
#228: pom:=pom+#195#164;
#229: pom:=pom+#196#186;
#230: pom:=pom+#196#135;
#231: pom:=pom+#195#167;
#232: pom:=pom+#196#141;
#233: pom:=pom+#195#169;
#234: pom:=pom+#196#153;
#235: pom:=pom+#195#171;
#236: pom:=pom+#196#155;
#237: pom:=pom+#195#173;
#238: pom:=pom+#195#174;
#239: pom:=pom+#196#143;
#240: pom:=pom+#196#145;
#241: pom:=pom+#197#132;
#242: pom:=pom+#197#136;
#243: pom:=pom+#195#179;
#244: pom:=pom+#195#180;
#245: pom:=pom+#197#145;
#246: pom:=pom+#195#182;
#247: pom:=pom+#195#183;
#248: pom:=pom+#197#153;
#249: pom:=pom+#197#175;
#250: pom:=pom+#195#186;
#251: pom:=pom+#197#177;
#252: pom:=pom+#195#188;
#253: pom:=pom+#195#189;
#254: pom:=pom+#197#163;
               else pom:=pom+s[i];
  end;
  result:=pom;
end;

function DecodeHTMLAmp(str: string): string;
var
  s: string;
begin
  s:=str;
  s:=StringReplace(s,'&amp;amp;','&',[rfReplaceAll]);
  s:=StringReplace(s,'&amp;','&',[rfReplaceAll]);
  s:=StringReplace(s,'&#260;','Ą',[rfReplaceAll]);
  s:=StringReplace(s,'&#261;','ą',[rfReplaceAll]);
  s:=StringReplace(s,'&#280;','Ę',[rfReplaceAll]);
  s:=StringReplace(s,'&#281;','ę',[rfReplaceAll]);
  s:=StringReplace(s,'&#211;','Ó',[rfReplaceAll]);
  s:=StringReplace(s,'&#243;','ó',[rfReplaceAll]);
  s:=StringReplace(s,'&#262;','Ć',[rfReplaceAll]);
  s:=StringReplace(s,'&#263;','ć',[rfReplaceAll]);
  s:=StringReplace(s,'&#321;','Ł',[rfReplaceAll]);
  s:=StringReplace(s,'&#322;','ł',[rfReplaceAll]);
  s:=StringReplace(s,'&#323;','Ń',[rfReplaceAll]);
  s:=StringReplace(s,'&#324;','ń',[rfReplaceAll]);
  s:=StringReplace(s,'&#346;','Ś',[rfReplaceAll]);
  s:=StringReplace(s,'&#347;','ś',[rfReplaceAll]);
  s:=StringReplace(s,'&#377;','Ź',[rfReplaceAll]);
  s:=StringReplace(s,'&#378;','ź',[rfReplaceAll]);
  s:=StringReplace(s,'&#379;','Ż',[rfReplaceAll]);
  s:=StringReplace(s,'&#380;','ż',[rfReplaceAll]);
  result:=s;
end;

procedure TextTo2Text(s: string; max: integer; var s1, s2: string);
var
  dl,i,znacznik: integer;
begin
  //inicjowanie zmiennych
  dl:=length(s);
  znacznik:=0;
  s1:=s;
  if dl>max then s2:=s else
  begin
    s2:='';
    exit;
  end;
  //znalezienie dogodnego cięcia
  for i:=max downto 1 do if s1[i]=' ' then
  begin
    znacznik:=i;
    break;
  end;
  if znacznik>0 then
  begin
    //pocięcie tekstu na dwa z uwzględnieniem spacji
    delete(s1,znacznik,1000);
    delete(s2,1,znacznik);
  end else begin
    delete(s1,max+1,1000);
    delete(s2,1,max);
  end;
end;

procedure ExtractPFE(s:string; var s1,s2,s3:string);
begin
  s1:=ExtractFilePath(s);
  s2:=ExtractFileName(s);
  s3:=ExtractFileExt(s);
  delete(s2,length(s2)-length(s3)+1,length(s3));
end;

{$IFDEF UNIX}
function OdczytajNazweKomputera: string;
begin
  Result:=GetHostName;
end;

function GetNameComputer: string;
begin
  Result:=GetHostName;
end;

function GetSysUser: string;
begin
  result:=GetEnvironmentVariable('USER');
end;

{$ELSE}

function OdczytajNazweKomputera: string;
var
  klient,comp: shortstring;
  s: shortstring;
  Buff: DWORD;
begin
  klient:=Sysutils.GetEnvironmentVariable('CLIENTNAME');
  //Buff := MAX_COMPUTERNAME_LENGTH + 1; //stała MAX_COMPUTERNAME_LENGTH ma wartość 15
  SetLength(comp, Buff);
  GetComputerName(@comp, Buff);
  if klient='' then s:=StrPas(@comp) else s:=klient;
  result:=s;
end;

function GetNameComputer: string;
var
  s: shortstring;
  Host : PHostEnt;
  CompName : array[0..128] of char; // Nazwa zalogowanego uzytkownika
  ACompName: PCHar;
begin
  //Pobieramy nazwę komputera i przypisujemy ja zmiennej "CompName"
  GetHostName(@CompName, 128);
  Host:=GetHostByName(@CompName); // Nazwa Uzytkownika
  ACompName:=Host^.h_name;
  s:=AcompName;
  result:=s;
end;

function GetSysUser: string;
var
  i: cardinal;
  s: string;
begin
  result:='';
  i:=255;
  SetLength(s,i);
  GetUserName(PChar(s),i);
  SetLength(s,i);
  result:=trim(s);
end;

{$ENDIF}

function NrDniaToNazwaDnia(nr:integer):string;
var
  s: string;
begin
  case nr of
    0: s:='Poniedziałek';
    1: s:='Wtorek';
    2: s:='Środa';
    3: s:='Czwartek';
    4: s:='Piątek';
    5: s:='Sobota';
    6: s:='Niedziela';
  end;
  result:=s;
end;

function GetGenerator(var gen:integer):integer;
begin
  inc(gen,1);
  result:=gen;
end;

function GetGenerator(var gen:cardinal):cardinal;
begin
  inc(gen,1);
  result:=gen;
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

function ToBoolean(s:string):boolean;
var
  b: boolean;
begin
  b:=false;
  if (uppercase(s)='TRUE') then b:=true;
  if (s[1]='1') or (s[1]='y') or (s[1]='Y') or (s[1]='t') or (s[1]='T') then b:=true;
  result:=b;
end;

function ToBoolean(c:char):boolean;
var
  b: boolean;
begin
  b:=false;
  if (c='1') or (c='y') or (c='Y') or (c='t') or (c='T') then b:=true;
  result:=b;
end;

function ToBoolean(i:integer):boolean;
var
  b: boolean;
begin
  if i=1 then b:=true else b:=false;
  result:=b;
end;

function IsPeselValid(pesel: string): boolean;
var
  suma,cyfra: integer;
begin
  case length(pesel) of
       0..10: result:=false;
       11:    begin
                suma:=0;
                suma:=suma+StrToInt(Copy(pesel,1,1))*1;
                suma:=suma+StrToInt(Copy(pesel,2,1))*3;
                suma:=suma+StrToInt(Copy(pesel,3,1))*7;
                suma:=suma+StrToInt(Copy(pesel,4,1))*9;
                suma:=suma+StrToInt(Copy(pesel,5,1))*1;
                suma:=suma+StrToInt(Copy(pesel,6,1))*3;
                suma:=suma+StrToInt(Copy(pesel,7,1))*7;
                suma:=suma+StrToInt(Copy(pesel,8,1))*9;
                suma:=suma+StrToInt(Copy(pesel,9,1))*1;
                suma:=suma+StrToInt(Copy(pesel,10,1))*3;
                cyfra:=0;
                cyfra:=10-StrToInt(copy(IntToStr(suma),length(IntToStr(suma)),1));
                if cyfra=10 then cyfra:=0;
                if Copy(pesel,11,1)=IntToStr(cyfra) then result:=true else result:=false;
              end;
  end;
end;

{ funkcja zwraca datę urodzenia osoby o podanym peselu (copy) }
function PeselToDate(Pesel:string):TDateTime;
var
  Y, M, D: Word;
begin
  //result:=null;
  if Length(pesel)>=6 then
  begin
    //if (Copy(pesel,10,1)='0') or (Copy(pesel,10,1)='1') or (Copy(pesel,10,1)='2') or (Copy(pesel,10,1)='3') or (Copy(pesel,10,1)='4') or (Copy(pesel,10,1)='5') or (Copy(pesel,10,1)='6') or (Copy(pesel,10,1)='7') or (Copy(pesel,10,1)='8') or (Copy(pesel,10,1)='9') then
    //begin
    Y := StrToInt(Copy(Pesel, 1, 2));
    M := StrToInt(Copy(Pesel, 3, 2));
    D := StrToInt(Copy(Pesel, 5, 2));
    case M of
      21..32: begin M := M - 20; Y := Y + 2000; end;
      41..52: begin M := M - 40; Y := Y + 2100; end;
      61..72: begin M := M - 60; Y := Y + 2200; end;
      81..92: begin M := M - 80; Y := Y + 1800; end;
    else
      Y := Y + 1900;
    end;
    Result := EncodeDate(Y, M, D);
    //end;
  end;
end;

{ funkcja zwraca ile lat ma osoba o podanym peselu }
function PeselToWiek(pesel:string):integer;
var
  wiek: integer;
  s: string;
begin
  try
    if trim(pesel)='' then wiek:=-1 else
    begin
      if StrToInt(copy(pesel,3,2))<=12 then s:='19' else s:='20';
      s:=s+copy(pesel,1,2);
    end;
    result:=StrToInt(FormatDateTime('yyyy',date)) - StrToInt(s);
    //result:=CurrentYaer-StrToInt(s);
  except
    result:=-1;
  end;
end;

function ObliczWiek(dt1,dt2: TDate): integer;
var
  y1,y2,m1,m2,d1,d2: word;
  wiek: integer;
  pom: TDate;
begin
  DecodeDate(dt1,y1,m1,d1);
  DecodeDate(dt2,y2,m2,d2);
  wiek:=y2-y1-1;
  (* dodatkowe obliczenie - begin *)
  pom:=EncodeDate(y1,m2,d2);
  if pom>=dt1 then inc(wiek);
  (* dodatkowe obliczenie - end *)
  if wiek<0 then wiek:=0;
  result:=wiek;
end;

function ObliczWiek(data_urodzenia: TDate): integer;
begin
  result:=ObliczWiek(data_urodzenia,date);
end;

function OnlyAlfaCharsAndNumeric(Key: char): char;
var
  c: char;
begin
  if ((UpperCase(Key)<'A') or (UpperCase(Key)>'Z')) and ((Key<'0') or (Key>'9')) and (Key<>#8) and (Key<>#22) and (Key<>#3) then
    c:=#9 else c:=Key;
  result:=c;
end;

function OnlyNumeric(Key: char): char;
var
  c: char;
begin
  if ((Key<'0') or (Key>'9')) and (Key<>#8) and (Key<>#22) and (Key<>#3) then
    c:=#9 else c:=Key;
  result:=c;
end;

function OnlyNumericAndSpace(Key: char): char;
var
  c: char;
begin
  if ((Key<'0') or (Key>'9')) and (Key<>' ') and (Key<>#8) and (Key<>#22) and (Key<>#3) then
    c:=#9 else c:=Key;
  result:=c;
end;

function OnlyCharForImieNazwisko(Key: char): char;
var
  c: char;
begin
  if (Key='''') or (Key='"') or (Key='<') or (Key='>') then
    c:=#9 else c:=Key;
  result:=c;
end;

function OnlyAlfaChars(Key: char): char;
var
  c: char;
begin
  if ((UpperCase(Key)<'A') or (UpperCase(Key)>'Z')) and (Key<>#8) and (Key<>#22) and (Key<>#3) then
    c:=#9 else c:=Key;
  result:=c;
end;

function PrepareFindToLike(FindText:string;AcceptedLength:integer;CountPercent:integer=2):string;
var
  s: string;
  pom,r: integer;
begin
  (* skrócenie nazw *)
  s:=FindText;
  (* jak za d³ugi tekst to ucinamy *)
  pom:=length(s);
  if pom>AcceptedLength then
  begin
    delete(s,AcceptedLength+1,1000);
    pom:=AcceptedLength;
  end;
  r:=AcceptedLength-pom;
  (* dodajemy ewentualne znaczki '%' *)
  case CountPercent of
    -1: if r>0 then s:='%'+s;
     1: if r>0 then s:=s+'%';
     2: if r>0 then
        begin
          if r=1 then s:='%'+s else s:='%'+s+'%';
        end;
  end;
  if s='' then s:='%';
  result:=s;
end;

function NormalizeLogin(sLogin:string):string;
var
  s: string;
begin
  s:=sLogin;
  if length(s)>0 then
  begin
    s:=lowercase(s);
    s[1]:=upcase(s[1]);
  end;
  result:=s;
end;

function NormalizeAdres(kod_pocztowy, miejscowosc, ulica, dom, lokal: string
  ): string;
var
  s,miasto,adres: string;
begin
  miasto:=trim(kod_pocztowy+' '+miejscowosc);
  adres:=trim(ulica+' '+dom);
  if lokal<>'' then adres:=trim(adres+' m. '+lokal);
  if (adres<>'') and (ulica='') then s:=miasto+' '+adres else s:=adres+#13#10+miasto;
  result:=s;
end;

function NormalizeNaglowekAdresowy(fullname, kod_pocztowy, miejscowosc, ulica,
  dom, lokal: string): string;
begin
  result:=fullname+#13#10+NormalizeAdres(kod_pocztowy,miejscowosc,ulica,dom,lokal);
end;

function NormalizeNaglowekAdresowy(imie, nazwisko, kod_pocztowy, miejscowosc,
  ulica, dom, lokal: string): string;
begin
  result:=NormalizeNaglowekAdresowy(imie+' '+nazwisko,kod_pocztowy,miejscowosc,ulica,dom,lokal);
end;

function NormalizeNaglowekSpecjalizacji(imie, nazwisko, specjalizacja,
  nr_prawa_zawodu: string): string;
begin
  result:=imie+' '+nazwisko+#13#10+specjalizacja+#13#10+nr_prawa_zawodu;
end;

procedure StringToFile(s, filename: string);
var
  ss: TStringList;
begin
  ss:=TStringList.Create;
  try
    ss.Add(s);
    ss.SaveToFile(filename);
  finally
    ss.Free;
  end;
end;

function DateTimeToDate(wartosc: TDateTime): TDate;
begin
  result:=StrToDate(FormatDateTime('yyyy-mm-dd',wartosc),'y/m/d','-');
end;

function GetPasswordInConsole(InputMask: char): string;
var
  s,pom: string;
  c: char;
  k: TKeyEvent;
  l,i: integer;
begin
  s:='';
  l:=0;
  InitKeyBoard;
  while true do
  begin
    k:=PollKeyEvent;
    if k<>0 then
    begin
      k:=GetKeyEvent;
      k:=TranslateKeyEvent(k);
      pom:=KeyEventToString(k);
      if (ord(pom[1])=13) or (ord(pom[1])=10) then break else
      if ord(pom[1])=8 then
      begin
        if l>0 then
        begin
          delete(s,length(s),1);
          write(pom); write(' '); write(pom);
          dec(l);
        end;
      end else begin
        s:=s+pom;
        write(InputMask);
        inc(l);
      end;
    end;
  end;
  DoneKeyBoard;
  writeln;
  result:=s;
end;

function HexToDec(Str: string): Integer;
var
  i, M: Integer;
begin
  Result:=0;
  M:=1;
  Str:=AnsiUpperCase(Str);
  for i:=Length(Str) downto 1 do
  begin
    case Str[i] of
      '1'..'9': Result:=Result+(Ord(Str[i])-Ord('0'))*M;
      'A'..'F': Result:=Result+(Ord(Str[i])-Ord('A')+10)*M;
    end;
    M:=M shl 4;
  end;
end;

function HexToStr(AHexText: string): string;
var
  i: integer;
  res: string;
begin
  res:='';
  i:=1;
  while i<length(AHexText) do
  begin
    res:=res+chr(HexToDec(copy(AHexText,i,2)));
    i:=i+2;
  end;
  result:=res;
end;

function StrToHex(str: string): string;
var
  i: integer;
  res: string;
begin
  res:='';
  for i:=1 to length(str) do res:=res+IntToHex(ord(str[i]),2);
  result:=res;
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

{procedure ScanNetRes(ResourceType, DisplayType: DWord; List: TStrings);
  procedure ScanLevel(NetResource: PNetResource);
  var
    Entries: DWord;
    NetResourceList: PNetResourceArray;
    i: Integer;
  begin
    if CreateNetResourceList(ResourceType, NetResource, Entries, NetResourceList) then try
      for i := 0 to Integer(Entries) - 1 do
      begin
        if (DisplayType = RESOURCEDISPLAYTYPE_GENERIC) or
          (NetResourceList[i].dwDisplayType = DisplayType) then begin
          List.AddObject(NetResourceList[i].lpRemoteName,
                        Pointer(NetResourceList[i].dwDisplayType));
        end;
        if (NetResourceList[i].dwUsage and RESOURCEUSAGE_CONTAINER) <> 0 then
          ScanLevel(@NetResourceList[i]);
      end;
    finally
      FreeMem(NetResourceList);
    end;
  end;
begin
  ScanLevel(Nil);
end;}

{$ENDIF}

function OMDateToTPDate(om_data: TDate; var tydzien,dzien_cyklu: integer; roznica_czasu: TDateTime = 0): TDate;
var
  b_null: boolean;
  d1,d2,tp: TDate;
  om_rok,om_miesiac,om_dzien,bezp: word;
  s: string;
begin
  bezp:=0;
  d1:=om_data;
  d2:=now+roznica_czasu;
  DecodeDate(d1,om_rok,om_miesiac,om_dzien);
  if om_dzien>28 then
  begin
    dec(om_dzien,5);
    bezp:=5;
  end;
  dec(om_miesiac,3);
  if om_miesiac<1 then
  begin
    inc(om_miesiac,12);
    dec(om_rok);
  end;
  inc(om_rok);
  tp:=EncodeDate(om_rok,om_miesiac,om_dzien);
  tp:=tp+7+bezp;
  tydzien:=trunc((d2-d1+5)/7);
  dzien_cyklu:=trunc(d2-d1);
  result:=tp;
end;

function OMDateToTPDate(om_data: TDate; roznica_czasu: TDateTime
  ): TDate;
var
  p1,p2: integer;
begin
  result:=OMDateToTPDate(om_data,p1,p2,roznica_czasu);
end;

//Funkcja sprawdza czy dana biblioteka dll jest dostępna.
function TestDll(Filename:string):boolean;
begin
  {$IFDEF WINDOWS}
  result:= FileExists(MyDir(Filename)) or FileExists(MyDirWindows(Filename)) or FileExists(MyDirSystem(Filename));
  {$ELSE}
  result:=true;
  {$ENDIF}
end;

{ -------------------------------------------------------------- }

{ ----------------------- KOD 02 ------------------------------- }
//Sprawdź, czy dany znak należy do takzwanych znaków białych
function IsWhiteChar(c:char):boolean;
begin
  case c of
    ' ',#9: result:=true;
    else result:=false;
  end;
end;

//Sprawdź, czy dany znak jest cyfrą
function IsDigit(c:char):boolean;
begin
  if (c>='0') and (c<='9') then result:=true else result:=false;
end;

//Konwersja stringu do liczby rzeczywistej
//1. Pierwsze znaki biale sa pomijane
//2. Liczba jest konwertowana
//3. Reszta jest wrzucana do s2
function StrToD(s1:string; var s2:string; znak_dziesietny: char = '.'):double;
var
  p,pom: string;
  i,ii,error: integer;
  d: double;
  zm_kropka,plus,minus: boolean;
  c: char;
  _TFS: TFormatSettings;
begin
  error:=0;
  _TFS.DecimalSeparator:=znak_dziesietny;
  p:=s1;
  pom:='';
  zm_kropka:=false;
  plus:=false;
  minus:=false;
  //wywalam wszystkie początkowe znaki białe
  while (length(p)>0) and IsWhiteChar(p[1]) do delete(p,1,1);
  //jeśli string jest pusty
  if p='' then
  begin
    pom:='';
    result:=0;
    exit;
  end;
  //szukam miejsca błędu
  for i:=1 to length(p) do
  begin
    if (p[i]='+') and (not plus) then
    begin
      plus:=true;
      continue;
    end;
    if (p[i]='-') and (not minus) then
    begin
      minus:=true;
      continue;
    end;
    if (p[i]=znak_dziesietny) and (not zm_kropka) then
    begin
      zm_kropka:=true;
      continue;
    end;
    if (not isdigit(p[i])) and (p[i]<>'e') and (p[i]<>'E') then
    begin
      error:=i;
      break;
    end;
  end;
  //przesuwam błąd
  if error<>0 then
  begin
    pom:=p;
    delete(p,error,1024);
    delete(pom,1,error-1);
  end;
  //błąd e
  if p='' then c:=' ' else c:=p[length(p)];
  if (c='e') or (c='E') then
  begin
    delete(p,length(p),1);
    pom:=c+pom;
  end;
  //próbuję zamienić liczbę
  if p<>'' then
  begin
    try
      d:=StrToFloat(p,_TFS);
    except
      ii:=pos(znak_dziesietny,p);
      delete(p,ii,1000);
      d:=StrToFloat(p,_TFS);
    end;
  end else d:=0;
  //oddaję wyniki
  s2:=pom;
  result:=d;
end;

function StrToDCurr(s1: string; var s2: string; znak_dziesietny: char): double;
var
  p,pom: string;
  i,ii,error: integer;
  d: double;
  zm_kropka,plus,minus: boolean;
  c: char;
  _TFS: TFormatSettings;
begin
  error:=0;
  _TFS.DecimalSeparator:=znak_dziesietny;
  p:=s1;
  pom:='';
  zm_kropka:=false;
  plus:=false;
  minus:=false;
  //wywalam wszystkie początkowe znaki białe
  while (length(p)>0) and IsWhiteChar(p[1]) do delete(p,1,1);
  //jeśli string jest pusty
  if p='' then
  begin
    pom:='';
    result:=0;
    exit;
  end;
  //szukam miejsca błędu
  for i:=1 to length(p) do
  begin
    if (p[i]='+') and (not plus) then
    begin
      plus:=true;
      continue;
    end;
    if (p[i]='-') and (not minus) then
    begin
      minus:=true;
      continue;
    end;
    if (p[i]=znak_dziesietny) and (not zm_kropka) then
    begin
      zm_kropka:=true;
      continue;
    end;
    if (not isdigit(p[i])) and (p[i]<>'e') and (p[i]<>'E') then
    begin
      error:=i;
      break;
    end;
  end;
  //przesuwam błąd
  if error<>0 then
  begin
    pom:=p;
    delete(p,error,1024);
    delete(pom,1,error-1);
  end;
  //błąd e
  if p='' then c:=' ' else c:=p[length(p)];
  if (c='e') or (c='E') then
  begin
    delete(p,length(p),1);
    pom:=c+pom;
  end;
  //próbuję zamienić liczbę
  if p<>'' then
  begin
    try
      d:=StrToCurr(p,_TFS);
    except
      ii:=pos(znak_dziesietny,p);
      delete(p,ii,1000);
      d:=StrToCurr(p,_TFS);
    end;
  end else d:=0;
  //oddaję wyniki
  s2:=pom;
  result:=d;
end;

//Konwersja stringu do liczby calkowitej
//1. Pierwsze znaki biale sa pomijane
//2. Liczba jest konwertowana
//3. Reszta jest wrzucana do s2
//gdzie: Baza jest polem informującym system liczbowy
//w tej chwili jest to pole ignorowane i zawsze przyjmowany jest
//system dziesiętny (wartosci 0 i 10)
function StrToL(s1:string; var s2:string; baza:integer):longint;
var
  p,pom: string;
  i,error: integer;
  d: longint;
  plus,minus: boolean;
begin
  error:=0;
  p:=s1;
  pom:='';
  plus:=false;
  minus:=false;
  //wywalam wszystkie początkowe znaki białe
  while (length(p)>0) and IsWhiteChar(p[1]) do delete(p,1,1);
  //jeśli string jest pusty
  if p='' then
  begin
    pom:='';
    result:=0;
    exit;
  end;
  //szukam miejsca błędu
  for i:=1 to length(p) do
  begin
    if (p[i]='+') and (not plus) then
    begin
      plus:=true;
      continue;
    end;
    if (p[i]='-') and (not minus) then
    begin
      minus:=true;
      continue;
    end;
    if not isdigit(p[i]) then
    begin
      error:=i;
      break;
    end;
  end;
  //przesuwam błąd
  if error<>0 then
  begin
    pom:=p;
    delete(p,error,1024);
    delete(pom,1,error-1);
  end;
  //próbuję zamienić liczbę
  if p<>'' then d:=StrToInt(p) else d:=0;
  //oddaję wyniki
  s2:=pom;
  result:=d;
end;

//Konwersja stringu do integer
//Funkcja kompatybilnosci z C++
function AToI(s:string):integer;
begin
  result:=StrToInt(s);
end;

//Konwersja liczby rzeczywistej do stringu
//Funkcja kompatybilnosci z C++
//dodatkowo funkcja zostala przystosowana do realiów języka Pascal
function GToS(d:double;l:integer):string;
var
  i: integer;
  s: string;
begin
  if l=0 then s:='0' else s:='0.';
  for i:=1 to l do s:=s+'#';
  result:=FormatFloat(s,d);
end;

//Bardzo wyjatkowa funkcja, w C jest to tak zwany automat do sortowania
//w pamieci, jest ona troszke bardziej rozbudowana niż funkcja poniżej.
//W oryginale uzytkownik sam buduje mechanizm sortowania, zas tu -
//Wszystko jest zautomatyzowane! Na razie wykorzystywane jest najprostsze
//sortowanie "bąbelkowe", ale z czasem to poprawię i zastosuję szybszy algorytm.
//Dziala to bardzo prosto. Podajemy w argumentach dane na temat bloku pamięci,
//oraz dane częsci bloku wg którego ma by wszystko sortowane.
//Wiecej informacji w helpie.
procedure QSort(adr:pointer;size_elementu:longint;adres:pointer;ile,ilosc_elementow:longint);
var
  ii,i,j,k,l: integer;
  p1,p2,p11,p22: ^byte;
  b: byte;
  q: integer;
begin
  for ii:=1 to ilosc_elementow {*ilosc_elementow} do for i:=0 to ilosc_elementow-2 do
  begin
    j:=i+1;
    p1:=adres;
    inc(p1,i*size_elementu);
    p2:=adres;
    inc(p2,j*size_elementu);
    for k:=ile-1 downto 0 do
    begin
      { przeprowadzam porównanie }
      p11:=p1; inc(p11,k);
      p22:=p2; inc(p22,k);
      q:=0;
      if p11^<p22^ then q:=1;
      if p11^>p22^ then q:=2;
      if q=0 then continue;
      if q=1 then break;
      { zamieniam strony }
      for l:=0 to size_elementu-1 do
      begin
        p11:=adr; inc(p11,i*size_elementu+l);
        p22:=adr; inc(p22,(i+1)*size_elementu+l);
        b:=p11^;
        p11^:=p22^;
        p22^:=b;
      end;
      break;
    end;
  end;
end;
{ -------------------------------------------------------------- }

{ ----------------------- KOD 03 ------------------------------- }

//Ponizsze funkcje to zachowanie kompatybilnosci języka C++,
//narazie bez komentarzy, póki nie zostanie ten model dokończony.

procedure SetWinEof;
begin
  _eof:='12';
  _eof[1]:=#13;
  _eof[2]:=#10;
  _FF:='\';
end;

procedure SetLinEof;
begin
  _eof:='1';
  _eof[1]:=#10;
  _FF:='/';
end;

procedure SetDefEof;
begin
  {$IFDEF UNIX}
  SetLinEof;
  {$ELSE}
  SetWinEof;
  {$ENDIF}
end;

function NormalizeFName(s:string):string;
var
  i: integer;
begin
  {$IFDEF UNIX}
  for i:=1 to length(s) do if s[i]='\' then s[i]:='/';
  {$ELSE}
  for i:=1 to length(s) do if s[i]='/' then s[i]:='\';
  {$ENDIF}
  result:=s;
end;

function FClose(var f:fchar):boolean;
begin
  try
    close(f);
    result:=true;
  except
    result:=false;
  end;
end;

function FOpen(var f:fchar;s:string;a:char):boolean;
var
  b: boolean;
begin
  b:=true;
  s:=NormalizeFName(s);
  if (s='') or ((a<>'w') and (not FileExists(s))) then
  begin
    result:=false;
    exit;
  end;
  assign(f,s);
  try
    case a of
      'r': reset(f,1);
      'w': rewrite(f,1);
      'a': begin
             reset(f,1);
             seek(f,filesize(f));
           end;
    end;
  except
    b:=false;
  end;
  result:=b;
end;

function FGets(var cel:string; l:longint; var f:fchar):longint;
var
  wsk: longint;
  r,i: longint;
  bufor: pointer;
  straznik: ^byte;
begin
  getmem(bufor,(l+1)*sizeof(char));
  wsk:=filepos(f);

  blockread(f,bufor^,l,r);
  straznik:=bufor;
  inc(straznik,r);
  straznik^:=0;

  cel:=string(pchar(bufor));
  i:=pos(_eof,cel);
  delete(cel,i,r+1);
  seek(f,wsk+length(cel)+1);

  freemem(bufor);
  result:=length(cel);
end;

function FGetLn(var cel:string; var f:fchar):longint;
var
  c: char;
begin
  cel:='';
  while not eof(f) do
  begin
    blockread(f,c,1);
    if c=#10 then break;
    cel:=cel+c;
  end;
  result:=length(cel);
end;

function FPuts(s:string; var f:fchar):longint;
begin
  blockwrite(f,s[1],length(s));
  result:=length(s);
end;

function FPutLn(s:string; var f:fchar):longint;
var
  ln: integer;
begin
  ln:=length(s);
  blockwrite(f,s[1],ln);
{$IFDEF UNIX}
  blockwrite(f,_eof[1],length(_eof));
{$ELSE}
  blockwrite(f,_eof,length(_eof));
{$ENDIF}
  result:=ln;
end;

function FWrite(var f:fchar; s:string):longint;
begin
  result:=fputs(s,f);
end;

function FWriteLn(var f:fchar; s:string):longint;
begin
  result:=fputln(s,f);
end;

procedure Rewind(var f:fchar);
begin
  seek(f,0);
end;
{ -------------------------------------------------------------- }

{

15.   Pokaz informacji o wersji aplikacji.

ponizszy objekt dostarcza (wyciąga) informacje z plików wykonywalnych i bibliotek

unit siverinfo;

interface
uses Windows, Classes, SysUtils;

type TVersionInfo = class(TObject)
private
FData: Pointer;   FSize: Cardinal;   FCompanyName: string;   FFileDescription: string;
FFileVersion: string;   FInternalName: string;   FLegalCopyright: string;
FLegalTrademarks: string;   FOriginalFilename: string;   FProductName: string;
FProductVersion: string;   FComments: string;
public
constructor Create(FileName: string);
destructor Destroy; override;
property CompanyName: string read FCompanyName;
property FileDescription: string read FFileDescription;
property FileVersion: string read FFileVersion;
property InternalName: string read FInternalName;
property LegalCopyright: string read FLegalCopyright;
property LegalTrademarks: string read FLegalTrademarks;
property OriginalFilename: string read FOriginalFilename;
property ProductName: string read FProductName;
property ProductVersion: string read FProductVersion;
property Comments: string read FComments;
end;

implementation { TVersionInfo }

constructor TVersionInfo.Create(FileName: string);
var sz, lpHandle, tbl: Cardinal; lpBuffer: Pointer; str: PChar;
strtbl: string; int: PInteger; hiW, loW: Word;
begin
inherited Create;
FSize := GetFileVersionInfoSize(PChar(FileName), lpHandle);
FData := AllocMem(FSize);
GetFileVersionInfo(PChar(FileName), lpHandle, FSize, FData);

VerQueryValue(FData, '\\VarFileInfo\Translation', lpBuffer, sz);
int := lpBuffer;   hiW := HiWord(int^);   loW := LoWord(int^);
tbl := (loW shl 16) or hiW;   strtbl := Format('%x', [tbl]);
if Length(strtbl) < 8 then  strtbl := '0' + strtbl;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\CompanyName'), lpBuffer, sz);
str := lpBuffer;   FCompanyName := str;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\FileDescription'), lpBuffer, sz);
str := lpBuffer;   FFileDescription := str;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\FileVersion'), lpBuffer, sz);
str := lpBuffer;   FFileVersion := str;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\InternalName'), lpBuffer, sz);
str := lpBuffer;   FInternalName := str;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\LegalCopyright'), lpBuffer, sz);
str := lpBuffer; FLegalCopyright := str;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\LegalTrademarks'), lpBuffer, sz);
str := lpBuffer;   FLegalTrademarks := str;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\OriginalFilename'), lpBuffer, sz);
str := lpBuffer;   FOriginalFilename := str;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\ProductName'), lpBuffer, sz);
str := lpBuffer;   FProductName := str;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\ProductVersion'), lpBuffer, sz);
str := lpBuffer;   FProductVersion := str;

VerQueryValue(FData, PChar('\\StringFileInfo\'+strtbl+'\Comments'), lpBuffer, sz);
str := lpBuffer;   FComments := str;
end;

destructor TVersionInfo.Destroy;
begin
FreeMem(FData);
inherited;
end;

end.


}

begin
  SetDefEof;
  DefConv:='cp1250';
  DefConvOff:=false;
  TextSeparator:='"';
end.
