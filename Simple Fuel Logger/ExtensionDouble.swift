//
//  ExtensionDouble.swift
//  Simple Fuel Logger
//
//  Created by Master on 18/10/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
