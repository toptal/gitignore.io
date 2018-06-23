//
//  String+Extensions.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/18/16.
//
//

import Foundation

internal extension String {
    /// Remove duplicate lines, except blank strings or comment strings
    ///
    /// - Returns: String with duplicate lines removed
    internal func removeDuplicateLines() -> String {
        return self.components(separatedBy: "\n")
            .reduce([String]()){
                if !$1.isEmpty && !$1.hasPrefix("#") && $0.contains($1) {
                    return $0
                }
                return $0 + [$1]
            }
            .joined(separator: "\n")
    }
}
