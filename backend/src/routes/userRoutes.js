import express from 'express';
import { registerUser, deleteUser } from '../controllers/user.js';
import { userProfile } from "../controllers/profile.js";
import { imageUpload } from "../controllers/imageUpload.js";

const router = express.Router();

// POST /user → 회원가입 요청 처리
router.post('/', registerUser);

// PATCH /user/profile -> 프로필 추가 및 수정
router.patch('/profile', userProfile);

// POST /user/profile/upload -> 프로필 사진 저장
router.post('/profile/upload', imageUpload);

// DELETE /user/delete -> 계정 탈퇴 처리
router.delete( '/delete', deleteUser);

export default router;