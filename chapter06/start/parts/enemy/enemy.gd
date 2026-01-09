class_name Enemy extends CharacterBody2D

@onready var _navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var speed: float = 300
@export var acceleration: float = 1500
@export var deceleration: float = 1500

var player: Player

func _ready() -> void:
	player = get_player()

func get_player() -> Player:
	var player_nodes: Array[Node] = get_tree().get_nodes_in_group("player")
	return player_nodes.front() as Player

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		# try to get player again next frame
		player = get_player()
		return

	_navigation_agent.target_position = player.global_position

	if _navigation_agent.is_navigation_finished():
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	else:
		var next_position: Vector2 = _navigation_agent.get_next_path_position()
		var direction_to_next_position: Vector2 = global_position.direction_to(next_position)
		velocity = velocity.move_toward(direction_to_next_position * speed, acceleration * delta)
	move_and_slide()

func hit() -> void:
	queue_free()

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	body.hit(1)
	queue_free()
