//
//  ColorsCollectionViewCell.swift
//  Shopify
//
//  Created by maha on 14/06/2024.
//

import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorLB: UILabel!
    override func awakeFromNib() {
           super.awakeFromNib()
           setupCell()
       }
       
       private func setupCell() {
           // Customize the appearance
           contentView.layer.cornerRadius = 8
           contentView.layer.borderWidth = 2
           contentView.layer.borderColor = UIColor.black.cgColor
           contentView.layer.masksToBounds = true
       }
}
