//
//  String+Extensions.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/18/16.
//
//

import Foundation
import HTTP

extension String {
    var name: String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    var fileName: String {
        return NSURL(fileURLWithPath: self).lastPathComponent ?? ""
    }
    
    var fileExtensionss: String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
    
    /// Create HTTP resposne with headers
    ///
    /// - parameter headers: HTTP headers to be added to response
    ///
    /// - returns: Response with HTTP headers
    func response(headers: [HeaderKey: String]) -> Response {
        let response = Response(status: .ok, body: self)
        for header in headers {
            response.headers[header.key] = header.value
        }
        return response
    }

    /// Remove duplicate lines, except blank strings or comment strings
    ///
    /// - returns: String with duplicate lines removed
    func removeDuplcatesLines() -> String {
        var seen = Set<String>()
        return self.components(separatedBy: "\n")
            .filter { (line) -> Bool in
                if !line.isEmpty && !line.hasPrefix("#") && seen.contains(line) {
                    return false
                }
                seen.insert(line)
                return true
            }
            .joined(separator: "\n")
    }
}
