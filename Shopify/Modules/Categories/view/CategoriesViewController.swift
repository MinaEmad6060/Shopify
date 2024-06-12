//
//  CategoriesViewController.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var categoryTable: UICollectionView!
    @IBOutlet weak var selectCategory: UISegmentedControl!
    @IBOutlet weak var selectSubCategory: UISegmentedControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var fetchDataFromApi: FetchDataFromApi!
    var brandProducts: BrandProduct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        fetchDataFromApi = FetchDataFromApi()
        brandProducts = BrandProduct()
        
        getSelectedCategoryValue(sender: selectCategory)
        getSelectedCategoryValue(sender: selectSubCategory)
        
        fetchDataFromApi.getSportData(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "products", query: "collection_id", value: "304608903339")){[weak self] (brandProducts: BrandProduct) in
            self?.brandProducts = brandProducts
            self?.categoryCollectionView.reloadData()
        }
        
        let nibCustomCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        self.categoryCollectionView.register(nibCustomCell, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let products = brandProducts.products{
            return products.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        
        cell.categoryItemPrice.text = brandProducts.products?[indexPath.row].variants?[0].price
        
        let productName = brandProducts.products?[indexPath.row].title
        cell.categoryItemName.text = productName?.components(separatedBy: " | ")[1]
        
        if let brandProductURLString = brandProducts.products?[indexPath.row].images?[0].src, let brandProductURL = URL(string: brandProductURLString) {
            cell.categoryItemImage.kf.setImage(with: brandProductURL, placeholder: UIImage(named: "placeholderlogo.jpeg"))
        } else {
            cell.categoryItemImage.image = UIImage(named: "placeholderlogo.jpeg")
        }
        
        return cell
    }
 
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let selectedSegmentTitle = sender.titleForSegment(at: selectedIndex)
    }
    
    func getSelectedCategoryValue(sender: UISegmentedControl){
        sender.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControlValueChanged(sender)
    }
}
