//
//  AddStockErrorResponse.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 6/25/24.
//

import Foundation

struct AddStockErrorResponse: Codable {
    let ticker: String
    let error: String
    let success: Bool
}

/*
 {
     "ticker": "tslala",
     "error": "invalid ticker symbol",
     "success": false
 }
 */
