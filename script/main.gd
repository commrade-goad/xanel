extends Node

var enemies: Array = []  # Initialize the array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var enemy = preload("res://scene/enemy.tscn")
    for i in range(3):
        var enemy_instance = enemy.instantiate()
        enemy_instance.position = Vector2(i * 20 * 16, i * 16)
        add_child(enemy_instance)

        enemies.append(enemy_instance)
    
    for single_enemy in enemies:
        single_enemy.set_enemies(enemies)
    
    $player.position = Vector2(0, 0)
    $bg.position = Vector2(-16, -16 * 2)
    $bg/higher_tile.position = Vector2(0, 16 * 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
    pass
