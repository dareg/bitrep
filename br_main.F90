PROGRAM MAIN

USE BR_INTRINSICS
USE PARKIND1, ONLY : JPRB

IMPLICIT NONE

INTEGER, PARAMETER :: NVAL = 10000

REAL (KIND=JPRB), PARAMETER :: ZATAN_X1 = -8._JPRB,  ZEXP_X1 = -5._JPRB,  ZLOG_X1 = 0.001_JPRB,  ZSIN_X1 = -5._JPRB, ZASIN_X1 = -1._JPRB, ZCOS_X1 = -5._JPRB
REAL (KIND=JPRB), PARAMETER :: ZATAN_X2 = +8._JPRB,  ZEXP_X2 = +5._JPRB,  ZLOG_X2 = 2000._JPRB,  ZSIN_X2 = +5._JPRB, ZASIN_X2 = +1._JPRB, ZCOS_X2 = +5._JPRB

REAL (KIND=JPRB) :: ZATAN_X(NVAL),   ZEXP_X(NVAL),   ZLOG_X(NVAL),   ZSIN_X(NVAL),   ZASIN_X(NVAL),   ZCOS_X(NVAL)
REAL (KIND=JPRB) :: ZATAN_Y(NVAL,4), ZEXP_Y(NVAL,4), ZLOG_Y(NVAL,4), ZSIN_Y(NVAL,4), ZASIN_Y(NVAL,4), ZCOS_Y(NVAL,4)

CHARACTER*8 :: CLARCH = ARCH

INTEGER :: I, J
CHARACTER, PARAMETER :: CLSUF (4) = ['i', 'b', 'I', 'B']
REAL (KIND=JPRB) :: Z1, Z2

ZATAN_X  = 0._JPRB; ZATAN_Y  = 0._JPRB
ZEXP_X   = 0._JPRB; ZEXP_Y   = 0._JPRB
ZLOG_X   = 0._JPRB; ZLOG_Y   = 0._JPRB
ZSIN_X   = 0._JPRB; ZSIN_Y   = 0._JPRB
ZASIN_X  = 0._JPRB; ZASIN_Y  = 0._JPRB
ZCOS_X   = 0._JPRB; ZCOS_Y   = 0._JPRB

DO I = 1, NVAL
  Z2 = REAL (I-1, JPRB) / REAL (NVAL-1, JPRB)
  Z1 = 1. - Z2
  ZATAN_X (I) = ZATAN_X1 * Z1 + ZATAN_X2 * Z2
  ZEXP_X  (I) = ZEXP_X1  * Z1 + ZEXP_X2  * Z2
  ZLOG_X  (I) = ZLOG_X1  * Z1 + ZLOG_X2  * Z2
  ZSIN_X  (I) = ZSIN_X1  * Z1 + ZSIN_X2  * Z2
  ZASIN_X (I) = ZASIN_X1 * Z1 + ZASIN_X2 * Z2
  ZCOS_X  (I) = ZCOS_X1  * Z1 + ZCOS_X2  * Z2
ENDDO

!$acc data copyin (ZATAN_X, ZEXP_X, ZLOG_X, ZSIN_X, ZASIN_X, ZCOS_X) &
!$acc    & copyout (ZATAN_Y (:,1:2), ZEXP_Y (:,1:2), ZLOG_Y (:,1:2), ZSIN_Y (:,1:2), ZASIN_Y (:,1:2), ZCOS_Y (:,1:2))

!$acc serial
DO I = 1, NVAL
  ZATAN_Y (I,1) = ATAN (ZATAN_X (I))
  ZEXP_Y  (I,1) = EXP  (ZEXP_X  (I))
  ZLOG_Y  (I,1) = LOG  (ZLOG_X  (I))
  ZSIN_Y  (I,1) = SIN  (ZSIN_X  (I))
  ZASIN_Y (I,1) = ASIN (ZASIN_X (I))
  ZCOS_Y  (I,1) = COS  (ZCOS_X  (I))
ENDDO

DO I = 1, NVAL
  ZATAN_Y (I,2) = BR_ATAN (ZATAN_X (I))
  ZEXP_Y  (I,2) = BR_EXP  (ZEXP_X  (I))
  ZLOG_Y  (I,2) = BR_LOG  (ZLOG_X  (I))
  ZSIN_Y  (I,2) = BR_SIN  (ZSIN_X  (I))
  ZASIN_Y (I,2) = BR_ASIN (ZASIN_X (I))
  ZCOS_Y  (I,2) = BR_COS  (ZCOS_X  (I))
ENDDO
!$acc end serial

!$acc end data

DO I = 1, NVAL
  ZATAN_Y (I,3) = ATAN (ZATAN_X (I))
  ZEXP_Y  (I,3) = EXP  (ZEXP_X  (I))
  ZLOG_Y  (I,3) = LOG  (ZLOG_X  (I))
  ZSIN_Y  (I,3) = SIN  (ZSIN_X  (I))
  ZASIN_Y (I,3) = ASIN (ZASIN_X (I))
  ZCOS_Y  (I,3) = COS  (ZCOS_X  (I))
ENDDO

DO I = 1, NVAL
  ZATAN_Y (I,4) = BR_ATAN (ZATAN_X (I))
  ZEXP_Y  (I,4) = BR_EXP  (ZEXP_X  (I))
  ZLOG_Y  (I,4) = BR_LOG  (ZLOG_X  (I))
  ZSIN_Y  (I,4) = BR_SIN  (ZSIN_X  (I))
  ZASIN_Y (I,4) = BR_ASIN (ZASIN_X (I))
  ZCOS_Y  (I,4) = BR_COS  (ZCOS_X  (I))
ENDDO

DO J = 1, 4

  OPEN (71, FILE="ZATAN."//TRIM (CLSUF (J))//"."//TRIM (CLARCH)//".dat", FORM="FORMATTED")
  OPEN (72, FILE="ZEXP_."//TRIM (CLSUF (J))//"."//TRIM (CLARCH)//".dat", FORM="FORMATTED")
  OPEN (73, FILE="ZLOG_."//TRIM (CLSUF (J))//"."//TRIM (CLARCH)//".dat", FORM="FORMATTED")
  OPEN (74, FILE="ZSIN_."//TRIM (CLSUF (J))//"."//TRIM (CLARCH)//".dat", FORM="FORMATTED")
  OPEN (75, FILE="ZASIN."//TRIM (CLSUF (J))//"."//TRIM (CLARCH)//".dat", FORM="FORMATTED")
  OPEN (76, FILE="ZCOS_."//TRIM (CLSUF (J))//"."//TRIM (CLARCH)//".dat", FORM="FORMATTED")
  
  DO I = 1, NVAL
    WRITE (71, '(2E30.20)') ZATAN_X (I), ZATAN_Y (I,J)
    WRITE (72, '(2E30.20)') ZEXP_X  (I), ZEXP_Y  (I,J)
    WRITE (73, '(2E30.20)') ZLOG_X  (I), ZLOG_Y  (I,J)
    WRITE (74, '(2E30.20)') ZSIN_X  (I), ZSIN_Y  (I,J)
    WRITE (75, '(2E30.20)') ZASIN_X (I), ZASIN_Y (I,J)
    WRITE (76, '(2E30.20)') ZCOS_X  (I), ZCOS_Y  (I,J)
  ENDDO
  
  CLOSE (71)
  CLOSE (72)
  CLOSE (73)
  CLOSE (74)
  CLOSE (75)
  CLOSE (76)

ENDDO

END
