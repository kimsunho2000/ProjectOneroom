//
//  ValidationError.swift
//  OneRoom
//
//  Created by 김선호 on 2/5/25.
//

import Foundation

enum ValidationError: LocalizedError {
    case invalidID
    case invalidPW
    case passwordNotMatch
    case invalidName
    case invalidNickName
    case invalidPhoneNumber
    case invalidGender
    case invalidBirthDate
    
    var errorDescription: String? {
        switch self {
        case .invalidID:
            return "유효하지 않은 아이디 형식입니다."
        case .invalidPW:
            return "유효하지 않은 비밀번호 형식입니다."
        case .passwordNotMatch:
            return "비밀번호가 일치하지 않습니다."
        case .invalidName:
            return "이름은 정확히 3글자로 입력해야 합니다."
        case .invalidNickName:
            return "닉네임은 8글자 이내로 입력해야 합니다."
        case .invalidPhoneNumber:
            return "유효하지 않은 전화번호 형식입니다. (예: 010-1234-5678)"
        case .invalidGender:
            return "성별을 선택하세요"
        case .invalidBirthDate:
            return "생일을 입력하세요"
        }
    }
}
