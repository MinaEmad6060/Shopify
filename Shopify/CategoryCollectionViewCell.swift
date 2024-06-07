//
//  CategoryCollectionViewCell.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var categoryItemImage: UIImageView!
    
    
    @IBOutlet weak var btnFavCategoryItem: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.categoryItemImage.layer.cornerRadius = 25
        self.categoryItemImage.clipsToBounds = true
        
        self.btnFavCategoryItem.layer.cornerRadius = 10
        self.btnFavCategoryItem.clipsToBounds = true
    }

}
