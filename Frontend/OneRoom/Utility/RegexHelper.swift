//
//  RegexHelper.swift
//  OneRoom
//
//  Created by 김선호 on 2/1/25.
//

import Foundation

// 아이디,비밀번호 형식 에러시 메시지 표기
enum RegexValidationError: LocalizedError {
    case invalidID
    case invalidPW

    var errorDescription: String? {
        switch self {
        case .invalidID:
            return "유효하지 않은 아이디 형식입니다."
        case .invalidPW:
            return "유효하지 않은 비밀번호 형식입니다."
        }
    }
}

class RegexHelper {

    // ID 검증
    static func isIDValid(_ ID : String) -> Bool {
        // 이메일 주소만 입력 받는 정규식
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return ID.range(of: pattern, options: .regularExpression) != nil
    }
    
    // PW 검증
    static func isPWValid(_ PW : String) -> Bool {
        // 비밀번호는 대소문자 + 숫자 + 8자 이상
        let pattern = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$"#
        return PW.range(of: pattern, options: .regularExpression) != nil
    }
    
}
