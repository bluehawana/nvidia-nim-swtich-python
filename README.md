# NVIDIA NIM Switch

**Switch between 180+ NVIDIA NIM models in under 1 second!**

```
Claude Code  ──→  Proxy (localhost:8089)  ──→  NVIDIA NIM
                       ↓
                  182 Models
                 Switch in <1s
```

[![Tests](https://img.shields.io/badge/tests-23%2F23%20passing-brightgreen)]()
[![Python](https://img.shields.io/badge/python-3.10%2B-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()

---

## ✨ Features

- 🔄 **180+ models** - Access entire NVIDIA NIM catalog
- ⚡ **Sub-second switching** - Change models in <1s via web UI or API
- 🌐 **Beautiful interface** - Speed indicators (⚡🚀🐢), search, filters
- 🔌 **RESTful API** - Full model management API
- 🚀 **Production ready** - Docker, systemd, Nginx, SSL
- 💻 **Cross-platform** - Linux, Mac, Windows (WSL2)

---

## 🚀 Quick Start

### Windows Users (WSL2 Required)

```powershell
# 1. Install WSL2 (PowerShell as Admin)
wsl --install
# Reboot, then open "Ubuntu" from Start Menu

# 2. In Ubuntu terminal:
sudo apt update && sudo apt upgrade -y
sudo apt install git -y
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# 3. Clone and setup
cd ~
git clone https://github.com/bluehawana/nvidia-nim-switch-python.git
cd nvidia-nim-switch-python
cp .env.example .env
nano .env  # Add your NVIDIA API key

# 4. Install and run
uv sync
./scripts/install_global.sh
source ~/.bashrc
nim-start
```

**Get API Key**: https://build.nvidia.com/explore/discover

**Open in Windows browser**: http://localhost:8089/

📖 **Detailed guide**: [Windows Installation](docs/WINDOWS_INSTALLATION.md)

---

### Linux/Mac Users

```bash
# 1. Clone
git clone https://github.com/bluehawana/nvidia-nim-switch-python.git
cd nvidia-nim-switch-python

# 2. Setup
cp .env.example .env
nano .env  # Add your NVIDIA API key

# 3. Install uv (if needed)
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# 4. Install and run
uv sync
./scripts/install_global.sh
source ~/.bashrc
nim-start
```

**Get API Key**: https://build.nvidia.com/explore/discover

**Open browser**: http://localhost:8089/

---

## 🎯 Usage

```bash
nim-start      # Start server
nim-stop       # Stop server
nim-status     # Check status
nim-web        # Open web interface
nim-claude     # Use with Claude Code
nim-switch     # Quick model switch
```

**Web Interface**: http://localhost:8089/

**API Endpoints**:
- `GET /v1/models` - List all models
- `GET /v1/models/current` - Get current model
- `POST /v1/models/switch` - Switch model

---

## 📖 Documentation

**Installation**:
- [Windows (WSL2)](docs/WINDOWS_INSTALLATION.md) - Complete WSL2 setup
- [Quick Start](docs/QUICK_START.md) - 5-minute guide

**Usage**:
- [User Guide](docs/USER_GUIDE.md) - Complete documentation
- [Claude Code Integration](docs/USE_WITH_CLAUDE_CODE.md)
- [Model Speed Guide](docs/MODEL_SPEED_GUIDE.md)

**Deployment**:
- [VPS Deployment](docs/VPS_DEPLOYMENT.md) - Production setup
- [Cloudflare Setup](docs/CLOUDFLARE_SETUP.md) - DNS & SSL

---

## 🐛 Troubleshooting

**Windows**: "sudo: command not found"
- You're in PowerShell/CMD, not WSL2
- Open "Ubuntu" from Start Menu

**"Command not found: uv"**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
```

**"Connection refused"**
```bash
nim-status  # Check if running
nim-start   # Start if needed
```

**More help**: See [Windows Guide](docs/WINDOWS_INSTALLATION.md) or [User Guide](docs/USER_GUIDE.md)

---

## 🙏 Attribution

**Discovered via**: [@Gorden_Sun's X.com post](https://x.com/Gorden_Sun/status/1871808558591299801) about NVIDIA's free APIs

**Learned from**: [cc-nim](https://github.com/Alishahryar1/cc-nim) by [@Alishahryar1](https://github.com/Alishahryar1) - Original Claude Code + NVIDIA NIM concept

**This project**: Independent enhancement with significant improvements:
- ✅ Web UI (vs manual .env editing)
- ✅ Instant switching (vs restart required)
- ✅ 180+ models with speed indicators
- ✅ Production deployment ready
- ✅ Comprehensive documentation
- ✅ 23 automated tests

See [ATTRIBUTION.md](ATTRIBUTION.md) for details.

---

## 📜 Disclaimer

- **Open source & non-profit** - Educational/research purposes
- **Not affiliated with NVIDIA** - Uses public NVIDIA NIM APIs
- **Independent project** - Inspired by cc-nim, built from scratch
- **Proper attribution** - Full credit to community contributors

Questions? [GitHub Issues](https://github.com/bluehawana/nvidia-nim-switch-python/issues)

---

## 📊 Stats

✅ 23/23 tests passing | 🌟 180+ models | ⚡ <1s switching | 📖 15+ guides | 🐳 Docker ready

---

## License

MIT License - See [LICENSE](LICENSE)

---

**Made with ❤️ for the open-source AI community**
