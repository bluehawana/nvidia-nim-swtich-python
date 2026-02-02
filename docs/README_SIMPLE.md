# 🚀 NVIDIA NIM Switch - Simple Guide

Use 180+ NVIDIA NIM models with Claude Code. Switch models in 1 second. Works from any folder.

---

## ⚡ Quick Install

```bash
git clone https://github.com/bluehawana/nvidia-nim-swtich-python.git
cd nvidia-nim-swtich-python
./install_global.sh
source ~/.bashrc
```

---

## 🎯 Three Simple Commands

### 1. Start Server (Once)
```bash
nim-start
```

### 2. Switch Models (Visual)
```bash
nim-web
```
Opens browser → Click any model → Done!

### 3. Use Claude Code (Anywhere)
```bash
cd ~/your-project
nim-claude
```

---

## ✨ What You Get

- ✅ **182 models** (DeepSeek, Llama, Qwen, etc.)
- ✅ **1-second switching** (vs 30-60s in Claude Code)
- ✅ **Works anywhere** (any project folder)
- ✅ **Visual interface** (http://localhost:8089/)
- ✅ **No restart needed**

---

## 📝 All Commands

```bash
nim-start      # Start server
nim-stop       # Stop server
nim-status     # Check status
nim-web        # Open web interface
nim-claude     # Start Claude Code
nim-switch     # Quick CLI switch
```

---

## 🎬 Example Usage

```bash
# Start once
nim-start

# Switch to coding model
nim-web  # Click "Qwen Coder"

# Work on any project
cd ~/my-project
nim-claude

# Switch to reasoning model
nim-switch deepseek-v3.1

# Continue coding
nim-claude
```

---

## 🔧 Setup Your API Key

Edit `.env` file:
```bash
NVIDIA_NIM_API_KEY=your_key_here
```

Get key: https://build.nvidia.com/explore/discover

---

## 📚 More Info

- Full guide: [USER_GUIDE.md](USER_GUIDE.md)
- Test results: [FINAL_TEST_RESULTS.md](FINAL_TEST_RESULTS.md)
- Documentation: [README.md](README.md)

---

**That's it! Simple, fast, powerful.** 🎉
