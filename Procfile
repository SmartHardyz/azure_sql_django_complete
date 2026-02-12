release: bash scripts/install_odbc.sh
web: gunicorn --bind 0.0.0.0:8000 --workers 1 --timeout 600 azure_project.wsgi:application
