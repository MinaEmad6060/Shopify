//
//  ProfileViewController.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var noOrders: UILabel!
    @IBOutlet weak var wishListTableView: UITableView!
    @IBOutlet weak var noWishList: UILabel!
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var wishListTitle: UILabel!
    @IBOutlet weak var welcomeUserTitle: UILabel!
    
    @IBAction func btnSettings(_ sender: UIBarButtonItem) {
        let customerId = Utilites.getCustomerID()
           if customerId == 0 {
               Utilites.displayGuestAlert(in:self, message: "Please log in to access settings.")
               return
           }
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let productInfoVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC")

        productInfoVC.modalPresentationStyle = .fullScreen
        present(productInfoVC, animated: true, completion: nil)
    }
    @IBAction func btnCart(_ sender: UIBarButtonItem) {
        let customerId = Utilites.getCustomerID()
           if customerId == 0 {
               Utilites.displayGuestAlert(in:self, message: "Please log in to access cart.")
               return
           }
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        let productInfoVC = storyboard.instantiateViewController(withIdentifier: "CartVCR")

        productInfoVC.modalPresentationStyle = .fullScreen
        present(productInfoVC, animated: true, completion: nil)
    }
    
    
    @IBAction func btnSeeMoreOrders(_ sender: UIButton) {
        let customerId = Utilites.getCustomerID()
           if customerId == 0 {
               Utilites.displayGuestAlert(in:self, message: "Please log in to access orders.")
               return
           }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productInfoVC = storyboard.instantiateViewController(withIdentifier: "AllOrdersVC")

        productInfoVC.modalPresentationStyle = .fullScreen
        present(productInfoVC, animated: true, completion: nil)
    }
    
    
    @IBAction func btnSeeMoreFav(_ sender: Any) {
        let customerId = Utilites.getCustomerID()
           if customerId == 0 {
               Utilites.displayGuestAlert(in:self, message: "Please log in to access favourites.")
               return
           }
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let productInfoVC = storyboard.instantiateViewController(withIdentifier: "FavVC")

        productInfoVC.modalPresentationStyle = .fullScreen
        present(productInfoVC, animated: true, completion: nil)
    }
    
    
    var profileViewModel: ProfileViewModelProtocol!
    var favouriteViewModel: FavoriteViewModel!
    var complectedOrders: [OrderViewData]!
    var allProductsViewModel: AllProductsViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
    
        wishListTableView.delegate = self
        wishListTableView.dataSource = self
        
        noOrders.isHidden = true
        noWishList.isHidden = true
        
        profileViewModel = ProfileViewModel()
        favouriteViewModel = FavoriteViewModel()
        complectedOrders = [OrderViewData]()
        allProductsViewModel = AllProductsViewModel()
        fetchProductsFromApi()
        
           
        self.orderTitle.layer.cornerRadius = 10
        self.orderTitle.clipsToBounds = true
        
        self.wishListTitle.layer.cornerRadius = 10
        self.wishListTitle.clipsToBounds = true
        
        self.welcomeUserTitle.layer.cornerRadius = 20
        self.welcomeUserTitle.clipsToBounds = true
        
        
        let customerId = Utilites.getCustomerID()
           if customerId == 0 {
               self.welcomeUserTitle.text = "Please Login!"
           }else {
               self.welcomeUserTitle.text = "Welcome \(Utilites.getCustomerName())"
           }
        
        let nibCustomCell = UINib(nibName: "OrdersTableViewCell", bundle: nil)
            ordersTableView.register(nibCustomCell, forCellReuseIdentifier: "orderCell")
        
        let nibCustomCell2 = UINib(nibName: "WishListTableViewCell", bundle: nil)
            wishListTableView.register(nibCustomCell2, forCellReuseIdentifier: "wishListCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchProductsFromApi()

        let favID = Utilites.getDraftOrderIDFavoriteFromNote()
        favouriteViewModel.fetchLineItems(draftOrderId: favID)
        favouriteViewModel.didUpdateLineItems = { [weak self] in
               DispatchQueue.main.async {
                   self?.wishListTableView.reloadData()
               }
           }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ordersTableView{
            if complectedOrders?.count ?? 0 > 2 {
                noOrders.isHidden = true
                ordersTableView.isHidden = false
                return 2
            }else if complectedOrders?.count ?? 0 == 0{
                noOrders.isHidden = false
                ordersTableView.isHidden = true
                return 0
            }else{
                noOrders.isHidden = true
                ordersTableView.isHidden = false
                return complectedOrders?.count ?? 0
            }
        }else{
            if favouriteViewModel.displayedLineItems.count > 4 {
                noWishList.isHidden = true
                wishListTableView.isHidden = false
                return 4
            }else if favouriteViewModel.displayedLineItems.count == 0{
                noWishList.isHidden = false
                wishListTableView.isHidden = true
                return 0
            }else{
                noWishList.isHidden = true
                wishListTableView.isHidden = false
                return favouriteViewModel.displayedLineItems.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ordersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersTableViewCell
            if complectedOrders?.count ?? 0 > indexPath.row{
//                cell.totalPrice.text = (complectedOrders?[indexPath.row].total_price ?? "") + " $ "
                let priceString = complectedOrders?[indexPath.row].total_price ?? "0"
                let priceInt = Double(priceString) ?? 0
                let convertedPrice = priceInt / (Double(Utilites.getCurrencyRate()) ?? 1)
                let formattedPrice = String(format: "%.1f", convertedPrice)

                cell.totalPrice.text = "\(formattedPrice) " + Utilites.getCurrencyCode()
                
                                    
                    let dateTimeComponents = complectedOrders?[indexPath.row].created_at?.components(separatedBy: "T")

                    if dateTimeComponents?.count == 2 {
                        cell.creationDate.text = dateTimeComponents?[0]
                    }
                }
                return cell
            } else if tableView == wishListTableView {
                print("Constants.displayedLineItems?.count \(favouriteViewModel.displayedLineItems.count)")
                let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! WishListTableViewCell
                if favouriteViewModel.displayedLineItems.count > indexPath.row{
                    let lineItem = favouriteViewModel.displayedLineItems[indexPath.row]

                    let imageString = lineItem.properties?[2].value ?? ""
                        let productName = lineItem.title
                        cell.wishItemBrand.text = productName?.components(separatedBy: " | ")[0]
                        cell.wishItemName.text = productName?.components(separatedBy: " | ")[1]
                        
//                        cell.wishItemPrice.text = (lineItem.price ?? "") + "$"
                    let priceString = lineItem.price ?? "0"
                    let priceInt = Double(priceString) ?? 0
                    let convertedPrice = priceInt / (Double(Utilites.getCurrencyRate()) ?? 1)
                    let formattedPrice = String(format: "%.1f", convertedPrice)
                    cell.wishItemPrice.text = "\(formattedPrice) " + Utilites.getCurrencyCode()
                        
                        if let url = URL(string: imageString) {
                            cell.wishItemImage.kf.setImage(with: url)
                        }
                }
                return cell
                    
            } else {
                return UITableViewCell()
            }
    }
    
    func fetchProductsFromApi(){
        profileViewModel.getOrdersFromNetworkService()
        profileViewModel.bindOrdersToViewController = {
            self.complectedOrders = self.profileViewModel.ordersViewData
            DispatchQueue.main.async {
                self.ordersTableView.reloadData()
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ordersTableView{
            guard let orderDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsViewController else {
                return
            }
            
            if self.complectedOrders.count > indexPath.row{
                Constants.orderId = self.complectedOrders?[indexPath.row].id
            }
            orderDetailsViewController.modalPresentationStyle = .fullScreen
            present(orderDetailsViewController, animated: true )
        }else{
            if favouriteViewModel.displayedLineItems.count > indexPath.row{
                let lineItem = favouriteViewModel.displayedLineItems[indexPath.item]
                var product = BrandProductViewData()
                let productId = lineItem.productID
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
        }
        
        
        
        
    }
}
