extends CharacterBody2D

@export var speed: float = 50  # Speed of the zombie
@export var damage: int = 10  # Damage dealt to the player
@export var health: int = 50  # Health of the zombie
@export var attack_interval: float = 1.0  # Time in seconds between attacks
var target: Node2D = null  # The player to follow
var player_in_range: Node2D = null  # Reference to the player in attack range

@onready var attack_timer: Timer = $attack_timer  # Timer for periodic attacks

func set_target(player: Node2D):
	target = player

func _ready():
	attack_timer.wait_time = attack_interval  # Set the attack interval

func _physics_process(delta):
	if target == null:
		return

	# Move towards the player
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check if the collided object is the player
		player_in_range = body  # Store a reference to the player
		attack_timer.start()  # Start the attack timer
		print("Player entered attack range!")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check if the exited object is the player
		player_in_range = null  # Clear the reference to the player
		attack_timer.stop()  # Stop the attack timer
		print("Player exited attack range!")

func _on_attack_timer_timeout() -> void:
	if player_in_range and player_in_range.has_method("take_damage"):
		player_in_range.take_damage(damage)  # Deal damage to the player
		print("Zombie dealt ", damage, " damage to the player!")

func take_damage(amount: int):
	health -= amount
	print("🧟 Zombie took ", amount, " damage! Health: ", health)
	if health <= 0:
		die()

func die():
	print("💀 Zombie has died!")
	queue_free()  # Remove the zombie from the scene
