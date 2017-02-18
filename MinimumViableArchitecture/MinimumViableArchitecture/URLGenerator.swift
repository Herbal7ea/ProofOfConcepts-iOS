//
//  URLGenerator.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import UIKit

class URLGenerator {
    static var shared = URLGenerator()
    
    private var imageSize = 400
    
    func urlStringFor(text: String) -> String {
        
        let randomColor1 = UIColor.random.hexString
        let randomColor2 = UIColor.random.hexString
        var url = "https://placehold.it/\(imageSize)/\(randomColor1)/\(randomColor2)?text=\(text)"
            url = url.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        return url
    }
}
