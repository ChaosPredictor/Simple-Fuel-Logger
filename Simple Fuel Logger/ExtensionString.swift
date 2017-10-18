//
//  ExtensionString.swift
//  Simple Fuel Logger
//
//  Created by Master on 18/10/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import Foundation

extension String {
    func padLeft (totalWidth: Int, with: String) -> String {
        let toPad = totalWidth - self.characters.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: with, startingAt: 0) + self
    }
    
    func padRight(totalWidth: Int, with: String) -> String {
        let toPad = totalWidth - self.count
        if toPad < 1 {return self}
        return self + "".padding(toLength: toPad, withPad: with, startingAt: 0)
    }
    
    func padAsDoubleFromRight(totalWidth: Int, with: String) -> String {
        let toPad = totalWidth - self.split(separator: ".")[1].count
        print(toPad)
        if toPad < 1 {return self}
        return self + "".padding(toLength: toPad, withPad: with, startingAt: 0)
    }
}
