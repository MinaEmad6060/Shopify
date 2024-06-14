//
//  MoreOrdersViewController.swift
//  Shopify
//
//  Created by Mina Emad on 11/06/2024.
//

import UIKit

class MoreOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var moreOrdersTable: UITableView!
    
    var orders: [Order]!
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreOrdersTable.delegate = self
        moreOrdersTable.dataSource = self
        
//        orders = [Order]()
        orders = Constants.orders

        self.moreOrdersTable.reloadData()
        
        let nibCustomCell = UINib(nibName: "OrdersTableViewCell", bundle: nil)
        moreOrdersTable.register(nibCustomCell, forCellReuseIdentifier: "moreOrdersCell")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ordersConut = orders{
            if ordersConut.count > 0{
                return orders.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreOrdersCell", for: indexPath) as! OrdersTableViewCell
        if orders?.count ?? 0 > indexPath.row{
            if let item = orders?[indexPath.row].line_items{
                    cell.totalPrice.text = item[0].price_set?.shop_money?.amount
                
                let dateTimeComponents = orders?[indexPath.row].customer?.created_at?.components(separatedBy: "T")

                if dateTimeComponents?.count == 2 {
                    cell.creationDate.text = dateTimeComponents?[0]
                }
                
                                        
                }
            }
        return cell
    }
}
