//
//  AddStockViewController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 3/4/24.
//

import UIKit

class AddStockViewController: UIViewController, TickerSearchResultCellDelegate {
    
    var networkManager = NetworkManager.shared
    var userManager = UserManager.shared
    var parentViewContoller : HomeViewController?
    var tickerSearchResults : [StockSearchResult] = []
    
    @IBOutlet weak var stockSymbolField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    
    @IBOutlet weak var stockSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addStockButtonPressed(_ sender: UIButton) {
        print("adding \(quantityField.text!) shares of \(stockSymbolField.text!) with price of \(priceField.text!) to list")
        //authToken, count: Int , ticker: String, cost: Float
        let quantity = Float(quantityField.text!)
        let price = Float(priceField.text!)
        if(quantity == nil || price == nil){
            presentInputError("Quantity and Price must be numbers.")
            return
        }
        
        networkManager.addStockWatch(authToken:self.userManager.authToken!, count: quantity!, ticker: stockSymbolField.text!, cost: price!, {(addStockResponse: AddStockResponse?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
            
            if let addStockResponse {
                print("Sucessfully added \(addStockResponse.ticker) to stock list")
                //reload data for parent
                self.parentViewContoller?.loadData()
                //dismiss current view
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }

        })
        
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
        
        print("AddStockViewController viewDidLoad()")
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        title = ""
        
        let uiNib = UINib(nibName: "TickerSearchResultCellTableViewCell", bundle: nil)
        
        tableView.register(uiNib, forCellReuseIdentifier: "searchResultCellId")
        
        tableView.isHidden = true
        
    }
    
    func loadData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        if(searchText.isEmpty){
            tableView.isHidden = true
            return
        }
        
        networkManager.searchTicker(authToken:self.userManager.authToken!, searchText: searchText,  {(searchResults: [StockSearchResult]?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
                    self.presentError(error)
                }
            }
            
            if let searchResults {
                print("Found \(searchResults.count) results for searchText: \(searchText)")
                self.tickerSearchResults = searchResults
                
                
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        })
    }
    
}

extension AddStockViewController : UITableViewDelegate {
    func didTapButtonInCell(_ cell: TickerSearchResultCellTableViewCell) {
        print("User chose a search result cell")
        print("self: \(self)")
        stockSymbolField.text = cell.stockSearchResult?.ticker
        tableView.isHidden = true
        stockSearchBar.text = ""
        priceField.becomeFirstResponder()
    }
}


extension AddStockViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickerSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView(AddStockViewController)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCellId", for: indexPath) as! TickerSearchResultCellTableViewCell
        let searchResult = tickerSearchResults[indexPath.row]
        
        cell.companyName.text = searchResult.name
        cell.stockSearchResult = searchResult
        cell.delegate = self
        
        let path = "https://eodhd.com/img/logos/US/tsla.png"
        
        networkManager.getImageData(imageUrl: path, {(data: Data?, error: DMError?) ->  () in
            if error != nil {
                print("Didn't find \(path)")
            }
            
            if let data {
                print("Received: \(data.count) bytes for image \(path).")
                if(data.count > 200){
                    //this means it was found for stockPositons[i].logo
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.stockImage.image = image
                    }
                } else {
                    //try altLogo
                    let newPath = "https://eodhd.com/img/logos/US/tsla.png"
                    self.networkManager.getImageData(imageUrl: newPath, {(data: Data?, error: DMError?) ->  () in
                        if let error {
                            print("Didn't find \(newPath)")
                        }
                        
                        if let data {
                            print("Received: \(data.count) bytes for new image \(newPath).")
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                cell.stockImage.image = image
                            }
                        }
                    })
                }
                
                //self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            }
        })
        
        return cell
    }
}
