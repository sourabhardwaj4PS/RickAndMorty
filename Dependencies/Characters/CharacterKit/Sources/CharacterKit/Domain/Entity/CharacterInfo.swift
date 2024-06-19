//
//  CharacterInfo.swift
//  
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation

public protocol CharacterInfo: Codable {
    var count: Int { get set }
    var pages: Int { get set }
    var next: String? { get set }
    var prev: String? { get set }
}

public struct CharacterInfoImpl: CharacterInfo {
    public var count: Int
    public var pages: Int
    public var next: String?
    public var prev: String?
}
