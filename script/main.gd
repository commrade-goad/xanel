extends Node

@onready var transition = $Transition

signal request_level
signal current_upgrade(obj)
signal upgrade_and_add_this(hp: int, sp: int, st: int, heal: int) # send to player
signal level(lvl: int)
signal pause_timer()
signal resume_timer()

var current_up = {"hp": 0, "sp": 0, "st": 0}
var wave_finished = false
var current_level = 1
var enemy_spawn_count = current_level + 1
var enemy_spawnned = 0
var enemy_nums = current_level + 1
var max_spawn_count = 2
var enemy_spawnned_total = 0
var levelup_scene
var can_spawn = false
var levelup_exist = false
var hp_percentage = 1.0
var low_hp_sound = true

var enemies: Array = []
var dim_light = false

var sp_bar: ColorRect
var hp_bar: ColorRect

var max_hp: int
var max_sp: int

var enemy_def_sc = load("res://script/enemy_def.gd")
var enemy_def = enemy_def_sc.new().enemy_def

var menu_scene = preload("res://scene/pause.tscn")
var pobj

func show_menu() -> void:
	# Memuat scene pause
	pobj = menu_scene.instantiate()
	pobj.z_index = 255
	pobj.light_mask = 2

	# Menghubungkan sinyal restart ke menu pause
	if pobj.name == "pause":  # Pastikan root adalah "Pause"
		pobj.connect("restart", Callable(self, "_on_restart"))

	# Menambahkan pause menu ke dalam scene
	$camera.add_child(pobj)

func levelup() -> void:
	if is_instance_valid(pobj):
		pobj.queue_free()
	var levelup_tscn = preload("res://scene/levelup.tscn")
	levelup_scene = levelup_tscn.instantiate()
	levelup_scene.z_index = 200
	add_child(levelup_scene)
	levelup_scene.connect("upgrade_and_del", Callable(self, "_on_upgrade_and_del"))
	emit_signal("current_upgrade", current_up)
	levelup_exist = true
	$camera/ui.hide()
	emit_signal("pause_timer")

func _ready() -> void:
	$GameOver.stop()
	$LowHp.stop()
	levelup()
	
	sp_bar = $camera/sp
	hp_bar = $camera/hp
	
	$player.position = Vector2(0, 0)
	$bg.position = Vector2(-16, -16 * 2)
	$bg/higher_tile.position = Vector2(0, 16 * 2)

func gen_random_pos() -> Vector2:
	var ppos = $player.position
	var result: Vector2 = Vector2(randi_range(1, 150) * 16, 100 * 16)
	var min_distance_from_player = 15 * 16
	while abs(result.x - ppos.x) < min_distance_from_player:
		result = Vector2(randi_range(1, 150) * 16, 100 * 16)
	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if hp_percentage < 0.40 and hp_percentage > 0 and low_hp_sound == true:
		print(hp_percentage)
		$LowHp.play()
		low_hp_sound = false
		
	elif low_hp_sound == false and hp_percentage > 0.41:
		$LowHp.stop()
		low_hp_sound = true
		
	if get_node_or_null("levelup") != null:
		var stuff = get_node("levelup")
		stuff.global_position = $player.global_position
		levelup_exist = true
	
	if dim_light == true and $PointLight2D.energy < 10.03 and $PointLight2D.energy >= 5:
		$PointLight2D.energy -= .5
	else:
		$PointLight2D.energy = 10.03
		dim_light = false
	
	$player.position = $player.position.clamp(Vector2(0, 0), Vector2(150 * 16, 102 * 16))
	$camera.position = $player.position 
	$PointLight2D.position = $player.position

	# Calculate player's z_index based on its y-position
	$player.z_index = clamp(int($player.position.y / 10), 1, 100)
	
	# Calculate z_index for each enemy based on its own position
	for i in range(len(enemies)):
		enemies[i].position = enemies[i].position.clamp(Vector2(0, 0), Vector2(150 * 16, 102 * 16))
		enemies[i].z_index = clamp(int(enemies[i].position.y / 10), 1, 100)  # Use enemies[i] position, not enemies[y]

	if len(enemies) <= 0 and enemy_nums <= enemy_spawnned_total and levelup_exist == false:
		
		for i in len(enemies):
			var en = enemies[i]
			en.queue_free()
			enemies.remove_at(i)
			
		can_spawn = false
		enemy_spawnned = 0
		enemy_spawnned_total = 0
		levelup() 
		current_level += 1
		if current_level > 1:
			$LevelComplete.play()
		enemy_nums += 1
		if max_spawn_count < 5:
			max_spawn_count += 1
			
	if enemy_spawnned_total >= enemy_nums:
		return
		
	if can_spawn == true and enemy_spawnned >= max_spawn_count and enemy_nums > enemy_spawnned_total and len(enemies) < 5:
		enemy_spawnned = 0
	
	if can_spawn == true and max_spawn_count > enemy_spawnned:
		var enemy = preload("res://scene/enemy.tscn")
		var enemy_instance = enemy.instantiate()
		enemy_instance.position = gen_random_pos()
		#enemy_instance.active = "enemy_" + enemy_def[randi() % len(enemy_def)]["name"]
		enemy_instance.active = "enemy_" + enemy_def[6]["name"]
		add_child(enemy_instance)
		var callable = Callable(self, "_on_free_mem")
		var callable2 = Callable(self, "_on_enemies_arr_change")
		enemy_instance.connect("free_mem", callable, 0)
		enemy_instance.connect("enemies_arr_chage", callable2, 0)
		enemies.append(enemy_instance)

		for single_enemy in enemies:
			single_enemy.set_enemies(enemies)

		$spawn_timer.start()
		can_spawn = false
		enemy_spawnned += 1
		enemy_spawnned_total += 1
		
# Kalau Player Mati / Dead
func _on_player_ded() -> void:
	var gameover_load = preload("res://scene/gameover.tscn")
	var gameover = gameover_load.instantiate()
	gameover.z_as_relative = false
	gameover.z_index = 256
	gameover.position = Vector2($camera.position.x - 1280 / 2, $camera.position.y - 720 / 2)
	hp_bar.size.x = 0
	add_child(gameover)
	$EerieSound.stop()
	$DungeonSound.stop()
	$GameOver.play()
	$LowHp.stop()
	emit_signal("pause_timer")
	emit_signal("level", current_level)
	if is_instance_valid(pobj):
		pobj.queue_free()
	
func _on_free_mem(idx: int) -> void:
	if idx >= len(enemies):
		idx -= 1
	enemies[idx].queue_free()
	enemies.remove_at(idx)

func _on_player_player_hit() -> void:
	dim_light = true

func _on_player_current_stats(hp: int, sp: int) -> void:
	hp_percentage = float(hp) / float(max_hp)
	hp_bar.size.x = 229 * hp_percentage
	var sp_percentage: float = float(sp) / float(max_sp)
	sp_bar.size.x = 229 * sp_percentage

func _on_player_current_max_stats(hp: int, sp: int) -> void:
	max_hp = hp
	max_sp = sp

func _on_player_current_level(v: int) -> void:
	current_level = v
	emit_signal("level", current_level)
	
func _on_upgrade_and_del(hp, sp, st):
	current_up["hp"] += hp
	current_up["sp"] += sp
	current_up["st"] += st
	emit_signal("upgrade_and_add_this", hp, sp, st, 1)
	levelup_scene.queue_free()
	$spawn_timer.start()
	levelup_exist = false
	$camera/ui/wave.text = "[center] Wave " + str(current_level) + " [center]"
	$camera/ui.show()
	emit_signal("resume_timer")
	show_menu()

# Timer
func _on_spawn_timer_timeout() -> void:
	$spawn_timer.stop()
	can_spawn = true

# Sound Eerie
func _on_backsound_1_finished() -> void:
	$EerieSound.play()

# Sound Dungeon
func _on_backsound_2_finished() -> void:
	$DungeonSound.play()

# Posisi Potion
func _on_player_current_potion(p: int) -> void:
	$camera/ui/potion_text.text = "[right] " + str(p) + "x [right]"

# Kondisi saat Low HP
func _on_low_hp_finished() -> void:
	low_hp_sound = true

func _on_enemies_arr_change(arr: Array) -> void:
	enemies = enemies
	
func _on_restart() -> void:
	var reset = get_node("pause")
	if reset != null:
		reset.queue_free()
	transition.play("fade_out")
	await transition.animation_finished
