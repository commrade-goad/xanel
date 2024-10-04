extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player.position = Vector2(0,0)
	$bg.position = Vector2(-16,16)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	$player.position = $player.position.clamp(Vector2(0, 0), Vector2(100 * 16, 100 * 16 -2))
	$camera.position = $player.position
