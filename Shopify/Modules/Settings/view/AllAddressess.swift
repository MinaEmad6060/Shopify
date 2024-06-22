//
//  AllAddressess.swift
//  Shopify
//
//  Created by Slsabel Hesham on 12/06/2024.
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
            
        }//7445466022059
        allAddressesViewModel?.getAllAddress(customerId: 7445466022059)
        
        
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
        
        cell.cityLabel.text = "\(allAddressesViewModel?.addresses[indexPath.row].country ?? "Country"), \(allAddressesViewModel?.addresses[indexPath.row].city ?? "City")"
        
        cell.phoneLabel.text = allAddressesViewModel?.addresses[indexPath.row].phone
        
        cell.addressLabel.text = allAddressesViewModel?.addresses[indexPath.row].address1
        
        cell.cellView.layer.cornerRadius = 25.0
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let addressId = allAddressesViewModel?.addresses[indexPath.row].id else { return }
            NetworkManager.deleteCustomerAddress(customerId: 7423232082091, addressId: addressId) { [weak self] success in
                if success {
                    self?.allAddressesViewModel?.addresses.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } else {
                    // Handle the error appropriately (e.g., show an alert to the user)
                }
            }
        }
    }
}
