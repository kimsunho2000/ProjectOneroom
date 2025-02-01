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
            let createAccountResult: Observable<OneRoomUser>
        }
        
        func transform(input: Input) -> Output {
            // 계정 생성 버튼 활성화 조건: ID와 비밀번호가 유효하고, 비밀번호가 일치하는 경우
            let isCreateAccountEnabled = Observable
                .combineLatest(input.idText, input.pwText, input.confirmPasswordText) { id, password, confirmPassword in
                    !id.isEmpty && !password.isEmpty && password == confirmPassword
                }
                .asDriver(onErrorJustReturn: false)
            
            //backTap 이벤트 처리
            let navigateToPrevious = input.backTap
            
            // 계정 생성 결과: OneRoomUser 객체 생성 및 반환
            let createAccountResult = input.createAccountTap
                .withLatestFrom(Observable.combineLatest(input.idText, input.pwText))
                .flatMapLatest { id, password -> Observable<OneRoomUser> in
                            let newUser = OneRoomUser(
                                id: id,
                                name: "", // 추가 정보는 추후 뷰에서 입력받아 업데이트
                                displayName: "",
                                email: "",
                                phoneNumber: "",
                                password: password,
                                createdAt: Date(),
                                birthDate: Date()
                            )
                    return RegisterManager.shared.createAccount(user: newUser) // 모델 호출
                        }
            return Output(
                isCreateAccountEnabled: isCreateAccountEnabled,
                navigateToPrevious: navigateToPrevious,
                createAccountResult: createAccountResult
            )
        }
}
