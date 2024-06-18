//
//  AdsCollectionViewCell.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var discountCodeLabel: UILabel!
    @IBOutlet weak var adImage: UIImageView!
    
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.adImage.layer.cornerRadius = 25
        //self.adImage.clipsToBounds = true
    }

}
