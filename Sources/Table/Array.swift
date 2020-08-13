//
//  Array.swift
//  Table
//
//  Created by Bradley Hilton on 6/2/18.
//  Copyright © 2018 Brad Hilton. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension Array {
    
    mutating func popFirst(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try firstIndex(where: predicate) else {
            return nil
        }
        return remove(at: index)
    }
    
}
#endif
