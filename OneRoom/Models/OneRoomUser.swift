//
//  User.swift
//  OneRoom
//
//  Created by 김선호 on 1/8/25.
//

import Foundation

struct OneRoomUser: Codable {
    let id: Int
    var name: String
    var displayName: String
    var email: String
    var phoneNumber: String
    var password: String
    var createdAt: String
    var bio: String
    var birthDate: String
    var profileImageUrl: String

}

