# SQL Query Interface for InterSystems IRIS Globals

## Overview
Create SQL queries for non-mapped IRIS globals with ease. This solution provides a flexible pattern that can be adapted to query any global with a similar structure, enabling SQL functionality without direct SQL mapping.

## Features
- Query globals using standard SQL syntax
- Apply WHERE clauses and filtering
- Sort results with ORDER BY
- Compatible with SQL reporting tools
- Easy to customize for different global structures

## Global Structure
The example uses a three-level global structure:
```
^GLOBAL
    |-- date ($H format)
        |-- time (seconds)
            |-- message (string)
```

## Installation

1. Import the class:
```objectscript
do $system.OBJ.Load("User/scrAudSql.cls", "ck")
```

2. Configure your global name:
```objectscript
// In User/scrAudSql.cls
Parameter AUDITGLOBAL = "^YOURGLOBAL";
```

## Usage Examples

### Basic Query
```sql
SELECT * FROM SQLUser.scrAudSql_ShowAudit()
```

### Filtered Query
```sql
-- Search for specific text
SELECT * FROM SQLUser.scrAudSql_ShowAudit()
WHERE AuditMessage LIKE '%error%'

-- Filter by date
SELECT * FROM SQLUser.scrAudSql_ShowAudit()
WHERE AuditMessage LIKE '2025-06-%'
```

## Customization Guide

### Modifying Row Structure
```objectscript
// Adjust ROWSPEC for different columns
Query ShowAudit() As %Query(ROWSPEC = "YourColumn:%String") [ SqlProc ]
```

### Changing Output Format
```objectscript
// Modify the line formatting in Fetch method
SET line = $ZDATE(date,3)_" "_$ZTIME(time)_": "_msg
```

## Technical Requirements
- InterSystems IRIS 2021.1+
- READ access to target global
- USER namespace (or equivalent)

## Contributing
Feel free to fork and modify this code for your specific needs. The pattern can be adapted to work with any global structure by modifying the traversal logic in the Fetch method.

## License
MIT License - See LICENSE file for details.

---
*Note: This example demonstrates SQL querying of non-mapped globals. While the example uses a specific date/time/message structure, the pattern can be adapted to any global structure through modification of the core
