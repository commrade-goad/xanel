extends Node

signal WaveDone()
signal WaveStart()

# maks spawn diwave itu bila mati 1 akan spawn 1 lagi hingga 5 
const max_spawn_rate: int = 5
var max_enemy_len: int = current_wave + 4
var current_wave:int = 1
var enemy_spawned: int = 0
var enemy_spawn_rate: int = get_enemy_spawn_rate()

var enemy_scene = preload("res://scene/enemy.tscn")
var enemy_def_sc = load("res://script/enemy_def.gd")
var enemy_def = enemy_def_sc.new().enemy_def

func get_enemy_arr():
    return get_children()

func get_enemy_spawn_rate():
    return get_child_count()

func spawn_enemy():
    var a = enemy_scene.instantiate()
    a.position = Vector2(randi_range(1, 150) * 16, 10 * 16)
    a.active = "enemy_" + enemy_def[randi() % len(enemy_def)]["name"]
    add_child(a)
    enemy_spawned += 1
    enemy_spawn_rate = get_enemy_spawn_rate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_node_level(lvl: int) -> void:
    current_wave = lvl
