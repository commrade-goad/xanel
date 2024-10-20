extends Node2D

signal upgrade_and_del(hp: int, sp: int, st: int)
var hp = 0
var sp = 0
var st = 0
var parents
var current_up = {}
var selected = false
var obj_backup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    parents = get_parent()
    parents.connect("current_upgrade", Callable(self, "_on_current_upgrade"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if selected == true:
        $ColorRect/grid2/Button2.disabled = true
        $ColorRect/grid3/Button3.disabled = true
        $ColorRect/grid4/Button4.disabled = true


func _on_button_hp_pressed() -> void:
    if selected == false:
        hp = 1
        $ColorRect/grid2/hp_text.text = "[right]+ " + str(obj_backup["hp"] + hp) + "[/right]"
        selected = true


func _on_button_sp_pressed() -> void:
    if selected == false:
        sp = 1
        $ColorRect/grid3/sp_text.text = "[right]+ " + str(obj_backup["sp"] + sp) + "[/right]"
        selected = true


func _on_button_st_pressed() -> void:
    if selected == false:
        st = 1
        $ColorRect/grid4/st_text.text = "[right]+ " + str(obj_backup["st"] + st) + "[/right]"
        selected = true


func _on_button_con_pressed() -> void:
    if selected == true:
        emit_signal("upgrade_and_del", hp, sp, st)
    
func _on_current_upgrade(obj):
    obj_backup = obj
    $ColorRect/grid2/hp_text.text = "[right]+ " + str(obj["hp"]) + "[/right]"
    $ColorRect/grid3/sp_text.text = "[right]+ " + str(obj["sp"]) + "[/right]"
    $ColorRect/grid4/st_text.text = "[right]+ " + str(obj["st"]) + "[/right]"
