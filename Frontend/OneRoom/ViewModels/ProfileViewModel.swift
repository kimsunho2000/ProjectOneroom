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
        let completeButtonTap: Observable<Void>
    }
    
    struct Output {
        let isProfileValid: Driver<Bool>
        let genderOptions: Driver<[String]> // "Male", "Female" 선택 옵션
        let selectedGender: Driver<String> // 현재 선택된 성별
        let birthDate: Driver<String> // 현재 선택된 생년월일
        let completeButtonEnabled: Driver<Bool>
        let errorMessage: Driver<String?> // 에러 메시지 전달
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let genderOptions = Observable.just(["Male", "Female"])
        
        let isProfileValid = Observable.combineLatest(input.name, input.displayName,
                                                      input.phoneNum, input.gender, input.birthDate) {
            name, displayName, phoneNum, gender, birthDate in
            return !name.isEmpty && !displayName.isEmpty && !phoneNum.isEmpty && !gender.isEmpty && !birthDate.isEmpty
        }.asDriver(onErrorJustReturn: false)
            
        let completeButtonEnabled = isProfileValid
        
        let errorMessage = PublishRelay<String?>()
        
        let profileInputEvent = input.completeButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.name, input.displayName, input.phoneNum, input.gender, input.birthDate
            ))
            .flatMapLatest { name, displayName, phoneNum, gender, birthDate  -> Observable<String?> in
                // 검증
                if !RegexHelper.isNameValid(name) {
                    return Observable.just(ValidationError.invalidName.errorDescription)
                }
                
                if !RegexHelper.isNickNameValid(displayName) {
                    return Observable.just(ValidationError.invalidNickName.errorDescription)
                }
                
                if !RegexHelper.isPhoneNumberValid(phoneNum) {
                    return Observable.just(ValidationError.invalidPhoneNumber.errorDescription)
                }
                
                if gender != "Male" && gender != "Female" {
                    return Observable.just(ValidationError.invalidGender.errorDescription)
                }
                
                if birthDate.isEmpty {
                    return Observable.just(ValidationError.invalidBirthDate.errorDescription)
                }
                
                // 모든 검증 통과 시 오류 메시지를 nil로 설정
                return Observable.just(nil)
            }
            .do(onNext: { message in
                errorMessage.accept(message)
            })
        
        profileInputEvent.subscribe().disposed(by: disposeBag)

        return Output(
            isProfileValid: isProfileValid,
            genderOptions: genderOptions.asDriver(onErrorJustReturn: []),
            selectedGender: input.gender.asDriver(onErrorJustReturn: "Male"),
            birthDate: input.birthDate.asDriver(onErrorJustReturn: ""),
            completeButtonEnabled: completeButtonEnabled,
            errorMessage: errorMessage.asDriver(onErrorJustReturn: nil)
        )
    }
}
