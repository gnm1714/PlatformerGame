extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func new_game():
	$player.position.x = get_node("StartPosition").position.x
	$player.position.y = get_node("StartPosition").position.y
	$player.show()
