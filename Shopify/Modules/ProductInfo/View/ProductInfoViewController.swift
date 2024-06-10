//
//  ProductInfoViewController.swift
//  Shopify
//
//  Created by maha on 09/06/2024.
//

import UIKit
import ImageSlideshow

class ProductInfoViewController: UIViewController {

    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureImageSlideshow()
    }
    
    private func configureImageSlideshow() {
           // Set up the images
           let imageInputs = [
               ImageSource(image: UIImage(named: "wish")!),
               ImageSource(image: UIImage(named: "category")!),
               ImageSource(image: UIImage(named: "Ad")!)
           ]
           
           imageSlideshow.setImageInputs(imageInputs)
           
           // Optional configurations
           imageSlideshow.slideshowInterval = 5.0
           imageSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
           imageSlideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
           
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
