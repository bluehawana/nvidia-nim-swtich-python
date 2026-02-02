# 🚀 Quick Start Guide

## For Developers Who Want to Use NVIDIA NIM with Claude Code

---

## What You Get

✨ Use **180+ NVIDIA NIM models** with **Claude Code IDE**  
✨ Switch models in **1-2 seconds** (vs 30-60 seconds in Claude Code)  
✨ No code changes needed - drop-in replacement for Claude API  
✨ Beautiful web interface for model management  

---

## Installation (5 minutes)

### Step 1: Clone the Repository
```bash
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
cd nvidia-nim-swtich-python
```

### Step 2: Install Dependencies
```bash
# Make sure you have uv installed
# If not: curl -LsSf https://astral.sh/uv/install.sh | sh

uv sync
```

### Step 3: Configure Your API Key
```bash
# Copy the example env file
cp .env.example .env

# Edit .env and add your NVIDIA API key
# Get your key from: https://build.nvidia.com/explore/discover
nano .env  # or use your favorite editor
```

Add your key:
```bash
NVIDIA_NIM_API_KEY=your_nvidia_api_key_here
```

### Step 4: Start the Server
```bash
uv run python server.py --host 0.0.0.0 --port 8089
```

You should see:
```
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8089
```

---

## Usage

### Option 1: Web Interface (Easiest)

1. Open your browser: **http://localhost:8089/**
2. Browse available models
3. Click "Switch to this model" on any model
4. Done! ✨

### Option 2: Use with Claude Code

```bash
# Set the proxy URL
export ANTHROPIC_BASE_URL=http://localhost:8089

# Start Claude Code
claude
```

Now Claude Code will use NVIDIA NIM models instead of Claude!

### Option 3: API Calls

```bash
# List all available models
curl http://localhost:8089/v1/models

# Get current model
curl http://localhost:8089/v1/models/current

# Switch to a different model
curl -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d '{"model": "deepseek-ai/deepseek-v3.1"}'

# Send a message (Claude API format)
curl -X POST http://localhost:8089/v1/messages \
  -H "Content-Type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 1024,
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

---

## Popular Models to Try

### 🧠 Reasoning Models
- `deepseek-ai/deepseek-v3.1` - Excellent reasoning
- `deepseek-ai/deepseek-r1-distill-qwen-32b` - Fast reasoning
- `qwen/qwq-32b-preview` - Qwen reasoning

### 💻 Coding Models
- `qwen/qwen3-coder-480b-a35b-instruct` - Best for coding
- `deepseek-ai/deepseek-coder-6.7b-instruct` - Fast coding
- `meta/llama-3.1-70b-instruct` - General purpose

### ⚡ Fast Models
- `meta/llama-3.1-8b-instruct` - Very fast
- `google/gemma-2-9b-it` - Fast and efficient
- `microsoft/phi-3-medium-4k-instruct` - Compact

### 🎯 Specialized
- `nvidia/llama-3.1-nemotron-70b-instruct` - NVIDIA optimized
- `mistralai/mistral-large-2-instruct` - Multilingual
- `01-ai/yi-large` - Chinese + English

---

## Testing

### Run All Tests
```bash
# Test model switching
uv run python test_model_switching.py

# Test Claude API compatibility
uv run python test_claude_compatibility.py

# Run demo
uv run python demo.py
```

---

## Troubleshooting

### Server won't start
```bash
# Check if port 8089 is already in use
lsof -i :8089

# Kill existing process
kill -9 <PID>

# Or use a different port
uv run python server.py --port 8090
```

### API key not working
1. Get a new key from https://build.nvidia.com/explore/discover
2. Make sure there are no spaces in your `.env` file
3. Restart the server after changing `.env`

### Models not loading
```bash
# Check if nvidia_nim_models.json exists
ls -la nvidia_nim_models.json

# Check server logs
tail -f server.log
```

---

## Tips & Tricks

### 1. Keep Server Running
```bash
# Run in background
nohup uv run python server.py > server.log 2>&1 &

# Check if running
curl http://localhost:8089/health
```

### 2. Quick Model Switch
```bash
# Create an alias for quick switching
alias switch-model='curl -X POST http://localhost:8089/v1/models/switch -H "Content-Type: application/json" -d'

# Usage
switch-model '{"model": "deepseek-ai/deepseek-v3.1"}'
```

### 3. Monitor Usage
```bash
# Watch server logs in real-time
tail -f server.log

# Or use the output log
tail -f server_output.log
```

---

## Performance Comparison

| Feature | Claude Code | NVIDIA NIM Switch |
|---------|-------------|-------------------|
| Model switching time | 30-60 seconds | 1-2 seconds ⚡ |
| Requires restart | Yes | No ✨ |
| Available models | ~5 | 180+ 🎉 |
| Web interface | No | Yes 🌐 |
| API for switching | No | Yes 🔌 |

---

## What's Next?

1. ⭐ Star the repo: https://github.com/bluehawana/nvidia-nim-swtich-python
2. 🐛 Report issues on GitHub
3. 💡 Suggest new features
4. 🤝 Contribute improvements

---

## Support

- 📖 Full docs: [README.md](README.md)
- 🔧 Model switching: [MODEL_SWITCHING.md](MODEL_SWITCHING.md)
- 📊 Project status: [PROJECT_STATUS.md](PROJECT_STATUS.md)
- 🐛 Issues: https://github.com/bluehawana/nvidia-nim-swtich-python/issues

---

## License

MIT License - Use freely!

---

**Happy coding with NVIDIA NIM! 🚀**
