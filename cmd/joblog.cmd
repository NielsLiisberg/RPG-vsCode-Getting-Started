
    CMD        PROMPT('Put message into joblog') 

    PARM KWD(text) TYPE(*CHAR) LEN(2000) EXPR(*YES) CASE(*MIXED) min(1) VARY(*YES *INT2) PROMPT('Text')
    