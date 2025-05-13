#!/bin/bash

# Define password
MYSQL_PASSWORD="pa55word"

# Step 1: Install MySQL Server
echo "📦 Installing MySQL Server..."
sudo apt update
sudo apt install -y mysql-server

# Step 2: Create ~/.my.cnf to enable passwordless login
echo "🔑 Creating MySQL client config..."
cat > ~/.my.cnf <<EOF
[client]
user=root
password=$MYSQL_PASSWORD
EOF

chmod 600 ~/.my.cnf

# Step 3: Set MySQL root password and switch to native password auth
echo "🔧 Configuring MySQL authentication..."
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Step 4: Load schema.sql into MySQL
echo "📄 Importing schema..."
mysql < /app/schema.sql

echo "✅ MySQL setup complete."
