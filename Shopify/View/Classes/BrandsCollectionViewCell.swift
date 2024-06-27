//
//  BrandsCollectionViewCell.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit

class BrandsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandImage: UIImageView!
    
    
    @IBOutlet weak var brandName: UILabel!
    
    
    @IBOutlet weak var bgView: UILabel!
    
    @IBOutlet weak var imageBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.brandImage.layer.cornerRadius = 25
        self.brandImage.clipsToBounds = true
        
        self.bgView.layer.cornerRadius = 25
        self.bgView.clipsToBounds = true
        
        self.imageBgView.layer.cornerRadius = 25
        self.imageBgView.clipsToBounds = true
    }
}
