# cc-nvd-python (Enhanced NVIDIA NIM Manager)

Independent enhancement of NVIDIA NIM proxy with advanced model switching capabilities.

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

**Switch between 180+ NVIDIA NIM models in under 1 second!**

[![Tests](https://img.shields.io/badge/tests-23%2F23%20passing-brightgreen)]()
[![Python](https://img.shields.io/badge/python-3.10%2B-blue)]()
[![License](https://img.shields.io/badge/license-MIT-green)]()

---

## 🌟 Enhanced Features

### 🔄 Advanced Model Switching
- Switch between 1,000+ NVIDIA NIM models on-the-fly via API or web interface
- Persistent model selection across server restarts
- No need to manually edit environment variables or restart services

### 🌐 Web Interface for NVIDIA NIM
- User-friendly web dashboard for browsing and selecting NVIDIA NIM models
- Search functionality to quickly find models
- Real-time model switching with visual feedback

### 🔌 NVIDIA NIM RESTful API
- `GET /v1/models` - List all available NVIDIA NIM models
- `GET /v1/models/current` - Get the currently selected NVIDIA NIM model
- `POST /v1/models/switch` - Switch to a different NVIDIA NIM model
- Full compatibility with NVIDIA NIM API specifications

### ⚡ Optimized for NVIDIA NIM
- Built specifically for NVIDIA NIM performance
- Supports all NVIDIA NIM parameters and features
- Optimized streaming responses for NVIDIA NIM

## 🚀 Installation Methods

### Method 1: Git Clone (Recommended for Development)

**Step 1: Clone the Repository**
```bash
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
cd nvidia-nim-swtich-python
```

**Step 2: Get Your NVIDIA NIM API Key**
1. Visit [NVIDIA Build](https://build.nvidia.com/explore/discover)
2. Sign in or create an account
3. Generate your NVIDIA NIM API key
4. Copy the API key (starts with `nvapi-`)

**Step 3: Configure Your API Key**
```bash
# Copy the example file
cp .env.example .env

# Edit the .env file
nano .env  # or use: vim .env, code .env, etc.
```

Add your API key to the `.env` file:
```bash
NVIDIA_NIM_API_KEY=nvapi-your-actual-key-here
```

**Step 4: Install Dependencies**
```bash
# Install uv if you don't have it
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install project dependencies
uv sync
```

**Step 5: Install Global Commands**
```bash
./scripts/install_global.sh
source ~/.bashrc  # or source ~/.zshrc for zsh
```

**Step 6: Start the Server**
```bash
nim-start
```

### Method 2: Homebrew (Coming Soon)

Homebrew installation will be available after the first stable release:

```bash
# Coming soon
brew tap bluehawana/nvidia-nim-switch
brew install nvidia-nim-switch
```

### Method 3: Manual Start (Without Global Install)

If you prefer not to install global commands:

```bash
# After steps 1-4 above
uv run python server.py --host 0.0.0.0 --port 8089
```

---

## ✅ Verify Installation

After installation, verify everything works:

```bash
# Check server status
nim-status

# Or manually check
curl http://localhost:8089/health
```

You should see: `{"status":"healthy"}`

---

## 🎯 Usage

### Access the Web Interface

Open your browser and go to: **http://localhost:8089/**

You'll see:
- **Current Model** - The active model and its settings
- **Model Grid** - All 182 available models
- **Search Bar** - Find models quickly
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
3. Launch Claude Code with NVIDIA NIM models

### Switch Models

**Option 1: Web Interface** (Easiest)
```bash
nim-web  # Opens browser
# Click on any model to switch
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
nim-web        # Open web interface
nim-claude     # Start Claude Code with proxy
nim-switch     # Quick model switch
```

---

## 📖 Detailed Guides

- 📘 [Complete User Guide](docs/USER_GUIDE.md) - Everything you need to know
- 🚀 [Quick Start Guide](docs/QUICK_START.md) - Get started in 5 minutes
- 🔧 [Use with Claude Code](docs/USE_WITH_CLAUDE_CODE.md) - Integration guide

---

## 🐛 Troubleshooting

### "Command not found: uv"
Install uv first:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### "Command not found: nim-start"
Reload your shell after installation:
```bash
source ~/.bashrc  # or source ~/.zshrc
```

### "Connection refused" when accessing http://localhost:8089
Make sure the server is running:
```bash
nim-status  # Check if running
nim-start   # Start if not running
```

### "Invalid API key" error
1. Check your `.env` file has the correct API key
2. Make sure there are no extra spaces
3. Get a new key from https://build.nvidia.com/explore/discover
4. Restart the server after updating `.env`

### Port 8089 already in use
```bash
# Check what's using the port
lsof -i :8089

# Stop the existing server
nim-stop

# Or use a different port
uv run python server.py --port 8090
```

---

## Setup Your NVIDIA NIM API Key

1. Visit [NVIDIA Build](https://build.nvidia.com/explore/discover)
2. Generate your NVIDIA NIM API key
3. Configure your key in the `.env` file:
   ```
   NVIDIA_NIM_API_KEY=your_nvidia_api_key_here
   ```

## NVIDIA NIM Model Switching API

### List Available NVIDIA NIM Models
```bash
curl http://localhost:8089/v1/models
```

### Get Current NVIDIA NIM Model
```bash
curl http://localhost:8089/v1/models/current
```

### Switch NVIDIA NIM Models
```bash
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "nvidia/llama-3.1-nemotron-70b-instruct"}'
```

## Web Interface

Access the web interface at `http://localhost:8089/` to visually browse and switch between NVIDIA NIM models with a modern, responsive UI.

## Installation

See [INSTALLATION.md](INSTALLATION.md) for detailed installation instructions.

Or use the quick global install:
```bash
./scripts/install_global.sh
```

## Documentation

- 📖 [User Guide](docs/USER_GUIDE.md) - Complete user documentation
- 🚀 [Quick Start](docs/QUICK_START.md) - Get started in 5 minutes
- 🔧 [Use with Claude Code](docs/USE_WITH_CLAUDE_CODE.md) - Integration guide
- 📊 [Testing Summary](docs/TESTING_SUMMARY.md) - Test results (23/23 passed)
- 📁 [All Documentation](docs/) - Complete documentation folder

## Attribution

This is an **independent project** that draws inspiration from concepts in various AI proxy implementations. See [ATTRIBUTION.md](ATTRIBUTION.md) for details.

## Trademarks

NVIDIA and NVIDIA NIM are trademarks of NVIDIA Corporation. This project is not officially affiliated with or endorsed by NVIDIA.

## License

MIT