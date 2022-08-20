
/*------------------------------------------------------------------------
    File        : IHM.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : yassi
    Created     : Thu Aug 18 10:58:41 WAT 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.
        DEFINE VARIABLE wi_Lib_domaine AS CHARACTER FORMAT "x(76)".
        DEFINE VARIABLE Path  AS CHARACTER FORMAT "x(76)" NO-UNDO.
        DEFINE VARIABLE OKpressed AS LOGICAL   NO-UNDO INITIAL TRUE.
        DEFINE VARIABLE wi_Lib_domaine1 AS CHARACTER FORMAT "x(76)".
        DEFINE VARIABLE Path1  AS CHARACTER  FORMAT "x(76)" NO-UNDO.
        DEFINE VARIABLE OKpressed1 AS LOGICAL   NO-UNDO INITIAL TRUE.
        DEFINE VARIABLE db1  AS CHARACTER NO-UNDO.
        DEFINE VARIABLE db2  AS CHARACTER NO-UNDO.
        DEF VAR wNomBase        AS CHAR                 NO-UNDO.
        DEF VAR wNomBase1        AS CHAR                 NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE BUTTON Btn_annuler
     LABEL "":U
     SIZE 16 BY 1.2.

    DEFINE BUTTON Btn_db2
         LABEL "":U
         SIZE 16 BY 1.2.
    
    DEFINE BUTTON Btn_db1
         LABEL "":U
         SIZE 16 BY 1.2.
    
    DEFINE BUTTON Btn_compare
         LABEL "":U
         SIZE 16 BY 1.2.
         


DEFINE FRAME F1
        Path1                       AT ROW 3        COL 10      VIEW-AS TEXT        SIZE 50 BY 1
        Path                      AT ROW 6        COL 10      VIEW-AS TEXT        SIZE 50 BY 1
        "DATABASE 1 :":L                      AT ROW 2        COL 10      VIEW-AS TEXT        SIZE 15 BY 1
        "DATABASE 2 :":L                      AT ROW 5        COL 10      VIEW-AS TEXT        SIZE 15 BY 1
        Btn_db2                              AT ROW 5        COL 30
        Btn_db1                              AT ROW 2        COL 30
        Btn_compare                              AT ROW 8        COL 20
        Btn_annuler                         AT ROW 8        COL 50
        WITH CENTERED KEEP-TAB-ORDER OVERLAY
            SIDE-LABELS NO-UNDERLINE THREE-D
            SIZE 75 BY 10 VIEW-AS DIALOG-BOX
            TITLE "":U.
            
            
            
ASSIGN
        FRAME F1:TITLE       = TRIM("connect            ")
        Btn_annuler:LABEL                   = TRIM("&Cancel   ")
        Btn_annuler:AUTO-ENDKEY                           = TRUE
        Btn_compare:LABEL                        = TRIM("&COMPARE       ")
        Btn_db1:LABEL                        = TRIM("&BROWSE DB1       ")
        Btn_db2:LABEL                        = TRIM("&BROWSE DB2       ").
        
VIEW FRAME F1.
    
    
    
ON CHOOSE OF Btn_db1 IN FRAME F1
    DO:
        Main:
        REPEAT :
          SYSTEM-DIALOG GET-FILE Path1
            TITLE   "Choose your .PF file "
            FILTERS "Source Files (*.pf)"   "*.pf"
            MUST-EXIST
            USE-FILENAME
            UPDATE OKpressed1 . 
        
        
            IF OKpressed1 = TRUE THEN DO:
                 INPUT FROM VALUE (Path1).
                 IMPORT UNFORMATTED wi_Lib_domaine1.
                 DISPLAY wi_Lib_domaine1.
                 LEAVE.
            END. /*THEN DO:*/  
                ELSE LEAVE Main.
            END. 
            
            DISPLAY Path1 WITH FRAME F1.  
    END. /*ON CHOOSE OF Btn_db2 IN FRAME F1 DO:*/

    
    
    
    
ON CHOOSE OF Btn_db2 IN FRAME F1
    DO:
        Main:
        REPEAT :
          SYSTEM-DIALOG GET-FILE Path
            TITLE   "Choose your .PF file "
            FILTERS "Source Files (*.pf)"   "*.pf"
            MUST-EXIST
            USE-FILENAME
            UPDATE OKpressed . 
        
        
            IF OKpressed = TRUE THEN DO:
                 INPUT FROM VALUE (Path).
                IMPORT UNFORMATTED wi_Lib_domaine.
                DISPLAY wi_Lib_domaine.
                LEAVE.
                END. /*THEN DO:*/  
                ELSE LEAVE Main.
            END.   
                        DISPLAY Path WITH FRAME F1.  
            
    END. /*ON CHOOSE OF Btn_db2 IN FRAME F1 DO:*/
    
   
    
ON CHOOSE OF Btn_compare IN FRAME F1
    DO:
RUN connect.p(INPUT wi_Lib_domaine,
              INPUT wi_Lib_domaine1 ,
              OUTPUT wNomBase1, 
              OUTPUT wNomBase ).
RUN compare.p.
RUN compareJson.p(INPUT wNomBase1,
                      INPUT wNomBase ).         
    END.
    

    
    
ENABLE
        Btn_db1
        Btn_compare
        Btn_db2
        Btn_annuler
    WITH FRAME F1.

UPDATE
         Btn_db1
        Btn_compare
        Btn_db2
        Btn_annuler
    WITH FRAME F1.

    
    HIDE FRAME F1 NO-PAUSE.
    
        DISPLAY
        db1
        db2.