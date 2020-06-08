import Vapor

public final class UrlResolver {
    static let HOST_ORIGIN_FALLBACK = "https://www.toptal.com"

    // reads "HOST_ORIGIN" from environment variables, leading/trailing "/"s will be removed
    public static func getHostOrigin() -> String {
        guard let hostOrigin = Environment.get("HOST_ORIGIN") else {
            return HOST_ORIGIN_FALLBACK
        }

        return hostOrigin.trimmingCharacters(in: ["/"])
    }

    // generates canonical URL, based on "HOST_ORIGIN" and "BASE_PREFIX" envvars
    public static func getCanonicalUrl() -> String {
        let hostOrigin = self.getHostOrigin()

        guard let prefix = Environment.get("BASE_PREFIX") else {
            return hostOrigin
        }

        return hostOrigin + "/" + prefix.trimmingCharacters(in: ["/"])
    }

    // adds "BASE_PREFIX" envvar to "route" (coming as a parameter)
    // used in route handlers
    public static func withBasePrefix(_ route: String) -> String {
        guard let prefix = Environment.get("BASE_PREFIX") else {
            return route
        }

        return "/" + prefix.trimmingCharacters(in: ["/"]) + route
    }
}
