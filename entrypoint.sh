#!/bin/bash

# Start MySQL service
service mysql start

# Optional: Wait until MySQL is fully up
until mysqladmin ping --silent; do
    echo "Waiting for MySQL..."
    sleep 2
done

source venv/bin/activate   # ✅ Activates the virtual environment
nohup python3 run.py > app.log 2>&1 & # ✅ Runs the app in the background and keeps it open
