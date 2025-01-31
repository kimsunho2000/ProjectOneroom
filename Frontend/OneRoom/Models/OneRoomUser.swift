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

    static func createAccount(user: OneRoomUser) -> Observable<OneRoomUser> {
        let url = "http://172.0.0.1:3000/login"
        AF.request("http://127.0.0.1:3000/temp", method: .get)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print("GET 요청 성공, Raw Data: \(data)")
                    if let string = String(data: data, encoding: .utf8) {
                        print("응답 문자열: \(string)")
                    }
                case .failure(let error):
                    print("GET 요청 실패: \(error.localizedDescription)")
                }
            }
        // JSON 직렬화
        guard let jsonData = try? JSONEncoder().encode(user) else {
            print("Failed to encode user to JSON")
            return Observable.error(NSError(domain: "EncodingError", code: 400, userInfo: nil))
        }

        // JSON 데이터 디버깅 출력
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Sending JSON: \(jsonString)")
        }

        return Observable.create { observer in
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let request = AF.request(url,
                                     method: .post,
                                     parameters: user.dictionary,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
                .validate(statusCode: 200..<300) // 성공적인 상태 코드만 허용
                .responseDecodable(of: OneRoomUser.self) { response in
                    switch response.result {
                    case .success(let user):
                        observer.onNext(user) // 성공 응답 반환
                        observer.onCompleted()
                    case .failure(let error):
                        print(" Error: \(error.localizedDescription)")
                        observer.onError(error) // 네트워크 요청 실패 시 에러 반환
                    }
                }
            
            return Disposables.create {
                request.cancel() // Observable이 dispose되면 네트워크 요청 취소
            }
        }
    }
    
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
