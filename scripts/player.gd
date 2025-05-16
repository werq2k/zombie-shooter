extends CharacterBody2D

@export var speed: float = 100
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun: Node2D = $gun

var health: int = 100  # Player's health

func _ready():
	add_to_group("player")  # Add the player to the "player" group

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1

	velocity = direction.normalized() * speed if direction != Vector2.ZERO else Vector2.ZERO
	move_and_slide()

	# Aim gun toward mouse
	var mouse_pos = get_global_mouse_position()
	var aim_direction = (mouse_pos - global_position).normalized()
	gun.rotation = aim_direction.angle()

	# Flip gun sprite based on rotation
	gun.scale.y = -1 if gun.rotation > PI / 2 or gun.rotation < -PI / 2 else 1

	# Optional: Flip player sprite based on direction
	anim_sprite.flip_h = mouse_pos.x < global_position.x

func take_damage(amount: int):
	health -= amount
	print("💔 Player took ", amount, " damage! Health: ", health)
	if health <= 0:
		die()

func die():
	print("☠️ Player has died!")
	show_game_over_screen()  # Show the Game Over screen
	queue_free()  # Remove the player from the scene

func show_game_over_screen():
	var game_over_scene = preload("res://scenes/game_over.tscn").instantiate()
	get_tree().current_scene.add_child(game_over_scene)
