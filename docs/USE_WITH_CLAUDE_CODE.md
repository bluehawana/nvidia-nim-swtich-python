# 🎯 How to Use with Claude Code

## Quick Start (3 Steps)

### Step 1: Start the Proxy Server

**Option A: Using the helper script (easiest)**
```bash
./start_with_claude.sh
```

**Option B: Manual start**
```bash
uv run python server.py --host 0.0.0.0 --port 8089
```

Keep this terminal window open!

---

### Step 2: Open a NEW Terminal Window

Open a new terminal (don't close the server terminal!)

---

### Step 3: Start Claude Code with the Proxy

**Option A: One-line command (recommended)**
```bash
ANTHROPIC_BASE_URL=http://localhost:8089 claude -dangerously-skip-permissions
```

**Option B: Export then run**
```bash
export ANTHROPIC_BASE_URL=http://localhost:8089
claude -dangerously-skip-permissions
```

**Option C: Add to your shell profile (permanent)**

Add this to your `~/.zshrc` or `~/.bashrc`:
```bash
export ANTHROPIC_BASE_URL=http://localhost:8089
```

Then reload:
```bash
source ~/.zshrc  # or source ~/.bashrc
claude -dangerously-skip-permissions
```

---

## ✅ Verify It's Working

### In Claude Code, try this:
```
@claude What model are you using?
```

Claude should respond with the NVIDIA NIM model name (not "Claude")!

### Or check via API:
```bash
curl http://localhost:8089/v1/models/current
```

---

## 🔄 Switch Models

### Option 1: Web Interface (Easiest)
1. Open http://localhost:8089/ in your browser
2. Browse available models
3. Click "Switch to this model"
4. Continue using Claude Code - it will use the new model!

### Option 2: API Call
```bash
# Switch to DeepSeek v3.1
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "deepseek-ai/deepseek-v3.1"}'

# Switch to Llama 3.1 8B (fast)
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "meta/llama-3.1-8b-instruct"}'

# Switch to Qwen Coder (best for coding)
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "qwen/qwen3-coder-480b-a35b-instruct"}'
```

---

## 🛑 Stop the Server

When you're done:
```bash
pkill -f 'python server.py'
```

Or press `Ctrl+C` in the server terminal.

---

## 🐛 Troubleshooting

### "Connection refused" error
**Problem**: Server is not running  
**Solution**: Start the server first (Step 1)

### Claude Code still uses Claude models
**Problem**: Environment variable not set  
**Solution**: Make sure you set `ANTHROPIC_BASE_URL` before starting Claude Code

### "Port already in use"
**Problem**: Server is already running or port is taken  
**Solution**: 
```bash
# Check what's using port 8089
lsof -i :8089

# Kill it if needed
pkill -f 'python server.py'

# Or use a different port
uv run python server.py --port 8090
# Then use: ANTHROPIC_BASE_URL=http://localhost:8090
```

### Models not switching
**Problem**: Server needs restart or cache issue  
**Solution**:
```bash
# Restart server
pkill -f 'python server.py'
./start_with_claude.sh

# Clear Claude Code cache (if needed)
rm -rf ~/.claude/cache
```

---

## 💡 Pro Tips

### 1. Keep Server Running in Background
```bash
# Start in background
nohup uv run python server.py > server.log 2>&1 &

# Check if running
curl http://localhost:8089/health
```

### 2. Create an Alias
Add to your `~/.zshrc`:
```bash
alias claude-nim='ANTHROPIC_BASE_URL=http://localhost:8089 claude -dangerously-skip-permissions'
```

Then just run:
```bash
claude-nim
```

### 3. Monitor Server Logs
```bash
tail -f server_output.log
```

### 4. Quick Model Info
```bash
# See current model
curl -s http://localhost:8089/v1/models/current | python3 -m json.tool

# List all models
curl -s http://localhost:8089/v1/models | python3 -m json.tool | less
```

---

## 📊 Popular Models to Try

### For Coding
```bash
# Best coding model
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "qwen/qwen3-coder-480b-a35b-instruct"}'

# Fast coding
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "deepseek-ai/deepseek-coder-6.7b-instruct"}'
```

### For Reasoning
```bash
# Best reasoning
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "deepseek-ai/deepseek-v3.1"}'

# Fast reasoning
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "qwen/qwq-32b-preview"}'
```

### For Speed
```bash
# Very fast
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "meta/llama-3.1-8b-instruct"}'
```

---

## 🎉 You're All Set!

Now you can:
- ✅ Use 180+ NVIDIA NIM models with Claude Code
- ✅ Switch models in 1-2 seconds (no restart needed!)
- ✅ Use the web interface for easy model management
- ✅ Keep coding without interruption

**Happy coding! 🚀**
