extends Area2D

var attack_mode = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_enemy_boleh_attack() -> void:
    attack_mode = true
    print("on attack mode")
    $sprite.animation = "attack"


func _on_sprite_animation_looped() -> void:
    if attack_mode == true:
        attack_mode = false
        $sprite.animation = "default"
