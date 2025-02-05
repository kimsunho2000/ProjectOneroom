import express from 'express';
import { login } from '../controllers/login.js'

const router = express.Router();

//POST /auth/login 요청시 로그인
router.post('/login', login )

export default router;