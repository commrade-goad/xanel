extends Node2D

signal ded
signal change_sword
signal hide_sword
signal show_sword
signal rotate_sword(flip:bool)
signal player_hit
signal current_stats(hp:int, sp:int)
signal current_max_stats(hp: int, sp: int)
signal current_level(v: int)
signal current_potion(p: int)
@export var roll_speed = 3000
@export var speed = 250
@export var friction = 0.2 
@export var max_hp = 100
@export var max_sp = 100
@export var hp = 100
@export var sp = 100
@export var attack = 10
@export var level = 1
@export var hp_potion = 1
var screen_size
var blood_sprite
var player_ded = false
var velocity = Vector2.ZERO
var rolling = false
var attacking = false
var can_regen = false

var enemy_dmg_sc = load("res://script/enemy_def.gd")
var enemy_dmg_in = enemy_dmg_sc.new().enemy_def

var parent
# --- NEW ---
var sword_target_position = Vector2.ZERO
var sword_target_rotation = 0.0
var sw
# ----------

func _ready() -> void:
	screen_size = get_viewport_rect().size
	position.x = 0
	position.y = 0
	$player_sprite.play()
	blood_sprite = $blood
	blood_sprite.hide()
	emit_signal("current_max_stats", max_hp, max_sp)
	$sp_regen_timer.start()
	parent = get_parent()
	parent.connect("upgrade_and_add_this", Callable(self, "_on_upgrade_and_add_this"))
	emit_signal("current_potion", hp_potion)

func _process(delta: float) -> void:
	
	if sp < max_sp and can_regen == true:
		sp += 30
		$sp_regen_timer.start()
		can_regen = false
	
	if sp > max_sp:
		sp = max_sp

	if hp <= 0 and player_ded == false:
		player_ded = true
		$player_sprite.play("die")
		emit_signal("ded")
		
	if player_ded == true:
		$player_hand.hide()
		$player_hand_main.hide()
		emit_signal("hide_sword")
		return

	emit_signal("current_stats", hp, sp)

	# Dash
	if rolling == true:
		if $player_sprite.animation != "roll":
			$player_sprite.animation = "roll"
			$Dash.play()
			
	# Walk
	elif velocity.length() > 1 and rolling == false:
		if $player_sprite.animation != "walk":
			$player_sprite.animation = "walk"
			$WalkDirtGravel.play()
	
	# Idle / AFK	
	else:
		if $player_sprite.animation != "idle":
			$player_sprite.animation = "idle"
			$Dash.stop()

	if Input.is_action_just_pressed("cycles_sword"):
		emit_signal("change_sword")
		
	if Input.is_action_just_pressed("p_heal") and hp_potion >= 1 and hp < max_hp:
		hp_potion -=1
		hp += 30 + level * 2
		if hp > max_hp:
			hp = max_hp
		emit_signal("current_potion", hp_potion)

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

	if Input.is_action_just_pressed("p_roll") and rolling == false and sp >= 25:
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
			$Dash.play()
			$player_hand.hide()
			emit_signal("hide_sword")
			$player_hand_main.hide()
			$roll_timer.start()
			sp -= 25

	velocity = velocity.lerp(input_velocity, friction)

	position += velocity * delta

	if velocity.x != 0:
		$player_sprite.flip_h = velocity.x < 0

	var mouse_pos = get_global_mouse_position()

	var player_global_pos = $player_sprite.global_position
	var angle = atan2(mouse_pos.y - player_global_pos.y, mouse_pos.x - player_global_pos.x)
	if rolling == false:
		$player_sprite.flip_h = angle >= 1.5 or angle <= -1.5
	
	# sword (OLD WAY)
	#var offset = Vector2(cos(angle), sin(angle)) * 18
	#$p_sword.global_position = Vector2(player_global_pos.x - 5, player_global_pos.y + 2) + offset
	#emit_signal("rotate_sword", angle >= 1.5 or angle <= -1.5)
	#if angle >= 1.5 or angle <= -1.5 :
		#$p_sword.global_position.x += 10
	#$p_sword.rotation = angle + PI / 2
	# Update the target position and rotation
	
	# --- NEW ---
	var offset = Vector2(cos(angle), sin(angle)) * 18
	sword_target_position = Vector2(player_global_pos.x - 5, player_global_pos.y + 2) + offset
	if angle >= 1.5 or angle <= -1.5:
		sword_target_position.x += 10

	sword_target_rotation = angle + PI / 2
	emit_signal("rotate_sword", angle >= 1.5 or angle <= -1.5)

	# Interpolate towards the target position and rotation
	$p_sword.global_position = $p_sword.global_position.lerp(sword_target_position, 0.5) # Adjust 0.1 for speed
	$p_sword.rotation = lerp_angle($p_sword.rotation, sword_target_rotation, sw) # Adjust 0.1 for speed
	var new_rotation = $p_sword.rotation
	# -----------
	
	# hand
	var hand_offset = Vector2(cos(angle) - 5, sin(angle))
	if angle >= 1.5 or angle <= -1.5 :
		hand_offset = Vector2(cos(angle) + 5, sin(angle))
	$player_hand_main.flip_v = angle >= 1.5 or angle <= -1.5
	#$player_hand_main.rotation = angle
	$player_hand_main.rotation = new_rotation -1.5
	$player_hand_main.global_position = player_global_pos + hand_offset
	
	$player_hand.flip_v = angle >= 1.5 or angle <= -1.5
	#$player_hand.rotation = angle + PI / 18
	$player_hand.rotation = (new_rotation -1.5) + PI / 18
	$player_hand.global_position = Vector2(player_global_pos.x, player_global_pos.y) + hand_offset
	if (angle <= -0.8 and angle >= -1.5) or (angle <= 2.0 and angle >= 1.5):
		$player_hand.hide()
	elif rolling == false:
		$player_hand.show()

func _on_roll_timer_timeout() -> void:
	if rolling == true:
		$player_sprite.animation = "idle"
		rolling = false
		$player_hand_main.show()
		$player_hand.show()
		emit_signal("show_sword")
		velocity = Vector2.ZERO
	$roll_timer.stop()

func _on_area_entered(area: Area2D) -> void:
	var build_me = "slash"
	if area is Pebble:
		speed = 100

	for obj in enemy_dmg_in:
		if area.name == build_me + "_enemy_" + obj["name"] and rolling == false and player_ded == false:
			hp -= obj["damage"] + level
			blood_sprite.show()
			blood_sprite.play()
			emit_signal("player_hit")

func _on_player_sprite_animation_looped() -> void:
	if player_ded == true:
		$player_sprite.stop()
		$player_sprite.frame = 6

func _on_blood_animation_looped() -> void:
	blood_sprite.hide()
	blood_sprite.stop()
	blood_sprite.frame = 0

func _on_sp_regen_timer_timeout() -> void:
	can_regen = true

func _on_upgrade_and_add_this(hp, sp, st, health) -> void:
	max_hp += hp
	max_sp += sp
	attack += st
	hp_potion += health
	emit_signal("current_max_stats", max_hp, max_sp)
	emit_signal("current_stats", hp, sp)
	emit_signal("current_potion", hp_potion)

func _on_area_exited(area: Area2D) -> void:
	#print(area.name)
	#if area.name == "pebble":
		#speed = 250
	if area is Pebble:
		speed = 250

func _on_p_sword_sword_w(w: Variant) -> void:
	sw = w
