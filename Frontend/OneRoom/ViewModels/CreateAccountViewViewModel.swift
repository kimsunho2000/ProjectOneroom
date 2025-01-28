//
//  CreateAccountViewViewModel.swift
//  OneRoom
//
//  Created by 김선호 on 1/27/25.
//

import Foundation
import RxSwift
import RxCocoa

class CreateAccountViewModel {
    
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
                .map { id, password in
                    // ID와 비밀번호로만 User 객체 생성
                    return OneRoomUser(
                        id: id,
                        name: "",
                        displayName: "",
                        email: "",
                        phoneNumber: "",
                        password: password,
                        createdAt: Date(),
                        birthDate: Date()
                    )
                }
            
            return Output(
                isCreateAccountEnabled: isCreateAccountEnabled,
                navigateToPrevious: navigateToPrevious,
                createAccountResult: createAccountResult
            )
        }
}
