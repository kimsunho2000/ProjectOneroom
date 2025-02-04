import User from "../models/oneroomUser.js";
// /user post요청 처리
export const registerUser = async (req, res) => {
    try {
        const { id, name, displayName, phoneNumber, password, createdAt, bio, birthDate, profileImageURL } = req.body;
        // ID,PW 입력 확인
        if ( !id || !password ) {
            return res.status(400).json({ message: "ID 혹은 PW 누락" });
        }
        // ID중복 검사
        const existingUser = await User.findOne({ id });
        if (existingUser) {
            return res.status(400).json({ message: "이미 존재하는 이메일입니다." });
        }
        else {
            console.log("가입 가능")
        }
        //user 객체 생성
        const newUser = new User({
            id,
            name,
            displayName,
            phoneNumber,
            password,
            createdAt: createdAt ? new Date(createdAt) : new Date(),
            birthDate: birthDate ? new Date(birthDate) : null
        });

        await newUser.save();

        res.status(201).json({
            message: "✅ 회원가입 성공!",
            user: newUser
        });
    }
    catch (e) {
        res.status(500).json({ message: "서버 오류 발생", error: error.message });
        console.error(e);
    }
}