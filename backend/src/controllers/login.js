import passport from 'passport'

export const login = async(req, res, next) => {
    passport.authenticate("local", (err, user, info) => {
        if (err) return next(err); //서버 에러 발생 시 Express 에러 헨들러로 전달
        if (!user) return res.status(401).json({ message: info.message });
        req.login(user, (err) => {
            if (err) return next(err);
            return res.json({ message:"로그인 성공", user});
        });
    })(req, res, next);
}