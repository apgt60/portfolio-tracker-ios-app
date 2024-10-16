//
//  GenericErrorResponse.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 6/25/24.
//

import Foundation

struct GenericErrorResponse: Codable {
    let errors: [FieldError]
}


/*
 {
     "errors": [
         {
             "field": "username",
             "error": "Username must be at least 4 characters long."
         },
         {
             "field": "password",
             "error": "Password must be at least 6 characters long."
         }
     ],
     "success": false
 }
 */
