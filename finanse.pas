unit Finanse;

{  Autor: Jacek Leszczyński (tao@bialan.pl)
   Wszelkie Prawa Zastrzeżone (C) Jacek Leszczyński
   Zezwala się na używanie tego modułu przez firmę: Elmark Marek Łotko }

{$mode objfpc}

interface

uses
  Classes, SysUtils; 

function CurrencyToStr(r: double; ZM_ZLOTE: boolean = true):string;

implementation

var
  zl3,zl6: boolean;

function PodajSetki(c: string):string;
var
  s: string;
begin
  case c[1] of
    '0': s:='';
    '1': s:='sto';
    '2': s:='dwieście';
    '3': s:='trzysta';
    '4': s:='czterysta';
    '5': s:='pięćset';
    '6': s:='sześćset';
    '7': s:='siedemset';
    '8': s:='osiemset';
    '9': s:='dziewięćset';
  end;
  PodajSetki:=s;
end;

function PodajNaste(c: string):string;
var
  s: string;
begin
  case c[3] of
    '0': s:='dziesięć';
    '1': s:='jedenaście';
    '2': s:='dwanaście';
    '3': s:='trzynaście';
    '4': s:='czternaście';
    '5': s:='piętnaście';
    '6': s:='szesnaście';
    '7': s:='siedemnaście';
    '8': s:='osiemnaście';
    '9': s:='dziewiętnaście';
  end;
  PodajNaste:=s;
end;

function PodajDziesiatki(c: string):string;
var
  s: string;
begin
  case c[2] of
    '0': s:='';
    '1': s:=PodajNaste(c);
    '2': s:='dwadzieścia';
    '3': s:='trzydzieści';
    '4': s:='czterdzieści';
    '5': s:='pięćdziesiąt';
    '6': s:='sześćdziesiąt';
    '7': s:='siedemdziesiąt';
    '8': s:='osiemdziesiąt';
    '9': s:='dziewięćdziesiąt';
  end;
  PodajDziesiatki:=s;
end;

function PodajJednostki(c: string):string;
var
  s: string;
begin
  case c[3] of
    '0': s:='';
    '1': s:='jeden';
    '2': s:='dwa';
    '3': s:='trzy';
    '4': s:='cztery';
    '5': s:='pięć';
    '6': s:='sześć';
    '7': s:='siedem';
    '8': s:='osiem';
    '9': s:='dziewięć';
  end;
  PodajJednostki:=s;
end;

function PodajGrupe(pom: string;j: integer):string;
var
  s,s1: string;
  i: integer;
begin
  s:='';
  for i:=1 to 3 do
  begin
    if (i=3) and (pom[2]='1') then
    begin
      if j=3 then zl3:=true;
      if j=6 then zl6:=true;
      continue;
    end;
    case i of
      1: s1:=PodajSetki(pom);
      2: s1:=PodajDziesiatki(pom);
      3: s1:=PodajJednostki(pom);
    end;
    if s1<>'' then if s='' then s:=s1 else s:=s+' '+s1;
  end;
  PodajGrupe:=s;
end;

function CurrencyToStr(r: double; ZM_ZLOTE: boolean = true):string;
var
  s,s1,s2,ss: string;
  pom: string;
  a,b: integer;
  i,l: integer;
begin
  s:='';
  zl3:=false;
  zl6:=false;
  a:=trunc(r);
  s1:=IntToStr(a);
  s2:=FormatFloat('0.00',r);
  for i:=1 to length(s2) do if s2[i]=',' then break;
  delete(s2,1,i);
  if s2='' then s2:='0';
  b:=StrToInt(s2);
  if length(s2)=2 then s2:='0'+s2 else
  if length(s2)=1 then s2:='00'+s2;
  //Złote
  l:=length(s1);
  pom:='';
  for i:=1 to l do
  begin
    pom:=pom+s1[i];
    if ((l-i) mod 3)=0 then
    begin
      if length(pom)=2 then pom:='0'+pom else
      if length(pom)=1 then pom:='00'+pom;
      ss:=PodajGrupe(pom,l-i);
      if s='' then s:=ss else s:=s+' '+ss;
      case (l-i) of
        0: if ZM_ZLOTE then s:=s+' złotych';
        3: if zl3 then s:=s+' tysięcy' else case s1[i] of
             '0': if (l>4) and ((s1[l-4]<>'0') or (s1[l-5]<>'0')) then s:=s+' tysięcy';
             '1': if (l>4) and ((s1[l-4]<>'0') or (s1[l-5]<>'0')) then s:=s+' tysięcy' else s:=s+' tysiąc';
             '2'..'4': s:=s+' tysiące';
             '5'..'9': s:=s+' tysięcy';
           end;
        6: if zl6 then s:=s+' milionów' else case s1[i] of
             '0': if (l>7) and ((s1[l-7]<>'0') or (s1[l-8]<>'0')) then s:=s+' milionów';
             '1': if (l>7) and ((s1[l-7]<>'0') or (s1[l-8]<>'0')) then s:=s+' milionów' else s:=s+' milion';
             '2'..'4': s:=s+' miliony';
             '5'..'9': s:=s+' milionów';
           end;
      end;
      pom:='';
    end;
  end;
  //Grosze
  if b>0 then s:=s+' '+PodajGrupe(s2,0);
  if ZM_ZLOTE and (b>0) then s:=s+' groszy';
  //Wyniki
  CurrencyToStr:=s;
end;

end.

