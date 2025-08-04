const http = require('http');
const fs = require('fs');
const path = require('path');

function startHttpServer(port = 15398) {
  const server = http.createServer((req, res) => {
    if (req.method === 'GET' && req.url === '/debug.html') {
      const filePath = path.join(__dirname, 'debug.html');
      fs.readFile(filePath, (err, data) => {
        if (err) {
          res.writeHead(404, { 'Content-Type': 'text/plain' });
          res.end('debug.html not found');
        } else {
          res.writeHead(200, { 'Content-Type': 'text/html' });
          res.end(data);
        }
      });
    } else {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('Not found');
    }
  });

  server.listen(port, () => {
    console.log(`HTTP server started on port ${port}.`);
  });

  return server;
}

module.exports = { startHttpServer };
