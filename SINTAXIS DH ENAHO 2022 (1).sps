
GET
  FILE='D:\Robinson\BD ENAHO\Enaho01-2007-2013-100(origiNAL +AJUS DE SERV HIGIENICO+AJUS DOMINIO Y ESTRATO).sav'.
*** Data caracteristicas de la vivienda del hogar

*********************FILTRAR LOS LAS ENCUESTAS CONTESTADAS PARACIAL O TOTALMENTE*******
FILTER OFF.
USE ALL.
SELECT IF(RESULT   <= 2 ).
EXECUTE .

*********************************************************************************************

****IF(HOGAR='11') NHOGAR=1. 
****IF(HOGAR>'11') NHOGAR=2. 
****VARIABLE LABELS NHOGAR 'N?mero hogares por vivienda'.
****EXECUTE.
****VALUE LABELS NHOGAR 1 "Un Hogar" 2 "M?s de un Hogar" .

****************************************************************************************************
********************?REA URBANO RURAL****************************
****************************************************************************************************

IF(ESTRATO = 1 | ESTRATO = 2 | ESTRATO = 3 | ESTRATO = 4 | ESTRATO = 5) AREA=1. 
IF(ESTRATO = 6 | ESTRATO = 7 | ESTRATO = 8) AREA=2. 
VARIABLE LABELS AREA 'Tipo de ?rea '.
EXECUTE.
VALUE LABELS AREA 1 "Urbana" 2 "Rural".

******************************************************************************
* D    ?   F   I   C   I   T       H   A   B   I   T  A   C   I   O   N   A   L*
******************************************************************************

*****D?FICIT  CUANTITATIVO*

IF(HOGAR<'20') DT=0.
IF(HOGAR >'20') DT=1.
EXECUTE.
VARIABLE LABELS DT 'DIFICIT TRADICIONAL'.
VALUE LABELS DT 0 'NRO. DE HOGARES CON VIVIENDAS' 1 'NRO. DE HOGARES QUE REQUIEREN VIVIENDAS'.

IF(P101=7) DT1=1.
IF(P101=8) DT1=1.
IF(P101=6 & (P105A=1 | P105A=5 | P105A=6 | P105A=7)) DT1=1.
EXECUTE.
VARIABLE LABELS DT1 'NRO. DE HOGARES CON VIVIENDAS NO ADECUADAS'.
VALUE LABELS DT1 1 'HOGARES CON VIVIENDAS NO ADECUADAS'.

IF(DT=1) DCUAN=1.
IF(DT1=1) DCUAN=1.
EXECUTE.

VARIABLE LABELS DCUAN 'DIFICIT CUANTITATIVO'.
VALUE LABELS DCUAN 1 'DIFICIT CUANTITATIVO'.

RECODE DT (SYSMIS=0).
EXECUTE.

RECODE DT1 (SYSMIS=0).
EXECUTE.

RECODE DCUAN (SYSMIS=0).
EXECUTE.


WEIGHT BY FACTOR07.



SAVE OUTFILE='\\argus\estadistica$\8_ESTADISTICA_2015\DEFICIT HABITACIONAL\ENAHO 2004-2014 OK\ DEFICIT DE VIVIENDA INICIAL-AJUSTE AREA-hac solo al primer hogar.SAV' /COMPRESSED.


*****D?FICIT  CUALITATIVO*

***********************************************************************************************************************************************************.
*****************************************************NRO. DE PERSONAS DEL PRIMER HOGARPOR HABITACION******************************************************.
***********************************************************************************************************************************************************.
GET
  FILE='\\argus\estadistica$\8_ESTADISTICA_2015\DEFICIT HABITACIONAL\ENAHO 2004-2014 OK\Enaho01-2004-2014-200(original).sav'.
*** Data caracteristicas de los miembros del hogar

DO IF (hogar < '20' ).

IF (((p204 = 1 & p205 = 2) | (p204 = 2 & p206 = 1))) presid = 1.

END IF.
EXECUTE.




AGGREGATE
/OUTFILE=*
/BREAK=AÑO MES CONGLOME vivienda
/RESID_sum = SUM(RESID).


SORT CASES BY
  AÑO(A) MES(A) CONGLOME (A) VIVIENDA (A) .

SAVE OUTFILE='\\argus\estadistica$\8_ESTADISTICA_2015\DEFICIT HABITACIONAL\ENAHO 2004-2014 OK\HACINAMIENTO.SAV'  /COMPRESSED.


GET
  FILE='D:\Robinson\BD ENAHO\ DEFICIT DE VIVIENDA INICIAL-AJUSTE AREA-hac solo al primer hogar.SAV'.

SORT CASES BY
  AÑO(A) MES(A) CONGLOME (A) VIVIENDA (A) .



MATCH FILES /FILE=*
  /TABLE='\\argus\estadistica$\8_ESTADISTICA_2015\DEFICIT HABITACIONAL\ENAHO 2004-2014 OK\HACINAMIENTO.SAV'
  /BY año mes conglome vivienda.
EXECUTE.

SAVE OUTFILE='D:\Robinson\BD ENAHO\ DEFICIT DE VIVIENDA INICIAL-AJUSTE AREA-hac solo al primer hogar.SAV' /COMPRESSED.


***********************************************************************************************************************************************************.
*********************************INDICADOR DE MATERIALIDAD DE LA VIVIENDA**************************************************************.
***********************************************************************************************************************************************************.

DO IF (hogar < '20' ).

IF(AREA = 1 & (P102=1 | P102=2)) CPARED=1.
IF(AREA = 2 & (P102=1 | P102=2 | P102=3 | P102=4)) CPARED=1.
IF(AREA = 1 & (P102=3 | P102=4 | P102=5 | P102=7)) CPARED=2.
IF(AREA = 2 & (P102=5 | P102=6 | P102=7)) CPARED=2.
IF(AREA = 1 & (P102=6 | P102=8 | P102=9)) CPARED=3.
IF(AREA = 2 & (P102=8 | P102=9)) CPARED=3.
END IF.
EXECUTE.

VARIABLE LABELS CPARED 'CALIDAD DE MATERIAL PREDOMINANTE EN PAREDES EXTERIORES'.
EXECUTE.
VALUE LABELS CPARED 1 "ACEPTABLE" 2 "RECUPERABLE" 3 "IRRECUPERABLE".



DO IF (hogar < '20' ).

IF(AREA<= 2 & P103 <=5) CPISOS =1.
IF(AREA<= 2 & (P103=6 | P103=7) ) CPISOS=2.
END IF.
EXECUTE.

VARIABLE LABELS CPISOS 'CALIDAD DE MATERIAL PREDOMINANTE EN PISOS'.
EXECUTE.
VALUE LABELS CPISOS 1 "ACEPTABLE" 2 "RECUPERABLE".



DO IF (hogar < '20' ).

IF(p101 < 5 | (p101 = 6 & ( p105A=2  | p105A =3 | p105A = 4))) MATERIALIDAD=1.
IF(MATERIALIDAD = 1 & CPARED=1 & CPISOS=1) IMV=1.
IF(MATERIALIDAD = 1 & CPARED=2 & CPISOS<=2) IMV=2.
IF(MATERIALIDAD = 1 & CPARED<=2 & CPISOS=2) IMV=2.
IF(MATERIALIDAD = 1 & CPARED=3 & CPISOS<=2) IMV=3.
END IF.
EXECUTE.

VARIABLE LABELS IMV 'INDICE DE MATERIALIDAD DE LA VIVIENDA'.
EXECUTE.
VALUE LABELS IMV 1'ACEPTABLE' 2 'RECUPERABLE' 3 'IRRECUPERABLE'.

WEIGHT BY  FACTOR07.

FREQUENCIES IMV. 

WEIGHT OFF. 

***********************************************************************************************************************************************************.
******************************************************C?LCULO DEL HACINAMIENTO**************************************************************.
***********************************************************************************************************************************************************.

DO IF P104~=0.
COMPUTE NPERSH1 = Resid_1hogar_sum / P104.
ELSE IF P104=0.
COMPUTE NPERSH1=0.
END IF.
EXECUTE.

DO IF (hogar < '20' ).

IF (P101 < 6 | (P101 = 6 & (P105A =2  | P105A =3 | P105A = 4))) HACINAMIENTO=1. 
IF ((IMV<3 | MISSING(IMV)) & HACINAMIENTO =1 & NPERSH1<= 3.0) TABNP=1. 
IF((IMV<3 | MISSING(IMV)) &HACINAMIENTO = 1 & NPERSH1>3.0) TABNP=2.  
END IF.
EXECUTE.


VARIABLE LABELS TABNP 'NRO. DE PERSONAS POR HABITACI?N'.
EXECUTE.
VALUE LABELS TABNP 1 "SIN HACINAMIENTO" 2 "CON HACINAMIENTO".

WEIGHT BY FACTOR07.

FREQUENCIES  TABNP . 

WEIGHT OFF. 


***********************************************************************************************************************************************************.
*************************************** INDICADOR DE SERVICIOS B?SICOS DE LA VIVIENDA*************************************************.
***********************************************************************************************************************************************************.

DO IF (hogar < '20' ).
IF(AREA = 1 & P110 = 1) AGUA=1.
IF(AREA = 1 & P110 >1 & P110 <=8) AGUA=2.
IF(AREA = 2 & (P110 =1 |P110 =2 | P110 =3 | P110 =5)) AGUA=1.
IF(AREA = 2 & (P110 =4 | P110 =6| P110 =7| P110 =8)) AGUA=2.
END IF.
EXECUTE.


VARIABLE LABELS AGUA 'CALIDAD DE SERVICIOS BASICOS (AGUA)'.
VALUE LABELS AGUA 1 "ACEPTABLE" 2 "DEFICITARIO".
----------------------------------------------------------------------------------------------------------------


DO IF (hogar < '20' ).
IF(AREA =1 & P111 =1) DESAGUE=1.
IF(AREA = 1 & P111 >1 & P111 <=9) DESAGUE=2.
IF(AREA = 2 & P111 >=1 & P111 <=5) DESAGUE=1.
IF(AREA = 2 & (P111 >5)) DESAGUE=2.
END IF.
EXECUTE.


VARIABLE LABELS DESAGUE 'CALIDAD DE SERVICIOS BASICOS (SERVICIO HIGIENICO)'.
VALUE LABELS DESAGUE 1 "ACEPTABLE" 2 "DEFICITARIO".

---------------------------------------------------------------------------------------------------------------------------------------------------

DO IF (hogar < '20' ).

IF(AREA<=2 & P1121 =1) LUZ=1.
IF(AREA<=2 & P1121 =0) LUZ=2.
END IF.
EXECUTE.


VARIABLE LABELS LUZ 'CALIDAD DE SERVICIOS B?SICOS (LUZ)'.
VALUE LABELS  LUZ 1 "ACEPTABLE" 2 "DEFICITARIO".

DO IF (hogar < '20' ).
IF(P101 < 4 | P101=5 | (P101 = 6 & (P105A =2  | P105A =3 | P105A = 4))) SERVICIOS=1.
IF( (IMV<3 | MISSING(IMV)) & (TABNP~=2 | MISSING(TABNP)) & SERVICIOS=1 & AGUA=1& DESAGUE=1& LUZ=1) ISB=1.
IF((IMV<3 | MISSING(IMV)) & (TABNP~=2 | MISSING(TABNP)) & SERVICIOS=1 & AGUA=2& DESAGUE=1& LUZ=1) ISB=1.
IF((IMV<3 | MISSING(IMV)) & (TABNP~=2 | MISSING(TABNP)) & SERVICIOS=1 & AGUA=1& DESAGUE=2& LUZ=1) ISB=1.
IF((IMV<3 | MISSING(IMV)) &(TABNP~=2 | MISSING(TABNP)) & SERVICIOS=1 & AGUA=1& DESAGUE=1& LUZ=2) ISB=1.
IF((IMV<3 | MISSING(IMV))  &(TABNP~=2 | MISSING(TABNP)) & SERVICIOS=1 &AGUA=2& DESAGUE=2& LUZ=1) ISB=1.
IF((IMV<3 | MISSING(IMV)) & (TABNP~=2 | MISSING(TABNP)) & SERVICIOS=1 & AGUA=1& DESAGUE=2& LUZ=2) ISB=1.
IF((IMV<3 | MISSING(IMV)) & (TABNP~=2 | MISSING(TABNP)) & SERVICIOS=1 &AGUA=2& DESAGUE=1& LUZ=2) ISB=1.
IF((IMV<3 | MISSING(IMV)) & (TABNP~=2 | MISSING(TABNP)) &  SERVICIOS=1 & AGUA=2 & DESAGUE=2& LUZ=2) ISB=2.
END IF.
EXECUTE.

VARIABLE LABELS ISB 'INDICE DE SERVICIOS BASICOS DE VIVIENDA'.
EXECUTE.
VALUE LABELS ISB 1 "ACEPTABLE" 2 "DEFICITARIO".

WEIGHT BY FACTOR07.

FREQUENCIES  ISB. 

WEIGHT OFF. 



IF(MATERIALIDAD=1 & IMV=3) DEF1=1.
VARIABLE LABELS  DEF1 'INDICE DE MATERIALIDAD'.
EXECUTE.
VALUE LABELS DEF1 1 "VIV. MATERIALIDAD DEFICIENTE".

IF(HACINAMIENTO=1 & TABNP=2) DEF2=1.
VARIABLE LABELS  DEF2 'INDICE DE HACINAMIENTO'.
EXECUTE.
VALUE LABELS DEF2 1 "VIVIENDA HACINADA".

IF(SERVICIOS=1 & ISB=2) DEF3=1.
VARIABLE LABELS  DEF3 'INDICE DE SERVICIOS B?SICOS'.
EXECUTE.
VALUE LABELS DEF3 1 "VIV. SERV. BASICOS DEF".

COMPUTE DEFCUALIT=SUM(DEF1 TO DEF3).
EXECUTE. 
VARIABLE LABELS DEFCUALIT 'DEFICIT CUALITATIVO'.

SAVE OUTFILE='D:\Robinson\BD ENAHO\ DEFICIT DE VIVIENDA.SAV' /COMPRESSED.



***********************************************************************************************************************************************************.
*******************************************************C?LCULO DEL D?FICIT HABITACIONAL****************************************************.
***********************************************************************************************************************************************************.


