//
//  AddStockViewController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 3/4/24.
//

import UIKit

class AddStockViewController: UIViewController {
    
    var networkManager = NetworkManager.shared
    var userManager = UserManager.shared
    var parentViewContoller : HomeViewController?
    
    @IBOutlet weak var stockSymbolField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    
    @IBAction func addStockButtonPressed(_ sender: UIButton) {
        print("adding \(quantityField.text!) shares of \(stockSymbolField.text!) with price of \(priceField.text!) to list")
        //userId: Int, count: Int , ticker: String, cost: Float
        networkManager.addStockWatch(userId:self.userManager.localUser!.id, count: Int(quantityField.text!)!, ticker: stockSymbolField.text!, cost: Float(priceField.text!)!, {(addStockResponse: AddStockResponse?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
                    //self.presentError(error)
                }
            }
            
            if let addStockResponse {
                print("Sucessfully added \(addStockResponse.ticker) to stock list")
                DispatchQueue.main.async {
                    self.parentViewContoller?.loadData()
                    self.dismiss(animated: true)
                }
            }
            
            DispatchQueue.main.async {
                //self.tableView.reloadData()
            }
            
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "showHome", sender: self)
//            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
