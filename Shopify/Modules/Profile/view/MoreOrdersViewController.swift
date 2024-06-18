//
//  MoreOrdersViewController.swift
//  Shopify
//
//  Created by Mina Emad on 11/06/2024.
//

import UIKit

class MoreOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var moreOrdersTable: UITableView!
    
    var profileViewModel: ProfileViewModelProtocol!
    var complectedOrders: [OrderViewData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreOrdersTable.delegate = self
        moreOrdersTable.dataSource = self
        
        profileViewModel = ProfileViewModel()
        complectedOrders = [OrderViewData]()
        
        fetchProductsFromApi()

        self.moreOrdersTable.reloadData()
        
        let nibCustomCell = UINib(nibName: "OrdersTableViewCell", bundle: nil)
        moreOrdersTable.register(nibCustomCell, forCellReuseIdentifier: "moreOrdersCell")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ordersConut = complectedOrders{
            if ordersConut.count > 0{
                return complectedOrders.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "moreOrdersCell", for: indexPath) as! OrdersTableViewCell
        if complectedOrders?.count ?? 0 > indexPath.row{
                    cell.totalPrice.text = complectedOrders?[indexPath.row].amount
                
                let dateTimeComponents = complectedOrders?[indexPath.row].created_at?.components(separatedBy: "T")

                if dateTimeComponents?.count == 2 {
                    cell.creationDate.text = dateTimeComponents?[0]
                }
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let orderDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsViewController else {
            return
        }
                   
        orderDetailsViewController.orderId = self.complectedOrders?[indexPath.row].id
       orderDetailsViewController.modalPresentationStyle = .fullScreen
        present(orderDetailsViewController, animated: true )
    }
    
    
    func fetchProductsFromApi(){
        profileViewModel.getOrdersFromNetworkService()
        profileViewModel.bindOrdersToViewController = {
            self.complectedOrders = self.profileViewModel.ordersViewData
            Constants.orders = self.profileViewModel.ordersViewData
            DispatchQueue.main.async {
                self.moreOrdersTable.reloadData()
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
