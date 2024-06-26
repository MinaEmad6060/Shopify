//
//  SearchViewController.swift
//  Shopify
//
//  Created by maha on 18/06/2024.
//

import UIKit
import Kingfisher
class SearchViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
  
    var allProductsViewModel: AllProductsViewModel!

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)

    }
    @IBOutlet weak var searchTableView: UITableView!
    var viewModel = SearchViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allProductsViewModel = AllProductsViewModel()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        viewModel.getAllProduct()
        viewModel.bindFilteredProductsToViewController = {
            DispatchQueue.main.async {
                print("DispatchQueue VC :: \(self.viewModel.filteredProducts.count)")
                self.searchTableView.reloadData()
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView VC :: \(viewModel.filteredProducts.count)")
        if Constants.isAllProductsScreen ?? true {
            return viewModel.filteredProducts.count
        }else{
            return Constants.categoryFilteredItems?.count ?? 0
        }
    }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            /*
            if Constants.isAllProductsScreen ?? true {
                
                let product = viewModel.filteredProducts[indexPath.row]
                
                if let imageView = cell.contentView.viewWithTag(0) as? UIImageView {
                    if let firstImage = product.images?.first, let imageUrl = URL(string: firstImage.src ?? "") {
                        imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "wish"))
                    }
                }
                
                if let label = cell.contentView.viewWithTag(1) as? UILabel {
                    label.text = product.title
                }*/
            if Constants.isAllProductsScreen ?? true {

                if viewModel.filteredProducts.count > indexPath.row {
                    let product = viewModel.filteredProducts[indexPath.row]
                    
                    if let imageView = cell.contentView.viewWithTag(2) as? UIImageView {
                        if let firstImage = product.images?[0].src, let imageUrl = URL(string: firstImage) {
                            imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "wish"))
                        }
                    }
                    if let label = cell.contentView.viewWithTag(1) as? UILabel {
                        label.text = product.title?.components(separatedBy: " | ")[1]
                    }
                    if Constants.isAllProductsScreen ?? true {
                        
                        let product = viewModel.filteredProducts[indexPath.row]
                        
                        if let imageView = cell.contentView.viewWithTag(0) as? UIImageView {
                            if let firstImage = product.images?.first, let imageUrl = URL(string: firstImage.src ?? "") {
                                imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "wish"))
                            }
                        }
                        
                        if let label = cell.contentView.viewWithTag(1) as? UILabel {
                            label.text = product.title
                        }
                        
                    }
                }
            }else{
                if Constants.categoryFilteredItems?.count ?? 0 > indexPath.row {
                    
                    let product = Constants.categoryFilteredItems?[indexPath.row]
                    
                    if let imageView = cell.contentView.viewWithTag(2) as? UIImageView {
                        if let firstImage = product?.src.first, let imageUrl = URL(string: firstImage) {
                            imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "wish"))
                        }
                    }
                    
                    if let label = cell.contentView.viewWithTag(1) as? UILabel {
                        label.text = product?.title
                    }
                }
            }
                

           return cell
        }
    
    
    /**
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                 if Constants.isAllProductsScreen ?? true {
                     
                     let product = viewModel.filteredProducts[indexPath.row]
                     
                     if let imageView = cell.contentView.viewWithTag(0) as? UIImageView {
                         if let firstImage = product.images?.first, let imageUrl = URL(string: firstImage.src ?? "") {
                             imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "wish"))
                         }
                     }
                     
                     if let label = cell.contentView.viewWithTag(1) as? UILabel {
                         label.text = product.title
                     }
                 }else{
                     let product = Constants.categoryFilteredItems?[indexPath.row]
                     
                     if let imageView = cell.contentView.viewWithTag(0) as? UIImageView {
                         if let firstImage = product?.src.first, let imageUrl = URL(string: firstImage) {
                             imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "wish"))
                         }
                     }
                     
                     if let label = cell.contentView.viewWithTag(1) as? UILabel {
                         label.text = product?.title
                     }
                 }

                return cell
             }
         
     */
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if Constants.isAllProductsScreen ?? true {
//            let lineItem = viewModel.filteredProducts[indexPath.item]
//            var product = BrandProductViewData()
//            let productId = lineItem.id
//            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//            let productInfoVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoVCR") as! ProductInfoViewController
//            
//            allProductsViewModel.getProductFromNetworkService(id: productId)
//            allProductsViewModel.bindBrandProductsToViewController = {
//                product = self.allProductsViewModel.productViewData
//                let productInfoViewModel = ProdutInfoViewModel(product: product)
//                productInfoVC.productInfoViewModel = productInfoViewModel
//                DispatchQueue.main.async {
//                    productInfoVC.modalPresentationStyle = .fullScreen
//                    self.present(productInfoVC, animated: true, completion: nil)
//                }
//            }
//        }else{
//            let lineItem = Constants.categoryFilteredItems?[indexPath.item]
//            var product = BrandProductViewData()
//            let productId = lineItem?.id
//            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//            let productInfoVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoVCR") as! ProductInfoViewController
//            
//            allProductsViewModel.getProductFromNetworkService(id: productId)
//            allProductsViewModel.bindBrandProductsToViewController = {
//                product = self.allProductsViewModel.productViewData
//                let productInfoViewModel = ProdutInfoViewModel(product: product)
//                productInfoVC.productInfoViewModel = productInfoViewModel
//                DispatchQueue.main.async {
//                    productInfoVC.modalPresentationStyle = .fullScreen
//                    self.present(productInfoVC, animated: true, completion: nil)
//                }
//            }
//        }
    }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel.searchProducts(for: searchText)
            searchTableView.reloadData()
        }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
