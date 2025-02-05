//
//  RegisterManager.swift
//  OneRoom
//
//  Created by 김선호 on 2/1/25.
//

import Foundation
import RxSwift
import Alamofire

class RegisterManager {
    
    static let shared = RegisterManager()
    private init(){}
    
    private let baseUrl = "http://127.0.0.1:3000"
    
    
    func createAccount(user: OneRoomUser) -> Observable<OneRoomUser> {
        
        let url = "\(baseUrl)/user"
        
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
                        // 상태 코드 400 등 실패 응답 시, 응답 데이터가 있다면 서버 에러 메시지 파싱 시도
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
                request.cancel() // Observable이 dispose되면 네트워크 요청 취소
            }
        }
    }
}
