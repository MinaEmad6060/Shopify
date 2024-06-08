//
//  HomeViewController.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
          // 1
          let layout = UICollectionViewCompositionalLayout{sectionindex,enviroment in
              if sectionindex==0 {
                  return self.drawAdsSection()
              }else{
                  return self.drawBrandsSection()
              }
          }
        homeCollectionView.setCollectionViewLayout(layout, animated: true)
        
        let nibCustomCell = UINib(nibName: "AdsCollectionViewCell", bundle: nil)
        self.homeCollectionView.register(nibCustomCell, forCellWithReuseIdentifier: "AdsCell")
        
        let noDataCustomCell = UINib(nibName: "BrandsCollectionViewCell", bundle: nil)
        self.homeCollectionView.register(noDataCustomCell, forCellWithReuseIdentifier: "BrandsCell")
    }
    
    
    func drawAdsSection ()-> NSCollectionLayoutSection{
        //6 item size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        //5 create item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // 4 group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .absolute(230))
        //3 create group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8 )
        //2 create section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0)
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
             items.forEach { item in
             let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
             let minScale: CGFloat = 0.8
             let maxScale: CGFloat = 1.2
             let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
             item.transform = CGAffineTransform(scaleX: scale, y: scale)
             }
        }
        return section
    }
    
    func drawBrandsSection ()-> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
       , heightDimension: .fractionalHeight(1))
       let item = NSCollectionLayoutItem(layoutSize: itemSize)
       
       let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
       , heightDimension: .absolute(210))
       let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
       , subitems: [item])
       group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
       , bottom: 8, trailing: 0)
       
       let section = NSCollectionLayoutSection(group: group)
       section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15
       , bottom: 10, trailing: 15)
       
       return section
    }

  

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section==0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCell", for: indexPath) as! AdsCollectionViewCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCollectionViewCell
        
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
            guard let allProductsViewController = storyboard?.instantiateViewController(withIdentifier: "AllProductsVC") as? AllProductsViewController else {
                return
            }
            
       
            allProductsViewController.modalPresentationStyle = .fullScreen
            present(allProductsViewController, animated: true )

            
    }
    
}
