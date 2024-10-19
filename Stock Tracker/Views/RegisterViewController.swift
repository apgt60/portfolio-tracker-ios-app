//
//  RegisterController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 7/16/24.
//
//

import UIKit

class RegisterViewController: UIViewController {
    
    var networkManager = NetworkManager.shared
    
    var userEmail: String?
    var userFullname: String?
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordText.isSecureTextEntry = true
        confirmPasswordText.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called on RegisterViewController")
        self.navigationController?.navigationBar.isHidden = false
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        print("viewIsAppearing called on RegisterController")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get a reference to the second view controller
        let secondViewController = segue.destination as! WelcomeViewController
        
        // Set a variable in the second view controller with the String to pass
        secondViewController.receivedUserFullname = self.userFullname ?? "<userFullname>"
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        if(passwordText.text != confirmPasswordText.text){
            self.presentError(DMError.passwordMismatch)
        }
        
        networkManager.registerUser(email:emailText.text!, password: passwordText.text!,firstName: firstNameText.text!, lastName: lastNameText.text!, {(registerUserResponse: RegisterUserResponse?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
            
            if let registerUserResponse {
                print("Created new user: \(registerUserResponse.email)")
                self.userEmail = registerUserResponse.email
                self.userFullname = registerUserResponse.name
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showWelcome", sender: self)
            }
        })
    }
    
    
    func presentError(_ error : DMError){
        print(error.rawValue)
        let alert = UIAlertController(title: "Registration Error", message: error.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
//            self.emailText.text = ""
            self.passwordText.text = ""
            self.confirmPasswordText.text = ""
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

