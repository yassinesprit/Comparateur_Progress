
/*------------------------------------------------------------------------
    File        : compare.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : yassi
    Created     : Thu Aug 18 13:09:57 WAT 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.




DEFINE TEMP-TABLE ttmp1 NO-UNDO
 FIELD CODE_PLF AS CHARACTER
 FIELD CODE_DO AS CHARACTER
 FIELD LIB_PARAM AS CHARACTER
 FIELD ZONE_NUM_1 AS DECIMAL
 FIELD ZONE_NUM_2 AS DECIMAL
 FIELD ZONE_NUM_3 AS DECIMAL
 FIELD ZONE_NUM_4 AS DECIMAL
 FIELD ZONE_NUM_5 AS DECIMAL
 FIELD ZONE_ALPHA_1 AS CHARACTER
 FIELD ZONE_ALPHA_2 AS CHARACTER
 FIELD ZONE_ALPHA_3 AS CHARACTER
 FIELD ZONE_ALPHA_4 AS CHARACTER
 FIELD ZONE_ALPHA_5 AS CHARACTER
 FIELD ZONE_DATE_1 AS DATE
 FIELD ZONE_DATE_2 AS DATE
 FIELD ZONE_DATE_3 AS DATE
 FIELD ZONE_DATE_4 AS DATE
 FIELD ZONE_DATE_5 AS DATE
 FIELD ZONE_LOG_1 AS LOGICAL
 FIELD ZONE_LOG_2 AS LOGICAL
 FIELD ZONE_LOG_3 AS LOGICAL
 FIELD ZONE_LOG_4 AS LOGICAL
 FIELD ZONE_LOG_5 AS LOGICAL
 FIELD TYPE_PARAM AS CHARACTER
 FIELD CATEG_PARAM AS CHARACTER
 FIELD CODE_PARAM AS CHARACTER
 FIELD ZONE_NUM_6 AS DECIMAL
 FIELD ZONE_ALPHA_6 AS CHARACTER
 FIELD ZONE_DATE_6 AS DATE
 FIELD ZONE_LOG_6 AS LOGICAL
 FIELD DATE_DER_MAJ AS DATE
 FIELD HEURE_DER_MAJ AS INTEGER
 FIELD NOM_UTIL_DER_MAJ AS CHARACTER
 FIELD NIVEAU AS CHARACTER
 FIELD CLASSIFICATION AS CHARACTER
 FIELD A_TRADUIRE AS LOGICAL
 INDEX PARAMETRE_PK IS PRIMARY UNIQUE CODE_DO CODE_PLF TYPE_PARAM CATEG_PARAM CODE_PARAM .


DEFINE TEMP-TABLE ttmp2 NO-UNDO
 FIELD CODE_PLF AS CHARACTER
 FIELD CODE_DO AS CHARACTER
 FIELD LIB_PARAM AS CHARACTER
 FIELD ZONE_NUM_1 AS DECIMAL
 FIELD ZONE_NUM_2 AS DECIMAL
 FIELD ZONE_NUM_3 AS DECIMAL
 FIELD ZONE_NUM_4 AS DECIMAL
 FIELD ZONE_NUM_5 AS DECIMAL
 FIELD ZONE_ALPHA_1 AS CHARACTER
 FIELD ZONE_ALPHA_2 AS CHARACTER
 FIELD ZONE_ALPHA_3 AS CHARACTER
 FIELD ZONE_ALPHA_4 AS CHARACTER
 FIELD ZONE_ALPHA_5 AS CHARACTER
 FIELD ZONE_DATE_1 AS DATE
 FIELD ZONE_DATE_2 AS DATE
 FIELD ZONE_DATE_3 AS DATE
 FIELD ZONE_DATE_4 AS DATE
 FIELD ZONE_DATE_5 AS DATE
 FIELD ZONE_LOG_1 AS LOGICAL
 FIELD ZONE_LOG_2 AS LOGICAL
 FIELD ZONE_LOG_3 AS LOGICAL
 FIELD ZONE_LOG_4 AS LOGICAL
 FIELD ZONE_LOG_5 AS LOGICAL
 FIELD TYPE_PARAM AS CHARACTER
 FIELD CATEG_PARAM AS CHARACTER
 FIELD CODE_PARAM AS CHARACTER
 FIELD ZONE_NUM_6 AS DECIMAL
 FIELD ZONE_ALPHA_6 AS CHARACTER
 FIELD ZONE_DATE_6 AS DATE
 FIELD ZONE_LOG_6 AS LOGICAL
 FIELD DATE_DER_MAJ AS DATE
 FIELD HEURE_DER_MAJ AS INTEGER
 FIELD NOM_UTIL_DER_MAJ AS CHARACTER
 FIELD NIVEAU AS CHARACTER
 FIELD CLASSIFICATION AS CHARACTER
 FIELD A_TRADUIRE AS LOGICAL
 INDEX PARAMETRE_PK IS PRIMARY UNIQUE CODE_DO CODE_PLF TYPE_PARAM CATEG_PARAM CODE_PARAM .
 
 
 DEFINE STREAM MyStream1.
 DEFINE STREAM MyStream2.
 
DEFINE BUFFER bi1_parametre FOR LPFRET.PARAMETRE.
DEFINE BUFFER bi2_parametre FOR LPFSEC.PARAMETRE.

DEFINE VARIABLE wg_comparaison AS LOGICAL NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
EMPTY TEMP-TABLE ttmp1.
EMPTY TEMP-TABLE ttmp2.


    FOR EACH   bi1_parametre NO-LOCK :
        FIND FIRST bi2_parametre 
             WHERE bi2_parametre.CODE_DO     = bi1_parametre.CODE_DO 
               AND bi2_parametre.CODE_PLF    = bi1_parametre.CODE_PLF
               AND bi2_parametre.TYPE_PARAM  = bi1_parametre.TYPE_PARAM 
               AND bi2_parametre.CATEG_PARAM = bi1_parametre.CATEG_PARAM
               AND bi2_parametre.CODE_PARAM  = bi1_parametre.CODE_PARAM 
               /**/
          NO-ERROR .
       wg_comparaison = true.
       IF AVAILABLE (bi2_parametre) 
       THEN  DO:
           BUFFER-COMPARE bi1_parametre
           TO bi2_parametre
           SAVE RESULT in wg_comparaison.
           IF NOT wg_comparaison 
           THEN DO:
               CREATE ttmp1.
               CREATE ttmp2.
               
               BUFFER-COPY bi1_parametre TO ttmp1 NO-ERROR.
               BUFFER-COPY bi2_parametre TO ttmp2 NO-ERROR.
           END. /*IF NOT wg_comparaison*/     
              
            
         
    	END. /**/
        ELSE do: /*IF AVAILABLE (bi2_parametre) THEN  DO:*/
            IF NOT CAN-FIND (FIRST ttmp1                                        
                             WHERE ttmp1.CODE_DO     = bi1_parametre.CODE_DO    
                             AND   ttmp1.CODE_PLF    = bi1_parametre.CODE_PLF   
                             AND   ttmp1.TYPE_PARAM  = bi1_parametre.TYPE_PARAM 
                             AND   ttmp1.CATEG_PARAM = bi1_parametre.CATEG_PARAM
                             AND   ttmp1.CODE_PARAM  = bi1_parametre.CODE_PARAM 
                              )                                                 
            AND                                                                 
                NOT CAN-FIND (FIRST ttmp2                                       
                             WHERE ttmp2.CODE_DO     = bi1_parametre.CODE_DO    
                             AND   ttmp2.CODE_PLF    = bi1_parametre.CODE_PLF   
                             AND   ttmp2.TYPE_PARAM  = bi1_parametre.TYPE_PARAM 
                             AND   ttmp2.CATEG_PARAM = bi1_parametre.CATEG_PARAM
                             AND   ttmp2.CODE_PARAM  = bi1_parametre.CODE_PARAM 
                              )                                                 
            THEN DO:
                    CREATE ttmp1.
                    CREATE ttmp2.
                    BUFFER-COPY bi1_parametre TO ttmp1 NO-ERROR.
                    ASSIGN                                                   
                             ttmp2.CODE_DO           =   bi1_parametre.CODE_DO     
                             ttmp2.CODE_PLF          =   bi1_parametre.CODE_PLF    
                             ttmp2.TYPE_PARAM        =   bi1_parametre.TYPE_PARAM  
                             ttmp2.CATEG_PARAM       =   bi1_parametre.CATEG_PARAM 
                             ttmp2.CODE_PARAM        =   bi1_parametre.CODE_PARAM . 
            END. /*IF NOT CAN-FIND (FIRST ttmp1*/
           
        
        END. /*ELSE de IF AVAILABLE (bi2_parametre) THEN*/
        END. /**/ 
  
             FOR EACH   bi2_parametre NO-LOCK :
                FIND FIRST bi1_parametre 
                     WHERE bi1_parametre.CODE_DO     = bi2_parametre.CODE_DO 
                       AND bi1_parametre.CODE_PLF    = bi2_parametre.CODE_PLF
                       AND bi1_parametre.TYPE_PARAM  = bi2_parametre.TYPE_PARAM 
                       AND bi1_parametre.CATEG_PARAM = bi2_parametre.CATEG_PARAM
                       AND bi1_parametre.CODE_PARAM  = bi2_parametre.CODE_PARAM 
                       /**/
                  NO-ERROR .
               
                IF NOT AVAILABLE (bi1_parametre) THEN DO :
                    IF NOT CAN-FIND (FIRST ttmp1                                        
                             WHERE ttmp1.CODE_DO     = bi2_parametre.CODE_DO    
                             AND   ttmp1.CODE_PLF    = bi2_parametre.CODE_PLF   
                             AND   ttmp1.TYPE_PARAM  = bi2_parametre.TYPE_PARAM 
                             AND   ttmp1.CATEG_PARAM = bi2_parametre.CATEG_PARAM
                             AND   ttmp1.CODE_PARAM  = bi2_parametre.CODE_PARAM 
                              )                                                 
                    AND                                                                 
                        NOT CAN-FIND (FIRST ttmp2                                       
                             WHERE ttmp2.CODE_DO     = bi2_parametre.CODE_DO    
                             AND   ttmp2.CODE_PLF    = bi2_parametre.CODE_PLF   
                             AND   ttmp2.TYPE_PARAM  = bi2_parametre.TYPE_PARAM 
                             AND   ttmp2.CATEG_PARAM = bi2_parametre.CATEG_PARAM
                             AND   ttmp2.CODE_PARAM  = bi2_parametre.CODE_PARAM 
                              )                                                 
                    THEN DO:
                    CREATE ttmp1.
                    CREATE ttmp2.

                    BUFFER-COPY bi2_parametre TO ttmp2 NO-ERROR.
                    ASSIGN                                                   
                             ttmp1.CODE_DO           =   bi2_parametre.CODE_DO     
                             ttmp1.CODE_PLF          =   bi2_parametre.CODE_PLF    
                             ttmp1.TYPE_PARAM        =   bi2_parametre.TYPE_PARAM  
                             ttmp1.CATEG_PARAM       =   bi2_parametre.CATEG_PARAM 
                             ttmp1.CODE_PARAM        =   bi2_parametre.CODE_PARAM . 
            END. /*IF NOT CAN-FIND (FIRST ttmp1*/
                END. /*IF NOT AVAILABLE (bi1_parametre) THEN DO : */
            END.
OUTPUT STREAM MyStream1 TO "C:\Users\yassi\Desktop\compare.csv".
PUT STREAM MyStream1 UNFORMATTED   /*3 instruction d'ecriture*/
        "CODE_PLF-1":L    ";":U
        "CODE_DO-1":L    ";":U
        "TYPE_PARAM-1":L    ";":U
        "CATEG_PARAM-1":L    ";":U
        "CODE_PARAM-1":L    ";":U
        "LIB_PARAM-1":L    ";":U
        "ZONE_NUM_1-1":L    ";":U
        "ZONE_NUM_2-1":L    ";":U
        "ZONE_NUM_3-1":L    ";":U
        "ZONE_NUM_4-1":L    ";":U
        "ZONE_NUM_5-1":L    ";":U
        "ZONE_ALPHA_1-1":L    ";":U
        "ZONE_ALPHA_2-1":L    ";":U
        "ZONE_ALPHA_3-1":L    ";":U
        "ZONE_ALPHA_4-1":L    ";":U
        "ZONE_ALPHA_5-1":L    ";":U
        "ZONE_DATE_1-1":L    ";":U
        "ZONE_DATE_2-1":L    ";":U
        "ZONE_DATE_3-1":L    ";":U
        "ZONE_DATE_4-1":L    ";":U
        "ZONE_DATE_5-1":L    ";":U
        "ZONE_LOG_1-1":L    ";":U
        "ZONE_LOG_2-1":L    ";":U
        "ZONE_LOG_3-1":L    ";":U
        "ZONE_LOG_4-1":L    ";":U
        "ZONE_LOG_5-1":L    ";":U
        "ZONE_NUM_6-1":L    ";":U
        "ZONE_ALPHA_6-1":L    ";":U
        "ZONE_DATE_6-1":L    ";":U
        "ZONE_LOG_6-1":L    ";":U
        "DATE_DER_MAJ-1":L    ";":U
        "HEURE_DER_MAJ-1":L    ";":U
        "NOM_UTIL_DER_MAJ-1":L    ";":U
        "NIVEAU-1":L    ";":U
        "CLASSIFICATION-1":L    ";":U
        "A_TRADUIRE-1":L    SKIP
        .
FOR EACH   ttmp1 EXCLUSIVE-LOCK:
/*     STREAM MyStream1 ttmp1 .*/
PUT STREAM MyStream1 UNFORMATTED   /*3 instruction d'ecriture*/
        ttmp1.CODE_PLF         ";":U
        ttmp1.CODE_DO           ";":U
        ttmp1.TYPE_PARAM         ";":U
        ttmp1.CATEG_PARAM        ";":U
        ttmp1.CODE_PARAM        ";":U
        ttmp1.LIB_PARAM        ";":U
        ttmp1.ZONE_NUM_1        ";":U
        ttmp1.ZONE_NUM_2        ";":U
        ttmp1.ZONE_NUM_3        ";":U
        ttmp1.ZONE_NUM_4        ";":U
        ttmp1.ZONE_NUM_5        ";":U
        ttmp1.ZONE_ALPHA_1        ";":U
        ttmp1.ZONE_ALPHA_2        ";":U
        ttmp1.ZONE_ALPHA_3        ";":U
        ttmp1.ZONE_ALPHA_4        ";":U
        ttmp1.ZONE_ALPHA_5        ";":U
        ttmp1.ZONE_DATE_1        ";":U
        ttmp1.ZONE_DATE_2        ";":U
        ttmp1.ZONE_DATE_3        ";":U
        ttmp1.ZONE_DATE_4        ";":U
        ttmp1.ZONE_DATE_5        ";":U
        ttmp1.ZONE_LOG_1        ";":U
        ttmp1.ZONE_LOG_2        ";":U
        ttmp1.ZONE_LOG_3        ";":U
        ttmp1.ZONE_LOG_4        ";":U
        ttmp1.ZONE_LOG_5        ";":U
        ttmp1.ZONE_NUM_6        ";":U
        ttmp1.ZONE_ALPHA_6         ";":U
        ttmp1.ZONE_DATE_6         ";":U
        ttmp1.ZONE_LOG_6         ";":U
        ttmp1.DATE_DER_MAJ         ";":U
        ttmp1.HEURE_DER_MAJ         ";":U
        ttmp1.NOM_UTIL_DER_MAJ       ";":U
        ttmp1.NIVEAU                  ";":U
        ttmp1.CLASSIFICATION       ";":U
        ttmp1.A_TRADUIRE          SKIP
        .
    END.
    OUTPUT STREAM MyStream1 CLOSE .
    
    OUTPUT STREAM MyStream2 TO "C:\Users\yassi\Desktop\environnement 2.csv".
PUT STREAM MyStream2 UNFORMATTED   /*3 instruction d'ecriture*/
        "CODE_PLF-1":L    ";":U
        "CODE_DO-1":L    ";":U
        "TYPE_PARAM-1":L    ";":U
        "CATEG_PARAM-1":L    ";":U
        "CODE_PARAM-1":L    ";":U
        "LIB_PARAM-1":L    ";":U
        "ZONE_NUM_1-1":L    ";":U
        "ZONE_NUM_2-1":L    ";":U
        "ZONE_NUM_3-1":L    ";":U
        "ZONE_NUM_4-1":L    ";":U
        "ZONE_NUM_5-1":L    ";":U
        "ZONE_ALPHA_1-1":L    ";":U
        "ZONE_ALPHA_2-1":L    ";":U
        "ZONE_ALPHA_3-1":L    ";":U
        "ZONE_ALPHA_4-1":L    ";":U
        "ZONE_ALPHA_5-1":L    ";":U
        "ZONE_DATE_1-1":L    ";":U
        "ZONE_DATE_2-1":L    ";":U
        "ZONE_DATE_3-1":L    ";":U
        "ZONE_DATE_4-1":L    ";":U
        "ZONE_DATE_5-1":L    ";":U
        "ZONE_LOG_1-1":L    ";":U
        "ZONE_LOG_2-1":L    ";":U
        "ZONE_LOG_3-1":L    ";":U
        "ZONE_LOG_4-1":L    ";":U
        "ZONE_LOG_5-1":L    ";":U
        "ZONE_NUM_6-1":L    ";":U
        "ZONE_ALPHA_6-1":L    ";":U
        "ZONE_DATE_6-1":L    ";":U
        "ZONE_LOG_6-1":L    ";":U
        "DATE_DER_MAJ-1":L    ";":U
        "HEURE_DER_MAJ-1":L    ";":U
        "NOM_UTIL_DER_MAJ-1":L    ";":U
        "NIVEAU-1":L    ";":U
        "CLASSIFICATION-1":L    ";":U
        "A_TRADUIRE-1":L    SKIP
        .
FOR EACH   ttmp2 EXCLUSIVE-LOCK:
/*     STREAM MyStream1 ttmp1 .*/
PUT STREAM MyStream2 UNFORMATTED   /*3 instruction d'ecriture*/
        ttmp2.CODE_PLF         ";":U
        ttmp2.CODE_DO           ";":U
        ttmp2.TYPE_PARAM         ";":U
        ttmp2.CATEG_PARAM        ";":U
        ttmp2.CODE_PARAM        ";":U
        ttmp2.LIB_PARAM        ";":U
        ttmp2.ZONE_NUM_1        ";":U
        ttmp2.ZONE_NUM_2        ";":U
        ttmp2.ZONE_NUM_3        ";":U
        ttmp2.ZONE_NUM_4        ";":U
        ttmp2.ZONE_NUM_5        ";":U
        ttmp2.ZONE_ALPHA_1        ";":U
        ttmp2.ZONE_ALPHA_2        ";":U
        ttmp2.ZONE_ALPHA_3        ";":U
        ttmp2.ZONE_ALPHA_4        ";":U
        ttmp2.ZONE_ALPHA_5        ";":U
        ttmp2.ZONE_DATE_1        ";":U
        ttmp2.ZONE_DATE_2        ";":U
        ttmp2.ZONE_DATE_3        ";":U
        ttmp2.ZONE_DATE_4        ";":U
        ttmp2.ZONE_DATE_5        ";":U
        ttmp2.ZONE_LOG_1        ";":U
        ttmp2.ZONE_LOG_2        ";":U
        ttmp2.ZONE_LOG_3        ";":U
        ttmp2.ZONE_LOG_4        ";":U
        ttmp2.ZONE_LOG_5        ";":U
        ttmp2.ZONE_NUM_6        ";":U
        ttmp2.ZONE_ALPHA_6         ";":U
        ttmp2.ZONE_DATE_6         ";":U
        ttmp2.ZONE_LOG_6         ";":U
        ttmp2.DATE_DER_MAJ         ";":U
        ttmp2.HEURE_DER_MAJ         ";":U
        ttmp2.NOM_UTIL_DER_MAJ       ";":U
        ttmp2.NIVEAU                  ";":U
        ttmp2.CLASSIFICATION       ";":U
        ttmp2.A_TRADUIRE          SKIP
        .
    END.
    OUTPUT STREAM MyStream2 CLOSE .
    
MESSAGE "success"
   VIEW-AS ALERT-BOX INFO BUTTONS OK.