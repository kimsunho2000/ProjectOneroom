//
//  LoginManager.swift
//  OneRoom
//
//  Created by 김선호 on 1/26/25.
//

import Foundation
import Alamofire
import RxSwift

class LoginManager {
    
    static let shared = LoginManager()
    private init() {}
    
    private let baseURL = "http://127.0.0.1:3000" // 로컬호스트 주소 수정
    
    func login(loginRequest: LoginRequest) -> Observable<Bool> {
        
        let url = "\(baseURL)/auth/login"
        // JSON 직렬화
        guard let jsonData = try? JSONEncoder().encode(loginRequest) else {
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
                                     parameters: loginRequest.dictionary,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case .success:
                        observer.onNext(true) // 로그인 성공 시 true 반환
                        observer.onCompleted()
                    case .failure(let error):
                        // 서버 에러 메시지 파싱 시도
                        if let data = response.data {
                            do {
                                let serverError = try JSONDecoder().decode(ServerError.self, from: data)
                                print("Server Error: \(serverError.message)")
                                observer.onError(NSError(domain: "ServerError", code: response.response?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: serverError.message]))
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
// 서버 응답 모델 추가
struct LoginResponse: Codable {
    let success: Bool
}
