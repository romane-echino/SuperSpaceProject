extends Control
 
@export var Address = "127.0.0.1";
@export var port = 8910;
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected);
	multiplayer.peer_disconnected.connect(peer_disconnected);
	multiplayer.connected_to_server.connect(connected_to_server);
	multiplayer.connection_failed.connect(connection_failed);
	pass # Replace with function body.


# Called every frame. 'delta'  is the elapsed time since the previous frame.
func _process(delta):
	pass

# called on host and clients
func peer_connected(id):
	print("Connected " + str(id) )

# called on host and clients
func peer_disconnected(id):
	print("Disconnected " + str(id) )

# only called on clients
func connected_to_server():
	print("Connected to server")
	SendPlayerInfo.rpc_id(1,$Nick.text, multiplayer.get_unique_id())

# only called on clients
func connection_failed():
	print("Connection failed")
	
@rpc("any_peer")
func SendPlayerInfo(name,id):
	if !NetworkManager.Players.has(id):
		NetworkManager.Players[id] = {
			"name":name,
			"id":id
		}
	if multiplayer.is_server():
		for i in NetworkManager.Players:
			SendPlayerInfo.rpc(NetworkManager.Players[i].name,i)

@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://Main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_start_button_down():
	StartGame.rpc()
	pass # Replace with function body.


func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer);
	pass # Replace with function body.


func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	var error =  peer.create_server(port,12);
	
	if error != OK:
		print("unable to host :"+error)
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer);
	print("Awaiting players...")
	SendPlayerInfo($Nick.text, multiplayer.get_unique_id())
	pass # Replace with function body.
