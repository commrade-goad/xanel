extends Node2D

@onready var transition = $AnimationPlayer

func _on_restart_pressed() -> void:
	$Pressed.play()
	await $Pressed.finished
	#get_tree().reload_current_scene() ini buat restart tp rusak

func _on_exit_pressed() -> void:
	$Pressed.play()
	get_tree().quit()
