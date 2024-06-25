//
//  CategoriesViewController.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit


struct CategoriesProductViewData{
    var id: Int64?
    var title: String?
    var body_html: String?
    var product_type: String?
    var price: String?
    var src: [String] = []
    var name: String?
    var values: [String] = []
}


class CategoriesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var categoryTable: UICollectionView!
    @IBOutlet weak var selectCategory: UISegmentedControl!
    @IBOutlet weak var selectSubCategory: UISegmentedControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var noDataImage: UIImageView!
    
    var categoriesViewModel: CategoriesViewModelProtocol!
    var brandProducts: [BrandProductViewData]!
    var filterdBrandProducts: [BrandProductViewData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        noDataImage.isHidden = true
        
        
        categoriesViewModel = CategoriesViewModel()
        Constants.setSelectedCategory(category: getSelectedCategoryValue(sender: selectCategory))
   
        
        let nibCustomCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        self.categoryCollectionView.register(nibCustomCell, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Constants.isAllProductsScreen = false
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
            cell.categoryItemPrice.text = filterdBrandProducts[indexPath.row].price
            
            let productName = filterdBrandProducts[indexPath.row].title
            cell.categoryItemName.text = productName?.components(separatedBy: " | ")[1]
            
            if let brandProductURL = URL(string: filterdBrandProducts[indexPath.row].src[0]) {
                cell.categoryItemImage.kf.setImage(with: brandProductURL, placeholder: UIImage(named: "placeholderlogo.jpeg"))
            } else {
                cell.categoryItemImage.image = UIImage(named: "placeholderlogo.jpeg")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = filterdBrandProducts?[indexPath.row] else { return }

            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            guard let productInfoVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoVCR") as? ProductInfoViewController else {
                print("Could not instantiate view controller with identifier 'ProductInfoVC'")
                return
            }

            let productInfoViewModel = ProdutInfoViewModel(product: product)
        print("Product :::::::: \(product.id ?? -1)")
            productInfoVC.productInfoViewModel = productInfoViewModel

            productInfoVC.modalPresentationStyle = .fullScreen
            present(productInfoVC, animated: true, completion: nil)
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
        categoriesViewModel.getCategoriesFromNetworkService()
        categoriesViewModel.bindCategoriesToViewController = {
            self.brandProducts = self.categoriesViewModel.categoriesViewData
            DispatchQueue.main.async {
                self.setSubCategory()
            }
        }
    }
    
    func setSubCategory(){
        let subCategory = self.getSelectedCategoryValue(sender: self.selectSubCategory ?? UISegmentedControl())
        if let allProdudts = self.brandProducts{
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
            Constants.categoryFilteredItems = self.filterdBrandProducts
            self.categoryCollectionView.reloadData()
        }
    }
}
