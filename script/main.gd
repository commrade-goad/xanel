extends Node

var enemies: Array = []  # Initialize the array
var dim_light = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    
    var enemy_def_sc = load("res://script/enemy_def.gd")
    var enemy_def = enemy_def_sc.new().enemy_def
    
    
    var enemy = preload("res://scene/enemy.tscn")
    for i in range(5):
        var enemy_instance = enemy.instantiate()
        enemy_instance.position = Vector2(i * 20 * 16, i * 16)
        enemy_instance.active = "enemy_" + enemy_def[randi() % len(enemy_def)]["name"]
        add_child(enemy_instance)
        var callable = Callable(self, "_on_free_mem")
        enemy_instance.connect("free_mem", callable, 0)

        enemies.append(enemy_instance)
    
    for single_enemy in enemies:
        single_enemy.set_enemies(enemies)
    
    $player.position = Vector2(0, 0)
    $bg.position = Vector2(-16, -16 * 2)
    $bg/higher_tile.position = Vector2(0, 16 * 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
        
    if dim_light == true and $PointLight2D.energy < 10.03 and $PointLight2D.energy >= 7:
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


func _on_player_ded() -> void:
    var gameover_load = preload("res://scene/gameover.tscn")
    var gameover = gameover_load.instantiate()
    gameover.z_as_relative = false
    gameover.z_index = 256
    gameover.position = Vector2($camera.position.x - 1280 / 2, $camera.position.y - 720 / 2)
    add_child(gameover)


func _on_free_mem(idx: int) -> void:
    enemies[idx].queue_free()
    enemies.remove_at(idx)


func _on_player_player_hit() -> void:
    print("yes")
    dim_light = true
    
