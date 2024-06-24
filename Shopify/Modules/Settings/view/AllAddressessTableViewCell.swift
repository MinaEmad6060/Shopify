//
//  AllAddressessTableViewCell.swift
//  Shopify
//
//  Created by Slsabel Hesham on 12/06/2024.
//

import UIKit

class AllAddressessTableViewCell: UITableViewCell {

    @IBAction func defaultAddressBtn(_ sender: Any) {
        setDefault?()
    }
    @IBOutlet weak var defaultBtn: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var setDefault: (() -> Void)?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
