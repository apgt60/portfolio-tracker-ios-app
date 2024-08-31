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
    
    
    @IBOutlet weak var stockSearchBar: UISearchBar!
    
    @IBAction func addStockButtonPressed(_ sender: UIButton) {
        print("adding \(quantityField.text!) shares of \(stockSymbolField.text!) with price of \(priceField.text!) to list")
        //authToken, count: Int , ticker: String, cost: Float
        let quantity = Float(quantityField.text!)
        let price = Float(priceField.text!)
        if(quantity == nil || price == nil){
            presentInputError("Quantity and Price must be numbers.")
            return
        }
        
        
    }
    
    func presentError(_ error : DMError){
        print(error.rawValue)
        let alert = UIAlertController(title: "Add Stock Error", message: error.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in}))
        present(alert, animated: true, completion: nil)
    }
    
    func presentInputError(_ error : String){
        let alert = UIAlertController(title: "Add Stock Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in}))
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        stockSearchBar.barStyle = .black
//        stockSearchBar.placeholder = "Ticker Symbol Search"
//        stockSearchBar.sizeToFit()
//        stockSearchBar.isTranslucent = true
//        stockSearchBar.delegate = self
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

extension AddStockViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)")
        
        networkManager.searchTicker(authToken:self.userManager.authToken!, searchText: searchText,  {(searchResults: [StockSearchResult]?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
            
            if let searchResults {
                print("Found \(searchResults.count) results for searchText: \(searchText)")
                
                DispatchQueue.main.async {
                    if(searchResults.count == 1){
                        self.stockSymbolField.text = searchResults[0].ticker
                    }
                }
            }
            
            DispatchQueue.main.async {
                //self.tableView.reloadData()
            }

        })
    }
    
}
