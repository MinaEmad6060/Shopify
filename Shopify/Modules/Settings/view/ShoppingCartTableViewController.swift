//
//  ShoppingCartTableViewController.swift
//  Shopify
//
//  Created by Slsabel Hesham on 14/06/2024.
//

import UIKit

class ShoppingCartTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var lineItems: [LineItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchDraftOrderItems()
    }
    
    func fetchDraftOrderItems() {
        let draftOrderId = 967448690859
        NetworkManager.fetchDraftOrder(draftOrderId: draftOrderId) { [weak self] draftOrder in
            guard let self = self else { return }
            if let draftOrder = draftOrder {
                self.lineItems = draftOrder.lineItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? ShoppingCartViewCell else {
            return UITableViewCell()
        }
        
        let lineItem = lineItems[indexPath.row]
        cell.cartItem.text = lineItem.name
        cell.totalAmount.text = "\(lineItem.quantity)"
        cell.cartPrice.text = lineItem.price
        
        cell.incrementAction = { [weak self] in
            self?.updateQuantity(for: lineItem.id, increment: true)
        }
        
        cell.decrementAction = { [weak self] in
            self?.updateQuantity(for: lineItem.id, increment: false)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func updateQuantity(for lineItemId: Int, increment: Bool) {
        guard let index = lineItems.firstIndex(where: { $0.id == lineItemId }) else { return }
        
        //let productId = lineItems[index].id
        let productId = 8100172759211
        NetworkManager.checkProductAvailability(productId: productId) { [weak self] availableQuantity in
            guard let self = self else { return }
            
            if let availableQuantity = availableQuantity {
                if increment && self.lineItems[index].quantity < availableQuantity {
                    self.lineItems[index].quantity += 1
                } else if !increment && self.lineItems[index].quantity > 1 {
                    self.lineItems[index].quantity -= 1
                } else {
                    print("Requested quantity not available or minimum quantity is 1")
                }
                
                
                NetworkManager.updateDraftOrder(draftOrderId: 967448690859, lineItems: self.lineItems) { success in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        // Handle the error appropriately (e.g., show an alert to the user)
                    }
                }
            }
        }
    }
}
