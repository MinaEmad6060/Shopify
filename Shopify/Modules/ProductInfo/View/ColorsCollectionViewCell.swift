//
//  ColorsCollectionViewCell.swift
//  Shopify
//
//  Created by maha on 14/06/2024.
//

import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorLB: UILabel!
    override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.cornerRadius = self.frame.size.width / 2
            self.layer.masksToBounds = true
        }
    
}
