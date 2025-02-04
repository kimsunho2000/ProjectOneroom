import express from 'express';
import { registerUser } from '../controllers/user.js';

const router = express.Router();

// POST /user → 회원가입 요청 처리
router.post('/', registerUser);

export default router;