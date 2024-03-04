//
//  AddStockViewController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 3/4/24.
//

import UIKit

class AddStockViewController: UIViewController {
    
    @IBOutlet weak var stockSymbolField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    
    @IBAction func addStockButtonPressed(_ sender: UIButton) {
        print("adding \(quantityField.text!) shares of \(stockSymbolField.text!) with price of \(priceField.text!) to list")
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
