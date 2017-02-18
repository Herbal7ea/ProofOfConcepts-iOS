//
//  NetworkLayer.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import Foundation

class NetworkLayer {
    static var shared = NetworkLayer()
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }.resume()
    }
}
