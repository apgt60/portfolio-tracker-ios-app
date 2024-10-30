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
    let cost: String
    let id: Int
    let guid: String
    let quote: Float
    let gainLoss: String
    let totalAmount: String
    let totalCost: String
    let totalGainLoss: String
}

/*
    [
 "ticker": "HD",
            "logo": "https://eodhd.com/img/logos/US/hd.png",
            "name": "Home Depot Inc",
            "count": 100,
            "cost": 150,
            "id": 55,
            "guid": "ee6682f1-e46b-403e-9caa-0f49561100bf",
            "quote": 342.4,
            "gainLoss": 128.3,
            "altLogo": "https://eodhd.com/img/logos/US/HD.png",
            "totalAmount": 34240,
            "totalCost": 15000,
            "totalGainLoss": 19240
        },
        {
            "ticker": "AAPL",
            "logo": "https://eodhd.com/img/logos/US/aapl.png",
            "name": "Apple Inc",
            "count": 10,
            "cost": 212,
            "id": 57,
            "guid": "be8ade7f-70c2-446c-b6f1-360dbea1e2b4",
            "quote": 209.82,
            "gainLoss": -1,
            "altLogo": "https://eodhd.com/img/logos/US/AAPL.png",
            "totalAmount": 2098.2,
            "totalCost": 2120,
            "totalGainLoss": -21.8
        }
     ]
 */
