//
//  ProductOfOrderViewCell.swift
//  Shopify
//
//  Created by Mina Emad on 14/06/2024.
//

import UIKit

class ProductOfOrderViewCell: UITableViewCell {

    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var priceCurrency: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
