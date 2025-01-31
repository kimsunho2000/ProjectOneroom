import express from 'express';

const router = express.Router(); //라우터 설정

// 계정 생성 API
router.post('/', async (req, res) => { 
    let data = req.body;
    console.log(data);
})

export default router;