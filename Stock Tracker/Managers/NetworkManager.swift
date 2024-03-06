//
//  NetworkManager.swift
//  Stock Tracker
//
//  Created by Amit Patel on 2/28/24.
//

import Foundation

enum DMError: String, Error {
    case invalidURL = "There was an issue connecting to the server."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}


class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "http://localhost:8765/api/" //login"
    
    private init() {}
    
    func getUser(username: String, password: String, _ callback : @escaping (LocalUser?, DMError?) -> ()) {
        
        let usersURL = baseUrl + "login"
        let params = ["username": username, "password": password]
        
        let url = URL(string: usersURL)
        if(url == nil){
            callback(nil, DMError.invalidURL)
            return
        }
        
        //create the Request object using the url object
        var request = URLRequest(url: url!)
        //set http method as POST
        request.httpMethod = "POST"

        do {
            // pass dictionary to data object and set it as request body
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            callback(nil, DMError.invalidURL)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                print("Error not nil: \(error!)")
                callback(nil, DMError.unableToComplete)
                return
            }
            
            if(data == nil){
                print("data is nil")
                callback(nil, DMError.unableToComplete)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedData = try decoder.decode(LocalUser.self, from: data!)
                callback(decodedData, nil)
            } catch {
                callback(nil, DMError.invalidResponse)
                print(error)
            }
        }
        
        task.resume()
    }
    
    func getStockWatches(userId: Int, _ callback : @escaping ([StockWatch]?, DMError?) -> ()) {
        
        let usersURL = baseUrl + "stockwatches"
        //{"appuser_id":6}
        let params = ["appuser_id": userId]
        
        let url = URL(string: usersURL)
        if(url == nil){
            callback(nil, DMError.invalidURL)
            return
        }
        
        //create the Request object using the url object
        var request = URLRequest(url: url!)
        //set http method as GET
        request.httpMethod = "POST"

        do {
            // pass dictionary to data object and set it as request body
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            callback(nil, DMError.invalidURL)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                print("Error not nil: \(error!)")
                callback(nil, DMError.unableToComplete)
                return
            }
            
            if(data == nil){
                print("data is nil")
                callback(nil, DMError.unableToComplete)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedData = try decoder.decode(StockWatchResponse.self, from: data!)
                callback(decodedData.watches, nil)
            } catch {
                callback(nil, DMError.invalidResponse)
                print(error)
            }
        }
        
        task.resume()
    }
    
    func addStockWatch(userId: Int, count: Int , ticker: String, cost: Float, _ callback : @escaping (AddStockResponse?, DMError?) -> ()) {
        
        let usersURL = baseUrl + "addstockwatch"
        //{"appuser_id":6,"ticker":"aapl","count": 0,"cost":0}
        let params = ["appuser_id": userId, "ticker": ticker, "count": count, "cost": cost] as [String : Any]
        
        let url = URL(string: usersURL)
        if(url == nil){
            callback(nil, DMError.invalidURL)
            return
        }
        
        //create the Request object using the url object
        var request = URLRequest(url: url!)
        //set http method as POST
        request.httpMethod = "POST"

        do {
            // pass dictionary to data object and set it as request body
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            callback(nil, DMError.invalidURL)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                print("Error not nil: \(error!)")
                callback(nil, DMError.unableToComplete)
                return
            }
            
            if(data == nil){
                print("data is nil")
                callback(nil, DMError.unableToComplete)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedData = try decoder.decode(AddStockResponse.self, from: data!)
                callback(decodedData, nil)
            } catch {
                callback(nil, DMError.invalidResponse)
                print(error)
            }
        }
        
        task.resume()
    }
    
    func getImageData(imageUrl: String, _ callback : @escaping (Data?, DMError?) -> ()) {
        
        let url = URL(string: imageUrl)
        if(url == nil){
            callback(nil, DMError.invalidURL)
            return
        }
        
        //create the Request object using the url object
        var request = URLRequest(url: url!)
        //set http method as GET
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if(error != nil){
                print("Error not nil: \(error!)")
                callback(nil, DMError.unableToComplete)
                return
            }
            
            if(data == nil){
                print("data is nil")
                callback(nil, DMError.unableToComplete)
                return
            }
            
            callback(data, nil)
        }
        
        task.resume()
    }
    
}
