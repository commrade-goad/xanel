extends Area2D
var sword_sprite: Sprite2D
var arm: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    sword_sprite = $basic_sword_sprite
    arm = $arm
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    sword_sprite.global_position = arm.global_position
    sword_sprite.rotation = arm.rotation
    if sword_sprite.rotation >= 1.5 or sword_sprite.rotation <= -1.5:
        sword_sprite.flip_v = true
        sword_sprite.offset.y = -3
    else:
        sword_sprite.flip_v = false
        sword_sprite.offset.y = -15

func _on_enemy_died() -> void:
    sword_sprite.hide()
