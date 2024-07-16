//
//  ViewController.swift
//  Stock Tracker
//
//  Created by Amit Patel on 2/28/24.
//

import UIKit

class LoginController: UIViewController {
    
    var networkManager = NetworkManager.shared
    var userManager = UserManager.shared
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordText.isSecureTextEntry = true
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        print("viewIsAppearing called on LoginController")
        passwordText.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        networkManager.getUser(username:usernameText.text!, password: passwordText.text!, {(loginResponse: LoginResponse?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
            
            if let loginResponse {
                print("Received user: \(loginResponse.user.username) with id: \(loginResponse.user.guid) and token: \(loginResponse.token.prefix(5))...")
                self.userManager.localUser = loginResponse.user
                self.userManager.authToken = loginResponse.token
            }
            
            DispatchQueue.main.async {
                //self.tableView.reloadData()
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showHome", sender: self)
            }
        })
    }
    
    @IBAction func createNewAccountButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showRegister", sender: self)
        }
        
    }
    
    func presentError(_ error : DMError){
        print(error.rawValue)
        let alert = UIAlertController(title: "Login Error", message: error.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.passwordText.text = ""
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

