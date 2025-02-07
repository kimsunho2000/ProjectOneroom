//
//  LoginRequest.swift
//  OneRoom
//
//  Created by 김선호 on 2/7/25.
//

import Foundation
import RxSwift
import Alamofire


struct LoginRequest: Codable {
    let id: String
    let pw: String
    
    // JSON 변환을 위한 딕셔너리 프로퍼티
    var dictionary: [String: Any] {
        return [
            "id": id,
            "password": pw
        ]
    }
    init(
        id: String,
        pw: String
    ) {
        self.id = id
        self.pw = pw
    }
}
