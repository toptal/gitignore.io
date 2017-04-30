//
//  URL+Extensions.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 1/29/17.
//
//

import Foundation

internal extension URL {
    
    /// Name of file without extension
    internal var name: String {
        return self.deletingPathExtension().lastPathComponent
    }
    
    /// Name of file first component
    internal var stackName: String? {
        return self.deletingPathExtension().lastPathComponent.components(separatedBy: ".").first
    }

    /// Name of file with extension
    internal var fileName: String {
        return self.lastPathComponent
    }
}
