import passport from "passport"
import { Strategy as LocalStrategy } from "passport-local"
import bcrypt from "bcryptjs"
import User from "../models/oneroomUser.js"

// 로그인 설정(Local db)
passport.use(
    new LocalStrategy({ usernameField: "id"}, async (id, password, done) => {
        try {
                const user = await  User.findOne({ id });
                if (!user) return done(null, false, { message: "이메일이 존재하지 않습니다."});

                const isMatch = await bcrypt.compare(password, user.password);
                if (!isMatch) return done(null, false, { message: "비밀번호가 틀렸습니다."});
                return done(null, user);
            }   catch (err) {
                return done(err);
            }
    })
);
// 세션 직렬화(세젼 저장)
passport.serializeUser((user, done) => {
    done(null, user.id);
});
// 세션 역직렬화(세션 복원)
passport.deserializeUser( (user, done) => {
   try {
       const user =  User.findById(id);
       done(null, user);
   } catch (err) {
       done(err);
   }
});

export default passport;
