//
//  ProductInfoViewController.swift
//  Shopify
//
//  Created by maha on 09/06/2024.
//

import UIKit
import ImageSlideshow
import Kingfisher

class ProductInfoViewController: UIViewController , ImageSlideshowDelegate{
    
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    
    @IBOutlet weak var colorSegment: UISegmentedControl!
    
    @IBOutlet weak var favBtn: UIBarButtonItem!

    var favViewMode: FavoriteViewModel!
  
    var productViewData: BrandProductViewData!
    var productInfoViewModel : ProdutInfoViewModel?
    var allProductsViewModel: AllProductsViewModel!
    
    var homeViewModel: HomeViewModelProtocol!

    @IBOutlet weak var quantityLB: UILabel!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    
    @IBOutlet weak var tiitleLB: UILabel!
    
    @IBOutlet weak var priceLB: UILabel!
    
@IBOutlet weak var descTextView: UILabel!
    
    @IBOutlet weak var cartBtn: UIButton!
    
@IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
@IBOutlet weak var sizeCollectionView: UICollectionView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    //var productInfoViewModel : ProdutInfoViewModel?
    var selectedSizeIndexPath: IndexPath?
       var selectedColorIndexPath: IndexPath?
       var selectedSize: String?
       var selectedColor: String?
    var selectedQuantity: Int?
    var productId :Int?
    var productId2 :Int?
    var productTitle :String?
    var favoriteProducts: [Int: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSegment()
        print("selectedSize:...:\(selectedSize)")
        print("selectedColor:...:\(selectedColor)")

        productViewData = BrandProductViewData()
        allProductsViewModel = AllProductsViewModel()

        configureImageSlideshow()
        tiitleLB.text = productInfoViewModel?.product?.title
        descTextView.text = productInfoViewModel?.product?.body_html
        
       // priceLB.text =  productInfoViewModel?.product?.price
        
        let priceString = productInfoViewModel?.product?.price ?? "0"
       
         let priceInt = Double(priceString) ?? 0
        let convertedPrice = priceInt * (Double(Utilites.getCurrencyRate()) ?? 1)
        priceLB.text = "\(convertedPrice) " + Utilites.getCurrencyCode()
        guard let productId = productInfoViewModel?.product?.id else {
            print("Product ID is nil")
            return
        }
        guard let productTitle = productInfoViewModel?.product?.title else {
            print("Product title is nil")
            return
        }
        
        
        homeViewModel = HomeViewModel()
        homeViewModel.getCurrentCustomer()
        
       
         //           self.updateDraftOrder()
       self.checkProductInDraftOrder()
        self.checkProductInDraftOrder()
                
        
        priceLB.text =  productInfoViewModel?.product?.price
        favViewMode = FavoriteViewModel()
        print("displayed line items******\(favViewMode.displayedLineItems)")
        
//        print("quantity.....\(productInfoViewModel?.product?.quantity)")
        if let quantity = productInfoViewModel?.product?.quantity[0] {
                    quantityLB.text = "\(quantity) items are available for this Size"
                } else {
                    quantityLB.text = "This size not available Now "
                }

    }
    func updateDraftOrder() {
            
            if let product = productInfoViewModel?.product {
                productInfoViewModel?.updateCartDraftOrder(product: product)
                productInfoViewModel?.updateFavoriteDraftOrder(product: product)
            }
        }
 
    private func configureImageSlideshow() {
            guard let productImages = productInfoViewModel?.product?.src else {
                imageSlideshow.setImageInputs([ImageSource(image: UIImage(named: "Ad")!)])
                return
            }
            
            // Convert product images to ImageSource array
        let imageUrls = productImages.compactMap { URL(string: $0) }
            
            if imageUrls.isEmpty {
                imageSlideshow.setImageInputs([ImageSource(image: UIImage(named: "Ad")!)])
            } else {
                downloadImages(from: imageUrls) { imageSources in
                    DispatchQueue.main.async {
                        self.imageSlideshow.setImageInputs(imageSources)
                    }
                }
            }
            
            imageSlideshow.slideshowInterval = 3.0
            imageSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
            imageSlideshow.contentScaleMode = UIView.ContentMode.scaleAspectFit
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.black
            pageIndicator.pageIndicatorTintColor = UIColor.lightGray
            imageSlideshow.pageIndicator = pageIndicator
            
            imageSlideshow.activityIndicator = DefaultActivityIndicator()
            imageSlideshow.delegate = self
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            imageSlideshow.addGestureRecognizer(recognizer)
            
            imageSlideshow.layer.cornerRadius = 20
            imageSlideshow.clipsToBounds = true
        }
        
        private func downloadImages(from urls: [URL], completion: @escaping ([ImageSource]) -> Void) {
            var imageSources: [ImageSource] = []
            let dispatchGroup = DispatchGroup()
            
            for url in urls {
                dispatchGroup.enter()
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        imageSources.append(ImageSource(image: image))
                    }
                    dispatchGroup.leave()
                }.resume()
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(imageSources)
            }
        }

       @objc func didTap() {
           let fullScreenController = imageSlideshow.presentFullScreenController(from: self)
           fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
       }
    
    @IBAction func addToCartBtn(_ sender: UIButton) {
        let customerId = Utilites.getCustomerID()
           if customerId == 0 {
               Utilites.displayGuestAlert(in:self, message: "Please log in to add cart.")
               return
           }
        productInfoViewModel?.updateCartDraftOrder( product: (productInfoViewModel?.product)!)
    }
    
    
    @IBAction func favBtn(_ sender: UIBarButtonItem) {
       
   /* guard let productTitle = productInfoViewModel?.product?.title else { return }
    
    guard let productTitle = productInfoViewModel?.product?.title else { return }

            guard let productId = productInfoViewModel?.product?.id else { return }
        
            favoriteProducts[productId] = !(favoriteProducts[productId] ?? false)

            if let isFavorite = favoriteProducts[productId] {
                updateFavoriteButtonImage(isFavorite)

                if isFavorite ,(favViewMode.displayedLineItems.contains(where: { $0.productID == productId })) == false{
                    print("productId ** from fav(productId)")
                    productInfoViewModel?.updateFavoriteDraftOrder(product: productInfoViewModel!.product!)
                } else {
                   
                    productInfoViewModel?.removeProductFromDraftOrder(productTitle: productTitle)
                }
           }*/
       
        guard let productTitle = productInfoViewModel?.product?.title,
                  let productId = productInfoViewModel?.product?.id else { return }
        let customerId = Utilites.getCustomerID()
           if customerId == 0 {
               Utilites.displayGuestAlert(in:self, message: "Please log in to add favorites.")
               return
           }

            favoriteProducts[productId] = !(favoriteProducts[productId] ?? false)

            if let isFavorite = favoriteProducts[productId] {
                updateFavoriteButtonImage(isFavorite)

                if isFavorite {
                    productInfoViewModel?.isProductInDraftOrder(productTitle: productTitle) { isInDraftOrder in
                        if !isInDraftOrder {
                            print("Adding productId ** from fav(productId)")
                            self.productInfoViewModel?.updateFavoriteDraftOrder(product: self.productInfoViewModel!.product!)
                        } else {
                            print("Product already in draft order, not adding again.")
                        }
                    }
                } else {
                    productInfoViewModel?.removeProductFromDraftOrder(productTitle: productTitle)
                }
            }

        
    }
    func checkProductInDraftOrder() {
            let productTitle = productInfoViewModel?.product?.title ?? ""
        productInfoViewModel?.isProductInDraftOrder(productTitle:productTitle  ?? "") { isInDraftOrder in
                if isInDraftOrder {
                    print("Product is in the draft order****.\(productTitle )")
                    self.updateFavoriteButtonImage(true)
                } else {
                    print("Product is not in the draft order.\(productTitle )")
                    self.updateFavoriteButtonImage(false)
                }
            }
        }

    private func updateFavoriteButtonImage(_ isFavorite: Bool) {
           let imageName = isFavorite ? "heart.fill" : "heart"
           favBtn.image = UIImage(systemName: imageName)
       }
    
    @IBAction func sizeSegmentedControlChanged(_ sender: UISegmentedControl) {
        selectedSize = productInfoViewModel?.product?.sizes[sender.selectedSegmentIndex] ?? ""
           print("selectedSize:...:\(selectedSize)")
        productInfoViewModel?.product?.sizes[0] = selectedSize ?? ""
        if let quantities = productInfoViewModel?.product?.quantity, sender.selectedSegmentIndex < quantities.count {
                     let quantity = quantities[sender.selectedSegmentIndex]
                     quantityLB.text = quantity == 0 ? "This size not available now" : "\(quantity) items are available for this size"
                   selectedQuantity = quantity
                   productInfoViewModel?.product?.inventory_quantity = selectedQuantity ?? 0
            updateAddToCartButton()
                 } else {
                     quantityLB.text = "N/A"
                 }
     
    }
    
    
    @IBAction func colorSegmentedControlChanged(_ sender: UISegmentedControl) {
        selectedColor = productInfoViewModel?.product?.colors[sender.selectedSegmentIndex] ?? ""
          print("selectedColor:...:\(selectedColor)")
        productInfoViewModel?.product?.colors[0] = selectedColor ?? ""
    }
    func updateSegment(){
        sizeSegment.removeAllSegments()
        productInfoViewModel?.product?.sizes.forEach { sizeSegment.insertSegment(withTitle: $0, at: sizeSegment.numberOfSegments, animated: false) }
        sizeSegment.selectedSegmentIndex = 0
        selectedSize = productInfoViewModel?.product?.sizes.first ?? ""

        colorSegment.removeAllSegments()
        productInfoViewModel?.product?.colors.forEach { colorSegment.insertSegment(withTitle: $0, at: colorSegment.numberOfSegments, animated: false) }
        colorSegment.selectedSegmentIndex = 0
        selectedColor = productInfoViewModel?.product?.colors.first ?? ""
        

    }
    private func updateAddToCartButton() {
        if let selectedSizeIndex = sizeSegment?.selectedSegmentIndex,
           let quantities = productInfoViewModel?.product?.quantity,
           selectedSizeIndex < quantities.count {
            let quantity = quantities[selectedSizeIndex]
            cartBtn.isEnabled = quantity > 0
            cartBtn.setTitle(quantity > 0 ? "Add to Cart" : "Sold Out", for: .normal)
        } else {
            cartBtn.isEnabled = false
            cartBtn.setTitle("Sold Out", for: .normal)
        }
    }

    
}

 
   
