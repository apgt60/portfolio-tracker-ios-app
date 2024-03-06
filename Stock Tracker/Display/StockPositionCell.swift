//
//  StockPositionCell.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 2/29/24.
//

import UIKit

class StockPositionCell: UITableViewCell {
    
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var upDownIcon: UIImageView!
    @IBOutlet weak var gainLoss: UILabel!
    @IBOutlet weak var stockImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
