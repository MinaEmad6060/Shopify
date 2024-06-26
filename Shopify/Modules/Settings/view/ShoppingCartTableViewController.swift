//
//  ShoppingCartTableViewController.swift
//  Shopify
//
//  Created by Slsabel Hesham on 14/06/2024.
//

import UIKit

class ShoppingCartTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var noCart: UIImageView!
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var subTotalPriceView: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var lineItems: [LineItemm] = []
    var myLine: [LineItemm] = []
    var items: [LineItemm] = []

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
        if let totalPriceText = self.totalPrice.text {
            let components = totalPriceText.split(separator: " ")
            if let firstPart = components.first, firstPart == "0.0" {
                Utilites.displayToast(message: "Please add items to your cart", seconds: 2.0, controller: self)
                return
            }
        }
        
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let placeOrderVC = storyboard.instantiateViewController(withIdentifier: "PlaceOrderVC") as? PlaceOrderViewController {
            placeOrderVC.lineItems = self.lineItems
            placeOrderVC.subTotal = self.subTotal
            placeOrderVC.modalPresentationStyle = .fullScreen
            self.present(placeOrderVC, animated: true, completion: nil)
        }
    }
    
    
    func fetchDraftOrderItems() {

        let draftOrderId = Utilites.getDraftOrderIDCartFromNote()

        
        fetchDataFromApi.getDataFromApi(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl,request: "draft_orders/\(draftOrderId)")){[weak self] (draftOrderResponsee:DraftOrderResponsee?) in
            if let draftOrder = draftOrderResponsee {
                guard let self = self else { return }
                
                self.lineItems = draftOrder.draft_order.lineItems
                print(draftOrder.draft_order.lineItems)
                if self.lineItems.count == 1{
                    self.noCart.isHidden = false
                }
                else{
                    self.noCart.isHidden = true
                    
                    
                    var itemDictionary: [String: LineItemm] = [:]
                    
                    for item in lineItems {
                        let propertiesString = item.properties?.map { "\($0.name)=\($0.value)" }.joined(separator: "&") ?? ""
                        let key = "\(item.title)-\(item.price)-\(String(describing: item.variant_id))-\(String(describing: item.variant_title))-\(propertiesString)"
                        
                        if var existingItem = itemDictionary[key] {
                            existingItem.quantity += item.quantity
                            itemDictionary[key] = existingItem
                        } else {
                            itemDictionary[key] = item
                        }
                    }
                    
                    let combinedLineItems = Array(itemDictionary.values)
                    
                    print("********************************")
                    for item in combinedLineItems {
                        print("Title: \(item.title), Quantity: \(item.quantity), Price: \(item.price), Variant: \(String(describing: item.variant_title)), Properties: \(String(describing: item.properties))")
                    }
                    self.lineItems = combinedLineItems
                    myLine = lineItems
                    lineItems = lineItems.filter { $0.title != "Sample Product"}
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.subTotal = self.calculateTotal(lineItems: self.lineItems)
                        self.totalPrice.text = "\(self.subTotal) EGP"
                    }
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
        
        let productId = lineItems[index].product_id ?? 0
        fetchDataFromApi?.getDataFromApi(url: fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl, request: "products/\(productId)") ?? "") { [weak self] (availableQuantity: ProductResponse?) in
            guard let self = self else { return }
            
            if let availableQuantity = availableQuantity?.product.variants?.first?.inventory_quantity {
                if increment && self.lineItems[index].quantity ?? 0 < availableQuantity {
                    self.lineItems[index].quantity += 1
                    self.myLine[index + 1].quantity += 1
                    
                } else if !increment && self.lineItems[index].quantity ?? 0 > 1 {
                    self.lineItems[index].quantity -= 1
                    self.myLine[index + 1].quantity -= 1
                    
                } else if !increment && self.lineItems[index].quantity ?? 0 == 1 {
                    self.confirmDeleteItem(at: index)
                    return
                } else {
                    print("Requested quantity not available or minimum quantity is 1")
                }
                
                NetworkManager.updateDraftOrder(draftOrderId: Utilites.getDraftOrderIDCartFromNote(), lineItems: self.myLine) { success in
                    
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            if self.myLine.count == 1 {
                                self.noCart.isHidden = false
                            } else {
                                self.noCart.isHidden = true
                            }
                            self.subTotal = self.calculateTotal(lineItems: self.lineItems)
                            self.totalPrice.text = "\(self.subTotal) EGP"
                        }
                    } else {
                        print("error")
                    }
                }
            }
        }
    }

    func confirmDeleteItem(at index: Int) {
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let lineItem = self.lineItems[index]
            
            self.lineItems.remove(at: index)
            self.myLine.remove(at: index + 1)
            let updatedLineItems = self.myLine
            
            NetworkManager.updateDraftOrder(draftOrderId: Utilites.getDraftOrderIDCartFromNote(), lineItems: updatedLineItems) { success in
                if success {
                    print(self.lineItems.count)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.subTotal = self.calculateTotal(lineItems: self.lineItems)
                        self.totalPrice.text = "\(self.subTotal) EGP"
                    }
                } else {
                    print("Error updating draft order")
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                let lineItem = self.lineItems[indexPath.row]
                
                self.lineItems.remove(at: indexPath.row)
                self.myLine.remove(at: indexPath.row + 1)
                let updatedLineItems = self.myLine
                
                NetworkManager.updateDraftOrder(draftOrderId: Utilites.getDraftOrderIDCartFromNote(), lineItems: updatedLineItems) { success in
                    if success {
                        print(self.lineItems.count)
                        DispatchQueue.main.async {
                            tableView.reloadData()
                            self.subTotal = self.calculateTotal(lineItems: self.lineItems)
                            self.totalPrice.text = "\(self.subTotal) EGP"
                        }
                    } else {
                        print("Error updating draft order")
                    }
                }
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
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
