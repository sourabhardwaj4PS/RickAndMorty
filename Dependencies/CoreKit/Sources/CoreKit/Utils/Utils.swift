//
//  Utils.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import NetworkKit
import Kingfisher

///
/// Global function to handle prints
///
public func DLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(items, separator: separator, terminator: terminator)
    #endif
}
