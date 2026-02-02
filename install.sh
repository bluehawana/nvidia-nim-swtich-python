#!/bin/bash

# cc-nvd-python Installation Script
# This script installs cc-nvd-python with all dependencies

set -e  # Exit on any error

echo "🚀 Installing cc-nvd-python (Claude Code - NVIDIA Dynamic)..."

# Determine OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          echo "Unsupported OS: ${OS}"; exit 1;;
esac

echo "📦 Detected OS: ${MACHINE}"

# Install uv if not present
if ! command -v uv &> /dev/null; then
    echo "⬇️ Installing uv (Python package manager)..."
    if [[ "${MACHINE}" == "Mac" ]]; then
        if command -v brew &> /dev/null; then
            brew install uv
        else
            curl -LsSf https://astral.sh/uv/install.sh | sh
        fi
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
else
    echo "✅ uv already installed"
fi

# Clone or download cc-nvd-python
INSTALL_DIR="${HOME}/.cc-nvd-python"
echo "📥 Installing to ${INSTALL_DIR}..."

if [ ! -d "${INSTALL_DIR}" ]; then
    git clone https://github.com/yourusername/cc-nvd-python.git "${INSTALL_DIR}" || {
        echo "❌ Failed to clone repository"
        exit 1
    }
else
    echo "🔄 Updating existing installation..."
    cd "${INSTALL_DIR}"
    git pull
fi

cd "${INSTALL_DIR}"

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
uv sync --frozen

# Create symlink to PATH
echo "🔗 Adding to PATH..."
BIN_DIR="${HOME}/.local/bin"
mkdir -p "${BIN_DIR}"

# Create a simple launcher script
LAUNCHER_SCRIPT="${BIN_DIR}/cc-nvd"
cat > "${LAUNCHER_SCRIPT}" << 'EOF'
#!/bin/bash
# cc-nvd-python launcher script

CC_NVD_DIR="${HOME}/.cc-nvd-python"
cd "${CC_NVD_DIR}"

if [ "$1" == "serve" ]; then
    uv run uvicorn server:app --host 0.0.0.0 --port 8089
elif [ "$1" == "test" ]; then
    uv run pytest tests/
else
    uv run python "$@"
fi
EOF

chmod +x "${LAUNCHER_SCRIPT}"

echo "✅ Installation complete!"
echo ""
echo "🚀 To start the server:"
echo "   cc-nvd serve"
echo ""
echo "📖 Documentation: https://github.com/yourusername/cc-nvd-python"
echo "🌍 Web interface: http://localhost:8089/"