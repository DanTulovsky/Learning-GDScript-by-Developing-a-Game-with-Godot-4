class_name Player extends CharacterBody2D

signal died

@export var projectile_scene: PackedScene = preload("res://parts/projectile/projectile.tscn")
@export var shoot_distance: float = 400

@onready var _shoot_timer: Timer = $ShootTimer

const MAX_HEALTH: int = 10
const MAX_NUMBER_OF_COINS: int = 10000

@export_range(0, MAX_HEALTH) var health: int = 10:
	get:
		return health

	set(new_value):
		if health > 0 and new_value <= 0:
			_shoot_timer.stop()
			died.emit()
			set_physics_process(false)

		health = clampi(new_value, 0, MAX_HEALTH)

		update_health_label()

@export_range(0, MAX_NUMBER_OF_COINS) var number_of_coins: int = 0:
	get:
		return number_of_coins
	set(new_value):
		number_of_coins = clampi(new_value, 0, MAX_NUMBER_OF_COINS)
		update_coins_label()

@export var acceleration: float = 2500.0
@export var deceleration: float = 1500.0
@export var max_speed: float = 500.0


@onready var _health_label: Label = $HealthLabel
@onready var _coins_label: Label = $CoinsLabel

@export var speed: float = 500:
	get:
		return speed
	set(new_value):
		speed = clampf(new_value, 0, max_speed)

func add_health_points(difference: int):
	health += difference

func update_health_label():
	if not is_instance_valid(_health_label):
		return
	_health_label.text = "{0}/{1}".format([health, MAX_HEALTH])

func update_coins_label():
	if not is_instance_valid(_coins_label):
		return
	_coins_label.text = "🪙 {0}".format([number_of_coins])

func add_coin(num: int = 1):
	number_of_coins += num

func hit(damage: int):
	health -= damage

func _on_shoot_timer_timeout() -> void:
	var closest_enemy: Enemy
	var smallest_distance: float = INF
	var all_enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")

	for enemy in all_enemies:
		var distance_to_enemy: float = global_position.distance_to(enemy.global_position)
		if distance_to_enemy < smallest_distance:
			smallest_distance = distance_to_enemy
			closest_enemy = enemy as Enemy

	if not is_instance_valid(closest_enemy):
		return
	if smallest_distance > shoot_distance:
		return

	var new_projectile: Projectile = projectile_scene.instantiate()
	new_projectile.target = closest_enemy
	get_parent().add_child(new_projectile)
	new_projectile.global_position = global_position

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

	move_and_slide()

func _ready() -> void:
	update_health_label()
	update_coins_label()
	_shoot_timer.start()
