import Foundation
import Vapor

let drop = Droplet()

let templateController = TemplateController(drop: drop)

_ = SiteHandlers(drop: drop, templateController: templateController)
_ = APIHandlers(drop: drop, templateController: templateController)

drop.run()
