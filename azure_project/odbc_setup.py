"""
ODBC driver installer that runs on Django startup
This ensures the driver is installed before any database connection is attempted
"""

import subprocess
import sys
import os


def install_odbc_driver():
    """Install ODBC Driver 18 for SQL Server on Linux"""
    
    # Only run on Linux (check for /etc/os-release)
    if not os.path.exists("/etc/os-release"):
        return  # Not Linux, skip
    
    print("Checking ODBC Driver 18 for SQL Server...")
    
    # Check if driver is already installed
    result = subprocess.run(
        ["odbcinst", "-j"],
        capture_output=True,
        text=True
    )
    
    if "ODBC Driver 18 for SQL Server" in result.stdout or "ODBC Driver 18 for SQL Server" in result.stderr:
        print("✓ ODBC Driver 18 already installed")
        return
    
    print("Installing ODBC Driver 18...")
    
    # Install dependencies
    subprocess.run(["apt-get", "update"], capture_output=True)
    subprocess.run(
        ["apt-get", "install", "-y", "msodbcsql18"],
        env={**os.environ, "ACCEPT_EULA": "Y"},
        capture_output=True
    )
    subprocess.run(["apt-get", "install", "-y", "unixodbc-dev"], capture_output=True)
    
    print("✓ ODBC Driver 18 installed")


# Run installer when this module is imported
try:
    install_odbc_driver()
except Exception as e:
    print(f"Warning: ODBC install failed: {e}", file=sys.stderr)
