#!/bin/bash

# Start NVIDIA NIM Switch Proxy and configure Claude Code
# Usage: ./start_with_claude.sh

echo "🚀 Starting NVIDIA NIM Switch Proxy..."

# Check if server is already running
if curl -s http://localhost:8089/health > /dev/null 2>&1; then
    echo "✅ Server is already running on port 8089"
else
    echo "📦 Starting server..."
    nohup uv run python server.py --host 0.0.0.0 --port 8089 > server_output.log 2>&1 &
    SERVER_PID=$!
    echo "   Server PID: $SERVER_PID"
    
    # Wait for server to start
    echo "⏳ Waiting for server to start..."
    for i in {1..10}; do
        if curl -s http://localhost:8089/health > /dev/null 2>&1; then
            echo "✅ Server started successfully!"
            break
        fi
        sleep 1
    done
fi

# Get current model
echo ""
echo "📊 Current Configuration:"
CURRENT_MODEL=$(curl -s http://localhost:8089/v1/models/current | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['id'])" 2>/dev/null)
if [ -n "$CURRENT_MODEL" ]; then
    echo "   Model: $CURRENT_MODEL"
else
    echo "   Model: (checking...)"
fi

echo ""
echo "🌐 Web Interface: http://localhost:8089/"
echo "📚 API Docs: http://localhost:8089/docs"
echo ""
echo "🔧 To use with Claude Code, run these commands:"
echo ""
echo "   export ANTHROPIC_BASE_URL=http://localhost:8089"
echo "   claude -dangerously-skip-permissions"
echo ""
echo "Or in one line:"
echo ""
echo "   ANTHROPIC_BASE_URL=http://localhost:8089 claude -dangerously-skip-permissions"
echo ""
echo "💡 To stop the server:"
echo "   pkill -f 'python server.py'"
echo ""
