//
//  UserDefaultsConstants.swift
//  Github Rest APi
//
//  Created by Inderpreet Singh on 04/03/24.
//

import Foundation

class UserDefaultsConstants:NSObject {

    static let shareInstance = UserDefaultsConstants()
    
    func isTutorialDone() {
        UserDefaults.standard.setValue(true, forKey: "isTutorial")
    }
    
}
