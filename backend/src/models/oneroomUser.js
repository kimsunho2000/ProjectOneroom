import mongoose from 'mongoose';

// 스위프트에서 보낸 user객체 정보와 통일
const userSchema = new mongoose.Schema({
    id: { type: String, required: true, unique: true },
    name: { type: String, default: "" },
    displayName: { type: String, default: "" },
    email: { type: String, required: true, unique: true },
    phoneNumber: { type: String, default: "" },
    password: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
    birthDate: { type: Date }
});

const User = mongoose.model('User', userSchema);
export default User;