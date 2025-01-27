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
        let pwConfirmText: Observable<String>
        let createAccountTap: Observable<Void>
        let backTap: Observable<Void>
    }
    
    struct Output {
        let idLabel: Driver<String>
        let pwLabel: Driver<String>
        let pwConfirmLabel: Driver<String>
        let idTextField: Driver<String>
        let pwTextField: Driver<String>
        let pwConfirmTextField: Driver<String>
        let isCreateAccountEnabled: Driver<Bool>
        let createAccountResult: Observable<Bool>
        let navigateToPrevious: Observable<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // 기본 라벨 설정
        let idLabel = Driver.just("ID")
        let pwLabel = Driver.just("Password")
        let pwConfirmLabel = Driver.just("Confirm Password")
        
        // 텍스트 필드의 값을 그대로 출력
        let idTextField = input.idText.asDriver(onErrorJustReturn: "")
        let pwTextField = input.pwText.asDriver(onErrorJustReturn: "")
        let pwConfirmTextField = input.pwConfirmText.asDriver(onErrorJustReturn: "")
        
        // 계정 생성 버튼 활성화: ID, PW가 비어있지 않고, PW와 PWConfirm이 동일해야 함
        let isCreateAccountEnabled = Observable
            .combineLatest(input.idText, input.pwText, input.pwConfirmText) { id, pw, pwConfirm in
                !id.isEmpty && !pw.isEmpty && pw == pwConfirm
            }
            .asDriver(onErrorJustReturn: false)
        
        // 계정 생성 버튼 탭 시 결과 전달 (여기서는 단순히 성공 여부를 반환, 실제 로직은 네트워크 호출 등으로 대체 가능)
        let createAccountResult = input.createAccountTap
            .withLatestFrom(Observable.combineLatest(input.idText, input.pwText, input.pwConfirmText))
            .map { id, pw, pwConfirm in
                // 예시 로직: 단순히 조건이 맞으면 성공
                return !id.isEmpty && !pw.isEmpty && pw == pwConfirm
            }
        
        // 뒤로가기 버튼 탭 이벤트 전달
        let navigateToPrevious = input.backTap
        
        return Output(
            idLabel: idLabel,
            pwLabel: pwLabel,
            pwConfirmLabel: pwConfirmLabel,
            idTextField: idTextField,
            pwTextField: pwTextField,
            pwConfirmTextField: pwConfirmTextField,
            isCreateAccountEnabled: isCreateAccountEnabled,
            createAccountResult: createAccountResult,
            navigateToPrevious: navigateToPrevious
        )
    }
}
