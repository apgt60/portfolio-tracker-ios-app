//
//  StockWatch.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 2/29/24.
//

import Foundation

struct StockWatch: Codable {
    let ticker: String
    let logo: String
    let name: String
    let count: Float
    let cost: Float
    let quote: Float
}

/*
 [
         {
             "ticker": "META",
             "logo": "https://static2.finnhub.io/file/publicdatany/finnhubimage/stock_logo/FB.svg",
             "name": "Meta Platforms Inc",
             "count": 124,
             "cost": 444.77,
             "quote": 488.66
         },
         {
             "ticker": "AAPL",
             "logo": "https://static2.finnhub.io/file/publicdatany/finnhubimage/stock_logo/AAPL.svg",
             "name": "Apple Inc",
             "count": 0,
             "cost": 0,
             "quote": 181.34
         }
     ]
 */
