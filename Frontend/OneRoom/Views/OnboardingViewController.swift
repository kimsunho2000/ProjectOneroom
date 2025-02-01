import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OnboardingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = OnboardingViewModel()
    
    // MARK: - UI Components
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Log in to your account"
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.isHidden = true
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateWelcomeLabel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        [welcomeLabel, loginLabel, loginButton, createAccountButton].forEach {
            view.addSubview($0)
        }
        
        // Layout using SnapKit
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
    
    // MARK: - Binding ViewModel
    private func bindViewModel() {
        let input = OnboardingViewModel.Input(
            loginButtonTap: loginButton.rx.tap.asObservable(),
            createAccountButtonTap: createAccountButton.rx.tap.asObservable()
        )
        
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
        
        output.navigateToLoginView
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
    
    // MARK: - Navigation
    private func navigateToLoginScreen() {
        let vc = LoginViewController()
        present(vc, animated: true)
    }
    
    private func navigateToCreateAccountScreen() {
        let vc = RegisterViewController()
        present(vc, animated: true)
    }
    
    // MARK: - Animations
    private func animateWelcomeLabel() {
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
        }
    }
}
