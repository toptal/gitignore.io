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
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }

    var fileName: String {
        return NSURL(fileURLWithPath: self).lastPathComponent ?? ""
    }

    var fileExtensionss: String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
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
