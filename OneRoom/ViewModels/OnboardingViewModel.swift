import Foundation
import RxSwift
import RxCocoa

class OnboardingViewModel {
    // Input: View에서 전달받는 이벤트
    struct Input {
        let loginButtonTap: Observable<Void>
        let createAccountButtonTap: Observable<Void>
    }
    
    // Output: View에 전달할 상태
    struct Output {
        let welcomeMessage: Driver<String>
        let loginMessage: Driver<String>
        let loginButtonTitle: Driver<String>
        let createAccountButtonTitle: Driver<String>
        let navigateToLogin: Observable<Void>
        let navigateToCreateAccount: Observable<Void>
    }
    
    // Transform: Input을 받아 Output 생성
    func transform(input: Input) -> Output {
        let welcomeMessage = Driver.just("Welcome to OneRoom!")
        let loginMessage = Driver.just("If you have an account, please login \nor create a new account")
        let loginButtonTitle = Driver.just("Click to Login")
        let createAccountButtonTitle = Driver.just("Create Account")
        
        // 버튼 탭 이벤트 처리
        let navigateToLogin = input.loginButtonTap
        let navigateToCreateAccount = input.createAccountButtonTap
        
        return Output(
            welcomeMessage: welcomeMessage,
            loginMessage: loginMessage,
            loginButtonTitle: loginButtonTitle,
            createAccountButtonTitle: createAccountButtonTitle,
            navigateToLogin: navigateToLogin,
            navigateToCreateAccount: navigateToCreateAccount
        )
    }
}
