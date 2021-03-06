C    Copyright(C) 2014 National Technology & Engineering Solutions of
C    Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    Redistribution and use in source and binary forms, with or without
C    modification, are permitted provided that the following conditions are
C    met:
C    
C    * Redistributions of source code must retain the above copyright
C       notice, this list of conditions and the following disclaimer.
C    
C    * Redistributions in binary form must reproduce the above
C      copyright notice, this list of conditions and the following
C      disclaimer in the documentation and/or other materials provided
C      with the distribution.
C    
C    * Neither the name of NTESS nor the names of its
C      contributors may be used to endorse or promote products derived
C      from this software without specific prior written permission.
C    
C    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
C    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
C    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
C    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
C    OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
C    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
C    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
C    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
C    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
C    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
C    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
C    

C $Id: repsmo.f,v 1.2 1998/07/14 18:19:56 gdsjaar Exp $
C $Log: repsmo.f,v $
C Revision 1.2  1998/07/14 18:19:56  gdsjaar
C Removed unused variables, cleaned up a little.
C
C Changed BLUE labels to GREEN to help visibility on black background
C (indirectly requested by a couple users)
C
C Revision 1.1.1.1  1990/11/30 11:14:46  gdsjaar
C FASTQ Version 2.0X
C
c Revision 1.1  90/11/30  11:14:44  gdsjaar
c Initial revision
c 
C
CC* FILE: [.QMESH]REPSMO.FOR
CC* MODIFIED BY: TED BLACKER
CC* MODIFICATION DATE: 7/6/90
CC* MODIFICATION: COMPLETED HEADER INFORMATION
C
      SUBROUTINE REPSMO (MXND, XN, YN, LXN, NNN, NNNOLD, NIT, EPS, RO,
     &   M1)
C***********************************************************************
C
C  SUBROUTINE REPSMO = SMOOTHS A MESH GENERATED BY RMESH BY THE
C                      EQUIPOTENTIAL, OR WEIGHTED LAPLACIAN METHOD.
C                      GAUSS-SEIDEL TYPE RELAXATION IS USED.
C     REFERENCE--MESH GENERATION-A SURVEY, BY BUELL AND BUSH, F.M.C.
C
C***********************************************************************
C
C     NIT - MAX NUMBER OF ITERATIONS
C     EPS - CONVERGENCE CRITERION FOR NODE MOVEMENTS
C     RO  - RELAXATION FACTOR  (USUALLY 1.0 OR LARGER)
C     M1  - SAME AS M1 GIVEN TO RMESH.  THE MESH MUST BE LOGICALLY
C           EXACTLY AS PRODUCED BY RMESH.
C
C***********************************************************************
C
      DIMENSION LXN (4, MXND), XN (MXND), YN (MXND)
C
      LOGICAL BIG
C
      EPS2 = (EPS*RO)**2
      NROW = M1 + 1
C
C  ITERATION LOOP
C
      DO 110 IT = 1, NIT
         BIG = .FALSE.
C
C  NODE LOOP
C
         DO 100 NODE = NNNOLD + 1, NNN
C
C  SKIP BOUNDARY NODES
C
            IF (LXN (2, NODE) .GT. 0) THEN
               NT = NODE + NROW
               NB = NODE - NROW
C
C  COMPUTE WEIGHTS
C
               XPHI = 0.5* (XN (NT) - XN (NB))
               YPHI = 0.5* (YN (NT) - YN (NB))
               XPSI = 0.5* (XN (NODE + 1) - XN (NODE - 1))
               YPSI = 0.5* (YN (NODE + 1) - YN (NODE - 1))
               ALPHA = XPSI**2 + YPSI**2
               GAMMA = XPHI**2 + YPHI**2
               BETA2 =  (XPHI*XPSI + YPHI*YPSI)*0.5
               WEIGHT = 2.0* (ALPHA + GAMMA)
C
C  COMPUTE WEIGHTED SUM OF COORDINATES
C
               XSUM = ALPHA * (XN (NT) + XN (NB))
     &            + GAMMA * (XN (NODE - 1) + XN (NODE + 1))
     &            + BETA2 * (XN (NT - 1) + XN (NB + 1)
     &            - XN (NT + 1) - XN (NB - 1))
               YSUM = ALPHA * (YN (NT) + YN (NB))
     &            + GAMMA * (YN (NODE - 1) + YN (NODE + 1))
     &            + BETA2 * (YN (NT - 1) + YN (NB + 1)
     &            - YN (NT + 1) - YN (NB - 1))
C
C  MOVE THE NODE AS INDICATED
C
               DELX = (XSUM/WEIGHT - XN (NODE)) * RO
               DELY = (YSUM/WEIGHT - YN (NODE)) * RO
               XN (NODE) = XN (NODE) + DELX
               YN (NODE) = YN (NODE) + DELY
               IF (DELX ** 2 + DELY ** 2  .GT.  EPS2) BIG = .TRUE.
            ENDIF
  100    CONTINUE
         IF (.NOT.BIG) RETURN
  110 CONTINUE
      RETURN
      END
