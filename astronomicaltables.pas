unit AstronomicalTables;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils;

type
  TPlanets = (plMerkury,plWenus,plZiemia,plMars,plJowisz,plSaturn,plUran,plNeptun,plPluton,plAtlantyda,plKsiezyc);

  { TVector3D_D }

  TpfRec=record      //yet another planet data record
    name:String;     // 'Jupiter'
    radius:Double;   // in km
    mass:Double;     // in tons ?
    rotPer:Double;   // rotation period in days
    revPer:Double;   // revolution period in days (aka "year" length )
    Obliq:Double;    // Obliquity in degrees (from http://solarviews.com/cap/misc/obliquity.htm)
  end;

  TVector3D_D=record    // 3d vector w/ Double components
    x,y,z:Double;
    class function Create(const ax,ay,az: Double): TVector3D_D; static;
    // basic vector arithmetic
    class operator Negative(const aVector: TVector3D_D): TVector3D_D;
    class operator Add(const aVector1, aVector2: TVector3D_D): TVector3D_D;
    class operator Subtract(const aVector1, aVector2: TVector3D_D): TVector3D_D;
    class operator Multiply(const aFactor: Double; const aVector: TVector3D_D): TVector3D_D;
    class operator Multiply(const aVector: TVector3D_D; const aFactor: Double): TVector3D_D;
    class operator Divide(const aVector: TVector3D_D; const aFactor: Double): TVector3D_D;
    // TODO: dot and vector products
    function Length: Double;
    function Normalize: TVector3D_D;
    function getLatLonRadius(var aLat,aLon,aRadius:Double):boolean;    // convert cartesian x,y,z ---> lat,lon,radius ( spherical coordinates )
  end;

const
  NUM_PLANETS=9;            // Use same planets as vsop2013.pas
  NUM_OBJS=NUM_PLANETS+2;   // Sun is included as planet # zero. Moon also included
  // Astronomical Unit is the mean distance between Sun and Earth
  AUtoM =149597870700;   // since 2012, according to https://en.wikipedia.org/wiki/Astronomical_unit
  AUtoKm=AUtoM/1000;     // 1 AU = 149.598.787 Km   (~ 150M km)
  // 1 AU in KM = 149,598,000 kilometers . From https://www.universetoday.com/41974/1-au-in-km/
  Day2Sec=24.0*3600;
  // convert m/s^2 --> AU/day^2
  M_S2toAU_day2=Day2Sec*Day2Sec/AUtoM;   // M_S2toAU_day2 ~ 0.049900175484

  UnivGravConst = 6.67408E-11;  //  6.67408E-11 N . m^2/Kg^2 Universal Gravitational Constant
  EarthRadius = 6378.1;

  PLANET_DATA: Array[0..NUM_OBJS-1] of TpfRec=(       // planet sizes
    (name: 'Sun'    ; radius:696340; mass:1.98847e+30; rotPer:0;    revPer:0      ; Obliq: 0.0),   // 0
    (name: 'Mercury'; radius:2439.7; mass:3.30100e+23; rotPer:58.6; revPer:87.97  ; Obliq: 0.1),   // 1
    (name: 'Venus'  ; radius:6051.8; mass:4.13800e+24; rotPer:243 ; revPer:224.7  ; Obliq: 177.4), // 2
    (name: 'Earth'  ; radius:6378.1; mass:5.97200e+24; rotPer:0.99; revPer:365.26 ; Obliq: 23.45), // 3
    (name: 'Mars'   ; radius:3396.2; mass:6.42730e+23; rotPer:1.03; revPer:686.67 ; Obliq: 25.19), // 4
    (name: 'Jupiter'; radius:71492 ; mass:1.89852e+27; rotPer:0.41; revPer:4331.86; Obliq: 3.12),  // 5
    (name: 'Saturn' ; radius:60268 ; mass:5.68460e+26; rotPer:0.45; revPer:10760.3; Obliq: 26.73), // 6
    (name: 'Uranus' ; radius:25559 ; mass:8.68190e+25; rotPer:0.72; revPer:30684  ; Obliq: 97.86), // 7
    (name: 'Neptune'; radius:24764 ; mass:1.02431e+26; rotPer:0.67; revPer:60189  ; Obliq: 29.56), // 8
    (name: 'Pluto'  ; radius:1195  ; mass:1.47100e+22; rotPer:6.39; revPer:90797  ; Obliq: 16.11), // 9
    (name: 'Moon'   ; radius:1737.1; mass:7.34600e+22; rotPer:28  ; revPer:28     ; Obliq: 0) );   // 10

procedure GetPlanet(aPlanet: TPlanets; var aIndex: integer; var aNazwa: string; var aSrednica,aPromien,aOkres: single; aKompromis: boolean = false); overload;
procedure GetPlanet(aIndex: integer; var aPlanet: TPlanets; var aNazwa: string; var aSrednica,aPromien,aOkres: single; aKompromis: boolean = false); overload;
function Vector3D_D(const X, Y, Z: Double): TVector3D_D;
(* Ascronomical Algorithms *)
procedure AngleTo0_360(var A:Double); // put angle in 0..360° range
function getAngleTo0_360(const A:Double):Double;  //same as above, but different..
// date utils
Function JD(Y,M,D,UT:Double):Double;  // encode Julian date
Function JDtoDatetime(const JD:Double):TDatetime;
Function DatetimeToJD(const D:TDatetime):Double;
Function TJ2000(K,M,I,UT:Double):Double; {Time in centuries since  J2000.0}
// T in centuries since j2000
Procedure NutationCorrection(const T,aRAi,aDecli:Double; {out:} var DAlfaNu,DDeltaNu:Double);
// Nutation correction ( aka: the Nutella correction :)
Procedure CorrNut(const T:Double; var Eps,DPhy,DEps:Double);
// zenital
Procedure geoPositionToCelestial(aDay,aMonth,aYear:word; const aGMTTime,aLat,aLon:double;{out:}var aRA,aDecl:double);
// returns celestial coordinates (RA,Decl) of Greenwitch apparent position
Procedure GreenwitchToCelestial(const aUT:TDatetime; {out:} var aRA,aDecl:double);
// degree trigs
Function Sing(const G:Double):Double;  { Sin() using degrees}
Function ASing(const S:Double):Double; {arc sin em Graus}
Function Cosg(const G:Double):Double;  { Cos() using degrees}
Function Tang(G:Double):Double;        { Tan() using degrees }
// float --> str
function floatToLatitudeStr(const a:Double):String;   // degrees -->  '23.26°N'
function floatToLongitudeStr(const a:Double):String;
Function floatToHHMMSS(R:Double):String; {Double --> 'HHHh MM' SS"} //nova fev06
Function floatToGMSD(R:Double):String;   //degrees Double --> 'GGGøMM'SS.DD"} mai08:Om:

implementation

uses
  math;

function R2HMS(R:Double;var HMS:Double):String;    {Double --> 'HHHh MM' SS"}
var h,m,s:Double; sh,sm,ss:String; Sx:Char; Sn:Integer;
begin
  if R<0 then begin Sx:='O'; Sn:=-1; r:=-r;  end //nov/05 Sx= '0' quando negativo ?
    else begin Sx:=' '; Sn:=1; end;
  {R=HH.DDDD}
  h := Trunc(R);  {HH}
  R := 60*(R-h);  {MM.DD}
  m := Trunc(R);  {MM}
  R := 60*(R-m);  {SSDD}
  s := Round(R);
  if (S>=60) then begin S:=s-60; m:=m+1; end;
  if (m>=60) then begin m:=m-60; h:=h+1; end;
  Str(h:2:0, sh);
  Str(m:2:0, sm);
  Str(s:2:0, ss);
  if sm[1]=' ' then sm[1]:='0';
  if ss[1]=' ' then ss[1]:='0';
  R2HMS:=sh+':'+sm+':'+ss+' '+Sx;
  HMS:=Sn*(h+m/100+s/10000);      {H retorna HH.MMSS}
end;

Function HourTo0_24(const H:Double):Double; //put H in 0- 24h range
begin
  Result := H;
  if (Result<0)        then Result := Result+24
  else if (Result>=24) then Result := Result-24;
end;

// H in hours UT
// GMST - Greenwitch Mean Sideral Time
// GAST - Greenwich Apparent Sidereal Time ( = GMST affected by nutation )
// returned times in hours
procedure SiderealTime(D,M,A,H:Double;{out:} var GMST,GAST:Double); {AA pag.83}
var T,E,Eps,DPhy,DEps:Double;
begin
  T    := TJ2000(A,M,D,0);
  GMST := 24110.54841+8640184.812866*T+0.093104*T*T-0.0000062*T*T*T; {em seg, 0 UT}
  GMST := GMST/3600.0+1.00273790935*H;   {em horas}
  CorrNut(T, Eps, DPhy, DEps);           {calc Corr por nutacao}
  E    := DPhy*Cosg(Eps)/3600.0/15.0;
  GAST := GMST+E;
  GAST := HourTo0_24(GAST);
  GMST := HourTo0_24(GMST);
end;

procedure GetPlanet(aPlanet: TPlanets; var aIndex: integer; var aNazwa: string;
  var aSrednica, aPromien, aOkres: single; aKompromis: boolean);
var
  pom: TPlanets;
begin
  case aPlanet of
    plMerkury   : aIndex:=1;
    plWenus     : aIndex:=2;
    plZiemia    : aIndex:=3;
    plMars      : aIndex:=4;
    plJowisz    : aIndex:=5;
    plSaturn    : aIndex:=6;
    plUran      : aIndex:=7;
    plNeptun    : aIndex:=8;
    plPluton    : aIndex:=9;
    plAtlantyda : aIndex:=10;
    plKsiezyc   : aIndex:=11;
  end;
  GetPlanet(aIndex,pom,aNazwa,aSrednica,aPromien,aOkres,aKompromis);
end;

procedure GetPlanet(aIndex: integer; var aPlanet: TPlanets; var aNazwa: string;
  var aSrednica, aPromien, aOkres: single; aKompromis: boolean);
begin
  case aIndex of
     1: aPlanet:=plMerkury;
     2: aPlanet:=plWenus;
     3: aPlanet:=plZiemia;
     4: aPlanet:=plMars;
     5: aPlanet:=plJowisz;
     6: aPlanet:=plSaturn;
     7: aPlanet:=plUran;
     8: aPlanet:=plNeptun;
     9: aPlanet:=plPluton;
    10: aPlanet:=plAtlantyda;
    11: aPlanet:=plKsiezyc;
  end;
  case aIndex of
     1 : aNazwa:='Merkury';
     2 : aNazwa:='Wenus';
     3 : aNazwa:='Ziemia';
     4 : aNazwa:='Mars';
     5 : aNazwa:='Jowisz';
     6 : aNazwa:='Saturn';
     7 : aNazwa:='Uran';
     8 : aNazwa:='Neptun';
     9 : aNazwa:='Pluton';
     10 : aNazwa:='Atlantyda';
     11 : aNazwa:='Księżyc';
  end;
  case aIndex of
     1 : aSrednica:= 0.39;
     2 : aSrednica:= 0.95;
     3 : aSrednica:= 1;
     4 : aSrednica:= 0.53;
     5 : aSrednica:=11.2;
     6 : aSrednica:=23;
     7 : aSrednica:=5;
     8 : aSrednica:= 3.81;
     9 : aSrednica:= 0.371584653;
    10 : aSrednica:=2.5;
    11 : aSrednica:=0.25;
  end;
  if aKompromis then
  begin
    case aIndex of
       1 : aPromien:=0.39;
       2 : aPromien:=0.72;
       3 : aPromien:=1;
       4 : aPromien:=1.52;
       5 : aPromien:=4;
       6 : aPromien:=5.5;
       7 : aPromien:=7;
       8 : aPromien:=8.5;
       9 : aPromien:=10;
      10 : aPromien:=2.5;
      11 : aPromien:=0.12;
    end;
  end else begin
    case aIndex of
       1 : aPromien:=0.39;
       2 : aPromien:=0.72;
       3 : aPromien:=1;
       4 : aPromien:=1.52;
       5 : aPromien:=5.20;
       6 : aPromien:=9.54;
       7 : aPromien:=19.22;
       8 : aPromien:=30.06;
       9 : aPromien:=39.482;
      10 : aPromien:=2.5;
      11 : aPromien:=0.12;
    end;
  end;
  case aIndex of
     1 : aOkres:=0.24;
     2 : aOkres:=0.62;
     3 : aOkres:=1;
     4 : aOkres:=1.88;
     5 : aOkres:=11.86;
     6 : aOkres:=29.46;
     7 : aOkres:=84.01;
     8 : aOkres:=164.8;
     9 : aOkres:=247.30;
    10 : aOkres:=3;
    11 : aOkres:=0.1;
  end;
end;

function Vector3D_D(const X, Y, Z: Double): TVector3D_D;
begin
  Result.x := X;
  Result.y := Y;
  Result.z := Z;
end;

procedure AngleTo0_360(var A: Double);
begin
  while (A<0)      do A:=A+360.0;
  while (A>=360.0) do A:=A-360.0;
end;

function getAngleTo0_360(const A: Double): Double;
var
  aA: Double;
begin
  aA := A;
  AngleTo0_360( aA );
  Result := aA;
end;

function JD(Y, M, D, UT: Double): Double;
var
  A,B: double;
begin
  if (M<=2) then
    begin
      Y:=Y-1;
      M:=M+12;
    end;
  A:=Int(Y/100);
  B:=2-A+Int(A/4); //Gregoriano
  //B:=0;          //Juliano
  Result := Int(365.25*(Y+4716))+Int(30.6001*(M+1))+D+B-1524.5+UT/24;
end;

function JDtoDatetime(const JD: Double): TDatetime;
var
  A,B,F,H: Double;
  alpha,C,E: integer;
  D,Z: longint;
  dd,mm,yy: word;
begin
  H := Frac(JD+0.5);    // JD zeroes at noon  ( go figure... )

  Z := trunc(JD + 0.5);
  F := (JD + 0.5) - Z;
  if (Z<2299161.0) then A:=Z
    else begin
      alpha := trunc( (Z-1867216.25)/36524.25 );
      A := Z+1+alpha-(alpha div 4);
    end;
  B := A + 1524;
  C := trunc( (B - 122.1) / 365.25);
  D := trunc( 365.25 * C);
  E := trunc((B - D) / 30.6001);
  dd := Trunc(B - D - int(30.6001 * E) + F);
  if (E<14) then mm:=E-1
    else mm :=E-13;
  if mm > 2 then yy := C - 4716
    else yy := C - 4715;

  Result := EncodeDate(yy,mm,dd)+ H;   // time
end;

function DatetimeToJD(const D: TDatetime): Double;
var
  YY,MM,DD: Word;
  H: Double;
begin
  DecodeDate( Trunc(D), {out:}YY,MM,DD);
  H := Frac(D)*24;
  Result := JD(YY,MM,DD,{UT:}H  );
end;

function TJ2000(K, M, I, UT: Double): Double;
begin
  result := (JD(K,M,I,UT)-2451545.0)/36525.0;
end;

procedure NutationCorrection(const T, aRAi, aDecli: Double; var DAlfaNu,
  DDeltaNu: Double);
var
  DPhy,DEps: Double;
  Eps: Double;
  TDi,SEps,CEps,SA,CA: Double;
begin
  CorrNut(T,Eps,DPhy,DEps);
  SEps := Sing(Eps);
  CEps := Cosg(Eps);
  SA := Sing(aRAi);   CA := Cosg(aRAi);   TDi := Tang(aDecli);  //memoise trigs
  DAlfaNu  := (CEps+SEps*SA*TDi)*DPhy-(CA*TDi)*DEps;            {formula 22.1 pag.139 Ast.Alg}
  DDeltaNu := (SEps*CA)*DPhy+SA*DEps;
end;

procedure CorrNut(const T: Double; var Eps, DPhy, DEps: Double);
var
  Omega: Double;
  L,Ll: Double;
  T2,T3: Double;
  Eps0: Double;
begin            {Nutacao e obliquidade da ecliptica Ast.Alg. pag. 132}
  T2 := T*T; T3 := T*T2;
  Omega := 125.04452-1934.136261*T;
  L     := 280.4665 + 36000.7698*T;
  Ll    := 218.3165 +481267.8813*T;
  {nas formulas da pag 132, DPhy e DEps em " de grau, Eps0 em graus}
  DPhy := -17.2*Sing(Omega)-1.32*sing(2*L)-0.23*Sing(2*Ll)+0.21*Sing(2*Omega);
  DEps :=   9.2*cosg(Omega)+0.57*cosg(2*L)+0.10*Cosg(2*Ll)-0.09*Cosg(2*Omega);
  Eps0 :=  23.4392911+(-46.8150*T-0.00059*T2+0.001813*T3)/3600;    {21.2}
  Eps  :=  Eps0+DEps/3600;
end;

procedure geoPositionToCelestial(aDay, aMonth, aYear: word; const aGMTTime,
  aLat, aLon: double; var aRA, aDecl: double);
var
  aGHA,aGMST,aGAST: Double;
begin
  SiderealTime(aDay,aMonth,aYear,aGMTTime,{out:} aGMST,aGAST);  //calc GAST (in hours)
  aDecl:= aLat;
  aGHA := aLon;
  aRA  := aGAST*15-aGHA;   //15 converte de horas para graus.
  AngleTo0_360(aRA);       // Ajusta o angulo colocando entre 0 e 360°
end;

procedure GreenwitchToCelestial(const aUT: TDatetime; var aRA, aDecl: double);
var
  aGHA,aGMST,aGAST,aHour: Double;
  YY,MM,DD: word;
  D: TDatetime;
begin
  D     := Trunc( aUT );
  DecodeDate( D, {out:} YY,MM,DD);
  aHour := Frac(aUT)*24;        // in hours

  SiderealTime(DD,MM,YY,aHour,{out:} aGMST,aGAST);  //calc GAST (in hours)
  aDecl:= 0;  //
  aGHA := 0;  // greenwitch GHA=0
  // use GW apparent time  ( applies nutation to GMST )
  aRA  := aGAST*15-aGHA;   // 15 converte de horas para graus. ()
  AngleTo0_360(aRA);       // Ajusta o angulo colocando entre 0 e 360°
end;

function Sing(const G: Double): Double;
begin
  result := Sin(G*Pi/180);
end;

function ASing(const S: Double): Double;
begin
  result := ArcSin(S)*180/Pi;
end;

function Cosg(const G: Double): Double;
begin
  result := Cos(G*Pi/180);
end;

function Tang(G: Double): Double;
var
  CG: Double;
begin
  CG:=Cosg(G);
  {if CG=0.0 then CG:=1E-20;}     {= Numero bem pequeno}
  result:=Sing(G)/CG;
end;

function floatToLatitudeStr(const a: Double): String;
var
  ang: Double;
  Sulfix: string;
begin
  if      (a>0) then Sulfix:='N'
  else if (a<0) then Sulfix:='S'
  else Sulfix:='';   // 0 --> '00.00'
  ang := Abs(a);
  Result := Trim( Format('%5.1f°',[ang]) )+Sulfix;
end;

function floatToLongitudeStr(const a: Double): String;
var
  ang: Double;
  Sulfix: string;
begin
  if      (a>0) then Sulfix:='E'
  else if (a<0) then Sulfix:='W'
  else Sulfix:='';   // 0 --> '00.00'
  ang := Abs(a);
  Result := Trim( Format('%6.1f°',[ang]) )+Sulfix;
end;

function floatToHHMMSS(R: Double): String;
var
  Dummy: Double;
  L: integer;
begin
  Result := R2HMS(R,Dummy);
  L := Length(Result);
  if (Result[L]='O') then //O no final de R2HMS() significa negativo
    begin
      Delete(Result,L,1);
      Result:='(-)'+Result;
    end;
end;

function floatToGMSD(R: Double): String;
var
  g,m,s: Double;
  sg,sm,ss: string;
  Sx: char;
  Sn: integer;
begin
  if (R<0) then begin Sx:='-'; r:=-r;  end
    else begin  Sx:=' '; end;
  {R=GG.DDDD}
  g := Trunc(R);  {GG}
  R := 60*(R-g);  {MM.DD}
  m := Trunc(R);  {MM}
  R := 60*(R-m);  {SSDD}
  s := R;
  if (s>=60) then begin s:=s-60; m:=m+1; end;
  if (m>=60) then begin m:=m-60; g:=g+1; end;
  Str(g:2:0,sg);
  Str(m:2:0,sm);
  if (sm[1]=' ') then sm[1]:='0';
  ss := Format('%5.2f',[s]);
  if (ss[1]=' ') then ss[1]:='0';
  Result := Trim( Sx+sg+'°'+sm+''''+ss+'"');
end;

{ TVector3D_D }

class function TVector3D_D.Create(const ax, ay, az: Double): TVector3D_D;
begin
  Result.x := ax;
  Result.y := ay;
  Result.z := az;
end;

class operator TVector3D_D.Negative(const aVector: TVector3D_D): TVector3D_D;
begin
  Result.x := -aVector.x;
  Result.y := -aVector.y;
  Result.z := -aVector.z;
end;

class operator TVector3D_D.Add(const aVector1, aVector2: TVector3D_D
  ): TVector3D_D;
begin
  Result.x := aVector1.x + aVector2.x;
  Result.y := aVector1.y + aVector2.y;
  Result.z := aVector1.z + aVector2.z;
end;

class operator TVector3D_D.Subtract(const aVector1, aVector2: TVector3D_D
  ): TVector3D_D;
begin
  Result.x := aVector1.x - aVector2.x;
  Result.y := aVector1.y - aVector2.y;
  Result.z := aVector1.z - aVector2.z;
end;

class operator TVector3D_D.Multiply(const aFactor: Double;
  const aVector: TVector3D_D): TVector3D_D;
begin
  Result := aVector * aFactor;
end;

class operator TVector3D_D.Multiply(const aVector: TVector3D_D;
  const aFactor: Double): TVector3D_D;
begin
  Result.x := aVector.x * aFactor;
  Result.y := aVector.y * aFactor;
  Result.z := aVector.z * aFactor;
end;

class operator TVector3D_D.Divide(const aVector: TVector3D_D;
  const aFactor: Double): TVector3D_D;
begin
  Result := aVector * ( 1 / aFactor );
end;

function TVector3D_D.Length: Double;
begin
  Result := Sqrt( x*x + y*y + z*z );
end;

function TVector3D_D.Normalize: TVector3D_D;
var
  aLen:Double;
begin
  aLen   := Self.Length;
  if (aLen<>0) then   Result := Self * (1/aLen)
     else Result := Self;         // zero vector
end;

function TVector3D_D.getLatLonRadius(var aLat, aLon, aRadius: Double): boolean;
const
  rad2deg=180/Pi;
begin
  aRadius := Length;        // in AU
  if aRadius<>0 then
    begin
      aLat   := ArcSin( z/aRadius )*rad2deg;    // isso memo ??
      aLon   := ArcTan2( y, x )*rad2deg;        // ou vice-versa ?
      Result := true;
    end
    else Result := false;   // zero radius --> no lat,lon
end;

end.

