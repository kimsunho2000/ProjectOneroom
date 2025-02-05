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
    
    var errorDescription: String? {
        switch self {
        case .invalidID:
            return "유효하지 않은 아이디 형식입니다."
        case .invalidPW:
            return "유효하지 않은 비밀번호 형식입니다."
        case .passwordNotMatch:
            return "비밀번호가 일치하지 않습니다."
        }
    }
}
