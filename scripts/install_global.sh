#!/bin/bash

# Global Installation Script for NVIDIA NIM Switch
# This installs the proxy as a global service you can use from anywhere

set -e

echo "🚀 Installing NVIDIA NIM Switch Globally..."
echo ""

# Get the current directory (where the project is)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "📁 Project directory: $PROJECT_DIR"

# Create global bin directory if it doesn't exist
GLOBAL_BIN="$HOME/.local/bin"
mkdir -p "$GLOBAL_BIN"

# Create the nim-proxy command
echo "📝 Creating global commands..."

cat > "$GLOBAL_BIN/nim-proxy" << EOF
#!/bin/bash
# NVIDIA NIM Proxy - Global Command
cd "$PROJECT_DIR"
uv run python server.py "\$@"
EOF

chmod +x "$GLOBAL_BIN/nim-proxy"

# Create nim-start command (starts in background)
cat > "$GLOBAL_BIN/nim-start" << EOF
#!/bin/bash
# Start NVIDIA NIM Proxy in background

# Check if already running
if curl -s http://localhost:8089/health > /dev/null 2>&1; then
    echo "✅ NVIDIA NIM Proxy is already running"
    echo "🌐 Web Interface: http://localhost:8089/"
    exit 0
fi

echo "🚀 Starting NVIDIA NIM Proxy..."
cd "$PROJECT_DIR"
nohup uv run python server.py --host 0.0.0.0 --port 8089 > "$PROJECT_DIR/server_output.log" 2>&1 &
PID=\$!
echo "   PID: \$PID"

# Wait for server to start
echo "⏳ Waiting for server..."
for i in {1..15}; do
    if curl -s http://localhost:8089/health > /dev/null 2>&1; then
        echo "✅ Server started successfully!"
        echo ""
        echo "🌐 Web Interface: http://localhost:8089/"
        echo "📚 API Docs: http://localhost:8089/docs"
        echo ""
        CURRENT_MODEL=\$(curl -s http://localhost:8089/v1/models/current | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['id'])" 2>/dev/null)
        if [ -n "\$CURRENT_MODEL" ]; then
            echo "📊 Current Model: \$CURRENT_MODEL"
        fi
        echo ""
        echo "💡 To use with Claude Code from ANY folder:"
        echo "   nim-claude"
        echo ""
        echo "💡 To switch models:"
        echo "   Open http://localhost:8089/ in your browser"
        echo ""
        echo "💡 To stop:"
        echo "   nim-stop"
        exit 0
    fi
    sleep 1
done

echo "❌ Server failed to start. Check logs:"
echo "   tail -f $PROJECT_DIR/server_output.log"
exit 1
EOF

chmod +x "$GLOBAL_BIN/nim-start"

# Create nim-stop command
cat > "$GLOBAL_BIN/nim-stop" << EOF
#!/bin/bash
# Stop NVIDIA NIM Proxy

echo "🛑 Stopping NVIDIA NIM Proxy..."
pkill -f "python server.py" && echo "✅ Server stopped" || echo "⚠️  Server was not running"
EOF

chmod +x "$GLOBAL_BIN/nim-stop"

# Create nim-status command
cat > "$GLOBAL_BIN/nim-status" << EOF
#!/bin/bash
# Check NVIDIA NIM Proxy status

if curl -s http://localhost:8089/health > /dev/null 2>&1; then
    echo "✅ NVIDIA NIM Proxy is running"
    echo ""
    echo "🌐 Web Interface: http://localhost:8089/"
    echo "📚 API Docs: http://localhost:8089/docs"
    echo ""
    CURRENT_MODEL=\$(curl -s http://localhost:8089/v1/models/current | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['id'])" 2>/dev/null)
    if [ -n "\$CURRENT_MODEL" ]; then
        echo "📊 Current Model: \$CURRENT_MODEL"
    fi
    echo ""
    echo "💡 Switch models: http://localhost:8089/"
else
    echo "❌ NVIDIA NIM Proxy is not running"
    echo ""
    echo "💡 Start it with: nim-start"
fi
EOF

chmod +x "$GLOBAL_BIN/nim-status"

# Create nim-web command (opens web interface)
cat > "$GLOBAL_BIN/nim-web" << EOF
#!/bin/bash
# Open NVIDIA NIM Proxy web interface

if ! curl -s http://localhost:8089/health > /dev/null 2>&1; then
    echo "⚠️  Server is not running. Starting it now..."
    nim-start
    sleep 2
fi

echo "🌐 Opening web interface..."
open http://localhost:8089/ 2>/dev/null || xdg-open http://localhost:8089/ 2>/dev/null || echo "Please open: http://localhost:8089/"
EOF

chmod +x "$GLOBAL_BIN/nim-web"

# Create nim-claude command (starts Claude Code with proxy)
cat > "$GLOBAL_BIN/nim-claude" << EOF
#!/bin/bash
# Start Claude Code with NVIDIA NIM Proxy

# Check if server is running
if ! curl -s http://localhost:8089/health > /dev/null 2>&1; then
    echo "⚠️  NVIDIA NIM Proxy is not running. Starting it now..."
    nim-start
    sleep 3
fi

# Get current model
CURRENT_MODEL=\$(curl -s http://localhost:8089/v1/models/current | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['id'])" 2>/dev/null)
if [ -n "\$CURRENT_MODEL" ]; then
    echo "📊 Using model: \$CURRENT_MODEL"
    echo "💡 Switch models: nim-web"
    echo ""
fi

# Start Claude Code with proxy
export ANTHROPIC_BASE_URL=http://localhost:8089
exec claude -dangerously-skip-permissions "\$@"
EOF

chmod +x "$GLOBAL_BIN/nim-claude"

# Create nim-switch command (quick model switch from CLI)
cat > "$GLOBAL_BIN/nim-switch" << EOF
#!/bin/bash
# Quick model switch from command line

if [ -z "\$1" ]; then
    echo "Usage: nim-switch <model-name>"
    echo ""
    echo "Popular models:"
    echo "  deepseek-v3.1          - DeepSeek v3.1 (reasoning)"
    echo "  qwen-coder             - Qwen Coder (best for coding)"
    echo "  llama-8b               - Llama 3.1 8B (fast)"
    echo "  llama-70b              - Llama 3.1 70B (powerful)"
    echo ""
    echo "Or use the web interface: nim-web"
    exit 1
fi

# Map friendly names to full model IDs
case "\$1" in
    deepseek-v3.1)
        MODEL="deepseek-ai/deepseek-v3.1"
        ;;
    qwen-coder)
        MODEL="qwen/qwen3-coder-480b-a35b-instruct"
        ;;
    llama-8b)
        MODEL="meta/llama-3.1-8b-instruct"
        ;;
    llama-70b)
        MODEL="meta/llama-3.1-70b-instruct"
        ;;
    *)
        MODEL="\$1"
        ;;
esac

echo "🔄 Switching to: \$MODEL"
curl -s -X POST http://localhost:8089/v1/models/switch \
  -H "Content-Type: application/json" \
  -d "{\"model\": \"\$MODEL\"}" | python3 -c "import sys, json; data = json.load(sys.stdin); print('✅ Switched to:', data.get('id', 'unknown')) if 'id' in data else print('❌ Error:', data.get('detail', 'unknown'))"
EOF

chmod +x "$GLOBAL_BIN/nim-switch"

# Add to PATH if not already there
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "$GLOBAL_BIN" "$SHELL_RC" 2>/dev/null; then
        echo "" >> "$SHELL_RC"
        echo "# NVIDIA NIM Switch" >> "$SHELL_RC"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
        echo "✅ Added to PATH in $SHELL_RC"
        echo "   Run: source $SHELL_RC"
    else
        echo "✅ Already in PATH"
    fi
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "📝 Available commands:"
echo "   nim-start      - Start the proxy server"
echo "   nim-stop       - Stop the proxy server"
echo "   nim-status     - Check server status"
echo "   nim-web        - Open web interface for model switching"
echo "   nim-claude     - Start Claude Code with proxy (use from ANY folder!)"
echo "   nim-switch     - Quick model switch from CLI"
echo ""
echo "🚀 Quick start:"
echo "   1. nim-start              # Start the server"
echo "   2. nim-web                # Open web interface to switch models"
echo "   3. cd ~/your-project      # Go to ANY project folder"
echo "   4. nim-claude             # Start Claude Code"
echo ""
echo "💡 Or just run 'nim-claude' from any folder - it will auto-start the server!"
echo ""

# Check if PATH needs to be reloaded
if ! command -v nim-start &> /dev/null; then
    echo "⚠️  Please reload your shell:"
    echo "   source $SHELL_RC"
    echo ""
    echo "   Or open a new terminal window"
fi
