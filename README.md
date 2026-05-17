# RBAC Audit Script — “AA - LEGO” Project

## Overview
This script audits Active Directory users and identifies which RBAC groups (prefixed with **“AA - LEGO”**) they are assigned to.  
The output is used to validate whether users have been granted the correct RBAC roles according to the RBAC mapping document.

---

## Features
- Enumerates all AD users  
- Retrieves each user’s group memberships  
- Filters RBAC groups by prefix (`AA - LEGO`)  
- Outputs a clean list of users and their RBAC assignments  
- Optional export to CSV/JSON  

---

## Requirements
- Windows PowerShell 5.1 or PowerShell 7+  
- RSAT ActiveDirectory module  
  - If unavailable, script can fall back to ADSI  
- AD read permissions  

---

## Usage

### Basic Run
```powershell
.\Get-RBACAssignments.ps1
```

### Export to CSV
```powershell
.\Get-RBACAssignments.ps1 -ExportCsv "RBAC_Audit.csv"
```

### Output Format
Each record contains:
- Username
- Display Name
- UPN
- RBAC Groups (Array)
Example (JSON):
```JSON
{
  "UserName": "jdoe",
  "DisplayName": "John Doe",
  "UPN": "jdoe@example.com",
  "RBACGroups": [
    "AA - LEGO - PROD - CreditUser",
    "AA - LEGO - ACC - Accountant"
  ]
}
```

## Roadmap
- Automated comparison against RBAC mapping
- Compliance scoring
- Scheduled reporting
- Integration with approval workflows