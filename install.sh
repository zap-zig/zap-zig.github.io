#!/bin/bash

set -e  # Exit on error

VERSION="0.1.1"

echo "Installing zap v$VERSION..."

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$OS" in
    linux)
        case "$ARCH" in
            x86_64)  PLATFORM="linux-x86_64" ;;
            aarch64) PLATFORM="linux-aarch64" ;;
            arm64)   PLATFORM="linux-aarch64" ;;
            *)       echo "Error: Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    darwin)
        case "$ARCH" in
            x86_64)  PLATFORM="macos-x86_64" ;;
            aarch64) PLATFORM="macos-aarch64" ;;
            arm64)   PLATFORM="macos-aarch64" ;;
            *)       echo "Error: Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    *)
        echo "Error: Unsupported OS: $OS"
        exit 1
        ;;
esac

echo "Detected platform: $PLATFORM"

# User paths
USER_PATH="$HOME/.zap/bin"
ZAP_PATH="$USER_PATH/zap"

# Create directory if it doesn't exist
if [ ! -d "$USER_PATH" ]; then
    echo "Creating directory: $USER_PATH"
    mkdir -p "$USER_PATH"
fi

# Download zap
DOWNLOAD_URL="https://github.com/zap-zig/zap/releases/download/$VERSION/zap-$PLATFORM"
echo "Downloading from: $DOWNLOAD_URL"
curl -fL "$DOWNLOAD_URL" -o "$ZAP_PATH"
chmod +x "$ZAP_PATH"

# Verify installation
if [ -x "$ZAP_PATH" ]; then
    echo "Downloaded successfully"
else
    echo "Error: Download failed"
    exit 1
fi

# Auto-detect shell and set path
CURRENT_SHELL=$(basename "$SHELL")
echo "Detected shell: $CURRENT_SHELL"

case $CURRENT_SHELL in
    fish)
        echo "Configuring for fish..."
        if [ -f "$HOME/.config/fish/config.fish" ]; then
            if ! grep -q "\.zap/bin" "$HOME/.config/fish/config.fish"; then
                echo "set -gx PATH \$HOME/.zap/bin \$PATH" >> "$HOME/.config/fish/config.fish"
                echo "Added to fish config"
            else
                echo "Already in fish config"
            fi
        else
            mkdir -p "$HOME/.config/fish"
            echo "set -gx PATH \$HOME/.zap/bin \$PATH" > "$HOME/.config/fish/config.fish"
            echo "Created fish config"
        fi
        ;;
    bash)
        echo "Configuring for bash..."
        if [ -f "$HOME/.bashrc" ]; then
            if ! grep -q "\.zap/bin" "$HOME/.bashrc"; then
                echo 'export PATH="$HOME/.zap/bin:$PATH"' >> "$HOME/.bashrc"
                echo "Added to bashrc"
            else
                echo "Already in bashrc"
            fi
        elif [ -f "$HOME/.bash_profile" ]; then
            if ! grep -q "\.zap/bin" "$HOME/.bash_profile"; then
                echo 'export PATH="$HOME/.zap/bin:$PATH"' >> "$HOME/.bash_profile"
                echo "Added to bash_profile"
            else
                echo "Already in bash_profile"
            fi
        else
            echo 'export PATH="$HOME/.zap/bin:$PATH"' > "$HOME/.bashrc"
            echo "Created bashrc"
        fi
        ;;
    zsh)
        echo "Configuring for zsh..."
        if [ -f "$HOME/.zshrc" ]; then
            if ! grep -q "\.zap/bin" "$HOME/.zshrc"; then
                echo 'export PATH="$HOME/.zap/bin:$PATH"' >> "$HOME/.zshrc"
                echo "Added to zshrc"
            else
                echo "Already in zshrc"
            fi
        else
            echo 'export PATH="$HOME/.zap/bin:$PATH"' > "$HOME/.zshrc"
            echo "Created zshrc"
        fi
        ;;
    *)
        echo "Note: For shell: $CURRENT_SHELL, add to your config manually:"
        echo 'export PATH="$HOME/.zap/bin:$PATH"'
        ;;
esac

echo ""
echo "zap v$VERSION installed successfully!"
echo ""
echo "Run 'zap --help' to get started"
echo ""
echo "You may need to restart your shell or run:"
case $CURRENT_SHELL in
    fish) echo "  source ~/.config/fish/config.fish" ;;
    bash) echo "  source ~/.bashrc" ;;
    zsh) echo "  source ~/.zshrc" ;;
    *) echo "  source your shell config file" ;;
esac
