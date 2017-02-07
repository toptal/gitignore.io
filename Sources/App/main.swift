import Vapor
import GitignoreIOServer


let drop = GitignoreIOServer.configureServer(droplet: Droplet())
drop.run()
