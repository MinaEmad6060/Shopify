//
//  ShoppingCartTableViewController.swift
//  Shopify
//
//  Created by Slsabel Hesham on 14/06/2024.
//

import UIKit

class ShoppingCartTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var subTotalPriceView: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var lineItems: [LineItemm] = []
    var subTotal = 0.0
    
    var fetchDataFromApi: FetchDataFromApi!
    var allProductsViewModel: AllProductsViewModel!

    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ShoppingCartViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "CartCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataFromApi = FetchDataFromApi()
        allProductsViewModel = AllProductsViewModel()

        self.subTotalPriceView.layer.cornerRadius = 20.0
        self.checkoutView.layer.cornerRadius = 20.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkoutTapped))
        self.checkoutView.addGestureRecognizer(tapGesture)
        fetchDraftOrderItems()
    }
    @objc func checkoutTapped() {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let paymentOptionsVC = storyboard.instantiateViewController(withIdentifier: "PaymentOptionsVC") as? PaymentOptionsViewController {
            paymentOptionsVC.lineItems = self.lineItems
            paymentOptionsVC.subTotal = self.subTotal
            paymentOptionsVC.modalPresentationStyle = .fullScreen
            self.present(paymentOptionsVC, animated: true, completion: nil)
        }
    }
    
    
    func fetchDraftOrderItems() {

        let draftOrderId = Utilites.getDraftOrderIDCartFromNote()
        
        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl,request: "draft_orders/\(draftOrderId)")){[weak self] (draftOrderResponsee:DraftOrderResponsee?) in
            if let draftOrder = draftOrderResponsee {
                self?.lineItems = draftOrder.draft_order.lineItems
                print("FirstID :::: \(self?.lineItems[1].product_id ?? -1)")
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.subTotal = self?.calculateTotal(lineItems: self?.lineItems ?? [LineItemm]()) ?? 0.0
                    self?.totalPrice.text = "\(self?.subTotal ?? 0.0)EGP"
                }
            }
        }
        
        
//        NetworkManager.fetchDraftOrder(draftOrderId: draftOrderId) { [weak self] draftOrder in
//            guard let self = self else { return }
//            if let draftOrder = draftOrder {
//                self.lineItems = draftOrder.lineItems
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    self.subTotal = self.calculateTotal(lineItems: self.lineItems)
//                    self.totalPrice.text = "\(self.subTotal)EGP"
//                }
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? ShoppingCartViewCell else {
            return UITableViewCell()
        }
        
        let lineItem = lineItems[indexPath.row]
        cell.cartItem.text = lineItem.title
        cell.totalAmount.text = "\(lineItem.quantity)"
        
        if let properties = lineItem.properties, properties.count > 2, let url = URL(string: properties[2].value) {
            cell.cartImge.kf.setImage(with: url)
        } else {
            cell.cartImge.image = UIImage(named: "lineItemImage")
        }
        print("\(lineItem.quantity)testtt")
        print(lineItem.price)
        
        let quantity = lineItem.quantity
        let price = lineItem.price

        if let priceDouble = Double(price) {
            let totalPrice = Double(quantity) * priceDouble
            print("Total price for \(quantity) items: \(totalPrice)")
            cell.cartPrice.text = "\(totalPrice)"
        } else {
            print("Invalid price format")
        }
        //cell.cartPrice.text = "\(lineItem.quantity * Int(lineItem.price)! )test"
        
        cell.incrementAction = { [weak self] in
            self?.updateQuantity(for: lineItem.id ?? 0, increment: true)
            var itemPrice = lineItem.quantity * (Int(lineItem.price) ?? 0)
            
            cell.cartPrice.text = "\(itemPrice)"
        }
    
        cell.decrementAction = { [weak self] in
            self?.updateQuantity(for: lineItem.id ?? 0, increment: false)
            var itemPrice = lineItem.quantity * (Int(lineItem.price) ?? 0)
            
            cell.cartPrice.text = "\(itemPrice)"

        }
    
        cell.amountView.layer.borderWidth = 1.5
        cell.amountView.layer.borderColor = UIColor(hexString: "AE9376").cgColor
        cell.amountView.layer.cornerRadius = 15.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lineItem = lineItems[indexPath.row]
        var product = BrandProductViewData()
        let productId = lineItem.product_id
        print("productID ShoppingCartTableViewController ::: \(lineItem.product_id)")
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let productInfoVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoVCR") as! ProductInfoViewController
            
            allProductsViewModel.getProductFromNetworkService(id: productId)
            allProductsViewModel.bindBrandProductsToViewController = {
                product = self.allProductsViewModel.productViewData
                let productInfoViewModel = ProdutInfoViewModel(product: product)
                productInfoVC.productInfoViewModel = productInfoViewModel
                DispatchQueue.main.async {
                    productInfoVC.modalPresentationStyle = .fullScreen
                    self.present(productInfoVC, animated: true, completion: nil)
                }
            }
    }
    
    func updateQuantity(for lineItemId: Int, increment: Bool) {
        guard let index = lineItems.firstIndex(where: { $0.id == lineItemId }) else { return }
        
        let productId = 8100172759211
        fetchDataFromApi?.getDataFromApi(url: fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl,request: "products/\(productId)") ?? ""){[weak self] (availableQuantity: ProductResponse?) in
            if let availableQuantity = availableQuantity {
                if increment && self?.lineItems[index].quantity ?? 5 < availableQuantity.product.variants?.first?.inventory_quantity ?? 0 {
                    self?.lineItems[index].quantity += 1

                } else if !increment && self?.lineItems[index].quantity ?? 5 > 1 {
                    self?.lineItems[index].quantity -= 1

                } else {
                    print("Requested quantity not available or minimum quantity is 1")
                }

                NetworkManager.updateDraftOrder(draftOrderId: Utilites.getDraftOrderIDCartFromNote(), lineItems: self?.lineItems ?? [LineItemm]()) { success in
                    if success {
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                            self?.subTotal = self?.calculateTotal(lineItems: self?.lineItems ?? [LineItemm]()) ?? 0.0
                            self?.totalPrice.text = "\(self?.subTotal ?? 0.0)EGP"
                        }
                    } else {
                        print("error")
                    }
                }
            }
        }
        
        
        
//        NetworkManager.checkProductAvailability(productId: productId) { [weak self] availableQuantity in
//            guard let self = self else { return }
//            
//            if let availableQuantity = availableQuantity {
//                if increment && self.lineItems[index].quantity ?? 5 < availableQuantity {
//                    self.lineItems[index].quantity += 1
//                    
//                } else if !increment && self.lineItems[index].quantity ?? 5 > 1 {
//                    self.lineItems[index].quantity -= 1
//                    
//                } else {
//                    print("Requested quantity not available or minimum quantity is 1")
//                }
//                
//                NetworkManager.updateDraftOrder(draftOrderId: Utilites.getDraftOrderIDCartFromNote(), lineItems: self.lineItems) { success in
//                    if success {
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                            self.subTotal = self.calculateTotal(lineItems: self.lineItems)
//                            self.totalPrice.text = "\(self.subTotal)EGP"
//                        }
//                    } else {
//                        print("error")
//                    }
//                }
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let lineItem = lineItems[indexPath.row]
            
            
            self.lineItems.remove(at: indexPath.row)
            let updatedLineItems = lineItems
            
            print("Deleting line item with id: \(lineItem.id)")
            print("Updated line items: \(updatedLineItems)")
            
            NetworkManager.updateDraftOrder(draftOrderId: Utilites.getDraftOrderIDCartFromNote(), lineItems: updatedLineItems) { [weak self] success in
                if success {
                    print(self?.lineItems.count)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self?.subTotal = (self?.calculateTotal(lineItems: self!.lineItems))!
                        self?.totalPrice.text = "\(self?.subTotal)EGP"
                    }
                } else {
                    print("Error updating draft order")
                }
            }
        }
    }
    func calculateTotal(lineItems: [LineItemm]) -> Double {
        var total: Double = 0.0
        
        for item in lineItems {
            total += (Double(item.price) ?? 0.0) * Double(item.quantity)
        }
        
        return total
    }

}
