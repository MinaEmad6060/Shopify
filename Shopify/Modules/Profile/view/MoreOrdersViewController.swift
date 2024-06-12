//
//  MoreOrdersViewController.swift
//  Shopify
//
//  Created by Mina Emad on 11/06/2024.
//

import UIKit

class MoreOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var moreOrdersTable: UITableView!
    
    
    @IBAction func btnBack(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreOrdersTable.delegate = self
        moreOrdersTable.dataSource = self
        
        let nibCustomCell = UINib(nibName: "OrdersTableViewCell", bundle: nil)
        moreOrdersTable.register(nibCustomCell, forCellReuseIdentifier: "moreOrdersCell")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreOrdersCell", for: indexPath)
        return cell
    }
}
