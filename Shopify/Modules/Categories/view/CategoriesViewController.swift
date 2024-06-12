//
//  CategoriesViewController.swift
//  Shopify
//
//  Created by Mina Emad on 06/06/2024.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var selectCategory: UISegmentedControl!
    
    @IBOutlet weak var selectSubCategory: UISegmentedControl!
    
    
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        getSelectedCategoryValue(sender: selectCategory)
        getSelectedCategoryValue(sender: selectSubCategory)
        
        let nibCustomCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        self.categoryCollectionView.register(nibCustomCell, forCellWithReuseIdentifier: "CategoryCell")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        return cell
    }
 
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let selectedSegmentTitle = sender.titleForSegment(at: selectedIndex)
    }
    
    func getSelectedCategoryValue(sender: UISegmentedControl){
        sender.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControlValueChanged(sender)
    }
}
