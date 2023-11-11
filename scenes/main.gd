extends Node2D

@onready var player = $player
@onready var hook = $hook
@onready var ray = $player/RayCast2D

func interpolate(length, duration=0.2):
	var tween_offset = get_tree().create_tween()
	var tween_rect_h = get_tree().create_tween()
	
	tween_offset.tween_property($hook/Sprite2D, "offset", Vector2(0, length/2.0), duration)
	tween_rect_h.tween_property($hook/Sprite2D, "region_rect", Rect2(0, 0, 5, length), duration)
	

func _process(delta):
	hook.global_position = player.global_position
	ray.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("hook"):
		if ray.is_colliding():
			var sticking_object = ray.get_collider()
			var distance_to_object = ray.get_collision_point().distance_to(player.global_position)
			
			hook.length = distance_to_object
			hook.global_rotation_degrees = ray.global_rotation_degrees - 90
			
			interpolate(hook.length, 0.2)
			
			hook.node_b = sticking_object.get_path()
		
			await get_tree().create_timer(0.2).timeout
	else:
		interpolate(0, 0.5)


func new_game():
	$player.position.x = get_node("StartPosition").position.x
	$player.position.y = get_node("StartPosition").position.y
	$player.show()
