extends Node2D

signal boleh_attack
signal free_mem(idx: int)
signal died
var speed
@export var friction = 0.2
@export var hp = 100
var velocity = Vector2.ZERO
var enemies: Array
var player: Area2D 
var active: String
var plen
var offset
var attack_sprite: AnimatedSprite2D
var attack_coll: CollisionShape2D
var attack_cooldown: Timer
var enemy_sprite: AnimatedSprite2D
var arm_sprite: Sprite2D
var blood_sprite
var can_attack = false
var lock_angle = false
var p
var s
var die = false
var idx_to_del = -1
var active_id
var enemy_def_sc = load("res://script/enemy_def.gd")
var enemy_def = enemy_def_sc.new().enemy_def
var parent_main
var c_level = 1

func _ready() -> void:
	var ignore
	parent_main = get_parent()
	parent_main.connect("level", Callable(self, "_on_level_get"))
	for i in range(len(enemy_def)):
		if active == "enemy_" + enemy_def[i]["name"]:
			ignore = i
			active_id = i
			continue
		if ignore != i:
			var build = "enemy_" + enemy_def[i]["name"]
			var node = get_node(build)
			node.queue_free()
			
	attack_sprite = get_node(active + "/slash_" + active + "/slash_sprite")
	attack_coll = get_node(active + "/slash_" + active + "/slash_coll")
	attack_cooldown = get_node(active + "/slash_" + active + "/slash_cooldown")
	arm_sprite = get_node_or_null(active + "/arm")
	enemy_sprite = get_node(active + "/sprite")
	attack_sprite.play()
	player = get_parent().get_node("player")
	p = get_parent().get_node("player")
	s = p.get_node("p_sword")
	enemy_sprite.animation = "default"
	enemy_sprite.play()
	blood_sprite = get_node(active + "/blood")
	blood_sprite.hide()
	
	speed = enemy_def[active_id]["movement_speed"]
	
	if enemy_def[active_id]["enable_hand"] == false:
		if arm_sprite != null :
			arm_sprite.hide()

func _process(delta: float) -> void:
	
	if die == true:
		return
		
	if hp <= 0:
		var idx = 0
		for other_enemy in enemies:
			if other_enemy == self:
				enemy_sprite.animation = "die"
				idx_to_del = idx
				die = true
				attack_sprite.frame = 0
				attack_sprite.stop()
				if arm_sprite != null:
					arm_sprite.hide()
				emit_signal("died")
			idx += 1
	
	attack_sprite.global_position = position
	attack_sprite.z_index = 101
	if player:
		# movement
		var diff = player.position - position
		plen = diff.length()
		var sprite = get_node(active + "/sprite")
		sprite.flip_h = diff.x < 0
		
		separate_from_others()

		var distance = enemy_def[active_id]["attack_range"]
		if can_attack == false:
			distance += 100
		if plen > distance :
			var direction = diff.normalized()
			var input_velocity = direction * speed
			velocity = velocity.lerp(input_velocity, 0.2)
		elif can_attack == false and plen < distance - 75:
			var direction = -diff.normalized()
			var input_velocity = direction * speed
			velocity = velocity.lerp(input_velocity, 0.2)
		if lock_angle == false:
			position += velocity * delta

		# attack
		if enemy_def[active_id]["use_default_attack_system"] == true:
			if plen <= enemy_def[active_id]["attack_range"] and can_attack == true:
				emit_signal("boleh_attack")
				attack_sprite.play()
				attack_cooldown.start()
				
			if lock_angle == false:
				var angle = atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x)
				offset = Vector2(cos(angle), sin(angle)) * enemy_def[active_id]["offset_radius"]
				attack_sprite.rotation = angle

			if diff.x < 0 :
				attack_sprite.global_position += offset
				attack_sprite.flip_v = true
			else:
				attack_sprite.global_position += offset
				attack_sprite.flip_v = false

			attack_coll.global_position = attack_sprite.global_position
			attack_coll.rotation = attack_sprite.rotation
			if enemy_def[active_id]["enable_hand"] == true:
				arm_sprite.global_position = attack_sprite.global_position - offset
				if lock_angle == false:
					arm_sprite.rotation = attack_sprite.rotation
				else:
					var to_use = deg_to_rad(3)
					if arm_sprite.rotation >= 1.5 or arm_sprite.rotation <= -1.5:
						to_use *= -1
					arm_sprite.rotation += to_use

			if attack_sprite.frame == 1:
				lock_angle = true
				
			# TODO : make it dynamic
			if attack_sprite.frame <= enemy_def[active_id]["attack_frame_min"] or attack_sprite.frame >= enemy_def[active_id]["attack_frame_max"]:
				attack_coll.disabled = true
			else:
				attack_coll.disabled = false

			# TODO : make it dynamic
			if attack_sprite.frame == enemy_def[active_id]["attack_frame_count"]:
				can_attack = false
				lock_angle = false
				attack_cooldown.start()
				attack_sprite.stop()
		else:
			attack_sprite.stop()
			attack_coll.disabled = true

# Function to receive the array of enemies
func set_enemies(enemy_array: Array) -> void:
	enemies = enemy_array

func separate_from_others() -> void:
	var separation_force = Vector2.ZERO
	var separation_radius = 40  # Minimum distance to keep between enemies
	var separation_strength = 5  # Amplify this to make enemies repel more strongly
	var velo_res
	for other_enemy in enemies:
		if other_enemy != self:
			var diff = position - other_enemy.position
			var distance = diff.length()

			if distance < separation_radius and distance > 0:
				var force = diff.normalized() / distance * speed
				separation_force += force * separation_strength

	velo_res = separation_force
	velocity = velocity.lerp(velo_res, 0.1)
	#velocity += velo_res

func _on_slash_cooldown_timeout():
	can_attack = true

func _on_enemy_a_area_entered(area: Area2D) -> void:
	if area.name == "p_sword":
		hp -= p.attack + s.bonus_damage - c_level
		print("enemy healt: " + str(hp))
		if enemy_def[active_id]["enable_blood"] == true and die == false:
			blood_sprite.show()
			blood_sprite.play()
	pass # Replace with function body.

func _on_sprite_animation_looped() -> void:
	if die == true:
		emit_signal("free_mem", idx_to_del)

func _on_blood_animation_looped() -> void:
	blood_sprite.hide()
	blood_sprite.stop()
	blood_sprite.frame = 0

func _on_level_get() -> void:
	pass
