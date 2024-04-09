************************************************************
*QUITAMOS FILTROS Y FACTOR DE EXPANSIÓN
************************************************************.

FILTER OFF.
USE ALL.
EXECUTE.

WEIGHT OFF.

*******************************************************************************************
*Cuando se sacan resultados a nivel de población usar el filtro "RESIDENTES"
*******************************************************************************************.

IF  ((P204=1 & P205=2) | (P204=2 & P206=1)) Residentes=1.
EXECUTE.

*****************************************************************************************************************************************************
*INDICADOR 01: PORCENTAJE DE HOGARES QUE TIENEN ACCESO AL SERVICIO DE AGUA POR RED PÚBLICA. 2018-2019
*****************************************************************************************************************************************************.

COMPUTE Indicador_1=0.
EXECUTE.

IF (P129G=1 | P129G=2 | P129G=3) Indicador_1=1.
EXECUTE.


VARIABLE LABELS Indicador_1 'PORCENTAJE DE HOGARES QUE TIENEN ACCESO AL SERVICIO DE AGUA POR RED PÚBLICA'.


*****************************************************************************************************************************************************
*INDICADOR 02: PORCENTAJE DE HOGARES QUE TIENEN SERVICIO DE ALCANTARILLADO U OTRAS FORMAS DE 
                         DISPOSICIÓN SANITARIA DE EXCRETAS. 2018 - 2019
*****************************************************************************************************************************************************.

COMPUTE  Indicador_2_Hig=0.
EXECUTE.

if((P142A=1 | P142A=2) | ((P142A=3 | P142A=4 | P142A=5) & P143=1 & P146=3)) Indicador_2_Hig=1.
EXECUTE.

VARIABLE LABELS Indicador_2_Hig 'PORCENTAJE DE HOGARES QUE TIENEN SERVICIO DE ALCANTARILLADO U OTRAS FORMAS DE DISPOSICIÓN SANITARIA DE EXCRETAS'.


******************************************************************************************************************************************************
*INDICADOR 12: PORCENTAJE DE HOGARES QUE TIENEN AGUA SEGURA
******************************************************************************************************************************************************.

if(P129C=1 | P129C=2 | P129C=3) Agua_segura_responde=0.
if(P129C=1) Agua_segura_responde=1.
EXECUTE.

compute Indicador_12 = Agua_segura_responde.
EXECUTE.


VALUE LABELS Indicador_12
1 Agua segura en hogares solo responden
0 cc.


VARIABLE LABELS  Indicador_12 'INDICADOR 12: PORCENTAJE DE HOGARES QUE TIENEN AGUA SEGURA'.


**************************************************************************************************************************************************
*INDICADOR 13: CONTINUIDAD DEL SERVICIO DE AGUA POR RED PÚBLICA EN LOS HOGARES RURALES
**************************************************************************************************************************************************.

RECODE P130A P130B P130C (SYSMIS=0).
EXECUTE.

IF  (Indicador_1 = 1) HARP=1.
VARIABLE LABELS  HARP 'IF (Indicador_1 = 1) HARP=1 '.
EXECUTE.

COMPUTE DIAS_AGUA=P130B.
VARIABLE LABELS  DIAS_AGUA 'COMPUTE DIAS_AGUA=P130B'.
EXECUTE.

IF((Indicador_1 = 1) & (P130=1)) DIAS_AGUA=7.
EXECUTE.

COMPUTE HORAS_AGUA=P130C.
VARIABLE LABELS  HORAS_AGUA 'COMPUTE HORAS_AGUA=P130C'.
EXECUTE.


IF((Indicador_1 = 1) & (P130=1)) HORAS_AGUA=P130A.
EXECUTE.

IF  (Indicador_1 = 1) DixHi=DIAS_AGUA * HORAS_AGUA.
VARIABLE LABELS  DixHi 'IF (Indicador_1 = 1) DixHi=DIAS_AGUA * HORAS_AGUA '.
EXECUTE.

COMPUTE Indicador_13_dia=DixHi/7.
VARIABLE LABELS  Indicador_13 'CONTINUIDAD DIARIA DEL SERVICIO DE AGUA POR RED PÚBLICA EN LOS HOGARES'.
EXECUTE.

