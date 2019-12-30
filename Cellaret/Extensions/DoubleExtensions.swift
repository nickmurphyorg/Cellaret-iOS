//
//  DoubleExtensions.swift
//  Cellaret
//
//  Created by Nick Murphy on 12/30/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Double {
    var toString: String {
        if let characters = self {
            return String(characters)
        } else {
            return ""
        }
    }
}
