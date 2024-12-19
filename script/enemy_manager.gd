extends Node

signal WaveDone()
signal WaveStart()
# untuk dapat level gunakan emit_signal("lvl", level) dari main
var current_wave:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_node_level(lvl: int) -> void:
    current_wave = lvl
