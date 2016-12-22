import Vapor
import GitignoreIO

let drop = GitignoreIO.configureServer()
drop.run()
