//
//  StockWatchDetailViewController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 3/13/24.
//

import UIKit

class StockWatchDetailViewController : UIViewController {
    
    var parentViewContoller : HomeViewController?
    
    @IBOutlet weak var stockImage: UIImageView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var upDownIcon: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var gainLossPercentLabel: UILabel!
    @IBOutlet weak var numberOfSharesLabel: UILabel!
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
        self.totalCostLabel.text = "Total Cost: $\(stockWatch!.totalCost)"
        self.currValueLabel.text = "Curr Value: $\(stockWatch!.totalAmount)"
        
        let imageForStock = stockPositionCell?.stockImage.image
        let imageForUpDownIcon = stockPositionCell?.upDownIcon.image
        DispatchQueue.main.async {
            self.stockImage.image = imageForStock
            self.upDownIcon.image = imageForUpDownIcon
        }
        
        print("stockWatch?.ticker:")
        print("\(stockWatch!.ticker)")
        self.tickerLabel.text = stockWatch!.ticker
        self.nameLabel.text = stockWatch!.name
//        self.quoteLabel.text = "$\(String(describing: stockWatch!.quote))"
        self.quoteLabel.text = "$\(String(stockWatch!.quote))"
//        self.gainLossPercentLabel.text = "\(String(describing: stockWatch!.gainLoss))%"
        self.gainLossPercentLabel.text = "\(String(stockWatch!.gainLoss))%"
        if(stockWatch!.quote > stockWatch!.cost){
            self.gainLossPercentLabel.textColor = UIColor.green
            self.totalGainLossLabel.text = "Total Gain: $\(stockWatch!.totalGainLoss)"
        } else {
            self.gainLossPercentLabel.textColor = UIColor.red
            self.totalGainLossLabel.text = "Total Loss: $\(stockWatch!.totalGainLoss)"
        }
        
    }
    
}


