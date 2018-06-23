//
//  FileManager+Extensions.swift
//  App
//
//  Created by Joe Blau on 6/23/18.
//

import Foundation

extension FileManager {
    func templatePathsFor(_ dataDirectory: URL) -> [URL]? {
        return self.enumerator(at: dataDirectory, includingPropertiesForKeys: nil)?
            .allObjects
            .compactMap { (templatePath: Any) -> URL? in
                templatePath as? URL
            }
    }
}
