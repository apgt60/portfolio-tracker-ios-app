//
//  ViewController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 2/29/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    var networkManager = NetworkManager.shared
    var userManager = UserManager.shared
    
    var stockPositons = [
        StockWatch(ticker: "GOOG", logo: "https://static2.finnhub.io/file/publicdatany/finnhubimage/stock_logo/FB.svg", name: "Alphabet Inc.", count: 50, cost: 450, quote: 500)
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showAddModal", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController viewDidLoad()")
        // Do any additional setup after loading the view.
        titleLabel.text = "\(userManager.localUser!.firstname) \(userManager.localUser!.lastname)"
        
        tableView.dataSource = self
        title = "some title"
        
        tableView.register(UINib(nibName: "StockPositionCell", bundle: nil), forCellReuseIdentifier: "stockPositionCellId")
    }
    

}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockPositons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockPositionCellId", for: indexPath) as! StockPositionCell
        cell.costLabel.text = String(stockPositons[indexPath.row].cost)
        cell.quoteLabel.text = String(stockPositons[indexPath.row].quote)
        cell.tickerLabel.text = stockPositons[indexPath.row].ticker
        return cell
    }
    
}
