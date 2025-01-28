//
//  User.swift
//  OneRoom
//
//  Created by 김선호 on 1/8/25.
//

import Foundation
import RxSwift

struct OneRoomUser: Codable {
    let id: String
    var name: String
    var displayName: String
    var email: String
    var phoneNumber: String
    var password: String 
    var createdAt: Date
    var bio: String?
    var birthDate: Date
    var profileImageUrl: String?
    
    static func createAccount(user: OneRoomUser) -> Observable<Bool> {
            // JSON 직렬화
            guard let jsonData = try? JSONEncoder().encode(user) else {
                print("Failed to encode user to JSON")
                return Observable.just(false) // JSON 직렬화 실패 시 false 반환
            }
            
            // JSON 데이터 출력 (디버깅용)
            print("Sending JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
            
            // 서버로 전송 (여기서는 네트워크 요청을 생략하고 성공으로 처리)
            // 실제 네트워크 요청이 필요한 경우 URLSession 등을 사용
            return Observable.just(true)
        }

    init(
        id: String,
        name: String,
        displayName: String,
        email: String,
        phoneNumber: String,
        password: String,
        createdAt: Date,
        bio: String? = nil,
        birthDate: Date,
        profileImageUrl: String? = nil
    ) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
        self.createdAt = createdAt
        self.bio = bio
        self.birthDate = birthDate
        self.profileImageUrl = profileImageUrl
    }
}

