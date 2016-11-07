import Vapor
import GitignoreIOServer

let drop = GitignoreIOServer.configureServer()
drop.run()
