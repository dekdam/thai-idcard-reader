const { Reader } = require('thaismartcardreader.js');
const { WebSocketServer } = require('ws');

function startWebSocketServer(port = 15399) {
  const wss = new WebSocketServer({ port });
  console.log(`WebSocket server started on port ${port}.`);
  console.log('Waiting for client connections...');

  wss.on('connection', ws => {
    console.log('Client connected.');
    ws.on('close', () => {
      console.log('Client disconnected.');
    });
    ws.on('error', error => {
      console.log('WebSocket Error:', error);
    });
  });

  // Function to broadcast data to all connected clients
  function broadcast(event, data) {
    const message = JSON.stringify({ event, data });
    wss.clients.forEach(client => {
      if (client.readyState === client.OPEN) {
        client.send(message);
      }
    });
  }

  // --- Smart Card Reader Setup ---
  const myReader = new Reader();
  console.log('Waiting for smart card device and card...');

  myReader.on('device-activated', (event) => {
    const message = `Device Activated: ${event.name}`;
    console.log(message);
    broadcast('status', message);
  });

  myReader.on('device-deactivated', () => {
    const message = 'Device Deactivated.';
    console.log(message);
    broadcast('status', message);
  });

  myReader.on('card-inserted', async (person) => {
    console.log('Card Inserted. Reading data...');
    broadcast('status', 'Card Inserted. Reading data...');
    try {
      const cid = await person.getCid();
      const thName = await person.getNameTH();
      const enName = await person.getNameEN();
      const dob = await person.getDoB();
      const gender = await person.getGender();
      const issuer = await person.getIssuer();
      const issueDate = await person.getIssueDate();
      const expireDate = await person.getExpireDate();
      const address = await person.getAddress();
      // Photo is a buffer, converting to base64 to send over WebSocket
      const photoBuffer = await person.getPhoto();
      const photo = `data:image/bmp;base64,${photoBuffer.toString('base64')}`;

      const cardData = {
        cid,
        thName: `${thName.prefix} ${thName.firstname} ${thName.lastname}`,
        enName: `${enName.prefix} ${enName.firstname} ${enName.lastname}`,
        dob: `${dob.day}/${dob.month}/${dob.year}`,
        gender,
        address: `${address}`,
        issuer,
        issueDate: `${issueDate.day}/${issueDate.month}/${issueDate.year}`,
        expireDate: `${expireDate.day}/${expireDate.month}/${expireDate.year}`,
        photo
      };

      console.log('Reading Complete. Broadcasting data...');
      broadcast('card-read', cardData);
    } catch (error) {
      console.error('Error reading data from card:', error);
      broadcast('error', 'Error reading data from card.');
    }
  });

  myReader.on('card-removed', () => {
    const message = 'Card Removed. Waiting for new card...';
    console.log(message);
    broadcast('status', message);
  });

  myReader.on('error', (err) => {
    console.error('An error occurred:', err);
    broadcast('error', 'A reader error occurred.');
  });

  process.on('unhandledRejection', (reason, promise) => {
    console.log('Unhandled Rejection at:', promise, 'reason:', reason);
    broadcast('error', 'A server error occurred.');
  });

  return wss;
}

module.exports = { startWebSocketServer };
