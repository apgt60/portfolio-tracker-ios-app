//
//  StockWatchDetailViewController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 3/13/24.
//

import UIKit

class StockWatchDetailViewController : UIViewController {
    
    var networkManager = NetworkManager.shared
    var userManager = UserManager.shared
    
    var parentViewContoller : HomeViewController?
    
    @IBOutlet weak var stockImage: UIImageView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var upDownIcon: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var gainLossPercentLabel: UILabel!
    @IBOutlet weak var numberOfSharesLabel: UILabel!
    @IBOutlet weak var unitCostLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var currValueLabel: UILabel!
    @IBOutlet weak var totalGainLossLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewDidLoad() - StockWatchDetailViewController for \(self.parentViewContoller?.currentDetailStockWatch?.ticker)")
        
        let stockPositionCell = parentViewContoller?.currentDetailStockPositionCell
        let stockWatch = stockPositionCell!.stockWatch
        
        self.numberOfSharesLabel.text = "Shares: \(stockWatch!.count)"
        self.unitCostLabel.text = "Unit Cost: $\(stockWatch!.cost)"
        self.totalCostLabel.text = "Total Cost: $\(stockWatch!.totalCost)"
        self.currValueLabel.text = "Curr Value: $\(stockWatch!.totalAmount)"
        
        let imageForStock = stockPositionCell?.stockImage.image
        let imageForUpDownIcon = stockPositionCell?.upDownIcon.image
        DispatchQueue.main.async {
            self.stockImage.image = imageForStock
            self.upDownIcon.image = imageForUpDownIcon
        }
        
        self.tickerLabel.text = stockWatch!.ticker
        self.nameLabel.text = stockWatch!.name
        self.quoteLabel.text = "$\(String(stockWatch!.quote))"
        self.gainLossPercentLabel.text = "\(String(stockWatch!.gainLoss))%"
        if(Float(stockWatch!.quote) > Float(stockWatch!.cost)!){
            self.gainLossPercentLabel.textColor = UIColor.green
            self.totalGainLossLabel.text = "Total Gain: $\(stockWatch!.totalGainLoss)"
        } else {
            self.gainLossPercentLabel.textColor = UIColor.red
            self.totalGainLossLabel.text = "Total Loss: $\(stockWatch!.totalGainLoss)"
        }
    }
    
    
    @IBAction func removeStockButtonPressed(_ sender: Any) {
        presentRemoveConfirmation()
    }
    
    func presentRemoveConfirmation(){
        let alert = UIAlertController(title: "Please Confirm", message: "Are you sure you want stop watching this stock?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            //delete from server and reload data
            self.performDelete()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {_ in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func performDelete(){
        networkManager.removeStockWatch(authToken: self.userManager.authToken!, uuid: self.parentViewContoller!.currentDetailStockWatch!.guid, {(removeStockResponse: RemoveStockResponse?, error: DMError?) -> () in
            if error != nil {
                //TODO: Handle delete error
            }
            
            if removeStockResponse != nil {
                print("Sucessfully removed stock watch")
                //reload data for parent
                self.parentViewContoller?.loadData()
                //dismiss current view
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        })
    }
    
    func performAdd(){
        networkManager.addStockWatch(authToken:self.userManager.authToken!, count: 1, ticker: "tsla", cost: 10.0, {(addStockResponse: AddStockResponse?, error: DMError?) ->  () in
//            if let error {
//                DispatchQueue.main.async {
//                    self.presentError(error)
//                }
//            }
            
            if let addStockResponse {
                print("Sucessfully added \(addStockResponse.ticker) to stock list")
//                DispatchQueue.main.async {
//                    self.parentViewContoller?.loadData()
//                    self.dismiss(animated: true)
//                }
            }
            
            DispatchQueue.main.async {
                //self.tableView.reloadData()
            }

        })
    }
    
}


