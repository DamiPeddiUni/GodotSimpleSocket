const http = require("http")
const websocketServer = require("websocket").server
const httpServer = http.createServer()
httpServer.listen(3000, () => console.log("Listening on port 3000"))

const wsServer = new websocketServer({
    "httpServer": httpServer
})


wsServer.on("request", request => {
    const connection = request.accept(null, request.origin)
    connection.on("open", () => console.log("Opened Connection"))
    connection.on("close", () => console.log("Closed Connection"))
    connection.on("message", message => {
        var data = JSON.parse(message.binaryData.toString())
        if(data.method == "chat"){
            const msg = data.msg
            console.log("Received: " + msg)
        }
    })
    const payload = {
        "method": "connected",
        "msg": "Welcome to the Server"
    }
    connection.send(JSON.stringify(payload))
})