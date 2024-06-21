//
//  Extensions.swift
//
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation

extension Optional where Wrapped == String {
    public var value: String {
        switch self {
        case .some(let value): return value
        case .none: return ""
        }
    }
}

extension Optional where Wrapped == URL {
    public var value: URL {
        switch self {
        case .some(let value): return value
        case .none: return URL(string: "")!
        }
    }
}
