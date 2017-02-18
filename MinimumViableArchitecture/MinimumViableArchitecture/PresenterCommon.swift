//
//  PresenterCommon.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import UIKit

class PresenterCommon {
    
    static var shared = PresenterCommon()
    
    func downloadImage(url: URL, finished: @escaping (UIImage?) -> Void) {
        
        NetworkLayer.shared.getDataFromUrl(url: url) { data, response, error  in
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)

            let image = UIImage(data: data)
            finished(image)
        }
    }
}
