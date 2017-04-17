      ******************************************************************
      * Author: Lauryn Brown
      * Date: 2017
      * Purpose: COBOL Common Lisp Interpreter
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CISP.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT LISP-FILE ASSIGN TO DYNAMIC LISP-NAME
               ORGANISATION IS LINE SEQUENTIAL.
           SELECT OPTIONAL CALL-STACK ASSIGN TO "stack.dat"
               ORGANIZATION IS INDEXED
               ACCESS IS RANDOM
               RECORD KEY IS COMMAND-ID.
           SELECT OPTIONAL LOG-FILE ASSIGN TO DYNAMIC LOG-FILE-NAME
               ORGANISATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
           FD LISP-FILE.
           01 IN-LISP-RECORD PIC X(2000).
           FD CALL-STACK.
           01 CALL-STACK-FILE.
               02 COMMAND-ID PIC 9(5).
               02 COMMAND-NAME PIC X(20).
               02 COMMAND-RESULT PIC X(20).
               02 COMMAND-RESULT-NUMERIC PIC 9(20).
           FD LOG-FILE.
           01 LOG-RECORD.
               02 LOG-RECORD-ID PIC 9(10).
               02 LOG-RECORD-FUNCTION-NAME PIC X(40).
               02 LOG-RECORD-MESSAGE PIC X(100).
       WORKING-STORAGE SECTION.
       01 WS-LOG-RECORD.
           02 WS-LOG-RECORD-ID PIC 9(10).
           02 WS-LOG-RECORD-FUNCTION-NAME PIC X(40).
           02 WS-LOG-RECORD-MESSAGE PIC X(100).
       78 WS-SYMBOL-LENGTH VALUE 5.
       01 WS-LISP-SYMBOLS.
           02 WS-SYMBOL-TABLE-SIZE PIC 9.
           02 WS-SYMBOL PIC X(100) OCCURS WS-SYMBOL-LENGTH TIMES.
       01 WS-COUNT PIC 9(10).
       01 STRING-PTR PIC 9(10).
       01 WS-TEMP-NUM PIC 9(10).
       01 WS-FLAG PIC A(1).
           88 WS-FLAG-YES VALUE 'Y', FALSE 'N'.
       01 WS-SYMBOL-FLAGS.
           02 WS-OPEN-PAREN PIC X.
               88 WS-OPEN-PAREN-YES VALUE 'Y', FALSE 'N'.
           02 WS-CLOSE-PAREN PIC X.
               88 WS-CLOSE-PAREN-YES VALUE 'Y', FALSE 'N'.
      *     02 WS-SYMBOL-SUBSCRIPT PIC S9(3) COMP-3.
       01 WS-PARSE-STR.
           02 WS-PARSE-STR-INDEX PIC 9(5).
           02 WS-PARSE-STR-END PIC X.
               88 WS-PARSE-HAS-ENDED VALUE 'Y', FALSE 'N'.
           02 WS-PARSE-STR-CHAR PIC X.
           02 WS-PARSE-EXPRESSION-START PIC 9(5).
           02 WS-PARSE-EXPRESSION-END PIC 9(5).
           02 WS-PARSE-EXPRESSION-LEN PIC 9(5).
       01 WS-CURR-COMMAND PIC X(100).
       01 WS-CALL-STACK.
           02 WS-COMMAND-ID PIC 9(5).
           02 WS-COMMAND-NAME PIC X(20).
           02 WS-COMMAND-RESULT PIC X(20).
           02 WS-COMMAND-RESULT-NUMERIC PIC 9(20).
       01 WS-CALL-STACK-EOF PIC A(1).
       01 WS-CALL-STACK-NEXT-ID PIC 9(5).
       01 WS-IS-LAST-EXPRESSION PIC X.
           88 WS-IS-LAST-EXPRESSION-YES VALUE 'Y', FALSE 'N'.
      * 77 TEMP-STACK-AREA PIC X ANY LENGTH.
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM LOG-INIT-PROCEDURE.
           PERFORM FILE-HANDLING-PROCEDURE.
           MOVE "MAIN-PROCEDURE" TO WS-LOG-RECORD-FUNCTION-NAME.
           MOVE "COMPLETED FILE-HANDLING-PROCEDURE"
             TO WS-LOG-RECORD-MESSAGE.
           PERFORM LOG-WRITE-TO-PROCEDURE.
           PERFORM LISP-PROCEDURE.
           MOVE "MAIN-PROCEDURE" TO WS-LOG-RECORD-FUNCTION-NAME.
           MOVE "COMPLETED LISP-PROCEDURE"
             TO WS-LOG-RECORD-MESSAGE.
           PERFORM LOG-WRITE-TO-PROCEDURE.
           STOP RUN.
       LOG-INIT-PROCEDURE.
           MOVE '..\logs\log.data' TO LOG-FILE-NAME.
           OPEN OUTPUT LOG-FILE.
           MOVE 1 TO LOG-RECORD-ID.
           MOVE "LOG-INIT-PROCEDURE" TO LOG-RECORD-FUNCTION-NAME.
           MOVE "Starting Program!" TO LOG-RECORD-MESSAGE.
           WRITE LOG-RECORD.
       LOG-WRITE-TO-PROCEDURE.
           ADD 1 TO LOG-RECORD-ID.
           MOVE WS-LOG-RECORD-FUNCTION-NAME TO LOG-RECORD-FUNCTION-NAME.
           MOVE WS-LOG-RECORD-MESSAGE TO LOG-RECORD-MESSAGE.
           WRITE LOG-RECORD.
       GET-FILE-NAME-PROCEDURE.
           ACCEPT LISP-NAME.
           IF LISP-NAME EQUALS SPACES THEN
               MOVE "..\test\arithmetic.lisp" TO LISP-NAME
           END-IF.
       FILE-HANDLING-PROCEDURE.
           PERFORM GET-FILE-NAME-PROCEDURE.
           OPEN INPUT LISP-FILE.
           READ LISP-FILE.
      *     DISPLAY IN-LISP-RECORD.
           CLOSE LISP-FILE.
       LISP-PROCEDURE.
           PERFORM UNSTRING-LISP-PROCEDURE.
      *******log completion
           MOVE "LISP-PROCEDURE" TO WS-LOG-RECORD-FUNCTION-NAME.
           MOVE "COMPLETED UNSTRING-LISP-PROCEDURE"
             TO WS-LOG-RECORD-MESSAGE.
           PERFORM LOG-WRITE-TO-PROCEDURE.
      ******
           PERFORM EVALUATE-LISP-PRCEDURE.
       EVALUATE-LISP-PRCEDURE.
           PERFORM INIT-CALL-STACK-PROCEDURE.
           PERFORM VARYING WS-COUNT FROM 1 BY 1 UNTIL
           WS-COUNT > WS-SYMBOL-TABLE-SIZE
               PERFORM PARSE-STRING-PROCEDURE
               MOVE WS-SYMBOL(WS-COUNT)
               (WS-PARSE-EXPRESSION-START:WS-PARSE-EXPRESSION-LEN)
               TO WS-CURR-COMMAND
      ******log Current Command To be Executed
               MOVE 'EVALUATE-LISP-PRCEDURE'
               TO WS-LOG-RECORD-FUNCTION-NAME
               STRING 'Command:' DELIMITED BY SIZE
               WS-CURR-COMMAND DELIMITED BY SIZE
               INTO WS-LOG-RECORD-MESSAGE
               PERFORM LOG-WRITE-TO-PROCEDURE
      ************
               PERFORM PRINT-PARSE-FLAGS-PROCEDURE
               PERFORM EVALUATE-CURRENT-COMMAND
               PERFORM PRINT-CALL-STACK-PROCEDURE
           END-PERFORM.
           PERFORM PRINT-CALL-STACK-PROCEDURE.
           PERFORM CLOSE-CALL-STACK-PROCEDURE.
       EVALUATE-CURRENT-COMMAND.
           EVALUATE WS-CURR-COMMAND
           WHEN "write"
               PERFORM LISP-WRITE-PROCEDURE
           WHEN "+"
               IF WS-OPEN-PAREN-YES THEN
                   MOVE 0 TO WS-COMMAND-RESULT-NUMERIC
               END-IF
               PERFORM LISP-ADD-PROCEDURE
           WHEN OTHER
               IF WS-CURR-COMMAND(1:WS-PARSE-EXPRESSION-LEN) IS NUMERIC THEN

                   MOVE WS-CURR-COMMAND TO WS-COMMAND-RESULT-NUMERIC
                   DISPLAY "NUMERIC:" WS-COMMAND-RESULT-NUMERIC
                   PERFORM LISP-EVAL-LAST-EXPRESSION
               ELSE
                   Display "OTHER"
               END-IF
           .
           IF WS-CLOSE-PAREN-YES THEN
               DISPLAY "FINISHED:" WS-CALL-STACK " AND " CALL-STACK-FILE
               PERFORM CALL-STACK-DELETE-PROCEDURE
           END-IF.

       LISP-WRITE-PROCEDURE.
           DISPLAY "WRITE".
           PERFORM RECURSION-PROCEDURE.
       LISP-ADD-PROCEDURE.
           DISPLAY "ADD:" WS-COMMAND-RESULT-NUMERIC
           " AND " COMMAND-RESULT-NUMERIC.
           ADD COMMAND-RESULT-NUMERIC TO WS-COMMAND-RESULT-NUMERIC.
           DISPLAY "RESULT:" WS-COMMAND-RESULT-NUMERIC.
           IF WS-OPEN-PAREN-YES THEN
               PERFORM RECURSION-PROCEDURE
           END-IF.
       LISP-EVAL-LAST-EXPRESSION.
           SET  WS-IS-LAST-EXPRESSION-YES TO TRUE.
           MOVE WS-CALL-STACK-NEXT-ID TO COMMAND-ID.
           SUBTRACT 1 FROM COMMAND-ID.
           READ CALL-STACK
               KEY IS COMMAND-ID
           END-READ.

           MOVE COMMAND-NAME TO WS-CURR-COMMAND.
           PERFORM EVALUATE-CURRENT-COMMAND.

           IF NOT WS-CLOSE-PAREN-YES THEN
               PERFORM MOVE-WS-TO-CALL-STACK
               REWRITE CALL-STACK-FILE
               END-REWRITE
           END-IF.
           SET WS-IS-LAST-EXPRESSION-YES TO FALSE.

       RECURSION-PROCEDURE.
           MOVE WS-CALL-STACK-NEXT-ID TO WS-COMMAND-ID.
           MOVE WS-CURR-COMMAND TO WS-COMMAND-NAME.
           PERFORM CALL-STACK-ADD-PROCEDURE.
       INIT-CALL-STACK-PROCEDURE.
      * Preventing the error of something already being in the
      * stack file after a system crash
           OPEN OUTPUT CALL-STACK.
           CLOSE CALL-STACK.
           OPEN I-O CALL-STACK.
           MOVE 1 TO WS-CALL-STACK-NEXT-ID.
       CLOSE-CALL-STACK-PROCEDURE.
           CLOSE CALL-STACK.
           DELETE FILE CALL-STACK.
       MOVE-CALL-STACK-TO-WS.
           MOVE COMMAND-ID TO WS-COMMAND-ID.
           MOVE COMMAND-NAME TO WS-COMMAND-NAME.
           MOVE COMMAND-RESULT TO WS-COMMAND-RESULT.
           MOVE COMMAND-RESULT-NUMERIC TO WS-COMMAND-RESULT-NUMERIC.
       MOVE-WS-TO-CALL-STACK.
           MOVE WS-COMMAND-ID TO COMMAND-ID.
           MOVE WS-COMMAND-NAME TO COMMAND-NAME.
           MOVE WS-COMMAND-RESULT TO COMMAND-RESULT.
           MOVE WS-COMMAND-RESULT-NUMERIC TO COMMAND-RESULT-NUMERIC.
       CALL-STACK-ADD-PROCEDURE.
           PERFORM MOVE-WS-TO-CALL-STACK.
           WRITE CALL-STACK-FILE.
           ADD 1 TO WS-CALL-STACK-NEXT-ID.
       PRINT-CALL-STACK-PROCEDURE.
           PERFORM VARYING COMMAND-ID FROM 1 BY 1
           UNTIL COMMAND-ID = WS-CALL-STACK-NEXT-ID
               READ CALL-STACK RECORD INTO WS-CALL-STACK
                   KEY IS COMMAND-ID
                   NOT INVALID KEY DISPLAY WS-CALL-STACK
               END-READ
           END-PERFORM.
       CALL-STACK-DELETE-PROCEDURE.
      *     MOVE WS-CURR-COMMAND-ID TO COMMAND-ID.
           MOVE CALL-STACK-FILE TO WS-CALL-STACK.
           DELETE CALL-STACK RECORD
               INVALID KEY DISPLAY "INVALID KEY"
               NOT INVALID KEY DISPLAY "RECORD Deleted"
           END-DELETE.

       RESET-PARSE-FLAGS-PROCEDURE.
           SET WS-OPEN-PAREN-YES TO FALSE.
           SET WS-CLOSE-PAREN-YES TO FALSE.
           MOVE 0 TO WS-PARSE-EXPRESSION-START.
           MOVE 0 TO WS-PARSE-EXPRESSION-END.
           MOVE 0 TO WS-PARSE-EXPRESSION-LEN.
       PRINT-PARSE-FLAGS-PROCEDURE.
           DISPLAY 'Open Paren:' WS-OPEN-PAREN.
           DISPLAY 'Close Paren:' WS-CLOSE-PAREN.
           DISPLAY 'Expression Start:' WS-PARSE-EXPRESSION-START.
           DISPLAY 'Expression END:' WS-PARSE-EXPRESSION-END.
           DISPLAY 'Expression Length:' WS-PARSE-EXPRESSION-LEN.
       PARSE-STRING-PROCEDURE.
           PERFORM RESET-PARSE-FLAGS-PROCEDURE.
           MOVE 1 TO WS-PARSE-STR-INDEX.
           SET WS-PARSE-HAS-ENDED TO FALSE.
           PERFORM VARYING WS-PARSE-STR-INDEX FROM 1 BY 1
           UNTIL WS-PARSE-HAS-ENDED
              MOVE WS-SYMBOL(WS-COUNT)(WS-PARSE-STR-INDEX:1)
              TO WS-PARSE-STR-CHAR
              EVALUATE WS-PARSE-STR-CHAR
              WHEN '('
                  SET WS-OPEN-PAREN-YES TO TRUE

              WHEN ')'
                   SET WS-CLOSE-PAREN-YES TO TRUE
              WHEN ' '
                   SET WS-PARSE-HAS-ENDED TO TRUE
                   MOVE WS-PARSE-STR-INDEX TO WS-PARSE-EXPRESSION-END
                   SUBTRACT 1 FROM WS-PARSE-EXPRESSION-END
              WHEN OTHER
                   IF WS-PARSE-EXPRESSION-START = 0 THEN
                       MOVE WS-PARSE-STR-INDEX
                       TO WS-PARSE-EXPRESSION-START
                    END-IF
                    ADD 1 TO WS-PARSE-EXPRESSION-LEN
           END-PERFORM.
       UNSTRING-LISP-PROCEDURE.
           MOVE 1 TO STRING-PTR.
           MOVE 0 TO WS-SYMBOL-TABLE-SIZE.
           SET WS-FLAG-YES TO FALSE.
           PERFORM VARYING WS-COUNT FROM 1 BY 1 UNTIL
             WS-COUNT > WS-SYMBOL-LENGTH
             OR WS-FLAG
               UNSTRING IN-LISP-RECORD DELIMITED BY ALL ' ' INTO
               WS-SYMBOL(WS-COUNT) WITH POINTER STRING-PTR
               IF WS-SYMBOL(WS-COUNT) = SPACES THEN
                   SET WS-FLAG-YES TO TRUE
               ELSE
                   ADD 1 TO WS-SYMBOL-TABLE-SIZE
               END-IF
           END-PERFORM.
           DISPLAY "TABLE SIZE:" WS-SYMBOL-TABLE-SIZE.
      *     DISPLAY "LISP PROCEDURE".
      *     PERFORM PRINT-SYMBOL-TABLE.
       PRINT-SYMBOL-TABLE.
           MOVE 1 TO WS-COUNT.
           PERFORM VARYING WS-COUNT FROM 1 BY 1 UNTIL
           WS-COUNT GREATER THAN WS-SYMBOL-LENGTH
               DISPLAY WS-COUNT
               DISPLAY WS-SYMBOL(WS-COUNT)
           END-PERFORM.
       END PROGRAM CISP.
