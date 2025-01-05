//
//  OnboardingViewController.swift
//  OneRoom
//
//  Created by 김선호 on 1/4/25.
//

import UIKit
import SnapKit
import SwiftUI

class OnboardingViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to OneRoom!"
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "If you have an account, please login"
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Click to Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize:  20)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.isHidden = true // 처음에는 숨김
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeLabel)
        view.addSubview(loginLabel)
        view.addSubview(loginButton)
        
        // 초기 위치
        welcomeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loginLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(325)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(250)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 텍스트 이동 애니메이션
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.welcomeLabel.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().multipliedBy(0.3)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            // 애니메이션 완료 후 UI 표시
            self.loginLabel.isHidden = false
            self.loginButton.isHidden = false
        }
    }
}

// MARK: - SwiftUI Preview for UIKit

#if DEBUG
struct OnboardingViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            OnboardingViewController()
        }
    }
}

struct ViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> ViewController

    init(_ builder: @escaping () -> ViewController) {
        self.viewControllerBuilder = builder
    }

    func makeUIViewController(context: Context) -> ViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // No updates needed for preview
    }
}
#endif
