//
//  DataType.swift
//  Jsonift Editor
//
//  Created by Ram Kumar on 25/04/23.
//

import Foundation

indirect enum DataType {
    case string, bool, array(DataType), custom(String), int, decimal, date, anyType, optional(DataType)
    
    var typeString: String {
        switch self {
        case .string:
            return "String"
        case .int:
            return "Int"
        case .decimal:
            return "Decimal"
        case .bool:
            return "Bool"
        case .array(let type):
            return "[\(type.typeString)]"
        case .custom(let modelName):
            return "\(modelName)"
        case .date:
            return "Date?"
        case .anyType:
            return "Any?"
        case .optional(let type):
            return "\(type.typeString)?"
        }
    }
    
    static func of(_ value: Any, for key: String) -> DataType {
        if value is String {
            
        // https://sarunw.com/posts/how-to-parse-iso8601-date-in-swift/
            for formatter in ISO8601DateFormatter.formatters {
                if formatter.date(from: value as! String) != nil {
                    return .date
                }
            }
                
            return .string
            
        } else if value is NSNumber {
           
            // https://stackoverflow.com/a/53547922
            // https://developer.apple.com/documentation/corefoundation/cfnumbertype
            
            if CFNumberGetType((value as! CFNumber)) == .charType {
                return .bool
            } else if CFNumberGetType((value as! CFNumber)) == .sInt64Type {
                return .int
            } else {
                return .decimal
            }
            
        } else if let array = value as? Array<Any> {
            
            if let firstElement = array.first {
               if firstElement is String {
                   return .array(.string)
               } else if firstElement is NSNumber {
                   
                   if CFNumberGetType((firstElement as! CFNumber)) == .charType {
                       return .array(.bool)
                   } else if CFNumberGetType((firstElement as! CFNumber)) == .sInt64Type {
                       return .array(.int)
                   } else {
                       return .array(.decimal)
                   }
                  
               } else if firstElement is Dictionary<String, Any> {
                   return .array(.custom(key.camelCase.capitalizeFirst))
               }
            }
            else {
                return .array(.anyType)
            }
            
        } else if value is Dictionary<String, Any> {
            return .custom(key.camelCase.capitalizeFirst)
        }
            return .anyType
    }
    
    var defaultValue: String {
        switch self {
        case .string:
            return "\"\""
        case .bool:
            return "false"
        case .array(_):
            return "[]"
        case .custom(let modelName):
            return "\(modelName)()"
        case .int:
            return "0"
        case .decimal:
            return "0.0"
        case .anyType:
            return "nil"
        case .date:
            return "nil"
        case .optional(_):
            return "nil"
        }
    }
}
