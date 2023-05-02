//
//  AppError.swift
//  Jsonift Editor
//
//  Created by Ram Kumar on 25/04/23.
//

import Foundation

struct AppError: LocalizedError {
    var message: String
    
    var errorDescription: String {
        message
    }
}
