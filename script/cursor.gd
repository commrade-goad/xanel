extends Node2D

var p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    p = get_parent()
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var gpos = p.get_global_mouse_position()
    gpos = to_local(gpos)
    $cur_sprite.position = gpos
