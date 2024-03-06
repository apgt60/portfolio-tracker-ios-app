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
    
//    var stockPositons = [
//        StockWatch(ticker: "GOOG", logo: "https://static2.finnhub.io/file/publicdatany/finnhubimage/stock_logo/FB.svg", name: "Alphabet Inc.", count: 50, cost: 450, quote: 500)
//    ]
    var stockPositons: [StockWatch] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("self: \(self)")
        self.performSegue(withIdentifier: "showAddModal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "showAddModal" {
            print("Segue triggered for HomeViewController with segue identifier \(segue.identifier!)")
            let newVc = segue.destination as! AddStockViewController
            newVc.parentViewContoller = self
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController viewDidLoad()")
        // Do any additional setup after loading the view.
        titleLabel.text = "\(userManager.localUser!.firstname) \(userManager.localUser!.lastname)"
        
        tableView.dataSource = self
        title = ""
        
        let uiNib = UINib(nibName: "StockPositionCell", bundle: nil)
        
        tableView.register(uiNib, forCellReuseIdentifier: "stockPositionCellId")
        
        loadData()
    }
    
    func loadData(){
        networkManager.getStockWatches(userId:userManager.localUser!.id, {(stockWatches: [StockWatch]?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
//                    self.presentError(error)
                }
            }
            
            if let stockWatches {
                print("Received: \(stockWatches.count) stockwatches for user id: \(self.userManager.localUser!.id)")
                self.stockPositons = stockWatches
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called on HomeViewController")
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        print("viewIsAppearing called on HomeViewController")
    }
}



extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockPositons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockPositionCellId", for: indexPath) as! StockPositionCell
        cell.quoteLabel.text = String(stockPositons[indexPath.row].quote)
        cell.tickerLabel.text = stockPositons[indexPath.row].ticker
        
        if(stockPositons[indexPath.row].quote >= stockPositons[indexPath.row].cost){
            cell.upDownIcon.image = UIImage(named: "UpArrow")
        } else {
            cell.upDownIcon.image = UIImage(named: "DownArrow")
        }
        cell.gainLoss.text = "\(stockPositons[indexPath.row].gainLoss)%"
        
//        let url = URL(string: stockPositons[indexPath.row].logo)
//        let data = try? Data(contentsOf: url!)
//
//        if let imageData = data {
//            let image = UIImage(data: imageData)
//            print("image.size for ticker \(cell.tickerLabel.text):\(image?.size)")
//            cell.stockImage.image = image
//        }
        
        // “https://eodhd.com/img/logos/US/MSFT.png“
        
        let path = stockPositons[indexPath.row].logo
        do {
            let data = try Data(contentsOf: URL(string: path)!)
            cell.stockImage.image = UIImage(data: data)
        } catch {
            
        }
        
        
        
        return cell
    }
    
}
