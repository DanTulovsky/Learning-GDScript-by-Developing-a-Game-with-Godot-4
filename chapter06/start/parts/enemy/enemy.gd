class_name Enemy extends CharacterBody2D

const PLAYER_GROUP: String = "player"

@onready var _navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var _player_detection_area: Area2D = $PlayerDetectionArea

@export var speed: float = 300
@export var acceleration: float = 1500
@export var deceleration: float = 1500

var target: Player

func _ready() -> void:
	if not multiplayer.is_server():
		set_physics_process(false)
		_player_detection_area.monitoring = false
		return

	var player_nodes: Array = get_tree().get_nodes_in_group(PLAYER_GROUP)
	if not player_nodes.is_empty():
		target = player_nodes.pick_random()

func get_player() -> Player:
	var player_nodes: Array[Node] = get_tree().get_nodes_in_group(PLAYER_GROUP)
	if len(player_nodes) == 0:
		printerr("No player found")
		return null
	return player_nodes.front() as Player

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		# try to get target again next frame
		target = get_player()
		return

	_navigation_agent.target_position = target.global_position

	if _navigation_agent.is_navigation_finished():
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	else:
		var next_position: Vector2 = _navigation_agent.get_next_path_position()
		var direction_to_next_position: Vector2 = global_position.direction_to(next_position)
		velocity = velocity.move_toward(direction_to_next_position * speed, acceleration * delta)
	move_and_slide()

func hit() -> void:
	queue_free()

# note this detects self on spawn!
func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group(PLAYER_GROUP):
		return

	body.hit(1)
	queue_free()
