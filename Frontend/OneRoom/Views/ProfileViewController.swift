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
    
    private let genderPickerView = UIPickerView()
    private let datePicker = UIDatePicker()
    
    // MARK: - UI Components
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Write your profile"
        label.font = .systemFont(ofSize: 35)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let profileAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let nameTextField = createTextField(placeholder: "Real name")
    private let displayNameTextField = createTextField(placeholder: "Nick name")
    private let phoneNumTextField = createTextField(placeholder: "Phone Number(xxx-xxxx-xxxx)")
    
    private let bioTextField: UITextField = {
        let textField = createTextField(placeholder: "Gender")
        textField.tintColor = .clear
        return textField
    }()
    
    private let birthTextField: UITextField = {
        let textField = createTextField(placeholder: "Birth Date")
        textField.tintColor = .clear
        return textField
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupDatePicker()
        setupGenderPicker()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [mainLabel, profileAvatarImageView, nameTextField, displayNameTextField, phoneNumTextField, bioTextField, birthTextField, completeButton].forEach {
            view.addSubview($0)
        }
        
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
    
    // MARK: - Date Picker
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        birthTextField.inputView = datePicker

        let toolbar = createToolbar(selector: #selector(dismissDatePicker))
        birthTextField.inputAccessoryView = toolbar
        
        datePicker.rx.date
            .map { DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .none) }
            .bind(to: birthTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    @objc private func dismissDatePicker() {
        view.endEditing(true)
    }
    
    // MARK: - Gender Picker
    
    private func setupGenderPicker() {
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        bioTextField.inputView = genderPickerView
        
        let toolbar = createToolbar(selector: #selector(dismissGenderPicker))
        bioTextField.inputAccessoryView = toolbar
    }
    
    // MARK: - Toolbar
    
    private func createToolbar(selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: selector)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([space, doneButton], animated: false)
        return toolbar
    }
    
    @objc private func dismissGenderPicker() {
        view.endEditing(true)
    }
    
    private static func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }
    
    
    
    // MARK: - Helper Methods
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        let input = ProfileViewModel.Input(
            name: nameTextField.rx.text.orEmpty.asObservable(),
            displayName: displayNameTextField.rx.text.orEmpty.asObservable(),
            phoneNum: phoneNumTextField.rx.text.orEmpty.asObservable(),
            gender: bioTextField.rx.text.orEmpty.asObservable(),
            birthDate: birthTextField.rx.text.orEmpty.asObservable(),
            completeButtonTap: completeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.completeButtonEnabled
            .drive(completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.completeButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                self?.completeButton.backgroundColor = isEnabled ? .systemBlue : .lightGray
            })
            .disposed(by: disposeBag)
        
        output.selectedGender
            .drive(bioTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.birthDate
            .drive(birthTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(onNext: { [weak self] message in
                guard let self = self else { return }
                if let message = message, !message.isEmpty {
                    self.showErrorAlert(with: message)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UIPickerView Delegate & DataSource
extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return 2 }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return row == 0 ? "Male" : "Female" }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { bioTextField.text = row == 0 ? "Male" : "Female" }
}
