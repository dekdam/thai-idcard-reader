# Thai ID Card WebSocket & HTTP Server

This project provides a Node.js server for reading Thai national ID cards using a smart card reader, and broadcasting the card data to connected WebSocket clients. It also serves a debug HTML page for testing.

## Features
- Reads Thai ID card data using `thaismartcardreader.js`.
- Broadcasts card data and status updates to all connected WebSocket clients.
- Serves a debug HTML page via HTTP for testing and development.
- Modular code: HTTP and WebSocket servers are separated for clarity and maintainability.

## Project Structure
```
├── index.js            # Main entry point, starts both servers
├── http-server.js      # HTTP server logic (serves debug.html)
├── ws-server.js        # WebSocket server and smart card logic
├── debug.html          # Debug/test page (served at /debug.html)
├── package.json        # Project dependencies and scripts
├── automation.sh       # (Optional) Automation script
├── install.sh          # (Optional) Install script
```

## Requirements
- Node.js (v14 or newer recommended)
- A supported Thai smart card reader
- The `thaismartcardreader.js` Node.js package

## Installation
1. Clone this repository:
   ```bash
   git clone git@gitlab.orisma.com:vd/vd25a-thai-idcard-reader.git
   cd vd25a-thai-idcard-reader
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. (Optional) Run the install script if provided:
   ```bash
   ./install.sh
   ```

## Usage
1. Connect your Thai smart card reader and insert a Thai ID card.
2. Start the server:
   ```bash
   node index.js
   ```
3. Open your browser and navigate to:
   - [http://localhost:15398/debug.html](http://localhost:15398/debug.html) for the debug page
   - WebSocket clients can connect to `ws://localhost:15399`

## How It Works
- The HTTP server listens on port **15398** and serves `debug.html` at `/debug.html`.
- The WebSocket server listens on port **15399** and broadcasts card data and status updates to all connected clients.
- When a card is inserted, the server reads the card data (including photo) and sends it to all WebSocket clients.

## Customization
- You can modify `debug.html` to create your own test or UI page.
- Adjust ports in `index.js` if needed.

## License
MIT License

---

**Note:** This project is intended for use with supported Thai smart card readers and the `thaismartcardreader.js` library. Ensure you have the necessary drivers and permissions to access USB devices on your system.
