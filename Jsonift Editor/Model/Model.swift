//
//  Model.swift
//  Jsonift Editor
//
//  Created by Ram Kumar on 25/04/23.
//

import Foundation

struct Model {
    var name: String
    var variables: Set<Variable> = []
    
    var model: [String] {
        
        let _variables = variables.sorted(by: {
            if let first = $0.name.first, let second = $1.name.first {
                return first < second
            }
            return false
        })
        
        var texts: [String] = []
        texts.append("struct \(name): Codable{")
        texts.append(contentsOf: _variables.map{$0.declaration})
        texts.append("enum CodingKeys: String, CodingKey, CaseIterable {")
        texts.append(contentsOf: _variables.map{$0.codingKey})
        texts.append("}")
        
        texts.append("init() {")
        texts.append("}")
        
        texts.append("public init(from decoder: Decoder) throws {")
        texts.append("let container = try decoder.container(keyedBy: CodingKeys.self)")
        texts.append(contentsOf: _variables.map{$0.decoder})
        texts.append("}")
        
        texts.append("func encode(to encoder: Encoder) throws {")
        texts.append("var container = encoder.container(keyedBy: CodingKeys.self)")
        texts.append(contentsOf: _variables.map{$0.encoder})
        texts.append("}")
        
        texts.append("}")
        return texts
    }
}
