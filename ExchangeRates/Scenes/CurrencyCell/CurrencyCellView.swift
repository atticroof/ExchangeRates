//
//  CurrencyCellView.swift
//  ExchangeRates
//
//  Created by Vladimir on 03.06.2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import UIKit

class CurrencyCellView: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
