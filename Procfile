#!/bin/bash
release: ./startup.sh
web: ~/.local/bin/gunicorn --bind 0.0.0.0:8000 --workers 1 --timeout 600 azure_project.wsgi:application
