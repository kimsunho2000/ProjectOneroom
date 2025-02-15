//
//  ProfileManager.swift
//  OneRoom
//
//  Created by 김선호 on 2/15/25.
//

import Foundation
import Alamofire
import RxSwift

class ProfileManager {
    
    static let shared = ProfileManager()
    private init() {}
    
    private let baseURL = "http://127.0.0.1:3000"
    
    func patchProfile(profile: Profile) -> Observable<Profile> {
        
        let url = "\(baseURL)/user/profile"
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            return decoder
        }()
        
        // 프로필 객체를 JSON으로 인코딩
        guard let jsonData = try? JSONEncoder().encode(profile) else {
            print("Failed to encode profile to JSON")
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
                                     method: .patch,
                                     parameters: profile.dictionary,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
                .validate(statusCode: 200..<300) // 성공적인 상태 코드만 허용
                .responseDecodable(of: ProfileResponse.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let profileResponse):
                        let profile = profileResponse.profile
                        observer.onNext(profile) // 성공 응답 반환
                        observer.onCompleted()
                    case .failure(let error):
                        if let data = response.data {
                            do {
                                let serverError = try JSONDecoder().decode(ServerError.self, from: data)
                                observer.onError(serverError)
                            } catch {
                                print("Error decoding server error: \(error.localizedDescription)")
                                observer.onError(error)
                            }
                        } else {
                            observer.onError(error)
                        }
                    }
                }
                        return Disposables.create {
                            request.cancel()
                        }
                }
        }
}
