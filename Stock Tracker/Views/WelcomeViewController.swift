//
//  WelcomeViewController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 7/16/24.
//

import Foundation

import UIKit

class WelcomeViewController: UIViewController {
    
    var networkManager = NetworkManager.shared
    var userManager = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
    }
    
    @IBAction func backToLoginButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
    
    func presentError(_ error : DMError){
    }
    
}

