extends Area2D

var sword_def = load("res://script/sword_def.gd")
var s = sword_def.new().sword_def
@export var sword_id = 0
var bonus_damage

func disable_all_sword() -> void:
    $basic_sword_sprite.hide()
    $basic_sword_coll.disabled = true
    $flamming_sword_sprite.hide()
    $flamming_sword_coll.disabled = true

func enable_sword(sword_sprite, sword_coll) -> void:
    sword_sprite.show()
    sword_coll.disabled = false
    bonus_damage = s[sword_id]["bonus_damage"]

func current_sword(sword_t: String) -> Array:
    var ret = [
        get_node(sword_t + "_sprite"),
        get_node(sword_t + "_coll")
    ]
    return ret

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    disable_all_sword()
    var sword_type = s[sword_id]["name"]
    var curs = current_sword(sword_type)
    enable_sword(curs[0], curs[1])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_player_hide_sword() -> void:
    disable_all_sword()


func _on_player_show_sword() -> void:
    var sword_type = s[sword_id]["name"]
    var curs = current_sword(sword_type)
    enable_sword(curs[0], curs[1])


func _on_player_rotate_sword(flip) -> void:
    var sword_type = s[sword_id]["name"]
    var curs = current_sword(sword_type)
    curs[0].flip_h = not flip
