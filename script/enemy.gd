extends Node2D

signal hit
@export var speed = 270
@export var friction = 0.2
@export var hp = 100
var velocity = Vector2.ZERO
var player: CharacterBody2D
var active: String
var plen
var offset
var attack_sprite: AnimatedSprite2D
var attack_coll: CollisionShape2D
var attack_cooldown: Timer
var arm_sprite = Sprite2D
var can_attack = false
var lock_angle = false

func _ready() -> void:
    active = "enemy_a" 
    attack_sprite = get_node(active + "/slash_sprite")
    attack_coll = get_node(active + "/slash_coll")
    attack_cooldown = get_node(active + "/slash_cooldown")
    arm_sprite = get_node(active + "/arm")
    attack_sprite.play()
    player = get_parent().get_node("player")

func _process(delta: float) -> void:
    attack_sprite.global_position = position
    attack_sprite.z_index = 101
    if player:
        # movement
        var diff = player.position - position
        plen = diff.length()
        var sprite = get_node(active + "/sprite")
        sprite.flip_h = diff.x < 0

        if plen <= 50 and can_attack == true:
            attack_sprite.play()
            attack_cooldown.start()

        var distance = 50
        if can_attack == false:
            distance += 100
        if plen > distance :
            var direction = diff.normalized()
            var input_velocity = direction * speed
            velocity = velocity.lerp(input_velocity, 0.2)
            if lock_angle == false:
                position += velocity * delta
        elif can_attack == false and plen < distance - 50:
            var direction = -diff.normalized()
            var input_velocity = direction * speed
            velocity = velocity.lerp(input_velocity, 0.2)
            if lock_angle == false:
                position += velocity * delta

        # attack
        if lock_angle == false:
            var angle = atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x)
            offset = Vector2(cos(angle), sin(angle)) * 30
            attack_sprite.rotation = angle

        if diff.x < 0 :
            attack_sprite.global_position += offset
            attack_sprite.flip_v = true
        else:
            attack_sprite.global_position += offset
            attack_sprite.flip_v = false

        attack_coll.global_position = attack_sprite.global_position
        attack_coll.rotation = attack_sprite.rotation
        arm_sprite.global_position = attack_sprite.global_position - offset

        arm_sprite.rotation = attack_sprite.rotation

        if attack_sprite.frame == 1:
            lock_angle = true

        if attack_sprite.frame <= 3 or attack_sprite.frame >= 8:
            attack_coll.disabled = true
        else:
            attack_coll.disabled = false

        if attack_sprite.frame == 10:
            can_attack = false
            lock_angle = false
            attack_cooldown.start()
            attack_sprite.stop()


func _on_slash_cooldown_timeout():
    can_attack = true
