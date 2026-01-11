class_name EntitySpawner extends Node2D

const MIN_SPAWN_INTERVAL: float = 0.3

@export var entity_scene: PackedScene
@export var spawn_interval: float = 1.5
@export var spawn_interval_decrease_amount: float = 0.1
@export var spawn_interval_decrease_time: float = 2

@onready var _positions: Node2D = $Positions
@onready var _spawn_timer: Timer = $SpawnTimer
@onready var _spawn_interval_increase_timer: Timer = $SpawnIntervalIncreaseTimer
@onready var _multiplayer_spawner = $MultiplayerSpawner


func _ready() -> void:
	_multiplayer_spawner.add_spawnable_scene(entity_scene.resource_path)
	if multiplayer.is_server():
		start_spawn_timer()
		_spawn_interval_increase_timer.start(spawn_interval_decrease_time)


func spawn_entity() -> void:
	if len(_positions.get_children()) == 0:
		return

	if not is_instance_valid(entity_scene):
		print("Entity scene is not valid")
		return

	var random_position: Marker2D = _positions.get_children().pick_random()

	var new_entity: Node2D = entity_scene.instantiate()
	new_entity.position = random_position.position

	add_child(new_entity, true)

func _on_timer_timeout() -> void:
	spawn_entity()

func start_spawn_timer() -> void:
	_spawn_timer.start(spawn_interval)

func stop_spawn_timer() -> void:
	_spawn_timer.stop()

func _on_spawn_increase_timer_timeout() -> void:
	spawn_interval -= spawn_interval_decrease_amount
	if spawn_interval < MIN_SPAWN_INTERVAL:
		spawn_interval = MIN_SPAWN_INTERVAL
	start_spawn_timer()
