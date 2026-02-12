#!/bin/bash
# Install ODBC Driver 18 for SQL Server on Linux Azure App Service

echo "=========================================="
echo "Installing ODBC Driver 18 for SQL Server"
echo "=========================================="

# Update package manager
apt-get update -y

# Install ODBC driver dependencies
ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Install unixodbc (required for pyodbc)
apt-get install -y unixodbc-dev

# Run Django migrations
echo "Running Django migrations..."
python manage.py migrate --noinput

echo "✓ Setup complete"
