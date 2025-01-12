import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OnboardingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = OnboardingViewModel()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.isHidden = true
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        bindViewModel()
    }
    
    private func setupLayout() {
        view.addSubview(welcomeLabel)
        view.addSubview(loginLabel)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        
        // 초기 위치
        welcomeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loginLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(450)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(350)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginLabel.snp.bottom).offset(30)
            make.width.equalTo(300)
        }
    }
    
    private func bindViewModel() {
        // Input 생성
        let input = OnboardingViewModel.Input(
            loginButtonTap: loginButton.rx.tap.asObservable(),
            createAccountButtonTap: createAccountButton.rx.tap.asObservable()
        )
        
        // ViewModel의 Output과 View 바인딩
        let output = viewModel.transform(input: input)
        
        output.welcomeMessage
            .drive(welcomeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.loginMessage
            .drive(loginLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.loginButtonTitle
            .drive(loginButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        output.createAccountButtonTitle
            .drive(createAccountButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        output.navigateToLogin
            .subscribe(onNext: { [weak self] in
                self?.navigateToLoginScreen()
            })
            .disposed(by: disposeBag)
        
        output.navigateToCreateAccount
            .subscribe(onNext: { [weak self] in
                self?.navigateToCreateAccountScreen()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToLoginScreen() {
        print("Navigate to Login Screen")
        // 실제 네비게이션 로직 추가
    }
    
    private func navigateToCreateAccountScreen() {
        print("Navigate to Create Account Screen")
        // 실제 네비게이션 로직 추가
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.welcomeLabel.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().multipliedBy(0.3)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.loginLabel.isHidden = false
            self.loginButton.isHidden = false
            self.createAccountButton.isHidden = false
            self.view.setNeedsLayout()
        }
    }
}
