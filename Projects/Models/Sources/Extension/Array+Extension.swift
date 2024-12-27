//
//  Array+Extension.swift
//  Models
//
//  Created by sungyeon on 12/27/24.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it exists, otherwise nil
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
