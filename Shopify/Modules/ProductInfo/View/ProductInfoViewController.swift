//
//  ProductInfoViewController.swift
//  Shopify
//
//  Created by maha on 09/06/2024.
//

import UIKit
import ImageSlideshow
import Kingfisher

class ProductInfoViewController: UIViewController,UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
    
  
    
    var productInfoViewModel : ProdutInfoViewModel?
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    
    @IBOutlet weak var tiitleLB: UILabel!
    
    @IBOutlet weak var priceLB: UILabel!
    
    @IBOutlet weak var descTextView: UITextView!
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
@IBOutlet weak var sizeCollectionView: UICollectionView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    var productId :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
    
           sizeCollectionView.dataSource = self
              sizeCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        configureImageSlideshow()
        print(productInfoViewModel?.product?.images)
        tiitleLB.text = productInfoViewModel?.product?.title
        descTextView.text = productInfoViewModel?.product?.body_html
        priceLB.text =  productInfoViewModel?.product?.variants?[0].price
       // sizeLB.text = productInfoViewModel?.product?.options[0].values?[0]
       // productId = productInfoViewModel?.product?.id
        guard let productId = productInfoViewModel?.product?.id else {
               print("Product ID is nil")
               return
           }
        print( "product id:*****\(productId)")
        productInfoViewModel?.getCurrentCustomer()
    }

    private func configureImageSlideshow() {
            guard let productImages = productInfoViewModel?.product?.images else {
                imageSlideshow.setImageInputs([ImageSource(image: UIImage(named: "Ad")!)])
                return
            }
            
            // Convert product images to ImageSource array
            let imageUrls = productImages.compactMap { URL(string: $0.src ?? "") }
            
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
        
        productInfoViewModel?.updateCartDraftOrder( product: (productInfoViewModel?.product)!)
    }
    
    
    @IBAction func favBtn(_ sender: UIBarButtonItem) {
    }
    
}

   extension ProductInfoViewController: ImageSlideshowDelegate {
       func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
           print("current page:", page)
       }
//       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SizeCollectionViewCell
//           if let size = productInfoViewModel?.product?.options[0].values?[indexPath.item] {
//                   cell.sizeLB.text = size
//               print("size ===\(size)")
//               }
//               return cell
//       
//           }
           
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if collectionView == sizeCollectionView {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SizeCollectionViewCell
               if let size = productInfoViewModel?.product?.options.first(where: { $0.name == "Size" })?.values?[indexPath.item] {
                   cell.sizeLB.text = size
               }
               return cell
           } else if collectionView == colorCollectionView {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorsCollectionViewCell
               if let color = productInfoViewModel?.product?.options.first(where: { $0.name == "Color" })?.values?[indexPath.item] {
                   cell.colorLB.text = color
                   //cell.colorView.backgroundColor = UIColor(named: color) // Assuming you have color names that match your app's color assets
               }
               return cell
           }
           return UICollectionViewCell()
       }
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//           return   productInfoViewModel?.product?.options.first(where: { $0.name == "Size" })?.values?.count ?? 0
           if collectionView == sizeCollectionView {
                  return productInfoViewModel?.product?.options.first(where: { $0.name == "Size" })?.values?.count ?? 0
              } else if collectionView == colorCollectionView {
                  return productInfoViewModel?.product?.options.first(where: { $0.name == "Color" })?.values?.count ?? 0
              }
              return 0
       }
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 50, height: 50)
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 10
       }

   }
