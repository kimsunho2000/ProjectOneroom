//
//  ProfileViewModel.swift
//  OneRoom
//
//  Created by 김선호 on 2/5/25.
//

import RxSwift
import RxCocoa

class ProfileViewModel {
    
    struct Input {
        let profileAvatarImageView : Observable<String>
        let nameTextField: Observable<String>
        let displayNameTextField: Observable<String>
        let phoneNumTextField: Observable<String>
        let bioTextField: Observable<String>
        let birthTextField: Observable<String>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isProfileValid: Driver<Bool>
        let profileAvatarImageView: Driver<String>
        let completeButtonEnabled: Driver<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
}
