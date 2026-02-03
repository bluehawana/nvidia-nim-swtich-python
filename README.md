# NVIDIA NIM Switch - Model Switcher for Claude Code

**Switch between 180+ NVIDIA NIM models in under 1 second!**

```
┌─────────────────────────────────────────────────────────────┐
│                    NVIDIA NIM Switch                        │
│                                                             │
│  Claude Code  ──→  Proxy (localhost:8089)  ──→  NVIDIA NIM │
│                         ↓                                   │
│                    182 Models                               │
│                  Switch in <1s                              │
└─────────────────────────────────────────────────────────────┘
```

[![Tests](https://img.shields.io/badge/tests-23%2F23%20passing-brightgreen)]()
[![Python](https://img.shields.io/badge/python-3.10%2B-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()

🌐 **[Try Live Demo](https://models.bluehawana.com)** - Free trial available!

---

## � Table of Contents

- [Features](#-features)
- [Quick Start](#-quick-start)
  - [Windows Installation](#-windows-installation)
  - [Linux/Mac Installation](#-linuxmac-installation)
- [Usage](#-usage)
- [Documentation](#-documentation)
- [Troubleshooting](#-troubleshooting)
- [Best Practices](#-best-practices)
- [Attribution](#-attribution--inspiration)

---

## ✨ Features

### 🔄 Advanced Model Switching
- **180+ NVIDIA NIM models** - Access the entire NVIDIA model catalog
- **Sub-second switching** - Change models in <1 second (60x faster than restarting)
- **No .env editing** - Switch via web UI or API, no manual config changes
- **Persistent context** - Keep your conversation history when switching models
- **Works anywhere** - Run from any project folder, not just the installation directory

### 🌐 Beautiful Web Interface
- **⚡ Speed indicators** - Visual badges showing Fast/Medium/Slow models
- **Smart sorting** - Sort by speed, name, provider, or model size
- **Performance filters** - Show only fast models when you need quick responses
- **Search functionality** - Find models instantly
- **Model size badges** - See model parameters (8B, 70B, 480B, etc.)
- **One-click switching** - Change models with a single button click

### 🔌 RESTful API
- `GET /v1/models` - List all available models
- `GET /v1/models/current` - Get currently active model
- `POST /v1/models/switch` - Switch to a different model
- Full Claude API compatibility

### 🚀 Production Ready
- Docker support with docker-compose
- Systemd service configuration
- Nginx reverse proxy setup
- Let's Encrypt SSL automation
- Rate limiting and security
- Comprehensive logging

---

## 🚀 Quick Start

Choose your operating system:

### 🪟 Windows Installation

**⚠️ CRITICAL: Windows users MUST use WSL2 (Windows Subsystem for Linux)**

This project uses Linux commands (`sudo`, `nano`, `bash`, etc.) and **will NOT work in PowerShell or CMD directly**.

**Why WSL2?**
- ✅ Full Linux compatibility
- ✅ Better performance than virtual machines
- ✅ Seamless integration with Windows
- ✅ Free and built into Windows 10/11

---

#### Step 1: Check if You Have WSL2

Open PowerShell and run:
```powershell
wsl --version
```

**If you see version info**: Skip to Step 3 (you already have WSL2!)

**If you see an error**: Continue to Step 2

---

#### Step 2: Install WSL2

**Open PowerShell as Administrator:**
1. Press `Win + X`
2. Click "Windows PowerShell (Admin)" or "Terminal (Admin)"
3. Click "Yes" on the security prompt

**Run this command:**
```powershell
wsl --install
```

You'll see:
```
Installing: Windows Subsystem for Linux
Installing: Ubuntu
```

**⚠️ IMPORTANT: Reboot your computer when installation completes!**

After reboot, Ubuntu will automatically open. If it doesn't, open "Ubuntu" from the Start Menu.

---

#### Step 3: Set Up Ubuntu (First Time Only)

When Ubuntu opens for the first time, you'll see:
```
Installing, this may take a few minutes...
```

Then it will ask for:

**1. Username** (lowercase, no spaces, no special characters):
```
Enter new UNIX username: yourname
```
Example: `john`, `alice`, `dev123`

**2. Password** (you won't see it as you type - this is normal!):
```
New password: ********
Retype new password: ********
```

**💡 TIP**: Remember this password! You'll need it for `sudo` commands.

---

#### Step 4: Update Ubuntu

Copy and paste this into Ubuntu terminal:
```bash
sudo apt update && sudo apt upgrade -y
```

Enter your password when prompted. This will take 2-5 minutes.

---

#### Step 5: Install Git

```bash
sudo apt install git -y
```

Verify it worked:
```bash
git --version
```

You should see: `git version 2.x.x`

---

#### Step 6: Install uv (Python Environment Manager)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Reload your shell:**
```bash
source ~/.bashrc
```

Verify it worked:
```bash
uv --version
```

You should see: `uv x.x.x`

---

#### Step 7: Clone the Project

**⚠️ CRITICAL: Clone to Linux home directory, NOT Windows C: drive!**

```bash
# Go to your Linux home directory
cd ~

# Clone the project
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git

# Rename for convenience (optional but recommended)
mv nvidia-nim-swtich-python nvidia-nim

# Enter the project directory
cd nvidia-nim
```

**Why not clone to `/mnt/c`?**
- `/mnt/c` is your Windows C: drive
- File permissions don't work correctly there
- Much slower performance
- Will cause weird errors with `sudo` and file operations

**Where is my project now?**
- In Linux: `~/nvidia-nim`
- From Windows File Explorer: `\\wsl$\Ubuntu\home\yourname\nvidia-nim`

---

#### Step 8: Get Your NVIDIA API Key

**Open your Windows browser** and:

1. Visit: https://build.nvidia.com/explore/discover
2. Sign in or create a free account
3. Click "Get API Key" button
4. Copy your API key (starts with `nvapi-`)

**💡 TIP**: Keep this browser tab open, you'll need the key in the next step!

---

#### Step 9: Configure Your API Key

**Back in Ubuntu terminal:**

```bash
# Copy the example configuration file
cp .env.example .env

# Open the file in nano editor
nano .env
```

**In the nano editor:**

1. You'll see a file with many settings
2. Find the line that says: `NVIDIA_NIM_API_KEY=""`
3. Use arrow keys to move cursor between the quotes
4. Paste your API key: `NVIDIA_NIM_API_KEY="nvapi-your-actual-key-here"`
5. **Save and exit:**
   - Press `Ctrl + O` (save)
   - Press `Enter` (confirm filename)
   - Press `Ctrl + X` (exit)

**💡 TIP**: To paste in Ubuntu terminal:
- Right-click to paste
- Or press `Shift + Insert`
- Or press `Ctrl + Shift + V`

---

#### Step 10: Install Python Dependencies

```bash
uv sync
```

This will install all required Python packages. Takes 1-2 minutes.

You'll see:
```
Resolved X packages in X.XXs
Installed X packages in X.XXs
```

---

#### Step 11: Install Global Commands

```bash
./scripts/install_global.sh
```

You'll see:
```
✅ Installed: nim-start
✅ Installed: nim-stop
✅ Installed: nim-status
...
```

**Reload your shell:**
```bash
source ~/.bashrc
```

---

#### Step 12: Start the Server

```bash
nim-start
```

You should see:
```
🚀 Starting NVIDIA NIM Switch server...
✅ Server running at http://localhost:8089
🌐 Web Interface: http://localhost:8089/
💚 Health: http://localhost:8089/health
```

**🎉 Success! The server is running!**

---

#### Step 13: Test in Your Windows Browser

**Open your Windows browser** (Chrome, Edge, Firefox, etc.) and go to:

```
http://localhost:8089/
```

You should see:
- ✅ NVIDIA NIM Model Switcher interface
- ✅ Current model displayed
- ✅ 182 models with speed indicators (⚡🚀🐢)
- ✅ Search bar and filters

**Test the health endpoint:**
```
http://localhost:8089/health
```

You should see: `{"status":"healthy"}`

---

#### Step 14: Use with Claude Code (Optional)

If you have Claude Code installed:

```bash
# From any project folder
cd ~/your-project
nim-claude
```

This will launch Claude Code with the NVIDIA NIM proxy!

---

### 🎯 Daily Usage on Windows

**Every time you want to use the project:**

1. Open "Ubuntu" from Start Menu
2. Start the server:
   ```bash
   nim-start
   ```
3. Use the web interface in your Windows browser: http://localhost:8089/

**To stop the server:**
```bash
nim-stop
```

**To check if it's running:**
```bash
nim-status
```

---

### 💡 Windows Pro Tips

#### Tip 1: Pin Ubuntu to Taskbar
Right-click "Ubuntu" in Start Menu → "Pin to taskbar"

#### Tip 2: Use Windows Terminal (Better Experience)
Install "Windows Terminal" from Microsoft Store for:
- Multiple tabs
- Better colors and fonts
- Easier copy/paste

#### Tip 3: Access Project Files from Windows
In Windows File Explorer, type:
```
\\wsl$\Ubuntu\home\yourname\nvidia-nim
```

Or just browse to: `\\wsl$`

#### Tip 4: Edit Files with VS Code
Install VS Code with "Remote - WSL" extension:
```bash
# In Ubuntu
cd ~/nvidia-nim
code .
```

This opens VS Code with full WSL integration!

#### Tip 5: Keep WSL Updated
```bash
# Update Ubuntu packages
sudo apt update && sudo apt upgrade -y
```

In PowerShell (as Admin):
```powershell
# Update WSL itself
wsl --update
```

---

### ⚠️ Common Windows Mistakes to Avoid

❌ **DON'T** run commands in PowerShell or CMD
✅ **DO** run commands in Ubuntu terminal

❌ **DON'T** clone to `/mnt/c/Users/YourName/...`
✅ **DO** clone to `~/nvidia-nim` (Linux home)

❌ **DON'T** edit `.env` file in Windows Notepad
✅ **DO** edit with `nano` in Ubuntu or VS Code with WSL extension

❌ **DON'T** forget to run `source ~/.bashrc` after installing
✅ **DO** reload shell or close/reopen Ubuntu

❌ **DON'T** use Windows paths like `C:\Users\...`
✅ **DO** use Linux paths like `~/nvidia-nim`

---

### 🐧 Linux/Mac Installation

#### Step 1: Clone the Repository

```bash
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
cd nvidia-nim-swtich-python
```

#### Step 2: Get NVIDIA API Key

1. Visit: https://build.nvidia.com/explore/discover
2. Sign in or create account
3. Click "Get API Key"
4. Copy your key (starts with `nvapi-`)

#### Step 3: Configure API Key

```bash
cp .env.example .env
nano .env  # or: vim .env, code .env
```

Add your API key:
```bash
NVIDIA_NIM_API_KEY="nvapi-your-key-here"
```

Save and exit.

#### Step 4: Install uv (if not installed)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc  # or source ~/.zshrc for zsh
```

#### Step 5: Install Dependencies

```bash
uv sync
```

#### Step 6: Install Global Commands

```bash
./scripts/install_global.sh
source ~/.bashrc  # or source ~/.zshrc
```

#### Step 7: Start the Server

```bash
nim-start
```

You should see:
```
🚀 Starting NVIDIA NIM Switch server...
✅ Server running at http://localhost:8089
🌐 Web Interface: http://localhost:8089/
```

#### Step 8: Test Installation

Open your browser and go to:
```
http://localhost:8089/
```

You should see the NVIDIA NIM Model Switcher interface! 🎉

---

## ✅ Verify Installation

After installation, verify everything works:

```bash
# Check server status
nim-status

# Or manually check
curl http://localhost:8089/health
```

Expected output: `{"status":"healthy"}`

---

## 🎯 Usage

### Access the Web Interface

Open your browser: **http://localhost:8089/**

You'll see:
- **Current Model** - The active model and its settings
- **Model Grid** - All 182 available models with speed indicators
- **Search Bar** - Find models quickly
- **Sort Options** - By speed, name, provider, or size
- **Filter Options** - Show only fast models
- **Switch Buttons** - One-click model switching

### Use with Claude Code

From **any project folder**:

```bash
cd ~/your-project
nim-claude
```

This will:
1. Auto-start the server if not running
2. Show you which model is active
3. Launch Claude Code with NVIDIA NIM proxy

### Switch Models

**Option 1: Web Interface** (Easiest)
```bash
nim-web  # Opens browser
# Click on any model's "Switch to Model" button
```

**Option 2: Command Line**
```bash
nim-switch deepseek-v3.1      # DeepSeek for reasoning
nim-switch qwen-coder          # Qwen for coding
nim-switch llama-8b            # Llama for speed
```

**Option 3: API Call**
```bash
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "deepseek-ai/deepseek-v3.1"}'
```

### Available Commands

```bash
nim-start      # Start the server
nim-stop       # Stop the server
nim-status     # Check server status
nim-web        # Open web interface in browser
nim-claude     # Start Claude Code with proxy
nim-switch     # Quick model switch (interactive)
```

---

## 📖 Documentation

### Installation Guides
- 🪟 **[Windows Installation](docs/WINDOWS_INSTALLATION.md)** - Complete WSL2 setup guide
- 🚀 **[Quick Start](docs/QUICK_START.md)** - Get started in 5 minutes

### Usage Guides
- 📖 **[User Guide](docs/USER_GUIDE.md)** - Complete user documentation
- 🔧 **[Use with Claude Code](docs/USE_WITH_CLAUDE_CODE.md)** - Integration guide
- 📊 **[Model Speed Guide](docs/MODEL_SPEED_GUIDE.md)** - Understanding model performance

### Deployment Guides
- 🌐 **[VPS Deployment](docs/VPS_DEPLOYMENT.md)** - Deploy to production
- ☁️ **[Cloudflare Setup](docs/CLOUDFLARE_SETUP.md)** - DNS and SSL configuration
- 🚀 **[Bluehawana Deployment](docs/BLUEHAWANA_DEPLOYMENT.md)** - Specific deployment guide

### Technical Documentation
- 📊 **[Testing Summary](docs/TESTING_SUMMARY.md)** - Test results (23/23 passed)
- 📁 **[All Documentation](docs/)** - Complete documentation folder

---

## 🐛 Troubleshooting

### Windows Issues

#### ❌ "wsl: command not found" in PowerShell

**Problem**: WSL not installed or not available

**Solution**:
1. Make sure you're on Windows 10 (version 2004 or higher) or Windows 11
2. Check Windows version: Press `Win + R`, type `winver`, press Enter
3. If version is too old, update Windows
4. Run PowerShell as Administrator
5. Run: `wsl --install`
6. Reboot computer

#### ❌ "sudo: command not found" or "nano: command not found"

**Problem**: You're running commands in PowerShell or CMD, not WSL2

**Solution**:
1. Close PowerShell/CMD
2. Press `Win` key
3. Type "Ubuntu"
4. Click "Ubuntu" app (NOT PowerShell!)
5. Run all commands in the Ubuntu terminal

**How to tell the difference:**
- ❌ PowerShell: `PS C:\Users\YourName>`
- ❌ CMD: `C:\Users\YourName>`
- ✅ Ubuntu/WSL: `yourname@DESKTOP-XXX:~$`

#### ❌ "Permission denied" errors

**Problem**: Project cloned to Windows drive (`/mnt/c`)

**Solution**:
```bash
# Check where you are
pwd

# If you see /mnt/c/..., you're in the wrong place!
# Remove the project
cd ~
rm -rf /mnt/c/Users/YourName/nvidia-nim  # or wherever it is

# Clone to correct location (Linux home)
cd ~
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
mv nvidia-nim-swtich-python nvidia-nim
cd nvidia-nim

# Verify you're in the right place
pwd
# Should show: /home/yourname/nvidia-nim
```

#### ❌ Can't access http://localhost:8089 from Windows browser

**Problem**: WSL networking issue or server not running

**Solution 1** - Check if server is actually running:
```bash
nim-status
```

If it says "not running":
```bash
nim-start
```

**Solution 2** - Restart WSL networking:
```powershell
# In PowerShell as Administrator
wsl --shutdown
```
Then reopen Ubuntu and start the server again.

**Solution 3** - Use WSL IP address directly:
```bash
# In Ubuntu, get your WSL IP address
ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
```

Copy that IP (e.g., `172.24.123.45`) and use in browser:
```
http://172.24.123.45:8089/
```

**Solution 4** - Check Windows Firewall:
1. Open Windows Security
2. Go to Firewall & network protection
3. Click "Allow an app through firewall"
4. Make sure WSL is allowed

#### ❌ "curl: command not found"

**Problem**: Ubuntu not fully set up

**Solution**:
```bash
sudo apt update
sudo apt install curl -y
```

#### ❌ "uv: command not found" after installation

**Problem**: Shell not reloaded

**Solution**:
```bash
source ~/.bashrc
```

Or close Ubuntu and reopen it.

#### ❌ Installation stuck or very slow

**Problem**: Windows Defender or antivirus scanning files

**Solution**:
1. Add WSL to Windows Defender exclusions:
   - Open Windows Security
   - Go to Virus & threat protection
   - Click "Manage settings"
   - Scroll to "Exclusions"
   - Add: `\\wsl$\Ubuntu\home\yourname\nvidia-nim`

2. Or temporarily disable real-time protection during installation

#### ❌ "git clone" fails with SSL error

**Problem**: Corporate firewall or proxy

**Solution**:
```bash
# Use HTTPS instead of git protocol
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git

# If still fails, configure git to use your proxy
git config --global http.proxy http://proxy.company.com:8080
```

#### ❌ Can't paste into Ubuntu terminal

**Problem**: Different paste shortcuts in WSL

**Solutions** (try these):
1. Right-click in terminal
2. Press `Shift + Insert`
3. Press `Ctrl + Shift + V`
4. In Windows Terminal: `Ctrl + V` works normally

#### ❌ "E: Could not get lock /var/lib/dpkg/lock"

**Problem**: Another apt process running

**Solution**:
```bash
# Wait a minute for other process to finish
# Or force remove lock (use carefully!)
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock
sudo dpkg --configure -a
sudo apt update
```

#### ❌ WSL uses too much memory

**Problem**: WSL default memory allocation

**Solution**:
Create `.wslconfig` file in Windows:
```powershell
# In PowerShell
notepad $env:USERPROFILE\.wslconfig
```

Add this content:
```ini
[wsl2]
memory=4GB
processors=2
```

Save, then restart WSL:
```powershell
wsl --shutdown
```

#### ❌ "The system cannot find the path specified" when opening Ubuntu

**Problem**: WSL installation incomplete

**Solution**:
```powershell
# In PowerShell as Administrator
wsl --install Ubuntu
wsl --set-default-version 2
wsl --set-default Ubuntu
```

---

### 🔄 Reset/Reinstall on Windows

**If everything is broken, start completely fresh:**

#### Option 1: Reset Project Only
```bash
# In Ubuntu
cd ~
rm -rf ~/nvidia-nim

# Re-clone and set up
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
mv nvidia-nim-swtich-python nvidia-nim
cd nvidia-nim
cp .env.example .env
nano .env  # Add your API key
uv sync
./scripts/install_global.sh
source ~/.bashrc
nim-start
```

#### Option 2: Reset Ubuntu (Nuclear Option)
```powershell
# In PowerShell as Administrator
# WARNING: This deletes ALL Ubuntu files!
wsl --unregister Ubuntu
wsl --install Ubuntu
```

Then start from Step 3 of installation.

---

### Linux/Mac Issues

#### ❌ "Command not found: uv"

**Problem**: uv not installed or not in PATH

**Solution**:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc  # or source ~/.zshrc
```

#### ❌ "Command not found: nim-start"

**Problem**: Global commands not installed or shell not reloaded

**Solution**:
```bash
./scripts/install_global.sh
source ~/.bashrc  # or source ~/.zshrc
```

#### ❌ "Connection refused" when accessing http://localhost:8089

**Problem**: Server not running

**Solution**:
```bash
nim-status  # Check if running
nim-start   # Start if not running
```

#### ❌ "Invalid API key" error

**Problem**: API key not configured correctly

**Solution**:
1. Check your `.env` file has the correct API key
2. Make sure there are no extra spaces
3. Get a new key from https://build.nvidia.com/explore/discover
4. Restart the server: `nim-stop && nim-start`

#### ❌ Port 8089 already in use

**Problem**: Another service using port 8089

**Solution**:
```bash
# Check what's using the port
lsof -i :8089

# Stop the existing server
nim-stop

# Or use a different port
uv run python server.py --port 8090
```

---

### General Issues

#### ❌ Models not loading or switching fails

**Problem**: API key invalid or rate limit exceeded

**Solution**:
1. Verify API key in `.env` file
2. Check NVIDIA API status: https://build.nvidia.com/
3. Wait a few minutes if rate limited
4. Check logs: `tail -f server.log`

#### ❌ Slow model responses

**Problem**: Using a slow model

**Solution**:
1. Open web interface: `nim-web`
2. Sort by "Speed"
3. Switch to a ⚡ Fast model (like Llama 8B)
4. See [Model Speed Guide](docs/MODEL_SPEED_GUIDE.md)

---

## 💡 Best Practices

### 1. Choose the Right Model

**For Speed** (⚡ Fast):
- `meta/llama-3.1-8b-instruct` - General tasks
- `meta/llama-3.2-3b-instruct` - Simple queries
- `google/gemma-2-9b-it` - Balanced performance

**For Quality** (🚀 Medium):
- `nvidia/llama-3.1-nemotron-70b-instruct` - High quality
- `meta/llama-3.1-70b-instruct` - Complex tasks
- `mistralai/mixtral-8x7b-instruct-v0.1` - Good balance

**For Reasoning** (🐢 Slow but powerful):
- `deepseek-ai/deepseek-v3.1` - Best reasoning
- `qwen/qwen2.5-coder-32b-instruct` - Code generation
- `nvidia/llama-3.1-nemotron-70b-instruct` - Complex analysis

### 2. Use Speed Filters

In the web interface:
1. Click "Sort by: Speed"
2. Select "Filter: Fast Only" for quick responses
3. Use search to find specific models

### 3. Switch Models Based on Task

```bash
# Quick questions
nim-switch llama-8b

# Code generation
nim-switch qwen-coder

# Complex reasoning
nim-switch deepseek-v3.1

# General use
nim-switch nemotron-70b
```

### 4. Monitor Your Usage

```bash
# Check current model
curl http://localhost:8089/v1/models/current

# View server logs
tail -f server.log

# Check server status
nim-status
```

### 5. Keep Your API Key Secure

- ✅ Never commit `.env` file to git
- ✅ Use environment variables in production
- ✅ Rotate keys periodically
- ✅ Don't share your API key

### 6. Update Regularly

```bash
cd ~/nvidia-nim  # or your installation directory
git pull
uv sync
nim-stop
nim-start
```

### 7. Use Global Commands

Instead of:
```bash
cd ~/nvidia-nim
uv run python server.py
```

Use:
```bash
nim-start  # Works from anywhere!
```

### 8. Backup Your Configuration

```bash
# Backup your .env file
cp .env .env.backup

# Save your preferred model
echo "MY_FAVORITE_MODEL=nvidia/llama-3.1-nemotron-70b-instruct" >> .env.backup
```

---

## 🙏 Attribution & Inspiration

This project was inspired by and built upon ideas from the AI proxy community.

### 🌟 Special Thanks

- **[@Gorden_Sun](https://twitter.com/Gorden_Sun)** - For sharing about NVIDIA's free API offerings
- **[cc-nim](https://github.com/Alishahryar1/cc-nim)** by [@Alishahryar1](https://github.com/Alishahryar1) - Original concept for Claude Code + NVIDIA NIM integration
- **NVIDIA Build Platform** - For providing free access to 180+ AI models

### ✨ What Makes This Project Different

While inspired by existing projects, we've built something significantly enhanced:

| Feature | Original Projects | This Project |
|---------|------------------|--------------|
| Model Switching | Manual .env editing | Web UI + API (1-click) |
| Context Preservation | Lost on switch | Maintained |
| Visual Interface | None | Beautiful web dashboard |
| Speed Indicators | No | Yes (⚡🚀🐢) |
| Sorting & Filtering | No | Yes (by speed, size, provider) |
| Cross-Folder Support | No | Yes (works anywhere) |
| Production Ready | No | Yes (Docker, systemd, Nginx) |
| Documentation | Basic | 15+ comprehensive guides |
| Testing | None | 23 automated tests |
| Windows Support | No | Yes (WSL2 guide) |

**See [ATTRIBUTION.md](ATTRIBUTION.md) for complete details.**

---

## 📜 Disclaimer

### Open Source & Non-Profit
This is an **independent, open-source, free, non-profit project** created for **educational and research purposes** to help democratize access to AI technology.

### Trademarks
**NVIDIA** and **NVIDIA NIM** are trademarks of NVIDIA Corporation. This project is **not officially affiliated with or endorsed by NVIDIA**. All AI models are provided by NVIDIA's platform at [build.nvidia.com](https://build.nvidia.com).

### Copyright Notice
If any individual or organization believes this project constitutes copyright infringement or conflicts with their interests, please contact us directly via [GitHub Issues](https://github.com/bluehawana/nvidia-nim-swtich-python/issues) and we will address the concern promptly.

---

## 🏷️ Tags

`#AI` `#MachineLearning` `#NVIDIA` `#OpenSource` `#Python` `#DeveloperTools` `#NewYearNewProject` `#AIProxy` `#ModelSwitching` `#FastAPI` `#ClaudeCode`

---

## 📞 Support & Community

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/bluehawana/nvidia-nim-swtich-python/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/bluehawana/nvidia-nim-swtich-python/discussions)
- 📖 **Documentation**: [docs/](docs/) folder
- 🌐 **Live Demo**: https://models.bluehawana.com

---

## 📊 Project Stats

- ✅ **23/23 tests passing**
- 🌟 **180+ models supported**
- ⚡ **<1 second model switching**
- 📖 **15+ documentation guides**
- 🐳 **Docker ready**
- 🔒 **Production tested**

---

## License

MIT License - See [LICENSE](LICENSE) for details.

---

**Made with ❤️ for the open-source AI community**

*Together, we're making AI more accessible!* 🚀
