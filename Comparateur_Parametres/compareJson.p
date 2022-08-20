BLOCK-LEVEL ON ERROR UNDO, THROW.
 
 DEFINE STREAM MyStream1.
 DEFINE STREAM MyStream2.
 
DEFINE BUFFER bi1_parametre FOR LPFRET.PARAMETRE.
DEFINE BUFFER bi2_parametre FOR LPFSEC.PARAMETRE.

DEFINE VARIABLE wg_comparaison AS LOGICAL NO-UNDO.


&SCOPED-DEFINE VAL_DB_1 wg_valDb1.

&SCOPED-DEFINE VAL_DB_2 wg_valDb2.

 

/*DEFINE INPUT PARAMETER  wg_valDb1 AS CHARACTER NO-UNDO.*/
/*                                                       */
/*DEFINE INPUT PARAMETER  wg_valDb2 AS CHARACTER NO-UNDO.*/

DEFINE VARIABLE  json AS LONGCHAR NO-UNDO.

DEFINE VARIABLE handleDataSet AS HANDLE NO-UNDO.


DEFINE TEMP-TABLE tt_listeParamDifferents NO-UNDO

    FIELD index_f AS CHARACTER SERIALIZE-NAME "INDEX":U
    
    FIELD existance AS CHARACTER SERIALIZE-NAME "EXISTANCE":U
    
    .

   

DEFINE TEMP-TABLE tt_listeDifferences NO-UNDO

    FIELD index_f   AS CHARACTER SERIALIZE-HIDDEN

    FIELD champ     AS CHARACTER SERIALIZE-NAME "CHAMP":U

    FIELD val_db1   AS CHARACTER SERIALIZE-NAME "DB1"

    FIELD val_db2   AS CHARACTER SERIALIZE-NAME "BD2".

DEFINE INPUT PARAMETER  NM_DB1 AS CHARACTER.

DEFINE INPUT PARAMETER  NM_DB2 AS CHARACTER.
/*                                            */
/*DEFINE VARIABLE nm_db1 AS CHARACTER NO-UNDO.*/
/*DEFINE VARIABLE nm_db2 AS CHARACTER NO-UNDO.*/



DEFINE TEMP-TABLE tt_bases NO-UNDO SERIALIZE-NAME "Liste des bases compare":U

    FIELD db1Name AS CHARACTER SERIALIZE-NAME "Nom Base 1":U

    FIELD db2Name AS CHARACTER SERIALIZE-NAME "Nom Base 2":U.


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE wg_valDb1  AS CHARACTER NO-UNDO.

DEFINE VARIABLE wg_valDb2  AS CHARACTER NO-UNDO.

ASSIGN  wg_valDb1 = "LPFSEC"

        wg_valDb2 = "LPFRET".




DEFINE DATASET DSActReporting

    FOR tt_bases, tt_listeParamDifferents, tt_listeDifferences

    DATA-RELATION RELATION1 FOR tt_listeParamDifferents, tt_listeDifferences RELATION-FIELDS (index_f, index_f) NESTED.





ASSIGN handleDataSet = DATASET DSActReporting:HANDLE.

CREATE tt_bases.

    ASSIGN tt_bases.db1Name = nm_db1.

    ASSIGN tt_bases.db2Name = nm_db2.



    FOR EACH   bi1_parametre NO-LOCK :
        FIND FIRST bi2_parametre
             WHERE bi2_parametre.CODE_DO     = bi1_parametre.CODE_DO
               AND bi2_parametre.CODE_PLF    = bi1_parametre.CODE_PLF
               AND bi2_parametre.TYPE_PARAM  = bi1_parametre.TYPE_PARAM
               AND bi2_parametre.CATEG_PARAM = bi1_parametre.CATEG_PARAM
               AND bi2_parametre.CODE_PARAM  = bi1_parametre.CODE_PARAM
               /**/
          NO-ERROR .

        IF AVAILABLE (bi2_parametre) THEN  DO:
/*                   THEN  DO:*/
           BUFFER-COMPARE bi1_parametre
           TO bi2_parametre
           SAVE RESULT in wg_comparaison.
           IF NOT wg_comparaison
                  THEN  DO:
           
            CREATE tt_listeParamDifferents.
            ASSIGN tt_listeParamDifferents.index_f =
                                                        bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM
             tt_listeParamDifferents.existance="1 et 2"
             .




        IF  bi1_parametre.LIB_PARAM  <> bi2_parametre.LIB_PARAM
        THEN DO:
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "LIB_PARAM"

                tt_listeDifferences.val_db1 = bi1_parametre.LIB_PARAM

                tt_listeDifferences.val_db2 = bi2_parametre.LIB_PARAM .
        END.

        IF bi1_parametre.ZONE_NUM_1  <> bi2_parametre.ZONE_NUM_1
        THEN DO:
        CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_1"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_NUM_1)

                tt_listeDifferences.val_db2 =STRING( bi2_parametre.ZONE_NUM_1) .
        END.



        IF bi1_parametre.ZONE_NUM_2  <> bi2_parametre.ZONE_NUM_2
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_2"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_NUM_2)

                tt_listeDifferences.val_db2 =STRING(bi2_parametre.ZONE_NUM_2) .
        END.



        IF bi1_parametre.ZONE_NUM_3  <>  bi2_parametre.ZONE_NUM_3
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_3"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_NUM_3)

                tt_listeDifferences.val_db2 = STRING(bi2_parametre.ZONE_NUM_3) .
        END.



        IF bi1_parametre.ZONE_NUM_4  <>  bi2_parametre.ZONE_NUM_4
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_4"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_NUM_4)

                tt_listeDifferences.val_db2 =STRING( bi2_parametre.ZONE_NUM_4) .
        END.



        IF bi1_parametre.ZONE_NUM_5  <>  bi2_parametre.ZONE_NUM_5
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_5"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_NUM_5)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_NUM_5) .
        END.



        IF bi1_parametre.ZONE_ALPHA_1  <>  bi2_parametre.ZONE_ALPHA_1
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_1"

                tt_listeDifferences.val_db1 = bi1_parametre.ZONE_ALPHA_1

                tt_listeDifferences.val_db2 = bi2_parametre.ZONE_ALPHA_1 .
        END.



        IF bi1_parametre.ZONE_ALPHA_2  <>  bi2_parametre.ZONE_ALPHA_2
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_2"

                tt_listeDifferences.val_db1 = bi1_parametre.ZONE_ALPHA_2

                tt_listeDifferences.val_db2 = bi2_parametre.ZONE_ALPHA_2 .
        END.



        IF bi1_parametre.ZONE_ALPHA_3   <>  bi2_parametre.ZONE_ALPHA_3
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_3"

                tt_listeDifferences.val_db1 = bi1_parametre.ZONE_ALPHA_3

                tt_listeDifferences.val_db2 = bi2_parametre.ZONE_ALPHA_3 .
        END.




        IF bi1_parametre.ZONE_ALPHA_4   <>  bi2_parametre.ZONE_ALPHA_4
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_4"

                tt_listeDifferences.val_db1 = bi1_parametre.ZONE_ALPHA_4

                tt_listeDifferences.val_db2 = bi2_parametre.ZONE_ALPHA_4 .
        END.



        IF bi1_parametre.ZONE_ALPHA_5   <>  bi2_parametre.ZONE_ALPHA_5
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_5"

                tt_listeDifferences.val_db1 = bi1_parametre.ZONE_ALPHA_5

                tt_listeDifferences.val_db2 = bi2_parametre.ZONE_ALPHA_5 .
        END.



        IF bi1_parametre.ZONE_DATE_1    <>  bi2_parametre.ZONE_DATE_1
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_1"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_DATE_1)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_DATE_1) .
        END.

        IF bi1_parametre.ZONE_DATE_2    <>  bi2_parametre.ZONE_DATE_2
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_2"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_DATE_2)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_DATE_2) .
        END.



        IF bi1_parametre.ZONE_DATE_3    <>  bi2_parametre.ZONE_DATE_3
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_3"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_DATE_3)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_DATE_3) .
        END.



        IF bi1_parametre.ZONE_DATE_4    <>  bi2_parametre.ZONE_DATE_4
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_4"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_DATE_4)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_DATE_4) .
        END.



        IF bi1_parametre.ZONE_DATE_5    <>  bi2_parametre.ZONE_DATE_5
        THEN DO:
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_5"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_DATE_5)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_DATE_5) .
        END.



        IF bi1_parametre.ZONE_LOG_1   <>  bi2_parametre.ZONE_LOG_1
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_1"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_LOG_1)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_LOG_1) .
        END.



        IF bi1_parametre.ZONE_LOG_2     <>     bi2_parametre.ZONE_LOG_2
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_2"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_LOG_2)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_LOG_2) .
        END.



        IF bi1_parametre.ZONE_LOG_3     <>     bi2_parametre.ZONE_LOG_3
        THEN DO:
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_3"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_LOG_3)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_LOG_3) .
        END.



        IF bi1_parametre.ZONE_LOG_4     <>      bi2_parametre.ZONE_LOG_4
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_4"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_LOG_4)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_LOG_4) .
        END.



        IF bi1_parametre.ZONE_LOG_5     <>      bi2_parametre.ZONE_LOG_5
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_5"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_LOG_5)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_LOG_5) .
        END.




        IF bi1_parametre.ZONE_NUM_6     <>      bi2_parametre.ZONE_NUM_6
        THEN DO:
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_6"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_NUM_6)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_NUM_6) .
        END.



        IF bi1_parametre.ZONE_ALPHA_6       <>      bi2_parametre.ZONE_ALPHA_6
        THEN DO:
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_6"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_ALPHA_6)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_ALPHA_6) .
        END.



        IF bi1_parametre.ZONE_DATE_6        <>      bi2_parametre.ZONE_DATE_6
        THEN DO:
           CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_6"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_DATE_6)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_DATE_6) .
        END.



        IF bi1_parametre.ZONE_LOG_6     <>      bi2_parametre.ZONE_LOG_6
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_6"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.ZONE_LOG_6)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.ZONE_LOG_6) .
        END.



        IF bi1_parametre.DATE_DER_MAJ       <>      bi2_parametre.DATE_DER_MAJ
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "DATE_DER_MAJ"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.DATE_DER_MAJ)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.DATE_DER_MAJ) .
        END.



        IF bi1_parametre.HEURE_DER_MAJ      <>      bi2_parametre.HEURE_DER_MAJ
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "HEURE_DER_MAJ"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.HEURE_DER_MAJ)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.HEURE_DER_MAJ) .
        END.



        IF bi1_parametre.NOM_UTIL_DER_MAJ       <>      bi2_parametre.NOM_UTIL_DER_MAJ
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "NOM_UTIL_DER_MAJ"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.NOM_UTIL_DER_MAJ)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.NOM_UTIL_DER_MAJ) .
        END.



        IF bi1_parametre.NIVEAU     <>      bi2_parametre.NIVEAU
        THEN DO:
           CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "NIVEAU"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.NIVEAU)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.NIVEAU) .
        END.



        IF bi1_parametre.CLASSIFICATION<>bi2_parametre.CLASSIFICATION
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "CLASSIFICATION"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.CLASSIFICATION)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.CLASSIFICATION) .
        END.

        IF bi1_parametre.A_TRADUIRE     <>      bi2_parametre.A_TRADUIRE
        THEN DO :
            CREATE tt_listeDifferences.

            ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "A_TRADUIRE"

                tt_listeDifferences.val_db1 =STRING( bi1_parametre.A_TRADUIRE)

                tt_listeDifferences.val_db2 = STRING( bi2_parametre.A_TRADUIRE) .
        END.
        END.
        END.
        ELSE DO: /*IF AVAILABLE (bi2_parametre) THEN  DO:*/
            CREATE tt_listeParamDifferents.
            ASSIGN tt_listeParamDifferents.index_f =
                                                        bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM
             tt_listeParamDifferents.existance="1 seulement"
             .
             
             CREATE tt_listeDifferences.

             ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "LIB_PARAM"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.LIB_PARAM)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_1"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_NUM_1)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_2"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_NUM_2)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_3"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_NUM_3)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_4"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_NUM_4)

                tt_listeDifferences.val_db2 ="" .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_5"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_NUM_5)

                tt_listeDifferences.val_db2 ="" .
             
             
                             CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_1"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_ALPHA_1)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_2"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_ALPHA_2)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_3"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_ALPHA_3)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_4"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_ALPHA_4)

                tt_listeDifferences.val_db2 ="" .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_5"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_ALPHA_5)

                tt_listeDifferences.val_db2 ="" .
             
             
                                          CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_1"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_DATE_1)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_2"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_DATE_2)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_3"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_DATE_3)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_4"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_DATE_4)

                tt_listeDifferences.val_db2 ="" .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_5"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_DATE_5)

                tt_listeDifferences.val_db2 ="" .
             
             
             
                                                       CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_1"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_LOG_1)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_2"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_LOG_2)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_3"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_LOG_3)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_4"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_LOG_4)

                tt_listeDifferences.val_db2 ="" .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_5"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_LOG_5)

                tt_listeDifferences.val_db2 ="" .
             
             
               CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_6"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_NUM_6)

                tt_listeDifferences.val_db2 ="" .
             
             
             CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_6"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_ALPHA_6)

                tt_listeDifferences.val_db2 ="" .
             
             
             CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_6"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_DATE_6)

                tt_listeDifferences.val_db2 ="" .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_6"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.ZONE_LOG_6)

                tt_listeDifferences.val_db2 ="" .
             
                    
                    
                    CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "DATE_DER_MAJ"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.DATE_DER_MAJ)

                tt_listeDifferences.val_db2 ="" .
                
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "HEURE_DER_MAJ"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.HEURE_DER_MAJ)

                tt_listeDifferences.val_db2 ="" .
                
                
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "NOM_UTIL_DER_MAJ"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.NOM_UTIL_DER_MAJ)

                tt_listeDifferences.val_db2 ="" .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "NIVEAU"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.NIVEAU)

                tt_listeDifferences.val_db2 ="" .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "CLASSIFICATION"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.CLASSIFICATION)

                tt_listeDifferences.val_db2 ="" .
                
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi1_parametre.CODE_DO + "/"
                                                        + bi1_parametre.CODE_PLF + "/"
                                                        + bi1_parametre.TYPE_PARAM + "/"
                                                        + bi1_parametre.CATEG_PARAM + "/"
                                                        + bi1_parametre.CODE_PARAM

                tt_listeDifferences.champ = "A_TRADUIRE"

                tt_listeDifferences.val_db1 = STRING (bi1_parametre.A_TRADUIRE)

                tt_listeDifferences.val_db2 ="" .
                
                
                
            END. /*ELSE do:*/


     END. /*FOR EACH   bi1_parametre NO-LOCK */


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
                   
                   
                   CREATE tt_listeParamDifferents.
            ASSIGN tt_listeParamDifferents.index_f =
                                                        bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM
             tt_listeParamDifferents.existance="2 seulement"
             .
             
             CREATE tt_listeDifferences.

             ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "LIB_PARAM"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.LIB_PARAM) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_1"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_NUM_1) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_2"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_NUM_2) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_3"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_NUM_3).
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_4"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_NUM_4) .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_5"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_NUM_5) .
             
             
                             CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_1"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_ALPHA_1) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_2"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_ALPHA_2) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_3"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_ALPHA_3) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_4"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_ALPHA_4) .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_5"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_ALPHA_5) .
             
             
                                          CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_1"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_DATE_1) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_2"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_DATE_2) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_3"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_DATE_3) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_4"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_DATE_4) .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_5"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_DATE_5) .
             
             
             
                                                       CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_1"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_LOG_1) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_2"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_LOG_2) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_3"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_LOG_3) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_4"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_LOG_4) .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_5"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_LOG_5) .
             
             
               CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_NUM_6"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_NUM_6) .
             
             
             CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_ALPHA_6"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_ALPHA_6) .
             
             
             CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_DATE_6"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_DATE_6) .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "ZONE_LOG_6"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_LOG_6) .
             
                    
                    
                    CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "DATE_DER_MAJ"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.ZONE_LOG_6) .
                
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "HEURE_DER_MAJ"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.HEURE_DER_MAJ) .
                
                
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "NOM_UTIL_DER_MAJ"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.NOM_UTIL_DER_MAJ) .
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "NIVEAU"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.NIVEAU) .
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "CLASSIFICATION"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.CLASSIFICATION) .
                
                
                
                CREATE tt_listeDifferences.

                ASSIGN

                tt_listeDifferences.index_f = bi2_parametre.CODE_DO + "/"
                                                        + bi2_parametre.CODE_PLF + "/"
                                                        + bi2_parametre.TYPE_PARAM + "/"
                                                        + bi2_parametre.CATEG_PARAM + "/"
                                                        + bi2_parametre.CODE_PARAM

                tt_listeDifferences.champ = "A_TRADUIRE"

                tt_listeDifferences.val_db1 = ""

                tt_listeDifferences.val_db2 =STRING (bi2_parametre.A_TRADUIRE) .
                
                
                
                
                   
                END. /*IF NOT AVAILABLE (bi1_parametre) THEN DO : */
            END.
OUTPUT STREAM MyStream1 TO "C:\Users\yassi\Desktop\environnement 1.csv".

MESSAGE "success"
   VIEW-AS ALERT-BOX INFO BUTTONS OK.

   
DATASET DSActReporting:SERIALIZE-HIDDEN = TRUE.

handleDataSet:WRITE-JSON ("LONGCHAR":U, json, FALSE, "UTF-8":U).

 

OUTPUT TO VALUE ("C:\Users\yassi\Desktop\enonce.txt").

PUT UNFORMATTED STRING(json).

OUTPUT CLOSE.

