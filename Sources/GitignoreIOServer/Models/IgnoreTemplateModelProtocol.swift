//
//  IgnoreTemplateModelProtocol.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 1/29/17.
//
//

import Foundation

internal protocol IgnoreTemplateModelProtocol {
    var key: String { get set }
    var name: String { get set }
    var fileName: String { get set }
    var contents: String { get set }
}
