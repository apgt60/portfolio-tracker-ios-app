//
//  LoginResponse.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 6/25/24.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let user: LocalUser
}

/*
 {
 "token": "eyJhbGc...xFI_RlVmiDyorbk",
 "user": {
     "guid": "2e152be8-0518-40a0-9084-ea5764b98ec6",
     "username": "userH002",
     "firstname": "Testy",
     "lastname": "Tester",
     "created": "2024-06-24T20:06:55.060Z"
 }
 */
