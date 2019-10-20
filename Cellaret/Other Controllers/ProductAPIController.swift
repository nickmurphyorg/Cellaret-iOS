//
//  ProductAPIController.swift
//  Cellaret
//
//  Created by Nick Murphy on 8/10/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import Foundation
import Keys

class ProductAPIController {
    static let shared = ProductAPIController()
    
    let cellaretKeys = CellaretKeys()
    let baseURL = URL(string: "https://api.barcodespider.com/v1/")!
    let jsonDecoder = JSONDecoder()
    
    func getProduct(UPC: String, completion: @escaping (DrinkData?) -> Void) {
        let productURL = baseURL.appendingPathComponent("lookup")
        let queryString = "token=\(cellaretKeys.apiToken)&upc=\(UPC)"
        let jsonDecoder = JSONDecoder()
        
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: true)
        components?.query = queryString
        
        guard let requestURL = components?.url else {
            print("ProductAPIController - Request URL is nil.")
            completion(nil)
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let data = data,
                let parsedData = try? jsonDecoder.decode(DrinkData.self, from: data) {
                completion(parsedData)
                
            } else {
                print("Either no data was returned, or data was not properly decoded.")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
