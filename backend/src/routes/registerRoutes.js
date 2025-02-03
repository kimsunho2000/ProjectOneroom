import express from 'express';
import { registerUser } from '../controllers/register.js';

const router = express.Router();

// POST /register → 회원가입 요청 처리
router.post('/', registerUser);

export default router;