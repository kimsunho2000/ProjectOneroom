import mongoose from 'mongoose';
import dotenv from 'dotenv'

// dotenv 설정
dotenv.config()

//mongDB연결
const connectDB = async() => {
    mongoose
        .connect(process.env.MONGO_URI)
        .then(() => console.log('DB 연결 성공'))
        .catch((e) => console.error('DB 연결 실패:', e));
}

export default connectDB;
