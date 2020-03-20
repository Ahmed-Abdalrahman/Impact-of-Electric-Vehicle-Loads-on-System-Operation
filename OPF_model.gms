***************************************************************************
$ontext
Program:            Penetration and impact of electric vehicle loads on system operation
Project No.:        20
Author:             Ahmed Abdalrahman
Course:             ECE 666 - Winter 2017
$offtext
***************************************************************************



*----------------------------------------------------------
* Notations Used
*----------------
*  A generator cost function is represented as a quadratic polynomial
*  as follows: A*P**2 + B*P + C
*  A:     Quadratic component of cost function, in dollars per MW**2-h
*  B:     Linear component of cost function, in dollars per MWh
*  C:     Constant component of cost function, in dollars per hour
*  PMax:  Generating unit maximum capacity in MW
*  PMin:  Generating unit minimum capacity in MW
*  QMax:  Generating unit maximum reactive power capacity in MVAr
*  QPMin: Generating unit minimum capacity in MW
*  Gen:   Denotes the set of generating units
*  Load:  Denotes the total load in the system in MW
*----------------------------------------------------------


Option solprint = ON;
Option sysout   = ON;
Option limrow   =  6;
Option limcol   =  6;
Option decimals =  8 ;

set   i     buses    /1*38/
     time    time    /1*24/ ;
alias (i,j) ;

Set Gen(i)  PV bus /1/
    Load(i) Load buses /2*38/
    Head1   Generator data headings / PMin, PMax, QMin, QMax, A, B, C, D, E, F/
    Head2   Line data table headings / Re, Xe /
    Head3   Demand data table headings / PDem, QDem /
    Head4   PEV load demand / PEV_load /  ;

Scalar Base base MVA  /100 /;
scalar phi            /3.141592654 /;

***********************************************************
TABLE PEV(time,Head4)  PEV load demand in kW
          PEV_load
1        180.2714171
2        164.0752415
3        174.6894134
4        178.0436121
5        168.0575999
6        177.6134497
7        561.6928463
8        722.5444764
9        547.412708
10        553.7573386
11        541.2709713
12        540.7345166
13        541.2590546
14        554.7181519
15        840.2057675
16        836.0122055
17        717.0938808
18        561.5942129
19        554.7013038
20        167.9225467
21        176.1525828
22        180.7396591
23        173.6582427
24        158.7714413
;

*------- Convert PEV data to per unit quantities ----------
Parameter PEVD(time);

PEVD(time) = PEV(time,"PEV_load")/(Base);
**********  Generator DATA SECTION ****************************************

TABLE Generat(i,Head1)  generator data
   PMin     PMax   QMin      QMax       A       B        C
*    MW       MW   MVAR      MVAR

1    50      1000   -100      150     0.007995 17.5035 319.65
;

*------- Convert generator data to per unit quantities ----------
Parameter PMx(i), PMn(i), QMx(i), QMn(i), Ac(i), Bc(i), Cc(i);

PMx(i) = Generat(i,"PMax")/Base;
PMn(i) = Generat(i,"PMin")/Base;
QMx(i) = Generat(i,"QMax")/Base;
QMn(i) = Generat(i,"QMin")/Base;
Ac(i)  = Generat(i,"A")*Base*Base;
Bc(i)  = Generat(i,"B")*Base;
Cc(i)  = Generat(i,"C");
*----------------------------------------------------------------
Table Demand(i,Head3)        Real and reactive power demand at bus i
             PDem    QDem
*            (pu)   (pu)
2            0.1     0.06
3            0.09    0.04
4            0.12    0.08
5            0.06    0.03
6            0.06    0.02
7            0.2      0.1
8            0.2      0.1
9            0.06    0.02
10           0.06    0.02
11           0.04    0.03
12           0.06    0.035
13           0.06    0.035
14           0.12    0.08
15           0.06    0.01
16           0.06    0.02
17           0.06    0.02
18           0.09    0.04
19           0.09    0.04
20           0.09    0.04
21           0.09    0.04
22           0.09    0.04
23           0.09    0.05
24           0.42    0.02
25           0.42    0.02
26           0.06    0.025
27           0.06    0.025
28           0.06    0.02
29           0.12    0.07
30           0.2     0.6
31           0.15    0.07
32           0.21    0.1
33           0.06    0.4
34           0       0
35           0       0
36           0       0
37           0       0
38           0       0
;

*--- Convert Demand data to per unit quantities ----
Parameter  PD(i), QD(i) ;
PD(i) = Demand(i,"PDem");
QD(i) = Demand(i,"QDem");
PD("5") = PD("5")+ PEVD("1");

*---------------------------------------------------------------------
display Pd, QD;
Table LineData(i,j,Head2)
            Re          Xe
*         (p.u.)       (p.u.)
1.2        0.000574   0.00293
2.3        0.00307    0.001564
3.4        0.002279   0.001161
4.5        0.002373   0.001209
5.6        0.0051     0.004402
6.7        0.001166   0.003853
7.8        0.00443    0.001464
8.9        0.006413   0.004608
9.10       0.006501   0.004608
10.11      0.001224   0.000405
11.12      0.002331   0.000771
12.13      0.009141   0.007192
13.14      0.003372   0.004439
14.15      0.00381    0.003275
15.16      0.004647   0.003394
16.17      0.008026   0.010716
17.18      0.004558   0.003574
2.19       0.001021   0.000974
19.20      0.009366   0.00844
20.21      0.00255    0.002979
21.22      0.004414   0.005836
3.23       0.002809   0.00192
23.24      0.005592   0.004415
24.25      0.005579   0.004366
6.26       0.001264   0.000644
26.27      0.00177    0.00901
27.28      0.006594   0.005814
28.29      0.005007   0.004362
29.30      0.00316    0.00161
30.31      0.006067   0.005996
31.32      0.001933   0.002253
32.33      0.002123   0.003301
8.34       0.012453   0.012453
9.35       0.012453   0.012453
12.36      0.012453   0.012453
18.37      0.003113   0.003113
25.38      0.003113   0.003113
;
********** DATA INPUT SECTION ENDS HERE ******************************

*---FORMATION OF THE Y-BUS MATRIX ------------------------------------
Parameter Z(i,j), GG(i,j), BB(i,j), YCL(i);
Parameter G(i,j), B(i,j), Y(i,j), ZI(i,j), Theta(i,j);

LineData(j,i,"Re")$(LineData(i,j,"Re") gt 0.00) = LineData(i,j,"Re");
LineData(j,i,"Xe")$(LineData(i,j,"Xe") gt 0.00) = LineData(i,j,"Xe");

Z(i,j) = (LineData(i,j,"Re"))**2 + (LineData(i,j,"Xe"))**2 ;
GG(i,j)$(Z(i,j) ne 0.00) = LineData(i,j,"Re")/z(i,j) ;

BB(i,j)$(Z(i,j) ne 0.00) = -LineData(i,j,"Xe")/Z(i,j);
BB(j,i)$(Z(i,j) ne 0.00) = -LineData(i,j,"Xe")/Z(i,j);


B(i,i) = sum(j, BB(i,j));
G(i,i) = sum(j, GG(i,j));
G(i,j)$(ord(i) ne ord(j)) = -GG(i,j);
B(i,j)$(ord(i) ne ord(j)) = -BB(i,j);

Y(i,j) = sqrt(G(i,j)*G(i,j) + B(i,j)*B(i,j));

ZI(i,j)$(G(i,j) ne 0.00)  = abs(B(i,j))/abs(G(i,j)) ;

Theta(i,j) = arctan(ZI(i,j));
Theta(i,j)$((B(i,j) eq 0) and (G(i,j) gt 0)) = 0.0 ;
Theta(i,j)$((B(i,j) eq 0) and (G(i,j) lt 0))   = -0.5*phi ;
Theta(i,j)$((B(i,j) gt 0) and (G(i,j) gt 0))   = Theta(i,j) ;
Theta(i,j)$((B(i,j) lt 0) and (G(i,j) gt 0))   = 2*phi - Theta(i,j) ;
Theta(i,j)$((B(i,j) gt 0) and (G(i,j) lt 0))   = phi - Theta(i,j);
Theta(i,j)$((B(i,j) lt 0) and (G(i,j) lt 0))   = phi + Theta(i,j);
Theta(i,j)$((B(i,j) gt 0) and (G(i,j) eq 0))   = 0.5*phi;
Theta(i,j)$((B(i,j) lt 0) and (G(i,j) eq 0))   = -0.5*phi;
Theta(i,j)$((B(i,j) eq 0) and (G(i,j) eq 0))   = 0.0 ;

*---AT THIS POINT WE HAVE AVAILABLE Y(i,j) AND THETA(i,j)-------------

********* MODEL DEFINITION, SOLVE AND OUTPUT RESULTS SECTION *********
VARIABLES
V(i)           Voltage magnitude at bus i in per unit
Delta(i)       Voltage angle at bus i in radians
P(i)           Real power generation at bus i in per unit
Q(i)           Reactive power generation at bus i in per unit
Loss           Total system cost
;

Positive variable P ;

Parameter G(i,j);
G(i,j)    = -Y(i,j)*cos(Theta(i,j));

*-Initialization of Variables ------------------------------
Parameter VLevel(Gen)
/ 1 1.07
/ ;

V.l(i)        = 1.0 ;
V.Fx(Gen)     = VLevel(Gen);
Delta.l(i)    = 0.0 ;
Delta.fx("1") = 0;
*----------------------------------------------------------

EQUATIONS
LossFn       Total system generation cost in $
Equn1(i)     Real power load flow equation
Equn2(i)     Reactive power load flow equation
;


LossFn..   Loss =e= Sum((i,j),0.5*G(i,j)*(V(i)*V(i)+V(j)*V(j)-2*V(i)*V(j)*Cos(Delta(j) - Delta(i))));


Equn1(i).. P(i) - PD(i) =e=  Sum(j, Y(i,j)*V(i)*V(j)*Cos(Theta(i,j) + Delta(j) - Delta(i))) ;

Equn2(i).. Q(i) - QD(i) =e= -Sum(j, Y(i,j)*V(i)*V(j)*Sin(Theta(i,j) + Delta(j) - Delta(i)));


V.up(load) = 1.07;
V.lo(load) = 0.95;

P.Up(i)    = PMx(i);
P.Lo(i)    = PMn(i);
Q.Up(i)    = QMx(i);
Q.Lo(i)    = QMn(i);


MODEL OPF
/
LossFn
Equn1
Equn2
/ ;

*-----------About Display of Solution---------------------------------
*  The final results will be available in the file 'OPFResultForPEV1.put'
*  For additional information on the solution process, see the file
*    'PEV ECE666 Project with PEV 38 Node system.lst'
*---------------------------------------------------------------------

File OPFResultForPEV1;

Parameters PGx(i), QGx(i), CostA, MCPA(i), MCQA(i),LossA,VA(i),DeltaA(i),PflowA(i,j),QflowA(i,j);

************************CASE-A **********************************
*  COST MINIMIZATION PROBLEM
*****************************************************************

SOLVE OPF using NLP Minimizing Loss;

CostA   = Sum(i, Cc(i) + Bc(i)*P.l(i) + Ac(i)*P.l(i)*P.l(i));
PGx(i)  = P.l(i)*100;
QGx(i)  = Q.l(i)*100;
MCPA(i) = Equn1.m(i)/100;
MCQA(i) = Equn2.m(i)/100;
VA(i)   = V.l(i);
DeltaA(i)= Delta.l(i);
LossA = 100*Loss.l;
PflowA(i,j)=100*(Y(i,j)*V.l(i)*V.l(i)*Cos(Theta(i,j))-Y(i,j)*V.l(i)*V.l(j)*Cos(Theta(i,j) + Delta.l(j) - Delta.l(i)));
QflowA(i,j)=100*(Y(i,j)*V.l(i)*V.l(i)*Sin(Theta(i,j))-Y(i,j)*V.l(i)*V.l(j)*Sin(Theta(i,j) + Delta.l(j) - Delta.l(i)));

display
CostA
,LossA
,PGx
,QGx
,PflowA
,QflowA
,MCPA
,MCQA
,VA
,DeltaA;

Put OPFResultForPEV1;
Put '*********************************************************************';
Put /;
Put ' Loss Minimizing in OPF Solution without PEVs Load Demand';
Put /;
Put '*********************************************************************';
Put /;
Put '   Bus     Votlage      Delta    P-Optimal      Q-Optimal       Real MC       Reactive MC';
Put /;
Put '            (PU)        (Rad)      (MW)           (MW)           ($/MWh)       ($/MVArh)';
Put /;
Loop(i,
  Put '   ', i.TL:2, VA(i):12:3, DeltaA(i):12:3, PGx(i):12:3, QGx(i):15:3, MCPA(i):17:3, MCQA(i):17:3 ;
  Put /;
);

Put /;

Put 'Minimum Cost = ',CostA:12:3;Put '($)';Put /;

Put 'Power Loss   = ',LossA:12:3;Put '(MW)';Put /;

Put 'Magnitude of Ybus';Put /;
Loop(i,
Put '|';
Loop(j,
         Put '   ',Y(i,j):12:3;
);
Put '   |';
Put /;
);

Put 'Angle of Ybus';Put /;
Loop(i,
Put '|';
Loop(j,
         Put '   ',Theta(i,j):12:3;
);
Put '   |';
Put /;
);

Put 'Real Power Flow';Put /;
Loop(i,
Put '|';
Loop(j,
         Put '   ',PflowA(i,j):12:3;
);
Put '   |';
Put /;
);

Put 'Reactive Power Flow';Put /;
Loop(i,
Put '|';
Loop(j,
         Put '   ',QflowA(i,j):12:3;
);
Put '   |';
Put /;
);
Put ///;
