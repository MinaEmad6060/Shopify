//
//  SizeCollectionViewCell.swift
//  Shopify
//
//  Created by maha on 13/06/2024.
//

import UIKit

class SizeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sizeLB: UILabel!
    override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.cornerRadius = self.frame.size.width / 2
            self.layer.masksToBounds = true
        }
    
}
