extends CharacterBody2D

signal fell

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 1000.0
const DASH_LENGTH = 0.08

@onready var dash = $dash
@onready var speedTimer = $SpeedTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speedUp = false
var direction

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("dash"):
		dash.start_dash(DASH_LENGTH)
	var speed = DASH_SPEED if dash.is_dashing() else SPEED
	
	if Input.is_action_pressed("move_left"):
		direction = -1
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
	elif Input.is_action_pressed("move_right"):
		direction = 1
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
	else:
		direction = 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()

	velocity.x = direction * speed
	
	if speedUp:
		velocity.x += 100000.0 * delta * direction
		
	if dash.is_dashing():
		set_collision_mask_value(3, false)
	else:
		set_collision_mask_value(3, true)

	move_and_slide()


func _on_speed_pad_body_entered(body):
	if speedTimer.is_stopped():
		speedUp = true
		speedTimer.start(2)


func _on_speed_timer_timeout():
	speedTimer.stop()
	speedUp = false


func _on_bottom_wall_body_entered(body):
	hide()
	fell.emit()
