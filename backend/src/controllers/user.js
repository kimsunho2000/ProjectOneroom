import User from "../models/oneroomUser.js";
import error from "passport/lib/errors/authenticationerror.js";
import bcrypt from "bcryptjs";

// /user post요청 처리
export const registerUser = async (req, res) => {
    try {
        const { id, name, displayName, phoneNumber, password, createdAt, bio, birthDate, profileImageUrl } = req.body;
        // ID,PW 입력 확인
        if ( !id || !password ) {
            return res.status(400).json({ message: "ID 혹은 PW 누락" });
        }
        // ID중복 검사
        const existingUser = await User.findOne({ id });
        if (existingUser) {
            return res.status(400).json({ message: "이미 존재하는 이메일입니다." });
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        console.log("가입 가능")

        //user 객체 생성
        const newUser = new User({
            id,
            name,
            displayName,
            phoneNumber,
            password: hashedPassword,
            createdAt: createdAt ? new Date(createdAt) : new Date(),
            bio,
            birthDate: birthDate ? new Date(birthDate) : new Date(),
            profileImageUrl
        });

        await newUser.save();

        res.status(201).json({
            message: "회원가입 성공!",
            user: newUser
        });
    }
    catch (e) {
        res.status(500).json({ message: "서버 오류 발생", error: error.message });
        console.error(e);
    }
}


export const deleteUser = async (req, res) => {
    try {
        if (!req.session.passport?.user) {
            return res.status(401).json({message: "Unauthorized"});
        }
        const userId = req.session.passport?.user;// 세션에서 유저 ID 가져오기

        // MongoDB에서 해당 유저 계정 정보 삭제
        const removeUser = await User.findByIdAndDelete(userId);
        if (!removeUser) {
            return res.status(404).json({ message: "User not found" });
        }
        console.log("삭제 성공" , removeUser);
        return res.status(201).json( { message: "Delete success", User: userId });
    }
    catch
        (error)
        {
            res.status(500).json({error: error.message});
        }
}