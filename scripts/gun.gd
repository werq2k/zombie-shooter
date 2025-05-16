extends Node2D

@export var bullet_scene: PackedScene  # Drag Bullet.tscn into this in the Inspector
@onready var muzzle: Marker2D = $Muzzle  # Ensure you have a Marker2D node named "Muzzle"
@onready var shoot_timer: Timer = $ShootTimer  # Add a Timer node named ShootTimer

func _ready():
	shoot_timer.one_shot = true  # Ensure the timer only runs once per shot

func _process(delta):
	if Input.is_action_just_pressed("shoot") and shoot_timer.is_stopped():
		shoot()

func shoot():
	if bullet_scene == null:
		print("❌ No bullet scene assigned!")
		return

	shoot_timer.start()  # Start the timer to prevent rapid shooting

	# Instantiate the bullet
	var bullet = bullet_scene.instantiate()
	if bullet == null:
		print("❌ Failed to instantiate bullet!")
		return

	# Set the bullet's position and rotation
	bullet.global_position = muzzle.global_position
	bullet.rotation = global_rotation  # Rotate the bullet to match the gun's rotation

	# Set the bullet's direction for movement
	var direction = Vector2.RIGHT.rotated(global_rotation)  # Calculate direction based on gun rotation
	if bullet.has_method("set_direction"):
		bullet.set_direction(direction)

	# Add the bullet to the current scene
	get_tree().current_scene.add_child(bullet)
	print("🔫 Bullet fired from position: ", muzzle.global_position, " with direction: ", direction)
