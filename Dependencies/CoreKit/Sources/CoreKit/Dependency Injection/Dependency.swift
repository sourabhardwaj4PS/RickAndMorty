//
//  Dependency.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation

@propertyWrapper
public struct Dependency<Dependency> {
    
    public var dependency: Dependency
    
    public init(_ dependencyType: DependencyType = .newInstance) {
        guard let dependency = DependencyContainer.resolve(dependencyType: dependencyType, Dependency.self) else {
            fatalError("No dependency of type \(String(describing: Dependency.self)) registered!")
        }
        
        self.dependency = dependency
    }
    
    public var wrappedValue: Dependency {
        get { self.dependency }
        mutating set { dependency = newValue }
    }
}
