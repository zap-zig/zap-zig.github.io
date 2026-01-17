#!/bin/bash
echo "USER ONLY INSTALL OR SYSTEM WIDE? ["1=useronly","2=systemwide"]:"
read -p "SELECT: " installtype

USER_PATH="$HOME/.zap/bin"
ROOT_PATH="/usr/local/bin"

case $installtype in
    1)
        if [ ! -d "$USER_PATH" ]; then
            echo "PATH $USER_PATH NOT FOUND CREATING AUTOMATICALLY."
            mkdir -p "$USER_PATH"
        fi
        curl -o "$USER_PATH/zap" -L "https://github.com/zap-zig/zap/releases/download/1.0.0/zap"
        chmod +x "$USER_PATH/zap"
        
        # Auto-detect shell and set path
        CURRENT_SHELL=$(basename "$SHELL")
        echo "Detected shell: $CURRENT_SHELL"
        
        case $CURRENT_SHELL in
            fish)
                echo "setting path for fish"
                if [ -f "$HOME/.config/fish/config.fish" ]; then
                    if ! grep -q "\.zap/bin" "$HOME/.config/fish/config.fish"; then
                        echo "set -gx PATH \$HOME/.zap/bin \$PATH" >> "$HOME/.config/fish/config.fish"
                        echo "PATH ADDED TO fish config"
                    else
                        echo "PATH ALREADY SET IN fish config"
                    fi
                else
                    mkdir -p "$HOME/.config/fish"
                    echo "set -gx PATH \$HOME/.zap/bin \$PATH" > "$HOME/.config/fish/config.fish"
                    echo "CREATED fish config WITH PATH"
                fi
                ;;
            bash)
                echo "setting path for bash"
                if [ -f "$HOME/.bashrc" ]; then
                    if ! grep -q "\.zap/bin" "$HOME/.bashrc"; then
                        echo 'export PATH="$HOME/.zap/bin:$PATH"' >> "$HOME/.bashrc"
                        echo "PATH ADDED TO bashrc"
                    else
                        echo "PATH ALREADY SET IN bashrc"
                    fi
                elif [ -f "$HOME/.bash_profile" ]; then
                    if ! grep -q "\.zap/bin" "$HOME/.bash_profile"; then
                        echo 'export PATH="$HOME/.zap/bin:$PATH"' >> "$HOME/.bash_profile"
                        echo "PATH ADDED TO bash_profile"
                    else
                        echo "PATH ALREADY SET IN bash_profile"
                    fi
                else
                    echo 'export PATH="$HOME/.zap/bin:$PATH"' > "$HOME/.bashrc"
                    echo "CREATED bashrc WITH PATH"
                fi
                ;;
            zsh)
                echo "setting path for zsh"
                if [ -f "$HOME/.zshrc" ]; then
                    if ! grep -q "\.zap/bin" "$HOME/.zshrc"; then
                        echo 'export PATH="$HOME/.zap/bin:$PATH"' >> "$HOME/.zshrc"
                        echo "PATH ADDED TO zshrc"
                    else
                        echo "PATH ALREADY SET IN zshrc"
                    fi
                else
                    echo 'export PATH="$HOME/.zap/bin:$PATH"' > "$HOME/.zshrc"
                    echo "CREATED zshrc WITH PATH"
                fi
                ;;
            *)
                echo "UNKNOWN SHELL: $CURRENT_SHELL"
                echo "PLEASE ADD MANUALLY TO YOUR SHELL CONFIG:"
                echo 'export PATH="$HOME/.zap/bin:$PATH"'
                ;;
        esac
        
        echo "YOU'RE SET RUN 'zap --help' to get started"
        echo "RESTART YOUR SHELL OR RUN: source ~/.$(basename "$SHELL" | sed 's/.*-//')rc"
        ;;
    2)
        if [ "$EUID" -ne 0 ]; then
            echo "PLEASE RUN AS ROOT!"
            exit 1
        fi
        curl -o "$ROOT_PATH/zap" -L "https://github.com/zap-zig/zap/releases/download/1.0.0/zap"
        chmod +x "$ROOT_PATH/zap"
        echo "INSTALLED SYSTEM WIDE! RUN 'zap --help' to get started"
        ;;
    *)
        echo "INVALID SELECTION. PLEASE CHOOSE 1 OR 2."
        exit 1
        ;;
esac
