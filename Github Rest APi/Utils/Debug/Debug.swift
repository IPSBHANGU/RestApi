//
//  Debug.swift
//  APiDemo
//
//  Created by Inderpreet Singh on 29/02/24.
//

import Foundation

class Debug:NSObject {
    let is_DEBUG = false
    
    static let shared = Debug()
    
    func getBoolValue() -> Bool {
        return is_DEBUG
    }
}
