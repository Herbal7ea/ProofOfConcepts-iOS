//
//  TableViewModel.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import Foundation

class TableViewModel {
    
    var people: [PersonDao]
    
    init() {
        people = DataLayer.shared.loadPeopleDaos(numberOfPagesToLoad: 1600)
    }
}
