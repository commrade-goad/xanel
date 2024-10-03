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
	position.x = 0
	position.y = 0
	$player_sprite.play()

func _process(delta: float) -> void:

	if rolling == true:
		if $player_sprite.animation != "roll":
			$player_sprite.animation = "roll"
	elif velocity.length() > 1 and rolling == false:
		if $player_sprite.animation != "walk":
			$player_sprite.animation = "walk"
	else:
		if $player_sprite.animation != "idle":
			$player_sprite.animation = "idle"

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
			rolling = true
		if Input.is_action_pressed("p_left"):
			input_velocity.x -= roll_speed
			rolling = true
		if Input.is_action_pressed("p_up"):
			input_velocity.y -= roll_speed
			rolling = true
		if Input.is_action_pressed("p_down"):
			input_velocity.y += roll_speed
			rolling = true
		if rolling == true:
			$player_hand.hide()
			$p_sword/sword_sprite.hide()
			$roll_timer.start()

	velocity = velocity.lerp(input_velocity, friction)

	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)

	print(velocity)
	if velocity.x != 0:
		$player_sprite.flip_h = velocity.x < 0


	var mouse_pos = get_global_mouse_position()


	var player_global_pos = $player_sprite.global_position
	var angle = atan2(mouse_pos.y - player_global_pos.y, mouse_pos.x - player_global_pos.x)
	if rolling == false:
		$player_sprite.flip_h = angle >= 1.5 or angle <= -1.5
	
	# sword
	var offset = Vector2(cos(angle), sin(angle)) * 16
	$p_sword.global_position = player_global_pos + offset
	$p_sword/sword_sprite.flip_h = angle >= 1.5 or angle <= -1.5
	$p_sword.rotation = angle + 1.25
	if angle >= 1.5 or angle <= -1.5 :
		$p_sword.rotation = angle + 1.75
	
	# hand
	var hand_offset = Vector2(cos(angle), sin(angle))
	if angle >= 1.5 or angle <= -1.5 :
		hand_offset = Vector2(cos(angle), sin(angle))
	$player_hand.flip_v = angle >= 1.5 or angle <= -1.5
	$player_hand.rotation = angle
	$player_hand.global_position = player_global_pos + hand_offset


func _on_roll_timer_timeout() -> void:
	if rolling == true:
		$player_sprite.animation = "idle"
		rolling = false
		$player_hand.show()
		$p_sword/sword_sprite.show()
		velocity = Vector2.ZERO
