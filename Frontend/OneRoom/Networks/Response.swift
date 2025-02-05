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
