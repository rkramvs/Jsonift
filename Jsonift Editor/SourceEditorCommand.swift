//
//  SourceEditorCommand.swift
//  Jsonift Editor
//
//  Created by Ram Kumar on 25/04/23.
//

import Foundation
import XcodeKit
import AppKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        guard let jsonString = NSPasteboard.general.string(forType: .string), let jsonData = jsonString.data(using: .utf8) else { completionHandler(AppError(message: "Can't find JSON string in clipboard."))
            return
        }
        
        guard let jsonDict = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            completionHandler(AppError(message: "Not an valid JSON String."))
            return
        }
        
        let buffer = invocation.buffer
        var lineEndAt = buffer.lines.count
        
        let modelFactory = ModelFactory(with: jsonDict)
        let modelLines = modelFactory.generate()
    
        for line in modelLines {
            buffer.lines.insert(line, at: lineEndAt)
            lineEndAt += 1
        }
        
        completionHandler(nil)
    }
    
}
