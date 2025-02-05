import express from 'express';
import path from 'path';
import nunjucks from 'nunjucks';
import bodyParser from 'body-parser';
import userRoutes from './routes/userRoutes.js'
import loginRoutes from './routes/loginRoutes.js'
import connectDB from './config/db.js'

const __dirname = path.resolve();
const app = express();

// Body Parser 설정
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Nunjucks 설정
nunjucks.configure('src', {
    watch: true,
    express: app,
});

// 라우터 설정
app.use('/user', userRoutes);
app.use('/auth', loginRoutes);

// DB 실행
connectDB()

// 서버 실행
app.listen(3000, () => {
    console.log('Server is running');
});