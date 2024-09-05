//
//  StockSearchResult.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 8/31/24.
//

import Foundation

struct StockSearchResult : Codable {
    let id: Int
    let ticker: String
    let name: String
    let logo: String
    let altLogo: String
}
