//
//  UITableViewCell.swift
//  Table
//
//  Created by Bradley Hilton on 5/21/18.
//  Copyright © 2018 Brad Hilton. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UITableViewCell {
    
    var didEndDisplaying: (UITableViewCell) -> () {
        get {
            return storage[\.didEndDisplaying, default: { _ in }]
        }
        set {
            storage[\.didEndDisplaying] = newValue
        }
    }
    
}
#endif
