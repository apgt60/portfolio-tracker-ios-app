//
//  ViewController.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 2/29/24.
//

import UIKit

class HomeViewController: UIViewController, StockPositionCellDelegate {
    
    var networkManager = NetworkManager.shared
    var userManager = UserManager.shared
    var stockPositons: [StockWatch] = []
    var currentDetailStockWatch : StockWatch?
    var currentDetailStockPositionCell : StockPositionCell?
    
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
        } else if segue.identifier == "showDetailModal" {
            print("Segue triggered for HomeViewController with segue identifier \(segue.identifier!)")
            let newVc = segue.destination as! StockWatchDetailViewController
            newVc.parentViewContoller = self
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController viewDidLoad()")
        // Do any additional setup after loading the view.
        titleLabel.text = "Portfolio for \(userManager.localUser!.firstname) \(userManager.localUser!.lastname)"
        
        tableView.dataSource = self
        title = ""
        
        let uiNib = UINib(nibName: "StockPositionCell", bundle: nil)
        
        tableView.register(uiNib, forCellReuseIdentifier: "stockPositionCellId")
        
        loadData()
    }
    
    func loadData(){
        networkManager.getStockWatches(authToken:userManager.authToken!, {(stockWatches: [StockWatch]?, error: DMError?) ->  () in
            if let error {
                DispatchQueue.main.async {
                    print("Error getting stock watches:")
                    self.presentError(error)
                }
            }
            
            if let stockWatches {
                print("Received: \(stockWatches.count) stockwatches for user id: \(self.userManager.localUser!.guid)")
                self.stockPositons = stockWatches
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called on HomeViewController")
        
        self.navigationController?.navigationBar.isHidden = false
        
        let backButton = UIBarButtonItem()
        backButton.title = "Logout"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        print("viewIsAppearing called on HomeViewController")
    }
    
    func presentError(_ error : DMError){
       print(error.rawValue)
       let alert = UIAlertController(title: "Network Error", message: error.rawValue, preferredStyle: .alert)
       present(alert, animated: true, completion: nil)
   }
}

extension HomeViewController : UITableViewDelegate {
    func didTapButtonInCell(_ cell: StockPositionCell) {
        print("Load details screen for \(cell.stockWatch?.ticker)")
        print("self: \(self)")
        self.currentDetailStockWatch = cell.stockWatch
        self.currentDetailStockPositionCell = cell
        self.performSegue(withIdentifier: "showDetailModal", sender: self)
    }
}


extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockPositons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView(stuff)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockPositionCellId", for: indexPath) as! StockPositionCell
        let stockPosition = stockPositons[indexPath.row]
        
        cell.quoteLabel.text = String(stockPosition.quote)
        cell.tickerLabel.text = stockPosition.ticker
        cell.stockWatch = stockPosition
        cell.delegate = self
        
        if(stockPosition.quote >= stockPosition.cost){
            cell.upDownIcon.image = UIImage(named: "UpArrow")
        } else {
            cell.upDownIcon.image = UIImage(named: "DownArrow")
        }
        cell.gainLoss.text = "\(stockPosition.gainLoss)%"
        
        let path = stockPosition.logo
        print("path for ticker \(cell.tickerLabel.text!): \(path)")
        networkManager.getImageData(imageUrl: path, {(data: Data?, error: DMError?) ->  () in
            if let error {
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
                    let newPath = self.stockPositons[indexPath.row].altLogo
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
