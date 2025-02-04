extends Node2D

var p

@onready var transition = $Transition

func _ready() -> void:
	$Transition/bg_transition.hide()
	p = get_parent()
	if p != null:
		p.connect("level", Callable(self, "_on_get_wave"))

func _on_restart_pressed() -> void:
	$Pressed.play()
	await $Pressed.finished
	#transition.play("fade_out")
	#await transition.animation_finished
	emit_signal("restart")
	var t = get_tree()
	if t:
		t.paused = false
		t.reload_current_scene()

func _on_exit_pressed() -> void:
	$Pressed.play()
	$Transition/bg_transition.show()
	transition.play("fade_out")
	await transition.animation_finished
	get_tree().change_scene_to_file("res://scene/menu.tscn")

func _on_get_wave(lvl):
	var change_this = $wave
	change_this.text = "[center] Lasted " + str(lvl) + " wave[center]"
