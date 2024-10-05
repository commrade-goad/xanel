extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile = $bg_tile
	var htile = $higher_tile
	for y in range(101 + 5):
		for x in range(152):
			if y == 0 or y == 1 or y == 2:
				tile.set_cell(Vector2i(x,y), 1, Vector2i(randi() % 4, 0), 0)
				continue
			if y == 104 or y == 103 or y == 102:
				htile.set_cell(Vector2i(x,y), 1, Vector2i(randi() % 4, 0), 0)
			tile.set_cell(Vector2i(x,y), 0, Vector2i(randi() % 4, randi() % 2), 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
