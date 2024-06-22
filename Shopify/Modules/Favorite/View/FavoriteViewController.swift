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
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var favCollectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
  
    override func viewDidLoad() {
        super.viewDidLoad()
        brandProducts = [BrandProductViewData]()
       favCollectionView.delegate = self
        favCollectionView.dataSource = self
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
               self.favCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
       
        bindViewModel()
        //967667908779
        //productInfoViewModel?.draftOrderIDFavorite ?? 0
        let favID = UserDefaults.standard.integer(forKey: "favIDNet")
        viewModel.fetchLineItems(draftOrderId: favID)
//        if let draftOrderIDFavorite = productInfoViewModel?.draftOrderIDFavorite {
//                    viewModel.fetchLineItems(draftOrderId: draftOrderIDFavorite)
//                } else {
//                    print("No draft order ID available")
//                }
   
    }
    

    private func bindViewModel() {
           viewModel.didUpdateLineItems = { [weak self] in
               DispatchQueue.main.async {
                   self?.favCollectionView.reloadData()
               }
           }
       }

       // MARK: - UICollectionViewDataSource

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return  viewModel.displayedLineItems.count
       }
       
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
        
        let lineItem = viewModel.displayedLineItems[indexPath.item]
        
        let imageString = lineItem.sku ?? ""
           let components = imageString.components(separatedBy: ",")
           if components.count == 2 {
               let productID = components[0]
               let imageURL = components[1]
            
               
               let productName = lineItem.title
               cell.categoryItemName.text = productName?.components(separatedBy: " | ")[1]
               
//               cell.categoryItemName.text = lineItem.title
               cell.categoryItemPrice.text = lineItem.price
               cell.categoryItemCurrency.text = "$"
               
               if let url = URL(string: imageURL) {
                   cell.categoryItemImage.kf.setImage(with: url)
               }
              
               if viewModel.isProductFavorite(productTitle: productName ?? "") {
                          cell.btnFavCategoryItem.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                      } else {
                          cell.btnFavCategoryItem.setImage(UIImage(systemName: "heart"), for: .normal)
                      }

                      // Configure favorite button action
                      cell.favButtonTapped = { [weak self] in
                          guard let self = self else { return }
                          let productName = lineItem.title
                          if self.viewModel.isProductFavorite(productTitle: productName ?? "") {
                              self.viewModel.removeProductFromDraftOrder(productTitle: productName ?? "")
                            
                          } else {
                              self.viewModel.addProductToFavorites(productTitle: productName ?? "")
                          }
                          // Reload the collection view after updating the favorite list
                          self.favCollectionView.reloadData()
                      }
               
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
        let imageString = lineItem.sku ?? ""
        let components = imageString.components(separatedBy: ",")

        if components.count == 2, let productId = Int(components[0]) {
            NetworkManager.fetchProductDetails(productId: productId) { result in
                switch result {
                case .success(let product):
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                        let productInfoVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoVCR") as! ProductInfoViewController
                        //productInfoVC.productInfoViewModel!.product = product
                        self.present(productInfoVC, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print("Failed to fetch product details: \(error)")
                }
            }
        }
   }

   
}
