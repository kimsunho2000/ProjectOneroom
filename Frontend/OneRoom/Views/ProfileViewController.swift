//
//  ProfileViewController.swift
//  OneRoom
//
//  Created by 김선호 on 2/5/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    private let viewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "Write your profile"
        label.font = .systemFont(ofSize: 35)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let profileAvatarImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Real name"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    private let displayNameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nick name"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    private let phoneNumTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone Numner"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    private let bioTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Bio"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    private let birthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Birth Date"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("complete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.isEnabled = false // 초기 상태는 비활성화
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
        [mainLabel, profileAvatarImageView, nameTextField, displayNameTextField,  phoneNumTextField,  bioTextField, birthTextField, completeButton].forEach {
            view.addSubview($0)
        }
        
        // Layout using Snapkit
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }

        profileAvatarImageView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileAvatarImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        displayNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        phoneNumTextField.snp.makeConstraints { make in
            make.top.equalTo(displayNameTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        bioTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        birthTextField.snp.makeConstraints { make in
            make.top.equalTo(bioTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(birthTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    // MARK: - Rx Binding
    
    private func bindViewModel() {
        
    }
}
