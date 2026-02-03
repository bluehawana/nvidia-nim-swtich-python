#!/bin/bash

# Cloudflare DNS Setup Script using Cloudflare API
# Automates DNS record creation for models.bluehawana.com

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Cloudflare DNS Setup - models.bluehawana.com            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
DOMAIN="bluehawana.com"
SUBDOMAIN="models"
FULL_DOMAIN="${SUBDOMAIN}.${DOMAIN}"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}Installing jq for JSON parsing...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    else
        sudo apt-get update && sudo apt-get install -y jq
    fi
fi

# Get Cloudflare credentials
echo "📝 Cloudflare API Credentials Required"
echo ""
echo "Get your API token from: https://dash.cloudflare.com/profile/api-tokens"
echo "Required permissions: Zone.DNS (Edit)"
echo ""

read -p "Enter your Cloudflare API Token: " CF_API_TOKEN
echo ""

read -p "Enter your VPS IP address: " VPS_IP
echo ""

# Validate IP address
if ! [[ $VPS_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo -e "${RED}❌ Invalid IP address format${NC}"
    exit 1
fi

echo "🔍 Looking up Zone ID for ${DOMAIN}..."

# Get Zone ID
ZONE_RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json")

ZONE_ID=$(echo $ZONE_RESPONSE | jq -r '.result[0].id')

if [ "$ZONE_ID" == "null" ] || [ -z "$ZONE_ID" ]; then
    echo -e "${RED}❌ Could not find zone for ${DOMAIN}${NC}"
    echo "Please check:"
    echo "  1. Domain is added to your Cloudflare account"
    echo "  2. API token has correct permissions"
    echo "  3. API token is valid"
    exit 1
fi

echo -e "${GREEN}✓${NC} Found Zone ID: ${ZONE_ID}"
echo ""

# Check if DNS record already exists
echo "🔍 Checking for existing DNS record..."

EXISTING_RECORD=$(curl -s -X GET \
    "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?type=A&name=${FULL_DOMAIN}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json")

RECORD_ID=$(echo $EXISTING_RECORD | jq -r '.result[0].id')

if [ "$RECORD_ID" != "null" ] && [ -n "$RECORD_ID" ]; then
    echo -e "${YELLOW}⚠${NC} DNS record already exists"
    echo ""
    read -p "Update existing record? (y/n): " UPDATE_RECORD
    
    if [ "$UPDATE_RECORD" == "y" ]; then
        echo "📝 Updating DNS record..."
        
        UPDATE_RESPONSE=$(curl -s -X PUT \
            "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
            -H "Authorization: Bearer ${CF_API_TOKEN}" \
            -H "Content-Type: application/json" \
            --data "{
                \"type\": \"A\",
                \"name\": \"${SUBDOMAIN}\",
                \"content\": \"${VPS_IP}\",
                \"ttl\": 1,
                \"proxied\": true
            }")
        
        SUCCESS=$(echo $UPDATE_RESPONSE | jq -r '.success')
        
        if [ "$SUCCESS" == "true" ]; then
            echo -e "${GREEN}✓${NC} DNS record updated successfully"
        else
            echo -e "${RED}❌ Failed to update DNS record${NC}"
            echo $UPDATE_RESPONSE | jq '.errors'
            exit 1
        fi
    else
        echo "Skipping DNS record update"
    fi
else
    echo "📝 Creating new DNS record..."
    
    CREATE_RESPONSE=$(curl -s -X POST \
        "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
        -H "Authorization: Bearer ${CF_API_TOKEN}" \
        -H "Content-Type: application/json" \
        --data "{
            \"type\": \"A\",
            \"name\": \"${SUBDOMAIN}\",
            \"content\": \"${VPS_IP}\",
            \"ttl\": 1,
            \"proxied\": true,
            \"comment\": \"NVIDIA NIM Switch - Auto-created\"
        }")
    
    SUCCESS=$(echo $CREATE_RESPONSE | jq -r '.success')
    
    if [ "$SUCCESS" == "true" ]; then
        echo -e "${GREEN}✓${NC} DNS record created successfully"
        RECORD_ID=$(echo $CREATE_RESPONSE | jq -r '.result.id')
    else
        echo -e "${RED}❌ Failed to create DNS record${NC}"
        echo $CREATE_RESPONSE | jq '.errors'
        exit 1
    fi
fi

echo ""
echo "🔒 Configuring SSL/TLS settings..."

# Set SSL/TLS to Full (strict)
SSL_RESPONSE=$(curl -s -X PATCH \
    "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/settings/ssl" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"value":"full"}')

SSL_SUCCESS=$(echo $SSL_RESPONSE | jq -r '.success')

if [ "$SSL_SUCCESS" == "true" ]; then
    echo -e "${GREEN}✓${NC} SSL/TLS mode set to Full (strict)"
else
    echo -e "${YELLOW}⚠${NC} Could not set SSL/TLS mode (may need manual configuration)"
fi

# Enable Always Use HTTPS
HTTPS_RESPONSE=$(curl -s -X PATCH \
    "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/settings/always_use_https" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"value":"on"}')

HTTPS_SUCCESS=$(echo $HTTPS_RESPONSE | jq -r '.success')

if [ "$HTTPS_SUCCESS" == "true" ]; then
    echo -e "${GREEN}✓${NC} Always Use HTTPS enabled"
else
    echo -e "${YELLOW}⚠${NC} Could not enable Always Use HTTPS (may need manual configuration)"
fi

# Enable Auto HTTPS Rewrites
REWRITE_RESPONSE=$(curl -s -X PATCH \
    "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/settings/automatic_https_rewrites" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"value":"on"}')

REWRITE_SUCCESS=$(echo $REWRITE_RESPONSE | jq -r '.success')

if [ "$REWRITE_SUCCESS" == "true" ]; then
    echo -e "${GREEN}✓${NC} Automatic HTTPS Rewrites enabled"
else
    echo -e "${YELLOW}⚠${NC} Could not enable HTTPS Rewrites (may need manual configuration)"
fi

echo ""
echo "🔍 Verifying DNS configuration..."

# Get the created/updated record
VERIFY_RESPONSE=$(curl -s -X GET \
    "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json")

RECORD_NAME=$(echo $VERIFY_RESPONSE | jq -r '.result.name')
RECORD_CONTENT=$(echo $VERIFY_RESPONSE | jq -r '.result.content')
RECORD_PROXIED=$(echo $VERIFY_RESPONSE | jq -r '.result.proxied')

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ✅ Cloudflare Configuration Complete                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 DNS Record Details:"
echo "   Domain: ${RECORD_NAME}"
echo "   IP Address: ${RECORD_CONTENT}"
echo "   Proxied: ${RECORD_PROXIED}"
echo ""
echo "🔒 SSL/TLS Settings:"
echo "   Mode: Full (strict)"
echo "   Always HTTPS: Enabled"
echo "   Auto Rewrites: Enabled"
echo ""
echo "⏳ DNS Propagation:"
echo "   Wait 1-5 minutes for DNS to propagate globally"
echo ""
echo "🧪 Test DNS Resolution:"
echo "   dig ${FULL_DOMAIN}"
echo "   nslookup ${FULL_DOMAIN}"
echo ""
echo "🚀 Next Steps:"
echo "   1. Wait 5 minutes for DNS propagation"
echo "   2. SSH to your VPS: ssh user@${VPS_IP}"
echo "   3. Run deployment script:"
echo "      curl -fsSL https://raw.githubusercontent.com/bluehawana/nvidia-nim-swtich-python/main/scripts/deploy_vps.sh | bash"
echo ""
echo "📝 Save this information:"
echo "   Zone ID: ${ZONE_ID}"
echo "   Record ID: ${RECORD_ID}"
echo ""

# Save configuration
cat > cloudflare_config.txt << EOF
Cloudflare Configuration
========================
Date: $(date)
Domain: ${FULL_DOMAIN}
VPS IP: ${VPS_IP}
Zone ID: ${ZONE_ID}
Record ID: ${RECORD_ID}
Proxied: ${RECORD_PROXIED}

SSL/TLS: Full (strict)
Always HTTPS: Enabled
Auto Rewrites: Enabled

Next: Deploy to VPS at ${VPS_IP}
EOF

echo "💾 Configuration saved to: cloudflare_config.txt"
echo ""
