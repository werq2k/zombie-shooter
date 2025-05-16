extends Area2D

@export var speed: float = 500  # Speed of the bullet
@export var damage: int = 20  # Damage dealt by the bullet
var direction: Vector2 = Vector2.ZERO  # Direction the bullet will move in

func _ready():
	# Automatically queue the bullet after 2 seconds to prevent clutter
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _physics_process(delta):
	# Move the bullet in the specified direction
	global_position += direction * speed * delta

func set_direction(dir: Vector2):
	# Set the direction for the bullet
	direction = dir.normalized()

func _on_body_entered(body):
	# Check if the body has a "take_damage" method
	if body.has_method("take_damage"):
		body.take_damage(damage)  # Deal damage to the zombie
		queue_free()  # Destroy the bullet on impact
