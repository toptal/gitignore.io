import Foundation
import Vapor

let drop = Droplet()

TemplateGenerationController().parseTemplateDirectory()

_ = Site(drop: drop)
_ = TemplateAPI(drop: drop)

drop.run()
