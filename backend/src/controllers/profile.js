import User from "../models/oneroomUser.js";

export const userProfile = async (req, res) => {
    try {
        if (!req.session.passport?.user) {
            return res.status(401).json({message: "Unauthorized"});
        }
        const userId = req.session.passport?.user;// 세션에서 유저 ID 가져오기
        const updates = req.body; // 업데이트할 데이터
        // MongoDB에서 해당 유저 업데이트
        const updatedUser = await User.findByIdAndUpdate(userId, updates);
        if (!updatedUser) {
            return res.status(404).json({ message: "User not found" });
        }
        console.log("업데이트 성공" , updates);
        return res.status(201).json( { message: "Update success", profile: updates });
    }
    catch (error) {
        res.status(500).json({ error: error.message });
    }
}
