//
//  RegexHelper.swift
//  OneRoom
//
//  Created by 김선호 on 2/1/25.
//

import Foundation

class RegexHelper {
    
    let shared = RegexHelper()
    
    //ID 검증
    static func isIDValid(_ ID : String) {
        //이메일 주소만 입력 받는 정규식
        private let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return ID.range(of: pattern, options: .regularExpression) != nil
    }
    
    //PW 검증
    static func isPWValid(_ PW : String) {
        
    }
    
}
