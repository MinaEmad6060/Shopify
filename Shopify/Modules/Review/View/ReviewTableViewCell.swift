//
//  ReviewTableViewCell.swift
//  Shopify
//
//  Created by maha on 22/06/2024.
//

import UIKit
import Cosmos
class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userReviewLB: UILabel!
    
    @IBOutlet weak var reviewRatingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        reviewView.layer.cornerRadius = 15
        reviewView.clipsToBounds = true
        reviewRatingView.settings.fillMode = .full
              reviewRatingView.settings.filledColor = UIColor.systemYellow
              reviewRatingView.settings.emptyBorderColor = UIColor.systemYellow
              reviewRatingView.settings.filledBorderColor = UIColor.systemYellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
           super.layoutSubviews()
           self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
       }
    
}
