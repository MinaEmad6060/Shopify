//
//  ProfileViewController.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var noOrders: UILabel!
    @IBOutlet weak var wishListTableView: UITableView!
    @IBOutlet weak var noWishList: UILabel!
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var wishListTitle: UILabel!
    @IBOutlet weak var welcomeUserTitle: UILabel!
    
    var profileViewModel: ProfileViewModelProtocol!
    var complectedOrders: [OrderViewData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
    
        wishListTableView.delegate = self
        wishListTableView.dataSource = self
        
        noOrders.isHidden = true
        noWishList.isHidden = true
        
        profileViewModel = ProfileViewModel()
        complectedOrders = [OrderViewData]()
        
        fetchProductsFromApi()

        self.orderTitle.layer.cornerRadius = 10
        self.orderTitle.clipsToBounds = true
        
        self.wishListTitle.layer.cornerRadius = 10
        self.wishListTitle.clipsToBounds = true
        
        self.welcomeUserTitle.layer.cornerRadius = 20
        self.welcomeUserTitle.clipsToBounds = true
        
        let nibCustomCell = UINib(nibName: "OrdersTableViewCell", bundle: nil)
            ordersTableView.register(nibCustomCell, forCellReuseIdentifier: "orderCell")
        
        let nibCustomCell2 = UINib(nibName: "WishListTableViewCell", bundle: nil)
            wishListTableView.register(nibCustomCell2, forCellReuseIdentifier: "wishListCell")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ordersTableView{
            return 2
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ordersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersTableViewCell
            if complectedOrders?.count ?? 0 > indexPath.row{
                        cell.totalPrice.text = complectedOrders?[indexPath.row].amount
                    
                    let dateTimeComponents = complectedOrders?[indexPath.row].created_at?.components(separatedBy: "T")

                    if dateTimeComponents?.count == 2 {
                        cell.creationDate.text = dateTimeComponents?[0]
                    }
                }
                return cell
            } else if tableView == wishListTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath)
                return cell
            } else {
                return UITableViewCell()
            }
    }
    
    func fetchProductsFromApi(){
        profileViewModel.getOrdersFromNetworkService()
        profileViewModel.bindOrdersToViewController = {
            self.complectedOrders = self.profileViewModel.ordersViewData
//            Constants.orders = self.profileViewModel.ordersViewData
            DispatchQueue.main.async {
                self.ordersTableView.reloadData()
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         guard let orderDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsViewController else {
             return
         }
                    
//         orderDetailsViewController.orderId = self.complectedOrders?[indexPath.row].id
        if self.complectedOrders.count > indexPath.row{
            Constants.orderId = self.complectedOrders?[indexPath.row].id
        }
        orderDetailsViewController.modalPresentationStyle = .fullScreen
         present(orderDetailsViewController, animated: true )
    }
}
