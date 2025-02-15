//
//  Profile.swift
//  OneRoom
//
//  Created by 김선호 on 2/15/25.
//

import Foundation

struct Profile: Codable {
    
    var name: String
    var displayName: String
    var phoneNumber: String
    var bio: String
    var birthDate: Date
    var profileImageUrl: String
    
    // JSON 변환을 위한 딕셔너리 프로퍼티
    var dictionary: [String: Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return [
            "name": name,
            "displayName": displayName,
            "phoneNumber": phoneNumber,
            "bio": bio,
            "birthDate": dateFormatter.string(from: birthDate),
            "profileImageUrl": profileImageUrl
        ]
    }
    init (
        name: String,
        displayName: String,
        phoneNumber: String,
        bio: String,
        birthDate: Date,
        profileImageUrl: String
    )
    {
        self.name = name
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        self.bio = bio
        self.birthDate = birthDate
        self.profileImageUrl = profileImageUrl
    }
}

