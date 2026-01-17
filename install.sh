#!/bin/bash

set -e  # Exit on error

echo "Installing zap to user directory..."

# User paths
USER_PATH="$HOME/.zap/bin"
ZAP_PATH="$USER_PATH/zap"

# Create directory if it doesn't exist
if [ ! -d "$USER_PATH" ]; then
    echo "Creating directory: $USER_PATH"
    mkdir -p "$USER_PATH"
fi

# Download zap
echo "Downloading zap..."
curl -fL "https://github.com/zap-zig/zap/releases/download/1.0.0/zap" -o "$ZAP_PATH"
chmod +x "$ZAP_PATH"

# Auto-detect shell and set path
CURRENT_SHELL=$(basename "$SHELL")
echo "Detected shell: $CURRENT_SHELL"

case $CURRENT_SHELL in
    fish)
        echo "Configuring for fish..."
        if [ -f "$HOME/.config/fish/config.fish" ]; then
            if ! grep -q "\.zap/bin" "$HOME/.config/fish/config.fish"; then
                echo "set -gx PATH \$HOME/.zap/bin \$PATH" >> "$HOME/.config/fish/config.fish"
                echo "✓ Added to fish config"
            else
                echo "✓ Already in fish config"
            fi
        else
            mkdir -p "$HOME/.config/fish"
            echo "set -gx PATH \$HOME/.zap/bin \$PATH" > "$HOME/.config/fish/config.fish"
            echo "✓ Created fish config"
        fi
        ;;
    bash)
        echo "Configuring for bash..."
        if [ -f "$HOME/.bashrc" ]; then
            if ! grep -q "\.zap/bin" "$HOME/.bashrc"; then
                echo 'export PATH="$HOME/.zap/bin:$PATH"' >> "$HOME/.bashrc"
                echo "✓ Added to bashrc"
            else
                echo "✓ Already in bashrc"
            fi
        elif [ -f "$HOME/.bash_profile" ]; then
            if ! grep -q "\.zap/bin" "$HOME/.bash_profile"; then
                echo 'export PATH="$HOME/.zap/bin:$PATH"' >> "$HOME/.bash_profile"
                echo "✓ Added to bash_profile"
            else
                echo "✓ Already in bash_profile"
            fi
        else
            echo 'export PATH="$HOME/.zap/bin:$PATH"' > "$HOME/.bashrc"
            echo "✓ Created bashrc"
        fi
        ;;
    zsh)
        echo "Configuring for zsh..."
        if [ -f "$HOME/.zshrc" ]; then
            if ! grep -q "\.zap/bin" "$HOME/.zshrc"; then
                echo 'export PATH="$HOME/.zap/bin:$PATH"' >> "$HOME/.zshrc"
                echo "✓ Added to zshrc"
            else
                echo "✓ Already in zshrc"
            fi
        else
            echo 'export PATH="$HOME/.zap/bin:$PATH"' > "$HOME/.zshrc"
            echo "✓ Created zshrc"
        fi
        ;;
    *)
        echo "Note: For shell: $CURRENT_SHELL, add to your config manually:"
        echo 'export PATH="$HOME/.zap/bin:$PATH"'
        ;;
esac

echo ""
echo "✓ Installation complete!"
echo "Run 'zap --help' to get started"
echo ""
echo "You may need to restart your shell or run:"
case $CURRENT_SHELL in
    fish) echo "  source ~/.config/fish/config.fish" ;;
    bash) echo "  source ~/.bashrc" ;;
    zsh) echo "  source ~/.zshrc" ;;
    *) echo "  source your shell config file" ;;
esac
