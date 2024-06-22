//
//  SearchViewController.swift
//  Shopify
//
//  Created by maha on 18/06/2024.
//

import UIKit
import Kingfisher
class SearchViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
  

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)

    }
    @IBOutlet weak var searchTableView: UITableView!
    var viewModel = SearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        viewModel.getAllProduct()
        viewModel.bindFilteredProductsToViewController = {
            DispatchQueue.main.async {
                print("DispatchQueue VC :: \(self.viewModel.filteredProducts.count)")
                self.searchTableView.reloadData()
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView VC :: \(viewModel.filteredProducts.count)")

            return viewModel.filteredProducts.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            let product = viewModel.filteredProducts[indexPath.row]

//                   if let imageView = cell.contentView.viewWithTag(0) as? UIImageView {
//                       //
//                       if let imageUrl = URL(string: product.image?.src ?? "") {
//                           print("**************")
//                           print("image url\(imageUrl)")
//                           print("**************")
//                           imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "wish"))
//                       }
//                   }
            if let imageView = cell.contentView.viewWithTag(0) as? UIImageView {
                        if let firstImage = product.images?.first, let imageUrl = URL(string: firstImage.src ?? "") {
                            imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "wish"))
                        }
                    }
                   if let label = cell.contentView.viewWithTag(1) as? UILabel {
                       label.text = product.title
                   }

                   return cell
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel.searchProducts(for: searchText)
            searchTableView.reloadData()
        }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
