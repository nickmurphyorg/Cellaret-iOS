//
//  ProductAPIController.swift
//  Cellaret
//
//  Created by Nick Murphy on 8/10/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import Foundation
import OAuthSwift
import Keys

class ProductAPIController {
    static let shared = ProductAPIController()
    
    let cellaretKeys = CellaretKeys()
    let baseURL = URL(string: "https://api.semantics3.com/v1/")!
    let oauthCredentials: OAuth1Swift!
    let jsonDecoder = JSONDecoder()
    
    private init() {
        oauthCredentials = OAuth1Swift(consumerKey: cellaretKeys.semantics3Key, consumerSecret: cellaretKeys.semantics3Secret)
    }
    
    func getProduct(upc: String) {
        let productURL = baseURL.appendingPathComponent("products")
        let productData = ["upc": upc]
        
        guard let serializedProductData = serializeJSON(object: productData) else {
            print("ProductAPIController - Could not serialize product data.")
            
            return
        }
        
        let queryString = "q=" + serializedProductData
        
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: true)
        components?.query = queryString
        
        guard let requestURL = components?.url else {
            print("ProductAPIController - Request URL is nil.")
            
            return
        }
        
        let _ = oauthCredentials.client.get(requestURL.absoluteString, success: { [weak self] (response) in
            guard let weakSelf = self else {
                return
            }
            
            if let responseData = try? weakSelf.jsonDecoder.decode([String: String].self, from: response.data) {
                // TODO: - Initialize model to pass data back to caller.
                
            }
        }, failure: { (error) in
            print("ProductAPIController - \(error)")
        })
    }
}

// Mark: - Helper Methods
extension ProductAPIController {
    func serializeJSON(object: Any) -> String? {
        var serializedString: String?
        
        guard JSONSerialization.isValidJSONObject(object) else {
            print("ProductAPIController - Object is not a valid JSON object.")
            
            return nil
        }
        
        do {
            let serializedJSONData: Data = try JSONSerialization.data(withJSONObject: object, options: .sortedKeys)
            
            serializedString = String(data: serializedJSONData, encoding: .utf8)
        } catch let error {
            print("ProductAPIController - \(error)")
        }
        
        return serializedString
    }
}
