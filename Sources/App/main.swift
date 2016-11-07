import Vapor
import Foundation

let drop = Droplet()

drop.get("/") { request in
    return try drop.view.make("index", [
        "titleString": drop.localization[request.lang, "global", "title"],
        "descriptionString": drop.localization[request.lang, "global", "description"].replacingOccurrences(of: "{templateCount}", with: "100"),
        "searchPlaceholderString":  drop.localization[request.lang, "index", "searchPlaceholder"],
        "searchGoString":  drop.localization[request.lang, "index", "searchGo"],
        "searchDownloadString":  drop.localization[request.lang, "index", "searchDownload"],
        "subtitleString": drop.localization[request.lang, "index", "subtitle"],
        "sourceCodeDescriptionString": drop.localization[request.lang, "index", "sourceCodeDescription"],
        "sourceCodeTitleString": drop.localization[request.lang, "index", "sourceCodeTitle"],
        "commandLineDescriptionString": drop.localization[request.lang, "index", "commandLineDescription"],
        "commandLineTitleString": drop.localization[request.lang, "index", "commandLineTitle"],
        "videoDescriptionString": drop.localization[request.lang, "index", "videoDescription"],
        "videoTitleString": drop.localization[request.lang, "index", "videoTitle"],
        "footerString": drop.localization[request.lang, "index", "footer"].replacingOccurrences(of: "{templateCount}", with: "100")
    ])
}

drop.get("/docs") { request in
    return try drop.view.make("docs", [
        "titleString": drop.localization[request.lang, "global", "title"],
        "descriptionString": drop.localization[request.lang, "global", "description"].replacingOccurrences(of: "{templateCount}", with: "100")
    ])
}

drop.get("/api", ":ignore") { request in
    guard let userId = request.parameters["ignore"]?.int else {
        throw Abort.badRequest
    }
    
    return "You requested User #\(userId)"
}

drop.get("/api/f", ":ignore") { request in
    guard let userId = request.parameters["ignore"]?.int else {
        throw Abort.badRequest
    }
    
    return "You requested User #\(userId)"
}

drop.get("/api/list") { request in

    return "You want to see a list"
}

drop.run()
