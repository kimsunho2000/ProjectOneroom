import express from 'express';
import path from 'path';
import nunjucks from 'nunjucks';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';

const __dirname = path.resolve();
const app = express();

// Body Parser 설정
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Nunjucks 설정
nunjucks.configure('views', {
    watch: true,
    express: app,
});

//서버 실행
app.listen(3000, () => {
    console.log('Server is running');
});