#!/bin/bash

# This script ensures Node.js version 23 is installed on macOS, 
# installs dependencies, and then runs the Thai ID Card Reader WebSocket server.

# --- Check for Xcode Command Line Tools (required for native modules and USB access) ---
if ! xcode-select -p &> /dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    echo "Please follow the prompts to complete installation, then re-run this script."
    exit 1
else
    echo "Xcode Command Line Tools are installed."
fi

# --- Ensure NVM is available ---
# Set the NVM directory and source the script if it exists
export NVM_DIR="$HOME/.nvm"

# Check if NVM is installed, if not, install it
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    echo "NVM not found. Installing NVM..."
    # Use curl to download and run the official NVM install script
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    if [ $? -ne 0 ]; then
        echo "NVM installation failed. Please check for errors and try again."
        exit 1
    fi
    echo "NVM installed successfully."
fi

# Source the NVM script to make it available in the current shell session.
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Ensure NVM is loaded in future shell sessions
if ! grep -q 'NVM_DIR' "$HOME/.bash_profile" 2>/dev/null; then
    echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.bash_profile"
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> "$HOME/.bash_profile"
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> "$HOME/.bash_profile"
    echo "NVM initialization added to ~/.bash_profile"
fi


# --- Check for correct Node.js version ---
DESIRED_NODE_VERSION="23"
NEEDS_INSTALL=false

# Check if node command exists
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed."
    NEEDS_INSTALL=true
else
    # If node exists, check its major version
    CURRENT_MAJOR_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    echo "Found Node.js version: $(node -v)"
    if [ "$CURRENT_MAJOR_VERSION" != "$DESIRED_NODE_VERSION" ]; then
        echo "Incorrect Node.js version detected. Required major version is $DESIRED_NODE_VERSION."
        NEEDS_INSTALL=true
    fi
fi

# If the correct version is not installed or active, use NVM to install/switch
if [ "$NEEDS_INSTALL" = true ]; then
    echo "Installing and switching to Node.js version $DESIRED_NODE_VERSION with NVM..."
    nvm install "$DESIRED_NODE_VERSION"
    if [ $? -ne 0 ]; then
        echo "Node.js v$DESIRED_NODE_VERSION installation via NVM failed. Please check for errors."
        exit 1
    fi
    
    # Use the newly installed version
    nvm use "$DESIRED_NODE_VERSION"
    echo "Successfully switched to Node.js version $DESIRED_NODE_VERSION."
fi


echo "Correct Node.js version is active."
node -v
npm -v

# --- Install Dependencies ---
# Check if the node_modules directory exists. This is where npm installs packages.
if [ ! -d "node_modules" ]; then
    echo "Dependencies not found. Installing..."
    # Run npm install to download the required packages.
    npm install
    if [ $? -ne 0 ]; then
        echo "npm install failed. Please check for errors."
        exit 1
    fi
    echo "Dependencies installed successfully."
fi

# --- Create automation.sh script ---
echo "cd $(pwd)" | cat > "automation.sh"
echo "$(which npm) install" | cat >> "automation.sh"
echo "$(which node) index.js" | cat >> "automation.sh"