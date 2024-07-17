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
    
    var userName: String?
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordText.isSecureTextEntry = true
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
        secondViewController.receivedUserName = self.userName ?? "<username>"
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        networkManager.registerUser(username:userNameText.text!, password: passwordText.text!,firstName: "", lastName: "", {(registerUserResponse: RegisterUserResponse?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
            
            if let registerUserResponse {
                print("Created new user: \(registerUserResponse.username)")
                self.userName = registerUserResponse.username
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
            self.userNameText.text = ""
            self.emailText.text = ""
            self.passwordText.text = ""
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

