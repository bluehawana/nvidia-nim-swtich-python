#!/bin/bash

# Complete Deployment Script
# Automates both Cloudflare DNS setup and VPS deployment

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   NVIDIA NIM Switch - Complete Deployment                 ║"
echo "║   models.bluehawana.com                                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
DOMAIN="bluehawana.com"
SUBDOMAIN="models"
FULL_DOMAIN="${SUBDOMAIN}.${DOMAIN}"

echo -e "${BLUE}This script will:${NC}"
echo "  1. Configure Cloudflare DNS"
echo "  2. Set up SSL/TLS settings"
echo "  3. Deploy to your VPS"
echo "  4. Configure Nginx and Let's Encrypt"
echo "  5. Start the service"
echo ""

read -p "Continue? (y/n): " CONTINUE
if [ "$CONTINUE" != "y" ]; then
    echo "Deployment cancelled"
    exit 0
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "STEP 1: Cloudflare Configuration"
echo "════════════════════════════════════════════════════════════"
echo ""

# Check if running on VPS or local machine
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]] || [[ "$ID" == "debian" ]]; then
        ON_VPS=true
        echo -e "${GREEN}✓${NC} Detected VPS environment"
    else
        ON_VPS=false
        echo -e "${YELLOW}⚠${NC} Running on local machine"
    fi
else
    ON_VPS=false
fi

# Install jq if needed
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    else
        sudo apt-get update && sudo apt-get install -y jq
    fi
fi

# Get Cloudflare API Token
echo "📝 Cloudflare API Token Required"
echo "Get it from: https://dash.cloudflare.com/profile/api-tokens"
echo "Required permissions: Zone.DNS (Edit), Zone.Settings (Edit)"
echo ""
read -p "Enter your Cloudflare API Token: " CF_API_TOKEN
echo ""

# Get VPS IP
if [ "$ON_VPS" = true ]; then
    VPS_IP=$(curl -s ifconfig.me)
    echo -e "${GREEN}✓${NC} Detected VPS IP: ${VPS_IP}"
    read -p "Is this correct? (y/n): " IP_CORRECT
    if [ "$IP_CORRECT" != "y" ]; then
        read -p "Enter correct VPS IP: " VPS_IP
    fi
else
    read -p "Enter your VPS IP address: " VPS_IP
fi
echo ""

# Get NVIDIA API Key
echo "📝 NVIDIA NIM API Key Required"
echo "Get it from: https://build.nvidia.com/explore/discover"
echo ""
read -p "Enter your NVIDIA NIM API Key: " NVIDIA_API_KEY
echo ""

# Validate inputs
if [ -z "$CF_API_TOKEN" ] || [ -z "$VPS_IP" ] || [ -z "$NVIDIA_API_KEY" ]; then
    echo -e "${RED}❌ Missing required information${NC}"
    exit 1
fi

# Get Zone ID
echo "🔍 Looking up Cloudflare Zone ID..."
ZONE_RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json")

ZONE_ID=$(echo $ZONE_RESPONSE | jq -r '.result[0].id')

if [ "$ZONE_ID" == "null" ] || [ -z "$ZONE_ID" ]; then
    echo -e "${RED}❌ Could not find zone for ${DOMAIN}${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Found Zone ID"

# Create/Update DNS Record
echo "📝 Configuring DNS record..."

EXISTING_RECORD=$(curl -s -X GET \
    "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?type=A&name=${FULL_DOMAIN}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json")

RECORD_ID=$(echo $EXISTING_RECORD | jq -r '.result[0].id')

if [ "$RECORD_ID" != "null" ] && [ -n "$RECORD_ID" ]; then
    # Update existing record
    curl -s -X PUT \
        "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
        -H "Authorization: Bearer ${CF_API_TOKEN}" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"${SUBDOMAIN}\",\"content\":\"${VPS_IP}\",\"ttl\":1,\"proxied\":true}" > /dev/null
    echo -e "${GREEN}✓${NC} DNS record updated"
else
    # Create new record
    CREATE_RESPONSE=$(curl -s -X POST \
        "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
        -H "Authorization: Bearer ${CF_API_TOKEN}" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"${SUBDOMAIN}\",\"content\":\"${VPS_IP}\",\"ttl\":1,\"proxied\":true}")
    
    RECORD_ID=$(echo $CREATE_RESPONSE | jq -r '.result.id')
    echo -e "${GREEN}✓${NC} DNS record created"
fi

# Configure SSL/TLS
echo "🔒 Configuring SSL/TLS..."
curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/settings/ssl" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"value":"full"}' > /dev/null

curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/settings/always_use_https" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"value":"on"}' > /dev/null

echo -e "${GREEN}✓${NC} SSL/TLS configured"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "STEP 2: VPS Deployment"
echo "════════════════════════════════════════════════════════════"
echo ""

if [ "$ON_VPS" = false ]; then
    echo -e "${YELLOW}⚠${NC} Not on VPS. Please SSH to your VPS and run:"
    echo ""
    echo "ssh user@${VPS_IP}"
    echo ""
    echo "Then run this command on the VPS:"
    echo ""
    echo "curl -fsSL https://raw.githubusercontent.com/bluehawana/nvidia-nim-swtich-python/main/scripts/deploy_vps.sh | bash"
    echo ""
    echo "When prompted, use:"
    echo "  Domain: ${FULL_DOMAIN}"
    echo "  API Key: ${NVIDIA_API_KEY}"
    echo ""
    exit 0
fi

# Continue with VPS deployment if on VPS
echo "🚀 Starting VPS deployment..."
echo ""

# Update system
echo "1️⃣  Updating system..."
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo "2️⃣  Installing dependencies..."
sudo apt install -y python3.11 python3-pip curl git nginx certbot python3-certbot-nginx ufw

# Install uv
echo "3️⃣  Installing uv..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Clone repository
echo "4️⃣  Cloning repository..."
APP_DIR="/opt/nvidia-nim-swtich-python"
if [ -d "$APP_DIR" ]; then
    cd "$APP_DIR"
    sudo git pull
else
    cd /opt
    sudo git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
    cd "$APP_DIR"
fi
sudo chown -R $USER:$USER "$APP_DIR"

# Install Python dependencies
echo "5️⃣  Installing Python dependencies..."
uv sync

# Setup environment
echo "6️⃣  Configuring environment..."
cp .env.example .env
sed -i "s/NVIDIA_NIM_API_KEY=.*/NVIDIA_NIM_API_KEY=$NVIDIA_API_KEY/" .env

# Create systemd service
echo "7️⃣  Creating systemd service..."
sudo tee /etc/systemd/system/nvidia-nim-switch.service > /dev/null <<EOF
[Unit]
Description=NVIDIA NIM Switch
After=network.target

[Service]
Type=simple
User=$USER
Group=$USER
WorkingDirectory=$APP_DIR
Environment="PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=$HOME/.local/bin/uv run python server.py --host 0.0.0.0 --port 8089
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable nvidia-nim-switch

# Configure firewall
echo "8️⃣  Configuring firewall..."
sudo ufw --force enable
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Configure Nginx
echo "9️⃣  Configuring Nginx..."
sudo tee /etc/nginx/sites-available/nvidia-nim-switch > /dev/null <<EOF
server {
    listen 80;
    server_name ${FULL_DOMAIN};

    location / {
        proxy_pass http://localhost:8089;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/nvidia-nim-switch /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx

# Setup SSL
echo "🔟 Setting up SSL certificate..."
sudo certbot --nginx -d ${FULL_DOMAIN} --non-interactive --agree-tos --register-unsafely-without-email

# Start service
echo "🚀 Starting service..."
sudo systemctl start nvidia-nim-switch

# Wait and test
sleep 5

echo ""
echo "════════════════════════════════════════════════════════════"
echo "STEP 3: Verification"
echo "════════════════════════════════════════════════════════════"
echo ""

# Test health
if curl -s http://localhost:8089/health | grep -q "healthy"; then
    echo -e "${GREEN}✓${NC} Health check passed"
else
    echo -e "${RED}✗${NC} Health check failed"
fi

# Test HTTPS
if curl -s -k https://${FULL_DOMAIN}/health | grep -q "healthy"; then
    echo -e "${GREEN}✓${NC} HTTPS working"
else
    echo -e "${YELLOW}⚠${NC} HTTPS not yet available (DNS may still be propagating)"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ✅ Deployment Complete!                                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "🌐 Your service is live at:"
echo "   https://${FULL_DOMAIN}/"
echo ""
echo "📊 Service Status:"
sudo systemctl status nvidia-nim-switch --no-pager | head -5
echo ""
echo "📝 Useful Commands:"
echo "   View logs: sudo journalctl -u nvidia-nim-switch -f"
echo "   Restart: sudo systemctl restart nvidia-nim-switch"
echo "   Status: sudo systemctl status nvidia-nim-switch"
echo ""
