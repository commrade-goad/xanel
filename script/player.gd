extends Node2D

signal hit
@export var roll_speed = 2000
@export var speed = 300
@export var friction = 0.2 # Friction value to slow down movement smoothly
var screen_size
var velocity = Vector2.ZERO
var rolling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	# Handle basic movement input
	var input_velocity = Vector2.ZERO
	if Input.is_action_pressed("p_right"):
		input_velocity.x += 1
	if Input.is_action_pressed("p_left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("p_up"):
		input_velocity.y -= 1
	if Input.is_action_pressed("p_down"):
		input_velocity.y += 1

	# Normalize the input to ensure uniform speed in diagonal directions
	if input_velocity.length() > 0:
		input_velocity = input_velocity.normalized() * speed
	
	# Add roll speed on rolling action (triggered only once per press)
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

	# Apply movement velocity with gradual deceleration
	velocity = velocity.lerp(input_velocity, friction)

	# Move the player and limit to the screen boundaries
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# Flip sprite based on movement direction
	if velocity.x != 0:
		$player_sprite.flip_h = velocity.x < 0
	
	if rolling == true :
		$player_sprite.animation = "roll"
	else :
		$player_sprite.animation = "idle"


func _on_roll_timer_timeout() -> void:
	$player_sprite.animation = "idle"
	rolling = false
