extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for y in range(101):
		for x in range(102):
			set_cell(Vector2i(x,y), 0, Vector2i(randi() % 4, randi() % 2), 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
