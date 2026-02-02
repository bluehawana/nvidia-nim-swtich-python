# 🎯 NVIDIA NIM Switch - User Guide

## The Simplest Way to Use NVIDIA NIM with Claude Code

---

## 🚀 One-Time Setup (2 Minutes)

### Step 1: Install Globally
```bash
./install_global.sh
```

### Step 2: Reload Your Shell
```bash
source ~/.bashrc  # or source ~/.zshrc
```

**That's it!** You now have 6 simple commands available from ANY folder.

---

## 📝 Simple Commands (No UV, No Complexity!)

### 1. `nim-start` - Start the Server
```bash
nim-start
```
Starts the proxy server in the background. You only need to do this once!

### 2. `nim-web` - Open Visual Interface
```bash
nim-web
```
Opens http://localhost:8089/ in your browser where you can:
- ✅ See all 182 available models
- ✅ Search for models
- ✅ Click to switch models instantly
- ✅ See current model and settings

### 3. `nim-claude` - Use Claude Code from ANY Folder
```bash
cd ~/my-project
nim-claude
```
This is the magic command! It:
- ✅ Auto-starts the server if not running
- ✅ Shows you which model you're using
- ✅ Starts Claude Code with NVIDIA NIM
- ✅ Works from ANY project folder!

### 4. `nim-status` - Check What's Running
```bash
nim-status
```
Shows if server is running and which model is active.

### 5. `nim-switch` - Quick Model Switch (CLI)
```bash
nim-switch deepseek-v3.1
nim-switch qwen-coder
nim-switch llama-8b
```
Quick model switching without opening browser.

### 6. `nim-stop` - Stop the Server
```bash
nim-stop
```
Stops the proxy server when you're done.

---

## 🎬 Real-World Usage Examples

### Example 1: Working on Different Projects
```bash
# Morning: Working on a Python project
cd ~/projects/python-app
nim-claude
# Uses NVIDIA NIM models for coding

# Afternoon: Working on a React project
cd ~/projects/react-app
nim-claude
# Same proxy, different project folder!
```

### Example 2: Switching Models for Different Tasks
```bash
# Start server
nim-start

# Open web interface to browse models
nim-web
# Click on "qwen/qwen3-coder-480b-a35b-instruct" for coding

# Work on your project
cd ~/my-project
nim-claude
# Now using Qwen Coder

# Later, switch to reasoning model via CLI
nim-switch deepseek-v3.1
# Now using DeepSeek for complex reasoning
```

### Example 3: Daily Workflow
```bash
# Monday morning - start once
nim-start

# Work on project A
cd ~/projects/project-a
nim-claude

# Exit Claude Code, switch model for project B
nim-web  # Switch to a faster model

# Work on project B
cd ~/projects/project-b
nim-claude

# Friday evening - stop server
nim-stop
```

---

## 🌐 Visual Model Switching (Web Interface)

### Open the Web Interface
```bash
nim-web
```

### What You'll See:
1. **Current Model Card** - Shows active model and settings
2. **Search Bar** - Find models by name or provider
3. **Model Grid** - All 182 models with:
   - Model name
   - Provider (NVIDIA, Meta, DeepSeek, etc.)
   - "Switch to this model" button

### How to Switch:
1. Browse or search for a model
2. Click "Switch to this model"
3. See confirmation message
4. Continue using Claude Code - it's now using the new model!

**No restart needed!** The switch happens in 1-2 seconds.

---

## 🎯 Recommended Models by Use Case

### For Coding (Best)
```bash
nim-switch qwen-coder
# Full name: qwen/qwen3-coder-480b-a35b-instruct
```

### For Reasoning
```bash
nim-switch deepseek-v3.1
# Full name: deepseek-ai/deepseek-v3.1
```

### For Speed (Fast Responses)
```bash
nim-switch llama-8b
# Full name: meta/llama-3.1-8b-instruct
```

### For Power (Best Quality)
```bash
nim-switch llama-70b
# Full name: meta/llama-3.1-70b-instruct
```

---

## 🔄 How It Solves Your Problems

### Problem 1: "I don't want to remember UV commands"
**Solution**: Simple aliases!
- ❌ Before: `uv run python server.py --host 0.0.0.0 --port 8089`
- ✅ Now: `nim-start`

### Problem 2: "I need visual interface to switch models"
**Solution**: Web interface!
- ❌ Before: Complex API calls
- ✅ Now: `nim-web` → Click button

### Problem 3: "I work in different project folders"
**Solution**: Global installation!
- ❌ Before: Only works in proxy folder
- ✅ Now: Works from ANY folder with `nim-claude`

---

## 💡 Pro Tips

### 1. Auto-Start on Login (Optional)
Add to your `~/.zshrc` or `~/.bashrc`:
```bash
# Auto-start NVIDIA NIM proxy
if ! curl -s http://localhost:8089/health > /dev/null 2>&1; then
    nim-start > /dev/null 2>&1
fi
```

### 2. Create Project-Specific Aliases
```bash
# In your project's folder
alias dev='nim-claude'
```

### 3. Quick Status Check
```bash
# Add to your shell prompt (optional)
nim-status | grep "Current Model"
```

### 4. Bookmark the Web Interface
Add http://localhost:8089/ to your browser bookmarks for quick access.

---

## 🐛 Troubleshooting

### "Command not found: nim-start"
**Solution**: Reload your shell
```bash
source ~/.bashrc  # or source ~/.zshrc
# Or open a new terminal window
```

### "Server failed to start"
**Solution**: Check if port is in use
```bash
lsof -i :8089
# If something is using it, kill it or use different port
```

### "Claude Code still uses Claude models"
**Solution**: Make sure you use `nim-claude` command, not just `claude`
```bash
# Wrong
claude

# Correct
nim-claude
```

### "Models not showing in web interface"
**Solution**: Check if server is running
```bash
nim-status
# If not running:
nim-start
```

---

## 📊 Command Cheat Sheet

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `nim-start` | Start server | Once per day |
| `nim-stop` | Stop server | End of day |
| `nim-status` | Check status | Anytime |
| `nim-web` | Open web UI | To browse/switch models |
| `nim-claude` | Start Claude Code | Every time you code |
| `nim-switch` | Quick model switch | Fast CLI switching |

---

## 🎉 You're All Set!

Now you can:
- ✅ Use simple commands (no UV complexity)
- ✅ Switch models visually in browser
- ✅ Work from ANY project folder
- ✅ Switch models in 1-2 seconds
- ✅ Access 182 NVIDIA NIM models

**Just remember 3 commands**:
1. `nim-start` - Start once
2. `nim-web` - Switch models
3. `nim-claude` - Code anywhere

**Happy coding! 🚀**

---

## 📚 More Resources

- Full documentation: [README.md](README.md)
- Model switching details: [MODEL_SWITCHING.md](MODEL_SWITCHING.md)
- Testing results: [TESTING_SUMMARY.md](TESTING_SUMMARY.md)
- Quick start: [QUICK_START.md](QUICK_START.md)
