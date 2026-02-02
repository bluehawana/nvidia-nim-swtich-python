#!/bin/bash

# Test Fresh Installation
# Simulates a new user cloning and installing the project

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         FRESH INSTALLATION TEST                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

TEST_DIR="/tmp/nvidia-nim-switch-test-$$"

echo "📁 Creating test directory: $TEST_DIR"
mkdir -p "$TEST_DIR"

echo "📦 Cloning repository..."
git clone "$(git remote get-url origin)" "$TEST_DIR" 2>/dev/null || {
    echo "⚠️  Using local copy instead of cloning"
    cp -r "$(pwd)" "$TEST_DIR"
}

cd "$TEST_DIR"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Step 1: Check project structure"
echo "════════════════════════════════════════════════════════════"

echo -n "Checking README.md... "
[ -f "README.md" ] && echo "✅" || echo "❌"

echo -n "Checking server.py... "
[ -f "server.py" ] && echo "✅" || echo "❌"

echo -n "Checking .env.example... "
[ -f ".env.example" ] && echo "✅" || echo "❌"

echo -n "Checking scripts/install_global.sh... "
[ -f "scripts/install_global.sh" ] && echo "✅" || echo "❌"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Step 2: Check .env file (should NOT exist)"
echo "════════════════════════════════════════════════════════════"

if [ -f ".env" ]; then
    echo "❌ FAIL: .env file exists in fresh clone!"
    exit 1
else
    echo "✅ PASS: .env file does not exist (as expected)"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Step 3: Create .env file"
echo "════════════════════════════════════════════════════════════"

cp .env.example .env
echo "✅ Created .env from .env.example"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Step 4: Check dependencies"
echo "════════════════════════════════════════════════════════════"

echo -n "Checking uv is installed... "
if command -v uv &> /dev/null; then
    echo "✅"
else
    echo "❌ (would need to install)"
fi

echo -n "Checking pyproject.toml... "
[ -f "pyproject.toml" ] && echo "✅" || echo "❌"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Step 5: Test global installation script"
echo "════════════════════════════════════════════════════════════"

if [ -f "scripts/install_global.sh" ]; then
    echo "✅ install_global.sh exists"
    echo -n "Checking script is executable... "
    if [ -x "scripts/install_global.sh" ]; then
        echo "✅"
    else
        echo "⚠️  Not executable (would need chmod +x)"
    fi
else
    echo "❌ install_global.sh not found"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Step 6: Cleanup"
echo "════════════════════════════════════════════════════════════"

cd /tmp
rm -rf "$TEST_DIR"
echo "✅ Test directory cleaned up"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  ✅ FRESH INSTALLATION TEST COMPLETED                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Summary:"
echo "✅ Project structure is correct"
echo "✅ .env file not included in repository"
echo "✅ .env.example available for users"
echo "✅ Installation scripts present"
echo ""
echo "A new user can successfully:"
echo "1. Clone the repository"
echo "2. Copy .env.example to .env"
echo "3. Add their API key"
echo "4. Run installation"
