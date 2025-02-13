import express from 'express';
import { registerUser } from '../controllers/user.js';
import { userProfile } from "../controllers/profile.js";

const router = express.Router();

// POST /user → 회원가입 요청 처리
router.post('/', registerUser);
router.post('/profile', userProfile);

export default router;