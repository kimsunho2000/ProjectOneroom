//
//  User.swift
//  OneRoom
//
//  Created by 김선호 on 1/8/25.
//

import Foundation

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

