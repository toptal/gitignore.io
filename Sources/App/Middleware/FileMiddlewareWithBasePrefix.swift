/// Serves static files from a public directory.
///
///     middlewareConfig = MiddlewareConfig()
///     middlewareConfig.use(FileMiddlewareWithBasePrefix.self)
///     services.register(middlewareConfig)
///
/// `FileMiddlewareWithBasePrefix` will default to `DirectoryConfig`'s working directory with `"/Public"` appended.
import Vapor

public final class FileMiddlewareWithBasePrefix: Middleware, ServiceType {
    /// See `ServiceType`.
    public static func makeService(for container: Container) throws -> FileMiddlewareWithBasePrefix {
        return try .init(publicDirectory: container.make(DirectoryConfig.self).workDir + "Public/")
    }

    /// The public directory.
    /// - note: Must end with a slash.
    private let publicDirectory: String

    /// Creates a new `FileMiddlewareWithBasePrefix`.
    public init(publicDirectory: String) {
        self.publicDirectory = publicDirectory.hasSuffix("/") ? publicDirectory : publicDirectory + "/"
    }

    /// See `Middleware`.
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        // make a copy of the path
        var path = req.http.url.path

        if let basePrefix = Environment.get("BASE_PREFIX") {
            if path.hasPrefix(basePrefix) {
                path = String(path.dropFirst(basePrefix.count))
            }
        }

        // path must be relative.
        while path.hasPrefix("/") {
            path = String(path.dropFirst())
        }

        // protect against relative paths
        guard !path.contains("../") else {
            throw Abort(.forbidden)
        }

        // create absolute file path
        let filePath = publicDirectory + path

        // check if file exists and is not a directory
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir), !isDir.boolValue else {
            return try next.respond(to: req)
        }

        // stream the file
        return try req.streamFile(at: filePath)
    }
}
