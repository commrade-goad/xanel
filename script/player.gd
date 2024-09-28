extends Node2D

signal hit
@export var roll_speed = 2000
@export var speed = 350
@export var friction = 0.2 
var screen_size
var velocity = Vector2.ZERO
var rolling = false
var attacking = false


func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:

	var input_velocity = Vector2.ZERO
	if Input.is_action_pressed("p_right"):
		input_velocity.x += 1
	if Input.is_action_pressed("p_left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("p_up"):
		input_velocity.y -= 1
	if Input.is_action_pressed("p_down"):
		input_velocity.y += 1

	if input_velocity.length() > 0:
		input_velocity = input_velocity.normalized() * speed

	if Input.is_action_just_pressed("p_roll") and rolling == false:
		if Input.is_action_pressed("p_right"):
			input_velocity.x += roll_speed
		if Input.is_action_pressed("p_left"):
			input_velocity.x -= roll_speed
		if Input.is_action_pressed("p_up"):
			input_velocity.y -= roll_speed
		if Input.is_action_pressed("p_down"):
			input_velocity.y += roll_speed
		rolling = true
		$roll_timer.start()

	velocity = velocity.lerp(input_velocity, friction)

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$player_sprite.flip_h = velocity.x < 0
	
	if rolling == true :
		$player_sprite.animation = "roll"
	else :
		$player_sprite.animation = "idle"

	var mouse_pos = get_global_mouse_position()

	# Get the player's global position (after camera movement)
	var player_global_pos = $player_sprite.global_position
	# Calculate angle between player and mouse
	var angle = atan2(mouse_pos.y - player_global_pos.y, mouse_pos.x - player_global_pos.x)

	# Set the sword's position relative to the player, using global positions
	var offset = Vector2(cos(angle), sin(angle)) * 30  # Adjust the distance as needed
	$p_sword.global_position = player_global_pos + offset

	$p_sword/sword_sprite.flip_v = angle >= 1.5 or angle <= -1.5
	# Rotate the sword to face the mouse
	$p_sword.rotation = angle + 45
	if angle >= 1.5 or angle <= -1.5 :
		$p_sword.rotation = angle -45


func _on_roll_timer_timeout() -> void:
	$player_sprite.animation = "idle"
	rolling = false
