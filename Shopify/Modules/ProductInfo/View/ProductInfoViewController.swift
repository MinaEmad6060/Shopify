//
//  ProductInfoViewController.swift
//  Shopify
//
//  Created by maha on 09/06/2024.
//

import UIKit
import ImageSlideshow
import Kingfisher
class ProductInfoViewController: UIViewController {
    var productInfoViewModel : ProdutInfoViewModel?
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    
    @IBOutlet weak var tiitleLB: UILabel!
    
    @IBOutlet weak var priceLB: UILabel!
    
    @IBOutlet weak var descTextView: UITextView!
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        configureImageSlideshow()
        print(productInfoViewModel?.product?.images)
        tiitleLB.text = productInfoViewModel?.product?.title
        descTextView.text = productInfoViewModel?.product?.body_html
        priceLB.text =  productInfoViewModel?.product?.variants?[0].price
    }
    
    private func configureImageSlideshow() {
           // Set up the images
//           let imageInputs = [
//               ImageSource(image: UIImage(named: "wish")!),
//               ImageSource(image: UIImage(named: "category")!),
//               ImageSource(image: UIImage(named: "Ad")!)
//           ]
//           
          // imageSlideshow.setImageInputs(imageInputs)
        

              // Convert product images to ImageSource array
              
        guard let productImages = productInfoViewModel?.product?.images else {
             
            imageSlideshow.setImageInputs([ImageSource(image: UIImage(named: "Ad")!)])
             return
         }

         // Convert product images to ImageSource array
         let imageInputs = productImages.compactMap { image -> ImageSource? in
             if let urlString = image.src, let url = URL(string: urlString) {
                 let imageView = UIImageView()
                 imageView.kf.setImage(with: url)
                 return ImageSource(image: imageView.image ?? UIImage())
             }
             return nil
         }
        print("imageInputs******\(imageInputs)")

         imageSlideshow.setImageInputs(imageInputs)
           imageSlideshow.slideshowInterval = 3.0
        imageSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
           imageSlideshow.contentScaleMode = UIView.ContentMode.scaleAspectFit
           
           let pageIndicator = UIPageControl()
           pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
           pageIndicator.pageIndicatorTintColor = UIColor.black
           imageSlideshow.pageIndicator = pageIndicator
           
           imageSlideshow.activityIndicator = DefaultActivityIndicator()
           imageSlideshow.delegate = self
        
           let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
           imageSlideshow.addGestureRecognizer(recognizer)
        
              imageSlideshow.layer.cornerRadius = 20
              imageSlideshow.clipsToBounds = true
       }

       @objc func didTap() {
           let fullScreenController = imageSlideshow.presentFullScreenController(from: self)
           fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
       }
   }

   extension ProductInfoViewController: ImageSlideshowDelegate {
       func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
           print("current page:", page)
       }
   }
