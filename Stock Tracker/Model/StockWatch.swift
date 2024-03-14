//
//  StockWatch.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 2/29/24.
//

import Foundation

struct StockWatchResponse: Codable {
    let success: Bool
    let watches: [StockWatch]
}

struct StockWatch: Codable {
    let ticker: String
    let logo: String
    let altLogo: String
    let name: String
    let count: Float
    let cost: Float
    let id: Int
    let quote: Float
    let gainLoss: Float
    let totalAmount: Float
    let totalCost: Float
    let totalGainLoss: Float
}

/*
    [
         {
             "ticker": "WMT",
             "logo": "https://eodhd.com/img/logos/US/wmt.png",
             "name": "Walmart Inc",
             "count": 10,
             "cost": 55,
             "id": 32,
             "quote": 60.71,
             "gainLoss": 10.4,
             "altLogo": "https://eodhd.com/img/logos/US/WMT.png",
             "totalAmount": 607.1,
             "totalCost": 550,
             "totalGainLoss": 57.1
         },
         {
             "ticker": "KO",
             "logo": "https://eodhd.com/img/logos/US/ko.png",
             "name": "Coca-Cola Co",
             "count": 10,
             "cost": 65,
             "id": 33,
             "quote": 60.625,
             "gainLoss": -6.7,
             "altLogo": "https://eodhd.com/img/logos/US/KO.png",
             "totalAmount": 606.25,
             "totalCost": 650,
             "totalGainLoss": -43.75
         }
     ]
 */
