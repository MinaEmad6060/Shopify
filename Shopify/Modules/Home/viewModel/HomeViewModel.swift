//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


class HomeViewModel: HomeViewModelProtocol{
   
    var brandsViewData: [BrandsViewData]!
    var fetchDataFromApi: FetchDataFromApi!
    var bindBrandsToViewController : (()->())! = {}
    
    
    init(){
        brandsViewData = [BrandsViewData]()
        fetchDataFromApi = FetchDataFromApi()
    }
    
    func getBrandsFromNetworkService(){
        fetchDataFromApi?.getDataFromApi(url: fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl, request: "smart_collections") ?? ""){[weak self] (brands: Brand) in
            var brand = BrandsViewData()
            for i in 0..<(brands.smart_collections?.count ?? 0){
                brand.id = brands.smart_collections?[i].id
                brand.image = brands.smart_collections?[i].image
                brand.title = brands.smart_collections?[i].title
                self?.brandsViewData.append(brand)
            }
            self?.bindBrandsToViewController?()
        }
    }
   
    func getCurrentCustomer() {
        let email = Utilites.getCustomerEmail()
        print("URL :::: \(fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl,request: "customers/search", query: "query", value: "email:\(email)") ?? "")")
        fetchDataFromApi?.getDataFromApi(url: fetchDataFromApi?.formatUrl(baseUrl: Constants.baseUrl,request: "customers/search", query: "query", value: "email:\(email)") ?? ""){(loginedCustomers: LoginedCustomers) in
            print("testSuccess :::: ")
            let fname = loginedCustomers.customers[0].first_name
            UserDefaults.standard.set(fname, forKey: "fname")
            let userID = loginedCustomers.customers[0].id
            UserDefaults.standard.set(userID, forKey: "userID")
            if let note = loginedCustomers.customers[0].note {

                let components = note.split(separator: ",")

                if components.count == 2,
                   let firstID = Int(components[0]),
                   let secondID = Int(components[1]) {
                    UserDefaults.standard.set(firstID, forKey: "favIDNet")
                    UserDefaults.standard.set(secondID, forKey: "cartIDNet")
                } else {
                    print("Note does not contain two valid IDs")
                }
            } else {
                print("Customer note is nil or does not contain valid IDs")
            }
        }
        
        
//        NetworkManager.getCustomer(email: email) { customer in
//            
//            let fname = customer?.first_name
//            UserDefaults.standard.set(fname, forKey: "fname")
//            let userID = customer?.id
//            UserDefaults.standard.set(userID, forKey: "userID")
//            if let note = customer?.note {
//                
//                let components = note.split(separator: ",")
//                
//                if components.count == 2,
//                   let firstID = Int(components[0]),
//                   let secondID = Int(components[1]) {
//                    UserDefaults.standard.set(firstID, forKey: "favIDNet")
//                    UserDefaults.standard.set(secondID, forKey: "cartIDNet")
//                } else {
//                    print("Note does not contain two valid IDs")
//                }
//            } else {
//                print("Customer note is nil or does not contain valid IDs")
//            }
//            
//        }
    }
}
