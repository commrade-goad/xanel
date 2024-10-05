extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $player.position = Vector2(0,0)
    $bg.position = Vector2(-16, -16 * 2)
    $bg/higher_tile.position = Vector2(0, 16 *2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    $player.position = $player.position.clamp(Vector2(0, 0), Vector2(150 * 16, 102 * 16))
    $camera.position = $player.position

    $player.z_index = clamp(int($player.position.y / 10), 1, 100)
    $enemy.z_index = clamp(int($enemy.position.y / 10), 1, 100)

