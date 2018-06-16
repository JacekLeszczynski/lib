unit ExtC;

{$IFNDEF FPC AND $IFDEF MSWINDOWS}
  {$DEFINE DELPHI}
{$ENDIF}

{$IFDEF MSWINDOWS}
  {$DEFINE WINDOWS}
{$ENDIF}

{$IFDEF FPC}
  {$DEFINE LAZARUS}
{$ENDIF}

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
  DefConv: string;
  DefConvOff: boolean;
  TextSeparator: char;

{ ----------------------- KOD 01 ------------------------------- }
function MyTempFileName(const APrefix: string): string;
function TrimDepth(s:string;c:char=' '):string;
function kropka(str:string;b:boolean=false;usuwac_spacje:boolean=false):string;
function StringToDate(str:string):TDateTime;
procedure BinaryToStrings(var vTab:TStrings; Tab:array of byte);
function GetLineToStr(s:string;l:integer;separator:char;wynik:string=''):string;
function GetLineCount(s: string; separator:char):integer;
function GetKeyFromStr(s:string):string;
function GetIntKeyFromStr(s:string):integer;
function MyDir(Filename:string=''):string;
procedure SetConfDir(Filename:string='');
function MyConfDir(Filename:string=''):string;
function ConvIso(s: string): string;
function ConvOdczyt(s:string):string;
function ConvZapis(s:string):string;
function Latin2ToUtf8(s:string):string;
procedure TextTo2Text(s:string;max:integer;var s1,s2:string);
procedure ExtractPFE(s:string; var s1,s2,s3:string);
function OdczytajNazweKomputera:string;
function GetNameComputer:string;
function GetSysUser:string;

{$IFDEF UNIX}
{$ELSE}
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
  Unix, SysUtils, lconvencoding;
{$ELSE}
  Windows, SysUtils, lconvencoding, Winsock;
{$ENDIF}

{$IFDEF UNIX}
{$ELSE}
type
  PNetResourceArray = ^TNetResourceArray;
  TNetResourceArray = array[0..100] of TNetResource;
{$ENDIF}

var
  ConfigDirectory: string = '';

{ ----------------------- KOD 01 ------------------------------- }

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

//Funkcja zwraca aktualny katalog z którego uruchamiany jest program.
function MyDir(Filename:string):string;
var
  s: string;
begin
  s:=ExtractFilePath(ParamStr(0));
  if Filename='' then delete(s,length(s),1) else s:=s+Filename;
  result:=s;
end;

procedure SetConfDir(Filename:string='');
begin
  {$IFDEF WINDOWS}
  ConfigDirectory:=MyDir;
  {$ELSE}
  ConfigDirectory:=GetEnvironmentVariable('HOME')+'/.'+Filename;
  if not DirectoryExists(ConfigDirectory) then mkdir(ConfigDirectory);
  {$ENDIF}
end;

function MyConfDir(Filename:string):string;
var
  s: string;
begin
  s:=ConfigDirectory;
  if Filename<>'' then s:=s+'/'+Filename;
  result:=s;
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

{$IFDEF UNIX}
{$ELSE}

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
end;

procedure SetLinEof;
begin
  _eof:='1';
  _eof[1]:=#10;
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
