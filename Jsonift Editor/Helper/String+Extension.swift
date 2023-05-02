//
//  String+Extension.swift
//  Jsonift Editor
//
//  Created by Ram Kumar on 25/04/23.
//

import Foundation

extension String {
    var camelCase: String {
        return self
            .split(separator: "_")  // split to components
            .map { String($0) }   // convert subsequences to String
            .enumerated()  // get indices
            .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() } // added lowercasing
            .joined()
    }
    
    var capitalizeFirst: String {
        return self.prefix(1).capitalized + self.dropFirst()
    }
}


extension Array where Element == String {
    var align: [String] {
        var newArray: [String] = []
        
        var tabs: [String] = []
        for line in self {
            
            if line.last == "}"{
                tabs.removeLast()
            }
            
            newArray.append("\(tabs.joined())\(line)")
            
            if line.last == "{" {
                tabs.append("\t")
            }
        }
        
        return newArray
    }
}
