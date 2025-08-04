const { startHttpServer } = require('./http-server');
const { startWebSocketServer } = require('./ws-server');

startHttpServer(15398);
startWebSocketServer(15399);