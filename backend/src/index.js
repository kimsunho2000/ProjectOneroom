import express from 'express';
import path from 'path';
import nunjucks from 'nunjucks';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';

const __dirname = path.resolve();
const app = express();

//mongDB연결
mongoose
    .connect('mongodb://127.0.0.1:27017')
    .then(() => console.log('DB 연결 성공'))
    .catch((e) => console.error('DB 연결 실패:', e));


// Body Parser 설정
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Nunjucks 설정
nunjucks.configure('views', {
    watch: true,
    express: app,
});

// 서버 실행
app.listen(3000, () => {
    console.log('Server is running');
});