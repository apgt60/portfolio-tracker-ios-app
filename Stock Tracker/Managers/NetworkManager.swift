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
    
    /*
     2.1 Modify the getUsers function to accept a completion closure. The closure should accept a Result For the success case, the associated value for the result should be an array of User. For the failure case, the associated value should be a DMError.
     2.2 Continue to modify getUsers to use the closure. For all failures, call the completion closure with the correct DMError. For a success, call the completion closure with the array of User.
     */
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
    
}
