      PROGRAM BI2STE3
      IMPLICIT REAL*16 (A-H,O-Z)
      COMMON TOLRD,EPS,SW,RHO0L,FAKL(0:2000),REJPBC(0:2000),
     1HYP0(-1:2000),IC(0:2000)
      OPEN(UNIT=5, STATUS='OLD', FILE='ste3_inp')
      OPEN(UNIT=6, STATUS='UNKNOWN', FILE='ste3_out')
      READ(5,9000) M,N,EPS,ALPHA,SW,TOLRD,TOL,MAXH
 9000 FORMAT(2(I5/),5(F20.12/),I6)  
      WRITE (6,1000) M,N,EPS,ALPHA,SW,TOLRD,TOL,MAXH
      RHO0L=QLOG(1-EPS)
      NN= M+N
      FAKL(0)= 0
      DO 1 I= 1,2000
      QI= I
    1 FAKL(I)= FAKL(I-1) + QLOG(QI)
      ALPH_0=ALPHA      
      SIZE=REJMAX(M,N,ALPH_0)
      WRITE(5,2000) ALPH_0,NHST,SIZE
      DO WHILE (SIZE.LE.ALPHA)
      ALPH_0=ALPH_0+.01
      SIZE=REJMAX(M,N,ALPH_0)
      WRITE(5,2000) ALPH_0,NHST,SIZE
      END DO 
      NHST=0  
      ALPH_1=ALPH_0-.01
      ALPH_2=ALPH_0
   11 NHST=NHST+1
      ALPH_0=(ALPH_1+ALPH_2)/2  
      SIZE=REJMAX(M,N,ALPH_0)
      WRITE(6,2000) ALPH_0,NHST,SIZE
      IF((QABS(SIZE-ALPHA).LT.TOL).OR.(NHST.GE.MAXH)) GO TO 14
      IF(SIZE.GT.ALPHA) GO TO 12
      IF(SIZE.LT.ALPHA) GO TO 13
   12 ALPH_2=ALPH_0 
      GO TO 11 
   13 ALPH_1=ALPH_0 
      GO TO 11 
   14 SIZE=REJMAX(M,N,ALPH_0)      
      WRITE(6,2000) ALPH_0,NHST,SIZE
 1000 FORMAT('M= ',I4,5X,'N= ',I4,10X,'EPS=  ',F6.4,8X,'ALPHA= ',F10.8/
     1'SW= ',F7.5,5X,'TOLRD=  ',E10.4,5X,'TOL=  ',F7.5,4X,
     2'MAXH= ',I3/)
 2000 FORMAT('ALPH_0= ',F12.10,10X,'NHST= ',I6,5X,'SIZE= ',F20.18//)
      STOP
      END
      REAL FUNCTION REJMAX*16(M,N,ALPHA)
      IMPLICIT REAL*16 (A-H,O-Z)
      COMMON TOLRD,EPS,SW,RHO0L,FAKL(0:2000),IC(0:2000)
      DIMENSION HYP0(-1:2000)
      NN=M+N
      OOM0L=0
      DO 6 IS= 1,NN-1
      IXL= MAX(0,IS-N)
      IXU= MIN(IS,M)
      HYP0(IXU)= 0
      DO 2 J=1,IXU-IXL+1
      IX=IXU-J
      HL= FAKL(M)-FAKL(IX+1)-FAKL(M-IX-1)+FAKL(N)-FAKL(IS-IX-1)-
     1FAKL(N-IS+IX+1)
      HYP0(IX)= QEXP(HL+(IX+1)*RHO0L-OOM0L)
    2 HYP0(IX)= HYP0(IX) + HYP0(IX+1)
      OOM0L=OOM0L+QLOG(HYP0(IXL-1))
      DO 3 IX=IXL, IXU-1
    3 HYP0(IX)=HYP0(IX)/HYP0(IXL-1)
      HYP0(IXL-1)=1
      K=IXU+1
    4 K=K-1
      SIZE=HYP0(K)
      IF (SIZE-ALPHA)4,4,5
    5 IC(IS)=K+1
    6 CONTINUE
      ITMAX=1/SW -1 
      REJMAX=0
      P2=TOLRD
      P1=(1-EPS)*P2/(1-P2)
      P1=P1/(1+P1)
      P2_0=P2
      P1_0=P1
      PBRJ=RJPBNC7(M,N,P2,P1)    
      REJMAX=QMAX1(REJMAX,PBRJ)
      IF(PBRJ.NE.REJMAX) GO TO 61
      P2_0=P2
      P1_0=P1 
   61 DO 9 IT=1,ITMAX
      P2=IT*SW
      P1RD=(1-EPS)*P2/(1-P2)
      P1RD=P1RD/(1+P1RD)
      P1=P1RD
      PBRJ=RJPBNC7(M,N,P2,P1)    
      REJMAX=QMAX1(REJMAX,PBRJ)
      IF(PBRJ.NE.REJMAX) GO TO 9
      P2_0=P2
      P1_0=P1      
    9 CONTINUE    
      P2=1-TOLRD
      P1=(1-EPS)*P2/(1-P2)
      P1=P1/(1+P1)
      PBRJ=RJPBNC7(M,N,P2,P1)    
      REJMAX=QMAX1(REJMAX,PBRJ)  
      RETURN
      END
      REAL FUNCTION RJPBNC7*16(M,N,P2,P1)
      IMPLICIT REAL*16 (A-H,O-Z)
      COMMON TOLRD,EPS,SW,RHO0L,FAKL(0:2000),IC(0:2000)
      DIMENSION HYPA(-1:2000),REJPB_C7(0:2000)
      NN=M+N
      P1L=QLOG(P1)
      Q1L=QLOG(1-P1)
      P2L=QLOG(P2)
      Q2L=QLOG(1-P2)
      RHOAL=P1L+Q2L-Q1L-P2L
      OOMAL=0     
      RJPBNC7=0
      DO 9 IS= 1,NN-1
      IXL= MAX(0,IS-N)
      IXU= MIN(IS,M)
      HYPA(IXU)= 0
      DO 2 J=1,IXU-IXL+1
      IX=IXU-J
      HL= FAKL(M)-FAKL(IX+1)-FAKL(M-IX-1)+FAKL(N)-FAKL(IS-IX-1)-
     1FAKL(N-IS+IX+1)
      HYPA(IX)= QEXP(HL+(IX+1)*RHOAL -OOMAL)
    2 HYPA(IX)= HYPA(IX) + HYPA(IX+1)
      OOMAL=OOMAL+QLOG(HYPA(IXL-1))
      DO 3 IX=IXL, IXU-1
    3 HYPA(IX)=HYPA(IX)/HYPA(IXL-1)
      HYPA(IXL-1)=1
      REJPB_C7(IS) = HYPA(IC(IS))
      PROBS=0
      DO 6 IX=IXL,IXU
      BL= FAKL(N)-FAKL(IS-IX)-FAKL(N-IS+IX) +(IS-IX)*P2L+(N-IS+IX)
     1*Q2L+FAKL(M)-FAKL(IX)-FAKL(M-IX)+IX*P1L+(M-IX)*Q1L
    6 PROBS= PROBS+QEXP(BL)
    9 RJPBNC7=RJPBNC7+REJPB_C7(IS)*PROBS
      RETURN
      END































