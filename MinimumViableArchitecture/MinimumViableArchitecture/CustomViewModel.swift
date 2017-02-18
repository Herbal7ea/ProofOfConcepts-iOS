//
//  CustomViewModel.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import UIKit

class CustomViewModel {
    func loadImage(urlString: String, success: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { print("Unable to load \(urlString)"); return }
        
        PresenterCommon.shared.downloadImage(url: url, finished: success)
    }
}
