//
//  FavoriteViewController.swift
//  Shopify
//
//  Created by maha on 18/06/2024.
//

import UIKit

class FavoriteViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource{
    private var viewModel = FavoriteViewModel()

    @IBOutlet weak var favCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.favCollectionView.delegate
        self.favCollectionView.dataSource
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
               self.favCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        bindViewModel()
        viewModel.fetchLineItems(draftOrderId: 123456)
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
           return viewModel.lineItems.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
           let lineItem = viewModel.lineItems[indexPath.item]
           cell.configure(with: lineItem)
           return cell
       }
}
