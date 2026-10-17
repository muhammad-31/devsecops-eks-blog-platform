#!/bin/bash
# ============================================
# Jerney Blog Platform - single EC2 setup
# Run on a fresh Ubuntu 24.04 instance, from a copy of this repository:
#
#   git clone https://github.com/muhammad-31/devsecops-eks-blog-platform.git ~/Jerney
#   bash ~/Jerney/deploy/setup.sh
#
# The database password is generated here (or taken from DB_PASSWORD) and
# written to /var/www/jerney/backend/.env (mode 600). It is never committed.
# ============================================

set -euo pipefail

SRC_DIR="${SRC_DIR:-$HOME/Jerney}"
APP_DIR=/var/www/jerney
DB_NAME=jerney_db
DB_USER=jerney_user
DB_PASSWORD="${DB_PASSWORD:-$(openssl rand -hex 24)}"

echo "==> Updating system packages"
sudo apt-get update
sudo apt-get upgrade -y

echo "==> Installing Node.js 22 (LTS)"
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
echo "Node.js $(node -v), npm $(npm -v)"

echo "==> Installing PostgreSQL, Nginx and PM2"
sudo apt-get install -y postgresql nginx
sudo npm install -g pm2

echo "==> Creating the database and its user"
# The password is passed as a psql variable, so it is quoted correctly and
# never appears in the process list.
sudo -u postgres psql -v ON_ERROR_STOP=1 -v pw="$DB_PASSWORD" <<'SQL'
CREATE USER jerney_user WITH PASSWORD :'pw';
CREATE DATABASE jerney_db OWNER jerney_user;
SQL

echo "==> Copying the application to $APP_DIR"
sudo mkdir -p "$APP_DIR"
sudo chown -R "$USER:$USER" "$APP_DIR"
cp -r "$SRC_DIR"/. "$APP_DIR"/

echo "==> Backend: dependencies and configuration"
cd "$APP_DIR/backend"
npm ci --omit=dev
# Read by dotenv at startup (src/index.js).
umask 077
cat > .env <<EOF
PORT=5000
DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
EOF
umask 022

echo "==> Frontend: build"
cd "$APP_DIR/frontend"
npm ci
npm run build

echo "==> Nginx"
sudo cp "$APP_DIR/deploy/jerney-nginx.conf" /etc/nginx/sites-available/jerney
sudo ln -sf /etc/nginx/sites-available/jerney /etc/nginx/sites-enabled/jerney
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl reload nginx

echo "==> Starting the backend with PM2"
cd "$APP_DIR/backend"
pm2 start src/index.js --name jerney-backend
pm2 save
sudo env PATH="$PATH" pm2 startup systemd -u "$USER" --hp "$HOME"

echo
echo "Done. Open http://<this-instance's-public-address>/"
echo "  pm2 status | pm2 logs jerney-backend | sudo systemctl reload nginx"
