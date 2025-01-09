extends Node2D

var p

@onready var transition = $AnimationPlayer

func _ready() -> void:
	p = get_parent()
	if p != null:
		p.connect("level", Callable(self, "_on_get_wave"))

func _on_restart_pressed() -> void:
	$Pressed.play()
	await $Pressed.finished
	#get_tree().reload_current_scene() ini buat restart tp rusak

func _on_exit_pressed() -> void:
	$Pressed.play()
	get_tree().quit()

func _on_get_wave(lvl):
	var change_this = $Blur/wave
	change_this.text = "[center] Last Wave : " + str(lvl) + "[center]"
