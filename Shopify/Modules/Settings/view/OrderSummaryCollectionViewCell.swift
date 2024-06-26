//
//  OrderSummaryCollectionViewCell.swift
//  Shopify
//
//  Created by Slsabel Hesham on 26/06/2024.
//

import UIKit

class OrderSummaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var orderAmountView: UIView!
    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderSize: UILabel!
    @IBOutlet weak var orderColor: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
}
