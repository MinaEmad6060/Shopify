//
//  CategoriesViewController.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var categoryList = ["Women" , "Kids" , "Men" ,  "Sale"]
    var subCategoryList = ["T-Shirt" , "Shoes" , "Accessories"]

    var lastIndexCategoryActive:IndexPath = [1 ,0]
    var lastIndexSubCategoryActive:IndexPath = [1 ,0]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        
        selectCategoryCollectionView.delegate = self
        selectCategoryCollectionView.dataSource = self

        let nibCustomCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        self.categoryCollectionView.register(nibCustomCell, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    // UICollectionViewDelegateFlowLayout method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the desired size for the cells
        return CGSize(width: 20, height: 20) // Example size
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width / 3.5, height: view.frame.height/4)
//    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == selectCategoryCollectionView{
            return 2
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectCategoryCollectionView{
            if section == 0{
                return self.categoryList.count
            }else{
                return self.subCategoryList.count
            }
        }
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == selectCategoryCollectionView{
            if indexPath.section == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! SelectCategory

                cell.nameSelectedCell.text = self.categoryList[indexPath.row]
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subCell", for: indexPath as IndexPath) as! SelectSubCategory

                cell.nameSubSelectedCell.text = self.subCategoryList[indexPath.row]
                return cell
            }
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectCategoryCollectionView{
            if self.lastIndexCategoryActive != indexPath && indexPath.section == 0 {
                let cell = collectionView.cellForItem(at: indexPath) as! SelectCategory
                cell.nameSelectedCell.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.selectCell.backgroundColor = #colorLiteral(red: 0.5197754502, green: 0.4352019429, blue: 0.3402310014, alpha: 1)
                cell.selectCell.layer.masksToBounds = true
                
                let cell1 = collectionView.cellForItem(at: self.lastIndexCategoryActive) as? SelectCategory
                cell1?.nameSelectedCell.textColor = #colorLiteral(red: 0.5197754502, green: 0.4352019429, blue: 0.3402310014, alpha: 1)
                cell1?.selectCell.backgroundColor = #colorLiteral(red: 0.9565492272, green: 0.9433754086, blue: 0.9277216792, alpha: 1)
                cell1?.selectCell.layer.masksToBounds = true
                self.lastIndexCategoryActive = indexPath
                
                print(cell.nameSelectedCell.text!)
            }
            else if self.lastIndexSubCategoryActive != indexPath && indexPath.section == 1 {
                let cell = collectionView.cellForItem(at: indexPath) as! SelectSubCategory
                cell.nameSubSelectedCell.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.selectSubCell.backgroundColor = #colorLiteral(red: 0.5197754502, green: 0.4352019429, blue: 0.3402310014, alpha: 1)
                cell.selectSubCell.layer.masksToBounds = true
                
                let cell1 = collectionView.cellForItem(at: self.lastIndexSubCategoryActive) as? SelectSubCategory
                cell1?.nameSubSelectedCell.textColor = #colorLiteral(red: 0.5197754502, green: 0.4352019429, blue: 0.3402310014, alpha: 1)
                cell1?.selectSubCell.backgroundColor = #colorLiteral(red: 0.9565492272, green: 0.9433754086, blue: 0.9277216792, alpha: 1)
                cell1?.selectSubCell.layer.masksToBounds = true
                self.lastIndexSubCategoryActive = indexPath
                
                print(cell.nameSubSelectedCell.text!)
            }
        }
    }
    
    
    
    
}
