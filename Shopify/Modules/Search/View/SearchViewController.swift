//
//  SearchViewController.swift
//  Shopify
//
//  Created by maha on 18/06/2024.
//

import UIKit

class SearchViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
