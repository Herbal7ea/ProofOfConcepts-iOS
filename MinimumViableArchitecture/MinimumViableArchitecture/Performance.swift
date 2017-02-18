//
//  Performance.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/17/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import Foundation

typealias VoidBlock = () -> Void

func printTimeElapsedWhenRunningCode(title:String, operation:VoidBlock) {
    let startTime = CFAbsoluteTimeGetCurrent()
    
    operation()
    
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed) s")
}

func timeElapsedInSecondsWhenRunningCode(operation:VoidBlock) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    
    operation()
    
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    return Double(timeElapsed)
}
