//
//  OrdersTableViewCell.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
       }
    
}
