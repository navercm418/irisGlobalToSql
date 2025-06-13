Class User.scrAudSql Extends %RegisteredObject
{

// Change SCRAUD to your desired global name, for example MYAUDIT

Parameter AUDITGLOBAL = "^SCRAUD";

Query ShowAudit() As %Query(ROWSPEC = "AuditMessage:%String") [ SqlProc ]
{
}

ClassMethod ShowAuditExecute(ByRef qHandle As %Binary) As %Status
{
    SET qHandle = ""
    QUIT $$$OK
}

ClassMethod ShowAuditFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
    SET date = ""
    SET time = ""
    
    IF qHandle '= "" {
        SET date = $PIECE(qHandle, ",", 1)
        SET time = $PIECE(qHandle, ",", 2)
        SET time = $ORDER(@..#AUDITGLOBAL@(date, time))
        IF time = "" {
            SET date = $ORDER(@..#AUDITGLOBAL@(date))
            IF date '= "" SET time = $ORDER(@..#AUDITGLOBAL@(date, ""))
        }
    } ELSE {
        SET date = $ORDER(@..#AUDITGLOBAL@(""))
        IF date '= "" SET time = $ORDER(@..#AUDITGLOBAL@(date, ""))
    }
    
    IF (date = "") || (time = "") {
        SET AtEnd = 1
        SET qHandle = ""
        QUIT $$$OK
    }
    
    SET msg = $GET(@..#AUDITGLOBAL@(date, time))
    SET line = $ZDATE(date,3)_" "_$ZTIME(time)_": "_msg
    SET Row = $LISTBUILD(line)
    SET qHandle = date_","_time
    SET AtEnd = 0
    
    QUIT $$$OK
}

ClassMethod ShowAuditClose(ByRef qHandle As %Binary) As %Status
{
    SET qHandle = ""
    QUIT $$$OK
}

}
