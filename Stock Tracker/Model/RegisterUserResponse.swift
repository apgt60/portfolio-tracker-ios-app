//
//  RegisterUserResponse.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 7/17/24.
//

import Foundation

struct RegisterUserResponse: Codable {
    let email: String
    let success: Bool
}

//{"email": "userT1000tn@email.edu","success": false}
