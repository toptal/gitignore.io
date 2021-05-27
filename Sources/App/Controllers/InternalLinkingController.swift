
import Vapor

internal protocol ReadOnlyInternalLinkingProtocol {
    var links: InternalLinks { get }
}

internal struct InternalLinkingController: ReadOnlyInternalLinkingProtocol {
     internal var links = InternalLinks(links: [InternalLink]())
     init() {
        let directory = DirectoryConfig.detect()
        var rawLinks = [InternalLink]()
        do {
          let jsonData = try Data(contentsOf: URL(fileURLWithPath: directory.workDir)
                .appendingPathComponent("Resources", isDirectory: true)
                .appendingPathComponent("links.json", isDirectory: false))

            rawLinks = try JSONDecoder().decode([InternalLink].self, from: jsonData)
              

            self.links = InternalLinks(links: rawLinks)
        } catch {
            print("‼️ You might not have done a recursive clone to update your submodules:\n‼️ `git submodule update --init --recursive`")
        }
    }
}