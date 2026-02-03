# 🪟 Windows Installation Guide

**⚠️ IMPORTANT: This project requires WSL2 (Windows Subsystem for Linux)**

This project uses Linux-specific commands like `sudo`, `nano`, `bash`, etc. You **MUST** run it inside WSL2, not directly in PowerShell or CMD.

---

## 🎯 Why WSL2?

Windows PowerShell and CMD don't support:
- ❌ `sudo` command
- ❌ `nano` editor
- ❌ Bash scripts
- ❌ Linux file permissions
- ❌ Many Python packages that require Linux

**Solution**: Use WSL2 (Windows Subsystem for Linux) - it's free and built into Windows 10/11!

---

## 📋 Step-by-Step Installation

### Step 1: Install WSL2

**Open PowerShell as Administrator:**
1. Press `Win + X`
2. Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

**Run this command:**
```powershell
wsl --install
```

**Reboot your computer when prompted.**

After reboot, Ubuntu will automatically open and complete setup.

---

### Step 2: Set Up Ubuntu

When Ubuntu opens for the first time:

1. **Create a username** (lowercase, no spaces)
   ```
   Enter new UNIX username: yourname
   ```

2. **Create a password** (you won't see it as you type)
   ```
   New password: ********
   Retype new password: ********
   ```

3. **Update Ubuntu:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

---

### Step 3: Install Git

```bash
sudo apt install git -y
```

Verify:
```bash
git --version
```

---

### Step 4: Install uv (Python Environment Manager)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Reload your shell:**
```bash
source ~/.bashrc
```

Verify:
```bash
uv --version
```

---

### Step 5: Clone the Project

**⚠️ IMPORTANT: Clone into Linux home directory, NOT `/mnt/c`**

```bash
# Go to your Linux home directory
cd ~

# Clone the project
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git

# Rename for convenience (optional)
mv nvidia-nim-swtich-python nvidia-nim

# Enter the project
cd nvidia-nim
```

**Why not `/mnt/c`?**
- `/mnt/c` is your Windows C: drive
- File permissions don't work correctly there
- Much slower performance
- Can cause weird errors

---

### Step 6: Get Your NVIDIA API Key

1. Visit: https://build.nvidia.com/explore/discover
2. Sign in or create an account
3. Click "Get API Key"
4. Copy your API key (starts with `nvapi-`)

---

### Step 7: Configure Your API Key

```bash
# Copy the example file
cp .env.example .env

# Edit with nano
nano .env
```

**In nano editor:**
1. Find the line: `NVIDIA_NIM_API_KEY=""`
2. Add your key: `NVIDIA_NIM_API_KEY="nvapi-xxxxxxxxxxxxxx"`
3. Press `Ctrl + O` to save
4. Press `Enter` to confirm
5. Press `Ctrl + X` to exit

---

### Step 8: Install Dependencies

```bash
uv sync
```

This will install all Python packages needed.

---

### Step 9: Install Global Commands

```bash
./scripts/install_global.sh
source ~/.bashrc
```

---

### Step 10: Start the Server

```bash
nim-start
```

You should see:
```
🚀 Starting NVIDIA NIM Switch server...
✅ Server running at http://localhost:8089
🌐 Web Interface: http://localhost:8089/
```

---

## ✅ Verify Installation

### Test 1: Health Check
```bash
curl http://localhost:8089/health
```

Expected: `{"status":"healthy"}`

### Test 2: Check Status
```bash
nim-status
```

### Test 3: Open Web Interface

**From Windows:**
1. Open your browser (Chrome, Edge, Firefox)
2. Go to: http://localhost:8089/

You should see the NVIDIA NIM Model Switcher interface!

---

## 🎯 Daily Usage

### Starting the Server

**Every time you open WSL:**
```bash
cd ~/nvidia-nim
nim-start
```

### Using with Claude Code

**From any project folder in WSL:**
```bash
cd ~/your-project
nim-claude
```

### Switching Models

**Option 1: Web Interface**
```bash
nim-web  # Opens browser
```

**Option 2: Command Line**
```bash
nim-switch deepseek-v3.1
nim-switch qwen-coder
nim-switch llama-8b
```

---

## 🔧 Troubleshooting

### Issue 1: "wsl: command not found"

**Cause**: WSL not installed or not in PATH

**Solution**:
1. Make sure you're on Windows 10 (version 2004+) or Windows 11
2. Run PowerShell as Administrator
3. Run: `wsl --install`
4. Reboot

### Issue 2: "sudo: command not found"

**Cause**: You're running in PowerShell/CMD, not WSL

**Solution**:
1. Open "Ubuntu" from Start Menu
2. Run commands there, not in PowerShell

### Issue 3: "Permission denied" errors

**Cause**: Project cloned to `/mnt/c` (Windows drive)

**Solution**:
```bash
# Remove the wrong location
rm -rf /mnt/c/Users/YourName/nvidia-nim

# Clone to Linux home
cd ~
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
mv nvidia-nim-swtich-python nvidia-nim
cd nvidia-nim
```

### Issue 4: "curl: command not found"

**Cause**: Ubuntu not fully updated

**Solution**:
```bash
sudo apt update
sudo apt install curl -y
```

### Issue 5: Can't access http://localhost:8089 from Windows browser

**Cause**: Firewall or WSL networking issue

**Solution 1 - Check server is running:**
```bash
nim-status
```

**Solution 2 - Restart WSL networking:**
```powershell
# In PowerShell as Admin
wsl --shutdown
# Then reopen Ubuntu and start server
```

**Solution 3 - Use WSL IP directly:**
```bash
# In WSL, get your IP
ip addr show eth0 | grep inet
# Use that IP in browser: http://172.x.x.x:8089
```

### Issue 6: "uv: command not found" after installation

**Cause**: Shell not reloaded

**Solution**:
```bash
source ~/.bashrc
# Or close and reopen Ubuntu
```

---

## 🔄 Reset/Reinstall

**If something is broken, start fresh:**

```bash
# Remove the project
cd ~
rm -rf ~/nvidia-nim

# Re-clone
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
mv nvidia-nim-swtich-python nvidia-nim
cd nvidia-nim

# Reconfigure
cp .env.example .env
nano .env  # Add your API key

# Reinstall
uv sync
./scripts/install_global.sh
source ~/.bashrc

# Start
nim-start
```

---

## 💡 Pro Tips for Windows Users

### 1. Access Windows Files from WSL

Your Windows drives are mounted at `/mnt/`:
```bash
cd /mnt/c/Users/YourName/Documents  # Windows Documents
cd /mnt/d/Projects                   # D: drive
```

**But remember**: Don't clone the project there!

### 2. Access WSL Files from Windows

In File Explorer, type:
```
\\wsl$\Ubuntu\home\yourname\nvidia-nim
```

Or just:
```
\\wsl$
```

### 3. Use Windows Terminal

Install "Windows Terminal" from Microsoft Store for a better experience:
- Multiple tabs
- Better colors
- Copy/paste works better

### 4. VS Code Integration

Install "Remote - WSL" extension in VS Code:
```bash
# In WSL
cd ~/nvidia-nim
code .
```

This opens VS Code with full WSL integration!

### 5. Keep WSL Updated

```bash
# Update Ubuntu packages
sudo apt update && sudo apt upgrade -y

# Update WSL itself (in PowerShell as Admin)
wsl --update
```

---

## 📊 Quick Reference

### Essential Commands

```bash
# Navigate to project
cd ~/nvidia-nim

# Start server
nim-start

# Stop server
nim-stop

# Check status
nim-status

# Open web interface
nim-web

# Use with Claude Code
nim-claude

# Switch models
nim-switch model-name
```

### File Locations

```bash
# Project location
~/nvidia-nim

# Config file
~/nvidia-nim/.env

# Logs
~/nvidia-nim/server.log
```

### WSL Commands (from PowerShell)

```powershell
# List WSL distributions
wsl --list

# Shutdown WSL
wsl --shutdown

# Update WSL
wsl --update

# Open Ubuntu
wsl
```

---

## 🎓 Learning Resources

### WSL Basics
- Official WSL Docs: https://docs.microsoft.com/en-us/windows/wsl/
- WSL Tutorial: https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-10

### Linux Commands
- Basic Commands: https://ubuntu.com/tutorials/command-line-for-beginners
- Nano Editor: https://www.nano-editor.org/dist/latest/cheatsheet.html

---

## ✅ Installation Checklist

- [ ] WSL2 installed
- [ ] Ubuntu set up with username/password
- [ ] Ubuntu updated (`sudo apt update && upgrade`)
- [ ] Git installed
- [ ] uv installed
- [ ] Project cloned to `~/nvidia-nim` (NOT `/mnt/c`)
- [ ] `.env` file created with API key
- [ ] Dependencies installed (`uv sync`)
- [ ] Global commands installed
- [ ] Server starts successfully
- [ ] Health check passes
- [ ] Web interface accessible from Windows browser

---

## 🎉 Success!

Once everything is working:
- ✅ Server runs in WSL
- ✅ Access web interface from Windows browser
- ✅ Use with Claude Code
- ✅ Switch between 180+ models
- ✅ All features work perfectly

**Welcome to NVIDIA NIM Switch on Windows!** 🚀

---

## 📞 Need Help?

- GitHub Issues: https://github.com/bluehawana/nvidia-nim-swtich-python/issues
- Check other docs: `docs/` folder
- WSL Issues: https://github.com/microsoft/WSL/issues

---

*Last updated: February 3, 2026*
