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
    
    
    
    var fetchDataFromApi: FetchDataFromApi!
    var complectedOrders: ComplectedOrder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
    
        wishListTableView.delegate = self
        wishListTableView.dataSource = self
        
        noOrders.isHidden = true
        noWishList.isHidden = true
        
        fetchDataFromApi = FetchDataFromApi()
        complectedOrders = ComplectedOrder()
        
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
            if complectedOrders.orders?.count ?? 0 > indexPath.row{
                if let item = complectedOrders.orders?[indexPath.row].line_items{
                        cell.totalPrice.text = item[0].price_set?.shop_money?.amount
                    
                    let dateTimeComponents = complectedOrders.orders?[indexPath.row].customer?.created_at?.components(separatedBy: "T")

                    if dateTimeComponents?.count == 2 {
                        cell.creationDate.text = dateTimeComponents?[0]
                    }
                    
                                            
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
    
    //status=any&customer_id=7435246534827
    func fetchProductsFromApi(){
        print("URL ::: \(fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "orders", query: "customer_id", value: "7435246534827"))")
        fetchDataFromApi.getSportData(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "orders", query: "customer_id", value: "7435246534827")){[weak self] (complectedOrders: ComplectedOrder) in
            self?.complectedOrders.orders = complectedOrders.orders
            Constants.orders = complectedOrders.orders
            self?.ordersTableView.reloadData()
        }
    }

}
