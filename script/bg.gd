extends Node2D
var pabble_max_count = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pebble_arr = []
	var pebble_scene = preload("res://scene/pebble.tscn")
	for i in range(pabble_max_count):
		var peb_obj = pebble_scene.instantiate()
		peb_obj.position = Vector2(randi_range(2 * 20, 120 * 20), randi_range(2 * 20, 102 * 20))
		pebble_arr.push_back(peb_obj)
		add_child(peb_obj)
	
	var tile = $bg_tile
	var htile = $higher_tile
	var outter_mask_bottom = $outer_black_bottom
	var outter_mask_right = $outer_black_right
	var outter_mask_left = $outer_black_left
	for y in range(101 + 5):
		for x in range(152):
			if y == 0 or y == 1 or y == 2:
				tile.set_cell(Vector2i(x,y), 1, Vector2i(randi() % 4, 0), 0)
				continue
			if y == 104 or y == 103 or y == 102:
				htile.set_cell(Vector2i(x,y), 1, Vector2i(randi() % 4, 0), 0)
			tile.set_cell(Vector2i(x,y), 0, Vector2i(randi() % 4, randi() % 2), 0)

	for y in range(107):
		for x in range(154):
			if x == 0 or x == 153:
				htile.set_cell(Vector2i(x -1,y -2), 1, Vector2i(randi() % 4, 0), 0)

	outter_mask_bottom.position = Vector2(0, 107 *16)
	outter_mask_bottom.size = Vector2(153 *16, 100*16)
	outter_mask_left.position = Vector2(-4 * 16, 0)
	outter_mask_left.size = Vector2(3 *16, 107 * 16)
	outter_mask_right.position = Vector2(153 * 16, 0)
	outter_mask_right.size = Vector2(3 *16, 107 * 16)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
