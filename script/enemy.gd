extends Node2D

signal hit
@export var speed = 250
@export var friction = 0.2
@export var hp = 100
var velocity = Vector2.ZERO
var player: CharacterBody2D
var active: String
var attack_sprite: AnimatedSprite2D
var attack_coll: CollisionShape2D
var plen
var can_attack = false

func _ready() -> void:
    attack_sprite = $enemy_a/slash_sprite
    attack_coll = $enemy_a/slash_coll
    attack_sprite.play()
    player = get_parent().get_node("player")
    active = "enemy_a" 

func _process(delta: float) -> void:
    attack_sprite.global_position = position
    attack_sprite.z_index = 101
    if player:
        var diff = player.position - position
        plen = diff.length()
        var sprite = get_node(active + "/sprite")
        sprite.flip_h = diff.x < 0

        if plen <= 50 and can_attack == true:
            $enemy_a/slash_sprite.play()
            $enemy_a/slash_cooldown.start()

        var angle = atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x)
        var offset = Vector2(cos(angle), sin(angle)) * 30
        attack_sprite.rotation = angle

        if diff.x < 0 :
            attack_sprite.global_position += offset
            attack_sprite.flip_v = true
        else:
            attack_sprite.global_position += offset
            attack_sprite.flip_v = false

        attack_coll.global_position = attack_sprite.global_position
        attack_coll.rotation = attack_sprite.rotation

        if attack_sprite.frame <= 3 or attack_sprite.frame >= 8:
            attack_coll.disabled = true
        else:
            attack_coll.disabled = false

        if attack_sprite.frame == 10:
            can_attack = false
            $enemy_a/slash_cooldown.start()
            $enemy_a/slash_sprite.stop()


        var distance = 50
        if can_attack == false:
            distance += 100
        if plen > distance :
            var direction = diff.normalized()
            var input_velocity = direction * speed
            velocity = velocity.lerp(input_velocity, friction)
            position += velocity * delta
        elif can_attack == false and plen < distance - 50:
            var direction = -diff.normalized()
            var input_velocity = direction * speed
            velocity = velocity.lerp(input_velocity, friction)
            position += velocity * delta


func _on_slash_cooldown_timeout():
    can_attack = true
