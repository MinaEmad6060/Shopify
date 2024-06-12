//
//  AllProductsViewController.swift
//  Shopify
//
//  Created by Mina Emad on 07/06/2024.
//

import UIKit
import Kingfisher


class AllProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    
    @IBOutlet weak var productsBrandName: UILabel!
    
    @IBOutlet weak var productBrandImage: UIImageView!
    
    @IBOutlet weak var allProductsCollectionView: UICollectionView!
    
    var fetchDataFromApi: FetchDataFromApi!
    var brandProducts: BrandProduct!
    var query = ""
    var queryValue = ""
    var brandImage = ""
    var brandName = ""
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDataFromApi = FetchDataFromApi()
        brandProducts = BrandProduct()
        
//        print("URL : \(fetchDataFromApi.formatUrl(request: "products", query: query, value: queryValue))")
        
        fetchDataFromApi.getSportData(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "products", query: query, value: queryValue)){[weak self] (brandProducts: BrandProduct) in
            self?.brandProducts = brandProducts
            self?.allProductsCollectionView.reloadData()
        }
        
        if let brandImageURL = URL(string: brandImage) {
            productBrandImage.kf.setImage(with: brandImageURL, placeholder: UIImage(named: "placeholderlogo.jpeg"))
        } else {
            productBrandImage.image = UIImage(named: "placeholderlogo.jpeg")
        }
        
        productsBrandName.text = brandName
        
        allProductsCollectionView.delegate = self
        allProductsCollectionView.dataSource = self
        
        let nibCustomCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        allProductsCollectionView.register(nibCustomCell, forCellWithReuseIdentifier: "productCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandProducts.products?.count ?? 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryItemPrice.text = brandProducts.products?[indexPath.row].variants?[0].price
        
        if let brandProductURLString = brandProducts.products?[indexPath.row].images?[0].src, let brandProductURL = URL(string: brandProductURLString) {
            cell.categoryItemImage.kf.setImage(with: brandProductURL, placeholder: UIImage(named: "placeholderlogo.jpeg"))
        } else {
            cell.categoryItemImage.image = UIImage(named: "placeholderlogo.jpeg")
        }
        
                
        return cell
    }
    
}
