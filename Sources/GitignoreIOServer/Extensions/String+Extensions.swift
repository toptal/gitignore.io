//
//  String+Extensions.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/18/16.
//
//

import Foundation

extension String {
    var name: String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    var fileName: String {
        return URL(fileURLWithPath: self).lastPathComponent
    }

    /// Remove duplicate lines, except blank strings or comment strings
    ///
    /// - returns: String with duplicate lines removed
    func removeDuplicateLines() -> String {
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
