//
//  AddStockResponse.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 3/4/24.
//

import Foundation

struct AddStockResponse: Codable {
    let ticker: String
    let count: Int
    let cost: Float
    let success: Bool
}

/*
 {
     "ticker": "AAPL",
     "count": 10,
     "cost": 212,
     "success": true
 }
 */
