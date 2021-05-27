struct InternalLink: Codable {
    let title: String
    let url: String
}

struct InternalLinks: Encodable {
    var links: [InternalLink]
}