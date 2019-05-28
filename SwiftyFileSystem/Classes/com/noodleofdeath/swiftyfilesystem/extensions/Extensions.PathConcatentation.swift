//
//  Extensions.String.swift
//  Pods-SwiftyFileSystem_Example
//
//  Created by MORGAN, THOMAS B on 3/13/19.
//

import Foundation

// MARK: - Path Component Concatentation Infix Operator

infix operator +/ : AdditionPrecedence

// MARK: - URL Path Concatenation
extension URL {
    
    static func +/ (lhs: URL, rhs: String) -> URL {
        return lhs.appendingPathComponent(rhs)
    }
    
    static func +/ (lhs: URL, rhs: String?) -> URL? {
        guard let rhs = rhs else { return nil }
        return lhs.appendingPathComponent(rhs)
    }
    
}

func +/ (lhs: URL?, rhs: String) -> URL? {
    guard let lhs = lhs else { return nil }
    return lhs.appendingPathComponent(rhs)
}

// MARK: - String Path Concatenation
extension String {
    
    public static func +/ (lhs: String, rhs: String) -> String {
        return (lhs as NSString).appendingPathComponent(rhs)
    }
    
    public static func +/ (lhs: String?, rhs: String) -> String? {
        guard let lhs = lhs else { return nil }
        return (lhs as NSString).appendingPathComponent(rhs)
    }
    
    public static func +/ (lhs: String, rhs: String?) -> String? {
        guard let rhs = rhs else { return nil }
        return (lhs as NSString).appendingPathComponent(rhs)
    }
    
}
