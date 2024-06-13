//
//  MoreWishesViewController.swift
//  Shopify
//
//  Created by Mina Emad on 11/06/2024.
//

import UIKit

class MoreWishesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    
    @IBOutlet weak var moreWishesTable: UITableView!
    
    
    
    
    @IBAction func btnBack(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreWishesTable.delegate = self
        moreWishesTable.dataSource = self
        
        let nibCustomCell = UINib(nibName: "WishListTableViewCell", bundle: nil)
        moreWishesTable.register(nibCustomCell, forCellReuseIdentifier: "moreWishesCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreWishesCell", for: indexPath)
        return cell
    }

}
