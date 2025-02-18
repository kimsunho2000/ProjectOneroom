import express from 'express';
import session from 'express-session'
import path from 'path';
import nunjucks from 'nunjucks';
import bodyParser from 'body-parser';
import passport from './config/passport.js'
import userRoutes from './routes/userRoutes.js'
import loginRoutes from './routes/loginRoutes.js'
import connectDB from './config/db.js'
import dotenv from 'dotenv'
import fs from 'fs'

const __dirname = path.resolve();
const app = express();

dotenv.config()

// 업로드 폴더 경로 설정 (현재 실행 중인 폴더 기준)
const uploadDir = path.join(process.cwd(), "uploads");

// 서버 실행 시 `uploads/` 폴더가 없으면 자동 생성
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// Body Parser 설정
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Nunjucks 설정
nunjucks.configure('src', {
    watch: true,
    express: app,
});

// 세션 설정
app.use(
    session({
        secret: process.env.SESSION_KEY,
        resave: false, // 변경사항 없을시 세션을 다시 저장x
        saveUninitialized: false //빈 세션 저장x
    })
);


// passport 초기화 및 세션설정
app.use(passport.initialize());
app.use(passport.session());

// 라우터 설정
app.use('/user', userRoutes);
app.use('/auth', loginRoutes);

// DB 실행
connectDB()

// 서버 실행
app.listen(3000, () => {
    console.log('Server is running');
});