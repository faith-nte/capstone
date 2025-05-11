#!/bin/bash

# Start MySQL service
service mysql start

# Optional: Wait until MySQL is fully up
until mysqladmin ping --silent; do
    echo "Waiting for MySQL..."
    sleep 2
done

# create database
mysql -u root < /app/schema.sql

# Start your Python app
exec python3 app/run.py
