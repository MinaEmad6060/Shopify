//
//  AllProductsViewController.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import UIKit
import Kingfisher

struct BrandProductViewData: Decodable{
    var id: Int64?
    var title: String?
    var body_html: String?
    var product_type: String?
    var price: String?
    var src: String?
    var name: String?
    var values: [String]?
}

class AllProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var productsBrandName: UILabel!
    @IBOutlet weak var productBrandImage: UIImageView!
    @IBOutlet weak var allProductsCollectionView: UICollectionView!

    var allProductsViewModel: AllProductsViewModelProtocol!
    var brandProducts: [BrandProductViewData]?
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brandProducts = [BrandProductViewData]()
        
        allProductsViewModel.getBrandProductsFromNetworkService()
        allProductsViewModel.bindBrandProductsToViewController = {
            self.brandProducts = self.allProductsViewModel.brandProductsViewData
            DispatchQueue.main.async {
                self.allProductsCollectionView.reloadData()
            }
        }
        
        if let brandImageURL = URL(string: allProductsViewModel.brandImage ?? "") {
            productBrandImage.kf.setImage(with: brandImageURL, placeholder: UIImage(named: "placeholderlogo.jpeg"))
        } else {
            productBrandImage.image = UIImage(named: "placeholderlogo.jpeg")
        }
        
        productsBrandName.text = allProductsViewModel.brandName
        
        allProductsCollectionView.delegate = self
        allProductsCollectionView.dataSource = self
        
        let nibCustomCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        allProductsCollectionView.register(nibCustomCell, forCellWithReuseIdentifier: "productCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryItemPrice.text = brandProducts?[indexPath.row].price
        
        let productName = brandProducts?[indexPath.row].title
        cell.categoryItemName.text = productName?.components(separatedBy: " | ")[1]
        
        if let brandProductURLString = brandProducts?[indexPath.row].src, let brandProductURL = URL(string: brandProductURLString) {
            cell.categoryItemImage.kf.setImage(with: brandProductURL, placeholder: UIImage(named: "placeholderlogo.jpeg"))
        } else {
            cell.categoryItemImage.image = UIImage(named: "placeholderlogo.jpeg")
        }
        
                
        return cell
    }
    
    //navigate to productInfoViewController
    //ProductInfoVC
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            guard let product = brandProducts[indexPath.row] else { return }
//
//            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//            guard let productInfoVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoVC") as? ProductInfoViewController else {
//                print("Could not instantiate view controller with identifier 'ProductInfoVC'")
//                return
//            }
//
//            let productInfoViewModel = ProdutInfoViewModel(product: product)
//            productInfoVC.productInfoViewModel = productInfoViewModel
//
//            productInfoVC.modalPresentationStyle = .fullScreen
//            present(productInfoVC, animated: true, completion: nil)
//        }
}
