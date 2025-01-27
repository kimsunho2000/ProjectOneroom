const http = require('http'); //서버 객체 생성

const server = http.createServer((req, res) => {
    res.writeHead(200, {'Content-Type': 'text/plain' });
    res.write('Hello node.js');
    res.end();
});

server.listen(3000, () => {
    console.log('server running');
});