//
//  TickerSearchResultCellTableViewCell.swift
//  Portfolio Tracker
//
//  Created by Amit Patel on 9/3/24.
//

import UIKit

class TickerSearchResultCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stockImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    
    var stockSearchResult : StockSearchResult?
    
    weak var delegate: TickerSearchResultCellDelegate?
    
    @IBAction func tickerSearchButtonClicked(_ sender: UIButton) {
        print("button clicked for search result")
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

protocol TickerSearchResultCellDelegate: AnyObject {
    func didTapButtonInCell(_ cell: TickerSearchResultCellTableViewCell)
}
