//
//  LoginViewController.swift
//  OneRoom
//
//  Created by 김선호 on 1/12/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    private let IdLabel: UILabel = {
        let label = UILabel()
        label.text = "ID"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let PwLabel: UILabel = {
        let label = UILabel()
        label.text = "PW"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let IdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ID"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let PwTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "PW"
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.isHidden = true
        return textField
    }()
    
    private let LoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let FindAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Find Account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    // MARK: - Navigation
}
