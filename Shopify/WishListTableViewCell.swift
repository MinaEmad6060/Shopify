//
//  WishListTableViewCell.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var wishItemImage: UIImageView!
    
    @IBOutlet weak var wishItemName: UILabel!
    
    @IBOutlet weak var wishItemBrand: UILabel!
    
    @IBOutlet weak var wishItemColor: UILabel!
    
    @IBOutlet weak var wishItemSize: UILabel!
    
    @IBOutlet weak var wishItemPrice: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.wishItemImage.layer.cornerRadius = 25
        self.wishItemImage.clipsToBounds = true
        
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
