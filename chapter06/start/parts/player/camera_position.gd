extends Node2D

@export var camera_distance: float = 200
@export var position_interpolation_speed: float = 5

@onready var _player: CharacterBody2D = get_parent()

func _process(_delta: float) -> void:
	var move_direction: Vector2 = _player.velocity.normalized()
	var target_position: Vector2 = move_direction * camera_distance
	position = position.lerp(target_position, position_interpolation_speed * _delta)
