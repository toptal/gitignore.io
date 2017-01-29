//
//  TemplateSuffix.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 1/29/17.
//
//

import Foundation

/// Template Suffix Enum
internal enum TemplateSuffix {
    case template, patch
    
    internal var `extension`: String {
        switch self {
        case .template: return "gitignore"
        case .patch: return "patch"
        }
    }
    
    internal func header(name: String) -> String {
        switch self {
        case .template: return "\n### \(name) ###\n"
        case .patch: return "\n### \(name) Patch ###\n"
        }
    }
}
