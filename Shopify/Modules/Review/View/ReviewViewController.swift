//
//  ReviewViewController.swift
//  Shopify
//
//  Created by maha on 21/06/2024.
//

import UIKit
import Cosmos
struct Review {
    var image: UIImage?
    var name: String
    var review: String
    var rating: Double
}
class ReviewViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    var reviews: [Review] = []
    @IBOutlet weak var reviewTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        // Assume Review is your model for review data
        
        
        // Load reviews data
        loadReviews()
    }
    
    func loadReviews() {
        // Populate your reviews array with data
        // Example data:
        reviews = [
            Review(image: UIImage(named: "1"), name: "Maha Farghaly", review: "Great product, and high quality, very good!", rating: 4.5),
            Review(image: UIImage(named: "2"), name: "Mina Emad", review: "Amazing experience, will definitely buy again!", rating: 5.0),
            Review(image: UIImage(named: "3"), name: "Slsabel Hesham", review: "Good value for money, satisfied with the purchase.", rating: 4.3),
            Review(image: UIImage(named: "4"), name: "Nourhan Ahmed", review: "Decent product, could be improved.", rating: 3.5),
            Review(image: UIImage(named: "5"), name: "Omar Hassan", review: "Satisfied with the quality, but shipping was slow.", rating: 3.5),
            Review(image: UIImage(named: "6"), name: "Layla Mohamed", review: "Average product, nothing special.", rating: 3.0),
            Review(image: UIImage(named: "7"), name: "Youssef Ali", review: "Not as expected, quite disappointed.", rating: 2.5),
            Review(image: UIImage(named: "8"), name: "Hana Khaled", review: "Excellent quality, highly recommend!", rating: 5.0),
            Review(image: UIImage(named: "9"), name: "Mohamed Fathy", review: "Works fine, but had some issues initially.", rating: 3.8),
            Review(image: UIImage(named: "10"), name: "Fatma Saad", review: "Not worth the price, poor quality.", rating: 2.0)
        ]
 
        reviewTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewTableViewCell
        let review = reviews[indexPath.row]
        
        cell.userImage.image = review.image
        cell.userName.text = review.name
        cell.userReviewLB.text = review.review
        cell.reviewRatingView.rating = review.rating
       
        
        return cell
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
      self.dismiss(animated: true)
     
       
    }
}

