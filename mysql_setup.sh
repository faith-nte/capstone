#!/bin/bash

# Define password
MYSQL_PASSWORD="pa55word"

# Step 1: Install MySQL Server
echo "📦 Installing MySQL Server..."
apt update
apt install -y mysql-server

# Step 2: Create ~/.my.cnf to enable passwordless login
echo "🔑 Creating MySQL client config..."
cat > ~/.my.cnf <<EOF
[client]
user=root
password=$MYSQL_PASSWORD
EOF

chmod 600 ~/.my.cnf

cp ~/.my.cnf /root/
chmod 600 /root/.my.cnf

echo "Make VAR folder for mysql"
mkdir -p /var/run/mysqld
chown mysql:mysql /var/run/mysqld
service mysql start


# Step 3: Set MySQL root password and switch to native password auth
echo "🔧 Configuring MySQL authentication..."
mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Step 4: Load schema.sql into MySQL
echo "📄 Importing schema..."
mysql < schema.sql

echo "✅ MySQL setup complete."
