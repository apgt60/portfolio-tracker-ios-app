//
//  WelcomeViewController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 7/16/24.
//

import Foundation

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeMessageText: UILabel!
    
    var networkManager = NetworkManager.shared
    var userManager = UserManager.shared
    var receivedUserFullname = "<userEmail>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called on WelcomeViewController")
        self.navigationController?.navigationBar.isHidden = true
        welcomeMessageText.text = "\(self.receivedUserFullname).  Please log in."
    }
    
    
    
    @IBAction func backToLoginButtonPressed(_ sender: Any) {
        //go back to the initial login screen
        if let firstViewController = self.navigationController?.viewControllers.first {
                self.navigationController?.popToViewController(firstViewController, animated: true)
            }
    }
    
    func presentError(_ error : DMError){
    }
    
}

