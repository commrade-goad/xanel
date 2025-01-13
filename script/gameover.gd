extends Node2D

var p

@onready var transition = $Transition

func _ready() -> void:
	$bg_transition.hide()
	p = get_parent()
	if p != null:
		p.connect("level", Callable(self, "_on_get_wave"))

func _on_restart_pressed() -> void:
	$Pressed.play()
	await $Pressed.finished
	#transition.play("fade_out")
	#await transition.animation_finished
	emit_signal("restart")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	$Pressed.play()
	await $Pressed.finished
	$bg_transition.show()
	#transition.play("fade_out")
	#await transition.animation_finished
	get_tree().change_scene_to_file("res://scene/menu.tscn")

func _on_get_wave(lvl):
	var change_this = $Blur/wave
	change_this.text = "[center] Last Wave : " + str(lvl) + "[center]"
