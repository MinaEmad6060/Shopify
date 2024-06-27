//
//  OrderDetailsViewController.swift
//  Shopify
//
//  Created by Mina Emad on 12/06/2024.
//

import UIKit


struct OrderDetailsViewData{
    var amount: String?
    var currency_code: String?
    var quantity: Int8?
    var title: String?
}

struct BasicDetailsOrderViewData{
    var created_at: String?
    var orderId: UInt64?
    var first_name: String?
}

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var orderNumber: UILabel!
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    var orderDetailsViewModel: ProfileViewModelProtocol!
    var orderDetails: BasicDetailsOrderViewData?
    var productsOfOrder: [OrderDetailsViewData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsTableView.delegate = self
        productsTableView.dataSource = self
        orderDetailsViewModel = ProfileViewModel()
        productsOfOrder = [OrderDetailsViewData]()
        orderDetails = BasicDetailsOrderViewData()
        
        orderDetailsViewModel.getOrderDetailsFromNetworkService()
        orderDetailsViewModel.bindOrderDetailsToViewController = {
            self.orderDetails = self.orderDetailsViewModel.basicOrderDetailsViewData
            self.productsOfOrder = self.orderDetailsViewModel.orderDetailsViewData
            
            DispatchQueue.main.async {
                let dateTimeComponents = self.orderDetails?.created_at?.components(separatedBy: "T")
                if dateTimeComponents?.count == 2 {
                    self.createdDate.text = dateTimeComponents?[0]
                }
                self.customerName.text = self.orderDetails?.first_name
                self.orderNumber.text = "\(self.orderDetails?.orderId ?? 0)"
                self.productsTableView.reloadData()
            }
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
        
        
//        cell.productPrice.text = self.productsOfOrder?[indexPath.row].amount
//        cell.priceCurrency.text = self.productsOfOrder?[indexPath.row].currency_code
        
        let priceString = self.productsOfOrder?[indexPath.row].amount ?? "0"
        print("Currency String :: \(self.productsOfOrder?[indexPath.row].amount  ?? "0")")
        let priceInt = Double(priceString) ?? 0
        print("Currency Int :: \(priceInt)")


        let convertedPrice = priceInt / (Double(Utilites.getCurrencyRate()) ?? 1)
        let formattedPrice = String(format: "%.1f", convertedPrice)

        cell.productPrice.text = "\(formattedPrice)"
        cell.priceCurrency.text = Utilites.getCurrencyCode()
        
        cell.productQuantity.text = "\(self.productsOfOrder?[indexPath.row].quantity ?? 0)"
        
        return cell
    }
    
    

    
}
