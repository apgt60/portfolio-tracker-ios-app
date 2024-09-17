//
//  AppEnvManager.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 9/17/24.
//

import Foundation

enum AppEnvManager {
    
    private static let infoDict : [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist is not found")
        }
        return dict
    }()
    
    static var rootURL: String {
        guard let baseUrlString = AppEnvManager.infoDict["API_BASE_URL"] as? String else {
            fatalError("API_BASE_URL not found")
        }
        
        return baseUrlString
    }
}
