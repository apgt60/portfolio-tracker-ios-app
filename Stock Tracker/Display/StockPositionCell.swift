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
    
    var stockWatch : StockWatch?
    weak var delegate: StockPositionCellDelegate?
    
    @IBAction func stockButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        print("button for ticker \(tickerLabel.text) pressed")
        delegate?.didTapButtonInCell(self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

protocol StockPositionCellDelegate: class {
    func didTapButtonInCell(_ cell: StockPositionCell)
}
