//
//  CategoryCollectionViewCell.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit
import Kingfisher
class CategoryCollectionViewCell: UICollectionViewCell {

    var favButtonTapped: (() -> Void)?
    @IBOutlet weak var categoryItemImage: UIImageView!
    
    @IBOutlet weak var categoryItemName: UILabel!
    
    @IBOutlet weak var btnFavCategoryItem: UIButton!
    
    @IBOutlet weak var categoryItemPrice: UILabel!
    
    @IBOutlet weak var categoryItemCurrency: UILabel!
    
    @IBAction func btnFavCategoryItemTapped(_ sender: UIButton) {
        favButtonTapped?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.categoryItemImage.layer.cornerRadius = 15
        self.categoryItemImage.clipsToBounds = true
        
        self.btnFavCategoryItem.layer.cornerRadius = 10
        self.btnFavCategoryItem.clipsToBounds = true
    }
   
}
