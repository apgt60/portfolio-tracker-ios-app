//
//  RegisterUserResponse.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 7/17/24.
//

import Foundation

struct RegisterUserResponse: Codable {
    let username: String
    let success: Bool
}

//{"username": "userT1000tn","success": false}
