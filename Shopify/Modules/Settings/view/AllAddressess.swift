//
//  AllAddressess.swift
//  Shopify
//
//  Created by Slsabel Hesham on 11/06/2024.
//

import UIKit

class AllAddressess: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var allAddressessTableView: UITableView!
    var allAddressesViewModel: AllAddressesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.allAddressessTableView.delegate = self
        self.allAddressessTableView.dataSource = self
        
        allAddressesViewModel = AllAddressesViewModel()
        allAddressesViewModel?.bindResultToAllAddressViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.allAddressessTableView.reloadData()
            }
            
        }
        allAddressesViewModel?.getAllAddress(customerId: 7423232082091)

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // #warning Incomplete implementation, return the number of sections
       return 1
   }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAddressesViewModel?.addresses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllAddressessTableViewCell

        cell.cityLabel.text = allAddressesViewModel?.addresses[indexPath.row].city

        return cell
        
    }
}
