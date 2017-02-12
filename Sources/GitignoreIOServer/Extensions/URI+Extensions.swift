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
        return self.host.contains("gitignore.io")
    }
}
