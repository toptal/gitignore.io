//
//  ReadOnlyTemplateManagerProtocol.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 1/29/17.
//
//

import Foundation

internal protocol ReadOnlyTemplateManagerProtocol {
    var order: [String: Int] { get }
    var count: Int { get }
    var templates: [String: IgnoreTemplateModel] { get }
}
