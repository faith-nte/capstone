# Use Ubuntu as the base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    mysql-server \
    default-libmysqlclient-dev \
    build-essential \
    curl \
    git \
    && apt-get clean

# Set working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip3 install --upgrade pip && pip3 install -r requirements.txt

# Copy the rest of the app
COPY . .

# Expose the port your Flask app runs on
EXPOSE 5000

# Start MySQL and the Flask app
CMD service mysql start && python3 app/main.py