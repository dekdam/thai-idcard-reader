#!/bin/bash

# This script checks if Node.js is installed on macOS, installs dependencies,
# and then runs the Thai ID Card Reader WebSocket server.

# --- Check for Node.js and attempt to install if missing on macOS using NVM ---
# The 'command -v node' command checks if 'node' is a known command.
if ! command -v node &> /dev/null
then
    echo "Node.js is not found. Attempting to install via NVM (Node Version Manager)..."

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
    # This is necessary because the installer adds the source command to your shell's
    # profile file (like .zshrc or .bash_profile), but it won't be loaded in this script's session.
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # Now that NVM is loaded, install the specified version of Node.js
    echo "Installing Node.js version 23 with NVM..."
    nvm install 23
    if [ $? -ne 0 ]; then
        echo "Node.js installation via NVM failed. Please check for errors."
        exit 1
    fi
    
    # Use the newly installed version
    nvm use 23
    echo "Node.js version 23 installed successfully via NVM."
fi

echo "Node.js is installed."
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

# --- Run the Server ---
# Once Node.js is confirmed and dependencies are installed, start the server.
echo "Starting the WebSocket server..."
npm run start
