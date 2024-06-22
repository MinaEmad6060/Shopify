//
//  NetworkManager.swift
//  Shopify
//
//  Created by Slsabel Hesham on 09/06/2024.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var baseUrl = "\(Constants.baseUrl)customers/177564125/addresses.json"
    //smart_collections.json
    func formatUrl(request: String, query: String="", value: String="") -> String{
        return baseUrl+request+".json?"+query+"="+value
    }
    
    static func getDataFromApi<T: Decodable>(url: String, handler: @escaping (T)->Void){
        let urlFB = URL(string: url)
        guard let urlFB = urlFB else{return}
        
        
        AF.request(urlFB).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let result):
                handler(result)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    static func addNewAddress(customerID: Int, address: Address, completion: @escaping (Bool) -> Void) {
        let url = "\(Constants.baseUrl)customers/\(customerID)/addresses.json"
        
        let customerAddressRequest = CustomerAddressRequest(address: address)
        
        guard let encodedCredentials = "\(Constants.api_key):\(Constants.password)".data(using: .utf8)?.base64EncodedString() else {
            print("Failed to encode credentials")
            completion(false)
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(encodedCredentials)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: customerAddressRequest, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Error adding address: \(error)")
                    completion(false)
                }
            }
    }
    static func deleteCustomerAddress(customerId: Int, addressId: Int, completion: @escaping (Bool) -> Void) {
        let url = "\(Constants.baseUrl)customers/\(customerId)/addresses/\(addressId).json"
        
        AF.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Error deleting address: \(error)")
                    completion(false)
                }
            }
    }

    static func updateCustomerNote(customerId: Int, newNote: String, completion: @escaping (Int) -> Void) {
            let url = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/customers/\(customerId).json"
            
            let customerInfoDictionary: [String: Any] = ["customer": ["id": customerId, "note": newNote]]
            
            AF.request(url, method: .put, parameters: customerInfoDictionary, encoding: JSONEncoding.prettyPrinted, headers: ["Content-Type": "application/json"]).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let httpResponse = response.response {
                        do {
                            let decodedResponse = try JSONDecoder().decode(CustomerResponse.self, from: response.data!)
                            let updatedCustomer = decodedResponse.customer
                            
                            // Update UserDefaults based on the note
                            if updatedCustomer.note == "cart" {
                                UserDefaults.standard.set(updatedCustomer.id, forKey: "draftOrderIDCart")
                            } else if updatedCustomer.note == "favorite" {
                                UserDefaults.standard.set(updatedCustomer.id, forKey: "draftOrderIDFavorite")
                            }
                            
                            completion(httpResponse.statusCode)
                        } catch let decodeError {
                            print("Failed to decode response: \(decodeError.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Network request failed: \(error.localizedDescription)")
                    completion(-1)
                }
            }
        }
    static func updateDraftOrder(draftOrderId: Int,product: BrandProductViewData, complication: @escaping (Int) -> Void) {
        let urlString = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/draft_orders/\(draftOrderId).json"
        
        let newLineItem = LineItem(
            id: nil,
            variantID:nil,
            productID: product.id ?? 0,
            title: product.title,
            variantTitle: nil,
            sku: "\(product.id ?? 0),\(product.src[0] ?? "")",
            vendor: nil,
            quantity: 2,
            requiresShipping: nil,
            taxable: nil,
            giftCard: nil,
            fulfillmentService: nil,
            grams: nil,
            taxLines: nil,
            name: nil,
            custom: nil,
            price: product.price,
            image: product.src[0]
        )
        
        AF.request(urlString).responseDecodable(of: Drafts.self) { response in
            switch response.result {
            case .success(let draftResponse):
                guard var draftOrder = draftResponse.draftOrder else {
                    print("Draft Order not found")
                    return
                }
                
                // Add the new line item to the existing line items
                var updatedLineItems = draftOrder.lineItems ?? []
                updatedLineItems.append(newLineItem)
                
                // Update the draft order with the new line items
                draftOrder.lineItems = updatedLineItems
                
               
                do {
                    let updatedDraftOrderDictionary = try draftOrder.asDictionary()
                    let requestBody: [String: Any] = ["draft_order": updatedDraftOrderDictionary]
                    
                    // Send the updated draft order using PUT request
                    AF.request(urlString, method: .put, parameters: requestBody, encoding: JSONEncoding.default).response { response in
                        if let httpResponse = response.response {
                            complication(httpResponse.statusCode)
                        } else if let error = response.error {
                            print("HTTP request error: \(error.localizedDescription)")
                        }
                    }
                } catch {
                    print("Error converting draft order to dictionary: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error fetching draft order: \(error.localizedDescription)")
            }
        }
    }
    static func getCustomer(customerID: Int, completion: @escaping (Customer?) -> Void) {
            let url = "https://\(Constants.api_key):\(Constants.password)@\(Constants.hostname)/admin/api/2023-04/customers/\(customerID).json"
            
            guard let encodedCredentials = "\(Constants.api_key):\(Constants.password)".data(using: .utf8)?.base64EncodedString() else {
                print("Failed to encode credentials")
                completion(nil)
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Basic \(encodedCredentials)",
                "Content-Type": "application/json"
            ]
            
            AF.request(url, headers: headers).responseDecodable(of: CustomerResponse.self) { response in
                switch response.result {
                case .success(let result):
                    completion(result.customer)
                case .failure(let error):
                    print("Error fetching customer: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    static func fetchLineItemsInDraftOrder(draftOrderId: Int, completion: @escaping ([LineItem]?) -> Void) {
           let urlString = "https://\(Constants.api_key):\(Constants.password)@\(Constants.hostname)/admin/api/2023-04/draft_orders/\(draftOrderId).json"
           
           AF.request(urlString).responseDecodable(of: Drafts.self) { response in
               switch response.result {
               case .success(let draftResponse):
                   if let lineItems = draftResponse.draftOrder?.lineItems {
                       completion(lineItems)
                       print("lineItems:***\(lineItems)")
                   } else {
                       print("No line items found in api")
                       completion(nil)
                   }
               case .failure(let error):
                   print("Error fetching line items: \(error.localizedDescription)")
                   completion(nil)
               }
           }
       }
   static func fetchAllProducts(completion: @escaping (Result<BrandProduct, Error>) -> Void) {
            let url = "https://\(Constants.api_key):\(Constants.password)@\(Constants.hostname)/admin/api/2023-04/products.json"
       
            
            AF.request(url).validate().responseDecodable(of: BrandProduct.self) { response in
                switch response.result {
                case .success(let brandProduct):
                    completion(.success(brandProduct))
                   // print(brandProduct)
                case .failure(let error):
                    completion(.failure(error))
                    print("errorrrr")
                }
            }
        }

    
    static func updateDraftOrder(draftOrderId: Int, lineItems: [LineItemm], completion: @escaping (Bool) -> Void) {
        let url = "\(Constants.baseUrl)/draft_orders/\(draftOrderId).json"
        guard let encodedCredentials = "\(Constants.api_key):\(Constants.password)".data(using: .utf8)?.base64EncodedString() else {
            print("Failed to encode credentials")
            completion(false)
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(encodedCredentials)",
            "Content-Type": "application/json"
        ]
        
        let lineItemsData = lineItems.map {
            [
                "id": $0.id,
                "quantity": $0.quantity,
                "title": $0.name,
                "price": $0.price,
                "variant_id": $0.variant_id as Any,
                "variant_title": $0.variant_title as Any
            ]
        }
        
        let parameters: [String: Any] = [
            "draft_order": [
                "line_items": lineItemsData
            ]
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print("\(error)")
                completion(false)
            }
        }
    }
    static func fetchDraftOrder(draftOrderId: Int, completion: @escaping (DraftOrderr?) -> Void) {
        let url = "\(Constants.baseUrl)draft_orders/\(draftOrderId).json"
        
        
        AF.request(url, method: .get).responseDecodable(of: DraftOrderResponsee.self) { response in
            switch response.result {
            case .success(let draftOrderResponse):
                completion(draftOrderResponse.draft_order)
            case .failure(let error):
                print("Error fetching draft order: \(error)")
                completion(nil)
            }
        }
    }
    static func checkProductAvailability(productId: Int, completion: @escaping (Int?) -> Void) {
        let url = "\(Constants.baseUrl)products/8100172759211.json"
        
        
        AF.request(url, method: .get).responseDecodable(of: ProductResponse.self) { response in
            switch response.result {
            case .success(let productResponse):
                completion(productResponse.product.variants?.first?.inventory_quantity)
            case .failure(let error):
                print("Error fetching product availability: \(error)")
                completion(nil)
            }
        }
    }
    

    func setDefaultAddress(customerID: Int, addressID: Int, completion: @escaping (Bool) -> Void) {
        let url = "\(Constants.baseUrl)customers/\(customerID)/addresses/\(addressID).json"
        
        guard let encodedCredentials = "\(Constants.api_key):\(Constants.password)".data(using: .utf8)?.base64EncodedString() else {
            print("Failed to encode credentials")
            completion(false)
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(encodedCredentials)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "address": [
                "default": true
            ]
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Error: \(error)")
                    completion(false)
                }
            }
    }

    static func removeLineItemFromDraftOrder(draftOrderId: Int, productTitle: String, completion: @escaping (Int) -> Void) {
        let urlString = "\(Constants.baseUrl)draft_orders/\(draftOrderId).json"
        
        AF.request(urlString).responseDecodable(of: Drafts.self) { response in
            switch response.result {
            case .success(let draftResponse):
                guard var draftOrder = draftResponse.draftOrder else {
                    print("Draft Order not found")
                    return
                }
                
                // Remove the line item with the specified line item ID
                draftOrder.lineItems = draftOrder.lineItems?.filter { $0.title != productTitle }
                
                do {
                    let updatedDraftOrderDictionary = try draftOrder.asDictionary()
                    let requestBody: [String: Any] = ["draft_order": updatedDraftOrderDictionary]
                    
                    // Send the updated draft order using PUT request
                    AF.request(urlString, method: .put, parameters: requestBody, encoding: JSONEncoding.default).response { response in
                        if let httpResponse = response.response {
                            completion(httpResponse.statusCode)
                        } else if let error = response.error {
                            print("HTTP request error: \(error.localizedDescription)")
                        }
                    }
                } catch {
                    print("Error converting draft order to dictionary: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error fetching draft order: \(error.localizedDescription)")
            }
        }
    }
   static func fetchProductDetails(productId: Int, completion: @escaping (Result<Product, Error>) -> Void) {
        let url = "https://106ef29b5ab2d72aa0243decb0774101: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@mad44-alex-ios-team3.myshopify.com/admin/api/2024-04/products/\(productId).json"
        
        AF.request(url).validate().responseDecodable(of: Product.self) { response in
            switch response.result {
            case .success(let product):
                completion(.success(product))
                print("/********/")
                print(response)
                print("/********/")
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }



}

