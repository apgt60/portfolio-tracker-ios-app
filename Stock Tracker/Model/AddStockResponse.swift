//
//  AddStockResponse.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 3/4/24.
//

import Foundation

struct AddStockResponse: Codable {
    let ticker: String
    let cost: Float
    let success: Bool
}

//{"ticker": "aapl","cost": 0,"success": true}
