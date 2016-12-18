//
//  String+Extensions.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/18/16.
//
//

import Foundation

extension String {
    var fileName: String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    var fileExtensionss: String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
}
