//
//  ShoppingCartViewCell.swift
//  Shopify
//
//  Created by Slsabel Hesham on 04/06/2024.
//

import UIKit

class ShoppingCartViewCell: UITableViewCell {

    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var decrement: UIButton!
    @IBOutlet weak var increment: UIButton!
    @IBOutlet weak var cartPrice: UILabel!
    @IBOutlet weak var cartItem: UILabel!
    @IBOutlet weak var cartImge: UIImageView!
    
    var incrementAction: (() -> Void)?
    var decrementAction: (() -> Void)?

    @IBAction func incrementButtonTapped(_ sender: UIButton) {
        incrementAction?()
    }
        
    @IBAction func decrementButtonTapped(_ sender: UIButton) {
        decrementAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var amountView: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
