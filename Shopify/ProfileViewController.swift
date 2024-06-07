//
//  ProfileViewController.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ordersTableView: UITableView!
    
    @IBOutlet weak var seeMoreOrdersOutlit: UIButton!
    
    @IBOutlet weak var noOrders: UILabel!
    
    
    @IBOutlet weak var wishListTableView: UITableView!
    
    @IBOutlet weak var seeMoreWishListOutlit: UIButton!
    
    @IBOutlet weak var noWishList: UILabel!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
    
        wishListTableView.delegate = self
        wishListTableView.dataSource = self
        
        let nibCustomCell = UINib(nibName: "OrdersTableViewCell", bundle: nil)
            self.ordersTableView.register(nibCustomCell, forCellReuseIdentifier: "orderCell")
        
        let nibCustomCell2 = UINib(nibName: "WishListTableViewCell", bundle: nil)
            self.wishListTableView.register(nibCustomCell2, forCellReuseIdentifier: "wishListCell")
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGSize(width: 75, height: 130)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: 75, height: 130) // Set your desired width and height
//        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ordersTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)
//                cell.textLabel?.text = "Order \(indexPath.row)"
                return cell
            } else if tableView == wishListTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath)
                cell.textLabel?.text = "wishList \(indexPath.row)"
                return cell
            } else {
                return UITableViewCell()
            }
    }

}
