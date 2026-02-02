# ☁️ Cloudflare DNS Setup for models.bluehawana.com

Complete guide to configure Cloudflare DNS for your NVIDIA NIM Switch deployment.

---

## 🎯 Overview

Since your domain (bluehawana.com) is managed by Cloudflare, you need to:
1. Add DNS record for models.bluehawana.com
2. Configure SSL/TLS settings
3. Set up security rules
4. Configure caching (optional)

---

## 📋 Prerequisites

- [ ] Cloudflare account with bluehawana.com added
- [ ] VPS IP address ready
- [ ] Access to Cloudflare dashboard

---

## 🔧 Step 1: Add DNS Record

### Login to Cloudflare

1. Go to https://dash.cloudflare.com/
2. Select your domain: **bluehawana.com**
3. Click on **DNS** in the left sidebar

### Add A Record

Click **Add record** and configure:

```
Type: A
Name: models
IPv4 address: YOUR_VPS_IP_ADDRESS
Proxy status: Proxied (orange cloud) ✅
TTL: Auto
```

**Important**: 
- ✅ **Enable Proxy (Orange Cloud)** - This gives you Cloudflare's CDN, DDoS protection, and SSL
- Name should be just `models` (not `models.bluehawana.com`)

### Verify DNS

After adding, you should see:
```
models.bluehawana.com → YOUR_VPS_IP (Proxied)
```

Wait 1-5 minutes for DNS propagation, then test:

```bash
# Check DNS resolution
dig models.bluehawana.com

# Or use nslookup
nslookup models.bluehawana.com
```

---

## 🔒 Step 2: SSL/TLS Configuration

### Navigate to SSL/TLS Settings

1. In Cloudflare dashboard, click **SSL/TLS**
2. Select **Overview** tab

### Choose SSL/TLS Encryption Mode

Select: **Full (strict)** ✅

**Why?**
- **Off**: No encryption ❌
- **Flexible**: Cloudflare to visitor encrypted, Cloudflare to server not encrypted ⚠️
- **Full**: Encrypted but doesn't validate certificate ⚠️
- **Full (strict)**: Fully encrypted and validates certificate ✅ (Best!)

### Enable Always Use HTTPS

1. Go to **SSL/TLS** → **Edge Certificates**
2. Enable **Always Use HTTPS** ✅
3. Enable **Automatic HTTPS Rewrites** ✅

---

## 🛡️ Step 3: Security Settings

### Firewall Rules (Optional but Recommended)

1. Go to **Security** → **WAF**
2. Click **Create rule**

**Rule 1: Rate Limiting**
```
Rule name: API Rate Limit
Field: URI Path
Operator: contains
Value: /v1/messages
Action: Challenge
Rate: 10 requests per minute
```

**Rule 2: Block Bad Bots**
```
Rule name: Block Bad Bots
Field: Known Bots
Operator: equals
Value: Bad Bots
Action: Block
```

### Security Level

1. Go to **Security** → **Settings**
2. Set **Security Level**: Medium or High
3. Enable **Bot Fight Mode** (free plan) ✅

---

## ⚡ Step 4: Performance Settings

### Caching Configuration

1. Go to **Caching** → **Configuration**
2. Set **Caching Level**: Standard

### Page Rules (Optional)

1. Go to **Rules** → **Page Rules**
2. Click **Create Page Rule**

**Rule 1: Cache Static Files**
```
URL: models.bluehawana.com/static/*
Settings:
  - Cache Level: Cache Everything
  - Edge Cache TTL: 1 day
```

**Rule 2: Bypass Cache for API**
```
URL: models.bluehawana.com/v1/*
Settings:
  - Cache Level: Bypass
```

---

## 🚀 Step 5: Deploy to VPS

Now that Cloudflare is configured, deploy to your VPS:

### Get Your VPS IP

```bash
# If you don't know your VPS IP
ssh user@your-vps-ip
curl ifconfig.me
```

### Run Deployment Script

```bash
# SSH to your VPS
ssh user@your-vps-ip

# Run deployment
curl -fsSL https://raw.githubusercontent.com/bluehawana/nvidia-nim-swtich-python/main/scripts/deploy_vps.sh | bash
```

When prompted:
- **Domain**: `models.bluehawana.com`
- **API Key**: Your NVIDIA NIM API key
- **Setup SSL**: `y` (yes)

---

## 🔍 Step 6: Verify Setup

### Test DNS Resolution

```bash
dig models.bluehawana.com
```

Should show Cloudflare IPs (not your VPS IP directly).

### Test HTTPS

```bash
curl -I https://models.bluehawana.com/health
```

Should return:
```
HTTP/2 200
server: cloudflare
...
```

### Test Web Interface

Open in browser: https://models.bluehawana.com/

You should see:
- ✅ HTTPS (padlock icon)
- ✅ NVIDIA NIM Model Switcher interface
- ✅ No certificate warnings

### Test API

```bash
curl -X POST https://models.bluehawana.com/v1/messages \
  -H "Content-Type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 50,
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

---

## 🎨 Step 7: Customize Cloudflare (Optional)

### Custom Error Pages

1. Go to **Custom Pages**
2. Customize error pages for better branding

### Analytics

1. Go to **Analytics & Logs**
2. View traffic, requests, bandwidth
3. Monitor performance

### Speed Optimization

1. Go to **Speed** → **Optimization**
2. Enable:
   - ✅ Auto Minify (JavaScript, CSS, HTML)
   - ✅ Brotli compression
   - ✅ Early Hints

---

## 🔧 Troubleshooting

### Issue 1: "Too Many Redirects"

**Cause**: SSL/TLS mode mismatch

**Solution**:
1. In Cloudflare: Set SSL/TLS to **Full (strict)**
2. On VPS: Ensure Let's Encrypt certificate is installed
3. In Nginx: Ensure HTTPS is configured

### Issue 2: "502 Bad Gateway"

**Cause**: Service not running on VPS

**Solution**:
```bash
# SSH to VPS
ssh user@your-vps-ip

# Check service status
sudo systemctl status nvidia-nim-switch

# Restart if needed
sudo systemctl restart nvidia-nim-switch

# Check logs
sudo journalctl -u nvidia-nim-switch -f
```

### Issue 3: "DNS_PROBE_FINISHED_NXDOMAIN"

**Cause**: DNS not propagated yet

**Solution**:
- Wait 5-10 minutes
- Clear DNS cache: `ipconfig /flushdns` (Windows) or `sudo dscacheutil -flushcache` (Mac)
- Check Cloudflare DNS settings

### Issue 4: Certificate Errors

**Cause**: Let's Encrypt not installed or Cloudflare SSL mode wrong

**Solution**:
1. Ensure Cloudflare SSL/TLS is **Full (strict)**
2. On VPS, run: `sudo certbot --nginx -d models.bluehawana.com`
3. Restart Nginx: `sudo systemctl restart nginx`

---

## 📊 Cloudflare Dashboard Overview

After setup, your Cloudflare dashboard should show:

### DNS Records
```
Type  Name    Content          Proxy Status
A     models  YOUR_VPS_IP      Proxied (✅)
```

### SSL/TLS
```
Mode: Full (strict) ✅
Always Use HTTPS: On ✅
```

### Security
```
Security Level: Medium
Bot Fight Mode: On
```

### Analytics
- Requests per day
- Bandwidth usage
- Threats blocked

---

## 🎯 Complete Setup Checklist

- [ ] Cloudflare DNS A record added (models → VPS IP)
- [ ] Proxy status enabled (orange cloud)
- [ ] SSL/TLS set to Full (strict)
- [ ] Always Use HTTPS enabled
- [ ] VPS deployment completed
- [ ] Let's Encrypt certificate installed
- [ ] Nginx configured
- [ ] Service running
- [ ] HTTPS working (https://models.bluehawana.com)
- [ ] API responding
- [ ] Web interface accessible

---

## 🚀 Quick Reference

### Cloudflare Settings Summary

```yaml
DNS:
  - Type: A
  - Name: models
  - IP: YOUR_VPS_IP
  - Proxy: Enabled (Orange Cloud)

SSL/TLS:
  - Mode: Full (strict)
  - Always HTTPS: On
  - Auto HTTPS Rewrites: On

Security:
  - Level: Medium
  - Bot Fight: On
  - Rate Limiting: 10 req/min

Performance:
  - Caching: Standard
  - Minify: JS, CSS, HTML
  - Brotli: On
```

### VPS Nginx Configuration

Your Nginx should listen on:
- Port 80 (HTTP) - Redirects to HTTPS
- Port 443 (HTTPS) - Main traffic

Cloudflare will:
- Handle SSL termination
- Provide DDoS protection
- Cache static files
- Block bad bots

---

## 💡 Pro Tips

### 1. Use Cloudflare Analytics

Monitor your service usage:
- Requests per day
- Bandwidth consumption
- Geographic distribution
- Bot traffic

### 2. Set Up Alerts

1. Go to **Notifications**
2. Create alerts for:
   - High traffic
   - DDoS attacks
   - SSL certificate expiration

### 3. Enable Argo Smart Routing (Paid)

For better performance:
- Faster routing
- Reduced latency
- Better reliability

### 4. Use Cloudflare Workers (Advanced)

Add custom logic:
- Request validation
- Usage tracking
- Custom rate limiting

---

## 📞 Support

### Cloudflare Issues
- Cloudflare Community: https://community.cloudflare.com/
- Cloudflare Support: https://support.cloudflare.com/

### VPS Issues
- Check logs: `sudo journalctl -u nvidia-nim-switch -f`
- GitHub Issues: https://github.com/bluehawana/nvidia-nim-swtich-python/issues

---

## ✅ Success!

Once everything is configured, you'll have:

🌐 **Live Service**: https://models.bluehawana.com/  
🔒 **Secure**: HTTPS with Cloudflare SSL  
🛡️ **Protected**: DDoS protection and bot filtering  
⚡ **Fast**: CDN caching and optimization  
📊 **Monitored**: Analytics and insights  

**Your free trial service is ready for the world!** 🎉

---

*Last updated: February 2, 2026*
