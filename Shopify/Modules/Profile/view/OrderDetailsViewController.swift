//
//  OrderDetailsViewController.swift
//  Shopify
//
//  Created by Mina Emad on 12/06/2024.
//

import UIKit

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    var orderId: UInt64?
//    var numberOfProducts: Int?
    var fetchDataFromApi: FetchDataFromApi!
    var productsOfOrder: [OrderProduct]?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("order id ::: \(orderId ?? 0)")
        
        productsTableView.delegate = self
        productsTableView.dataSource = self
        fetchDataFromApi = FetchDataFromApi()
        productsOfOrder = [OrderProduct]()
        print("url :: \(fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "orders/\(orderId ?? 0)"))")
        fetchDataFromApi.getSportData(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "orders/\(orderId ?? 0)")){[weak self] (orderDetails: OrderDetails) in
            let dateTimeComponents = orderDetails.order?.created_at?.components(separatedBy: "T")

            if dateTimeComponents?.count == 2 {
                self?.createdDate.text = dateTimeComponents?[0]
            }
            self?.customerName.text = orderDetails.order?.customer?.first_name
            self?.productsOfOrder = orderDetails.order?.line_items
            self?.productsTableView.reloadData()
        }
        
        let nibCustomCell = UINib(nibName: "ProductOfOrderViewCell", bundle: nil)
        productsTableView.register(nibCustomCell, forCellReuseIdentifier: "orderDetailsCell")
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count :: \(self.productsOfOrder?.count ?? 0)")
        return self.productsOfOrder?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetailsCell", for: indexPath) as! ProductOfOrderViewCell
        
        cell.productName.text = self.productsOfOrder?[indexPath.row].title
        cell.productPrice.text = self.productsOfOrder?[indexPath.row].price_set?.shop_money?.amount
        cell.priceCurrency.text = self.productsOfOrder?[indexPath.row].price_set?.shop_money?.currency_code
        cell.productQuantity.text = "\(self.productsOfOrder?[indexPath.row].quantity ?? 0)"
        
        return cell
    }
    
    

    
}
