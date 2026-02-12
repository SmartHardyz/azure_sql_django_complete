#!/bin/bash
# startup.sh - Install ODBC Driver 18 on Linux Azure App Service

echo "=========================================="
echo "Installing ODBC Driver 18 for SQL Server"
echo "=========================================="

# Update package manager
apt-get update

# Install ODBC driver dependencies
ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Install unixodbc (required for pyodbc)
apt-get install -y unixodbc-dev

echo "✓ ODBC setup complete"

# Run Django startup
cd /home/site/wwwroot
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
