//
//  TemplateGenerator.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/17/16.
//
//

import Foundation

struct TemplateGenerationController {
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func parseTemplateDirectory() {
        
        let fileManager = FileManager()     // let fileManager = NSFileManager.defaultManager()
        let en=fileManager.enumerator(atPath: Bundle.main.bundlePath)   // let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(folderPath)
        
        debugPrint("boom")
        while let element = en?.nextObject() as? String {
            debugPrint(element)
            
            if element.hasSuffix("ext") {
                // do something with the_path/*.ext ....
            }
        }
    }
    
    
//    static let projectRootDirectory = Dir(Bundle.main.bundlePath)
//    
//    func parseTemplates(directory: Dir) {
//        
//        do {
//            try directory.forEachEntry(closure: { (descriptor) in
//                if File(directory.path + descriptor).isDir {
//                    print("D: \(descriptor)")
//                    //                    parseTemplates(directory: Dir(directory.path + descriptor))
//                } else {
//                    print("F: \(descriptor)")
//                }
//            })
//        } catch {
//            debugPrint(error)
//        }
//    }
}
