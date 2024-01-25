extends Node2D

@export var PlayerPrefab: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	print("MainScene")
	for i in NetworkManager.Players:
		print("+1 player" + str(NetworkManager.Players[i].id))
		var currentPlayer = PlayerPrefab.instantiate()
		currentPlayer.name = str(NetworkManager.Players[i].id)
		add_child(currentPlayer) 
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
