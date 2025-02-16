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
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        // 서버에서 오는 날짜 문자열 처리
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    
    func patchProfile(profile: Profile) -> Observable<Profile> {
        
        let url = "\(baseURL)/user/profile"
        
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
                .responseDecodable(of: ProfileResponse.self, decoder: self.decoder) { response in
                    print(response)
                    switch response.result {
                    case .success(let profileResponse):
                        print("Profile updated successfully: \(profileResponse)")
                        let profile = profileResponse.profile
                        observer.onNext(profile)
                        observer.onCompleted()
                        
                    case .failure(let error):
                        if let data = response.data {
                            do {
                                // 먼저 ProfileResponse로 디코딩 시도
                                if let profileResponse = try? JSONDecoder().decode(ProfileResponse.self, from: data) {
                                    print("Received ProfileResponse but was in failure block: \(profileResponse)")
                                    observer.onNext(profileResponse.profile)
                                    observer.onCompleted()
                                    return
                                }
                                
    
                                if let messageResponse = try? JSONDecoder().decode(ProfileResponse.self, from: data) {
                                    print("Server message: \(messageResponse.message)")
                                    observer.onCompleted()
                                    return
                                }
                                
                                // 서버 에러 응답 처리
                                let serverError = try JSONDecoder().decode(ServerError.self, from: data)
                                print("Server returned an error: \(serverError.message)")
                                observer.onError(serverError)
                                
                            } catch {
                                print(" Unexpected response format: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
                                observer.onError(error)
                            }
                        } else {
                            print(" Request failed with error: \(error.localizedDescription)")
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
