import Vapor
import GitignoreIOServer

print("**create** droplet")
let drop = GitignoreIOServer.configureServer()
print("**run** droplet")
drop.run()
