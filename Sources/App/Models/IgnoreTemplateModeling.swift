//
//  IgnoreTemplateModeling.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 1/29/17.
//
//

internal protocol IgnoreTemplateModeling: Codable {
    var key: String { get set }
    var name: String { get set }
    var fileName: String { get set }
    var contents: String { get set }
}
