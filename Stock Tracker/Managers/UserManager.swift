//
//  UserManager.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 2/28/24.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    var localUser : LocalUser?
    var authToken: String?
    
    private init() {}
}
