//
//  CreateAccountViewViewModel.swift
//  OneRoom
//
//  Created by 김선호 on 1/27/25.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    struct Input {
        let idText: Observable<String>
        let pwText: Observable<String>
        let confirmPasswordText: Observable<String>
        let createAccountTap: Observable<Void>
        let backTap: Observable<Void>
    }
    
    struct Output {
        let isCreateAccountEnabled: Driver<Bool>
        let navigateToPrevious: Observable<Void>
        let createAccountResult: Driver<OneRoomUser>
        let errorMessage: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        let isCreateAccountEnabled = Observable
            .combineLatest(input.idText, input.pwText, input.confirmPasswordText) { id, password, confirm in
                return !id.isEmpty &&
                !password.isEmpty &&
                password == confirm &&
                RegexHelper.isIDValid(id) &&
                RegexHelper.isPWValid(password)
            }
            .asDriver(onErrorJustReturn: false)
        
        let navigateToPrevious = input.backTap
        
        // 네트워크 요청 이벤트를 materialize()를 사용하여 에러와 정상 이벤트 모두 처리
        let createAccountEvent = input.createAccountTap
            .withLatestFrom(Observable.combineLatest(input.idText, input.pwText, input.confirmPasswordText))
            .flatMapLatest { id, pw, confirm -> Observable<Event<OneRoomUser>> in
                // 아이디 형식 검증
                if !RegexHelper.isIDValid(id) {
                    return Observable.error(ValidationError.invalidID).materialize()
                }
                // 패스워드 형식 검증
                if !RegexHelper.isPWValid(pw) {
                    return Observable.error(ValidationError.invalidPW).materialize()
                }
                // 비밀번호와 확인용 비밀번호가 일치하는지 검증
                if pw != confirm {
                    return Observable.error(ValidationError.passwordNotMatch).materialize()
                }
                //형식 검증이 끝나면 객체 생성
                let newUser = OneRoomUser(
                    id: id,
                    name: "",
                    displayName: "",
                    phoneNumber: "",
                    password: pw,
                    createdAt: Date(),
                    bio: "",
                    birthDate: Date(),
                    profileImageUrl: ""
                )
                return RegisterManager.shared.createAccount(user: newUser)
                    .materialize()
            }
            .share()
        
        let accountSuccess = createAccountEvent
            .compactMap { event -> OneRoomUser? in
                if case .next(let user) = event {
                    return user
                }
                return nil
            }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let errorMessage = createAccountEvent
            .compactMap { event -> String? in
                if case .error(let error) = event {
                    // 서버에서 전달한 에러 메시지 또는 기본 localizedDescription 사용
                    return (error as? ServerError)?.localizedDescription ?? error.localizedDescription
                }
                return nil
            }
            .startWith(nil)
            .asDriver(onErrorDriveWith: Driver.empty())
        
        return Output(
            isCreateAccountEnabled: isCreateAccountEnabled,
            navigateToPrevious: navigateToPrevious,
            createAccountResult: accountSuccess,
            errorMessage: errorMessage
        )
    }
}
