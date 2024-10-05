extends Node2D

signal hit
@export var speed = 250
@export var friction = 0.2
@export var hp = 100
var velocity = Vector2.ZERO
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Assuming the player node is a sibling of the enemy node in the scene tree
    player = get_parent().get_node("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if player:
        # Calculate the difference vector from the enemy to the player
        var diff = player.position - position
        
        # Get the distance (length) between the enemy and the player
        var plen = diff.length()

        if plen > 50:  # Move only if the enemy is far enough from the player (outside 50 units)
            # Normalize the difference vector to get the direction
            var direction = diff.normalized()
            
            # Calculate target velocity based on the direction and speed
            var input_velocity = direction * speed

            # Apply friction to velocity (lerp between current velocity and target velocity)
            velocity = velocity.lerp(input_velocity, friction)

            # Update the enemy position based on velocity and delta time
            position += velocity * delta

