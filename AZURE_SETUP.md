# Azure App Service Setup - ODBC Driver Fix

## Problem
Azure App Service is missing the ODBC Driver 18 for SQL Server, causing connection errors to Azure SQL Database.

## Solution
We've added a startup script that automatically installs the ODBC driver when your app starts.

## Setup Instructions

### 1. Azure App Service Configuration

Go to your Azure App Service in the Azure Portal and set the startup command:

**Navigate to:**
- Settings → Configuration → General settings → Startup command

**Enter this command:**
```
PowerShell -File startup.ps1
```

**OR if that doesn't work, try:**
```
powershell -File startup.ps1
```

### 2. Verify Files Are in Root
Make sure these files are in the **root** of your `azure_sql_django_complete` folder:
- `startup.ps1` ← startup script (auto-installs ODBC driver)
- `manage.py` 
- `requirements.txt`
- etc.

### 3. Deploy to GitHub
Push your code to GitHub. Azure App Service will automatically redeploy and run the startup command.

### 4. Verify It Works
- Go to your App Service in Azure Portal → Deployment Center
- Check the logs in **Log stream** to see if startup runs successfully
- Test your API endpoint

## What the Startup Script Does
1. Checks if ODBC Driver 18 for SQL Server is installed
2. If missing, downloads and installs it automatically
3. Exits (Azure then runs the normal Django startup)

## If It Still Fails
1. Check the **Log stream** in Azure Portal for error messages
2. Make sure your App Service is **Windows** (not Linux)
3. Verify the startup command is set correctly in Configuration → General settings

## Support Files
- `startup.ps1` - Main startup script (handles ODBC installation)
- `scripts/ensure_odbc_driver.ps1` - Standalone ODBC check script
- `scripts/runserver.ps1` - Local development helper
