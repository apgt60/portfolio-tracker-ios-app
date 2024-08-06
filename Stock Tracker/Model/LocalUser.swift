//
//  LocalUser.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 2/28/24.
//

import Foundation

struct LocalUser: Codable {
    let guid: String
    let email: String
    let firstname: String
    let lastname: String
}

/*
{"guid": "a54e74cd-97ea-4e14-bd4b-7c6b0eaa8223",
"email": "email3@test.edu",
"firstname": "Userf",
"lastname": "Userl",
"created": "2024-08-06T06:13:26.422Z"
*/


