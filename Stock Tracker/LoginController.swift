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
        
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        networkManager.getUser(username:usernameText.text!, password: passwordText.text!, {(localUser: LocalUser?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
            
            if let localUser {
                print("Received user: \(localUser.username) with id: \(localUser.id)")
                self.userManager.localUser = localUser
            }
            
            DispatchQueue.main.async {
                //self.tableView.reloadData()
            }
            
            print("successfully logged in and got new user id \(self.userManager.localUser!.id)")
            
        })
    }
    
    
    func presentError(_ error : DMError){
       print(error.rawValue)
       let alert = UIAlertController(title: "Network Error", message: error.rawValue, preferredStyle: .alert)
       present(alert, animated: true, completion: nil)
   }
    
    


}

