//
//  ModelFactory.swift
//  Jsonift Editor
//
//  Created by Ram Kumar on 25/04/23.
//

import Foundation
import OrderedCollections

class ModelFactory {
    
    private var models: OrderedDictionary<String, Model> = [:]
    
    func generate() -> [String] {
        return models.values.flatMap{$0.model}.align
    }
    
    init(with dict: [String: Any]) {
        constructModel(modelName: "Base", dict: dict)
    }
    
    private func constructModel(modelName: String,  dict: [String: Any]) {
        
        if models[modelName] == nil {
            models[modelName] = Model(name: modelName.capitalizeFirst)
        }

        let keys: [String] = dict.keys.map{$0}.sorted(by: {
            if let first = $0.first, let second = $1.first {
                return first < second
            }
            return false
        })
        
        for key in keys {
            
            let type = DataType.of(dict[key]!, for: key)
            
            var variable = Variable(name: key.camelCase.capitalizeFirst, type: type)
            variable.declaration = declaration(key, type: type)
            variable.codingKey = codingKeys(key)
            variable.decoder = decoder(key, type: type)
            variable.encoder = encoder(key)
            models[modelName]?.variables.insert(variable)
            
            switch type {
            case .custom(let name):
                constructModel(modelName: name, dict: dict[key]! as! [String: Any])
            case .array(let type):
    
                if case let DataType.custom(name) = type {
                    let array = dict[key]! as! [[String: Any]]
                    array.forEach{
                        constructModel(modelName: name, dict: $0)
                    }
                }
                
            default:
                break
            }
        }
    }
    
    func declaration(_ snakeCaseName: String, type: DataType) -> String {
        return "public var \(snakeCaseName.camelCase): \(type.typeString) = \(type.defaultValue)"
    }
    
    func codingKeys(_ snakeCaseName: String) -> String {
        return "case \(snakeCaseName.camelCase) = \"\(snakeCaseName)\" "
    }
    
    func decoder(_ snakeCaseName: String, type: DataType) -> String {
        
        let variableName = snakeCaseName.camelCase
        switch type {
        case .date:
            return "\(variableName) = try container.decodeIfPresent(\(type.typeString).self, forKey: .\(variableName))"
        case .anyType:
            return "\(variableName) = try container.decodeIfPresent(\(type.typeString).self, forKey: .\(variableName))"
        case .optional(_):
            return "\(variableName) = try container.decodeIfPresent(\(type.typeString).self, forKey: .\(variableName))"
        default:
            return "\(variableName) = try container.decode(\(type.typeString).self, forKey: .\(variableName))"
        }
        
    }
    
    func encoder(_ snakeCaseName: String) -> String {
        let variableName = snakeCaseName.camelCase
        return "try container.encode(\(variableName), forKey: .\(variableName))"
    }
}
