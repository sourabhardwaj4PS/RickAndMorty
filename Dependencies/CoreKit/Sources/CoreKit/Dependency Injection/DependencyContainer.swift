//
//  DependencyContainer.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation

public enum DependencyType {
    case singleton
    case newInstance
    case automatic
}

public final class DependencyContainer {
    
    private static var cache: [String: Any] = [:]
    private static var generators: [String: () -> Any] = [:]
    
    public static func register<Dependency>(type: Dependency.Type, as dependencyType: DependencyType = .automatic, _ factory: @autoclosure @escaping () -> Dependency) {
        generators[String(describing: type.self)] = factory
        
        if dependencyType == .singleton {
            cache[String(describing: type.self)] = factory()
        }
    }
    
    public static func resolve<Dependency>(dependencyType: DependencyType = .automatic, _ type: Dependency.Type) -> Dependency? {
        let key = String(describing: type.self)
        switch dependencyType {
        case .singleton:
            if let cachedDependency = cache[key] as? Dependency {
                return cachedDependency
            } else {
                fatalError("\(String(describing: type.self)) is not registeres as singleton")
            }
            
        case .automatic:
            if let cachedDependency = cache[key] as? Dependency {
                return cachedDependency
            }
            fallthrough
            
        case .newInstance:
            if let dependency = generators[key]?() as? Dependency {
                cache[String(describing: type.self)] = dependency
                return dependency
            } else {
                return nil
            }
        }
    }
}
