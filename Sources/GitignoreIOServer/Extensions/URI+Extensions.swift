//
//  URI+Extensions.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 2/12/17.
//
//

import Foundation
import URI

extension URI {
    var servedOnGitignoreIO: Bool {
        return self.host.string?.contains("gitignore.io") ?? false
    }
}
