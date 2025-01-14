extends Area2D
class_name Pebble

func _on_area_entered(area: Area2D) -> void:
	$HitRock.play()

func _on_area_exited(area: Area2D) -> void:
	$HitRock.stop()
