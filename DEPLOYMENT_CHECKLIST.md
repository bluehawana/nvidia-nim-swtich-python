# ✅ Deployment Checklist for models.bluehawana.com

## 📋 Pre-Deployment

### Cloudflare Setup (Do This First!)
- [ ] Login to Cloudflare dashboard
- [ ] Go to bluehawana.com domain
- [ ] Add DNS A record:
  - Type: `A`
  - Name: `models`
  - IPv4: `YOUR_VPS_IP`
  - Proxy: `Enabled` (Orange Cloud ✅)
- [ ] Set SSL/TLS to `Full (strict)`
- [ ] Enable `Always Use HTTPS`
- [ ] Wait 5 minutes for DNS propagation

### VPS Preparation
- [ ] VPS ready (Ubuntu 20.04+, 4GB RAM, 2 CPU)
- [ ] Know your VPS IP address
- [ ] SSH access working
- [ ] Sudo privileges confirmed

### API Key Ready
- [ ] NVIDIA NIM API key obtained from https://build.nvidia.com/explore/discover
- [ ] API key copied and ready to paste

---

## 🚀 Deployment Steps

### Step 1: Verify DNS
```bash
# Test DNS resolution
dig models.bluehawana.com

# Should show Cloudflare IPs
```
- [ ] DNS resolves correctly

### Step 2: SSH to VPS
```bash
ssh user@your-vps-ip
```
- [ ] Successfully connected to VPS

### Step 3: Run Deployment Script
```bash
curl -fsSL https://raw.githubusercontent.com/bluehawana/nvidia-nim-swtich-python/main/scripts/deploy_vps.sh | bash
```

When prompted, enter:
- [ ] Domain: `models.bluehawana.com`
- [ ] API Key: `your_nvidia_api_key`
- [ ] Setup SSL: `y`

### Step 4: Wait for Deployment
- [ ] System updated
- [ ] Dependencies installed
- [ ] Repository cloned
- [ ] Python dependencies installed
- [ ] Systemd service created
- [ ] Nginx configured
- [ ] SSL certificate obtained
- [ ] Service started

---

## 🧪 Testing

### Test 1: Health Check
```bash
curl https://models.bluehawana.com/health
```
Expected: `{"status":"healthy"}`
- [ ] Health check passed

### Test 2: Web Interface
Open in browser: https://models.bluehawana.com/
- [ ] Page loads with HTTPS (padlock icon)
- [ ] No certificate warnings
- [ ] NVIDIA NIM Model Switcher interface visible
- [ ] Can see 182 models
- [ ] Speed indicators showing (⚡🚀🐢)
- [ ] Search bar working
- [ ] Sort dropdown working

### Test 3: Model Switching
In the web interface:
- [ ] Click on a model's "Switch to Model" button
- [ ] See success notification
- [ ] Current model updates

### Test 4: API Test
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
- [ ] API responds with valid JSON
- [ ] Response contains text content
- [ ] No errors

### Test 5: Rate Limiting
Make 15 requests quickly:
- [ ] After 10 requests, rate limiting kicks in
- [ ] Receives 429 status code or challenge

---

## 📊 Monitoring Setup

### Check Service Status
```bash
sudo systemctl status nvidia-nim-switch
```
- [ ] Service is active (running)
- [ ] No errors in status

### View Logs
```bash
# Application logs
sudo journalctl -u nvidia-nim-switch -f

# Nginx logs
sudo tail -f /var/log/nginx/models.bluehawana.com-access.log
```
- [ ] Logs are being written
- [ ] No error messages

### Check Cloudflare Analytics
1. Go to Cloudflare dashboard
2. Select bluehawana.com
3. Click Analytics
- [ ] Seeing traffic
- [ ] Requests being logged

---

## 🔒 Security Verification

### Firewall
```bash
sudo ufw status
```
Expected:
```
Status: active
22/tcp    ALLOW
80/tcp    ALLOW
443/tcp   ALLOW
```
- [ ] Firewall is active
- [ ] Only necessary ports open

### SSL Certificate
```bash
sudo certbot certificates
```
- [ ] Certificate for models.bluehawana.com exists
- [ ] Not expired
- [ ] Auto-renewal configured

### File Permissions
```bash
ls -la /opt/nvidia-nim-swtich-python/.env
```
- [ ] .env file has restricted permissions (600 or 640)
- [ ] Owned by appropriate user

---

## 🎯 Post-Deployment

### Update README
- [ ] Add live demo link to README
- [ ] Update documentation with actual domain

### Social Media Announcement
- [ ] Prepare announcement post
- [ ] Include link: https://models.bluehawana.com
- [ ] Mention key features
- [ ] Post on LinkedIn
- [ ] Post on Twitter/X

### Monitor First 24 Hours
- [ ] Check logs regularly
- [ ] Monitor Cloudflare analytics
- [ ] Watch for errors
- [ ] Respond to any issues

### Gather Feedback
- [ ] Add feedback form (optional)
- [ ] Monitor GitHub issues
- [ ] Track user requests
- [ ] Plan improvements

---

## 🆘 Troubleshooting

### If Health Check Fails
```bash
# Check service
sudo systemctl status nvidia-nim-switch

# Restart service
sudo systemctl restart nvidia-nim-switch

# Check logs
sudo journalctl -u nvidia-nim-switch -n 50
```

### If HTTPS Not Working
1. Check Cloudflare SSL/TLS mode (should be Full strict)
2. Verify Let's Encrypt certificate: `sudo certbot certificates`
3. Check Nginx config: `sudo nginx -t`
4. Restart Nginx: `sudo systemctl restart nginx`

### If DNS Not Resolving
1. Check Cloudflare DNS settings
2. Ensure proxy is enabled (orange cloud)
3. Wait 5-10 minutes for propagation
4. Clear local DNS cache

### If Rate Limiting Too Strict
Edit `/opt/nvidia-nim-swtich-python/.env`:
```bash
NVIDIA_NIM_RATE_LIMIT=20  # Increase from 10
```
Then restart: `sudo systemctl restart nvidia-nim-switch`

---

## 📞 Support Contacts

### Technical Issues
- GitHub Issues: https://github.com/bluehawana/nvidia-nim-swtich-python/issues
- Documentation: Check docs/ folder

### Cloudflare Issues
- Cloudflare Support: https://support.cloudflare.com/
- Community: https://community.cloudflare.com/

### NVIDIA NIM API Issues
- NVIDIA Build: https://build.nvidia.com/
- API Documentation: Check NVIDIA docs

---

## ✅ Final Checklist

Before announcing publicly:
- [ ] All tests passed
- [ ] HTTPS working
- [ ] Web interface accessible
- [ ] API responding correctly
- [ ] Rate limiting working
- [ ] Monitoring in place
- [ ] Logs being collected
- [ ] Cloudflare analytics active
- [ ] Documentation updated
- [ ] Announcement prepared

---

## 🎉 Success Criteria

Your deployment is successful when:
- ✅ https://models.bluehawana.com/ loads with HTTPS
- ✅ Web interface shows all 182 models
- ✅ Model switching works
- ✅ API responds to requests
- ✅ Rate limiting protects the service
- ✅ Cloudflare shows traffic
- ✅ No errors in logs

**Congratulations! Your free trial service is live!** 🚀

---

*Deployment Date: _____________*  
*Deployed By: _____________*  
*Status: _____________*
