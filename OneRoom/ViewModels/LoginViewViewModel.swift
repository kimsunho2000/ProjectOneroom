//
//  LoginViewViewModel.swift
//  OneRoom
//
//  Created by 김선호 on 1/13/25.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewViewModel  {
    
    struct Input {
        let loginButtonTap: Observable<Void>
        let findAccountButtonTap: Observable<Void>
    }
    
    struct Output {
        let idLabel: Driver<String>
        let pwLabel: Driver<String>
        let idTextField: Driver<String>
        let pwTextField: Driver<String>
        let loginButtonEnabled: Driver<Bool>
        let navigateToLogin: Observable<Void>
        let navigateToFindAccount: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let idLabel = Driver.just("ID")
        let pwLabel = Driver.just("PW")
        let idTextField = input.loginButtonTap.map(\.text).asDriver(onErrorJustReturn: "")
        let pwTextField = input.loginButtonTap.map(\.text).asDriver(onErrorJustReturn: "")
        let navigateToLogin = input.loginButtonTap
        let navigateToFindAccount = input.findAccountButtonTap
        
        return Output(
            idLabel: idLabel,
            pwLabel: pwLabel,
            idTextField: idTextField,
            pwTextField: pwTextField,
            loginButtonEnabled: loginButtonEnabled,
            navigateToLogin: navigateToLogin,
            navigateToFindAccount: navigateToFindAccount)
    }

}
