import Foundation
import RxSwift
import Alamofire

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
    
    /// JSON 변환을 위한 딕셔너리 프로퍼티
    var dictionary: [String: Any] {
        let formatter = ISO8601DateFormatter()
        return [
            "id": id,
            "name": name,
            "displayName": displayName,
            "email": email,
            "phoneNumber": phoneNumber,
            "password": password,
            "createdAt": formatter.string(from: createdAt),
            "bio": bio ?? "",
            "birthDate": formatter.string(from: birthDate),
            "profileImageUrl": profileImageUrl ?? ""
        ]
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
