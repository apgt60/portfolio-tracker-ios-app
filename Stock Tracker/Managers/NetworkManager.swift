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
    case invalidCredentials = "The email and password is incorrect.  Please try again."
    case invalidTicker = "The ticker symbol entered is invalid.  Please try again."
    case emailTaken = "An account with the email already exists."
    case passwordMismatch = "Passwords do not match.  Please try again."
    case emailAndPasswordLength = "Please provide a valid email.  Password must be 6 characters long."
}


class NetworkManager {
    static let shared = NetworkManager()
    //TODO: Create environment variable for this URL
    private let baseUrl = AppEnvManager.rootURL
    
    /*
     "http://localhost:8765/api/"
     "https://portfolio-tracker-server-j0cb.onrender.com/api/"
    */
    
    private init() {}
    
    func registerUser(email: String, password: String, firstName: String, lastName: String, _ callback : @escaping (RegisterUserResponse?, DMError?) -> ()) {
        
        let usersURL = baseUrl + "register"
        let params = ["email": email, "password": password, "firstname": firstName, "lastname": lastName]
        
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
            
            //Check for 400 Bad Request if email is already taken
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 400{
                    do {
                        let decodedData = try decoder.decode(GenericErrorResponse.self, from: data!)
                        print("400 server message: \(decodedData.message)")
                        callback(nil, DMError.emailTaken)
                        return
                    } catch {
                        callback(nil, DMError.invalidResponse)
                        print(error)
                        return
                    }
                }
            }
            
            do {
                let decodedData = try decoder.decode(RegisterUserResponse.self, from: data!)
                callback(decodedData, nil)
            } catch {
                callback(nil, DMError.invalidResponse)
                print(error)
            }
        }
        
        task.resume()
    }
    
    func getUser(email: String, password: String, _ callback : @escaping (LoginResponse?, DMError?) -> ()) {
        
        let usersURL = baseUrl + "login"
        let params = ["email": email, "password": password]
        
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
            
            //Check for 401 Unauthorized if credentials are incorrect
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 401{
                    do {
                        let decodedData = try decoder.decode(GenericErrorResponse.self, from: data!)
                        print("401 server message: \(decodedData.message)")
                        callback(nil, DMError.invalidCredentials)
                        return
                    } catch {
                        callback(nil, DMError.invalidResponse)
                        print(error)
                        return
                    }
                }
            }
            
            do {
                let decodedData = try decoder.decode(LoginResponse.self, from: data!)
                callback(decodedData, nil)
            } catch {
                callback(nil, DMError.invalidResponse)
                print(error)
            }
        }
        
        task.resume()
    }
    
    func getStockWatches(authToken: String, _ callback : @escaping ([StockWatch]?, DMError?) -> ()) {
        
        let usersURL = baseUrl + "stockwatches"
        //{"appuser_id":6}
        
        let url = URL(string: usersURL)
        if(url == nil){
            callback(nil, DMError.invalidURL)
            return
        }
        
        //create the Request object using the url object
        var request = URLRequest(url: url!)
        //set http method as GET
        request.httpMethod = "GET"

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(authToken, forHTTPHeaderField: "authtoken")
        
        //Use DI to abstract this so that it can be mocked
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
    
    func searchTicker(authToken: String, searchText: String, _ callback : @escaping ([StockSearchResult]?, DMError?) -> ()) {
        
        let usersURL = baseUrl + "searchByTicker"
        
        var url = URL(string: usersURL)
        let queryItem = URLQueryItem(name: "text", value: searchText)
        url?.append(queryItems: [queryItem])
        if(url == nil){
            callback(nil, DMError.invalidURL)
            return
        }
        
        //create the Request object using the url object
        var request = URLRequest(url: url!)
        //set http method as GET
        request.httpMethod = "GET"

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(authToken, forHTTPHeaderField: "authtoken")
        
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
                let decodedData = try decoder.decode(StockSearchResponse.self, from: data!)
                callback(decodedData.results, nil)
            } catch {
                callback(nil, DMError.invalidResponse)
                print(error)
            }
        }
        
        task.resume()
    }
    
    func addStockWatch(authToken: String, count: Float , ticker: String, cost: Float, _ callback : @escaping (AddStockResponse?, DMError?) -> ()) {
        
        let usersURL = baseUrl + "addstockwatch"
        //{"ticker":"aapl","count": 0,"cost":0}
        let params = ["ticker": ticker, "count": count, "cost": cost] as [String : Any]
        
        let url = URL(string: usersURL)
        if(url == nil){
            callback(nil, DMError.invalidURL)
            return
        }
        
        //create the Request object using the url object
        var request = URLRequest(url: url!)
        //set http method as PUT
        request.httpMethod = "PUT"

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
        request.addValue(authToken, forHTTPHeaderField: "authtoken")
        
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
            
            //Check for 400 Bad Request if ticker is invalid
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 400{
                    do {
                        let decodedData = try decoder.decode(AddStockErrorResponse.self, from: data!)
                        print("200 server error: \(decodedData.error)")
                        callback(nil, DMError.invalidTicker)
                        return
                    } catch {
                        callback(nil, DMError.invalidResponse)
                        print(error)
                        return
                    }
                }
            }
            
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
    
    func removeStockWatch(authToken: String, uuid: String, _ callback : @escaping (RemoveStockResponse?, DMError?) -> ()) {
        
        let usersURL = baseUrl + "removewatch/\(uuid)"
        
        let url = URL(string: usersURL)
        if(url == nil){
            callback(nil, DMError.invalidURL)
            return
        }
        
        //create the Request object using the url object
        var request = URLRequest(url: url!)
        //set http method as DELETE
        request.httpMethod = "DELETE"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(authToken, forHTTPHeaderField: "authtoken")
        
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
            
            //Check for 400 Bad Request if ticker is invalid
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 400{
                    do {
                        let decodedData = try decoder.decode(AddStockErrorResponse.self, from: data!)
                        print("200 server error: \(decodedData.error)")
                        callback(nil, DMError.invalidTicker)
                        return
                    } catch {
                        callback(nil, DMError.invalidResponse)
                        print(error)
                        return
                    }
                }
            }
            
            do {
                let decodedData = try decoder.decode(RemoveStockResponse.self, from: data!)
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
