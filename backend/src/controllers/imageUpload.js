import multer from "multer"
import path from "path"
import fs from "fs";
import User from "../models/oneroomUser.js";

const uploadDir = path.join(process.cwd(), "uploads");

// 스토리지 설정 (로컬 저장)
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir); // uploads 폴더에 저장
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}-${file.originalname}`);
    },
});

const upload = multer({ storage }).single("image");

export const imageUpload = async (req, res) => {
    upload(req, res, async (err) => {
        if (err) {
            return res.status(500).json({ error: "이미지 업로드 실패", details: err.message });
        }

        if (!req.file) {
            return res.status(400).json({ error: "파일이 업로드되지 않았습니다." });
        }

        const imageUrl = `/uploads/${req.file.filename}`;

        try {
            // 세션에서 사용자 ID 가져오기
            if (!req.session.passport?.user) {
                return res.status(401).json({ message: "Unauthorized" });
            }
            const userId = req.session.passport.user;

            // MongoDB에서 해당 유저의 프로필 이미지 업데이트
            const updatedUser = await User.findByIdAndUpdate(
                userId,{ profileImageUrl: imageUrl });

            if (!updatedUser) {
                // 유저를 찾지 못했으면 업로드된 파일 삭제
                fs.unlinkSync(path.join(uploadDir, req.file.filename));
                return res.status(404).json({ message: "User not found" });
            }

            return res.status(201).json({
                message: "프로필 이미지 업데이트 성공",
                profileImage: imageUrl,
            });
        } catch (dbError) {
            fs.unlinkSync(path.join(uploadDir, req.file.filename));
            return res.status(500).json({error: "DB 저장 실패", details: dbError.message});
        }
    });
};