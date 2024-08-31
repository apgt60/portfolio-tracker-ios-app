//
//  StockSearchResponse.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 8/31/24.
//

import Foundation

struct StockSearchResponse: Codable {
    let results : [StockSearchResult]
}

/*
 {
     "results": [
         {
             "id": 6402,
             "ticker": "MET",
             "name": "MetLife, Inc."
         },
         {
             "id": 6403,
             "ticker": "MET-A",
             "name": "Metlife, Inc. Floating Rate Non Cuml Series A"
         },
         {
             "id": 6404,
             "ticker": "MET-E",
             "name": "MetLife, Inc. Depositary Shares, each representing a 1/1,000th interest in a share of 5.625% Non-Cum"
         }
    ]
 }
 */
