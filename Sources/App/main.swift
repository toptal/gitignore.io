import Foundation
import Vapor

let drop = Droplet()

Site(drop: drop)
TemplateAPI(drop: drop)

drop.run()
