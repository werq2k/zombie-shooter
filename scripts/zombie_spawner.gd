extends Node2D

@export var zombie_scene: PackedScene
@onready var spawn_timer: Timer = $SpawnTimer
var player: Node2D = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("❌ Player not found!")
	else:
		print("✅ Player found: ", player.name)
	spawn_timer.start()

func _on_spawn_timer_timeout():
	spawn_zombie()

func spawn_zombie():
	if zombie_scene == null:
		print("❌ No zombie scene assigned!")
		return

	var zombie = zombie_scene.instantiate()
	var screen = get_viewport().get_visible_rect().size
	var side = randi() % 4
	var spawn_pos = Vector2.ZERO
	
	# Calculate spawn position based on which side was randomly chosen
	match side:
		0: # Left
			spawn_pos = Vector2(0, randf() * screen.y)
		1: # Right
			spawn_pos = Vector2(screen.x, randf() * screen.y)
		2: # Top
			spawn_pos = Vector2(randf() * screen.x, 0)
		_: # Bottom
			spawn_pos = Vector2(randf() * screen.x, screen.y)

	zombie.global_position = spawn_pos
	get_tree().current_scene.add_child(zombie)

	# Set the zombie's target directly, but only if the player is valid
	if is_instance_valid(player) and zombie.has_method("set_target"):
		zombie.set_target(player)
		print("🧟 Zombie spawned and tracking player")
	else:
		print("⚠️ Player is not valid. Zombie has no target.")
