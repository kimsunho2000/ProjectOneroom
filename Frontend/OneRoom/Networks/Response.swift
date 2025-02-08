//
//  Response.swift
//  OneRoom
//
//  Created by 김선호 on 2/5/25.
//

import Foundation

/// 서버로부터 전달받은 에러 응답 모델
struct ServerError: Error, Decodable {
    let message: String

    var localizedDescription: String {
        return message
    }
}
// 가입시 서버 응답 모델
struct RegisterResponse: Codable {
    let message: String
    let user: OneRoomUser
}

// 서버 응답 모델 추가
struct LoginResponse: Codable {
    let message: String
    let user: OneRoomUser
}
