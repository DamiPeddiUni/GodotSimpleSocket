extends Node

var ws = WebSocketClient.new()
var URL = "ws://localhost:3000/"

func _ready():
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "_on_data")
	
	var err = ws.connect_to_url(URL)
	if err != OK:
		print("Connection Refused")
		set_process(false)
		
func _closed(was_clean = false):
	print("Connection Closed")

func _connected(proto = ""):
	print("Connected To Server")
	
func _on_data():
	var response = JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8()).result
	if response.method == "connected":
		print("SERVER: " + response.msg)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		var payload = {
			"method": "chat",
			"msg": "HELLO FROM CLIENT"
		}
		ws.get_peer(1).put_packet(JSON.print(payload).to_utf8())
		
	ws.poll()
	
