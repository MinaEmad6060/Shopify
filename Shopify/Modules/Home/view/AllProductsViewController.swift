//
//  AllProductsViewController.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import UIKit
import Kingfisher

struct BrandProductViewData: Decodable{
    var id: Int?
    var title: String?
    var body_html: String?
    var product_type: String?
    var price: String?
    var src: [String] = []
    var name: String?
    var sizes: [String] = []
    var colors: [String] = []
}

class AllProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var productsBrandName: UILabel!
    @IBOutlet weak var productBrandImage: UIImageView!
    @IBOutlet weak var allProductsCollectionView: UICollectionView!

    var allProductsViewModel: AllProductsViewModelProtocol!
    var brandProducts: [BrandProductViewData]?
    var filteredProducts: [BrandProductViewData]?
    
    @IBOutlet weak var sliderOutlet: UISlider!
    
    
    @IBAction func sliderAction(_ sender: UISlider) {
        let sliderValue = Double(sender.value)
            filteredProducts = brandProducts?.filter { product in
                if let priceString = product.price, let price = Double(priceString) {
                    print("Slider : \(price)")
                    return price <= sliderValue
                }
                return false
            }
        
        self.allProductsCollectionView.reloadData()

    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderOutlet.minimumValue = 0
        sliderOutlet.maximumValue = 200
        sliderOutlet.value = 200
        
        brandProducts = [BrandProductViewData]()
        
        allProductsViewModel.getBrandProductsFromNetworkService()
        allProductsViewModel.bindBrandProductsToViewController = {
            self.brandProducts = self.allProductsViewModel.brandProductsViewData
            DispatchQueue.main.async {
                self.filteredProducts = self.brandProducts
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
        return filteredProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryItemPrice.text = filteredProducts?[indexPath.row].price
        
        let productName = filteredProducts?[indexPath.row].title
        cell.categoryItemName.text = productName?.components(separatedBy: " | ")[1]
        
        if let brandProductURLString = filteredProducts?[indexPath.row].src[0], let brandProductURL = URL(string: brandProductURLString) {
            print("image :: \(brandProductURL)")
            cell.categoryItemImage.kf.setImage(with: brandProductURL, placeholder: UIImage(named: "placeholderlogo.jpeg"))
        } else {
            cell.categoryItemImage.image = UIImage(named: "placeholderlogo.jpeg")
        }
        
                
        return cell
    }
    
    //navigate to productInfoViewController
    //ProductInfoVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = brandProducts?[indexPath.row] else { return }

            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            guard let productInfoVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoVCR") as? ProductInfoViewController else {
                print("Could not instantiate view controller with identifier 'ProductInfoVC'")
                return
            }

            let productInfoViewModel = ProdutInfoViewModel(product: product)
            productInfoVC.productInfoViewModel = productInfoViewModel

            productInfoVC.modalPresentationStyle = .fullScreen
            present(productInfoVC, animated: true, completion: nil)
        }
}
