//
//  FavoriteViewController.swift
//  Shopify
//
//  Created by maha on 18/06/2024.
//

import UIKit

class FavoriteViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    private var viewModel = FavoriteViewModel()
    var brandProducts: [BrandProductViewData]?
    var allProductsViewModel: AllProductsViewModel!
    
    @IBOutlet weak var noDataImage: UIImageView!
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var favCollectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brandProducts = [BrandProductViewData]()
        allProductsViewModel = AllProductsViewModel()
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        self.favCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        
        
//        let favID = UserDefaults.standard.integer(forKey: "favIDNet")
//        viewModel.fetchLineItems(draftOrderId: favID)
//        bindViewModel()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let favID = UserDefaults.standard.integer(forKey: "favIDNet")
        viewModel.fetchLineItems(draftOrderId: favID)
        bindViewModel()
    }
    
    
    private func bindViewModel() {
        viewModel.didUpdateLineItems = { [weak self] in
            DispatchQueue.main.async {
                self?.favCollectionView.reloadData()
                self?.updateNoDataImageVisibility()
            }
        }
    }
    private func updateNoDataImageVisibility() {
          noDataImage.isHidden = !viewModel.displayedLineItems.isEmpty
      }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  viewModel.displayedLineItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
        
        let lineItem = viewModel.displayedLineItems[indexPath.item]
        
        let imageString = lineItem.properties?[2].value ?? ""
        
        let productName = lineItem.title
        cell.categoryItemName.text = productName?.components(separatedBy: " | ")[1]
        
        //               cell.categoryItemName.text = lineItem.title
        cell.categoryItemPrice.text = lineItem.price
        cell.categoryItemCurrency.text = "$"
        
        if let url = URL(string: imageString) {
            cell.categoryItemImage.kf.setImage(with: url)
        }
        cell.btnFavCategoryItem.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        cell.favButtonTapped = { [weak self] in
            guard let self = self else { return }
            let productName = lineItem.title
            self.viewModel.lineItems.remove(at: indexPath.row+1)
            self.favCollectionView.reloadData()
            self.updateNoDataImageVisibility()
            self.viewModel.removeProductFromDraftOrder(productTitle: productName ?? "")
            
            
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lineItem = viewModel.displayedLineItems[indexPath.item]
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
