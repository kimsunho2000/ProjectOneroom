import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = RegisterViewModel()
    
    // MARK: - UI Components
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Join us to find your special oneroom!"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ID"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private let pwTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "PW"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let pwConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "PW Confirm"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        [welcomeLabel, idTextField, pwTextField, pwConfirmTextField, createAccountButton, backButton].forEach {
            view.addSubview($0)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        pwConfirmTextField.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(pwConfirmTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(createAccountButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Rx Binding
    private func bindViewModel() {
        let input = RegisterViewModel.Input(
            idText: idTextField.rx.text.orEmpty.asObservable(),
            pwText: pwTextField.rx.text.orEmpty.asObservable(),
            confirmPasswordText: pwConfirmTextField.rx.text.orEmpty.asObservable(),
            createAccountTap: createAccountButton.rx.tap.asObservable(),
            backTap: backButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // 버튼 활성화 바인딩
        output.isCreateAccountEnabled
            .drive(createAccountButton.rx.isEnabled) // Driver 사용
            .disposed(by: disposeBag)
        
        // 버튼 활성화시 색상 바인딩
        output.isCreateAccountEnabled
                .drive(onNext: { [weak self] isEnabled in
                    self?.createAccountButton.backgroundColor = isEnabled ? .systemBlue : .lightGray
                })
                .disposed(by: disposeBag)

        
        // 뒤로 가기 버튼 바인딩
        output.navigateToPrevious
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 계정 생성 결과 바인딩
        output.createAccountResult
            .subscribe(onNext: { user in
                print("Account created successfully for user: \(user.id)")
                // self?.navigateToUserProfile(user: user)
            })
            .disposed(by: disposeBag)
    }
    
    /* private func navigateToUserProfile() {
        let userProfileVC = UserProfileViewController()
        userProfileVC.modalPresentationStyle = .fullScreen
        present(userProfileVC, animated: true)
    } */

    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to create account. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
