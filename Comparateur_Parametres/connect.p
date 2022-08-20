
/*------------------------------------------------------------------------
    File        : connect.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : yassi
    Created     : Thu Aug 18 11:09:54 WAT 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE INPUT PARAMETER   wi_Lib_domaine AS CHARACTER NO-UNDO .
DEFINE INPUT PARAMETER   wi_Lib_domaine1 AS CHARACTER NO-UNDO .
DEFINE OUTPUT PARAMETER   wNomBase AS CHARACTER NO-UNDO .
DEFINE OUTPUT PARAMETER   wNomBase1 AS CHARACTER NO-UNDO .
/*DEF VAR wNomBase        AS CHAR                 NO-UNDO.*/
DEF VAR wParamBase      AS CHAR                 NO-UNDO.
/*DEF VAR wNomBase1        AS CHAR                 NO-UNDO.*/
DEF VAR wParamBase1      AS CHAR                 NO-UNDO.
    
    /*lecture du contenu de fichier pf de la 2eme base */

    IF wi_Lib_domaine MATCHES "* -N ":U AND wi_Lib_domaine MATCHES " -S ":U AND wi_Lib_domaine MATCHES " -H *":U THEN DO:
        ASSIGN  wNomBase = ENTRY( 1, wi_lib_domaine, " ":U )
                wParamBase = wi_lib_domaine
                ENTRY( 1, wParamBase, " ":U ) = "":U.
                CONNECT VALUE( wNomBase )               /* Nom de la base */
                VALUE( wParamBase )             /* param de connexion */
                NO-ERROR.
                CREATE ALIAS VALUE ("LPFSEC":U) FOR DATABASE VALUE (wNomBase) .
                LEAVE.
    END. /*IF wi_Lib_domaine MATCHES "* -N ":U AND wi_Lib_domaine MATCHES " -S ":U AND wi_Lib_domaine MATCHES " -H *":U THEN DO:*/
    ELSE 
        CONNECT VALUE( wi_lib_domaine )  
            NO-ERROR.
                IF ERROR-STATUS:NUM-MESSAGES > 0
                    THEN DO:
                        MESSAGE ERROR-STATUS:GET-MESSAGE (1)
                        VIEW-AS ALERT-BOX.
                    END.
                ELSE DO:
                    MESSAGE "DB2 Connected":U
                    VIEW-AS ALERT-BOX.
                    ASSIGN wNomBase = ENTRY (NUM-ENTRIES (wi_lib_domaine, " ":U), wi_lib_domaine, " ":U).
                    MESSAGE "test :" wNomBase
                    VIEW-AS ALERT-BOX.
                    CREATE ALIAS VALUE ("LPFSEC":U) FOR DATABASE VALUE (wNomBase) .
        
    
                END. /*ELSE DO:*/
    
    /*lecture du contenu de fichier pf de la 1ere base */
        IF wi_Lib_domaine1 MATCHES "* -N ":U AND wi_Lib_domaine1 MATCHES " -S ":U AND wi_Lib_domaine1 MATCHES " -H *":U THEN DO:
        ASSIGN  wNomBase1 = ENTRY( 1, wi_Lib_domaine1, " ":U )
                wParamBase1 = wi_Lib_domaine1
                ENTRY( 1, wParamBase1, " ":U ) = "":U.
                CONNECT VALUE( wNomBase1 )               /* Nom de la base */
                VALUE( wParamBase1 )             /* param de connexion */
                NO-ERROR.
                CREATE ALIAS VALUE ("LPFRET":U) FOR DATABASE VALUE (wNomBase1) .
                LEAVE.
    END. /*IF wi_Lib_domaine MATCHES "* -N ":U AND wi_Lib_domaine MATCHES " -S ":U AND wi_Lib_domaine MATCHES " -H *":U THEN DO:*/
    ELSE 
        CONNECT VALUE( wi_lib_domaine1 )  
            NO-ERROR.
                IF ERROR-STATUS:NUM-MESSAGES > 0
                    THEN DO:
                        MESSAGE ERROR-STATUS:GET-MESSAGE (1)
                        VIEW-AS ALERT-BOX.
                    END.
                ELSE DO:
                    MESSAGE "DB1 Connected":U
                    VIEW-AS ALERT-BOX.
                    ASSIGN wNomBase1 = ENTRY (NUM-ENTRIES (wi_lib_domaine1, " ":U), wi_lib_domaine1, " ":U).
                    MESSAGE "test :" wNomBase1
                    VIEW-AS ALERT-BOX.
                    CREATE ALIAS VALUE ("LPFRET":U) FOR DATABASE VALUE (wNomBase1) .
        
    
                END. /*ELSE DO:*/
                
                
                
/*lancement de la comparaison */

/*RUN compare.p.                         */
/*                                       */
/*RUN compareJson.p(INPUT wNomBase1,     */
/*                      INPUT wNomBase ).*/
/*                                       */
