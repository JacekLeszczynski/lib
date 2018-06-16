unit Files;

interface

const
  GL_INITOSTR: char = ',';

procedure GetFileName(name:string;var s,s11,s22:string);
function TruncateFileName(s:string):string;
function TruncateFileNameLinux(s:string):string;
function GetFileSize(n:string):longint;
function CopyFileStr(s1,s2:string;q:boolean):boolean;
function SpecjalCopyFile(a,b:string):string;
procedure CopyTree(a,b:string);
procedure DelTree(k:string);
procedure DelReadOnlyTree(k:string);
procedure SpecjalDelTree(k:string);
procedure SpecjalCreateDirectory(d:string);
function ConvertIniToStr(s:string;l:integer):string;
function ConvertToPak(s:string):string;
function GetFileCode(n:string):string;
function GetStringCode(s:string;l:byte):string;
function GetStringDeCode(s:string;l:byte):string;
function GetAlfaCode(s:string;l:byte):string;
function GetAlfaDeCode(s:string;l:byte):string;
procedure DeleteSection(plik,sekcja:string);
procedure DeleteLineSection(plik,sekcja,line:string);

implementation
uses
  Crt, SysUtils, WinProcs;

var
  tab: array [0..54] of char;
  maxtab :byte;

procedure GetFileName(name:string;var s,s11,s22:string);
var
  pom,s1: string;
  s2: string;
  i: byte;
begin
  s:=name;
  pom:=name;
  for i:=length(pom) downto 0 do
    if (pom[i]='\') or (pom[i]=':') then break;
  delete(pom,1,i);
  if i<>0 then delete(s,i+1,255) else s:='';
  s1:=pom;
  s2:=pom;
  i:=pos('.',s1);
  delete(s1,i,255);
  if i<>0 then delete(s2,1,i-1) else s2:='';
  s11:=s1;
  s22:=s2;
end;

function TruncateFileName(s:string):string;
var
  i: integer;
begin
  for i:=length(s) downto 1 do if s[i]='\' then break;
  delete(s,i,255);
  TruncateFileName:=s;
end;

function TruncateFileNameLinux(s:string):string;
var
  i: integer;
begin
  for i:=length(s) downto 1 do if s[i]='/' then break;
  delete(s,1,i);
  TruncateFileNameLinux:=s;
end;

function GetFileSize(n:string):longint;
var
  f: file;
begin
  FileMode:=0;
  AssignFile(f,n);
  Reset(f,1);
  GetFileSize:=FileSize(f);
  CloseFile(f);
  FileMode:=2;
end;

function CopyFileStr(s1,s2:string;q:boolean):boolean;
var
  a,b: PChar;
  c,d: integer;
  pom: boolean;
begin
  c:=length(s1);
  d:=length(s2);
  GetMem(a,c+1);
  GetMem(b,d+1);
  StrPCopy(a,s1);
  StrPCopy(b,s2);
  pom:=CopyFile(a,b,q);
  FreeMem(a,c+1);
  FreeMem(b,d+1);
  CopyFileStr:=pom;
end;

function SpecjalCopyFile(a,b:string):string;
var
  s,s1,s2,ss: string;
  czy: boolean;
  i: integer;
begin
  Randomize;
  GetFileName(b,s,s1,s2);
  {Ustawienie nowej nazwy}
  repeat
    i:=random(100000000);
    ss:=IntToStr(i);
    czy:=FileExists(ss);
  until not czy;
  SpecjalCopyFile:=ss;
  CopyFileStr(a,s+ss,false);
end;

procedure _CopyTree(a,b:string;flaga:boolean);
var
  s: TSearchRec;
//  error: integer;
  ile: integer;
begin
  {$i-}
  mkdir(b);
  {$i+}
//  error:=ioresult;
  while true do
  begin
    if flaga then
    begin
      ile:=findfirst(a+'\*.*',faAnyFile,s);
      flaga:=false;
    end else ile:=findnext(s);
    if ile<>0 then break;
    if (s.name='.') or (s.name='..') then continue;
    if (s.attr and faDirectory)=faDirectory then _CopyTree(a+'\'+s.name,b+'\'+s.name,true)
    else CopyFileStr(a+'\'+s.name,b+'\'+s.name,true);
  end;
end;

procedure CopyTree(a,b:string);
begin
  _CopyTree(a,b,true);
end;

procedure _deltree(k:string;flaga:boolean);
var
  s: TSearchRec;
//  error: integer;
  ile: integer;
begin
  while true do
  begin
    if flaga then
    begin
      ile:=findfirst(k+'\*.*',faAnyFile,s);
      flaga:=false;
    end else ile:=findnext(s);
    if ile<>0 then break;
    if (s.name='.') or (s.name='..') then continue;
    if (s.attr and faDirectory)=faDirectory then _deltree(k+'\'+s.name,true)
    else RemoveFile(k+'\'+s.name);
  end;
  {$i-}
  rmdir(k);
  {$i+}
//  error:=ioresult;
end;

procedure DelTree(k:string);
begin
  _deltree(k,true);
end;

function _ro(a:integer):integer;
begin
  case a of
    01: a:=128;
    03: a:=2;
    05: a:=4;
    07: a:=6;
    17: a:=16;
    19: a:=18;
    21: a:=20;
    23: a:=22;
    33: a:=32;
    35: a:=34;
    37: a:=36;
    39: a:=38;
    49: a:=48;
    51: a:=50;
    53: a:=52;
    55: a:=54;
  end;
  _ro:=a;
end;

procedure _DelReadOnlyTree(k:string;flaga:boolean);
var
  s: TSearchRec;
//  error: integer;
  ile: integer;
begin
  while true do
  begin
    if flaga then
    begin
      ile:=findfirst(k+'\*.*',faAnyFile,s);
      flaga:=false;
    end else ile:=findnext(s);
    if ile<>0 then break;
    if (s.name='.') or (s.name='..') then continue;
    if (s.attr and faDirectory)=faDirectory then _DelReadOnlyTree(k+'\'+s.name,true) else FileSetAttr(k+'\'+s.name,_ro(FileGetAttr(k+'\'+s.name)));
  end;
  FileSetAttr(k,_ro(FileGetAttr(k)));
end;

procedure DelReadOnlyTree(k:string);
begin
  _DelReadOnlyTree(k,true);
end;

procedure SpecjalDelTree(k:string);
var
  error: integer;
  s1,s2,s3: string;
begin
  {Skasowanie normalnego katalogu...}
  _deltree(k,true);
  {PrÛba kasowania katalogÛw pustych...}
  s1:=k;
  repeat
    GetFileName(s1,s1,s2,s3);
    delete(s1,length(s1),1);
    {$i-}
    RmDir(s1);
    {$i+}
    error:=ioresult;
  until error<>0;
end;

procedure SpecjalCreateDirectory(d:string);
var
  error: integer;
  s1,s2,s3: string;
begin
  {$i-}
  MkDir(d);
  {$i+}
  error:=ioresult;
  if error=3 then
  begin
    GetFileName(d,s1,s2,s3);
    delete(s1,length(s1),1);
    SpecjalCreateDirectory(s1);
    MkDir(d);
  end;
end;

function ConvertIniToStr(s:string;l:integer):string;
var
  i,ll,dl: integer;
begin
  dl:=length(s);
  ll:=1;
  s:=s+GL_INITOSTR;
  for i:=1 to length(s) do
  begin
    if s[i]=GL_INITOSTR then inc(ll);
    if ll=l then break;
  end;
  if ll=1 then dec(i);
  delete(s,1,i);
  for i:=1 to length(s) do
  begin
    if s[i]=GL_INITOSTR then break;
  end;
  delete(s,i,dl);
  ConvertIniToStr:=s;
end;

function ConvertToPak(s:string):string;
var
  s1,s2,s3: string;
begin
  GetFileName(s,s1,s2,s3);
  if length(s3)=0 then s3:=s3+'.';
  if length(s3)=4 then s3[4]:='_' else s3:=s3+'_';
  ConvertToPak:=s1+s2+s3;
end;

function GetFileCode(n:string):string;
var
  f: textfile;
  l,l1,l2,l3,ll: integer;
  s: string;
  i: byte;
begin
  l1:=0;
  l2:=0;
  l3:=0;
  l:=1;
  AssignFile(f,n);
  reset(f);
  while not eof(f) do
  begin
    readln(f,s);
    ll:=0;
    for i:=1 to length(s) do ll:=ll+ord(s[i])*i;
    l1:=l1+ll*l;
    if l1>999999999 then
    begin
      dec(l1,1000000000);
      inc(l2);
    end;
    if l2>999999999 then
    begin
      dec(l2,1000000000);
      inc(l3);
    end;
    inc(l);
  end;
  CloseFile(f);
  GetFileCode:=IntToStr(l3)+IntToStr(l2)+IntToStr(l1);
end;

function GetStringCode(s:string;l:byte):string;
var
  i,ll: byte;
begin
  if s='' then
  begin
    GetStringCode:='';
    exit;
  end;
  ll:=length(s);
  inc(s[1],l);
  for i:=2 to ll do s[i]:=chr(ord(s[i])+ord(s[i-1]));
  GetStringCode:=s;
end;

function GetStringDeCode(s:string;l:byte):string;
var
  i,ll: byte;
begin
  if s='' then
  begin
    GetStringDeCode:='';
    exit;
  end;
  ll:=length(s);
  for i:=ll downto 2 do s[i]:=chr(ord(s[i])-ord(s[i-1]));
  dec(s[1],l);
  GetStringDeCode:=s;
end;

procedure incc(var q: char; l: byte);
var
  l1: byte;
  i: integer;
  b: boolean;
begin
  //Zabezpieczam siÍ
  while l>maxtab do l:=l-maxtab-1;
  //ZnajdujÍ kod znaku w/g tabeli kodÛw
  b:=false;
  l1:=0;
  for i:=0 to maxtab do if q=tab[i] then
  begin
    l1:=i;
    b:=true;
    break;
  end;
  if not b then exit;
  //Zakodowanie wyniku
  inc(l1,l);
  while l1>maxtab do l1:=l1-maxtab-1;
  //ZnajdujÍ znak wynikowy w/g tabeli kodÛw
  q:=tab[l1];
end;

function GetAlfaCode(s:string;l:byte):string;
var
  i,ll,b: byte;
  c: char;
begin
  if s='' then
  begin
    GetAlfaCode:='';
    exit;
  end;
  ll:=length(s);
  incc(s[1],l);
  for i:=2 to ll do
  begin
    b:=ord(s[i-1])+l;
    c:=s[i];
    incc(c,b);
    s[i]:=c;
  end;
  GetAlfaCode:=s;
end;

procedure decc(var q: char; l: byte);
var
  l1: integer;
  i: integer;
  b: boolean;
begin
  //Zabezpieczam siÍ
  while l>maxtab do l:=l-maxtab-1;
  //ZnajdujÍ kod znaku w/g tabeli kodÛw
  b:=false;
  l1:=0;
  for i:=0 to maxtab do if q=tab[i] then
  begin
    l1:=i;
    b:=true;
    break;
  end;
  if not b then exit;
  //Zakodowanie wyniku
  dec(l1,l);
  while l1<0 do l1:=l1+maxtab+1;
  //ZnajdujÍ znak wynikowy w/g tabeli kodÛw
  q:=tab[l1];
end;

function GetAlfaDeCode(s:string;l:byte):string;
var
  i,ll,b: byte;
  c: char;
begin
  if s='' then
  begin
    GetAlfaDeCode:='';
    exit;
  end;
  ll:=length(s);
  for i:=ll downto 2 do
  begin
    b:=ord(s[i-1])+l;
    c:=s[i];
    decc(c,b);
    s[i]:=c;
  end;
  decc(s[1],l);
  GetAlfaDeCode:=s;
end;

procedure _iniini(s:string);
var
  f: file of char;
  a,b: char;
begin
  assign(f,s);
  reset(f);
  while true do
  begin
    seek(f,filesize(f)-4);
    read(f,a);
    read(f,b);
    if (a=#13) and (b=#10) then truncate(f) else break;
  end;
  close(f);
end;

procedure DeleteSection(plik,sekcja:string);
var
  f1,f2: text;
  s,temp: string;
  sek: boolean;
begin
  sek:=false;
  temp:=TempFileName;
  assign(f1,plik);
  assign(f2,temp);
  reset(f1);
  rewrite(f2);
  while not eof(f1) do
  begin
    readln(f1,s);
    if sek and (s<>'') and (s[1]='[') then sek:=false;
    if s='['+sekcja+']' then sek:=true;
    if not sek then writeln(f2,s);
  end;
  close(f1);
  close(f2);
  _iniini(temp);
  copyfilestr(temp,plik,false);
  removefile(temp);
end;

procedure DeleteLineSection(plik,sekcja,line:string);
var
  f1,f2: textfile;
  s,temp: string;
  sek: boolean;
  pom: byte;
begin
  sek:=false;
  temp:=TempFileName;
  assign(f1,plik);
  assign(f2,temp);
  reset(f1);
  rewrite(f2);
  while not eof(f1) do
  begin
    readln(f1,s);
    if sek and (s<>'') and (s[1]='[') then sek:=false;
    if s='['+sekcja+']' then sek:=true;
    if sek then
    begin
      pom:=pos(line+'=',s);
      if pom=1 then continue;
    end;
    writeln(f2,s);
  end;
  closefile(f1);
  closefile(f2);
  _iniini(temp);
  copyfilestr(temp,plik,false);
  removefile(temp);
end;

procedure Tabl_k;
var
  i: byte;
begin
  {Przygotowanie tablicy kodÛw 0..54}
  maxtab:=54;
  //00..25
  for i:=65 to 90 do tab[i-65]:=chr(i);
  //26..35
  for i:=48 to 57 do tab[i-22]:=chr(i);
  //36..44
  tab[36]:=' ';
  tab[37]:='”';
  tab[38]:='•';
  tab[39]:='å';
  tab[40]:='£';
  tab[41]:='Ø';
  tab[42]:='è';
  tab[43]:='∆';
  tab[44]:='—';
  //45..54
  tab[45]:=' ';
  tab[46]:='-';
  tab[47]:='/';
  tab[48]:='\';
  tab[49]:='.';
  tab[50]:=',';
  tab[51]:='@';
  tab[52]:='&';
  tab[53]:='(';
  tab[54]:=')';
end;
begin
  Tabl_k;
end.
