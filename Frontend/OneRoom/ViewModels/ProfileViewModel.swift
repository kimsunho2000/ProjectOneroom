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
        let name: Observable<String>
        let displayName: Observable<String>
        let phoneNum: Observable<String>
        let gender: Observable<String>
        let birthDate: Observable<String>
        let avatarImageTap: Observable<Void>
        let completeButtonTap: Observable<Void>
    }
    
    struct Output {
        let isProfileValid: Driver<Bool>
        let genderOptions: Driver<[String]> // "Male", "Female" 선택 옵션
        let selectedGender: Driver<String> // 현재 선택된 성별
        let birthDate: Driver<Date> // 현재 선택된 생년월일
        let completeButtonEnabled: Driver<Bool>
        let errorMessage: Driver<String?> // 에러 메시지 전달
        let selectedAvatarImage: Driver<UIImage?>
    }
    
    private let disposeBag = DisposeBag()
    
    
    private let defaultAvatarImage = UIImage(systemName: "person.circle.fill") // 기본 이미지
    private let selectedAvatarImageRelay = BehaviorRelay<UIImage?>(value: nil)
    
    func transform(input: Input) -> Output {
        
        let isProfileValid = Observable.combineLatest(input.name, input.displayName,
                                                      input.phoneNum, input.gender, input.birthDate) {
            name, displayName, phoneNum, gender, birthDate in
            return !name.isEmpty && !displayName.isEmpty && !phoneNum.isEmpty && !gender.isEmpty && !birthDate.isEmpty
        }.asDriver(onErrorJustReturn: false)
            
        let completeButtonEnabled = isProfileValid
        
        let genderOptions = Observable.just(["Male", "Female"])
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let errorMessage = PublishRelay<String?>()
        
        let birthDateObservable: Observable<Date> = input.birthDate
            .compactMap { dateFormatter.date(from: $0) }
            .catchAndReturn(Date()) // 변환 실패 시 기본값을 현재 날짜로 설정
            .asObservable()
        
        let profileInputEvent = input.completeButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.name, input.displayName, input.phoneNum, input.gender, birthDateObservable
            ))
            .flatMapLatest { name, displayName, phoneNum, gender, birthDate -> Observable<Profile> in
                if !RegexHelper.isNameValid(name) {
                    return Observable.error(ValidationError.invalidName)
                }

                if !RegexHelper.isNickNameValid(displayName) {
                    return Observable.error(ValidationError.invalidNickName)
                }

                if !RegexHelper.isPhoneNumberValid(phoneNum) {
                    return Observable.error(ValidationError.invalidPhoneNumber)
                }

                if gender != "Male" && gender != "Female" {
                    return Observable.error(ValidationError.invalidGender)
                }

                let profile = Profile(
                    name: name,
                    displayName: displayName,
                    phoneNumber: phoneNum,
                    bio: gender,
                    birthDate: birthDate,
                    profileImageUrl: ""
                )

                return ProfileManager.shared.patchProfile(profile: profile)
            }
            .do(onError: { error in
                if let validationError = error as? ValidationError {
                    errorMessage.accept(validationError.errorDescription) // 에러 메시지 전달
                }
            })

        profileInputEvent.subscribe().disposed(by: disposeBag)
        
        let avatarImageDriver = selectedAvatarImageRelay
            .asDriver(onErrorJustReturn: defaultAvatarImage) // 에러 발생 시 기본 이미지 반환
            .map { $0 ?? self.defaultAvatarImage } // nil 값 방지

                
        return Output(
            isProfileValid: isProfileValid,
            genderOptions: genderOptions.asDriver(onErrorJustReturn: []),
            selectedGender: input.gender.asDriver(onErrorJustReturn: "Male"),
            birthDate: birthDateObservable.asDriver(onErrorJustReturn: Date()),
            completeButtonEnabled: completeButtonEnabled,
            errorMessage: errorMessage.asDriver(onErrorJustReturn: nil),
            selectedAvatarImage: avatarImageDriver
        )
    }
    
    // ViewController에서 이미지 업데이트 요청
       func updateSelectedImage(_ image: UIImage?) {
           selectedAvatarImageRelay.accept(image)
       }
}
