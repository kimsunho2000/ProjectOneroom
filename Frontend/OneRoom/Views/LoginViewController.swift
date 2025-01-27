import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    private let viewModel = LoginViewViewModel()
    private let disposeBag = DisposeBag()
    // MARK: - UI Components
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let pwLabel: UILabel = {
        let label = UILabel()
        label.text = "PW"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ID"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let pwTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "PW"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.isEnabled = false // 초기 상태는 비활성화
        return button
    }()
    
    private let findAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Find Account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
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
        view.backgroundColor = .white
        
        // Add subviews
        [idLabel, pwLabel, idTextField, pwTextField, loginButton, findAccountButton].forEach {
            view.addSubview($0)
        }
        
        // Layout using SnapKit
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        findAccountButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Rx Binding
    
    private func bindViewModel() {
        let input = LoginViewViewModel.Input(
            idText: idTextField.rx.text.orEmpty.asObservable(),
            pwText: pwTextField.rx.text.orEmpty.asObservable(),
            loginButtonTap: loginButton.rx.tap.asObservable(),
            findAccountButtonTap: findAccountButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.idLabel
            .drive(idLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.pwLabel
            .drive(pwLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.idTextField
            .drive(idTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.pwTextField
            .drive(pwTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.loginButtonEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.navigateToLogin
            .subscribe(onNext: {
                print("Navigate to login logic")
                // Add navigation logic here
            })
            .disposed(by: disposeBag)
        
        output.navigateToFindAccount
            .subscribe(onNext: {
                print("Navigate to find account logic")
                // Add navigation logic here
            })
            .disposed(by: disposeBag)
    }
}
