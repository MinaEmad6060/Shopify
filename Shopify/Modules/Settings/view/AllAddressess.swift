//
//  AllAddressess.swift
//  Shopify
//
//  Created by Slsabel Hesham on 12/06/2024.
//

import UIKit

class AllAddressess: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noAddresses: UIImageView!
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var allAddressessTableView: UITableView!
    var allAddressesViewModel: AllAddressesViewModel?
    var fetchDataFromApi: FetchDataFromApi!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromApi = FetchDataFromApi()
        
        // Do any additional setup after loading the view.
        self.allAddressessTableView.delegate = self
        self.allAddressessTableView.dataSource = self
        
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        allAddressesViewModel = AllAddressesViewModel()
        allAddressesViewModel?.bindResultToAllAddressViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.allAddressessTableView.reloadData()
                if self?.allAddressesViewModel?.addresses.count == 0{
                    self?.noAddresses.isHidden = false
                }else{
                    self?.noAddresses.isHidden = true
                }
            }
            
        }
        allAddressesViewModel?.getAllAddress(customerId: Utilites.getCustomerID())
        
    }
    /*
     func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 1
     }
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAddressesViewModel?.addresses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllAddressessTableViewCell
        
        
        
        if let addresses = allAddressesViewModel?.addresses {
            for address in addresses {
                if allAddressesViewModel?.addresses[indexPath.row].default == true {
                    print("oo")
                    cell.defaultBtn.setImage(UIImage(named: "Default.png"), for: .normal)
                    
                } else {
                    cell.defaultBtn.setImage(UIImage(named: "nonDefault.png"), for: .normal)
                }
            }
        } else {
            print("error")
        }
        
        
        cell.cityLabel.text = "\(allAddressesViewModel?.addresses[indexPath.row].country_name ?? "Country"), \(allAddressesViewModel?.addresses[indexPath.row].city ?? "City")"
        
        cell.phoneLabel.text = allAddressesViewModel?.addresses[indexPath.row].phone
        
        cell.addressLabel.text = allAddressesViewModel?.addresses[indexPath.row].address1
        
        cell.cellView.layer.cornerRadius = 10.0
        cell.setDefault = { [weak self] in
            
            guard let addressId = self?.allAddressesViewModel?.addresses[indexPath.row].id else { return }
            NetworkManager.setDefaultAddress(customerID: Utilites.getCustomerID(), addressID: addressId) { success in
                if success {
                    print("Address set as default successfully")
                    
                    self?.view.makeToast("Address set as default successfully")
                    if var addresses = self?.allAddressesViewModel?.addresses {
                        for index in addresses.indices {
                            addresses[index].default = false
                        }
                        self?.allAddressesViewModel?.addresses = addresses
                    } else {
                        print("error")
                    }
                    
                    
                    self?.allAddressesViewModel?.addresses[indexPath.row].default = true
                } else {
                    print("Failed to set address as default")
                }
                tableView.reloadData()
                
            }
            
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145.0
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let address = allAddressesViewModel?.addresses[indexPath.row]
            
            if address?.default == false {
                let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this address?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                    guard let addressId = address?.id else { return }
                    
                    self?.fetchDataFromApi?.deleteDataFromApi(url: self?.fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl, request: "customers/\(Utilites.getCustomerID())/addresses/\(addressId)") ?? "") { success in
                        if success {
                            print("del")
                            self?.allAddressesViewModel?.addresses.remove(at: indexPath.row)
                            DispatchQueue.main.async {
                                tableView.reloadData()
                                if self?.allAddressesViewModel?.addresses.count == 0 {
                                    self?.noAddresses.isHidden = false
                                } else {
                                    self?.noAddresses.isHidden = true
                                }
                            }
                        } else {
                            print("error")
                        }
                    }
                }))
                
                present(alert, animated: true, completion: nil)
            } else {
                self.view.makeToast("Can't delete default address")
            }
        }
    }
}
