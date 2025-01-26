//
//  RoomMetaData.swift
//  OneRoom
//
//  Created by 김선호 on 1/8/25.
//

import Foundation

struct RoomMetaData: Codable {
    var id = UUID().uuidString
    let author: OneRoomUser
    let authorID: String
    let likeCount: Int
    let likers: [String]
    let roomName: String
    let roomLocation: String
    
}
