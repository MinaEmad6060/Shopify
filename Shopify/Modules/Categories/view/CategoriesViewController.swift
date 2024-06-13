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
    @IBOutlet weak var noDataImage: UIImageView!
    
    var fetchDataFromApi: FetchDataFromApi!
    var brandProducts: BrandProduct!
    var filterdBrandProducts: [Product]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        noDataImage.isHidden = true
        
        fetchDataFromApi = FetchDataFromApi()
        brandProducts = BrandProduct()
        filterdBrandProducts = [Product]()
        
        Constants.setSelectedCategory(category: getSelectedCategoryValue(sender: selectCategory))
        fetchProductsFromApi()
        
        let nibCustomCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        self.categoryCollectionView.register(nibCustomCell, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        self.setSubCategory()

        if let products = filterdBrandProducts{
            if products.count > 0{
                noDataImage.isHidden = true
                categoryTable.isHidden = false
            }else{
                noDataImage.isHidden = false
                categoryTable.isHidden = true
            }
            return products.count
        }else{
            noDataImage.isHidden = false
            categoryTable.isHidden = true
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        
        
        if filterdBrandProducts.count > indexPath.row{
            cell.categoryItemPrice.text = filterdBrandProducts[indexPath.row].variants?[0].price
            
            let productName = filterdBrandProducts[indexPath.row].title
            cell.categoryItemName.text = productName?.components(separatedBy: " | ")[1]
            
            if let brandProductURLString = filterdBrandProducts[indexPath.row].images?[0].src, let brandProductURL = URL(string: brandProductURLString) {
                cell.categoryItemImage.kf.setImage(with: brandProductURL, placeholder: UIImage(named: "placeholderlogo.jpeg"))
            } else {
                cell.categoryItemImage.image = UIImage(named: "placeholderlogo.jpeg")
            }
        }
        
        return cell
    }
 
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl)  -> String{
        let selectedIndex = sender.selectedSegmentIndex
        let selectedSegmentTitle = sender.titleForSegment(at: selectedIndex) ?? ""
        Constants.setSelectedCategory(category: selectedSegmentTitle)

        if sender == selectCategory{
            fetchProductsFromApi()
        }else{
            self.categoryCollectionView.reloadData()
        }
        return selectedSegmentTitle
    }
    
    func getSelectedCategoryValue(sender: UISegmentedControl) -> String{
        sender.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControlValueChanged(sender)
    }
    
    func fetchProductsFromApi(){
        fetchDataFromApi.getSportData(url: fetchDataFromApi.formatUrl(baseUrl: Constants.baseUrl, request: "products", query: "collection_id", value: "\(Constants.categoryID ?? 0)")){[weak self] (brandProducts: BrandProduct) in
            self?.brandProducts = brandProducts
            self?.setSubCategory()
        }
    }
    
    func setSubCategory(){
        let subCategory = self.getSelectedCategoryValue(sender: self.selectSubCategory ?? UISegmentedControl())
        if let filteredProducts = self.filterdBrandProducts,
        let allProdudts = self.brandProducts.products{
            if(subCategory == "ALL"){
                self.filterdBrandProducts = allProdudts
            }else if(subCategory == "EXTRAS"){
                self.filterdBrandProducts = allProdudts.filter { product in
                    return product.product_type == "ACCESSORIES"
                }
            }else{
                self.filterdBrandProducts = allProdudts.filter { product in
                    return product.product_type == subCategory
                }
            }
            self.categoryCollectionView.reloadData()
        }
    }
}
