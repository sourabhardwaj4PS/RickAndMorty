//
//  NeverDecodable.swift
//
//
//  Created by Sourabh Bhardwaj on 16/06/24.
//

import Foundation

enum DecodingError: Error {
    case unexpectedValue
}

public struct NeverDecodable: Decodable {
    public init(from decoder: Decoder) throws {
        throw DecodingError.unexpectedValue
    }
}

