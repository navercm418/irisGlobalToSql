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
    SET audNumber = ""
    
    IF qHandle '= "" {
        SET date = $PIECE(qHandle, ",", 1)
        SET time = $PIECE(qHandle, ",", 2)
        SET audNumber = $PIECE(qHandle, ",", 3)
        
        // Get next audit number for current date/time
        SET audNumber = $ORDER(@..#AUDITGLOBAL@(date, time, audNumber))
        IF audNumber = "" {
            // Move to next time when no more audit numbers
            SET time = $ORDER(@..#AUDITGLOBAL@(date, time))
            IF time '= "" SET audNumber = $ORDER(@..#AUDITGLOBAL@(date, time, ""))
        }
        IF time = "" {
            // Move to next date when no more times
            SET date = $ORDER(@..#AUDITGLOBAL@(date))
            IF date '= "" {
                SET time = $ORDER(@..#AUDITGLOBAL@(date, ""))
                IF time '= "" SET audNumber = $ORDER(@..#AUDITGLOBAL@(date, time, ""))
            }
        }
    } ELSE {
        // First call - get initial position
        SET date = $ORDER(@..#AUDITGLOBAL@(""))
        IF date '= "" {
            SET time = $ORDER(@..#AUDITGLOBAL@(date, ""))
            IF time '= "" SET audNumber = $ORDER(@..#AUDITGLOBAL@(date, time, ""))
        }
    }
    
    IF (date = "") || (time = "") || (audNumber = "") {
        SET AtEnd = 1
        SET qHandle = ""
        QUIT $$$OK
    }
    
    SET msg = $GET(@..#AUDITGLOBAL@(date, time, audNumber))
    SET line = $ZDATE(date,3)_" "_$ZTIME(time)_" ["_audNumber_"]: "_msg
    SET Row = $LISTBUILD(line)
    SET qHandle = date_","_time_","_audNumber
    SET AtEnd = 0
    
    QUIT $$$OK
}

ClassMethod ShowAuditClose(ByRef qHandle As %Binary) As %Status
{
    SET qHandle = ""
    QUIT $$$OK
}

}
