import RxSwift
import RxCocoa

class LoginViewViewModel {
    
    struct Input {
        let idText: Observable<String>
        let pwText: Observable<String>
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
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let idLabel = Driver.just("ID")
        let pwLabel = Driver.just("PW")
        
        // ID와 PW 텍스트 필드의 값을 그대로 출력
        let idTextField = input.idText.asDriver(onErrorJustReturn: "")
        let pwTextField = input.pwText.asDriver(onErrorJustReturn: "")
        
        // 로그인 버튼 활성화: ID와 PW가 모두 비어있지 않을 때
        let loginButtonEnabled = Observable
            .combineLatest(input.idText, input.pwText) { !$0.isEmpty && !$1.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        // 버튼 탭 이벤트 전달
        let navigateToLogin = input.loginButtonTap
        let navigateToFindAccount = input.findAccountButtonTap
        
        return Output(
            idLabel: idLabel,
            pwLabel: pwLabel,
            idTextField: idTextField,
            pwTextField: pwTextField,
            loginButtonEnabled: loginButtonEnabled,
            navigateToLogin: navigateToLogin,
            navigateToFindAccount: navigateToFindAccount
        )
    }
}
