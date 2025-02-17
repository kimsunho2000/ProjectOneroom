import RxSwift
import RxCocoa

class LoginViewModel {
    
    struct Input {
        let idText: Observable<String>
        let pwText: Observable<String>
        let loginButtonTap: Observable<Void>
        let findAccountButtonTap: Observable<Void>
        let backTap: Observable<Void>
    }
    
    struct Output {
        let idLabel: Driver<String>
        let pwLabel: Driver<String>
        let idTextField: Driver<String>
        let pwTextField: Driver<String>
        let loginButtonEnabled: Driver<Bool>
        let navigateToLogin: Driver<Bool>
        let navigateToFindAccount: Observable<Void>
        let errorMessage: Driver<String?>
        let navigateToBack: Observable<Void>
    }

    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let idLabel = Driver.just("ID")
        let pwLabel = Driver.just("PW")
        
        let idTextField = input.idText.asDriver(onErrorJustReturn: "")
        let pwTextField = input.pwText.asDriver(onErrorJustReturn: "")
        
        let loginButtonEnabled = Observable
            .combineLatest(input.idText, input.pwText) { !$0.isEmpty && !$1.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        // 로그인 요청 이벤트
        let loginEvent = input.loginButtonTap
            .withLatestFrom(Observable.combineLatest(input.idText, input.pwText))
            .flatMapLatest { id, pw -> Observable<Event<LoginResponse>> in
                let loginRequest = LoginRequest(id: id, pw: pw)
                return LoginManager.shared.login(loginRequest: loginRequest)
                    .materialize()
            }
            .share()
        
        // 로그인 성공 여부
        let loginResult = loginEvent
            .compactMap { event -> LoginResponse? in
                if case .next(let OneroomUser) = event {
                    return OneroomUser
                }
                return nil
            }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let navigateToLogin = loginResult
            .map { !($0.user.name.isEmpty) }
            .asDriver(onErrorDriveWith: .empty())
        
        let errorMessage = loginEvent
            .compactMap { event -> String? in
                if case .error(let error) = event {
                    return (error as? ServerError)?.localizedDescription ?? error.localizedDescription
                }
                return nil
            }
            .startWith(nil)
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let navigateToBack = input.backTap
    
        return Output(
            idLabel: idLabel,
            pwLabel: pwLabel,
            idTextField: idTextField,
            pwTextField: pwTextField,
            loginButtonEnabled: loginButtonEnabled,
            navigateToLogin: navigateToLogin,
            navigateToFindAccount: input.findAccountButtonTap,
            errorMessage: errorMessage,
            navigateToBack: navigateToBack
        )
    }
}
