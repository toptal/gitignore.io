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
    case template, patch, stack
    
    internal var `extension`: String {
        switch self {
        case .template: return "gitignore"
        case .patch: return "patch"
        case .stack: return "stack"
        }
    }
    
    internal func header(name: String) -> String {
        switch self {
        case .template: return "\n### \(name) ###\n"
        case .patch: return "\n### \(name) Patch ###\n"
        case .stack: return "\n### \(name) Stack ###\n"
        }
    }
}
