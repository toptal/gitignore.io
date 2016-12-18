import Foundation
import Vapor

let drop = Droplet()

let templateManager = TemplateManager(drop: drop)

_ = Site(drop: drop)
_ = TemplateAPI(drop: drop, templateManager: templateManager)

drop.run()
