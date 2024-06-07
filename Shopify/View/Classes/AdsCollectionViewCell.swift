//
//  AdsCollectionViewCell.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var adImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.adImage.layer.cornerRadius = 25
        self.adImage.clipsToBounds = true
    }

}
