//
//  ISO8601DateFormatter+Extension.swift
//  Jsonift Editor
//
//  Created by Ram Kumar on 25/04/23.
//

import Foundation

extension ISO8601DateFormatter {
    
    convenience init(options: ISO8601DateFormatter.Options) {
        self.init()
        self.formatOptions = options
    }
    
    static var formatters: [ISO8601DateFormatter] = [
        ISO8601DateFormatter(options: .withFullDate)
    ]
}

