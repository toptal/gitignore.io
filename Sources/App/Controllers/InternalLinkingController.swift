
import Vapor

internal protocol ReadOnlyInternalLinkingProtocol {
    var links: InternalLinks { get }
}

internal struct InternalLinkingController: ReadOnlyInternalLinkingProtocol {
    internal var links = InternalLinks(links: [InternalLink]())
    init() {
        let directory = DirectoryConfig.detect()
        let internalLinksFilePath = URL(fileURLWithPath: directory.workDir)
                                    .appendingPathComponent("Resources", isDirectory: true)
                                    .appendingPathComponent("links.json", isDirectory: false)
        var rawLinks = [InternalLink]()
        do {
            let jsonData = try Data(contentsOf: internalLinksFilePath)
            rawLinks = try JSONDecoder().decode([InternalLink].self, from: jsonData)
        
            self.links = InternalLinks(links: rawLinks)
        } catch {
            print("‼️ Could not load internal links from json, check:\n‼️ Resources/links.json")
        }
    }
}