//
//  Event.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/17/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import Foundation
import CoreData

enum EventType: Int32 {
    case general,
         birth,
         death,
         marriage,
         divorce,
         child,
         move
}

extension Event {
    var type: EventType {
        get {
            let type = EventType(rawValue: typeValue)!
            return type
        }
        set {
            typeValue = newValue.rawValue
        }
    }
}
