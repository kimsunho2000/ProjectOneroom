//
//  Utility.swift
//  OneRoom
//
//  Created by 김선호 on 2/10/25.
//

import Foundation
import UIKit

class Utility {
    
    static let shared = Utility()
    
    private init(){}
    
    //화면 전환 메소드(자연스러운 화면 전환)
    public func replaceRootViewController(with newViewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = newViewController
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    
}
