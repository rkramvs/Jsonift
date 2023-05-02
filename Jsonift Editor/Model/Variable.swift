//
//  Variable.swift
//  Jsonift Editor
//
//  Created by Ram Kumar on 25/04/23.
//

import Foundation

struct Variable: Hashable, Equatable {
    
    var name: String
    var type: DataType
    var declaration: String = ""
    var codingKey: String = ""
    var decoder: String = ""
    var encoder: String = ""

    static func == (lhs: Variable, rhs: Variable) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(declaration)
    }
}
