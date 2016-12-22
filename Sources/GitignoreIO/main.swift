import Foundation
import Vapor

let drop = Droplet()

let templateController = TemplateController()

_ = SiteHandlers(drop: drop, templateController: templateController)
_ = APIHandlers(drop: drop, templateController: templateController)

drop.run()
